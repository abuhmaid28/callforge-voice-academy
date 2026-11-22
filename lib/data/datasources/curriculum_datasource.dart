import '../../domain/entities/adaptive_curriculum.dart';

abstract class CurriculumDataSource {
  /// Canonical 13-week milestones across the 90-day adaptive curriculum.
  static final List<WeeklyMilestone> weeklyMilestones = [
    // Phase 1: Foundations (Weeks 1–4, Days 1–30)
    const WeeklyMilestone(
      weekNumber: 1,
      phase: CurriculumPhaseType.phase1Foundations,
      title: 'Mandatory Greeting & Speech Clarity',
      titleArabic: 'الترحيب الإلزامي ومخارج الحروف',
      targetCompetency:
          'Flawless verbatim Alex greeting and P/B phonemic clarity',
    ),
    const WeeklyMilestone(
      weekNumber: 2,
      phase: CurriculumPhaseType.phase1Foundations,
      title: 'AERD Empathy & De-escalation',
      titleArabic: 'التعاطف المهني ونزع فتيل التوتر',
      targetCompetency: 'Acknowledge, Empathize, Reassure, and Deliver structured resolutions',
    ),
    const WeeklyMilestone(
      weekNumber: 3,
      phase: CurriculumPhaseType.phase1Foundations,
      title: 'Billing Breakdown & Proration',
      titleArabic: 'شرح الفواتير والمبالغ المجزأة',
      targetCompetency:
          'Transparent line-item audits and activation fee explanation',
    ),
    const WeeklyMilestone(
      weekNumber: 4,
      phase: CurriculumPhaseType.phase1Foundations,
      title: 'Mandatory Disclosures & Compliance',
      titleArabic: 'الإفصاحات الإلزامية والامتثال',
      targetCompetency:
          'AutoPay, cancellation rights, and E911 disclosure accuracy',
    ),

    // Phase 2: Sales Confidence (Weeks 5–8, Days 31–60)
    const WeeklyMilestone(
      weekNumber: 5,
      phase: CurriculumPhaseType.phase2SalesConfidence,
      title: 'Consultative Needs Discovery',
      titleArabic: 'استكشاف احتياجات العميل الاستشارية',
      targetCompetency:
          'Open-ended questioning to uncover commute, work, and family usage',
    ),
    const WeeklyMilestone(
      weekNumber: 6,
      phase: CurriculumPhaseType.phase2SalesConfidence,
      title: 'Plan Right-Sizing & Value Bridge',
      titleArabic: 'ملاءمة الباقة وجسر القيمة',
      targetCompetency:
          'Upgrading Starter to Extra/Premium based strictly on verified need',
    ),
    const WeeklyMilestone(
      weekNumber: 7,
      phase: CurriculumPhaseType.phase2SalesConfidence,
      title: 'Symmetrical Fiber & Address Qualification',
      titleArabic: 'تأهيل سرعات الفايبر وعناوين التغطية',
      targetCompetency:
          'Symmetrical upload value and address verification guardrails',
    ),
    const WeeklyMilestone(
      weekNumber: 8,
      phase: CurriculumPhaseType.phase2SalesConfidence,
      title: 'Multi-Line Math & Ecosystem Expansion',
      titleArabic: 'حسابات تعدد الخطوط وتوسيع المنظومة',
      targetCompetency:
          'Multi-line volume discount math, wearable, and tablet lines',
    ),

    // Phase 3: Advanced Closing (Weeks 9–13, Days 61–90)
    const WeeklyMilestone(
      weekNumber: 9,
      phase: CurriculumPhaseType.phase3AdvancedClosing,
      title: 'Copper Retirement & Landline Transitions',
      titleArabic: 'ترقية خطوط النحاس القديمة والهواتف اللاسلكية',
      targetCompetency:
          'Number porting safety and pulse/medical alert guardrails',
    ),
    const WeeklyMilestone(
      weekNumber: 10,
      phase: CurriculumPhaseType.phase3AdvancedClosing,
      title: 'Trade-In Appraisal & Condition Honesty',
      titleArabic: 'تقييم استبدال الأجهزة ومصداقية الفحص',
      targetCompetency:
          'Screen damage tiers, iCloud unlock, and 36-month installment truth',
    ),
    const WeeklyMilestone(
      weekNumber: 11,
      phase: CurriculumPhaseType.phase3AdvancedClosing,
      title: 'High-Friction Objection Handling',
      titleArabic: 'التعامل مع الاعتراضات الشديدة',
      targetCompetency:
          'Countering price friction, competitor flyers, and lock-in fear',
    ),
    const WeeklyMilestone(
      weekNumber: 12,
      phase: CurriculumPhaseType.phase3AdvancedClosing,
      title: 'Retention Saves & Floor Ownership',
      titleArabic: 'الحفاظ على العملاء والمسؤولية المباشرة',
      targetCompetency: 'De-escalating supervisor demands and crafting permanent bundle saves',
    ),
    const WeeklyMilestone(
      weekNumber: 13,
      phase: CurriculumPhaseType.phase3AdvancedClosing,
      title: 'Ethical Closing & Respectful No-Sale Mastery',
      titleArabic: 'الإغلاق الأخلاقي واحتراف البيع المحترم',
      targetCompetency: 'Mastery of customer autonomy, no false promises, and full certification',
    ),
  ];

