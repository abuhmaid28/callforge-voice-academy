import 'package:callforge/core/evaluation/multi_turn_evaluator.dart';
import 'package:callforge/data/datasources/scenario_catalog.dart';
import 'package:callforge/domain/entities/scenario.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MultiTurnEvaluator Unit Tests', () {
    late Scenario sampleScenario;
    late ScenarioTurn agentTurn;

    setUp(() {
      sampleScenario = ScenarioCatalog.allScenarios.first; // scen-01-first-bill
      // Turn 3: Representative's AERD explanation turn
      agentTurn = sampleScenario.turns.firstWhere(
        (t) => t.turnNumber == 3 && t.speaker == TurnSpeaker.agent,
      );
    });

    test('high AERD and keyword coverage produces target met and high score', () {
      const highQualityAgentResponse =
          'I completely understand your surprise, Marcus. Let me look right into your bill breakdown so you know exactly what is charged and when your ongoing rate applies.';

      final result = MultiTurnEvaluator.evaluateTurn(
        turn: agentTurn,
        agentTranscript: highQualityAgentResponse,
      );

      expect(result.isTargetMet, isTrue);
      expect(result.score, greaterThanOrEqualTo(80.0));
      expect(result.matchedKeywords, contains('understand'));
      expect(result.matchedKeywords, contains('bill'));
      expect(result.aerdBreakdown['A'], isTrue); // Acknowledge
      expect(result.aerdBreakdown['E'], isTrue); // Empathy
      expect(result.aerdBreakdown['D'], isTrue); // Defuse/Discover
      expect(result.nextTurnId, equals('turn-01-04'));
      expect(result.trainerFeedbackArabic, contains('أداء ممتاز'));
    });

    test('cold response missing empathy and required anchors fails target', () {
      const poorAgentResponse =
          'Pay the bill or your service gets disconnected.';

      final result = MultiTurnEvaluator.evaluateTurn(
        turn: agentTurn,
        agentTranscript: poorAgentResponse,
      );

      expect(result.isTargetMet, isFalse);
      expect(result.score, lessThan(50.0));
      expect(result.missingKeywords, isNotEmpty);
      expect(result.aerdBreakdown['E'], isFalse);
      expect(
        result.trainerFeedbackArabic,
        contains('محاولة جيدة، لكن محتاج تركز'),
      );
    });

    test('detects bilabial P/B confusion in agent utterance', () {
      const responseWithPb =
          'I understand your broblem Marcus let me look into your bill breakdown.';

      final result = MultiTurnEvaluator.evaluateTurn(
        turn: agentTurn,
        agentTranscript: responseWithPb,
      );

      expect(result.pbConfusions, isNotEmpty);
      expect(result.pbConfusions.first, contains('broblem'));
      expect(result.trainerFeedbackArabic, contains('انتبه لنطق P و B'));
    });
  });
}
