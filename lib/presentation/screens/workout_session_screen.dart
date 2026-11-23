import 'package:flutter/material.dart';

import '../../core/audio/speech_service.dart';
import '../../core/di/service_locator.dart';
import '../../data/models/attempt_record.dart';
import '../../data/datasources/sales_scenario_catalog.dart';
import '../../data/datasources/scenario_catalog.dart';
import '../../domain/entities/adaptive_curriculum.dart';
import '../../domain/entities/workout_session.dart';
import '../../domain/repositories/attempt_repository.dart';
import '../../domain/repositories/progress_repository.dart';
import '../controllers/floor_skills_controller.dart';
import '../controllers/workout_session_controller.dart';
import 'discovery_drill_screen.dart';
import 'floor_skills_screen.dart';
import 'multi_turn_simulator_screen.dart';
import 'objection_drill_screen.dart';
import 'sales_simulator_screen.dart';

class WorkoutSessionScreen extends StatefulWidget {
  final DailyWorkoutPlan workout;
  final WorkoutSessionController? controller;

  const WorkoutSessionScreen({
    super.key,
    required this.workout,
    this.controller,
  });

  @override
  State<WorkoutSessionScreen> createState() => _WorkoutSessionScreenState();
}

class _WorkoutSessionScreenState extends State<WorkoutSessionScreen> {
  late WorkoutSessionController _controller;
  bool _ownsController = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else if (ServiceLocator.isRegistered<WorkoutSessionController>()) {
      _controller = ServiceLocator.get<WorkoutSessionController>();
    } else {
      final progressRepo = ServiceLocator.isRegistered<IProgressRepository>()
          ? ServiceLocator.get<IProgressRepository>()
          : null;
      final attemptRepo = ServiceLocator.isRegistered<IAttemptRepository>()
          ? ServiceLocator.get<IAttemptRepository>()
          : null;
      _controller = WorkoutSessionController(
        progressRepository: progressRepo,
        attemptRepository: attemptRepo,
      );
      _ownsController = true;
    }

