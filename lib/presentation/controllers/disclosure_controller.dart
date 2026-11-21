import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../core/audio/speech_service.dart';
import '../../core/evaluation/disclosure_evaluator.dart';
import '../../data/models/attempt_record.dart';
import '../../data/models/disclosure_script.dart';
import '../../domain/repositories/attempt_repository.dart';
import '../../domain/repositories/disclosure_repository.dart';
import '../../domain/repositories/progress_repository.dart';

enum DisclosureState {
  idle,
  listening,
  evaluating,
  evaluated,
  playingCustomerResponse,
  playingReference,
  error,
}

class DisclosureController extends ChangeNotifier {
  final ISpeechService speechService;
  final IDisclosureRepository disclosureRepository;
  final IProgressRepository? progressRepository;
  final IAttemptRepository? attemptRepository;

  DisclosureState _state = DisclosureState.idle;
  DisclosureState get state => _state;

  List<DisclosureScript> _scripts = [];
  List<DisclosureScript> get scripts => _scripts;

  DisclosureScript? _selectedScript;
  DisclosureScript? get selectedScript => _selectedScript;

  String _currentTranscript = '';
  String get currentTranscript => _currentTranscript;

  DisclosureEvaluationResult? _latestResult;
  DisclosureEvaluationResult? get latestResult => _latestResult;

  SimulatedCustomerResponse? _activeCustomerResponse;
  SimulatedCustomerResponse? get activeCustomerResponse =>
      _activeCustomerResponse;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  DateTime? _listeningStartTime;
  int _sessionGeneration = 0;
  bool _isDisposed = false;

  DisclosureController({
    required this.speechService,
    required this.disclosureRepository,
    this.progressRepository,
    this.attemptRepository,
  });

  @override
  void notifyListeners() {
    if (!_isDisposed) {
      super.notifyListeners();
    }
  }

  Future<void> initialize() async {
    try {
      await speechService.initialize();
      _scripts = await disclosureRepository.getAllScripts();
      if (_scripts.isNotEmpty) {
        _selectedScript = _scripts.first;
      }
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load disclosures: $e';
      _state = DisclosureState.error;
      notifyListeners();
    }
  }

  void selectScript(DisclosureScript script) {
    _sessionGeneration++;
    _selectedScript = script;
    _latestResult = null;
    _currentTranscript = '';
    _activeCustomerResponse = null;
    _state = DisclosureState.idle;
    speechService.stopSpeaking();
    speechService.cancelListening();
    notifyListeners();
  }

  Future<void> startReading() async {
    if (_selectedScript == null) return;
    final currentSession = ++_sessionGeneration;

    _errorMessage = null;
    _latestResult = null;
    _currentTranscript = '';
    _activeCustomerResponse = null;

    _state = DisclosureState.listening;
    _listeningStartTime = DateTime.now();
    notifyListeners();

    try {
      await speechService.startListening(
        onResult: (text) {
          if (_isDisposed || currentSession != _sessionGeneration) return;
          _currentTranscript = text;
          notifyListeners();
        },
        onError: (err) {
          if (_isDisposed || currentSession != _sessionGeneration) return;
          _errorMessage = err;
          _state = DisclosureState.error;
          notifyListeners();
        },
      );
    } catch (e) {
      if (_isDisposed || currentSession != _sessionGeneration) return;
      _errorMessage = 'Audio capture failed: $e';
      _state = DisclosureState.error;
      notifyListeners();
    }
  }

  Future<void> stopReadingAndEvaluate() async {
    if (_state != DisclosureState.listening || _selectedScript == null) return;
    final currentSession = ++_sessionGeneration;

    _state = DisclosureState.evaluating;
    notifyListeners();

    try {
      await speechService.stopListening();
    } catch (_) {}

    final duration = _listeningStartTime != null
        ? DateTime.now().difference(_listeningStartTime!)
        : const Duration(seconds: 15);

    _latestResult = DisclosureEvaluator.evaluate(
      spokenTranscript: _currentTranscript,
      script: _selectedScript!,
      duration: duration,
    );

    if (_isDisposed || currentSession != _sessionGeneration) return;
    _state = DisclosureState.evaluated;

    if (_latestResult != null && _latestResult!.isTargetMet) {
      if (_selectedScript!.customerResponses.isNotEmpty) {
        _activeCustomerResponse = _selectedScript!.customerResponses.first;
      }

      if (progressRepository != null) {
        await progressRepository!.recordDisclosureCompletion(
          scriptId: _selectedScript!.id,
          score: _latestResult!.similarityScore * 100,
        );
      }

      if (attemptRepository != null) {
        await attemptRepository!.saveAttempt(
          AttemptRecord(
            id: 'att-disc-${DateTime.now().millisecondsSinceEpoch}',
            scenarioId: _selectedScript!.id,
            timestamp: DateTime.now(),
            transcript: _currentTranscript,
            accuracyPercentage: (_latestResult!.similarityScore * 100).round(),
            passed: _latestResult!.isTargetMet,
            wpm: _latestResult!.estimatedWpm,
            missingAnchors: _latestResult!.missingCriticalTerms
                .map((t) => t.term)
                .toList(),
            pbErrors: _latestResult!.detectedPbErrors,
            arabicCoaching: _latestResult!.arabicCoaching,
            scriptTitle: _selectedScript!.title,
            scriptSnapshot: _selectedScript!.scriptText,
            attemptType: 'disclosure',
          ),
        );
      }
    }

    notifyListeners();
  }

