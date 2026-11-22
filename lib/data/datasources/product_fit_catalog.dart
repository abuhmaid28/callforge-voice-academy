import '../../core/models/provenance.dart';
import '../../domain/entities/product_fit.dart';

/// Pre-populated fictional product catalog for consultative sales practice.
/// All pricing, speed tiers, and terms are strictly simulated for training.
abstract class ProductFitCatalog {
  static const List<FictionalProduct> standardProducts = [
    // 1. Wireless Starter
    FictionalProduct(
      id: 'prod-wireless-starter',
      name: 'Unlimited Starter SL',
      serviceType: ServiceType.wireless,
      headline: 'Essential unlimited talk, text, and data with standard definition streaming.',
      fictionalMonthlyCost:
          'Fictional \$65.00/mo (Single line with AutoPay & Paperless)',
      keyFeatures: [
        'Unlimited talk, text, and data in US, Mexico, and Canada',
        'Standard definition streaming',
        '5GB mobile hotspot per line',
        'AT&T ActiveArmor mobile security basic',
      ],
      idealForNeeds: [
        'budget-conscious',
        'single-user',
        'light-streaming',
        'basic-smartphone',
        'cost-saving',
      ],
      mandatoryDisclosures: [
        'AutoPay and paperless billing enrollment required for discount',
        'Speeds may be temporarily slowed during network congestion',
        'Taxes, administrative fees, and regulatory charges are extra',
      ],
      unknownEligibilityPrerequisites: [
        'Credit check requirement for postpaid service',
        'Existing account status and balance standing',
      ],
      metadata: ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes: 'Fictional wireless entry tier [Fictional / Simulation Only].',
      ),
    ),

