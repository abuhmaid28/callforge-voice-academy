import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../core/audio/speech_service.dart';
import '../../core/evaluation/disclosure_evaluator.dart';
import '../../data/models/disclosure_script.dart';
import '../../domain/repositories/disclosure_repository.dart';
import '../../domain/repositories/progress_repository.dart';

enum DisclosureState {
  idle,
  listening,
  evaluating,
  evaluated,
  playingCustomerResponse,
  error,
}

class DisclosureController extends ChangeNotifier {
  final ISpeechService _speechService;
  final IDisclosureRepository _disclosureRepository;
  final IProgressRepository? _progressRepository;

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

  DisclosureController({
    required this._speechService,
    required this._disclosureRepository,
    this._progressRepository,
  });

  Future<void> initialize() async {
    try {
      await _speechService.initialize();
      _scripts = await _disclosureRepository.getAllScripts();
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
    _selectedScript = script;
    _latestResult = null;
    _currentTranscript = '';
    _activeCustomerResponse = null;
    _state = DisclosureState.idle;
    notifyListeners();
  }

  Future<void> startReading() async {
    if (_selectedScript == null) return;
    _errorMessage = null;
    _latestResult = null;
    _currentTranscript = '';
    _activeCustomerResponse = null;

    _state = DisclosureState.listening;
    _listeningStartTime = DateTime.now();
    notifyListeners();

    try {
      await _speechService.startListening(
        onResult: (text) {
          _currentTranscript = text;
          notifyListeners();
        },
        onError: (err) {
          _errorMessage = err;
          _state = DisclosureState.error;
          notifyListeners();
        },
      );
    } catch (e) {
      _errorMessage = 'Audio capture failed: $e';
      _state = DisclosureState.error;
      notifyListeners();
    }
  }

  Future<void> stopReadingAndEvaluate() async {
    if (_state != DisclosureState.listening || _selectedScript == null) return;

    _state = DisclosureState.evaluating;
    notifyListeners();

    try {
      await _speechService.stopListening();
    } catch (_) {}

    final duration = _listeningStartTime != null
        ? DateTime.now().difference(_listeningStartTime!)
        : const Duration(seconds: 15);

    _latestResult = DisclosureEvaluator.evaluate(
      spokenTranscript: _currentTranscript,
      script: _selectedScript!,
      duration: duration,
    );

    _state = DisclosureState.evaluated;

    if (_latestResult != null && _latestResult!.isTargetMet) {
      // Pick a random or sequential customer response to simulate customer reply
      if (_selectedScript!.customerResponses.isNotEmpty) {
        _activeCustomerResponse = _selectedScript!.customerResponses.first;
      }

      // Record progress
      if (_progressRepository != null) {
        await _progressRepository.recordDisclosureCompletion(
          scriptId: _selectedScript!.id,
          score: _latestResult!.similarityScore * 100,
        );
      }
    }

    notifyListeners();
  }

  Future<void> playCustomerResponse(SimulatedCustomerResponse response) async {
    _activeCustomerResponse = response;
    _state = DisclosureState.playingCustomerResponse;
    notifyListeners();

    try {
      await _speechService.speakCustomerPrompt(
        response.spokenText,
        onFinished: () {
          _state = DisclosureState.evaluated;
          notifyListeners();
        },
        onError: (err) {
          _errorMessage = 'Audio playback failed: $err';
          _state = DisclosureState.evaluated;
          notifyListeners();
        },
      );
    } catch (e) {
      _errorMessage = 'Audio playback failed: $e';
      _state = DisclosureState.evaluated;
      notifyListeners();
    }
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

    await _disclosureRepository.saveUserDraft(draft);
    _scripts = await _disclosureRepository.getAllScripts();
    _selectedScript = draft;
    _latestResult = null;
    _currentTranscript = '';
    _state = DisclosureState.idle;
    notifyListeners();
  }

  void cancel() {
    _speechService.cancelListening();
    _speechService.stopSpeaking();
    _state = DisclosureState.idle;
    notifyListeners();
  }

  @override
  void dispose() {
    _speechService.cancelListening();
    _speechService.stopSpeaking();
    super.dispose();
  }
}
