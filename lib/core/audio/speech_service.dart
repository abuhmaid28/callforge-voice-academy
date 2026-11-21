import 'dart:async';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
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
  Future<void> cancelListening();
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
  String _latestRecognizedWords = '';
  bool _hasDeliveredFinalResult = false;
  Timer? _watchdogTimer;

  Function(String error)? _activeOnError;
  ResultCallback? _activeOnResult;

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
    if (_isInitialized) return;

    // Configure Text-To-Speech for American English Customer
    try {
      await _tts.setLanguage('en-US');
      await _tts.setSpeechRate(0.50);
      await _tts.setPitch(1.0);
      await _tts.awaitSpeakCompletion(true);
    } catch (_) {
      // Best-effort initialization on host
    }

    // Configure Speech-To-Text with robust error and status handlers
    try {
      final available = await _stt.initialize(
        onError: _handleSpeechError,
        onStatus: _handleSpeechStatus,
      );
      _isInitialized = available;
    } catch (_) {
      _isInitialized = false;
    }
  }

  void _handleSpeechError(SpeechRecognitionError error) {
    _watchdogTimer?.cancel();
    final errorMsg = _translateSpeechError(error.errorMsg);
    _setState(VoiceEngineState.error);
    if (_activeOnError != null) {
      _activeOnError!(errorMsg);
    }
  }

  void _handleSpeechStatus(String status) {
    if (status == 'done' || status == 'notListening') {
      if (_state == VoiceEngineState.listeningToUser) {
        _setState(VoiceEngineState.processing);

        // Watchdog: If engine stopped without firing finalResult, resolve with latest words
        _watchdogTimer?.cancel();
        _watchdogTimer = Timer(const Duration(milliseconds: 600), () {
          if (!_hasDeliveredFinalResult &&
              _state == VoiceEngineState.processing) {
            _deliverFinalTranscript();
          }
        });
      }
    }
  }

  String _translateSpeechError(String rawError) {
    final lower = rawError.toLowerCase();
    if (lower.contains('timeout') || lower.contains('no_match')) {
      return 'No speech detected. Please speak clearly into the microphone.';
    }
    if (lower.contains('network') || lower.contains('server')) {
      return 'Offline speech recognition model not available. To use speech offline, install English (US) in Android Settings > Google > Speech Services, or connect to the internet.';
    }
    if (lower.contains('busy') ||
        lower.contains('audio') ||
        lower.contains('client')) {
      return 'Speech audio subsystem is currently busy. Please tap to retry.';
    }
    return 'Speech recognition error: $rawError';
  }

  void _deliverFinalTranscript() {
    _watchdogTimer?.cancel();
    _hasDeliveredFinalResult = true;

    final transcript = _latestRecognizedWords.trim();
    if (transcript.isEmpty) {
      _setState(VoiceEngineState.idle);
      if (_activeOnError != null) {
        _activeOnError!(
          'No speech was captured. Please tap the mic and try again.',
        );
      }
    } else {
      _setState(VoiceEngineState.processing);
      if (_activeOnResult != null) {
        _activeOnResult!(transcript);
      }
      _setState(VoiceEngineState.idle);
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

    _activeOnResult = onResult;
    _activeOnError = onError;
    _latestRecognizedWords = '';
    _hasDeliveredFinalResult = false;
    _watchdogTimer?.cancel();

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
          _latestRecognizedWords = result.recognizedWords;
          if (!_transcriptController.isClosed) {
            _transcriptController.add(result.recognizedWords);
          }
          if (result.finalResult) {
            _deliverFinalTranscript();
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
        onError('Error initializing microphone listener: $e');
      }
    }
  }

  @override
  Future<void> stopListening() async {
    _watchdogTimer?.cancel();
    try {
      await _stt.stop();
    } catch (_) {}
    if (_state == VoiceEngineState.listeningToUser) {
      // If words were captured before user tapped stop, deliver them
      if (!_hasDeliveredFinalResult && _latestRecognizedWords.isNotEmpty) {
        _deliverFinalTranscript();
      } else {
        _setState(VoiceEngineState.idle);
      }
    }
  }

  @override
  Future<void> cancelListening() async {
    _watchdogTimer?.cancel();
    _hasDeliveredFinalResult = true;
    _latestRecognizedWords = '';
    try {
      await _stt.cancel();
    } catch (_) {}
    _setState(VoiceEngineState.idle);
  }

  @override
  void dispose() {
    _watchdogTimer?.cancel();
    stopSpeaking();
    cancelListening();
    _stateController.close();
    _transcriptController.close();
  }
}
