/// The three 30-day phases of the 90-Day Adaptive Academy.
enum CurriculumPhaseType {
  /// Days 1–30: Core foundations, mandatory opening, AERD, billing explanations, and basic disclosures.
  phase1Foundations,

  /// Days 31–60: Consultative sales discovery, uncovering household needs, value bridging, and plan upgrades.
  phase2SalesConfidence,

  /// Days 61–90: High-friction objection handling, retention recovery, ethical closing, and respectful no-sale mastery.
  phase3AdvancedClosing,
}

/// The type of step in a multi-step daily workout queue.
enum WorkoutStepType {
  /// A preliminary speech, phonemic, or discovery warm-up drill.
  warmupDrill,

  /// The core simulated multi-turn customer scenario of the day.
  primaryScenario,

  /// A secondary drill to challenge the agent on objections or number recognition.
  challengeDrill,

  /// Structured pedagogical review of coaching points and scorecard metrics.
  coachingReview,
}

/// A discrete actionable task within a daily workout session.
class WorkoutStep {
  final String id;
  final String title;
  final String titleArabic;
  final String description;
  final WorkoutStepType type;
  final String targetId; // scenario ID or drill ID
  final String?
  drillType; // 'objection', 'discovery', 'pb_contrast', 'fast_numbers'
  final int estimatedMinutes;
  final bool isCompleted;

  const WorkoutStep({
    required this.id,
    required this.title,
    this.titleArabic = '',
    required this.description,
    required this.type,
    required this.targetId,
    this.drillType,
    required this.estimatedMinutes,
    this.isCompleted = false,
  });

  WorkoutStep copyWith({
    String? id,
    String? title,
    String? titleArabic,
    String? description,
    WorkoutStepType? type,
    String? targetId,
    String? drillType,
    int? estimatedMinutes,
    bool? isCompleted,
  }) {
    return WorkoutStep(
      id: id ?? this.id,
      title: title ?? this.title,
      titleArabic: titleArabic ?? this.titleArabic,
      description: description ?? this.description,
      type: type ?? this.type,
      targetId: targetId ?? this.targetId,
      drillType: drillType ?? this.drillType,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'titleArabic': titleArabic,
    'description': description,
    'type': type.name,
    'targetId': targetId,
    if (drillType != null) 'drillType': drillType,
    'estimatedMinutes': estimatedMinutes,
    'isCompleted': isCompleted,
  };

  factory WorkoutStep.fromJson(Map<String, dynamic> json) => WorkoutStep(
    id: json['id'] as String,
    title: json['title'] as String,
    titleArabic: json['titleArabic'] as String? ?? '',
    description: json['description'] as String? ?? '',
    type: WorkoutStepType.values.firstWhere(
      (t) => t.name == json['type'],
      orElse: () => WorkoutStepType.primaryScenario,
    ),
    targetId: json['targetId'] as String,
    drillType: json['drillType'] as String?,
    estimatedMinutes: json['estimatedMinutes'] as int? ?? 5,
    isCompleted: json['isCompleted'] as bool? ?? false,
  );
}

/// Metadata and assignment for an individual day in the 90-day program.
class CurriculumDay {
  final int dayNumber; // 1..90
  final CurriculumPhaseType phase;
  final String themeTitle;
  final String themeTitleArabic;
  final String focusSkillTag;
  final String primaryScenarioId;
  final String? drillType; // 'objection', 'discovery', 'pb_contrast', 'fast_numbers', 'disclosure'
  final String? drillId;
  final List<String> learningObjectives;

  const CurriculumDay({
    required this.dayNumber,
    required this.phase,
    required this.themeTitle,
    required this.themeTitleArabic,
    required this.focusSkillTag,
    required this.primaryScenarioId,
    this.drillType,
    this.drillId,
    this.learningObjectives = const [],
  });

  int get weekNumber => ((dayNumber - 1) ~/ 7) + 1;

  Map<String, dynamic> toJson() => {
    'dayNumber': dayNumber,
    'phase': phase.name,
    'themeTitle': themeTitle,
    'themeTitleArabic': themeTitleArabic,
    'focusSkillTag': focusSkillTag,
    'primaryScenarioId': primaryScenarioId,
    if (drillType != null) 'drillType': drillType,
    if (drillId != null) 'drillId': drillId,
    'learningObjectives': learningObjectives,
  };

