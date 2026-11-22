import '../../../core/constants/training_constants.dart';
import '../../../domain/entities/sales_scenario.dart';
import '../../../domain/entities/scenario.dart';

abstract class LandlineToWirelessScenariosCatalog {
  static final List<SalesScenario> scenarios = [
    // Scenario 25: Aging Copper Retirement & Cellular Base
    SalesScenario(
      id: 'sales-25-copper-wire-retire',
      title: 'Copper Wire Retirement & Wireless Home Phone Transition',
      category: 'landline_to_wireless',
      difficulty: 'intermediate',
      profile: const SalesCustomerProfile(
        name: 'Harold Jenkins',
        tone: 'concerned retiree',
        currentProvider: 'Traditional Landline (Copper)',
        householdNeeds:
            'Keep home telephone number active after copper retirement notice',
        financialConstraint:
            'On fixed retirement pension, wants no bill increases',
        coreBlocker: 'Afraid of losing his 40-year-old home phone number during migration',
      ),
      contextNotes: 'Received a carrier notice regarding traditional copper maintenance phase-out in his neighborhood.',
      skillTags: [
        'Copper Migration',
        'Number Porting',
        'Senior Empathy',
        'AERD',
      ],
      prohibitedPromises: [
        'promise copper lines will never be decommissioned',
        'guarantee instant zero-second number porting without verification',
        'waive all local taxes permanently',
      ],
      mandatoryDisclosures: [
        'Wireless Home Phone base requires cellular signal coverage inside the home',
        'Number porting typically completes within three to five business days',
        'E911 location accuracy depends on the registered service address',
      ],
      fictionalCandidateProducts: ['prod-landline-cell-base'],
      turns: [
        const SalesTurn(
          id: 'turn-ll25-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: TrainingConstants.standardGreeting,
          phase: SalesPhase.greeting,
          requiredKeywords: ['att', 'alex', 'first', 'last', 'name'],
          trainerGuidanceArabic:
              'ابدأ بالترحيب الإلزامي الكامل متضمناً اسمك Alex وشركة AT&T.',
          usEnglishModelResponse: TrainingConstants.standardGreeting,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-ll25-02'),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll25-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Hello Alex. My name is Harold Jenkins. I got a letter saying the copper wiring in my neighborhood is being retired. I have had this same phone number since 1984, and I cannot afford to lose it.',
          phase: SalesPhase.initialResolution,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-ll25-03'),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll25-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'I completely understand your concern, Mr. Jenkins. Having the same phone number for forty years is very meaningful. We can protect your number and move it seamlessly to a Wireless Home Phone base that plugs right into your existing home phones.',
          phase: SalesPhase.explorationPermission,
          requiredKeywords: [
            'understand',
            'protect',
            'number',
            'wireless home phone',
          ],
          trainerGuidanceArabic: 'طَمئِن العميل بخصوص رقم هاتفه وقدم جهاز Wireless Home Phone كحل مباشر.',
          usEnglishModelResponse: 'I completely understand, Mr. Jenkins. You will not lose your number. We have a wireless home phone adapter that keeps your exact phone number and plugs directly into your existing telephones.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-ll25-04'),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll25-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Does that mean I do not need a computer or a smartphone? And how much does this cost compared to my seventy-dollar copper bill?',
          phase: SalesPhase.discovery,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-ll25-05'),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll25-05',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'No computer or smartphone is required. You plug your regular cordless or corded phone right into the back of the base. The plan is thirty dollars a month, which actually saves you forty dollars every month.',
          phase: SalesPhase.valueBridge,
          requiredKeywords: [
            'no computer',
            'thirty dollars',
            'cordless',
            'saves',
          ],
          trainerGuidanceArabic: 'اشرح بساطة التركيب والتوفير المالي (30 دولار بدلاً من 70 دولار بدون أجهزة معقدة).',
          usEnglishModelResponse: 'No internet or smartphone is needed. Your regular home telephone plugs right into the wireless base. The service is thirty dollars a month, cutting your current bill in half.',
          branches: [
            ScenarioBranch(conditionKey: 'accept', nextTurnId: 'turn-ll25-06A'),
            ScenarioBranch(
              conditionKey: 'decline',
              nextTurnId: 'turn-ll25-06B',
            ),
            ScenarioBranch(conditionKey: 'verify', nextTurnId: 'turn-ll25-06C'),
          ],
        ),
        // Path A: Qualified Accept
        const SalesTurn(
          id: 'turn-ll25-06A',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'That sounds like a huge relief and a great savings. What do I need to do to make sure the number transfers smoothly?',
          phase: SalesPhase.objectionHandling,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ll25-07A',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll25-07A',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'We will ship the wireless base to your home with free delivery. Please keep your current copper service active until the base arrives and activates, which ensures zero disruption to your calls.',
          phase: SalesPhase.eligibilityBoundary,
          requiredKeywords: [
            'ship',
            'free delivery',
            'keep active',
            'zero disruption',
          ],
          trainerGuidanceArabic: 'نبه العميل بأهمية إبقاء الخدمة الحالية نشطة حتى وصول الجهاز لتجنب فقدان الرقم.',
          usEnglishModelResponse: 'We will mail the equipment to your doorstep. Keep your existing copper service active until you connect the base, ensuring continuous service.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ll25-08A',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll25-08A',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText: 'Wonderful! Thank you so much Alex. Let us go ahead and set that up so my number is safe.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.qualifiedAccept,
        ),
        // Path B: Respectful No-Sale
        const SalesTurn(
          id: 'turn-ll25-06B',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'I am really hesitant about wireless signals. I think I would rather just cancel my home phone entirely and rely on visits from my daughter.',
          phase: SalesPhase.objectionHandling,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ll25-07B',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll25-07B',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'I completely respect your decision, Mr. Jenkins. You do not have to purchase anything today. Take time to discuss it with your daughter, and if you ever need our help, we will be here.',
          phase: SalesPhase.closing,
          requiredKeywords: ['respect', 'decision', 'daughter', 'here'],
          trainerGuidanceArabic:
              'احترم قراره بالتشاور مع ابنته ولا تضغط عليه إطلاقاً.',
          usEnglishModelResponse: 'I completely respect that, Mr. Jenkins. Feel free to talk it over with your daughter first. We will not change a thing on your account today.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ll25-08B',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll25-08B',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText: 'Thank you for your honesty and patience, Alex. That means a great deal to me.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.respectfulNoSale,
        ),
        // Path C: Needs Verification
        const SalesTurn(
          id: 'turn-ll25-06C',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Before we do anything, my home is in a hilly valley where cell phones sometimes struggle. Can you check if the cellular signal reaches my exact address?',
          phase: SalesPhase.eligibilityBoundary,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ll25-07C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll25-07C',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'That is an essential check, Mr. Jenkins. Let me verify our detailed coverage map at your exact physical address before we place any order, ensuring strong indoor signal.',
          phase: SalesPhase.eligibilityBoundary,
          requiredKeywords: [
            'verify',
            'coverage map',
            'physical address',
            'signal',
          ],
          trainerGuidanceArabic: 'تحقق من التغطية بدقة في عنوانه الجغرافي قبل البيع لتفادي مشاكل انقطاع الخدمة.',
          usEnglishModelResponse: 'That is very important. Let me pull up our coverage tool and verify the signal quality at your exact house before we proceed.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ll25-08C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll25-08C',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText: 'Thank you. Let us check the address coverage carefully first before we submit anything.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.needsVerification,
        ),
      ],
    ),

