/// 8 Objection Drills with synthetic customer objections, target rephrasings, and Egyptian Arabic coaching.
class ObjectionDrillItem {
  final String id;
  final String title;
  final String customerObjection;
  final List<String> requiredResponseKeywords;
  final List<String> prohibitedResponsePhrases;
  final String modelResponseEnglish;
  final String coachingArabic;
  final String skillTag;

  const ObjectionDrillItem({
    required this.id,
    required this.title,
    required this.customerObjection,
    required this.requiredResponseKeywords,
    this.prohibitedResponsePhrases = const [],
    required this.modelResponseEnglish,
    required this.coachingArabic,
    this.skillTag = 'Objection Handling',
  });
}

abstract class ObjectionDrillsCatalog {
  static const List<ObjectionDrillItem> drills = [
    // 1. Not Interested
    ObjectionDrillItem(
      id: 'obj-01-not-interested',
      title: 'Immediate "Not Interested" Deflection',
      customerObjection: 'Look, I am really not interested in buying anything today. I just called to get my bill question answered.',
      requiredResponseKeywords: ['understand', 'respect', 'focus', 'help'],
      prohibitedResponsePhrases: [
        'you must hear this',
        'special deal today only',
      ],
      modelResponseEnglish: 'I completely respect that, and my main focus right now is taking care of your bill question. We will leave everything else alone.',
      coachingArabic: 'احترم رفض العميل فوراً وطمنه إن تركيزك الأول على حل مشكلته الأساسية. بلاش تلح لما العميل يقول مش مهتم.',
    ),

    // 2. Too Expensive
    ObjectionDrillItem(
      id: 'obj-02-too-expensive',
      title: 'Cost & Affordability Resistance',
      customerObjection: 'Everything with AT&T is getting way too expensive lately. I cannot afford to add another dime to my bill.',
      requiredResponseKeywords: ['understand', 'budget', 'save', 'review'],
      prohibitedResponsePhrases: ['it is only a few dollars', 'cheap'],
      modelResponseEnglish: 'I completely understand, and keeping your costs down is important. Let us review your existing account to see if AutoPay discounts can actually lower what you pay.',
      coachingArabic: 'اعترف بأهمية الميزانية للعميل، واعرض مراجعة خصومات حسابه الحالي عشان تقلل الفاتورة بدل ما تزودها.',
    ),

    // 3. Hidden Fees Fear
    ObjectionDrillItem(
      id: 'obj-03-hidden-fees',
      title: 'Hidden Fees & Surcharge Skepticism',
      customerObjection: 'Every time a phone rep promises me a rate, I end up getting hit with ten hidden fees and taxes on the next bill.',
      requiredResponseKeywords: ['transparent', 'breakdown', 'taxes', 'fees'],
      prohibitedResponsePhrases: ['guarantee zero taxes', 'no fees ever'],
      modelResponseEnglish: 'I completely appreciate your concern for transparency. While standard government taxes and regulatory fees still apply, our plan rate and equipment pricing are fixed with no surprise surcharges.',
      coachingArabic: 'وضح بشفافية إن الضرائب الحكومية موجودة ومحدش يقدر يلغيها، لكن سعر الباقة والراوتر ثابتين بدون رسوم خفية.',
    ),

    // 4. Happy with Cable
    ObjectionDrillItem(
      id: 'obj-04-happy-with-cable',
      title: 'Content with Cable Competitor',
      customerObjection: 'My cable internet with Xfinity works fine for what I need. Why would I go through the headache of switching?',
      requiredResponseKeywords: ['understand', 'upload', 'fiber', 'reliable'],
      prohibitedResponsePhrases: ['cable is garbage', 'you have to switch'],
      modelResponseEnglish: 'I understand completely. The main difference our customers appreciate is symmetrical fiber upload speeds, so video calls and backups run just as fast as downloads without slowdowns during peak hours.',
      coachingArabic: 'متغلطش في شركة الكابل؛ وضح الميزة الحقيقية للفايبر وهي سرعة الرفع المتطابقة (Symmetrical Upload) اللي مش موجودة في الكابل.',
    ),

    // 5. Spouse Consultation
    ObjectionDrillItem(
      id: 'obj-05-spouse-permission',
      title: 'Third-Party / Spouse Decision Blocker',
      customerObjection: 'This sounds reasonable, but I make household financial decisions with my wife, and I cannot agree to anything without discussing it with her first.',
      requiredResponseKeywords: [
        'respect',
        'discuss',
        'information',
        'whenever',
      ],
      prohibitedResponsePhrases: [
        'act now',
        'she will love it',
        'offer ends today',
      ],
      modelResponseEnglish: 'I completely respect that. Please take all the time you need to discuss it together. I will make a note on your account with these exact details so whenever you are ready, any representative can assist you.',
      coachingArabic: 'احترم قرار العميل بمشاورة شريكه وسجل ملحوظة واضحة في الحساب بدون أي ضغط أو ادعاء استعجال كاذب.',
    ),

    // 6. Contract Lock-in Fear
    ObjectionDrillItem(
      id: 'obj-06-contract-fear',
      title: 'Long-Term Contract & Penalty Hesitation',
      customerObjection: 'I had a two-year contract before that trapped me with early termination penalties. I am never signing a service contract again.',
      requiredResponseKeywords: [
        'contract',
        'cancel',
        'freedom',
        'transparent',
      ],
      prohibitedResponsePhrases: ['sign today', 'mandatory agreement'],
      modelResponseEnglish: 'You will be glad to know our AT&T Fiber and wireless postpaid plans have no annual service contracts or early cancellation penalties. You have the freedom to change or cancel anytime.',
      coachingArabic: 'طمن العميل إن الفايبر وباقات الموبايل مفيهاش عقود سنوية ملزمة (No Annual Contracts) ويقدر يغير في أي وقت.',
    ),

    // 7. Past Bad Experience
    ObjectionDrillItem(
      id: 'obj-07-past-bad-experience',
      title: 'Lingering Frustration from Past Order Defect',
      customerObjection: 'Two years ago, a phone representative promised me a promotional credit that took six months and ten phone calls to finally resolve.',
      requiredResponseKeywords: ['sorry', 'understand', 'verify', 'document'],
      prohibitedResponsePhrases: ['that was not my fault', 'forget the past'],
      modelResponseEnglish: 'I am truly sorry you had to go through that experience. That is why today I ensure every term is fully documented on your confirmation summary before any change is finalized.',
      coachingArabic: 'اعتذر بصدق عن التجربة القديمة السيئة، وأكد إنك بتوثق كل الشروط كتابياً قبل ما تأكد أي خطوة.',
    ),

    // 8. Competitor Price Match Request
    ObjectionDrillItem(
      id: 'obj-08-competitor-deal',
      title: 'Unmatchable Promotional Competitor Price',
      customerObjection: 'Spectrum sent me a flyer offering internet for thirty dollars a month. Can you match that exact thirty-dollar price right now?',
      requiredResponseKeywords: [
        'transparent',
        'cannot match',
        'value',
        'reliable',
      ],
      prohibitedResponsePhrases: [
        'yes I can match that',
        'guarantee thirty dollars',
      ],
      modelResponseEnglish: 'To be completely transparent with you, I cannot match that promotional promotional introductory rate. What AT&T Fiber offers instead is a dedicated fiber connection that does not jump in price after a few months.',
      coachingArabic: 'كن صريح وأمين؛ قول إنك مش هتقدر تطابق السعر الدعائي المؤقت، وركز على ثبات خدمة الفايبر وجودتها.',
    ),
  ];
}
