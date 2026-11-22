import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../core/audio/speech_service.dart';
import '../../core/evaluation/sales_evaluator.dart';
import '../../data/models/attempt_record.dart';
import '../../domain/entities/sales_scenario.dart';
import '../../domain/entities/sales_scorecard.dart';
import '../../domain/entities/scenario.dart';
import '../../domain/repositories/attempt_repository.dart';
import '../../domain/repositories/progress_repository.dart';

enum SalesSimulatorState {
  idle,
  agentListening,
  agentEvaluating,
  customerSpeaking,
  turnCompleted,
  callCompleted,
  error,
}

class SalesConversationBubble {
  final String turnId;
  final TurnSpeaker speaker;
  final String text;
  final SalesPhase phase;
  final DateTime timestamp;

  SalesConversationBubble({
    required this.turnId,
    required this.speaker,
    required this.text,
    required this.phase,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

class SalesSimulatorController extends ChangeNotifier {
  final ISpeechService speechService;
  final IProgressRepository? progressRepository;
  final IAttemptRepository? attemptRepository;
  final int? curriculumDay;

  SalesSimulatorState _state = SalesSimulatorState.idle;
  SalesSimulatorState get state => _state;
  bool get isCallCompleted => _state == SalesSimulatorState.callCompleted;

  SalesScenario? _activeScenario;
  SalesScenario? get activeScenario => _activeScenario;

  SalesTurn? _currentTurn;
  SalesTurn? get currentTurn => _currentTurn;

  final List<SalesConversationBubble> _conversationHistory = [];
  List<SalesConversationBubble> get conversationHistory =>
      List.unmodifiable(_conversationHistory);

  final Map<int, String> _agentTurnTranscripts = {};
  Map<int, String> get agentTurnTranscripts =>
      Map.unmodifiable(_agentTurnTranscripts);

  String _liveTranscript = '';
  String get liveTranscript => _liveTranscript;

  SalesScorecard? _latestScorecard;
  SalesScorecard? get latestScorecard => _latestScorecard;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  int _sessionGeneration = 0;
  int _activeListenSession = 0;
  bool _hasRecordedCompletion = false;
  bool _isDisposed = false;

  SalesSimulatorController({
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

  void startScenario(SalesScenario scenario) {
    _activeListenSession++;
    _sessionGeneration++;
    _activeScenario = scenario;
    _conversationHistory.clear();
    _agentTurnTranscripts.clear();
    _liveTranscript = '';
    _latestScorecard = null;
    _errorMessage = null;
    _hasRecordedCompletion = false;

    if (scenario.turns.isNotEmpty) {
      _currentTurn = scenario.turns.first;
      if (_currentTurn!.speaker == TurnSpeaker.customer) {
        _playCustomerTurn(_currentTurn!);
      } else {
        _state = SalesSimulatorState.idle;
        notifyListeners();
      }
    }
  }

  Future<void> startListening() async {
    if (_state == SalesSimulatorState.agentListening ||
        _state == SalesSimulatorState.customerSpeaking ||
        _currentTurn == null ||
        _currentTurn!.speaker != TurnSpeaker.agent) {
      return;
    }

    _errorMessage = null;
    _liveTranscript = '';
    _state = SalesSimulatorState.agentListening;
    final int targetListenSession = ++_activeListenSession;
    notifyListeners();

    try {
      await speechService.startListening(
        onResult: (text) {
          if (_isDisposed || targetListenSession != _activeListenSession) {
            return;
          }
          _liveTranscript = text;
          notifyListeners();
        },
        onError: (err) {
          if (_isDisposed || targetListenSession != _activeListenSession) {
            return;
          }
          _errorMessage = err;
          _state = SalesSimulatorState.error;
          notifyListeners();
        },
      );
    } catch (e) {
      if (_isDisposed || targetListenSession != _activeListenSession) return;
      _errorMessage = e.toString();
      _state = SalesSimulatorState.error;
      notifyListeners();
    }
  }

  Future<void> stopListening() async {
    if (_state != SalesSimulatorState.agentListening || _currentTurn == null) {
      return;
    }

    final int targetSession = _activeListenSession;
    _state = SalesSimulatorState.agentEvaluating;
    notifyListeners();

    try {
      await speechService.stopListening();
    } catch (_) {}

    if (_isDisposed || targetSession != _activeListenSession) return;

    // Seal session token
    _activeListenSession++;

    final bool hasAudio = _liveTranscript.trim().isNotEmpty;
    final String transcriptText = hasAudio
        ? _liveTranscript.trim()
        : '(No audio detected)';

    _agentTurnTranscripts[_currentTurn!.turnNumber] = hasAudio
        ? _liveTranscript.trim()
        : '';

    _conversationHistory.add(
      SalesConversationBubble(
        turnId: _currentTurn!.id,
        speaker: TurnSpeaker.agent,
        text: transcriptText,
        phase: _currentTurn!.phase,
      ),
    );

    // GATE: Turn 1 Opening Mandatory Greeting Check
    if (_currentTurn!.turnNumber == 1) {
      final lower = _liveTranscript.toLowerCase();
      final hasAlex = lower.contains('alex');
      final hasAtt = lower.contains('at&t') || lower.contains('att');

      if (!hasAudio || !hasAlex || !hasAtt) {
        _errorMessage = 'Mandatory Greeting Incomplete: You must state your name (Alex) and AT&T.';
        _state = SalesSimulatorState.idle;
        notifyListeners();
        return;
      }
    }

    // Explicitly prevent no-audio advancing
    if (!hasAudio) {
      _errorMessage = 'No spoken response detected. Please press the mic and speak clearly.';
      _state = SalesSimulatorState.idle;
      notifyListeners();
      return;
    }

    _state = SalesSimulatorState.turnCompleted;
    notifyListeners();

    // Check if turn was final
    if (_currentTurn!.isFinal) {
      _completeCall(
        _currentTurn!.resultingOutcome ?? SalesOutcomeType.qualifiedAccept,
      );
      return;
    }

    // Branch to next turn
    _resolveNextTurn();
  }

  void _resolveNextTurn() {
    if (_currentTurn == null || _activeScenario == null) return;

    if (_currentTurn!.branches.isNotEmpty) {
      final defaultBranch = _currentTurn!.branches.first;
      final nextTurn = _activeScenario!.findTurnById(defaultBranch.nextTurnId);
      if (nextTurn != null) {
        _advanceToTurn(nextTurn);
      }
    }
  }

  void _advanceToTurn(SalesTurn nextTurn) {
    _currentTurn = nextTurn;
    _liveTranscript = '';

    if (nextTurn.speaker == TurnSpeaker.customer) {
      _playCustomerTurn(nextTurn);
    } else {
      _state = SalesSimulatorState.idle;
      notifyListeners();
    }
  }

  Future<void> _playCustomerTurn(SalesTurn customerTurn) async {
    _state = SalesSimulatorState.customerSpeaking;
    final int generation = _sessionGeneration;
    notifyListeners();

    _conversationHistory.add(
      SalesConversationBubble(
        turnId: customerTurn.id,
        speaker: TurnSpeaker.customer,
        text: customerTurn.spokenText,
        phase: customerTurn.phase,
      ),
    );

    try {
      await speechService.speakCustomerPrompt(
        customerTurn.spokenText,
        onFinished: () {
          if (_isDisposed || generation != _sessionGeneration) return;

          if (customerTurn.isFinal) {
            _completeCall(
              customerTurn.resultingOutcome ?? SalesOutcomeType.qualifiedAccept,
            );
            return;
          }

          // Advance to agent turn
          if (customerTurn.branches.isNotEmpty) {
            final nextTurnId = _evaluateCustomerBranch(customerTurn);
            final nextTurn = _activeScenario?.findTurnById(nextTurnId);
            if (nextTurn != null) {
              _currentTurn = nextTurn;
              _state = SalesSimulatorState.idle;
              notifyListeners();
            }
          } else {
            _state = SalesSimulatorState.idle;
            notifyListeners();
          }
        },
      );
    } catch (_) {
      if (_isDisposed || generation != _sessionGeneration) return;
      _state = SalesSimulatorState.idle;
      notifyListeners();
    }
  }

  String _evaluateCustomerBranch(SalesTurn customerTurn) {
    // If only 1 branch, return it directly
    if (customerTurn.branches.length == 1) {
      return customerTurn.branches.first.nextTurnId;
    }

    // Branch selection logic based on previous agent transcript
    final previousAgentText = _conversationHistory.reversed
        .firstWhere(
          (b) => b.speaker == TurnSpeaker.agent,
          orElse: () => _conversationHistory.first,
        )
        .text
        .toLowerCase();

    // Check for decline / no-sale branch
    if (previousAgentText.contains('respect') ||
        previousAgentText.contains('no problem') ||
        previousAgentText.contains('keep') ||
        previousAgentText.contains('leave as is')) {
      final declineBranch = customerTurn.branches.firstWhere(
        (b) =>
            b.conditionKey == 'decline' || b.conditionKey.contains('no_sale'),
        orElse: () => customerTurn.branches.first,
      );
      return declineBranch.nextTurnId;
    }

    // Check for verification branch
    if (previousAgentText.contains('verify') ||
        previousAgentText.contains('check') ||
        previousAgentText.contains('address') ||
        previousAgentText.contains('specifications')) {
      final verifyBranch = customerTurn.branches.firstWhere(
        (b) => b.conditionKey == 'verify' || b.conditionKey.contains('check'),
        orElse: () => customerTurn.branches.first,
      );
      return verifyBranch.nextTurnId;
    }

    // Default to accept branch if present
    final acceptBranch = customerTurn.branches.firstWhere(
      (b) => b.conditionKey == 'accept' || b.conditionKey == 'default',
      orElse: () => customerTurn.branches.first,
    );
    return acceptBranch.nextTurnId;
  }

  void _completeCall(SalesOutcomeType outcome) {
    if (_hasRecordedCompletion || _activeScenario == null) return;
    _hasRecordedCompletion = true;

    final completedTurns = _activeScenario!.turns
        .where(
          (t) =>
              _agentTurnTranscripts.containsKey(t.turnNumber) ||
              _conversationHistory.any((b) => b.turnId == t.id),
        )
        .toList();

    // Evaluate full call using SalesEvaluator
    final scorecard = SalesEvaluator.evaluateSalesCall(
      scenario: _activeScenario!,
      agentUtterances: _agentTurnTranscripts.values.toList(),
      reachedOutcome: outcome,
      completedTurns: completedTurns,
    );

    _latestScorecard = scorecard;
    _state = SalesSimulatorState.callCompleted;
    notifyListeners();

    // Save AttemptRecord
    if (attemptRepository != null) {
      attemptRepository!.saveAttempt(
        AttemptRecord(
          id: 'att-sales-${DateTime.now().millisecondsSinceEpoch}',
          scenarioId: _activeScenario!.id,
          timestamp: DateTime.now(),
          transcript: _agentTurnTranscripts.values.join(' '),
          accuracyPercentage: scorecard.overallScore.round(),
          passed: scorecard.passed,
          wpm: 0,
          missingAnchors: const [],
          pbErrors: const [],
          arabicCoaching: scorecard.dimensions.isNotEmpty
              ? scorecard.dimensions.first.feedbackArabic
              : '',
          scriptTitle: _activeScenario!.title,
          scriptSnapshot: _activeScenario!.contextNotes,
          scriptVersion: 'sales-v2.0',
          attemptType: 'sales',
          salesOutcomeType: outcome.name,
          isNoSaleSuccess: scorecard.isNoSaleSuccess,
          curriculumDay: curriculumDay,
          salesScorecard: scorecard.toJson(),
        ),
      );
    }

    // Record progress in ProgressRepository
    if (progressRepository != null) {
      progressRepository!.recordSalesSimulationCompletion(
        scenarioId: _activeScenario!.id,
        skillTags: _activeScenario!.skillTags,
        score: scorecard.overallScore,
        isNoSaleSuccess: scorecard.isNoSaleSuccess,
      );

      if (curriculumDay != null) {
        progressRepository!.recordCurriculumDayCompletion(
          dayNumber: curriculumDay!,
          score: scorecard.overallScore,
        );
      }
    }
  }

  void cancelListening() {
    _activeListenSession++;
    _sessionGeneration++;
    try {
      speechService.stopListening();
    } catch (_) {}
    _state = SalesSimulatorState.idle;
    notifyListeners();
  }

  void teardown() {
    _activeListenSession++;
    _sessionGeneration++;
    try {
      speechService.stopListening();
      speechService.stopSpeaking();
    } catch (_) {}
  }

  @override
  void dispose() {
    _isDisposed = true;
    teardown();
    super.dispose();
  }
}
