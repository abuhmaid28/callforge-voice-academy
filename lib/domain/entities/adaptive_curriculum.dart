/// The three 30-day phases of the 90-Day Adaptive Academy.
enum CurriculumPhaseType {
  /// Days 1–30: Core foundations, mandatory opening, AERD, billing explanations, and basic disclosures.
  phase1Foundations,

  /// Days 31–60: Consultative sales discovery, uncovering household needs, value bridging, and plan upgrades.
  phase2SalesConfidence,

  /// Days 61–90: High-friction objection handling, retention recovery, ethical closing, and respectful no-sale mastery.
  phase3AdvancedClosing,
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

  const DailyWorkoutPlan({
    required this.day,
    this.chosenMinutes = 20,
    this.isCompleted = false,
    this.isRecoveryWorkout = false,
    required this.scheduledDate,
    this.completedAt,
    this.scoreEarned,
  });

  DailyWorkoutPlan copyWith({
    CurriculumDay? day,
    int? chosenMinutes,
    bool? isCompleted,
    bool? isRecoveryWorkout,
    DateTime? scheduledDate,
    DateTime? completedAt,
    double? scoreEarned,
  }) {
    return DailyWorkoutPlan(
      day: day ?? this.day,
      chosenMinutes: chosenMinutes ?? this.chosenMinutes,
      isCompleted: isCompleted ?? this.isCompleted,
      isRecoveryWorkout: isRecoveryWorkout ?? this.isRecoveryWorkout,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      completedAt: completedAt ?? this.completedAt,
      scoreEarned: scoreEarned ?? this.scoreEarned,
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
