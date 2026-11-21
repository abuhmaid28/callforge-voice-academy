import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../core/audio/speech_service.dart';
import '../../core/evaluation/multi_turn_evaluator.dart';
import '../../domain/entities/scenario.dart';
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
  final ISpeechService _speechService;
  final IProgressRepository? _progressRepository;

  MultiTurnState _state = MultiTurnState.idle;
  MultiTurnState get state => _state;

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

  double _accumulatedScore = 0.0;
  int _agentTurnsCount = 0;

  bool _isDisposed = false;

  MultiTurnController({required this._speechService, this._progressRepository});

  @override
  void notifyListeners() {
    if (!_isDisposed) {
      super.notifyListeners();
    }
  }

  void startScenario(Scenario scenario) {
    _activeScenario = scenario;
    _conversationHistory.clear();
    _liveTranscript = '';
    _latestEvaluation = null;
    _errorMessage = null;
    _accumulatedScore = 0.0;
    _agentTurnsCount = 0;

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

    _errorMessage = null;
    _liveTranscript = '';
    _state = MultiTurnState.agentListening;
    notifyListeners();

    try {
      await _speechService.startListening(
        onResult: (text) {
          _liveTranscript = text;
          notifyListeners();
        },
        onError: (err) {
          _errorMessage = err;
          _state = MultiTurnState.error;
          notifyListeners();
        },
      );
    } catch (e) {
      _errorMessage = 'Microphone recording error: $e';
      _state = MultiTurnState.error;
      notifyListeners();
    }
  }

  Future<void> stopAgentListeningAndEvaluate() async {
    if (_state != MultiTurnState.agentListening || _currentTurn == null) return;

    _state = MultiTurnState.agentEvaluating;
    notifyListeners();

    try {
      await _speechService.stopListening();
    } catch (_) {}

    final eval = MultiTurnEvaluator.evaluateTurn(
      turn: _currentTurn!,
      agentTranscript: _liveTranscript,
    );
    _latestEvaluation = eval;
    _accumulatedScore += eval.score;
    _agentTurnsCount += 1;

    _conversationHistory.add(
      ConversationBubbleItem(
        turnId: _currentTurn!.id,
        speaker: TurnSpeaker.agent,
        text: _liveTranscript.isEmpty ? '(No audio detected)' : _liveTranscript,
        evaluation: eval,
      ),
    );

    if (_currentTurn!.isFinal) {
      _completeCall();
      return;
    }

    _state = MultiTurnState.turnCompleted;
    notifyListeners();

    // Move to next turn automatically if target met and branch resolved
    if (eval.isTargetMet && eval.nextTurnId != null) {
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
      await _speechService.speakCustomerPrompt(
        customerTurn.spokenText,
        onFinished: () {
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
          _errorMessage = 'Customer audio playback failed: $err';
          _state = MultiTurnState.idle;
          notifyListeners();
        },
      );
    } catch (e) {
      _errorMessage = 'Customer audio playback failed: $e';
      _state = MultiTurnState.idle;
      notifyListeners();
    }
  }

  void _completeCall() {
    _state = MultiTurnState.callCompleted;
    notifyListeners();

    if (_progressRepository != null && _activeScenario != null) {
      final avgScore = _agentTurnsCount > 0
          ? _accumulatedScore / _agentTurnsCount
          : 75.0;
      _progressRepository.recordSimulationCompletion(
        scenarioId: _activeScenario!.id,
        skillTags: _activeScenario!.skillTags,
        score: avgScore,
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
    _liveTranscript = '';
    _latestEvaluation = null;
    _speechService.cancelListening();
    _speechService.stopSpeaking();
    _state = MultiTurnState.idle;
    notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _speechService.cancelListening();
    _speechService.stopSpeaking();
    super.dispose();
  }
}
