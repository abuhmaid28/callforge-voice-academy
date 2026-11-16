import 'dart:async';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

/// Current operational state of the voice engine
enum VoiceEngineState {
  idle,
  customerSpeaking,
  listeningToUser,
  processing,
  error,
}

typedef VoidCallback = void Function();
typedef ResultCallback = FutureOr<void> Function(String transcript);

/// Abstract contract for voice synthesis and recognition
abstract class ISpeechService {
  VoiceEngineState get state;
  Stream<VoiceEngineState> get stateStream;
  Stream<String> get partialTranscriptStream;

  Future<void> initialize();
  Future<void> speakCustomerPrompt(String text, {VoidCallback? onFinished});
  Future<void> stopSpeaking();
  Future<void> startListening({
    required ResultCallback onResult,
    Function(String error)? onError,
  });
  Future<void> stopListening();
  void dispose();
}

/// Native Android implementation using FlutterTts & SpeechToText
class NativeSpeechService implements ISpeechService {
  final FlutterTts _tts = FlutterTts();
  final stt.SpeechToText _stt = stt.SpeechToText();

  final _stateController = StreamController<VoiceEngineState>.broadcast();
  final _transcriptController = StreamController<String>.broadcast();

  VoiceEngineState _state = VoiceEngineState.idle;
  bool _isInitialized = false;

  @override
  VoiceEngineState get state => _state;

  @override
  Stream<VoiceEngineState> get stateStream => _stateController.stream;

  @override
  Stream<String> get partialTranscriptStream => _transcriptController.stream;

  void _setState(VoiceEngineState newState) {
    _state = newState;
    _stateController.add(newState);
  }

  @override
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Configure Text-To-Speech for American English Customer
    try {
      await _tts.setLanguage('en-US');
      await _tts.setSpeechRate(0.50);
      await _tts.setPitch(1.0);
      await _tts.awaitSpeakCompletion(true);
    } catch (_) {
      // Best-effort initialization on non-mobile or headless host
    }

    // Configure Speech-To-Text
    try {
      final available = await _stt.initialize(
        onError: (val) {
          _setState(VoiceEngineState.idle);
        },
        onStatus: (status) {
          if (status == 'done' || status == 'notListening') {
            if (_state == VoiceEngineState.listeningToUser) {
              _setState(VoiceEngineState.processing);
            }
          }
        },
      );
      _isInitialized = available;
    } catch (_) {
      _isInitialized = false;
    }
  }

  @override
  Future<void> speakCustomerPrompt(
    String text, {
    VoidCallback? onFinished,
  }) async {
    try {
      await stopListening();
      _setState(VoiceEngineState.customerSpeaking);

      _tts.setCompletionHandler(() {
        _setState(VoiceEngineState.idle);
        if (onFinished != null) onFinished();
      });

      _tts.setErrorHandler((msg) {
        _setState(VoiceEngineState.error);
        if (onFinished != null) onFinished();
      });

      await _tts.speak(text);
    } catch (e) {
      _setState(VoiceEngineState.error);
      if (onFinished != null) onFinished();
    }
  }

  @override
  Future<void> stopSpeaking() async {
    try {
      await _tts.stop();
    } catch (_) {}
    if (_state == VoiceEngineState.customerSpeaking) {
      _setState(VoiceEngineState.idle);
    }
  }

  @override
  Future<void> startListening({
    required ResultCallback onResult,
    Function(String error)? onError,
  }) async {
    await stopSpeaking();

    // Check runtime microphone permissions
    final status = await Permission.microphone.request();
    if (status.isDenied || status.isPermanentlyDenied) {
      _setState(VoiceEngineState.error);
      if (onError != null) {
        onError('Microphone permission is required to practice spoken calls.');
      }
      return;
    }

    if (!_isInitialized) {
      await initialize();
    }

    if (!_isInitialized) {
      _setState(VoiceEngineState.error);
      if (onError != null) {
        onError('Speech recognition engine is unavailable on this device.');
      }
      return;
    }

    _setState(VoiceEngineState.listeningToUser);

    try {
      await _stt.listen(
        onResult: (result) {
          _transcriptController.add(result.recognizedWords);
          if (result.finalResult) {
            _setState(VoiceEngineState.processing);
            onResult(result.recognizedWords);
          }
        },
        listenOptions: stt.SpeechListenOptions(
          listenMode: stt.ListenMode.confirmation,
          pauseFor: const Duration(seconds: 3),
          localeId: 'en_US',
        ),
      );
    } catch (e) {
      _setState(VoiceEngineState.error);
      if (onError != null) {
        onError('Error listening: $e');
      }
    }
  }

  @override
  Future<void> stopListening() async {
    try {
      await _stt.stop();
    } catch (_) {}
    if (_state == VoiceEngineState.listeningToUser) {
      _setState(VoiceEngineState.idle);
    }
  }

  @override
  void dispose() {
    stopSpeaking();
    stopListening();
    _stateController.close();
    _transcriptController.close();
  }
}
