import '../../data/datasources/curriculum_datasource.dart';
import '../../domain/entities/adaptive_curriculum.dart';

/// Progress summary report for the 90-day curriculum.
class CurriculumProgressSummary {
  final int currentDay;
  final int completedDaysCount;
  final double completionPercentage;
  final CurriculumPhaseType currentPhase;
  final int currentWeek;
  final WeeklyMilestone? currentMilestone;
  final bool isCompleted;

  const CurriculumProgressSummary({
    required this.currentDay,
    required this.completedDaysCount,
    required this.completionPercentage,
    required this.currentPhase,
    required this.currentWeek,
    this.currentMilestone,
    required this.isCompleted,
  });
}

/// Core engine for generating daily workouts, handling day skips, and tracking 90-day progress.
class CurriculumEngine {
  /// Generate a tailored daily workout plan for the specified day and user duration preference.
  static DailyWorkoutPlan generateDailyWorkout({
    required int dayNumber,
    int chosenMinutes = 20,
    DateTime? currentDate,
    DateTime? lastActiveDate,
    bool isCompleted = false,
    DateTime? completedAt,
    double? scoreEarned,
  }) {
    final now = currentDate ?? DateTime.now();
    final day =
        CurriculumDataSource.getDay(dayNumber) ??
        CurriculumDataSource.allDays.first;

    // Detect missed days (2 or more days between last activity and now)
    bool isRecovery = false;
    if (lastActiveDate != null && !isCompleted) {
      final daysDiff = DateTime(now.year, now.month, now.day)
          .difference(
            DateTime(
              lastActiveDate.year,
              lastActiveDate.month,
              lastActiveDate.day,
            ),
          )
          .inDays;
      if (daysDiff >= 2) {
        isRecovery = true;
      }
    }

    final steps = _generateWorkoutSteps(day, chosenMinutes);

    return DailyWorkoutPlan(
      day: day,
      chosenMinutes: chosenMinutes,
      isCompleted: isCompleted,
      isRecoveryWorkout: isRecovery,
      scheduledDate: now,
      completedAt: completedAt,
      scoreEarned: scoreEarned,
      steps: steps,
    );
  }

  static List<WorkoutStep> _generateWorkoutSteps(
    CurriculumDay day,
    int minutes,
  ) {
    final steps = <WorkoutStep>[];
    final dayNum = day.dayNumber;

    // Step 1: Warm-up Drill
    final warmupDrillType = day.drillType ?? 'pb_contrast';
    final warmupDrillId = day.drillId ?? 'pb-01-payment';
    final warmupMins = minutes == 10 ? 3 : (minutes == 20 ? 4 : 5);

    steps.add(
      WorkoutStep(
        id: 'step-warmup-$dayNum',
        title: 'Warm-up Drill: ${day.focusSkillTag}',
        titleArabic: 'إحماء صوتي ومهاري',
        description: 'Sharpen vocal delivery, terminology, and phonemic awareness before live customer interaction.',
        type: WorkoutStepType.warmupDrill,
        targetId: warmupDrillId,
        drillType: warmupDrillType,
        estimatedMinutes: warmupMins,
      ),
    );

    // Step 2: Primary Simulated Scenario
    final primaryMins = minutes == 10 ? 7 : (minutes == 20 ? 12 : 15);
    steps.add(
      WorkoutStep(
        id: 'step-primary-$dayNum',
        title: 'Primary Scenario: ${day.themeTitle}',
        titleArabic: day.themeTitleArabic,
        description: 'Execute the core interactive multi-turn scenario adhering to mandatory opening, empathy, and disclosure standards.',
        type: WorkoutStepType.primaryScenario,
        targetId: day.primaryScenarioId,
        estimatedMinutes: primaryMins,
      ),
    );

    // Step 3 for 30 minutes: Challenge Drill
    if (minutes >= 30) {
      String challengeType = 'objection';
      String challengeId = 'obj-01-not-interested';

      if (day.phase == CurriculumPhaseType.phase1Foundations) {
        if (warmupDrillType == 'pb_contrast') {
          challengeType = 'fast_numbers';
          challengeId = 'num-01-acct';
        } else {
          challengeType = 'pb_contrast';
          challengeId = 'pb-01-payment';
        }
      } else if (day.phase == CurriculumPhaseType.phase2SalesConfidence) {
        challengeType = 'objection';
        challengeId = 'obj-02-too-expensive';
      } else {
        challengeType = 'discovery';
        challengeId = 'disc-04-budget-comfort';
      }

      steps.add(
        WorkoutStep(
          id: 'step-challenge-$dayNum',
          title: 'Challenge Drill: Cross-Skill Agility',
          titleArabic: 'تدريب التحدي المتقدم',
          description: 'Reinforce handling of unexpected customer pushback and friction under pressure.',
          type: WorkoutStepType.challengeDrill,
          targetId: challengeId,
          drillType: challengeType,
          estimatedMinutes: 6,
        ),
      );
    }

    // Step 3 (20 min) or Step 4 (30 min): Coaching Review
    if (minutes >= 20) {
      steps.add(
        WorkoutStep(
          id: 'step-review-$dayNum',
          title: 'Pedagogical Review & Scorecard',
          titleArabic: 'مراجعة الملاحظات التدريبية',
          description: 'Analyze your turn-by-turn performance, Egyptian Arabic coaching notes, and compliance metrics.',
          type: WorkoutStepType.coachingReview,
          targetId: day.primaryScenarioId,
          estimatedMinutes: 4,
        ),
      );
    }

    return steps;
  }

  /// Calculates high-level progress statistics across the 90-day curriculum.
  static CurriculumProgressSummary calculateProgress({
    required List<int> completedDays,
    required int currentDay,
  }) {
    final validCurrentDay = currentDay.clamp(1, 90);
    final dayObj =
        CurriculumDataSource.getDay(validCurrentDay) ??
        CurriculumDataSource.allDays.first;
    final week = dayObj.weekNumber;
    final milestone = CurriculumDataSource.getMilestoneForWeek(week);

    final completedCount = completedDays
        .toSet()
        .where((d) => d >= 1 && d <= 90)
        .length;
    final percentage = (completedCount / 90.0).clamp(0.0, 1.0);

    return CurriculumProgressSummary(
      currentDay: validCurrentDay,
      completedDaysCount: completedCount,
      completionPercentage: percentage,
      currentPhase: dayObj.phase,
      currentWeek: week,
      currentMilestone: milestone,
      isCompleted: completedCount >= 90,
    );
  }

  /// Returns the next sequential uncompleted curriculum day (1..90).
  static int getNextUncompletedDay({
    required List<int> completedDays,
    int currentDay = 1,
  }) {
    final completedSet = completedDays.toSet();
    for (int d = currentDay; d <= 90; d++) {
      if (!completedSet.contains(d)) return d;
    }
    // If all subsequent days are completed, search from Day 1
    for (int d = 1; d <= 90; d++) {
      if (!completedSet.contains(d)) return d;
    }
    return 90;
  }
}
