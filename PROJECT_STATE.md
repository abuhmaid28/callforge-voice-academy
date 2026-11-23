# PROJECT_STATE.md — CALLFORGE Current Project Status

## Current execution checkpoint (2026-11-23)
- **Repository**: `https://github.com/abuhmaid28/callforge-voice-academy`
- **Current milestone**: **BETA-1** — Practical Voice Academy UX, Hosted Emulator Evidence & Android APK Handoff
- **Implementation issue**: https://github.com/abuhmaid28/callforge-voice-academy/issues/17
- **Current feature branch**: `feat/beta-1-practical-voice-academy`
- **Base merge commit**: `30439baa83a3743c9ce6fd8b19dc3e2f12104798` (approved RC1 squash merge)
- **BETA-1 implementation status**: **IN PROGRESS / READY FOR PR**.
  - B1: Mobile UI/UX & Responsive Navigation: Re-engineered `MainScaffold` and `AppTheme.darkTheme` for 360dp mobile screens and large text (1.4x scale). Configured `navigationBarTheme` with compact height (66dp), rounded indicator pills, explicit destination keys (`nav_today`, `nav_arena`, etc.), and `NavigationRail` for wide/tablet displays (>= 640dp).
  - B2: Layout Overflow & Visual Hardening: Fixed `RenderFlex overflowed` vulnerabilities across `HomeScreen`, `CurriculumTimelineView`, `VoiceArenaScreen`, `SalesLabScreen`, `FloorSkillsScreen`, and `WaveformIndicator`. Wrapped chips, titles, duration pills, and milestone cards in `Flexible`/`Expanded`/`FittedBox`/`Wrap`.
  - B3: Actionable Voice Error Recovery: Implemented `clearError()` across `MultiTurnController`, `SalesSimulatorController`, `DisclosureController`, and `FloorSkillsController`. Upgraded error banners with direct links to system settings (`openAppSettings()` for microphone permission) and dismiss icon buttons.
  - B4: Practice History & Cross-Navigation: Upgraded `HistoryScreen` to support viewing all academy attempts when `scenarioId == null`. Added direct navigation from `ProgressScreen` AppBar (`btn_view_history`) and quick-access card. Added honest educational disclaimers.
  - B5: Versioned Android Beta-1 Artifact: Updated application version to `1.0.0-beta.1+2` in `pubspec.yaml` and set Android label to `CALLFORGE`. Compiled debug APK (`157,022,433 bytes`, SHA-256: `AD8BA1B33654C14AEAF49DC850B9EC90560EBFB84BC851EF73A7F3AFC642FBB0`). Added `docs/BETA_TESTING.md` with 10–15 minute Egyptian Arabic testing checklist and offline guidance.
  - B6: CI & Emulator Screenshot Pipeline: Updated `.github/workflows/ci.yml` to capture hosted Android API 34 emulator screenshots (`screenshots/emulator_beta1_pixel6_api34.png`) and upload `callforge-beta1-debug-apk` and `callforge-emulator-screenshots` artifacts.
  - B7: Quality & Test Suite: 181 automated tests passing across 21 test files (0 failures, 0 skips), 0 static analysis issues (`flutter analyze`), 100% formatted Dart code.
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
| **Automated Tests** | `VERIFIED` | 181 tests passing (unit, widget, integration) with 0 static analysis issues |

---

## 🎯 Delivered Milestone: RC1 (Release Candidate Stabilization)

- [x] R1: Unique Per-Step Attempt Evidence: Added `workoutStepId` to `AttemptRecord`, controllers, and screens. Screens wrapped in `PopScope(canPop: false)` returning `_lastSavedAttempt`. `WorkoutSessionScreen` tracks `priorAttemptIds` before step start and strictly checks `!priorAttemptIds.contains(a.id) && a.workoutStepId == step.id`.
- [x] R2: Contextual Affirmative Consent & Strict Refusal Guardrails: Strict word-boundary affirmative verbs, negative refusal guardrails (`no thanks`, `leave it`, `do not upgrade`), conditional hesitation rejection (`but not`, `but wait`), and actionable agent closing proposal requirement. Excluded non-refusal idioms like "no-brainer", "no problem", "cannot wait".
- [x] R3: 48×3 Sales Scenarios Trajectory & Controller Execution: Automated simulation test suite in `all_48_scenarios_reachability_test.dart` executing all 48 scenarios through `SalesSimulatorController` across Path A (`qualifiedAccept`), Path B (`respectfulNoSale`), Path C (`needsVerification`), and mandatory disclosure omission downgrades (6/6 tests passing).
- [x] R4: Hosted Emulator Journeys (C3-03..05): Added `C3-03` (full 20-min passing workout advancing Day 1 to Day 2), `C3-04` (cold-start session resumption), and `C3-05` (Sales Simulator UI execution) in `app_smoke_test.dart` and `integration_test/app_test.dart`.
- [x] R5: CI, Analysis & Packaging: 174 automated tests passing (0 failures), 0 static analysis issues, 100% formatted, debug APK built in 41.6s. Squash merged via PR #16 into `main` at `30439baa83a3743c9ce6fd8b19dc3e2f12104798`.

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
