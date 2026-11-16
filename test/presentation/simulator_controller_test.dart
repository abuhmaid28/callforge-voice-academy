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

  group('SimulatorController Tests', () {
    test('initializes with idle state and loads empty history', () {
      expect(controller.engineState, equals(VoiceEngineState.idle));
      expect(controller.hasEvaluation, isFalse);
      expect(controller.liveTranscript, isEmpty);
      expect(controller.bestScore, isNull);
    });

    test('plays customer prompt and completes cleanly', () async {
      await controller.playCustomerPrompt();
      expect(controller.engineState, equals(VoiceEngineState.idle));
    });

    test(
      'processes spoken greeting, evaluates, and persists attempt',
      () async {
        mockSpeech.simulatedTranscript = TrainingConstants.standardGreeting;

        await controller.startListening();

        expect(controller.hasEvaluation, isTrue);
        expect(controller.evaluationResult!.passed, isTrue);
        expect(controller.evaluationResult!.accuracyPercentage, equals(100));
        expect(controller.bestScore, equals(100));
        expect(controller.recentAttempts.length, equals(1));
      },
    );

    test('retry clears live transcript and evaluation state', () async {
      mockSpeech.simulatedTranscript = TrainingConstants.standardGreeting;
      await controller.startListening();
      expect(controller.hasEvaluation, isTrue);

      controller.retry();

      expect(controller.hasEvaluation, isFalse);
      expect(controller.liveTranscript, isEmpty);
    });

    test('handles microphone permission failure gracefully', () async {
      mockSpeech.shouldFailMic = true;
      await controller.startListening();

      expect(controller.errorMessage, contains('permission denied'));
      expect(controller.engineState, equals(VoiceEngineState.error));
    });
  });
}
