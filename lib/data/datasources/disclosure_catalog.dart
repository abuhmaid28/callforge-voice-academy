import '../../core/models/provenance.dart';
import '../models/disclosure_script.dart';

/// Authoritative catalog of self-contained fictional disclosure practice scripts.
/// Strictly labeled [Fictional / Simulation Only] — NOT official proprietary AT&T legal copy.
class DisclosureCatalog {
  static final List<DisclosureScript> standardDisclosures = [
    // 1. AutoPay & Paperless Discount
    const DisclosureScript(
      id: 'disc-autopay-01',
      title: 'AutoPay & Paperless Billing Discount',
      category: 'Billing & Payments',
      scriptText: 'By enrolling in AutoPay and Paperless Billing today, you will receive a ten dollar monthly discount per phone line when paying with a debit card or checking account. The discount will appear within two billing cycles. If you switch to a credit card, the discount is reduced to five dollars per line. You may update your payment method or cancel at any time in the app.',
      criticalTerms: [
        CriticalTerm(
          term: 'ten dollar',
          category: 'amount',
          isNumericOrPrice: true,
        ),
        CriticalTerm(term: 'debit card', category: 'condition'),
        CriticalTerm(term: 'checking account', category: 'condition'),
        CriticalTerm(
          term: 'two billing cycles',
          category: 'duration',
          isNumericOrPrice: true,
        ),
        CriticalTerm(
          term: 'five dollars',
          category: 'amount',
          isNumericOrPrice: true,
        ),
        CriticalTerm(term: 'cancel at any time', category: 'obligation'),
      ],
      customerResponses: [
        SimulatedCustomerResponse(
          outcome: ConsentOutcome.agreed,
          spokenText: 'Sounds great, Alex! Go ahead and set that up with my checking account.',
          trainerGuidanceArabic:
              'العميل وافق بوضوح. كمل الإجراء واشكره على تفعيل الخصم.',
          expectedAgentAction:
              'Acknowledge agreement and confirm account details.',
        ),
        SimulatedCustomerResponse(
          outcome: ConsentOutcome.questioned,
          spokenText: 'Wait, Alex, does the ten dollar discount start right on the first bill, or do I wait two months?',
          trainerGuidanceArabic: 'العميل متردد بخصوص موعد بدء الخصم. اشرح له بلطف إنه بيحتاج دورة أو دورتين فواتير عشان يظهر على السيستم.',
          expectedAgentAction:
              'Clarify billing cycle timing without restarting disclosure.',
        ),
        SimulatedCustomerResponse(
          outcome: ConsentOutcome.refused,
          spokenText: 'No thanks, Alex. I prefer keeping paper bills so I can review them manually every month.',
          trainerGuidanceArabic: 'العميل رفض الـ AutoPay. احترم رغبته بـ AERD ومتضغطش عليه بطريقة غير مهنية.',
          expectedAgentAction:
              'Acknowledge preference respectfully using AERD.',
        ),
      ],
      metadata: ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        version: '1.0.0',
        lastReviewed: '2026-11-21',
        authorOrSource: 'CALLFORGE Fictional Practice Suite',
        notes:
            'Fictionalized exercise for pacing and critical numbers precision.',
      ),
    ),

