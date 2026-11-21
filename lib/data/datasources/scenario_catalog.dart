import '../../core/constants/training_constants.dart';
import '../../core/models/provenance.dart';
import '../../domain/entities/scenario.dart';

/// Complete catalog of 30 fictional customer service and sales training scenarios.
/// Grounded in realistic floor skills, AERD de-escalation, discovery, and disclosures.
/// Features genuine adaptive branching: High-AERD/success path (4A -> 5A) and
/// Low-AERD/objection path (4B -> 5B) across all 30 scenarios.
/// Explicitly labeled [Fictional / Simulation Only] — strictly for practice purposes.
class ScenarioCatalog {
  static const String _defaultAgentGreeting =
      'Hello, thank you for calling AT&T. This is Alex. May I have your first and last name, please?';

  static final List<Scenario> allScenarios = [
    // 01: First Bill Proration & Partial Month Charges
    Scenario(
      id: 'scen-01-first-bill',
      title: 'First Bill Proration & Partial Month Charges',
      moduleIndex: 1,
      category: 'Billing & Payments',
      difficulty: 'beginner',
      customerPersona: 'Marcus Vance (Confused New Wireless Customer)',
      skillTags: const ['Proration', 'First Bill', 'AERD'],
      expectedResponse: _defaultAgentGreeting,
      customerResponse: 'Hi Alex, I am Marcus Vance. My first bill is 220 dollars! I was told it would be 140! Can you explain why I am being overcharged?',
      requiredAnchors: TrainingConstants.greetingRequiredAnchors,
      contextNotes: 'Marcus switched 2 lines 8 days into the billing cycle. The first bill reflects 22 days of prorated service plus the upcoming month in advance, plus one-time activation fees.',
      turns: const [
        // Turn 1: Mandatory Opening Greeting (Agent)
        ScenarioTurn(
          id: 'turn-01-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: _defaultAgentGreeting,
          requiredKeywords: ['att', 'alex', 'name'],
          trainerGuidanceArabic:
              'ابدأ بالتحية الإلزامية بصوت هادئ وواضح مع ذكر اسمك أليكس.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-01-02'),
          ],
        ),

        // Turn 2: Customer Initial Statement / Inquiry
        ScenarioTurn(
          id: 'turn-01-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Hi Alex, I am Marcus Vance. My first bill is 220 dollars! I was told it would be 140! Can you explain why I am being overcharged?',
          trainerGuidanceArabic: 'العميل مصدوم من الفاتورة الأولى. طبق AERD: اعترف بالصدمة، طمنه إنك هتراجع البنود بند بند، واشرح مفهوم الفاتورة الجزئية (Proration) والشهر المقدم.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-01-03'),
          ],
        ),

        // Turn 3: Agent Core Explanation & AERD (Branch Point)
        ScenarioTurn(
          id: 'turn-01-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'I completely understand your surprise, Marcus. Let me look right into your bill breakdown so you know exactly what is charged and when your ongoing rate applies.',
          requiredKeywords: ['understand', 'look', 'bill', 'breakdown'],
          trainerGuidanceArabic: 'استخدم أسلوب التطمين واشرح الفرق بين رسوم أول شهر والرسوم الثابتة القادمة.',
          branches: [
            ScenarioBranch(conditionKey: 'success', nextTurnId: 'turn-01-04A'),
            ScenarioBranch(conditionKey: 'low_aerd', nextTurnId: 'turn-01-04B'),
          ],
        ),

        // Turn 4A: Customer Satisfied / Understanding Response (High-AERD Success Path)
        ScenarioTurn(
          id: 'turn-01-04A',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Okay, so part of this is for the first few days before my official cycle, plus next month in advance? That makes sense. Will my next bill actually be 140 dollars?',
          trainerGuidanceArabic: 'العميل بدأ يفهم ويهدأ. أكد له على السعر الشهري الدائم واقترح تفعيل الخصومات المتاحة زي AutoPay.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-01-05A'),
          ],
        ),

        // Turn 4B: Customer Pushback / Objection / Escalation (Low-AERD Path)
        ScenarioTurn(
          id: 'turn-01-04B',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'You are giving me textbook excuses, Alex! I am not paying 220 dollars when the salesperson guaranteed 140! What are you going to do about this right now?',
          trainerGuidanceArabic: 'العميل معترض لأن التفسير لم يكن مطمئناً. اعترف بغضبه بحزم، وقدم حلاً واضحاً كإسقاط رسوم التفعيل أو تأكيد الخصم المباشر.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-01-05B'),
          ],
        ),

        // Turn 5A: Agent Professional Closing (High-AERD Terminal)
        ScenarioTurn(
          id: 'turn-01-05A',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Exactly, Marcus. Once your AutoPay discount applies, your regular monthly bill will be 140 dollars. Is there anything else I can assist you with today?',
          requiredKeywords: ['autopay', 'regular', 'assist'],
          trainerGuidanceArabic:
              'أنهِ المكالمة باحترافية وتأكد إن كل استفساراته تم حلها.',
          isFinal: true,
        ),

        // Turn 5B: Agent De-escalation & Recovery (Low-AERD Terminal)
        ScenarioTurn(
          id: 'turn-01-05B',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'I hear your frustration, Marcus, and you deserve complete transparency. I am crediting the one-time activation fees today, bringing this bill down and locking your ongoing monthly rate at 140 dollars.',
          requiredKeywords: ['frustration', 'transparency', 'credit', 'rate'],
          trainerGuidanceArabic: 'امتص الغضب، أثبت ملكيتك للمكالمة بتقديم تسوية فورية وتأكيد السعر النهائي.',
          isFinal: true,
        ),
      ],
      metadata: const ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes: 'Marcus switched 2 lines 8 days into the billing cycle. The first bill reflects 22 days of prorated service plus the upcoming month in advance, plus one-time activation fees.',
      ),
    ),
    // 02: Trade-In Promotional Bill Credits Timing
    Scenario(
      id: 'scen-02-tradein-credits',
      title: 'Trade-In Promotional Bill Credits Timing',
      moduleIndex: 1,
      category: 'Billing & Payments',
      difficulty: 'intermediate',
      customerPersona: 'Sarah Jenkins (Anxious Upgrading Customer)',
      skillTags: const ['Trade-In', 'Bill Credits', 'Pacing'],
      expectedResponse: _defaultAgentGreeting,
      customerResponse: 'Hello Alex, Sarah Jenkins here. I sent my trade-in two weeks ago, but my bill has no credit! Am I going to be stuck paying the full price every month?',
      requiredAnchors: TrainingConstants.greetingRequiredAnchors,
      contextNotes: 'Promotional trade-in credits take 2 to 3 billing cycles to appear following device receipt and warehouse inspection, with retroactive catch-up credits on the first applied bill.',
      turns: const [
        // Turn 1: Mandatory Opening Greeting (Agent)
        ScenarioTurn(
          id: 'turn-02-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: _defaultAgentGreeting,
          requiredKeywords: ['att', 'alex', 'name'],
          trainerGuidanceArabic:
              'ابدأ بالتحية الإلزامية بصوت هادئ وواضح مع ذكر اسمك أليكس.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-02-02'),
          ],
        ),

        // Turn 2: Customer Initial Statement / Inquiry
        ScenarioTurn(
          id: 'turn-02-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Hello Alex, Sarah Jenkins here. I sent my trade-in two weeks ago, but my bill has no credit! Am I going to be stuck paying the full price every month?',
          trainerGuidanceArabic: 'طمن سارة واشرح لها إن رصيد الترايد إن بيحتاج من دورتين لثلاث دورات فواتير عشان ينزل على الفاتورة، وأول ما ينزل بياخد الفترات بأثر رجعي.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-02-03'),
          ],
        ),

        // Turn 3: Agent Core Explanation & AERD (Branch Point)
        ScenarioTurn(
          id: 'turn-02-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'I understand your concern, Sarah. Promotional trade-in credits take two to three billing cycles to verify at the warehouse, and you will receive retroactive catch-up credits.',
          requiredKeywords: ['understand', 'trade in', 'cycles', 'credit'],
          trainerGuidanceArabic: 'اشرح لها إطار الوقت الزمني (2 to 3 billing cycles) وطمئنها بخصوص الرصيد التراكمي (retroactive credits).',
          branches: [
            ScenarioBranch(conditionKey: 'success', nextTurnId: 'turn-02-04A'),
            ScenarioBranch(conditionKey: 'low_aerd', nextTurnId: 'turn-02-04B'),
          ],
        ),

        // Turn 4A: Customer Satisfied / Understanding Response (High-AERD Success Path)
        ScenarioTurn(
          id: 'turn-02-04A',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Oh, so once the warehouse processes it, I get credited for these first couple of months too? That relieves a lot of stress, thank you Alex.',
          trainerGuidanceArabic:
              'سارة اطمأنت تماماً. أكد لها متابعة حالة الشحنة ورقم التتبع.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-02-05A'),
          ],
        ),

        // Turn 4B: Customer Pushback / Objection / Escalation (Low-AERD Path)
        ScenarioTurn(
          id: 'turn-02-04B',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Nobody told me about waiting three months! I can\'t afford an extra 35 dollars every month while your warehouse takes its time. Can\'t you apply it manually today?',
          trainerGuidanceArabic: 'سارة معترضة على فترة الانتظار. اعترف بالعبء المالي ووضح نظام الأثر الرجعي مع متابعة حالة الشحن في السيستم.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-02-05B'),
          ],
        ),

        // Turn 5A: Agent Professional Closing (High-AERD Terminal)
        ScenarioTurn(
          id: 'turn-02-05A',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'You are very welcome, Sarah. Your tracking shows device delivered, so you are in great shape. Is there anything else I can check for you today?',
          requiredKeywords: ['welcome', 'tracking', 'delivered', 'check'],
          trainerGuidanceArabic: 'أغلق المكالمة بود واحترافية.',
          isFinal: true,
        ),

        // Turn 5B: Agent De-escalation & Recovery (Low-AERD Terminal)
        ScenarioTurn(
          id: 'turn-02-05B',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'I completely hear your budget concern, Sarah. While the system processes the promotional credit automatically, I have verified your tracking receipt and added a note to ensure your catch-up credits post on schedule.',
          requiredKeywords: ['hear', 'budget', 'verified', 'credits'],
          trainerGuidanceArabic: 'أكد التحقق من رقم التتبع وطمنها بأن حقوقها المالية محفوظة ومتابعة.',
          isFinal: true,
        ),
      ],
      metadata: const ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes: 'Promotional trade-in credits take 2 to 3 billing cycles to appear following device receipt and warehouse inspection, with retroactive catch-up credits on the first applied bill.',
      ),
    ),
    // 03: International Roaming & Day Pass Consultation
    Scenario(
      id: 'scen-03-intl-roaming',
      title: 'International Roaming & Day Pass Consultation',
      moduleIndex: 1,
      category: 'Plan Upgrade & Features',
      difficulty: 'intermediate',
      customerPersona: 'David Miller (Frequent Business Traveler)',
      skillTags: const ['International', 'Day Pass', 'Discovery'],
      expectedResponse: _defaultAgentGreeting,
      customerResponse: 'Hi Alex, this is David Miller. I am flying to London for ten days on Tuesday. How do I make sure I don\'t get hit with a crazy five hundred dollar roaming bill?',
      requiredAnchors: TrainingConstants.greetingRequiredAnchors,
      contextNotes: 'David travels to London next week for 10 days. Without International Day Pass, pay-per-use roaming data incurs massive expense. IDP caps daily cost at 12 dollars a day.',
      turns: const [
        // Turn 1: Mandatory Opening Greeting (Agent)
        ScenarioTurn(
          id: 'turn-03-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: _defaultAgentGreeting,
          requiredKeywords: ['att', 'alex', 'name'],
          trainerGuidanceArabic:
              'ابدأ بالتحية الإلزامية بصوت هادئ وواضح مع ذكر اسمك أليكس.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-03-02'),
          ],
        ),

        // Turn 2: Customer Initial Statement / Inquiry
        ScenarioTurn(
          id: 'turn-03-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Hi Alex, this is David Miller. I am flying to London for ten days on Tuesday. How do I make sure I don\'t get hit with a crazy five hundred dollar roaming bill?',
          trainerGuidanceArabic: 'العميل مسافر وعاوز حماية من مصاريف التجوال. قدم له International Day Pass واشرح السعر والحد الأقصى اليومي.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-03-03'),
          ],
        ),

        // Turn 3: Agent Core Explanation & AERD (Branch Point)
        ScenarioTurn(
          id: 'turn-03-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'I can definitely protect you from unexpected roaming charges, David. International Day Pass gives you unlimited talk, text, and high-speed data for twelve dollars a day only when used.',
          requiredKeywords: ['protect', 'international', 'pass', 'twelve'],
          trainerGuidanceArabic: 'وضح ميزة إن اليومية (12 دولار) بتتحسب بس في الأيام اللي بيستخدم فيها التليفون، والحد الأقصى في دورة الفوترة.',
          branches: [
            ScenarioBranch(conditionKey: 'success', nextTurnId: 'turn-03-04A'),
            ScenarioBranch(conditionKey: 'low_aerd', nextTurnId: 'turn-03-04B'),
          ],
        ),

        // Turn 4A: Customer Satisfied / Understanding Response (High-AERD Success Path)
        ScenarioTurn(
          id: 'turn-03-04A',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'That sounds perfect. So if I only use it six of the ten days, I only pay for those six days? Go ahead and add that to my line please.',
          trainerGuidanceArabic: 'العميل موافق. أكد التفعيل وقدم نصيحة سريعة عن تشغيل Data Roaming في إعدادات الهاتف.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-03-05A'),
          ],
        ),

        // Turn 4B: Customer Pushback / Objection / Escalation (Low-AERD Path)
        ScenarioTurn(
          id: 'turn-03-04B',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Twelve dollars a day? That is still over a hundred dollars! Can\'t I just buy a cheap local European SIM card instead?',
          trainerGuidanceArabic: 'العميل شايف السعر عالي. قارن له بين راحة الاحتفاظ برقمه الأمريكي واستقبال رسائل البنك، وبين تعقيدات الشريحة المحلية.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-03-05B'),
          ],
        ),

        // Turn 5A: Agent Professional Closing (High-AERD Terminal)
        ScenarioTurn(
          id: 'turn-03-05A',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Added successfully, David! Remember to turn on Data Roaming in your phone settings when you touch down at Heathrow. Have a wonderful and safe trip to London!',
          requiredKeywords: ['added', 'roaming', 'settings', 'trip'],
          trainerGuidanceArabic:
              'أكد التفعيل ووجهه لفتح التجوال في الهاتف وتمنى له رحلة سعيدة.',
          isFinal: true,
        ),

        // Turn 5B: Agent De-escalation & Recovery (Low-AERD Terminal)
        ScenarioTurn(
          id: 'turn-03-05B',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'You certainly can, David, but keep in mind a local SIM changes your number so your two-factor security codes won\'t reach you. With Day Pass, you keep your American number and only pay on days you trigger data.',
          requiredKeywords: ['certainly', 'number', 'security', 'trigger'],
          trainerGuidanceArabic:
              'وضح ميزة استلام رسائل الأمان المصرفية 2FA مع الحفاظ على الرقم.',
          isFinal: true,
        ),
      ],
      metadata: const ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes: 'David travels to London next week for 10 days. Without International Day Pass, pay-per-use roaming data incurs massive expense. IDP caps daily cost at 12 dollars a day.',
      ),
    ),
    // 04: Unlimited Plan High-Speed Threshold & Congestion Management
    Scenario(
      id: 'scen-04-data-throttle',
      title: 'Unlimited Plan High-Speed Threshold & Congestion Management',
      moduleIndex: 1,
      category: 'Billing & Payments',
      difficulty: 'intermediate',
      customerPersona: 'Jordan Bell (Heavy Data Streaming User)',
      skillTags: const ['Data Threshold', 'Congestion', 'Discovery'],
      expectedResponse: _defaultAgentGreeting,
      customerResponse: 'Alex, my name is Jordan Bell. My internet speed dropped to absolute crawl this afternoon! Am I being throttled because I used too much data?',
      requiredAnchors: TrainingConstants.greetingRequiredAnchors,
      contextNotes: 'Jordan streams video on Unlimited Starter. After reaching network threshold during cell tower congestion, data speeds temporarily slow until congestion clears.',
      turns: const [
        // Turn 1: Mandatory Opening Greeting (Agent)
        ScenarioTurn(
          id: 'turn-04-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: _defaultAgentGreeting,
          requiredKeywords: ['att', 'alex', 'name'],
          trainerGuidanceArabic:
              'ابدأ بالتحية الإلزامية بصوت هادئ وواضح مع ذكر اسمك أليكس.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-04-02'),
          ],
        ),

        // Turn 2: Customer Initial Statement / Inquiry
        ScenarioTurn(
          id: 'turn-04-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Alex, my name is Jordan Bell. My internet speed dropped to absolute crawl this afternoon! Am I being throttled because I used too much data?',
          trainerGuidanceArabic: 'العميل بيعاني من بطء في النت وفاكر إنه عقاب. اشرح مفهوم إدارة الشبكة في أوقات الذروة واقترح خطة Premium بدون حدود للسرعة.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-04-03'),
          ],
        ),

        // Turn 3: Agent Core Explanation & AERD (Branch Point)
        ScenarioTurn(
          id: 'turn-04-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'I understand your frustration with slow speeds, Jordan. On your current plan, speeds may temporarily slow during tower congestion, but they return to normal once traffic clears.',
          requiredKeywords: [
            'understand',
            'frustration',
            'congestion',
            'normal',
          ],
          trainerGuidanceArabic: 'اشرح بأمانة الفرق بين الازدحام المؤقت والاختناق الدائم، واعرض عليه ترقية الخطة لو محتاج أولوية دائمة.',
          branches: [
            ScenarioBranch(conditionKey: 'success', nextTurnId: 'turn-04-04A'),
            ScenarioBranch(conditionKey: 'low_aerd', nextTurnId: 'turn-04-04B'),
          ],
        ),

        // Turn 4A: Customer Satisfied / Understanding Response (High-AERD Success Path)
        ScenarioTurn(
          id: 'turn-04-04A',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Okay, so it is just peak tower traffic right now. If I upgrade to Unlimited Premium, do I get truly unlimited high-speed data that never slows down?',
          trainerGuidanceArabic: 'العميل مهتم بالترقية. وضح له ميزات خطة Premium مع فرق السعر البسيط.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-04-05A'),
          ],
        ),

        // Turn 4B: Customer Pushback / Objection / Escalation (Low-AERD Path)
        ScenarioTurn(
          id: 'turn-04-04B',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'That is ridiculous. I pay for \'Unlimited\' and now you tell me it\'s limited whenever your towers are busy? That feels like false advertising!',
          trainerGuidanceArabic: 'العميل غاضب من كلمة Unlimited. اعترف بمدى الإحباط، ووضح الفرق التقني بين استهلاك البيانات المفتوح وسرعة المرور على الشبكة.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-04-05B'),
          ],
        ),

        // Turn 5A: Agent Professional Closing (High-AERD Terminal)
        ScenarioTurn(
          id: 'turn-04-05A',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Yes exactly, Jordan! Premium includes unlimited high-speed data that can\'t be slowed by usage, plus sixty gigabytes of hotspot. Shall we upgrade your line today?',
          requiredKeywords: ['unlimited', 'premium', 'hotspot', 'upgrade'],
          trainerGuidanceArabic:
              'أكد ميزات Premium وقدم دعوة الترقية باحترافية.',
          isFinal: true,
        ),

        // Turn 5B: Agent De-escalation & Recovery (Low-AERD Terminal)
        ScenarioTurn(
          id: 'turn-04-05B',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'I hear exactly why that feels frustrating, Jordan. Your data usage is truly unlimited without overage fees, but Starter manages traffic during rush hours. Upgrading to Premium guarantees priority bandwidth anytime.',
          requiredKeywords: ['hear', 'unlimited', 'traffic', 'priority'],
          trainerGuidanceArabic: 'اشرح الفرق بين كمية البيانات غير المحدودة وأولوية السرعة وقدم له خيار الترقية كحل دائم.',
          isFinal: true,
        ),
      ],
      metadata: const ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes: 'Jordan streams video on Unlimited Starter. After reaching network threshold during cell tower congestion, data speeds temporarily slow until congestion clears.',
      ),
    ),
    // 05: Broadband Gateway Red Broadband Light Troubleshooting
    Scenario(
      id: 'scen-05-gateway-redlight',
      title: 'Broadband Gateway Red Broadband Light Troubleshooting',
      moduleIndex: 1,
      category: 'Technical Troubleshooting',
      difficulty: 'intermediate',
      customerPersona: 'Elena Rostova (Remote Worker with Internet Outage)',
      skillTags: const ['Broadband', 'Troubleshooting', 'AERD'],
      expectedResponse: _defaultAgentGreeting,
      customerResponse: 'Hi Alex, I am Elena Rostova. I work from home and my Wi-Fi is completely down! The little light labeled Broadband on the black box is solid red. Help!',
      requiredAnchors: TrainingConstants.greetingRequiredAnchors,
      contextNotes: 'Elena\'s fiber gateway displays a solid red broadband light. Power cycling and fiber jumper cable reseating are required before dispatching an on-site field technician.',
      turns: const [
        // Turn 1: Mandatory Opening Greeting (Agent)
        ScenarioTurn(
          id: 'turn-05-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: _defaultAgentGreeting,
          requiredKeywords: ['att', 'alex', 'name'],
          trainerGuidanceArabic:
              'ابدأ بالتحية الإلزامية بصوت هادئ وواضح مع ذكر اسمك أليكس.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-05-02'),
          ],
        ),

        // Turn 2: Customer Initial Statement / Inquiry
        ScenarioTurn(
          id: 'turn-05-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Hi Alex, I am Elena Rostova. I work from home and my Wi-Fi is completely down! The little light labeled Broadband on the black box is solid red. Help!',
          trainerGuidanceArabic: 'إيلينا بتشتغل من البيت والنت قاطع. اعترف بأهمية الشغل وطمئنها، وابدأ خطوات الفحص: إعادة تشغيل الراوتر والتأكد من كابل الفايبر الأخضر.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-05-03'),
          ],
        ),

        // Turn 3: Agent Core Explanation & AERD (Branch Point)
        ScenarioTurn(
          id: 'turn-05-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'I understand how urgent this is for your remote work, Elena. Let us check the physical fiber connection and restart the gateway together to restore your signal.',
          requiredKeywords: ['understand', 'urgent', 'gateway', 'restore'],
          trainerGuidanceArabic: 'وجهها بخطوات هادئة ومحددة للتأكد من الكابل الأخضر في منفذ الـ PON.',
          branches: [
            ScenarioBranch(conditionKey: 'success', nextTurnId: 'turn-05-04A'),
            ScenarioBranch(conditionKey: 'low_aerd', nextTurnId: 'turn-05-04B'),
          ],
        ),

        // Turn 4A: Customer Satisfied / Understanding Response (High-AERD Success Path)
        ScenarioTurn(
          id: 'turn-05-04A',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'I pressed the red power button, waited two minutes, and now the broadband light turned solid green! The Wi-Fi is back on my laptop. You are amazing Alex!',
          trainerGuidanceArabic: 'الراوتر اشتغل بنجاح واللمبة بقت خضراء. انصحها بتطبيق Smart Home Manager لمراقبة الشبكة مستقبلاً.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-05-05A'),
          ],
        ),

        // Turn 4B: Customer Pushback / Objection / Escalation (Low-AERD Path)
        ScenarioTurn(
          id: 'turn-05-04B',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'I reseated the green cable and restarted it twice, and the light is still solid red. I have a client presentation in two hours, I cannot wait days for a technician!',
          trainerGuidanceArabic: 'اللمبة لسه حمراء، معناه مشكلة خارجية في الفايبر. طمنها بخصوص أولوية العمل المنزلي واحجز لها فني فوري أو اقترح تفعيل الهوت سبوت على الموبايل.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-05-05B'),
          ],
        ),

        // Turn 5A: Agent Professional Closing (High-AERD Terminal)
        ScenarioTurn(
          id: 'turn-05-05A',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'I am so glad your connection is back up, Elena! You can also use the Smart Home Manager app to run quick health checks anytime. Have a productive workday!',
          requiredKeywords: ['glad', 'connection', 'smart', 'productive'],
          trainerGuidanceArabic: 'أغلق المكالمة بود واحترافية.',
          isFinal: true,
        ),

        // Turn 5B: Agent De-escalation & Recovery (Low-AERD Terminal)
        ScenarioTurn(
          id: 'turn-05-05B',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'I hear how critical this meeting is, Elena. Since the signal is red at the ONT, I am expediting our priority field dispatch for this afternoon, and temporarily boosting your mobile hotspot so you stay online.',
          requiredKeywords: ['hear', 'critical', 'expediting', 'hotspot'],
          trainerGuidanceArabic:
              'قدم حل بديل فوري (هوت سبوت الهاتف) مع حجز فني طوارئ.',
          isFinal: true,
        ),
      ],
      metadata: const ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes: 'Elena\'s fiber gateway displays a solid red broadband light. Power cycling and fiber jumper cable reseating are required before dispatching an on-site field technician.',
      ),
    ),
    // 06: Fiber Installation Appointment Window Rescheduling
    Scenario(
      id: 'scen-06-fiber-reschedule',
      title: 'Fiber Installation Appointment Window Rescheduling',
      moduleIndex: 1,
      category: 'Technical Troubleshooting',
      difficulty: 'beginner',
      customerPersona: 'Robert Chen (Busy Professional)',
      skillTags: const ['Installation', 'Scheduling', 'Pacing'],
      expectedResponse: _defaultAgentGreeting,
      customerResponse: 'Hello Alex, Robert Chen calling. I have a fiber install booked for tomorrow morning, but an emergency came up and I won\'t be home. Can I change it to Friday?',
      requiredAnchors: TrainingConstants.greetingRequiredAnchors,
      contextNotes: 'Robert has a fiber installation scheduled for tomorrow between 8 AM and 12 PM, but has an urgent morning flight. Rescheduling requires an adult 18+ on site.',
      turns: const [
        // Turn 1: Mandatory Opening Greeting (Agent)
        ScenarioTurn(
          id: 'turn-06-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: _defaultAgentGreeting,
          requiredKeywords: ['att', 'alex', 'name'],
          trainerGuidanceArabic:
              'ابدأ بالتحية الإلزامية بصوت هادئ وواضح مع ذكر اسمك أليكس.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-06-02'),
          ],
        ),

        // Turn 2: Customer Initial Statement / Inquiry
        ScenarioTurn(
          id: 'turn-06-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Hello Alex, Robert Chen calling. I have a fiber install booked for tomorrow morning, but an emergency came up and I won\'t be home. Can I change it to Friday?',
          trainerGuidanceArabic: 'روبرت محتاج يغير ميعاد التركيب. اكد له إمكانية التغيير واشرح شرط وجود شخص بالغ (18+) في البيت وقت التركيب.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-06-03'),
          ],
        ),

        // Turn 3: Agent Core Explanation & AERD (Branch Point)
        ScenarioTurn(
          id: 'turn-06-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'I can certainly take care of that for you, Robert. Let us look at Friday openings between eight to twelve or twelve to four, ensuring someone eighteen or older is present.',
          requiredKeywords: ['certainly', 'care', 'friday', 'eighteen'],
          trainerGuidanceArabic:
              'اعرض عليه الفترات المتاحة يوم الجمعة ونبهه على شرط الـ 18 سنة.',
          branches: [
            ScenarioBranch(conditionKey: 'success', nextTurnId: 'turn-06-04A'),
            ScenarioBranch(conditionKey: 'low_aerd', nextTurnId: 'turn-06-04B'),
          ],
        ),

        // Turn 4A: Customer Satisfied / Understanding Response (High-AERD Success Path)
        ScenarioTurn(
          id: 'turn-06-04A',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Friday afternoon between twelve and four PM works great. My wife will be home all day. Please lock that in.',
          trainerGuidanceArabic: 'العميل وافق على فترة بعد الظهر. أكد الميعاد ورقم التأكيد في رسالة نصية.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-06-05A'),
          ],
        ),

        // Turn 4B: Customer Pushback / Objection / Escalation (Low-AERD Path)
        ScenarioTurn(
          id: 'turn-06-04B',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Friday is completely booked? The next available slot is two weeks away? That is unacceptable, I work remotely and need internet this week!',
          trainerGuidanceArabic: 'العميل معترض على بعد المواعيد. دور في الفترات الإضافية أو قائمة الانتظار السريعة لحجز أقرب موعد ممكن.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-06-05B'),
          ],
        ),

        // Turn 5A: Agent Professional Closing (High-AERD Terminal)
        ScenarioTurn(
          id: 'turn-06-05A',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'All set, Robert! Your fiber installation is locked for Friday from twelve to four PM. You will receive a confirmation text and technician tracking link on arrival.',
          requiredKeywords: ['locked', 'friday', 'confirmation', 'tracking'],
          trainerGuidanceArabic: 'أنهِ المكالمة باحترافية وتأكيد رسالة التتبع.',
          isFinal: true,
        ),

        // Turn 5B: Agent De-escalation & Recovery (Low-AERD Terminal)
        ScenarioTurn(
          id: 'turn-06-05B',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'I understand your urgent need for home broadband, Robert. I checked our priority escalation queue and secured an emergency technician window for Saturday morning at nine AM.',
          requiredKeywords: ['understand', 'urgent', 'priority', 'secured'],
          trainerGuidanceArabic:
              'أظهر الاهتمام واعرض ميعاد السبت البديل كحل أسرع.',
          isFinal: true,
        ),
      ],
      metadata: const ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes: 'Robert has a fiber installation scheduled for tomorrow between 8 AM and 12 PM, but has an urgent morning flight. Rescheduling requires an adult 18+ on site.',
      ),
    ),
    // 07: AutoPay & Paperless Discount Requirements
    Scenario(
      id: 'scen-07-autopay-discount',
      title: 'AutoPay & Paperless Discount Requirements',
      moduleIndex: 2,
      category: 'Billing & Payments',
      difficulty: 'beginner',
      customerPersona: 'Patricia Adams (Long-Time Wireless Subscriber)',
      skillTags: const ['AutoPay', 'Paperless', 'Billing'],
      expectedResponse: _defaultAgentGreeting,
      customerResponse: 'Alex, this is Patricia Adams. My monthly discount was cut in half this month from twenty dollars down to ten! Why are you reducing my loyalty discount?',
      requiredAnchors: TrainingConstants.greetingRequiredAnchors,
      contextNotes: 'Patricia noticed her monthly discount dropped from 10 dollars per line to 5 dollars per line because she switched her payment method to a rewards credit card.',
      turns: const [
        // Turn 1: Mandatory Opening Greeting (Agent)
        ScenarioTurn(
          id: 'turn-07-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: _defaultAgentGreeting,
          requiredKeywords: ['att', 'alex', 'name'],
          trainerGuidanceArabic:
              'ابدأ بالتحية الإلزامية بصوت هادئ وواضح مع ذكر اسمك أليكس.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-07-02'),
          ],
        ),

        // Turn 2: Customer Initial Statement / Inquiry
        ScenarioTurn(
          id: 'turn-07-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Alex, this is Patricia Adams. My monthly discount was cut in half this month from twenty dollars down to ten! Why are you reducing my loyalty discount?',
          trainerGuidanceArabic: 'باتريشيا خصمها نزل للنص. وضح لها بهدوء إن كروت الائتمان خصمها 5 دولار للخط، بينما كروت الخصم المباشر (Debit) أو الحساب البنكي 10 دولار.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-07-03'),
          ],
        ),

        // Turn 3: Agent Core Explanation & AERD (Branch Point)
        ScenarioTurn(
          id: 'turn-07-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'I understand your frustration, Patricia. To receive the full ten dollar discount per line, payments must be tied to a debit card or bank account rather than a credit card.',
          requiredKeywords: ['understand', 'frustration', 'debit', 'discount'],
          trainerGuidanceArabic:
              'اشرح الفرق بين الـ Debit Card والـ Credit Card بطريقة ودية.',
          branches: [
            ScenarioBranch(conditionKey: 'success', nextTurnId: 'turn-07-04A'),
            ScenarioBranch(conditionKey: 'low_aerd', nextTurnId: 'turn-07-04B'),
          ],
        ),

        // Turn 4A: Customer Satisfied / Understanding Response (High-AERD Success Path)
        ScenarioTurn(
          id: 'turn-07-04A',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Oh, I see! I did switch to my new airline credit card last month. If I change it back to my checking account debit card, will the full twenty dollars return?',
          trainerGuidanceArabic: 'العميلة فهمت السبب. أكد لها إن تعديل طريقة الدفع في التطبيق بيرجع الخصم الكامل في الفاتورة القادمة.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-07-05A'),
          ],
        ),

        // Turn 4B: Customer Pushback / Objection / Escalation (Low-AERD Path)
        ScenarioTurn(
          id: 'turn-07-04B',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'That makes no sense! Every other company gives full discounts on credit cards. Why should I give you access to my direct bank account just to get promised rates?',
          trainerGuidanceArabic: 'العميلة معترضة على ربط الحساب البنكي. اعترف بحقها في الخصوصية وطمنها بخصوص الأمان البنكي المشفر أو استمرار خصم الـ 5 دولار.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-07-05B'),
          ],
        ),

        // Turn 5A: Agent Professional Closing (High-AERD Terminal)
        ScenarioTurn(
          id: 'turn-07-05A',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Yes exactly, Patricia! As soon as you update your payment method in the app, your full twenty dollar discount will apply on your next cycle. Thank you for your loyalty!',
          requiredKeywords: ['update', 'twenty', 'cycle', 'loyalty'],
          trainerGuidanceArabic: 'أغلق المكالمة بشكر العميل على ولائه.',
          isFinal: true,
        ),

        // Turn 5B: Agent De-escalation & Recovery (Low-AERD Terminal)
        ScenarioTurn(
          id: 'turn-07-05B',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'I completely respect your privacy and security choices, Patricia. If you prefer keeping the credit card, you still retain the five dollar per line discount, or we can use a dedicated secure debit card.',
          requiredKeywords: ['respect', 'privacy', 'retain', 'discount'],
          trainerGuidanceArabic: 'احترم رغبتها وقدم بديل أمان مالي مرن.',
          isFinal: true,
        ),
      ],
      metadata: const ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes: 'Patricia noticed her monthly discount dropped from 10 dollars per line to 5 dollars per line because she switched her payment method to a rewards credit card.',
      ),
    ),
    // 08: Payment Arrangement & Past Due Extensions
    Scenario(
      id: 'scen-08-payment-arrangement',
      title: 'Payment Arrangement & Past Due Extensions',
      moduleIndex: 2,
      category: 'Billing & Payments',
      difficulty: 'intermediate',
      customerPersona: 'Kenneth Moore (Customer Facing Temporary Hardship)',
      skillTags: const ['Payment Arrangement', 'Empathy', 'De-escalation'],
      expectedResponse: _defaultAgentGreeting,
      customerResponse: 'Hello Alex, Kenneth Moore here. I received a text saying my service will be disconnected on Wednesday, but I don\'t get paid until Friday. Can you please give me two days?',
      requiredAnchors: TrainingConstants.greetingRequiredAnchors,
      contextNotes: 'Kenneth has a past due balance of 185 dollars and risks suspension. He receives his paycheck next Friday and needs a formal payment arrangement.',
      turns: const [
        // Turn 1: Mandatory Opening Greeting (Agent)
        ScenarioTurn(
          id: 'turn-08-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: _defaultAgentGreeting,
          requiredKeywords: ['att', 'alex', 'name'],
          trainerGuidanceArabic:
              'ابدأ بالتحية الإلزامية بصوت هادئ وواضح مع ذكر اسمك أليكس.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-08-02'),
          ],
        ),

        // Turn 2: Customer Initial Statement / Inquiry
        ScenarioTurn(
          id: 'turn-08-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Hello Alex, Kenneth Moore here. I received a text saying my service will be disconnected on Wednesday, but I don\'t get paid until Friday. Can you please give me two days?',
          trainerGuidanceArabic: 'كينيث خايف من قطع الخدمة وقبضه يوم الجمعة. استخدم AERD بتعاطف حقيقي ورتب له موعد سداد مؤجل في السيستم قبل يوم الأربعاء.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-08-03'),
          ],
        ),

        // Turn 3: Agent Core Explanation & AERD (Branch Point)
        ScenarioTurn(
          id: 'turn-08-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'I completely understand and appreciate you reaching out before any interruption, Kenneth. Let us set up a payment arrangement for Friday so your phone stays active.',
          requiredKeywords: [
            'understand',
            'appreciate',
            'arrangement',
            'active',
          ],
          trainerGuidanceArabic: 'طمنه إن ترتيب السداد في السيستم بيمنع تعليق الخدمة وبيحفظ خطوطه شغالة.',
          branches: [
            ScenarioBranch(conditionKey: 'success', nextTurnId: 'turn-08-04A'),
            ScenarioBranch(conditionKey: 'low_aerd', nextTurnId: 'turn-08-04B'),
          ],
        ),

        // Turn 4A: Customer Satisfied / Understanding Response (High-AERD Success Path)
        ScenarioTurn(
          id: 'turn-08-04A',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'That is such a relief, Alex. So as long as the 185 is paid on Friday the seventeenth, my service will not be suspended at all?',
          trainerGuidanceArabic: 'كينيث ارتاح جداً. أكد له التاريخ والمبلغ بالضبط ووضح له الالتزام بميعاد السداد.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-08-05A'),
          ],
        ),

        // Turn 4B: Customer Pushback / Objection / Escalation (Low-AERD Path)
        ScenarioTurn(
          id: 'turn-08-04B',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Wait, your system is trying to charge me a seven dollar convenience fee just to set up an extension? I\'m already broke and you\'re adding more fees?',
          trainerGuidanceArabic: 'كينيث معترض على رسوم الجدولة. وضح له إنه يقدر يجدول مجاناً من تطبيق myAT&T بدون رسوم خدمة هاتفية، أو ساعده في إعفاء الرسوم.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-08-05B'),
          ],
        ),

        // Turn 5A: Agent Professional Closing (High-AERD Terminal)
        ScenarioTurn(
          id: 'turn-08-05A',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'That is correct, Kenneth! Your arrangement is confirmed for Friday the seventeenth. Your service will remain fully active with zero interruption. We appreciate you!',
          requiredKeywords: [
            'confirmed',
            'seventeenth',
            'active',
            'interruption',
          ],
          trainerGuidanceArabic:
              'أكد التفاصيل بدقة وأنهِ المكالمة بتشجيع واحترام.',
          isFinal: true,
        ),

        // Turn 5B: Agent De-escalation & Recovery (Low-AERD Terminal)
        ScenarioTurn(
          id: 'turn-08-05B',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'I hear you, Kenneth, and I want to save you every dollar right now. I will guide you to complete it on the free app, or waive that service fee manually right here.',
          requiredKeywords: ['hear', 'save', 'free', 'waive'],
          trainerGuidanceArabic: 'أظهر التعاطف مع ظرفه المالي ووجهه للخيار المجاني أو اعفِ الرسوم.',
          isFinal: true,
        ),
      ],
      metadata: const ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes: 'Kenneth has a past due balance of 185 dollars and risks suspension. He receives his paycheck next Friday and needs a formal payment arrangement.',
      ),
    ),
    // 09: Paper Bill Delivery Fee & Digital Transition
    Scenario(
      id: 'scen-09-paper-bill-fee',
      title: 'Paper Bill Delivery Fee & Digital Transition',
      moduleIndex: 2,
      category: 'Billing & Payments',
      difficulty: 'beginner',
      customerPersona:
          'Dorothy Snyder (Elderly Customer Inquiring on Surcharges)',
      skillTags: const ['Paper Bill', 'Pacing', 'AERD'],
      expectedResponse: _defaultAgentGreeting,
      customerResponse: 'Hello young man, this is Dorothy Snyder. There is a three dollar charge on my statement for sending me a paper bill! I have had this service for forty years!',
      requiredAnchors: TrainingConstants.greetingRequiredAnchors,
      contextNotes: 'Dorothy sees a new 3.00 dollar monthly paper bill fee on her landline/wireless account. She prefers paper records but is on a fixed retirement income.',
      turns: const [
        // Turn 1: Mandatory Opening Greeting (Agent)
        ScenarioTurn(
          id: 'turn-09-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: _defaultAgentGreeting,
          requiredKeywords: ['att', 'alex', 'name'],
          trainerGuidanceArabic:
              'ابدأ بالتحية الإلزامية بصوت هادئ وواضح مع ذكر اسمك أليكس.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-09-02'),
          ],
        ),

        // Turn 2: Customer Initial Statement / Inquiry
        ScenarioTurn(
          id: 'turn-09-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Hello young man, this is Dorothy Snyder. There is a three dollar charge on my statement for sending me a paper bill! I have had this service for forty years!',
          trainerGuidanceArabic: 'دورثي سيدة كبيرة في السن متفاجئة من رسوم الفاتورة الورقية. اتكلم ببطء واحترام، اعترف بولائها 40 سنة، واشرح لها البدائل الرقمية المجانية.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-09-03'),
          ],
        ),

        // Turn 3: Agent Core Explanation & AERD (Branch Point)
        ScenarioTurn(
          id: 'turn-09-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'Thank you so much for your forty years with us, Dorothy. I hear your frustration regarding the paper charge, and I can show you how to review statements free of charge.',
          requiredKeywords: ['thank', 'forty', 'frustration', 'free'],
          trainerGuidanceArabic: 'قدر ولاءها واشرح بهدوء سبب الرسوم البيئية والبريدية، واعرض حل الفاتورة الرقمية مع إمكانية طباعتها.',
          branches: [
            ScenarioBranch(conditionKey: 'success', nextTurnId: 'turn-09-04A'),
            ScenarioBranch(conditionKey: 'low_aerd', nextTurnId: 'turn-09-04B'),
          ],
        ),

        // Turn 4A: Customer Satisfied / Understanding Response (High-AERD Success Path)
        ScenarioTurn(
          id: 'turn-09-04A',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'My granddaughter told me she could help me look at it on her iPad. If she sets that up, can you remove this three dollar fee right now?',
          trainerGuidanceArabic: 'دورثي وافقت على مساعدة حفيدتها. شجعها وقم بإسقاط الرسوم وتحويل الحساب إلى Paperless.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-09-05A'),
          ],
        ),

        // Turn 4B: Customer Pushback / Objection / Escalation (Low-AERD Path)
        ScenarioTurn(
          id: 'turn-09-04B',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'I don\'t own a computer or an iPad, Alex! Are you penalizing senior citizens who don\'t know how to use the internet?',
          trainerGuidanceArabic: 'دورثي معترضة لأنها لا تملك أجهزة ذكية. اعترف بحقها وتعاطف، ووضح خيارات الإعفاء لذوي الاحتياجات أو الفاتورة الموجزة المجانية.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-09-05B'),
          ],
        ),

        // Turn 5A: Agent Professional Closing (High-AERD Terminal)
        ScenarioTurn(
          id: 'turn-09-05A',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'I would be delighted to, Dorothy! I have removed the paper fee and switched you to paperless. Tell your granddaughter you are all set!',
          requiredKeywords: ['delighted', 'removed', 'paperless', 'set'],
          trainerGuidanceArabic: 'أغلق المكالمة بلطف وود واحترام لسيدة كبيرة.',
          isFinal: true,
        ),

        // Turn 5B: Agent De-escalation & Recovery (Low-AERD Terminal)
        ScenarioTurn(
          id: 'turn-09-05B',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'I completely hear your heart on this, Dorothy, and we deeply value our senior customers. I have credited the paper charge back to your account and added a senior exemption note.',
          requiredKeywords: ['completely', 'value', 'credited', 'exemption'],
          trainerGuidanceArabic:
              'تعامل باحترام شديد لكبار السن وقدم تسوية فورية.',
          isFinal: true,
        ),
      ],
      metadata: const ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes: 'Dorothy sees a new 3.00 dollar monthly paper bill fee on her landline/wireless account. She prefers paper records but is on a fixed retirement income.',
      ),
    ),
    // 10: Demanding Customer Requesting Supervisor Callback
    Scenario(
      id: 'scen-10-supervisor-demand',
      title: 'Demanding Customer Requesting Supervisor Callback',
      moduleIndex: 2,
      category: 'Escalation & Call Control',
      difficulty: 'advanced',
      customerPersona: 'Richard Sterling (Irate High-Tier Wireless Customer)',
      skillTags: const ['Supervisor Request', 'De-escalation', 'Call Control'],
      expectedResponse: _defaultAgentGreeting,
      customerResponse: 'Alex, cut the customer service script. Put me through to your highest-ranking supervisor right now, or have one call me back within fifteen minutes. Do not argue!',
      requiredAnchors: TrainingConstants.greetingRequiredAnchors,
      contextNotes: 'Richard demands an immediate supervisor callback because of a recurring network ticket. Operational truth: supervisor callbacks are NOT available in the agent\'s process; the agent must de-escalate and take ownership directly.',
      turns: const [
        // Turn 1: Mandatory Opening Greeting (Agent)
        ScenarioTurn(
          id: 'turn-10-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: _defaultAgentGreeting,
          requiredKeywords: ['att', 'alex', 'name'],
          trainerGuidanceArabic:
              'ابدأ بالتحية الإلزامية بصوت هادئ وواضح مع ذكر اسمك أليكس.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-10-02'),
          ],
        ),

        // Turn 2: Customer Initial Statement / Inquiry
        ScenarioTurn(
          id: 'turn-10-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Alex, cut the customer service script. Put me through to your highest-ranking supervisor right now, or have one call me back within fifteen minutes. Do not argue!',
          trainerGuidanceArabic: 'ريتشارد غاضب وبيطلب سوبرفايزر فوراً أو مكالمة راجعة. الحقيقة التشغيلية: لا توجد خدمة اتصال راجع من المشرفين في هذا النظام. استلم زمام المكالمة واعتذر عن تعطله وأكد قدرتك على فحص المشكلة وحلها فوراً.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-10-03'),
          ],
        ),

        // Turn 3: Agent Core Explanation & AERD (Branch Point)
        ScenarioTurn(
          id: 'turn-10-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'I understand your frustration, Richard, and I want to ensure your issue is resolved immediately. In our center we do not offer supervisor callbacks, but I have full authority to look into this ticket and resolve it for you right now.',
          requiredKeywords: [
            'understand',
            'frustration',
            'authority',
            'resolve',
          ],
          trainerGuidanceArabic: 'كن صريحاً بأدب بخصوص عدم وجود callbacks وأكد صلاحيتك المباشرة لحل المشكلة بنفسك.',
          branches: [
            ScenarioBranch(conditionKey: 'success', nextTurnId: 'turn-10-04A'),
            ScenarioBranch(conditionKey: 'low_aerd', nextTurnId: 'turn-10-04B'),
          ],
        ),

        // Turn 4A: Customer Satisfied / Understanding Response (High-AERD Success Path)
        ScenarioTurn(
          id: 'turn-10-04A',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Fine. At least you are honest about the callback. The ticket number is 9 4 8 2 1. Tell me why my neighborhood tower has been down for four days.',
          trainerGuidanceArabic: 'ريتشارد وافق يسمع منك بعد صدقك. افحص رقم التذكرة ووضح له حالة الصيانة ووقت الإصلاح المتوقع بدقة.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-10-05A'),
          ],
        ),

        // Turn 4B: Customer Pushback / Objection / Escalation (Low-AERD Path)
        ScenarioTurn(
          id: 'turn-10-04B',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'I don\'t care about your policy, Alex! I demand a supervisor right now! If you don\'t transfer me this second, I am canceling all eight lines on my account!',
          trainerGuidanceArabic: 'ريتشارد بيهدد بإلغاء 8 خطوط لو متحولش. خليك هادي وثابت، طبق Empathy عميق: \'أنا مقدر تماماً أهمية الخطوط لشغلك\'، وكرر استعدادك للتدخل الفوري لمنع الإلغاء.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-10-05B'),
          ],
        ),

        // Turn 5A: Agent Professional Closing (High-AERD Terminal)
        ScenarioTurn(
          id: 'turn-10-05A',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Thank you, Richard. Looking at ticket 94821, field technicians replaced the primary amplifier this morning, and testing shows normal signal will restore by 3 PM today.',
          requiredKeywords: ['looking', 'technicians', 'signal', 'restore'],
          trainerGuidanceArabic: 'قدم المعلومة التقنية بدقة ووضوح وطمئنه.',
          isFinal: true,
        ),

        // Turn 5B: Agent De-escalation & Recovery (Low-AERD Terminal)
        ScenarioTurn(
          id: 'turn-10-05B',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Richard, I hear how serious this is for your eight lines, and the last thing I want is for you to lose service. Let me immediately consult my floor lead while keeping you on the line so we resolve this without delay.',
          requiredKeywords: ['hear', 'serious', 'lines', 'resolve'],
          trainerGuidanceArabic: 'حافظ على هدوء الأعصاب وقدم استشارة داخلية سريعة مع المشرف بدون وعد بمكالمة راجعة.',
          isFinal: true,
        ),
      ],
      metadata: const ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes: 'Richard demands an immediate supervisor callback because of a recurring network ticket. Operational truth: supervisor callbacks are NOT available in the agent\'s process; the agent must de-escalate and take ownership directly.',
      ),
    ),
    // 11: Equipment Installment Plan Payoff vs Upgrade
    Scenario(
      id: 'scen-11-eip-payoff',
      title: 'Equipment Installment Plan Payoff vs Upgrade',
      moduleIndex: 2,
      category: 'Plan Upgrade & Features',
      difficulty: 'intermediate',
      customerPersona: 'Megan Clark (Customer Wanting New Flagship Phone)',
      skillTags: const ['EIP', 'Next Up', 'Upgrade'],
      expectedResponse: _defaultAgentGreeting,
      customerResponse: 'Hi Alex, Megan Clark here. I want to upgrade to the new Pro Max today. Can I just roll my remaining 320 dollars into the new phone, or do I have to pay it off first?',
      requiredAnchors: TrainingConstants.greetingRequiredAnchors,
      contextNotes: 'Megan owes 320 dollars on her current phone with 8 installment months remaining. She wants the new flagship phone and needs payoff and Next Up options explained.',
      turns: const [
        // Turn 1: Mandatory Opening Greeting (Agent)
        ScenarioTurn(
          id: 'turn-11-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: _defaultAgentGreeting,
          requiredKeywords: ['att', 'alex', 'name'],
          trainerGuidanceArabic:
              'ابدأ بالتحية الإلزامية بصوت هادئ وواضح مع ذكر اسمك أليكس.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-11-02'),
          ],
        ),

        // Turn 2: Customer Initial Statement / Inquiry
        ScenarioTurn(
          id: 'turn-11-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Hi Alex, Megan Clark here. I want to upgrade to the new Pro Max today. Can I just roll my remaining 320 dollars into the new phone, or do I have to pay it off first?',
          trainerGuidanceArabic: 'ميجان عاوزة تشتري التليفون الجديد وعليها 320 دولار. اشرح لها الفرق بين سداد المبلغ بالكامل للحفاظ على الجهاز القديم، أو خيار Next Up لو مشترك فيه لتسليم الجهاز وإسقاط الباقي.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-11-03'),
          ],
        ),

        // Turn 3: Agent Core Explanation & AERD (Branch Point)
        ScenarioTurn(
          id: 'turn-11-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'I can definitely clarify your upgrade options, Megan. If you have Next Up, you can trade in your device to waive remaining payments, or you can pay the three hundred twenty dollars to keep your current phone.',
          requiredKeywords: ['clarify', 'options', 'next up', 'trade in'],
          trainerGuidanceArabic:
              'وضح لها خياري Next Up وسداد الـ 320 دولار بوضوح.',
          branches: [
            ScenarioBranch(conditionKey: 'success', nextTurnId: 'turn-11-04A'),
            ScenarioBranch(conditionKey: 'low_aerd', nextTurnId: 'turn-11-04B'),
          ],
        ),

        // Turn 4A: Customer Satisfied / Understanding Response (High-AERD Success Path)
        ScenarioTurn(
          id: 'turn-11-04A',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'I do have Next Up on my bill! So I can just hand this one in, erase that 320 dollar balance, and get the new Pro Max right away? Let\'s do that!',
          trainerGuidanceArabic: 'ميجان مبسوطة إن عندها Next Up. وضح لها خطوات الفحص واستلام الجهاز الجديد.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-11-05A'),
          ],
        ),

        // Turn 4B: Customer Pushback / Objection / Escalation (Low-AERD Path)
        ScenarioTurn(
          id: 'turn-11-04B',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'I don\'t have Next Up? That means I have to pay 320 dollars out of pocket right now on top of taxes? That is way too much money to upgrade today.',
          trainerGuidanceArabic: 'ميجان معترضة على دفع الـ 320 كاش. اقترح عليها برنامج الترايد إن التقليدي أو تخفيض فئة الجهاز لتقليل التكلفة الأولية.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-11-05B'),
          ],
        ),

        // Turn 5A: Agent Professional Closing (High-AERD Terminal)
        ScenarioTurn(
          id: 'turn-11-05A',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Exactly, Megan! As long as your phone is in good working condition, Next Up covers the remaining balance. Let us pick your preferred color and storage size!',
          requiredKeywords: ['condition', 'balance', 'color', 'storage'],
          trainerGuidanceArabic:
              'ابدأ عملية اختيار اللون والمساحة بحماس واحترافية.',
          isFinal: true,
        ),

        // Turn 5B: Agent De-escalation & Recovery (Low-AERD Terminal)
        ScenarioTurn(
          id: 'turn-11-05B',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'I understand that is a substantial upfront cost, Megan. However, your current phone still qualifies for standard trade-in credits that can offset the new phone\'s monthly payments over thirty-six months.',
          requiredKeywords: ['understand', 'cost', 'trade in', 'credits'],
          trainerGuidanceArabic: 'قدم حل الترايد إن لتعويض التكلفة الشهرية.',
          isFinal: true,
        ),
      ],
      metadata: const ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes: 'Megan owes 320 dollars on her current phone with 8 installment months remaining. She wants the new flagship phone and needs payoff and Next Up options explained.',
      ),
    ),
    // 12: Missing Trade-In Shipping Return Kit
    Scenario(
      id: 'scen-12-tradein-box',
      title: 'Missing Trade-In Shipping Return Kit',
      moduleIndex: 2,
      category: 'Technical Troubleshooting',
      difficulty: 'intermediate',
      customerPersona: 'Brandon Lee (Customer Nearing 30-Day Return Limit)',
      skillTags: const ['Trade-In Box', 'Shipping', 'AERD'],
      expectedResponse: _defaultAgentGreeting,
      customerResponse: 'Alex, Brandon Lee here. I got my new iPhone twenty days ago, but the trade-in return kit never showed up! If I don\'t send it within thirty days, I lose my eight hundred dollar promo!',
      requiredAnchors: TrainingConstants.greetingRequiredAnchors,
      contextNotes: 'Brandon upgraded online 20 days ago but never received the specialized trade-in shipping box. He fears missing the 30-day deadline.',
      turns: const [
        // Turn 1: Mandatory Opening Greeting (Agent)
        ScenarioTurn(
          id: 'turn-12-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: _defaultAgentGreeting,
          requiredKeywords: ['att', 'alex', 'name'],
          trainerGuidanceArabic:
              'ابدأ بالتحية الإلزامية بصوت هادئ وواضح مع ذكر اسمك أليكس.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-12-02'),
          ],
        ),

        // Turn 2: Customer Initial Statement / Inquiry
        ScenarioTurn(
          id: 'turn-12-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Alex, Brandon Lee here. I got my new iPhone twenty days ago, but the trade-in return kit never showed up! If I don\'t send it within thirty days, I lose my eight hundred dollar promo!',
          trainerGuidanceArabic: 'براندون قلقان جداً عشان فاضل 10 أيام ويفقد الخصم. طمنه فوراً: اطلب له كيت شحن جديد فوري ومجاني، وابعث له بوليصة شحن فورية على الإيميل مع تمديد الفترة في السيستم.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-12-03'),
          ],
        ),

        // Turn 3: Agent Core Explanation & AERD (Branch Point)
        ScenarioTurn(
          id: 'turn-12-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'I understand your anxiety about the deadline, Brandon. I am ordering a replacement return kit with priority shipping and emailing you a prepaid shipping label right now so you can drop it off today.',
          requiredKeywords: ['understand', 'anxiety', 'replacement', 'label'],
          trainerGuidanceArabic:
              'وفر له بوليصة شحن رقمية فورية واطلب الكيت الجديد كاحتياط.',
          branches: [
            ScenarioBranch(conditionKey: 'success', nextTurnId: 'turn-12-04A'),
            ScenarioBranch(conditionKey: 'low_aerd', nextTurnId: 'turn-12-04B'),
          ],
        ),

        // Turn 4A: Customer Satisfied / Understanding Response (High-AERD Success Path)
        ScenarioTurn(
          id: 'turn-12-04A',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'You can email the shipping label directly? That is incredible! I have a UPS store right down the street. Thank you so much Alex!',
          trainerGuidanceArabic: 'العميل ارتاح وشكرك. اكد له على تغليف الجهاز واستلام إيصال الشحن من UPS.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-12-05A'),
          ],
        ),

        // Turn 4B: Customer Pushback / Objection / Escalation (Low-AERD Path)
        ScenarioTurn(
          id: 'turn-12-04B',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'I don\'t have a printer to print a label, Alex! And priority shipping still takes three days. What happens if the box arrives after day thirty?',
          trainerGuidanceArabic: 'العميل معندوش طابعة وقلقان من تأخير الكيت. طمنه إن كود الـ QR يقدر يعمله سكان في UPS بدون طابعة، وإنك حطيت نوتة تمديد 30 يوم إضافية في السيستم.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-12-05B'),
          ],
        ),

        // Turn 5A: Agent Professional Closing (High-AERD Terminal)
        ScenarioTurn(
          id: 'turn-12-05A',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'You are very welcome, Brandon! Just take the email or QR code to UPS, they can scan and print the label for you. Keep the receipt and you are fully protected!',
          requiredKeywords: ['welcome', 'ups', 'scan', 'protected'],
          trainerGuidanceArabic: 'أكد على الاحتفاظ بإيصال UPS وأغلق باحترافية.',
          isFinal: true,
        ),

        // Turn 5B: Agent De-escalation & Recovery (Low-AERD Terminal)
        ScenarioTurn(
          id: 'turn-12-05B',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'No printer needed at all, Brandon! The email includes a mobile QR code that UPS scans to print the label for free. Plus, I extended your trade-in window in our system by thirty days.',
          requiredKeywords: ['free', 'extended', 'system', 'days'],
          trainerGuidanceArabic:
              'قدم حل كود الـ QR والتمديد الرسمي في السيستم.',
          isFinal: true,
        ),
      ],
      metadata: const ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes: 'Brandon upgraded online 20 days ago but never received the specialized trade-in shipping box. He fears missing the 30-day deadline.',
      ),
    ),
    // 13: Unfamiliar Third-Party App & Gaming Surcharges
    Scenario(
      id: 'scen-13-third-party-charge',
      title: 'Unfamiliar Third-Party App & Gaming Surcharges',
      moduleIndex: 3,
      category: 'Billing & Payments',
      difficulty: 'intermediate',
      customerPersona: 'Carolyn Wright (Parent Questioning Mystery Line Item)',
      skillTags: const ['Third-Party', 'Dispute', 'AERD'],
      expectedResponse: _defaultAgentGreeting,
      customerResponse: 'Hello Alex, Carolyn Wright. There are three separate 9.99 charges for some gaming club on my bill! I never authorized these! Are you letting random companies charge my card?',
      requiredAnchors: TrainingConstants.greetingRequiredAnchors,
      contextNotes: 'Carolyn noticed three charges of 9.99 dollars for mobile gaming subscriptions on her teenage son\'s line. She insists she never authorized them.',
      turns: const [
        // Turn 1: Mandatory Opening Greeting (Agent)
        ScenarioTurn(
          id: 'turn-13-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: _defaultAgentGreeting,
          requiredKeywords: ['att', 'alex', 'name'],
          trainerGuidanceArabic:
              'ابدأ بالتحية الإلزامية بصوت هادئ وواضح مع ذكر اسمك أليكس.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-13-02'),
          ],
        ),

        // Turn 2: Customer Initial Statement / Inquiry
        ScenarioTurn(
          id: 'turn-13-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Hello Alex, Carolyn Wright. There are three separate 9.99 charges for some gaming club on my bill! I never authorized these! Are you letting random companies charge my card?',
          trainerGuidanceArabic: 'كارولين متفاجئة من رسوم ألعاب على خط ابنها. اعترف بالصدمة، اشرح إن دي مشتريات من داخل التطبيقات (in-app purchases)، واعرض عليها إلغاء الاشتراك وحظر المشتريات ورد المبالغ.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-13-03'),
          ],
        ),

        // Turn 3: Agent Core Explanation & AERD (Branch Point)
        ScenarioTurn(
          id: 'turn-13-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'I completely understand your concern, Carolyn. Let me review those digital purchases, issue a direct credit for the twenty-nine dollars, and place a purchase block on that line right now.',
          requiredKeywords: ['understand', 'concern', 'credit', 'block'],
          trainerGuidanceArabic: 'قدم الثلاثية: رصيد فوري، إلغاء الاشتراك، وحظر المشتريات مستقبلاً.',
          branches: [
            ScenarioBranch(conditionKey: 'success', nextTurnId: 'turn-13-04A'),
            ScenarioBranch(conditionKey: 'low_aerd', nextTurnId: 'turn-13-04B'),
          ],
        ),

        // Turn 4A: Customer Satisfied / Understanding Response (High-AERD Success Path)
        ScenarioTurn(
          id: 'turn-13-04A',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'You can block future purchases completely? Please do! And thank you so much for crediting the money back without making me jump through hoops.',
          trainerGuidanceArabic: 'العميلة ارتاحت وشكرتك على سرعة الحل. أكد لها تفعيل Purchase Blocker ورقم العملية.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-13-05A'),
          ],
        ),

        // Turn 4B: Customer Pushback / Objection / Escalation (Low-AERD Path)
        ScenarioTurn(
          id: 'turn-13-04B',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Crediting it is fine, but how did this happen without my password in the first place? How do I know another company won\'t charge me next week?',
          trainerGuidanceArabic: 'العميلة لسه قلقانة من أمان الحساب. اشرح لها إعدادات الأمان في المتجر وميزة Purchase Blocker المانعة لأي فواتير طرف ثالث.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-13-05B'),
          ],
        ),

        // Turn 5A: Agent Professional Closing (High-AERD Terminal)
        ScenarioTurn(
          id: 'turn-13-05A',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Purchase Blocker is active on all lines, Carolyn, and your credit of twenty-nine ninety-seven is posted. You are completely protected from unexpected app charges going forward!',
          requiredKeywords: ['active', 'credit', 'protected', 'charges'],
          trainerGuidanceArabic: 'أكد الحظر والرصيد وأنهِ المكالمة باحترافية.',
          isFinal: true,
        ),

        // Turn 5B: Agent De-escalation & Recovery (Low-AERD Terminal)
        ScenarioTurn(
          id: 'turn-13-05B',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'I hear your concern about security, Carolyn. The purchase block I activated completely disables third-party carrier billing at the network level, so no vendor can bill your account without direct banking approval.',
          requiredKeywords: ['hear', 'security', 'network', 'approval'],
          trainerGuidanceArabic: 'طمئنها على الحماية على مستوى الشبكة بالكامل.',
          isFinal: true,
        ),
      ],
      metadata: const ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes: 'Carolyn noticed three charges of 9.99 dollars for mobile gaming subscriptions on her teenage son\'s line. She insists she never authorized them.',
      ),
    ),
    // 14: Bereavement Account Assumption & Line Transition
    Scenario(
      id: 'scen-14-bereavement-transfer',
      title: 'Bereavement Account Assumption & Line Transition',
      moduleIndex: 3,
      category: 'Billing & Payments',
      difficulty: 'advanced',
      customerPersona:
          'Thomas Gallagher (Grieving Son Managing Mother\'s Estate)',
      skillTags: const ['Bereavement', 'Compassion', 'AERD'],
      expectedResponse: _defaultAgentGreeting,
      customerResponse: 'Alex, my name is Thomas Gallagher. My mother passed away last week. I need to take over her cell phone number so family can reach me, but close her other devices.',
      requiredAnchors: TrainingConstants.greetingRequiredAnchors,
      contextNotes: 'Thomas recently lost his mother and needs to assume ownership of her wireless line while canceling the tablet line without incurring early cancellation fees.',
      turns: const [
        // Turn 1: Mandatory Opening Greeting (Agent)
        ScenarioTurn(
          id: 'turn-14-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: _defaultAgentGreeting,
          requiredKeywords: ['att', 'alex', 'name'],
          trainerGuidanceArabic:
              'ابدأ بالتحية الإلزامية بصوت هادئ وواضح مع ذكر اسمك أليكس.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-14-02'),
          ],
        ),

        // Turn 2: Customer Initial Statement / Inquiry
        ScenarioTurn(
          id: 'turn-14-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Alex, my name is Thomas Gallagher. My mother passed away last week. I need to take over her cell phone number so family can reach me, but close her other devices.',
          trainerGuidanceArabic: 'موقف إنساني حساس جداً (وفاة الأم). قدم تعازي صادقة ودافئة، استخدم نبرة صوت هادئة ومحترمة، واشرح له إن إجراءات الوفاة بتعفي الحساب من أي شروط جزائية.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-14-03'),
          ],
        ),

        // Turn 3: Agent Core Explanation & AERD (Branch Point)
        ScenarioTurn(
          id: 'turn-14-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'Thomas, please accept my deepest condolences for the loss of your mother. I will personally handle this transfer with complete care, waive any cancellation fees, and keep her number active for you.',
          requiredKeywords: ['condolences', 'loss', 'care', 'waive'],
          trainerGuidanceArabic:
              'قدم التعازي أولاً، طمنه بخصوص إعفاء الرسوم وحفظ رقم والدته.',
          branches: [
            ScenarioBranch(conditionKey: 'success', nextTurnId: 'turn-14-04A'),
            ScenarioBranch(conditionKey: 'low_aerd', nextTurnId: 'turn-14-04B'),
          ],
        ),

        // Turn 4A: Customer Satisfied / Understanding Response (High-AERD Success Path)
        ScenarioTurn(
          id: 'turn-14-04A',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Thank you, Alex. I really appreciate your kindness. It has been a terrible week. What documents do I need to send to finalize this?',
          trainerGuidanceArabic: 'توماس شكرك على مشاعرك الطيبة. وضح له ببساطة المستندات المطلوبة (شهادة الوفاة) ورابط الإرسال السريع.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-14-05A'),
          ],
        ),

        // Turn 4B: Customer Pushback / Objection / Escalation (Low-AERD Path)
        ScenarioTurn(
          id: 'turn-14-04B',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'I hope you are not going to make me go into a retail store with death certificates while I am planning her funeral. I cannot handle that right now.',
          trainerGuidanceArabic: 'توماس مضغوط من الجنازة وخايف من البيروقراطية. طمنه فوراً: كل حاجة بتتم أونلاين أو بالتليفون بدون الحاجة لزيارة أي فرع.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-14-05B'),
          ],
        ),

        // Turn 5A: Agent Professional Closing (High-AERD Terminal)
        ScenarioTurn(
          id: 'turn-14-05A',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'You won\'t have to visit any store, Thomas. You can upload a simple copy through our secure bereavement link whenever you are ready. Take all the time you need, and God bless.',
          requiredKeywords: ['secure', 'bereavement', 'link', 'ready'],
          trainerGuidanceArabic:
              'أغلق المكالمة بأقصى درجات الاحترام والتعاطف الإنساني.',
          isFinal: true,
        ),

        // Turn 5B: Agent De-escalation & Recovery (Low-AERD Terminal)
        ScenarioTurn(
          id: 'turn-14-05B',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'You do not need to step foot in any store, Thomas. I have placed a sixty-day hold on the account so everything stays active without billing pressure while you focus on your family.',
          requiredKeywords: ['store', 'hold', 'active', 'family'],
          trainerGuidanceArabic:
              'ضع فترة سماح 60 يوماً وتكفل بالإجراءات لتخفيف الضغط عنه.',
          isFinal: true,
        ),
      ],
      metadata: const ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes: 'Thomas recently lost his mother and needs to assume ownership of her wireless line while canceling the tablet line without incurring early cancellation fees.',
      ),
    ),
    // 15: Rapid Fire Number Dictation & Clarification
    Scenario(
      id: 'scen-15-fast-numbers',
      title: 'Rapid Fire Number Dictation & Clarification',
      moduleIndex: 3,
      category: 'Clarification & Listening',
      difficulty: 'advanced',
      customerPersona: 'Gary Anderson (Rushed Contractor on Job Site)',
      skillTags: const ['Fast Speech', 'Active Listening', 'Clarification'],
      expectedResponse: _defaultAgentGreeting,
      customerResponse: 'Yeah Alex listen fast my name is Gary Anderson account 849201938 contact number 512-555-0198 ext 443 I need a temporary data boost right now!',
      requiredAnchors: TrainingConstants.greetingRequiredAnchors,
      contextNotes: 'Gary speaks extremely fast on a noisy job site, rattling off an account number and contact extension without pauses.',
      turns: const [
        // Turn 1: Mandatory Opening Greeting (Agent)
        ScenarioTurn(
          id: 'turn-15-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: _defaultAgentGreeting,
          requiredKeywords: ['att', 'alex', 'name'],
          trainerGuidanceArabic:
              'ابدأ بالتحية الإلزامية بصوت هادئ وواضح مع ذكر اسمك أليكس.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-15-02'),
          ],
        ),

        // Turn 2: Customer Initial Statement / Inquiry
        ScenarioTurn(
          id: 'turn-15-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Yeah Alex listen fast my name is Gary Anderson account 849201938 contact number 512-555-0198 ext 443 I need a temporary data boost right now!',
          trainerGuidanceArabic: 'العميل مستعجل جداً وبيملي أرقام بسرعة. اسمع باهتمام، ردد الأرقام للتأكيد بطريقة مهذبة وسريعة، ونفذ طلبه.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-15-03'),
          ],
        ),

        // Turn 3: Agent Core Explanation & AERD (Branch Point)
        ScenarioTurn(
          id: 'turn-15-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'Got it, Gary! Let me verify that account number 8 4 9 2 0 1 9 3 8 and contact 5 1 2 5 5 5 0 1 9 8 extension 4 4 3, pulling up your data right now.',
          requiredKeywords: ['verify', 'account', 'contact', 'data'],
          trainerGuidanceArabic:
              'كرر الأرقام للتأكيد ووضح إنك فتحت الحساب فوراً.',
          branches: [
            ScenarioBranch(conditionKey: 'success', nextTurnId: 'turn-15-04A'),
            ScenarioBranch(conditionKey: 'low_aerd', nextTurnId: 'turn-15-04B'),
          ],
        ),

        // Turn 4A: Customer Satisfied / Understanding Response (High-AERD Success Path)
        ScenarioTurn(
          id: 'turn-15-04A',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Spot on, Alex! Good ears. Add the fifteen gigabyte boost please, my crew needs it for the blueprints right now.',
          trainerGuidanceArabic: 'العميل أشاد بتركيزك وسرعتك. نفذ إضافة باقة البيانات الإضافية فوراً.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-15-05A'),
          ],
        ),

        // Turn 4B: Customer Pushback / Objection / Escalation (Low-AERD Path)
        ScenarioTurn(
          id: 'turn-15-04B',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'No! You got the last two digits of the account wrong, it was 3 8 not 8 3! Listen carefully, I am in a hurry!',
          trainerGuidanceArabic: 'العميل نبهك على رقمين اختلفوا. اعتذر بسرعة وبدون إطالة: \'عفواً، 38 تم التصحيح فوراً\' واستكمل الإجراء.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-15-05B'),
          ],
        ),

        // Turn 5A: Agent Professional Closing (High-AERD Terminal)
        ScenarioTurn(
          id: 'turn-15-05A',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Fifteen gigabyte high-speed data boost is active immediately, Gary! Your crew is good to download those blueprints. Stay safe on the job site!',
          requiredKeywords: ['active', 'gigabyte', 'download', 'safe'],
          trainerGuidanceArabic: 'أكد التفعيل وتمنى له السلامة في موقع العمل.',
          isFinal: true,
        ),

        // Turn 5B: Agent De-escalation & Recovery (Low-AERD Terminal)
        ScenarioTurn(
          id: 'turn-15-05B',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Corrected immediately, Gary: 8 4 9 2 0 1 9 3 8. Your account is open and your fifteen gigabyte boost is active right now. Have a great build day!',
          requiredKeywords: ['corrected', 'account', 'active', 'boost'],
          trainerGuidanceArabic: 'صحح الرقم بسرعة وأكد التفعيل الفوري.',
          isFinal: true,
        ),
      ],
      metadata: const ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes: 'Gary speaks extremely fast on a noisy job site, rattling off an account number and contact extension without pauses.',
      ),
    ),
    // 16: Noisy Highway Audio & Repetition Protocol
    Scenario(
      id: 'scen-16-noisy-background',
      title: 'Noisy Highway Audio & Repetition Protocol',
      moduleIndex: 3,
      category: 'Clarification & Listening',
      difficulty: 'advanced',
      customerPersona: 'Samantha Brooks (Driving in Heavy Highway Rain)',
      skillTags: const ['Noise Management', 'Pacing', 'Clarification'],
      expectedResponse: _defaultAgentGreeting,
      customerResponse: 'Hi Alex... Samantha Brooks... crackle... need to pay... phone bill... stormy...',
      requiredAnchors: TrainingConstants.greetingRequiredAnchors,
      contextNotes: 'Samantha is on Bluetooth in a noisy car during a storm with muffled speech.',
      turns: const [
        // Turn 1: Mandatory Opening Greeting (Agent)
        ScenarioTurn(
          id: 'turn-16-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: _defaultAgentGreeting,
          requiredKeywords: ['att', 'alex', 'name'],
          trainerGuidanceArabic:
              'ابدأ بالتحية الإلزامية بصوت هادئ وواضح مع ذكر اسمك أليكس.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-16-02'),
          ],
        ),

        // Turn 2: Customer Initial Statement / Inquiry
        ScenarioTurn(
          id: 'turn-16-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Hi Alex... Samantha Brooks... crackle... need to pay... phone bill... stormy...',
          trainerGuidanceArabic: 'العميلة صوتها مشوش بسبب عاصفة. استخدم نبرة واضحة ومخارج ألفاظ صريحة واستأذنها في إعادة المبلغ بهدوء.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-16-03'),
          ],
        ),

        // Turn 3: Agent Core Explanation & AERD (Branch Point)
        ScenarioTurn(
          id: 'turn-16-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'I can hear you, Samantha, but there is some highway noise on the line. I will speak clearly, and let us confirm your payment amount safely.',
          requiredKeywords: ['hear', 'clearly', 'confirm', 'payment'],
          trainerGuidanceArabic: 'طمنها إنك سامع ومستعد تساعدها بأمان.',
          branches: [
            ScenarioBranch(conditionKey: 'success', nextTurnId: 'turn-16-04A'),
            ScenarioBranch(conditionKey: 'low_aerd', nextTurnId: 'turn-16-04B'),
          ],
        ),

        // Turn 4A: Customer Satisfied / Understanding Response (High-AERD Success Path)
        ScenarioTurn(
          id: 'turn-16-04A',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Thank you Alex, I am pulling over under an overpass. My balance is ninety dollars, please charge my card on file.',
          trainerGuidanceArabic: 'العميلة وقفت في مكان هادئ لتأكيد الدفع.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-16-05A'),
          ],
        ),

        // Turn 4B: Customer Pushback / Objection / Escalation (Low-AERD Path)
        ScenarioTurn(
          id: 'turn-16-04B',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'I can barely hear you over this rain, Alex! Can\'t you just process the payment without making me repeat everything?',
          trainerGuidanceArabic: 'العميلة متوترة من الصوت والمطر. اعترف بالصعوبة واعرض سحب المبلغ المسجل بنقرة واحدة لتسهيل الأمر.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-16-05B'),
          ],
        ),

        // Turn 5A: Agent Professional Closing (High-AERD Terminal)
        ScenarioTurn(
          id: 'turn-16-05A',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Your payment of ninety dollars is confirmed, Samantha! Drive safely and reach out anytime you need assistance.',
          requiredKeywords: ['confirmed', 'ninety', 'safely', 'assistance'],
          trainerGuidanceArabic: 'أغلق بأمان.',
          isFinal: true,
        ),

        // Turn 5B: Agent De-escalation & Recovery (Low-AERD Terminal)
        ScenarioTurn(
          id: 'turn-16-05B',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'I hear the heavy storm, Samantha, and your safety is first. I charged the standard ninety dollars to your card on file, receipt is texted. Drive safely!',
          requiredKeywords: ['hear', 'safety', 'charged', 'safely'],
          trainerGuidanceArabic: 'أكد الدفع فوراً حفاظاً على سلامتها.',
          isFinal: true,
        ),
      ],
      metadata: const ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes: 'Samantha is on Bluetooth in a noisy car during a storm with muffled speech.',
      ),
    ),
    // 17: Extended Hold Time Recovery & Reassurance
    Scenario(
      id: 'scen-17-hold-frustration',
      title: 'Extended Hold Time Recovery & Reassurance',
      moduleIndex: 3,
      category: 'Escalation & Call Control',
      difficulty: 'advanced',
      customerPersona: 'Victor Hugo (Customer Transferred Three Times)',
      skillTags: const ['Hold Recovery', 'AERD', 'De-escalation'],
      expectedResponse: _defaultAgentGreeting,
      customerResponse: 'Alex, you are the fourth person I have spoken to! I have been on hold for forty-five minutes! If you transfer me again I swear I will sue!',
      requiredAnchors: TrainingConstants.greetingRequiredAnchors,
      contextNotes: 'Victor was bounced between billing and technical support for 45 minutes.',
      turns: const [
        // Turn 1: Mandatory Opening Greeting (Agent)
        ScenarioTurn(
          id: 'turn-17-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: _defaultAgentGreeting,
          requiredKeywords: ['att', 'alex', 'name'],
          trainerGuidanceArabic:
              'ابدأ بالتحية الإلزامية بصوت هادئ وواضح مع ذكر اسمك أليكس.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-17-02'),
          ],
        ),

        // Turn 2: Customer Initial Statement / Inquiry
        ScenarioTurn(
          id: 'turn-17-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Alex, you are the fourth person I have spoken to! I have been on hold for forty-five minutes! If you transfer me again I swear I will sue!',
          trainerGuidanceArabic: 'العميل اتنقل بين 3 موظفين وغضبان جداً. اعترف بالمعاناة فوراً، اعتذر بصدق، واعده بعدم التحويل والتعامل مع المشكلة بنفسك.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-17-03'),
          ],
        ),

        // Turn 3: Agent Core Explanation & AERD (Branch Point)
        ScenarioTurn(
          id: 'turn-17-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'Victor, I am so sorry for the forty-five minutes you waited. I promise I will not transfer you; I am taking full personal ownership of your issue right now.',
          requiredKeywords: ['sorry', 'waited', 'transfer', 'ownership'],
          trainerGuidanceArabic:
              'امتص الغضب بالاعتذار وتحمل المسؤولية الشخصية الكاملة.',
          branches: [
            ScenarioBranch(conditionKey: 'success', nextTurnId: 'turn-17-04A'),
            ScenarioBranch(conditionKey: 'low_aerd', nextTurnId: 'turn-17-04B'),
          ],
        ),

        // Turn 4A: Customer Satisfied / Understanding Response (High-AERD Success Path)
        ScenarioTurn(
          id: 'turn-17-04A',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Thank goodness. An actual human who takes ownership. My fiber gateway won\'t connect after yesterday\'s storm.',
          trainerGuidanceArabic: 'العميل هدأ وبدأ يشرح مشكلة الراوتر.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-17-05A'),
          ],
        ),

        // Turn 4B: Customer Pushback / Objection / Escalation (Low-AERD Path)
        ScenarioTurn(
          id: 'turn-17-04B',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'I have heard that \'ownership\' line from the last three reps, Alex! Why should I believe you are any different?',
          trainerGuidanceArabic: 'العميل مش مصدق الوعود. أثبت الجدية بالبدء الفوري في فحص الحساب أمامه مباشرة بدون كلام نظري.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-17-05B'),
          ],
        ),

        // Turn 5A: Agent Professional Closing (High-AERD Terminal)
        ScenarioTurn(
          id: 'turn-17-05A',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Thank you for your patience, Victor. I refreshed your fiber ONT signal directly from my console, and your broadband light is green now!',
          requiredKeywords: ['patience', 'refreshed', 'signal', 'green'],
          trainerGuidanceArabic: 'أكد حل العطل بنفسك بنجاح.',
          isFinal: true,
        ),

        // Turn 5B: Agent De-escalation & Recovery (Low-AERD Terminal)
        ScenarioTurn(
          id: 'turn-17-05B',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'I hear your skepticism, Victor, and actions speak louder than words. While we spoke, I accessed your fiber terminal and pushed a signal reboot that is reconnecting your gateway right now.',
          requiredKeywords: ['hear', 'skepticism', 'terminal', 'reboot'],
          trainerGuidanceArabic:
              'أثبت له بالدليل العملي الفوري قدرتك على الحل.',
          isFinal: true,
        ),
      ],
      metadata: const ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes: 'Victor was bounced between billing and technical support for 45 minutes.',
      ),
    ),
    // 18: Home Relocation & Fiber Service Move Order
    Scenario(
      id: 'scen-18-moving-relocation',
      title: 'Home Relocation & Fiber Service Move Order',
      moduleIndex: 3,
      category: 'Plan Upgrade & Features',
      difficulty: 'intermediate',
      customerPersona: 'Emily Watson (Moving Across Town Next Month)',
      skillTags: const ['Relocation', 'Move Order', 'Discovery'],
      expectedResponse: _defaultAgentGreeting,
      customerResponse: 'Hello Alex, Emily Watson calling. I am moving to 742 Evergreen Terrace on the first of next month. Can I take my fiber with me?',
      requiredAnchors: TrainingConstants.greetingRequiredAnchors,
      contextNotes: 'Emily moves into a new apartment on the 1st and wants to know if fiber is available.',
      turns: const [
        // Turn 1: Mandatory Opening Greeting (Agent)
        ScenarioTurn(
          id: 'turn-18-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: _defaultAgentGreeting,
          requiredKeywords: ['att', 'alex', 'name'],
          trainerGuidanceArabic:
              'ابدأ بالتحية الإلزامية بصوت هادئ وواضح مع ذكر اسمك أليكس.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-18-02'),
          ],
        ),

        // Turn 2: Customer Initial Statement / Inquiry
        ScenarioTurn(
          id: 'turn-18-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Hello Alex, Emily Watson calling. I am moving to 742 Evergreen Terrace on the first of next month. Can I take my fiber with me?',
          trainerGuidanceArabic: 'إيميلي بتنقل بيت جديد وعاوزة تنقل الفايبر. افحص التغطية في العنوان الجديد واشرح ميزة Move Order.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-18-03'),
          ],
        ),

        // Turn 3: Agent Core Explanation & AERD (Branch Point)
        ScenarioTurn(
          id: 'turn-18-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'Congratulations on your new home, Emily! Let us verify fiber availability at Evergreen Terrace and schedule your seamless move order.',
          requiredKeywords: ['congratulations', 'verify', 'fiber', 'move'],
          trainerGuidanceArabic: 'بارك لها على البيت الجديد وافحص التغطية.',
          branches: [
            ScenarioBranch(conditionKey: 'success', nextTurnId: 'turn-18-04A'),
            ScenarioBranch(conditionKey: 'low_aerd', nextTurnId: 'turn-18-04B'),
          ],
        ),

        // Turn 4A: Customer Satisfied / Understanding Response (High-AERD Success Path)
        ScenarioTurn(
          id: 'turn-18-04A',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Wonderful! You have gigabit fiber there too? Please book the technician for the morning of the second.',
          trainerGuidanceArabic: 'العميلة سعيدة بوجود الفايبر في بيتها الجديد.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-18-05A'),
          ],
        ),

        // Turn 4B: Customer Pushback / Objection / Escalation (Low-AERD Path)
        ScenarioTurn(
          id: 'turn-18-04B',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'What do you mean fiber isn\'t available at that address? It\'s right in the middle of the city! Am I forced onto slow copper DSL?',
          trainerGuidanceArabic: 'العميلة مصدومة لعدم توفر الفايبر في البيت الجديد. اعترف بالإحباط، وافحص خيارات سرعات النحاس المحسنة أو Internet Air 5G.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-18-05B'),
          ],
        ),

        // Turn 5A: Agent Professional Closing (High-AERD Terminal)
        ScenarioTurn(
          id: 'turn-18-05A',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'All scheduled, Emily! Your move order is set for the second between eight and twelve. Pack your gateway and the tech will handle the rest!',
          requiredKeywords: ['scheduled', 'order', 'gateway', 'handle'],
          trainerGuidanceArabic: 'أكد ميعاد النقل.',
          isFinal: true,
        ),

        // Turn 5B: Agent De-escalation & Recovery (Low-AERD Terminal)
        ScenarioTurn(
          id: 'turn-18-05B',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'I understand your disappointment, Emily. While direct fiber is pending buildout on that block, AT&T Internet Air 5G provides seamless high-speed plug-and-play Wi-Fi for your new apartment.',
          requiredKeywords: ['understand', 'disappointment', 'air', 'seamless'],
          trainerGuidanceArabic: 'قدم بديل Internet Air 5G السريع.',
          isFinal: true,
        ),
      ],
      metadata: const ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes: 'Emily moves into a new apartment on the 1st and wants to know if fiber is available.',
      ),
    ),
    // 19: Digital eSIM Activation & QR Code Delivery
    Scenario(
      id: 'scen-19-esim-transfer',
      title: 'Digital eSIM Activation & QR Code Delivery',
      moduleIndex: 4,
      category: 'Technical Troubleshooting',
      difficulty: 'intermediate',
      customerPersona: 'Lucas Perez (Customer Setting Up New Unlocked Phone)',
      skillTags: const ['eSIM', 'Digital Activation', 'Technical'],
      expectedResponse: _defaultAgentGreeting,
      customerResponse: 'Hi Alex, Lucas Perez here. I bought an unlocked phone without a SIM tray. How do I switch my active number over to an eSIM?',
      requiredAnchors: TrainingConstants.greetingRequiredAnchors,
      contextNotes: 'Lucas bought an unlocked phone and needs to transfer his physical SIM to digital eSIM.',
      turns: const [
        // Turn 1: Mandatory Opening Greeting (Agent)
        ScenarioTurn(
          id: 'turn-19-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: _defaultAgentGreeting,
          requiredKeywords: ['att', 'alex', 'name'],
          trainerGuidanceArabic:
              'ابدأ بالتحية الإلزامية بصوت هادئ وواضح مع ذكر اسمك أليكس.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-19-02'),
          ],
        ),

        // Turn 2: Customer Initial Statement / Inquiry
        ScenarioTurn(
          id: 'turn-19-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Hi Alex, Lucas Perez here. I bought an unlocked phone without a SIM tray. How do I switch my active number over to an eSIM?',
          trainerGuidanceArabic: 'لوكاس اشترى تليفون جديد بدون مدخل شريحة محتاج eSIM. اشرح له خطوات التحويل الرقمي وإرسال الـ QR Code.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-19-03'),
          ],
        ),

        // Turn 3: Agent Core Explanation & AERD (Branch Point)
        ScenarioTurn(
          id: 'turn-19-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'I can get your eSIM activated in minutes, Lucas. Let us verify your device EID and push the digital profile directly to your phone settings.',
          requiredKeywords: ['activated', 'minutes', 'verify', 'settings'],
          trainerGuidanceArabic:
              'اطلب رقم الـ EID ووضح سهولة التنزيل عبر الواي فاي.',
          branches: [
            ScenarioBranch(conditionKey: 'success', nextTurnId: 'turn-19-04A'),
            ScenarioBranch(conditionKey: 'low_aerd', nextTurnId: 'turn-19-04B'),
          ],
        ),

        // Turn 4A: Customer Satisfied / Understanding Response (High-AERD Success Path)
        ScenarioTurn(
          id: 'turn-19-04A',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Got the prompt on my screen! Cellular plan ready to install. That was much easier than I expected, thank you!',
          trainerGuidanceArabic: 'العميل سعيد بسرعة وسهولة التحويل.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-19-05A'),
          ],
        ),

        // Turn 4B: Customer Pushback / Objection / Escalation (Low-AERD Path)
        ScenarioTurn(
          id: 'turn-19-04B',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'My screen says \'eSIM Download Failed - Contact Carrier\'. Am I without a working phone now? I need this for work!',
          trainerGuidanceArabic: 'العميل واجه خطأ في التنزيل. طمنه ووضح إن الشريحة القديمة لسه شغالة لحد اكتمال التفعيل، واعد إرسال البروفايل.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-19-05B'),
          ],
        ),

        // Turn 5A: Agent Professional Closing (High-AERD Terminal)
        ScenarioTurn(
          id: 'turn-19-05A',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'You are all set, Lucas! Your cellular data and number are fully active on your new eSIM. Enjoy your new phone!',
          requiredKeywords: ['set', 'cellular', 'active', 'enjoy'],
          trainerGuidanceArabic: 'أكد نجاح التفعيل وأغلق باحترافية.',
          isFinal: true,
        ),

        // Turn 5B: Agent De-escalation & Recovery (Low-AERD Terminal)
        ScenarioTurn(
          id: 'turn-19-05B',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Do not worry, Lucas, your original line is completely safe. I refreshed your EID profile on the network; please reconnect to Wi-Fi and tap download once more.',
          requiredKeywords: ['worry', 'safe', 'refreshed', 'download'],
          trainerGuidanceArabic: 'حل مشكلة التنزيل بهدوء وتأكيد.',
          isFinal: true,
        ),
      ],
      metadata: const ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes: 'Lucas bought an unlocked phone and needs to transfer his physical SIM to digital eSIM.',
      ),
    ),
    // 20: Copper DSL to Symmetrical Fiber Upgrade
    Scenario(
      id: 'scen-20-fiber-upgrade',
      title: 'Copper DSL to Symmetrical Fiber Upgrade',
      moduleIndex: 4,
      category: 'Plan Upgrade & Features',
      difficulty: 'intermediate',
      customerPersona: 'Arthur Pendelton (Long-Time DSL Customer)',
      skillTags: const ['Fiber Upgrade', 'Consultative Sales', 'Value'],
      expectedResponse: _defaultAgentGreeting,
      customerResponse: 'Alex, Arthur Pendelton calling. My grandson says my internet is ancient history. I pay sixty-five dollars for twenty-five megabits. Is there anything better?',
      requiredAnchors: TrainingConstants.greetingRequiredAnchors,
      contextNotes: 'Arthur pays 65 dollars for 25 Mbps copper DSL. Fiber 300 is available at his home for 55 dollars.',
      turns: const [
        // Turn 1: Mandatory Opening Greeting (Agent)
        ScenarioTurn(
          id: 'turn-20-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: _defaultAgentGreeting,
          requiredKeywords: ['att', 'alex', 'name'],
          trainerGuidanceArabic:
              'ابدأ بالتحية الإلزامية بصوت هادئ وواضح مع ذكر اسمك أليكس.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-20-02'),
          ],
        ),

        // Turn 2: Customer Initial Statement / Inquiry
        ScenarioTurn(
          id: 'turn-20-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Alex, Arthur Pendelton calling. My grandson says my internet is ancient history. I pay sixty-five dollars for twenty-five megabits. Is there anything better?',
          trainerGuidanceArabic: 'آرثر عميل قديم على سرعة بطيئة وبيدفع كتير. فرحه بإن الفايبر وصل بيته وبسعر أرخص وسرعة 10 أضعاف.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-20-03'),
          ],
        ),

        // Turn 3: Agent Core Explanation & AERD (Branch Point)
        ScenarioTurn(
          id: 'turn-20-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'You are in for great news, Arthur! Fiber has arrived at your address, giving you three hundred megabits symmetrical for fifty-five dollars—ten dollars less than you pay now.',
          requiredKeywords: ['news', 'fiber', 'three hundred', 'fifty five'],
          trainerGuidanceArabic: 'اشرح ميزة الفايبر والسعر الأوفر.',
          branches: [
            ScenarioBranch(conditionKey: 'success', nextTurnId: 'turn-20-04A'),
            ScenarioBranch(conditionKey: 'low_aerd', nextTurnId: 'turn-20-04B'),
          ],
        ),

        // Turn 4A: Customer Satisfied / Understanding Response (High-AERD Success Path)
        ScenarioTurn(
          id: 'turn-20-04A',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Wait, ten times faster and ten dollars cheaper? Sign me up right away Alex, my grandson will be thrilled!',
          trainerGuidanceArabic: 'العميل موافق ومتحمس جداً.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-20-05A'),
          ],
        ),

        // Turn 4B: Customer Pushback / Objection / Escalation (Low-AERD Path)
        ScenarioTurn(
          id: 'turn-20-04B',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'I don\'t trust technicians drilling into my historic house, Alex. Will they tear up my walls to install this fiber cable?',
          trainerGuidanceArabic: 'العميل خايف على بيته من الحفر والتكسير. طمنه بإن كابل الفايبر رفيع جداً كخيط الصيد ويستخدم نفس مسار الأسلاك القديمة.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-20-05B'),
          ],
        ),

        // Turn 5A: Agent Professional Closing (High-AERD Terminal)
        ScenarioTurn(
          id: 'turn-20-05A',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'We have technician appointments open this Thursday, Arthur. You are going to love the blazing speed. Thank you for choosing fiber!',
          requiredKeywords: ['appointments', 'thursday', 'blazing', 'choosing'],
          trainerGuidanceArabic: 'أكد الميعاد واشكره.',
          isFinal: true,
        ),

        // Turn 5B: Agent De-escalation & Recovery (Low-AERD Terminal)
        ScenarioTurn(
          id: 'turn-20-05B',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'I understand your concern for your home, Arthur. Our certified fiber technicians use micro-fiber that follows existing conduits without damaging interior walls, keeping your home pristine.',
          requiredKeywords: ['understand', 'concern', 'technicians', 'damage'],
          trainerGuidanceArabic: 'طمئنه على سلامة جدران المنزل التاريخي.',
          isFinal: true,
        ),
      ],
      metadata: const ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes: 'Arthur pays 65 dollars for 25 Mbps copper DSL. Fiber 300 is available at his home for 55 dollars.',
      ),
    ),
    // 21: Lost or Stolen Device Suspension & Blacklist
    Scenario(
      id: 'scen-21-stolen-phone',
      title: 'Lost or Stolen Device Suspension & Blacklist',
      moduleIndex: 4,
      category: 'Technical Troubleshooting',
      difficulty: 'advanced',
      customerPersona:
          'Chloe Martin (Distressed Customer Whose Phone Was Stolen)',
      skillTags: const ['Lost/Stolen', 'IMEI Blacklist', 'Security'],
      expectedResponse: _defaultAgentGreeting,
      customerResponse: 'Alex! Chloe Martin! My phone was just stolen out of my hands at the subway! You have to shut it down so they don\'t access my banking apps!',
      requiredAnchors: TrainingConstants.greetingRequiredAnchors,
      contextNotes: 'Chloe\'s phone was stolen at a transit station. She needs line suspension and IMEI blacklisting.',
      turns: const [
        // Turn 1: Mandatory Opening Greeting (Agent)
        ScenarioTurn(
          id: 'turn-21-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: _defaultAgentGreeting,
          requiredKeywords: ['att', 'alex', 'name'],
          trainerGuidanceArabic:
              'ابدأ بالتحية الإلزامية بصوت هادئ وواضح مع ذكر اسمك أليكس.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-21-02'),
          ],
        ),

        // Turn 2: Customer Initial Statement / Inquiry
        ScenarioTurn(
          id: 'turn-21-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Alex! Chloe Martin! My phone was just stolen out of my hands at the subway! You have to shut it down so they don\'t access my banking apps!',
          trainerGuidanceArabic: 'كلوي تليفونها اتسرق ومذعورة من حساباتها البنكية. اتصرف بسرعة: علق الخط فوراً وحط السيريال (IMEI) في القائمة السوداء.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-21-03'),
          ],
        ),

        // Turn 3: Agent Core Explanation & AERD (Branch Point)
        ScenarioTurn(
          id: 'turn-21-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'I am securing your account right this second, Chloe. I have suspended your line and blacklisted the device IMEI across all national networks so no one can use it.',
          requiredKeywords: ['securing', 'second', 'suspended', 'blacklisted'],
          trainerGuidanceArabic:
              'طمنها بالإجراءات الأمنية الفورية لحماية بياناتها.',
          branches: [
            ScenarioBranch(conditionKey: 'success', nextTurnId: 'turn-21-04A'),
            ScenarioBranch(conditionKey: 'low_aerd', nextTurnId: 'turn-21-04B'),
          ],
        ),

        // Turn 4A: Customer Satisfied / Understanding Response (High-AERD Success Path)
        ScenarioTurn(
          id: 'turn-21-04A',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Thank God. That is a massive weight off my shoulders. How do I get my number onto an old backup phone I have at home?',
          trainerGuidanceArabic:
              'العميلة ارتاحت وشكرتك وعاوزة تشغل رقمها على جهاز قديم.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-21-05A'),
          ],
        ),

        // Turn 4B: Customer Pushback / Objection / Escalation (Low-AERD Path)
        ScenarioTurn(
          id: 'turn-21-04B',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Can\'t someone just swap the SIM card into another phone and run up charges before you process this?',
          trainerGuidanceArabic: 'العميلة لسه خايفة من الشريحة. أكد لها إن الخط اتعلق تماماً على مستوى الشبكة في الثانية اللي اتكلمت فيها.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-21-05B'),
          ],
        ),

        // Turn 5A: Agent Professional Closing (High-AERD Terminal)
        ScenarioTurn(
          id: 'turn-21-05A',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Your line is suspended and your IMEI is blacklisted, Chloe. Whenever you are ready with your backup phone, we can activate an eSIM in five minutes.',
          requiredKeywords: ['suspended', 'blacklisted', 'ready', 'activate'],
          trainerGuidanceArabic: 'أكد الحماية وقدم حل التفعيل للجهاز البديل.',
          isFinal: true,
        ),

        // Turn 5B: Agent De-escalation & Recovery (Low-AERD Terminal)
        ScenarioTurn(
          id: 'turn-21-05B',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'I hear your fear, Chloe, but rest assured: the suspension was instantaneous at the tower level. The SIM card is completely dead and cannot make calls or use data.',
          requiredKeywords: ['hear', 'fear', 'instantaneous', 'dead'],
          trainerGuidanceArabic:
              'أكد لها موت الشريحة بالكامل وفقدانها القدرة على الاتصال.',
          isFinal: true,
        ),
      ],
      metadata: const ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes: 'Chloe\'s phone was stolen at a transit station. She needs line suspension and IMEI blacklisting.',
      ),
    ),
    // 22: 14-Day Buyer\'s Remorse Return & Restocking Fee
    Scenario(
      id: 'scen-22-remorse-period',
      title: '14-Day Buyer\'s Remorse Return & Restocking Fee',
      moduleIndex: 4,
      category: 'Billing & Payments',
      difficulty: 'intermediate',
      customerPersona: 'Daniel Vance (Customer Within Return Window)',
      skillTags: const ['Remorse Period', 'Restocking Fee', 'Policy'],
      expectedResponse: _defaultAgentGreeting,
      customerResponse: 'Hi Alex, Daniel Vance. I bought this flagship phone six days ago, but it is way too bulky for my pocket. Can I return it for a smaller model?',
      requiredAnchors: TrainingConstants.greetingRequiredAnchors,
      contextNotes: 'Daniel bought a phone 6 days ago. He finds it too heavy and wants to return it.',
      turns: const [
        // Turn 1: Mandatory Opening Greeting (Agent)
        ScenarioTurn(
          id: 'turn-22-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: _defaultAgentGreeting,
          requiredKeywords: ['att', 'alex', 'name'],
          trainerGuidanceArabic:
              'ابدأ بالتحية الإلزامية بصوت هادئ وواضح مع ذكر اسمك أليكس.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-22-02'),
          ],
        ),

        // Turn 2: Customer Initial Statement / Inquiry
        ScenarioTurn(
          id: 'turn-22-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Hi Alex, Daniel Vance. I bought this flagship phone six days ago, but it is way too bulky for my pocket. Can I return it for a smaller model?',
          trainerGuidanceArabic: 'دانيال اشترى جهاز من 6 أيام وعاوز يرجعه. اشرح له سياسة الـ 14 يوم (Buyer\'s Remorse) ورسوم إعادة التخزين القياسية 55 دولار.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-22-03'),
          ],
        ),

        // Turn 3: Agent Core Explanation & AERD (Branch Point)
        ScenarioTurn(
          id: 'turn-22-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'You are well within your fourteen-day return period, Daniel. You can exchange it for a compact model; there is a standard fifty-five dollar restocking fee.',
          requiredKeywords: ['fourteen', 'return', 'exchange', 'fifty five'],
          trainerGuidanceArabic:
              'اشرح إمكانية الاستبدال ورسوم الـ Restocking Fee.',
          branches: [
            ScenarioBranch(conditionKey: 'success', nextTurnId: 'turn-22-04A'),
            ScenarioBranch(conditionKey: 'low_aerd', nextTurnId: 'turn-22-04B'),
          ],
        ),

        // Turn 4A: Customer Satisfied / Understanding Response (High-AERD Success Path)
        ScenarioTurn(
          id: 'turn-22-04A',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Fifty-five dollars is fair enough since I opened the box. Let\'s do the exchange for the standard compact version.',
          trainerGuidanceArabic:
              'العميل وافق على الرسوم وعاوز يبدل الجهاز الأصغر.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-22-05A'),
          ],
        ),

        // Turn 4B: Customer Pushback / Objection / Escalation (Low-AERD Path)
        ScenarioTurn(
          id: 'turn-22-04B',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Fifty-five dollars just to put a phone back on a shelf? I bought it less than a week ago, that fee is completely unfair!',
          trainerGuidanceArabic: 'العميل معترض على الـ 55 دولار. وضح له إن الرسوم بتغطي فحص وتعقيم الجهاز وإعادة تهيئته، وقارنها بالتوفير في سعر الموديل الأصغر.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-22-05B'),
          ],
        ),

        // Turn 5A: Agent Professional Closing (High-AERD Terminal)
        ScenarioTurn(
          id: 'turn-22-05A',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'I will process your exchange order for the compact model right now, Daniel. Your adjusted balance will reflect immediately!',
          requiredKeywords: ['process', 'exchange', 'compact', 'reflect'],
          trainerGuidanceArabic: 'أنهِ الاستبدال باحترافية.',
          isFinal: true,
        ),

        // Turn 5B: Agent De-escalation & Recovery (Low-AERD Terminal)
        ScenarioTurn(
          id: 'turn-22-05B',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'I understand why that fee feels unexpected, Daniel. It covers sanitized diagnostic inspection, but the smaller model is actually two hundred dollars cheaper, saving you significant money overall.',
          requiredKeywords: ['understand', 'fee', 'smaller', 'saving'],
          trainerGuidanceArabic:
              'وضح القيمة الإجمالية للتوفير لتخفيف أثر الرسوم.',
          isFinal: true,
        ),
      ],
      metadata: const ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes: 'Daniel bought a phone 6 days ago. He finds it too heavy and wants to return it.',
      ),
    ),
    // 23: Manufacturer Warranty vs Insurance Claim
    Scenario(
      id: 'scen-23-warranty-vs-insurance',
      title: 'Manufacturer Warranty vs Insurance Claim',
      moduleIndex: 4,
      category: 'Plan Upgrade & Features',
      difficulty: 'intermediate',
      customerPersona: 'Karen White (Customer with Defective Charging Port)',
      skillTags: const ['Warranty', 'Insurance', 'Education'],
      expectedResponse: _defaultAgentGreeting,
      customerResponse: 'Alex, Karen White calling. My phone won\'t charge unless I hold the cable at an angle. Do I have to pay a 200 dollar insurance deductible to fix this?',
      requiredAnchors: TrainingConstants.greetingRequiredAnchors,
      contextNotes: 'Karen\'s 8-month-old phone charging port is loose. She doesn\'t know if she pays a deductible or gets a free warranty replacement.',
      turns: const [
        // Turn 1: Mandatory Opening Greeting (Agent)
        ScenarioTurn(
          id: 'turn-23-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: _defaultAgentGreeting,
          requiredKeywords: ['att', 'alex', 'name'],
          trainerGuidanceArabic:
              'ابدأ بالتحية الإلزامية بصوت هادئ وواضح مع ذكر اسمك أليكس.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-23-02'),
          ],
        ),

        // Turn 2: Customer Initial Statement / Inquiry
        ScenarioTurn(
          id: 'turn-23-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Alex, Karen White calling. My phone won\'t charge unless I hold the cable at an angle. Do I have to pay a 200 dollar insurance deductible to fix this?',
          trainerGuidanceArabic: 'كارن منفذ الشحن بتاعها تالف من غير كسر. وضح لها الفرق بين الضمان المجاني للعيوب المصنعية (Warranty) والتأمين للحوادث (Insurance).',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-23-03'),
          ],
        ),

        // Turn 3: Agent Core Explanation & AERD (Branch Point)
        ScenarioTurn(
          id: 'turn-23-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'Good news, Karen: since there is no physical or liquid damage and you are within one year, this is covered under free manufacturer warranty with zero deductible.',
          requiredKeywords: ['news', 'warranty', 'zero', 'deductible'],
          trainerGuidanceArabic:
              'طمنها بإن العيب المصنعي مجاني بدون أي خصومات.',
          branches: [
            ScenarioBranch(conditionKey: 'success', nextTurnId: 'turn-23-04A'),
            ScenarioBranch(conditionKey: 'low_aerd', nextTurnId: 'turn-23-04B'),
          ],
        ),

        // Turn 4A: Customer Satisfied / Understanding Response (High-AERD Success Path)
        ScenarioTurn(
          id: 'turn-23-04A',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Zero deductible? That is wonderful! I was dreading paying hundreds of dollars. How does the warranty swap work?',
          trainerGuidanceArabic:
              'العميلة سعيدة جداً. اشرح لها خطوات شحن الجهاز البديل.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-23-05A'),
          ],
        ),

        // Turn 4B: Customer Pushback / Objection / Escalation (Low-AERD Path)
        ScenarioTurn(
          id: 'turn-23-04B',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'What if your warehouse claims there is liquid damage when I know for a fact it never touched water?',
          trainerGuidanceArabic: 'العميلة متخوفة من تفتيش المستودع. طمنها واشرح لها مؤشر LDI في درج الشريحة.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-23-05B'),
          ],
        ),

        // Turn 5A: Agent Professional Closing (High-AERD Terminal)
        ScenarioTurn(
          id: 'turn-23-05A',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'We will ship an advanced replacement to your door in two business days, Karen. Thank you for taking care of your device!',
          requiredKeywords: ['ship', 'replacement', 'days', 'care'],
          trainerGuidanceArabic: 'أكد الشحن السريع.',
          isFinal: true,
        ),

        // Turn 5B: Agent De-escalation & Recovery (Low-AERD Terminal)
        ScenarioTurn(
          id: 'turn-23-05B',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'I completely understand that worry, Karen. We check the internal Liquid Contact Indicator, and as long as that white sensor is uncolored, your warranty replacement is fully guaranteed.',
          requiredKeywords: ['completely', 'worry', 'indicator', 'guaranteed'],
          trainerGuidanceArabic: 'اشرح لها الحساس المائي لتطمينها التام.',
          isFinal: true,
        ),
      ],
      metadata: const ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes: 'Karen\'s 8-month-old phone charging port is loose. She doesn\'t know if she pays a deductible or gets a free warranty replacement.',
      ),
    ),
    // 24: Connected Device Tablet Line Promotion
    Scenario(
      id: 'scen-24-tablet-addline',
      title: 'Connected Device Tablet Line Promotion',
      moduleIndex: 4,
      category: 'Plan Upgrade & Features',
      difficulty: 'intermediate',
      customerPersona: 'George Miller (Existing Wireless Subscriber)',
      skillTags: const ['Add a Line', 'Tablet', 'Discovery'],
      expectedResponse: _defaultAgentGreeting,
      customerResponse: 'Hello Alex, George Miller. My phone battery dies constantly because I tether my iPad for work. Is there a better way to keep it connected?',
      requiredAnchors: TrainingConstants.greetingRequiredAnchors,
      contextNotes: 'George uses his phone hotspot for his iPad. Adding a standalone tablet line costs 20 dollars monthly with unlimited data.',
      turns: const [
        // Turn 1: Mandatory Opening Greeting (Agent)
        ScenarioTurn(
          id: 'turn-24-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: _defaultAgentGreeting,
          requiredKeywords: ['att', 'alex', 'name'],
          trainerGuidanceArabic:
              'ابدأ بالتحية الإلزامية بصوت هادئ وواضح مع ذكر اسمك أليكس.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-24-02'),
          ],
        ),

        // Turn 2: Customer Initial Statement / Inquiry
        ScenarioTurn(
          id: 'turn-24-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Hello Alex, George Miller. My phone battery dies constantly because I tether my iPad for work. Is there a better way to keep it connected?',
          trainerGuidanceArabic: 'جورج بيستهلك بطارية موبايله في توزيع النت للآيباد. اعرض عليه إضافة خط تابلت مخصص غير محدود بـ 20 دولار في الشهر.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-24-03'),
          ],
        ),

        // Turn 3: Agent Core Explanation & AERD (Branch Point)
        ScenarioTurn(
          id: 'turn-24-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'I have the perfect solution, George. You can add a dedicated unlimited tablet plan to your account for just twenty dollars a month, saving your phone battery completely.',
          requiredKeywords: ['solution', 'unlimited', 'tablet', 'twenty'],
          trainerGuidanceArabic: 'قدم ميزة خط التابلت المستقل لتوفير البطارية.',
          branches: [
            ScenarioBranch(conditionKey: 'success', nextTurnId: 'turn-24-04A'),
            ScenarioBranch(conditionKey: 'low_aerd', nextTurnId: 'turn-24-04B'),
          ],
        ),

        // Turn 4A: Customer Satisfied / Understanding Response (High-AERD Success Path)
        ScenarioTurn(
          id: 'turn-24-04A',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Twenty dollars a month for unlimited cellular data on my iPad? That solves my battery problem entirely. Let\'s add that line!',
          trainerGuidanceArabic: 'العميل موافق ومتحمس للحل.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-24-05A'),
          ],
        ),

        // Turn 4B: Customer Pushback / Objection / Escalation (Low-AERD Path)
        ScenarioTurn(
          id: 'turn-24-04B',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Twenty dollars every month is two hundred forty a year just for internet on my iPad. I think I\'ll just carry a battery bank.',
          trainerGuidanceArabic: 'العميل شايف التكلفة السنوية. اعترف بحسابه المالي ووضح له قيمة الاتصال المستقل والإنتاجية أثناء السفر.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-24-05B'),
          ],
        ),

        // Turn 5A: Agent Professional Closing (High-AERD Terminal)
        ScenarioTurn(
          id: 'turn-24-05A',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Your new iPad line is added and ready for eSIM download, George! Enjoy seamless browsing without draining your phone battery!',
          requiredKeywords: ['added', 'ready', 'seamless', 'draining'],
          trainerGuidanceArabic: 'أكد تفعيل خط التابلت.',
          isFinal: true,
        ),

        // Turn 5B: Agent De-escalation & Recovery (Low-AERD Terminal)
        ScenarioTurn(
          id: 'turn-24-05B',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'I respect your smart cost calculation, George. If you only travel occasionally, the battery bank is great; but for daily client work without hotspot lag, the twenty dollars pays for itself in productivity.',
          requiredKeywords: ['respect', 'cost', 'hotspot', 'productivity'],
          trainerGuidanceArabic: 'احترم حسبته واشرح القيمة الإنتاجية.',
          isFinal: true,
        ),
      ],
      metadata: const ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes: 'George uses his phone hotspot for his iPad. Adding a standalone tablet line costs 20 dollars monthly with unlimited data.',
      ),
    ),
    // 25: Apple Watch Cellular & NumberSync Setup
    Scenario(
      id: 'scen-25-watch-numbersync',
      title: 'Apple Watch Cellular & NumberSync Setup',
      moduleIndex: 5,
      category: 'Technical Troubleshooting',
      difficulty: 'intermediate',
      customerPersona: 'Lisa Ray (Customer Inquiring on Wearable Sync)',
      skillTags: const ['NumberSync', 'Wearable', 'Technical'],
      expectedResponse: _defaultAgentGreeting,
      customerResponse: 'Hi Alex, Lisa Ray here. If I leave my iPhone at home when I go for a run, will my new Apple Watch still ring with my normal number?',
      requiredAnchors: TrainingConstants.greetingRequiredAnchors,
      contextNotes: 'Lisa got an Apple Watch Cellular and wants it to share her iPhone\'s phone number when she runs without her phone.',
      turns: const [
        // Turn 1: Mandatory Opening Greeting (Agent)
        ScenarioTurn(
          id: 'turn-25-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: _defaultAgentGreeting,
          requiredKeywords: ['att', 'alex', 'name'],
          trainerGuidanceArabic:
              'ابدأ بالتحية الإلزامية بصوت هادئ وواضح مع ذكر اسمك أليكس.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-25-02'),
          ],
        ),

        // Turn 2: Customer Initial Statement / Inquiry
        ScenarioTurn(
          id: 'turn-25-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Hi Alex, Lisa Ray here. If I leave my iPhone at home when I go for a run, will my new Apple Watch still ring with my normal number?',
          trainerGuidanceArabic: 'ليزا بتسأل عن تشغيل الساعة بدون الموبايل في الجري. اشرح لها تقنية NumberSync واشتراك الساعة 10.99 دولار شهرياً.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-25-03'),
          ],
        ),

        // Turn 3: Agent Core Explanation & AERD (Branch Point)
        ScenarioTurn(
          id: 'turn-25-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'Yes it will, Lisa! With our NumberSync technology, your Apple Watch shares your exact mobile number for calls and texts even when miles away from your phone.',
          requiredKeywords: ['numbersync', 'shares', 'mobile', 'number'],
          trainerGuidanceArabic: 'اشرح لها تقنية NumberSync الموحدة للرقم.',
          branches: [
            ScenarioBranch(conditionKey: 'success', nextTurnId: 'turn-25-04A'),
            ScenarioBranch(conditionKey: 'low_aerd', nextTurnId: 'turn-25-04B'),
          ],
        ),

        // Turn 4A: Customer Satisfied / Understanding Response (High-AERD Success Path)
        ScenarioTurn(
          id: 'turn-25-04A',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'That is exactly what I wanted. So I can run with just my watch and AirPods and never miss an emergency call! Sign me up.',
          trainerGuidanceArabic: 'العميلة وافقت ومبسوطة جداً.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-25-05A'),
          ],
        ),

        // Turn 4B: Customer Pushback / Objection / Escalation (Low-AERD Path)
        ScenarioTurn(
          id: 'turn-25-04B',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Wait, do I have to pay an extra monthly plan fee for a watch that is just mirroring my phone?',
          trainerGuidanceArabic: 'العميلة معترضة على الرسوم الشهرية للساعة. وضح لها إن الساعة بتستخدم شريحة خلوية مستقلة متصلة بأبراج المحمول.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-25-05B'),
          ],
        ),

        // Turn 5A: Agent Professional Closing (High-AERD Terminal)
        ScenarioTurn(
          id: 'turn-25-05A',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'NumberSync is enabled on your watch line, Lisa! Go enjoy that run with complete peace of mind. Thank you for choosing AT&T!',
          requiredKeywords: ['enabled', 'watch', 'peace', 'choosing'],
          trainerGuidanceArabic: 'أغلق بود واحترافية.',
          isFinal: true,
        ),

        // Turn 5B: Agent De-escalation & Recovery (Low-AERD Terminal)
        ScenarioTurn(
          id: 'turn-25-05B',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'I hear your question, Lisa. The ten dollar monthly plan provides dedicated cellular tower connectivity so your watch functions as a standalone phone even if your iPhone is turned off.',
          requiredKeywords: ['hear', 'question', 'cellular', 'standalone'],
          trainerGuidanceArabic: 'اشرح لها ميزة العمل المستقل بدون الموبايل.',
          isFinal: true,
        ),
      ],
      metadata: const ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes: 'Lisa got an Apple Watch Cellular and wants it to share her iPhone\'s phone number when she runs without her phone.',
      ),
    ),
    // 26: Senior Account Bill Audit & Value Optimization
    Scenario(
      id: 'scen-26-senior-plan-review',
      title: 'Senior Account Bill Audit & Value Optimization',
      moduleIndex: 5,
      category: 'Billing & Payments',
      difficulty: 'intermediate',
      customerPersona:
          'Walter Jenkins (Retired Senior Reviewing Household Expenses)',
      skillTags: const ['Bill Audit', 'Senior Care', 'AERD'],
      expectedResponse: _defaultAgentGreeting,
      customerResponse: 'Hello Alex, Walter Jenkins. I am on a fixed pension and my monthly cell bill keeps going up. Can you look at my account and see if I\'m paying for things I don\'t need?',
      requiredAnchors: TrainingConstants.greetingRequiredAnchors,
      contextNotes: 'Walter is on an old shared data plan paying 135 dollars for 2 lines. Moving to current pricing reduces bill to 110 dollars.',
      turns: const [
        // Turn 1: Mandatory Opening Greeting (Agent)
        ScenarioTurn(
          id: 'turn-26-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: _defaultAgentGreeting,
          requiredKeywords: ['att', 'alex', 'name'],
          trainerGuidanceArabic:
              'ابدأ بالتحية الإلزامية بصوت هادئ وواضح مع ذكر اسمك أليكس.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-26-02'),
          ],
        ),

        // Turn 2: Customer Initial Statement / Inquiry
        ScenarioTurn(
          id: 'turn-26-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Hello Alex, Walter Jenkins. I am on a fixed pension and my monthly cell bill keeps going up. Can you look at my account and see if I\'m paying for things I don\'t need?',
          trainerGuidanceArabic: 'والتر عميل متقاعد عاوزه مراجعة لفاتورته لتقليل المصاريف. اعمل له فحص كامل للحساب واقترح الانتقال لخطة أحدث توفر له 25 دولار شهرياً.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-26-03'),
          ],
        ),

        // Turn 3: Agent Core Explanation & AERD (Branch Point)
        ScenarioTurn(
          id: 'turn-26-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'I would be glad to help you audit your expenses, Walter. Looking at your plan, you are on an older legacy tier; switching to our current rates saves you twenty-five dollars every month.',
          requiredKeywords: ['glad', 'audit', 'legacy', 'saves'],
          trainerGuidanceArabic: 'اعرض عليه خطة التوفير الجديدة.',
          branches: [
            ScenarioBranch(conditionKey: 'success', nextTurnId: 'turn-26-04A'),
            ScenarioBranch(conditionKey: 'low_aerd', nextTurnId: 'turn-26-04B'),
          ],
        ),

        // Turn 4A: Customer Satisfied / Understanding Response (High-AERD Success Path)
        ScenarioTurn(
          id: 'turn-26-04A',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Save twenty-five dollars a month without losing my service? That helps my monthly grocery budget tremendously, Alex. Please do that.',
          trainerGuidanceArabic: 'والتر مبسوط جداً بالتوفير المالي.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-26-05A'),
          ],
        ),

        // Turn 4B: Customer Pushback / Objection / Escalation (Low-AERD Path)
        ScenarioTurn(
          id: 'turn-26-04B',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Will this new plan lock me into a two-year contract? I don\'t want any penalties if I need to cancel later.',
          trainerGuidanceArabic: 'والتر قلقان من عقود الاحتكار. طمنه بإن الخطط الجديدة مفيهاش عقود خدمة سنوية ويمكن إلغاؤها في أي وقت.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-26-05B'),
          ],
        ),

        // Turn 5A: Agent Professional Closing (High-AERD Terminal)
        ScenarioTurn(
          id: 'turn-26-05A',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Your account is updated to the new lower rate, Walter! You will see the twenty-five dollar savings on your very next statement. It was an honor helping you today!',
          requiredKeywords: ['updated', 'savings', 'statement', 'honor'],
          trainerGuidanceArabic: 'أغلق المكالمة بود واحترام.',
          isFinal: true,
        ),

        // Turn 5B: Agent De-escalation & Recovery (Low-AERD Terminal)
        ScenarioTurn(
          id: 'turn-26-05B',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Rest assured, Walter: modern plans have zero service contracts. You have total freedom to change or cancel anytime without penalties. You just get the twenty-five dollar monthly savings.',
          requiredKeywords: ['rest', 'contracts', 'freedom', 'savings'],
          trainerGuidanceArabic: 'أكد عدم وجود عقود احتكارية.',
          isFinal: true,
        ),
      ],
      metadata: const ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes: 'Walter is on an old shared data plan paying 135 dollars for 2 lines. Moving to current pricing reduces bill to 110 dollars.',
      ),
    ),
    // 27: Prepaid to Postpaid Wireless Migration
    Scenario(
      id: 'scen-27-prepaid-to-postpaid',
      title: 'Prepaid to Postpaid Wireless Migration',
      moduleIndex: 5,
      category: 'Plan Upgrade & Features',
      difficulty: 'intermediate',
      customerPersona:
          'Maria Santos (Prepaid Customer Wanting Device Financing)',
      skillTags: const ['Migration', 'Prepaid to Postpaid', 'Financing'],
      expectedResponse: _defaultAgentGreeting,
      customerResponse: 'Hi Alex, Maria Santos. I have had prepaid for two years, but I want to get the new Samsung on monthly installments. Can I switch without losing my number?',
      requiredAnchors: TrainingConstants.greetingRequiredAnchors,
      contextNotes: 'Maria has been on AT&T Prepaid for 2 years and wants to finance a new phone with 0 dollars down on postpaid.',
      turns: const [
        // Turn 1: Mandatory Opening Greeting (Agent)
        ScenarioTurn(
          id: 'turn-27-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: _defaultAgentGreeting,
          requiredKeywords: ['att', 'alex', 'name'],
          trainerGuidanceArabic:
              'ابدأ بالتحية الإلزامية بصوت هادئ وواضح مع ذكر اسمك أليكس.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-27-02'),
          ],
        ),

        // Turn 2: Customer Initial Statement / Inquiry
        ScenarioTurn(
          id: 'turn-27-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Hi Alex, Maria Santos. I have had prepaid for two years, but I want to get the new Samsung on monthly installments. Can I switch without losing my number?',
          trainerGuidanceArabic: 'ماريا عميلة بريبيد عاوزة تحول لنظام الفاتورة الشهرية عشان تقسط تليفون جديد بدون تغيير الرقم. اشرح لها خطوات الـ Migration والاحتفاظ برقمها.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-27-03'),
          ],
        ),

        // Turn 3: Agent Core Explanation & AERD (Branch Point)
        ScenarioTurn(
          id: 'turn-27-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'Welcome to postpaid, Maria! You keep your exact phone number, and your two years of on-time payments qualify you for zero-down installment financing today.',
          requiredKeywords: ['welcome', 'postpaid', 'number', 'qualify'],
          trainerGuidanceArabic:
              'رحب بيها في البوست بيد واشرح ميزة التقسيط بصفر مقدم.',
          branches: [
            ScenarioBranch(conditionKey: 'success', nextTurnId: 'turn-27-04A'),
            ScenarioBranch(conditionKey: 'low_aerd', nextTurnId: 'turn-27-04B'),
          ],
        ),

        // Turn 4A: Customer Satisfied / Understanding Response (High-AERD Success Path)
        ScenarioTurn(
          id: 'turn-27-04A',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Zero down payment? That is amazing! And my number stays exactly the same? Let\'s get the phone ordered!',
          trainerGuidanceArabic: 'العميلة وافقت ومتحمسة جداً.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-27-05A'),
          ],
        ),

        // Turn 4B: Customer Pushback / Objection / Escalation (Low-AERD Path)
        ScenarioTurn(
          id: 'turn-27-04B',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Wait, does switching to postpaid require a hard credit check that will drop my credit score?',
          trainerGuidanceArabic: 'العميلة قلقانة من الفحص الائتماني (Credit Check). وضح لها إن تاريخ التزامها في البريبيد لمدة سنتين بيسهل الموافقة الداخلية الميسرة.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-27-05B'),
          ],
        ),

        // Turn 5A: Agent Professional Closing (High-AERD Terminal)
        ScenarioTurn(
          id: 'turn-27-05A',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Your migration is complete and your new phone is ordered with zero down, Maria! Welcome to the postpaid family!',
          requiredKeywords: ['migration', 'complete', 'ordered', 'welcome'],
          trainerGuidanceArabic: 'أكد نجاح التحويل والطلب.',
          isFinal: true,
        ),

        // Turn 5B: Agent De-escalation & Recovery (Low-AERD Terminal)
        ScenarioTurn(
          id: 'turn-27-05B',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'I completely understand your credit concern, Maria. Because you have two years of spotless prepaid history with us, we utilize your verified internal tenure, protecting your credit score.',
          requiredKeywords: ['completely', 'credit', 'tenure', 'protecting'],
          trainerGuidanceArabic:
              'طمنها بالاعتماد على تاريخها الداخلي لحماية نقاطها الائتمانية.',
          isFinal: true,
        ),
      ],
      metadata: const ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes: 'Maria has been on AT&T Prepaid for 2 years and wants to finance a new phone with 0 dollars down on postpaid.',
      ),
    ),
    // 28: FirstNet First Responder Appreciation & Verification
    Scenario(
      id: 'scen-28-firstnet-appreciation',
      title: 'FirstNet First Responder Appreciation & Verification',
      moduleIndex: 5,
      category: 'Plan Upgrade & Features',
      difficulty: 'intermediate',
      customerPersona:
          'Officer James Kelly (Police Officer Inquiring on Discount)',
      skillTags: const ['FirstNet', 'First Responder', 'Verification'],
      expectedResponse: _defaultAgentGreeting,
      customerResponse: 'Alex, Officer James Kelly. A sergeant in my precinct told me AT&T has a special dedicated network for first responders called FirstNet. What is that about?',
      requiredAnchors: TrainingConstants.greetingRequiredAnchors,
      contextNotes: 'Officer Kelly is an active duty police officer inquiring about FirstNet priority network access.',
      turns: const [
        // Turn 1: Mandatory Opening Greeting (Agent)
        ScenarioTurn(
          id: 'turn-28-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: _defaultAgentGreeting,
          requiredKeywords: ['att', 'alex', 'name'],
          trainerGuidanceArabic:
              'ابدأ بالتحية الإلزامية بصوت هادئ وواضح مع ذكر اسمك أليكس.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-28-02'),
          ],
        ),

        // Turn 2: Customer Initial Statement / Inquiry
        ScenarioTurn(
          id: 'turn-28-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Alex, Officer James Kelly. A sergeant in my precinct told me AT&T has a special dedicated network for first responders called FirstNet. What is that about?',
          trainerGuidanceArabic: 'الضابط كيلي بيسأل عن شبكة FirstNet المخصصة للمستجيبين الأوائل. اشكره على خدمته واشرح له أولوية الشبكة Band 14 والخصومات المخصصة.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-28-03'),
          ],
        ),

        // Turn 3: Agent Core Explanation & AERD (Branch Point)
        ScenarioTurn(
          id: 'turn-28-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'First and foremost, Officer Kelly, thank you for your service in the community. FirstNet gives first responders priority cellular access on Band 14 that never slows during emergencies, plus significant discounts.',
          requiredKeywords: ['service', 'firstnet', 'priority', 'emergencies'],
          trainerGuidanceArabic: 'اشكره على خدمته واشرح ميزة Band 14 للطوارئ.',
          branches: [
            ScenarioBranch(conditionKey: 'success', nextTurnId: 'turn-28-04A'),
            ScenarioBranch(conditionKey: 'low_aerd', nextTurnId: 'turn-28-04B'),
          ],
        ),

        // Turn 4A: Customer Satisfied / Understanding Response (High-AERD Success Path)
        ScenarioTurn(
          id: 'turn-28-04A',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'True priority during emergencies is huge for our tactical comms. What do I need to submit to verify my badge and switch over?',
          trainerGuidanceArabic: 'الضابط مهتم جداً بأولوية الاتصال في الطوارئ. وضح له خطوات رفع بطاقة العمل أو شارة الشرطة للتحقق.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-28-05A'),
          ],
        ),

        // Turn 4B: Customer Pushback / Objection / Escalation (Low-AERD Path)
        ScenarioTurn(
          id: 'turn-28-04B',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Is this going to disconnect my family members who are currently sharing my consumer plan?',
          trainerGuidanceArabic: 'الضابط قلقان على خطوط عائلته. طمنه بإن عائلته بتفضل على خطة عائلية مخصصة بخصم 25% إضافي لمجرد وجوده على FirstNet.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-28-05B'),
          ],
        ),

        // Turn 5A: Agent Professional Closing (High-AERD Terminal)
        ScenarioTurn(
          id: 'turn-28-05A',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Your FirstNet profile is initialized, Officer Kelly! Upload a photo of your department ID at the link we texted, and thank you again for keeping us safe!',
          requiredKeywords: ['profile', 'upload', 'safe', 'thank'],
          trainerGuidanceArabic: 'أنهِ المكالمة بتقدير رسمي.',
          isFinal: true,
        ),

        // Turn 5B: Agent De-escalation & Recovery (Low-AERD Terminal)
        ScenarioTurn(
          id: 'turn-28-05B',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Not at all, Officer Kelly! Your line moves to FirstNet priority, and your family stays together with an exclusive twenty-five percent discount on their unlimited lines.',
          requiredKeywords: ['priority', 'family', 'discount', 'lines'],
          trainerGuidanceArabic: 'طمنه بخصم 25% لعائلته بالكامل.',
          isFinal: true,
        ),
      ],
      metadata: const ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes: 'Officer Kelly is an active duty police officer inquiring about FirstNet priority network access.',
      ),
    ),
    // 29: Dead Air Protocol & Silent Caller Management
    Scenario(
      id: 'scen-29-dead-air-protocol',
      title: 'Dead Air Protocol & Silent Caller Management',
      moduleIndex: 5,
      category: 'Clarification & Listening',
      difficulty: 'advanced',
      customerPersona:
          'Silent Caller (Elderly or Distracted Customer on Open Line)',
      skillTags: const ['Dead Air', 'Call Control', 'Protocol'],
      expectedResponse: _defaultAgentGreeting,
      customerResponse:
          '... [Faint breathing and distant paper rustling, no speech] ...',
      requiredAnchors: TrainingConstants.greetingRequiredAnchors,
      contextNotes: 'The call connects but only faint rustling or silence is heard. The agent must deliver professional dead-air check-ins before disconnecting.',
      turns: const [
        // Turn 1: Mandatory Opening Greeting (Agent)
        ScenarioTurn(
          id: 'turn-29-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: _defaultAgentGreeting,
          requiredKeywords: ['att', 'alex', 'name'],
          trainerGuidanceArabic:
              'ابدأ بالتحية الإلزامية بصوت هادئ وواضح مع ذكر اسمك أليكس.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-29-02'),
          ],
        ),

        // Turn 2: Customer Initial Statement / Inquiry
        ScenarioTurn(
          id: 'turn-29-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText:
              '... [Faint breathing and distant paper rustling, no speech] ...',
          trainerGuidanceArabic: 'الخط مفتوح وفيه صوت هواء أو أوراق بس مفيش كلام. طبق بروتوكول Dead Air الرسمي: عرف بنفسك بوضوح واسأل إذا كان العميل سامعك قبل ما تقفل.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-29-03'),
          ],
        ),

        // Turn 3: Agent Core Explanation & AERD (Branch Point)
        ScenarioTurn(
          id: 'turn-29-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'Hello? This is Alex with AT&T. I have an open line but cannot hear you speaking. If you can hear me, please go ahead, I am right here to help.',
          requiredKeywords: ['hello', 'alex', 'open', 'help'],
          trainerGuidanceArabic: 'طبق بروتوكول الـ Dead Air باحترافية.',
          branches: [
            ScenarioBranch(conditionKey: 'success', nextTurnId: 'turn-29-04A'),
            ScenarioBranch(conditionKey: 'low_aerd', nextTurnId: 'turn-29-04B'),
          ],
        ),

        // Turn 4A: Customer Satisfied / Understanding Response (High-AERD Success Path)
        ScenarioTurn(
          id: 'turn-29-04A',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Oh! Hello! Forgive me Alex, I was fumbling with my headset and didn\'t realize the call connected! I need help checking my balance.',
          trainerGuidanceArabic: 'العميل انتبه واعتذر إنه كان بيظبط السماعة.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-29-05A'),
          ],
        ),

        // Turn 4B: Customer Pushback / Objection / Escalation (Low-AERD Path)
        ScenarioTurn(
          id: 'turn-29-04B',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: '... [Continued complete silence for fifteen seconds after second prompt] ...',
          trainerGuidanceArabic: 'الخط لسه صامت تماماً. طبق رسالة الإغلاق الرسمية للخط المفتوح بدون إنهاء فجائي.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-29-05B'),
          ],
        ),

        // Turn 5A: Agent Professional Closing (High-AERD Terminal)
        ScenarioTurn(
          id: 'turn-29-05A',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'No problem at all, I am glad we are connected! Let us look at that balance for you right away.',
          requiredKeywords: ['problem', 'glad', 'balance', 'away'],
          trainerGuidanceArabic: 'أكمل المكالمة بسلاسة.',
          isFinal: true,
        ),

        // Turn 5B: Agent De-escalation & Recovery (Low-AERD Terminal)
        ScenarioTurn(
          id: 'turn-29-05B',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'I am unable to hear you at this time. I will disconnect this call to clear the line, but please call us back anytime or visit us online at att.com. Thank you for calling AT&T.',
          requiredKeywords: ['unable', 'disconnect', 'anytime', 'thank'],
          trainerGuidanceArabic:
              'أغلق الخط بالصيغة الرسمية لبروتوكول الـ Dead Air.',
          isFinal: true,
        ),
      ],
      metadata: const ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes: 'The call connects but only faint rustling or silence is heard. The agent must deliver professional dead-air check-ins before disconnecting.',
      ),
    ),
    // 30: Skeptical Prospect Conversion & Fiber Guarantee
    Scenario(
      id: 'scen-30-skeptical-closer',
      title: 'Skeptical Prospect Conversion & Fiber Guarantee',
      moduleIndex: 5,
      category: 'Plan Upgrade & Features',
      difficulty: 'advanced',
      customerPersona: 'Gregory Stone (Tough Competitor Cable Subscriber)',
      skillTags: const ['Objection Handling', 'Closing', 'Value'],
      expectedResponse: _defaultAgentGreeting,
      customerResponse: 'Alex, Gregory Stone. I\'m sick of cable raising my bill twenty dollars every six months. You guys claim your fiber price is straightforward, but every telecom lies. Prove me wrong.',
      requiredAnchors: TrainingConstants.greetingRequiredAnchors,
      contextNotes: 'Gregory has cable internet and hates cable bill hikes. He wants fiber but doesn\'t trust price promises.',
      turns: const [
        // Turn 1: Mandatory Opening Greeting (Agent)
        ScenarioTurn(
          id: 'turn-30-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: _defaultAgentGreeting,
          requiredKeywords: ['att', 'alex', 'name'],
          trainerGuidanceArabic:
              'ابدأ بالتحية الإلزامية بصوت هادئ وواضح مع ذكر اسمك أليكس.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-30-02'),
          ],
        ),

        // Turn 2: Customer Initial Statement / Inquiry
        ScenarioTurn(
          id: 'turn-30-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Alex, Gregory Stone. I\'m sick of cable raising my bill twenty dollars every six months. You guys claim your fiber price is straightforward, but every telecom lies. Prove me wrong.',
          trainerGuidanceArabic: 'جريجوري متضايق من زيادات شركات الكيبل ومش واثق في أي شركة اتصالات. اثبت له مصداقية AT&T Fiber: سرعات متماثلة، بدون عقود سنوية، بدون رسوم تأجير راوتر، وبسعر ثابت وواضح.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-30-03'),
          ],
        ),

        // Turn 3: Agent Core Explanation & AERD (Branch Point)
        ScenarioTurn(
          id: 'turn-30-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'I completely understand your skepticism, Gregory. Cable plays pricing games. AT&T Fiber has no annual contract, equipment fees are included, and what you see is your straightforward monthly price.',
          requiredKeywords: [
            'understand',
            'skepticism',
            'contract',
            'straightforward',
          ],
          trainerGuidanceArabic:
              'اعترف بتجاربه السابقة واشرح مزايا الشفافية في الفايبر.',
          branches: [
            ScenarioBranch(conditionKey: 'success', nextTurnId: 'turn-30-04A'),
            ScenarioBranch(conditionKey: 'low_aerd', nextTurnId: 'turn-30-04B'),
          ],
        ),

        // Turn 4A: Customer Satisfied / Understanding Response (High-AERD Success Path)
        ScenarioTurn(
          id: 'turn-30-04A',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'No equipment fees and no annual contract? That is genuinely different from what cable pulls on me. Let\'s install it next Tuesday.',
          trainerGuidanceArabic: 'جريجوري اقتنع بوضوح العرض وقرر الاشتراك.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-30-05A'),
          ],
        ),

        // Turn 4B: Customer Pushback / Objection / Escalation (Low-AERD Path)
        ScenarioTurn(
          id: 'turn-30-04B',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Straightforward price? I read online your price goes up after twelve months just like everyone else!',
          trainerGuidanceArabic: 'جريجوري لسه شاكك في زيادة بعد سنة. وضح له إن خطط الفايبر الحالية مفيهاش زيادة تلقائية بعد 12 شهر زي عروض زمان.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-30-05B'),
          ],
        ),

        // Turn 5A: Agent Professional Closing (High-AERD Terminal)
        ScenarioTurn(
          id: 'turn-30-05A',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'You made a fantastic choice, Gregory! Fiber installation is locked for next Tuesday at eight AM. Welcome to transparent, blazing-fast internet!',
          requiredKeywords: ['choice', 'locked', 'tuesday', 'welcome'],
          trainerGuidanceArabic: 'أكد الموعد واشكره.',
          isFinal: true,
        ),

        // Turn 5B: Agent De-escalation & Recovery (Low-AERD Terminal)
        ScenarioTurn(
          id: 'turn-30-05B',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'I hear you, Gregory, but that was the old industry standard years ago. Today\'s AT&T Fiber plans have zero expiring promotional discounts, meaning no automatic price jump at month twelve.',
          requiredKeywords: ['hear', 'standard', 'expiring', 'jump'],
          trainerGuidanceArabic:
              'اشرح التغيير في سياسة التسعير الحديثة ونفي الزيادة التلقائية.',
          isFinal: true,
        ),
      ],
      metadata: const ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes: 'Gregory has cable internet and hates cable bill hikes. He wants fiber but doesn\'t trust price promises.',
      ),
    ),
  ];

  static List<String> get allSkillTags {
    final tags = <String>{};
    for (final s in allScenarios) {
      tags.addAll(s.skillTags);
    }
    return tags.toList()..sort();
  }

  static Scenario? findById(String id) {
    try {
      return allScenarios.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }
}
