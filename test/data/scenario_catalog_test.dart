import 'package:callforge/core/evaluation/multi_turn_evaluator.dart';
import 'package:callforge/core/models/provenance.dart';
import 'package:callforge/data/datasources/scenario_catalog.dart';
import 'package:callforge/domain/entities/scenario.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ScenarioCatalog Integrity & Adaptive Branching Tests', () {
    test('catalog contains exactly 30 distinct scenarios', () {
      expect(ScenarioCatalog.allScenarios.length, equals(30));

      final ids = ScenarioCatalog.allScenarios.map((s) => s.id).toSet();
      expect(
        ids.length,
        equals(30),
        reason: 'Every scenario ID must be unique',
      );
    });

    test(
      'all 30 scenarios have non-empty titles, personas, and context notes',
      () {
        for (final s in ScenarioCatalog.allScenarios) {
          expect(s.id, isNotEmpty);
          expect(s.title, isNotEmpty);
          expect(s.customerPersona, isNotEmpty);
          expect(s.contextNotes, isNotEmpty);
          expect(s.expectedResponse, isNotEmpty);
          expect(s.customerResponse, isNotEmpty);
          expect(s.skillTags, isNotEmpty);
          expect(s.category, isNotEmpty);
          expect(s.metadata.provenance, isNotNull);
          expect(
            s.metadata.provenance == ProvenanceTier.fictionalSimulation ||
                s.metadata.provenance == ProvenanceTier.workReported,
            isTrue,
            reason: 'Provenance must be strictly fictional or work-reported',
          );
        }
      },
    );

    test('all 30 scenarios define distinct reachable adaptive branches (success vs objection)', () {
      for (final s in ScenarioCatalog.allScenarios) {
        final turnIds = s.turns.map((t) => t.id).toSet();

        // Turn 1 must be agent greeting
        final turn1 = s.turns.firstWhere((t) => t.turnNumber == 1);
        expect(turn1.speaker, equals(TurnSpeaker.agent));
        expect(turn1.branches, isNotEmpty);

        // Turn 3 must have distinct success and low_aerd branches
        final turn3 = s.turns.firstWhere((t) => t.turnNumber == 3);
        expect(turn3.speaker, equals(TurnSpeaker.agent));
        expect(turn3.branches.length, greaterThanOrEqualTo(2));

        final successBranch = turn3.branches.firstWhere(
          (b) => b.conditionKey == 'success' || b.conditionKey == 'high_aerd',
          orElse: () => throw Exception(
            'Scenario ${s.id} missing success branch on Turn 3',
          ),
        );
        final lowBranch = turn3.branches.firstWhere(
          (b) => b.conditionKey == 'low_aerd' || b.conditionKey == 'objection',
          orElse: () => throw Exception(
            'Scenario ${s.id} missing low_aerd branch on Turn 3',
          ),
        );

        expect(successBranch.nextTurnId, isNot(equals(lowBranch.nextTurnId)));
        expect(turnIds.contains(successBranch.nextTurnId), isTrue);
        expect(turnIds.contains(lowBranch.nextTurnId), isTrue);

        // Turn 4A (Success path) must be customer speaking
        final turn4A = s.turns.firstWhere(
          (t) => t.id == successBranch.nextTurnId,
        );
        expect(turn4A.speaker, equals(TurnSpeaker.customer));
        expect(turn4A.branches, isNotEmpty);

        // Turn 4B (Objection path) must be customer speaking
        final turn4B = s.turns.firstWhere((t) => t.id == lowBranch.nextTurnId);
        expect(turn4B.speaker, equals(TurnSpeaker.customer));
        expect(turn4B.branches, isNotEmpty);

        // Turn 5A and Turn 5B must both be final agent turns
        final turn5AId = turn4A.branches.first.nextTurnId;
        final turn5BId = turn4B.branches.first.nextTurnId;

        final turn5A = s.turns.firstWhere((t) => t.id == turn5AId);
        final turn5B = s.turns.firstWhere((t) => t.id == turn5BId);

        expect(turn5A.isFinal, isTrue);
        expect(turn5A.speaker, equals(TurnSpeaker.agent));
        expect(turn5B.isFinal, isTrue);
        expect(turn5B.speaker, equals(TurnSpeaker.agent));
        expect(turn5A.id, isNot(equals(turn5B.id)));

        // Validate non-empty spokenText and Egyptian Arabic coaching
        for (final t in s.turns) {
          expect(t.spokenText, isNotEmpty);
          expect(t.trainerGuidanceArabic, isNotEmpty);
        }
      }
    });

    test('exhaustive graph reachability: all turns reachable without cycles', () {
      for (final s in ScenarioCatalog.allScenarios) {
        final turnsMap = {for (var t in s.turns) t.id: t};

        // BFS / DFS from turn 1 to find all reachable turns
        final reachable = <String>{};
        final queue = <String>[s.turns.first.id];

        while (queue.isNotEmpty) {
          final currId = queue.removeAt(0);
          if (reachable.contains(currId)) continue;
          reachable.add(currId);

          final turn = turnsMap[currId];
          expect(
            turn,
            isNotNull,
            reason:
                'Turn $currId referenced by branch must exist in scenario ${s.id}',
          );

          if (!turn!.isFinal) {
            for (final b in turn.branches) {
              expect(
                turnsMap.containsKey(b.nextTurnId),
                isTrue,
                reason:
                    'Branch destination ${b.nextTurnId} must exist in scenario ${s.id}',
              );
              queue.add(b.nextTurnId);
            }
          }
        }

        // Verify all turns in the scenario are reachable from root
        expect(
          reachable.length,
          equals(s.turns.length),
          reason:
              'Every turn in scenario ${s.id} must be reachable from turn 1',
        );
      }
    });

    test('end-to-end evaluation across all 30 scenarios routes correctly to 4A or 4B', () {
      for (final s in ScenarioCatalog.allScenarios) {
        final turn3 = s.turns.firstWhere((t) => t.turnNumber == 3);

        // 1. High AERD + matching keyword response should route to success branch (4A)
        final highEval = MultiTurnEvaluator.evaluateTurn(
          turn: turn3,
          agentTranscript: turn3.spokenText,
        );
        expect(
          highEval.isTargetMet,
          isTrue,
          reason: 'Reference spokenText in ${s.id} must meet target',
        );
        expect(
          highEval.nextTurnId,
          contains('04A'),
          reason:
              'Target met in scenario ${s.id} must route to 4A customer success turn',
        );

        // 2. Low AERD / cold rejection response should route to objection branch (4B)
        final lowEval = MultiTurnEvaluator.evaluateTurn(
          turn: turn3,
          agentTranscript:
              'I do not care about your problem, just pay the bill.',
        );
        expect(lowEval.isTargetMet, isFalse);
        expect(
          lowEval.nextTurnId,
          contains('04B'),
          reason:
              'Target unmet in scenario ${s.id} must route to 4B customer objection turn',
        );
      }
    });

    test('allSkillTags extracts complete list of unique tags', () {
      final tags = ScenarioCatalog.allSkillTags;
      expect(tags, isNotEmpty);
      expect(tags.contains('AERD'), isTrue);
      expect(tags.contains('Proration'), isTrue);
    });

    test(
      'findById retrieves scenario correctly or returns null for non-existent',
      () {
        final scenario = ScenarioCatalog.findById('scen-01-first-bill');
        expect(scenario, isNotNull);
        expect(scenario!.title, contains('First Bill'));

        final nonExistent = ScenarioCatalog.findById('does_not_exist');
        expect(nonExistent, isNull);
      },
    );

    test('Policy Guard (B4): all 30 scenarios contain zero unauthorized fee waivers, rate locks, or supervisor callback promises', () {
      for (final s in ScenarioCatalog.allScenarios) {
        for (final turn in s.turns) {
          final textToCheck =
              '${turn.spokenText} ${turn.trainerGuidanceArabic}';

          // Check for explicit prohibited policy phrases in agent and customer utterances
          expect(
            textToCheck.toLowerCase().contains('lock your rate'),
            isFalse,
            reason:
                'Scenario ${s.id} Turn ${turn.id} contains prohibited rate lock promise',
          );
          expect(
            textToCheck.toLowerCase().contains('supervisor will call'),
            isFalse,
            reason:
                'Scenario ${s.id} Turn ${turn.id} contains prohibited supervisor callback promise',
          );
          expect(
            textToCheck.toLowerCase().contains(
              'schedule a supervisor callback',
            ),
            isFalse,
            reason:
                'Scenario ${s.id} Turn ${turn.id} contains prohibited supervisor callback scheduling',
          );
          expect(
            textToCheck.toLowerCase().contains('arrange a supervisor callback'),
            isFalse,
            reason:
                'Scenario ${s.id} Turn ${turn.id} contains prohibited supervisor callback arrangement',
          );
          expect(
            textToCheck.toLowerCase().contains('waiving the activation fee'),
            isFalse,
            reason:
                'Scenario ${s.id} Turn ${turn.id} contains unauthorized activation fee waiver',
          );
          expect(
            textToCheck.toLowerCase().contains('waive your activation fee'),
            isFalse,
            reason:
                'Scenario ${s.id} Turn ${turn.id} contains unauthorized activation fee waiver',
          );
          expect(
            textToCheck.toLowerCase().contains(
              'guaranteed that your replacement is completely free',
            ),
            isFalse,
            reason:
                'Scenario ${s.id} Turn ${turn.id} contains unauthorized replacement guarantee',
          );
        }
      }
    });
  });
}
