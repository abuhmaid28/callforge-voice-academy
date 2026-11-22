# PROJECT_STATE.md — CALLFORGE Current Project Status

## Current execution checkpoint (2026-11-23)
- **Repository**: `https://github.com/abuhmaid28/callforge-voice-academy`
- **Current milestone**: **C2-R1** — Sales Academy Quality, Workout Progression & Concurrency Resilience
- **Implementation issue**: https://github.com/abuhmaid28/callforge-voice-academy/issues/9
- **Current feature branch**: `feat/c2-r1-sales-academy-quality`
- **Draft PR**: [#10](https://github.com/abuhmaid28/callforge-voice-academy/pull/10)
- **Base merge commit**: `7b773aeb6ba2d3821fcebab1d59d33da906e665f` (approved C2-MEGA squash merge)
- **C2-R1 implementation status**: **COMPLETED**.
  - B1: 100% of 90 curriculum day IDs and linked drill IDs resolved and launchable; multi-step structured workout queues (10m 2-step, 20m 3-step, 30m 4-step) with bottom sheet modal launcher.
  - B2: Turn 1 greeting gate hardened using token-aware anchor matching (`SpeechEvaluator`); rejects substring false-positives ("matter"/"battery") and requires Alex, AT&T, and customer first/last name request.
  - B3: Ethical sales conversion gate validates consultative discovery, disclosure coverage, and passing scorecard before awarding `qualifiedAccept`, downgrading unearned sales to `needsVerification`.
  - B4: Turn branching and customer evaluation hardened with multi-condition matching and punctuation-agnostic interrogative recognition.
  - B5: Fictional framing (`[Fictional / Simulation Only]`) and zero supervisor callbacks enforced.
  - B6: Progress persistence serialized via FIFO async synchronization lock; curriculum day completion awarded strictly on passing score (`>= 70.0`).
- **Binding verification strategy**: No personal Android phone, Windows local emulator, local ADB/USB scans, paid APIs, unverified real AT&T offers, proprietary scripts or real customer PII. Native audio remains simulated.
- **Product Owner's authorization**: Complete autonomous execution without routine approvals; standing squash merge authorization granted upon 100% green CI.

---

## 🚦 System & Environment Verification

| Component | Status | Details |
| :--- | :--- | :--- |
| **Flutter SDK** | `VERIFIED` | Flutter 3.47.0 (Channel stable, Dart 3.13.0) at `C:\src\flutter` |
| **Android SDK** | `VERIFIED` | Android SDK 36.0.0, Platform android-37.0 at `C:\Android\Sdk` |
| **Java JDK** | `VERIFIED` | OpenJDK 25.0.2 at `C:\Program Files\Android\Android Studio\jbr` |
| **GitHub CLI** | `VERIFIED` | Authenticated as `abuhmaid28` via git operations protocol HTTPS |
| **Hardware Environment**| `VERIFIED` | Windows 10 Enterprise x64 (8 GB RAM constraint managed with `-Xmx2048m`) |
| **Verification Strategy**| `VERIFIED` | Phone-free hosted Linux CI (GitHub Actions) & Android Emulator integration tests (ADR 010) |
| **Automated Tests** | `VERIFIED` | 138 tests passing (unit, widget, integration) with 0 static analysis issues |

---

## 🎯 Delivered Milestone: C2-MEGA (M4 Sales Mastery & M5 90-Day Adaptive Academy)

- [x] **Phase 1 — 48 Consultative Sales Scenarios Across 6 Core Categories**:
  - Category 1: `wireless_upgrade` (Scenarios 1–8: Starter to Extra, Extra to Premium, Unlimited Choice, Business Starter, 4G LTE to 5G, Tablet Add-on, Travel Pass, Fixed Income Starter).
  - Category 2: `fiber_discovery` (Scenarios 9–16: Cable Internet Frustration, Symmetrical Upload, Home Office, Work-From-Home Zoom, Move Order, Fiber 300 to 500, Gigabit Power User, Fiber Unavailable Guardrail).
  - Category 3: `add_a_line` (Scenarios 17–24: New Teen Driver, Elderly Parent, College Student, Connected Watch, Tablet Line, Small Business Secondary Line, Second Job Line, Port-In from Competitor).
  - Category 4: `landline_to_wireless` (Scenarios 25–32: Aging Copper High Bill, Storm Outage Storm Resilience, Fixed Wireless Terminal, Medical Alert Life-Safety Guardrail, Security Alarm Pulse Dialing Guardrail, Low-Usage Senior, Rural Cottage, Home Fax Migration).
  - Category 5: `trade_in_eip` (Scenarios 33–40: Cracked Screen Trade-In, 36-Month Bill Credit Explainer, Early Upgrade Next Up, Flagship Pre-Order, Clean Condition Evaluation, Unlocked Device BYOD, Battery Degradation Replacement, Early Payoff Balance Transfer).
  - Category 6: `retention_care_to_sales` (Scenarios 41–48: Competitor BOGO Promo Threat, Billing Shock Plan Restructure, De-escalation & Supervisor Call Absence, Low Data Overage Pivot, Job Loss Budget Relief, Relocation Retention, Network Coverage Dissatisfaction, Respectful No-Sale Ethical Closure).
  - All 48 scenarios feature 8–16+ turns, >=2 decision branches, and 3 reachable terminal outcomes (`qualifiedAccept`, `respectfulNoSale`, `needsVerification`).
- [x] **Phase 2 — 12 Spoken Discovery & 8 Intensive Objection Drills**:
  - 8 Objection Drills with synthetic customer objections, required consultative keywords, and Egyptian Arabic coaching cards (`obj-01` through `obj-08`).
  - 12 Discovery Drills practicing open-ended inquiry (Who, What, How) across device load, commute tethering, gaming latency, and multi-line billing (`disc-01` through `disc-12`).
- [x] **Phase 3 — Fictional Product-Fit Catalog & Explainable Matching Engine**:
  - `ProductFitEngine` implementing the explainable "Needs -> Fit -> Value" framework.
  - Physical facility guardrails: Fiber address check qualification guardrail (`ProductFitStatus.needsVerification`), Landline rate-center portability check guardrail.
  - Ethical budget contradiction detection preventing upselling premium tiers against stated budget limitations.
  - On-device `CustomOffersLocalDataSource` enabling agents to author, practice, and delete local custom scenario offers with 0 remote dependencies.
- [x] **Phase 4 — Ethical Sales Evaluator & Practice Scorecard**:
  - 7 Consultative dimensions: Opening Discipline & Identity, Needs Discovery Quality, Active Listening & AERD, Value Relevance, Permission & Customer Autonomy, Factual Safety & Policy Guardrails, Objection Handling & Respectful Close.
  - Strict prohibited promises penalty (-30 points) for rate locks, guaranteed fee waivers, or supervisor callback promises.
  - Ethical "No-Sale Success" rating awarding exemplary score when honoring customer decline or lack of fit.
- [x] **Phase 5 — 90-Day Adaptive Curriculum Engine**:
  - 90-Day structured syllabus across 3 phases (Days 1–30 Foundations, Days 31–60 Sales Confidence, Days 61–90 Advanced Closing) with 13 weekly milestones.
  - Daily workout plan generation tailored to 10, 20, or 30-minute target sessions.
  - Calendar-boundary recovery mode for skipped days without streak destruction.
- [x] **Phase 6 — Polished Flutter Sales UX**:
  - `SalesLabScreen` with 4 tabs, search bar, and category/difficulty filtering chips.
  - `SalesSimulatorScreen` with customer profile ribbon, phase indicator, push-to-talk mic button, live transcript, and scorecard modal.
  - `ProductFitScreen` with qualification switches, budget slider, and custom offer CRUD.
  - `ObjectionDrillScreen` and `DiscoveryDrillScreen` with synthetic customer speech and audio recording.
  - `CurriculumTimelineView` integrated directly into `HomeScreen` (Today).
  - `MainScaffold` updated with 6 destinations (Today, Arena, Disclosures, Floor Skills, Sales Lab, Progress).
- [x] **Phase 7 — Automated Verification**:
  - 133 automated tests passing cleanly across unit, widget, and integration test suites.
  - Debug APK built in 32.9 seconds with 0 build errors.
  - Zero static analysis issues and 100% formatted Dart codebase.

---

## 📊 Module Implementation Matrix (M0–M6 Technical Roadmap)

| Module | Curriculum Focus | Technical Milestone | Status | Notes |
| :--- | :--- | :--- | :--- | :--- |
| **1. Real Voice Call Simulator** | Spoken roleplay | M1 & M3 | `IMPLEMENTED` | Multi-turn branching simulation cockpit with 30 care scenarios. |
| **2. Disclosure Reading & Pronunciation** | Legal disclosures & phonetics | M2 | `IMPLEMENTED` | Karaoke tracking, critical terms checking, customer consent, P/B drills. |
| **3. American English Listening & Speaking** | Dialects & fast speech | M3 | `IMPLEMENTED` | Fast numbers & IMEI active listening dictation drills. |
| **4. AERD and Call Control** | Steering & de-escalation | M3 | `IMPLEMENTED` | AERD scoring engine with Egyptian Arabic coaching cards. |
| **5. AT&T Product Knowledge** | Plan & device training | M4 | `IMPLEMENTED` | 48 Consultative scenarios, Product-Fit engine, and local custom offers. |
| **6. Sales Discovery and Conversion** | Consultative sales | M4 | `IMPLEMENTED` | 12 Discovery drills, 8 objection drills, ethical sales scorecard. |
| **7. Billing and Technical Troubleshooting** | Bill breakdown & tech reset | M3 | `IMPLEMENTED` | Proration, billing cycles, red light gateway, and move orders. |
| **8. Escalation and Angry Customers** | High stress calls | M3 | `IMPLEMENTED` | Supervisor demand, transfer frustration, and line suspension care. |
| **9. KPI and Quality Tracking** | Handling pace & scorecard | M5 | `IMPLEMENTED` | 7-Dimension consultative scorecard, streak logic, mastery tracking. |
| **10. Adaptive 90-Day Learning System** | Long-term progression | M5 | `IMPLEMENTED` | 90-Day syllabus, 10/20/30m workouts, skipped-day recovery mode. |
