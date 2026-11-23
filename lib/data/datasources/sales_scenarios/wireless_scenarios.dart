import '../../../core/constants/training_constants.dart';
import '../../../domain/entities/sales_scenario.dart';
import '../../../domain/entities/scenario.dart';

abstract class WirelessScenariosCatalog {
  static final List<SalesScenario> scenarios = [
    // Scenario 1: Starter to Extra Plan-Fit
    SalesScenario(
      id: 'sales-01-starter-to-extra',
      title: 'Commuter Mobile Hotspot & Priority Data Upgrade',
      category: 'wireless_upgrade',
      difficulty: 'intermediate',
      profile: const SalesCustomerProfile(
        name: 'Carlos Mendez',
        tone: 'pragmatic and busy',
        currentProvider: 'AT&T Unlimited Starter',
        householdNeeds:
            'Hotspot connection for work laptop on daily train commute',
        financialConstraint: 'Wants to keep monthly increase under \$15',
        coreBlocker: 'Fears hidden hotspot throttling and excessive bill fees',
      ),
      contextNotes: 'Customer calls to ask why laptop tethering disconnected on the train.',
      skillTags: ['Hotspot Discovery', 'Plan-Fit', 'Ethical Upsell', 'AERD'],
      prohibitedPromises: [
        'guarantee unlimited full-speed hotspot',
        'waive all taxes and administrative fees',
        'lock this rate forever',
      ],
      mandatoryDisclosures: [
        'Thirty gigabyte monthly hotspot allowance per line on Unlimited Extra',
        'Speeds reduce to 128Kbps after 30GB allowance',
        'AutoPay and paperless billing enrollment required for ten dollar discount',
      ],
      fictionalCandidateProducts: ['prod-wireless-extra'],
      turns: [
        // Turn 1: Agent Opening
        const SalesTurn(
          id: 'turn-w01-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: TrainingConstants.standardGreeting,
          phase: SalesPhase.greeting,
          requiredKeywords: ['att', 'alex', 'first', 'last', 'name'],
          trainerGuidanceArabic:
              'ابدأ بالترحيب الإلزامي الكامل متضمناً اسمك Alex وشركة AT&T.',
          usEnglishModelResponse: TrainingConstants.standardGreeting,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-w01-02'),
          ],
        ),

        // Turn 2: Customer Inquiry
        const SalesTurn(
          id: 'turn-w01-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Hi Alex, my name is Carlos Mendez. I was tethering my laptop on the train to finish some client presentations, and all of a sudden the internet connection just slowed to a crawl. Does my plan not include hotspot?',
          phase: SalesPhase.initialResolution,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-w01-03'),
          ],
        ),

        // Turn 3: Agent Acknowledgment & Discovery Permission
        const SalesTurn(
          id: 'turn-w01-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'I completely understand how important that client work is, Carlos. Unlimited Starter includes a basic 5GB hotspot allowance. May I check how often you tether during your weekly commute?',
          phase: SalesPhase.discovery,
          requiredKeywords: ['understand', 'hotspot', 'may i', 'commute'],
          trainerGuidanceArabic: 'اعترف بأهمية العمل وقدم المعلومة بأمانة، ثم استأذن لمعرفة حجم استخدامه الأسبوعي.',
          usEnglishModelResponse: 'I completely understand, Carlos. Your current Starter plan includes 5GB of hotspot data. May I ask how many days a week you need laptop tethering on the train?',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-w01-04'),
          ],
        ),

        // Turn 4: Customer Usage Detail (Decision Node 1)
        const SalesTurn(
          id: 'turn-w01-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'I commute four days a week, about an hour each way. I send emails and upload slides. What option gives me enough data without jumping fifty dollars higher?',
          phase: SalesPhase.discovery,
          branches: [
            ScenarioBranch(
              conditionKey: 'high_value',
              nextTurnId: 'turn-w01-05A',
              description: 'Offer Unlimited Extra with 30GB hotspot',
            ),
            ScenarioBranch(
              conditionKey: 'budget_decline',
              nextTurnId: 'turn-w01-05B',
              description: 'Customer declines plan upgrade due to budget',
            ),
            ScenarioBranch(
              conditionKey: 'needs_check',
              nextTurnId: 'turn-w01-05C',
              description:
                  'Customer wants to check account AutoPay status first',
            ),
          ],
        ),

