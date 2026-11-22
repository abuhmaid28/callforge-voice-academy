import '../../core/evaluation/speech_evaluator.dart';
import '../../domain/entities/sales_scenario.dart';
import '../../domain/entities/sales_scorecard.dart';

/// Evaluates representative spoken turns during consultative sales simulations.
/// Enforces transparent, practice-grounded rubric criteria without artificial KPIs.
abstract class SalesEvaluator {
  /// Known prohibited promises that breach floor compliance and policy standards.
  static const List<String> universalProhibitedPromises = [
    'guarantee price for life',
    'lock your rate forever',
    'waive all fees guaranteed',
    'promise a supervisor callback',
    'guaranteed number transfer',
    'guarantee tomorrow installation',
    'free service forever',
    'unlimited credits',
    'promise you will never pay taxes',
  ];

  /// Open-ended discovery question anchors.
  static const List<String> discoveryQuestionMarkers = [
    'who',
    'what',
    'how',
    'tell me about',
    'help me understand',
    'share with me',
    'which',
    'could you explain',
    'may i ask how',
  ];

  /// Ethical permission and exploration anchors.
  static const List<String> permissionMarkers = [
    'may i',
    'is it okay if',
    'is it alright',
    'would you mind if',
    'do i have your permission',
    'would you like me to check',
    'can we look at',
  ];

  /// Respectful closing and no-sale acknowledgment anchors.
  static const List<String> respectfulDeclineMarkers = [
    'completely understand',
    'no problem at all',
    'keep everything as is',
    'leave your plan exactly',
    'respect your decision',
    'no pressure',
    'whenever you are ready',
    'door is always open',
    'is there anything else',
  ];

