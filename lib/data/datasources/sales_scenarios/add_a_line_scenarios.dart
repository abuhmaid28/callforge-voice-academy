import '../../../core/constants/training_constants.dart';
import '../../../domain/entities/sales_scenario.dart';
import '../../../domain/entities/scenario.dart';

abstract class AddALineScenariosCatalog {
  static final List<SalesScenario> scenarios = [
    // Scenario 17: Teenager First Smartphone Line
    SalesScenario(
      id: 'sales-17-teenager-first-phone',
      title: 'First Smartphone Line for Middle School Student',
      category: 'add_a_line',
      difficulty: 'intermediate',
      profile: const SalesCustomerProfile(
        name: 'Maria Gonzalez',
        tone: 'protective and budget-conscious mother',
        currentProvider: 'AT&T Unlimited Extra (2 existing lines)',
        householdNeeds: 'Adding line for 13-year-old daughter for school bus tracking and safety',
        financialConstraint:
            'Does not want monthly bill to increase by more than \$40',
        coreBlocker: 'Fears daughter will rack up accidental purchases or wander into unsafe apps',
      ),
      contextNotes: 'Parent calls to ask about parental controls and costs for adding a 3rd line.',
      skillTags: ['Add-a-Line', 'Parental Controls', 'Multi-Line Discount'],
      prohibitedPromises: [
        'promise child can never access bad content on internet',
      ],
      mandatoryDisclosures: [
        'Adding a third line reduces per-line pricing on eligible unlimited plans',
        'Standard one-time thirty-five dollar activation fee applies unless promotional waiver is active',
        'Parental control app Secure Family is optional add-on',
      ],
      fictionalCandidateProducts: ['prod-add-a-line', 'prod-wireless-starter'],
      turns: [
        const SalesTurn(
          id: 'turn-a17-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: TrainingConstants.standardGreeting,
          phase: SalesPhase.greeting,
          trainerGuidanceArabic:
              'ابدأ بالترحيب الإلزامي الكامل متضمناً اسمك Alex وشركة AT&T.',
          requiredKeywords: ['att', 'alex', 'first', 'last', 'name'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-a17-02'),
          ],
        ),
        const SalesTurn(
          id: 'turn-a17-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Hello Alex, this is Maria Gonzalez. My daughter just started middle school and takes the bus home. How much would it cost to add a third line for her so she can call me in emergencies?',
          phase: SalesPhase.initialResolution,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-a17-03'),
          ],
        ),
        const SalesTurn(
          id: 'turn-a17-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'Congratulations to your daughter on middle school, Maria! Adding a third line actually triggers our 3-line group discount, bringing your plan cost down to about thirty-five to forty dollars per line on Starter.',
          phase: SalesPhase.valueBridge,
          requiredKeywords: [
            'congratulations',
            'third line',
            'group discount',
            'starter',
          ],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-a17-04'),
          ],
        ),
        const SalesTurn(
          id: 'turn-a17-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'That fits my forty dollar budget! Does she get unlimited calling, and can I manage her screen time?',
          phase: SalesPhase.objectionHandling,
          branches: [
            ScenarioBranch(conditionKey: 'accept', nextTurnId: 'turn-a17-05A'),
            ScenarioBranch(conditionKey: 'decline', nextTurnId: 'turn-a17-05B'),
            ScenarioBranch(
              conditionKey: 'needs_check',
              nextTurnId: 'turn-a17-05C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-a17-05A',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Yes, she gets unlimited talk, text, and data, and you can pair it with our AT&T Secure Family app for location tracking and screen time limits. Standard activation applies on the new line.',
          phase: SalesPhase.closing,
          requiredKeywords: [
            'unlimited',
            'secure family',
            'location',
            'activation',
          ],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-a17-06A'),
          ],
        ),
        const SalesTurn(
          id: 'turn-a17-06A',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Peace of mind knowing she can reach me on the bus is wonderful. Let us add the line today.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.qualifiedAccept,
        ),
        const SalesTurn(
          id: 'turn-a17-05B',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'I understand completely, Maria. Deciding when a child is ready for their first smartphone is an important family step. We will leave your two lines exactly as they are.',
          phase: SalesPhase.closing,
          requiredKeywords: [
            'understand',
            'family step',
            'leave',
            'as they are',
          ],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-a17-06B'),
          ],
        ),
        const SalesTurn(
          id: 'turn-a17-06B',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'I will talk to her father tonight to make sure we are both on the same page first. Thank you, Alex.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.respectfulNoSale,
        ),
        const SalesTurn(
          id: 'turn-a17-05C',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'We must verify your account permissions first to confirm whether you are the primary account holder authorized to add lines and run a credit evaluation.',
          phase: SalesPhase.eligibilityBoundary,
          requiredKeywords: [
            'verify',
            'authorized',
            'primary account holder',
            'credit',
          ],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-a17-06C'),
          ],
        ),
        const SalesTurn(
          id: 'turn-a17-06C',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'The account is in my husband name. Let me have him call in or add me as an authorized manager.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.needsVerification,
        ),
      ],
    ),

    // Scenario 18: Spouse Switcher Porting from Competitor
    SalesScenario(
      id: 'sales-18-spouse-switch-from-verizon',
      title: 'Spouse Carrier Port & Multi-Line Consolidation',
      category: 'add_a_line',
      difficulty: 'intermediate',
      profile: const SalesCustomerProfile(
        name: 'David Henderson',
        tone: 'practical organizer',
        currentProvider: 'Husband on AT&T, wife on Verizon standalone',
        householdNeeds:
            'Bringing wife over so they only pay one bill every month',
        financialConstraint:
            'Wife pays \$70 alone on Verizon; wants joint savings',
        coreBlocker:
            'Needs to ensure wife keeps her exact phone number of 15 years',
      ),
      contextNotes: 'Husband wants to port wife phone from Verizon onto his AT&T account.',
      skillTags: [
        'Number Portability',
        'Spouse Line Addition',
        'Consolidation',
      ],
      prohibitedPromises: ['promise port takes two seconds without PIN'],
      mandatoryDisclosures: [
        'Verizon line must remain active until number port completes',
        'Requires Verizon account number and Number Transfer PIN',
      ],
      fictionalCandidateProducts: ['prod-add-a-line', 'prod-wireless-extra'],
      turns: [
        const SalesTurn(
          id: 'turn-a18-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: TrainingConstants.standardGreeting,
          phase: SalesPhase.greeting,
          trainerGuidanceArabic:
              'ابدأ بالترحيب الإلزامي الكامل متضمناً اسمك Alex وشركة AT&T.',
          requiredKeywords: ['att', 'alex', 'first', 'last', 'name'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-a18-02'),
          ],
        ),
        const SalesTurn(
          id: 'turn-a18-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Hello Alex, David Henderson here. My wife has had her cell number on Verizon for 15 years. How much would it cost to add her to my AT&T plan, and can she keep her exact number?',
          phase: SalesPhase.initialResolution,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-a18-03'),
          ],
        ),
        const SalesTurn(
          id: 'turn-a18-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'She can definitely keep her 15-year number, David! Adding her line to your account lowers your cost per line with our 2-line multi-line discount, so her line is only forty dollars on Starter or fifty on Extra.',
          phase: SalesPhase.valueBridge,
          requiredKeywords: [
            'keep her number',
            'lowers',
            'multi-line discount',
            'forty dollars',
          ],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-a18-04'),
          ],
        ),
        const SalesTurn(
          id: 'turn-a18-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'She pays seventy dollars alone on Verizon right now, so that saves us twenty to thirty dollars every single month. What information do we need from Verizon to switch?',
          phase: SalesPhase.objectionHandling,
          branches: [
            ScenarioBranch(conditionKey: 'accept', nextTurnId: 'turn-a18-05A'),
            ScenarioBranch(conditionKey: 'decline', nextTurnId: 'turn-a18-05B'),
            ScenarioBranch(
              conditionKey: 'needs_check',
              nextTurnId: 'turn-a18-05C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-a18-05A',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'All we need is her Verizon account number and a 6-digit Number Transfer PIN generated from her Verizon app. Do not cancel her Verizon line beforehand; the transfer will close it automatically.',
          phase: SalesPhase.closing,
          requiredKeywords: [
            'account number',
            'transfer pin',
            'do not cancel',
            'automatically',
          ],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-a18-06A'),
          ],
        ),
        const SalesTurn(
          id: 'turn-a18-06A',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'She just texted me the transfer PIN and account number. Let us port her line right now, Alex!',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.qualifiedAccept,
        ),
        const SalesTurn(
          id: 'turn-a18-05B',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'I understand completely, David. Take your time to review her Verizon contract end date so she avoids any early cancellation fees.',
          phase: SalesPhase.closing,
          requiredKeywords: ['understand', 'verizon', 'contract', 'fees'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-a18-06B'),
          ],
        ),
        const SalesTurn(
          id: 'turn-a18-06B',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'She has one month left on her device payment there. We will wait until next month to switch. Thanks!',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.respectfulNoSale,
        ),
        const SalesTurn(
          id: 'turn-a18-05C',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'We must verify that her Verizon phone is carrier-unlocked before we order a SIM card or eSIM.',
          phase: SalesPhase.eligibilityBoundary,
          requiredKeywords: ['verify', 'carrier-unlocked', 'sim card', 'esim'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-a18-06C'),
          ],
        ),
        const SalesTurn(
          id: 'turn-a18-06C',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Let me check her phone settings to confirm the SIM lock status first.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.needsVerification,
        ),
      ],
    ),

    // Scenario 19: Cellular Smartwatch Fitness Runner
    SalesScenario(
      id: 'sales-19-cellular-smartwatch-fitness',
      title: 'Stand-Alone Cellular Smartwatch Runner Line',
      category: 'add_a_line',
      difficulty: 'beginner',
      profile: const SalesCustomerProfile(
        name: 'Nathan Drake',
        tone: 'marathon runner and fitness enthusiast',
        currentProvider: 'AT&T Unlimited Premium',
        householdNeeds: 'Streaming music and emergency calls on Apple Watch without carrying heavy phone while running',
        financialConstraint: 'Looking for nominal \$10/mo smartwatch line cost',
        coreBlocker: 'Wants to make sure watch uses the same phone number for incoming calls',
      ),
      contextNotes: 'Runner wants to leave his phone at home during 10-mile training runs.',
      skillTags: ['Wearable Cellular', 'NumberSync', 'Smartwatch Add-On'],
      prohibitedPromises: [
        'promise smartwatch battery lasts 5 days on continuous cellular streaming',
      ],
      mandatoryDisclosures: [
        'Smartwatch line is ten dollars monthly plus taxes and regulatory fees',
        'Uses AT&T NumberSync to share smartphone mobile number for calls and texts',
      ],
      fictionalCandidateProducts: ['prod-add-a-line'],
      turns: [
        const SalesTurn(
          id: 'turn-a19-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: TrainingConstants.standardGreeting,
          phase: SalesPhase.greeting,
          trainerGuidanceArabic:
              'ابدأ بالترحيب الإلزامي الكامل متضمناً اسمك Alex وشركة AT&T.',
          requiredKeywords: ['att', 'alex', 'first', 'last', 'name'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-a19-02'),
          ],
        ),
        const SalesTurn(
          id: 'turn-a19-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Hi Alex, Nathan Drake here. I run long distance every morning, and carrying an iPhone in my pocket is uncomfortable. Can I activate cellular on my Apple Watch so I can stream music and receive calls without my phone?',
          phase: SalesPhase.initialResolution,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-a19-03'),
          ],
        ),
        const SalesTurn(
          id: 'turn-a19-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'That is the best part of having a cellular watch, Nathan! For just ten dollars a month, our NumberSync feature connects your watch to your existing cell number, so you can leave your phone at home and still receive calls, texts, and stream music.',
          phase: SalesPhase.valueBridge,
          requiredKeywords: [
            'ten dollars',
            'numbersync',
            'same number',
            'leave your phone',
          ],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-a19-04'),
          ],
        ),
        const SalesTurn(
          id: 'turn-a19-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'So when somebody dials my regular cell number, my wrist will ring even if my phone is five miles away on my kitchen counter?',
          phase: SalesPhase.objectionHandling,
          branches: [
            ScenarioBranch(conditionKey: 'accept', nextTurnId: 'turn-a19-05A'),
            ScenarioBranch(conditionKey: 'decline', nextTurnId: 'turn-a19-05B'),
            ScenarioBranch(
              conditionKey: 'needs_check',
              nextTurnId: 'turn-a19-05C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-a19-05A',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Exactly, Nathan! That is how NumberSync works. It costs ten dollars a month, and we can activate the eSIM on your watch right now through the Watch app on your phone.',
          phase: SalesPhase.closing,
          requiredKeywords: ['numbersync', 'ten dollars', 'esim', 'watch app'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-a19-06A'),
          ],
        ),
        const SalesTurn(
          id: 'turn-a19-06A',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Ten dollars to run completely phone-free is unbeatable. Let us activate it right now.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.qualifiedAccept,
        ),
        const SalesTurn(
          id: 'turn-a19-05B',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'I understand, Nathan. If you prefer to download offline playlists to your watch over Wi-Fi without adding a monthly fee, that works great too.',
          phase: SalesPhase.closing,
          requiredKeywords: ['understand', 'playlists', 'offline', 'without'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-a19-06B'),
          ],
        ),
        const SalesTurn(
          id: 'turn-a19-06B',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'I will try downloading offline podcasts first to see if that works for me. Thanks Alex!',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.respectfulNoSale,
        ),
        const SalesTurn(
          id: 'turn-a19-05C',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'We must verify whether your Apple Watch model is a GPS-only or GPS+Cellular model before adding the line.',
          phase: SalesPhase.eligibilityBoundary,
          requiredKeywords: ['verify', 'gps', 'cellular', 'model'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-a19-06C'),
          ],
        ),
        const SalesTurn(
          id: 'turn-a19-06C',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'I need to check the red ring on the digital crown to see if it has cellular hardware. Let me verify that first.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.needsVerification,
        ),
      ],
    ),

    // Scenario 20: Traveling Sales Rep iPad Cellular Data Line
    SalesScenario(
      id: 'sales-20-tablet-road-warrior-ipad',
      title: 'Mobile Real Estate Agent iPad Data Connectivity',
      category: 'add_a_line',
      difficulty: 'intermediate',
      profile: const SalesCustomerProfile(
        name: 'Jessica Alba',
        tone: 'busy real estate professional',
        currentProvider: 'AT&T Unlimited Extra',
        householdNeeds: 'Signing digital contracts on iPad in client driveways without hunting for Wi-Fi',
        financialConstraint: 'Wants flat \$20/mo tablet line cost',
        coreBlocker:
            'Frustrated by public Wi-Fi dropouts during document signing',
      ),
      contextNotes: 'Real estate agent lost a client signature when coffee shop Wi-Fi failed.',
      skillTags: ['Tablet Add-On', 'Professional Utility', 'Unlimited Tablet'],
      prohibitedPromises: ['promise Wi-Fi never needed for anything'],
      mandatoryDisclosures: [
        'Unlimited standalone tablet plan is twenty dollars monthly when added to eligible smartphone plan',
        'Subject to network management during heavy congestion',
      ],
      fictionalCandidateProducts: ['prod-add-a-line'],
      turns: [
        const SalesTurn(
          id: 'turn-a20-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: TrainingConstants.standardGreeting,
          phase: SalesPhase.greeting,
          trainerGuidanceArabic:
              'ابدأ بالترحيب الإلزامي الكامل متضمناً اسمك Alex وشركة AT&T.',
          requiredKeywords: ['att', 'alex', 'first', 'last', 'name'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-a20-02'),
          ],
        ),
        const SalesTurn(
          id: 'turn-a20-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Alex, Jessica Alba speaking. I am a real estate agent. Yesterday I was in a driveway with buyers trying to DocuSign on my iPad, and the phone hotspot disconnected and we lost our place. Can I get dedicated cellular data on my iPad?',
          phase: SalesPhase.initialResolution,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-a20-03'),
          ],
        ),
        const SalesTurn(
          id: 'turn-a20-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'I completely understand how critical those closing moments are, Jessica! You can add an Unlimited Tablet line to your account for just twenty dollars a month, giving your iPad its own dedicated 5G connection anywhere.',
          phase: SalesPhase.valueBridge,
          requiredKeywords: [
            'twenty dollars',
            'tablet',
            '5g',
            'dedicated',
            'ipad',
          ],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-a20-04'),
          ],
        ),
        const SalesTurn(
          id: 'turn-a20-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Twenty dollars a month for instant contracts anywhere in the city is a tax write-off and saves my deals. Can we activate it right away?',
          phase: SalesPhase.objectionHandling,
          branches: [
            ScenarioBranch(conditionKey: 'accept', nextTurnId: 'turn-a20-05A'),
            ScenarioBranch(conditionKey: 'decline', nextTurnId: 'turn-a20-05B'),
            ScenarioBranch(
              conditionKey: 'needs_check',
              nextTurnId: 'turn-a20-05C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-a20-05A',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Yes, Jessica! If your iPad has an eSIM, we can push the cellular profile electronically in five minutes, so your next closing is completely protected.',
          phase: SalesPhase.closing,
          requiredKeywords: [
            'esim',
            'twenty dollars',
            'electronically',
            'profile',
          ],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-a20-06A'),
          ],
        ),
        const SalesTurn(
          id: 'turn-a20-06A',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'That is so seamless. I have my iPad IMEI on screen. Let us activate it now.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.qualifiedAccept,
        ),
        const SalesTurn(
          id: 'turn-a20-05B',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'I understand, Jessica. If you prefer to keep tethering with your phone hotspot to avoid the monthly fee, we can optimize your phone hotspot settings.',
          phase: SalesPhase.closing,
          requiredKeywords: ['understand', 'hotspot', 'avoid', 'settings'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-a20-06B'),
          ],
        ),
        const SalesTurn(
          id: 'turn-a20-06B',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Let me try tweaking the hotspot timeout setting first before adding twenty dollars. Thanks Alex!',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.respectfulNoSale,
        ),
        const SalesTurn(
          id: 'turn-a20-05C',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'We must verify that your iPad hardware has a cellular antenna and IMEI, as Wi-Fi only iPads cannot connect to cellular towers.',
          phase: SalesPhase.eligibilityBoundary,
          requiredKeywords: [
            'verify',
            'ipad hardware',
            'cellular',
            'imei',
            'wi-fi only',
          ],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-a20-06C'),
          ],
        ),
        const SalesTurn(
          id: 'turn-a20-06C',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Wait, I bought this iPad at Best Buy as a Wi-Fi model. Let me check the model number on the back first.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.needsVerification,
        ),
      ],
    ),

    // Scenario 21: Aging Parent Safety Line (In-Law Suite)
    SalesScenario(
      id: 'sales-21-aging-parent-safety-line',
      title: 'Elderly Parent Dedicated Line & In-Law Suite Care',
      category: 'add_a_line',
      difficulty: 'beginner',
      profile: const SalesCustomerProfile(
        name: 'George Ramirez',
        tone: 'caring adult son',
        currentProvider: 'AT&T Unlimited Starter (2 lines)',
        householdNeeds: 'Dedicated phone line for 85-year-old mother living in attached in-law suite',
        financialConstraint:
            'Wants simple affordable plan without high smartphone charges',
        coreBlocker: 'Mother struggles with touchscreen smartphones and needs simple flip device',
      ),
      contextNotes: 'Son wants to add a flip phone line so mother can call family and doctors.',
      skillTags: ['Senior Safety', 'Basic Phone Addition', 'Family Account'],
      prohibitedPromises: [
        'guarantee 911 location tracking works with dead battery',
      ],
      mandatoryDisclosures: [
        'Basic flip phone line can be added to existing account with group discount',
        'Standard activation fee applies to newly added line',
      ],
      fictionalCandidateProducts: [
        'prod-add-a-line',
        'prod-cellular-base-landline',
      ],
      turns: [
        const SalesTurn(
          id: 'turn-a21-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: TrainingConstants.standardGreeting,
          phase: SalesPhase.greeting,
          trainerGuidanceArabic:
              'ابدأ بالترحيب الإلزامي الكامل متضمناً اسمك Alex وشركة AT&T.',
          requiredKeywords: ['att', 'alex', 'first', 'last', 'name'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-a21-02'),
          ],
        ),
        const SalesTurn(
          id: 'turn-a21-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Hello Alex, George Ramirez. My 85-year-old mother just moved into our attached in-law suite. She cannot use a modern touchscreen, but she needs a simple phone by her bed to call us and her doctor. Can I add a basic line for her?',
          phase: SalesPhase.initialResolution,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-a21-03'),
          ],
        ),
        const SalesTurn(
          id: 'turn-a21-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'That is so thoughtful, George. You can add a third line to your account with our multi-line discount for just thirty dollars a month, paired with a simple large-button flip phone or our wireless home phone base.',
          phase: SalesPhase.valueBridge,
          requiredKeywords: [
            'thirty dollars',
            'multi-line discount',
            'flip phone',
            'home phone base',
          ],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-a21-04'),
          ],
        ),
        const SalesTurn(
          id: 'turn-a21-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Thirty dollars is very affordable. Does the flip phone have large buttons and loud volume for her hearing aid?',
          phase: SalesPhase.objectionHandling,
          branches: [
            ScenarioBranch(conditionKey: 'accept', nextTurnId: 'turn-a21-05A'),
            ScenarioBranch(conditionKey: 'decline', nextTurnId: 'turn-a21-05B'),
            ScenarioBranch(
              conditionKey: 'needs_check',
              nextTurnId: 'turn-a21-05C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-a21-05A',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Yes, George. Our basic phone options feature large high-contrast tactile buttons, hearing aid compatibility, and dedicated one-touch emergency calling for complete peace of mind.',
          phase: SalesPhase.closing,
          requiredKeywords: [
            'tactile buttons',
            'hearing aid',
            'peace of mind',
            'emergency',
          ],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-a21-06A'),
          ],
        ),
        const SalesTurn(
          id: 'turn-a21-06A',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'That will make her feel safe and independent in her room. Add the line and ship the flip phone to our house.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.qualifiedAccept,
        ),
        const SalesTurn(
          id: 'turn-a21-05B',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'I understand, George. If you want to test an intercom system between your main house and the suite first, we will leave your mobile account alone.',
          phase: SalesPhase.closing,
          requiredKeywords: ['understand', 'intercom', 'leave', 'alone'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-a21-06B'),
          ],
        ),
        const SalesTurn(
          id: 'turn-a21-06B',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'We will try a baby monitor intercom first to see if that is enough. Thank you for your kindness, Alex.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.respectfulNoSale,
        ),
        const SalesTurn(
          id: 'turn-a21-05C',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'We must verify your account line limit to confirm your credit profile allows adding a third postpaid cellular line without a security deposit.',
          phase: SalesPhase.eligibilityBoundary,
          requiredKeywords: [
            'verify',
            'line limit',
            'credit profile',
            'deposit',
          ],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-a21-06C'),
          ],
        ),
        const SalesTurn(
          id: 'turn-a21-06C',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Please check the line authorization first so we know there are no surprise deposits required.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.needsVerification,
        ),
      ],
    ),

    // Scenario 22: Small Business Owner Second Dedicated Line
    SalesScenario(
      id: 'sales-22-small-business-work-line',
      title: 'Sole Proprietor Dedicated Business Line Separation',
      category: 'add_a_line',
      difficulty: 'intermediate',
      profile: const SalesCustomerProfile(
        name: 'Samantha Vance',
        tone: 'busy independent caterer',
        currentProvider: 'Single personal phone line with AT&T',
        householdNeeds: 'Separate business number for clients so she can turn off business calls on weekends',
        financialConstraint: 'Looking for cost-effective way to separate business taxes and receipts',
        coreBlocker:
            'Hesitant to carry two bulky phone handsets in her catering apron',
      ),
      contextNotes:
          'Caterer is getting customer calls at 10 PM on her personal number.',
      skillTags: [
        'Business Line Separation',
        'Work-Life Balance',
        'eSIM Second Line',
      ],
      prohibitedPromises: [
        'promise tax deductions without consulting accountant',
      ],
      mandatoryDisclosures: [
        'Second line can be activated via eSIM on existing compatible smartphone',
        'Itemized monthly billing provides separate line statement for expense records',
      ],
      fictionalCandidateProducts: ['prod-add-a-line', 'prod-wireless-starter'],
      turns: [
        const SalesTurn(
          id: 'turn-a22-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: TrainingConstants.standardGreeting,
          phase: SalesPhase.greeting,
          trainerGuidanceArabic:
              'ابدأ بالترحيب الإلزامي الكامل متضمناً اسمك Alex وشركة AT&T.',
          requiredKeywords: ['att', 'alex', 'first', 'last', 'name'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-a22-02'),
          ],
        ),
        const SalesTurn(
          id: 'turn-a22-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Hi Alex, Samantha Vance. I run an independent catering company and give out my personal cell phone number. Clients call me on Saturday nights while I am with my family. Can I add a second business number to my current phone without carrying two devices?',
          phase: SalesPhase.initialResolution,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-a22-03'),
          ],
        ),
        const SalesTurn(
          id: 'turn-a22-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'I completely appreciate the need for work-life balance, Samantha! Your smartphone supports dual eSIM lines. We can add a second dedicated line for forty dollars with multi-line discount, allowing you to turn off the business line on weekends while your personal line stays active.',
          phase: SalesPhase.valueBridge,
          requiredKeywords: [
            'work-life balance',
            'dual esim',
            'forty dollars',
            'weekends',
          ],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-a22-04'),
          ],
        ),
        const SalesTurn(
          id: 'turn-a22-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Turning off the business line on weekends with one tap on my phone would save my sanity. Does it show up as a separate itemized line on my statement for tax write-offs?',
          phase: SalesPhase.objectionHandling,
          branches: [
            ScenarioBranch(conditionKey: 'accept', nextTurnId: 'turn-a22-05A'),
            ScenarioBranch(conditionKey: 'decline', nextTurnId: 'turn-a22-05B'),
            ScenarioBranch(
              conditionKey: 'needs_check',
              nextTurnId: 'turn-a22-05C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-a22-05A',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Yes, Samantha! It is itemized with its own dedicated telephone number and charges, making business expense accounting simple and straightforward.',
          phase: SalesPhase.closing,
          requiredKeywords: [
            'itemized',
            'dedicated',
            'accounting',
            'straightforward',
          ],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-a22-06A'),
          ],
        ),
        const SalesTurn(
          id: 'turn-a22-06A',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Getting my personal weekends back is worth every dollar. Let us set up that second eSIM line right now.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.qualifiedAccept,
        ),
        const SalesTurn(
          id: 'turn-a22-05B',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'I understand, Samantha. You can also test a virtual VoIP forwarding app on your phone first before committing to an additional mobile line.',
          phase: SalesPhase.closing,
          requiredKeywords: ['understand', 'virtual', 'test', 'committing'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-a22-06B'),
          ],
        ),
        const SalesTurn(
          id: 'turn-a22-06B',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'I will test a free app on my phone first. Thank you for the honest advice, Alex.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.respectfulNoSale,
        ),
        const SalesTurn(
          id: 'turn-a22-05C',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'We must verify your specific phone model to confirm that it supports dual active eSIM standby before adding the service.',
          phase: SalesPhase.eligibilityBoundary,
          requiredKeywords: ['verify', 'phone model', 'dual active', 'standby'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-a22-06C'),
          ],
        ),
        const SalesTurn(
          id: 'turn-a22-06C',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Let me check my phone generation in my settings menu to make sure it supports dual eSIM.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.needsVerification,
        ),
      ],
    ),

    // Scenario 23: Sibling Heading to College Add-A-Line
    SalesScenario(
      id: 'sales-23-college-student-second-line',
      title: 'College Sibling Plan Addition & Unlimited Campus Data',
      category: 'add_a_line',
      difficulty: 'intermediate',
      profile: const SalesCustomerProfile(
        name: 'Lucas Campbell',
        tone: 'older brother helping younger sister',
        currentProvider: 'Single line on AT&T Unlimited Extra',
        householdNeeds:
            'Adding sister who is moving to dorms three states away',
        financialConstraint: 'Sister will venmo him \$35 every month',
        coreBlocker: 'Wants to make sure she has unlimited calling home and high hotspot data for dorms',
      ),
      contextNotes: 'Customer wants to know if lines can have different billing addresses.',
      skillTags: ['Dorm Student Line', 'Multi-Line Discount', 'Family Sharing'],
      prohibitedPromises: ['promise campus Wi-Fi will never disconnect'],
      mandatoryDisclosures: [
        'Account owner remains legally responsible for all lines billed to account',
        'Lines can be located anywhere in domestic US with nationwide coverage',
      ],
      fictionalCandidateProducts: ['prod-add-a-line', 'prod-wireless-extra'],
      turns: [
        const SalesTurn(
          id: 'turn-a23-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: TrainingConstants.standardGreeting,
          phase: SalesPhase.greeting,
          trainerGuidanceArabic:
              'ابدأ بالترحيب الإلزامي الكامل متضمناً اسمك Alex وشركة AT&T.',
          requiredKeywords: ['att', 'alex', 'first', 'last', 'name'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-a23-02'),
          ],
        ),
        const SalesTurn(
          id: 'turn-a23-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Hey Alex, Lucas Campbell here. My sister is starting college in Chicago next month while I live in Dallas. Can I add her to my AT&T plan even though she will be living in another state?',
          phase: SalesPhase.initialResolution,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-a23-03'),
          ],
        ),
        const SalesTurn(
          id: 'turn-a23-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'Absolutely, Lucas! Our network is nationwide, so she can use her phone anywhere in the country. Adding her gives both lines our 2-line group discount, dropping the cost per line down to fifty dollars on Extra with 30GB of hotspot for her study sessions.',
          phase: SalesPhase.valueBridge,
          requiredKeywords: [
            'nationwide',
            'group discount',
            'fifty dollars',
            'extra',
            'hotspot',
          ],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-a23-04'),
          ],
        ),
        const SalesTurn(
          id: 'turn-a23-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Fifty dollars each with thirty gigs of hotspot will keep her connected in her dorm. Can we ship the new phone or SIM directly to her dorm address?',
          phase: SalesPhase.objectionHandling,
          branches: [
            ScenarioBranch(conditionKey: 'accept', nextTurnId: 'turn-a23-05A'),
            ScenarioBranch(conditionKey: 'decline', nextTurnId: 'turn-a23-05B'),
            ScenarioBranch(
              conditionKey: 'needs_check',
              nextTurnId: 'turn-a23-05C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-a23-05A',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Yes, Lucas! As the account owner, you can specify an alternate shipping address for her device or activate an instant eSIM directly on her phone.',
          phase: SalesPhase.closing,
          requiredKeywords: [
            'alternate shipping',
            'esim',
            'account owner',
            'activate',
          ],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-a23-06A'),
          ],
        ),
        const SalesTurn(
          id: 'turn-a23-06A',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Shipping directly to her dorm makes it completely hassle-free. Let us add the line and send her the eSIM QR code.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.qualifiedAccept,
        ),
        const SalesTurn(
          id: 'turn-a23-05B',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'I understand, Lucas. If she wants to check whether her university offers a subsidized campus mobile plan first, we will keep your single line as is.',
          phase: SalesPhase.closing,
          requiredKeywords: ['understand', 'university', 'subsidized', 'as is'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-a23-06B'),
          ],
        ),
        const SalesTurn(
          id: 'turn-a23-06B',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'She is attending orientation this week. I will have her check campus offers first. Thanks!',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.respectfulNoSale,
        ),
        const SalesTurn(
          id: 'turn-a23-05C',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'We must verify her phone IMEI compatibility first to confirm her existing phone works properly on AT&T 5G bands.',
          phase: SalesPhase.eligibilityBoundary,
          requiredKeywords: ['verify', 'imei', 'compatibility', '5g bands'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-a23-06C'),
          ],
        ),
        const SalesTurn(
          id: 'turn-a23-06C',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Let me text her to get her 15-digit IMEI number from her settings first.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.needsVerification,
        ),
      ],
    ),

    // Scenario 24: Home Healthcare Telehealth Tablet Line
    SalesScenario(
      id: 'sales-24-parent-care-tablet-monitoring',
      title: 'Home Healthcare Telehealth Tablet Addition',
      category: 'add_a_line',
      difficulty: 'challenging',
      profile: const SalesCustomerProfile(
        name: 'Carolyn Baker',
        tone: 'concerned daughter managing elderly care',
        currentProvider: 'AT&T Unlimited Starter',
        householdNeeds: 'Dedicated tablet for nurse visits, blood pressure monitoring, and telehealth video calls',
        financialConstraint:
            'Looking for low monthly add-on without home Wi-Fi complications',
        coreBlocker: 'Home Wi-Fi in father house disconnects frequently, cutting off doctor appointments',
      ),
      contextNotes:
          'Nurse visits father and needs reliable cellular tablet connection.',
      skillTags: ['Telehealth Connectivity', 'Caregiver Tech', 'Tablet Add-On'],
      prohibitedPromises: [
        'guarantee FDA approval of third-party monitoring devices',
      ],
      mandatoryDisclosures: [
        'Dedicated tablet line is twenty dollars monthly with AutoPay on existing plan',
        'Provides cellular connectivity independent of home Wi-Fi network',
      ],
      fictionalCandidateProducts: ['prod-add-a-line'],
      turns: [
        const SalesTurn(
          id: 'turn-a24-01',
          turnNumber: 1,
          speaker: TurnSpeaker.agent,
          spokenText: TrainingConstants.standardGreeting,
          phase: SalesPhase.greeting,
          trainerGuidanceArabic:
              'ابدأ بالترحيب الإلزامي الكامل متضمناً اسمك Alex وشركة AT&T.',
          requiredKeywords: ['att', 'alex', 'first', 'last', 'name'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-a24-02'),
          ],
        ),
        const SalesTurn(
          id: 'turn-a24-02',
          turnNumber: 2,
          speaker: TurnSpeaker.customer,
          spokenText: 'Hello Alex, Carolyn Baker. My father receives visits from home health nurses, but his home Wi-Fi is constantly dropping, and they cannot submit his vitals or do telehealth calls. Can we get an iPad that connects directly to cell towers on my bill?',
          phase: SalesPhase.initialResolution,
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-a24-03'),
          ],
        ),
        const SalesTurn(
          id: 'turn-a24-03',
          turnNumber: 3,
          speaker: TurnSpeaker.agent,
          spokenText: 'I appreciate how vital reliable medical connectivity is, Carolyn. You can add a dedicated Unlimited Tablet line to your account for just twenty dollars a month, giving the tablet its own cellular 5G connection that works independently of home Wi-Fi.',
          phase: SalesPhase.valueBridge,
          requiredKeywords: [
            'vital',
            'twenty dollars',
            'tablet',
            '5g',
            'independently',
          ],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-a24-04'),
          ],
        ),
        const SalesTurn(
          id: 'turn-a24-04',
          turnNumber: 4,
          speaker: TurnSpeaker.customer,
          spokenText: 'Twenty dollars to guarantee the nurse never gets cut off during a doctor visit is worth every penny. Does it have unlimited data so they never run out during video calls?',
          phase: SalesPhase.objectionHandling,
          branches: [
            ScenarioBranch(conditionKey: 'accept', nextTurnId: 'turn-a24-05A'),
            ScenarioBranch(conditionKey: 'decline', nextTurnId: 'turn-a24-05B'),
            ScenarioBranch(
              conditionKey: 'needs_check',
              nextTurnId: 'turn-a24-05C',
            ),
          ],
        ),
        const SalesTurn(
          id: 'turn-a24-05A',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'Yes, Carolyn! It includes unlimited cellular data, so nurse video calls and medical uploads can happen anytime without worrying about overages.',
          phase: SalesPhase.closing,
          requiredKeywords: ['unlimited', 'video calls', 'overages', 'anytime'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-a24-06A'),
          ],
        ),
        const SalesTurn(
          id: 'turn-a24-06A',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'That takes a huge weight off our family shoulders. Add the tablet line and send the SIM to his house.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.qualifiedAccept,
        ),
        const SalesTurn(
          id: 'turn-a24-05B',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'I understand, Carolyn. If you want to try relocating his home Wi-Fi router closer to his living room first, we will leave your account unchanged.',
          phase: SalesPhase.closing,
          requiredKeywords: ['understand', 'relocating', 'router', 'unchanged'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-a24-06B'),
          ],
        ),
        const SalesTurn(
          id: 'turn-a24-06B',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Let me try moving the router closer first to see if that saves twenty dollars. Thanks Alex.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.respectfulNoSale,
        ),
        const SalesTurn(
          id: 'turn-a24-05C',
          turnNumber: 5,
          speaker: TurnSpeaker.agent,
          spokenText: 'We must verify whether his tablet is a cellular-capable model with an active SIM tray or eSIM chip before ordering service.',
          phase: SalesPhase.eligibilityBoundary,
          requiredKeywords: ['verify', 'cellular-capable', 'sim tray', 'esim'],
          branches: [
            ScenarioBranch(conditionKey: 'default', nextTurnId: 'turn-a24-06C'),
          ],
        ),
        const SalesTurn(
          id: 'turn-a24-06C',
          turnNumber: 6,
          speaker: TurnSpeaker.customer,
          spokenText: 'Let me inspect the tablet during my visit this evening to make sure it has a SIM slot. I will call back.',
          phase: SalesPhase.closing,
          isFinal: true,
          resultingOutcome: SalesOutcomeType.needsVerification,
        ),
      ],
    ),
  ];
}
