import 'adaptive_curriculum.dart';

enum WorkoutStepStatus { pending, inProgress, completed, skipped }

/// Structured outcome and evaluation of a single step within a daily workout session.
class WorkoutStepResult {
  final String stepId;
  final WorkoutStepType type;
  final String title;
  final double score;
  final bool passed;
  final String? transcript;
  final List<String> missingAnchors;
  final List<String> pbErrors;
  final String? arabicCoaching;
  final String? salesOutcomeType;
  final Map<String, dynamic>? salesScorecard;
  final DateTime completedAt;

  WorkoutStepResult({
    required this.stepId,
    required this.type,
    required this.title,
    required this.score,
    required this.passed,
    this.transcript,
    this.missingAnchors = const [],
    this.pbErrors = const [],
    this.arabicCoaching,
    this.salesOutcomeType,
    this.salesScorecard,
    DateTime? completedAt,
  }) : completedAt = completedAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'stepId': stepId,
    'type': type.name,
    'title': title,
    'score': score,
    'passed': passed,
    if (transcript != null) 'transcript': transcript,
    'missingAnchors': missingAnchors,
    'pbErrors': pbErrors,
    if (arabicCoaching != null) 'arabicCoaching': arabicCoaching,
    if (salesOutcomeType != null) 'salesOutcomeType': salesOutcomeType,
    if (salesScorecard != null) 'salesScorecard': salesScorecard,
    'completedAt': completedAt.toIso8601String(),
  };

  factory WorkoutStepResult.fromJson(Map<String, dynamic> json) =>
      WorkoutStepResult(
        stepId: json['stepId'] as String,
        type: WorkoutStepType.values.firstWhere(
          (t) => t.name == json['type'],
          orElse: () => WorkoutStepType.warmupDrill,
        ),
        title: json['title'] as String,
        score: (json['score'] as num).toDouble(),
        passed: json['passed'] as bool? ?? true,
        transcript: json['transcript'] as String?,
        missingAnchors:
            (json['missingAnchors'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            const [],
        pbErrors:
            (json['pbErrors'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            const [],
        arabicCoaching: json['arabicCoaching'] as String?,
        salesOutcomeType: json['salesOutcomeType'] as String?,
        salesScorecard: json['salesScorecard'] as Map<String, dynamic>?,
        completedAt: json['completedAt'] != null
            ? DateTime.parse(json['completedAt'] as String)
            : null,
      );
}

/// Active execution state of a daily multi-step practice workout session.
class WorkoutSessionState {
  final DailyWorkoutPlan workout;
  final int currentStepIndex;
  final Map<int, WorkoutStepStatus> stepStatuses;
  final Map<int, WorkoutStepResult> stepResults;
  final bool isSessionCompleted;
  final DateTime startedAt;
  final DateTime? completedAt;

  WorkoutSessionState({
    required this.workout,
    this.currentStepIndex = 0,
    Map<int, WorkoutStepStatus>? stepStatuses,
    Map<int, WorkoutStepResult>? stepResults,
    this.isSessionCompleted = false,
    DateTime? startedAt,
    this.completedAt,
  }) : stepStatuses =
           stepStatuses ??
           {
             for (int i = 0; i < workout.steps.length; i++)
               i: i == 0
                   ? WorkoutStepStatus.inProgress
                   : WorkoutStepStatus.pending,
           },
       stepResults = stepResults ?? {},
       startedAt = startedAt ?? DateTime.now();

  WorkoutStep? get currentStep =>
      currentStepIndex >= 0 && currentStepIndex < workout.steps.length
      ? workout.steps[currentStepIndex]
      : null;

  int get completedStepsCount =>
      stepStatuses.values.where((s) => s == WorkoutStepStatus.completed).length;

  double get progressFraction => workout.steps.isNotEmpty
      ? completedStepsCount / workout.steps.length
      : 0.0;

  WorkoutStepResult? get primaryScenarioResult {
    for (int i = 0; i < workout.steps.length; i++) {
      if (workout.steps[i].type == WorkoutStepType.primaryScenario) {
        return stepResults[i];
      }
    }
    return null;
  }

  WorkoutSessionState copyWith({
    DailyWorkoutPlan? workout,
    int? currentStepIndex,
    Map<int, WorkoutStepStatus>? stepStatuses,
    Map<int, WorkoutStepResult>? stepResults,
    bool? isSessionCompleted,
    DateTime? startedAt,
    DateTime? completedAt,
  }) {
    return WorkoutSessionState(
      workout: workout ?? this.workout,
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      stepStatuses: stepStatuses ?? Map.from(this.stepStatuses),
      stepResults: stepResults ?? Map.from(this.stepResults),
      isSessionCompleted: isSessionCompleted ?? this.isSessionCompleted,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
