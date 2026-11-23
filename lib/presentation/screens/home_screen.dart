import 'package:flutter/material.dart';

import '../../core/audio/speech_service.dart';
import '../../core/di/service_locator.dart';
import '../../data/datasources/sales_scenario_catalog.dart';
import '../../data/datasources/scenario_catalog.dart';
import '../../domain/entities/adaptive_curriculum.dart';
import '../../domain/repositories/progress_repository.dart';
import '../controllers/curriculum_controller.dart';
import '../controllers/floor_skills_controller.dart';
import '../controllers/progress_controller.dart';
import '../widgets/curriculum_timeline_view.dart';
import 'disclosure_studio_screen.dart';
import 'discovery_drill_screen.dart';
import 'floor_skills_screen.dart';
import 'multi_turn_simulator_screen.dart';
import 'objection_drill_screen.dart';
import 'sales_lab_screen.dart';
import 'sales_simulator_screen.dart';
import 'voice_arena_screen.dart';
import 'workout_session_screen.dart';

class HomeScreen extends StatefulWidget {
  final ProgressController progressController;

  const HomeScreen({super.key, required this.progressController});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CurriculumController? _curriculumController;

  @override
  void initState() {
    super.initState();
    if (ServiceLocator.isRegistered<IProgressRepository>()) {
      _curriculumController = CurriculumController(
        progressRepository: ServiceLocator.get<IProgressRepository>(),
      );
      _curriculumController!.addListener(_onCurriculumUpdate);
      _curriculumController!.loadCurriculum();
    }
  }

