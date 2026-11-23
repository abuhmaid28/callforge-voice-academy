import 'package:callforge/core/audio/mock_speech_service.dart';
import 'package:callforge/data/datasources/sales_scenario_catalog.dart';
import 'package:callforge/domain/entities/sales_scenario.dart';
import 'package:callforge/presentation/controllers/sales_simulator_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('All 48 Sales Scenarios Graph Reachability & Trajectory Tests (A5)', () {
    test('48 Scenarios: zero dead ends, valid branch targets, and cycle safety', () {
      final allScenarios = SalesScenarioCatalog.allScenarios;
      expect(allScenarios.length, equals(48));

      for (final scenario in allScenarios) {
        final turnMap = {for (final t in scenario.turns) t.id: t};

        // Root turn must be first turn
        final root = scenario.turns.first;
        expect(root.phase, equals(SalesPhase.greeting));

        // Validate each turn's branches
        for (final turn in scenario.turns) {
          if (turn.isFinal) {
            expect(
              turn.resultingOutcome,
              isNotNull,
              reason:
                  '${scenario.id} final turn ${turn.id} must have a resultingOutcome',
            );
          } else {
            expect(
              turn.branches.isNotEmpty,
              isTrue,
              reason:
                  '${scenario.id} non-final turn ${turn.id} must have outgoing branches',
            );
            for (final branch in turn.branches) {
              expect(
                turnMap.containsKey(branch.nextTurnId),
                isTrue,
                reason:
                    '${scenario.id} branch points to unknown turn ${branch.nextTurnId}',
              );
            }
          }
        }

        // Detect infinite cycles using DFS
        final visited = <String>{};
        final recStack = <String>{};

        bool hasCycle(String turnId) {
          visited.add(turnId);
          recStack.add(turnId);

          final turn = turnMap[turnId];
          if (turn != null && !turn.isFinal) {
            for (final branch in turn.branches) {
              if (!visited.contains(branch.nextTurnId)) {
                if (hasCycle(branch.nextTurnId)) return true;
              } else if (recStack.contains(branch.nextTurnId)) {
                return true; // Cycle detected
              }
            }
          }

          recStack.remove(turnId);
          return false;
        }

        expect(
          hasCycle(root.id),
          isFalse,
          reason: '${scenario.id} contains an infinite loop/cycle',
        );
      }
    });

    test('48 Scenarios: All 3 terminal outcomes are reachable from root via directed paths', () {
      final allScenarios = SalesScenarioCatalog.allScenarios;

      for (final scenario in allScenarios) {
        final turnMap = {for (final t in scenario.turns) t.id: t};
        final root = scenario.turns.first;

        // Traverse all paths from root
        final reachableOutcomes = <SalesOutcomeType>{};

        void traverse(String turnId, Set<String> currentPath) {
          final turn = turnMap[turnId];
          if (turn == null) return;

          if (turn.isFinal && turn.resultingOutcome != null) {
            reachableOutcomes.add(turn.resultingOutcome!);
            return;
          }

          for (final branch in turn.branches) {
            if (!currentPath.contains(branch.nextTurnId)) {
              traverse(branch.nextTurnId, {...currentPath, turnId});
            }
          }
        }

        traverse(root.id, {});

        expect(
          reachableOutcomes.contains(SalesOutcomeType.qualifiedAccept),
          isTrue,
          reason: '${scenario.id} qualifiedAccept is not reachable from root',
        );
        expect(
          reachableOutcomes.contains(SalesOutcomeType.respectfulNoSale),
          isTrue,
          reason: '${scenario.id} respectfulNoSale is not reachable from root',
        );
        expect(
          reachableOutcomes.contains(SalesOutcomeType.needsVerification),
          isTrue,
          reason: '${scenario.id} needsVerification is not reachable from root',
        );
      }
    });

    test('48 Scenarios: All 48 scenarios execute through SalesSimulatorController to reach qualified outcomes', () async {
      final mockSpeech = MockSpeechService();
      final allScenarios = SalesScenarioCatalog.allScenarios;

      for (final scenario in allScenarios) {
        // Path B: Respectful No-Sale
        final controller = SalesSimulatorController(speechService: mockSpeech);
        controller.startScenario(scenario);

        int safetySteps = 0;
        while (!controller.isCallCompleted &&
            controller.currentTurn != null &&
            safetySteps < 12) {
          safetySteps++;
          if (controller.currentTurn!.phase == SalesPhase.greeting) {
            mockSpeech.simulatedTranscript = 'Hello thank you for calling AT&T this is Alex may I have your first and last name please';
          } else {
            mockSpeech.simulatedTranscript = 'I completely understand and respect your decision. We will keep your account on the current plan and leave your service with no changes.';
          }
          await controller.startListening();
          await controller.stopListening();
          await Future.delayed(const Duration(milliseconds: 25));
        }

        expect(
          controller.isCallCompleted,
          isTrue,
          reason: '${scenario.id} did not complete on decline path',
        );
        expect(
          controller.latestScorecard?.outcomeType,
          anyOf(
            SalesOutcomeType.respectfulNoSale,
            SalesOutcomeType.needsVerification,
          ),
          reason:
              '${scenario.id} must conclude with ethical closure or verification',
        );

        controller.dispose();
      }
    });
  });
}
