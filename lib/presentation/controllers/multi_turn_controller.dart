import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../core/audio/speech_service.dart';
import '../../core/evaluation/multi_turn_evaluator.dart';
import '../../data/models/attempt_record.dart';
import '../../domain/entities/scenario.dart';
import '../../domain/repositories/attempt_repository.dart';
import '../../domain/repositories/progress_repository.dart';

enum MultiTurnState {
  idle,
  agentListening,
  agentEvaluating,
  customerSpeaking,
  turnCompleted,
  callCompleted,
  error,
}

class ConversationBubbleItem {
  final String turnId;
  final TurnSpeaker speaker;
  final String text;
  final MultiTurnEvaluationResult? evaluation;
  final DateTime timestamp;

  ConversationBubbleItem({
    required this.turnId,
    required this.speaker,
    required this.text,
    this.evaluation,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

class MultiTurnController extends ChangeNotifier {
  final ISpeechService speechService;
  final IProgressRepository? progressRepository;
  final IAttemptRepository? attemptRepository;
  final int? curriculumDay;

  MultiTurnState _state = MultiTurnState.idle;
  MultiTurnState get state => _state;
  bool get isCallCompleted => _state == MultiTurnState.callCompleted;

  Scenario? _activeScenario;
  Scenario? get activeScenario => _activeScenario;

  ScenarioTurn? _currentTurn;
  ScenarioTurn? get currentTurn => _currentTurn;

  final List<ConversationBubbleItem> _conversationHistory = [];
  List<ConversationBubbleItem> get conversationHistory =>
      List.unmodifiable(_conversationHistory);

  String _liveTranscript = '';
  String get liveTranscript => _liveTranscript;

  MultiTurnEvaluationResult? _latestEvaluation;
  MultiTurnEvaluationResult? get latestEvaluation => _latestEvaluation;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  final Map<String, MultiTurnEvaluationResult> _turnEvaluations = {};
  Map<String, MultiTurnEvaluationResult> get turnEvaluations =>
      Map.unmodifiable(_turnEvaluations);

  double get averageScore {
    if (_turnEvaluations.isEmpty) return 0.0;
    final total = _turnEvaluations.values.fold(0.0, (sum, e) => sum + e.score);
    return total / _turnEvaluations.length;
  }

  bool get isPassed => averageScore >= 70.0;

  int _sessionGeneration = 0;
  int _activeListenSession = 0;
  bool _hasRecordedCompletion = false;
  bool _isDisposed = false;

  MultiTurnController({
    required this.speechService,
    this.progressRepository,
    this.attemptRepository,
    this.curriculumDay,
  });

  @override
  void notifyListeners() {
    if (!_isDisposed) {
      super.notifyListeners();
    }
  }

  void startScenario(Scenario scenario) {
    _activeListenSession++;
    _sessionGeneration++;
    _activeScenario = scenario;
    _conversationHistory.clear();
    _turnEvaluations.clear();
    _liveTranscript = '';
    _latestEvaluation = null;
    _errorMessage = null;
    _hasRecordedCompletion = false;

    if (scenario.turns.isNotEmpty) {
      _currentTurn = scenario.turns.first;
    } else {
      _currentTurn = null;
    }

    _state = MultiTurnState.idle;
    notifyListeners();
  }

  Future<void> startAgentListening() async {
    if (_currentTurn == null || _currentTurn!.speaker != TurnSpeaker.agent) {
      return;
    }
    final listenSession = ++_activeListenSession;

    _errorMessage = null;
    _liveTranscript = '';
    _state = MultiTurnState.agentListening;
    notifyListeners();

    try {
      await speechService.startListening(
        onResult: (text) {
          if (_isDisposed || listenSession != _activeListenSession) return;
          _liveTranscript = text;
          notifyListeners();
        },
        onError: (err) {
          if (_isDisposed || listenSession != _activeListenSession) return;
          _errorMessage = err;
          _state = MultiTurnState.error;
          notifyListeners();
        },
      );
    } catch (e) {
      if (_isDisposed || listenSession != _activeListenSession) return;
      _errorMessage = 'Microphone recording error: $e';
      _state = MultiTurnState.error;
      notifyListeners();
    }
  }

  Future<void> stopAgentListeningAndEvaluate() async {
    if (_state != MultiTurnState.agentListening || _currentTurn == null) return;
    final targetSession = _activeListenSession;

    _state = MultiTurnState.agentEvaluating;
    notifyListeners();

    try {
      await speechService.stopListening();
    } catch (_) {}

    // Guard: ignore if session was cancelled or invalidated while stopping
    if (_isDisposed || targetSession != _activeListenSession) return;

    // Seal session token so late callbacks cannot alter transcript
    _activeListenSession++;

    final bool hasAudio = _liveTranscript.trim().isNotEmpty;
    final eval = MultiTurnEvaluator.evaluateTurn(
      turn: _currentTurn!,
      agentTranscript: _liveTranscript,
    );

    _latestEvaluation = eval;
    _turnEvaluations[_currentTurn!.id] = eval;

    _conversationHistory.add(
      ConversationBubbleItem(
        turnId: _currentTurn!.id,
        speaker: TurnSpeaker.agent,
        text: !hasAudio ? '(No audio detected)' : _liveTranscript,
        evaluation: eval,
      ),
    );

    // GATE 1: Final turn completion gate (Finding B2)
    if (_currentTurn!.isFinal) {
      if (eval.isTargetMet && hasAudio) {
        await _completeCall();
      } else {
        // Failed final turn: do not mark completed, do not record progress
        _state = MultiTurnState.idle;
        notifyListeners();

        // Persist failed attempt record for historical visibility without inflating completions
        if (attemptRepository != null && _activeScenario != null) {
          await attemptRepository!.saveAttempt(
            AttemptRecord(
              id: 'att-scen-fail-${DateTime.now().millisecondsSinceEpoch}',
              scenarioId: _activeScenario!.id,
              timestamp: DateTime.now(),
              transcript: _liveTranscript,
              accuracyPercentage: eval.score.round(),
              passed: false,
              wpm: 0,
              missingAnchors: eval.missingKeywords,
              pbErrors: eval.pbConfusions,
              arabicCoaching: eval.trainerFeedbackArabic,
              scriptTitle: _activeScenario!.title,
              scriptSnapshot: _currentTurn!.spokenText,
              scriptVersion: 'scenario-v1.0',
              attemptType: 'scenario',
              curriculumDay: curriculumDay,
            ),
          );
        }
      }
      return;
    }

    // GATE 2: Mandatory Opening Progression Gate (Finding B1)
    if (_currentTurn!.turnNumber == 1 && (!eval.isTargetMet || !hasAudio)) {
      // Must not advance to customer Turn 2; remain on Turn 1 with error feedback
      _state = MultiTurnState.idle;
      notifyListeners();
      return;
    }

    // Explicitly prevent no-audio advancing on any turn
    if (!hasAudio) {
      _state = MultiTurnState.idle;
      notifyListeners();
      return;
    }

    _state = MultiTurnState.turnCompleted;
    notifyListeners();

    // Advance along the chosen branch (success or low_aerd/objection)
    if (eval.nextTurnId != null) {
      final nextTurn = _findTurnById(eval.nextTurnId!);
      if (nextTurn != null) {
        _advanceToTurn(nextTurn);
      }
    }
  }

  void _advanceToTurn(ScenarioTurn nextTurn) {
    _currentTurn = nextTurn;
    _liveTranscript = '';

    if (nextTurn.speaker == TurnSpeaker.customer) {
      _playCustomerTurn(nextTurn);
    } else {
      _state = MultiTurnState.idle;
      notifyListeners();
    }
  }

  Future<void> _playCustomerTurn(ScenarioTurn customerTurn) async {
    final currentSession = ++_sessionGeneration;
    _state = MultiTurnState.customerSpeaking;
    notifyListeners();

    _conversationHistory.add(
      ConversationBubbleItem(
        turnId: customerTurn.id,
        speaker: TurnSpeaker.customer,
        text: customerTurn.spokenText,
      ),
    );

    try {
      await speechService.speakCustomerPrompt(
        customerTurn.spokenText,
        onFinished: () {
          if (_isDisposed || currentSession != _sessionGeneration) return;

          if (customerTurn.isFinal) {
            _completeCall();
            return;
          }

          // Resolve next agent turn
          if (customerTurn.branches.isNotEmpty) {
            final nextTurnId = customerTurn.branches.first.nextTurnId;
            final nextTurn = _findTurnById(nextTurnId);
            if (nextTurn != null) {
              _currentTurn = nextTurn;
            }
          }

          _state = MultiTurnState.idle;
          notifyListeners();
        },
        onError: (err) {
          if (_isDisposed || currentSession != _sessionGeneration) return;
          _errorMessage = 'Customer audio playback failed: $err';
          _state = MultiTurnState.idle;
          notifyListeners();
        },
      );
    } catch (e) {
      if (_isDisposed || currentSession != _sessionGeneration) return;
      _errorMessage = 'Customer audio playback failed: $e';
      _state = MultiTurnState.idle;
      notifyListeners();
    }
  }

  Future<void> _completeCall() async {
    if (_hasRecordedCompletion) return;
    _hasRecordedCompletion = true;

    _state = MultiTurnState.callCompleted;
    notifyListeners();

    final avgScore = _turnEvaluations.isNotEmpty ? averageScore : 75.0;
    final callPassed = avgScore >= 70.0;

    if (progressRepository != null && _activeScenario != null) {
      await progressRepository!.recordSimulationCompletion(
        scenarioId: _activeScenario!.id,
        skillTags: _activeScenario!.skillTags,
        score: avgScore,
      );

      if (curriculumDay != null && callPassed) {
        await progressRepository!.recordCurriculumDayCompletion(
          dayNumber: curriculumDay!,
          score: avgScore,
        );
      }
    }

    if (attemptRepository != null && _activeScenario != null) {
      await attemptRepository!.saveAttempt(
        AttemptRecord(
          id: 'att-scen-${DateTime.now().millisecondsSinceEpoch}',
          scenarioId: _activeScenario!.id,
          timestamp: DateTime.now(),
          transcript: _liveTranscript,
          accuracyPercentage: _latestEvaluation != null
              ? _latestEvaluation!.score.round()
              : avgScore.round(),
          passed: callPassed,
          wpm: 0,
          missingAnchors: _latestEvaluation?.missingKeywords ?? [],
          pbErrors: _latestEvaluation?.pbConfusions ?? [],
          arabicCoaching: _latestEvaluation?.trainerFeedbackArabic ?? '',
          scriptTitle: _activeScenario!.title,
          scriptSnapshot: _activeScenario!.customerResponse,
          scriptVersion: 'scenario-v1.0',
          attemptType: 'scenario',
          curriculumDay: curriculumDay,
        ),
      );
    }
  }

  ScenarioTurn? _findTurnById(String id) {
    if (_activeScenario == null) return null;
    try {
      return _activeScenario!.turns.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  void retryCurrentTurn() {
    _activeListenSession++;
    _sessionGeneration++;
    _liveTranscript = '';
    _latestEvaluation = null;
    if (_currentTurn != null) {
      _turnEvaluations.remove(_currentTurn!.id);
    }
    speechService.cancelListening();
    speechService.stopSpeaking();
    _state = MultiTurnState.idle;
    notifyListeners();
  }

  void resetAudioSession() {
    _activeListenSession++;
    _sessionGeneration++;
    _liveTranscript = '';
    speechService.cancelListening();
    speechService.stopSpeaking();
    _state = MultiTurnState.idle;
    notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _activeListenSession++;
    _sessionGeneration++;
    speechService.cancelListening();
    speechService.stopSpeaking();
    super.dispose();
  }
}
