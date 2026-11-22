import '../../core/constants/training_constants.dart';
import '../../core/models/provenance.dart';
import 'scenario.dart';

/// Consultative sales conversation phases.
enum SalesPhase {
  greeting,
  initialResolution,
  explorationPermission,
  discovery,
  valueBridge,
  objectionHandling,
  eligibilityBoundary,
  closing,
}

/// The distinct outcome classification for a consultative sales interaction.
enum SalesOutcomeType {
  /// Customer accepted the recommended service after transparent qualification and disclosures.
  qualifiedAccept,

  /// Customer explicitly declined; agent respected customer autonomy, provided options, avoided pressure.
  respectfulNoSale,

  /// Service eligibility or address compatibility is unverified; requires technician or address check.
  needsVerification,

  /// Interaction ended prematurely or customer disconnected.
  abandoned,
}

/// An enriched turn in a multi-turn consultative sales scenario.
class SalesTurn {
  final String id;
  final int turnNumber;
  final TurnSpeaker speaker;
  final String spokenText; // Customer TTS utterance OR agent reference target
  final SalesPhase phase;
  final List<String> requiredKeywords;
  final List<String>
  prohibitedPhrases; // Forbidden guarantees or pressure tactics
  final String trainerGuidanceArabic;
  final String usEnglishModelResponse;
  final List<ScenarioBranch> branches;
  final bool isFinal;
  final SalesOutcomeType? resultingOutcome;

  const SalesTurn({
    required this.id,
    required this.turnNumber,
    required this.speaker,
    required this.spokenText,
    required this.phase,
    this.requiredKeywords = const [],
    this.prohibitedPhrases = const [],
    this.trainerGuidanceArabic = '',
    this.usEnglishModelResponse = '',
    this.branches = const [],
    this.isFinal = false,
    this.resultingOutcome,
  });

  ScenarioTurn toScenarioTurn() => ScenarioTurn(
    id: id,
    turnNumber: turnNumber,
    speaker: speaker,
    spokenText: spokenText,
    requiredKeywords: requiredKeywords,
    trainerGuidanceArabic: trainerGuidanceArabic,
    branches: branches,
    isFinal: isFinal,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'turnNumber': turnNumber,
    'speaker': speaker.name,
    'spokenText': spokenText,
    'phase': phase.name,
    'requiredKeywords': requiredKeywords,
    'prohibitedPhrases': prohibitedPhrases,
    'trainerGuidanceArabic': trainerGuidanceArabic,
    'usEnglishModelResponse': usEnglishModelResponse,
    'branches': branches.map((b) => b.toJson()).toList(),
    'isFinal': isFinal,
    if (resultingOutcome != null) 'resultingOutcome': resultingOutcome!.name,
  };

