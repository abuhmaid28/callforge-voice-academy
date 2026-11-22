import '../../core/models/provenance.dart';

/// Categories of carrier services and products available in fictional simulation.
enum ServiceType {
  wireless,
  fiber,
  deviceInstallment,
  landlineToWireless,
  addALine,
  accessories,
}

/// A structured fictional product definition for consultative matching.
class FictionalProduct {
  final String id;
  final String name;
  final ServiceType serviceType;
  final String headline;
  final String
  fictionalMonthlyCost; // Clearly fictional, e.g. "Fictional \$65/mo"
  final List<String> keyFeatures;
  final List<String> idealForNeeds;
  final List<String> mandatoryDisclosures;
  final List<String>
  unknownEligibilityPrerequisites; // e.g. "Address check required for Fiber"
  final ContentMetadata metadata;

  const FictionalProduct({
    required this.id,
    required this.name,
    required this.serviceType,
    required this.headline,
    required this.fictionalMonthlyCost,
    required this.keyFeatures,
    required this.idealForNeeds,
    required this.mandatoryDisclosures,
    required this.unknownEligibilityPrerequisites,
    this.metadata = const ContentMetadata(
      provenance: ProvenanceTier.fictionalSimulation,
      notes: 'Fictional product catalog entry for educational roleplay only.',
    ),
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'serviceType': serviceType.name,
    'headline': headline,
    'fictionalMonthlyCost': fictionalMonthlyCost,
    'keyFeatures': keyFeatures,
    'idealForNeeds': idealForNeeds,
    'mandatoryDisclosures': mandatoryDisclosures,
    'unknownEligibilityPrerequisites': unknownEligibilityPrerequisites,
    'metadata': metadata.toJson(),
  };

  factory FictionalProduct.fromJson(Map<String, dynamic> json) =>
      FictionalProduct(
        id: json['id'] as String,
        name: json['name'] as String,
        serviceType: ServiceType.values.firstWhere(
          (s) => s.name == json['serviceType'],
          orElse: () => ServiceType.wireless,
        ),
        headline: json['headline'] as String,
        fictionalMonthlyCost: json['fictionalMonthlyCost'] as String,
        keyFeatures:
            (json['keyFeatures'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            const [],
        idealForNeeds:
            (json['idealForNeeds'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            const [],
        mandatoryDisclosures:
            (json['mandatoryDisclosures'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            const [],
        unknownEligibilityPrerequisites:
            (json['unknownEligibilityPrerequisites'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            const [],
        metadata: json['metadata'] != null
            ? ContentMetadata.fromJson(json['metadata'] as Map<String, dynamic>)
            : const ContentMetadata(
                provenance: ProvenanceTier.fictionalSimulation,
              ),
      );
}

/// Result of evaluating a fictional product against customer needs.
enum ProductFitStatus {
  /// Strong alignment with expressed household needs and confirmed budget.
  strongFit,

  /// Viable solution provided specific conditions or trade-offs are accepted.
  conditionalFit,

  /// Customer needs or budget directly contradict this product; ethical reps should not pitch.
  unqualified,

  /// Cannot determine fit until external verification is performed (e.g. Fiber address qualification, porting eligibility).
  needsVerification,
}

/// Explainable output of the Needs -> Fit -> Value engine.
class ProductFitEvaluation {
  final FictionalProduct product;
  final ProductFitStatus status;
  final String whyItFits;
  final String whyItFitsArabic;
  final List<String> matchedNeeds;
  final List<String> unknownPrerequisites;
  final List<String> questionsToAskCustomer;
  final String recommendedTransitionPhrase;

  const ProductFitEvaluation({
    required this.product,
    required this.status,
    required this.whyItFits,
    required this.whyItFitsArabic,
    required this.matchedNeeds,
    required this.unknownPrerequisites,
    required this.questionsToAskCustomer,
    required this.recommendedTransitionPhrase,
  });

  Map<String, dynamic> toJson() => {
    'productId': product.id,
    'status': status.name,
    'whyItFits': whyItFits,
    'whyItFitsArabic': whyItFitsArabic,
    'matchedNeeds': matchedNeeds,
    'unknownPrerequisites': unknownPrerequisites,
    'questionsToAskCustomer': questionsToAskCustomer,
    'recommendedTransitionPhrase': recommendedTransitionPhrase,
  };
}

/// User-created local practice offer stored only on-device.
class UserPracticeOffer {
  final String id;
  final String title;
  final String details;
  final DateTime effectiveDate;
  final DateTime? expiryDate;
  final String sourceNote;
  final bool isVerifiedFictional;

  const UserPracticeOffer({
    required this.id,
    required this.title,
    required this.details,
    required this.effectiveDate,
    this.expiryDate,
    required this.sourceNote,
    this.isVerifiedFictional = true,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'details': details,
    'effectiveDate': effectiveDate.toIso8601String(),
    if (expiryDate != null) 'expiryDate': expiryDate!.toIso8601String(),
    'sourceNote': sourceNote,
    'isVerifiedFictional': isVerifiedFictional,
  };

  factory UserPracticeOffer.fromJson(Map<String, dynamic> json) =>
      UserPracticeOffer(
        id: json['id'] as String,
        title: json['title'] as String,
        details: json['details'] as String,
        effectiveDate: DateTime.parse(json['effectiveDate'] as String),
        expiryDate: json['expiryDate'] != null
            ? DateTime.parse(json['expiryDate'] as String)
            : null,
        sourceNote:
            json['sourceNote'] as String? ?? 'User created practice note',
        isVerifiedFictional: json['isVerifiedFictional'] as bool? ?? true,
      );
}
