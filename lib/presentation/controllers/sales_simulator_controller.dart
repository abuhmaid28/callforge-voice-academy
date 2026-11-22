import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../core/audio/speech_service.dart';
import '../../core/evaluation/sales_evaluator.dart';
import '../../core/evaluation/speech_evaluator.dart';
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
      final norm = SpeechEvaluator.normalize(_liveTranscript);
      final tokens = norm.split(' ').where((w) => w.isNotEmpty).toList();
      final anchorResult = SpeechEvaluator.evaluateGreetingAnchors(tokens);

      final hasAlex = anchorResult.matched.contains('alex');
      final hasAtt = anchorResult.matched.contains('att');
      final hasCustomerName =
          anchorResult.matched.contains('name') ||
          (anchorResult.matched.contains('first') &&
              anchorResult.matched.contains('last'));

      if (!hasAudio || !hasAlex || !hasAtt || !hasCustomerName) {
        final missingList = <String>[];
        if (!hasAlex) missingList.add('Alex');
        if (!hasAtt) missingList.add('AT&T');
        if (!hasCustomerName) missingList.add('Customer Name request');

        _errorMessage =
            'Mandatory Greeting Incomplete: Missing ${missingList.join(', ')}. '
            'Please deliver the standard greeting: "Hello, thank you for calling AT&T. This is Alex. May I have your first and last name, please?"';
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
      await _completeCall(
        _currentTurn!.resultingOutcome ?? SalesOutcomeType.qualifiedAccept,
      );
      return;
    }

    // Branch to next turn
    _resolveNextTurn();
  }

  void _resolveNextTurn() {
    if (_currentTurn == null || _activeScenario == null) return;
    if (_currentTurn!.branches.isEmpty) return;

    if (_currentTurn!.branches.length == 1) {
      final defaultBranch = _currentTurn!.branches.first;
      final nextTurn = _activeScenario!.findTurnById(defaultBranch.nextTurnId);
      if (nextTurn != null) {
        _advanceToTurn(nextTurn);
      }
      return;
    }

    final normTranscript = SpeechEvaluator.normalize(_liveTranscript);
    final hasRequired =
        _currentTurn!.requiredKeywords.isEmpty ||
        _currentTurn!.requiredKeywords.any(
          (k) => normTranscript.contains(k.toLowerCase()),
        );

    final ScenarioBranch selectedBranch;
    if (hasRequired) {
      selectedBranch = _currentTurn!.branches.firstWhere(
        (b) =>
            b.conditionKey == 'success' ||
            b.conditionKey == 'high_empathy' ||
            b.conditionKey == 'accept' ||
            b.conditionKey == 'default',
        orElse: () => _currentTurn!.branches.first,
      );
    } else {
      selectedBranch = _currentTurn!.branches.firstWhere(
        (b) =>
            b.conditionKey == 'objection' ||
            b.conditionKey == 'retry' ||
            b.conditionKey == 'low_aerd' ||
            b.conditionKey == 'friction',
        orElse: () => _currentTurn!.branches.first,
      );
    }

    final nextTurn = _activeScenario!.findTurnById(selectedBranch.nextTurnId);
    if (nextTurn != null) {
      _advanceToTurn(nextTurn);
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
    if (customerTurn.branches.length == 1) {
      return customerTurn.branches.first.nextTurnId;
    }

    final previousAgentText = _conversationHistory.reversed
        .firstWhere(
          (b) => b.speaker == TurnSpeaker.agent,
          orElse: () => _conversationHistory.first,
        )
        .text;
    final normPrev = SpeechEvaluator.normalize(previousAgentText);

    // 1. Check for decline / no-sale branch (budget_decline, decline, no_sale)
    if (normPrev.contains('respect your') ||
        normPrev.contains('respect that') ||
        normPrev.contains('keep your') ||
        normPrev.contains('keep you on') ||
        normPrev.contains('leave as is') ||
        normPrev.contains('leave your') ||
        normPrev.contains('station wi fi') ||
        normPrev.contains('free wi fi') ||
        normPrev.contains('no changes')) {
      final declineBranch = customerTurn.branches.where(
        (b) =>
            b.conditionKey == 'budget_decline' ||
            b.conditionKey == 'decline' ||
            b.conditionKey == 'no_sale' ||
            b.conditionKey.contains('decline') ||
            b.conditionKey.contains('no_sale'),
      );
      if (declineBranch.isNotEmpty) {
        return declineBranch.first.nextTurnId;
      }
    }

    // 2. Check for verification / eligibility branch (verify, needs_check, check)
    if (normPrev.contains('verify') ||
        normPrev.contains('check') ||
        normPrev.contains('address') ||
        normPrev.contains('specifications') ||
        normPrev.contains('coverage') ||
        normPrev.contains('look up') ||
        normPrev.contains('confirm') ||
        normPrev.contains('review your billing') ||
        normPrev.contains('permission') ||
        normPrev.contains('status first')) {
      final verifyBranch = customerTurn.branches.where(
        (b) =>
            b.conditionKey == 'needs_check' ||
            b.conditionKey == 'verify' ||
            b.conditionKey.contains('check') ||
            b.conditionKey.contains('verify'),
      );
      if (verifyBranch.isNotEmpty) {
        return verifyBranch.first.nextTurnId;
      }
    }

    // 3. Check for friction / objection if response is very short/unclear
    if (normPrev.split(' ').where((w) => w.isNotEmpty).length < 3) {
      final frictionBranch = customerTurn.branches.where(
        (b) =>
            b.conditionKey == 'objection' ||
            b.conditionKey == 'friction' ||
            b.conditionKey == 'low_aerd',
      );
      if (frictionBranch.isNotEmpty) {
        return frictionBranch.first.nextTurnId;
      }
    }

    // 4. Default / accept / high_value branch
    final highValueBranch = customerTurn.branches.firstWhere(
      (b) =>
          b.conditionKey == 'high_value' ||
          b.conditionKey == 'qualified' ||
          b.conditionKey == 'accept',
      orElse: () => customerTurn.branches.firstWhere(
        (b) => b.conditionKey == 'default',
        orElse: () => customerTurn.branches.first,
      ),
    );
    return highValueBranch.nextTurnId;
  }

  Future<void> _completeCall(SalesOutcomeType outcome) async {
    if (_hasRecordedCompletion || _activeScenario == null) return;
    _hasRecordedCompletion = true;

    final completedTurns = _activeScenario!.turns
        .where(
          (t) =>
              _agentTurnTranscripts.containsKey(t.turnNumber) ||
              _conversationHistory.any((b) => b.turnId == t.id),
        )
        .toList();

    SalesOutcomeType validatedOutcome = outcome;

    // Ethical conversion gate:
    // If proposed outcome is qualifiedAccept, verify discovery, disclosures, and consent prerequisites
    if (validatedOutcome == SalesOutcomeType.qualifiedAccept) {
      final allAgentText = _agentTurnTranscripts.values.join(' ').toLowerCase();
      final normalizedAll = SpeechEvaluator.normalize(allAgentText);

      final hasProhibited =
          SalesEvaluator.universalProhibitedPromises.any(
            (p) => normalizedAll.contains(p.toLowerCase()),
          ) ||
          _activeScenario!.prohibitedPromises.any(
            (p) => normalizedAll.contains(p.toLowerCase()),
          );

      final hasDiscovery =
          SalesEvaluator.discoveryQuestionMarkers.any(
            (m) => normalizedAll.contains(m),
          ) ||
          RegExp(
            r'\b(who|what|where|when|why|how|which|tell me|could you|would you|can you|do you|are you)\b',
          ).hasMatch(normalizedAll);

      // Check scenario mandatory disclosures coverage
      final hasDisclosures = _hasMandatoryDisclosuresCovered(
        _activeScenario!,
        normalizedAll,
      );

      // Explicit consent check: customer outcome must have been qualifiedAccept
      final hasCustomerConsent = outcome == SalesOutcomeType.qualifiedAccept;

      if (hasProhibited ||
          !hasDiscovery ||
          !hasDisclosures ||
          !hasCustomerConsent) {
        validatedOutcome = SalesOutcomeType.needsVerification;
      }
    }

    // Evaluate full call using SalesEvaluator
    var scorecard = SalesEvaluator.evaluateSalesCall(
      scenario: _activeScenario!,
      agentUtterances: _agentTurnTranscripts.values.toList(),
      reachedOutcome: validatedOutcome,
      completedTurns: completedTurns,
    );

    // If scorecard failed overall (score < 70 or violations), do not award qualified acceptance
    if (!scorecard.passed &&
        validatedOutcome == SalesOutcomeType.qualifiedAccept) {
      validatedOutcome = SalesOutcomeType.needsVerification;
      scorecard = scorecard.copyWith(outcomeType: validatedOutcome);
    }

    _latestScorecard = scorecard;
    _state = SalesSimulatorState.callCompleted;
    notifyListeners();

    // Save AttemptRecord (awaited)
    if (attemptRepository != null) {
      await attemptRepository!.saveAttempt(
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
          salesOutcomeType: validatedOutcome.name,
          isNoSaleSuccess: scorecard.isNoSaleSuccess,
          curriculumDay: curriculumDay,
          salesScorecard: scorecard.toJson(),
        ),
      );
    }

    // Record progress in ProgressRepository (awaited)
    if (progressRepository != null) {
      await progressRepository!.recordSalesSimulationCompletion(
        scenarioId: _activeScenario!.id,
        skillTags: _activeScenario!.skillTags,
        score: scorecard.overallScore,
        isNoSaleSuccess: scorecard.isNoSaleSuccess,
      );

      // Award curriculum day completion ONLY when passed
      if (curriculumDay != null && scorecard.passed) {
        await progressRepository!.recordCurriculumDayCompletion(
          dayNumber: curriculumDay!,
          score: scorecard.overallScore,
        );
      }
    }
  }

  static bool _hasMandatoryDisclosuresCovered(
    SalesScenario scenario,
    String normalizedAllAgentText,
  ) {
    if (scenario.mandatoryDisclosures.isEmpty) return true;
    for (final disc in scenario.mandatoryDisclosures) {
      final words = disc
          .toLowerCase()
          .replaceAll(RegExp(r'[^\w\s]'), '')
          .split(' ')
          .where((w) => w.length >= 4 && !_isStopWord(w))
          .toList();
      if (words.isEmpty) continue;
      final matchedCount = words
          .where((w) => normalizedAllAgentText.contains(w))
          .length;
      if (matchedCount == 0) {
        return false;
      }
    }
    return true;
  }

  static bool _isStopWord(String word) {
    const stopWords = {
      'that',
      'this',
      'with',
      'from',
      'your',
      'have',
      'been',
      'will',
      'would',
      'could',
      'should',
      'their',
      'there',
      'about',
      'after',
      'before',
      'where',
      'which',
      'other',
      'under',
      'while',
      'these',
      'those',
      'being',
      'until',
      'also',
      'into',
      'onto',
      'upon',
    };
    return stopWords.contains(word);
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
