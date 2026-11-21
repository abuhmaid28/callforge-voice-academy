import '../../data/models/user_progress.dart';

abstract class IProgressRepository {
  Future<UserProgress> loadProgress();
  Future<void> recordSimulationCompletion({
    required String scenarioId,
    required List<String> skillTags,
    required double score,
  });
  Future<void> recordDisclosureCompletion({
    required String scriptId,
    required double score,
  });
  Future<void> recordDrillCompletion({
    required String drillType,
    required double score,
  });
  Future<void> resetAllProgress();
}