    // Scenario 26: Power Outage Battery Backup
    SalesScenario(
      id: 'sales-26-power-outage-battery-backup',
      title: 'Storm Season Power Outage & Battery Backup Assurance',
      category: 'landline_to_wireless',
      difficulty: 'intermediate',
      profile: const SalesCustomerProfile(
        name: 'Martha Vance',
        tone: 'cautious homeowner',
        currentProvider: 'Traditional Landline',
        householdNeeds:
            'Emergency telephone access during coastal storm blackouts',
        financialConstraint: 'Wants one-time hardware cost disclosed clearly',
        coreBlocker: 'Worried that a wireless base will die when the electric power goes out',
      ),
      contextNotes: 'Lives in a coastal storm region and relies on home phone for 911 when power fails.',
      skillTags: [
        'Emergency Preparedness',
        'Battery Backup Disclosure',
        'Safety Boundaries',
      ],
      prohibitedPromises: [
        'promise the battery will last for weeks without electricity',
        'guarantee wireless cell towers never lose power in major hurricanes',
      ],
      mandatoryDisclosures: [
        'Internal rechargeable battery provides up to three hours of talk time and twenty-four hours on standby',
        'Cordless phone handsets also require their own power or battery to ring during an outage',
      ],
      fictionalCandidateProducts: ['prod-landline-cell-base'],
      turns: [
        const SalesTurn(
          id: 'turn-ll26-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: TrainingConstants.standardGreeting,
          phase: SalesPhase.greeting,
          requiredKeywords: ['att', 'alex', 'first', 'last', 'name'],
          trainerGuidanceArabic: 'ابدأ بالترحيب القياسي الإلزامي.',
          usEnglishModelResponse: TrainingConstants.standardGreeting,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-ll26-02'),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll26-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Hello Alex, this is Martha Vance. We get severe winter storms here, and power goes out frequently. If I switch to a wireless home phone adapter, what happens when the electricity dies? Can I still call 911?',
          phase: SalesPhase.initialResolution,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-ll26-03'),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll26-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'Thank you for asking such an important safety question, Mrs. Vance. The Wireless Home Phone base includes an internal rechargeable backup battery that provides up to twenty-four hours of standby power and three hours of talk time during an outage.',
          phase: SalesPhase.valueBridge,
          requiredKeywords: [
            'safety',
            'backup battery',
            'twenty-four hours',
            'talk time',
          ],
          trainerGuidanceArabic: 'وضح سعة البطارية الاحتياطية (24 ساعة استعداد و3 ساعات مكالمات) بكل دقة وأمانة.',
          usEnglishModelResponse: 'That is a crucial safety question, Mrs. Vance. The wireless base includes a built-in battery backup providing up to 24 hours of standby and 3 hours of continuous talk time when your power fails.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-ll26-04'),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll26-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'And will my regular cordless phone ring if the power is out, or do I need a corded telephone?',
          phase: SalesPhase.discovery,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-ll26-05'),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll26-05',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'For complete safety, we always recommend keeping an inexpensive standard corded phone plugged into the base, because most wireless cordless handsets require wall power for their base station to transmit.',
          phase: SalesPhase.eligibilityBoundary,
          requiredKeywords: [
            'recommend',
            'corded phone',
            'cordless',
            'wall power',
          ],
          trainerGuidanceArabic: 'انصح العميل بالاحتفاظ بهاتف سلكي بسيط لحالات الطوارئ لأن الهواتف اللاسلكية تحتاج كهرباء.',
          usEnglishModelResponse: 'We always advise having a simple corded phone on hand, because cordless phone charging cradles need electrical power to broadcast to their handsets.',
          branches: [
            ScenarioBranch(conditionKey: 'accept', nextTurnId: 'turn-ll26-06A'),
            ScenarioBranch(
              conditionKey: 'decline',
              nextTurnId: 'turn-ll26-06B',
            ),
            ScenarioBranch(conditionKey: 'verify', nextTurnId: 'turn-ll26-06C'),
          ],
        ),
        // Path A: Qualified Accept
        const SalesTurn(
          id: 'turn-ll26-06A',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'I keep an old corded Western Electric phone in the guest bedroom closet. If I plug that in, that solves everything. Let us set up the base and save that monthly money.',
          phase: SalesPhase.objectionHandling,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ll26-07A',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll26-07A',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'That is the ideal setup, Mrs. Vance. The equipment is thirty dollars a month for the line, with no annual contract and free shipping. Let me prepare your order details.',
          phase: SalesPhase.closing,
          requiredKeywords: [
            'thirty dollars',
            'no contract',
            'free shipping',
            'order',
          ],
          trainerGuidanceArabic:
              'أكد تفاصيل الطلب والتكلفة بدون عقود وشحن مجاني.',
          usEnglishModelResponse: 'That is the perfect combination. The plan is thirty dollars monthly with zero contract. I can confirm your mailing address and order the unit right now.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ll26-08A',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll26-08A',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText: 'Terrific! Let us do it. Thank you for making sure my storm safety is covered, Alex.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.qualifiedAccept,
        ),
        // Path B: Respectful No-Sale
        const SalesTurn(
          id: 'turn-ll26-06B',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Twenty-four hours of battery does not feel long enough. Our storm last year knocked power out for five days straight. I would rather pay extra to keep my copper line going as long as the state allows.',
          phase: SalesPhase.objectionHandling,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ll26-07B',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll26-07B',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'I completely respect your peace of mind, Mrs. Vance. In extended multi-day outages, your security comes first. We will leave your copper landline untouched.',
          phase: SalesPhase.closing,
          requiredKeywords: ['respect', 'peace of mind', 'security', 'leave'],
          trainerGuidanceArabic: 'احترم رغبة العميل تماماً؛ أمانها النفسي أثناء العواصف أولى من البيع.',
          usEnglishModelResponse: 'I completely respect that, Mrs. Vance. Your peace of mind during extended storms is paramount. We will make zero changes to your existing copper service.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ll26-08B',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll26-08B',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText: 'Thank you for being so honest with me about the battery limits, Alex. That makes me trust you completely.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.respectfulNoSale,
        ),
        // Path C: Needs Verification
        const SalesTurn(
          id: 'turn-ll26-06C',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Can an external uninterruptible power supply or generator be connected to this base to extend the battery run time during prolonged outages?',
          phase: SalesPhase.eligibilityBoundary,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ll26-07C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll26-07C',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'Yes, it uses a standard AC power adapter that can connect to a UPS or generator. Let me verify the exact wattage specifications in our technical guide so you can match your equipment safely.',
          phase: SalesPhase.eligibilityBoundary,
          requiredKeywords: ['standard ac', 'ups', 'generator', 'wattage'],
          trainerGuidanceArabic: 'تحقق من مواصفات الوات والجهد الكهربائي لضمان توافق مولد الكهرباء أو الـ UPS بأمان.',
          usEnglishModelResponse: 'Yes, it connects via standard wall plug. Let me verify the exact power draw and adapter specs in our technical manual to make sure it matches your backup generator safely.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ll26-08C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll26-08C',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText: 'Thank you. Please look up those electrical specifications so I can verify with my electrician before we order.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.needsVerification,
        ),
      ],
    ),

    // Scenario 27: Standalone Rural Flip Phone
    SalesScenario(
      id: 'sales-27-standalone-rural-flip-phone',
      title: 'Rural Cabin Standalone Voice & Tactile Flip Phone',
      category: 'landline_to_wireless',
      difficulty: 'entry',
      profile: const SalesCustomerProfile(
        name: 'Dale Cooper',
        tone: 'independent rural cabin resident',
        currentProvider: 'Rural Independent Telco Landline (\$65/mo)',
        householdNeeds: 'Durable voice phone with physical buttons and loud speaker for cabin woodshop',
        financialConstraint:
            'Wants flat predictable billing, zero data plan charges',
        coreBlocker:
            'Refuses smartphones, touchscreens, and internet data plans',
      ),
      contextNotes: 'Lives off the beaten path; spends days in his workshop and wants a simple phone that can take drops.',
      skillTags: [
        'Tactile Hardware',
        'Voice-Only Discipline',
        'Simplicity Match',
      ],
      prohibitedPromises: [
        'promise satellite-level reception in deep caves or unmapped valleys',
        'force customer into an unlimited smartphone data package',
      ],
      mandatoryDisclosures: [
        'Basic phone voice plans include nationwide calling with no required data package',
        'Physical keypad device requires one-time equipment cost or monthly installment',
      ],
      fictionalCandidateProducts: ['prod-wireless-starter'],
      turns: [
        const SalesTurn(
          id: 'turn-ll27-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: TrainingConstants.standardGreeting,
          phase: SalesPhase.greeting,
          requiredKeywords: ['att', 'alex', 'first', 'last', 'name'],
          trainerGuidanceArabic: 'ابدأ بالترحيب الرسمي المعتمد.',
          usEnglishModelResponse: TrainingConstants.standardGreeting,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-ll27-02'),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll27-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Morning Alex. Name is Dale Cooper. Look, I live out by the state forest and my landline bill from the local company jumped to sixty-five bucks. I do not want any apps or glass touchscreens. Do you still sell simple flip phones with real buttons?',
          phase: SalesPhase.initialResolution,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-ll27-03'),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll27-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'Good morning Mr. Cooper! Absolutely, we have rugged flip phones with large physical tactile buttons, loud external speakers, and long battery life, with no data plan required.',
          phase: SalesPhase.explorationPermission,
          requiredKeywords: [
            'absolutely',
            'flip phones',
            'tactile buttons',
            'no data',
          ],
          trainerGuidanceArabic: 'احترم طلبه لهاتف بسيط بأزرار حقيقية وأكد عدم فرض باقة إنترنت غير مرغوبة.',
          usEnglishModelResponse: 'Good morning Mr. Cooper. Yes, we certainly do. We offer rugged flip phones with physical buttons, loud sound, and voice-only service without any required data bundle.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-ll27-04'),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll27-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'That is music to my ears. Can I take it out to my workshop, and does it come with a flat predictable rate each month?',
          phase: SalesPhase.discovery,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-ll27-05'),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll27-05',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Yes sir. The phone is built to withstand drops and sawdust in your shop. The standalone unlimited talk and text plan is thirty dollars a month, cutting your current landline expense by more than half.',
          phase: SalesPhase.valueBridge,
          requiredKeywords: ['withstand', 'shop', 'thirty dollars', 'half'],
          trainerGuidanceArabic: 'اشرح ملاءمة الهاتف للورشة والسعر الاقتصادي (30 دولار مكالمات ورسائل).',
          usEnglishModelResponse: 'It has a durable outer casing for workshop use, and the standalone voice and text plan is thirty dollars monthly, saving you over thirty-five dollars every single month.',
          branches: [
            ScenarioBranch(conditionKey: 'accept', nextTurnId: 'turn-ll27-06A'),
            ScenarioBranch(
              conditionKey: 'decline',
              nextTurnId: 'turn-ll27-06B',
            ),
            ScenarioBranch(conditionKey: 'verify', nextTurnId: 'turn-ll27-06C'),
          ],
        ),
        // Path A: Qualified Accept
        const SalesTurn(
          id: 'turn-ll27-06A',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Real buttons, half the price, and tough enough for the shop. Sign me up, Alex. That is exactly what I called for.',
          phase: SalesPhase.objectionHandling,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ll27-07A',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll27-07A',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'I will get that rugged flip phone packaged and sent right to your rural delivery route with simple activation instructions right in the box.',
          phase: SalesPhase.closing,
          requiredKeywords: [
            'packaged',
            'delivery route',
            'activation instructions',
            'box',
          ],
          trainerGuidanceArabic:
              'أكد تفاصيل الشحن وكتيب التعليمات البسيط داخل الصندوق.',
          usEnglishModelResponse: 'I will have the device shipped directly to your mailing address with easy setup instructions included inside the package.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ll27-08A',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll27-08A',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText: 'Appreciate the straightforward service, Alex. Looking forward to getting it.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.qualifiedAccept,
        ),
        // Path B: Respectful No-Sale
        const SalesTurn(
          id: 'turn-ll27-06B',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Actually, I just remembered my local phone company gives me a combined water-and-phone paper coupon. I think I will stick with them for now.',
          phase: SalesPhase.objectionHandling,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ll27-07B',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll27-07B',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'I understand completely, Mr. Cooper. Local utility bundles can be very convenient. You know where to find us if your needs ever change.',
          phase: SalesPhase.closing,
          requiredKeywords: [
            'understand',
            'local utility',
            'convenient',
            'find us',
          ],
          trainerGuidanceArabic:
              'احترم خياره المحلي وتمنّ له التوفيق دون أي ضغط.',
          usEnglishModelResponse: 'I completely respect that, Mr. Cooper. Local utility discounts can be a great perk. We are always here whenever you want to revisit it.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ll27-08B',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll27-08B',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText:
              'Thanks for your time and respect, Alex. Have a good one.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.respectfulNoSale,
        ),
        // Path C: Needs Verification
        const SalesTurn(
          id: 'turn-ll27-06C',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Before ordering, my cabin sits right behind a granite ridge. I need to know if the nearest cellular tower has clear line-of-sight to mile marker 14.',
          phase: SalesPhase.eligibilityBoundary,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ll27-07C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll27-07C',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'Let me verify our topographical tower mapping for mile marker 14 to verify signal propagation through that ridge before we process the order.',
          phase: SalesPhase.eligibilityBoundary,
          requiredKeywords: [
            'verify',
            'tower mapping',
            'signal propagation',
            'order',
          ],
          trainerGuidanceArabic:
              'تحقق من خريطة التغطية الطبوغرافية خلف التلال قبل اعتماد الطلب.',
          usEnglishModelResponse: 'That is a very smart check. Let me examine the elevation and tower coverage for that specific mile marker to ensure reliable signal reach.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ll27-08C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll27-08C',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText: 'Good man. Let us verify that tower elevation first so I do not end up with a paperweight.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.needsVerification,
        ),
      ],
    ),

    // Scenario 28: Fixed-Income Standalone Line
    SalesScenario(
      id: 'sales-28-fixed-income-standalone-line',
      title: 'Senior Citizen Budget Relief: Cutting \$80 Landline to \$30',
      category: 'landline_to_wireless',
      difficulty: 'entry',
      profile: const SalesCustomerProfile(
        name: 'Eleanor Higgins',
        tone: 'gentle, budget-anxious grandmother',
        currentProvider: 'Legacy Copper Telco (\$82.50/mo)',
        householdNeeds:
            'Reliable voice phone to talk to grandchildren on weekends',
        financialConstraint:
            'Living strictly on Social Security; every \$10 matters',
        coreBlocker: 'Fears hidden fees, bill spikes, or losing her dial tone',
      ),
      contextNotes: 'Paying over \$80 a month for basic dial tone because legacy copper maintenance rates kept rising.',
      skillTags: [
        'Senior Budgeting',
        'Empathetic Pricing',
        'Transparent Billing',
      ],
      prohibitedPromises: [
        'promise taxes are zero in all jurisdictions',
        'guarantee free hardware without clearly detailing equipment terms',
      ],
      mandatoryDisclosures: [
        'Thirty dollar monthly service fee plus applicable state and local government taxes and E911 fees',
        'No long-distance charges within the United States',
      ],
      fictionalCandidateProducts: ['prod-landline-cell-base'],
      turns: [
        const SalesTurn(
          id: 'turn-ll28-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: TrainingConstants.standardGreeting,
          phase: SalesPhase.greeting,
          requiredKeywords: ['att', 'alex', 'first', 'last', 'name'],
          trainerGuidanceArabic: 'ابدأ بالترحيب القياسي الإلزامي.',
          usEnglishModelResponse: TrainingConstants.standardGreeting,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-ll28-02'),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll28-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Hello Alex dear. My name is Eleanor Higgins. My monthly phone bill just came in at eighty-two dollars and fifty cents. I am eighty-three years old on a fixed pension, and I simply cannot keep paying this much just to talk to my grandkids.',
          phase: SalesPhase.initialResolution,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-ll28-03'),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll28-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'I hear you completely, Mrs. Higgins, and nobody should have to pay eighty-two dollars just to stay connected with family. We have a Wireless Home Phone option for thirty dollars a month that lets you keep your same number and existing handsets while putting fifty dollars back in your pocket.',
          phase: SalesPhase.explorationPermission,
          requiredKeywords: [
            'hear you',
            'family',
            'thirty dollars',
            'fifty dollars back',
          ],
          trainerGuidanceArabic: 'تعاطف مع ظروف ميزانيتها (AERD) واشرح توفير 50 دولار شهرياً لنفس الخدمة.',
          usEnglishModelResponse: 'I hear you completely, Mrs. Higgins. Paying over eighty dollars for basic telephone service is far too much. We can transition you to our Wireless Home Phone service for thirty dollars a month, keeping your exact phone and number while saving you over fifty dollars every month.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-ll28-04'),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll28-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Will long-distance calls to my grandchildren in Texas cost extra? My old plan charges per minute if they are out of state.',
          phase: SalesPhase.discovery,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-ll28-05'),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll28-05',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Not a single penny extra, Mrs. Higgins! Unlimited nationwide calling across all fifty states is fully included, so you can talk to Texas as long as you want.',
          phase: SalesPhase.valueBridge,
          requiredKeywords: [
            'not a penny',
            'unlimited nationwide',
            'fifty states',
            'included',
          ],
          trainerGuidanceArabic: 'طَمئِنها أن المكالمات لجميع الولايات مشمولة ومجانية بالكامل دون احتساب دقائق.',
          usEnglishModelResponse: 'Zero extra per-minute fees, Mrs. Higgins. Unlimited calling across the entire United States is included, so you can speak to your grandkids in Texas as often and as long as you like.',
          branches: [
            ScenarioBranch(conditionKey: 'accept', nextTurnId: 'turn-ll28-06A'),
            ScenarioBranch(
              conditionKey: 'decline',
              nextTurnId: 'turn-ll28-06B',
            ),
            ScenarioBranch(conditionKey: 'verify', nextTurnId: 'turn-ll28-06C'),
          ],
        ),
        // Path A: Qualified Accept
        const SalesTurn(
          id: 'turn-ll28-06A',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Saving fifty dollars a month will buy my groceries for a week! That is a true blessing, Alex. Please help me get this set up.',
          phase: SalesPhase.objectionHandling,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ll28-07A',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll28-07A',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'It is my absolute pleasure, Mrs. Higgins. I will set up the shipment with clear, large-print instructions, and remember to keep your current line plugged in until the new box arrives.',
          phase: SalesPhase.closing,
          requiredKeywords: [
            'pleasure',
            'large-print',
            'instructions',
            'keep plugged in',
          ],
          trainerGuidanceArabic: 'أكد إرسال تعليمات بخط كبير وواضح مع إبقاء الخط القديم متصلاً لحين وصول الجهاز.',
          usEnglishModelResponse: 'It is truly my pleasure. I will include easy-to-read instructions, and we will keep your existing telephone running smoothly until your new adapter arrives.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ll28-08A',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll28-08A',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText: 'Thank you ever so much, Alex. You have lifted a huge weight off my shoulders today.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.qualifiedAccept,
        ),
        // Path B: Respectful No-Sale
        const SalesTurn(
          id: 'turn-ll28-06B',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'I am so afraid of change at my age. Even thirty dollars is money, and I worry I will get confused plugging new boxes into the wall.',
          phase: SalesPhase.objectionHandling,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ll28-07B',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll28-07B',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'I understand completely, Mrs. Higgins. There is no rush at all, and your comfort comes first. We will not change anything today.',
          phase: SalesPhase.closing,
          requiredKeywords: ['understand', 'no rush', 'comfort', 'not change'],
          trainerGuidanceArabic:
              'احترم خوفها من التغيير واطمئنها أن لا شيء سيتغير اليوم.',
          usEnglishModelResponse: 'I completely understand, Mrs. Higgins. We will leave everything exactly as it is today. You should never feel pressured into changing equipment if it causes you stress.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ll28-08B',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll28-08B',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText: 'Bless your heart, Alex. Thank you for being so understanding and kind.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.respectfulNoSale,
        ),
        // Path C: Needs Verification
        const SalesTurn(
          id: 'turn-ll28-06C',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'I receive state lifeline assistance on my current telephone. Will that lifeline credit transfer over to this wireless service?',
          phase: SalesPhase.eligibilityBoundary,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ll28-07C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll28-07C',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'That is a very important financial benefit, Mrs. Higgins. Let me verify your Lifeline program eligibility guidelines in your specific state before we proceed, ensuring you do not lose any assistance.',
          phase: SalesPhase.eligibilityBoundary,
          requiredKeywords: ['lifeline', 'eligibility', 'state', 'verify'],
          trainerGuidanceArabic: 'تحقق من برنامج الدعم الحكومي (Lifeline) في ولايتها قبل اتخاذ أي خطوة لضمان عدم فقدان الدعم.',
          usEnglishModelResponse: 'Lifeline assistance is vital. Let me check the state Lifeline registry and transfer rules for your account to ensure your benefit transitions properly before making any changes.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ll28-08C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll28-08C',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText: 'Yes, please verify that lifeline credit first dear. I cannot afford to lose that discount.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.needsVerification,
        ),
      ],
    ),

    // Scenario 29: Security Alarm Pulse Warning (CRITICAL ETHICAL BOUNDARY)
    SalesScenario(
      id: 'sales-29-security-alarm-pulse-warning',
      title: 'Home Security Alarm System & Pulse Dialing Boundary',
      category: 'landline_to_wireless',
      difficulty: 'advanced',
      profile: const SalesCustomerProfile(
        name: 'Richard Sterling',
        tone: 'security-conscious homeowner',
        currentProvider: 'Traditional Copper Landline',
        householdNeeds: 'Inquires about cutting copper line cost while keeping wired security alarm monitoring',
        financialConstraint: 'Wants to reduce \$75 landline bill',
        coreBlocker: 'Monitored central security alarm panel installed in 2002 connected to RJ11 phone jack',
      ),
      contextNotes: 'CRITICAL ETHICAL TEST: Many legacy security systems use analog tone/pulse modem signals incompatible with cellular voice compression. Agent MUST NOT sell wireless base without alarm company verification.',
      skillTags: [
        'Alarm Safety Boundary',
        'Ethical Guardrail',
        'Compatibility Warning',
      ],
      prohibitedPromises: [
        'promise cellular base works with all legacy monitored security alarm panels',
        'advise customer to disconnect copper without consulting security alarm vendor',
        'guarantee central station will receive burglary signals over cellular voice',
      ],
      mandatoryDisclosures: [
        'Wireless Home Phone is not compatible with monitored home security alarm systems, fax machines, or dial-up modems',
        'Customer must contact their alarm monitoring provider to install a dedicated cellular communicator',
      ],
      fictionalCandidateProducts: ['prod-landline-cell-base'],
      turns: [
        const SalesTurn(
          id: 'turn-ll29-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: TrainingConstants.standardGreeting,
          phase: SalesPhase.greeting,
          requiredKeywords: ['att', 'alex', 'first', 'last', 'name'],
          trainerGuidanceArabic: 'ابدأ بالترحيب الرسمي المعتمد.',
          usEnglishModelResponse: TrainingConstants.standardGreeting,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-ll29-02'),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll29-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Hi Alex, Richard Sterling here. I pay seventy-five dollars a month for a landline that nobody talks on except my central security alarm system, which dials the monitoring station if someone breaks a window. Can I switch to your thirty-dollar wireless base to save fifty dollars?',
          phase: SalesPhase.initialResolution,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-ll29-03'),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll29-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'Thank you for asking that specific question upfront, Mr. Sterling. I must be completely transparent with you: our Wireless Home Phone base is designed strictly for voice calls and is not compatible with monitored home security alarm panels or modem transmissions.',
          phase: SalesPhase.eligibilityBoundary,
          requiredKeywords: [
            'transparent',
            'voice calls',
            'not compatible',
            'security alarm',
          ],
          trainerGuidanceArabic: 'تحذير أخلاقي إلزامي: وضح صراحة أن جهاز الهاتف اللاسلكي غير متوافق مع أجهزة الإنذار المربوطة بمراكز المراقبة.',
          usEnglishModelResponse: 'I appreciate you raising that immediately, Mr. Sterling. For your safety, I must be 100% upfront: the Wireless Home Phone base is built exclusively for voice conversations and does not reliably transmit analog alarm modem data to central stations.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-ll29-04'),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll29-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Really? Why is that? It just uses a regular telephone jack on the alarm panel.',
          phase: SalesPhase.discovery,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-ll29-05'),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll29-05',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Central alarm panels use analog frequency tones and handshake data protocols that can get distorted by digital cellular voice compression, which could prevent emergency burglary signals from reaching dispatch. Your alarm company can upgrade your panel with a dedicated cellular communicator.',
          phase: SalesPhase.valueBridge,
          requiredKeywords: [
            'analog',
            'compression',
            'alarm company',
            'cellular communicator',
          ],
          trainerGuidanceArabic: 'اشرح السبب التقني (ضغط الصوت الرقمي يشوش نغمات المودم) وانصحه بطلب جهاز اتصال خلوي مخصص من شركة الإنذار.',
          usEnglishModelResponse: 'Analog alarm panels send modem data bursts that cellular voice codecs can clip or distort, potentially blocking a burglary or fire signal. The safest route is having your alarm company install their own certified cellular radio directly inside the alarm panel.',
          branches: [
            ScenarioBranch(conditionKey: 'accept', nextTurnId: 'turn-ll29-06A'),
            ScenarioBranch(
              conditionKey: 'decline',
              nextTurnId: 'turn-ll29-06B',
            ),
            ScenarioBranch(conditionKey: 'verify', nextTurnId: 'turn-ll29-06C'),
          ],
        ),
        // Path A: Qualified Accept (Customer sets up voice only, separating alarm)
        const SalesTurn(
          id: 'turn-ll29-06A',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'My alarm company actually told me last month they can put a cellular radio in the panel for five dollars a month! If I do that with them, I can use your base for our kitchen phone and still save thirty-five dollars.',
          phase: SalesPhase.objectionHandling,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ll29-07A',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll29-07A',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'That is the safest and most effective solution, Mr. Sterling. Once your alarm company confirms their cellular unit is active, you can safely connect your voice phones to our wireless base.',
          phase: SalesPhase.closing,
          requiredKeywords: ['safest', 'effective', 'alarm company', 'active'],
          trainerGuidanceArabic: 'أكد الترتيب الصحيح: تفعيل وحدة الإنذار أولاً عبر شركة الحراسة ثم تشغيل هاتف المنزل.',
          usEnglishModelResponse: 'That is the ideal setup. Once the alarm company certifies their cellular communicator, you can activate our thirty-dollar voice base with complete peace of mind.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ll29-08A',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll29-08A',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText: 'Excellent advice, Alex. Thank you for putting my home safety ahead of a quick sale.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.qualifiedAccept,
        ),
        // Path B: Respectful No-Sale (Safety priority)
        const SalesTurn(
          id: 'turn-ll29-06B',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'My alarm panel is too old to upgrade, and replacing it costs twelve hundred dollars. I cannot risk my home security, so I must keep the copper landline.',
          phase: SalesPhase.objectionHandling,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ll29-07B',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll29-07B',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'You are making the 100% correct choice, Mr. Sterling. Your home security and life safety are far more important than saving a few dollars. We will leave your copper landline untouched.',
          phase: SalesPhase.closing,
          requiredKeywords: [
            'correct choice',
            'home security',
            'life safety',
            'untouched',
          ],
          trainerGuidanceArabic: 'اشهد له بصحة اختياره وأكد أن سلامة المنزل تأتي في المقام الأول قبل أي توفير مالي.',
          usEnglishModelResponse: 'You are making the absolute right call, Mr. Sterling. Your home security is paramount. We will make zero changes and leave your dedicated copper connection active.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ll29-08B',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll29-08B',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText: 'I am so grateful for your honesty, Alex. Many sales reps would have sold me the box and let my alarm fail silently. You are a true professional.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.respectfulNoSale,
        ),
        // Path C: Needs Verification
        const SalesTurn(
          id: 'turn-ll29-06C',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Let me get my security company technician on the phone right now or schedule a conference call to verify what model panel I have.',
          phase: SalesPhase.eligibilityBoundary,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ll29-07C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll29-07C',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'That is the most responsible step, Mr. Sterling. Please have your alarm vendor verify the panel specifications and confirm whether it requires a dedicated cellular transmitter before making any landline changes.',
          phase: SalesPhase.eligibilityBoundary,
          requiredKeywords: [
            'responsible',
            'alarm vendor',
            'specifications',
            'verify',
          ],
          trainerGuidanceArabic: 'شجعه على مراجعة فني شركة الإنذار للتحقق من الموديل قبل أي تعديل.',
          usEnglishModelResponse: 'That is the best path forward. Check with your alarm provider regarding their communicator requirements first, and we can revisit once they verify your system.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ll29-08C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll29-08C',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText: 'I will call them right now to verify the board model. Thank you, Alex.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.needsVerification,
        ),
      ],
    ),

    // Scenario 30: Rotary-to-Touchtone Modernization
    SalesScenario(
      id: 'sales-30-rotary-to-touchtone-modernization',
      title: 'Rotary Dial Modernization & Pulse-to-Tone Compatibility',
      category: 'landline_to_wireless',
      difficulty: 'intermediate',
      profile: const SalesCustomerProfile(
        name: 'Arthur Pendelton',
        tone: 'vintage enthusiast homeowner',
        currentProvider: 'Traditional Landline',
        householdNeeds: 'Transitioning home phone while wondering if antique rotary phones will dial out',
        financialConstraint:
            'Wants to know if adapter or new telephone hardware is required',
        coreBlocker:
            'Loves the mechanical bell and rotary dial of his 1950s phone',
      ),
      contextNotes: 'Has an antique 500-series rotary phone. Wireless base requires DTMF tone dialing for outgoing calls unless an external pulse-to-tone converter is used.',
      skillTags: [
        'Technical Accuracy',
        'Hardware Compatibility',
        'Expectation Setting',
      ],
      prohibitedPromises: [
        'promise antique pulse rotary phones work out-of-the-box without tone converter',
      ],
      mandatoryDisclosures: [
        'Wireless Home Phone base requires DTMF touch-tone signaling for outgoing dialing',
        'Rotary pulse dialing phones require a third-party pulse-to-tone converter or touchtone handset',
      ],
      fictionalCandidateProducts: ['prod-landline-cell-base'],
      turns: [
        const SalesTurn(
          id: 'turn-ll30-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: TrainingConstants.standardGreeting,
          phase: SalesPhase.greeting,
          requiredKeywords: ['att', 'alex', 'first', 'last', 'name'],
          trainerGuidanceArabic: 'ابدأ بالترحيب القياسي الإلزامي.',
          usEnglishModelResponse: TrainingConstants.standardGreeting,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-ll30-02'),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll30-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Good afternoon Alex. Arthur Pendelton speaking. I want to save money on my monthly phone bill, but I have a classic 1950s heavy rotary phone in my study that I love. If I plug it into your wireless base, will it work when I spin the wheel to dial?',
          phase: SalesPhase.initialResolution,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-ll30-03'),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll30-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'What a classic piece of history, Mr. Pendelton! The mechanical bell will ring loudly for incoming calls, but for dialing out, modern wireless bases require touch-tone signals. To dial out with your rotary wheel, you would need an inexpensive pulse-to-tone converter plugged between the phone and base.',
          phase: SalesPhase.explorationPermission,
          requiredKeywords: [
            'ring',
            'touch-tone',
            'pulse-to-tone converter',
            'dial out',
          ],
          trainerGuidanceArabic: 'اشرح بمصداقية: الجرس سيرن في المكالمات الواردة، لكن الاتصال للخارج بالقرص الدوار يحتاج محول نبضات إلى نغمات (pulse-to-tone).',
          usEnglishModelResponse: 'That is a fantastic vintage telephone, Mr. Pendelton! It will ring beautifully on incoming calls. However, for dialing outgoing calls, modern wireless adapters require DTMF tones, so you would need a small pulse-to-tone converter box or a push-button phone.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-ll30-04'),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll30-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'And where do people get those converters? Or could I just keep a modern push-button phone next to it for outgoing calls?',
          phase: SalesPhase.discovery,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-ll30-05'),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll30-05',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Keeping a standard push-button phone on the two-jack splitter is the simplest method! You can answer on your classic rotary whenever it rings, and use the push-button phone to dial out, all for thirty dollars a month.',
          phase: SalesPhase.valueBridge,
          requiredKeywords: [
            'push-button',
            'splitter',
            'answer',
            'thirty dollars',
          ],
          trainerGuidanceArabic: 'اقترح حلاً عملياً: توصيل هاتف بأزرار للاتصال واستخدام الهاتف الكلاسيكي للرد، وكل هذا بـ 30 دولار شهرياً.',
          usEnglishModelResponse: 'Using a standard two-way phone splitter allows both! You can dial out on a simple push-button phone and pick up your antique rotary to talk whenever it rings, cutting your bill in half.',
          branches: [
            ScenarioBranch(conditionKey: 'accept', nextTurnId: 'turn-ll30-06A'),
            ScenarioBranch(
              conditionKey: 'decline',
              nextTurnId: 'turn-ll30-06B',
            ),
            ScenarioBranch(conditionKey: 'verify', nextTurnId: 'turn-ll30-06C'),
          ],
        ),
        // Path A: Qualified Accept
        const SalesTurn(
          id: 'turn-ll30-06A',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'That is brilliant! I already have a push-button phone in the kitchen. Let us set up the thirty-dollar service.',
          phase: SalesPhase.objectionHandling,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ll30-07A',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll30-07A',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'Fantastic! I will order your Wireless Home Phone base with free shipping, keeping your existing telephone number intact.',
          phase: SalesPhase.closing,
          requiredKeywords: ['order', 'free shipping', 'number intact'],
          trainerGuidanceArabic:
              'أكد الطلب مع الشحن المجاني والاحتفاظ برقم الهاتف دون تغيير.',
          usEnglishModelResponse: 'Excellent, Mr. Pendelton. I will submit the order for your base with free delivery and seamless number transfer.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ll30-08A',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll30-08A',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText: 'Splendid service, Alex. Thank you for solving the technical details for me.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.qualifiedAccept,
        ),
        // Path B: Respectful No-Sale
        const SalesTurn(
          id: 'turn-ll30-06B',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'No, spinning the rotary wheel to call my friends is half the pleasure of having the phone. If I have to use push-buttons, I will just keep my copper line.',
          phase: SalesPhase.objectionHandling,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ll30-07B',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll30-07B',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'I completely appreciate that nostalgic joy, Mr. Pendelton. We will keep your copper line completely untouched so you can continue spinning that dial.',
          phase: SalesPhase.closing,
          requiredKeywords: ['nostalgic', 'copper line', 'untouched', 'dial'],
          trainerGuidanceArabic: 'احترم رغبته في التمسك بالهاتف القديم وطريقة اتصاله دون أي محاولة للضغط عليه.',
          usEnglishModelResponse: 'I completely respect that vintage joy, Mr. Pendelton. We will leave your copper connection unchanged so you can keep dialing just the way you like.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ll30-08B',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll30-08B',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText:
              'Thank you for understanding, Alex. Have a wonderful afternoon.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.respectfulNoSale,
        ),
        // Path C: Needs Verification
        const SalesTurn(
          id: 'turn-ll30-06C',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Let me search online for that pulse-to-tone converter module first to check its exact price and wiring before I decide.',
          phase: SalesPhase.eligibilityBoundary,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ll30-07C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll30-07C',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'That is a great idea. Search for "DialMagic" or similar pulse-to-tone converters, and once you have reviewed the hardware, call us right back to complete the setup.',
          phase: SalesPhase.eligibilityBoundary,
          requiredKeywords: [
            'great idea',
            'pulse-to-tone',
            'reviewed',
            'call us',
          ],
          trainerGuidanceArabic: 'اقترح عليه البحث عن أجهزة التحويل المتوفرة ومراجعتها قبل إتمام الطلب.',
          usEnglishModelResponse: 'That is a very wise approach. Review those converter units at your convenience, and we will be ready to set up your line whenever you are ready.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ll30-08C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll30-08C',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText: 'I will do that research tonight. Thank you for the helpful pointer, Alex.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.needsVerification,
        ),
      ],
    ),

    // Scenario 31: Medical Alert Device Check (CRITICAL LIFE-SAFETY BOUNDARY)
    SalesScenario(
      id: 'sales-31-medical-alert-device-check',
      title: 'Medical Alert Pendant System Life-Safety Boundary',
      category: 'landline_to_wireless',
      difficulty: 'advanced',
      profile: const SalesCustomerProfile(
        name: 'Clara Oswald',
        tone: 'concerned caregiver daughter',
        currentProvider: 'Traditional Landline',
        householdNeeds:
            'Looking to save money on her 86-year-old mother’s landline',
        financialConstraint: 'Wants to lower monthly bills',
        coreBlocker: 'Mother wears a fall-detection pendant linked to a base unit plugged into the phone jack',
      ),
      contextNotes: 'CRITICAL LIFE SAFETY: The fall pendant base dials out over analog phone lines. Wireless base may not be certified by the medical alert company. AGENT MUST HALT AND REQUIRE MEDICAL VENDOR CERTIFICATION.',
      skillTags: [
        'Life Safety Boundary',
        'Medical Alert Guardrail',
        'Ethical Verification',
      ],
      prohibitedPromises: [
        'promise medical alert pendants work guaranteed over wireless cellular bases',
        'urge customer to disconnect landline without medical provider written approval',
      ],
      mandatoryDisclosures: [
        'Medical alert monitoring equipment requires explicit certification from the medical alert provider before switching away from copper',
        'AT&T Wireless Home Phone does not warrant operation with medical monitoring equipment',
      ],
      fictionalCandidateProducts: ['prod-landline-cell-base'],
      turns: [
        const SalesTurn(
          id: 'turn-ll31-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: TrainingConstants.standardGreeting,
          phase: SalesPhase.greeting,
          requiredKeywords: ['att', 'alex', 'first', 'last', 'name'],
          trainerGuidanceArabic: 'ابدأ بالترحيب القياسي الإلزامي.',
          usEnglishModelResponse: TrainingConstants.standardGreeting,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-ll31-02'),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll31-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Hi Alex, my name is Clara Oswald. I manage my elderly mother’s affairs. Her phone bill is seventy dollars, and I saw an ad for your thirty-dollar wireless home phone base. She wears a life-alert fall pendant that connects through her phone line. Can I switch her line to this base today?',
          phase: SalesPhase.initialResolution,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-ll31-03'),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll31-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'Thank you so much for bringing that to my attention immediately, Ms. Oswald. Because your mother’s life and safety depend on that fall alert system, I cannot recommend switching to a wireless base until you speak with her medical alert company.',
          phase: SalesPhase.eligibilityBoundary,
          requiredKeywords: [
            'safety',
            'depend',
            'cannot recommend',
            'medical alert company',
          ],
          trainerGuidanceArabic: 'خط أحمر أخلاقي لسلامة الأرواح: لا تَبِع الخدمة إطلاقاً قبل التأكد من موافقة شركة جهاز الإنذار الطبي.',
          usEnglishModelResponse: 'I am so glad you mentioned that right away, Ms. Oswald. Because that pendant is a vital life-safety device, we strictly require that you verify compatibility with her medical alert provider before making any changes.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-ll31-04'),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll31-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText:
              'Why is that? Does the medical alert company have to approve it?',
          phase: SalesPhase.discovery,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-ll31-05'),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll31-05',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Yes, many medical alert base stations use specialized digital handshake tones that may not transmit reliably over wireless cellular voice compression. If she fell and pressed the button, an uncertified signal might fail to reach dispatch. Her provider may offer their own dedicated cellular pendant.',
          phase: SalesPhase.valueBridge,
          requiredKeywords: [
            'handshake tones',
            'compression',
            'fail to reach',
            'cellular pendant',
          ],
          trainerGuidanceArabic: 'اشرح المخاطر: نغمات الاتصال الرقمية قد تفشل مع ضغط الصوت الخلوي، وانصح بطلب قلادة خلوية مستقلة من شركة الجهاز.',
          usEnglishModelResponse: 'Yes, medical alert units transmit emergency data sequences that cellular compression can interrupt. If she had an emergency, the call must go through without fail. Most medical monitoring companies now supply direct cellular pendants that do not require any home phone line at all.',
          branches: [
            ScenarioBranch(conditionKey: 'accept', nextTurnId: 'turn-ll31-06A'),
            ScenarioBranch(
              conditionKey: 'decline',
              nextTurnId: 'turn-ll31-06B',
            ),
            ScenarioBranch(conditionKey: 'verify', nextTurnId: 'turn-ll31-06C'),
          ],
        ),
        // Path A: Qualified Accept (Medical provider already upgraded to cellular pendant)
        const SalesTurn(
          id: 'turn-ll31-06A',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Now that I think about it, we just upgraded her to their new mobile GPS pendant last week that works anywhere. Her old wall box is completely unplugged! So her home phone is just for chatting.',
          phase: SalesPhase.objectionHandling,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ll31-07A',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll31-07A',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'In that case, Ms. Oswald, since her safety monitoring is entirely mobile and independent of the wall jack, the Wireless Home Phone is a wonderful fit for her everyday calls at thirty dollars a month.',
          phase: SalesPhase.closing,
          requiredKeywords: [
            'independent',
            'wonderful fit',
            'everyday calls',
            'thirty dollars',
          ],
          trainerGuidanceArabic: 'طالما أن جهاز الإنذار الطبي أصبح مستقلاً ومنفصلاً عن المقبس، يمكن البيع بأمان تام.',
          usEnglishModelResponse: 'That is wonderful news. Since her emergency pendant is fully independent, our thirty-dollar wireless base will handle all her family conversations safely and save forty dollars a month.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ll31-08A',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll31-08A',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText: 'That is perfect. Let us set up the base for her home phone so we can save that money. Thank you, Alex!',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.qualifiedAccept,
        ),
        // Path B: Respectful No-Sale
        const SalesTurn(
          id: 'turn-ll31-06B',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Her pendant definitely plugs into the phone wall jack, and she is very fragile. I will not touch her phone line under any circumstances. Her safety is worth any bill.',
          phase: SalesPhase.objectionHandling,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ll31-07B',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll31-07B',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'You are 100% right, Ms. Oswald. Her health and life safety are infinitely more important than any discount. We will make zero changes to her account.',
          phase: SalesPhase.closing,
          requiredKeywords: [
            '100% right',
            'health',
            'life safety',
            'zero changes',
          ],
          trainerGuidanceArabic: 'أكد لها أن سلامة والدتها أهم من أي توفير مالي، ولا تقم بأي تعديل.',
          usEnglishModelResponse: 'You are making the absolute right decision as a daughter. Her health and safety come first. We will keep her copper line completely untouched.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ll31-08B',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll31-08B',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText: 'Thank you so much for your honesty and caring, Alex. I really appreciate it.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.respectfulNoSale,
        ),
        // Path C: Needs Verification (Must call medical provider)
        const SalesTurn(
          id: 'turn-ll31-06C',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'I need to call her medical alert company first and ask their lead technician if her specific model can work over cellular adapters.',
          phase: SalesPhase.eligibilityBoundary,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ll31-07C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll31-07C',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'That is precisely what I recommend, Ms. Oswald. Please have them verify compatibility in writing. We will keep this quote on file so you can reach back out once you have their confirmation.',
          phase: SalesPhase.eligibilityBoundary,
          requiredKeywords: [
            'precisely',
            'in writing',
            'on file',
            'confirmation',
          ],
          trainerGuidanceArabic: 'اطلب منها الحصول على تأكيد خطي من شركة الإنذار الطبي قبل اتخاذ أي قرار.',
          usEnglishModelResponse: 'That is the safest course of action. Verify with her alert provider first, and once they give you their official guidance, we will be here to assist you.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ll31-08C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll31-08C',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText: 'I will call her medical provider today. Thank you for protecting my mother, Alex.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.needsVerification,
        ),
      ],
    ),

    // Scenario 32: Accessibility Large-Button Phone
    SalesScenario(
      id: 'sales-32-accessibility-large-button',
      title: 'Vision Impairment & Tactile Voice Navigation Solution',
      category: 'landline_to_wireless',
      difficulty: 'intermediate',
      profile: const SalesCustomerProfile(
        name: 'George Washington Carver III',
        tone: 'visually impaired senior',
        currentProvider: 'Traditional Landline',
        householdNeeds: 'Accessible phone with tactile braille buttons and high-contrast display',
        financialConstraint:
            'Looking for affordable equipment and flat billing',
        coreBlocker: 'Cannot navigate glass smartphone touchscreens due to severe macular degeneration',
      ),
      contextNotes: 'Has severe macular degeneration and relies on specialized tactile large-button handsets.',
      skillTags: [
        'Accessibility Focus',
        'Empathetic Matching',
        'Tactile Solutions',
      ],
      prohibitedPromises: [
        'promise voice recognition AI will solve 100% of accessibility needs without physical buttons',
      ],
      mandatoryDisclosures: [
        'Existing accessibility-certified RJ11 corded phones plug directly into the Wireless Home Phone base',
        'Emergency 911 dispatch will receive registered home address location',
      ],
      fictionalCandidateProducts: ['prod-landline-cell-base'],
      turns: [
        const SalesTurn(
          id: 'turn-ll32-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: TrainingConstants.standardGreeting,
          phase: SalesPhase.greeting,
          requiredKeywords: ['att', 'alex', 'first', 'last', 'name'],
          trainerGuidanceArabic: 'ابدأ بالترحيب الرسمي المعتمد.',
          usEnglishModelResponse: TrainingConstants.standardGreeting,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-ll32-02'),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll32-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Hello Alex. My name is George Carver. I have macular degeneration, so I cannot see glass smartphone screens. I have a specialized large-button telephone with tactile braille dots that I rely on. Can I keep using this exact phone if I switch to your wireless home service?',
          phase: SalesPhase.initialResolution,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-ll32-03'),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll32-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'Yes, absolutely, Mr. Carver. Our Wireless Home Phone base uses a standard telephone cord jack, so your specialized large-button braille telephone plugs directly into it and functions exactly as it does today.',
          phase: SalesPhase.explorationPermission,
          requiredKeywords: [
            'absolutely',
            'standard telephone cord',
            'braille',
            'plugs directly',
          ],
          trainerGuidanceArabic: 'طَمئِن العميل أن هاتفه المخصص لضعاف البصر بأزرار برايل سيعمل مباشرة عبر منفذ الهاتف القياسي.',
          usEnglishModelResponse: 'Yes, absolutely Mr. Carver. The wireless base has standard telephone jacks on the back. You plug your tactile braille phone right in, and it operates just like normal with crystal clear sound.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-ll32-04'),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll32-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'That is wonderful to hear. Does the unit announce incoming caller numbers with audio speech, or will my phone handle that?',
          phase: SalesPhase.discovery,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-ll32-05'),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll32-05',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'The wireless base sends standard caller ID signals down the line, so your phone’s built-in speaking caller ID feature will announce incoming calls just like it does now, for thirty dollars a month.',
          phase: SalesPhase.valueBridge,
          requiredKeywords: [
            'caller id',
            'speaking',
            'announce',
            'thirty dollars',
          ],
          trainerGuidanceArabic: 'وضح أن إشارات Caller ID ستصل لهاتفه الناطق ليعلن أسماء المتصلين صوتياً كما اعتاد.',
          usEnglishModelResponse: 'The adapter passes full caller ID data to your phone, allowing your speaking caller ID handset to announce who is calling smoothly. The plan is thirty dollars monthly.',
          branches: [
            ScenarioBranch(conditionKey: 'accept', nextTurnId: 'turn-ll32-06A'),
            ScenarioBranch(
              conditionKey: 'decline',
              nextTurnId: 'turn-ll32-06B',
            ),
            ScenarioBranch(conditionKey: 'verify', nextTurnId: 'turn-ll32-06C'),
          ],
        ),
        // Path A: Qualified Accept
        const SalesTurn(
          id: 'turn-ll32-06A',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'That preserves my independence completely while saving me forty dollars every month. Let us go ahead and set that up, Alex.',
          phase: SalesPhase.objectionHandling,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ll32-07A',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll32-07A',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'I am honored to assist you, Mr. Carver. I will process your order with free delivery, and we will keep your existing phone line live until your adapter is set up.',
          phase: SalesPhase.closing,
          requiredKeywords: ['honored', 'free delivery', 'live', 'set up'],
          trainerGuidanceArabic: 'أكد إتمام الطلب باحترام مع شحن مجاني واستمرار الخدمة القديمة لحين التركيب.',
          usEnglishModelResponse: 'It is an absolute honor to help you maintain your independence. I will place the order with free home shipping and ensure your phone number transfers smoothly.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ll32-08A',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll32-08A',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText: 'Thank you so much, Alex. You made this so clear and easy for me.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.qualifiedAccept,
        ),
        // Path B: Respectful No-Sale
        const SalesTurn(
          id: 'turn-ll32-06B',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'My state commission for the blind pays for my current copper line under a special grant. If I switch to a private wireless plan, I might lose my state subsidy.',
          phase: SalesPhase.objectionHandling,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ll32-07B',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll32-07B',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'That state subsidy is a wonderful benefit, Mr. Carver! You should definitely keep your state grant in place. We will leave your account untouched.',
          phase: SalesPhase.closing,
          requiredKeywords: ['subsidy', 'state grant', 'keep', 'untouched'],
          trainerGuidanceArabic: 'احترم استحقاقه لمنحة المكفوفين الحكومية وشجعه على التمسك بها دون أي تغيير.',
          usEnglishModelResponse: 'That state grant is a wonderful resource. Keeping your grant intact is definitely the best decision, and we will make zero changes to your line.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ll32-08B',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll32-08B',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText: 'Thank you for your honesty, Alex. I appreciate you looking out for my benefits.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.respectfulNoSale,
        ),
        // Path C: Needs Verification
        const SalesTurn(
          id: 'turn-ll32-06C',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'My blind services social worker comes by on Thursday. Can you give me the exact technical model number so she can confirm it meets their grant guidelines?',
          phase: SalesPhase.eligibilityBoundary,
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ll32-07C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll32-07C',
          turnNumber: 7,
          speaker: TurnSpeaker.agent,
          spokenText: 'Certainly, Mr. Carver. The model is the AT&T Wireless Home Phone Base IFWA-40. I will save this reference in your profile so your social worker can review it on Thursday.',
          phase: SalesPhase.eligibilityBoundary,
          requiredKeywords: ['model', 'ifwa-40', 'social worker', 'review'],
          trainerGuidanceArabic: 'زود العميل بالموديل الدقيق للجهاز (IFWA-40) ليراجعه مع الأخصائية الاجتماعية قبل اتخاذ القرار.',
          usEnglishModelResponse: 'Certainly, Mr. Carver. It is the IFWA-40 Wireless Home Phone unit. I will document this on your profile so you and your social worker can confirm all guidelines together on Thursday.',
          branches: [
            ScenarioBranch(
              conditionKey: 'default',
              nextTurnId: 'turn-ll32-08C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-ll32-08C',
          turnNumber: 8,
          speaker: TurnSpeaker.customer,
          spokenText: 'Splendid. I will review that model with my worker on Thursday. Thank you, Alex.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.needsVerification,
        ),
      ],
    ),
  ];
}
