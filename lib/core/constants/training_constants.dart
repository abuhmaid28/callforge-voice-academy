/// Training constants, source provenance, and compliance anchors for CALLFORGE.
abstract class TrainingConstants {
  /// Required representative alias [User-Confirmed Workflow]
  static const String agentAlias = 'Alex';

  /// User-confirmed inbound greeting [User-Confirmed Workflow]
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

  /// Fictional customer persona for M1 inbound call [Fictional / Simulation Only]
  static const String m1CustomerPersona = 'David Miller (Fictional Customer)';

  /// Customer audio response delivered after Alex successfully delivers the greeting [Fictional / Simulation Only]
  static const String m1CustomerResponse =
      'Hi Alex, thank you. My name is David Miller. I just got my very first bill from AT&T in the mail, and it is almost forty dollars higher than what the rep in the retail store told me. Can you explain why this is so high?';

  /// Arabic Coaching Messages (Egyptian Arabic) [Derived Training Material]
  static const String coachingGreetingPerfect =
      'الله ينور يا أليكس! مطابقة ممتازة للافتتاحية الإلزامية حسب النص المحول، والاسم وشركة AT&T حاضرين بثقة.';

  static const String coachingGreetingGood =
      'أداء كويس يا بطل! الافتتاحية اتعرف عليها بشكل مناسب، بس راجع الكلمات اللي اختلفت عشان تجيب أعلى دقة في الـ QA.';

  static const String coachingGreetingNeedsWork =
      'محتاجين نعيد المحاولة. الافتتاحية الإلزامية لازم تتضمن اسمك "Alex" وشركة "AT&T" وطلب الاسم الأول والأخير بوضوح.';

  static const String coachingMissingAnchorsPrefix =
      'الكلمات الإلزامية دي مش ظاهرة في النص المحول: ';

  static const String coachingPbContrastWarning =
      'ملحوظة تدريبية: تم رصد كلمة في النص المحول فيها تشويش محتمل بين حرف P وحرف B. للتذكير: في الإنجليزي الأمريكي حرف الـ P voiceless ومحتاج دفعة هواء واضحة (Aspiration) عشان ميتسمعش كأنه B.';
}