        // Path A: Value Bridge & Plan Offer
        const SalesTurn(
          id: 'turn-w01-05A',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'In this simulated plan structure, our Unlimited Extra plan gives you 30GB of dedicated mobile hotspot data and 75GB of priority data, for an estimated ten dollars more per month with active AutoPay.',
          phase: SalesPhase.valueBridge,
          requiredKeywords: [
            'extra',
            '30gb',
            'hotspot',
            'autopay',
            'ten dollars',
          ],
          prohibitedPhrases: [
            'guarantee unlimited hotspot',
            'lock price forever',
          ],
          trainerGuidanceArabic: 'اربط ميزة الـ 30GB باحتياجه اليومي في القطار واذكر فارق السعر التقديري (\$10 مع AutoPay).',
          usEnglishModelResponse: 'Under this simulated plan structure, based on four days of commuting, our Unlimited Extra plan provides 30GB of dedicated hotspot data. The estimated monthly difference is ten dollars with your active AutoPay discount.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-w01-06A'),
          ],
        ),

        // Turn 6A: Customer Objection / Question
        const SalesTurn(
          id: 'turn-w01-06A',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Thirty gigabytes sounds like plenty for presentations. But are there extra setup fees or a contract required to change plans today?',
          phase: SalesPhase.objectionHandling,
          branches: [
            ScenarioBranch(conditionKey: 'accept', nextTurnId: 'turn-w01-07A'),
            ScenarioBranch(conditionKey: 'decline', nextTurnId: 'turn-w01-07B'),
          ],
        ),

        // Turn 7A: Agent Reassurance & Disclosure (Qualified Accept Path)
        const SalesTurn(
          id: 'turn-w01-07A',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'Under this simulated plan change, there are no separate change fees or service contracts, Carlos. Standard taxes and regulatory surcharges apply, and you will see prorated charges on your next bill.',
          phase: SalesPhase.eligibilityBoundary,
          requiredKeywords: ['no contract', 'proration', 'today', 'taxes'],
          trainerGuidanceArabic: 'وضح عدم وجود رسوم تغيير أو عقود واذكر تطبيق الضرائب والرسوم القياسية مع شرح الفاتورة المجزأة (Proration).',
          usEnglishModelResponse: 'Under this simulated offer, there are no plan change fees and no service contracts. Standard monthly taxes and regulatory fees apply, and prorated charges will appear on your next statement reflecting the difference.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-w01-08A'),
          ],
        ),

        // Turn 8A: Final Qualified Accept Outcome
        const SalesTurn(
          id: 'turn-w01-08A',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText: 'That works great for me, Alex. Let us go ahead and switch my line to Unlimited Extra so I can finish my work on the train ride home.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.qualifiedAccept,
        ),

        // Path B: Respectful No-Sale Success (Customer declines)
        const SalesTurn(
          id: 'turn-w01-05B',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'I completely understand, Carlos. We will keep you on Unlimited Starter so your bill stays exactly where it is. You can connect to free train station Wi-Fi whenever available.',
          phase: SalesPhase.closing,
          requiredKeywords: ['understand', 'keep', 'starter', 'bill'],
          trainerGuidanceArabic: 'احترم رغبة العميل واقترح بديل مجاني زي واي فاي المحطة؛ ده بيع أخلاقي محترم.',
          usEnglishModelResponse: 'I completely respect that, Carlos. We will leave your line on Starter with no changes. Whenever you are on the train, you can take advantage of station Wi-Fi to preserve your data.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-w01-06B'),
          ],
        ),

        const SalesTurn(
          id: 'turn-w01-06B',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'I appreciate you not pushing me into anything, Alex. That advice helps. Have a wonderful day.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.respectfulNoSale,
        ),

        // Path C: Needs Verification / Account Check
        const SalesTurn(
          id: 'turn-w01-05C',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Let me verify your account permissions first to confirm whether AutoPay is currently active, so you know the exact pricing before making any decision.',
          phase: SalesPhase.eligibilityBoundary,
          requiredKeywords: ['verify', 'account', 'autopay', 'pricing'],
          trainerGuidanceArabic:
              'تحقق من خصم AutoPay قبل تأكيد السعر النهائي لتجنب المفاجآت.',
          usEnglishModelResponse: 'Before we change anything, let me review your billing profile to confirm your AutoPay status and ensure you receive the ten dollar discount.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-w01-06C'),
          ],
        ),

        const SalesTurn(
          id: 'turn-w01-06C',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Good idea. Please verify that first, because if AutoPay is not set up, I want to review my payment method before doing anything else.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.needsVerification,
        ),
      ],
    ),

    // Scenario 2: Extra to Premium International Traveler
    SalesScenario(
      id: 'sales-02-extra-to-premium-travel',
      title: 'Latin America Roaming & 4K Streaming Upgrade',
      category: 'wireless_upgrade',
      difficulty: 'intermediate',
      profile: const SalesCustomerProfile(
        name: 'Elena Rostova',
        tone: 'frequent international traveler',
        currentProvider: 'AT&T Unlimited Extra',
        householdNeeds: 'Regular business trips to Brazil and Colombia without high daily roaming passes',
        financialConstraint:
            'Wants to avoid paying \$10/day International Day Pass repeatedly',
        coreBlocker: 'Unsure whether coverage is truly included in the monthly plan rate',
      ),
      contextNotes: 'Caller asks how much roaming will cost for a 14-day trip to Colombia.',
      skillTags: ['International Roaming', 'Travel Discovery', 'Value Bridge'],
      prohibitedPromises: [
        'guarantee 5G coverage worldwide',
        'promise roaming in every country',
      ],
      mandatoryDisclosures: [
        'Unlimited Premium includes talk, text, and high-speed data in 19 Latin American countries',
        'Device must be capable and have data roaming enabled in device settings',
      ],
      fictionalCandidateProducts: ['prod-wireless-premium'],
      turns: [
        const SalesTurn(
          id: 'turn-w02-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: TrainingConstants.standardGreeting,
          phase: SalesPhase.greeting,
          requiredKeywords: ['att', 'alex', 'first', 'last', 'name'],
          trainerGuidanceArabic: 'الافتتاحية الإلزامية بالاسم والشركة.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-w02-02'),
          ],
        ),
        const SalesTurn(
          id: 'turn-w02-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Hello Alex, this is Elena Rostova. I am flying to Colombia for two weeks for work, and I usually pay ten dollars a day for roaming. That adds up to 140 dollars. Is there any plan that includes Latin America?',
          phase: SalesPhase.initialResolution,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-w02-03'),
          ],
        ),
        const SalesTurn(
          id: 'turn-w02-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'Safe travels to Colombia, Elena! Our Unlimited Premium plan actually includes unlimited talk, text, and data in 19 Latin American countries including Colombia, for just ten dollars more per month than your current Extra plan.',
          phase: SalesPhase.valueBridge,
          requiredKeywords: ['premium', 'colombia', 'included', 'ten dollars'],
          trainerGuidanceArabic: 'قارن بين تكلفة الـ \$140 في السفرة الواحدة وفارق الـ \$10 شهرياً في باقة Premium.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-w02-04'),
          ],
        ),
        const SalesTurn(
          id: 'turn-w02-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Wait, so instead of paying 140 dollars for two weeks of Day Passes, I only pay ten dollars more on my plan rate and Colombia is completely included?',
          phase: SalesPhase.objectionHandling,
          branches: [
            ScenarioBranch(conditionKey: 'accept', nextTurnId: 'turn-w02-05A'),
            ScenarioBranch(conditionKey: 'decline', nextTurnId: 'turn-w02-05B'),
            ScenarioBranch(
              conditionKey: 'needs_check',
              nextTurnId: 'turn-w02-05C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-w02-05A',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Exactly, Elena. Colombia is one of the 19 included countries, plus you get 60GB of domestic hotspot and data that never slows down.',
          phase: SalesPhase.closing,
          requiredKeywords: ['colombia', 'included', '60gb', 'hotspot'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-w02-06A'),
          ],
        ),
        const SalesTurn(
          id: 'turn-w02-06A',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'That is a huge savings for my trip. Please upgrade my line to Unlimited Premium right now.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.qualifiedAccept,
        ),
        const SalesTurn(
          id: 'turn-w02-05B',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'I understand completely, Elena. If you prefer to stick with your current Extra plan and just use hotel Wi-Fi, we will leave everything as is.',
          phase: SalesPhase.closing,
          requiredKeywords: ['understand', 'leave', 'as is', 'wi-fi'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-w02-06B'),
          ],
        ),
        const SalesTurn(
          id: 'turn-w02-06B',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Thanks Alex, I will just stick to hotel Wi-Fi this time. Appreciate the clear comparison!',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.respectfulNoSale,
        ),
        const SalesTurn(
          id: 'turn-w02-05C',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Let me verify your device model first to ensure your phone hardware supports Latin American LTE bands before you make the switch.',
          phase: SalesPhase.eligibilityBoundary,
          requiredKeywords: ['verify', 'device', 'hardware', 'bands'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-w02-06C'),
          ],
        ),
        const SalesTurn(
          id: 'turn-w02-06C',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Good point, I am using an older phone. Let me check the model number and call back.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.needsVerification,
        ),
      ],
    ),

    // Scenario 3: Budget Wireless Discovery (Starter fit)
    SalesScenario(
      id: 'sales-03-budget-wireless-discovery',
      title: 'Fixed Income Single Line Optimization',
      category: 'wireless_upgrade',
      difficulty: 'beginner',
      profile: const SalesCustomerProfile(
        name: 'Harold Green',
        tone: 'elderly and very cost-conscious',
        currentProvider: 'Grandfathered 4GB Shared Data Plan',
        householdNeeds:
            'Basic calling, family texting, and checking weather apps',
        financialConstraint: 'Strict fixed pension budget',
        coreBlocker:
            'Pays overage charges when grandchildren visit and use data',
      ),
      contextNotes: 'Customer got charged \$15 data overage on his old grandfathered tier.',
      skillTags: ['Overage Protection', 'Budget Discovery', 'Ethical Plan-Fit'],
      prohibitedPromises: [
        'waive all future bills',
        'guarantee free line forever',
      ],
      mandatoryDisclosures: [
        'Unlimited Starter eliminates all data overage charges',
        'AutoPay with checking account gives ten dollar monthly discount',
      ],
      fictionalCandidateProducts: ['prod-wireless-starter'],
      turns: [
        const SalesTurn(
          id: 'turn-w03-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: TrainingConstants.standardGreeting,
          phase: SalesPhase.greeting,
          trainerGuidanceArabic:
              'ابدأ بالترحيب الإلزامي الكامل متضمناً اسمك Alex وشركة AT&T.',
          requiredKeywords: ['att', 'alex', 'first', 'last', 'name'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-w03-02'),
          ],
        ),
        const SalesTurn(
          id: 'turn-w03-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Hello Alex. My name is Harold Green. I am on a fixed income, and I got hit with a fifteen dollar data overage fee because my grandkids played games on my phone. Why do I get charged overages?',
          phase: SalesPhase.initialResolution,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-w03-03'),
          ],
        ),
        const SalesTurn(
          id: 'turn-w03-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'I am so sorry to hear about that unexpected fee, Harold. Your older 4GB plan charges overage fees when data runs out. Our Unlimited Starter plan gives you unlimited data with zero overage fees ever.',
          phase: SalesPhase.valueBridge,
          requiredKeywords: ['sorry', 'starter', 'unlimited', 'zero overage'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-w03-04'),
          ],
        ),
        const SalesTurn(
          id: 'turn-w03-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Zero overages sounds peaceful. But how much will Starter cost each month compared to my old plan?',
          phase: SalesPhase.objectionHandling,
          branches: [
            ScenarioBranch(conditionKey: 'accept', nextTurnId: 'turn-w03-05A'),
            ScenarioBranch(conditionKey: 'decline', nextTurnId: 'turn-w03-05B'),
            ScenarioBranch(
              conditionKey: 'needs_check',
              nextTurnId: 'turn-w03-05C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-w03-05A',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'With AutoPay, Unlimited Starter is sixty-five dollars a month, which is actually lower than your old bill with that fifteen dollar overage included.',
          phase: SalesPhase.closing,
          requiredKeywords: ['sixty five', 'autopay', 'lower', 'starter'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-w03-06A'),
          ],
        ),
        const SalesTurn(
          id: 'turn-w03-06A',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'If it protects me from surprise fees, let us switch it today. Thank you for looking out for my budget.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.qualifiedAccept,
        ),
        const SalesTurn(
          id: 'turn-w03-05B',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'I completely respect your budget, Harold. We will leave your current plan in place, and I will show you how to turn off cellular data in your phone settings when the grandkids visit.',
          phase: SalesPhase.closing,
          requiredKeywords: ['respect', 'budget', 'settings', 'leave'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-w03-06B'),
          ],
        ),
        const SalesTurn(
          id: 'turn-w03-06B',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Turning off data when they visit is a great tip. Thank you for respecting my budget, Alex.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.respectfulNoSale,
        ),
        const SalesTurn(
          id: 'turn-w03-05C',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Let me verify your AutoPay banking method first to make sure you qualify for the ten dollar discount before making any change.',
          phase: SalesPhase.eligibilityBoundary,
          requiredKeywords: ['verify', 'autopay', 'banking', 'discount'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-w03-06C'),
          ],
        ),
        const SalesTurn(
          id: 'turn-w03-06C',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Let me check my checkbook first so I know which account is linked. I will call back.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.needsVerification,
        ),
      ],
    ),

    // Scenario 4: Unlimited Extra Multi-Line Family Consolidation
    SalesScenario(
      id: 'sales-04-multiline-extra-family',
      title: 'Four-Line Family Account Consolidation',
      category: 'wireless_upgrade',
      difficulty: 'challenging',
      profile: const SalesCustomerProfile(
        name: 'Sarah Jenkins',
        tone: 'busy parent managing family finances',
        currentProvider: 'Two lines on AT&T, two lines on competitor',
        householdNeeds:
            'Shared billing, high schooler data, and mobile security',
        financialConstraint: 'Looking for group pricing under \$40/line',
        coreBlocker:
            'Wants reassurance that all numbers can be transferred safely',
      ),
      contextNotes:
          'Customer wants to understand how 4-line multi-line discounts work.',
      skillTags: [
        'Multi-Line Group Pricing',
        'Family Needs',
        'Porting Verification',
      ],
      prohibitedPromises: [
        'guarantee transfer in five minutes',
        'waive all carrier payoff costs',
      ],
      mandatoryDisclosures: [
        'Multi-line rate requires four active lines on eligible unlimited plan with AutoPay',
        'Porting numbers requires account number and transfer PIN from previous carrier',
      ],
      fictionalCandidateProducts: ['prod-wireless-extra', 'prod-add-a-line'],
      turns: [
        const SalesTurn(
          id: 'turn-w04-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: TrainingConstants.standardGreeting,
          phase: SalesPhase.greeting,
          trainerGuidanceArabic:
              'ابدأ بالترحيب الإلزامي الكامل متضمناً اسمك Alex وشركة AT&T.',
          requiredKeywords: ['att', 'alex', 'first', 'last', 'name'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-w04-02'),
          ],
        ),
        const SalesTurn(
          id: 'turn-w04-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Hi Alex, I am Sarah Jenkins. We have two lines with AT&T and two with Verizon. How much would it cost to bring all four lines onto Unlimited Extra together?',
          phase: SalesPhase.initialResolution,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-w04-03'),
          ],
        ),
        const SalesTurn(
          id: 'turn-w04-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'Great to assist you, Sarah! With four lines on Unlimited Extra, our multi-line discount brings the price down to just forty dollars per line per month with AutoPay.',
          phase: SalesPhase.valueBridge,
          requiredKeywords: ['four lines', 'forty dollars', 'line', 'autopay'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-w04-04'),
          ],
        ),
        const SalesTurn(
          id: 'turn-w04-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Forty dollars per line is significantly less than what we are paying separate right now. Can we bring our current phones and keep our numbers?',
          phase: SalesPhase.objectionHandling,
          branches: [
            ScenarioBranch(conditionKey: 'accept', nextTurnId: 'turn-w04-05A'),
            ScenarioBranch(conditionKey: 'decline', nextTurnId: 'turn-w04-05B'),
            ScenarioBranch(
              conditionKey: 'needs_check',
              nextTurnId: 'turn-w04-05C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-w04-05A',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Yes, Sarah! You can Bring Your Own Device with no device installment costs. Once you have the Verizon account number and transfer PIN, we can port both numbers seamlessly.',
          phase: SalesPhase.closing,
          requiredKeywords: [
            'bring your own device',
            'transfer pin',
            'port',
            'numbers',
          ],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-w04-06A'),
          ],
        ),
        const SalesTurn(
          id: 'turn-w04-06A',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'I have both PINs ready right now on my phone. Let us proceed with bringing over the other two lines.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.qualifiedAccept,
        ),
        const SalesTurn(
          id: 'turn-w04-05B',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'I completely understand, Sarah. Combining lines is a family decision. Take your time to review your Verizon statement and call us back whenever you are ready.',
          phase: SalesPhase.closing,
          requiredKeywords: ['understand', 'family', 'decision', 'whenever'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-w04-06B'),
          ],
        ),
        const SalesTurn(
          id: 'turn-w04-06B',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Thanks for the pressure-free breakdown, Alex. I will talk to my husband tonight first.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.respectfulNoSale,
        ),
        const SalesTurn(
          id: 'turn-w04-05C',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Before we initiate number transfer, we must verify that both devices are fully unlocked by your current carrier so they can connect to our network.',
          phase: SalesPhase.eligibilityBoundary,
          requiredKeywords: ['verify', 'unlocked', 'carrier', 'network'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-w04-06C'),
          ],
        ),
        const SalesTurn(
          id: 'turn-w04-06C',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Let me check if the phones are paid off and unlocked first. I will verify that with Verizon today.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.needsVerification,
        ),
      ],
    ),

    // Scenario 5: Heavy Content Creator 4K Streaming (Premium fit)
    SalesScenario(
      id: 'sales-05-content-creator-4k',
      title: 'Mobile Video Producer & Uncapped Data Fit',
      category: 'wireless_upgrade',
      difficulty: 'intermediate',
      profile: const SalesCustomerProfile(
        name: 'Jordan Reed',
        tone: 'energetic video content creator',
        currentProvider: 'Unlimited Starter',
        householdNeeds: 'Live streaming on TikTok/YouTube, 4K video uploads, remote hotspot',
        financialConstraint:
            'Willing to pay for performance if speeds do not throttle',
        coreBlocker: 'Frustrated by standard definition video caps on current Starter plan',
      ),
      contextNotes: 'Caller asks why his mobile streams look pixelated.',
      skillTags: ['4K Streaming', 'Power User', 'Premium Differentiation'],
      prohibitedPromises: ['guarantee 1000 Mbps mobile speed everywhere'],
      mandatoryDisclosures: [
        'Unlimited Premium data cannot slow down based on data usage',
        '4K UHD streaming requires turning on Stream Saver toggle in account settings',
      ],
      fictionalCandidateProducts: ['prod-wireless-premium'],
      turns: [
        const SalesTurn(
          id: 'turn-w05-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: TrainingConstants.standardGreeting,
          phase: SalesPhase.greeting,
          trainerGuidanceArabic:
              'ابدأ بالترحيب الإلزامي الكامل متضمناً اسمك Alex وشركة AT&T.',
          requiredKeywords: ['att', 'alex', 'first', 'last', 'name'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-w05-02'),
          ],
        ),
        const SalesTurn(
          id: 'turn-w05-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Hey Alex, I am Jordan Reed. When I broadcast live video on location, my streams keep buffering and the video looks blurry. Why is my phone capping my stream quality?',
          phase: SalesPhase.initialResolution,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-w05-03'),
          ],
        ),
        const SalesTurn(
          id: 'turn-w05-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'I understand completely, Jordan. Unlimited Starter streams in standard definition. Our Unlimited Premium plan unlocks 4K UHD video streaming and unlimited priority data that never slows down.',
          phase: SalesPhase.valueBridge,
          requiredKeywords: ['premium', '4k', 'uhd', 'never slows'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-w05-04'),
          ],
        ),
        const SalesTurn(
          id: 'turn-w05-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'That is exactly what my channel needs. What does the Premium plan run monthly?',
          phase: SalesPhase.objectionHandling,
          branches: [
            ScenarioBranch(conditionKey: 'accept', nextTurnId: 'turn-w05-05A'),
            ScenarioBranch(conditionKey: 'decline', nextTurnId: 'turn-w05-05B'),
            ScenarioBranch(
              conditionKey: 'needs_check',
              nextTurnId: 'turn-w05-05C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-w05-05A',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'With your active AutoPay discount, Unlimited Premium is eighty-five dollars a month, plus you get 60GB of hotspot for your editing laptop.',
          phase: SalesPhase.closing,
          requiredKeywords: ['eighty-five', 'sixty', 'hotspot', 'autopay'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-w05-06A'),
          ],
        ),
        const SalesTurn(
          id: 'turn-w05-06A',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Sixty gigs of hotspot and 4K streaming is worth every penny for my business. Switch me up right now.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.qualifiedAccept,
        ),
        const SalesTurn(
          id: 'turn-w05-05B',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'I understand, Jordan. Eighty-five dollars might be higher than you want to spend today. You can keep Starter and upload videos over studio Wi-Fi instead.',
          phase: SalesPhase.closing,
          requiredKeywords: ['understand', 'spend', 'keep', 'wi-fi'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-w05-06B'),
          ],
        ),
        const SalesTurn(
          id: 'turn-w05-06B',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Thanks for being real about the price, Alex. I will stick to studio Wi-Fi for now.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.respectfulNoSale,
        ),
        const SalesTurn(
          id: 'turn-w05-05C',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Let me verify whether your current device hardware supports 4K cellular video output before you change tiers.',
          phase: SalesPhase.eligibilityBoundary,
          requiredKeywords: ['verify', 'device', 'hardware', '4k'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-w05-06C'),
          ],
        ),
        const SalesTurn(
          id: 'turn-w05-06C',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Good thinking. Let me double-check my phone specs and reach back out.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.needsVerification,
        ),
      ],
    ),

    // Scenario 6: ActiveArmor Advanced Security Upgrade
    SalesScenario(
      id: 'sales-06-security-activearmor-upgrade',
      title: 'Spam Call Protection & Public Wi-Fi VPN Need',
      category: 'wireless_upgrade',
      difficulty: 'beginner',
      profile: const SalesCustomerProfile(
        name: 'Brenda Miller',
        tone: 'concerned about privacy and scams',
        currentProvider: 'Unlimited Starter',
        householdNeeds: 'Protection from scam calls and safe browsing on airport/hotel Wi-Fi',
        financialConstraint:
            'Prefers included security over buying separate VPN software',
        coreBlocker: 'Tired of getting 10 spam robocalls a day',
      ),
      contextNotes: 'Caller asks if AT&T can block relentless scam calls.',
      skillTags: ['Mobile Security', 'ActiveArmor', 'Privacy'],
      prohibitedPromises: ['guarantee zero spam calls ever reach phone'],
      mandatoryDisclosures: [
        'ActiveArmor Advanced requires downloading mobile app and enabling settings',
        'VPN feature encrypts public Wi-Fi on compatible iOS and Android devices',
      ],
      fictionalCandidateProducts: ['prod-wireless-extra'],
      turns: [
        const SalesTurn(
          id: 'turn-w06-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: TrainingConstants.standardGreeting,
          phase: SalesPhase.greeting,
          trainerGuidanceArabic:
              'ابدأ بالترحيب الإلزامي الكامل متضمناً اسمك Alex وشركة AT&T.',
          requiredKeywords: ['att', 'alex', 'first', 'last', 'name'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-w06-02'),
          ],
        ),
        const SalesTurn(
          id: 'turn-w06-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Hello Alex, this is Brenda Miller. I am getting bombarded by scam and spam calls every single day on my cell phone. Is there any way to block them automatically?',
          phase: SalesPhase.initialResolution,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-w06-03'),
          ],
        ),
        const SalesTurn(
          id: 'turn-w06-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'I completely understand your frustration with robocalls, Brenda. With Unlimited Extra, you receive AT&T ActiveArmor Advanced, which blocks spam calls, alerts you to identity breaches, and provides a secure Wi-Fi VPN.',
          phase: SalesPhase.valueBridge,
          requiredKeywords: [
            'understand',
            'activearmor',
            'advanced',
            'vpn',
            'spam',
          ],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-w06-04'),
          ],
        ),
        const SalesTurn(
          id: 'turn-w06-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Having built-in VPN and spam blocking would give me real peace of mind. Does that cost a lot extra on my plan?',
          phase: SalesPhase.objectionHandling,
          branches: [
            ScenarioBranch(conditionKey: 'accept', nextTurnId: 'turn-w06-05A'),
            ScenarioBranch(conditionKey: 'decline', nextTurnId: 'turn-w06-05B'),
            ScenarioBranch(
              conditionKey: 'needs_check',
              nextTurnId: 'turn-w06-05C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-w06-05A',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'It is included with Unlimited Extra for only ten dollars more a month, plus you get 30GB of hotspot data.',
          phase: SalesPhase.closing,
          requiredKeywords: ['included', 'extra', 'ten dollars', 'hotspot'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-w06-06A'),
          ],
        ),
        const SalesTurn(
          id: 'turn-w06-06A',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Ten dollars for spam blocking and VPN is well worth it. Please upgrade my plan and send me the app download link.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.qualifiedAccept,
        ),
        const SalesTurn(
          id: 'turn-w06-05B',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'I understand, Brenda. You can also download the free version of ActiveArmor on Starter for basic spam call blocking at no extra charge.',
          phase: SalesPhase.closing,
          requiredKeywords: [
            'understand',
            'free version',
            'basic',
            'no extra charge',
          ],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-w06-06B'),
          ],
        ),
        const SalesTurn(
          id: 'turn-w06-06B',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'I will try the free basic app first. Thank you for telling me about both options!',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.respectfulNoSale,
        ),
        const SalesTurn(
          id: 'turn-w06-05C',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Let me verify your smartphone operating system version to make sure your phone is compatible with the ActiveArmor app.',
          phase: SalesPhase.eligibilityBoundary,
          requiredKeywords: [
            'verify',
            'operating system',
            'compatible',
            'version',
          ],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-w06-06C'),
          ],
        ),
        const SalesTurn(
          id: 'turn-w06-06C',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Let me check my software update settings first to make sure it is updated.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.needsVerification,
        ),
      ],
    ),

    // Scenario 7: Student Shared Data to Starter Conversion
    SalesScenario(
      id: 'sales-07-student-shared-data-switch',
      title: 'College Student Shared Data Overage Fix',
      category: 'wireless_upgrade',
      difficulty: 'intermediate',
      profile: const SalesCustomerProfile(
        name: 'Tyler Vance',
        tone: 'busy college student',
        currentProvider: 'Parents shared 9GB plan',
        householdNeeds:
            'Streaming lectures, campus navigation, study group hotspot',
        financialConstraint:
            'Parents pay base bill but require him to pay overages',
        coreBlocker: 'Needs unlimited data so he stops getting scolded by parents for overages',
      ),
      contextNotes: 'Caller asks how to stop his phone from running out of gigabytes during finals.',
      skillTags: ['Student Needs', 'Overage Resolution', 'Unlimited Starter'],
      prohibitedPromises: ['waive parent approval requirement'],
      mandatoryDisclosures: [
        'Plan changes on family accounts require primary account holder authorization',
        'Unlimited Starter eliminates overage fees for the entire account',
      ],
      fictionalCandidateProducts: ['prod-wireless-starter'],
      turns: [
        const SalesTurn(
          id: 'turn-w07-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: TrainingConstants.standardGreeting,
          phase: SalesPhase.greeting,
          trainerGuidanceArabic:
              'ابدأ بالترحيب الإلزامي الكامل متضمناً اسمك Alex وشركة AT&T.',
          requiredKeywords: ['att', 'alex', 'first', 'last', 'name'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-w07-02'),
          ],
        ),
        const SalesTurn(
          id: 'turn-w07-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Hey Alex, my name is Tyler Vance. I am on my parents family plan, and every finals week I blow through our shared data studying on campus and my dad gets mad. How can we fix this?',
          phase: SalesPhase.initialResolution,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-w07-03'),
          ],
        ),
        const SalesTurn(
          id: 'turn-w07-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'I understand completely, Tyler. Moving your family account to Unlimited Starter gives all lines unlimited data with zero overage charges, often for less than what older shared plans cost.',
          phase: SalesPhase.valueBridge,
          requiredKeywords: [
            'understand',
            'family',
            'starter',
            'unlimited',
            'zero overage',
          ],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-w07-04'),
          ],
        ),
        const SalesTurn(
          id: 'turn-w07-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'That would save me a huge headache with my dad. Can you make that change right now on this call?',
          phase: SalesPhase.objectionHandling,
          branches: [
            ScenarioBranch(conditionKey: 'accept', nextTurnId: 'turn-w07-05A'),
            ScenarioBranch(conditionKey: 'decline', nextTurnId: 'turn-w07-05B'),
            ScenarioBranch(
              conditionKey: 'needs_check',
              nextTurnId: 'turn-w07-05C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-w07-05A',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Since you are an authorized user on the account, we can update the family plan to Starter today so everyone enjoys unlimited data immediately.',
          phase: SalesPhase.closing,
          requiredKeywords: ['authorized', 'starter', 'today', 'unlimited'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-w07-06A'),
          ],
        ),
        const SalesTurn(
          id: 'turn-w07-06A',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Awesome, dad already authorized me. Go ahead and switch us to Unlimited Starter!',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.qualifiedAccept,
        ),
        const SalesTurn(
          id: 'turn-w07-05B',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'I understand, Tyler. If your dad wants to review the bill comparison himself first, we will leave everything alone and you can show him our online plan tool.',
          phase: SalesPhase.closing,
          requiredKeywords: ['understand', 'leave', 'dad', 'review'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-w07-06B'),
          ],
        ),
        const SalesTurn(
          id: 'turn-w07-06B',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'I will have my dad log into the myAT&T app tonight to look at it. Thanks Alex!',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.respectfulNoSale,
        ),
        const SalesTurn(
          id: 'turn-w07-05C',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Before we make any changes, we must verify that you are listed as an authorized manager on your father account profile.',
          phase: SalesPhase.eligibilityBoundary,
          requiredKeywords: ['verify', 'authorized', 'manager', 'profile'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-w07-06C'),
          ],
        ),
        const SalesTurn(
          id: 'turn-w07-06C',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Let me get my dad on the line or have him add me as an authorized user first.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.needsVerification,
        ),
      ],
    ),

    // Scenario 8: Dual-Carrier Small Business Professional
    SalesScenario(
      id: 'sales-08-dual-carrier-pro-upgrade',
      title: 'Consultant Dual SIM Line & Priority Network Fit',
      category: 'wireless_upgrade',
      difficulty: 'challenging',
      profile: const SalesCustomerProfile(
        name: 'Dominic Shaw',
        tone: 'professional independent consultant',
        currentProvider: 'AT&T Personal + T-Mobile Work Line',
        householdNeeds: 'Dual SIM on single device, uncapped priority data, business hotspot',
        financialConstraint:
            'Looking to consolidate expenses into single deductible statement',
        coreBlocker:
            'Needs reassurance that work phone numbers port cleanly to eSIM',
      ),
      contextNotes: 'Caller wants to consolidate two physical phones into one Dual SIM device.',
      skillTags: ['eSIM Technology', 'Dual SIM', 'Business Consolidation'],
      prohibitedPromises: ['guarantee instant carrier release'],
      mandatoryDisclosures: [
        'eSIM activation requires compatible unlocked dual-SIM smartphone',
        'T-Mobile line transfer requires account number and porting authorization PIN',
      ],
      fictionalCandidateProducts: ['prod-wireless-premium', 'prod-add-a-line'],
      turns: [
        const SalesTurn(
          id: 'turn-w08-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: TrainingConstants.standardGreeting,
          phase: SalesPhase.greeting,
          trainerGuidanceArabic:
              'ابدأ بالترحيب الإلزامي الكامل متضمناً اسمك Alex وشركة AT&T.',
          requiredKeywords: ['att', 'alex', 'first', 'last', 'name'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-w08-02'),
          ],
        ),
        const SalesTurn(
          id: 'turn-w08-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Good morning Alex, Dominic Shaw speaking. I currently carry two phones: one AT&T personal and one T-Mobile work phone. Can I bring my work number onto my AT&T iPhone using an electronic SIM card?',
          phase: SalesPhase.initialResolution,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-w08-03'),
          ],
        ),
        const SalesTurn(
          id: 'turn-w08-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'Great to assist you, Dominic! Yes, your iPhone supports dual active eSIMs. We can add your work line to your account with a multi-line discount, so both numbers ring on the same phone.',
          phase: SalesPhase.valueBridge,
          requiredKeywords: [
            'esim',
            'dual',
            'multi-line',
            'discount',
            'iphone',
          ],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-w08-04'),
          ],
        ),
        const SalesTurn(
          id: 'turn-w08-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Carrying one phone would make my travel so much lighter. How does the billing work when adding the second line?',
          phase: SalesPhase.objectionHandling,
          branches: [
            ScenarioBranch(conditionKey: 'accept', nextTurnId: 'turn-w08-05A'),
            ScenarioBranch(conditionKey: 'decline', nextTurnId: 'turn-w08-05B'),
            ScenarioBranch(
              conditionKey: 'needs_check',
              nextTurnId: 'turn-w08-05C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-w08-05A',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Adding the second line lowers the cost per line, and both show clearly itemized on one bill. Once you have the transfer PIN from T-Mobile, we can download the eSIM in minutes.',
          phase: SalesPhase.closing,
          requiredKeywords: ['lowers', 'esim', 'transfer pin', 'itemized'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-w08-06A'),
          ],
        ),
        const SalesTurn(
          id: 'turn-w08-06A',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'I have the T-Mobile porting PIN generated in my app right now. Let us transfer it over to eSIM.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.qualifiedAccept,
        ),
        const SalesTurn(
          id: 'turn-w08-05B',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'I understand completely, Dominic. Keeping business and personal phones physically separate works well for many consultants. We will keep your personal line exactly as is.',
          phase: SalesPhase.closing,
          requiredKeywords: ['understand', 'separate', 'personal', 'as is'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-w08-06B'),
          ],
        ),
        const SalesTurn(
          id: 'turn-w08-06B',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'I think keeping two separate physical phones is still better for my tax accounting. Thank you, Alex.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.respectfulNoSale,
        ),
        const SalesTurn(
          id: 'turn-w08-05C',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Before we initiate transfer, we must confirm that your iPhone is carrier-unlocked and not restricted by your current employer.',
          phase: SalesPhase.eligibilityBoundary,
          requiredKeywords: ['confirm', 'unlocked', 'restricted', 'employer'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-w08-06C'),
          ],
        ),
        const SalesTurn(
          id: 'turn-w08-06C',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Let me verify with my company IT department whether they allow number porting off their corporate account.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.needsVerification,
        ),
      ],
    ),
  ];
}
