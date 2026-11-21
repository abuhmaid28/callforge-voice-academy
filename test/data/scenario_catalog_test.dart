import 'package:callforge/core/models/provenance.dart';
import 'package:callforge/data/datasources/scenario_catalog.dart';
import 'package:callforge/domain/entities/scenario.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ScenarioCatalog Integrity Tests', () {
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

    test(
      'all 30 scenarios have multi-turn conversation trees with valid branches',
      () {
        for (final s in ScenarioCatalog.allScenarios) {
          expect(
            s.turns,
            isNotEmpty,
            reason: 'Scenario ${s.id} must define multi-turn nodes',
          );
          expect(
            s.turns.length,
            greaterThanOrEqualTo(3),
            reason: 'Scenario ${s.id} must have at least 3 conversation turns',
          );

          // Verify turn 1 is agent greeting
          expect(s.turns.first.turnNumber, equals(1));
          expect(s.turns.first.speaker, equals(TurnSpeaker.agent));

          // Verify at least one turn is marked final
          expect(
            s.turns.any((t) => t.isFinal),
            isTrue,
            reason: 'Scenario ${s.id} must have at least one terminal node',
          );

          // Verify all non-final turns have non-empty spokenText and Arabic guidance
          for (final t in s.turns) {
            expect(t.spokenText, isNotEmpty);
            if (!t.isFinal) {
              expect(
                t.trainerGuidanceArabic,
                isNotEmpty,
                reason: 'Turn ${t.id} must have Egyptian Arabic coaching',
              );
            }
          }
        }
      },
    );

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
  });
}
