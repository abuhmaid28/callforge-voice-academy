import '../../core/constants/training_constants.dart';
import '../../core/models/provenance.dart';
import '../../domain/entities/scenario.dart';

/// Complete catalog of 30 fictional customer service and sales training scenarios.
/// Grounded in realistic floor skills, AERD de-escalation, discovery, and disclosures.
/// Explicitly labeled [Fictional / Simulation Only] — strictly for practice purposes.
class ScenarioCatalog {
  static const String _defaultAgentGreeting =
      'Hello, thank you for calling AT&T. This is Alex. May I have your first and last name, please?';

  static final List<Scenario> allScenarios = [
    // 01: Proration / First Bill Shock
    Scenario(
      id: 'scen-01-first-bill',
      title: 'First Bill Proration & Partial Month Charges',
      moduleIndex: 1,
      category: 'Billing & Payments',
      difficulty: 'beginner',
      customerPersona: 'Marcus Vance (Confused New Wireless Customer)',
      skillTags: const ['Proration', 'First Bill', 'AERD'],
      expectedResponse: _defaultAgentGreeting,
      customerResponse: 'Hi Alex, my name is Marcus Vance. I just opened two lines and my first bill is almost 220 dollars! The store told me it would be 140! Why is it so high?',
      requiredAnchors: TrainingConstants.greetingRequiredAnchors,
      contextNotes: 'Marcus switched 2 lines 8 days into the billing cycle. The first bill reflects 22 days of prorated service plus the upcoming month in advance, plus one-time activation fees.',
      turns: const [
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
        ScenarioTurn(
          id: 'turn-01-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'I completely understand your surprise, Marcus. Let me look right into your bill breakdown so you know exactly what is charged and when your ongoing rate applies.',
          requiredKeywords: ['understand', 'look', 'bill', 'breakdown'],
          trainerGuidanceArabic: 'استخدم أسلوب التطمين واشرح الفرق بين رسوم أول شهر والرسوم الثابتة القادمة.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-01-04'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-01-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Okay, so part of this is for the first few days before my official cycle, plus next month in advance? That makes sense. Will my next bill actually be 140 dollars?',
          trainerGuidanceArabic: 'العميل بدأ يفهم. أكد له على السعر الشهري الدائم واقترح تفعيل الخصومات المتاحة زي AutoPay.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-01-05'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-01-05',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Exactly, Marcus. Once your AutoPay discount applies, your regular monthly bill will be 140 dollars. Is there anything else I can assist you with today?',
          requiredKeywords: ['autopay', 'regular', 'assist'],
          trainerGuidanceArabic:
              'أنهِ المكالمة باحترافية وتأكد إن كل استفساراته تم حلها.',
          isFinal: true,
        ),
      ],
      metadata: const ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes: 'Fictional bill shock scenario for proration and AERD empathy.',
      ),
    ),

