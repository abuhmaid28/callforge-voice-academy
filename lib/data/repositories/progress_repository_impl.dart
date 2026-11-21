import '../../domain/repositories/progress_repository.dart';
import '../datasources/progress_local_datasource.dart';
import '../models/user_progress.dart';

class ProgressRepositoryImpl implements IProgressRepository {
  final ProgressLocalDataSource _dataSource;

  ProgressRepositoryImpl(this._dataSource);

  @override
  Future<UserProgress> loadProgress() async {
    return _dataSource.getProgress();
  }

  @override
  Future<void> recordSimulationCompletion({
    required String scenarioId,
    required List<String> skillTags,
    required double score,
  }) async {
    final current = await _dataSource.getProgress();
    final updatedScenarios = List<String>.from(current.completedScenarioIds);
    if (!updatedScenarios.contains(scenarioId)) {
      updatedScenarios.add(scenarioId);
    }

    final updatedMastery = Map<String, double>.from(current.skillMastery);
    final normalizedScore = (score / 100.0).clamp(0.0, 1.0);
    for (final tag in skillTags) {
      final prev = updatedMastery[tag] ?? 0.5;
      // Exponential moving average: 70% prior, 30% new
      updatedMastery[tag] = ((prev * 0.7) + (normalizedScore * 0.3)).clamp(
        0.0,
        1.0,
      );
    }

    final today = _getTodayDateString();
    int newStreak = current.streakDays;
    if (current.lastPracticeDate != today) {
      newStreak += 1;
    }

    final updated = current.copyWith(
      streakDays: newStreak,
      lastPracticeDate: today,
      totalSimulationsCompleted: current.totalSimulationsCompleted + 1,
      skillMastery: updatedMastery,
      completedScenarioIds: updatedScenarios,
    );

    await _dataSource.saveProgress(updated);
  }

  @override
  Future<void> recordDisclosureCompletion({
    required String scriptId,
    required double score,
  }) async {
    final current = await _dataSource.getProgress();
    final updatedDisclosures = List<String>.from(
      current.completedDisclosureIds,
    );
    if (!updatedDisclosures.contains(scriptId)) {
      updatedDisclosures.add(scriptId);
    }

    final updatedMastery = Map<String, double>.from(current.skillMastery);
    final normalizedScore = (score / 100.0).clamp(0.0, 1.0);
    const tag = 'Disclosures';
    final prev = updatedMastery[tag] ?? 0.5;
    updatedMastery[tag] = ((prev * 0.7) + (normalizedScore * 0.3)).clamp(
      0.0,
      1.0,
    );

    final today = _getTodayDateString();
    int newStreak = current.streakDays;
    if (current.lastPracticeDate != today) {
      newStreak += 1;
    }

    final updated = current.copyWith(
      streakDays: newStreak,
      lastPracticeDate: today,
      totalDisclosuresCompleted: current.totalDisclosuresCompleted + 1,
      skillMastery: updatedMastery,
      completedDisclosureIds: updatedDisclosures,
    );

    await _dataSource.saveProgress(updated);
  }

  @override
  Future<void> recordDrillCompletion({
    required String drillType,
    required double score,
  }) async {
    final current = await _dataSource.getProgress();
    final updatedMastery = Map<String, double>.from(current.skillMastery);
    final normalizedScore = (score / 100.0).clamp(0.0, 1.0);

    String tag;
    switch (drillType) {
      case 'pb_contrast':
        tag = 'P/B Phonetics';
        break;
      case 'fast_numbers':
        tag = 'Fast Numbers';
        break;
      case 'aerd_drill':
      default:
        tag = 'AERD';
        break;
    }

    final prev = updatedMastery[tag] ?? 0.5;
    updatedMastery[tag] = ((prev * 0.7) + (normalizedScore * 0.3)).clamp(
      0.0,
      1.0,
    );

    final today = _getTodayDateString();
    int newStreak = current.streakDays;
    if (current.lastPracticeDate != today) {
      newStreak += 1;
    }

    final updated = current.copyWith(
      streakDays: newStreak,
      lastPracticeDate: today,
      totalDrillsCompleted: current.totalDrillsCompleted + 1,
      skillMastery: updatedMastery,
    );

    await _dataSource.saveProgress(updated);
  }

  @override
  Future<void> resetAllProgress() async {
    await _dataSource.clearProgress();
  }

  static String _getTodayDateString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }
}
