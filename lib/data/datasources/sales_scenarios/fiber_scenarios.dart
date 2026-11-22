import '../../../core/constants/training_constants.dart';
import '../../../domain/entities/sales_scenario.dart';
import '../../../domain/entities/scenario.dart';

abstract class FiberScenariosCatalog {
  static final List<SalesScenario> scenarios = [
    // Scenario 9: Cable Frustrated Homeowner (Fiber 300)
    SalesScenario(
      id: 'sales-09-fiber-cable-frustrated',
      title: 'Frustrated Cable Internet Switch & Symmetrical Upload Need',
      category: 'fiber_discovery',
      difficulty: 'intermediate',
      profile: const SalesCustomerProfile(
        name: 'Rachel Adams',
        tone: 'exasperated with cable company',
        currentProvider: 'Comcast / Xfinity Cable 200 Mbps',
        householdNeeds: 'Reliable Wi-Fi for Zoom and streaming without price creeping every 6 months',
        financialConstraint: 'Wants bill under \$60/mo with equipment included',
        coreBlocker:
            'Fears equipment rental fees and underground installation messes',
      ),
      contextNotes: 'Customer calls wireless line to complain about cable internet bills.',
      skillTags: [
        'Cable Comparison',
        'Symmetrical Upload',
        'Address Qualification',
      ],
      prohibitedPromises: [
        'guarantee fiber is at her house without running address check',
        'promise free installation forever',
      ],
      mandatoryDisclosures: [
        'AT&T Fiber availability requires exact address verification in qualification database',
        'Wi-Fi 6 gateway equipment is included with service',
      ],
      fictionalCandidateProducts: ['prod-fiber-300'],
      turns: [
        const SalesTurn(
          id: 'turn-f09-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: TrainingConstants.standardGreeting,
          phase: SalesPhase.greeting,
          requiredKeywords: ['att', 'alex', 'first', 'last', 'name'],
          trainerGuidanceArabic: 'ابدأ بالترحيب الإلزامي.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-f09-02'),
          ],
        ),
        const SalesTurn(
          id: 'turn-f09-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Hello Alex, this is Rachel Adams. I am calling because my cable internet bill just went up to eighty-five dollars again, and every afternoon my Zoom calls freeze. Does AT&T have anything better in my area?',
          phase: SalesPhase.initialResolution,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-f09-03'),
          ],
        ),
        const SalesTurn(
          id: 'turn-f09-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'I completely understand that frustration, Rachel. Cable lines slow down during peak hours because you share bandwidth with the neighborhood. May I have your street address and zip code so I can check if our 100% Fiber network is available for your home?',
          phase: SalesPhase.discovery,
          requiredKeywords: [
            'understand',
            'cable',
            'fiber',
            'may i',
            'address',
          ],
          trainerGuidanceArabic: 'اشرح الفرق بين الكابل المشترك والفايبر الخاص واستأذن في العنوان لفحصه.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-f09-04'),
          ],
        ),
        const SalesTurn(
          id: 'turn-f09-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'My address is 742 Evergreen Terrace, Springfield, 62704. Please tell me you have fiber there!',
          phase: SalesPhase.discovery,
          branches: [
            ScenarioBranch(
              conditionKey: 'qualified',
              nextTurnId: 'turn-f09-05A',
              description: 'Address qualifies for Fiber 300',
            ),
            ScenarioBranch(
              conditionKey: 'decline',
              nextTurnId: 'turn-f09-05B',
              description: 'Customer hesitates about switching',
            ),
            ScenarioBranch(
              conditionKey: 'needs_check',
              nextTurnId: 'turn-f09-05C',
              description: 'Facility port status requires technician pre-check',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-f09-05A',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Great news, Rachel! Your address qualifies for AT&T Fiber 300 Mbps with symmetrical upload and download speeds, unlimited data, and Wi-Fi equipment included for just fifty-five dollars a month with AutoPay.',
          phase: SalesPhase.valueBridge,
          requiredKeywords: [
            'qualifies',
            '300',
            'symmetrical',
            'equipment included',
            'fifty five',
          ],
          trainerGuidanceArabic:
              'بشر العميل بتأهيل العنوان واذكر السعر وميزة الراوتر المجاني.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-f09-06A'),
          ],
        ),
        const SalesTurn(
          id: 'turn-f09-06A',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Fifty-five dollars with equipment included saves me thirty dollars a month, and symmetrical upload will fix my Zoom calls! Let us schedule the installation.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.qualifiedAccept,
        ),
        const SalesTurn(
          id: 'turn-f09-05B',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'I understand your hesitation, Rachel. Switching providers takes planning. We will leave your account as is, and your address qualification will remain on file whenever you are ready.',
          phase: SalesPhase.closing,
          requiredKeywords: ['understand', 'hesitation', 'leave', 'whenever'],
          trainerGuidanceArabic:
              'احترم تردد العميل واحتفظ بتأهيل العنوان بدون ضغط.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-f09-06B'),
          ],
        ),
        const SalesTurn(
          id: 'turn-f09-06B',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Thanks Alex. I will talk to my landlord about scheduling an installation date and call you back.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.respectfulNoSale,
        ),
        const SalesTurn(
          id: 'turn-f09-05C',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Your street has fiber facilities nearby, but the connection terminal at your property requires a brief engineering review to confirm drop wire availability.',
          phase: SalesPhase.eligibilityBoundary,
          requiredKeywords: [
            'terminal',
            'engineering review',
            'drop wire',
            'confirm',
          ],
          trainerGuidanceArabic:
              'وضح بأمانة أن البوكس محتاج فحص هندسي مسبق قبل تأكيد الموعد.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-f09-06C'),
          ],
        ),
        const SalesTurn(
          id: 'turn-f09-06C',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'I appreciate your honesty in checking the engineering status first. Please submit the ticket and notify me once verified.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.needsVerification,
        ),
      ],
    ),

    // Scenario 10: Remote Architecture Firm Large CAD Uploader (Fiber 1000)
    SalesScenario(
      id: 'sales-10-fiber-wfh-heavy-uploader',
      title: 'Architectural Design Firm Large Cloud Upload Need',
      category: 'fiber_discovery',
      difficulty: 'challenging',
      profile: const SalesCustomerProfile(
        name: 'Marcus Brody',
        tone: 'professional and impatient with slow uploads',
        currentProvider: 'Spectrum Cable 400 Mbps (with only 15 Mbps upload)',
        householdNeeds:
            'Uploading 5GB 3D CAD modeling files to cloud servers daily',
        financialConstraint: 'Business expense; cares about gigabit upload speed over saving \$10',
        coreBlocker:
            'Does not realize cable upload speeds are capped at 15–20 Mbps',
      ),
      contextNotes:
          'Customer spends 45 minutes uploading architectural project files.',
      skillTags: ['Gigabit Upload', 'Symmetrical Bandwidth', 'B2B Home Office'],
      prohibitedPromises: ['promise zero latency across whole global internet'],
      mandatoryDisclosures: [
        'Gigabit connection speeds require Wi-Fi 6 hardware or direct Cat6 Ethernet connection',
        'Address must qualify for 100% fiber optic infrastructure',
      ],
      fictionalCandidateProducts: ['prod-fiber-1000'],
      turns: [
        const SalesTurn(
          id: 'turn-f10-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: TrainingConstants.standardGreeting,
          phase: SalesPhase.greeting,
          trainerGuidanceArabic:
              'ابدأ بالترحيب الإلزامي الكامل متضمناً اسمك Alex وشركة AT&T.',
          requiredKeywords: ['att', 'alex', 'first', 'last', 'name'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-f10-02'),
          ],
        ),
        const SalesTurn(
          id: 'turn-f10-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Alex, my name is Marcus Brody. I run an architectural design studio from my home office. My cable provider gives me 400 Mbps download, but when I upload 5GB blueprints to our cloud server, it takes 45 minutes! Why is it so slow?',
          phase: SalesPhase.initialResolution,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-f10-03'),
          ],
        ),
        const SalesTurn(
          id: 'turn-f10-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'I understand your frustration, Marcus. Cable technology is asymmetrical: they give you fast downloads but choke upload speeds down to only 15 or 20 Mbps. AT&T Fiber 1 GIG gives you a full 1000 Mbps download and 1000 Mbps upload.',
          phase: SalesPhase.valueBridge,
          requiredKeywords: [
            'asymmetrical',
            '1000 mbps upload',
            'fiber',
            'blueprints',
          ],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-f10-04'),
          ],
        ),
        const SalesTurn(
          id: 'turn-f10-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'A full 1000 Mbps upload? That means my 5GB blueprint files would upload in less than a minute instead of 45 minutes! Is that verified at my address?',
          phase: SalesPhase.discovery,
          branches: [
            ScenarioBranch(
              conditionKey: 'qualified',
              nextTurnId: 'turn-f10-05A',
            ),
            ScenarioBranch(conditionKey: 'decline', nextTurnId: 'turn-f10-05B'),
            ScenarioBranch(
              conditionKey: 'needs_check',
              nextTurnId: 'turn-f10-05C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-f10-05A',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'I verified your address, Marcus: 1 GIG Fiber is live right outside your property. For eighty dollars a month with AutoPay, equipment is included with unlimited data and zero throttling.',
          phase: SalesPhase.closing,
          requiredKeywords: [
            'verified',
            'eighty dollars',
            '1 gig',
            'unlimited',
          ],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-f10-06A'),
          ],
        ),
        const SalesTurn(
          id: 'turn-f10-06A',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Cutting my upload time from 45 minutes to under a minute will transform my workday. Book the technician for the earliest available morning slot.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.qualifiedAccept,
        ),
        const SalesTurn(
          id: 'turn-f10-05B',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'I understand completely, Marcus. If you need to check with your business partner first, we will keep your address qualification notes saved on file.',
          phase: SalesPhase.closing,
          requiredKeywords: ['understand', 'partner', 'saved', 'file'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-f10-06B'),
          ],
        ),
        const SalesTurn(
          id: 'turn-f10-06B',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Let me verify our studio expenses with my accountant first. Thank you for the technical explanation, Alex.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.respectfulNoSale,
        ),
        const SalesTurn(
          id: 'turn-f10-05C',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Your address shows fiber in the neighborhood, but we must verify whether direct conduit exists from the street junction to your detached home office building.',
          phase: SalesPhase.eligibilityBoundary,
          requiredKeywords: ['verify', 'conduit', 'junction', 'detached'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-f10-06C'),
          ],
        ),
        const SalesTurn(
          id: 'turn-f10-06C',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'My office is in a detached carriage house, so that conduit check is essential. Let us run the site survey first.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.needsVerification,
        ),
      ],
    ),

    // Scenario 11: Competitive Multiplayer Gaming Household (Fiber 500)
    SalesScenario(
      id: 'sales-11-fiber-gaming-latency',
      title: 'Online Gaming Low Latency & High Bandwidth Fit',
      category: 'fiber_discovery',
      difficulty: 'intermediate',
      profile: const SalesCustomerProfile(
        name: 'Kevin Zhao',
        tone: 'competitive gamer and college student',
        currentProvider: 'Cable 300 Mbps',
        householdNeeds: 'Ultra-low ping/latency, no jitter, concurrent 4K streams by roommates',
        financialConstraint:
            'Split four ways between roommates (\$15–\$20 each)',
        coreBlocker: 'Suffers 120ms ping spikes when roommates stream video',
      ),
      contextNotes: 'Caller complains about ping spikes during competitive gaming matches.',
      skillTags: ['Gaming Latency', 'Ping Jitter', 'Roommate Split'],
      prohibitedPromises: ['promise 0ms ping to all game servers'],
      mandatoryDisclosures: [
        'Fiber latency advantages are best experienced over direct wired Ethernet connection',
        'Ping to game servers depends on distance to game host server data centers',
      ],
      fictionalCandidateProducts: ['prod-fiber-500'],
      turns: [
        const SalesTurn(
          id: 'turn-f11-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: TrainingConstants.standardGreeting,
          phase: SalesPhase.greeting,
          trainerGuidanceArabic:
              'ابدأ بالترحيب الإلزامي الكامل متضمناً اسمك Alex وشركة AT&T.',
          requiredKeywords: ['att', 'alex', 'first', 'last', 'name'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-f11-02'),
          ],
        ),
        const SalesTurn(
          id: 'turn-f11-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Yo Alex, Kevin Zhao here. Whenever my two roommates watch Netflix or download game patches, my ping in competitive matches spikes from 30ms to 150ms. How does fiber help with ping?',
          phase: SalesPhase.initialResolution,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-f11-03'),
          ],
        ),
        const SalesTurn(
          id: 'turn-f11-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'I hear you, Kevin! Cable networks suffer from bufferbloat during heavy traffic. AT&T Fiber 500 uses dedicated light signals, delivering ultra-low latency and symmetrical bandwidth so roommate downloads do not choke your gaming ping.',
          phase: SalesPhase.valueBridge,
          requiredKeywords: [
            'bufferbloat',
            'latency',
            'symmetrical',
            'fiber 500',
            'ping',
          ],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-f11-04'),
          ],
        ),
        const SalesTurn(
          id: 'turn-f11-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Dedicated light signals sound clean. How much is Fiber 500, and is there an equipment rental fee for the router?',
          phase: SalesPhase.objectionHandling,
          branches: [
            ScenarioBranch(conditionKey: 'accept', nextTurnId: 'turn-f11-05A'),
            ScenarioBranch(conditionKey: 'decline', nextTurnId: 'turn-f11-05B'),
            ScenarioBranch(
              conditionKey: 'needs_check',
              nextTurnId: 'turn-f11-05C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-f11-05A',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'It is sixty-five dollars a month with AutoPay, with Wi-Fi 6 router equipment included and zero equipment rental fees. Split four ways, that is only sixteen dollars per roommate.',
          phase: SalesPhase.closing,
          requiredKeywords: [
            'sixty-five',
            'equipment included',
            'roommate',
            'autopay',
          ],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-f11-06A'),
          ],
        ),
        const SalesTurn(
          id: 'turn-f11-06A',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Sixteen bucks each for no ping spikes is a no-brainer. Let us get it ordered and installed before tournament weekend.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.qualifiedAccept,
        ),
        const SalesTurn(
          id: 'turn-f11-05B',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'I understand completely, Kevin. Roommate expenses need group approval. Pitch it to your roommates and give us a call whenever you all agree.',
          phase: SalesPhase.closing,
          requiredKeywords: ['understand', 'roommates', 'approval', 'whenever'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-f11-06B'),
          ],
        ),
        const SalesTurn(
          id: 'turn-f11-06B',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'I will talk to the guys in our group chat tonight. Appreciate the info, Alex!',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.respectfulNoSale,
        ),
        const SalesTurn(
          id: 'turn-f11-05C',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'We must verify your apartment unit number in our system first, as some complex buildings share a single riser and require property manager approval.',
          phase: SalesPhase.eligibilityBoundary,
          requiredKeywords: [
            'verify',
            'unit number',
            'apartment',
            'property manager',
          ],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-f11-06C'),
          ],
        ),
        const SalesTurn(
          id: 'turn-f11-06C',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Let me check our lease agreement to see if the landlord has exclusive cable contracts. I will follow up.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.needsVerification,
        ),
      ],
    ),

    // Scenario 12: Smart Home IoT Heavy Ecosystem (Fiber 1000)
    SalesScenario(
      id: 'sales-12-fiber-smart-home-ecosystem',
      title: 'Smart Home Security & Multi-Camera Upload Density',
      category: 'fiber_discovery',
      difficulty: 'intermediate',
      profile: const SalesCustomerProfile(
        name: 'Victoria Stirling',
        tone: 'tech-enthusiast homeowner',
        currentProvider: 'Cable 500 Mbps (35 Mbps upload)',
        householdNeeds: 'Six outdoor 4K security cameras uploading 24/7 video streams, smart locks, thermostats',
        financialConstraint:
            'High budget; prioritizes camera uptime and no dropped feeds',
        coreBlocker: 'Security camera feeds constantly drop offline when children stream movies',
      ),
      contextNotes: 'Security cameras keep buffering and missing motion detection alerts.',
      skillTags: ['Smart Home IoT', 'Continuous Video Upload', 'Fiber Gigabit'],
      prohibitedPromises: [
        'guarantee cameras never disconnect on third-party Wi-Fi',
      ],
      mandatoryDisclosures: [
        'Continuous cloud camera recording requires adequate upstream bandwidth',
        'Gigabit speeds subject to internal Wi-Fi device congestion and gateway placement',
      ],
      fictionalCandidateProducts: ['prod-fiber-1000'],
      turns: [
        const SalesTurn(
          id: 'turn-f12-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: TrainingConstants.standardGreeting,
          phase: SalesPhase.greeting,
          trainerGuidanceArabic:
              'ابدأ بالترحيب الإلزامي الكامل متضمناً اسمك Alex وشركة AT&T.',
          requiredKeywords: ['att', 'alex', 'first', 'last', 'name'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-f12-02'),
          ],
        ),
        const SalesTurn(
          id: 'turn-f12-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Hi Alex, Victoria Stirling. I installed six 4K outdoor security cameras around our home, and half the time the cloud recording feed drops offline. Why cannot my cable internet handle six security cameras?',
          phase: SalesPhase.initialResolution,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-f12-03'),
          ],
        ),
        const SalesTurn(
          id: 'turn-f12-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'I understand your concern for home security, Victoria. Each 4K camera constantly pushes 4 to 8 Mbps upstream. With six cameras, you are maxing out your cable upload capacity. AT&T Fiber 1 GIG gives you 1000 Mbps upload, handling dozens of 4K cameras with ease.',
          phase: SalesPhase.valueBridge,
          requiredKeywords: [
            'security',
            'upstream',
            '1000 mbps',
            'fiber',
            'cameras',
          ],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-f12-04'),
          ],
        ),
        const SalesTurn(
          id: 'turn-f12-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'That explains why the cameras choke! Can your gateway support all my smart locks and sensors as well?',
          phase: SalesPhase.objectionHandling,
          branches: [
            ScenarioBranch(conditionKey: 'accept', nextTurnId: 'turn-f12-05A'),
            ScenarioBranch(conditionKey: 'decline', nextTurnId: 'turn-f12-05B'),
            ScenarioBranch(
              conditionKey: 'needs_check',
              nextTurnId: 'turn-f12-05C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-f12-05A',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Yes, our Wi-Fi 6 gateway supports over 100 concurrent smart devices seamlessly. For eighty dollars a month with AutoPay, your security system will have bulletproof bandwidth.',
          phase: SalesPhase.closing,
          requiredKeywords: ['wi-fi 6', 'eighty dollars', 'devices', 'autopay'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-f12-06A'),
          ],
        ),
        const SalesTurn(
          id: 'turn-f12-06A',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Having reliable 24/7 camera recording is essential for our family. Set up our installation order right away.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.qualifiedAccept,
        ),
        const SalesTurn(
          id: 'turn-f12-05B',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'I understand, Victoria. If you want to consult with your security system installer first, we will keep your fiber qualification saved in our system.',
          phase: SalesPhase.closing,
          requiredKeywords: ['understand', 'consult', 'installer', 'saved'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-f12-06B'),
          ],
        ),
        const SalesTurn(
          id: 'turn-f12-06B',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Let me have my alarm technician look at the gateway specs first. Thank you, Alex.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.respectfulNoSale,
        ),
        const SalesTurn(
          id: 'turn-f12-05C',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Let me verify your home optical network terminal terminal wiring first to make sure direct fiber optic line reaches your smart home media panel.',
          phase: SalesPhase.eligibilityBoundary,
          requiredKeywords: ['verify', 'terminal', 'wiring', 'panel'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-f12-06C'),
          ],
        ),
        const SalesTurn(
          id: 'turn-f12-06C',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'I need to locate our media enclosure box in the basement first. Let me find that and call back.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.needsVerification,
        ),
      ],
    ),

    // Scenario 13: Existing Wireless Customer Bundle Discovery (Fiber 300)
    SalesScenario(
      id: 'sales-13-fiber-bundle-wireless-discount',
      title: 'Unified Account & Wireless-Fiber Combined Value',
      category: 'fiber_discovery',
      difficulty: 'beginner',
      profile: const SalesCustomerProfile(
        name: 'Brian Gallagher',
        tone: 'friendly loyal wireless subscriber',
        currentProvider:
            'AT&T Wireless for 8 years + Spectrum for home internet',
        householdNeeds: 'Two adults streaming TV and general web browsing',
        financialConstraint:
            'Looking to consolidate bills and save on overall telecom budget',
        coreBlocker:
            'Did not know AT&T offered home internet in his neighborhood',
      ),
      contextNotes: 'Caller asks to pay his wireless bill; rep discovers he has cable internet.',
      skillTags: ['Care to Sales Pivot', 'Account Consolidation', 'Fiber 300'],
      prohibitedPromises: ['promise wireless is free when adding fiber'],
      mandatoryDisclosures: [
        'Combining wireless and fiber provides dedicated billing convenience and applicable promotions',
        'Address must qualify for fiber optic service',
      ],
      fictionalCandidateProducts: ['prod-fiber-300'],
      turns: [
        const SalesTurn(
          id: 'turn-f13-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: TrainingConstants.standardGreeting,
          phase: SalesPhase.greeting,
          trainerGuidanceArabic:
              'ابدأ بالترحيب الإلزامي الكامل متضمناً اسمك Alex وشركة AT&T.',
          requiredKeywords: ['att', 'alex', 'first', 'last', 'name'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-f13-02'),
          ],
        ),
        const SalesTurn(
          id: 'turn-f13-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Hi Alex, Brian Gallagher. I just paid my mobile bill online, but I wanted to make sure my credit card went through properly.',
          phase: SalesPhase.initialResolution,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-f13-03'),
          ],
        ),
        const SalesTurn(
          id: 'turn-f13-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'Your payment went through perfectly, Brian! Thank you for being a loyal customer for eight years. While I have your account open, may I check if your home qualifies for our 100% Fiber internet to consolidate your monthly bills?',
          phase: SalesPhase.explorationPermission,
          requiredKeywords: [
            'payment',
            'loyal',
            'may i',
            'fiber',
            'consolidate',
          ],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-f13-04'),
          ],
        ),
        const SalesTurn(
          id: 'turn-f13-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'I did not even know AT&T had fiber on my street. I pay Spectrum seventy-five dollars right now. What does AT&T Fiber cost?',
          phase: SalesPhase.discovery,
          branches: [
            ScenarioBranch(
              conditionKey: 'qualified',
              nextTurnId: 'turn-f13-05A',
            ),
            ScenarioBranch(conditionKey: 'decline', nextTurnId: 'turn-f13-05B'),
            ScenarioBranch(
              conditionKey: 'needs_check',
              nextTurnId: 'turn-f13-05C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-f13-05A',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Your address qualifies for Fiber 300 at fifty-five dollars a month with AutoPay, saving you twenty dollars every month compared to Spectrum, with equipment included.',
          phase: SalesPhase.closing,
          requiredKeywords: [
            'fifty-five',
            'saving',
            'twenty dollars',
            'equipment included',
          ],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-f13-06A'),
          ],
        ),
        const SalesTurn(
          id: 'turn-f13-06A',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Saving twenty dollars a month and putting both my mobile and internet on one AT&T bill is fantastic. Sign me up!',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.qualifiedAccept,
        ),
        const SalesTurn(
          id: 'turn-f13-05B',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'I understand completely, Brian. If you prefer to keep your home internet separate for now, we will leave everything as is.',
          phase: SalesPhase.closing,
          requiredKeywords: ['understand', 'separate', 'leave', 'as is'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-f13-06B'),
          ],
        ),
        const SalesTurn(
          id: 'turn-f13-06B',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'I will keep them separate for now until my Spectrum agreement ends. Thanks Alex!',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.respectfulNoSale,
        ),
        const SalesTurn(
          id: 'turn-f13-05C',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Let me verify your billing address versus your physical installation address to ensure our system checks the exact home service drop.',
          phase: SalesPhase.eligibilityBoundary,
          requiredKeywords: ['verify', 'physical', 'installation', 'drop'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-f13-06C'),
          ],
        ),
        const SalesTurn(
          id: 'turn-f13-06C',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'My billing address is a P.O. Box, so let me give you our physical street address to verify.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.needsVerification,
        ),
      ],
    ),

    // Scenario 14: 55+ Community Special Rate Qualification Check
    SalesScenario(
      id: 'sales-14-fiber-55-plus-community',
      title: 'Senior Community Conditional Pricing Inquiry',
      category: 'fiber_discovery',
      difficulty: 'challenging',
      profile: const SalesCustomerProfile(
        name: 'Dorothy Evans',
        tone: 'cautious senior citizen',
        currentProvider: 'CenturyLink DSL 10 Mbps',
        householdNeeds: 'Reliable video calling with grandchildren, telehealth doctor visits',
        financialConstraint: 'Strict fixed pension budget',
        coreBlocker: 'Neighbor told her AT&T offers special \$30 senior discount, but offer is unverified',
      ),
      contextNotes: 'Customer asks for a rumored \$30 senior rate that may not exist publicly.',
      skillTags: [
        'Eligibility Verification',
        'Ethical Transparency',
        'Senior Care',
      ],
      prohibitedPromises: [
        'promise thirty dollar senior rate without verification',
        'invent special unpublished discounts',
      ],
      mandatoryDisclosures: [
        'Fiber 300 standard promotional pricing is fifty-five dollars with AutoPay',
        'Special senior or low-income programs require formal government qualification (such as Access program)',
      ],
      fictionalCandidateProducts: ['prod-fiber-300'],
      turns: [
        const SalesTurn(
          id: 'turn-f14-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: TrainingConstants.standardGreeting,
          phase: SalesPhase.greeting,
          trainerGuidanceArabic:
              'ابدأ بالترحيب الإلزامي الكامل متضمناً اسمك Alex وشركة AT&T.',
          requiredKeywords: ['att', 'alex', 'first', 'last', 'name'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-f14-02'),
          ],
        ),
        const SalesTurn(
          id: 'turn-f14-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Hello young man. My name is Dorothy Evans. My neighbor told me that AT&T gives seniors in our 55+ community a thirty dollar fiber internet plan. Is that true?',
          phase: SalesPhase.initialResolution,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-f14-03'),
          ],
        ),
        const SalesTurn(
          id: 'turn-f14-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'It is a pleasure to speak with you, Dorothy! To be completely transparent, our standard high-speed Fiber 300 plan is fifty-five dollars with AutoPay. We also participate in the federal Access program for qualifying low-income households, which requires an eligibility application.',
          phase: SalesPhase.valueBridge,
          requiredKeywords: [
            'transparent',
            'fifty-five',
            'autopay',
            'eligibility',
          ],
          trainerGuidanceArabic: 'كن صريحاً جداً مع كبار السن؛ وضح السعر الفعلي \$55 واشرح برنامج Access بدون وعود وهمية.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-f14-04'),
          ],
        ),
        const SalesTurn(
          id: 'turn-f14-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'I appreciate your honesty, Alex. Fifty-five dollars is still ten dollars less than what I pay CenturyLink for their sluggish 10 Mbps DSL. Can you check if my address has fiber?',
          phase: SalesPhase.discovery,
          branches: [
            ScenarioBranch(
              conditionKey: 'qualified',
              nextTurnId: 'turn-f14-05A',
            ),
            ScenarioBranch(conditionKey: 'decline', nextTurnId: 'turn-f14-05B'),
            ScenarioBranch(
              conditionKey: 'needs_check',
              nextTurnId: 'turn-f14-05C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-f14-05A',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Your address qualifies for Fiber 300! It will make video calls with your grandchildren crystal clear without freezing, for fifty-five dollars a month.',
          phase: SalesPhase.closing,
          requiredKeywords: [
            'qualifies',
            'grandchildren',
            'fifty-five',
            'crystal clear',
          ],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-f14-06A'),
          ],
        ),
        const SalesTurn(
          id: 'turn-f14-06A',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Seeing my grandchildren clearly without freezing is worth fifty-five dollars. Let us proceed, Alex.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.qualifiedAccept,
        ),
        const SalesTurn(
          id: 'turn-f14-05B',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'I completely respect your fixed budget, Dorothy. We will leave your CenturyLink DSL in place so you have time to apply for the federal Access program first.',
          phase: SalesPhase.closing,
          requiredKeywords: ['respect', 'budget', 'access program', 'leave'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-f14-06B'),
          ],
        ),
        const SalesTurn(
          id: 'turn-f14-06B',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Thank you for not pressuring an old lady, Alex. I will look up that Access program application first.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.respectfulNoSale,
        ),
        const SalesTurn(
          id: 'turn-f14-05C',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'We must verify your community HOA rules first, as some retirement villages require HOA clearance before technicians run exterior fiber drops.',
          phase: SalesPhase.eligibilityBoundary,
          requiredKeywords: ['verify', 'community', 'hoa', 'clearance'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-f14-06C'),
          ],
        ),
        const SalesTurn(
          id: 'turn-f14-06C',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Our HOA board is very strict about wiring on the siding. Let me get their written permission first.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.needsVerification,
        ),
      ],
    ),

    // Scenario 15: New Home Construction Move Order (Fiber 500)
    SalesScenario(
      id: 'sales-15-fiber-moving-new-construction',
      title: 'New Subdivision Relocation & Fiber Pre-Installation',
      category: 'fiber_discovery',
      difficulty: 'intermediate',
      profile: const SalesCustomerProfile(
        name: 'Anthony Rossi',
        tone: 'busy homeowner in the middle of moving',
        currentProvider: 'AT&T Fiber 300 at previous home',
        householdNeeds: 'Immediate internet connectivity on move-in day for home security and smart appliances',
        financialConstraint:
            'Willing to upgrade to 500 Mbps for larger new home layout',
        coreBlocker: 'New street might not be mapped in postal database yet',
      ),
      contextNotes: 'Customer is moving into a newly built home next week.',
      skillTags: ['Move Order', 'New Construction', 'Fiber 500'],
      prohibitedPromises: [
        'guarantee same-day installation in unmapped subdivision',
      ],
      mandatoryDisclosures: [
        'New construction addresses require GIS coordinates if postal address is not yet registered',
        'Exterior optical terminal installation may be required prior to indoor activation',
      ],
      fictionalCandidateProducts: ['prod-fiber-500'],
      turns: [
        const SalesTurn(
          id: 'turn-f15-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: TrainingConstants.standardGreeting,
          phase: SalesPhase.greeting,
          trainerGuidanceArabic:
              'ابدأ بالترحيب الإلزامي الكامل متضمناً اسمك Alex وشركة AT&T.',
          requiredKeywords: ['att', 'alex', 'first', 'last', 'name'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-f15-02'),
          ],
        ),
        const SalesTurn(
          id: 'turn-f15-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Hi Alex, Anthony Rossi. I am moving into a brand new subdivision in Austin next Friday. I love my AT&T Fiber at my current apartment. Can I transfer service to the new house?',
          phase: SalesPhase.initialResolution,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-f15-03'),
          ],
        ),
        const SalesTurn(
          id: 'turn-f15-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'Congratulations on the new home, Anthony! Let us look up the new street address right now to ensure the fiber line is provisioned and ready for your move-in date.',
          phase: SalesPhase.discovery,
          requiredKeywords: [
            'congratulations',
            'address',
            'provisioned',
            'move-in',
          ],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-f15-04'),
          ],
        ),
        const SalesTurn(
          id: 'turn-f15-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'The address is 104 Willow Creek Way, Austin, Texas. We also upgraded from an apartment to a 3,000 square foot house, so we might need faster speeds.',
          phase: SalesPhase.discovery,
          branches: [
            ScenarioBranch(
              conditionKey: 'qualified',
              nextTurnId: 'turn-f15-05A',
            ),
            ScenarioBranch(conditionKey: 'decline', nextTurnId: 'turn-f15-05B'),
            ScenarioBranch(
              conditionKey: 'needs_check',
              nextTurnId: 'turn-f15-05C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-f15-05A',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'The subdivision is pre-wired with 100% fiber! For a 3,000 sq ft home, Fiber 500 gives you double the bandwidth for only ten dollars more, and we can schedule the technician for your move-in Friday.',
          phase: SalesPhase.closing,
          requiredKeywords: ['pre-wired', 'fiber 500', 'ten dollars', 'friday'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-f15-06A'),
          ],
        ),
        const SalesTurn(
          id: 'turn-f15-06A',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Having internet ready on move-in day is huge. Book that Friday morning appointment for Fiber 500!',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.qualifiedAccept,
        ),
        const SalesTurn(
          id: 'turn-f15-05B',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'I understand, Anthony. If your moving date is still tentative, we will hold off on scheduling so you do not have to reschedule later.',
          phase: SalesPhase.closing,
          requiredKeywords: [
            'understand',
            'tentative',
            'hold off',
            'reschedule',
          ],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-f15-06B'),
          ],
        ),
        const SalesTurn(
          id: 'turn-f15-06B',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'The closing date might slip a few days. Let me confirm the keys handover and call you back.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.respectfulNoSale,
        ),
        const SalesTurn(
          id: 'turn-f15-05C',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'The builder has not completed the street address registration in the municipal GIS database yet; we must file an address validation ticket before booking an install.',
          phase: SalesPhase.eligibilityBoundary,
          requiredKeywords: [
            'validation',
            'ticket',
            'gis',
            'database',
            'builder',
          ],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-f15-06C'),
          ],
        ),
        const SalesTurn(
          id: 'turn-f15-06C',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'I will get the lot number and parcel ID from our builder to help your team locate the drop.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.needsVerification,
        ),
      ],
    ),

    // Scenario 16: Underground Engineering Survey Boundary (Fiber 1000)
    SalesScenario(
      id: 'sales-16-fiber-address-unverified',
      title: 'Underground Facility Review & Unverified Plant Boundary',
      category: 'fiber_discovery',
      difficulty: 'challenging',
      profile: const SalesCustomerProfile(
        name: 'Clara Oswald',
        tone: 'eager customer asking for immediate fiber',
        currentProvider: 'Comcast Cable',
        householdNeeds: 'Heavy 4K streaming and high bandwidth home office',
        financialConstraint: 'Ready to pay \$80/mo for 1 GIG Fiber immediately',
        coreBlocker: 'Physical fiber cable stops across the street; needs engineering roadway bore',
      ),
      contextNotes: 'Customer saw fiber trucks across the street and wants to order today.',
      skillTags: ['Engineering Review', 'Truth in Selling', 'Unverified Plant'],
      prohibitedPromises: [
        'guarantee order completion when engineering survey is required',
        'promise underground boring will happen this week',
      ],
      mandatoryDisclosures: [
        'If facility records show unverified plant, representative cannot place a live service order',
        'An engineering facility review ticket must be submitted to verify feeder capacity',
      ],
      fictionalCandidateProducts: ['prod-fiber-1000'],
      turns: [
        const SalesTurn(
          id: 'turn-f16-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: TrainingConstants.standardGreeting,
          phase: SalesPhase.greeting,
          trainerGuidanceArabic:
              'ابدأ بالترحيب الإلزامي الكامل متضمناً اسمك Alex وشركة AT&T.',
          requiredKeywords: ['att', 'alex', 'first', 'last', 'name'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-f16-02'),
          ],
        ),
        const SalesTurn(
          id: 'turn-f16-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Hi Alex, Clara Oswald. AT&T fiber optic trucks were on our road all week burying orange cables. My neighbor across the street already got fiber installed. Can I place my 1 GIG order right now?',
          phase: SalesPhase.initialResolution,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-f16-03'),
          ],
        ),
        const SalesTurn(
          id: 'turn-f16-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'Seeing fiber in your neighborhood is exciting, Clara! Let me pull up our engineering facilities database right now to verify if the terminal on your side of the street is live and ready for orders.',
          phase: SalesPhase.discovery,
          requiredKeywords: ['engineering', 'facilities', 'verify', 'terminal'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-f16-04'),
          ],
        ),
        const SalesTurn(
          id: 'turn-f16-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'My address is 402 North Oak Street. Can you book the technician to come out this Saturday?',
          phase: SalesPhase.discovery,
          branches: [
            ScenarioBranch(
              conditionKey: 'qualified',
              nextTurnId: 'turn-f16-05A',
            ),
            ScenarioBranch(conditionKey: 'decline', nextTurnId: 'turn-f16-05B'),
            ScenarioBranch(
              conditionKey: 'needs_check',
              nextTurnId: 'turn-f16-05C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-f16-05A',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Great news, Clara! The terminal right adjacent to your driveway went live yesterday. Your home is fully qualified for 1 GIG Fiber at eighty dollars a month with AutoPay.',
          phase: SalesPhase.closing,
          requiredKeywords: ['qualified', '1 gig', 'eighty dollars', 'autopay'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-f16-06A'),
          ],
        ),
        const SalesTurn(
          id: 'turn-f16-06A',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Fantastic! Book that Saturday installation appointment. I cannot wait to ditch cable.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.qualifiedAccept,
        ),
        const SalesTurn(
          id: 'turn-f16-05B',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'I understand, Clara. If you want to wait until your existing cable contract ends in three months, we will keep your address pre-qualified so you can order without penalty.',
          phase: SalesPhase.closing,
          requiredKeywords: [
            'understand',
            'cable contract',
            'pre-qualified',
            'penalty',
          ],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-f16-06B'),
          ],
        ),
        const SalesTurn(
          id: 'turn-f16-06B',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Good call. I will wait out the last 60 days on my cable agreement so I avoid their early termination fee.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.respectfulNoSale,
        ),
        const SalesTurn(
          id: 'turn-f16-05C',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'To be completely honest with you, Clara, the fiber terminal across the street is live, but your side of the roadway shows facility review required because crossing the road requires a municipal permit. I cannot place an order until our engineers clear the permit.',
          phase: SalesPhase.eligibilityBoundary,
          requiredKeywords: [
            'honest',
            'facility review',
            'permit',
            'cannot place an order',
          ],
          trainerGuidanceArabic: 'أمانة تامة: لا تضع طلب قبل انتهاء تصريح الحفر البلدي عبر الشارع.',
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-f16-06C'),
          ],
        ),
        const SalesTurn(
          id: 'turn-f16-06C',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'I really appreciate your honesty instead of making false promises and having a technician fail to show up. Please submit the engineering ticket and notify me once cleared.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.needsVerification,
        ),
      ],
    ),
  ];
}
