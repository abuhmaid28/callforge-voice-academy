# PROJECT_STATE.md — CALLFORGE Current Project Status

## Current execution checkpoint (2026-11-23)
- **Repository**: `https://github.com/abuhmaid28/callforge-voice-academy`
- **Current milestone**: **RC1** — Release Candidate Stabilization (Practice Evidence & Sales Consent)
- **Implementation issue**: https://github.com/abuhmaid28/callforge-voice-academy/issues/15
- **Current feature branch**: `fix/rc1-practice-evidence-and-consent`
- **Base merge commit**: `63efe62900d53056f8effdd6c0ab86906f3440d6` (approved C3-FINAL squash merge)
- **RC1 implementation status**: **COMPLETED**.
  - R1: Unique Per-Step Attempt Evidence: Eliminated timestamp proximity and stale attempt reuse. Added `workoutStepId` to `AttemptRecord`, controllers, and screens. Screens wrapped in `PopScope(canPop: false)` returning `_lastSavedAttempt`. `WorkoutSessionScreen` tracks `priorAttemptIds` before step start and strictly checks `!priorAttemptIds.contains(a.id) && a.workoutStepId == step.id`. `saveAttempt` properly awaited in all drills.
  - R2: Contextual Affirmative Consent & Strict Refusal Guardrails: Phrase/turn-aware regex with word boundaries, affirmative transaction verbs (`lets add`, `order the`, `book the technician`, `let us activate`), strict refusal guardrails (`no thanks`, `leave it`, `do not upgrade`, `why would i`), conditional hesitation rejection (`but not`, `but wait`), and actionable agent closing proposal requirement. Excluded non-refusal idioms like "no-brainer", "no problem", "cannot wait".
  - R3: 48×3 Sales Scenarios Trajectory & Controller Execution: Automated simulation test suite in `all_48_scenarios_reachability_test.dart` executing all 48 scenarios through `SalesSimulatorController` across Path A (`qualifiedAccept`), Path B (`respectfulNoSale`), Path C (`needsVerification`), and mandatory disclosure omission downgrades (6/6 tests passing).
  - R4: Hosted Emulator Journeys (C3-03..05): Added `C3-03` (full 20-min passing workout advancing Day 1 to Day 2), `C3-04` (cold-start session resumption), and `C3-05` (Sales Simulator UI execution) in `app_smoke_test.dart` and `integration_test/app_test.dart`.
  - R5: CI, Analysis & Packaging: 174 automated tests passing (0 failures), 0 static analysis issues (`flutter analyze`), 100% formatted (`dart format`), debug APK built in 41.6s.
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
| **Automated Tests** | `VERIFIED` | 174 tests passing (unit, widget, integration) with 0 static analysis issues |

---

## 🎯 Delivered Milestone: C3-MEGA (Voice Journeys Integrity & Resumable Workout Engine)

- [x] **Phase 1 — Care Days 1–30 Completion & Day 30->31 Transition**:
  - `MultiTurnSimulatorScreen` and `MultiTurnController` accept and propagate `curriculumDay`.
  - Turn retry score replacement in `Map<String, MultiTurnEvaluationResult> _turnEvaluations` prevents score deflation from retries.
  - Successful scenario completion (`avgScore >= 70.0`) invokes `recordCurriculumDayCompletion`.
  - Proved transition from Day 30 (Customer Care) to Day 31 (Sales Confidence) and Day 90 graduation in `c3_mega_acceptance_test.dart`.
- [x] **Phase 2 — Executable, Resumable Multi-Step Workout Session Engine**:
  - `WorkoutSessionState`, `WorkoutStepResult`, `WorkoutSessionController`.
  - Dedicated full-screen `WorkoutSessionScreen` interactive workstation.
  - Step queue navigation with visual status chips (pending, in_progress, completed, skipped).
  - Auto-advancing from drill to scenario to review.
  - Evidence-based scorecard and coaching review showing real attempt accuracy, Egyptian Arabic coaching, and missing anchor chips.
