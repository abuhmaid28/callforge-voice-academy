import 'package:callforge/core/audio/mock_speech_service.dart';
import 'package:callforge/data/datasources/attempt_local_datasource.dart';
import 'package:callforge/data/datasources/progress_local_datasource.dart';
import 'package:callforge/data/datasources/scenario_catalog.dart';
import 'package:callforge/data/repositories/attempt_repository_impl.dart';
import 'package:callforge/data/repositories/progress_repository_impl.dart';
import 'package:callforge/domain/entities/scenario.dart';
import 'package:callforge/domain/repositories/attempt_repository.dart';
import 'package:callforge/presentation/controllers/multi_turn_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('MultiTurnController Tests', () {
    late MockSpeechService mockSpeech;
    late ProgressRepositoryImpl progressRepo;
    late IAttemptRepository attemptRepo;
    late MultiTurnController controller;
    late Scenario scenario;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      mockSpeech = MockSpeechService();
      progressRepo = ProgressRepositoryImpl(ProgressLocalDataSource(prefs));
      attemptRepo = AttemptRepositoryImpl(AttemptLocalDataSource(prefs));

      controller = MultiTurnController(
        speechService: mockSpeech,
        progressRepository: progressRepo,
        attemptRepository: attemptRepo,
      );

      scenario = ScenarioCatalog.allScenarios.first; // scen-01-first-bill
    });

    tearDown(() {
      controller.dispose();
    });

    test('startScenario initializes call with turn 1 (agent greeting)', () {
      controller.startScenario(scenario);

      expect(controller.activeScenario, equals(scenario));
      expect(controller.currentTurn, isNotNull);
      expect(controller.currentTurn!.turnNumber, equals(1));
      expect(controller.currentTurn!.speaker, equals(TurnSpeaker.agent));
      expect(controller.state, equals(MultiTurnState.idle));
    });

    test('startAgentListening and evaluate processes greeting turn', () async {
      controller.startScenario(scenario);

      mockSpeech.simulatedTranscript = 'Hello thank you for calling AT&T. This is Alex. May I have your first and last name please?';

      await controller.startAgentListening();
      expect(controller.state, equals(MultiTurnState.agentListening));

      await controller.stopAgentListeningAndEvaluate();

      expect(controller.conversationHistory, isNotEmpty);
      expect(
        controller.conversationHistory.first.speaker,
        equals(TurnSpeaker.agent),
      );
      expect(controller.latestEvaluation, isNotNull);
      expect(controller.latestEvaluation!.isTargetMet, isTrue);
    });

    test('Gate B1: missing Alex or AT&T on Turn 1 blocks advancement to customer Turn 2', () async {
      controller.startScenario(scenario);

      // Cold greeting missing Alex and AT&T
      mockSpeech.simulatedTranscript =
          'Hello what is your name and how can I help you today?';

      await controller.startAgentListening();
      await controller.stopAgentListeningAndEvaluate();

      // Must remain on Turn 1 in idle state
      expect(controller.latestEvaluation, isNotNull);
      expect(controller.latestEvaluation!.isTargetMet, isFalse);
      expect(controller.currentTurn!.turnNumber, equals(1));
      expect(controller.state, equals(MultiTurnState.idle));
      expect(controller.isCallCompleted, isFalse);

      // Customer Turn 2 must NOT have played
      expect(
        controller.conversationHistory.any(
          (t) => t.speaker == TurnSpeaker.customer,
        ),
        isFalse,
      );
    });

    test(
      'Gate B1: empty audio on Turn 1 remains on Turn 1 in idle state',
      () async {
        controller.startScenario(scenario);

        mockSpeech.simulatedTranscript = '';

        await controller.startAgentListening();
        await controller.stopAgentListeningAndEvaluate();

        expect(controller.latestEvaluation, isNotNull);
        expect(controller.latestEvaluation!.isTargetMet, isFalse);
        expect(controller.currentTurn!.turnNumber, equals(1));
        expect(controller.state, equals(MultiTurnState.idle));
        expect(controller.isCallCompleted, isFalse);
      },
    );

    test('Gate B2 & B5: failed final turn does not complete call; retry and success records once with versioned attempt', () async {
      controller.startScenario(scenario);

      // Turn 1: Pass
      mockSpeech.simulatedTranscript = 'Hello thank you for calling AT&T. This is Alex. May I have your first and last name please?';
      await controller.startAgentListening();
      await controller.stopAgentListeningAndEvaluate();
      expect(controller.latestEvaluation!.isTargetMet, isTrue);
      await Future.delayed(const Duration(milliseconds: 50));

      // Turn 3: High AERD and all required keywords for Turn 3
      mockSpeech.simulatedTranscript = 'I completely understand your surprise, Marcus. Let me look right into your bill breakdown so you know exactly what is charged and when your ongoing rate applies.';
      await controller.startAgentListening();
      await controller.stopAgentListeningAndEvaluate();
      await Future.delayed(const Duration(milliseconds: 50));

      // Now on final turn (Turn 5A)
      expect(controller.currentTurn!.id, equals('turn-01-05A'));
      expect(controller.currentTurn!.isFinal, isTrue);

      // Fail final turn (empty audio)
      mockSpeech.simulatedTranscript = '';
      await controller.startAgentListening();
      await controller.stopAgentListeningAndEvaluate();

      // Verify call is NOT completed and progress is NOT recorded
      expect(controller.isCallCompleted, isFalse);
      var progress = await progressRepo.loadProgress();
      expect(progress.totalSimulationsCompleted, equals(0));

      // Retry final turn with successful recap
      mockSpeech.simulatedTranscript = 'Exactly Marcus, once your autopay discount applies, your regular monthly bill will be 140 dollars. Is there anything else I can assist you with today?';
      await controller.startAgentListening();
      await controller.stopAgentListeningAndEvaluate();

      // Now call completes successfully
      expect(controller.isCallCompleted, isTrue);
      await Future.delayed(const Duration(milliseconds: 20));
      progress = await progressRepo.loadProgress();
      expect(progress.totalSimulationsCompleted, equals(1));
      expect(progress.completedScenarioIds, contains(scenario.id));

      // Versioned attempt record is persisted
      final attempts = await attemptRepo.getAttempts();
      expect(attempts, isNotEmpty);
      final scenarioAttempt = attempts.firstWhere(
        (a) => a.scenarioId == scenario.id,
      );
      expect(scenarioAttempt.scriptTitle, equals(scenario.title));
      expect(scenarioAttempt.attemptType, equals('scenario'));
      expect(scenarioAttempt.passed, isTrue);
    });

    test('retryCurrentTurn resets live transcript and idle state', () {
      controller.startScenario(scenario);
      controller.retryCurrentTurn();

      expect(controller.liveTranscript, isEmpty);
      expect(controller.latestEvaluation, isNull);
      expect(controller.state, equals(MultiTurnState.idle));
    });
  });
}
