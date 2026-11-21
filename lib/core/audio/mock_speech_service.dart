import 'dart:async';

import 'speech_service.dart';

/// Predictable mock implementation of [ISpeechService] for testing and simulation.
class MockSpeechService implements ISpeechService {
  final _stateController = StreamController<VoiceEngineState>.broadcast();
  final _transcriptController = StreamController<String>.broadcast();

  VoiceEngineState _state = VoiceEngineState.idle;
  String simulatedTranscript = '';
  bool shouldFailMic = false;
  bool shouldFailNetwork = false;
  bool shouldFailInit = false;
  bool shouldTimeoutWithSilence = false;
  bool shouldFailTts = false;
  int _sessionGeneration = 0;

  @override
  VoiceEngineState get state => _state;

  @override
  Stream<VoiceEngineState> get stateStream => _stateController.stream;

  @override
  Stream<String> get partialTranscriptStream => _transcriptController.stream;

  void _setState(VoiceEngineState newState) {
    _state = newState;
    if (!_stateController.isClosed) {
      _stateController.add(newState);
    }
  }

  @override
  Future<void> initialize() async {
    if (shouldFailInit) {
      _setState(VoiceEngineState.error);
      return;
    }
    _setState(VoiceEngineState.idle);
  }

  @override
  Future<void> speakCustomerPrompt(
    String text, {
    VoidCallback? onFinished,
    Function(String error)? onError,
  }) async {
    _setState(VoiceEngineState.customerSpeaking);
    await Future.delayed(const Duration(milliseconds: 20));

    if (shouldFailTts) {
      _setState(VoiceEngineState.error);
      if (onError != null) {
        onError('Simulated TTS playback failure');
      }
      return;
    }

    _setState(VoiceEngineState.idle);
    if (onFinished != null) onFinished();
  }

  @override
  Future<void> stopSpeaking() async {
    if (_state == VoiceEngineState.customerSpeaking) {
      _setState(VoiceEngineState.idle);
    }
  }

  @override
  Future<void> startListening({
    required ResultCallback onResult,
    Function(String error)? onError,
  }) async {
    _sessionGeneration++;
    final currentSession = _sessionGeneration;

    if (shouldFailMic) {
      _setState(VoiceEngineState.error);
      if (onError != null) {
        onError('Microphone permission is required to practice spoken calls.');
      }
      return;
    }

    if (shouldFailNetwork) {
      _setState(VoiceEngineState.error);
      if (onError != null) {
        onError(
          'Offline speech recognition model not available. To use speech offline, install English (US) in Android Settings > Google > Speech Services, or connect to the internet.',
        );
      }
      return;
    }

    if (shouldTimeoutWithSilence) {
      _setState(VoiceEngineState.listeningToUser);
      await Future.delayed(const Duration(milliseconds: 20));
      if (currentSession == _sessionGeneration) {
        _setState(VoiceEngineState.idle);
        if (onError != null) {
          onError('No speech was captured. Please tap the mic and try again.');
        }
      }
      return;
    }

    _setState(VoiceEngineState.listeningToUser);
    if (!_transcriptController.isClosed) {
      _transcriptController.add(simulatedTranscript);
    }

    // Simulate completion
    await Future.delayed(const Duration(milliseconds: 20));
    if (currentSession != _sessionGeneration) return;

    _setState(VoiceEngineState.processing);
    await onResult(simulatedTranscript);
    if (currentSession == _sessionGeneration) {
      _setState(VoiceEngineState.idle);
    }
  }

  @override
  Future<void> stopListening() async {
    if (_state == VoiceEngineState.listeningToUser) {
      _setState(VoiceEngineState.idle);
    }
  }

  @override
  Future<void> cancelListening() async {
    _sessionGeneration++;
    if (_state == VoiceEngineState.listeningToUser) {
      _setState(VoiceEngineState.idle);
    }
  }

  @override
  void dispose() {
    _sessionGeneration++;
    _stateController.close();
    _transcriptController.close();
  }
}
