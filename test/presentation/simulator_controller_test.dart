import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:callforge/core/audio/mock_speech_service.dart';
import 'package:callforge/core/audio/speech_service.dart';
import 'package:callforge/core/constants/training_constants.dart';
import 'package:callforge/data/datasources/attempt_local_datasource.dart';
import 'package:callforge/data/repositories/attempt_repository_impl.dart';
import 'package:callforge/presentation/controllers/simulator_controller.dart';

void main() {
  late MockSpeechService mockSpeech;
  late AttemptRepositoryImpl repository;
  late SimulatorController controller;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    repository = AttemptRepositoryImpl(AttemptLocalDataSource(prefs));
    mockSpeech = MockSpeechService();
    controller = SimulatorController(
      speechService: mockSpeech,
      repository: repository,
    );
    await controller.initialize();
  });

  tearDown(() {
    controller.dispose();
  });

  group('SimulatorController Tests & Inbound Audio Lifecycle', () {
    test('initializes with idle state and loads empty history', () {
      expect(controller.engineState, equals(VoiceEngineState.idle));
      expect(controller.hasEvaluation, isFalse);
      expect(controller.liveTranscript, isEmpty);
      expect(controller.bestScore, isNull);
    });

    test('plays customer response audio and completes cleanly', () async {
      await controller.playCustomerResponse();
      expect(controller.engineState, equals(VoiceEngineState.idle));
    });

    test('processes spoken greeting, evaluates, persists attempt, and triggers customer response on target met', () async {
      mockSpeech.simulatedTranscript = TrainingConstants.standardGreeting;

      await controller.startListening();

      expect(controller.hasEvaluation, isTrue);
      expect(controller.evaluationResult!.scriptTargetMet, isTrue);
      expect(controller.evaluationResult!.isVerbatimMatch, isTrue);
      expect(controller.evaluationResult!.similarityPercentage, equals(100));
      expect(controller.bestScore, equals(100));
      expect(controller.recentAttempts.length, equals(1));
      expect(controller.hasTargetMet, isTrue);
    });

    test(
      'retry clears live transcript, evaluation state, and stops audio',
      () async {
        mockSpeech.simulatedTranscript = TrainingConstants.standardGreeting;
        await controller.startListening();
        expect(controller.hasEvaluation, isTrue);

        controller.retry();

        expect(controller.hasEvaluation, isFalse);
        expect(controller.liveTranscript, isEmpty);
        expect(controller.errorMessage, isNull);
      },
    );

    test('cancelListening resets listening state without throwing', () async {
      await controller.cancelListening();
      expect(controller.engineState, equals(VoiceEngineState.idle));
      expect(controller.liveTranscript, isEmpty);
    });

    test('handles microphone permission failure gracefully', () async {
      mockSpeech.shouldFailMic = true;
      await controller.startListening();

      expect(controller.errorMessage, contains('Microphone permission'));
      expect(controller.engineState, equals(VoiceEngineState.error));
    });

    test(
      'handles offline/network required error with explicit user guidance',
      () async {
        mockSpeech.shouldFailNetwork = true;
        await controller.startListening();

        expect(
          controller.errorMessage,
          contains('Offline speech recognition model not available'),
        );
        expect(controller.engineState, equals(VoiceEngineState.error));
      },
    );

    test('handles silence timeout gracefully without crashing', () async {
      mockSpeech.shouldTimeoutWithSilence = true;
      await controller.startListening();

      expect(controller.errorMessage, contains('No speech was captured'));
      expect(controller.engineState, equals(VoiceEngineState.idle));
    });

    test(
      'handles TTS customer speech playback failure without false completion',
      () async {
        mockSpeech.shouldFailTts = true;
        await controller.playCustomerResponse();

        expect(
          controller.errorMessage,
          contains('Simulated TTS playback failure'),
        );
        expect(controller.engineState, equals(VoiceEngineState.error));
      },
    );

    test(
      'cancels active speech session and ignores stale completion',
      () async {
        mockSpeech.simulatedTranscript = TrainingConstants.standardGreeting;
        final listenFuture = controller.startListening();
        await controller.cancelListening();
        await listenFuture;

        expect(controller.engineState, equals(VoiceEngineState.idle));
        expect(controller.hasEvaluation, isFalse);
        expect(controller.recentAttempts, isEmpty);
      },
    );
  });
}
