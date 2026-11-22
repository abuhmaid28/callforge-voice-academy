import '../../data/datasources/product_fit_catalog.dart';
import '../../domain/entities/product_fit.dart';

/// Evaluates fictional customer needs against the simulated product catalog.
/// Implements the explainable "Needs -> Fit -> Value" consultative framework.
abstract class ProductFitEngine {
  /// Evaluates an individual product against customer signals.
  static ProductFitEvaluation evaluateFit({
    required FictionalProduct product,
    required List<String> expressedNeeds,
    String? budgetConstraint,
    bool addressChecked = false,
    bool numberPortChecked = false,
  }) {
    final lowerNeeds = expressedNeeds
        .map((n) => n.toLowerCase().trim())
        .toList();

    // Check matched needs tags
    final matchedNeeds = <String>[];
    for (final need in lowerNeeds) {
      for (final ideal in product.idealForNeeds) {
        if (ideal.toLowerCase().contains(need) ||
            need.contains(ideal.toLowerCase())) {
          if (!matchedNeeds.contains(ideal)) {
            matchedNeeds.add(ideal);
          }
        }
      }
    }

    // Guardrail 1: Fiber Address Verification
    if (product.serviceType == ServiceType.fiber && !addressChecked) {
      return ProductFitEvaluation(
        product: product,
        status: ProductFitStatus.needsVerification,
        whyItFits: 'Fiber fits customer bandwidth needs, but physical facility availability at the street address is UNKNOWN until verified in the qualification tool.',
        whyItFitsArabic: 'الفايبر خيار ممتاز لاحتياجات السرعة، لكن ضروري جداً تبلغ العميل إننا لازم نتحقق من عنوان العقار الأول قبل ما نعده بوجود الخدمة.',
        matchedNeeds: matchedNeeds,
        unknownPrerequisites: [
          'Street address qualification check must be performed',
          'Facility port availability at the neighborhood optical hub',
        ],
        questionsToAskCustomer: [
          'May I please have your full street address and zip code to check if our 100% fiber optic network has reached your home?',
          'Who is your current internet provider, and what upload speeds are you experiencing today?',
        ],
        recommendedTransitionPhrase: 'I would love to check our system right now to see if AT&T Fiber has reached your exact address.',
      );
    }

    // Guardrail 2: Landline Number Portability
    if (product.serviceType == ServiceType.landlineToWireless &&
        !numberPortChecked) {
      return ProductFitEvaluation(
        product: product,
        status: ProductFitStatus.needsVerification,
        whyItFits: 'Wireless home phone base replaces aging copper wire at low cost, but copper landline number portability is UNKNOWN until rate center check is run.',
        whyItFitsArabic: 'محول التليفون المنزلي اللاسلكي هيوفر على العميل، بس لازم تبلغه إن الاحتفاظ بنفس الرقم القديم خاضع للفحص التقني ولا يمكن ضمانه مسبقاً.',
        matchedNeeds: matchedNeeds,
        unknownPrerequisites: [
          'Telephone rate center portability check required',
          'Carrier account and PIN verification for landline transfer',
        ],
        questionsToAskCustomer: [
          'How many traditional home handsets do you currently have plugged into the wall?',
          'Is your current home phone line on a standalone bill or bundled with other services?',
        ],
        recommendedTransitionPhrase: 'We have a wireless home phone adapter that connects directly to your existing phones, subject to checking if your number can transfer.',
      );
    }

    // Check budget contradiction (e.g. strict low budget vs expensive plan)
    final isBudgetRestricted =
        budgetConstraint != null &&
        (budgetConstraint.contains('30') ||
            budgetConstraint.contains('tight') ||
            budgetConstraint.contains('fixed income') ||
            budgetConstraint.contains('expensive'));

    if (isBudgetRestricted && product.id == 'prod-wireless-premium') {
      return ProductFitEvaluation(
        product: product,
        status: ProductFitStatus.unqualified,
        whyItFits: 'Customer has expressed strict budget sensitivity; pitching top-tier Premium (\$85) contradicts their financial comfort and breaches ethical selling standards.',
        whyItFitsArabic: 'العميل محدد ميزانية ضيقة؛ عرض باقة Premium (\$85) هنا يعتبر بيع غير أخلاقي وهيخسر ثقة العميل. الأنسب عرض Starter أو مراجعة خصومات AutoPay.',
        matchedNeeds: matchedNeeds,
        unknownPrerequisites: [],
        questionsToAskCustomer: [
          'What monthly price range feels most comfortable for your household budget?',
        ],
        recommendedTransitionPhrase: 'Let us look at our most cost-effective tier to keep your monthly cost right within your comfort zone.',
      );
    }

    // Determine standard fit
    ProductFitStatus status;
    String whyEn;
    String whyAr;
    String transition;

    if (matchedNeeds.length >= 2) {
      status = ProductFitStatus.strongFit;
      whyEn =
          'Strong alignment with customer profile (${matchedNeeds.join(", ")}). Features directly solve expressed pain points.';
      whyAr =
          'توافق قوي جداً مع احتياجات العميل (${matchedNeeds.join(", ")}). الباقة بتعالج المشكلة اللي اشتكى منها مباشرة وبسعر مناسب.';
      transition =
          'Based on what you shared regarding ${matchedNeeds.first}, our ${product.name} would be the ideal fit.';
    } else if (matchedNeeds.isNotEmpty) {
      status = ProductFitStatus.conditionalFit;
      whyEn = 'Moderate alignment with customer profile. Requires confirming whether customer values the additional features.';
      whyAr = 'توافق متوسط؛ اسأل العميل الأول لو الميزات الإضافية تهمه قبل ما تبدأ تشرح تفاصيل السعر.';
      transition =
          'You mentioned ${matchedNeeds.first}. Would you be interested in seeing how our ${product.name} handles that?';
    } else {
      status = ProductFitStatus.conditionalFit;
      whyEn = 'No direct need expressed yet. Probe further before recommending this product.';
      whyAr = 'العميل لسه مذكرش احتياج صريح للمنتج ده. استمر في الأسئلة المفتوحة (Discovery) وماتستعجلش في العرض.';
      transition = 'May I ask how your household currently uses your service, to see if this might be relevant?';
    }

    return ProductFitEvaluation(
      product: product,
      status: status,
      whyItFits: whyEn,
      whyItFitsArabic: whyAr,
      matchedNeeds: matchedNeeds,
      unknownPrerequisites: product.unknownEligibilityPrerequisites,
      questionsToAskCustomer: [
        'How many people in your household rely on this service every day?',
        'What is the single biggest frustration with your current setup?',
      ],
      recommendedTransitionPhrase: transition,
    );
  }

  /// Evaluates and ranks all standard products against customer expressed needs.
  static List<ProductFitEvaluation> rankCatalog({
    required List<String> expressedNeeds,
    String? budgetConstraint,
    bool addressChecked = false,
    bool numberPortChecked = false,
  }) {
    final evals = ProductFitCatalog.standardProducts.map((p) {
      return evaluateFit(
        product: p,
        expressedNeeds: expressedNeeds,
        budgetConstraint: budgetConstraint,
        addressChecked: addressChecked,
        numberPortChecked: numberPortChecked,
      );
    }).toList();

    // Sort: strongFit first, then conditionalFit, then needsVerification, then unqualified
    evals.sort((a, b) {
      final rankA = _statusRank(a.status);
      final rankB = _statusRank(b.status);
      if (rankA != rankB) return rankA.compareTo(rankB);
      return b.matchedNeeds.length.compareTo(a.matchedNeeds.length);
    });

    return evals;
  }

  static int _statusRank(ProductFitStatus s) {
    switch (s) {
      case ProductFitStatus.strongFit:
        return 0;
      case ProductFitStatus.conditionalFit:
        return 1;
      case ProductFitStatus.needsVerification:
        return 2;
      case ProductFitStatus.unqualified:
        return 3;
    }
  }
}
