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

    test('48 Scenarios: All 48 scenarios execute through SalesSimulatorController on Path B (Decline -> Respectful No-Sale)', () async {
      final mockSpeech = MockSpeechService();
      final allScenarios = SalesScenarioCatalog.allScenarios;

      for (final scenario in allScenarios) {
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
          await Future.delayed(const Duration(milliseconds: 15));
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

    test('48 Scenarios: All 48 scenarios execute through SalesSimulatorController on Path C (Clarification -> Needs Verification)', () async {
      final mockSpeech = MockSpeechService();
      final allScenarios = SalesScenarioCatalog.allScenarios;

      for (final scenario in allScenarios) {
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
            mockSpeech.simulatedTranscript = 'I understand. Let me verify your account permissions and check your address and eligibility status first before looking into any plan changes.';
          }
          await controller.startListening();
          await controller.stopListening();
          await Future.delayed(const Duration(milliseconds: 15));
        }

        expect(
          controller.isCallCompleted,
          isTrue,
          reason: '${scenario.id} did not complete on verification path',
        );
        expect(
          controller.latestScorecard?.outcomeType,
          equals(SalesOutcomeType.needsVerification),
          reason:
              '${scenario.id} must conclude with needsVerification on account check path',
        );

        controller.dispose();
      }
    });

    test('48 Scenarios: All 48 scenarios execute through SalesSimulatorController on Path A (Offer + Disclosures -> Qualified Accept)', () async {
      final mockSpeech = MockSpeechService();
      final allScenarios = SalesScenarioCatalog.allScenarios;

      for (final scenario in allScenarios) {
        final controller = SalesSimulatorController(speechService: mockSpeech);
        controller.startScenario(scenario);

        int safetySteps = 0;
        while (!controller.isCallCompleted &&
            controller.currentTurn != null &&
            safetySteps < 12) {
          safetySteps++;
          final turn = controller.currentTurn!;
          if (turn.phase == SalesPhase.greeting) {
            mockSpeech.simulatedTranscript = 'Hello thank you for calling AT&T this is Alex may I have your first and last name please';
          } else {
            // Supply turn model response + required keywords + mandatory disclosures + eligibility verification to fulfill closing terms
            final modelResp = turn.usEnglishModelResponse;
            final keywords = turn.requiredKeywords.join(' ');
            final disclosures = scenario.mandatoryDisclosures.join(' ');
            mockSpeech.simulatedTranscript =
                '$modelResp $keywords $disclosures Your address qualifies for fiber availability, device condition is verified, and number porting is confirmed. Under this simulated plan change would you like to proceed with this offer?';
          }
          await controller.startListening();
          await controller.stopListening();
          await Future.delayed(const Duration(milliseconds: 15));
        }

        expect(
          controller.isCallCompleted,
          isTrue,
          reason: '${scenario.id} did not complete on accept path',
        );
        expect(
          controller.latestScorecard?.outcomeType,
          equals(SalesOutcomeType.qualifiedAccept),
          reason:
              '${scenario.id} must conclude with qualifiedAccept when disclosures and consent are covered',
        );

        controller.dispose();
      }
    });

    test('48 Scenarios: Omitting mandatory disclosures strictly downgrades Path A to needsVerification', () async {
      final mockSpeech = MockSpeechService();
      final allScenarios = SalesScenarioCatalog.allScenarios;

      for (final scenario in allScenarios) {
        final controller = SalesSimulatorController(speechService: mockSpeech);
        controller.startScenario(scenario);

        int safetySteps = 0;
        while (!controller.isCallCompleted &&
            controller.currentTurn != null &&
            safetySteps < 12) {
          safetySteps++;
          final turn = controller.currentTurn!;
          if (turn.phase == SalesPhase.greeting) {
            mockSpeech.simulatedTranscript = 'Hello thank you for calling AT&T this is Alex may I have your first and last name please';
          } else {
            // Only generic conversational words with NO mandatory disclosures
            mockSpeech.simulatedTranscript = 'I recommend our upgrade plan option device. It is really great and fits your budget. Would you like to proceed?';
          }
          await controller.startListening();
          await controller.stopListening();
          await Future.delayed(const Duration(milliseconds: 15));
        }

        expect(
          controller.isCallCompleted,
          isTrue,
          reason: '${scenario.id} did not complete',
        );
        expect(
          controller.latestScorecard?.outcomeType,
          equals(SalesOutcomeType.needsVerification),
          reason:
              '${scenario.id} without mandatory disclosures must downgrade to needsVerification',
        );

        controller.dispose();
      }
    });
  });
}