  /// The complete 90-day syllabus.
  static final List<CurriculumDay> allDays = _build90Days();

  static List<CurriculumDay> _build90Days() {
    final days = <CurriculumDay>[];

    // Days 1–30: Phase 1 Foundations
    for (int d = 1; d <= 30; d++) {
      // Primary care scenario id from existing 30 care scenarios (e.g. 'scen-01' to 'scen-30')
      final scenarioId = 'scen-${d.toString().padLeft(2, '0')}';
      final isOdd = d % 2 != 0;

      days.add(
        CurriculumDay(
          dayNumber: d,
          phase: CurriculumPhaseType.phase1Foundations,
          themeTitle: 'Day $d: Floor Care & Voice Fundamentals',
          themeTitleArabic: 'اليوم $d: أساسيات خدمة العملاء ومخارج الصوت',
          focusSkillTag: isOdd ? 'Greeting Discipline' : 'AERD Empathy',
          primaryScenarioId: scenarioId,
          drillType: isOdd ? 'pb_contrast' : 'fast_numbers',
          drillId: isOdd
              ? 'drill-pb-${(d % 5) + 1}'
              : 'drill-num-${(d % 5) + 1}',
          learningObjectives: [
            'Deliver standard Alex greeting without omissions',
            'Handle customer inquiries using calm, structured AERD',
            'Verify account identity securely',
          ],
        ),
      );
    }

    // Days 31–60: Phase 2 Sales Confidence (Sales Scenarios 1–24 & Discovery Drills 1–12)
    final phase2ScenarioIds = [
      'sales-01-starter-to-extra',
      'sales-02-extra-to-premium-travel',
      'sales-03-budget-wireless-discovery',
      'sales-04-multiline-extra-family',
      'sales-05-content-creator-4k',
      'sales-06-security-activearmor-upgrade',
      'sales-07-student-shared-data-switch',
      'sales-08-dual-carrier-pro-upgrade',
      'sales-09-fiber-300-streaming-upgrade',
      'sales-10-fiber-wfh-heavy-uploader',
      'sales-11-fiber-gaming-latency',
      'sales-12-fiber-smart-home-ecosystem',
      'sales-13-fiber-bundle-wireless-discount',
      'sales-14-fiber-55-plus-community',
      'sales-15-fiber-moving-new-construction',
      'sales-16-fiber-address-unverified',
      'sales-17-teenager-first-phone',
      'sales-18-spouse-switch-from-verizon',
      'sales-19-cellular-smartwatch-fitness',
      'sales-20-tablet-road-warrior-ipad',
      'sales-21-aging-parent-safety-line',
      'sales-22-small-business-work-line',
      'sales-23-college-student-second-line',
      'sales-24-parent-care-tablet-monitoring',
    ];

    for (int d = 31; d <= 60; d++) {
      final index = (d - 31) % phase2ScenarioIds.length;
      final scenarioId = phase2ScenarioIds[index];
      final discIndex = ((d - 31) % 12) + 1;
      final drillId = 'disc-${discIndex.toString().padLeft(2, '0')}';

      days.add(
        CurriculumDay(
          dayNumber: d,
          phase: CurriculumPhaseType.phase2SalesConfidence,
          themeTitle: 'Day $d: Consultative Discovery & Plan-Fit',
          themeTitleArabic: 'اليوم $d: الاستكشاف الاستشاري وملاءمة الباقات',
          focusSkillTag: d <= 45 ? 'Discovery Questioning' : 'Value Bridge',
          primaryScenarioId: scenarioId,
          drillType: 'discovery',
          drillId: drillId,
          learningObjectives: [
            'Ask open-ended discovery questions before proposing solutions',
            'Connect household pain points to specific plan capabilities',
            'State transparent pricing with required AutoPay disclosures',
          ],
        ),
      );
    }

    // Days 61–90: Phase 3 Advanced Closing (Sales Scenarios 25–48 & Objection Drills 1–8)
    final phase3ScenarioIds = [
      'sales-25-copper-wire-retire',
      'sales-26-power-outage-battery-backup',
      'sales-27-standalone-rural-flip-phone',
      'sales-28-fixed-income-standalone-line',
      'sales-29-security-alarm-pulse-warning',
      'sales-30-rotary-to-touchtone-modernization',
      'sales-31-medical-alert-device-check',
      'sales-32-accessibility-large-button',
      'sales-33-cracked-screen-tradein',
      'sales-34-next-up-early-upgrade',
      'sales-35-byod-vs-installment',
      'sales-36-activation-lock-removal',
      'sales-37-battery-health-degradation',
      'sales-38-storage-capacity-upgrade',
      'sales-39-promotional-bill-credits-timeline',
      'sales-40-credit-limit-installment-boundary',
      'sales-41-bill-shock-plan-audit',
      'sales-42-competitor-offer-match',
      'sales-43-expired-promotion-recovery',
      'sales-44-demanding-supervisor-deescalation',
      'sales-45-moving-retention-bundle',
      'sales-46-line-suspension-financial-hardship',
      'sales-47-unauthorized-third-party-add-on',
      'sales-48-longtime-loyalty-recap',
    ];

    for (int d = 61; d <= 90; d++) {
      final index = (d - 61) % phase3ScenarioIds.length;
      final scenarioId = phase3ScenarioIds[index];
      final objIndex = ((d - 61) % 8) + 1;
      final drillId = 'obj-${objIndex.toString().padLeft(2, '0')}';

      days.add(
        CurriculumDay(
          dayNumber: d,
          phase: CurriculumPhaseType.phase3AdvancedClosing,
          themeTitle: 'Day $d: High-Friction Mastery & Ethical Closing',
          themeTitleArabic:
              'اليوم $d: احتراف الاعتراضات الصعبة والإغلاق الأخلاقي',
          focusSkillTag: d >= 80 ? 'Respectful No-Sale' : 'Objection Handling',
          primaryScenarioId: scenarioId,
          drillType: 'objection',
          drillId: drillId,
          learningObjectives: [
            'Overcome price and contract friction without pushiness',
            'Enforce life-safety and technical eligibility boundaries',
            'Achieve respectful no-sale excellence when fit is absent',
          ],
        ),
      );
    }

    return days;
  }

  /// Get metadata for a specific curriculum day (1..90).
  static CurriculumDay? getDay(int dayNumber) {
    if (dayNumber < 1 || dayNumber > 90) return null;
    return allDays[dayNumber - 1];
  }

  /// Get all curriculum days belonging to a specific phase.
  static List<CurriculumDay> getDaysForPhase(CurriculumPhaseType phase) {
    return allDays.where((d) => d.phase == phase).toList();
  }

  /// Get milestone for a given week (1..13).
  static WeeklyMilestone? getMilestoneForWeek(int weekNumber) {
    try {
      return weeklyMilestones.firstWhere((m) => m.weekNumber == weekNumber);
    } catch (_) {
      return null;
    }
  }
}
