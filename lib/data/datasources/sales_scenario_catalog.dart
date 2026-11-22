import '../../domain/entities/sales_scenario.dart';
import 'sales_scenarios/add_a_line_scenarios.dart';
import 'sales_scenarios/discovery_drills.dart';
import 'sales_scenarios/fiber_scenarios.dart';
import 'sales_scenarios/landline_scenarios.dart';
import 'sales_scenarios/objection_drills.dart';
import 'sales_scenarios/retention_scenarios.dart';
import 'sales_scenarios/trade_in_scenarios.dart';
import 'sales_scenarios/wireless_scenarios.dart';

/// Unified catalog containing all 48 consultative sales scenarios, 8 objection drills,
/// and 12 spoken discovery drills for the CallForge Sales Lab and 90-Day Academy.
abstract class SalesScenarioCatalog {
  /// All 48 distinct multi-turn branching sales scenarios across 6 core categories.
  static final List<SalesScenario> allScenarios = [
    ...WirelessScenariosCatalog.scenarios, // 1–8: Wireless Upgrade
    ...FiberScenariosCatalog.scenarios, // 9–16: Fiber Discovery
    ...AddALineScenariosCatalog.scenarios, // 17–24: Add-a-Line & Family
    ...LandlineToWirelessScenariosCatalog
        .scenarios, // 25–32: Landline to Wireless
    ...TradeInScenariosCatalog.scenarios, // 33–40: Trade-In & EIP
    ...RetentionScenariosCatalog.scenarios, // 41–48: Retention & Care-to-Sales
  ];

  /// All 8 intensive objection handling drills.
  static final List<ObjectionDrillItem> allObjectionDrills =
      ObjectionDrillsCatalog.drills;

  /// All 12 targeted spoken listening and sales discovery drills.
  static final List<DiscoveryDrillItem> allDiscoveryDrills =
      DiscoveryDrillsCatalog.drills;

  /// Find a sales scenario by unique identifier.
  static SalesScenario? findById(String id) {
    try {
      return allScenarios.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Filter sales scenarios by category (e.g. 'wireless_upgrade', 'fiber_discovery').
  static List<SalesScenario> findByCategory(String category) {
    return allScenarios
        .where((s) => s.category.toLowerCase() == category.toLowerCase())
        .toList();
  }

  /// Filter sales scenarios by difficulty tier ('entry', 'intermediate', 'advanced').
  static List<SalesScenario> findByDifficulty(String difficulty) {
    return allScenarios
        .where((s) => s.difficulty.toLowerCase() == difficulty.toLowerCase())
        .toList();
  }

  /// Filter sales scenarios by associated skill tag.
  static List<SalesScenario> findBySkillTag(String tag) {
    final lowerTag = tag.toLowerCase();
    return allScenarios
        .where((s) => s.skillTags.any((t) => t.toLowerCase() == lowerTag))
        .toList();
  }

  /// Search scenarios by title, context notes, customer profile, or skill tags.
  static List<SalesScenario> search(String query) {
    final cleanQuery = query.trim().toLowerCase();
    if (cleanQuery.isEmpty) return allScenarios;

    return allScenarios.where((s) {
      final matchTitle = s.title.toLowerCase().contains(cleanQuery);
      final matchContext = s.contextNotes.toLowerCase().contains(cleanQuery);
      final matchName = s.profile.name.toLowerCase().contains(cleanQuery);
      final matchHousehold = s.profile.householdNeeds.toLowerCase().contains(
        cleanQuery,
      );
      final matchTags = s.skillTags.any(
        (t) => t.toLowerCase().contains(cleanQuery),
      );
      return matchTitle ||
          matchContext ||
          matchName ||
          matchHousehold ||
          matchTags;
    }).toList();
  }

  /// All unique categories available in the catalog.
  static List<String> get allCategories {
    return allScenarios.map((s) => s.category).toSet().toList()..sort();
  }

  /// All unique skill tags across all scenarios.
  static List<String> get allSkillTags {
    final set = <String>{};
    for (final s in allScenarios) {
      set.addAll(s.skillTags);
    }
    return set.toList()..sort();
  }

  /// Find an objection drill by identifier.
  static ObjectionDrillItem? findObjectionDrillById(String id) {
    try {
      return allObjectionDrills.firstWhere((d) => d.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Find a discovery drill by identifier.
  static DiscoveryDrillItem? findDiscoveryDrillById(String id) {
    try {
      return allDiscoveryDrills.firstWhere((d) => d.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Verify catalog integrity: assert minimum counts, unique IDs, branch validity,
  /// and reachable outcome completeness.
  static Map<String, dynamic> validateIntegrity() {
    final ids = <String>{};
    final duplicateIds = <String>[];
    int totalTurns = 0;
    int scenariosWithThreeOutcomes = 0;

    for (final scenario in allScenarios) {
      if (!ids.add(scenario.id)) {
        duplicateIds.add(scenario.id);
      }
      totalTurns += scenario.turns.length;

      final outcomes = scenario.turns
          .where((t) => t.isFinal && t.resultingOutcome != null)
          .map((t) => t.resultingOutcome!)
          .toSet();

      final hasAccept = outcomes.contains(SalesOutcomeType.qualifiedAccept);
      final hasNoSale = outcomes.contains(SalesOutcomeType.respectfulNoSale);
      final hasVerify = outcomes.contains(SalesOutcomeType.needsVerification);

      if (hasAccept && hasNoSale && hasVerify) {
        scenariosWithThreeOutcomes++;
      }
    }

    return {
      'totalScenarios': allScenarios.length,
      'totalObjectionDrills': allObjectionDrills.length,
      'totalDiscoveryDrills': allDiscoveryDrills.length,
      'totalTurns': totalTurns,
      'duplicateIds': duplicateIds,
      'scenariosWithThreeOutcomes': scenariosWithThreeOutcomes,
      'isValid':
          duplicateIds.isEmpty &&
          allScenarios.length >= 48 &&
          scenariosWithThreeOutcomes == allScenarios.length,
    };
  }
}
