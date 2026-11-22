import 'sales_scenario.dart';

/// Rating tiers for individual dimensions on the sales scorecard.
enum ScorecardRating {
  /// Dimension was not relevant or not reached during this interaction.
  notAssessed,

  /// Critical elements were omitted, rushed, or lacked customer focus.
  developing,

  /// Clear, conversational execution meeting floor expectations.
  proficient,

  /// Exceptional empathy, consultative depth, and value articulation.
  exemplary,
}

/// Evaluation of a single consultative sales skill dimension.
class ScorecardDimension {
  final String key;
  final String label;
  final String labelArabic;
  final ScorecardRating rating;
  final String evidenceSnippet;
  final String feedbackEnglish;
  final String feedbackArabic;

  const ScorecardDimension({
    required this.key,
    required this.label,
    required this.labelArabic,
    required this.rating,
    this.evidenceSnippet = '',
    this.feedbackEnglish = '',
    this.feedbackArabic = '',
  });

  bool get isAssessed => rating != ScorecardRating.notAssessed;

  double get scoreWeight {
    switch (rating) {
      case ScorecardRating.notAssessed:
        return 0.0;
      case ScorecardRating.developing:
        return 40.0;
      case ScorecardRating.proficient:
        return 80.0;
      case ScorecardRating.exemplary:
        return 100.0;
    }
  }

  Map<String, dynamic> toJson() => {
    'key': key,
    'label': label,
    'labelArabic': labelArabic,
    'rating': rating.name,
    'evidenceSnippet': evidenceSnippet,
    'feedbackEnglish': feedbackEnglish,
    'feedbackArabic': feedbackArabic,
  };

  factory ScorecardDimension.fromJson(Map<String, dynamic> json) =>
      ScorecardDimension(
        key: json['key'] as String,
        label: json['label'] as String,
        labelArabic: json['labelArabic'] as String? ?? '',
        rating: ScorecardRating.values.firstWhere(
          (r) => r.name == json['rating'],
          orElse: () => ScorecardRating.notAssessed,
        ),
        evidenceSnippet: json['evidenceSnippet'] as String? ?? '',
        feedbackEnglish: json['feedbackEnglish'] as String? ?? '',
        feedbackArabic: json['feedbackArabic'] as String? ?? '',
      );
}

/// Practice-based consultative sales scorecard.
/// Never measures uncalibrated speech acoustic signals, simulated revenue, or employer QA.
class SalesScorecard {
  final String scenarioId;
  final DateTime timestamp;
  final SalesOutcomeType outcomeType;
  final bool isNoSaleSuccess;
  final double overallScore;
  final bool passed;
  final List<ScorecardDimension> dimensions;
  final List<String> detectedProhibitedPromises;
  final String tacticalArabicAdvice;
  final String recommendedRephrasing;
  final List<String> keyEvidenceSnippets;

  const SalesScorecard({
    required this.scenarioId,
    required this.timestamp,
    required this.outcomeType,
    required this.isNoSaleSuccess,
    required this.overallScore,
    required this.passed,
    required this.dimensions,
    this.detectedProhibitedPromises = const [],
    this.tacticalArabicAdvice = '',
    this.recommendedRephrasing = '',
    this.keyEvidenceSnippets = const [],
  });

  ScorecardDimension? dimension(String key) {
    for (final d in dimensions) {
      if (d.key == key) return d;
    }
    return null;
  }

  Map<String, dynamic> toJson() => {
    'scenarioId': scenarioId,
    'timestamp': timestamp.toIso8601String(),
    'outcomeType': outcomeType.name,
    'isNoSaleSuccess': isNoSaleSuccess,
    'overallScore': overallScore,
    'passed': passed,
    'dimensions': dimensions.map((d) => d.toJson()).toList(),
    'detectedProhibitedPromises': detectedProhibitedPromises,
    'tacticalArabicAdvice': tacticalArabicAdvice,
    'recommendedRephrasing': recommendedRephrasing,
    'keyEvidenceSnippets': keyEvidenceSnippets,
  };

  factory SalesScorecard.fromJson(Map<String, dynamic> json) => SalesScorecard(
    scenarioId: json['scenarioId'] as String,
    timestamp: DateTime.parse(json['timestamp'] as String),
    outcomeType: SalesOutcomeType.values.firstWhere(
      (o) => o.name == json['outcomeType'],
      orElse: () => SalesOutcomeType.needsVerification,
    ),
    isNoSaleSuccess: json['isNoSaleSuccess'] as bool? ?? false,
    overallScore: (json['overallScore'] as num?)?.toDouble() ?? 0.0,
    passed: json['passed'] as bool? ?? false,
    dimensions:
        (json['dimensions'] as List<dynamic>?)
            ?.map((d) => ScorecardDimension.fromJson(d as Map<String, dynamic>))
            .toList() ??
        const [],
    detectedProhibitedPromises:
        (json['detectedProhibitedPromises'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        const [],
    tacticalArabicAdvice: json['tacticalArabicAdvice'] as String? ?? '',
    recommendedRephrasing: json['recommendedRephrasing'] as String? ?? '',
    keyEvidenceSnippets:
        (json['keyEvidenceSnippets'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        const [],
  );
}
