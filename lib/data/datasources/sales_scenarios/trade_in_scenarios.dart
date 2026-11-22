import '../../../core/constants/training_constants.dart';
import '../../../domain/entities/sales_scenario.dart';
import '../../../domain/entities/scenario.dart';

abstract class TradeInScenariosCatalog {
  static final List<SalesScenario> scenarios = [
    // Scenario 33: Cracked Screen Trade-In Qualification
    SalesScenario(
      id: 'sales-33-cracked-screen-tradein',
      title: 'Cracked Glass Screen Physical Trade-In Appraisal',
      category: 'trade_in_eip',
      difficulty: 'intermediate',
      profile: const SalesCustomerProfile(
        name: 'Brandon Walsh',
        tone: 'eager college student',
        currentProvider: 'AT&T Unlimited Extra',
        householdNeeds: 'Upgrade broken phone on 36-month installment plan',
        financialConstraint:
            'Tight budget, counting on maximum \$800 promotional credit',
        coreBlocker:
            'Phone has spiderweb cracks on front glass and corner casing dent',
      ),
      contextNotes: 'Saw a headline commercial for \$800 off with trade-in. However, device condition grading determines tier value.',
      skillTags: [
        'Condition Grading',
        'Expectation Calibration',
        'Transparent Appraisal',
      ],
      prohibitedPromises: [
        'promise top-tier \$800 trade-in credit for heavily damaged glass without physical evaluation',
        'promise cracked screen penalty can be bypassed or overridden',
      ],
      mandatoryDisclosures: [
        'Promotional trade-in credit tier requires device to be in good physical and working condition',
        'Cracked glass or display damage may reduce appraisal value to lower tier or fair market value',
        'Credits are applied over thirty-six monthly bill statements',
      ],
      fictionalCandidateProducts: ['prod-next-up-eip'],
      turns: [
        const SalesTurn(
          id: 'turn-ti33-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: TrainingConstants.standardGreeting,
          phase: SalesPhase.greeting,
          requiredKeywords: ['att', 'alex', 'first', 'last', 'name'],
          trainerGuidanceArabic: 'ابدأ بالترحيب الرسمي المعتمد.',
          usEnglishModelResponse: TrainingConstants.standardGreeting,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-ti33-02'),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti33-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Hey Alex! My name is Brandon Walsh. I saw your TV ad saying I can get eight hundred dollars off the new phone by trading in my old phone. My screen has spider cracks across the front. Can I still get the full eight hundred dollars credit?',
          phase: SalesPhase.initialResolution,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-ti33-03'),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti33-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'Thank you for calling Brandon, and I am glad you checked with us first! For the full eight hundred dollar promotional tier, the phone must be in good working condition with an intact, uncracked screen. A cracked screen lowers the valuation tier, but there are still trade-in options available.',
          phase: SalesPhase.explorationPermission,
          requiredKeywords: [
            'good working condition',
            'uncracked screen',
            'lowers',
            'valuation tier',
          ],
          trainerGuidanceArabic: 'صارح العميل بشفافية: الشاشة المكسورة تقلل فئة التقييم، وتجنب الوعود الكاذبة بـ 800 دولار كاملة.',
          usEnglishModelResponse: 'I am so glad you asked before sending it in, Brandon. To qualify for the top eight hundred dollar tier, the device display must be completely free of cracks. A cracked screen moves the device to a lower trade-in tier or fair market value credit.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-ti33-04'),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti33-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Oh man, that is a bummer. What tier would my cracked phone fall into, and how much would it actually save me on the monthly installment?',
          phase: SalesPhase.discovery,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-ti33-05'),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti33-05',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'With screen damage, it qualifies for the three hundred and fifty dollar promotional tier, or you could repair the glass screen first at an authorized repair center to qualify for the full eight hundred dollars. With the three hundred and fifty tier, it lowers your payment by about ten dollars a month over thirty-six months.',
          phase: SalesPhase.valueBridge,
          requiredKeywords: [
            'three hundred fifty',
            'repair',
            'authorized',
            'thirty-six months',
          ],
          trainerGuidanceArabic: 'قدم له خيارات عملية: الاستفادة من فئة 350 دولار أو إصلاح الشاشة أولاً في مركز معتمد للحصول على 800 دولار.',
          usEnglishModelResponse: 'With cracked glass, the promotional credit is three hundred and fifty dollars, which reduces your installment by roughly ten dollars monthly over thirty-six months. Alternatively, if you replace the glass at a certified repair shop first, you can qualify for the full eight hundred.',
          branches: [
            ScenarioBranch(conditionKey: 'accept', nextTurnId: 'turn-ti33-06A'),
            ScenarioBranch(
              conditionKey: 'decline',
              nextTurnId: 'turn-ti33-06B',
            ),
            ScenarioBranch(conditionKey: 'verify', nextTurnId: 'turn-ti33-06C'),
          ],
        ),
        // Path A: Qualified Accept
        const SalesTurn(
          id: 'turn-ti33-06A',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Taking the three hundred fifty dollar credit right now saves me the hassle of fixing the glass. Ten bucks off a month works within my college budget. Let us do it.',
          phase: SalesPhase.objectionHandling,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ti33-07A',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti33-07A',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'That is a very smart call, Brandon. I will order the new device on a thirty-six month installment agreement and generate your prepaid trade-in return shipping box with the condition accurately noted.',
          phase: SalesPhase.closing,
          requiredKeywords: [
            'thirty-six month',
            'installment agreement',
            'prepaid',
            'shipping box',
          ],
          trainerGuidanceArabic: 'أكد تفاصيل التقسيط لمدة 36 شهراً وصندوق الشحن مسبق الدفع مع تسجيل حالة الجهاز بدقة.',
          usEnglishModelResponse: 'That sounds like a great practical decision. I will set up the 36-month installment and mail you a padded trade-in box with prepaid label and instructions.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ti33-08A',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti33-08A',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText: 'Awesome! Thanks for being straight with me about the cracks Alex.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.qualifiedAccept,
        ),
        // Path B: Respectful No-Sale
        const SalesTurn(
          id: 'turn-ti33-06B',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Three hundred and fifty is way too low. I would rather just put a piece of tape over the crack and keep using this phone until it completely dies.',
          phase: SalesPhase.objectionHandling,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ti33-07B',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti33-07B',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'I completely understand, Brandon. Getting every drop of life out of your phone makes total sense. We will keep your account just as it is.',
          phase: SalesPhase.closing,
          requiredKeywords: ['understand', 'total sense', 'account', 'keep'],
          trainerGuidanceArabic: 'احترم رغبته في الاستمرار بجهازه الحالي دون إجباره على ترقية جديدة.',
          usEnglishModelResponse: 'I completely respect that, Brandon. Squeezing every ounce of value from your current phone is very smart. We will leave everything as is.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ti33-08B',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti33-08B',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText: 'Thanks Alex. Appreciate you not badgering me.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.respectfulNoSale,
        ),
        // Path C: Needs Verification
        const SalesTurn(
          id: 'turn-ti33-06C',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Let me get a repair estimate at the repair kiosk on campus first. If they can replace the glass for sixty bucks, I will do that and come back for the eight hundred dollar promo.',
          phase: SalesPhase.eligibilityBoundary,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ti33-07C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti33-07C',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'That is a very savvy financial plan, Brandon! Go check that glass repair quote first, and once it is repaired, contact us to submit the top-tier trade-in appraisal.',
          phase: SalesPhase.eligibilityBoundary,
          requiredKeywords: ['savvy', 'quote', 'repaired', 'top-tier'],
          trainerGuidanceArabic:
              'شجعه على فحص تكلفة الإصلاح أولاً؛ ده تفكير مالي ذكي وسليم.',
          usEnglishModelResponse: 'That is a great strategy. If you can fix the glass for sixty dollars and unlock four hundred and fifty dollars more in credit, that is a huge win. Reach back out once it is fixed!',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ti33-08C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti33-08C',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText:
              'I will check the shop today. Thanks for the great tip, Alex!',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.needsVerification,
        ),
      ],
    ),

