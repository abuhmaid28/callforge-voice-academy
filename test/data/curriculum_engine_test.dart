import 'package:flutter_test/flutter_test.dart';
import 'package:callforge/core/curriculum/curriculum_engine.dart';
import 'package:callforge/data/datasources/curriculum_datasource.dart';
import 'package:callforge/domain/entities/adaptive_curriculum.dart';

void main() {
  group('CurriculumDataSource Tests', () {
    test('contains exactly 90 days', () {
      expect(CurriculumDataSource.allDays.length, equals(90));
    });

    test('phases are correctly assigned to 30-day blocks', () {
      for (int i = 1; i <= 30; i++) {
        final day = CurriculumDataSource.getDay(i);
        expect(day?.phase, equals(CurriculumPhaseType.phase1Foundations));
      }

      for (int i = 31; i <= 60; i++) {
        final day = CurriculumDataSource.getDay(i);
        expect(day?.phase, equals(CurriculumPhaseType.phase2SalesConfidence));
      }

      for (int i = 61; i <= 90; i++) {
        final day = CurriculumDataSource.getDay(i);
        expect(day?.phase, equals(CurriculumPhaseType.phase3AdvancedClosing));
      }
    });

    test('13 weekly milestones are defined across the program', () {
      expect(CurriculumDataSource.weeklyMilestones.length, equals(13));
      for (int w = 1; w <= 13; w++) {
        final milestone = CurriculumDataSource.getMilestoneForWeek(w);
        expect(milestone, isNotNull);
        expect(milestone?.weekNumber, equals(w));
        expect(milestone?.title.isNotEmpty, isTrue);
        expect(milestone?.titleArabic.isNotEmpty, isTrue);
      }
    });

    test('100% of all 90 curriculum days resolve to existing scenarios and drills', () {
      for (final day in CurriculumDataSource.allDays) {
        expect(
          CurriculumDataSource.scenarioExists(day.primaryScenarioId),
          isTrue,
          reason:
              'Day ${day.dayNumber}: Scenario ${day.primaryScenarioId} must exist',
        );

        if (day.drillType != null && day.drillId != null) {
          expect(
            CurriculumDataSource.drillExists(day.drillType!, day.drillId!),
            isTrue,
            reason:
                'Day ${day.dayNumber}: Drill (${day.drillType}, ${day.drillId}) must exist',
          );
        }
      }
    });
  });

  group('CurriculumEngine Workout & Recovery Tests', () {
    test('generates multi-step workout queues for 10, 20, and 30 minutes', () {
      final workout10 = CurriculumEngine.generateDailyWorkout(
        dayNumber: 5,
        chosenMinutes: 10,
      );
      expect(workout10.chosenMinutes, equals(10));
      expect(workout10.day.dayNumber, equals(5));
      expect(workout10.isRecoveryWorkout, isFalse);
      expect(workout10.steps.length, equals(2));
      expect(workout10.steps[0].type, equals(WorkoutStepType.warmupDrill));
      expect(workout10.steps[1].type, equals(WorkoutStepType.primaryScenario));

      final workout20 = CurriculumEngine.generateDailyWorkout(
        dayNumber: 45,
        chosenMinutes: 20,
      );
      expect(workout20.chosenMinutes, equals(20));
      expect(workout20.steps.length, equals(3));
      expect(workout20.steps[0].type, equals(WorkoutStepType.warmupDrill));
      expect(workout20.steps[1].type, equals(WorkoutStepType.primaryScenario));
      expect(workout20.steps[2].type, equals(WorkoutStepType.coachingReview));

      final workout30 = CurriculumEngine.generateDailyWorkout(
        dayNumber: 75,
        chosenMinutes: 30,
      );
      expect(workout30.chosenMinutes, equals(30));
      expect(workout30.steps.length, equals(4));
      expect(workout30.steps[0].type, equals(WorkoutStepType.warmupDrill));
      expect(workout30.steps[1].type, equals(WorkoutStepType.primaryScenario));
      expect(workout30.steps[2].type, equals(WorkoutStepType.challengeDrill));
      expect(workout30.steps[3].type, equals(WorkoutStepType.coachingReview));
    });

    test('triggers recovery mode when 2 or more days are skipped without resetting progress', () {
      final now = DateTime(2026, 11, 25);
      final lastActive = DateTime(2026, 11, 22); // 3 days ago

      final workout = CurriculumEngine.generateDailyWorkout(
        dayNumber: 12,
        currentDate: now,
        lastActiveDate: lastActive,
      );

      expect(workout.isRecoveryWorkout, isTrue);
      expect(workout.day.dayNumber, equals(12));
    });

    test('does not trigger recovery mode when practiced yesterday', () {
      final now = DateTime(2026, 11, 23);
      final lastActive = DateTime(2026, 11, 22); // 1 day ago

      final workout = CurriculumEngine.generateDailyWorkout(
        dayNumber: 13,
        currentDate: now,
        lastActiveDate: lastActive,
      );

      expect(workout.isRecoveryWorkout, isFalse);
    });

    test('calculates accurate progress summary', () {
      final completed = [1, 2, 3, 4, 5, 6, 7]; // 7 days completed
      final summary = CurriculumEngine.calculateProgress(
        completedDays: completed,
        currentDay: 8,
      );

      expect(summary.completedDaysCount, equals(7));
      expect(summary.completionPercentage, closeTo(7 / 90.0, 0.001));
      expect(
        summary.currentPhase,
        equals(CurriculumPhaseType.phase1Foundations),
      );
      expect(summary.currentWeek, equals(2));
      expect(summary.isCompleted, isFalse);
    });

    test('returns next uncompleted day accurately', () {
      final completed = [1, 2, 3];
      final nextDay = CurriculumEngine.getNextUncompletedDay(
        completedDays: completed,
        currentDay: 1,
      );
      expect(nextDay, equals(4));

      final completedWithHoles = [1, 2, 4, 5];
      final nextHole = CurriculumEngine.getNextUncompletedDay(
        completedDays: completedWithHoles,
        currentDay: 1,
      );
      expect(nextHole, equals(3));
    });
  });
}
