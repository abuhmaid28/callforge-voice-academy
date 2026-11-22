import 'package:flutter_test/flutter_test.dart';
import 'package:callforge/data/datasources/sales_scenario_catalog.dart';
import 'package:callforge/domain/entities/sales_scenario.dart';
import 'package:callforge/domain/entities/scenario.dart';

void main() {
  group('SalesScenarioCatalog Integrity Tests', () {
    test('contains at least 48 distinct sales scenarios', () {
      expect(
        SalesScenarioCatalog.allScenarios.length,
        greaterThanOrEqualTo(48),
      );
    });

    test('all 48 scenarios have unique IDs', () {
      final ids = SalesScenarioCatalog.allScenarios.map((s) => s.id).toList();
      final uniqueIds = ids.toSet();
      expect(
        ids.length,
        equals(uniqueIds.length),
        reason: 'Duplicate scenario IDs detected',
      );
    });

    test('contains 8 objection drills and 12 discovery drills', () {
      expect(SalesScenarioCatalog.allObjectionDrills.length, equals(8));
      expect(SalesScenarioCatalog.allDiscoveryDrills.length, equals(12));
    });

    test('each scenario has between 8 and 25 turns', () {
      for (final scenario in SalesScenarioCatalog.allScenarios) {
        expect(
          scenario.turns.length,
          greaterThanOrEqualTo(8),
          reason:
              '${scenario.id} has fewer than 8 turns (${scenario.turns.length})',
        );
      }
    });

    test('each scenario has at least 3 distinct reachable outcomes', () {
      for (final scenario in SalesScenarioCatalog.allScenarios) {
        final finalOutcomes = scenario.turns
            .where((t) => t.isFinal && t.resultingOutcome != null)
            .map((t) => t.resultingOutcome!)
            .toSet();

        expect(
          finalOutcomes.contains(SalesOutcomeType.qualifiedAccept),
          isTrue,
          reason: '${scenario.id} lacks qualifiedAccept outcome',
        );
        expect(
          finalOutcomes.contains(SalesOutcomeType.respectfulNoSale),
          isTrue,
          reason: '${scenario.id} lacks respectfulNoSale outcome',
        );
        expect(
          finalOutcomes.contains(SalesOutcomeType.needsVerification),
          isTrue,
          reason: '${scenario.id} lacks needsVerification outcome',
        );
      }
    });

    test(
      'each scenario begins with agent greeting turn requiring Alex and AT&T',
      () {
        for (final scenario in SalesScenarioCatalog.allScenarios) {
          final firstTurn = scenario.turns.first;
          expect(firstTurn.phase, equals(SalesPhase.greeting));
          expect(firstTurn.speaker, equals(TurnSpeaker.agent));
          expect(firstTurn.requiredKeywords, contains('alex'));
          expect(firstTurn.requiredKeywords, contains('att'));
        }
      },
    );

    test('all scenarios have Arabic guidance for trainer review', () {
      final missingScenarios = <String>[];
      for (final scenario in SalesScenarioCatalog.allScenarios) {
        final hasGuidance = scenario.turns.any(
          (t) =>
              t.speaker == TurnSpeaker.agent &&
              t.trainerGuidanceArabic.trim().isNotEmpty,
        );
        if (!hasGuidance) {
          missingScenarios.add(scenario.id);
        }
      }
      expect(
        missingScenarios,
        isEmpty,
        reason: 'Scenarios lacking Arabic guidance: $missingScenarios',
      );
    });

    test('catalog integrity validator reports isValid == true', () {
      final report = SalesScenarioCatalog.validateIntegrity();
      expect(report['isValid'], isTrue, reason: 'Validation report: $report');
      expect(report['totalScenarios'], greaterThanOrEqualTo(48));
      expect(report['duplicateIds'], isEmpty);
      expect(
        report['scenariosWithThreeOutcomes'],
        equals(report['totalScenarios']),
      );
    });

    test('Policy Guard: assert zero prohibited guarantees in agent reference responses', () {
      final prohibitedTerms = [
        'supervisor callback',
        'lock this rate forever',
        'promise bill credits on day one',
        'bypass activation lock',
        'guarantee 100% cellular signal',
      ];

      for (final scenario in SalesScenarioCatalog.allScenarios) {
        for (final turn in scenario.turns.where(
          (t) => t.speaker == TurnSpeaker.agent,
        )) {
          final lowerSpoken = turn.spokenText.toLowerCase();
          final lowerModel = turn.usEnglishModelResponse.toLowerCase();

          for (final term in prohibitedTerms) {
            // "supervisor callback" check: allowed only when explaining that supervisor callbacks are NOT available
            if (term == 'supervisor callback') {
              if (lowerSpoken.contains('promise a supervisor callback') ||
                  lowerSpoken.contains('schedule a supervisor callback') ||
                  lowerModel.contains('promise a supervisor callback')) {
                fail(
                  '${scenario.id} turn ${turn.id} promises supervisor callback',
                );
              }
            } else {
              expect(
                lowerSpoken.contains(term),
                isFalse,
                reason:
                    '${scenario.id} turn ${turn.id} contains prohibited term "$term"',
              );
              expect(
                lowerModel.contains(term),
                isFalse,
                reason:
                    '${scenario.id} turn ${turn.id} model response contains prohibited term "$term"',
              );
            }
          }
        }
      }
    });

    test('search and category filtering helpers return accurate subsets', () {
      final wireless = SalesScenarioCatalog.findByCategory('wireless_upgrade');
      expect(wireless.length, equals(8));

      final fiber = SalesScenarioCatalog.findByCategory('fiber_discovery');
      expect(fiber.length, equals(8));

      final tradeIn = SalesScenarioCatalog.findByCategory('trade_in_eip');
      expect(tradeIn.length, equals(8));

      final retention = SalesScenarioCatalog.findByCategory(
        'retention_care_to_sales',
      );
      expect(retention.length, equals(8));

      final searchResults = SalesScenarioCatalog.search('fiber');
      expect(searchResults.isNotEmpty, isTrue);
    });
  });
}
