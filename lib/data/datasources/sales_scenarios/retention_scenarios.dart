import '../../../core/constants/training_constants.dart';
import '../../../domain/entities/sales_scenario.dart';
import '../../../domain/entities/scenario.dart';

abstract class RetentionScenariosCatalog {
  static final List<SalesScenario> scenarios = [
    // Scenario 41: First Bill Shock & Plan Audit Pivot
    SalesScenario(
      id: 'sales-41-bill-shock-plan-audit',
      title: 'First Bill Shock De-escalation & AutoPay Audit Pivot',
      category: 'retention_care_to_sales',
      difficulty: 'intermediate',
      profile: const SalesCustomerProfile(
        name: 'Gregory Scott',
        tone: 'angry, feeling misled',
        currentProvider: 'AT&T Unlimited Extra (1st bill)',
        householdNeeds: 'Expected \$65 monthly bill, received \$115 invoice with activation & proration',
        financialConstraint: 'Refuses to pay more than promised \$65 rate',
        coreBlocker: 'Activation fee and missing AutoPay discount caused first bill spike',
      ),
      contextNotes: 'First bill includes one-time \$35 activation fee, partial month proration, and AutoPay pending cycle. Agent must de-escalate with AERD and structure permanent \$65 rate.',
      skillTags: [
        'Bill De-escalation',
        'AERD Empathy',
        'AutoPay Enrollment',
        'Proration Breakdown',
      ],
      prohibitedPromises: [
        'promise all future bills will be zero taxes',
        'promise supervisor callback will issue unapproved \$200 cash credits',
      ],
      mandatoryDisclosures: [
        'First bill includes a one-time activation fee and partial-month prorated service days',
        'AutoPay and paperless billing enrollment requires checking account or debit card for the ten dollar discount',
        'Monthly ongoing rate stabilizes at sixty-five dollars starting cycle two',
      ],
      fictionalCandidateProducts: ['prod-wireless-extra'],
      turns: [
        const SalesTurn(
          id: 'turn-ret41-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: TrainingConstants.standardGreeting,
          phase: SalesPhase.greeting,
          requiredKeywords: ['att', 'alex', 'first', 'last', 'name'],
          trainerGuidanceArabic: 'ابدأ بالترحيب الرسمي المعتمد بالكامل.',
          usEnglishModelResponse: TrainingConstants.standardGreeting,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret41-02',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret41-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Listen Alex, my name is Gregory Scott. I was promised my bill would be sixty-five dollars a month. I just opened my first bill and it says one hundred and fifteen dollars! I am ready to cancel this service and go right back to my old carrier.',
          phase: SalesPhase.initialResolution,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret41-03',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret41-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'I hear you completely, Mr. Scott, and I would be just as frustrated if I expected sixty-five dollars and saw one hundred and fifteen. You called the right person: let me review the exact line items right now so we can get your billing stabilized at sixty-five dollars.',
          phase: SalesPhase.explorationPermission,
          requiredKeywords: [
            'hear you',
            'frustrated',
            'line items',
            'stabilized',
          ],
          trainerGuidanceArabic: 'استخدم مهارة AERD لتهدئة العميل ومشاركته مشاعره، ثم ابدأ في فحص بنود الفاتورة بهدوء.',
          usEnglishModelResponse: 'I completely understand your frustration, Mr. Scott. Seeing an unexpected one hundred and fifteen dollar bill is alarming. Let us review the charges together line by line so I can explain what occurred and ensure your ongoing rate is sixty-five dollars.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret41-04',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret41-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Explain to me why there is an extra fifty dollars on here right now.',
          phase: SalesPhase.discovery,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret41-05',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret41-05',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'The extra charges consist of a one-time thirty-five dollar activation fee and five days of prorated service from when you joined mid-cycle. Also, your AutoPay was not finalized, which adds ten dollars. If we complete AutoPay right now, your future bills will be sixty-five dollars exactly.',
          phase: SalesPhase.valueBridge,
          requiredKeywords: [
            'one-time',
            'thirty-five dollar',
            'prorated',
            'autopay',
            'sixty-five dollars',
          ],
          trainerGuidanceArabic: 'اشرح البنود بشفافية: رسوم تفعيل لمرة واحدة، أيام مجزأة (Proration)، وتفعيل AutoPay لخصم 10 دولارات شهرياً لتثبيت السعر عند 65 دولار.',
          usEnglishModelResponse: 'The first statement reflects two one-time factors: a thirty-five dollar setup fee and five days of partial month proration. Additionally, AutoPay is not yet active. Enrolling in AutoPay right now locks in your ten dollar monthly discount, bringing all future statements to sixty-five dollars.',
          branches: [
            ScenarioBranch(
              conditionKey: 'accept',
              nextTurnId: 'turn-ret41-06A',
            ),
            ScenarioBranch(
              conditionKey: 'decline',
              nextTurnId: 'turn-ret41-06B',
            ),
            ScenarioBranch(
              conditionKey: 'verify',
              nextTurnId: 'turn-ret41-06C',
            ),
          ],
        ),
        // Path A: Qualified Accept (Enrolls in AutoPay, stays with AT&T)
        const SalesTurn(
          id: 'turn-ret41-06A',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Okay, that makes complete sense why the first bill was higher. Let us set up AutoPay right now so I get that ten dollar discount and my sixty-five dollar rate moving forward.',
          phase: SalesPhase.objectionHandling,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret41-07A',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret41-07A',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'I have successfully enrolled your account in AutoPay and paperless billing. Your discount is locked in, and your future monthly statements will be sixty-five dollars.',
          phase: SalesPhase.closing,
          requiredKeywords: [
            'successfully enrolled',
            'autopay',
            'paperless billing',
            'sixty-five dollars',
          ],
          trainerGuidanceArabic:
              'أكد تفعيل الخصم وتثبيت الفاتورة المستقبلية عند 65 دولار.',
          usEnglishModelResponse: 'Your AutoPay and paperless billing enrollment is now active. Your ongoing rate is stabilized at sixty-five dollars starting with your next billing statement.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret41-08A',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret41-08A',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText: 'Thank you for explaining that so clearly, Alex. I feel much better staying with AT&T.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.qualifiedAccept,
        ),
        // Path B: Respectful No-Sale
        const SalesTurn(
          id: 'turn-ret41-06B',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'I refuse to give any company automatic access to my bank account, and I will not pay a thirty-five dollar activation fee. Cancel my line right now.',
          phase: SalesPhase.objectionHandling,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret41-07B',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret41-07B',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'I completely respect your stance regarding your banking information, Mr. Scott. You have the right to cancel during your trial period. I will assist you with the cancellation process without hassle.',
          phase: SalesPhase.closing,
          requiredKeywords: [
            'respect',
            'banking information',
            'trial period',
            'cancellation',
          ],
          trainerGuidanceArabic: 'احترم موقفه من الخصوصية البنكية وساعده في الإلغاء باحترام دون أي ضغط.',
          usEnglishModelResponse: 'I completely respect your privacy preferences regarding bank accounts, Mr. Scott. I will guide you through the return and cancellation process smoothly.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret41-08B',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret41-08B',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText: 'I appreciate your professionalism in handling my cancellation, Alex.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.respectfulNoSale,
        ),
        // Path C: Needs Verification
        const SalesTurn(
          id: 'turn-ret41-06C',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Can you place a temporary courtesy dispute on the thirty-five dollar activation fee while your billing team reviews my original order notes?',
          phase: SalesPhase.eligibilityBoundary,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret41-07C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret41-07C',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'Let me open a formal billing review ticket to investigate the original enrollment order notes regarding the activation fee before you submit payment.',
          phase: SalesPhase.eligibilityBoundary,
          requiredKeywords: [
            'billing review ticket',
            'investigate',
            'enrollment order',
            'submit payment',
          ],
          trainerGuidanceArabic:
              'افتح تذكرة مراجعة فواتير نظامية للتحقق من تفاصيل الطلب الأصلي.',
          usEnglishModelResponse: 'I will submit a formal investigation ticket to verify if an activation fee waiver was noted on your original order before we finalize anything.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret41-08C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret41-08C',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText: 'Please do that investigation first. Thank you, Alex.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.needsVerification,
        ),
      ],
    ),

    // Scenario 42: Competitor Offer Match
    SalesScenario(
      id: 'sales-42-competitor-offer-match',
      title: 'Competitor Price-Match Inquiry & Transparent Network Comparison',
      category: 'retention_care_to_sales',
      difficulty: 'intermediate',
      profile: const SalesCustomerProfile(
        name: 'Rachel Green',
        tone: 'bargain hunter',
        currentProvider: 'AT&T Unlimited Starter (\$65/mo)',
        householdNeeds: 'Received mail flyer from T-Mobile offering \$50 plan',
        financialConstraint: 'Wants to save \$15 a month',
        coreBlocker: 'Tempted by lower advertised price without checking rural coverage gaps',
      ),
      contextNotes: 'Has competitor flyer. AT&T does not arbitrarily match third-party promotions. Rep must compare coverage, rural density, and bundle discounts ethically.',
      skillTags: [
        'Competitor Comparison',
        'Coverage Reality',
        'Ethical Selling',
        'No False Promises',
      ],
      prohibitedPromises: [
        'promise AT&T will match any price on a competitor flyer',
        'falsely claim competitor has zero cell towers in major cities',
      ],
      mandatoryDisclosures: [
        'AT&T does not offer arbitrary promotional price matching',
        'Signature program discounts or Fiber bundle credits can provide ongoing monthly savings',
      ],
      fictionalCandidateProducts: ['prod-wireless-starter', 'prod-fiber-300'],
      turns: [
        const SalesTurn(
          id: 'turn-ret42-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: TrainingConstants.standardGreeting,
          phase: SalesPhase.greeting,
          requiredKeywords: ['att', 'alex', 'first', 'last', 'name'],
          trainerGuidanceArabic: 'ابدأ بالترحيب الرسمي المعتمد.',
          usEnglishModelResponse: TrainingConstants.standardGreeting,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret42-02',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret42-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Hi Alex, Rachel Green here. I have a flyer in my hand from T-Mobile offering a plan for fifty dollars a month. I pay you guys sixty-five dollars. Will you match their fifty-dollar price today or should I take my number to them?',
          phase: SalesPhase.initialResolution,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret42-03',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret42-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'Thank you for being upfront about that offer, Rachel. While AT&T does not do arbitrary flyer price matching, we can audit your account for employer Signature discounts or home fiber bundle savings that can bring your rate down, while keeping your superior nationwide network coverage.',
          phase: SalesPhase.explorationPermission,
          requiredKeywords: [
            'upfront',
            'does not do arbitrary',
            'signature discounts',
            'fiber bundle',
          ],
          trainerGuidanceArabic: 'كن صريحاً: لا يوجد مطابقة أسعار عشوائية، لكن ابحث عن خصومات العمل (Signature) أو خصم باقة الفايبر لتوفير المال مع الحفاظ على الشبكة.',
          usEnglishModelResponse: 'I appreciate your directness, Rachel. While we do not match competitor flyers dollar-for-dollar, let us explore legitimate discount avenues like work discounts or internet bundling to lower your bill while keeping our reliable coverage.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret42-04',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret42-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'What kind of work discounts are you talking about? I work at Memorial Regional Hospital.',
          phase: SalesPhase.discovery,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret42-05',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret42-05',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Healthcare professionals at Memorial Hospital qualify for our twenty-five percent healthcare appreciation discount! That lowers your sixty-five dollar plan to under forty-nine dollars a month, beating the flyer rate while giving you priority service.',
          phase: SalesPhase.valueBridge,
          requiredKeywords: [
            'healthcare',
            'twenty-five percent',
            'forty-nine dollars',
            'beating',
          ],
          trainerGuidanceArabic: 'اكتشاف ممتاز: ممرضات وأطباء مستشفى Memorial يستحقون خصم 25% (أقل من 49 دولار شهرياً)، وهو أفضل من عرض المنافس.',
          usEnglishModelResponse: 'Healthcare workers at Memorial Hospital are eligible for our 25% healthcare appreciation discount! That reduces your bill to under forty-nine dollars monthly, beating that flyer price.',
          branches: [
            ScenarioBranch(
              conditionKey: 'accept',
              nextTurnId: 'turn-ret42-06A',
            ),
            ScenarioBranch(
              conditionKey: 'decline',
              nextTurnId: 'turn-ret42-06B',
            ),
            ScenarioBranch(
              conditionKey: 'verify',
              nextTurnId: 'turn-ret42-06C',
            ),
          ],
        ),
        // Path A: Qualified Accept
        const SalesTurn(
          id: 'turn-ret42-06A',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Under forty-nine dollars with my healthcare badge? That is incredible! That beats their offer and I do not have to switch SIM cards. Let us apply that right now.',
          phase: SalesPhase.objectionHandling,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret42-07A',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret42-07A',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'I have attached the Healthcare Appreciation Signature program to your profile. You will receive an email link to upload a quick photo of your work ID badge to finalize the discount.',
          phase: SalesPhase.closing,
          requiredKeywords: [
            'healthcare appreciation',
            'attached',
            'email link',
            'work id badge',
          ],
          trainerGuidanceArabic: 'أكد ربط برنامج الخصم وإرسال رابط رفع صورة بطاقة العمل لتأكيد الاستحقاق.',
          usEnglishModelResponse: 'I have enrolled your line in the Healthcare Appreciation Program. Please follow the verification link sent to your email to verify your work badge.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret42-08A',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret42-08A',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText: 'I will upload my hospital badge right now. Thank you so much, Alex!',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.qualifiedAccept,
        ),
        // Path B: Respectful No-Sale
        const SalesTurn(
          id: 'turn-ret42-06B',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Actually, I work in administration through an independent temp agency, so I do not have a hospital staff badge. I will just go with T-Mobile.',
          phase: SalesPhase.objectionHandling,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret42-07B',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret42-07B',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'I completely understand, Rachel. You deserve the best value for your hard-earned money. If you decide to switch, your account number and transfer PIN are available in your myAT&T app.',
          phase: SalesPhase.closing,
          requiredKeywords: [
            'understand',
            'best value',
            'transfer pin',
            'available',
          ],
          trainerGuidanceArabic:
              'احترم رغبتها وزودها بمعلومات التحويل بسلاسة ودون تعقيد.',
          usEnglishModelResponse: 'I completely respect that decision, Rachel. Getting the best price matters. You can retrieve your number transfer PIN directly in the app.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret42-08B',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret42-08B',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText: 'Thank you for being so polite and helpful, Alex.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.respectfulNoSale,
        ),
        // Path C: Needs Verification
        const SalesTurn(
          id: 'turn-ret42-06C',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Let me verify with my hospital HR department whether our temp contractor agency qualifies under the hospital affiliation agreement.',
          phase: SalesPhase.eligibilityBoundary,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret42-07C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret42-07C',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'That is the best step, Rachel. Check with HR for your organization FAN code, and once you have that, we can apply the twenty-five percent discount immediately.',
          phase: SalesPhase.eligibilityBoundary,
          requiredKeywords: [
            'fan code',
            'twenty-five percent',
            'immediately',
            'check with hr',
          ],
          trainerGuidanceArabic: 'اطلب منها مراجعة الموارد البشرية للحصول على كود FAN الخاص بالمنظمة.',
          usEnglishModelResponse: 'Checking with HR for your contractor FAN discount code is the best way forward. Call us back once they provide that code.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret42-08C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret42-08C',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText: 'I will ask HR about the FAN code tomorrow morning. Thanks, Alex.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.needsVerification,
        ),
      ],
    ),

    // Scenario 43: Expired Promotion Recovery
    SalesScenario(
      id: 'sales-43-expired-promotion-recovery',
      title: 'Expired 12-Month Promotional Discount & Fiber Bundle Pivot',
      category: 'retention_care_to_sales',
      difficulty: 'intermediate',
      profile: const SalesCustomerProfile(
        name: 'Kevin Zhao',
        tone: 'disappointed subscriber',
        currentProvider: 'AT&T Fiber 500 & Wireless Extra',
        householdNeeds:
            'Recover \$20 monthly discount that expired after month 12',
        financialConstraint: 'Wants bill back under \$120 total',
        coreBlocker:
            'Promotional term ended and rate reverted to standard pricing',
      ),
      contextNotes: 'Initial 12-month promo expired. Agent can leverage the permanent 20% All-In Fiber + Wireless bundle discount instead of short-term temporary promotions.',
      skillTags: [
        'Bundle Discounting',
        'Long-Term Retention',
        'Permanent Savings',
      ],
      prohibitedPromises: [
        'promise temporary promotional rates can be locked in permanently without eligible bundles',
      ],
      mandatoryDisclosures: [
        'Initial twelve-month introductory promotions expire automatically at end of term',
        'All-In Fiber and Wireless bundle discount provides an ongoing twenty percent discount on Fiber when paired with an eligible unlimited wireless plan',
      ],
      fictionalCandidateProducts: ['prod-fiber-500', 'prod-wireless-extra'],
      turns: [
        const SalesTurn(
          id: 'turn-ret43-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: TrainingConstants.standardGreeting,
          phase: SalesPhase.greeting,
          requiredKeywords: ['att', 'alex', 'first', 'last', 'name'],
          trainerGuidanceArabic: 'ابدأ بالترحيب الرسمي المعتمد.',
          usEnglishModelResponse: TrainingConstants.standardGreeting,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret43-02',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret43-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Hi Alex, Kevin Zhao calling. My monthly bill went up by twenty dollars this month. I was told my fifty-five dollar fiber rate would stay that way, but now it is seventy-five dollars. Can you put my discount back on?',
          phase: SalesPhase.initialResolution,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret43-03',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret43-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'Thank you for calling Kevin. I see that your introductory twelve-month promotional discount completed its annual cycle. Rather than looking for temporary discounts that expire again next year, we have a permanent solution: our All-In bundle pairing your Fiber with your wireless plan saves you twenty percent every single month permanently.',
          phase: SalesPhase.explorationPermission,
          requiredKeywords: [
            'introductory',
            'annual cycle',
            'permanent solution',
            'twenty percent',
          ],
          trainerGuidanceArabic: 'اشرح انتهاء العرض الترويجي السنوي، وقدم حلاً دائماً ومستقراً: خصم الباقة المدمجة (All-In Bundle) بنسبة 20% شهرياً.',
          usEnglishModelResponse: 'Thank you for reaching out, Kevin. Your initial twelve-month discount has reached its scheduled end. Instead of temporary credits, pairing your Fiber and Wireless accounts unlocks our permanent twenty percent All-In bundle discount.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret43-04',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret43-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Wait, so twenty percent off my Fiber brings it down to sixty dollars forever as long as I have both services?',
          phase: SalesPhase.discovery,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret43-05',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret43-05',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Yes! Exactly sixty dollars a month for symmetrical five hundred megabit Fiber, with zero equipment fees, unlimited data, and no annual expiration date.',
          phase: SalesPhase.valueBridge,
          requiredKeywords: [
            'sixty dollars',
            'symmetrical',
            'zero equipment',
            'no expiration',
          ],
          trainerGuidanceArabic: 'أكد السعر (60 دولار) لسرعة 500 ميجابت متماثلة وبلا رسوم استئجار راوتر أو تاريخ انتهاء صلاحية.',
          usEnglishModelResponse: 'Exactly. It brings your Fiber 500 down to sixty dollars monthly with no expiration date, no contracts, and unlimited data.',
          branches: [
            ScenarioBranch(
              conditionKey: 'accept',
              nextTurnId: 'turn-ret43-06A',
            ),
            ScenarioBranch(
              conditionKey: 'decline',
              nextTurnId: 'turn-ret43-06B',
            ),
            ScenarioBranch(
              conditionKey: 'verify',
              nextTurnId: 'turn-ret43-06C',
            ),
          ],
        ),
        // Path A: Qualified Accept
        const SalesTurn(
          id: 'turn-ret43-06A',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'A permanent sixty dollar rate where I never have to call in every twelve months to beg for a discount? Sign me up immediately!',
          phase: SalesPhase.objectionHandling,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret43-07A',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret43-07A',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'I have linked your billing profiles and applied the permanent twenty percent All-In discount. Your new rate begins on your upcoming billing statement.',
          phase: SalesPhase.closing,
          requiredKeywords: [
            'linked',
            'permanent twenty percent',
            'all-in discount',
            'upcoming',
          ],
          trainerGuidanceArabic:
              'أكد ربط الحسابين وتطبيق خصم الباقة المدمجة بنجاح.',
          usEnglishModelResponse: 'I have unified your accounts under the All-In program. Your permanent 20% discount is locked in.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret43-08A',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret43-08A',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText: 'Thank you Alex! That solves my problem permanently.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.qualifiedAccept,
        ),
        // Path B: Respectful No-Sale
        const SalesTurn(
          id: 'turn-ret43-06B',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Sixty is still five dollars more than the fifty-five I was paying. My local cable company has a forty-dollar introductory deal. I will switch to them.',
          phase: SalesPhase.objectionHandling,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret43-07B',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret43-07B',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'I completely understand, Kevin. You should do what is best for your wallet. If you ever want symmetrical fiber speeds back, our doors are always open.',
          phase: SalesPhase.closing,
          requiredKeywords: [
            'understand',
            'best for your wallet',
            'symmetrical',
            'doors are always open',
          ],
          trainerGuidanceArabic: 'احترم رغبته دون ملاحقة أو تشكيك.',
          usEnglishModelResponse: 'I understand completely, Kevin. We appreciate your business and will be here whenever you want fiber speeds again.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret43-08B',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret43-08B',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText: 'Thank you for your courteous assistance, Alex.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.respectfulNoSale,
        ),
        // Path C: Needs Verification
        const SalesTurn(
          id: 'turn-ret43-06C',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'My wireless account is under my wife’s maiden name. Do our names have to match exactly on both accounts to link the bundle discount?',
          phase: SalesPhase.eligibilityBoundary,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret43-07C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret43-07C',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'The service address must match, and one authorized user must be shared on both profiles. Let me verify the account name formatting to make sure the automated system links them properly.',
          phase: SalesPhase.eligibilityBoundary,
          requiredKeywords: [
            'service address',
            'authorized user',
            'verify',
            'formatting',
          ],
          trainerGuidanceArabic: 'تحقق من مطابقة العنوان الجغرافي ووجود اسم مستخدم مفوض مشترك على الحسابين.',
          usEnglishModelResponse: 'The physical address must match and both profiles need a common authorized user. Let me verify the profile linkage requirements right now.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret43-08C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret43-08C',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText:
              'Let us check those profile names first. Thank you, Alex.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.needsVerification,
        ),
      ],
    ),

    // Scenario 44: Demanding Supervisor Callback (OPERATIONAL TRUTH: NO SUPERVISOR CALLBACKS)
    SalesScenario(
      id: 'sales-44-demanding-supervisor-deescalation',
      title: 'Demanding Supervisor De-escalation & Floor Ownership (No Supervisor Callbacks)',
      category: 'retention_care_to_sales',
      difficulty: 'advanced',
      profile: const SalesCustomerProfile(
        name: 'Victor Vance',
        tone: 'furious, demanding supervisor callback immediately',
        currentProvider: 'AT&T Unlimited Starter',
        householdNeeds: 'Furious over network outage last Tuesday; demands supervisor callback and \$150 compensation',
        financialConstraint: 'Demands massive uncalibrated credit',
        coreBlocker: 'Refuses to speak to front-line agent; demands callback from supervisor',
      ),
      contextNotes: 'CRITICAL OPERATIONAL TRUTH: Supervisor callbacks are NOT available in this process. Agent must take personal floor ownership, de-escalate with AERD, and resolve on the spot.',
      skillTags: [
        'Supervisor De-escalation',
        'AERD Floor Ownership',
        'Operational Truth',
        'No Invented Promises',
      ],
      prohibitedPromises: [
        'promise a supervisor callback',
        'give customer a fake supervisor callback time window',
        'promise an unauthorized \$150 credit without system qualification',
      ],
      mandatoryDisclosures: [
        'Supervisor callbacks are not an available process mechanism',
        'Front-line agents have full ownership and authorized escalation tools to resolve issues immediately on the call',
      ],
      fictionalCandidateProducts: ['prod-wireless-starter'],
      turns: [
        const SalesTurn(
          id: 'turn-ret44-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: TrainingConstants.standardGreeting,
          phase: SalesPhase.greeting,
          requiredKeywords: ['att', 'alex', 'first', 'last', 'name'],
          trainerGuidanceArabic: 'ابدأ بالترحيب الرسمي المعتمد.',
          usEnglishModelResponse: TrainingConstants.standardGreeting,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret44-02',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret44-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Do not give me a script, Alex! My name is Victor Vance. Your cell tower went down for six hours last Tuesday during my workday and cost me business. I do not want to talk to you. I want a supervisor callback within thirty minutes and a one hundred and fifty dollar credit on my bill!',
          phase: SalesPhase.initialResolution,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret44-03',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret44-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'Mr. Vance, I hear your anger loud and clear, and having your cell service interrupted during your workday is completely unacceptable when you are running a business. I must be completely honest with you: our floor does not have a supervisor callback option, so scheduling a callback would only delay your resolution. I have full authority on this call to investigate that outage and resolve this for you right now.',
          phase: SalesPhase.explorationPermission,
          requiredKeywords: [
            'hear your anger',
            'unacceptable',
            'does not have a supervisor callback',
            'full authority',
          ],
          trainerGuidanceArabic: 'حقيقة تشغيلية ملزمة: المشرف لا يعاود الاتصال (No supervisor callbacks). وضح ذلك بصدق وتولَّ المسؤولية الشخصية لحل المشكلة فوراً على المكالمة.',
          usEnglishModelResponse: 'Mr. Vance, I completely understand your frustration. Losing service during critical work hours is terrible. To be fully transparent, our support workflow does not offer supervisor callbacks, and promising one would mislead you. I have the complete floor authority to review that incident and take corrective action with you right now.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret44-04',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret44-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Fine! If you have the authority, what can you actually do to compensate me for Tuesday?',
          phase: SalesPhase.discovery,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret44-05',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret44-05',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'I verified that an unexpected fiber cut affected the tower on Tuesday for four hours. I am applying an immediate twenty-five dollar outage courtesy credit to your statement right now, and I will enable complimentary Wi-Fi Calling on your phone so your calls route over office internet automatically if local weather ever damages a tower again.',
          phase: SalesPhase.valueBridge,
          requiredKeywords: [
            'twenty-five dollar',
            'courtesy credit',
            'wi-fi calling',
            'automatically',
          ],
          trainerGuidanceArabic: 'طبق رصيد تعويض نظامي معتمد (\$25) وفعل ميزة Wi-Fi Calling كحل وقائي لضمان عدم انقطاع أعماله.',
          usEnglishModelResponse: 'I confirmed the localized fiber cut on Tuesday. I am applying an immediate twenty-five dollar courtesy credit for the outage, and I will activate Wi-Fi Calling on your account to provide automatic office Wi-Fi failover.',
          branches: [
            ScenarioBranch(
              conditionKey: 'accept',
              nextTurnId: 'turn-ret44-06A',
            ),
            ScenarioBranch(
              conditionKey: 'decline',
              nextTurnId: 'turn-ret44-06B',
            ),
            ScenarioBranch(
              conditionKey: 'verify',
              nextTurnId: 'turn-ret44-06C',
            ),
          ],
        ),
        // Path A: Qualified Accept
        const SalesTurn(
          id: 'turn-ret44-06A',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'That is twenty times better than being promised a supervisor call that never comes. The twenty-five dollar credit and Wi-Fi failover solves my problem. I accept.',
          phase: SalesPhase.objectionHandling,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret44-07A',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret44-07A',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'The twenty-five dollar credit is officially posted to your balance, and Wi-Fi Calling is enabled. I sincerely appreciate your patience and partnership, Mr. Vance.',
          phase: SalesPhase.closing,
          requiredKeywords: [
            'officially posted',
            'wi-fi calling',
            'patience and partnership',
          ],
          trainerGuidanceArabic:
              'أكد تسجيل الرصيد وتفعيل الميزة واشكره على تعاونه وصبره.',
          usEnglishModelResponse: 'The credit has posted to your current balance and Wi-Fi Calling is active. Thank you for working with me to resolve this directly, Mr. Vance.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret44-08A',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret44-08A',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText: 'You took ownership and got it done Alex. Thank you.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.qualifiedAccept,
        ),
        // Path B: Respectful No-Sale
        const SalesTurn(
          id: 'turn-ret44-06B',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Twenty-five dollars is an insult for lost business. I am filing a complaint with the state public utilities commission and switching carriers.',
          phase: SalesPhase.objectionHandling,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret44-07B',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret44-07B',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'I understand your anger, Mr. Vance, and you have every right to file an inquiry with regulatory bodies. I will document your detailed feedback directly in the formal outage log.',
          phase: SalesPhase.closing,
          requiredKeywords: [
            'understand',
            'every right',
            'document',
            'outage log',
          ],
          trainerGuidanceArabic: 'احترم حقه في تقديم شكوى للجهات التنظيمية وسجل ملاحظاته رسمياً دون أي مراءاة.',
          usEnglishModelResponse: 'I completely respect your right to seek formal regulatory review, Mr. Vance. I will log your formal feedback in our network engineering tracking system.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret44-08B',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret44-08B',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText: 'Good. Make sure every word of that is logged.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.respectfulNoSale,
        ),
        // Path C: Needs Verification
        const SalesTurn(
          id: 'turn-ret44-06C',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Give me the exact engineering outage incident ticket number so my corporate insurance carrier can verify the business interruption claim.',
          phase: SalesPhase.eligibilityBoundary,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret44-07C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret44-07C',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'Certainly, Mr. Vance. The regional engineering incident ticket number is NET-88419-TX. I will document this on your profile for your insurance claims adjuster.',
          phase: SalesPhase.eligibilityBoundary,
          requiredKeywords: [
            'incident ticket number',
            'net-88419-tx',
            'insurance claims adjuster',
          ],
          trainerGuidanceArabic:
              'زود العميل برقم تذكرة العطل الهندسي لتقديمه لشركة التأمين.',
          usEnglishModelResponse: 'The official network incident reference is NET-88419-TX. I have attached this record to your account for your insurer.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret44-08C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret44-08C',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText: 'I have that ticket number written down. That gives me what I need for insurance. Thank you, Alex.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.needsVerification,
        ),
      ],
    ),

    // Scenario 45: Moving Retention & Fiber Transfer
    SalesScenario(
      id: 'sales-45-moving-retention-bundle',
      title: 'Customer Relocation Retention & Seamless Fiber Move',
      category: 'retention_care_to_sales',
      difficulty: 'intermediate',
      profile: const SalesCustomerProfile(
        name: 'Jessica Alba-Martinez',
        tone: 'stressed moving home',
        currentProvider: 'AT&T Fiber 300 & Wireless Extra',
        householdNeeds: 'Moving to a new home next Friday; called to cancel internet service',
        financialConstraint:
            'Wants to avoid cancellation fees and high moving setup expenses',
        coreBlocker: 'Assumed she had to cancel AT&T and sign up with new local provider at new address',
      ),
      contextNotes: 'Calling to cancel because she is moving. Rep discovers new home is fiber-eligible and can execute a seamless Move Order with \$0 transfer fees and ongoing bundle savings.',
      skillTags: ['Move Concierge', 'Fiber Relocation', 'Retention Save'],
      prohibitedPromises: [
        'promise fiber is available at every address in the United States without checking qualification',
      ],
      mandatoryDisclosures: [
        'Move orders carry zero transfer fees when transferring existing eligible service',
        'Customer takes their existing Wi-Fi gateway to the new home or receives updated equipment',
      ],
      fictionalCandidateProducts: ['prod-fiber-300'],
      turns: [
        const SalesTurn(
          id: 'turn-ret45-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: TrainingConstants.standardGreeting,
          phase: SalesPhase.greeting,
          requiredKeywords: ['att', 'alex', 'first', 'last', 'name'],
          trainerGuidanceArabic: 'ابدأ بالترحيب الرسمي المعتمد.',
          usEnglishModelResponse: TrainingConstants.standardGreeting,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret45-02',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret45-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Hi Alex, my name is Jessica Martinez. We are moving across town next Friday and packing boxes, so I am calling to cancel my home internet service.',
          phase: SalesPhase.initialResolution,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret45-03',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret45-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'Congratulations on the new home, Mrs. Martinez! Moving can be exhausting. Before you cancel, let me check your new address: if fiber is available there, we can transfer your service with zero moving fees so your internet is live the minute you unpack your boxes.',
          phase: SalesPhase.explorationPermission,
          requiredKeywords: [
            'congratulations',
            'moving',
            'new address',
            'zero moving fees',
          ],
          trainerGuidanceArabic: 'بارك لها بالمنزل الجديد، واقترح فحص العنوان الجديد لنقل الخدمة مجاناً بدون رسوم بدلاً من الإلغاء.',
          usEnglishModelResponse: 'Congratulations on your new house, Mrs. Martinez! Moving is quite a task. Instead of canceling, let us check your new address. We can transfer your connection seamlessly with zero transfer fees.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret45-04',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret45-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'The new address is 742 Evergreen Terrace. Can you check if fiber is there?',
          phase: SalesPhase.discovery,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret45-05',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret45-05',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Under our relocation policy, 742 Evergreen Terrace is verified for AT&T Fiber. We can schedule a technician for next Saturday morning, transfer your service without early termination penalties, and preserve your twenty percent wireless bundle discount.',
          phase: SalesPhase.valueBridge,
          requiredKeywords: ['fiber', 'technician', 'transfer', 'preserve'],
          trainerGuidanceArabic: 'العنوان الجديد مجهز بالفايبر. احجز موعداً لنقل الخدمة وتفادي غرامات الإلغاء المبكر مع الحفاظ على خصم الباقة المدمجة.',
          usEnglishModelResponse: '742 Evergreen Terrace is verified for AT&T Fiber. We can set up a transfer for Saturday, move your active account without early termination penalties, and keep your twenty percent bundle discount intact.',
          branches: [
            ScenarioBranch(
              conditionKey: 'accept',
              nextTurnId: 'turn-ret45-06A',
            ),
            ScenarioBranch(
              conditionKey: 'decline',
              nextTurnId: 'turn-ret45-06B',
            ),
            ScenarioBranch(
              conditionKey: 'verify',
              nextTurnId: 'turn-ret45-06C',
            ),
          ],
        ),
        // Path A: Qualified Accept
        const SalesTurn(
          id: 'turn-ret45-06A',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'That saves me from having to research new internet companies while packing! Please set up that Saturday move order, Alex.',
          phase: SalesPhase.objectionHandling,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret45-07A',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret45-07A',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'Your move order is confirmed for next Saturday between 8:00 AM and 11:00 AM. Bring your existing Wi-Fi gateway in your personal car, and the technician will connect everything seamlessly.',
          phase: SalesPhase.closing,
          requiredKeywords: [
            'move order confirmed',
            'saturday',
            'bring gateway',
            'seamlessly',
          ],
          trainerGuidanceArabic: 'أكد تفاصيل موعد النقل السبت صباحاً مع التنبيه باصطحاب الراوتر معها بسيارتها.',
          usEnglishModelResponse: 'Your move appointment is booked for Saturday morning. Just take your gateway with you and the tech will handle the full setup.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret45-08A',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret45-08A',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText: 'You took a massive chore off my to-do list, Alex! Thank you so much.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.qualifiedAccept,
        ),
        // Path B: Respectful No-Sale
        const SalesTurn(
          id: 'turn-ret45-06B',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'The new landlord includes community gigabit fiber in our monthly HOA dues, so we cannot have our own private account. We definitely have to cancel.',
          phase: SalesPhase.objectionHandling,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret45-07B',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret45-07B',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'Free community fiber included in HOA dues is fantastic! I will process your internet cancellation effective next Friday with zero early termination penalties.',
          phase: SalesPhase.closing,
          requiredKeywords: [
            'hoa dues',
            'cancellation',
            'zero early termination',
            'effective',
          ],
          trainerGuidanceArabic: 'بارك لها بالإنترنت المشمول مع رسوم المجمع السكني ونفذ الإلغاء بدون رسوم جزائية.',
          usEnglishModelResponse: 'Included HOA fiber is a wonderful perk! I will schedule your disconnection for Friday with no termination charges.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret45-08B',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret45-08B',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText: 'Thank you for being so gracious and helpful, Alex.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.respectfulNoSale,
        ),
        // Path C: Needs Verification
        const SalesTurn(
          id: 'turn-ret45-06C',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Our home closing date might slide by three days depending on escrow. Can we verify the move window flexibility before finalizing the tech appointment?',
          phase: SalesPhase.eligibilityBoundary,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret45-07C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret45-07C',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'Yes, move orders can be rescheduled online anytime with twenty-four hours notice. Let me create the preliminary draft move order so your address reservation is held.',
          phase: SalesPhase.eligibilityBoundary,
          requiredKeywords: [
            'rescheduled',
            'twenty-four hours',
            'draft move order',
            'held',
          ],
          trainerGuidanceArabic: 'وضح مرونة تعديل الموعد عبر الإنترنت قبل 24 ساعة، وأنشئ مسودة حجز للعنوان.',
          usEnglishModelResponse: 'Move dates are completely flexible and can be modified online anytime. I will create a provisional reservation holding your fiber port.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret45-08C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret45-08C',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText: 'Let us keep it as a provisional reservation until escrow signs on Wednesday. Thanks, Alex.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.needsVerification,
        ),
      ],
    ),

    // Scenario 46: Line Suspension & Financial Hardship
    SalesScenario(
      id: 'sales-46-line-suspension-financial-hardship',
      title: 'Temporary Financial Hardship & Bridge Payment Plan Down-tiering',
      category: 'retention_care_to_sales',
      difficulty: 'intermediate',
      profile: const SalesCustomerProfile(
        name: 'Darren Cross',
        tone: 'stressed, humiliated',
        currentProvider: 'AT&T Unlimited Premium (\$85/mo)',
        householdNeeds: 'Faced sudden seasonal layoff; past due balance facing pending line suspension',
        financialConstraint:
            'Has \$30 today, expects unemployment check in 14 days',
        coreBlocker:
            'Needs active phone to receive job interview callback calls',
      ),
      contextNotes: 'Facing suspension. Agent demonstrates empathy, sets up payment arrangement, and downsizes plan to Starter (\$65) to protect phone during job search.',
      skillTags: [
        'Hardship Empathy',
        'Payment Arrangement',
        'Plan Right-Sizing',
        'Ethical Preservation',
      ],
      prohibitedPromises: [
        'promise debts are erased permanently from credit bureaus',
        'promise unlimited months of free service',
      ],
      mandatoryDisclosures: [
        'Bridge payment arrangement extends payment deadline to specified date without suspension',
        'Down-tiering to Unlimited Starter reduces monthly ongoing charge by twenty dollars',
      ],
      fictionalCandidateProducts: ['prod-wireless-starter'],
      turns: [
        const SalesTurn(
          id: 'turn-ret46-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: TrainingConstants.standardGreeting,
          phase: SalesPhase.greeting,
          requiredKeywords: ['att', 'alex', 'first', 'last', 'name'],
          trainerGuidanceArabic: 'ابدأ بالترحيب الرسمي المعتمد.',
          usEnglishModelResponse: TrainingConstants.standardGreeting,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret46-02',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret46-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Hello Alex. Darren Cross. I got a text saying my service will be shut off tomorrow for non-payment. I was laid off two weeks ago. I have thirty dollars right now and my unemployment check comes in two weeks. If my phone shuts off, I will miss callback interviews for jobs.',
          phase: SalesPhase.initialResolution,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret46-03',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret46-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'Mr. Cross, please take a deep breath. You are not going to lose your phone line. Your job interviews are essential, and we are going to protect your service today. We can take your thirty dollars now and schedule a formal bridge payment arrangement for the remainder when your check arrives in two weeks, stopping any suspension immediately.',
          phase: SalesPhase.explorationPermission,
          requiredKeywords: [
            'deep breath',
            'job interviews',
            'protect your service',
            'bridge payment arrangement',
          ],
          trainerGuidanceArabic: 'تعاطف إنساني عالي (AERD): طَمئِن العميل أن خطه لن ينقطع، وجدول ترتيب دفع مؤقت (Payment arrangement) بالمبلغ المتوفر (\$30).',
          usEnglishModelResponse: 'Mr. Cross, I hear you and we are going to keep your phone active. Keeping your line open for job interviews is top priority. We can apply your thirty dollars today and establish a payment arrangement for the balance when your check clears, preventing interruption.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret46-04',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret46-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'You can really do that? And what can I do to keep my upcoming bills lower while I am job hunting?',
          phase: SalesPhase.discovery,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret46-05',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret46-05',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Right now you are on Unlimited Premium at eighty-five dollars. We can move your plan to Unlimited Starter at sixty-five dollars, keeping unlimited talk, text, and data while cutting twenty dollars off your bill every month while you look for work.',
          phase: SalesPhase.valueBridge,
          requiredKeywords: [
            'starter',
            'sixty-five dollars',
            'unlimited talk',
            'cutting twenty dollars',
          ],
          trainerGuidanceArabic: 'خفض باقته من Premium (\$85) إلى Starter (\$65) لتوفير 20 دولار شهرياً أثناء فترة البحث عن عمل.',
          usEnglishModelResponse: 'You are currently on Premium at \$85. We can down-tier you to Starter at \$65 immediately, maintaining full unlimited calling and data while lowering your monthly expense by twenty dollars.',
          branches: [
            ScenarioBranch(
              conditionKey: 'accept',
              nextTurnId: 'turn-ret46-06A',
            ),
            ScenarioBranch(
              conditionKey: 'decline',
              nextTurnId: 'turn-ret46-06B',
            ),
            ScenarioBranch(
              conditionKey: 'verify',
              nextTurnId: 'turn-ret46-06C',
            ),
          ],
        ),
        // Path A: Qualified Accept
        const SalesTurn(
          id: 'turn-ret46-06A',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'That saves my line, saves twenty dollars a month, and gives me the time I need to land a new job. Please set up the thirty dollar payment and move me to Starter right now.',
          phase: SalesPhase.objectionHandling,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret46-07A',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret46-07A',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'Your thirty dollar payment is processed, the payment arrangement for the remainder is secured for the 14th, and your plan is switched to Starter. Your phone line is 100% protected.',
          phase: SalesPhase.closing,
          requiredKeywords: [
            'thirty dollar payment',
            'payment arrangement',
            'starter',
            '100% protected',
          ],
          trainerGuidanceArabic: 'أكد معالجة الدفعة وجدولة الباقي في يوم 14 وتحويل الخطة إلى Starter مع تأمين الخط بالكامل.',
          usEnglishModelResponse: 'Your payment arrangement is confirmed, your thirty dollar payment is logged, and your plan is updated to Starter. Your phone will remain fully operational.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret46-08A',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret46-08A',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText: 'You have no idea how much stress you just lifted off me Alex. Thank you from the bottom of my heart.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.qualifiedAccept,
        ),
        // Path B: Respectful No-Sale
        const SalesTurn(
          id: 'turn-ret46-06B',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Even sixty-five dollars is more than I can commit to until I know when I am going back to work. I think I have to let the line go and use library computers.',
          phase: SalesPhase.objectionHandling,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret46-07B',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret46-07B',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'I understand completely, Mr. Cross. We can place your line on voluntary temporary suspension for ten dollars a month, which reserves your phone number so you do not lose it while keeping charges to a minimum.',
          phase: SalesPhase.closing,
          requiredKeywords: [
            'voluntary temporary suspension',
            'ten dollars',
            'reserves your phone number',
          ],
          trainerGuidanceArabic: 'اعرض تعليق الخط المؤقت برسم رمزي (10 دولارات) لحجز الرقم دون تكاليف باقة كاملة.',
          usEnglishModelResponse: 'I completely understand, Mr. Cross. If you prefer, we can place the line on voluntary suspension for a small fee, keeping your phone number safe until you are ready.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret46-08B',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret46-08B',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText: 'Thank you for being so respectful of my financial situation, Alex.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.respectfulNoSale,
        ),
        // Path C: Needs Verification
        const SalesTurn(
          id: 'turn-ret46-06C',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Let me verify the exact deposit date on my state unemployment portal to make sure the arrangement date matches my deposit day.',
          phase: SalesPhase.eligibilityBoundary,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret46-07C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret46-07C',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'Take all the time you need to check that portal. I have placed a forty-eight hour courtesy suspension freeze on your account so your phone stays on while you check.',
          phase: SalesPhase.eligibilityBoundary,
          requiredKeywords: [
            'courtesy suspension freeze',
            'forty-eight hour',
            'stays on',
          ],
          trainerGuidanceArabic: 'ضع إيقافاً مؤقتاً لتعليق الخط لمدة 48 ساعة ريثما يتحقق من تاريخ نزول الإعانة.',
          usEnglishModelResponse: 'I will place a 48-hour suspension hold on your account right now so you can check your portal without worrying about your phone cutting off.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret46-08C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret46-08C',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText: 'Thank you for holding the line active while I check my portal, Alex.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.needsVerification,
        ),
      ],
    ),

    // Scenario 47: Unauthorized Third-Party Add-on / Bill Audit
    SalesScenario(
      id: 'sales-47-unauthorized-third-party-add-on',
      title: 'Unwanted Feature Removal & Ethical Account Bill Audit',
      category: 'retention_care_to_sales',
      difficulty: 'intermediate',
      profile: const SalesCustomerProfile(
        name: 'Nancy Drew',
        tone: 'suspicious, feels scammed',
        currentProvider: 'AT&T Unlimited Starter',
        householdNeeds: 'Discovered an unwanted \$17/mo device protection package added without consent',
        financialConstraint: 'Wants full refund and removal',
        coreBlocker:
            'Lost trust in store rep who added insurance without asking',
      ),
      contextNotes: 'Store rep added Protect Advantage insurance without consent ("cramming"). Agent must de-escalate, remove unwanted feature immediately, refund current cycle, and restore trust.',
      skillTags: [
        'Ethical Auditing',
        'Consent Enforcement',
        'Unwanted Add-on Removal',
      ],
      prohibitedPromises: [
        'blame third parties falsely or defend unapproved slamming/cramming',
      ],
      mandatoryDisclosures: [
        'Optional device protection features can be removed at any time with no penalties',
        'Customer maintains manufacturer warranty for hardware defects during the first year',
      ],
      fictionalCandidateProducts: ['prod-protect-advantage'],
      turns: [
        const SalesTurn(
          id: 'turn-ret47-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: TrainingConstants.standardGreeting,
          phase: SalesPhase.greeting,
          requiredKeywords: ['att', 'alex', 'first', 'last', 'name'],
          trainerGuidanceArabic: 'ابدأ بالترحيب الرسمي المعتمد.',
          usEnglishModelResponse: TrainingConstants.standardGreeting,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret47-02',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret47-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Hello Alex. Nancy Drew calling. I bought a phone in a retail store last month, and I explicitly told the rep I did NOT want insurance. I look at my bill today and there is a seventeen-dollar charge for Protect Advantage! Why did your company sneak this on my bill?',
          phase: SalesPhase.initialResolution,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret47-03',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret47-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'Ms. Drew, I am sincerely sorry that occurred. Adding any feature without your clear consent goes completely against our ethical standards. I will remove that seventeen-dollar protection package right now and issue an immediate seventeen-dollar credit for that charge.',
          phase: SalesPhase.explorationPermission,
          requiredKeywords: [
            'sincerely sorry',
            'consent',
            'ethical standards',
            'remove',
            'immediate seventeen-dollar credit',
          ],
          trainerGuidanceArabic: 'اعتذر بصدق: إضافة ميزات بدون موافقة صريحة تخالف معاييرنا الأخلاقية تماماً. احذف الباقة فوراً وأرجع الـ 17 دولار كخصم مباشر.',
          usEnglishModelResponse: 'Ms. Drew, I apologize unreservedly. Adding optional features without explicit consent is completely against our policy. I am removing Protect Advantage immediately and applying a seventeen dollar credit to reimburse you.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret47-04',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret47-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Thank you. Are there any other hidden charges or subscriptions attached to my lines that I do not know about?',
          phase: SalesPhase.discovery,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret47-05',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret47-05',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Let us conduct a complete line audit right now. Looking at your profile: you have zero third-party subscriptions, zero gaming charges, and zero roadside assistance add-ons. Your account is completely clean, and your bill is now down to sixty-five dollars.',
          phase: SalesPhase.valueBridge,
          requiredKeywords: [
            'line audit',
            'zero third-party',
            'clean',
            'sixty-five dollars',
          ],
          trainerGuidanceArabic: 'قم بفحص شامل لجميع الخطوط للتأكد من خلو الحساب من أي اشتراكات أو خدمات إضافية غير مرغوبة.',
          usEnglishModelResponse: 'I am performing a complete account audit right now. All lines are clean: no third-party services, no premium messaging, and no roadside add-ons. Your line is now strictly your \$65 plan.',
          branches: [
            ScenarioBranch(
              conditionKey: 'accept',
              nextTurnId: 'turn-ret47-06A',
            ),
            ScenarioBranch(
              conditionKey: 'decline',
              nextTurnId: 'turn-ret47-06B',
            ),
            ScenarioBranch(
              conditionKey: 'verify',
              nextTurnId: 'turn-ret47-06C',
            ),
          ],
        ),
        // Path A: Qualified Accept
        const SalesTurn(
          id: 'turn-ret47-06A',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'That is how customer care should be handled. You removed it, credited the fee, and audited my account. Thank you for fixing this so quickly, Alex.',
          phase: SalesPhase.objectionHandling,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret47-07A',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret47-07A',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'It was my duty to make this right, Ms. Drew. The credit is posted, the feature is cancelled, and you have a secure account password lock placed to prevent any future unauthorized changes.',
          phase: SalesPhase.closing,
          requiredKeywords: [
            'duty',
            'credit is posted',
            'cancelled',
            'password lock',
          ],
          trainerGuidanceArabic: 'أكد تطبيق الرصيد وإلغاء الخدمة ووضع قفل أمان على الحساب لمنع التعديلات دون إذن.',
          usEnglishModelResponse: 'It was my pleasure to correct this. The credit is on your balance, the feature is removed, and your profile is locked against unapproved modifications.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret47-08A',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret47-08A',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText:
              'You restored my faith in AT&T, Alex. Have a wonderful day.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.qualifiedAccept,
        ),
        // Path B: Respectful No-Sale
        const SalesTurn(
          id: 'turn-ret47-06B',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Even with the credit, the fact that a store rep could do that to me means I do not trust this company anymore. I am going to payoff my phone and leave.',
          phase: SalesPhase.objectionHandling,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret47-07B',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret47-07B',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'I completely respect your feelings, Ms. Drew. Broken trust is very hard to rebuild, and I am logging a formal store investigation ticket regarding that rep. If you choose to leave, we respect your autonomy.',
          phase: SalesPhase.closing,
          requiredKeywords: [
            'respect your feelings',
            'broken trust',
            'store investigation ticket',
            'autonomy',
          ],
          trainerGuidanceArabic: 'احترم مشاعرها تماماً: فقدان الثقة صعب تعويضه، وسجل شكوى تفتيش رسمية بحق الفرع.',
          usEnglishModelResponse: 'I completely understand, Ms. Drew. Trust is vital. I am submitting a formal retail conduct complaint to regional management.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret47-08B',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret47-08B',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText: 'Thank you for understanding and submitting that complaint, Alex.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.respectfulNoSale,
        ),
        // Path C: Needs Verification
        const SalesTurn(
          id: 'turn-ret47-06C',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Can you email me a full PDF summary of my active account features so I have documented proof for my records?',
          phase: SalesPhase.eligibilityBoundary,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret47-07C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret47-07C',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'I have just triggered an official Customer Service Summary email to your verified address showing the removed insurance and your current balance credit.',
          phase: SalesPhase.eligibilityBoundary,
          requiredKeywords: [
            'customer service summary',
            'verified address',
            'removed insurance',
            'credit',
          ],
          trainerGuidanceArabic: 'أرسل ملخص خدمة العملاء (CSS) الرسمي لبريدها الإلكتروني الموثق لإثبات الحذف والرصيد.',
          usEnglishModelResponse: 'I have sent an updated Customer Service Summary to your email showing the zeroed insurance and posted credit.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret47-08C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret47-08C',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText: 'I will check my inbox right now. Thank you, Alex.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.needsVerification,
        ),
      ],
    ),

    // Scenario 48: Longtime Loyalty Recap & AutoPay Optimization
    SalesScenario(
      id: 'sales-48-longtime-loyalty-recap',
      title: '15-Year Loyalty Recognition & Plan Optimization Recap',
      category: 'retention_care_to_sales',
      difficulty: 'entry',
      profile: const SalesCustomerProfile(
        name: 'Margaret Thorton',
        tone: 'loyal, nostalgic customer',
        currentProvider: 'AT&T Legacy Shared Plan (15 years)',
        householdNeeds:
            'Felt unappreciated after seeing new customer commercials',
        financialConstraint: 'Paying \$140 for 2 lines on outdated 2012 plan',
        coreBlocker: 'Fears modern unlimited plans will have hidden catches or degrade coverage',
      ),
      contextNotes: 'Has been a customer for 15 years paying high legacy rates for limited shared data. Agent honors loyalty, updates lines to modern Unlimited Starter, saving \$40/mo.',
      skillTags: [
        'Loyalty Recognition',
        'Legacy Migration',
        'Empathetic Value',
        'AERD',
      ],
      prohibitedPromises: [
        'promise legacy plans can be restored once migrated away',
      ],
      mandatoryDisclosures: [
        'Legacy shared data plans cannot be re-added once migrated to modern unlimited plans',
        'AutoPay and paperless billing discount requires valid debit or checking account payment method',
      ],
      fictionalCandidateProducts: ['prod-wireless-starter'],
      turns: [
        const SalesTurn(
          id: 'turn-ret48-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: TrainingConstants.standardGreeting,
          phase: SalesPhase.greeting,
          requiredKeywords: ['att', 'alex', 'first', 'last', 'name'],
          trainerGuidanceArabic: 'ابدأ بالترحيب الرسمي المعتمد.',
          usEnglishModelResponse: TrainingConstants.standardGreeting,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret48-02',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret48-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Hello Alex. My name is Margaret Thorton. I have been an AT&T customer for fifteen years. I see commercials on TV offering all kinds of great deals to new customers, but nobody ever calls us loyal customers. We pay one hundred and forty dollars for two lines on an old shared plan. Does our fifteen years of loyalty mean anything?',
          phase: SalesPhase.initialResolution,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret48-03',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret48-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'Mrs. Thorton, first let me say thank you from the bottom of my heart for fifteen wonderful years of loyalty to AT&T! You are the backbone of our company, and it means the world to us. You should never be stuck paying high rates on an outdated plan when modern plans offer so much more value. Let us audit your account right now to reward your loyalty.',
          phase: SalesPhase.explorationPermission,
          requiredKeywords: [
            'fifteen wonderful years',
            'loyalty',
            'backbone',
            'audit your account',
          ],
          trainerGuidanceArabic: 'أظهر تقديراً وامتناناً حقيقياً لـ 15 عاماً من الوفاء (AERD). بين لها أن العملاء القدامى يستحقون أفضل العروض.',
          usEnglishModelResponse: 'Mrs. Thorton, thank you so much for fifteen years with AT&T! Your loyalty means everything to us. You should never have to pay outdated rates while new customers get deals. Let us review your plan together right now to modernize your service and lower your monthly cost.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret48-04',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret48-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'I would really appreciate that Alex. What can we do with our two lines?',
          phase: SalesPhase.discovery,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret48-05',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret48-05',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Right now you are paying one hundred forty dollars for limited shared data. We can transition both lines to modern Unlimited Starter for just ninety dollars total with AutoPay, giving you unlimited data, 5G access, and spam call protection while saving you fifty dollars every single month.',
          phase: SalesPhase.valueBridge,
          requiredKeywords: [
            'unlimited starter',
            'ninety dollars total',
            'autopay',
            'saving you fifty dollars',
          ],
          trainerGuidanceArabic: 'انقلها من الباقة القديمة المحدودة (140 دولار) إلى Unlimited Starter لخطين (90 دولار إجمالي)، بتوفير 50 دولار شهرياً وبيانات غير محدودة.',
          usEnglishModelResponse: 'Your legacy plan charges \$140 for capped data. Moving to Unlimited Starter with AutoPay gives both lines unlimited high-speed data, 5G, and spam blocking for only \$90 total, putting fifty dollars back in your pocket each month.',
          branches: [
            ScenarioBranch(
              conditionKey: 'accept',
              nextTurnId: 'turn-ret48-06A',
            ),
            ScenarioBranch(
              conditionKey: 'decline',
              nextTurnId: 'turn-ret48-06B',
            ),
            ScenarioBranch(
              conditionKey: 'verify',
              nextTurnId: 'turn-ret48-06C',
            ),
          ],
        ),
        // Path A: Qualified Accept
        const SalesTurn(
          id: 'turn-ret48-06A',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Fifty dollars a month in savings and unlimited data for both of us? That is six hundred dollars a year! That shows AT&T really does value our loyalty. Let us make that switch, Alex.',
          phase: SalesPhase.objectionHandling,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret48-07A',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret48-07A',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'I have updated both lines to Unlimited Starter, locked in your ninety-dollar monthly rate with AutoPay, and applied a loyalty appreciation note to your profile. Thank you again for being with us for fifteen years!',
          phase: SalesPhase.closing,
          requiredKeywords: [
            'unlimited starter',
            'ninety-dollar',
            'loyalty appreciation',
            'fifteen years',
          ],
          trainerGuidanceArabic: 'أكد تحديث الخطين وتثبيت سعر 90 دولار مع تدوين ملاحظة تقدير الوفاء في الملف.',
          usEnglishModelResponse: 'I have moved both lines to Unlimited Starter at the ninety dollar AutoPay rate and added a special loyalty recognition note. Thank you for fifteen fantastic years with AT&T!',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret48-08A',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret48-08A',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText: 'Thank you so much Alex. You made this loyal customer very happy today.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.qualifiedAccept,
        ),
        // Path B: Respectful No-Sale
        const SalesTurn(
          id: 'turn-ret48-06B',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'My husband told me never to touch our legacy plan because he likes rollover minutes. I think I better not change anything today or he will be upset.',
          phase: SalesPhase.objectionHandling,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret48-07B',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret48-07B',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'I completely understand, Mrs. Thorton! Keeping harmony at home comes first. We will keep your legacy plan completely untouched so your rollover minutes stay right where they are.',
          phase: SalesPhase.closing,
          requiredKeywords: [
            'harmony',
            'legacy plan',
            'untouched',
            'rollover minutes',
          ],
          trainerGuidanceArabic:
              'احترم رغبة زوجها واطمئنها أن الخطة القديمة ستبقى دون أي تغيير.',
          usEnglishModelResponse: 'I completely respect that, Mrs. Thorton. Family peace of mind comes first. We will leave your legacy plan exactly as it is.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret48-08B',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret48-08B',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText: 'Thank you for being so polite and respectful, Alex.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.respectfulNoSale,
        ),
        // Path C: Needs Verification
        const SalesTurn(
          id: 'turn-ret48-06C',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Can you verify if my husband’s line has an active employer corporate discount attached from his former company before we switch plans?',
          phase: SalesPhase.eligibilityBoundary,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret48-07C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret48-07C',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'Let me review the FAN discount code attached to his line. If it is active, it may provide an additional fifteen percent discount on top of the ninety-dollar rate.',
          phase: SalesPhase.eligibilityBoundary,
          requiredKeywords: [
            'fan discount code',
            'active',
            'fifteen percent',
            'review',
          ],
          trainerGuidanceArabic: 'راجع كود الخصم FAN على خط زوجها للتأكد من إمكانية الحصول على خصم إضافي.',
          usEnglishModelResponse: 'Let me check the organization discount code attached to your profile. That could yield an even greater discount on your new plan.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ret48-08C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ret48-08C',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText: 'Please check that code first dear. Thank you, Alex.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.needsVerification,
        ),
      ],
    ),
  ];
}
