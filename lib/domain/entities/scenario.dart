import '../../core/constants/training_constants.dart';
import '../../core/models/provenance.dart';

enum TurnSpeaker { agent, customer }

/// A branching decision edge connecting conversation turns.
class ScenarioBranch {
  final String conditionKey;
  final String nextTurnId;
  final String description;

  const ScenarioBranch({
    required this.conditionKey,
    required this.nextTurnId,
    this.description = '',
  });

  Map<String, dynamic> toJson() => {
    'conditionKey': conditionKey,
    'nextTurnId': nextTurnId,
    'description': description,
  };

  factory ScenarioBranch.fromJson(Map<String, dynamic> json) => ScenarioBranch(
    conditionKey: json['conditionKey'] as String,
    nextTurnId: json['nextTurnId'] as String,
    description: json['description'] as String? ?? '',
  );
}

/// An individual turn in a multi-turn call simulation.
class ScenarioTurn {
  final String id;
  final int turnNumber;
  final TurnSpeaker speaker;
  final String spokenText; // Customer utterance OR reference agent target
  final List<String> requiredKeywords; // Semantic anchors expected on this turn
  final String trainerGuidanceArabic;
  final List<ScenarioBranch> branches;
  final bool isFinal;

  const ScenarioTurn({
    required this.id,
    required this.turnNumber,
    required this.speaker,
    required this.spokenText,
    this.requiredKeywords = const [],
    this.trainerGuidanceArabic = '',
    this.branches = const [],
    this.isFinal = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'turnNumber': turnNumber,
    'speaker': speaker.name,
    'spokenText': spokenText,
    'requiredKeywords': requiredKeywords,
    'trainerGuidanceArabic': trainerGuidanceArabic,
    'branches': branches.map((b) => b.toJson()).toList(),
    'isFinal': isFinal,
  };

  factory ScenarioTurn.fromJson(Map<String, dynamic> json) => ScenarioTurn(
    id: json['id'] as String,
    turnNumber: json['turnNumber'] as int? ?? 1,
    speaker: TurnSpeaker.values.firstWhere(
      (s) => s.name == json['speaker'],
      orElse: () => TurnSpeaker.customer,
    ),
    spokenText: json['spokenText'] as String,
    requiredKeywords:
        (json['requiredKeywords'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        const [],
    trainerGuidanceArabic: json['trainerGuidanceArabic'] as String? ?? '',
    branches:
        (json['branches'] as List<dynamic>?)
            ?.map((b) => ScenarioBranch.fromJson(b as Map<String, dynamic>))
            .toList() ??
        const [],
    isFinal: json['isFinal'] as bool? ?? false,
  );
}

/// Customer profile with personality and tone.
class CustomerPersona {
  final String name;
  final String
  tone; // 'confused', 'furious', 'skeptical', 'friendly', 'elderly', 'hurried'
  final String accountType; // 'Wireless', 'Fiber', 'Unified'

  const CustomerPersona({
    required this.name,
    required this.tone,
    required this.accountType,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'tone': tone,
    'accountType': accountType,
  };

  factory CustomerPersona.fromJson(Map<String, dynamic> json) =>
      CustomerPersona(
        name: json['name'] as String,
        tone: json['tone'] as String? ?? 'neutral',
        accountType: json['accountType'] as String? ?? 'Wireless',
      );
}

/// Represents a training scenario or multi-turn call simulation.
class Scenario {
  final String id;
  final String title;
  final int moduleIndex;
  final String customerPersona;
  final String
  expectedResponse; // Representative's required opening greeting (Turn 1)
  final String customerResponse; // Customer's spoken audio response upon receiving greeting (Turn 2)
  final List<String> requiredAnchors;
  final String contextNotes;
  final String category; // 'billing', 'troubleshooting', 'de_escalation', 'sales_discovery', 'care_loyalty'
  final String difficulty; // 'beginner', 'intermediate', 'advanced'
  final List<String> skillTags;
  final List<ScenarioTurn> turns;
  final ContentMetadata metadata;

  const Scenario({
    required this.id,
    required this.title,
    required this.moduleIndex,
    required this.customerPersona,
    required this.expectedResponse,
    required this.customerResponse,
    required this.requiredAnchors,
    required this.contextNotes,
    this.category = 'Floor Care',
    this.difficulty = 'intermediate',
    this.skillTags = const ['Call Control'],
    this.turns = const [],
    this.metadata = const ContentMetadata(
      provenance: ProvenanceTier.fictionalSimulation,
      version: '1.0.0',
      lastReviewed: '2026-11-21',
      authorOrSource: 'CALLFORGE Fictional Practice Suite',
      notes: 'Fictionalized customer practice scenario.',
    ),
  });

  /// Backward-compatible alias for customer prompt
  String get customerPrompt => customerResponse;

  /// Whether this scenario has multiple interactive conversation turns.
  bool get isMultiTurn => turns.isNotEmpty;

  /// Factory for M1 Inbound Greeting Scenario (Representative Speaks First)
  static Scenario m1GreetingScenario() {
    return const Scenario(
      id: 'm1_inbound_greeting_01',
      title: 'Inbound Standard Greeting & Discovery Initiation',
      moduleIndex: 1,
      customerPersona: TrainingConstants.m1CustomerPersona,
      expectedResponse: TrainingConstants.standardGreeting,
      customerResponse: TrainingConstants.m1CustomerResponse,
      requiredAnchors: TrainingConstants.greetingRequiredAnchors,
      contextNotes: 'Inbound call arrives. Representative Alex must deliver the standard AT&T greeting first. Once verified, customer David Miller responds with a first-bill inquiry.',
      category: 'Inbound Greeting',
      difficulty: 'beginner',
      skillTags: ['Greeting', 'Identity Verification'],
      turns: [
        ScenarioTurn(
          id: 'turn_1_greeting',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: TrainingConstants.standardGreeting,
          requiredKeywords: TrainingConstants.greetingRequiredAnchors,
          trainerGuidanceArabic: 'افتتح المكالمة بالترحيب الإلزامي: اسمك Alex، اسم الشركة AT&T، وطلب الاسم الأول والأخير.',
        ),
        ScenarioTurn(
          id: 'turn_2_customer_bill',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: TrainingConstants.m1CustomerResponse,
          trainerGuidanceArabic: 'العميل بيشتكي من ارتفاع الفاتورة الأولى. أظهر تعاطف واضح واستخدم أسلوب AERD.',
          isFinal: true,
        ),
      ],
    );
  }
}
