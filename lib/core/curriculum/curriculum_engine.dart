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

    return DailyWorkoutPlan(
      day: day,
      chosenMinutes: chosenMinutes,
      isCompleted: isCompleted,
      isRecoveryWorkout: isRecovery,
      scheduledDate: now,
      completedAt: completedAt,
      scoreEarned: scoreEarned,
    );
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