    // 2. Equipment Installment Plan (EIP) 36-Month
    const DisclosureScript(
      id: 'disc-eip-02',
      title: 'Equipment Installment Plan (36-Month EIP)',
      category: 'Hardware & Devices',
      scriptText: 'Your new device is purchased on a thirty-six month installment agreement with zero percent APR. The monthly device payment is twenty-five dollars. You may pay off the remaining balance at any time without penalty. If you disconnect wireless service, the entire remaining device balance becomes immediately due.',
      criticalTerms: [
        CriticalTerm(
          term: 'thirty-six month',
          category: 'duration',
          isNumericOrPrice: true,
        ),
        CriticalTerm(
          term: 'zero percent',
          category: 'amount',
          isNumericOrPrice: true,
        ),
        CriticalTerm(
          term: 'twenty-five dollars',
          category: 'amount',
          isNumericOrPrice: true,
        ),
        CriticalTerm(term: 'without penalty', category: 'condition'),
        CriticalTerm(term: 'immediately due', category: 'obligation'),
      ],
      customerResponses: [
        SimulatedCustomerResponse(
          outcome: ConsentOutcome.agreed,
          spokenText: 'Yes, thirty-six months works fine for me. Let’s finalize the order, Alex.',
          trainerGuidanceArabic:
              'موافقة صريحة على تقسيط الـ 36 شهر. كمل التوثيق.',
          expectedAgentAction: 'Confirm order submission and delivery address.',
        ),
        SimulatedCustomerResponse(
          outcome: ConsentOutcome.questioned,
          spokenText: 'Can I pay off the phone early next year if I get a holiday bonus?',
          trainerGuidanceArabic: 'العميل بيسأل عن السداد المبكر. أكد له إن السداد متاح في أي وقت وبدون أي غرامة إضافية.',
          expectedAgentAction:
              'Reassure client that early payoff has zero penalty.',
        ),
        SimulatedCustomerResponse(
          outcome: ConsentOutcome.refused,
          spokenText: 'Thirty-six months is way too long for a phone commitment. I will buy it unlocked in cash.',
          trainerGuidanceArabic: 'العميل رفض مدة التقسيط. قدم له خيار الشراء المباشر أو اسأله عن الميزانية المناسبة له.',
          expectedAgentAction: 'Offer full-retail alternative politely.',
        ),
      ],
      metadata: ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        version: '1.0.0',
        lastReviewed: '2026-11-21',
        authorOrSource: 'CALLFORGE Fictional Practice Suite',
        notes: 'Emphasizes thirty-six month duration and immediate due clause.',
      ),
    ),

    // 3. Fiber Installation & Proration
    const DisclosureScript(
      id: 'disc-fiber-03',
      title: 'Fiber Internet Installation & Proration',
      category: 'Broadband & Fiber',
      scriptText: 'Your technician appointment is scheduled for Thursday between eight AM and noon. An adult eighteen years or older must be present. Your first bill will include a prorated charge from installation day through your bill cycle end, plus the standard sixty-five dollar monthly recurring rate.',
      criticalTerms: [
        CriticalTerm(term: 'eight AM and noon', category: 'condition'),
        CriticalTerm(
          term: 'eighteen years or older',
          category: 'obligation',
          isNumericOrPrice: true,
        ),
        CriticalTerm(term: 'prorated charge', category: 'condition'),
        CriticalTerm(
          term: 'sixty-five dollar',
          category: 'amount',
          isNumericOrPrice: true,
        ),
      ],
      customerResponses: [
        SimulatedCustomerResponse(
          outcome: ConsentOutcome.agreed,
          spokenText: 'Thursday morning is perfect. I will be working from home so I will be there.',
          trainerGuidanceArabic:
              'العميل وافق على الموعد وأكد تواجده كبالغ في البيت.',
          expectedAgentAction:
              'Lock in dispatch appointment and review contact number.',
        ),
        SimulatedCustomerResponse(
          outcome: ConsentOutcome.questioned,
          spokenText: 'What do you mean by prorated charge? How much extra will that be?',
          trainerGuidanceArabic: 'العميل بيسأل عن الـ Proration. اشرح له إنه بيتحاسب بس على الأيام الفعلية اللي استخدم فيها الخدمة قبل بداية أول دورة فاتورة كاملة.',
          expectedAgentAction:
              'Break down daily proration simply using B1 English.',
        ),
        SimulatedCustomerResponse(
          outcome: ConsentOutcome.refused,
          spokenText: 'I cannot do Thursday morning at all. If you cannot do Saturday, cancel the order.',
          trainerGuidanceArabic: 'العميل مش متاح في الوقت ده. استخدم AERD عشان تفحص المواعيد المتاحة في الويك إند.',
          expectedAgentAction:
              'Acknowledge schedule conflict and search weekend dispatch.',
        ),
      ],
      metadata: ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        version: '1.0.0',
        lastReviewed: '2026-11-21',
        authorOrSource: 'CALLFORGE Fictional Practice Suite',
        notes: 'Proration explanation drill with time window critical terms.',
      ),
    ),

    // 4. Trade-In Promotional Credit Condition
    const DisclosureScript(
      id: 'disc-tradein-04',
      title: 'Trade-In Promotional Bill Credit Condition',
      category: 'Promotions & Credits',
      scriptText: 'To qualify for the eight-hundred dollar promotional credit, your trade-in device must be shipped within thirty days of receiving your new phone. The device must power on, have no screen cracks, and find my iPhone or activation locks removed. Credits are applied monthly across thirty-six billing cycles.',
      criticalTerms: [
        CriticalTerm(
          term: 'eight-hundred dollar',
          category: 'amount',
          isNumericOrPrice: true,
        ),
        CriticalTerm(
          term: 'thirty days',
          category: 'duration',
          isNumericOrPrice: true,
        ),
        CriticalTerm(term: 'no screen cracks', category: 'condition'),
        CriticalTerm(term: 'activation locks removed', category: 'condition'),
        CriticalTerm(
          term: 'thirty-six billing cycles',
          category: 'duration',
          isNumericOrPrice: true,
        ),
      ],
      customerResponses: [
        SimulatedCustomerResponse(
          outcome: ConsentOutcome.agreed,
          spokenText: 'Understood Alex. My phone is in great shape, so I will ship it right away.',
          trainerGuidanceArabic:
              'العميل متفهم الشروط وموافق يشحن الجهاز في خلال الـ 30 يوم.',
          expectedAgentAction:
              'Provide shipping label instructions and tracking reminder.',
        ),
        SimulatedCustomerResponse(
          outcome: ConsentOutcome.questioned,
          spokenText: 'Wait, I have a tiny hairline scratch on the back glass. Will that disqualify the full eight hundred?',
          trainerGuidanceArabic: 'العميل بيستفسر عن الخدوش البسيطة. وضح له إن الشاشة الأمامية لازم تكون سليمة وبدون كسور، وقدم له التقييم الشفاف.',
          expectedAgentAction:
              'Clarify front screen vs back glass condition guidelines.',
        ),
        SimulatedCustomerResponse(
          outcome: ConsentOutcome.refused,
          spokenText: 'I do not want to mail my phone. I have heard horror stories about lost trade-ins.',
          trainerGuidanceArabic: 'العميل خايف من الشحن بالبريد. وضح له إمكانية التسليم في الفرع المحلي برقم تتبع فوري.',
          expectedAgentAction:
              'Offer authorized corporate store trade-in drop-off option.',
        ),
      ],
      metadata: ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        version: '1.0.0',
        lastReviewed: '2026-11-21',
        authorOrSource: 'CALLFORGE Fictional Practice Suite',
        notes:
            'High-stake trade-in conditions requiring crystal clear numbers.',
      ),
    ),

    // 5. Device Protection Plan Renewal & Deductible
    const DisclosureScript(
      id: 'disc-insurance-05',
      title: 'Device Protection Plan Monthly Renewal',
      category: 'Insurance & Value Added',
      scriptText: 'Device Protection is optional and billed at seventeen dollars monthly per enrolled phone. Coverage automatically renews each month until canceled. Replacement claims carry a deductible between fifty and two hundred and fifty dollars depending on tier. You may cancel at any time with no cancellation penalty.',
      criticalTerms: [
        CriticalTerm(term: 'optional', category: 'condition'),
        CriticalTerm(
          term: 'seventeen dollars',
          category: 'amount',
          isNumericOrPrice: true,
        ),
        CriticalTerm(term: 'automatically renews', category: 'obligation'),
        CriticalTerm(term: 'deductible', category: 'condition'),
        CriticalTerm(
          term: 'fifty and two hundred and fifty dollars',
          category: 'amount',
          isNumericOrPrice: true,
        ),
        CriticalTerm(term: 'no cancellation penalty', category: 'condition'),
      ],
      customerResponses: [
        SimulatedCustomerResponse(
          outcome: ConsentOutcome.agreed,
          spokenText: 'Yes, please add that Alex. With my kids, phone protection is a lifesaver.',
          trainerGuidanceArabic:
              'العميل وافق على الحماية الشهرية. اكد له التفعيل ورقم البوليصة.',
          expectedAgentAction:
              'Confirm enrollment and state date of effective coverage.',
        ),
        SimulatedCustomerResponse(
          outcome: ConsentOutcome.questioned,
          spokenText: 'Does that seventeen dollar plan cover lost phones or just cracked screens?',
          trainerGuidanceArabic: 'العميل بيسأل عن تغطية الفقد والسرقة. وضح له إن الحماية بتشمل السرقة والتلف العرضي والشاشة.',
          expectedAgentAction:
              'Explain comprehensive loss/theft vs screen repair coverage.',
        ),
        SimulatedCustomerResponse(
          outcome: ConsentOutcome.refused,
          spokenText: 'Seventeen dollars every month is too expensive. I already have a tough case, so no insurance.',
          trainerGuidanceArabic: 'العميل رفض الحماية. متجادلش معاه، احترم قراره وأكد له إنه يقدر يشترك في خلال 30 يوم لو غير رأيه.',
          expectedAgentAction:
              'Respect refusal and note the standard 30-day enrollment window.',
        ),
      ],
      metadata: ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        version: '1.0.0',
        lastReviewed: '2026-11-21',
        authorOrSource: 'CALLFORGE Fictional Practice Suite',
        notes: 'Crucial for practicing optional/mandatory distinction and deductibles.',
      ),
    ),
  ];
}
