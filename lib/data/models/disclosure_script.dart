import '../../core/models/provenance.dart';

/// Customer consent outcome resulting from a disclosure read.
enum ConsentOutcome {
  agreed,
  questioned,
  refused;

  String get displayName {
    switch (this) {
      case ConsentOutcome.agreed:
        return 'Clear Agreement (موافقة العميل)';
      case ConsentOutcome.questioned:
        return 'Hesitation / Question (استفسار/تردد)';
      case ConsentOutcome.refused:
        return 'Direct Refusal (رفض)';
    }
  }
}

/// A critical legal or financial term inside a disclosure that must not be omitted or altered.
class CriticalTerm {
  final String term;
  final String category; // 'amount', 'duration', 'obligation', 'condition'
  final bool isNumericOrPrice;

  const CriticalTerm({
    required this.term,
    required this.category,
    this.isNumericOrPrice = false,
  });

  Map<String, dynamic> toJson() => {
    'term': term,
    'category': category,
    'isNumericOrPrice': isNumericOrPrice,
  };

  factory CriticalTerm.fromJson(Map<String, dynamic> json) => CriticalTerm(
    term: json['term'] as String,
    category: json['category'] as String? ?? 'obligation',
    isNumericOrPrice: json['isNumericOrPrice'] as bool? ?? false,
  );
}

/// Simulated customer follow-up to a disclosure reading.
class SimulatedCustomerResponse {
  final ConsentOutcome outcome;
  final String spokenText;
  final String trainerGuidanceArabic;
  final String expectedAgentAction;

  const SimulatedCustomerResponse({
    required this.outcome,
    required this.spokenText,
    required this.trainerGuidanceArabic,
    required this.expectedAgentAction,
  });

  Map<String, dynamic> toJson() => {
    'outcome': outcome.name,
    'spokenText': spokenText,
    'trainerGuidanceArabic': trainerGuidanceArabic,
    'expectedAgentAction': expectedAgentAction,
  };

  factory SimulatedCustomerResponse.fromJson(Map<String, dynamic> json) =>
      SimulatedCustomerResponse(
        outcome: ConsentOutcome.values.firstWhere(
          (o) => o.name == json['outcome'],
          orElse: () => ConsentOutcome.agreed,
        ),
        spokenText: json['spokenText'] as String,
        trainerGuidanceArabic: json['trainerGuidanceArabic'] as String,
        expectedAgentAction: json['expectedAgentAction'] as String,
      );
}

/// A structured disclosure script for verbatim reading practice.
class DisclosureScript {
  final String id;
  final String title;
  final String category;
  final String scriptText;
  final List<CriticalTerm> criticalTerms;
  final List<SimulatedCustomerResponse> customerResponses;
  final ContentMetadata metadata;
  final bool isCustomUserDraft;

  const DisclosureScript({
    required this.id,
    required this.title,
    required this.category,
    required this.scriptText,
    this.criticalTerms = const [],
    this.customerResponses = const [],
    this.metadata = const ContentMetadata(
      provenance: ProvenanceTier.fictionalSimulation,
      notes: 'Custom disclosure draft or test script.',
    ),
    this.isCustomUserDraft = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'category': category,
    'scriptText': scriptText,
    'criticalTerms': criticalTerms.map((c) => c.toJson()).toList(),
    'customerResponses': customerResponses.map((r) => r.toJson()).toList(),
    'metadata': metadata.toJson(),
    'isCustomUserDraft': isCustomUserDraft,
  };

  factory DisclosureScript.fromJson(Map<String, dynamic> json) =>
      DisclosureScript(
        id: json['id'] as String,
        title: json['title'] as String,
        category: json['category'] as String? ?? 'General',
        scriptText: json['scriptText'] as String,
        criticalTerms:
            (json['criticalTerms'] as List<dynamic>?)
                ?.map((c) => CriticalTerm.fromJson(c as Map<String, dynamic>))
                .toList() ??
            [],
        customerResponses:
            (json['customerResponses'] as List<dynamic>?)
                ?.map(
                  (r) => SimulatedCustomerResponse.fromJson(
                    r as Map<String, dynamic>,
                  ),
                )
                .toList() ??
            [],
        metadata: ContentMetadata.fromJson(
          json['metadata'] as Map<String, dynamic>? ?? {},
        ),
        isCustomUserDraft: json['isCustomUserDraft'] as bool? ?? false,
      );

  DisclosureScript copyWith({
    String? title,
    String? category,
    String? scriptText,
    List<CriticalTerm>? criticalTerms,
    List<SimulatedCustomerResponse>? customerResponses,
    ContentMetadata? metadata,
    bool? isCustomUserDraft,
  }) => DisclosureScript(
    id: id,
    title: title ?? this.title,
    category: category ?? this.category,
    scriptText: scriptText ?? this.scriptText,
    criticalTerms: criticalTerms ?? this.criticalTerms,
    customerResponses: customerResponses ?? this.customerResponses,
    metadata: metadata ?? this.metadata,
    isCustomUserDraft: isCustomUserDraft ?? this.isCustomUserDraft,
  );
}
