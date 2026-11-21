import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:callforge/data/datasources/attempt_local_datasource.dart';
import 'package:callforge/data/models/attempt_record.dart';
import 'package:callforge/data/repositories/attempt_repository_impl.dart';

void main() {
  late SharedPreferences prefs;
  late AttemptLocalDataSource dataSource;
  late AttemptRepositoryImpl repository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    dataSource = AttemptLocalDataSource(prefs);
    repository = AttemptRepositoryImpl(dataSource);
  });

  group('AttemptRepositoryImpl & LocalDataSource', () {
    test('initially returns empty attempt history', () async {
      final attempts = await repository.getAttempts();
      expect(attempts, isEmpty);
      final best = await repository.getBestAccuracy('m1_scenario');
      expect(best, isNull);
    });

    test('saves and retrieves attempts ordered by newest first', () async {
      final record1 = AttemptRecord(
        id: '1',
        scenarioId: 'm1_scenario',
        timestamp: DateTime(2026, 11, 16, 10, 0),
        transcript: 'Attempt 1',
        accuracyPercentage: 75,
        passed: true,
        wpm: 120,
        missingAnchors: [],
        pbErrors: [],
        arabicCoaching: 'Good',
      );

      final record2 = AttemptRecord(
        id: '2',
        scenarioId: 'm1_scenario',
        timestamp: DateTime(2026, 11, 16, 10, 15),
        transcript: 'Attempt 2',
        accuracyPercentage: 92,
        passed: true,
        wpm: 135,
        missingAnchors: [],
        pbErrors: [],
        arabicCoaching: 'Excellent',
      );

      await repository.saveAttempt(record1);
      await repository.saveAttempt(record2);

      final retrieved = await repository.getAttempts(scenarioId: 'm1_scenario');
      expect(retrieved.length, equals(2));
      expect(retrieved[0].id, equals('2')); // Newest first
      expect(retrieved[1].id, equals('1'));

      final best = await repository.getBestAccuracy('m1_scenario');
      expect(best, equals(92));
    });

    test('clearAllAttempts wipes local storage', () async {
      final record = AttemptRecord(
        id: '1',
        scenarioId: 'm1_scenario',
        timestamp: DateTime.now(),
        transcript: 'Test',
        accuracyPercentage: 80,
        passed: true,
        wpm: 120,
        missingAnchors: [],
        pbErrors: [],
        arabicCoaching: 'Test',
      );

      await repository.saveAttempt(record);
      expect((await repository.getAttempts()).length, equals(1));

      await repository.clearAllAttempts();
      expect((await repository.getAttempts()).length, equals(0));
    });
  });
}
