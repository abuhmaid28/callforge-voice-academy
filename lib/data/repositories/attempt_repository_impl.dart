import '../../domain/repositories/attempt_repository.dart';
import '../datasources/attempt_local_datasource.dart';
import '../models/attempt_record.dart';

class AttemptRepositoryImpl implements IAttemptRepository {
  final AttemptLocalDataSource _dataSource;

  AttemptRepositoryImpl(this._dataSource);

  @override
  Future<void> saveAttempt(AttemptRecord record) async {
    await _dataSource.saveAttempt(record);
  }

  @override
  Future<List<AttemptRecord>> getAttempts({String? scenarioId}) async {
    return _dataSource.getAttempts(scenarioId: scenarioId);
  }

  @override
  Future<int?> getBestAccuracy(String scenarioId) async {
    return _dataSource.getBestAccuracy(scenarioId);
  }

  @override
  Future<void> clearAllAttempts() async {
    await _dataSource.clearAll();
  }
}