    // Scenario 34: Next Up Early Upgrade at 50%
    SalesScenario(
      id: 'sales-34-next-up-early-upgrade',
      title: 'AT&T Next Up Mid-Contract Upgrade at 50% Milestone',
      category: 'trade_in_eip',
      difficulty: 'intermediate',
      profile: const SalesCustomerProfile(
        name: 'Samantha Reed',
        tone: 'tech-enthusiast professional',
        currentProvider: 'AT&T Unlimited Premium',
        householdNeeds: 'Upgrade to latest flagship phone released this week',
        financialConstraint:
            'Does not want to pay off remaining \$550 balance out-of-pocket',
        coreBlocker:
            'Currently at month 19 of 36 on existing device installment plan',
      ),
      contextNotes: 'Has active Next Up feature (\$6/mo) and has reached 50% payoff threshold (18+ months). Eligible to turn in phone and waive remaining 17 months.',
      skillTags: [
        'Next Up Feature',
        'Mid-Contract Turn-In',
        'Installment Balance Waiver',
      ],
      prohibitedPromises: [
        'promise customer keeps both the old phone and gets the balance wiped',
        'waive the return turn-in condition requirement',
      ],
      mandatoryDisclosures: [
        'Next Up requires turning in the current device in good physical and operational condition',
        'Remaining installment balance on the old device is waived upon inspection',
        'New device begins a new thirty-six month installment agreement',
      ],
      fictionalCandidateProducts: ['prod-next-up-eip'],
      turns: [
        const SalesTurn(
          id: 'turn-ti34-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: TrainingConstants.standardGreeting,
          phase: SalesPhase.greeting,
          requiredKeywords: ['att', 'alex', 'first', 'last', 'name'],
          trainerGuidanceArabic: 'ابدأ بالترحيب الرسمي المعتمد.',
          usEnglishModelResponse: TrainingConstants.standardGreeting,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-ti34-02'),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti34-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Hello Alex. My name is Samantha Reed. The new flagship phone just launched, and I really want to upgrade. But my account app says I still owe five hundred and forty dollars on my current installment plan. Do I have to pay that all off right now?',
          phase: SalesPhase.initialResolution,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-ti34-03'),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti34-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'I have wonderful news for you, Ms. Reed! You have the AT&T Next Up feature active on your line, and you have completed nineteen monthly payments, which means you have passed the fifty percent payoff mark. You can turn in your current phone and have the entire remaining balance waived.',
          phase: SalesPhase.explorationPermission,
          requiredKeywords: ['next up', 'fifty percent', 'turn in', 'waived'],
          trainerGuidanceArabic: 'اشرح ميزة Next Up: بما أنها سددت أكثر من 50%، يمكنها تسليم هاتفها الحالي وإسقاط باقي الأقساط (540 دولار) بالكامل.',
          usEnglishModelResponse: 'Great news Samantha! Your account has the AT&T Next Up feature and you are at month 19. That means you have reached 50% payoff. You can trade in your existing phone, and the remaining 540 dollar balance is completely forgiven.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-ti34-04'),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti34-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'That is amazing! And does the new device require Next Up again, or can I choose whether to add it?',
          phase: SalesPhase.discovery,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-ti34-05'),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti34-05',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Next Up is completely optional on your new thirty-six month installment agreement. It is six dollars a month and gives you the exact same freedom to upgrade at fifty percent next time, or you can opt out if you prefer to keep the phone for the full three years.',
          phase: SalesPhase.valueBridge,
          requiredKeywords: [
            'optional',
            'thirty-six month',
            'six dollars',
            'opt out',
          ],
          trainerGuidanceArabic: 'وضح أن إضافة Next Up اختيارية بـ 6 دولارات شهرياً لمنحها حرية الترقية المبكرة مجدداً، أو يمكنها الاستغناء عنها.',
          usEnglishModelResponse: 'It is entirely your choice. Next Up is six dollars monthly. If you love getting the latest flagship every eighteen months, it is fantastic. If you plan to keep this phone longer, you do not have to add it.',
          branches: [
            ScenarioBranch(conditionKey: 'accept', nextTurnId: 'turn-ti34-06A'),
            ScenarioBranch(
              conditionKey: 'decline',
              nextTurnId: 'turn-ti34-06B',
            ),
            ScenarioBranch(conditionKey: 'verify', nextTurnId: 'turn-ti34-06C'),
          ],
        ),
        // Path A: Qualified Accept
        const SalesTurn(
          id: 'turn-ti34-06A',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'I definitely want Next Up again because I always upgrade every two years. Waiving that five hundred and forty dollars makes my day. Let us process the order!',
          phase: SalesPhase.objectionHandling,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ti34-07A',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti34-07A',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'I will place the order for your new flagship device today with Next Up included, and provide a prepaid return kit to send back your current phone within thirty days of delivery.',
          phase: SalesPhase.closing,
          requiredKeywords: [
            'flagship',
            'next up',
            'prepaid return kit',
            'thirty days',
          ],
          trainerGuidanceArabic: 'أكد تفاصيل الطلب وحزمة الإرجاع مسبقة الدفع خلال 30 يوماً من الاستلام.',
          usEnglishModelResponse: 'I will submit the new order right away with Next Up attached. You will receive the new phone along with a return mailer to return your current phone within 30 days.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ti34-08A',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti34-08A',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText: 'Fabulous! You made this upgrade so easy and straightforward, Alex.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.qualifiedAccept,
        ),
        // Path B: Respectful No-Sale
        const SalesTurn(
          id: 'turn-ti34-06B',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Actually, having to mail back my phone means I cannot pass it down to my younger sister. I think I would rather just finish paying it off so she can have it.',
          phase: SalesPhase.objectionHandling,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ti34-07B',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti34-07B',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'Passing your phone down to family is a wonderful gesture, Ms. Reed. We will keep your installment running normally, and you can also remove the six-dollar Next Up feature to save money.',
          phase: SalesPhase.closing,
          requiredKeywords: [
            'family',
            'installment',
            'running normally',
            'save money',
          ],
          trainerGuidanceArabic: 'احترم رغبتها في إهداء الهاتف لأختها واقترح إلغاء ميزة الـ 6 دولارات لتوفير المال.',
          usEnglishModelResponse: 'Passing it down to your sister is a fantastic idea. We will leave your current plan intact. You can even drop the six dollar Next Up fee now to save on your bill.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ti34-08B',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti34-08B',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText: 'Thank you so much Alex! That saves me money right now.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.respectfulNoSale,
        ),
        // Path C: Needs Verification
        const SalesTurn(
          id: 'turn-ti34-06C',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Before ordering, my phone has a minor scratch on the aluminum bezel. Does Next Up turn-in accept minor cosmetic scratches?',
          phase: SalesPhase.eligibilityBoundary,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ti34-07C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti34-07C',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'Standard normal wear and tear like light bezel scuffs is acceptable, but the glass and screen must be crack-free. Let me open the physical condition checklist to verify the exact criteria with you.',
          phase: SalesPhase.eligibilityBoundary,
          requiredKeywords: [
            'wear and tear',
            'acceptable',
            'crack-free',
            'condition checklist',
          ],
          trainerGuidanceArabic:
              'راجع معها قائمة معايير الفحص المعتمدة للخدوش الطبيعية.',
          usEnglishModelResponse: 'Normal cosmetic surface scuffs are fine as long as there are no cracks, water damage, or screen burn-in. Let me walk you through the five-point physical checklist.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ti34-08C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti34-08C',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText: 'Great, let us go through those five checklist points first so I have zero surprises.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.needsVerification,
        ),
      ],
    ),

    // Scenario 35: BYOD vs 36-Month Financing
    SalesScenario(
      id: 'sales-35-byod-vs-installment',
      title: 'BYOD Unlocked Device vs 36-Month Installment Value Comparison',
      category: 'trade_in_eip',
      difficulty: 'intermediate',
      profile: const SalesCustomerProfile(
        name: 'Marcus Brody',
        tone: 'analytical cost-conscious consumer',
        currentProvider: 'Competitor BYOD',
        householdNeeds: 'Deciding whether to bring unlocked device or take 36-month financing',
        financialConstraint: 'Refuses long commitments unless total 3-year cost is mathematically superior',
        coreBlocker:
            'Skeptical of 36-month device contracts masking high monthly bills',
      ),
      contextNotes: 'Has an unlocked phone in great shape. Wants transparent side-by-side total cost of ownership analysis.',
      skillTags: [
        'Total Cost Analysis',
        'BYOD Transparency',
        'Math-Based Trust',
      ],
      prohibitedPromises: [
        'claim 36-month financing has zero commitments or penalties if leaving early',
        'hide the accelerated balance obligation if customer cancels wireless service',
      ],
      mandatoryDisclosures: [
        'Bringing your own device has zero equipment cost and zero device lock-in',
        'Device installment credits require keeping the wireless line active for thirty-six months',
        'Cancelling service before thirty-six months makes remaining device balance due immediately',
      ],
      fictionalCandidateProducts: ['prod-wireless-starter', 'prod-next-up-eip'],
      turns: [
        const SalesTurn(
          id: 'turn-ti35-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: TrainingConstants.standardGreeting,
          phase: SalesPhase.greeting,
          requiredKeywords: ['att', 'alex', 'first', 'last', 'name'],
          trainerGuidanceArabic: 'ابدأ بالترحيب الرسمي المعتمد.',
          usEnglishModelResponse: TrainingConstants.standardGreeting,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-ti35-02'),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti35-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Hello Alex, Marcus Brody here. I have an unlocked phone paid in full that works fine. A sales rep told me I am stupid if I do not finance a new phone for thirty-six months to get bill credits. Can you give me an honest financial breakdown comparing BYOD versus taking your new phone promo?',
          phase: SalesPhase.initialResolution,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-ti35-03'),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti35-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'I appreciate your direct question Marcus, and bringing your own paid-off phone is never stupid—it gives you total freedom! Let us look at the numbers honestly side by side so you can choose what fits your financial philosophy.',
          phase: SalesPhase.explorationPermission,
          requiredKeywords: [
            'total freedom',
            'numbers',
            'side by side',
            'financial philosophy',
          ],
          trainerGuidanceArabic: 'احترم ذكاء العميل وانصف خيار BYOD (إحضار جهازه الخاص) باعتباره حرية كاملة دون أي التزامات.',
          usEnglishModelResponse: 'I respect that completely, Marcus. Bringing your own device is a great financial move because you have zero hardware payments and zero commitment. Let us compare the exact 36-month cost of both paths.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-ti35-04'),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti35-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Lay it out for me. What are the pros and cons of both over three years?',
          phase: SalesPhase.discovery,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-ti35-05'),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti35-05',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'With BYOD, you pay just thirty-five dollars monthly on Starter with zero device charge and can leave whenever you want. With the promo, you get an eight hundred dollar phone discounted via bill credits over thirty-six months, but if you cancel early, the remaining unpaid balance becomes due immediately.',
          phase: SalesPhase.valueBridge,
          requiredKeywords: [
            'byod',
            'thirty-five dollars',
            'bill credits',
            'due immediately',
          ],
          trainerGuidanceArabic: 'قارن بشفافية كاملة: BYOD يمنح حرية الإلغاء، بينما الترقية تقسط الجهاز وتلزم بسداد الباقي فوراً في حال الإلغاء المبكر.',
          usEnglishModelResponse: 'With BYOD, your line cost is just \$35 on Starter with no hardware obligations. With the 36-month promo, you get a premium \$800 phone nearly offset by credits, but you must remain on the network for the full 36 months or pay the remaining balance.',
          branches: [
            ScenarioBranch(conditionKey: 'accept', nextTurnId: 'turn-ti35-06A'),
            ScenarioBranch(
              conditionKey: 'decline',
              nextTurnId: 'turn-ti35-06B',
            ),
            ScenarioBranch(conditionKey: 'verify', nextTurnId: 'turn-ti35-06C'),
          ],
        ),
        // Path A: Qualified Accept (Chooses BYOD SIM-only)
        const SalesTurn(
          id: 'turn-ti35-06A',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'I love the transparency. Since I plan on keeping my phone for another year, BYOD SIM-only with zero device debt is 100% the right choice for me. Set up my BYOD line.',
          phase: SalesPhase.objectionHandling,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ti35-07A',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti35-07A',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'That is a fantastic, debt-free choice, Marcus. I will set up your BYOD service with an eSIM activation or mail a SIM card with zero activation fee.',
          phase: SalesPhase.closing,
          requiredKeywords: ['debt-free', 'byod service', 'esim', 'sim card'],
          trainerGuidanceArabic: 'أكد تفعيل شريحة BYOD (سواء eSIM أو شريحة تقليدية) بدون أي قيود على الجهاز.',
          usEnglishModelResponse: 'That is an exceptionally smart move. I will order a BYOD line via instant eSIM or physical SIM with zero device commitments.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ti35-08A',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti35-08A',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText: 'You are the first rep who did not try to force a phone down my throat. Thank you Alex!',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.qualifiedAccept,
        ),
        // Path B: Respectful No-Sale
        const SalesTurn(
          id: 'turn-ti35-06B',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'I think thirty-five dollars is still higher than my current prepaid carrier who gives me fifteen dollar service. I will stay where I am.',
          phase: SalesPhase.objectionHandling,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ti35-07B',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti35-07B',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'I respect that arithmetic, Marcus. Fifteen dollars for your current usage is hard to beat. We will make no changes today.',
          phase: SalesPhase.closing,
          requiredKeywords: ['arithmetic', 'hard to beat', 'no changes'],
          trainerGuidanceArabic:
              'احترم رغبته في التمسك بالباقة مسبقة الدفع الأرخص ولا تضغط عليه.',
          usEnglishModelResponse: 'I completely respect that financial logic, Marcus. Fifteen dollars on prepaid is a great deal for light usage. We will leave everything as is.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ti35-08B',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti35-08B',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText: 'Thanks for your honesty, Alex. Good talking to you.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.respectfulNoSale,
        ),
        // Path C: Needs Verification
        const SalesTurn(
          id: 'turn-ti35-06C',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Let me check my phone’s IMEI number on your compatibility checker first to confirm it supports all your 5G frequency bands.',
          phase: SalesPhase.eligibilityBoundary,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ti35-07C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti35-07C',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'That is the ideal technical step, Marcus. Read me the fifteen-digit IMEI number from your settings, and I will verify its carrier unlock status and 5G band support on our network.',
          phase: SalesPhase.eligibilityBoundary,
          requiredKeywords: [
            'fifteen-digit',
            'imei',
            'carrier unlock',
            'verify',
          ],
          trainerGuidanceArabic: 'تحقق من رقم IMEI للتأكد من فك تشفير الجهاز ودعمه لترددات شبكة 5G.',
          usEnglishModelResponse: 'That is the most thorough approach. Share your 15-digit IMEI and I will run it through our hardware verification portal right now.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ti35-08C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti35-08C',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText:
              'Let me grab the IMEI from my settings right now. Good check.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.needsVerification,
        ),
      ],
    ),

    // Scenario 36: Activation Lock & iCloud Removal
    SalesScenario(
      id: 'sales-36-activation-lock-removal',
      title: 'iCloud Activation Lock & Factory Reset Trade-In Prerequisite',
      category: 'trade_in_eip',
      difficulty: 'intermediate',
      profile: const SalesCustomerProfile(
        name: 'Rebecca Torres',
        tone: 'busy working mother',
        currentProvider: 'AT&T Unlimited Extra',
        householdNeeds:
            'Send in old trade-in phone to secure \$700 bill credit',
        financialConstraint:
            'Needs bill credit applied promptly to avoid budget shortfall',
        coreBlocker: 'Did not disable "Find My" / iCloud Activation Lock before packing box',
      ),
      contextNotes: 'CRITICAL TRADE-IN REJECTION CAUSE: Phones returned with active iCloud/Google locks are classified as lost/stolen and awarded \$0 trade-in credit.',
      skillTags: [
        'Trade-In Safeguard',
        'Activation Lock Clearance',
        'Step-by-Step Guidance',
      ],
      prohibitedPromises: [
        'promise warehouse technicians can bypass iCloud or Google locks',
        'claim the trade-in credit will process even if device is locked',
      ],
      mandatoryDisclosures: [
        'Trade-in devices must have Find My and all cloud activation locks turned off before shipment',
        'Locked devices will be rejected by the warehouse evaluation center resulting in zero trade-in credit',
      ],
      fictionalCandidateProducts: ['prod-next-up-eip'],
      turns: [
        const SalesTurn(
          id: 'turn-ti36-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: TrainingConstants.standardGreeting,
          phase: SalesPhase.greeting,
          requiredKeywords: ['att', 'alex', 'first', 'last', 'name'],
          trainerGuidanceArabic: 'ابدأ بالترحيب الرسمي المعتمد.',
          usEnglishModelResponse: TrainingConstants.standardGreeting,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-ti36-02'),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti36-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Hi Alex, my name is Rebecca Torres. I have my trade-in return box sitting on the kitchen counter ready to tape up. The instruction sheet says something about turning off Find My and removing iCloud locks. Does that really matter if I already erased my photos?',
          phase: SalesPhase.initialResolution,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-ti36-03'),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti36-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'I am so thankful you called before taping that box, Rebecca! It matters tremendously. If Find My or Activation Lock remains active, the warehouse evaluation center cannot test or recondition the phone, and by federal regulation, it must be valued at zero dollars.',
          phase: SalesPhase.explorationPermission,
          requiredKeywords: [
            'thankful',
            'matters',
            'activation lock',
            'zero dollars',
          ],
          trainerGuidanceArabic: 'تحذير جوهري: إذا بقيت ميزة Find My مفعلة، المركز اللوجستي سيرفض الجهاز وتلغى قيمة التقييم لتصبح صفر دولار.',
          usEnglishModelResponse: 'I am so glad you called, Rebecca! It is absolutely essential. If iCloud or Find My is still attached, the intake facility cannot access the phone and the trade-in valuation automatically drops to zero dollars.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-ti36-04'),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti36-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Oh my goodness, I would have lost seven hundred dollars! How do I make sure it is completely unlocked before I put it in the box?',
          phase: SalesPhase.discovery,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-ti36-05'),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti36-05',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'It takes just two minutes: Go to Settings, tap your name at the top, select iCloud, tap Find My, and toggle Find My iPhone off with your Apple password. Then go to Transfer or Reset and choose Erase All Content and Settings.',
          phase: SalesPhase.valueBridge,
          requiredKeywords: [
            'settings',
            'find my',
            'toggle off',
            'erase all content',
          ],
          trainerGuidanceArabic: 'اشرح الخطوات بوضوح: الإعدادات -> الاسم -> Find My -> إيقاف -> مسح جميع المحتويات والإعدادات.',
          usEnglishModelResponse: 'It is very quick: Open Settings, tap your profile at the top, tap Find My, toggle off Find My iPhone and enter your Apple ID password. Then do a final Factory Reset.',
          branches: [
            ScenarioBranch(conditionKey: 'accept', nextTurnId: 'turn-ti36-06A'),
            ScenarioBranch(
              conditionKey: 'decline',
              nextTurnId: 'turn-ti36-06B',
            ),
            ScenarioBranch(conditionKey: 'verify', nextTurnId: 'turn-ti36-06C'),
          ],
        ),
        // Path A: Qualified Accept
        const SalesTurn(
          id: 'turn-ti36-06A',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'I just toggled it off and saw the Hello welcome screen appear! Now it is completely clean and ready to drop in the mail.',
          phase: SalesPhase.objectionHandling,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ti36-07A',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti36-07A',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'Seeing that Hello screen confirms your activation lock is 100% cleared! You can now safely seal the box and drop it at the post office with the tracking receipt.',
          phase: SalesPhase.closing,
          requiredKeywords: [
            'hello screen',
            'cleared',
            'seal the box',
            'tracking receipt',
          ],
          trainerGuidanceArabic: 'ظهور شاشة الترحيب (Hello) يؤكد نجاح إلغاء القفل. شجعها على الاحتفاظ بإيصال التتبع.',
          usEnglishModelResponse: 'That Hello screen confirms the device is completely unlocked and ready. Seal the package and keep the postal drop-off tracking receipt.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ti36-08A',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti36-08A',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText: 'You just saved my seven hundred dollar credit, Alex! You are a lifesaver.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.qualifiedAccept,
        ),
        // Path B: Respectful No-Sale
        const SalesTurn(
          id: 'turn-ti36-06B',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'I cannot remember my Apple ID password and my recovery email is deactivated. This is too stressful. I think I will just cancel the trade-in and give the phone to my nephew.',
          phase: SalesPhase.objectionHandling,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ti36-07B',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti36-07B',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'I understand completely, Rebecca. Losing a password can be deeply frustrating. Cancelling the trade-in avoids any risk of losing the phone, and you can keep it in the family.',
          phase: SalesPhase.closing,
          requiredKeywords: [
            'understand',
            'frustrating',
            'cancelling',
            'keep in family',
          ],
          trainerGuidanceArabic: 'تعاطف مع نسيان كلمة المرور ولا تضغط عليها، وأكد إلغاء الاستبدال لتفادي فقدان الجهاز.',
          usEnglishModelResponse: 'I completely understand, Rebecca. Password recovery can be very difficult. Cancelling the trade-in is the safest route so your phone remains safely in your family.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ti36-08B',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti36-08B',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText: 'Thank you for your empathy and understanding, Alex.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.respectfulNoSale,
        ),
        // Path C: Needs Verification
        const SalesTurn(
          id: 'turn-ti36-06C',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'I need to visit an Apple store to reset my password using my photo ID before I can toggle Find My off.',
          phase: SalesPhase.eligibilityBoundary,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ti36-07C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti36-07C',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'That is the safest step, Rebecca. Visit the Apple Genius Bar with your receipt and ID. We will extend your trade-in return window by thirty days so you have plenty of time to reset it.',
          phase: SalesPhase.eligibilityBoundary,
          requiredKeywords: ['safest', 'genius bar', 'extend', 'thirty days'],
          trainerGuidanceArabic: 'انصح بزيارة متجر أبل لتصفير كلمة المرور ومد فترة إرجاع الجهاز 30 يوماً.',
          usEnglishModelResponse: 'That is a great plan. Have Apple verify your credentials, and I will place a 30-day return window extension note on your order.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ti36-08C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti36-08C',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText: 'Thank you for the extension note, Alex! I will visit Apple on Saturday.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.needsVerification,
        ),
      ],
    ),

    // Scenario 37: Battery Health Degradation
    SalesScenario(
      id: 'sales-37-battery-health-degradation',
      title: 'Battery Health Degradation (<75%) vs Device Upgrade Assessment',
      category: 'trade_in_eip',
      difficulty: 'intermediate',
      profile: const SalesCustomerProfile(
        name: 'Jordan Lee',
        tone: 'pragmatic commuter',
        currentProvider: 'AT&T Unlimited Extra',
        householdNeeds: 'Solve battery dying by 2:00 PM every afternoon',
        financialConstraint: 'Evaluating whether \$89 battery swap is smarter than buying new phone',
        coreBlocker:
            'Battery health shows 71% maximum capacity service recommendation',
      ),
      contextNotes: 'Device works fine except battery capacity has dropped to 71%. Wants objective advice on battery replacement vs upgrade.',
      skillTags: [
        'Consultative Integrity',
        'Hardware Lifespan',
        'Financial Advisory',
      ],
      prohibitedPromises: [
        'claim a degraded battery cannot be replaced affordably',
        'urge customer to trash an otherwise working 2-year-old phone',
      ],
      mandatoryDisclosures: [
        'Battery health degradation does not reduce trade-in valuation if phone powers on and holds a charge during testing',
        'Third-party authorized battery replacement typically costs eighty to ninety dollars',
      ],
      fictionalCandidateProducts: ['prod-next-up-eip'],
      turns: [
        const SalesTurn(
          id: 'turn-ti37-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: TrainingConstants.standardGreeting,
          phase: SalesPhase.greeting,
          requiredKeywords: ['att', 'alex', 'first', 'last', 'name'],
          trainerGuidanceArabic: 'ابدأ بالترحيب الرسمي المعتمد.',
          usEnglishModelResponse: TrainingConstants.standardGreeting,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-ti37-02'),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti37-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Hi Alex, Jordan Lee speaking. My phone dies by two o’clock every afternoon, and the battery settings say maximum capacity is seventy-one percent. Should I pay eighty-nine dollars to replace the battery, or does it make more sense to trade it in for a new device?',
          phase: SalesPhase.initialResolution,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-ti37-03'),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti37-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'That is a great consultative question, Jordan! If your phone otherwise meets all your daily needs, an eighty-nine dollar battery replacement can give you another two solid years of life. On the other hand, if you want modern camera upgrades and faster 5G speeds, trading it in yields full promotional credit since battery health does not dock your trade-in tier.',
          phase: SalesPhase.explorationPermission,
          requiredKeywords: [
            'battery replacement',
            'two years',
            'camera upgrades',
            'does not dock',
          ],
          trainerGuidanceArabic: 'قدم استشارة موضوعية متوازنة: تبديل البطارية بـ 89 دولار خيار ممتاز، والترقية تمنحك مزايا إضافية دون خصم من التقييم.',
          usEnglishModelResponse: 'That is a very smart analysis, Jordan. If you love your current phone, spending \$89 on a fresh battery is extremely cost-effective. But if you are ready for updated cameras, trading it in gets full tier credit because battery health percentage does not penalize your trade-in valuation.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-ti37-04'),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti37-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Wait, so AT&T does not deduct money from my trade-in just because the battery health is seventy-one percent?',
          phase: SalesPhase.discovery,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-ti37-05'),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti37-05',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Correct! As long as the phone powers on, holds a charge without swelling, and has an intact screen, you receive the full tier credit over thirty-six monthly installments.',
          phase: SalesPhase.valueBridge,
          requiredKeywords: [
            'powers on',
            'holds charge',
            'intact screen',
            'thirty-six monthly',
          ],
          trainerGuidanceArabic: 'طَمئِنه أن صحة البطارية لا تخصم من التقييم طالما الجهاز يعمل ولا يوجد انتفاخ أو كسر بالشاشة.',
          usEnglishModelResponse: 'That is right! As long as the battery is not physically swollen and the device powers on and functions, you get the full promotional value.',
          branches: [
            ScenarioBranch(conditionKey: 'accept', nextTurnId: 'turn-ti37-06A'),
            ScenarioBranch(
              conditionKey: 'decline',
              nextTurnId: 'turn-ti37-06B',
            ),
            ScenarioBranch(conditionKey: 'verify', nextTurnId: 'turn-ti37-06C'),
          ],
        ),
        // Path A: Qualified Accept
        const SalesTurn(
          id: 'turn-ti37-06A',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'My camera lens has been struggling on evening shots anyway, so getting the full credit without battery penalty makes upgrading the obvious winner. Let us do the trade-in!',
          phase: SalesPhase.objectionHandling,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ti37-07A',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti37-07A',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'I will set up the new device order with full promotional bill credits and send your trade-in return mailer with clear packing instructions.',
          phase: SalesPhase.closing,
          requiredKeywords: [
            'promotional bill credits',
            'trade-in return mailer',
            'clear packing',
          ],
          trainerGuidanceArabic:
              'أكد تفاصيل الطلب مع الخصومات الشهرية ومغلف الإرجاع.',
          usEnglishModelResponse: 'I will submit the new phone order with the maximum promotional credit and ship you the prepaid return packaging.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ti37-08A',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti37-08A',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText: 'Thanks for the objective advice Alex, that made my decision crystal clear.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.qualifiedAccept,
        ),
        // Path B: Respectful No-Sale
        const SalesTurn(
          id: 'turn-ti37-06B',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'I think eighty-nine dollars for a new battery at the repair shop makes much more financial sense than a new three-year installment plan. I will just replace the battery.',
          phase: SalesPhase.objectionHandling,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ti37-07B',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti37-07B',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'That is a completely sound economic decision, Jordan! A fresh battery will make your phone feel like new for a fraction of the cost. We will keep your plan as is.',
          phase: SalesPhase.closing,
          requiredKeywords: [
            'sound economic',
            'fresh battery',
            'fraction of cost',
            'as is',
          ],
          trainerGuidanceArabic: 'أثنِ على قراره الاقتصادي الذكي؛ استبدال البطارية يوفر ماله ويبقيه راضياً.',
          usEnglishModelResponse: 'That is a wonderful and frugal decision, Jordan. You will get great performance from a fresh battery without taking on any new monthly payments.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ti37-08B',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti37-08B',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText: 'Thank you for being so honest and helpful, Alex.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.respectfulNoSale,
        ),
        // Path C: Needs Verification
        const SalesTurn(
          id: 'turn-ti37-06C',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Let me take it by an authorized technician to confirm whether the battery is physically swelling before I ship it through the mail.',
          phase: SalesPhase.eligibilityBoundary,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ti37-07C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti37-07C',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'That is a critical safety precaution, Jordan. Swollen batteries cannot be shipped via commercial air mail. Have a technician inspect it first, and let us know once it is cleared.',
          phase: SalesPhase.eligibilityBoundary,
          requiredKeywords: [
            'critical safety',
            'swollen batteries',
            'technician inspect',
            'cleared',
          ],
          trainerGuidanceArabic: 'تنبيه أمان حيوي: البطاريات المنتفخة يحظر شحنها بالبريد الجوي، ويجب فحصها لدى فني أولاً.',
          usEnglishModelResponse: 'That is an essential safety step. Postal rules strictly prohibit shipping bulging batteries. Get it inspected first and call us once verified.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ti37-08C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti37-08C',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText:
              'I will have them check it this afternoon. Thank you, Alex.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.needsVerification,
        ),
      ],
    ),

    // Scenario 38: Storage Capacity Upgrade
    SalesScenario(
      id: 'sales-38-storage-capacity-upgrade',
      title:
          'Device Storage Full (64GB to 256GB) & Cloud Optimization Discovery',
      category: 'trade_in_eip',
      difficulty: 'entry',
      profile: const SalesCustomerProfile(
        name: 'Chloe Bennett',
        tone: 'frustrated content creator',
        currentProvider: 'AT&T Unlimited Starter',
        householdNeeds:
            'Fix constant "Storage Almost Full" warnings while shooting video',
        financialConstraint: 'Wants modest monthly payment increase',
        coreBlocker:
            'Phone only has 64GB onboard storage which is completely full',
      ),
      contextNotes: 'Currently has base 64GB storage device that cannot take updates or video. Needs 256GB or 512GB tier.',
      skillTags: [
        'Storage Discovery',
        'Hardware Rightsizing',
        'Cloud vs Local Discovery',
      ],
      prohibitedPromises: [
        'promise cloud storage physically expands onboard flash drive memory for apps',
      ],
      mandatoryDisclosures: [
        'Higher internal storage tiers (256GB/512GB) carry a small increase in monthly installment payments',
        'Device storage is fixed at manufacturing and cannot be expanded via SD card on modern flagship devices',
      ],
      fictionalCandidateProducts: ['prod-next-up-eip'],
      turns: [
        const SalesTurn(
          id: 'turn-ti38-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: TrainingConstants.standardGreeting,
          phase: SalesPhase.greeting,
          requiredKeywords: ['att', 'alex', 'first', 'last', 'name'],
          trainerGuidanceArabic: 'ابدأ بالترحيب الرسمي المعتمد.',
          usEnglishModelResponse: TrainingConstants.standardGreeting,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-ti38-02'),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti38-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Hi Alex, Chloe Bennett here. Every time I try to record a video of my kids or download a software update, my phone pops up an alert saying storage is full. I keep deleting apps and photos, and I am sick of it. Does trading in my phone fix this?',
          phase: SalesPhase.initialResolution,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-ti38-03'),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti38-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'I completely understand that frustration, Chloe. Constantly having to delete memories just to take a short video is exhausting. Your current phone has sixty-four gigabytes of storage, which fills up very quickly with modern high-definition video. Upgrading to a two hundred and fifty-six gigabyte model will give you four times the room.',
          phase: SalesPhase.explorationPermission,
          requiredKeywords: [
            'frustration',
            'sixty-four gigabytes',
            'two hundred and fifty-six',
            'four times',
          ],
          trainerGuidanceArabic: 'أظهر تفهماً لمعاناتها (AERD) واشرح الفرق بين 64GB و 256GB (أربعة أضعاف المساحة لتصوير الفيديوهات).',
          usEnglishModelResponse: 'I hear that frustration loud and clear, Chloe. 64 gigabytes is very tight for 4K video. Moving to 256 gigabytes gives you four times the onboard storage so you never have to delete photos or delay updates again.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-ti38-04'),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti38-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'How much more does the 256 gigabyte version cost compared to the base model?',
          phase: SalesPhase.discovery,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-ti38-05'),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti38-05',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'The upgrade from base one hundred twenty-eight to two hundred fifty-six gigabytes is only two dollars and seventy-eight cents a month on your thirty-six month installment agreement, giving you complete peace of mind.',
          phase: SalesPhase.valueBridge,
          requiredKeywords: [
            'two dollars',
            'seventy-eight cents',
            'thirty-six month',
            'peace of mind',
          ],
          trainerGuidanceArabic: 'وضح فارق السعر البسيط جداً (أقل من 3 دولارات شهرياً على 36 شهراً) للحصول على راحة بال تامة.',
          usEnglishModelResponse: 'It is just two dollars and seventy-eight cents more per month over thirty-six months. For less than three dollars, you eliminate all storage headaches.',
          branches: [
            ScenarioBranch(conditionKey: 'accept', nextTurnId: 'turn-ti38-06A'),
            ScenarioBranch(
              conditionKey: 'decline',
              nextTurnId: 'turn-ti38-06B',
            ),
            ScenarioBranch(conditionKey: 'verify', nextTurnId: 'turn-ti38-06C'),
          ],
        ),
        // Path A: Qualified Accept
        const SalesTurn(
          id: 'turn-ti38-06A',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Less than three dollars a month to never see a storage full warning again? Sign me up immediately, Alex!',
          phase: SalesPhase.objectionHandling,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ti38-07A',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti38-07A',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'I will submit your order for the two hundred fifty-six gigabyte model today, apply your trade-in credit, and ship your prepaid return box.',
          phase: SalesPhase.closing,
          requiredKeywords: [
            'two hundred fifty-six',
            'order',
            'trade-in credit',
            'prepaid return box',
          ],
          trainerGuidanceArabic:
              'أكد تفاصيل الطلب لموديل 256GB وتطبيق الخصم وشحن صندوق الإرجاع.',
          usEnglishModelResponse: 'I will process your 256GB order right now, attach your trade-in promo, and send out your prepaid return mailer.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ti38-08A',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti38-08A',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText: 'Thank you so much Alex! You made my day.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.qualifiedAccept,
        ),
        // Path B: Respectful No-Sale
        const SalesTurn(
          id: 'turn-ti38-06B',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Actually, my husband has a two-terabyte family cloud drive that I have not set up on my phone yet. Let me just upload my old videos to his cloud for free.',
          phase: SalesPhase.objectionHandling,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ti38-07B',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti38-07B',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'That is an excellent zero-cost solution, Chloe! Offloading your video archives to the family cloud will instantly free up your phone without spending a dime.',
          phase: SalesPhase.closing,
          requiredKeywords: [
            'zero-cost',
            'family cloud',
            'free up',
            'without spending',
          ],
          trainerGuidanceArabic:
              'شجعها على استغلال السحابة العائلية المجانية؛ ده حل ممتاز وموفر.',
          usEnglishModelResponse: 'That is a fantastic solution. Offloading large videos to your existing cloud storage will clear your storage immediately without adding any monthly cost.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ti38-08B',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti38-08B',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText: 'Thank you for being so supportive, Alex!',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.respectfulNoSale,
        ),
        // Path C: Needs Verification
        const SalesTurn(
          id: 'turn-ti38-06C',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Let me check my current storage settings to see whether system data or apps are taking up the majority of the space before ordering.',
          phase: SalesPhase.eligibilityBoundary,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ti38-07C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti38-07C',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'That is a very smart diagnostic check, Chloe. Go to Settings, General, iPhone Storage. If "System Data" is bloated, a quick backup and restore can often reclaim twenty gigabytes.',
          phase: SalesPhase.eligibilityBoundary,
          requiredKeywords: [
            'diagnostic',
            'iphone storage',
            'system data',
            'backup and restore',
          ],
          trainerGuidanceArabic:
              'انصح بفحص بند System Data لتنظيف المساحة قبل اتخاذ قرار الشراء.',
          usEnglishModelResponse: 'That is a great diagnostic step. Look at the storage breakdown in Settings. If system cached data is clogging it, a simple clean restore might solve it right now.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ti38-08C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti38-08C',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText: 'I will review that storage breakdown right now. Thank you, Alex!',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.needsVerification,
        ),
      ],
    ),

    // Scenario 39: Promotional Bill Credits Timeline Disclosure
    SalesScenario(
      id: 'sales-39-promotional-bill-credits-timeline',
      title: 'Promotional Bill Credits 2-3 Billing Cycle Delay Disclosure',
      category: 'trade_in_eip',
      difficulty: 'advanced',
      profile: const SalesCustomerProfile(
        name: 'David Rossi',
        tone: 'hyper-vigilant billing inspector',
        currentProvider: 'AT&T Unlimited Starter',
        householdNeeds: 'Clear expectations on when trade-in discount appears on the bill statement',
        financialConstraint: 'Monitors checking account balance closely',
        coreBlocker: 'Furious in past with other carriers when first bill was charged at full price',
      ),
      contextNotes: 'CRITICAL ESCALATION DEFENSE: Carrier trade-in credits take 2-3 billing cycles to appear, with catch-up credits. AGENT MUST EXPLICITLY SET THIS EXPECTATION TO PREVENT BILL SHOCK.',
      skillTags: [
        'Billing Expectation Setting',
        'Proactive Disclosure',
        'Trust Building',
      ],
      prohibitedPromises: [
        'promise bill credits appear on day one or the very first bill',
        'claim the billing system can manually fast-track warehouse credit application',
      ],
      mandatoryDisclosures: [
        'Trade-in promotional bill credits typically appear on your bill within two to three billing cycles',
        'Once credits begin, a catch-up credit will apply to reimburse prior billing cycles',
        'Customer pays the standard monthly device installment until the warehouse verification completes',
      ],
      fictionalCandidateProducts: ['prod-next-up-eip'],
      turns: [
        const SalesTurn(
          id: 'turn-ti39-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: TrainingConstants.standardGreeting,
          phase: SalesPhase.greeting,
          requiredKeywords: ['att', 'alex', 'first', 'last', 'name'],
          trainerGuidanceArabic: 'ابدأ بالترحيب الرسمي المعتمد.',
          usEnglishModelResponse: TrainingConstants.standardGreeting,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-ti39-02'),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti39-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Hello Alex. My name is David Rossi. I am interested in your trade-in offer, but my buddy warned me that you guys will charge me the full thirty dollars a month on my next bill and make me fight customer service for months to get the credit. Is that true?',
          phase: SalesPhase.initialResolution,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-ti39-03'),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti39-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'I am so glad you asked about that directly, Mr. Rossi, because total billing transparency is my top priority. Promotional trade-in credits take two to three billing cycles to appear while the warehouse evaluates your device. However, you do not have to fight anyone: once approved, a retroactive catch-up credit is automatically applied to cover those first months.',
          phase: SalesPhase.explorationPermission,
          requiredKeywords: [
            'transparency',
            'two to three billing cycles',
            'catch-up credit',
            'automatically',
          ],
          trainerGuidanceArabic: 'إفصاح استباقي إلزامي: وضح بصدق أن الخصم يستغرق من دورتين إلى ثلاث فواتير للفحص، مع نزول رصيد رجعي تلقائي (Catch-up credit) دون الحاجة للجدال.',
          usEnglishModelResponse: 'I truly appreciate you bringing this up, Mr. Rossi. It is vital to be transparent: trade-in credits take two to three billing cycles to begin because the intake warehouse must physically process your phone. Once applied, a catch-up credit automatically reimburses any full payments made.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-ti39-04'),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti39-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'So on my very first bill next month, I will see the full installment charge, and then on month three I will get double or triple credits?',
          phase: SalesPhase.discovery,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-ti39-05'),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti39-05',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Exactly right, Mr. Rossi. You will see the standard charge on bills one and two, and then on bill three, you receive the current credit plus the previous two months back as a lump sum credit. Knowing that in advance prevents any surprise or stress.',
          phase: SalesPhase.valueBridge,
          requiredKeywords: [
            'standard charge',
            'lump sum credit',
            'advance',
            'surprise',
          ],
          trainerGuidanceArabic: 'أكد فهمه: الفاتورة الأولى والثانية بسعر عادي، وفي الثالثة ينزل الخصم الحالي ومعه المبالغ السابقة كاملة كخصم مجمع.',
          usEnglishModelResponse: 'That is spot on. Bills one and two will show the standard installment, and cycle three applies the catch-up credit reimbursing those months. Knowing this upfront ensures zero bill shock.',
          branches: [
            ScenarioBranch(conditionKey: 'accept', nextTurnId: 'turn-ti39-06A'),
            ScenarioBranch(
              conditionKey: 'decline',
              nextTurnId: 'turn-ti39-06B',
            ),
            ScenarioBranch(conditionKey: 'verify', nextTurnId: 'turn-ti39-06C'),
          ],
        ),
        // Path A: Qualified Accept
        const SalesTurn(
          id: 'turn-ti39-06A',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'I can handle that as long as I know what to expect and that it is automatic. That level of honesty is rare, Alex. Let us proceed with the trade-in order.',
          phase: SalesPhase.objectionHandling,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ti39-07A',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti39-07A',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'I will submit your order with the promotional trade-in attachment and mail you the pre-addressed return kit, with the credit timeline clearly documented in your confirmation email.',
          phase: SalesPhase.closing,
          requiredKeywords: [
            'promotional trade-in',
            'return kit',
            'confirmation email',
          ],
          trainerGuidanceArabic:
              'أكد إرسال تفاصيل الخصم وجدول المواعيد في البريد التأكيدي.',
          usEnglishModelResponse: 'I will place the order now and email you a full summary detailing the exact 36-month installment and 2-3 cycle credit timeline for your records.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ti39-08A',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti39-08A',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText: 'Thank you for being upfront and professional, Alex.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.qualifiedAccept,
        ),
        // Path B: Respectful No-Sale
        const SalesTurn(
          id: 'turn-ti39-06B',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'I cannot afford to have forty dollars floating on my bill for three months waiting for a catch-up credit. I will just wait until I have enough cash to buy a phone outright.',
          phase: SalesPhase.objectionHandling,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ti39-07B',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti39-07B',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'I completely respect your cash-flow discipline, Mr. Rossi. Protecting your monthly budget comes first, and buying outright whenever you are ready is a great approach.',
          phase: SalesPhase.closing,
          requiredKeywords: [
            'respect',
            'cash-flow discipline',
            'budget',
            'outright',
          ],
          trainerGuidanceArabic:
              'احترم حرصه المالي وانضباط ميزانيته النقدية دون أي ملاحقة.',
          usEnglishModelResponse: 'I completely respect that financial discipline, Mr. Rossi. Cash-flow predictability is very important. We will make zero changes to your line.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ti39-08B',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti39-08B',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText:
              'Thank you for understanding and not arguing with me, Alex.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.respectfulNoSale,
        ),
        // Path C: Needs Verification
        const SalesTurn(
          id: 'turn-ti39-06C',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Can you check my account’s exact billing cycle close date so I know the precise date range for those first two bills?',
          phase: SalesPhase.eligibilityBoundary,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ti39-07C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti39-07C',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'Certainly, Mr. Rossi. Your cycle closes on the 14th of each month, which means placing the order today allows the trade-in return package to reach the facility before cycle two ends.',
          phase: SalesPhase.eligibilityBoundary,
          requiredKeywords: [
            'cycle closes',
            '14th',
            'trade-in return package',
            'facility',
          ],
          trainerGuidanceArabic: 'تحقق من تاريخ إغلاق الدورة الفاتورية (14 من كل شهر) لمعرفة التوقيت الدقيق للفواتير.',
          usEnglishModelResponse: 'Your cycle closes on the 14th of each month. Submitting today aligns your trade-in delivery to minimize the waiting window.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ti39-08C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti39-08C',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText: 'That exact date breakdown is very helpful. Let me mark my calendar. Thank you, Alex.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.needsVerification,
        ),
      ],
    ),

    // Scenario 40: Credit Limit & Down Payment Installment Boundary
    SalesScenario(
      id: 'sales-40-credit-limit-installment-boundary',
      title: 'Account Financing Credit Limit & Required Down Payment Boundary',
      category: 'trade_in_eip',
      difficulty: 'advanced',
      profile: const SalesCustomerProfile(
        name: 'Andre Washington',
        tone: 'optimistic shopper',
        currentProvider: 'AT&T Unlimited Starter',
        householdNeeds: 'Purchase top-tier 512GB flagship phone on installment',
        financialConstraint: 'Has \$150 in checking account today',
        coreBlocker: 'Account financing credit limit requires a \$200 required down payment',
      ),
      contextNotes: 'Account financing limit caps device installment balance. System requires a \$200 down payment today. AGENT MUST COMMUNICATE THIS RESPECTFULLY WITHOUT OFFENSE.',
      skillTags: [
        'Credit Boundary Navigation',
        'Respectful Down Payment',
        'Budget Adjustment',
      ],
      prohibitedPromises: [
        'promise the down payment can be waived or bypassed',
        'blame customer personal credit score disparagingly',
      ],
      mandatoryDisclosures: [
        'Account financing limit requires a two hundred dollar equipment down payment today',
        'Down payment reduces the thirty-six month installment payment proportionally',
        'Sales tax on the full retail device price is due today',
      ],
      fictionalCandidateProducts: ['prod-next-up-eip'],
      turns: [
        const SalesTurn(
          id: 'turn-ti40-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: TrainingConstants.standardGreeting,
          phase: SalesPhase.greeting,
          requiredKeywords: ['att', 'alex', 'first', 'last', 'name'],
          trainerGuidanceArabic: 'ابدأ بالترحيب الرسمي المعتمد.',
          usEnglishModelResponse: TrainingConstants.standardGreeting,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-ti40-02'),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti40-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Hello Alex. Andre Washington speaking. I want to order the top-tier five hundred and twelve gigabyte flagship phone today on the installment plan. Can we get that submitted with zero down?',
          phase: SalesPhase.initialResolution,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-ti40-03'),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti40-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'Thank you for reaching out Mr. Washington! I checked the system for that top-tier model. Based on the account equipment financing limit, the order requires a two hundred dollar down payment today, with the remaining balance spread over thirty-six months. The great news is that down payment lowers your monthly bill by over five dollars every month.',
          phase: SalesPhase.explorationPermission,
          requiredKeywords: [
            'account equipment financing',
            'two hundred dollar',
            'down payment',
            'lowers',
          ],
          trainerGuidanceArabic: 'أبلغ عن الدفعة المقدمة (200 دولار) باحترام ولباقة مع إبراز الجانب الإيجابي: تخفيض القسط الشهري بـ 5 دولارات.',
          usEnglishModelResponse: 'Thank you for calling Mr. Washington! Reviewing the account equipment tier, this flagship model requires a two hundred dollar initial down payment, which directly reduces your monthly installment over the thirty-six month term.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-ti40-04'),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti40-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Two hundred down? Can you waive that or override the system for me?',
          phase: SalesPhase.discovery,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-ti40-05'),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti40-05',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'I wish I could override it, Mr. Washington, but equipment financing limits are automated and cannot be bypassed. However, if we choose the two hundred fifty-six gigabyte tier, the required down payment drops to zero dollars down, or you can proceed with the five hundred twelve gigabyte model with the two hundred dollar down payment.',
          phase: SalesPhase.valueBridge,
          requiredKeywords: [
            'automated',
            'cannot be bypassed',
            'two hundred fifty-six',
            'zero dollars down',
          ],
          trainerGuidanceArabic: 'صارحه بعدم إمكانية تجاوز النظام آلياً، واقترح بديلاً فورياً: فئة 256GB بمقدم صفر دولار تماماً.',
          usEnglishModelResponse: 'Financing limits are automated by the system and cannot be manually overridden. But here is a great alternative: the 256GB tier qualifies for zero dollars down today with no down payment required.',
          branches: [
            ScenarioBranch(conditionKey: 'accept', nextTurnId: 'turn-ti40-06A'),
            ScenarioBranch(
              conditionKey: 'decline',
              nextTurnId: 'turn-ti40-06B',
            ),
            ScenarioBranch(conditionKey: 'verify', nextTurnId: 'turn-ti40-06C'),
          ],
        ),
        // Path A: Qualified Accept (Takes 256GB zero down)
        const SalesTurn(
          id: 'turn-ti40-06A',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Zero down on the two hundred fifty-six gigabyte model fits my wallet perfectly today! Two hundred fifty-six is plenty of storage anyway. Let us order that one.',
          phase: SalesPhase.objectionHandling,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ti40-07A',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti40-07A',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'That is a fantastic, practical solution Mr. Washington! I will place your order for the two hundred fifty-six gigabyte model with zero down payment and standard thirty-six month installment terms.',
          phase: SalesPhase.closing,
          requiredKeywords: [
            'two hundred fifty-six',
            'zero down payment',
            'thirty-six month',
            'order',
          ],
          trainerGuidanceArabic:
              'أكد طلب فئة 256GB بمقدم صفر دولار وتقسيط على 36 شهراً.',
          usEnglishModelResponse: 'That is a wonderful choice. I will submit the 256GB order with zero down payment today on your 36-month installment agreement.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ti40-08A',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti40-08A',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText: 'You saved me two hundred bucks upfront, Alex! Thank you so much.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.qualifiedAccept,
        ),
        // Path B: Respectful No-Sale
        const SalesTurn(
          id: 'turn-ti40-06B',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'If I cannot get the five hundred and twelve gigabyte phone with zero down, I am not buying anything today. I will wait until payday.',
          phase: SalesPhase.objectionHandling,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ti40-07B',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti40-07B',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'I completely respect that decision, Mr. Washington. Waiting until payday so you get the exact phone and storage you want is the smartest move. We will be right here whenever you are ready.',
          phase: SalesPhase.closing,
          requiredKeywords: ['respect', 'payday', 'smartest move', 'ready'],
          trainerGuidanceArabic: 'احترم رغبته في الانتظار حتى موعد الراتب للحصول على الهاتف الذي يريده دون أدنى إلحاح.',
          usEnglishModelResponse: 'I completely understand, Mr. Washington. Getting the exact phone you truly want after payday is very smart. We will make zero changes today.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ti40-08B',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti40-08B',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText:
              'Thanks for your honesty, Alex. I will talk to you next Friday.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.respectfulNoSale,
        ),
        // Path C: Needs Verification
        const SalesTurn(
          id: 'turn-ti40-06C',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Can you check if paying off my old tablet installment balance first would increase my available equipment financing limit?',
          phase: SalesPhase.eligibilityBoundary,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ti40-07C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti40-07C',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'Yes! Paying off that ninety-dollar tablet balance will instantly free up line credit. Let me pull up your account credit profile to verify if that eliminates the down payment.',
          phase: SalesPhase.eligibilityBoundary,
          requiredKeywords: [
            'ninety-dollar',
            'free up line credit',
            'profile',
            'verify',
          ],
          trainerGuidanceArabic: 'تحقق من سداد قسط التابلت (90 دولار) لتحرير سقف الائتمان وتقليل الدفعة المقدمة.',
          usEnglishModelResponse: 'Yes, paying off that existing small installment frees up account credit. Let me calculate whether paying that off eliminates the down payment for you.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ti40-08C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ti40-08C',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText: 'Let us check that calculation right now. Thanks, Alex.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.needsVerification,
        ),
      ],
    ),
  ];
}