    _controller.startOrResumeSession(widget.workout);
    _controller.addListener(_onControllerUpdate);
  }

  void _onControllerUpdate() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdate);
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  Future<void> _launchCurrentStep() async {
    final session = _controller.session;
    if (session == null) return;
    final stepIndex = session.currentStepIndex;
    final step = session.currentStep;
    if (step == null) return;

    final attemptRepo = ServiceLocator.isRegistered<IAttemptRepository>()
        ? ServiceLocator.get<IAttemptRepository>()
        : null;

    switch (step.type) {
      case WorkoutStepType.warmupDrill:
      case WorkoutStepType.challengeDrill:
        await _executeDrillStep(step, stepIndex, attemptRepo);
        break;

      case WorkoutStepType.primaryScenario:
        await _executeScenarioStep(step, stepIndex, attemptRepo);
        break;

      case WorkoutStepType.coachingReview:
        await _controller.completeEntireWorkout();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Daily workout completed and persisted!'),
              backgroundColor: Colors.green,
            ),
          );
        }
        break;
    }
  }

  Future<void> _executeDrillStep(
    WorkoutStep step,
    int stepIndex,
    IAttemptRepository? attemptRepo,
  ) async {
    final speech = ServiceLocator.get<ISpeechService>();
    final priorAttemptIds = attemptRepo != null
        ? (await attemptRepo.getAttempts(scenarioId: step.targetId))
              .map((a) => a.id)
              .toSet()
        : <String>{};

    if (!mounted) return;

    dynamic popResult;
    if (step.drillType == 'discovery') {
      popResult = await Navigator.push<dynamic>(
        context,
        MaterialPageRoute(
          builder: (_) => DiscoveryDrillScreen(
            speechService: speech,
            initialDrillId: step.targetId,
            workoutStepId: step.id,
          ),
        ),
      );
    } else if (step.drillType == 'objection') {
      popResult = await Navigator.push<dynamic>(
        context,
        MaterialPageRoute(
          builder: (_) => ObjectionDrillScreen(
            speechService: speech,
            initialDrillId: step.targetId,
            workoutStepId: step.id,
          ),
        ),
      );
    } else if (step.drillType == 'fast_numbers') {
      popResult = await Navigator.push<dynamic>(
        context,
        MaterialPageRoute(
          builder: (_) => FloorSkillsScreen(
            initialDrillType: FloorDrillType.fastNumbers,
            initialDrillId: step.targetId,
            workoutStepId: step.id,
          ),
        ),
      );
    } else {
      // Default: pb_contrast
      popResult = await Navigator.push<dynamic>(
        context,
        MaterialPageRoute(
          builder: (_) => FloorSkillsScreen(
            initialDrillType: FloorDrillType.pbContrast,
            initialDrillId: step.targetId,
            workoutStepId: step.id,
          ),
        ),
      );
    }

    if (!mounted) return;

    // Check for fresh attempt tied to this step execution
    AttemptRecord? freshAttempt;
    if (popResult is AttemptRecord &&
        (popResult.workoutStepId == null ||
            popResult.workoutStepId == step.id)) {
      freshAttempt = popResult;
    } else if (attemptRepo != null) {
      final currentAttempts = await attemptRepo.getAttempts(
        scenarioId: step.targetId,
      );
      final newAttempts = currentAttempts.where((a) {
        if (priorAttemptIds.contains(a.id)) return false;
        if (a.workoutStepId != null && a.workoutStepId != step.id) {
          return false;
        }
        return true;
      }).toList();
      if (newAttempts.isNotEmpty) {
        freshAttempt = newAttempts.first;
      }
    }

    if (freshAttempt != null) {
      await _controller.recordStepResult(
        stepIndex: stepIndex,
        result: WorkoutStepResult(
          stepId: step.id,
          type: step.type,
          title: step.title,
          score: freshAttempt.accuracyPercentage.toDouble(),
          passed: freshAttempt.passed,
          transcript: freshAttempt.transcript,
          arabicCoaching: freshAttempt.arabicCoaching,
          missingAnchors: freshAttempt.missingAnchors,
          pbErrors: freshAttempt.pbErrors,
        ),
      );
      return;
    }

    // No fresh attempt recorded: user pressed Back or cancelled drill
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Drill practice was interrupted or cancelled. You can retry or skip.',
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _executeScenarioStep(
    WorkoutStep step,
    int stepIndex,
    IAttemptRepository? attemptRepo,
  ) async {
    final priorAttemptIds = attemptRepo != null
        ? (await attemptRepo.getAttempts(scenarioId: step.targetId))
              .map((a) => a.id)
              .toSet()
        : <String>{};

    if (!mounted) return;

    dynamic popResult;
    final salesScenario = SalesScenarioCatalog.findById(step.targetId);
    if (salesScenario != null) {
      popResult = await Navigator.push<dynamic>(
        context,
        MaterialPageRoute(
          builder: (_) => SalesSimulatorScreen(
            scenario: salesScenario,
            curriculumDay: widget.workout.day.dayNumber,
            workoutStepId: step.id,
          ),
        ),
      );
    } else {
      final arenaScenario = ScenarioCatalog.findById(step.targetId);
      if (arenaScenario != null) {
        popResult = await Navigator.push<dynamic>(
          context,
          MaterialPageRoute(
            builder: (_) => MultiTurnSimulatorScreen(
              scenario: arenaScenario,
              curriculumDay: widget.workout.day.dayNumber,
              workoutStepId: step.id,
            ),
          ),
        );
      }
    }

    if (!mounted) return;

    // Check for fresh attempt tied to this step execution
    AttemptRecord? freshAttempt;
    if (popResult is AttemptRecord &&
        (popResult.workoutStepId == null ||
            popResult.workoutStepId == step.id)) {
      freshAttempt = popResult;
    } else if (attemptRepo != null) {
      final currentAttempts = await attemptRepo.getAttempts(
        scenarioId: step.targetId,
      );
      final newAttempts = currentAttempts.where((a) {
        if (priorAttemptIds.contains(a.id)) return false;
        if (a.workoutStepId != null && a.workoutStepId != step.id) {
          return false;
        }
        return true;
      }).toList();
      if (newAttempts.isNotEmpty) {
        freshAttempt = newAttempts.first;
      }
    }

    if (freshAttempt != null) {
      await _controller.recordStepResult(
        stepIndex: stepIndex,
        result: WorkoutStepResult(
          stepId: step.id,
          type: step.type,
          title: step.title,
          score: freshAttempt.accuracyPercentage.toDouble(),
          passed: freshAttempt.passed,
          transcript: freshAttempt.transcript,
          missingAnchors: freshAttempt.missingAnchors,
          pbErrors: freshAttempt.pbErrors,
          arabicCoaching: freshAttempt.arabicCoaching,
          salesOutcomeType: freshAttempt.salesOutcomeType,
          salesScorecard: freshAttempt.salesScorecard,
        ),
      );
      return;
    }

    // No fresh attempt recorded: user pressed Back or cancelled simulation
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Simulation was cancelled or not completed. Please try again or skip.',
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final session = _controller.session;

    if (session == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Workout Session')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final currentStep = session.currentStep;
    final totalSteps = session.workout.steps.length;
    final currentStepNum = session.currentStepIndex + 1;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'DAY ${session.workout.day.dayNumber} WORKOUT SESSION',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.pause_circle_outline_rounded),
            tooltip: 'Pause & Return to Dashboard',
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Progress Header Card
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0D47A1), Color(0xFF002171)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00A3E0)
                              .withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          session.isSessionCompleted
                              ? 'SESSION COMPLETED'
                              : 'STEP $currentStepNum OF $totalSteps',
                          style: const TextStyle(
                            color: Color(0xFF64B5F6),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                      Text(
                        '${(session.progressFraction * 100).round()}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    session.workout.day.themeTitle,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  if (session.workout.day.themeTitleArabic.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      session.workout.day.themeTitleArabic,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFFFFD54F),
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: session.progressFraction,
                      minHeight: 6,
                      backgroundColor: Colors.white.withValues(alpha: 0.15),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF00A3E0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Step Queue List
            Text(
              'WORKOUT QUEUE (${session.completedStepsCount}/$totalSteps COMPLETED)',
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 8),

            ...session.workout.steps.asMap().entries.map((entry) {
              final idx = entry.key;
              final step = entry.value;
              final status =
                  session.stepStatuses[idx] ?? WorkoutStepStatus.pending;
              final isCurrent = idx == session.currentStepIndex;
              final result = session.stepResults[idx];

              return Card(
                elevation: isCurrent ? 3 : 1,
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: isCurrent
                        ? const Color(0xFF00A3E0)
                        : (status == WorkoutStepStatus.completed
                              ? Colors.green.shade700
                              : theme.dividerColor),
                    width: isCurrent ? 1.5 : 1,
                  ),
                ),
                child: ListTile(
                  dense: true,
                  leading: CircleAvatar(
                    radius: 14,
                    backgroundColor: status == WorkoutStepStatus.completed
                        ? Colors.green.withValues(alpha: 0.2)
                        : (isCurrent
                              ? const Color(0xFF00A3E0).withValues(alpha: 0.2)
                              : Colors.grey.withValues(alpha: 0.15)),
                    child: Icon(
                      status == WorkoutStepStatus.completed
                          ? Icons.check_circle_rounded
                          : (isCurrent
                                ? Icons.play_arrow_rounded
                                : Icons.circle_outlined),
                      size: 16,
                      color: status == WorkoutStepStatus.completed
                          ? Colors.green
                          : (isCurrent ? const Color(0xFF00A3E0) : Colors.grey),
                    ),
                  ),
                  title: Text(
                    '${idx + 1}. ${step.title}',
                    style: TextStyle(
                      fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                  subtitle: Text(
                    '${step.estimatedMinutes} min • ${step.description}',
                    style: const TextStyle(fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (result != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: result.passed
                                ? Colors.green.withValues(alpha: 0.2)
                                : Colors.red.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${result.score.round()}%',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: result.passed ? Colors.green : Colors.red,
                            ),
                          ),
                        ),
                      const SizedBox(width: 4),
                      Icon(
                        isCurrent
                            ? Icons.arrow_forward_ios_rounded
                            : Icons.chevron_right_rounded,
                        size: 14,
                        color: isCurrent
                            ? const Color(0xFF00A3E0)
                            : Colors.grey,
                      ),
                    ],
                  ),
                  onTap: () {
                    _controller.setCurrentStep(idx);
                  },
                ),
              );
            }),
            const SizedBox(height: 16),

            // Active Step Execution Deck
            if (currentStep != null) ...[
              if (currentStep.type == WorkoutStepType.coachingReview)
                _buildCoachingReviewCard(session)
              else
                _buildActiveStepCard(session, currentStep),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActiveStepCard(WorkoutSessionState session, WorkoutStep step) {
    final isWarmup = step.type == WorkoutStepType.warmupDrill;
    final isScenario = step.type == WorkoutStepType.primaryScenario;
    final isChallenge = step.type == WorkoutStepType.challengeDrill;

    String buttonLabel = 'START STEP';
    IconData buttonIcon = Icons.play_arrow_rounded;

    if (isWarmup) {
      buttonLabel = 'START WARM-UP DRILL';
      buttonIcon = Icons.record_voice_over_rounded;
    } else if (isScenario) {
      buttonLabel = 'ENTER SPOKEN SIMULATION';
      buttonIcon = Icons.headset_mic_rounded;
    } else if (isChallenge) {
      buttonLabel = 'START CHALLENGE DRILL';
      buttonIcon = Icons.bolt_rounded;
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Color(0xFF00A3E0), width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.play_circle_fill_rounded,
                  color: Color(0xFF00A3E0),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'CURRENT STEP: ${step.title.toUpperCase()}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00A3E0),
                      letterSpacing: 0.8,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              step.description,
              style: const TextStyle(fontSize: 13, height: 1.35),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                key: const Key('btn_launch_workout_step'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00A3E0),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: Icon(buttonIcon),
                label: Text(
                  buttonLabel,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
                onPressed: _launchCurrentStep,
              ),
            ),
            const SizedBox(height: 6),
            Center(
              child: TextButton(
                onPressed: () {
                  _controller.skipStep(session.currentStepIndex);
                },
                child: const Text('Skip this step'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoachingReviewCard(WorkoutSessionState session) {
    final scenarioResult = session.primaryScenarioResult;
    final objectives = session.workout.day.learningObjectives;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.green.shade700, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.fact_check_rounded,
                  color: Colors.green,
                  size: 22,
                ),
                const SizedBox(width: 8),
                const Text(
                  'EVIDENCE-BASED COACHING REVIEW',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Performance overview
            if (scenarioResult != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: scenarioResult.passed
                      ? Colors.green.withValues(alpha: 0.1)
                      : Colors.amber.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: scenarioResult.passed
                        ? Colors.green.shade800
                        : Colors.amber.shade800,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Simulation Score: ${scenarioResult.score.round()}%',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: scenarioResult.passed
                                ? Colors.green
                                : Colors.amber,
                          ),
                        ),
                        Text(
                          scenarioResult.passed ? 'PASSED' : 'NEEDS PRACTICE',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: scenarioResult.passed
                                ? Colors.green
                                : Colors.amber,
                          ),
                        ),
                      ],
                    ),
                    if (scenarioResult.salesOutcomeType != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        'Sales Outcome: ${scenarioResult.salesOutcomeType!.toUpperCase()}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Egyptian Arabic Coaching feedback
              if (scenarioResult.arabicCoaching != null &&
                  scenarioResult.arabicCoaching!.isNotEmpty) ...[
                const Text(
                  'Egyptian Arabic Floor Coaching:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFD54F),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2400),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    scenarioResult.arabicCoaching!,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFFFFE082),
                      height: 1.35,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // Missing anchors
              if (scenarioResult.missingAnchors.isNotEmpty) ...[
                const Text(
                  'Missing Anchors / Disclosures:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: scenarioResult.missingAnchors
                      .map(
                        (a) => Chip(
                          backgroundColor: Colors.red.withValues(alpha: 0.15),
                          label: Text(
                            a,
                            style: const TextStyle(
                              color: Colors.redAccent,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 12),
              ],
            ],

            // Day Learning Objectives
            if (objectives.isNotEmpty) ...[
              const Text(
                'Day Objectives Checklist:',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.6,
                ),
              ),
              const SizedBox(height: 6),
              ...objectives.map(
                (obj) => Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.check_circle_outline_rounded,
                        size: 16,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          obj,
                          style: const TextStyle(fontSize: 12, height: 1.3),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
            ],

            if (session.canCompleteWorkout) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  key: const Key('btn_complete_workout_session'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.check_rounded),
                  label: const Text(
                    'COMPLETE WORKOUT & RETURN',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                  onPressed: () async {
                    final completed = await _controller.completeEntireWorkout();
                    if (mounted) {
                      Navigator.pop(context, completed);
                    }
                  },
                ),
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber.shade700),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.amber.shade400,
                      size: 22,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        session.primaryScenarioResult == null
                            ? 'Primary scenario has not been completed. Passing score (>= 70%) required to complete daily workout.'
                            : (session.primaryScenarioResult!.passed
                                  ? 'Some exercises are still pending. Please complete or skip all steps.'
                                  : 'Primary scenario did not meet passing standard. Retry required to complete workout.'),
                        style: const TextStyle(fontSize: 12, height: 1.3),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  key: const Key('btn_complete_workout_session'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Color(0xFF00A3E0)),
                  ),
                  icon: const Icon(
                    Icons.exit_to_app_rounded,
                    color: Color(0xFF00A3E0),
                  ),
                  label: const Text(
                    'SAVE PROGRESS & EXIT (PARTIAL)',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
