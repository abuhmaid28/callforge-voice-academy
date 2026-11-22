import 'package:callforge/core/curriculum/curriculum_engine.dart';
import 'package:callforge/data/datasources/attempt_local_datasource.dart';
import 'package:callforge/data/datasources/progress_local_datasource.dart';
import 'package:callforge/data/repositories/attempt_repository_impl.dart';
import 'package:callforge/data/repositories/progress_repository_impl.dart';
import 'package:callforge/domain/entities/adaptive_curriculum.dart';
import 'package:callforge/domain/entities/workout_session.dart';
import 'package:callforge/presentation/controllers/workout_session_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('WorkoutSessionController & Engine Tests (P0-2)', () {
    late ProgressRepositoryImpl progressRepo;
    late AttemptRepositoryImpl attemptRepo;
    late DailyWorkoutPlan workoutPlan;
    late WorkoutSessionController controller;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      progressRepo = ProgressRepositoryImpl(ProgressLocalDataSource(prefs));
      attemptRepo = AttemptRepositoryImpl(AttemptLocalDataSource(prefs));

      workoutPlan = CurriculumEngine.generateDailyWorkout(
        dayNumber: 1,
        chosenMinutes: 20,
      );

      controller = WorkoutSessionController(
        progressRepository: progressRepo,
        attemptRepository: attemptRepo,
      );
    });

    tearDown(() {
      controller.dispose();
    });

    test('startOrResumeSession initializes 20-min session with 3 steps', () {
      controller.startOrResumeSession(workoutPlan);

      expect(controller.hasActiveSession, isTrue);
      expect(controller.session, isNotNull);
      final session = controller.session!;
      expect(session.workout.steps.length, equals(3));
      expect(session.currentStepIndex, equals(0));
      expect(session.stepStatuses[0], equals(WorkoutStepStatus.inProgress));
      expect(session.stepStatuses[1], equals(WorkoutStepStatus.pending));
      expect(session.stepStatuses[2], equals(WorkoutStepStatus.pending));
      expect(session.completedStepsCount, equals(0));
      expect(session.isSessionCompleted, isFalse);
    });

    test(
      'recordStepResult marks step completed and auto-advances to next step',
      () async {
        controller.startOrResumeSession(workoutPlan);

        final step0 = controller.session!.workout.steps[0];
        await controller.recordStepResult(
          stepIndex: 0,
          result: WorkoutStepResult(
            stepId: step0.id,
            type: step0.type,
            title: step0.title,
            score: 88.0,
            passed: true,
          ),
        );

        final session = controller.session!;
        expect(session.stepStatuses[0], equals(WorkoutStepStatus.completed));
        expect(session.stepStatuses[1], equals(WorkoutStepStatus.inProgress));
        expect(session.currentStepIndex, equals(1));
        expect(session.completedStepsCount, equals(1));
        expect(session.stepResults[0]?.score, equals(88.0));
      },
    );

    test('completes primary scenario with evidence-based scorecard and advances to coaching review', () async {
      controller.startOrResumeSession(workoutPlan);

      // Complete warmup drill
      await controller.recordStepResult(
        stepIndex: 0,
        result: WorkoutStepResult(
          stepId: workoutPlan.steps[0].id,
          type: workoutPlan.steps[0].type,
          title: workoutPlan.steps[0].title,
          score: 90.0,
          passed: true,
        ),
      );

      // Complete primary scenario with realistic coaching feedback
      await controller.recordStepResult(
        stepIndex: 1,
        result: WorkoutStepResult(
          stepId: workoutPlan.steps[1].id,
          type: workoutPlan.steps[1].type,
          title: workoutPlan.steps[1].title,
          score: 84.0,
          passed: true,
          arabicCoaching: 'ممتاز! تم توضيح الفاتورة والاعتذار بأسلوب مهني',
          missingAnchors: ['autopay discount'],
          salesOutcomeType: 'qualifiedAccept',
        ),
      );

      final session = controller.session!;
      expect(session.currentStepIndex, equals(2));
      expect(session.stepStatuses[1], equals(WorkoutStepStatus.completed));
      expect(session.primaryScenarioResult, isNotNull);
      expect(session.primaryScenarioResult?.score, equals(84.0));
      expect(session.primaryScenarioResult?.arabicCoaching, contains('ممتاز!'));
      expect(
        session.primaryScenarioResult?.missingAnchors,
        contains('autopay discount'),
      );
      expect(
        session.primaryScenarioResult?.salesOutcomeType,
        equals('qualifiedAccept'),
      );
    });

    test(
      'completeEntireWorkout marks all steps completed and sets completedAt',
      () async {
        controller.startOrResumeSession(workoutPlan);
        await controller.completeEntireWorkout();

        final session = controller.session!;
        expect(session.isSessionCompleted, isTrue);
        expect(session.completedAt, isNotNull);
        expect(session.completedStepsCount, equals(workoutPlan.steps.length));
      },
    );

    test(
      'startOrResumeSession resumes an in-progress session without data loss',
      () async {
        controller.startOrResumeSession(workoutPlan);
        await controller.recordStepResult(
          stepIndex: 0,
          result: WorkoutStepResult(
            stepId: workoutPlan.steps[0].id,
            type: workoutPlan.steps[0].type,
            title: workoutPlan.steps[0].title,
            score: 95.0,
            passed: true,
          ),
        );

        // Re-invoke startOrResumeSession with the same workout
        controller.startOrResumeSession(workoutPlan);

        final session = controller.session!;
        expect(session.currentStepIndex, equals(1));
        expect(session.completedStepsCount, equals(1));
        expect(session.stepResults[0]?.score, equals(95.0));
      },
    );

    test('skipStep advances currentStepIndex and marks step skipped', () {
      controller.startOrResumeSession(workoutPlan);
      controller.skipStep(0);

      final session = controller.session!;
      expect(session.stepStatuses[0], equals(WorkoutStepStatus.skipped));
      expect(session.currentStepIndex, equals(1));
      expect(session.stepStatuses[1], equals(WorkoutStepStatus.inProgress));
    });
  });
}
