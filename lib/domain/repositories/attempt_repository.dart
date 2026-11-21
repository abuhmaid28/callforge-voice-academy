import '../../data/models/attempt_record.dart';

abstract class IAttemptRepository {
  Future<void> saveAttempt(AttemptRecord record);
  Future<List<AttemptRecord>> getAttempts({String? scenarioId});
  Future<int?> getBestAccuracy(String scenarioId);
  Future<void> clearAllAttempts();
}
