import 'package:flutter/foundation.dart';

import '../../data/datasources/workout_session_local_datasource.dart';
import '../../domain/entities/adaptive_curriculum.dart';
import '../../domain/entities/workout_session.dart';
import '../../domain/repositories/attempt_repository.dart';
import '../../domain/repositories/progress_repository.dart';

class WorkoutSessionController extends ChangeNotifier {
  final IProgressRepository? progressRepository;
  final IAttemptRepository? attemptRepository;
  final WorkoutSessionLocalDataSource? sessionDataSource;

  WorkoutSessionState? _session;
  WorkoutSessionState? get session => _session;
  bool get hasActiveSession =>
      _session != null && !_session!.isSessionCompleted;

  WorkoutSessionController({
    this.progressRepository,
    this.attemptRepository,
    this.sessionDataSource,
  });

  Future<void> initializeFromStorage() async {
    if (sessionDataSource != null) {
      final saved = await sessionDataSource!.getSession();
      if (saved != null && !saved.isSessionCompleted) {
        _session = saved;
        notifyListeners();
      }
    }
  }

  Future<void> _saveSessionToStorage() async {
    if (sessionDataSource != null && _session != null) {
      await sessionDataSource!.saveSession(_session!);
    }
  }

  Future<void> startOrResumeSession(DailyWorkoutPlan workout) async {
    if (_session != null &&
        _session!.workout.day.dayNumber == workout.day.dayNumber &&
        !_session!.isSessionCompleted) {
      // Resume existing in-progress session
      notifyListeners();
      return;
    }
    _session = WorkoutSessionState(workout: workout);
    await _saveSessionToStorage();
    notifyListeners();
  }

  Future<void> setCurrentStep(int index) async {
    if (_session == null) return;
    if (index >= 0 && index < _session!.workout.steps.length) {
      final updatedStatuses = Map<int, WorkoutStepStatus>.from(
        _session!.stepStatuses,
      );
      if (updatedStatuses[index] == WorkoutStepStatus.pending) {
        updatedStatuses[index] = WorkoutStepStatus.inProgress;
      }
      _session = _session!.copyWith(
        currentStepIndex: index,
        stepStatuses: updatedStatuses,
      );
      await _saveSessionToStorage();
      notifyListeners();
    }
  }

  Future<void> recordStepResult({
    required int stepIndex,
    required WorkoutStepResult result,
  }) async {
    if (_session == null) return;
    final updatedStatuses = Map<int, WorkoutStepStatus>.from(
      _session!.stepStatuses,
    );
    final updatedResults = Map<int, WorkoutStepResult>.from(
      _session!.stepResults,
    );

    updatedStatuses[stepIndex] = result.passed
        ? WorkoutStepStatus.completed
        : WorkoutStepStatus.inProgress;
    updatedResults[stepIndex] = result;

    // Determine next step index
    int nextIndex = stepIndex + 1;
    bool allDone = true;
    for (int i = 0; i < _session!.workout.steps.length; i++) {
      if (updatedStatuses[i] != WorkoutStepStatus.completed &&
          updatedStatuses[i] != WorkoutStepStatus.skipped) {
        allDone = false;
        break;
      }
    }

    if (nextIndex < _session!.workout.steps.length) {
      if (updatedStatuses[nextIndex] == WorkoutStepStatus.pending) {
        updatedStatuses[nextIndex] = WorkoutStepStatus.inProgress;
      }
    } else {
      nextIndex = _session!.workout.steps.length - 1;
    }

    _session = _session!.copyWith(
      currentStepIndex: nextIndex,
      stepStatuses: updatedStatuses,
      stepResults: updatedResults,
      isSessionCompleted: allDone && _session!.canCompleteWorkout,
      completedAt: (allDone && _session!.canCompleteWorkout)
          ? DateTime.now()
          : null,
    );
    await _saveSessionToStorage();
    notifyListeners();
  }

  Future<void> skipStep(int stepIndex) async {
    if (_session == null) return;
    final updatedStatuses = Map<int, WorkoutStepStatus>.from(
      _session!.stepStatuses,
    );
    updatedStatuses[stepIndex] = WorkoutStepStatus.skipped;

    int nextIndex = (stepIndex + 1).clamp(
      0,
      _session!.workout.steps.length - 1,
    );
    if (updatedStatuses[nextIndex] == WorkoutStepStatus.pending) {
      updatedStatuses[nextIndex] = WorkoutStepStatus.inProgress;
    }

    _session = _session!.copyWith(
      currentStepIndex: nextIndex,
      stepStatuses: updatedStatuses,
    );
    await _saveSessionToStorage();
    notifyListeners();
  }

  /// Attempts to complete the entire workout session.
  /// Strictly requires verified evidence:
  /// - Mandatory primary scenario must be attempted and PASSED.
  /// - Other exercise steps must be completed or skipped (no pending).
  /// - At least one exercise completed.
  /// Returns `true` if certified as completed, `false` otherwise.
  Future<bool> completeEntireWorkout() async {
    if (_session == null || !_session!.canCompleteWorkout) {
      return false;
    }

    final updatedStatuses = Map<int, WorkoutStepStatus>.from(
      _session!.stepStatuses,
    );
    for (int i = 0; i < _session!.workout.steps.length; i++) {
      if (_session!.workout.steps[i].type == WorkoutStepType.coachingReview) {
        updatedStatuses[i] = WorkoutStepStatus.completed;
      }
    }

    final now = DateTime.now();
    _session = _session!.copyWith(
      isSessionCompleted: true,
      completedAt: now,
      stepStatuses: updatedStatuses,
    );
    await _saveSessionToStorage();

    if (progressRepository != null) {
      final earnedScore = _session!.primaryScenarioResult?.score ?? 80.0;
      await progressRepository!.recordCurriculumDayCompletion(
        dayNumber: _session!.workout.day.dayNumber,
        score: earnedScore,
      );
    }
    notifyListeners();
    return true;
  }

  Future<void> resetSession() async {
    _session = null;
    if (sessionDataSource != null) {
      await sessionDataSource!.clearSession();
    }
    notifyListeners();
  }
}