  /// Evaluates an entire consultative sales conversation transcript against the scenario graph.
  static SalesScorecard evaluateSalesCall({
    required SalesScenario scenario,
    required List<String> agentUtterances,
    required SalesOutcomeType reachedOutcome,
    required List<SalesTurn> completedTurns,
  }) {
    final allAgentText = agentUtterances.join(' ').toLowerCase();
    final normalizedAll = SpeechEvaluator.normalize(allAgentText);

    // 1. Check Prohibited Promises
    final detectedProhibited = <String>[];
    for (final phrase in universalProhibitedPromises) {
      if (normalizedAll.contains(phrase.toLowerCase())) {
        detectedProhibited.add(phrase);
      }
    }
    for (final phrase in scenario.prohibitedPromises) {
      if (normalizedAll.contains(phrase.toLowerCase())) {
        if (!detectedProhibited.contains(phrase)) {
          detectedProhibited.add(phrase);
        }
      }
    }

    final dimensions = <ScorecardDimension>[];

    // Dimension 1: Opening Discipline
    final openingTurn = agentUtterances.isNotEmpty ? agentUtterances.first : '';
    final openingNorm = SpeechEvaluator.normalize(openingTurn);
    final hasAlex = openingNorm.contains('alex');
    final hasAtt = RegExp(r'\b(att|at&t|at and t|at t)\b')
        .hasMatch(openingNorm);
    final hasNameRequest =
        openingNorm.contains('name') ||
        (openingNorm.contains('first') && openingNorm.contains('last'));

    ScorecardRating openingRating;
    String openingSnippet = openingTurn;
    String openingFeedbackEn;
    String openingFeedbackAr;

    if (hasAlex && hasAtt && hasNameRequest) {
      openingRating = ScorecardRating.exemplary;
      openingFeedbackEn = 'Verbatim opening delivered with confident identity and caller name verification.';
      openingFeedbackAr = 'افتتاحية ممتازة: ذكرت اسمك Alex واسم الشركة AT&T وطلبت اسم العميل باحترافية.';
    } else if (hasAlex && hasAtt) {
      openingRating = ScorecardRating.proficient;
      openingFeedbackEn = 'Mandatory alias and carrier stated; remember to ask for first and last name.';
      openingFeedbackAr = 'بداية جيدة: ذكرت Alex و AT&T، بس متنساش تطلب الاسم الأول والأخير للعميل.';
    } else {
      openingRating = ScorecardRating.developing;
      openingFeedbackEn = 'Mandatory opening missed required Alex alias or AT&T identification.';
      openingFeedbackAr = 'الافتتاحية الإلزامية غير مكتملة؛ لازم تذكر اسمك Alex وشركة AT&T بوضوح.';
    }

    dimensions.add(
      ScorecardDimension(
        key: 'opening_discipline',
        label: 'Opening Discipline & Identity',
        labelArabic: 'الانضباط في الافتتاحية والتعريف بالهوية',
        rating: openingRating,
        evidenceSnippet: openingSnippet,
        feedbackEnglish: openingFeedbackEn,
        feedbackArabic: openingFeedbackAr,
      ),
    );

    // Dimension 2: Needs Discovery Quality
    final hasDiscoveryQuestions = discoveryQuestionMarkers.any(
      (m) => normalizedAll.contains(m),
    );
    int questionCount = RegExp(r'\?').allMatches(allAgentText).length;
    final interrogativeRegex = RegExp(
      r'\b(who|what|where|when|why|how|which|tell me|could you|would you|can you|do you|are you|is there|did you)\b',
    );
    for (final utterance in agentUtterances) {
      final normU = SpeechEvaluator.normalize(utterance);
      if (normU.contains('?') || interrogativeRegex.hasMatch(normU)) {
        questionCount++;
      }
    }

    ScorecardRating discoveryRating;
    String discoveryFeedbackEn;
    String discoveryFeedbackAr;

    if (hasDiscoveryQuestions && questionCount >= 2) {
      discoveryRating = ScorecardRating.exemplary;
      discoveryFeedbackEn = 'Excellent open-ended probing uncovering household usage and core pain points.';
      discoveryFeedbackAr = 'أسئلة استكشافية ممتازة: استخدمت أدوات الاستفهام المفتوحة وفهمت احتياج العميل الحقيقي.';
    } else if (hasDiscoveryQuestions || questionCount >= 1) {
      discoveryRating = ScorecardRating.proficient;
      discoveryFeedbackEn = 'Good discovery inquiry; ask an additional follow-up question before presenting solutions.';
      discoveryFeedbackAr = 'استكشاف مقبول؛ حاول تسأل سؤال متابعة إضافي عن سرعة أو عدد أجهزة البيت قبل العرض.';
    } else {
      discoveryRating = ScorecardRating.developing;
      discoveryFeedbackEn = 'Direct pitch without open discovery questions; feels transactional rather than consultative.';
      discoveryFeedbackAr = 'العرض تم بسرعة بدون أسئلة استكشاف؛ لازم تفهم المشكلة الأول عشان العرض يكون مقنع.';
    }

    dimensions.add(
      ScorecardDimension(
        key: 'need_discovery',
        label: 'Needs Discovery & Inquiry',
        labelArabic: 'استكشاف احتياجات العميل',
        rating: discoveryRating,
        evidenceSnippet: _findSnippetWithMarkers(
          agentUtterances,
          discoveryQuestionMarkers,
        ),
        feedbackEnglish: discoveryFeedbackEn,
        feedbackArabic: discoveryFeedbackAr,
      ),
    );

    // Dimension 3: Active Listening & AERD
    final hasAcknowledge =
        normalizedAll.contains('understand') ||
        normalizedAll.contains('see') ||
        normalizedAll.contains('hear');
    final hasEmpathy =
        normalizedAll.contains('appreciate') ||
        normalizedAll.contains('frustrat') ||
        normalizedAll.contains('sorry') ||
        normalizedAll.contains('glad');
    final hasReassure =
        normalizedAll.contains('right place') ||
        normalizedAll.contains('help you') ||
        normalizedAll.contains('take care') ||
        normalizedAll.contains('look into');

    ScorecardRating aerdRating;
    String aerdFeedbackEn;
    String aerdFeedbackAr;

    if (hasAcknowledge && hasEmpathy && hasReassure) {
      aerdRating = ScorecardRating.exemplary;
      aerdFeedbackEn = 'Outstanding AERD execution: acknowledged concern, validated emotion, and provided confidence.';
      aerdFeedbackAr = 'تطبيق مثالي لنموذج AERD: احتويت انزعاج العميل وطمنته إنك هتحل المشكلة.';
    } else if (hasAcknowledge || hasReassure) {
      aerdRating = ScorecardRating.proficient;
      aerdFeedbackEn = 'Good listening acknowledgment; strengthen the empathy bridge before pivoting.';
      aerdFeedbackAr = 'استماع جيد؛ زود جرعة التعاطف بعبارة زي "I completely appreciate how frustrating that is".';
    } else {
      aerdRating = ScorecardRating.developing;
      aerdFeedbackEn = 'Rushed past customer concern without acknowledging their frustration.';
      aerdFeedbackAr = 'تجاهلت انزعاج العميل ودخلت في الحل مباشرة؛ لازم تعترف بالمشكلة الأول.';
    }

    dimensions.add(
      ScorecardDimension(
        key: 'active_listening_aerd',
        label: 'Active Listening & AERD Empathy',
        labelArabic: 'الاستماع النشط ونموذج الاحتواء AERD',
        rating: aerdRating,
        evidenceSnippet: _findSnippetWithMarkers(agentUtterances, [
          'understand',
          'appreciate',
          'help you',
        ]),
        feedbackEnglish: aerdFeedbackEn,
        feedbackArabic: aerdFeedbackAr,
      ),
    );

    // Dimension 4: Value Relevance & Tailored Solution
    final mentionsProduct =
        scenario.fictionalCandidateProducts.any(
          (p) => normalizedAll.contains(
            p.toLowerCase().replaceAll('prod-', '').replaceAll('-', ' '),
          ),
        ) ||
        normalizedAll.contains('plan') ||
        normalizedAll.contains('fiber') ||
        normalizedAll.contains('unlimited');

    ScorecardRating valueRating;
    String valueFeedbackEn;
    String valueFeedbackAr;

    if (mentionsProduct && hasDiscoveryQuestions) {
      valueRating = ScorecardRating.exemplary;
      valueFeedbackEn = 'Solution was logically connected to customer expressed needs with clear benefit articulation.';
      valueFeedbackAr = 'ربط ممتاز بين ميزات الباقة واحتياج العميل اللي قاله في أول المكالمة.';
    } else if (mentionsProduct) {
      valueRating = ScorecardRating.proficient;
      valueFeedbackEn = 'Relevant product mentioned; explain more explicitly how it saves money or improves experience.';
      valueFeedbackAr =
          'عرضت المنتج المناسب؛ وضح للعميل أكتر إزاي ده هيوفرله أو يحسن سرعته.';
    } else {
      valueRating = ScorecardRating.developing;
      valueFeedbackEn =
          'Product value was vague or disconnected from customer situation.';
      valueFeedbackAr = 'القيمة المضافة للمنتج ماكانتش واضحة كفاية للعميل.';
    }

    dimensions.add(
      ScorecardDimension(
        key: 'value_relevance',
        label: 'Value Relevance & Solution Match',
        labelArabic: 'ملاءمة القيمة والحل المقترح',
        rating: valueRating,
        evidenceSnippet: _findSnippetWithMarkers(agentUtterances, [
          'plan',
          'fiber',
          'save',
          'speed',
          'benefit',
        ]),
        feedbackEnglish: valueFeedbackEn,
        feedbackArabic: valueFeedbackAr,
      ),
    );

    // Dimension 5: Permission & Ethical Consent (evaluated on consultative turns after greeting)
    final consultativeUtterances = agentUtterances.length > 1
        ? agentUtterances.sublist(1).join(' ').toLowerCase()
        : '';
    final consultativeNorm = SpeechEvaluator.normalize(consultativeUtterances);
    final hasPermission = permissionMarkers.any(
      (m) => consultativeNorm.contains(m),
    );

    ScorecardRating permissionRating;
    String permissionFeedbackEn;
    String permissionFeedbackAr;

    if (hasPermission) {
      permissionRating = ScorecardRating.exemplary;
      permissionFeedbackEn = 'Respectful consultative bridge: asked caller permission before reviewing account or options.';
      permissionFeedbackAr = 'استئذان راقي: استأذنت العميل الأول قبل ما تفتح حسابه أو تقترح باقة جديدة.';
    } else if (completedTurns.length <= 4) {
      permissionRating = ScorecardRating.notAssessed;
      permissionFeedbackEn =
          'Call ended before consultative transition; dimension not assessed.';
      permissionFeedbackAr =
          'المكالمة انتهت قبل مرحلة الانتقال للعرض؛ لم يتم التقييم.';
    } else {
      permissionRating = ScorecardRating.developing;
      permissionFeedbackEn =
          'Pivoted into sales exploration without asking customer permission.';
      permissionFeedbackAr = 'بدأت تعرض بدون استئذان العميل؛ دايمًا اسأل "May I check your account?" الأول.';
    }

    dimensions.add(
      ScorecardDimension(
        key: 'permission_consent',
        label: 'Permission & Customer Autonomy',
        labelArabic: 'الاستئذان واحترام حرية العميل',
        rating: permissionRating,
        evidenceSnippet: _findSnippetWithMarkers(
          agentUtterances,
          permissionMarkers,
        ),
        feedbackEnglish: permissionFeedbackEn,
        feedbackArabic: permissionFeedbackAr,
      ),
    );

    // Dimension 6: Factual Safety & Policy Guardrails
    ScorecardRating safetyRating;
    String safetyFeedbackEn;
    String safetyFeedbackAr;

    if (detectedProhibited.isEmpty) {
      safetyRating = ScorecardRating.exemplary;
      safetyFeedbackEn = 'Full factual integrity: zero unauthorized guarantees, fee waivers, or rate locks.';
      safetyFeedbackAr = 'أمان تام في المعلومات: لم تقدم أي وعود غير مصرح بها أو ضمانات أسعار أبدية.';
    } else {
      safetyRating = ScorecardRating.developing;
      safetyFeedbackEn =
          'Compliance violation: detected prohibited promise (${detectedProhibited.join(", ")}).';
      safetyFeedbackAr =
          'تنبيه امتثال: تم رصد وعود محظورة (${detectedProhibited.join(", ")}). لا تعد العميل بما لا تملك تنفيذه.';
    }

    dimensions.add(
      ScorecardDimension(
        key: 'factual_safety',
        label: 'Factual Safety & Compliance',
        labelArabic: 'الدقة الواقعية والالتزام بالسياسات',
        rating: safetyRating,
        evidenceSnippet: detectedProhibited.isNotEmpty
            ? detectedProhibited.first
            : 'Clean factual compliance.',
        feedbackEnglish: safetyFeedbackEn,
        feedbackArabic: safetyFeedbackAr,
      ),
    );

    // Dimension 7: Objection Handling & Respectful Close
    final isDeclineOutcome =
        reachedOutcome == SalesOutcomeType.respectfulNoSale;
    final hasRespectfulDecline = respectfulDeclineMarkers.any(
      (m) => normalizedAll.contains(m),
    );

    ScorecardRating closeRating;
    String closeFeedbackEn;
    String closeFeedbackAr;
    bool isNoSaleSuccess = false;

    if (isDeclineOutcome) {
      if (hasRespectfulDecline) {
        closeRating = ScorecardRating.exemplary;
        isNoSaleSuccess = true;
        closeFeedbackEn = 'Masterful No-Sale Success: customer declined and you gracefully respected their decision without badgering.';
        closeFeedbackAr = 'نجاح بيعي أخلاقي (No-Sale Success): العميل رفض وأنت احترمت رغبته باحترافية بدون إلحاح مزعج.';
      } else {
        closeRating = ScorecardRating.proficient;
        isNoSaleSuccess = true;
        closeFeedbackEn = 'Customer declined; ensure you leave an explicit warm door open for future needs.';
        closeFeedbackAr =
            'العميل رفض؛ اترك انطباع طيب واعرض مساعدة إضافية في حسابه الحالي.';
      }
    } else if (reachedOutcome == SalesOutcomeType.qualifiedAccept) {
      closeRating = ScorecardRating.exemplary;
      closeFeedbackEn = 'Clean qualified close: customer consented with transparent disclosure review.';
      closeFeedbackAr = 'إغلاق بيعي ناجح ومكتمل بعد توضيح الشروط والخصومات.';
    } else if (reachedOutcome == SalesOutcomeType.needsVerification) {
      closeRating = ScorecardRating.proficient;
      closeFeedbackEn = 'Correct conditional outcome: paused to verify eligibility/address before false commitments.';
      closeFeedbackAr = 'تصرف سليم: وقفت العرض للتحقق من الأهلية أو العنوان قبل أي التزام رسمي.';
    } else {
      closeRating = ScorecardRating.developing;
      closeFeedbackEn =
          'Call ended without clear next steps or respectful resolution.';
      closeFeedbackAr = 'المكالمة انتهت بدون توضيح الخطوة القادمة للعميل.';
    }

    dimensions.add(
      ScorecardDimension(
        key: 'objection_close',
        label: 'Objection Handling & Respectful Close',
        labelArabic: 'التعامل مع الاعتراضات والإغلاق المحترم',
        rating: closeRating,
        evidenceSnippet: _findSnippetWithMarkers(
          agentUtterances,
          respectfulDeclineMarkers,
        ),
        feedbackEnglish: closeFeedbackEn,
        feedbackArabic: closeFeedbackAr,
      ),
    );

    // Calculate Overall Score (average of assessed dimensions)
    final assessedDims = dimensions.where((d) => d.isAssessed).toList();
    double totalWeight = 0.0;
    for (final d in assessedDims) {
      totalWeight += d.scoreWeight;
    }
    double overall = assessedDims.isNotEmpty
        ? totalWeight / assessedDims.length
        : 50.0;

    // Penalty for prohibited promises: drops score to at most 60
    if (detectedProhibited.isNotEmpty) {
      overall = overall.clamp(0.0, 55.0);
    }

    final passed = overall >= 70.0 && detectedProhibited.isEmpty;

    // Build Egyptian Arabic Tactical Advice
    String tacticalAdvice;
    if (detectedProhibited.isNotEmpty) {
      tacticalAdvice = 'أهم نقطة تركز عليها في المحاولة الجاية: ممنوع تقديم وعود بأسعار ثابتة أو إسقاط رسوم بدون فحص رسمي.';
    } else if (isNoSaleSuccess) {
      tacticalAdvice = 'تصرف ممتاز! احترام رفض العميل بيحافظ على ثقته في الشركة ومبيعتبرش فشل، بالعكس ده بيع أخلاقي سليم.';
    } else if (discoveryRating == ScorecardRating.developing) {
      tacticalAdvice = 'في المحاولة الجاية: اسأل العميل سؤالين مفتوحين (Who, What, How) قبل ما تبدأ تشرح الباقة.';
    } else if (passed) {
      tacticalAdvice = 'أداء متميز يا بطل! استمريت في السيطرة على المكالمة باحترافية وتوازن بين مصلحة العميل وسياسات الشركة.';
    } else {
      tacticalAdvice = 'محاولة جيدة: ركز في المرة الجاية على الاستئذان قبل فحص الحساب ومطابقة باقة مناسبة لميزانية العميل.';
    }

    // Build Model Rephrasing
    final modelRephrasing =
        scenario.turns.isNotEmpty &&
            scenario.turns.first.usEnglishModelResponse.isNotEmpty
        ? scenario.turns.first.usEnglishModelResponse
        : 'I completely understand your perspective, and I want to make sure your monthly setup fits your exact budget.';

    return SalesScorecard(
      scenarioId: scenario.id,
      timestamp: DateTime.now(),
      outcomeType: reachedOutcome,
      isNoSaleSuccess: isNoSaleSuccess,
      overallScore: overall,
      passed: passed,
      dimensions: dimensions,
      detectedProhibitedPromises: detectedProhibited,
      tacticalArabicAdvice: tacticalAdvice,
      recommendedRephrasing: modelRephrasing,
      keyEvidenceSnippets: agentUtterances.take(3).toList(),
    );
  }

  static String _findSnippetWithMarkers(
    List<String> utterances,
    List<String> markers,
  ) {
    for (final u in utterances) {
      final norm = u.toLowerCase();
      for (final m in markers) {
        if (norm.contains(m.toLowerCase())) {
          return u.trim();
        }
      }
    }
    return utterances.isNotEmpty ? utterances.first.trim() : '';
  }
}
