import 'package:callforge/core/audio/mock_speech_service.dart';
import 'package:callforge/core/audio/speech_service.dart';
import 'package:callforge/core/curriculum/curriculum_engine.dart';
import 'package:callforge/core/di/service_locator.dart';
import 'package:callforge/data/datasources/attempt_local_datasource.dart';
import 'package:callforge/data/datasources/progress_local_datasource.dart';
import 'package:callforge/data/repositories/attempt_repository_impl.dart';
import 'package:callforge/data/repositories/progress_repository_impl.dart';
import 'package:callforge/domain/entities/adaptive_curriculum.dart';
import 'package:callforge/domain/entities/workout_session.dart';
import 'package:callforge/domain/repositories/attempt_repository.dart';
import 'package:callforge/domain/repositories/progress_repository.dart';
import 'package:callforge/presentation/controllers/workout_session_controller.dart';
import 'package:callforge/presentation/screens/workout_session_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('WorkoutSessionScreen Widget Tests (P0-2)', () {
    late MockSpeechService mockSpeech;
    late ProgressRepositoryImpl progressRepo;
    late AttemptRepositoryImpl attemptRepo;
    late DailyWorkoutPlan workoutPlan;
    late WorkoutSessionController controller;

    setUp(() async {
      ServiceLocator.reset();
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      mockSpeech = MockSpeechService();
      ServiceLocator.registerSingleton<ISpeechService>(mockSpeech);

      progressRepo = ProgressRepositoryImpl(ProgressLocalDataSource(prefs));
      ServiceLocator.registerSingleton<IProgressRepository>(progressRepo);

      attemptRepo = AttemptRepositoryImpl(AttemptLocalDataSource(prefs));
      ServiceLocator.registerSingleton<IAttemptRepository>(attemptRepo);

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
      ServiceLocator.reset();
    });

    testWidgets('renders workout header, queue and launch button for Step 1', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WorkoutSessionScreen(
            workout: workoutPlan,
            controller: controller,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('DAY 1 WORKOUT SESSION'), findsOneWidget);
      expect(find.textContaining('WORKOUT QUEUE'), findsOneWidget);
      expect(find.byKey(const Key('btn_launch_workout_step')), findsOneWidget);
      expect(find.text('START WARM-UP DRILL'), findsOneWidget);
    });

    testWidgets('renders evidence-based coaching review when on review step', (
      tester,
    ) async {
      controller.startOrResumeSession(workoutPlan);

      // Advance to Step 3: Coaching Review
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

      await controller.recordStepResult(
        stepIndex: 1,
        result: WorkoutStepResult(
          stepId: workoutPlan.steps[1].id,
          type: workoutPlan.steps[1].type,
          title: workoutPlan.steps[1].title,
          score: 82.0,
          passed: true,
          arabicCoaching: 'أداء ممتاز في شرح التكلفة',
          missingAnchors: ['taxes and surcharges apply'],
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: WorkoutSessionScreen(
            workout: workoutPlan,
            controller: controller,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.textContaining('EVIDENCE-BASED COACHING REVIEW'),
        findsOneWidget,
      );
      expect(find.text('Simulation Score: 82%'), findsOneWidget);
      expect(find.text('أداء ممتاز في شرح التكلفة'), findsOneWidget);
      expect(find.text('taxes and surcharges apply'), findsOneWidget);
      expect(
        find.byKey(const Key('btn_complete_workout_session')),
        findsOneWidget,
      );
    });
  });
}
