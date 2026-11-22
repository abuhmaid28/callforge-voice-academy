/// 12 Spoken Listening and Discovery Drills to practice consultative questioning techniques.
class DiscoveryDrillItem {
  final String id;
  final String title;
  final String customerContextHint;
  final String customerSpokenStatement;
  final List<String> openEndedQuestionKeywords; // Expected interrogatives
  final String modelQuestionEnglish;
  final String coachingArabic;

  const DiscoveryDrillItem({
    required this.id,
    required this.title,
    required this.customerContextHint,
    required this.customerSpokenStatement,
    required this.openEndedQuestionKeywords,
    required this.modelQuestionEnglish,
    required this.coachingArabic,
  });
}

abstract class DiscoveryDrillsCatalog {
  static const List<DiscoveryDrillItem> drills = [
    // 1. Household Devices
    DiscoveryDrillItem(
      id: 'disc-01-household-devices',
      title: 'Probing Household Device Load',
      customerContextHint: 'Customer mentions internet feels slow on weekends.',
      customerSpokenStatement: 'Our internet always gets sluggish on Friday nights and weekends when everybody is home.',
      openEndedQuestionKeywords: ['how many', 'devices', 'who', 'what are'],
      modelQuestionEnglish: 'How many connected devices, like smart TVs, phones, and computers, are usually online at the same time in your home?',
      coachingArabic: 'اسأل عن عدد الأجهزة المتصلة ونوعية استخدام كل شخص عشان تقدر تقترح السرعة المناسبة لحجم البيت.',
    ),

    // 2. Work From Home
    DiscoveryDrillItem(
      id: 'disc-02-work-from-home',
      title: 'Uncovering Remote Work Pain Points',
      customerContextHint: 'Caller mentions working remotely from home.',
      customerSpokenStatement: 'I recently switched to working from home three days a week doing video conferencing and uploading client design files.',
      openEndedQuestionKeywords: ['what', 'how often', 'video calls', 'upload'],
      modelQuestionEnglish: 'What kinds of large files or video conferencing platforms do you rely on most during your workday?',
      coachingArabic: 'العمل عن بُعد محتاج سرعة رفع عالية (Upload)؛ اسأل العميل عن برامج الفيديو ونوعية الملفات اللي بيرفعها.',
    ),

    // 3. Teenager Data Usage
    DiscoveryDrillItem(
      id: 'disc-03-teenager-data',
      title: 'Identifying Family Mobile Hotspot Needs',
      customerContextHint: 'Customer complains about high wireless data usage.',
      customerSpokenStatement: 'My teenage son is always complaining that his phone runs out of high-speed data halfway through our billing cycle.',
      openEndedQuestionKeywords: ['what does', 'how does', 'hotspot', 'apps'],
      modelQuestionEnglish: 'What does he mainly use his phone for when he is away from your home Wi-Fi network?',
      coachingArabic: 'اسأل العميل ابنه بيستخدم النت في إيه برا البيت (Hotspot أو Streaming) عشان تختارله باقة Extra أو Starter المناسبة.',
    ),

    // 4. Budget Range Comfort
    DiscoveryDrillItem(
      id: 'disc-04-budget-comfort',
      title: 'Gentle Household Budget Discovery',
      customerContextHint: 'Customer is hesitant about plan changes.',
      customerSpokenStatement: 'I am open to looking at better options, but my monthly finances are on a pretty strict budget right now.',
      openEndedQuestionKeywords: ['what', 'monthly', 'range', 'comfortable'],
      modelQuestionEnglish: 'What monthly price range feels most comfortable for your household budget as we look at options?',
      coachingArabic: 'اسأل بذوق واحترام عن الميزانية الشهرية المريحة للعميل قبل ما تعرض أي سعر رسمي.',
    ),

    // 5. Travel & Roaming Habits
    DiscoveryDrillItem(
      id: 'disc-05-travel-habits',
      title: 'Uncovering International Roaming Needs',
      customerContextHint: 'Caller mentions visiting family outside the US.',
      customerSpokenStatement: 'I travel back to Mexico and Latin America two or three times a year to visit family and take care of business.',
      openEndedQuestionKeywords: [
        'how often',
        'countries',
        'use your phone',
        'what',
      ],
      modelQuestionEnglish: 'How often do you travel abroad each year, and what features do you need most while traveling?',
      coachingArabic: 'استكشف عدد مرات السفر؛ دي فرصة مناسبة توضح ميزة التجوال المجاني في باقة Unlimited Premium في أمريكا اللاتينية.',
    ),

    // 6. Current Provider Pain Points
    DiscoveryDrillItem(
      id: 'disc-06-current-provider-pain',
      title: 'Pinpointing Cable Frustration',
      customerContextHint: 'Customer is dissatisfied with their cable company.',
      customerSpokenStatement: 'My cable company keeps creeping the price up every six months, and customer service has been impossible.',
      openEndedQuestionKeywords: ['what', 'frustrates', 'most', 'experience'],
      modelQuestionEnglish: 'What has been the most frustrating part of that experience with your current provider?',
      coachingArabic: 'خلّي العميل يتكلم ويعبر عن المشكلة؛ فهم نقطة الألم هو مفتاح تقديم الحل الصحيح في الفايبر.',
    ),

    // 7. Copper Landline Handsets
    DiscoveryDrillItem(
      id: 'disc-07-copper-wire-handsets',
      title: 'Assessing Traditional Home Phone Setup',
      customerContextHint:
          'Caller asks why copper landline bill keeps increasing.',
      customerSpokenStatement: 'Our traditional home phone bill has gone up to sixty dollars, but my mother still likes having a home telephone handset.',
      openEndedQuestionKeywords: ['how many', 'handsets', 'plugs', 'where'],
      modelQuestionEnglish: 'How many traditional telephone handsets do you currently have plugged into the wall around your house?',
      coachingArabic: 'اسأل عن عدد الهواتف في البيت، عشان تتأكد إن المحول اللاسلكي Cellular Base هيشتغل مع كل التليفونات.',
    ),

    // 8. Device Condition for Trade-In
    DiscoveryDrillItem(
      id: 'disc-08-phone-condition-tradein',
      title: 'Qualifying Trade-In Device Condition',
      customerContextHint:
          'Customer is interested in a promotional phone upgrade.',
      customerSpokenStatement: 'I saw an advertisement for a free phone with trade-in, and I have an older iPhone 12 I might trade in.',
      openEndedQuestionKeywords: [
        'what condition',
        'cracks',
        'powers on',
        'screen',
      ],
      modelQuestionEnglish: 'What condition is the iPhone 12 in today? Does it power on normally with an intact screen free of cracks?',
      coachingArabic: 'لازم تتأكد من حالة الجهاز قبل ما توعد بأي خصم؛ افحص كسر الشاشة والتشغيل لتفادي رفض العرض الترويجي.',
    ),

    // 9. Accessibility & Elderly Device Needs
    DiscoveryDrillItem(
      id: 'disc-09-elderly-flip-phone',
      title: 'Discovering Accessibility Requirements',
      customerContextHint: 'Caller is shopping for an elderly relative.',
      customerSpokenStatement: 'I am looking for a simple phone for my 82-year-old father who struggles with touchscreens and small text.',
      openEndedQuestionKeywords: [
        'what features',
        'buttons',
        'volume',
        'hearing',
      ],
      modelQuestionEnglish: 'What features would make calling easiest for him, such as large tactile buttons or hearing aid compatibility?',
      coachingArabic: 'ركز على احتياجات الوصول وسهولة الاستخدام (أزرار كبيرة، وضوح صوت، توافق مع السماعات الطبية).',
    ),

    // 10. Multi-Line Household Consolidation
    DiscoveryDrillItem(
      id: 'disc-10-multiline-discount',
      title: 'Exploring Family Line Consolidation',
      customerContextHint:
          'Customer mentions family members on separate mobile plans.',
      customerSpokenStatement: 'My wife has her phone on Verizon and my daughter is on T-Mobile, so we are paying three separate bills every month.',
      openEndedQuestionKeywords: ['how much', 'who', 'combine', 'lines'],
      modelQuestionEnglish: 'How much are you all paying across those three separate bills each month, and would consolidating them into one account be helpful?',
      coachingArabic: 'اكتشف التكلفة الإجمالية للفواتير المتفرقة؛ خصومات الخطوط المتعددة بتوفر كتير لما العائلة تتجمع على حساب واحد.',
    ),

    // 11. Download vs Upload Speed Expectations
    DiscoveryDrillItem(
      id: 'disc-11-fiber-speed-expectations',
      title: 'Clarifying Symmetrical Speed Needs',
      customerContextHint:
          'Customer doesn’t understand why upload speed matters.',
      customerSpokenStatement: 'Why does it matter if my upload speed is 10 Mbps or 300 Mbps? Isn’t download the only thing that counts?',
      openEndedQuestionKeywords: ['what do you', 'video', 'cloud', 'backup'],
      modelQuestionEnglish: 'What kind of activities does your household do that send data out, such as video meetings, gaming, or cloud photo backups?',
      coachingArabic: 'اشرح بأسلوب بسيط إن سرعة الرفع مهمة لمكالمات الفيديو والألعاب وحفظ الصور السحابي بدون تهنيج.',
    ),

    // 12. Streaming & Add-On Consolidation
    DiscoveryDrillItem(
      id: 'disc-12-streaming-subscriptions',
      title: 'Discovering Entertainment Subscriptions',
      customerContextHint:
          'Caller is reviewing overall household entertainment costs.',
      customerSpokenStatement: 'Between Netflix, Max, and sports packages, our entertainment subscriptions feel completely out of control.',
      openEndedQuestionKeywords: [
        'which',
        'how many',
        'services',
        'watch most',
      ],
      modelQuestionEnglish: 'Which streaming services does your household watch most frequently each week?',
      coachingArabic: 'اسأل عن المنصات اللي بيتفرجوا عليها عشان تشوف لو في باقة بتوفر اشتراكات مدمجة أو توفير في البيانات.',
    ),
  ];
}