  void _onCurriculumUpdate() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _curriculumController?.removeListener(_onCurriculumUpdate);
    _curriculumController?.dispose();
    super.dispose();
  }

  Future<void> _refreshAll() async {
    await widget.progressController.loadProgress();
    if (_curriculumController != null) {
      await _curriculumController!.loadCurriculum();
    }
  }

  void _startDailyWorkout(BuildContext context, DailyWorkoutPlan workout) {
    _showWorkoutQueueSheet(context, workout);
  }

  void _launchScenario(BuildContext context, String scenarioId, int dayNumber) {
    if (scenarioId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: No scenario ID assigned')),
      );
      return;
    }
    final salesScenario = SalesScenarioCatalog.findById(scenarioId);
    if (salesScenario != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SalesSimulatorScreen(
            scenario: salesScenario,
            curriculumDay: dayNumber,
          ),
        ),
      ).then((_) => _refreshAll());
      return;
    }

    final arenaScenario = ScenarioCatalog.findById(scenarioId);
    if (arenaScenario != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MultiTurnSimulatorScreen(
            scenario: arenaScenario,
            curriculumDay: dayNumber,
          ),
        ),
      ).then((_) => _refreshAll());
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: Could not resolve scenario "$scenarioId"'),
        backgroundColor: Colors.red.shade800,
      ),
    );
  }

  void _launchStep(
    BuildContext context,
    WorkoutStep step,
    DailyWorkoutPlan workout,
  ) {
    switch (step.type) {
      case WorkoutStepType.warmupDrill:
      case WorkoutStepType.challengeDrill:
        if (step.drillType == 'discovery') {
          final exists = SalesScenarioCatalog.allDiscoveryDrills.any(
            (d) => d.id == step.targetId,
          );
          if (!exists) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Error: Could not resolve discovery drill "${step.targetId}"',
                ),
                backgroundColor: Colors.red.shade800,
              ),
            );
            return;
          }
          final speech = ServiceLocator.get<ISpeechService>();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DiscoveryDrillScreen(
                speechService: speech,
                initialDrillId: step.targetId,
              ),
            ),
          ).then((_) => _refreshAll());
        } else if (step.drillType == 'objection') {
          final exists = SalesScenarioCatalog.allObjectionDrills.any(
            (d) => d.id == step.targetId,
          );
          if (!exists) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Error: Could not resolve objection drill "${step.targetId}"',
                ),
                backgroundColor: Colors.red.shade800,
              ),
            );
            return;
          }
          final speech = ServiceLocator.get<ISpeechService>();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ObjectionDrillScreen(
                speechService: speech,
                initialDrillId: step.targetId,
              ),
            ),
          ).then((_) => _refreshAll());
        } else if (step.drillType == 'fast_numbers') {
          final item = FloorSkillsController.findFastNumberById(step.targetId);
          if (item == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Error: Could not resolve fast numbers drill "${step.targetId}"',
                ),
                backgroundColor: Colors.red.shade800,
              ),
            );
            return;
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FloorSkillsScreen(
                initialDrillType: FloorDrillType.fastNumbers,
                initialDrillId: step.targetId,
              ),
            ),
          ).then((_) => _refreshAll());
        } else {
          final item = FloorSkillsController.findPbById(step.targetId);
          if (item == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Error: Could not resolve P/B drill "${step.targetId}"',
                ),
                backgroundColor: Colors.red.shade800,
              ),
            );
            return;
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FloorSkillsScreen(
                initialDrillType: FloorDrillType.pbContrast,
                initialDrillId: step.targetId,
              ),
            ),
          ).then((_) => _refreshAll());
        }
        break;

      case WorkoutStepType.primaryScenario:
        _launchScenario(context, step.targetId, workout.day.dayNumber);
        break;

      case WorkoutStepType.coachingReview:
        showDialog(
          context: context,
          builder: (dialogCtx) => AlertDialog(
            title: const Text('Pedagogical Review & Objectives'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workout.day.themeTitle,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  if (workout.day.themeTitleArabic.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      workout.day.themeTitleArabic,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  const Text(
                    'Key Learning Objectives:',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  ...workout.day.learningObjectives.map(
                    (obj) => Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('• '),
                          Expanded(
                            child: Text(
                              obj,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogCtx),
                child: const Text('Done'),
              ),
            ],
          ),
        );
        break;
    }
  }

  void _showWorkoutQueueSheet(BuildContext context, DailyWorkoutPlan workout) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        final theme = Theme.of(sheetContext);
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade600,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00A3E0)
                              .withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'DAY ${workout.day.dayNumber} WORKOUT (${workout.chosenMinutes} MIN)',
                          style: const TextStyle(
                            color: Color(0xFF00A3E0),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(sheetContext),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    workout.day.themeTitle,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (workout.day.themeTitleArabic.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      workout.day.themeTitleArabic,
                      style: TextStyle(
                        color: theme.colorScheme.secondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Text(
                    'WORKOUT QUEUE (${workout.steps.length} STEPS)',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...workout.steps.asMap().entries.map((entry) {
                    final index = entry.key;
                    final step = entry.value;
                    IconData icon;
                    switch (step.type) {
                      case WorkoutStepType.warmupDrill:
                        icon = Icons.record_voice_over_rounded;
                        break;
                      case WorkoutStepType.primaryScenario:
                        icon = Icons.headset_mic_rounded;
                        break;
                      case WorkoutStepType.challengeDrill:
                        icon = Icons.bolt_rounded;
                        break;
                      case WorkoutStepType.coachingReview:
                        icon = Icons.fact_check_rounded;
                        break;
                    }

                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 16,
                          backgroundColor: const Color(0xFF00A3E0)
                              .withValues(alpha: 0.2),
                          child: Icon(
                            icon,
                            size: 18,
                            color: const Color(0xFF00A3E0),
                          ),
                        ),
                        title: Text(
                          '${index + 1}. ${step.title}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        subtitle: Text(
                          '${step.estimatedMinutes} min • ${step.description}',
                          style: const TextStyle(fontSize: 12),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: const Icon(
                          Icons.play_circle_fill_rounded,
                          color: Color(0xFF00A3E0),
                        ),
                        onTap: () {
                          Navigator.pop(sheetContext);
                          _launchStep(context, step, workout);
                        },
                      ),
                    );
                  }),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      key: const Key('btn_start_full_workout_session'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: const Color(0xFF0D47A1),
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.playlist_play_rounded),
                      label: const Text(
                        'START FULL WORKOUT SESSION',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(sheetContext);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                WorkoutSessionScreen(workout: workout),
                          ),
                        ).then((_) => _refreshAll());
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        foregroundColor: const Color(0xFF00A3E0),
                        side: const BorderSide(color: Color(0xFF00A3E0)),
                      ),
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: const Text(
                        'START PRIMARY SCENARIO',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(sheetContext);
                        _launchScenario(
                          context,
                          workout.day.primaryScenarioId,
                          workout.day.dayNumber,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: widget.progressController,
      builder: (context, child) {
        final progress = widget.progressController.progress;
        final rec = widget.progressController.dailyRecommendation;

        return Scaffold(
          appBar: AppBar(
            title: const Row(
              children: [
                Icon(Icons.bolt_rounded, color: Color(0xFF00A3E0)),
                SizedBox(width: 8),
                Text(
                  'CALLFORGE ACADEMY',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
            actions: [
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.amber.shade900.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.amber.shade700),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.local_fire_department_rounded,
                      color: Colors.amber,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${progress.streakDays} DAYS',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: _refreshAll,
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // Welcome Agent Header
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
                      const Text(
                        'AGENT WORKSTATION: ALEX',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF64B5F6),
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Ready for Spoken Floor Practice?',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Complete today\'s targeted voice workout to reinforce customer de-escalation, disclosures, and phonemic awareness.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade300,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          _statChip(
                            label: 'Simulations',
                            value: '${progress.totalSimulationsCompleted}',
                          ),
                          const SizedBox(width: 8),
                          _statChip(
                            label: 'Disclosures',
                            value: '${progress.totalDisclosuresCompleted}',
                          ),
                          const SizedBox(width: 8),
                          _statChip(
                            label: 'Mastery',
                            value: '${progress.overallMasteryPercent}%',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // 90-Day Adaptive Academy Timeline
                if (_curriculumController != null &&
                    _curriculumController!.progressSummary != null &&
                    _curriculumController!.activeWorkout != null) ...[
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_month_rounded,
                        size: 18,
                        color: Color(0xFF00A3E0),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '90-DAY ADAPTIVE ACADEMY',
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  CurriculumTimelineView(
                    summary: _curriculumController!.progressSummary!,
                    workout: _curriculumController!.activeWorkout!,
                    onSelectDuration: (mins) async {
                      await _curriculumController!.setDuration(mins);
                      setState(() {});
                    },
                    onStartWorkout: () => _startDailyWorkout(
                      context,
                      _curriculumController!.activeWorkout!,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Today's Recommended Workout Card (Floor Skills / Arena fallback)
                if (rec != null) ...[
                  Row(
                    children: [
                      const Icon(
                        Icons.fitness_center_rounded,
                        size: 18,
                        color: Color(0xFF00A3E0),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'TODAY\'S RECOMMENDED WORKOUT',
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: const Color(0xFF00A3E0).withValues(alpha: 0.3),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF00A3E0)
                                      .withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'FOCUS: ${rec.focusSkillTag.toUpperCase()}',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF00A3E0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            rec.recommendedScenario.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: Text(
                              rec.trainerRationaleArabic,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFFFFD54F),
                                height: 1.4,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          FilledButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => MultiTurnSimulatorScreen(
                                    scenario: rec.recommendedScenario,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.play_arrow_rounded),
                            label: const Text('Start Daily Call Simulation'),
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF00A3E0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // Fast Launch Hub
                Text(
                  'ACADEMY TRAINING SUITES',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 12),
                _hubCard(
                  context: context,
                  title: 'Sales Mastery Lab',
                  subtitle: '48 Consultative scenarios, 8 objection drills, 12 discovery drills, and product-fit tool.',
                  icon: Icons.storefront_rounded,
                  accentColor: const Color(0xFFF59E0B),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SalesLabScreen()),
                    );
                  },
                ),
                const SizedBox(height: 10),
                _hubCard(
                  context: context,
                  title: '30-Scenario Voice Arena',
                  subtitle: 'Customer de-escalation, billing proration, fiber troubleshooting, and sales discovery.',
                  icon: Icons.record_voice_over_rounded,
                  accentColor: const Color(0xFF00A3E0),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const VoiceArenaScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                _hubCard(
                  context: context,
                  title: 'M2 Disclosure Studio',
                  subtitle: 'Practice legally critical copy, karaoke word tracking, and simulated customer consent.',
                  icon: Icons.gavel_rounded,
                  accentColor: const Color(0xFFAB47BC),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const DisclosureStudioScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                _hubCard(
                  context: context,
                  title: 'M3 Floor Skills & Drills',
                  subtitle: 'P/B phonemic awareness minimal pairs, fast number listening, and AERD responses.',
                  icon: Icons.tune_rounded,
                  accentColor: const Color(0xFF26A69A),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const FloorSkillsScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _statChip({required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 10, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }

  Widget _hubCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.dividerColor.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: accentColor, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade400,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
