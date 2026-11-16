/// Training constants and compliance anchors for CALLFORGE.
abstract class TrainingConstants {
  /// Required representative alias
  static const String agentAlias = 'Alex';

  /// User-confirmed inbound greeting
  static const String standardGreeting =
      'Hello, thank you for calling AT&T. This is Alex. May I have your first and last name, please?';

  /// Normalized mandatory semantic anchors that must be present in greeting
  static const List<String> greetingRequiredAnchors = [
    'att', // or 'at&t'
    'alex',
    'first',
    'last',
    'name',
  ];

  /// Fictional customer scenario for M1 inbound call
  static const String m1CustomerPersona = 'David Miller (Fictional Customer)';
  static const String m1CustomerPrompt =
      'Hi there, I just got my very first bill from AT&T in the mail, and it is almost forty dollars higher than what the rep in the retail store told me. Can you explain why this is so high?';

  /// Arabic Coaching Messages (Egyptian Arabic)
  static const String coachingGreetingPerfect =
      'الله ينور يا أليكس! افتتاحية نموذجية 100%، نطق واضح جداً والاسم وشركة AT&T حاضرين بثقة.';

  static const String coachingGreetingGood =
      'أداء كويس يا بطل! بس ركز إنك متنساش ولا كلمة من الافتتاحية الإلزامية عشان الـ QA ميعلمش عليك.';

  static const String coachingGreetingNeedsWork =
      'محتاجين نعيد التدريب. الافتتاحية هي أول انطباع للعميل عنك، لازم تذكر اسمك "Alex" وشركة "AT&T" وتطلب الاسم الأول والأخير بوضوح.';

  static const String coachingMissingAnchorsPrefix =
      'الكلمات دي ناقصة في افتتاحيتك: ';

  static const String coachingPbContrastWarning =
      'ملحوظة صوتية هامة: لاحظنا وجود تشويش بين نطق حرف P وحرف B. في المكالمات مع الأمريكان، كلمة زي "Plan" أو "Payment" لو اتنطقت "Blan" أو "Bayment" بتعمل سوء فهم فوري. طلع هوا واضح من شفايفك وإنت بتنطق P.';
}
