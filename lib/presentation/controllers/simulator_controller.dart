import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../core/audio/speech_service.dart';
import '../../core/evaluation/evaluation_result.dart';
import '../../core/evaluation/speech_evaluator.dart';
import '../../data/models/attempt_record.dart';
import '../../domain/entities/scenario.dart';
import '../../domain/repositories/attempt_repository.dart';

class SimulatorController extends ChangeNotifier {
  final ISpeechService speechService;
  final IAttemptRepository repository;

  final Scenario scenario;

  String _liveTranscript = '';
  EvaluationResult? _evaluationResult;
  String? _errorMessage;
  int? _bestScore;
  List<AttemptRecord> _recentAttempts = [];
  DateTime? _listeningStartTime;

  StreamSubscription? _stateSub;
  StreamSubscription? _transcriptSub;

  SimulatorController({
    required this.speechService,
    required this.repository,
    Scenario? scenario,
  }) : scenario = scenario ?? Scenario.m1GreetingScenario() {
    _stateSub = speechService.stateStream.listen((_) {
      notifyListeners();
    });

    _transcriptSub = speechService.partialTranscriptStream.listen((partial) {
      _liveTranscript = partial;
      notifyListeners();
    });
  }

  VoiceEngineState get engineState => speechService.state;
  String get liveTranscript => _liveTranscript;
  EvaluationResult? get evaluationResult => _evaluationResult;
  String? get errorMessage => _errorMessage;
  int? get bestScore => _bestScore;
  List<AttemptRecord> get recentAttempts => _recentAttempts;

  bool get isCustomerSpeaking =>
      speechService.state == VoiceEngineState.customerSpeaking;
  bool get isListening =>
      speechService.state == VoiceEngineState.listeningToUser;
  bool get isProcessing => speechService.state == VoiceEngineState.processing;
  bool get hasEvaluation => _evaluationResult != null;
  bool get hasTargetMet => _evaluationResult?.scriptTargetMet == true;

  Future<void> initialize() async {
    await speechService.initialize();
    await loadHistory();
  }

  Future<void> loadHistory() async {
    _recentAttempts = await repository.getAttempts(scenarioId: scenario.id);
    _bestScore = await repository.getBestAccuracy(scenario.id);
    notifyListeners();
  }

  Future<void> playCustomerResponse() async {
    _errorMessage = null;
    notifyListeners();

    await speechService.speakCustomerPrompt(
      scenario.customerResponse,
      onFinished: () {
        notifyListeners();
      },
    );
  }

  /// Backward-compatible alias
  Future<void> playCustomerPrompt() => playCustomerResponse();

  Future<void> startListening() async {
    _errorMessage = null;
    _liveTranscript = '';
    _listeningStartTime = DateTime.now();
    notifyListeners();

    await speechService.startListening(
      onResult: (finalTranscript) async {
        await processTranscript(finalTranscript);
      },
      onError: (err) {
        _errorMessage = err;
        notifyListeners();
      },
    );
  }

  Future<void> stopListening() async {
    await speechService.stopListening();
  }

  Future<void> cancelListening() async {
    await speechService.cancelListening();
    _liveTranscript = '';
    notifyListeners();
  }

  Future<void> processTranscript(String transcript) async {
    _liveTranscript = transcript;
    final duration = _listeningStartTime != null
        ? DateTime.now().difference(_listeningStartTime!)
        : const Duration(seconds: 4);

    final result = SpeechEvaluator.evaluateGreeting(
      transcript,
      duration: duration,
    );
    _evaluationResult = result;

    // Persist attempt locally
    final record = AttemptRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      scenarioId: scenario.id,
      timestamp: DateTime.now(),
      transcript: transcript,
      accuracyPercentage: result.similarityPercentage,
      passed: result.scriptTargetMet,
      wpm: result.estimatedWpm,
      missingAnchors: result.missingAnchors,
      pbErrors: result.detectedPbErrors,
      arabicCoaching: result.arabicCoachingFeedback,
    );

    await repository.saveAttempt(record);
    await loadHistory();

    // If script target met, play customer response
    if (result.scriptTargetMet) {
      await playCustomerResponse();
    }
  }

  void retry() {
    speechService.stopSpeaking();
    _liveTranscript = '';
    _evaluationResult = null;
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _stateSub?.cancel();
    _transcriptSub?.cancel();
    speechService.dispose();
    super.dispose();
  }
}
