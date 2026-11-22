import 'package:callforge/core/audio/mock_speech_service.dart';
import 'package:callforge/data/datasources/attempt_local_datasource.dart';
import 'package:callforge/data/datasources/curriculum_datasource.dart';
import 'package:callforge/data/datasources/progress_local_datasource.dart';
import 'package:callforge/data/datasources/sales_scenario_catalog.dart';
import 'package:callforge/data/datasources/scenario_catalog.dart';
import 'package:callforge/data/repositories/attempt_repository_impl.dart';
import 'package:callforge/data/repositories/progress_repository_impl.dart';
import 'package:callforge/presentation/controllers/sales_simulator_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('C2-R1 Independent Audit Failure Reproductions', () {
    test('Verification B1: CurriculumDataSource resolves 100% of scenario IDs without missing references', () {
      final missingPrimaryScenarioIds = <String>[];

      for (final day in CurriculumDataSource.allDays) {
        final careScenario = ScenarioCatalog.findById(day.primaryScenarioId);
        final salesScenario = SalesScenarioCatalog.findById(
          day.primaryScenarioId,
        );

        if (careScenario == null && salesScenario == null) {
          missingPrimaryScenarioIds.add(
            'Day ${day.dayNumber}: ${day.primaryScenarioId}',
          );
        }
      }

      // Verifies that all 90 curriculum day IDs resolve successfully
      expect(missingPrimaryScenarioIds, isEmpty);
    });

    test('Verification B2: SalesSimulatorController rejects substring false-positive "matter" and accepts canonical greeting', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final mockSpeech = MockSpeechService();
      final attemptRepo = AttemptRepositoryImpl(AttemptLocalDataSource(prefs));
      final progressRepo = ProgressRepositoryImpl(
        ProgressLocalDataSource(prefs),
      );

      final controller = SalesSimulatorController(
        speechService: mockSpeech,
        progressRepository: progressRepo,
        attemptRepository: attemptRepo,
      );

      final scenario = SalesScenarioCatalog.allScenarios.first;
      controller.startScenario(scenario);

      // 1. Speak substring 'matter'/'battery' — must fail Turn 1 greeting gate
      mockSpeech.simulatedTranscript =
          'What is the matter with the battery alex?';
      await controller.startListening();
      await controller.stopListening();

      expect(controller.currentTurn?.turnNumber, equals(1));
      expect(
        controller.errorMessage,
        contains('Mandatory Greeting Incomplete'),
      );
      expect(controller.state, equals(SalesSimulatorState.idle));

      // 2. Speak canonical greeting — must pass Turn 1 gate and advance
      mockSpeech.simulatedTranscript = 'Hello, thank you for calling AT&T. This is Alex. May I have your first and last name, please?';
      await controller.startListening();
      await controller.stopListening();

      expect(controller.currentTurn?.turnNumber, greaterThan(1));
    });

    test('Verification B6: Concurrent unawaited progress writes are serialized without lost updates', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final progressRepo = ProgressRepositoryImpl(
        ProgressLocalDataSource(prefs),
      );

      // Trigger both writes concurrently without awaiting the first one
      final future1 = progressRepo.recordSalesSimulationCompletion(
        scenarioId: 'sales-01-starter-to-extra',
        skillTags: ['Plan-Fit'],
        score: 85.0,
        isNoSaleSuccess: false,
      );

      final future2 = progressRepo.recordCurriculumDayCompletion(
        dayNumber: 1,
        score: 85.0,
      );

      await Future.wait([future1, future2]);

      final progress = await progressRepo.loadProgress();

      // In the synchronized implementation, both updates are reliably preserved
      expect(progress.totalSalesScenariosCompleted, equals(1));
      expect(
        progress.completedSalesScenarioIds,
        contains('sales-01-starter-to-extra'),
      );
      expect(progress.completedCurriculumDays, contains(1));
      expect(progress.currentCurriculumDay, equals(2));

      // Also verify that a failed curriculum day attempt (< 70) is NOT awarded
      await progressRepo.recordCurriculumDayCompletion(
        dayNumber: 2,
        score: 55.0,
      );

      final progressAfterFail = await progressRepo.loadProgress();
      expect(progressAfterFail.completedCurriculumDays, isNot(contains(2)));
      expect(
        progressAfterFail.currentCurriculumDay,
        equals(2),
      ); // Did not advance
    });
  });
}
