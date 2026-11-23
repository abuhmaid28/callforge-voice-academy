import 'package:flutter/foundation.dart';

import '../../domain/entities/adaptive_curriculum.dart';
import '../../domain/entities/workout_session.dart';
import '../../domain/repositories/attempt_repository.dart';
import '../../domain/repositories/progress_repository.dart';

class WorkoutSessionController extends ChangeNotifier {
  final IProgressRepository? progressRepository;
  final IAttemptRepository? attemptRepository;

  WorkoutSessionState? _session;
  WorkoutSessionState? get session => _session;
  bool get hasActiveSession =>
      _session != null && !_session!.isSessionCompleted;

  WorkoutSessionController({this.progressRepository, this.attemptRepository});

  void startOrResumeSession(DailyWorkoutPlan workout) {
    if (_session != null &&
        _session!.workout.day.dayNumber == workout.day.dayNumber &&
        !_session!.isSessionCompleted) {
      // Resume existing in-progress session
      notifyListeners();
      return;
    }
    _session = WorkoutSessionState(workout: workout);
    notifyListeners();
  }

  void setCurrentStep(int index) {
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
      isSessionCompleted: allDone,
      completedAt: allDone ? DateTime.now() : null,
    );
    notifyListeners();
  }

  void skipStep(int stepIndex) {
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
    notifyListeners();
  }

  Future<void> completeEntireWorkout() async {
    if (_session == null) return;
    final updatedStatuses = Map<int, WorkoutStepStatus>.from(
      _session!.stepStatuses,
    );
    for (int i = 0; i < _session!.workout.steps.length; i++) {
      if (updatedStatuses[i] != WorkoutStepStatus.skipped) {
        updatedStatuses[i] = WorkoutStepStatus.completed;
      }
    }

    final now = DateTime.now();
    _session = _session!.copyWith(
      isSessionCompleted: true,
      completedAt: now,
      stepStatuses: updatedStatuses,
    );
    notifyListeners();
  }

  void resetSession() {
    _session = null;
    notifyListeners();
  }
}