  factory SalesTurn.fromJson(Map<String, dynamic> json) => SalesTurn(
    id: json['id'] as String,
    turnNumber: json['turnNumber'] as int? ?? 1,
    speaker: TurnSpeaker.values.firstWhere(
      (s) => s.name == json['speaker'],
      orElse: () => TurnSpeaker.customer,
    ),
    spokenText: json['spokenText'] as String,
    phase: SalesPhase.values.firstWhere(
      (p) => p.name == json['phase'],
      orElse: () => SalesPhase.discovery,
    ),
    requiredKeywords:
        (json['requiredKeywords'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        const [],
    prohibitedPhrases:
        (json['prohibitedPhrases'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        const [],
    trainerGuidanceArabic: json['trainerGuidanceArabic'] as String? ?? '',
    usEnglishModelResponse: json['usEnglishModelResponse'] as String? ?? '',
    branches:
        (json['branches'] as List<dynamic>?)
            ?.map((b) => ScenarioBranch.fromJson(b as Map<String, dynamic>))
            .toList() ??
        const [],
    isFinal: json['isFinal'] as bool? ?? false,
    resultingOutcome: json['resultingOutcome'] != null
        ? SalesOutcomeType.values.firstWhere(
            (o) => o.name == json['resultingOutcome'],
            orElse: () => SalesOutcomeType.needsVerification,
          )
        : null,
  );
}

/// Rich customer profile for consultative sales practice.
class SalesCustomerProfile {
  final String name;
  final String
  tone; // 'skeptical', 'budget-conscious', 'hurried', 'elderly', 'tech-savvy'
  final String currentProvider; // Fictional competitor or existing plan
  final String householdNeeds;
  final String financialConstraint;
  final String coreBlocker;
  final bool
  isEligibleForOffer; // In some scenarios, customer is genuinely not eligible

  const SalesCustomerProfile({
    required this.name,
    required this.tone,
    required this.currentProvider,
    required this.householdNeeds,
    required this.financialConstraint,
    required this.coreBlocker,
    this.isEligibleForOffer = true,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'tone': tone,
    'currentProvider': currentProvider,
    'householdNeeds': householdNeeds,
    'financialConstraint': financialConstraint,
    'coreBlocker': coreBlocker,
    'isEligibleForOffer': isEligibleForOffer,
  };

  factory SalesCustomerProfile.fromJson(Map<String, dynamic> json) =>
      SalesCustomerProfile(
        name: json['name'] as String,
        tone: json['tone'] as String? ?? 'neutral',
        currentProvider: json['currentProvider'] as String? ?? 'Competitor',
        householdNeeds: json['householdNeeds'] as String? ?? 'Standard',
        financialConstraint:
            json['financialConstraint'] as String? ?? 'None specified',
        coreBlocker: json['coreBlocker'] as String? ?? 'None',
        isEligibleForOffer: json['isEligibleForOffer'] as bool? ?? true,
      );
}

/// A comprehensive consultative sales scenario supporting 8-16+ turns,
/// multiple decision nodes, and 3+ meaningful outcomes.
class SalesScenario {
  final String id;
  final String title;
  final String category; // 'wireless_upgrade', 'fiber_discovery', 'add_a_line', 'landline_to_wireless', 'trade_in_eip', 'retention_care_to_sales'
  final String difficulty; // 'beginner', 'intermediate', 'advanced'
  final SalesCustomerProfile profile;
  final String contextNotes;
  final List<String> skillTags;
  final List<String> prohibitedPromises; // Universal scenario guardrails (e.g. rate locks, fee waivers)
  final List<String> mandatoryDisclosures;
  final List<String> fictionalCandidateProducts;
  final List<SalesTurn> turns;
  final ContentMetadata metadata;

  const SalesScenario({
    required this.id,
    required this.title,
    required this.category,
    required this.difficulty,
    required this.profile,
    required this.contextNotes,
    required this.skillTags,
    required this.prohibitedPromises,
    required this.mandatoryDisclosures,
    required this.fictionalCandidateProducts,
    required this.turns,
    this.metadata = const ContentMetadata(
      provenance: ProvenanceTier.fictionalSimulation,
      notes: 'Consultative sales roleplay simulation [Fictional / Simulation Only].',
    ),
  });

  /// Converts to standard Scenario for polymorphic rendering in Arena if needed.
  Scenario toScenario() {
    return Scenario(
      id: id,
      title: title,
      moduleIndex: 4,
      customerPersona: '${profile.name} (${profile.tone})',
      expectedResponse: TrainingConstants.standardGreeting,
      customerResponse: turns.isNotEmpty ? turns.first.spokenText : '',
      requiredAnchors: TrainingConstants.greetingRequiredAnchors,
      contextNotes: contextNotes,
      category: category,
      difficulty: difficulty,
      skillTags: skillTags,
      turns: turns.map((t) => t.toScenarioTurn()).toList(),
      metadata: metadata,
    );
  }

  SalesTurn? findTurnById(String turnId) {
    for (final turn in turns) {
      if (turn.id == turnId) return turn;
    }
    return null;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'category': category,
    'difficulty': difficulty,
    'profile': profile.toJson(),
    'contextNotes': contextNotes,
    'skillTags': skillTags,
    'prohibitedPromises': prohibitedPromises,
    'mandatoryDisclosures': mandatoryDisclosures,
    'fictionalCandidateProducts': fictionalCandidateProducts,
    'turns': turns.map((t) => t.toJson()).toList(),
    'metadata': metadata.toJson(),
  };

  factory SalesScenario.fromJson(Map<String, dynamic> json) => SalesScenario(
    id: json['id'] as String,
    title: json['title'] as String,
    category: json['category'] as String,
    difficulty: json['difficulty'] as String? ?? 'intermediate',
    profile: SalesCustomerProfile.fromJson(
      json['profile'] as Map<String, dynamic>,
    ),
    contextNotes: json['contextNotes'] as String? ?? '',
    skillTags:
        (json['skillTags'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        const [],
    prohibitedPromises:
        (json['prohibitedPromises'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        const [],
    mandatoryDisclosures:
        (json['mandatoryDisclosures'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        const [],
    fictionalCandidateProducts:
        (json['fictionalCandidateProducts'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        const [],
    turns:
        (json['turns'] as List<dynamic>?)
            ?.map((t) => SalesTurn.fromJson(t as Map<String, dynamic>))
            .toList() ??
        const [],
    metadata: json['metadata'] != null
        ? ContentMetadata.fromJson(json['metadata'] as Map<String, dynamic>)
        : const ContentMetadata(provenance: ProvenanceTier.fictionalSimulation),
  );
}