    // 2. Wireless Extra
    FictionalProduct(
      id: 'prod-wireless-extra',
      name: 'Unlimited Extra EL',
      serviceType: ServiceType.wireless,
      headline: 'High-speed priority data with generous 30GB mobile hotspot for professionals and families.',
      fictionalMonthlyCost:
          'Fictional \$75.00/mo (Single line with AutoPay & Paperless)',
      keyFeatures: [
        '75GB of high-speed dedicated priority data',
        '30GB mobile hotspot data per line',
        'Unlimited talk, text, and data in US, Mexico, and Canada',
        'AT&T ActiveArmor advanced mobile security',
      ],
      idealForNeeds: [
        'commuter',
        'remote-worker',
        'moderate-hotspot',
        'priority-data',
        'family-multi-line',
      ],
      mandatoryDisclosures: [
        'AutoPay & paperless discount applies to monthly recurring rate',
        'After 75GB, speeds may be temporarily slowed during network congestion',
        'Hotspot speed slows to 128Kbps after 30GB allowance',
      ],
      unknownEligibilityPrerequisites: [
        'Multi-line discount pricing depends on total verified active lines',
        'Account owner authorization required for plan migration',
      ],
      metadata: ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes:
            'Fictional mid-tier wireless plan [Fictional / Simulation Only].',
      ),
    ),

    // 3. Wireless Premium
    FictionalProduct(
      id: 'prod-wireless-premium',
      name: 'Unlimited Premium PL',
      serviceType: ServiceType.wireless,
      headline: 'Uncapped priority data that never slows, 60GB hotspot, and international roaming in 19 countries.',
      fictionalMonthlyCost:
          'Fictional \$85.00/mo (Single line with AutoPay & Paperless)',
      keyFeatures: [
        'Unlimited high-speed data that cannot slow down based on your usage',
        '60GB mobile hotspot data per line',
        '4K UHD streaming capable',
        'Unlimited talk, text, and high-speed data in 19 Latin American countries',
      ],
      idealForNeeds: [
        'heavy-streamer',
        'power-user',
        'international-traveler',
        'content-creator',
        'maximum-performance',
      ],
      mandatoryDisclosures: [
        'Requires 4K UHD capable device and settings toggle',
        'AutoPay & paperless billing discount required for advertised rate',
        'Coverage and international roaming subject to partner networks',
      ],
      unknownEligibilityPrerequisites: [
        'Device hardware compatibility for 4K streaming and 5G+ millimeter wave',
      ],
      metadata: ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes:
            'Fictional top-tier wireless plan [Fictional / Simulation Only].',
      ),
    ),

    // 4. AT&T Fiber 300
    FictionalProduct(
      id: 'prod-fiber-300',
      name: 'AT&T Fiber 300 Mbps',
      serviceType: ServiceType.fiber,
      headline: 'Ultra-fast symmetrical 100% fiber internet with equal upload and download speeds.',
      fictionalMonthlyCost: 'Fictional \$55.00/mo (with AutoPay & Paperless)',
      keyFeatures: [
        '300 Mbps download and 300 Mbps upload symmetrical speed',
        'Unlimited internet data with no annual contracts',
        'Wi-Fi 6 gateway equipment included with service',
        'Over 99% proven network reliability',
      ],
      idealForNeeds: [
        'home-internet-switch',
        'cable-frustrated',
        'zoom-calls',
        'cloud-backup',
        '2-to-4-devices',
      ],
      mandatoryDisclosures: [
        'Internet speed claims represent maximum wired network service capabilities',
        'Fiber optic availability is location-specific and subject to address verification',
        'Professional installation or self-install kit eligibility determined by facilities',
      ],
      unknownEligibilityPrerequisites: [
        'PHYSICAL ADDRESS QUALIFICATION UNKNOWN until checked in system',
        'Current drop wire and optical network terminal status at property',
      ],
      metadata: ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes: 'Fictional entry fiber internet tier [Fictional / Simulation Only].',
      ),
    ),

    // 5. AT&T Fiber 500
    FictionalProduct(
      id: 'prod-fiber-500',
      name: 'AT&T Fiber 500 Mbps',
      serviceType: ServiceType.fiber,
      headline: 'Heavy-duty symmetrical bandwidth for busy households with simultaneous video streaming and gaming.',
      fictionalMonthlyCost: 'Fictional \$65.00/mo (with AutoPay & Paperless)',
      keyFeatures: [
        '500 Mbps symmetrical download and upload',
        'No data caps and no overage penalties',
        'Ultra-low lag and latency for multiplayer gaming',
        'Wi-Fi 6 gateway router included',
      ],
      idealForNeeds: [
        'multi-user-household',
        'gaming',
        'multiple-4k-streams',
        'smart-home',
      ],
      mandatoryDisclosures: [
        'Address qualification check required prior to service order entry',
        'Actual customer Wi-Fi speeds vary depending on distance and home construction',
      ],
      unknownEligibilityPrerequisites: [
        'Fiber terminal port availability at the neighborhood distribution hub',
      ],
      metadata: ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes:
            'Fictional mid-tier fiber internet [Fictional / Simulation Only].',
      ),
    ),

    // 6. AT&T Fiber 1000 (1 GIG)
    FictionalProduct(
      id: 'prod-fiber-1000',
      name: 'AT&T Fiber 1 GIG (1000 Mbps)',
      serviceType: ServiceType.fiber,
      headline: 'Pro-grade Gigabit fiber for smart homes, extensive device ecosystems, and massive file transfers.',
      fictionalMonthlyCost: 'Fictional \$80.00/mo (with AutoPay & Paperless)',
      keyFeatures: [
        'Up to 1000 Mbps symmetrical speed capability',
        'Unlimited data allowance',
        'Advanced ActiveArmor internet security protection',
        'Handles 12+ connected devices simultaneously without buffering',
      ],
      idealForNeeds: [
        'smart-home-ecosystem',
        'large-family',
        'large-file-transfers',
        'competitive-gaming',
      ],
      mandatoryDisclosures: [
        'Gigabit speeds require compatible Ethernet hardware or latest Wi-Fi 6 cards',
        'Requires certified fiber optic terminal at residential premises',
      ],
      unknownEligibilityPrerequisites: [
        'Fiber optic line validation required for exact building address',
      ],
      metadata: ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes:
            'Fictional gigabit fiber internet [Fictional / Simulation Only].',
      ),
    ),

    // 7. Cellular Home Phone Base (Landline Alternative)
    FictionalProduct(
      id: 'prod-cellular-base-landline',
      name: 'Wireless Home Phone Cellular Base',
      serviceType: ServiceType.landlineToWireless,
      headline: 'Affordable wireless adapter that powers existing home telephone handsets over cellular network.',
      fictionalMonthlyCost:
          'Fictional \$30.00/mo (Hardware adapter installment extra)',
      keyFeatures: [
        'Connects standard home telephone handsets to cellular network',
        'Keep existing home telephone handset jacks and handsets',
        'Replaces aging copper landline wire without rewiring home',
        'Includes voicemail, caller ID, and call waiting features',
      ],
      idealForNeeds: [
        'elderly-caller',
        'copper-landline-replacement',
        'fixed-income',
        'keep-home-phone',
      ],
      mandatoryDisclosures: [
        'Number transfer from traditional copper landline is subject to carrier porting validation',
        'Requires cellular signal reception inside premises and backup battery for outages',
        'Does not support medical alert pulse systems or wired pulse security alarms without testing',
      ],
      unknownEligibilityPrerequisites: [
        'LANDLINE NUMBER PORTABILITY UNKNOWN until telephone exchange check is run',
        'Indoor cellular signal coverage verification required',
      ],
      metadata: ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes: 'Fictional copper landline alternative [Fictional / Simulation Only].',
      ),
    ),

    // 8. Next Up & 36-Month Installment
    FictionalProduct(
      id: 'prod-next-up-eip',
      name: 'Next Up Early Upgrade Option (36-Mo EIP)',
      serviceType: ServiceType.deviceInstallment,
      headline: 'Flexibility to trade in your smartphone and upgrade once 50% of the device balance is paid off.',
      fictionalMonthlyCost:
          'Fictional \$6.00/mo add-on + 36-month device installment',
      keyFeatures: [
        'Option to upgrade early when 50% of the retail device cost is reached',
        'Zero percent APR financing split across 36 monthly installments',
        'Trade-in must be in good physical and fully operational condition',
      ],
      idealForNeeds: [
        'annual-upgrader',
        'latest-tech',
        'smartphone-enthusiast',
        'low-upfront-cost',
      ],
      mandatoryDisclosures: [
        'Thirty-six month financing agreement; cancelling wireless service makes full remaining balance due',
        'Next Up six dollar monthly fee does not reduce the financed device principal balance',
        'Turned-in device must power on, have no screen cracks, and disable activation locks',
      ],
      unknownEligibilityPrerequisites: [
        'Credit qualification and account installment line limit verification',
      ],
      metadata: ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes: 'Fictional device installment and early upgrade add-on [Fictional / Simulation Only].',
      ),
    ),

    // 9. Add-a-Line & Family Multi-Device
    FictionalProduct(
      id: 'prod-add-a-line',
      name: 'Family Line Addition with Multi-Line Discount',
      serviceType: ServiceType.addALine,
      headline: 'Add a new wireless line to an existing account with compounding per-line group discounts.',
      fictionalMonthlyCost: 'Fictional \$35.00–\$45.00/line/mo (based on 4-line tier with AutoPay)',
      keyFeatures: [
        'Reduces the monthly cost of all existing lines on eligible unlimited tiers',
        'Shareable account management while each line has dedicated data and hotspot',
        'Bring Your Own Device (BYOD) or pair with promotional installment',
      ],
      idealForNeeds: [
        'teenager-phone',
        'spouse-addition',
        'elderly-parent',
        'tablet-or-watch',
        'family-plan',
      ],
      mandatoryDisclosures: [
        'Account owner or authorized user approval required to add a line',
        'One-time standard activation fee applies per newly activated line unless promotional waiver applies',
        'Per-line price reduces when adding lines 2 through 4, subject to plan terms',
      ],
      unknownEligibilityPrerequisites: [
        'Maximum allowed lines per account subject to credit standing',
        'Billed account status must be current without past due balance',
      ],
      metadata: ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes: 'Fictional multi-line addition [Fictional / Simulation Only].',
      ),
    ),

    // 10. Device Protection Advantage
    FictionalProduct(
      id: 'prod-device-protection',
      name: 'AT&T Protect Advantage (Device Insurance)',
      serviceType: ServiceType.accessories,
      headline: 'Comprehensive device protection covering accidental damage, loss, theft, and hardware malfunctions.',
      fictionalMonthlyCost:
          'Fictional \$14.00–\$17.00/mo (depending on device tier)',
      keyFeatures: [
        'Covers accidental damage including cracked screens and liquid damage',
        'Same-day screen repair available in select metropolitan areas',
        'Coverage for loss and theft with next-business-day device replacement',
        'Unlimited photo storage and technical support sessions',
      ],
      idealForNeeds: [
        'expensive-flagship',
        'kids-device',
        'accident-prone',
        'peace-of-mind',
      ],
      mandatoryDisclosures: [
        'Optional add-on; enrolling is not required to activate or purchase wireless service',
        'Thirty-day enrollment window from initial device purchase or upgrade date',
        'Replacement deductibles apply based on equipment tier and claim type',
        'May be cancelled at any time through myAT&T or representative assistance',
      ],
      unknownEligibilityPrerequisites: [
        'Device enrollment eligibility check (must be within 30 days of purchase)',
      ],
      metadata: ContentMetadata(
        provenance: ProvenanceTier.fictionalSimulation,
        notes: 'Fictional device insurance protection [Fictional / Simulation Only].',
      ),
    ),
  ];
}
