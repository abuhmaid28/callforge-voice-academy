import 'package:callforge/core/curriculum/curriculum_engine.dart';
import 'package:callforge/data/datasources/attempt_local_datasource.dart';
import 'package:callforge/data/datasources/curriculum_datasource.dart';
import 'package:callforge/data/datasources/progress_local_datasource.dart';
import 'package:callforge/data/datasources/sales_scenario_catalog.dart';
import 'package:callforge/data/models/attempt_record.dart';
import 'package:callforge/data/repositories/attempt_repository_impl.dart';
import 'package:callforge/data/repositories/progress_repository_impl.dart';
import 'package:callforge/domain/entities/adaptive_curriculum.dart';
import 'package:callforge/domain/entities/sales_scenario.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('C3-MEGA Comprehensive Acceptance Tests', () {
    late SharedPreferences prefs;
    late ProgressRepositoryImpl progressRepo;
    late AttemptRepositoryImpl attemptRepo;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();

      progressRepo = ProgressRepositoryImpl(ProgressLocalDataSource(prefs));
      attemptRepo = AttemptRepositoryImpl(AttemptLocalDataSource(prefs));
    });

    test('C3 Acceptance: Day 30 to Day 31 transition advances from Care to Sales phase', () async {
      // Simulate completing Days 1 to 29
      for (int i = 1; i <= 29; i++) {
        await progressRepo.recordCurriculumDayCompletion(
          dayNumber: i,
          score: 85.0,
        );
      }

      var progress = await progressRepo.loadProgress();
      expect(progress.currentCurriculumDay, equals(30));
      expect(progress.completedCurriculumDays.length, equals(29));

      // Day 30 is Phase 1 (Care Foundations)
      final day30 = CurriculumDataSource.getDay(30)!;
      expect(day30.phase, equals(CurriculumPhaseType.phase1Foundations));
      expect(day30.primaryScenarioId.startsWith('scen-'), isTrue);

      // Complete Day 30
      await progressRepo.recordCurriculumDayCompletion(
        dayNumber: 30,
        score: 88.0,
      );

      progress = await progressRepo.loadProgress();
      expect(progress.currentCurriculumDay, equals(31));
      expect(progress.completedCurriculumDays, contains(30));

      // Day 31 is Phase 2 (Sales Confidence)
      final day31 = CurriculumDataSource.getDay(31)!;
      expect(day31.phase, equals(CurriculumPhaseType.phase2SalesConfidence));
      expect(day31.primaryScenarioId.startsWith('sales-'), isTrue);

      final summary = CurriculumEngine.calculateProgress(
        completedDays: progress.completedCurriculumDays,
        currentDay: progress.currentCurriculumDay,
      );
      expect(summary.currentDay, equals(31));
      expect(
        summary.currentPhase,
        equals(CurriculumPhaseType.phase2SalesConfidence),
      );
      expect(summary.completedDaysCount, equals(30));
    });

    test('C3 Acceptance: Day 90 completion records 90th day and marks program complete', () async {
      // Simulate completing all 89 days
      for (int i = 1; i <= 89; i++) {
        await progressRepo.recordCurriculumDayCompletion(
          dayNumber: i,
          score: 85.0,
        );
      }

      var progress = await progressRepo.loadProgress();
      expect(progress.currentCurriculumDay, equals(90));

      // Complete Day 90
      await progressRepo.recordCurriculumDayCompletion(
        dayNumber: 90,
        score: 92.0,
      );

      progress = await progressRepo.loadProgress();
      expect(progress.completedCurriculumDays.length, equals(90));
      expect(progress.completedCurriculumDays, contains(90));
      expect(progress.currentCurriculumDay, equals(90));

      final summary = CurriculumEngine.calculateProgress(
        completedDays: progress.completedCurriculumDays,
        currentDay: progress.currentCurriculumDay,
      );
      expect(summary.completedDaysCount, equals(90));
      expect(summary.completionPercentage, equals(1.0));
      expect(summary.isCompleted, isTrue);
    });

    test('C3 Acceptance: 6 Category Representative Sales Scenarios have reachable adaptive graphs', () {
      final sampleIds = [
        'sales-01-starter-to-extra', // Wireless
        'sales-09-fiber-cable-frustrated', // Fiber
        'sales-17-teenager-first-phone', // Add-a-Line
        'sales-25-copper-wire-retire', // Landline
        'sales-33-cracked-screen-tradein', // Trade-in
        'sales-41-bill-shock-plan-audit', // Retention
      ];

      for (final id in sampleIds) {
        final scenario = SalesScenarioCatalog.findById(id);
        expect(
          scenario,
          isNotNull,
          reason: 'Scenario $id must exist in catalog',
        );

        // Assert 3 distinct reachable outcomes
        final outcomes = <SalesOutcomeType>{};
        for (final turn in scenario!.turns) {
          if (turn.isFinal && turn.resultingOutcome != null) {
            outcomes.add(turn.resultingOutcome!);
          }
        }

        expect(
          outcomes.contains(SalesOutcomeType.qualifiedAccept),
          isTrue,
          reason: '$id must have a qualifiedAccept path',
        );
        expect(
          outcomes.contains(SalesOutcomeType.respectfulNoSale),
          isTrue,
          reason: '$id must have a respectfulNoSale path',
        );
        expect(
          outcomes.contains(SalesOutcomeType.needsVerification),
          isTrue,
          reason: '$id must have a needsVerification path',
        );
      }
    });

    test(
      'C3 Acceptance: Progress and Attempt state persists across app restarts',
      () async {
        // 1. Session 1: Record attempts and curriculum progress
        await progressRepo.recordCurriculumDayCompletion(
          dayNumber: 1,
          score: 91.0,
        );
        await progressRepo.recordSimulationCompletion(
          scenarioId: 'scen-01-first-bill',
          skillTags: ['AERD', 'Billing Explanation'],
          score: 91.0,
        );
        await attemptRepo.saveAttempt(
          AttemptRecord(
            id: 'attempt-001',
            scenarioId: 'scen-01-first-bill',
            timestamp: DateTime.now(),
            transcript: 'First bill customer explanation',
            accuracyPercentage: 91,
            passed: true,
            wpm: 135,
            missingAnchors: const [],
            pbErrors: const [],
            arabicCoaching: 'ممتاز، الشرح واضح ودقيق',
            curriculumDay: 1,
          ),
        );

        // 2. Cold Restart: Create brand new repository instances over the same SharedPreferences
        final reloadedProgressRepo = ProgressRepositoryImpl(
          ProgressLocalDataSource(prefs),
        );
        final reloadedAttemptRepo = AttemptRepositoryImpl(
          AttemptLocalDataSource(prefs),
        );
        final reloadedProgress = await reloadedProgressRepo.loadProgress();
        final reloadedAttempts = await reloadedAttemptRepo.getAttempts();

        expect(reloadedProgress.completedCurriculumDays, contains(1));
        expect(reloadedProgress.currentCurriculumDay, equals(2));
        expect(reloadedProgress.totalSimulationsCompleted, equals(1));
        expect(
          reloadedProgress.completedScenarioIds,
          contains('scen-01-first-bill'),
        );
        expect(reloadedProgress.streakDays, greaterThanOrEqualTo(1));

        expect(reloadedAttempts.length, equals(1));
        expect(reloadedAttempts.first.scenarioId, equals('scen-01-first-bill'));
        expect(reloadedAttempts.first.accuracyPercentage, equals(91));
        expect(reloadedAttempts.first.curriculumDay, equals(1));
      },
    );
  });
}
