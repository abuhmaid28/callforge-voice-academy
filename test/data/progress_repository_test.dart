import 'package:callforge/data/datasources/progress_local_datasource.dart';
import 'package:callforge/data/repositories/progress_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('ProgressRepositoryImpl Tests', () {
    late ProgressLocalDataSource dataSource;
    late ProgressRepositoryImpl repository;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      dataSource = ProgressLocalDataSource(prefs);
      repository = ProgressRepositoryImpl(dataSource);
    });

    test('initially returns empty user progress', () async {
      final progress = await repository.loadProgress();
      expect(progress.streakDays, equals(0));
      expect(progress.totalSimulationsCompleted, equals(0));
      expect(progress.totalDisclosuresCompleted, equals(0));
      expect(progress.totalDrillsCompleted, equals(0));
      expect(progress.skillMastery, isEmpty);
      expect(progress.weakestSkillTag, equals('AERD'));
    });

    test(
      'records simulation completion and updates skill mastery and streak',
      () async {
        await repository.recordSimulationCompletion(
          scenarioId: 'scen-01-first-bill',
          skillTags: ['Proration', 'AERD'],
          score: 85.0,
        );

        final progress = await repository.loadProgress();
        expect(progress.totalSimulationsCompleted, equals(1));
        expect(progress.completedScenarioIds, contains('scen-01-first-bill'));
        expect(progress.streakDays, equals(1));
        expect(progress.skillMastery.containsKey('Proration'), isTrue);
        expect(progress.skillMastery.containsKey('AERD'), isTrue);
        expect(progress.skillMastery['Proration']!, greaterThan(0.5));
      },
    );

    test(
      'records disclosure completion and increments count and mastery',
      () async {
        await repository.recordDisclosureCompletion(
          scriptId: 'disc-autopay-01',
          score: 100.0,
        );

        final progress = await repository.loadProgress();
        expect(progress.totalDisclosuresCompleted, equals(1));
        expect(progress.completedDisclosureIds, contains('disc-autopay-01'));
        expect(progress.skillMastery.containsKey('Disclosures'), isTrue);
      },
    );

    test('records drill completion for P/B and fast numbers', () async {
      await repository.recordDrillCompletion(
        drillType: 'pb_contrast',
        score: 100.0,
      );
      await repository.recordDrillCompletion(
        drillType: 'fast_numbers',
        score: 90.0,
      );

      final progress = await repository.loadProgress();
      expect(progress.totalDrillsCompleted, equals(2));
      expect(progress.skillMastery.containsKey('P/B Phonetics'), isTrue);
      expect(progress.skillMastery.containsKey('Fast Numbers'), isTrue);
    });

    test('resetAllProgress wipes data back to empty state', () async {
      await repository.recordSimulationCompletion(
        scenarioId: 'scen-01-first-bill',
        skillTags: ['AERD'],
        score: 90.0,
      );

      await repository.resetAllProgress();
      final resetProg = await repository.loadProgress();
      expect(resetProg.totalSimulationsCompleted, equals(0));
      expect(resetProg.completedScenarioIds, isEmpty);
    });

    group('Consecutive Calendar-Day Streak Logic (calculateNewStreak)', () {
      test('initial practice sets streak to 1', () {
        expect(
          ProgressRepositoryImpl.calculateNewStreak(
            currentStreak: 0,
            lastPracticeDateStr: null,
            todayDate: DateTime(2026, 4, 15),
          ),
          equals(1),
        );
      });

      test('same calendar day maintains current streak', () {
        expect(
          ProgressRepositoryImpl.calculateNewStreak(
            currentStreak: 5,
            lastPracticeDateStr: '2026-04-15',
            todayDate: DateTime(2026, 4, 15, 18, 30),
          ),
          equals(5),
        );
      });

      test('consecutive calendar day increments streak by 1', () {
        expect(
          ProgressRepositoryImpl.calculateNewStreak(
            currentStreak: 5,
            lastPracticeDateStr: '2026-04-15',
            todayDate: DateTime(2026, 4, 16, 9, 0),
          ),
          equals(6),
        );
      });

      test('gap of 2 or more days resets streak to 1', () {
        expect(
          ProgressRepositoryImpl.calculateNewStreak(
            currentStreak: 12,
            lastPracticeDateStr: '2026-04-15',
            todayDate: DateTime(2026, 4, 18, 10, 0),
          ),
          equals(1),
        );
      });

      test('month and leap-year boundaries calculate correctly', () {
        // Month transition: March 31 to April 1
        expect(
          ProgressRepositoryImpl.calculateNewStreak(
            currentStreak: 3,
            lastPracticeDateStr: '2026-03-31',
            todayDate: DateTime(2026, 4, 1),
          ),
          equals(4),
        );

        // Year transition: Dec 31 to Jan 1
        expect(
          ProgressRepositoryImpl.calculateNewStreak(
            currentStreak: 10,
            lastPracticeDateStr: '2026-12-31',
            todayDate: DateTime(2027, 1, 1),
          ),
          equals(11),
        );
      });
    });
  });
}
