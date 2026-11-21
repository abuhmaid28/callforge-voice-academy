import 'package:callforge/core/audio/mock_speech_service.dart';
import 'package:callforge/data/datasources/progress_local_datasource.dart';
import 'package:callforge/data/datasources/scenario_catalog.dart';
import 'package:callforge/data/repositories/progress_repository_impl.dart';
import 'package:callforge/domain/entities/scenario.dart';
import 'package:callforge/presentation/controllers/multi_turn_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('MultiTurnController Tests', () {
    late MockSpeechService mockSpeech;
    late ProgressRepositoryImpl progressRepo;
    late MultiTurnController controller;
    late Scenario scenario;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      mockSpeech = MockSpeechService();
      progressRepo = ProgressRepositoryImpl(ProgressLocalDataSource(prefs));

      controller = MultiTurnController(
        speechService: mockSpeech,
        progressRepository: progressRepo,
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

    test('retryCurrentTurn resets live transcript and idle state', () {
      controller.startScenario(scenario);
      controller.retryCurrentTurn();

      expect(controller.liveTranscript, isEmpty);
      expect(controller.latestEvaluation, isNull);
      expect(controller.state, equals(MultiTurnState.idle));
    });
  });
}