    // 02: Trade-in Bill Credits
    Scenario(
      id: 'scen-02-tradein-credits',
      title: 'Trade-In Promotional Bill Credits Timing',
      moduleIndex: 1,
      category: 'Billing & Payments',
      difficulty: 'intermediate',
      customerPersona: 'Sarah Jenkins (Anxious Upgrading Customer)',
      skillTags: const ['Trade-In', 'Bill Credits', 'Pacing'],
      expectedResponse: _defaultAgentGreeting,
      customerResponse: 'Hello Alex, Sarah Jenkins here. I mailed in my old Galaxy two weeks ago for an 800-dollar trade-in promo, but my bill is charging me the full phone installment! Where is my credit?',
      requiredAnchors: TrainingConstants.greetingRequiredAnchors,
      contextNotes: 'Promotional trade-in credits take 2 to 3 billing cycles to appear following device receipt and warehouse inspection, with retroactive catch-up credits on the first applied bill.',
      turns: const [
        ScenarioTurn(
          id: 'turn-02-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: _defaultAgentGreeting,
          requiredKeywords: ['att', 'alex', 'name'],
          trainerGuidanceArabic:
              'رحب بسارة بوضوح واستمع لقلقها بخصوص جهاز الترايد إن.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-02-02'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-02-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'I sent my trade-in two weeks ago, but my bill has no credit! Am I going to be stuck paying the full price every month?',
          trainerGuidanceArabic: 'طمن سارة واشرح لها إن رصيد الترايد إن بيحتاج من دورتين لثلاث دورات فواتير عشان ينزل على الفاتورة، وأول ما ينزل بياخد الفترات بأثر رجعي.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-02-03'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-02-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'I understand your concern, Sarah. Trade-in promotional credits typically take two to three billing cycles to appear after inspection, and you will receive a catch-up credit covering the prior months.',
          requiredKeywords: [
            'two',
            'three',
            'billing cycles',
            'credit',
            'catch-up',
          ],
          trainerGuidanceArabic: 'تأكد من نطق Billing Cycles و Catch-up credit بوضوح وبدون لبس P/B.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-02-04'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-02-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Oh, so once it kicks in, it credits back the months I paid? That gives me peace of mind, Alex. Thank you!',
          trainerGuidanceArabic:
              'العميل ارتاح. وثق رقم التتبع لو متاح واختم المكالمة.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-02-05'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-02-05',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'You are very welcome, Sarah! I have noted your account with the trade-in tracking number. Thank you for choosing AT&T and have a wonderful day!',
          requiredKeywords: ['welcome', 'noted', 'thank you'],
          trainerGuidanceArabic:
              'أنهِ المكالمة بلباقة واحترافية وتأكد من توثيق كل تفاصيل الشحن.',
          isFinal: true,
        ),
      ],
      metadata: const ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes: 'Simulated 36-month trade-in promotion billing timeline.',
      ),
    ),

    // 03: International Roaming Day Pass
    Scenario(
      id: 'scen-03-intl-roaming',
      title: 'International Day Pass Charges & Feature Explanation',
      moduleIndex: 1,
      category: 'Billing & Payments',
      difficulty: 'intermediate',
      customerPersona: 'David Miller (Business Traveler)',
      skillTags: const ['Roaming', 'International Day Pass', 'De-escalation'],
      expectedResponse: _defaultAgentGreeting,
      customerResponse: 'Alex, my name is David Miller. I just got back from a business trip in London and I see ten charges of twelve dollars each labeled International Day Pass. Can you tell me what this is?',
      requiredAnchors: TrainingConstants.greetingRequiredAnchors,
      contextNotes: 'International Day Pass provides unlimited talk, text, and high-speed data in over 210 destinations for \$12/day on the first line (\$6/day for additional lines on same calendar day), capped at 10 daily fees per bill cycle.',
      turns: const [
        ScenarioTurn(
          id: 'turn-03-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: _defaultAgentGreeting,
          requiredKeywords: ['att', 'alex', 'name'],
          trainerGuidanceArabic:
              'التحية القياسية واستقبال سؤال ديفيد عن باقة السفر الدولي.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-03-02'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-03-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Why do I have 120 dollars in International Day Pass fees? Nobody told me about this daily fee!',
          trainerGuidanceArabic: 'اشرح ميزة International Day Pass وإنها حمت حسابه من رسوم التجوال المفتوح (Pay-per-use) اللي كانت ممكن توصل لآلاف الدولارات، وإنها بحد أقصى 10 أيام في الشهر.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-03-03'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-03-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'I hear you, David. The International Day Pass activates only on days you use cellular data abroad, giving you full plan access for twelve dollars a day and capping charges at ten days per billing cycle.',
          requiredKeywords: [
            'international day pass',
            'twelve dollars',
            'cap',
            'ten days',
          ],
          trainerGuidanceArabic: 'وضح الأرقام بدقة: 12 دولار في اليوم وكاب 10 أيام في دورة الفاتورة.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-03-04'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-03-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Wait, so without that pass I would have paid standard international roaming rates per megabyte? Wow, that could have been thousands. Thanks for explaining, Alex.',
          trainerGuidanceArabic: 'العميل قدر القيمة. أكد له إن الخدمة بتفضل متفعلة لرحلاته القادمة بدون رسوم طول ما هو جوه أمريكا.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-03-05'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-03-05',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Exactly, David. It stays on your account for free and only triggers when you travel outside the country. Enjoy your week!',
          requiredKeywords: ['account', 'travel', 'welcome'],
          isFinal: true,
        ),
      ],
      metadata: const ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes: 'Fictional international roaming feature value breakdown.',
      ),
    ),

    // 04: Throttled Data vs Network Congestion
    Scenario(
      id: 'scen-04-data-throttle',
      title: 'Premium Data Threshold vs Temporary Congestion',
      moduleIndex: 1,
      category: 'Technical Care',
      difficulty: 'intermediate',
      customerPersona: 'Tyler Reed (Frustrated Mobile Streamer)',
      skillTags: const ['Network', 'Unlimited Plan', 'AERD'],
      expectedResponse: _defaultAgentGreeting,
      customerResponse: 'Alex, my name is Tyler Reed. My internet on my phone has slowed to a crawl since yesterday. I pay for unlimited, so why are you guys throttling my speeds?',
      requiredAnchors: TrainingConstants.greetingRequiredAnchors,
      contextNotes: 'Tyler is on Unlimited Starter which may temporarily slow during network congestion, unlike Unlimited Premium which offers unlimited high-speed data that cannot be slowed based on usage.',
      turns: const [
        ScenarioTurn(
          id: 'turn-04-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: _defaultAgentGreeting,
          requiredKeywords: ['att', 'alex', 'name'],
          trainerGuidanceArabic: 'استقبل تايلر بهدوء وحافظ على نبرة احترافية.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-04-02'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-04-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'My video streams keep buffering! I am on an unlimited plan! Why am I being throttled?',
          trainerGuidanceArabic: 'اشرح الفرق بين الـ Throttling والـ Network Congestion على خطة Starter، واعرض عليه الترقية لخطة Premium بدون إجبار.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-04-03'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-04-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'I understand how frustrating buffering is, Tyler. Your current plan includes unlimited data with temporary speed adjustments only during peak tower congestion. Let us test your connection together.',
          requiredKeywords: ['understand', 'congestion', 'plan', 'test'],
          trainerGuidanceArabic: 'قدم Empathy حقيقي واقترح فحص الشبكة معاه.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-04-04'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-04-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'I see. So it is local tower traffic right now? How much would it be to move up to the plan that never slows down?',
          trainerGuidanceArabic: 'فرصة لاكتشاف المبيعات (Sales Discovery)! وضح فرق السعر البسيط لخطة Premium.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-04-05'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-04-05',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Moving up to Unlimited Premium is just ten dollars more per month, giving you completely unthrottled high-speed data and sixty gigabytes of mobile hotspot.',
          requiredKeywords: ['premium', 'ten dollars', 'hotspot'],
          isFinal: true,
        ),
      ],
      metadata: const ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes: 'Fictional unlimited tier comparison and network congestion clarification.',
      ),
    ),

    // 05: Fiber Gateway Red Blinking Light
    Scenario(
      id: 'scen-05-gateway-redlight',
      title: 'Fiber Wi-Fi Gateway Red Broadband Light Troubleshooting',
      moduleIndex: 2,
      category: 'Technical Care',
      difficulty: 'intermediate',
      customerPersona: 'Linda Green (Remote Worker in a Rush)',
      skillTags: const ['Troubleshooting', 'Fiber Gateway', 'Call Control'],
      expectedResponse: _defaultAgentGreeting,
      customerResponse: 'Alex, my name is Linda Green. I have an important Zoom meeting in thirty minutes and my home Wi-Fi is completely dead! The light on the AT&T box is blinking red! Help me fix this immediately!',
      requiredAnchors: TrainingConstants.greetingRequiredAnchors,
      contextNotes: 'A flashing red broadband/optical light indicates a physical fiber signal loss between the optical wall jack and the gateway or an upstream fiber outage.',
      turns: const [
        ScenarioTurn(
          id: 'turn-05-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: _defaultAgentGreeting,
          requiredKeywords: ['att', 'alex', 'name'],
          trainerGuidanceArabic:
              'استقبل ليندا بتطمين سريع لأن عندها ميتينج ومضغوطة جداً.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-05-02'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-05-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'My meeting starts soon! The front light is flashing red! Tell me what to push to make it work!',
          trainerGuidanceArabic: 'تحكم في المكالمة بهدوء (Call Control): طمنها واطلب منها تتأكد من الكابل الأخضر (Green fiber jumper) المتصل من الحائط للراوتر.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-05-03'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-05-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'Linda, I am right here with you and we will get this resolved. Please check the green fiber cable on the back of the gateway to make sure it is clicked securely into the green optical port.',
          requiredKeywords: ['resolved', 'green', 'fiber cable', 'securely'],
          trainerGuidanceArabic: 'وجهها خطوة بخطوة للتحقق من الكابل الأخضر.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-05-04'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-05-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Wait! My cat was behind the desk... I just pushed the green plug in and it clicked! The light turned solid white! Alex, you saved my life!',
          trainerGuidanceArabic: 'المشكلة اتحلت في ثواني! شاركها الفرحة واختم المكالمة بسرعة عشان تلحق اجتماعها.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-05-05'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-05-05',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'That is wonderful news, Linda! Your connection is fully restored. Good luck with your Zoom meeting, and thank you for calling AT&T!',
          requiredKeywords: ['wonderful', 'connection', 'restored', 'meeting'],
          isFinal: true,
        ),
      ],
      metadata: const ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes: 'Fiber gateway optical cable reseating and urgent customer call control.',
      ),
    ),

    // 06: Fiber Tech Install Window Reschedule
    Scenario(
      id: 'scen-06-fiber-reschedule',
      title: 'Fiber Technician Appointment Reschedule & Escalation Care',
      moduleIndex: 2,
      category: 'Technical Care',
      difficulty: 'advanced',
      customerPersona: 'Robert Chen (Upset Homeowner Waiting at Home)',
      skillTags: const ['Dispatch', 'Reschedule', 'AERD'],
      expectedResponse: _defaultAgentGreeting,
      customerResponse: 'Alex, I am Robert Chen. I took half a day off work waiting for the fiber installation tech between 8 AM and 12 PM. It is now 1:30 PM, nobody showed up, and nobody called! This is unacceptable!',
      requiredAnchors: TrainingConstants.greetingRequiredAnchors,
      contextNotes: 'The morning technician got delayed on a complex multi-dwelling drop. Representative must apologize sincerely without blaming other teams, verify dispatch status, and find the earliest priority window.',
      turns: const [
        ScenarioTurn(
          id: 'turn-06-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: _defaultAgentGreeting,
          requiredKeywords: ['att', 'alex', 'name'],
          trainerGuidanceArabic:
              'استقبل روبرت بمنتهى التعاطف واعتذر عن ضياع وقته.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-06-02'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-06-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'I lost four hours of pay sitting here waiting for your technician! What are you going to do about this?',
          trainerGuidanceArabic: 'طبق AERD بالكامل: اعتراف بصعوبة الموقف، تعاطف مع وقت عمله الضائع، طمأنينة بتحمل المسؤولية، وتحديد أسرع موعد متاح.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-06-03'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-06-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'I am truly sorry for the delay and for your lost time, Robert. I am taking personal ownership right now to check the dispatch ticket and secure the earliest priority arrival for you.',
          requiredKeywords: [
            'sorry',
            'lost time',
            'ownership',
            'dispatch',
            'priority',
          ],
          trainerGuidanceArabic:
              'أكد على المسؤولية الشخصية وتجنب إلقاء اللوم على الفني.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-06-04'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-06-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Can you get someone here by 4 PM today so I do not have to waste another day tomorrow?',
          trainerGuidanceArabic:
              'أكد الموعد المسائي وامنحه رقم التتبع المباشر للطلب.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-06-05'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-06-05',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'I have updated the dispatch note with your direct phone number for a priority arrival between three and five PM today. You will receive an SMS when the tech is en route.',
          requiredKeywords: ['dispatch', 'priority', 'sms'],
          isFinal: true,
        ),
      ],
      metadata: const ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes: 'Fictional technician dispatch delay de-escalation practice.',
      ),
    ),

    // 07: AutoPay Debit vs Credit Card Difference
    Scenario(
      id: 'scen-07-autopay-discount',
      title: 'AutoPay Discount Payment Method Differences',
      moduleIndex: 1,
      category: 'Billing & Payments',
      difficulty: 'beginner',
      customerPersona: 'Emily Watson (Budget-Conscious Customer)',
      skillTags: const ['AutoPay', 'Disclosures', 'Clarity'],
      expectedResponse: _defaultAgentGreeting,
      customerResponse: 'Hi Alex, Emily Watson speaking. My monthly bill went up by twenty dollars for my two lines, and someone said it is because I use a credit card for AutoPay? Can you explain that?',
      requiredAnchors: TrainingConstants.greetingRequiredAnchors,
      contextNotes: 'AutoPay discount is \$10 per phone line when linked to a debit card or checking account, but \$5 per phone line when linked to a credit card.',
      turns: const [
        ScenarioTurn(
          id: 'turn-07-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: _defaultAgentGreeting,
          requiredKeywords: ['att', 'alex', 'name'],
          trainerGuidanceArabic:
              'ابدأ بالتحية واشرح لإميلي تفاصيل سياسة الدفع.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-07-02'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-07-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Why do I lose ten dollars a line just for using my credit card on AutoPay?',
          trainerGuidanceArabic: 'اشرح بوضوح إن خصم الـ AutoPay كامل (10 دولار للخط) متاح مع بطاقة الخصم (Debit) أو الحساب البنكي، بينما بطاقات الائتمان بتعطي 5 دولار للخط.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-07-03'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-07-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'I understand completely, Emily. With debit card or checking account AutoPay, you receive the full ten dollar discount per line. With a credit card, the discount is five dollars per line.',
          requiredKeywords: [
            'debit card',
            'checking account',
            'ten dollar',
            'credit card',
            'five dollars',
          ],
          trainerGuidanceArabic:
              'انتبه لنطق P و B في Debit card و Checking account.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-07-04'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-07-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'If I switch my payment method to my bank debit card right now on the app, will my full twenty dollar discount return next bill?',
          trainerGuidanceArabic:
              'أكد لها إن التغيير متاح فورا عبر التطبيق وإن الخصم هيرجع.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-07-05'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-07-05',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Yes, exactly. Updating to your debit card in the app restores the full twenty dollar monthly savings on your very next bill cycle.',
          requiredKeywords: ['debit card', 'twenty dollar', 'bill cycle'],
          isFinal: true,
        ),
      ],
      metadata: const ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes: 'Fictional AutoPay payment method rules and pricing clarity.',
      ),
    ),

    // 08: Payment Arrangement & Promise to Pay
    Scenario(
      id: 'scen-08-payment-arrangement',
      title: 'Past-Due Balance & Payment Arrangement Terms',
      moduleIndex: 1,
      category: 'Billing & Payments',
      difficulty: 'intermediate',
      customerPersona: 'George Bailey (Stressed Family Account Holder)',
      skillTags: const ['Payment Arrangement', 'AERD', 'Empathy'],
      expectedResponse: _defaultAgentGreeting,
      customerResponse: 'Alex, my name is George Bailey. I got an alert saying my service will be suspended on Friday. I had unexpected medical expenses. Can I set up a payment arrangement until my payday next Wednesday?',
      requiredAnchors: TrainingConstants.greetingRequiredAnchors,
      contextNotes: 'Payment arrangements must be scheduled before service suspension occurs. Late fees may still apply, and payments will process automatically on the agreed date.',
      turns: const [
        ScenarioTurn(
          id: 'turn-08-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: _defaultAgentGreeting,
          requiredKeywords: ['att', 'alex', 'name'],
          trainerGuidanceArabic: 'استمع لجورج بتفهم واحترام لظروفه الطارئة.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-08-02'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-08-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'I just need five extra days until next Wednesday. I cannot afford to have my kids phones shut off.',
          trainerGuidanceArabic: 'طمن جورج، ووضح له شروط جدولة الدفع (Payment Arrangement) قبل تاريخ الإيقاف.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-08-03'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-08-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'I hear you, George, and we can certainly help protect your family lines. We can set up a scheduled payment arrangement for next Wednesday so your service remains active without interruption.',
          requiredKeywords: [
            'help',
            'payment arrangement',
            'wednesday',
            'active',
          ],
          trainerGuidanceArabic: 'استخدم نبرة مطمئنة وركز على استمرار الخدمة.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-08-04'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-08-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'That is such a relief. Does the system take the payment automatically on that Wednesday?',
          trainerGuidanceArabic:
              'وضح له إن السداد بيكون أوتوماتيكي في التاريخ المحدد.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-08-05'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-08-05',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Yes, George. The payment will process automatically on Wednesday. I have confirmed the arrangement on your account so your phones stay connected.',
          requiredKeywords: ['automatically', 'wednesday', 'confirmed'],
          isFinal: true,
        ),
      ],
      metadata: const ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes: 'Fictional promise-to-pay arrangement guidelines.',
      ),
    ),

    // 09: Paper Bill Administrative Fee
    Scenario(
      id: 'scen-09-paper-bill-fee',
      title: 'Paper Billing Fee Inquiry & Paperless Migration',
      moduleIndex: 1,
      category: 'Billing & Payments',
      difficulty: 'beginner',
      customerPersona: 'Helen Ross (Senior Customer Preferring Mail)',
      skillTags: const ['Paperless', 'Coaching', 'Patience'],
      expectedResponse: _defaultAgentGreeting,
      customerResponse: 'Hello Alex, this is Helen Ross. There is a five dollar paper bill fee on my account statement. I have always gotten my bill in the mail for twenty years. Why am I paying for paper now?',
      requiredAnchors: TrainingConstants.greetingRequiredAnchors,
      contextNotes: 'An administrative charge applies for monthly paper invoice delivery. The representative can patiently guide Helen through free digital view or print-at-home options.',
      turns: const [
        ScenarioTurn(
          id: 'turn-09-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: _defaultAgentGreeting,
          requiredKeywords: ['att', 'alex', 'name'],
          trainerGuidanceArabic:
              'رحب بهيلين باحترام وصبر شديد يناسب عميلة قديمة.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-09-02'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-09-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Why are you charging me five dollars just to send me my monthly bill through the post office?',
          trainerGuidanceArabic: 'اشرح بأدب سياسة الفاتورة الورقية واقترح إرسال ملخص SMS مجاني أو تفعيل الفاتورة الإلكترونية لتوفير المبلغ.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-09-03'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-09-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'I understand your perspective, Helen. To reduce environmental impact, a five dollar fee applies for mailed paper invoices. We can easily switch you to paperless billing to eliminate this charge completely.',
          requiredKeywords: [
            'understand',
            'five dollar',
            'paperless',
            'eliminate',
          ],
          trainerGuidanceArabic:
              'احرص على نصب P في Paperless و Perspective بدون B.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-09-04'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-09-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'If I switch to paperless, can I still print out the full bill from my computer if I need it?',
          trainerGuidanceArabic:
              'طمنها إنها تقدر تطبع نسخة PDF كاملة مجانا في أي وقت.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-09-05'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-09-05',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Yes, absolutely. You can download and print a full PDF copy anytime online at no charge. Shall I help you enroll in paperless billing today?',
          requiredKeywords: ['print', 'pdf', 'paperless', 'today'],
          isFinal: true,
        ),
      ],
      metadata: const ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes: 'Fictional paper billing policy explanation and paperless transition.',
      ),
    ),

    // 10: Supervisor Demand De-escalation
    Scenario(
      id: 'scen-10-supervisor-demand',
      title: 'Supervisor Demand & First-Contact Ownership',
      moduleIndex: 1,
      category: 'De-escalation & Retention',
      difficulty: 'advanced',
      customerPersona: 'Arthur Pendelton (Extremely Furious Caller)',
      skillTags: const ['Supervisor De-escalation', 'AERD', 'Ownership'],
      expectedResponse: _defaultAgentGreeting,
      customerResponse: 'Stop right there! I do not want to talk to a frontline rep! Give me your supervisor right now! Transfer me or get someone who actually has authority on the line!',
      requiredAnchors: TrainingConstants.greetingRequiredAnchors,
      contextNotes: 'Operational Floor Truth [Work-Reported Information]: Supervisor callbacks are NOT available in this queue. Representative must take immediate personal ownership, de-escalate with AERD, and resolve the underlying issue directly.',
      turns: const [
        ScenarioTurn(
          id: 'turn-010-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: _defaultAgentGreeting,
          requiredKeywords: ['att', 'alex', 'name'],
          trainerGuidanceArabic: 'العميل غاضب جداً ويطلب السوبرفايزر فوراً. حافظ على هدوء أعصابك وابدأ بتحيتك الرسمية بثقة.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-010-02'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-010-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'I said get me your manager! I am sick of dealing with scripted representatives who cannot do anything!',
          trainerGuidanceArabic: 'قاعدة تشغيلية مهمة: السوبرفايزر كول باك غير متاح في كيو أليكس. لا تَعِد بما لا تملك! طبق AERD: اعترف بغضبه، وطمنه إنك معاه، وتحمل المسؤولية بنفسك لحل المشكلة.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-010-03'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-010-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'I hear your frustration, and I understand why you want this resolved immediately. My supervisor will review the same account tools, and I have the authority right here to fix this for you. Tell me what happened so I can take care of it right now.',
          requiredKeywords: [
            'frustration',
            'resolved',
            'authority',
            'fix',
            'care',
          ],
          trainerGuidanceArabic: 'قدم نموذج الملكية الفردية (First-Contact Ownership): "I have the authority right here to fix this for you".',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-010-04'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-010-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Fine. If you actually have the power to fix my promotional credit that was canceled last week, prove it.',
          trainerGuidanceArabic: 'العميل وافق يسمعك ويتخلى عن طلب المدير. خذ رقم الحساب فوراً وابدأ الفحص.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-010-05'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-010-05',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'I am on it right now. Let me pull up your promotional enrollment and audit the adjustment so we get your credits restored.',
          requiredKeywords: ['promotional', 'audit', 'restored'],
          isFinal: true,
        ),
      ],
      metadata: const ContentMetadata(
        provenance: ProvenanceTier.workReported,
        notes: 'Grounded in floor reality: Supervisor callbacks are not available; agent must de-escalate with AERD and exercise direct front-line empowerment.',
      ),
    ),

    // 11: 36-Month EIP Balance Payoff
    Scenario(
      id: 'scen-11-eip-payoff',
      title: '36-Month EIP Payoff vs Forfeiture of Remaining Credits',
      moduleIndex: 1,
      category: 'Billing & Payments',
      difficulty: 'intermediate',
      customerPersona: 'Derek Morgan (Tech Enthusiast Wanting Early Unlock)',
      skillTags: const ['Installments', 'Payoff', 'Disclosures'],
      expectedResponse: _defaultAgentGreeting,
      customerResponse: 'Alex, my name is Derek Morgan. I want to pay off the remaining balance on my iPhone installment plan so I can unlock it. Will I keep getting my monthly promotional trade-in credits if I pay off the phone early?',
      requiredAnchors: TrainingConstants.greetingRequiredAnchors,
      contextNotes: 'Paying off a device early can affect promotional bill credits unless the payoff is processed correctly after credits start; changing plan or line disconnection forfeits remaining credits.',
      turns: const [
        ScenarioTurn(
          id: 'turn-011-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: _defaultAgentGreeting,
          requiredKeywords: ['att', 'alex', 'name'],
          trainerGuidanceArabic: 'استقبل ديريك وراجع معاه شروط سداد خطة التقسيط المبكر (EIP Payoff).',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-011-02'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-011-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'If I pay the full 400 dollars left on the phone, do my monthly promotional credits disappear?',
          trainerGuidanceArabic: 'اشرح القاعدة بدقة: طالما الخط شغال وعقد الترايد إن مفعل، الرصيد الترويجي بيكمل كخصم على الفاتورة الشهرية طالما لم يتم إلغاء الخط.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-011-03'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-011-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'Great question, Derek. As long as your line remains active on an eligible unlimited plan, paying off the device installment balance allows you to unlock the device while continuing to receive your monthly promotional bill credits.',
          requiredKeywords: ['line', 'active', 'eligible', 'unlock', 'credits'],
          trainerGuidanceArabic:
              'وضوح المصطلحات مهم جداً: Eligible plan, unlock device.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-011-04'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-011-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'That is awesome news! Go ahead and process the payoff with the card on file, Alex.',
          trainerGuidanceArabic: 'أكد المبلغ واطلب الموافقة الصريحة قبل الخصم.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-011-05'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-011-05',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'I have submitted the device payoff for four hundred dollars and initiated your device unlock request. You will receive email confirmation shortly.',
          requiredKeywords: [
            'submitted',
            'four hundred',
            'unlock',
            'confirmation',
          ],
          isFinal: true,
        ),
      ],
      metadata: const ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes:
            'Fictional early payoff policy and unlock eligibility explanation.',
      ),
    ),

    // 12: Trade-In Shipping Kit Delay
    Scenario(
      id: 'scen-12-tradein-box',
      title: 'Trade-In Return Shipping Kit Delay & Deadline Extension',
      moduleIndex: 1,
      category: 'Billing & Payments',
      difficulty: 'intermediate',
      customerPersona: 'Chloe Adams (Worried New Phone Owner)',
      skillTags: const ['Trade-In Kit', 'Reassurance', 'AERD'],
      expectedResponse: _defaultAgentGreeting,
      customerResponse: 'Alex, my name is Chloe Adams. I got my new iPhone ten days ago, but I still have not received the return shipping box for my old trade-in phone! I only have thirty days or I lose the 800-dollar promotion! What should I do?',
      requiredAnchors: TrainingConstants.greetingRequiredAnchors,
      contextNotes: 'The 30-day trade-in window is protected when a shipping kit replacement is ordered or a drop-off label is generated at a corporate retail store.',
      turns: const [
        ScenarioTurn(
          id: 'turn-012-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: _defaultAgentGreeting,
          requiredKeywords: ['att', 'alex', 'name'],
          trainerGuidanceArabic:
              'استقبل كلوي وطمنها فوراً إن حقها في العرض الترويجي محمي.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-012-02'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-012-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'I am terrified I am going to miss the thirty day deadline and be charged 800 dollars!',
          trainerGuidanceArabic: 'طمن كلوي إن السيستم بيوثق التأخير وإنها تقدر تطبع بوليصة شحن فورية أو تروح أي فرع رسمي تسلم الجهاز.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-012-03'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-012-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'Please do not worry, Chloe. Your promotion is completely safe. I can email you a prepaid return shipping label right now, or you can drop your device off at any official store for immediate inspection.',
          requiredKeywords: [
            'safe',
            'email',
            'prepaid',
            'shipping label',
            'store',
          ],
          trainerGuidanceArabic:
              'وضح الخيارين: إيميل ببوليصة شحن أو تسليم في الفرع.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-012-04'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-012-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Can you email me the printable label right now? That is so much easier than waiting for a box in the mail!',
          trainerGuidanceArabic:
              'أرسل البوليصة على إيميلها المسجل وأكد استلامها.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-012-05'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-012-05',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'I have sent the prepaid shipping label directly to your email on file. Your thirty-day window has been documented and extended on the account.',
          requiredKeywords: ['sent', 'prepaid', 'email', 'extended'],
          isFinal: true,
        ),
      ],
      metadata: const ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes:
            'Fictional trade-in kit delay handling and customer reassurance.',
      ),
    ),

    // 13: Third-Party App Store Mobile Purchases
    Scenario(
      id: 'scen-13-third-party-charge',
      title: 'Third-Party Mobile Purchases & Purchase Blocker',
      moduleIndex: 1,
      category: 'Billing & Payments',
      difficulty: 'intermediate',
      customerPersona:
          'Bradley Cooper (Father Surprised by Gaming In-App Charges)',
      skillTags: const ['Purchase Blocker', 'Billing Investigation', 'AERD'],
      expectedResponse: _defaultAgentGreeting,
      customerResponse: 'Alex, my name is Bradley Cooper. My bill has four separate charges of 9.99 labeled Mobile Purchase. I never authorized this! Is someone hacking my account?',
      requiredAnchors: TrainingConstants.greetingRequiredAnchors,
      contextNotes: 'Direct carrier billing allows app store purchases charged directly to the wireless invoice; representative can explain mobile purchase blocking feature.',
      turns: const [
        ScenarioTurn(
          id: 'turn-013-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: _defaultAgentGreeting,
          requiredKeywords: ['att', 'alex', 'name'],
          trainerGuidanceArabic: 'استقبل برادلي وتحقق من تفاصيل الرسوم.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-013-02'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-013-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Who authorized forty dollars in game purchases on my bill? I want this removed and blocked forever!',
          trainerGuidanceArabic: 'اشرح له خاصية الشراء عبر الفاتورة (Carrier Billing) واقترح تفعيل ميزة Purchase Blocker المجانية على جميع خطوط العائلة.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-013-03'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-013-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'I understand your concern, Bradley. Those charges stem from third-party app store purchases billed directly to the phone line. I can add our free Purchase Blocker to all lines right now to prevent any future charges.',
          requiredKeywords: [
            'understand',
            'third-party',
            'purchase blocker',
            'prevent',
          ],
          trainerGuidanceArabic: 'وضح مجانية ميزة Purchase Blocker.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-013-04'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-013-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Yes, please lock that down so my son cannot accidentally buy coins again. Thank you, Alex.',
          trainerGuidanceArabic: 'فعل الحظر وراجع سياسة التسوية المتاحة.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-013-05'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-013-05',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Purchase Blocker is now active across all lines on your account, so no further third-party charges can go through. Is there anything else I can protect today?',
          requiredKeywords: ['purchase blocker', 'active', 'protect'],
          isFinal: true,
        ),
      ],
      metadata: const ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes: 'Fictional carrier billing investigation and purchase blocker feature.',
      ),
    ),

    // 14: Bereavement Account Ownership Transfer
    Scenario(
      id: 'scen-14-bereavement-transfer',
      title: 'Bereavement Care & Compassionate Line Transfer',
      moduleIndex: 1,
      category: 'Account Floor Care',
      difficulty: 'advanced',
      customerPersona: 'Eleanor Vance (Grieving Widow)',
      skillTags: const ['Bereavement', 'Compassion', 'Transfer of Billing'],
      expectedResponse: _defaultAgentGreeting,
      customerResponse: 'Hello Alex. My name is Eleanor Vance. My husband passed away three weeks ago. The wireless account is under his name, and I need to know how to keep my phone number without having to pay cancellation fees.',
      requiredAnchors: TrainingConstants.greetingRequiredAnchors,
      contextNotes: 'Bereavement care requires genuine human compassion, zero early termination or transfer fees, and handling with care and respect without pressuring sales.',
      turns: const [
        ScenarioTurn(
          id: 'turn-014-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: _defaultAgentGreeting,
          requiredKeywords: ['att', 'alex', 'name'],
          trainerGuidanceArabic: 'موقف إنساني شديد الحساسية. استمع بإخلاص واستعد لتقديم واجب العزاء فورا.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-014-02'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-014-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'My husband handled all the bills. I just want to keep my number and make sure I am not penalized.',
          trainerGuidanceArabic: 'قدم واجب العزاء بصدق وبدون عبارات آلية. طمنها إن مفيش أي رسوم إلغاء أو جزاءات في حالات الوفاة وإنك هتنقل الخط باسمها بسلاسة.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-014-03'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-014-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'Mrs. Vance, please accept my deepest condolences for your loss. We are here to support you completely. There are zero cancellation fees or penalties, and I will personally walk you through keeping your phone number seamlessly.',
          requiredKeywords: [
            'condolences',
            'loss',
            'support',
            'zero',
            'penalties',
          ],
          trainerGuidanceArabic:
              'استخدم تعبير: "deepest condolences for your loss".',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-014-04'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-014-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Thank you so much, Alex. You have no idea how much your kindness means to me right now.',
          trainerGuidanceArabic:
              'أكمل الإجراء بلطف وصبر دون أي عروض تسويقية إطلاقاً.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-014-05'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-014-05',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'It is truly my privilege, Mrs. Vance. I have initiated the ownership transfer and noted your account with high priority. Please take all the time you need.',
          requiredKeywords: ['privilege', 'transfer', 'time'],
          isFinal: true,
        ),
      ],
      metadata: const ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes: 'Strict bereavement protocol: compassion first, zero sales pressure.',
      ),
    ),

    // 15: Fast Alphanumeric Caller Info
    Scenario(
      id: 'scen-15-fast-numbers',
      title: 'Fast-Speaking Caller Account Number & IMEI Capture',
      moduleIndex: 2,
      category: 'Technical Care',
      difficulty: 'advanced',
      customerPersona: 'Kevin Patel (Rushed Commuter Rattling Numbers)',
      skillTags: const ['Fast Numbers', 'Active Listening', 'Verification'],
      expectedResponse: _defaultAgentGreeting,
      customerResponse: 'Hey Alex, Kevin Patel here. My account is 849201938 and my device IMEI is 358291048291038, zip code 90210. I need a network refresh signal sent right now!',
      requiredAnchors: TrainingConstants.greetingRequiredAnchors,
      contextNotes: 'Customer speaks extremely quickly, challenging agent listening comprehension and read-back verification accuracy.',
      turns: const [
        ScenarioTurn(
          id: 'turn-015-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: _defaultAgentGreeting,
          requiredKeywords: ['att', 'alex', 'name'],
          trainerGuidanceArabic: 'التحية الرسمية واستقبال البيانات بسرعة.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-015-02'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-015-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Did you get that IMEI? 358-291-048-291-038. Refresh my cellular data tower connection!',
          trainerGuidanceArabic: 'تأكد من الأرقام وقراءتها بأسلوب التقطيع (Chunking) مع سرعة بديهة.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-015-03'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-015-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'Thank you, Kevin. I have verified your IMEI ending in one zero three eight and zip code 90210. I am broadcasting an over-the-air network refresh to your device right now.',
          requiredKeywords: ['verified', 'imei', 'zip code', 'refresh'],
          trainerGuidanceArabic:
              'أعد تأكيد آخر 4 أرقام من الـ IMEI لتوفير الوقت.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-015-04'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-015-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Signal just reconnected with five bars! Fast work Alex, thanks a lot.',
          trainerGuidanceArabic: 'أكد نجاح الإجراء واختم المكالمة.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-015-05'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-015-05',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Glad to hear that, Kevin! Restart your device when you reach your destination. Have a great commute!',
          requiredKeywords: ['restart', 'destination', 'commute'],
          isFinal: true,
        ),
      ],
      metadata: const ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes: 'Fast-paced number and alphanumeric verification drill.',
      ),
    ),

    // 16: Noisy Background / Distracted Caller
    Scenario(
      id: 'scen-16-noisy-background',
      title: 'Distracted Caller in Airport with Loud Background Noise',
      moduleIndex: 2,
      category: 'Account Floor Care',
      difficulty: 'intermediate',
      customerPersona: 'Maria Santos (Traveler at Busy Airport Gate)',
      skillTags: const ['Pacing', 'Clarity', 'Noise Management'],
      expectedResponse: _defaultAgentGreeting,
      customerResponse: 'Hello Alex! My name is Maria Santos. (Loud intercom announcement) Sorry, I am at the airport gate and boarding soon. Can you turn on my international travel pass before I get on the plane?',
      requiredAnchors: TrainingConstants.greetingRequiredAnchors,
      contextNotes: 'Representative must project clear, measured, high-contrast articulation to cut through background noise without shouting.',
      turns: const [
        ScenarioTurn(
          id: 'turn-016-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: _defaultAgentGreeting,
          requiredKeywords: ['att', 'alex', 'name'],
          trainerGuidanceArabic:
              'تحدث بنبرة واضحة ومخارج حروف قوية للتغلب على الضوضاء.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-016-02'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-016-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Can you hear me over the speakers? I need international pass added right now before doors close!',
          trainerGuidanceArabic:
              'طمنها بوضوح: الخدمة هتتفعل في ثواني ومفيش داعي للقلق.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-016-03'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-016-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'I can hear you clearly, Maria. I am adding the International Day Pass to your line right now so your phone will be ready the moment you touch down.',
          requiredKeywords: ['hear', 'international day pass', 'ready', 'line'],
          trainerGuidanceArabic:
              'ركز على مخارج حروف P في Pass و B في Boarding.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-016-04'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-016-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Done already? You are amazing, Alex! Thank you so much, boarding now!',
          trainerGuidanceArabic: 'تمنى لها رحلة سعيدة واختم باقتضاب.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-016-05'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-016-05',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Have a safe and wonderful flight, Maria! Thank you for choosing AT&T!',
          requiredKeywords: ['flight', 'safe', 'thank you'],
          isFinal: true,
        ),
      ],
      metadata: const ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes: 'Noise management and rapid execution drill.',
      ),
    ),

    // 17: Long Hold Frustration & Multiple Transfers
    Scenario(
      id: 'scen-17-hold-frustration',
      title: 'Caller Frustrated by Multiple Previous Transfers',
      moduleIndex: 1,
      category: 'De-escalation & Retention',
      difficulty: 'advanced',
      customerPersona: 'Thomas Sterling (Exhausted Businessman)',
      skillTags: const ['Hold Frustration', 'No More Transfers', 'AERD'],
      expectedResponse: _defaultAgentGreeting,
      customerResponse: 'Alex, my name is Thomas Sterling. You are the fourth person I have been transferred to in the last forty-five minutes! If you transfer me again, I am canceling all five of my lines right now!',
      requiredAnchors: TrainingConstants.greetingRequiredAnchors,
      contextNotes: 'Customer is on the verge of churn due to repeated transfers. The agent must commit to staying on the line and resolving the issue personally.',
      turns: const [
        ScenarioTurn(
          id: 'turn-017-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: _defaultAgentGreeting,
          requiredKeywords: ['att', 'alex', 'name'],
          trainerGuidanceArabic:
              'استقبل توماس بثبات وطاقة إيجابية واعتذر عن التشتيت.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-017-02'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-017-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Do not put me on hold and do not transfer me! Can you actually help me or not?',
          trainerGuidanceArabic: 'تطبيق التعهد الحاسم (The No-Transfer Promise): "You have reached the right person, and I will not transfer you anywhere."',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-017-03'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-017-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'I sincerely apologize for the transfers and your time, Thomas. You have reached Alex, and I promise you will not be transferred again. I am taking full ownership to handle this from start to finish.',
          requiredKeywords: [
            'apologize',
            'transfers',
            'promise',
            'ownership',
            'finish',
          ],
          trainerGuidanceArabic:
              'أكد على الوعد بعدم التحويل والمسؤولية الكاملة.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-017-04'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-017-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Thank goodness. Finally someone who takes responsibility. I need to change the billing name on my account.',
          trainerGuidanceArabic: 'ابدأ فورا في تنفيذ التعديل المطلوب.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-017-05'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-017-05',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'I am updating the billing name on your account right now. You are all set and in good hands, Thomas.',
          requiredKeywords: ['updating', 'billing name', 'hands'],
          isFinal: true,
        ),
      ],
      metadata: const ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes: 'De-escalation for transferred callers and ownership assertion.',
      ),
    ),

    // 18: Moving / Relocation Fiber Availability Check
    Scenario(
      id: 'scen-18-moving-relocation',
      title: 'Move Order & Fiber Speed Availability at New Address',
      moduleIndex: 2,
      category: 'Account Floor Care',
      difficulty: 'intermediate',
      customerPersona: 'Samantha Lee (Moving Homeowner)',
      skillTags: const ['Move Order', 'Fiber Speeds', 'Discovery'],
      expectedResponse: _defaultAgentGreeting,
      customerResponse: 'Hi Alex! I am Samantha Lee. We are moving to Austin next Friday and I want to see if we can transfer our AT&T Fiber service to our new home at 4420 Oak Creek Lane.',
      requiredAnchors: TrainingConstants.greetingRequiredAnchors,
      contextNotes: 'Move orders require address verification, facility qualification (Gigabit vs Multi-Gig), and scheduling install or self-install kit delivery.',
      turns: const [
        ScenarioTurn(
          id: 'turn-018-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: _defaultAgentGreeting,
          requiredKeywords: ['att', 'alex', 'name'],
          trainerGuidanceArabic:
              'هنئ سامانثا على الانتقال وابدأ فحص العنوان الجديد.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-018-02'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-018-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Can I get the same 1000 megabit fiber speeds at the new place, and can it be connected next Friday?',
          trainerGuidanceArabic: 'افحص توافر الخدمة وبشرها بتوافر سرعات الفايبر 1 جيجا مع خيار التوصيل الذاتي أو الفني.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-018-03'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-018-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'Congratulations on the new home, Samantha! I checked 4420 Oak Creek Lane and AT&T Fiber 1000 is ready for activation there. We can easily schedule your hookup for next Friday.',
          requiredKeywords: [
            'congratulations',
            'fiber 1000',
            'activation',
            'friday',
          ],
          trainerGuidanceArabic: 'ركز على نطق B و P في Fiber و Hookup.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-018-04'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-018-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'That is fantastic! Do I take my current white Wi-Fi gateway with me, or do you send new equipment?',
          trainerGuidanceArabic:
              'وضح لها تعليمات أخذ المودم القديم معاها للعنوان الجديد.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-018-05'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-018-05',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Please pack your current gateway and power cord and bring them with you. Your move order is scheduled for next Friday with zero gap in service.',
          requiredKeywords: ['gateway', 'scheduled', 'friday', 'service'],
          isFinal: true,
        ),
      ],
      metadata: const ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes: 'Fictional move order qualification and customer guidance.',
      ),
    ),

    // 19: eSIM QR Code Activation on New Device
    Scenario(
      id: 'scen-19-esim-transfer',
      title: 'eSIM QR Code Push & Quick Transfer Troubleshooting',
      moduleIndex: 2,
      category: 'Technical Care',
      difficulty: 'intermediate',
      customerPersona: 'Justin Blake (Frustrated iPhone Buyer)',
      skillTags: const ['eSIM', 'Activation', 'Troubleshooting'],
      expectedResponse: _defaultAgentGreeting,
      customerResponse: 'Alex, my name is Justin Blake. I just bought an unlocked iPhone without a physical SIM slot. I tried activating the eSIM through the app, but it says Cellular Setup Failed. My old phone is already deactivated!',
      requiredAnchors: TrainingConstants.greetingRequiredAnchors,
      contextNotes: 'eSIM activation failure requires verifying EID number, Wi-Fi connection on new device, and pushing an over-the-air carrier profile download.',
      turns: const [
        ScenarioTurn(
          id: 'turn-019-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: _defaultAgentGreeting,
          requiredKeywords: ['att', 'alex', 'name'],
          trainerGuidanceArabic:
              'استقبل جاستن وطمنه إن مشكلة الـ eSIM بتتحل في دقايق عبر Wi-Fi.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-019-02'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-019-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'I have no working phone right now! How do I get cellular signal onto this new iPhone?',
          trainerGuidanceArabic: 'اطلب منه التأكد إنه متصل بشبكة Wi-Fi، وادخل رقم الـ EID لتنزيل بروفايل الـ eSIM أوتوماتيكياً.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-019-03'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-019-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'I can help you get connected right away, Justin. Please make sure your new iPhone is connected to Wi-Fi. I am sending an over-the-air eSIM carrier profile push directly to your device EID right now.',
          requiredKeywords: ['connected', 'wi-fi', 'esim', 'push', 'eid'],
          trainerGuidanceArabic:
              'وضح خطوة الاتصال بالـ Wi-Fi قبل إرسال البروفايل.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-019-04'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-019-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'A notification just popped up saying AT&T Cellular Plan Ready to Install! I tapped it and bars appeared! Alex, thank you!',
          trainerGuidanceArabic:
              'أكد انتهاء التفعيل وانصحه بإعادة تشغيل الهاتف.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-019-05'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-019-05',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'You are all set with active five G cellular service, Justin! Enjoy your new iPhone and thank you for calling AT&T!',
          requiredKeywords: ['active', 'five g', 'enjoy', 'iphone'],
          isFinal: true,
        ),
      ],
      metadata: const ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes: 'eSIM OTA push and dual-SIM device onboarding practice.',
      ),
    ),

    // 20: Fiber 1000 Upgrade Pitch / Value Explanation
    Scenario(
      id: 'scen-20-fiber-upgrade',
      title: 'Fiber 300 to Fiber 1000 Upgrade & Household Discovery',
      moduleIndex: 3,
      category: 'Sales & Discovery',
      difficulty: 'intermediate',
      customerPersona: 'Danielle Brooks (Work-from-Home Parent with Gamers)',
      skillTags: const ['Sales Discovery', 'Fiber Upgrade', 'Value Selling'],
      expectedResponse: _defaultAgentGreeting,
      customerResponse: 'Alex, my name is Danielle Brooks. We currently have your 300 megabit internet, but my husband works from home uploading large video files and my two teenagers are constantly gaming. Would upgrading to Fiber 1000 actually make a difference for us?',
      requiredAnchors: TrainingConstants.greetingRequiredAnchors,
      contextNotes: 'Danielle has bandwidth contention due to symmetric upstream needs for video production and low latency gaming. Fiber 1000 provides symmetric gigabit up/down with unlimited data.',
      turns: const [
        ScenarioTurn(
          id: 'turn-020-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: _defaultAgentGreeting,
          requiredKeywords: ['att', 'alex', 'name'],
          trainerGuidanceArabic:
              'استقبل دانييل وابدأ ممارسة الاستكشاف البيعي (Sales Discovery).',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-020-02'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-020-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Is moving up to 1000 megabits worth the extra twenty dollars a month, or is it just overkill?',
          trainerGuidanceArabic: 'اشرح ميزة السرعات المتطابقة (Symmetrical speeds) والـ Upload عالي السرعة لملفات الفيديو والـ Latency المنخفض للجيمرز.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-020-03'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-020-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'With video uploads and multiple gamers simultaneously, Fiber 1000 is an ideal fit. It delivers equal gigabit upload and download speeds with ultra-low latency, so your husband can transfer large files without affecting the gaming.',
          requiredKeywords: [
            'fiber 1000',
            'upload',
            'download',
            'latency',
            'transfer',
          ],
          trainerGuidanceArabic:
              'وضح القيمة العملية لمشاكلهم اليومية في البيت.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-020-04'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-020-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Equal upload speed is huge for his job! Let us do it, Alex. Can you upgrade our speed today?',
          trainerGuidanceArabic: 'أكد الترقية اللحظية بدون الحاجة لزيارة فني.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-020-05'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-020-05',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'I have submitted your upgrade to Fiber 1000 right now. Your gateway will automatically provision the new gigabit speeds within fifteen minutes with no technician visit needed.',
          requiredKeywords: ['fiber 1000', 'fifteen minutes', 'upgrade'],
          isFinal: true,
        ),
      ],
      metadata: const ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes: 'Value-based sales discovery and symmetrical speed explanation.',
      ),
    ),

    // 21: Stolen Phone Immediate Line Suspend
    Scenario(
      id: 'scen-21-stolen-phone',
      title: 'Stolen Phone Emergency Line Suspend & IMEI Blacklist',
      moduleIndex: 2,
      category: 'Account Floor Care',
      difficulty: 'intermediate',
      customerPersona: 'Amber Scott (Panicked Subway Theft Victim)',
      skillTags: const ['Security', 'IMEI Blacklist', 'Emergency Suspend'],
      expectedResponse: _defaultAgentGreeting,
      customerResponse: 'Alex, this is Amber Scott! My purse was just stolen on the subway with my phone inside! I need you to shut my phone off immediately before whoever stole it accesses my bank accounts!',
      requiredAnchors: TrainingConstants.greetingRequiredAnchors,
      contextNotes: 'Immediate action required: suspend wireless line with stolen reason code and add device IMEI to the global blacklist to prevent unauthorized cellular use.',
      turns: const [
        ScenarioTurn(
          id: 'turn-021-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: _defaultAgentGreeting,
          requiredKeywords: ['att', 'alex', 'name'],
          trainerGuidanceArabic:
              'استقبل أمبر بهدوء شديد وتحرك فورا لحماية أمن حسابها.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-021-02'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-021-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Please blacklist the phone and suspend my line right now so nobody can make calls or read my two-factor security texts!',
          trainerGuidanceArabic: 'طمنها بكلمات واضحة: الخط تم تعليقه والجهاز دخل الـ Blacklist دوليا.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-021-03'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-021-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'Amber, take a deep breath. Your account is secure. I have immediately suspended your line and added the device IMEI to the global blacklist so it cannot be activated or used on any network.',
          requiredKeywords: ['secure', 'suspended', 'blacklist', 'network'],
          trainerGuidanceArabic:
              'ركز على مصطلح Global Blacklist و Suspended line.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-021-04'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-021-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Thank goodness. You acted so fast, Alex. When I get a replacement device, can I get my number back?',
          trainerGuidanceArabic:
              'أكد لها إن رقمها محفوظ وممكن تسترده فورا مع الشريحة الجديدة.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-021-05'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-021-05',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Absolutely, Amber. Your phone number is safely preserved. Whenever you are ready with a replacement device, we will activate it immediately.',
          requiredKeywords: ['preserved', 'replacement', 'activate'],
          isFinal: true,
        ),
      ],
      metadata: const ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes: 'Emergency line suspension and IMEI blacklisting protocol.',
      ),
    ),

    // 22: 14-Day Remorse Period & Restocking Fee
    Scenario(
      id: 'scen-22-remorse-period',
      title: '14-Day Return Policy & Device Restocking Fee Explanation',
      moduleIndex: 1,
      category: 'Billing & Payments',
      difficulty: 'intermediate',
      customerPersona: 'Lucas Gray (Buyer with Second Thoughts on Big Screen)',
      skillTags: const ['Return Policy', 'Restocking Fee', 'Disclosures'],
      expectedResponse: _defaultAgentGreeting,
      customerResponse: 'Alex, my name is Lucas Gray. I bought a Galaxy S24 Ultra eight days ago, but the screen is just too big for my hands. I want to return it for the standard model, but the store told me there is a fifty-five dollar restocking fee? Why?',
      requiredAnchors: TrainingConstants.greetingRequiredAnchors,
      contextNotes: 'The standard retail return period is 14 days from purchase or delivery. A \$55 restocking fee applies to open-box wireless phone returns (except where prohibited by state law).',
      turns: const [
        ScenarioTurn(
          id: 'turn-022-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: _defaultAgentGreeting,
          requiredKeywords: ['att', 'alex', 'name'],
          trainerGuidanceArabic: 'استقبل لوكاس ووضح له سياسة الإرجاع خلال الـ 14 يوم (Buyer Remorse).',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-022-02'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-022-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Why do I have to pay fifty-five dollars just to exchange an opened phone within the fourteen days?',
          trainerGuidanceArabic: 'اشرح سبب رسوم الـ Restocking Fee (إعادة الفحص والتعقيم والتغليف) وأكد له إن الـ 14 يوم بتسمح له بالتبديل للحجم الأنسب.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-022-03'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-022-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'I understand, Lucas. The fifty-five dollar restocking fee covers warehouse inspection, repackaging, and data sanitization for opened devices. Since you are within the fourteen-day window, you can exchange it today for the smaller model.',
          requiredKeywords: [
            'fifty-five dollar',
            'restocking fee',
            'fourteen-day',
            'exchange',
          ],
          trainerGuidanceArabic: 'نطق Restocking و Fee و P/B بوضوح.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-022-04'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-022-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Okay, that makes sense. If I exchange it for the smaller phone, does my installment agreement adjust to the lower price?',
          trainerGuidanceArabic: 'أكد له إن خطة التقسيط هتتعدل للسعر الأقل.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-022-05'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-022-05',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Yes, exactly. Your installment agreement will be updated to reflect the lower monthly payment for the standard device.',
          requiredKeywords: ['installment', 'lower', 'payment'],
          isFinal: true,
        ),
      ],
      metadata: const ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes: '14-day remorse period and restocking fee explanation drill.',
      ),
    ),

    // 23: Warranty vs Insurance Claim Distinction
    Scenario(
      id: 'scen-23-warranty-vs-insurance',
      title: 'Manufacturer Warranty vs Protect Advantage Insurance Claim',
      moduleIndex: 2,
      category: 'Technical Care',
      difficulty: 'intermediate',
      customerPersona: 'Diana Prince (Customer with Cracked Glass)',
      skillTags: const ['Insurance vs Warranty', 'Deductible', 'Clarity'],
      expectedResponse: _defaultAgentGreeting,
      customerResponse: 'Alex, my name is Diana Prince. My phone screen has a hairline crack and the touch sensor is glitching. My one-year warranty should cover this for free, right? Why was I told to file an insurance claim?',
      requiredAnchors: TrainingConstants.greetingRequiredAnchors,
      contextNotes: 'Manufacturer warranty covers mechanical/electrical defects with zero physical damage. Any cracks or liquid damage fall under device protection insurance, requiring a deductible.',
      turns: const [
        ScenarioTurn(
          id: 'turn-023-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: _defaultAgentGreeting,
          requiredKeywords: ['att', 'alex', 'name'],
          trainerGuidanceArabic:
              'استقبل ديانا ووضح الفرق بين الضمان المصنعي والتأمين ضد الحوادث.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-023-02'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-023-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'The touch screen is acting crazy, so that is a defect! Why won warranty replace it?',
          trainerGuidanceArabic: 'اشرح بأسلوب راقٍ إن شروط الضمان المصنعي تشترط عدم وجود أي كسر أو شرخ في الزجاج، وإن الكسر بيعتبر Physical Damage بيتغطى بالتأمين (Insurance).',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-023-03'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-023-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'I understand how frustrating that is, Diana. Manufacturer warranty covers internal hardware defects but excludes any physical impact or cracked glass. Because of the hairline crack, Protect Advantage insurance covers your screen repair for a low deductible.',
          requiredKeywords: [
            'manufacturer warranty',
            'physical',
            'cracked',
            'protect advantage',
            'deductible',
          ],
          trainerGuidanceArabic: 'وضح ميزة تصليح الشاشة بسعر Deductible مخفض مع Protect Advantage.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-023-04'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-023-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Oh, I see. What is the deductible for a front screen repair if I file through insurance?',
          trainerGuidanceArabic: 'وضح إن إصلاح الشاشة الأمامية غالباً 29 دولار في الأماكن المؤهلة.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-023-05'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-023-05',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Eligible cracked screen repairs through Protect Advantage are typically twenty-nine dollars, often with same-day certified technician repair.',
          requiredKeywords: [
            'twenty-nine dollars',
            'protect advantage',
            'certified',
          ],
          isFinal: true,
        ),
      ],
      metadata: const ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes: 'Fictional distinction between manufacturer warranty and insurance claim.',
      ),
    ),

    // 24: Tablet Add-a-Line with Existing Unlimited Plan
    Scenario(
      id: 'scen-24-tablet-addline',
      title: 'Adding an Unlimited Tablet Line to Existing Account',
      moduleIndex: 3,
      category: 'Sales & Discovery',
      difficulty: 'intermediate',
      customerPersona: 'Ryan Reynolds (Parent Buying Cellular iPad for Kids)',
      skillTags: const ['Add-a-Line', 'Tablet Plan', 'Sales Discovery'],
      expectedResponse: _defaultAgentGreeting,
      customerResponse: 'Alex, my name is Ryan Reynolds. I bought an iPad with cellular for my daughter and I want to add it to my existing Unlimited Your Way wireless plan. How much does a standalone tablet line cost per month?',
      requiredAnchors: TrainingConstants.greetingRequiredAnchors,
      contextNotes: 'Adding an unlimited tablet line to an existing post-paid unlimited group is typically \$20/month plus taxes/fees, sharing or receiving dedicated unlimited tablet data.',
      turns: const [
        ScenarioTurn(
          id: 'turn-024-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: _defaultAgentGreeting,
          requiredKeywords: ['att', 'alex', 'name'],
          trainerGuidanceArabic:
              'استقبل رايان وابدأ شرح تفاصيل إضافة خط تابلت.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-024-02'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-024-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Does the tablet line get its own unlimited data, or does it eat into my phone hotspot?',
          trainerGuidanceArabic: 'اشرح إن خط التابلت له باقة Unlimited خاصة بيه بسعر 20 دولار شهريا، ومش بيستهلك من هوت سبوت الموبايل.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-024-03'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-024-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'The unlimited tablet plan is twenty dollars per month when added to your current unlimited group. It includes its own dedicated unlimited on-device data without using your smartphone hotspot.',
          requiredKeywords: [
            'twenty dollars',
            'unlimited tablet',
            'dedicated',
            'hotspot',
          ],
          trainerGuidanceArabic:
              'ركز على وضوح عبارة "twenty dollars per month".',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-024-04'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-024-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Twenty bucks for unlimited iPad data is great for road trips. Can you activate it using eSIM right now?',
          trainerGuidanceArabic: 'أكد التفعيل اللحظي عبر الـ eSIM.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-024-05'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-024-05',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'I have added the tablet line to your account with eSIM activation. You can download the cellular plan directly in iPad settings.',
          requiredKeywords: ['added', 'tablet line', 'esim', 'settings'],
          isFinal: true,
        ),
      ],
      metadata: const ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes: 'Fictional tablet add-a-line pricing and feature presentation.',
      ),
    ),

    // 25: Apple Watch NumberSync Setup
    Scenario(
      id: 'scen-25-watch-numbersync',
      title: 'Apple Watch Cellular Pairing & NumberSync Configuration',
      moduleIndex: 2,
      category: 'Technical Care',
      difficulty: 'intermediate',
      customerPersona: 'Chloe Kim (Runner Wanting Phone-Free Workouts)',
      skillTags: const ['NumberSync', 'Wearables', 'Technical Care'],
      expectedResponse: _defaultAgentGreeting,
      customerResponse: 'Alex, my name is Chloe Kim. I just got an Apple Watch Cellular, but when I try to set up cellular in the Watch app, NumberSync gives me an error code. I want to leave my phone home when running!',
      requiredAnchors: TrainingConstants.greetingRequiredAnchors,
      contextNotes: 'NumberSync allows cellular smartwatches to use the same telephone number as the iPhone for calls and texts; requires active smartwatch rate plan (\$10.99/mo) and verified E911 address.',
      turns: const [
        ScenarioTurn(
          id: 'turn-025-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: _defaultAgentGreeting,
          requiredKeywords: ['att', 'alex', 'name'],
          trainerGuidanceArabic: 'استقبل كلوي ووضح لها خطوات ضبط NumberSync.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-025-02'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-025-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Why does NumberSync keep asking for an emergency address during setup?',
          trainerGuidanceArabic: 'اشرح أهمية عنوان الطوارئ E911 القانوني لساعة أبل وحدثه على الحساب لمتابعة التزامن.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-025-03'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-025-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'NumberSync requires a verified E911 address so emergency responders can locate you if you make an emergency call from your watch. Once we confirm your physical address, the pairing completes instantly.',
          requiredKeywords: [
            'numbersync',
            'e911 address',
            'emergency',
            'pairing',
          ],
          trainerGuidanceArabic: 'وضح دور عنوان E911 القانوني.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-025-04'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-025-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Address confirmed, and the watch just finished syncing! I can make calls right from my wrist now!',
          trainerGuidanceArabic: 'أكد اكتمال الخدمة واختم بروح مشجعة.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-025-05'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-025-05',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'That is wonderful, Chloe! Enjoy your phone-free runs and thank you for calling AT&T!',
          requiredKeywords: ['wonderful', 'phone-free', 'thank you'],
          isFinal: true,
        ),
      ],
      metadata: const ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes: 'NumberSync smartwatch setup and E911 emergency address requirement.',
      ),
    ),

    // 26: Senior Citizen Plan Audit & Bill Optimization
    Scenario(
      id: 'scen-26-senior-plan-review',
      title: 'Grandfathered Plan Audit & Bill Optimization',
      moduleIndex: 1,
      category: 'Billing & Payments',
      difficulty: 'intermediate',
      customerPersona: 'Walter Sullivan (Retired Senior on Obsolete Plan)',
      skillTags: const ['Plan Optimization', 'Grandfathered Plans', 'Empathy'],
      expectedResponse: _defaultAgentGreeting,
      customerResponse: 'Alex, my name is Walter Sullivan. I have had my two wireless lines since 2012 on an old Mobile Share plan. My bill keeps creeping up and I am on a fixed income. Can you help me lower this without cutting my service?',
      requiredAnchors: TrainingConstants.greetingRequiredAnchors,
      contextNotes: 'Grandfathered tiered-data plans incur administrative fee increases over time; migrating Walter to modern Unlimited Starter or AARP discount saves money while providing unlimited data.',
      turns: const [
        ScenarioTurn(
          id: 'turn-026-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: _defaultAgentGreeting,
          requiredKeywords: ['att', 'alex', 'name'],
          trainerGuidanceArabic:
              'استمع لوالتر بكل احترام وتفهم لظروف المعاش والدخل الثابت.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-026-02'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-026-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'I am paying 160 dollars for only six gigabytes of shared data. Can we do better?',
          trainerGuidanceArabic: 'بشره بوجود خطط حديثة توفر له بيانات غير محدودة مع توفير 30-40 دولار شهريا، واذكر خصم AARP لو مشترك فيه.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-026-03'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-026-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'Walter, we can definitely lower your bill while giving you better service. By migrating your lines to Unlimited Starter with AutoPay, your monthly bill drops to one hundred twenty dollars with unlimited data.',
          requiredKeywords: [
            'lower',
            'unlimited starter',
            'autopay',
            'one hundred twenty',
          ],
          trainerGuidanceArabic:
              'وضح التوفير الواضح بالأرقام: 120 دولار شهريا مع إنترنت مفتوح.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-026-04'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-026-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Forty dollars less every month AND unlimited data? That is fantastic, Alex. Please switch us right away.',
          trainerGuidanceArabic: 'أكد التغيير واشكره على ولائه الطويل للشركة.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-026-05'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-026-05',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'I have updated your plan to Unlimited Starter, saving you forty dollars each month. Thank you so much for being a loyal customer with us for over a decade!',
          requiredKeywords: [
            'unlimited starter',
            'saving',
            'forty dollars',
            'loyal',
          ],
          isFinal: true,
        ),
      ],
      metadata: const ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes: 'Grandfathered plan migration to current unlimited tier with cost savings.',
      ),
    ),

    // 27: Prepaid to Postpaid Account Migration
    Scenario(
      id: 'scen-27-prepaid-to-postpaid',
      title: 'Prepaid to Postpaid Line Migration & Device Upgrade',
      moduleIndex: 3,
      category: 'Sales & Discovery',
      difficulty: 'intermediate',
      customerPersona:
          'Maria Gonzalez (Prepaid Customer Wanting Flagship Phone)',
      skillTags: const ['Migration', 'Credit Check Disclosure', 'Upgrade'],
      expectedResponse: _defaultAgentGreeting,
      customerResponse: 'Hi Alex! Maria Gonzalez here. I have had AT&T Prepaid for three years, but I want to get the new iPhone on monthly installments. Can I switch my account to postpaid without losing my phone number?',
      requiredAnchors: TrainingConstants.greetingRequiredAnchors,
      contextNotes: 'Prepaid to postpaid migration preserves the phone number, transfers remaining prepaid balance as bill credit, and requires credit check disclosure before financing.',
      turns: const [
        ScenarioTurn(
          id: 'turn-027-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: _defaultAgentGreeting,
          requiredKeywords: ['att', 'alex', 'name'],
          trainerGuidanceArabic: 'رحب بماريا واشرح لها خطوات النقل من كارت (Prepaid) إلى خط فاتورة (Postpaid).',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-027-02'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-027-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Will my phone number stay the same, and what happens to the twenty dollars balance I just added to my prepaid account?',
          trainerGuidanceArabic: 'طمنها: الرقم يفضل زي ما هو بدون تغيير، والرصيد المتبقي بيتحول لرصيد دائن (Credit) على أول فاتورة.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-027-03'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-027-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'Yes, Maria! You keep your exact phone number, and any unused prepaid balance transfers directly as a credit on your first postpaid bill. Moving to postpaid also qualifies you for device installment financing.',
          requiredKeywords: [
            'keep',
            'phone number',
            'credit',
            'installment',
            'postpaid',
          ],
          trainerGuidanceArabic: 'وضح ميزة تقسيط الأجهزة المتاحة على الفاتورة.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-027-04'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-027-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Does moving to postpaid require a credit check to finance the phone?',
          trainerGuidanceArabic: 'أكد على إفصاح الفحص الائتماني (Credit check disclosure) بوضوح وأمانة.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-027-05'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-027-05',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Yes, Maria. Financing a device on an installment plan requires a standard credit evaluation. With your three-year positive payment history with us, we can begin that seamlessly.',
          requiredKeywords: ['credit evaluation', 'history', 'installment'],
          isFinal: true,
        ),
      ],
      metadata: const ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes: 'Prepaid-to-postpaid migration and credit check disclosure.',
      ),
    ),

    // 28: FirstNet / Military / Appreciation Discount
    Scenario(
      id: 'scen-28-firstnet-appreciation',
      title: 'FirstNet & 25% Appreciation Discount Validation',
      moduleIndex: 3,
      category: 'Sales & Discovery',
      difficulty: 'intermediate',
      customerPersona: 'Lieutenant Mark Ramirez (Firefighter & Paramedic)',
      skillTags: const ['FirstNet', 'Appreciation Discount', 'Validation'],
      expectedResponse: _defaultAgentGreeting,
      customerResponse: 'Alex, my name is Mark Ramirez. I am a paramedic and captain with the county fire department. A colleague told me AT&T offers a twenty-five percent discount for first responders and military. How do I get that on my family plan?',
      requiredAnchors: TrainingConstants.greetingRequiredAnchors,
      contextNotes: 'First Responders, Military, Veterans, Teachers, and Nurses receive a 25% monthly discount on unlimited wireless plans via identity verification with ID.me or work credentials.',
      turns: const [
        ScenarioTurn(
          id: 'turn-028-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: _defaultAgentGreeting,
          requiredKeywords: ['att', 'alex', 'name'],
          trainerGuidanceArabic:
              'استقبل مارك واشكره على خدمته للمجتمع كرجل إطفاء ومسعف.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-028-02'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-028-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Does the twenty-five percent appreciation discount apply to all four lines on my family plan?',
          trainerGuidanceArabic: 'اشكره على خدمته وأكد له إن خصم الـ 25% بينطبق على جميع خطوط باقات Unlimited المؤهلة في حسابه.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-028-03'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-028-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'First, Captain Ramirez, thank you for your service to our community. Yes, our First Responder Appreciation offer provides a full twenty-five percent monthly discount across all eligible unlimited lines on your account.',
          requiredKeywords: [
            'thank you',
            'service',
            'twenty-five percent',
            'discount',
            'lines',
          ],
          trainerGuidanceArabic: 'ابدأ بـ "thank you for your service".',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-028-04'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-028-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'That saves my family over fifty dollars every month! What proof or documents do I need to submit?',
          trainerGuidanceArabic:
              'اشرح كيفية رفع وثيقة العمل أو عبر منصة ID.me في دقائق.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-028-05'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-028-05',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'I am sending a secure link to your phone right now. You can upload a photo of your departmental ID or paystub, and your twenty-five percent discount will appear within one to two billing cycles.',
          requiredKeywords: [
            'secure link',
            'upload',
            'twenty-five percent',
            'billing cycles',
          ],
          isFinal: true,
        ),
      ],
      metadata: const ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes: '25% Appreciation discount verification for first responders and military.',
      ),
    ),

    // 29: Dead Air / Silent Caller Floor Protocol
    Scenario(
      id: 'scen-29-dead-air-protocol',
      title: 'Dead Air & Silent Caller Verification Protocol',
      moduleIndex: 2,
      category: 'Account Floor Care',
      difficulty: 'beginner',
      customerPersona: 'Silent Line (Caller Muted / Line Noise Only)',
      skillTags: const ['Dead Air Protocol', 'Call Control', 'Procedure'],
      expectedResponse: _defaultAgentGreeting,
      customerResponse: '... (Silence, distant faint background static) ...',
      requiredAnchors: TrainingConstants.greetingRequiredAnchors,
      contextNotes: 'Operational Floor Rule: If caller is silent upon connection, agent must deliver the standard dead-air prompt twice before concluding call, never hanging up abruptly.',
      turns: const [
        ScenarioTurn(
          id: 'turn-029-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: _defaultAgentGreeting,
          requiredKeywords: ['att', 'alex', 'name'],
          trainerGuidanceArabic: 'ابدأ بالتحية الإلزامية كالمعتاد.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-029-02'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-029-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: '... (Complete silence) ...',
          trainerGuidanceArabic: 'بروتوكول السكوت (Dead Air): العميل مش سامع أو الخط صامت. متقفلش في وشه! اسأل بوضوح: "Hello? I am unable to hear you. Can you hear me?"',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-029-03'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-029-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'Hello? This is Alex with AT&T. I am unable to hear audio on this line. If you can hear me, please speak or check your mute button.',
          requiredKeywords: ['alex', 'unable to hear', 'mute'],
          trainerGuidanceArabic: 'انتظر ثانيتين وقدم المحاولة الثانية الرسمية.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-029-04'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-029-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Oh! I am so sorry Alex! My Bluetooth headset was connected to the car in the garage! Can you hear me now?',
          trainerGuidanceArabic:
              'العميل رجع على الخط! رحب بيه فورا وكمل المكالمة.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-029-05'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-029-05',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Yes, I can hear you loud and clear now! How can I assist you with your AT&T account today?',
          requiredKeywords: ['hear', 'clear', 'assist'],
          isFinal: true,
        ),
      ],
      metadata: const ContentMetadata(
        provenance: ProvenanceTier.workReported,
        notes: 'Floor protocol for dead air check and professional patience.',
      ),
    ),

    // 30: Skeptical Closer / Reluctant Customer Objection Handling
    Scenario(
      id: 'scen-30-skeptical-closer',
      title: 'Skeptical Customer Closer & Risk Reversal Handling',
      moduleIndex: 3,
      category: 'Sales & Discovery',
      difficulty: 'advanced',
      customerPersona: 'Victor Stone (Cautious Commercial Contractor)',
      skillTags: const ['Closing', 'Objection Handling', 'AERD'],
      expectedResponse: _defaultAgentGreeting,
      customerResponse: 'Alex, my name is Victor Stone. Everything you said about upgrading our three crew tablets to the unlimited plan sounds nice, but every time I make a change with a phone company, my bill ends up full of hidden fees. Why should I trust you today?',
      requiredAnchors: TrainingConstants.greetingRequiredAnchors,
      contextNotes: 'Victor is ready to buy but held back by fear of billing surprises. The agent must deliver transparent billing recap, mention the 14-day risk-free guarantee, and invite confidence.',
      turns: const [
        ScenarioTurn(
          id: 'turn-030-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: _defaultAgentGreeting,
          requiredKeywords: ['att', 'alex', 'name'],
          trainerGuidanceArabic: 'استقبل فيكتور بثقة وحيادية واضحة.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-030-02'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-030-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Give me one good reason to believe my bill will actually be what you quoted today with no surprises.',
          trainerGuidanceArabic: 'طبق Risk Reversal: اعترف بمخاوفه (AERD)، اقرأ له ملخص الفاتورة الشامل متضمنا الضرائب المتوقعة، وذكره بضمان الـ 14 يوم للإلغاء بدون شروط.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-030-03'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-030-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'I completely respect your caution, Victor. I am reviewing the exact customer summary with you right now: exactly sixty dollars total for the three tablets with AutoPay, plus standard local taxes. You are protected by our fourteen-day return period if you are not fully satisfied.',
          requiredKeywords: [
            'respect',
            'summary',
            'sixty dollars',
            'taxes',
            'fourteen-day',
          ],
          trainerGuidanceArabic:
              'أكد على الشفافية التامة في التسعير وفترة الـ 14 يوم.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-030-04'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-030-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'I appreciate the straight talk and the exact breakdown, Alex. That is the transparency I was looking for. Go ahead and put the order through.',
          trainerGuidanceArabic:
              'أتمم الإجراء بثقة واشكره على ثقته فيك وفي أليكس.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-030-05'),
          ],
        ),
        ScenarioTurn(
          id: 'turn-030-05',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'It has been my pleasure, Victor. Your order is submitted, the confirmation is in your email, and your lines are active. Thank you for choosing AT&T!',
          requiredKeywords: ['pleasure', 'order', 'submitted', 'confirmation'],
          isFinal: true,
        ),
      ],
      metadata: const ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes: 'Risk reversal, transparent pricing summary, and confident closing.',
      ),
    ),
  ];

  /// Look up scenario by ID
  static Scenario? findById(String id) {
    try {
      return allScenarios.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Get scenarios by category
  static List<Scenario> getByCategory(String category) {
    return allScenarios.where((s) => s.category == category).toList();
  }

  /// Get all unique skill tags across the catalog
  static List<String> get allSkillTags {
    final tags = <String>{};
    for (final s in allScenarios) {
      tags.addAll(s.skillTags);
    }
    return tags.toList()..sort();
  }
}
