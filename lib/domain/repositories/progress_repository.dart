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
  Future<void> recordSalesSimulationCompletion({
    required String scenarioId,
    required List<String> skillTags,
    required double score,
    required bool isNoSaleSuccess,
  });
  Future<void> recordCurriculumDayCompletion({
    required int dayNumber,
    required double score,
  });
  Future<void> updateLearningPreferences({
    int? targetDailyMinutes,
    double? preferredSpeechSpeed,
    String? primaryLearningGoal,
  });
  Future<void> resetAllProgress();
}
