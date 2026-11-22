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
    final newStreak = calculateNewStreak(
      currentStreak: current.streakDays,
      lastPracticeDateStr: current.lastPracticeDate,
    );

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
    final newStreak = calculateNewStreak(
      currentStreak: current.streakDays,
      lastPracticeDateStr: current.lastPracticeDate,
    );

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
    final newStreak = calculateNewStreak(
      currentStreak: current.streakDays,
      lastPracticeDateStr: current.lastPracticeDate,
    );

    final updated = current.copyWith(
      streakDays: newStreak,
      lastPracticeDate: today,
      totalDrillsCompleted: current.totalDrillsCompleted + 1,
      skillMastery: updatedMastery,
    );

    await _dataSource.saveProgress(updated);
  }

  @override
  Future<void> recordSalesSimulationCompletion({
    required String scenarioId,
    required List<String> skillTags,
    required double score,
    required bool isNoSaleSuccess,
  }) async {
    final current = await _dataSource.getProgress();
    final updatedSales = List<String>.from(current.completedSalesScenarioIds);
    if (!updatedSales.contains(scenarioId)) {
      updatedSales.add(scenarioId);
    }

    final updatedMastery = Map<String, double>.from(current.skillMastery);
    final normalizedScore = (score / 100.0).clamp(0.0, 1.0);
    for (final tag in skillTags) {
      final prev = updatedMastery[tag] ?? 0.5;
      updatedMastery[tag] = ((prev * 0.7) + (normalizedScore * 0.3)).clamp(
        0.0,
        1.0,
      );
    }
    // Boost consultative sales mastery tag
    const salesTag = 'Sales Mastery';
    final prevSales = updatedMastery[salesTag] ?? 0.5;
    updatedMastery[salesTag] = ((prevSales * 0.7) + (normalizedScore * 0.3))
        .clamp(0.0, 1.0);

    final today = _getTodayDateString();
    final newStreak = calculateNewStreak(
      currentStreak: current.streakDays,
      lastPracticeDateStr: current.lastPracticeDate,
    );

    final updated = current.copyWith(
      streakDays: newStreak,
      lastPracticeDate: today,
      totalSalesScenariosCompleted: current.totalSalesScenariosCompleted + 1,
      skillMastery: updatedMastery,
      completedSalesScenarioIds: updatedSales,
    );

    await _dataSource.saveProgress(updated);
  }

  @override
  Future<void> recordCurriculumDayCompletion({
    required int dayNumber,
    required double score,
  }) async {
    final current = await _dataSource.getProgress();
    final updatedDays = List<int>.from(current.completedCurriculumDays);
    if (!updatedDays.contains(dayNumber)) {
      updatedDays.add(dayNumber);
      updatedDays.sort();
    }

    final nextDay = (dayNumber < 90) ? dayNumber + 1 : 90;
    final today = _getTodayDateString();
    final newStreak = calculateNewStreak(
      currentStreak: current.streakDays,
      lastPracticeDateStr: current.lastPracticeDate,
    );

    final updated = current.copyWith(
      streakDays: newStreak,
      lastPracticeDate: today,
      currentCurriculumDay: nextDay,
      completedCurriculumDays: updatedDays,
    );

    await _dataSource.saveProgress(updated);
  }

  @override
  Future<void> updateLearningPreferences({
    int? targetDailyMinutes,
    double? preferredSpeechSpeed,
    String? primaryLearningGoal,
  }) async {
    final current = await _dataSource.getProgress();
    final updated = current.copyWith(
      targetDailyMinutes: targetDailyMinutes,
      preferredSpeechSpeed: preferredSpeechSpeed,
      primaryLearningGoal: primaryLearningGoal,
    );
    await _dataSource.saveProgress(updated);
  }

  @override
  Future<void> resetAllProgress() async {
    await _dataSource.clearProgress();
  }

  /// Calculates the new practice streak enforcing strictly consecutive calendar days.
  static int calculateNewStreak({
    required int currentStreak,
    required String? lastPracticeDateStr,
    DateTime? todayDate,
  }) {
    final now = todayDate ?? DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (lastPracticeDateStr == null || lastPracticeDateStr.isEmpty) {
      return 1;
    }

    try {
      final parts = lastPracticeDateStr.split('-');
      if (parts.length != 3) return 1;
      final last = DateTime(
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
      );

      final diffDays = today.difference(last).inDays;

      if (diffDays == 0) {
        // Practiced today already; maintain streak
        return currentStreak == 0 ? 1 : currentStreak;
      } else if (diffDays == 1) {
        // Consecutive calendar day
        return currentStreak + 1;
      } else {
        // Skipped one or more days (diffDays >= 2) or time shifted backwards
        return 1;
      }
    } catch (_) {
      return 1;
    }
  }

  static String _getTodayDateString([DateTime? date]) {
    final now = date ?? DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }
}