  factory CurriculumDay.fromJson(Map<String, dynamic> json) => CurriculumDay(
    dayNumber: json['dayNumber'] as int,
    phase: CurriculumPhaseType.values.firstWhere(
      (p) => p.name == json['phase'],
      orElse: () => CurriculumPhaseType.phase1Foundations,
    ),
    themeTitle: json['themeTitle'] as String,
    themeTitleArabic: json['themeTitleArabic'] as String? ?? '',
    focusSkillTag: json['focusSkillTag'] as String? ?? 'AERD',
    primaryScenarioId: json['primaryScenarioId'] as String,
    drillType: json['drillType'] as String?,
    drillId: json['drillId'] as String?,
    learningObjectives:
        (json['learningObjectives'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        const [],
  );
}

/// Generated daily practice session configured for 10, 20, or 30 minutes.
class DailyWorkoutPlan {
  final CurriculumDay day;
  final int chosenMinutes; // 10, 20, or 30
  final bool isCompleted;
  final bool isRecoveryWorkout;
  final DateTime scheduledDate;
  final DateTime? completedAt;
  final double? scoreEarned;
  final List<WorkoutStep> steps;

  const DailyWorkoutPlan({
    required this.day,
    this.chosenMinutes = 20,
    this.isCompleted = false,
    this.isRecoveryWorkout = false,
    required this.scheduledDate,
    this.completedAt,
    this.scoreEarned,
    this.steps = const [],
  });

  DailyWorkoutPlan copyWith({
    CurriculumDay? day,
    int? chosenMinutes,
    bool? isCompleted,
    bool? isRecoveryWorkout,
    DateTime? scheduledDate,
    DateTime? completedAt,
    double? scoreEarned,
    List<WorkoutStep>? steps,
  }) {
    return DailyWorkoutPlan(
      day: day ?? this.day,
      chosenMinutes: chosenMinutes ?? this.chosenMinutes,
      isCompleted: isCompleted ?? this.isCompleted,
      isRecoveryWorkout: isRecoveryWorkout ?? this.isRecoveryWorkout,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      completedAt: completedAt ?? this.completedAt,
      scoreEarned: scoreEarned ?? this.scoreEarned,
      steps: steps ?? this.steps,
    );
  }

  Map<String, dynamic> toJson() => {
    'day': day.toJson(),
    'chosenMinutes': chosenMinutes,
    'isCompleted': isCompleted,
    'isRecoveryWorkout': isRecoveryWorkout,
    'scheduledDate': scheduledDate.toIso8601String(),
    if (completedAt != null) 'completedAt': completedAt!.toIso8601String(),
    if (scoreEarned != null) 'scoreEarned': scoreEarned,
    'steps': steps.map((s) => s.toJson()).toList(),
  };

  factory DailyWorkoutPlan.fromJson(Map<String, dynamic> json) =>
      DailyWorkoutPlan(
        day: CurriculumDay.fromJson(json['day'] as Map<String, dynamic>),
        chosenMinutes: json['chosenMinutes'] as int? ?? 20,
        isCompleted: json['isCompleted'] as bool? ?? false,
        isRecoveryWorkout: json['isRecoveryWorkout'] as bool? ?? false,
        scheduledDate: DateTime.parse(json['scheduledDate'] as String),
        completedAt: json['completedAt'] != null
            ? DateTime.parse(json['completedAt'] as String)
            : null,
        scoreEarned: (json['scoreEarned'] as num?)?.toDouble(),
        steps:
            (json['steps'] as List<dynamic>?)
                ?.map((e) => WorkoutStep.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
      );
}

/// High-level 13-week milestones across the 90-day program.
class WeeklyMilestone {
  final int weekNumber; // 1..13
  final CurriculumPhaseType phase;
  final String title;
  final String titleArabic;
  final String targetCompetency;

  const WeeklyMilestone({
    required this.weekNumber,
    required this.phase,
    required this.title,
    required this.titleArabic,
    required this.targetCompetency,
  });
}
