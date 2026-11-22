import 'package:flutter/foundation.dart';

import '../../core/curriculum/curriculum_engine.dart';
import '../../data/models/user_progress.dart';
import '../../domain/entities/adaptive_curriculum.dart';
import '../../domain/repositories/progress_repository.dart';

class CurriculumController extends ChangeNotifier {
  final IProgressRepository progressRepository;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  UserProgress? _userProgress;
  UserProgress? get userProgress => _userProgress;

  CurriculumProgressSummary? _progressSummary;
  CurriculumProgressSummary? get progressSummary => _progressSummary;

  DailyWorkoutPlan? _activeWorkout;
  DailyWorkoutPlan? get activeWorkout => _activeWorkout;

  int _selectedDuration = 20; // 10, 20, or 30 minutes
  int get selectedDuration => _selectedDuration;

  bool _isDisposed = false;

  CurriculumController({required this.progressRepository});

  @override
  void notifyListeners() {
    if (!_isDisposed) {
      super.notifyListeners();
    }
  }

  Future<void> loadCurriculum() async {
    _isLoading = true;
    notifyListeners();

    try {
      final progress = await progressRepository.loadProgress();
      _userProgress = progress;
      _selectedDuration = progress.targetDailyMinutes;

      _progressSummary = CurriculumEngine.calculateProgress(
        completedDays: progress.completedCurriculumDays,
        currentDay: progress.currentCurriculumDay,
      );

      final isTodayCompleted = progress.completedCurriculumDays.contains(
        progress.currentCurriculumDay,
      );

      final lastDate = progress.lastPracticeDate.isNotEmpty
          ? DateTime.tryParse(progress.lastPracticeDate)
          : null;

      _activeWorkout = CurriculumEngine.generateDailyWorkout(
        dayNumber: progress.currentCurriculumDay,
        chosenMinutes: _selectedDuration,
        currentDate: DateTime.now(),
        lastActiveDate: lastDate,
        isCompleted: isTodayCompleted,
      );
    } catch (_) {}

    _isLoading = false;
    notifyListeners();
  }

  Future<void> setDuration(int minutes) async {
    if (minutes != 10 && minutes != 20 && minutes != 30) return;
    _selectedDuration = minutes;

    if (_activeWorkout != null) {
      _activeWorkout = _activeWorkout!.copyWith(chosenMinutes: minutes);
    }

    try {
      await progressRepository.updateLearningPreferences(
        targetDailyMinutes: minutes,
      );
    } catch (_) {}

    notifyListeners();
  }

  Future<void> completeActiveWorkout({required double scoreEarned}) async {
    if (_activeWorkout == null) return;

    final dayNumber = _activeWorkout!.day.dayNumber;
    await progressRepository.recordCurriculumDayCompletion(
      dayNumber: dayNumber,
      score: scoreEarned,
    );

    // Refresh curriculum state
    await loadCurriculum();
  }

  Future<void> advanceToNextDay() async {
    if (_userProgress == null) return;

    final nextDay = CurriculumEngine.getNextUncompletedDay(
      completedDays: _userProgress!.completedCurriculumDays,
      currentDay: _userProgress!.currentCurriculumDay + 1,
    );

    final lastDate = _userProgress!.lastPracticeDate.isNotEmpty
        ? DateTime.tryParse(_userProgress!.lastPracticeDate)
        : null;

    _activeWorkout = CurriculumEngine.generateDailyWorkout(
      dayNumber: nextDay,
      chosenMinutes: _selectedDuration,
      currentDate: DateTime.now(),
      lastActiveDate: lastDate,
      isCompleted: _userProgress!.completedCurriculumDays.contains(nextDay),
    );

    _progressSummary = CurriculumEngine.calculateProgress(
      completedDays: _userProgress!.completedCurriculumDays,
      currentDay: nextDay,
    );

    notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