  Future<void> playCustomerResponse(SimulatedCustomerResponse response) async {
    // GUARD (B3): Customer consent outcomes can only be triggered after meeting practice target
    if (_latestResult == null || !_latestResult!.isTargetMet) {
      _errorMessage = 'Complete a successful practice read (100% Target Met) before simulating customer consent.';
      notifyListeners();
      return;
    }

    final currentSession = ++_sessionGeneration;
    _activeCustomerResponse = response;
    _state = DisclosureState.playingCustomerResponse;
    notifyListeners();

    try {
      await speechService.speakCustomerPrompt(
        response.spokenText,
        onFinished: () {
          if (_isDisposed || currentSession != _sessionGeneration) return;
          _state = DisclosureState.evaluated;
          notifyListeners();
        },
        onError: (err) {
          if (_isDisposed || currentSession != _sessionGeneration) return;
          _errorMessage = 'Audio playback failed: $err';
          _state = DisclosureState.evaluated;
          notifyListeners();
        },
      );
    } catch (e) {
      if (_isDisposed || currentSession != _sessionGeneration) return;
      _errorMessage = 'Audio playback failed: $e';
      _state = DisclosureState.evaluated;
      notifyListeners();
    }
  }

  /// Play standard American English reference audio of the disclosure text
  Future<void> playReferenceAudio() async {
    if (_selectedScript == null) return;

    if (_state == DisclosureState.playingReference) {
      await stopReferenceAudio();
      return;
    }

    final currentSession = ++_sessionGeneration;
    _state = DisclosureState.playingReference;
    notifyListeners();

    try {
      await speechService.speakCustomerPrompt(
        _selectedScript!.scriptText,
        onFinished: () {
          if (_isDisposed || currentSession != _sessionGeneration) return;
          _state = DisclosureState.idle;
          notifyListeners();
        },
        onError: (err) {
          if (_isDisposed || currentSession != _sessionGeneration) return;
          _errorMessage = 'Reference playback failed: $err';
          _state = DisclosureState.idle;
          notifyListeners();
        },
      );
    } catch (e) {
      if (_isDisposed || currentSession != _sessionGeneration) return;
      _errorMessage = 'Reference playback failed: $e';
      _state = DisclosureState.idle;
      notifyListeners();
    }
  }

  Future<void> stopReferenceAudio() async {
    _sessionGeneration++;
    try {
      await speechService.stopSpeaking();
    } catch (_) {}
    _state = DisclosureState.idle;
    notifyListeners();
  }

  Future<void> saveCustomDraft({
    required String title,
    required String category,
    required String scriptText,
    List<CriticalTerm> criticalTerms = const [],
  }) async {
    final draft = DisclosureScript(
      id: 'custom-draft-${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      category: category,
      scriptText: scriptText,
      criticalTerms: criticalTerms,
      isCustomUserDraft: true,
    );

    await disclosureRepository.saveUserDraft(draft);
    _scripts = await disclosureRepository.getAllScripts();
    _selectedScript = draft;
    _latestResult = null;
    _currentTranscript = '';
    _state = DisclosureState.idle;
    notifyListeners();
  }

  Future<void> updateCustomDraft(DisclosureScript updated) async {
    await disclosureRepository.saveUserDraft(updated);
    _scripts = await disclosureRepository.getAllScripts();
    _selectedScript = updated;
    _latestResult = null;
    _currentTranscript = '';
    _state = DisclosureState.idle;
    notifyListeners();
  }

  Future<void> deleteCustomDraft(String id) async {
    await disclosureRepository.deleteUserDraft(id);
    _scripts = await disclosureRepository.getAllScripts();
    _selectedScript = _scripts.isNotEmpty ? _scripts.first : null;
    _latestResult = null;
    _currentTranscript = '';
    _state = DisclosureState.idle;
    notifyListeners();
  }

  void cancel() {
    _sessionGeneration++;
    speechService.cancelListening();
    speechService.stopSpeaking();
    _state = DisclosureState.idle;
    notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _sessionGeneration++;
    speechService.cancelListening();
    speechService.stopSpeaking();
    super.dispose();
  }
}