- [x] **Phase 3 — Fictional Content & Disclosure Guardrails**:
  - Refactored `wireless_scenarios.dart` (`sales-01` Turns 5A & 7A) and `retention_scenarios.dart` (Turn 5) to remove hard rate-locks and guaranteed zero-fee promises.
  - Refactored `objection_drills.dart` (`obj-03`) to eliminate claims of fixed plans without surcharges.
  - Replaced with conditional practice framing (`[Fictional / Simulation Only]`) and operational truth prohibiting supervisor callbacks.
- [x] **Phase 4 — Ethical Sales Outcome Gates (Consent, Eligibility & Mandatory Disclosures)**:
  - Added Dimension 8 (`mandatory_disclosures`) in `SalesEvaluator`.
  - Added `_hasMandatoryDisclosuresCovered` and explicit customer consent verification in `SalesSimulatorController`.
  - Strictly downgrades unearned sales to `needsVerification` when disclosures or consent are missing.
- [x] **Phase 5 — Adaptive Multi-Condition Sales Branching**:
  - Enhanced `_evaluateCustomerBranch` in `SalesSimulatorController` to recognize `budget_decline`, `high_value`, `needs_check`, `accept`, `decline`, and `verify`.
  - Proved 3 distinct reachable terminal outcomes across representative sales scenarios in `sales_ethical_gates_and_branching_test.dart` and `c3_mega_acceptance_test.dart`.
- [x] **Phase 6 — Awaited, Idempotent Persistence & Cold Restart Verification**:
  - Awaited all repository calls in `SalesSimulatorController`, `MultiTurnController`, and `FloorSkillsController`.
  - Verified attempt and progress state persistence across simulated cold app restarts.
- [x] **Phase 7 — Verification & Android Emulator Integration**:
  - 157 automated tests passing with 0 failures across 19 test files.
  - Added `C3-01` integration test to `test/integration/app_smoke_test.dart` and `integration_test/app_test.dart`.
  - Debug APK compiled in 32.9s.
  - 0 static analysis warnings, 100% formatted Dart code.

---

## 📊 Module Implementation Matrix (M0–M6 Technical Roadmap)

| Module | Curriculum Focus | Technical Milestone | Status | Notes |
| :--- | :--- | :--- | :--- | :--- |
| **1. Real Voice Call Simulator** | Spoken roleplay | M1 & M3 | `IMPLEMENTED` | Multi-turn branching simulation cockpit with 30 care scenarios + curriculum completion. |
| **2. Disclosure Reading & Pronunciation** | Legal disclosures & phonetics | M2 | `IMPLEMENTED` | Karaoke tracking, critical terms checking, customer consent, P/B drills. |
| **3. American English Listening & Speaking** | Dialects & fast speech | M3 | `IMPLEMENTED` | Fast numbers & IMEI active listening dictation drills. |
| **4. AERD and Call Control** | Steering & de-escalation | M3 | `IMPLEMENTED` | AERD scoring engine with Egyptian Arabic coaching cards. |
| **5. AT&T Product Knowledge** | Plan & device training | M4 | `IMPLEMENTED` | 48 Consultative scenarios, Product-Fit engine, and local custom offers. |
| **6. Sales Discovery and Conversion** | Consultative sales | M4 | `IMPLEMENTED` | 12 Discovery drills, 8 objection drills, ethical sales scorecard + mandatory disclosures. |
| **7. Billing and Technical Troubleshooting** | Bill breakdown & tech reset | M3 | `IMPLEMENTED` | Proration, billing cycles, red light gateway, and move orders. |
| **8. Escalation and Angry Customers** | High stress calls | M3 | `IMPLEMENTED` | Supervisor demand, transfer frustration, and line suspension care (no callbacks). |
| **9. KPI and Quality Tracking** | Handling pace & scorecard | M5 | `IMPLEMENTED` | 8-Dimension consultative scorecard, streak logic, mastery tracking. |
| **10. Adaptive 90-Day Learning System** | Long-term progression | M5 & C3 | `IMPLEMENTED` | 90-Day syllabus, 10/20/30m interactive workout sessions, skipped-day recovery mode. |
