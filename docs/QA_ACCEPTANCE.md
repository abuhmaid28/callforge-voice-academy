# QA_ACCEPTANCE.md — Quality Assurance, Governance Gates, & Hosted CI Evidence

This document defines the automated quality gates, acceptance criteria, and verification evidence for CALLFORGE across M1 through M5 and C3-MEGA.

---

## 📜 Product Owner Testing Governance Policy

> [!IMPORTANT]
> **Binding Product Owner Decision (2026-11-21)**:  
> The Product Owner **strictly forbids using personal Android hardware** for CALLFORGE development, testing, or sideloading.  
> - No local USB cable attachments, Windows ADB device scans, or prompts for personal hardware debugging.
> - Testing is conducted entirely through **GitHub-hosted Linux CI** (Ubuntu runners), headless compilation, automated test suites, and hosted Android Emulators (`reactivecircus/android-emulator-runner@v2`).
> - The absence of a personal physical phone is **never** a blocking defect for development progression.
> - Acceptance status is designated as **`AUTOMATED / HOSTED EMULATOR VERIFIED`**. Real-world acoustic microphone formant accuracy, physical speaker output fidelity, and physical device offline language packs remain documented as **`NOT TESTED / UNVERIFIED (Awaiting Real Device or Simulated Hardware Environment)`**.

---

## 🏆 C3-MEGA Automated Verification Evidence

- **Repository**: `abuhmaid28/callforge-voice-academy`
- **Active Branch**: `feat/c3-mega-voice-journeys-integrity`
- **Active PR**: [#12](https://github.com/abuhmaid28/callforge-voice-academy/pull/12)
- **Target Issue**: [#11](https://github.com/abuhmaid28/callforge-voice-academy/issues/11) (C3-MEGA Voice Journeys & Integrity)
- **Base Commit**: `38496aec5292ec31fbe04cff7f4b80682e505a0d` (Approved C2-R1 Squash Merge on `main`)
- **Total Automated Tests**: **157 / 157 PASSING** (0 failures, 0 skips)
- **Static Analysis**: **0 issues found** (`flutter analyze`)
- **Code Formatting**: **100% compliant** (`dart format --output=none --set-exit-if-changed .`)
- **Debug APK Build**: **Built successfully in 32.9s** (`build/app/outputs/flutter-apk/app-debug.apk`)

### Test Suite Execution Summary (157 Tests)

| Test Suite File | Scope & Target Capabilities | Tests Passed | Status |
| :--- | :--- | :--- | :--- |
| `test/core/c3_mega_acceptance_test.dart` | C3 Acceptance: Day 30 to 31 Care-to-Sales phase transition, Day 90 completion and program graduation, 6-category representative adaptive branching reachability, cold-restart persistence of attempts & progress | 4 | `PASS` |
| `test/presentation/workout_session_controller_test.dart` | WorkoutSessionController: queue initialization, step status progression, auto-advance, step skipping, session completion, score accumulation | 6 | `PASS` |
| `test/presentation/workout_session_screen_test.dart` | WorkoutSessionScreen: interactive workstation, queue navigation, drill/scenario launch decks, evidence-based scorecard/coaching review | 2 | `PASS` |
| `test/presentation/sales_ethical_gates_and_branching_test.dart` | Sales Simulator: Path A (`qualifiedAccept`), Path B (`respectfulNoSale`), Path C (`needsVerification`), mandatory disclosure omission downgrade | 4 | `PASS` |
| `test/presentation/multi_turn_controller_test.dart` | MultiTurnController: Care Day 1 curriculum completion pass/fail gate, turn retry score replacement, delayed-final STT capture, adaptive branching | 10 | `PASS` |
| `test/data/c2_r1_reproduction_test.dart` | C2-R1 Verification: 100% (90/90) curriculum day scenario & drill resolution, Turn 1 greeting gate rejection of substring false-positives ("matter"), synchronized FIFO progress persistence | 3 | `PASS` |
| `test/data/sales_scenario_catalog_test.dart` | 48 sales scenario integrity, uniqueness, 3 reachable terminal outcomes per scenario, Policy Guard zero prohibited promises, 8 objection drills, 12 discovery drills | 10 | `PASS` |
| `test/data/curriculum_engine_test.dart` | 90-day syllabus integrity, 100% scenario & drill existence, 3 phases, 13 weekly milestones, multi-step workout queue generation (10m 2-step, 20m 3-step, 30m 4-step), skipped-day recovery mode, progress summary math | 9 | `PASS` |
| `test/core/evaluation/sales_evaluator_test.dart` | 8-Dimension consultative scorecard (including mandatory disclosures), opening discipline, punctuation-agnostic discovery questioning, AERD active listening, prohibited promise penalties (-30 cap), respectful No-Sale Success rating | 7 | `PASS` |
| `test/core/evaluation/product_fit_engine_test.dart` | Explainable Needs->Fit->Value matching, Fiber address qualification guardrail, Landline portability guardrail, budget contradiction detection, 10 standard products metadata | 5 | `PASS` |
| `test/presentation/sales_screens_widget_test.dart` | SalesLabScreen 4 tabs and filtering, SalesSimulatorScreen caller profile & phase banner, ProductFitScreen switches and cards, ObjectionDrillScreen audio simulation, DiscoveryDrillScreen open-ended inquiry | 5 | `PASS` |
| `test/data/scenario_catalog_test.dart` | 30 care scenario uniqueness, 6-turn adaptive branches (4A/5A vs 4B/5B), graph reachability, end-to-end evaluation, Policy Guard B4 | 8 | `PASS` |
| `test/core/evaluation/disclosure_evaluator_test.dart` | DP sequence alignment, verbatim evaluation, missing critical terms, P/B detection, negation alteration invalidation, CPNI disclosure | 7 | `PASS` |
| `test/core/evaluation/multi_turn_evaluator_test.dart` | Word-boundary regex anchor matching, AT&T variants, AERD scoring, branch resolution (success vs low_aerd), P/B alerts | 3 | `PASS` |
| `test/core/evaluation/speech_evaluator_test.dart` | Text normalization, hyphen stripping, Levenshtein distance, WER, P/B bilabial detection, token anchors, greeting evaluation | 13 | `PASS` |
| `test/data/attempt_repository_test.dart` | Local attempt storage, retrieval ordering, data clearing | 3 | `PASS` |
| `test/data/progress_repository_test.dart` | User progress persistence, consecutive calendar-day streak calculation, moving average skill mastery, data reset | 10 | `PASS` |
| `test/presentation/simulator_controller_test.dart` | M1 Simulator lifecycle, audio state machine, error handling, retry | 10 | `PASS` |
| `test/presentation/disclosure_controller_test.dart` | Disclosure Studio controller, locked consent simulation, versioned attempt snapshot saving, custom draft CRUD, reference audio, delayed-final STT capture | 11 | `PASS` |
| `test/presentation/floor_skills_controller_test.dart` | Spoken P/B contrast drill evaluation, fast number audio playback, digit precision verification, delayed-final STT capture, awaited progress recording | 7 | `PASS` |
| `test/presentation/screens_widget_test.dart` | MainScaffold 6-tab navigation, VoiceArenaScreen, MultiTurnSimulatorScreen, DisclosureStudioScreen, FloorSkillsScreen, HistoryScreen, active-listening teardown | 7 | `PASS` |
| `test/widget_test.dart` | SimulatorScreen M1 greeting rendering and voice drill loop | 2 | `PASS` |
| `test/integration/app_smoke_test.dart` | Headless app smoke integration lifecycle tests (ST-01..11, C1-01..05, C2-01..03, C3-01 Workout Session workstation integration) | 13 | `PASS` |

---

## 📱 Canonical Integration & Smoke-Test Matrix (ST-01..11, C1-01..05, C2-01..03, C3-01)

| Test ID | Test Scenario | Verification Mechanism & Test File | Expected Outcome | Status |
| :--- | :--- | :--- | :--- | :--- |
| **ST-01** | **Cold Launch & Startup Stability** | Headless smoke & Emulator<br>`test/integration/app_smoke_test.dart` | App launches cleanly, renders "CALLFORGE ACADEMY" and "CALLFORGE SIMULATOR" without crash. | `PASS` |
| **ST-02** | **Microphone Permission Handling** | Deterministic simulation<br>`test/presentation/simulator_controller_test.dart` | Permission denial catches gracefully, shows guidance banner, mic resets to idle. | `PASS` |
| **ST-03** | **Missing Anchor Rejection & Coaching** | Deterministic simulation<br>`test/integration/app_smoke_test.dart` | Omitting "Alex" or "AT&T" triggers `DRILL TARGET UNMET`, displays missing anchor guidance. | `PASS` |
| **ST-04** | **English-US Speech Recognition** | Deterministic voice double (`MockSpeechService`) | Simulated standard greeting transcribes into live transcript display in real-time. | `PASS (DETERMINISTIC)` |
| **ST-05** | **Recognized-Text Coaching & Progression** | Headless smoke & Evaluator<br>`test/integration/app_smoke_test.dart` | Evaluates verbatim greeting, renders `VERBATIM TRANSCRIPT MATCH (100% Text Match)`. | `PASS` |
| **ST-06** | **Customer TTS Response Playback** | Deterministic TTS simulation | Transitions to `customerSpeaking`, displays customer response, completes cleanly to idle. | `PASS (DETERMINISTIC)` |
| **ST-07** | **User-Initiated Stop/Cancel** | Unit & Controller lifecycle test<br>`test/presentation/simulator_controller_test.dart` | Canceling listening increments session generation, discards pending callbacks, returns cleanly to idle. | `PASS` |
| **ST-08** | **Silence & Recognizer Timeout** | Unit & Controller lifecycle test<br>`test/presentation/simulator_controller_test.dart` | Watchdog detects silence, displays informative banner ("No speech was captured..."), resets state to idle. | `PASS` |
| **ST-09** | **Offline Behavior & Guidance** | Unit & Controller lifecycle test<br>`test/presentation/simulator_controller_test.dart` | Offline recognizer failure catches cleanly, displays explicit guidance banner regarding offline language pack prerequisites. | `PASS` |
| **ST-10** | **Retry & Interruption Recovery** | Headless smoke test<br>`test/integration/app_smoke_test.dart` | Tapping "Try Again" halts active audio, clears live transcript, resets evaluation card, mic restores to tap-to-speak. | `PASS` |
| **ST-11** | **Local Persistence Across Navigation** | Headless smoke test<br>`test/integration/app_smoke_test.dart` | Practice attempts and progress persist in `SharedPreferences` with timestamps, score %, and Arabic notes. | `PASS` |
| **C1-01** | **MainScaffold 6-Tab Navigation** | Headless smoke & Emulator<br>`integration_test/app_test.dart` | Renders Home, Voice Arena, Disclosure Studio, Floor Skills, Sales Lab, and Progress tabs cleanly with bottom navigation bar. | `PASS` |
| **C1-02** | **Multi-Turn Adaptive Branching Journey** | Headless smoke & Emulator<br>`integration_test/app_test.dart` | Launches Voice Arena scenario, captures Turn 1 greeting, triggers Turn 2 customer TTS, routes Turn 3 high-AERD response along Turn 4A success path. | `PASS` |
| **C1-03** | **Disclosure Studio Consent & Draft CRUD** | Headless smoke & Emulator<br>`integration_test/app_test.dart` | Tests reference audio playback, unlocks consent buttons only after 100% target met, simulates Agreed outcome, adds custom draft via bottom sheet, persists draft chip. | `PASS` |
| **C1-04** | **Floor Skills P/B Drills & Fast Numbers** | Headless smoke & Emulator<br>`integration_test/app_test.dart` | Evaluates spoken P/B contrast pair against target/contrast words, verifies 100% digit accuracy on fast number dictation drill. | `PASS` |
| **C1-05** | **Negative & Recovery Journey** | Headless smoke & Emulator<br>`integration_test/app_test.dart` | Verifies Turn 1 greeting failure remains on Turn 1 without playing customer Turn 2; valid greeting recovers; verifies consent outcome simulation is locked prior to practice; verifies rapid tab transitions safely cancel audio. | `PASS` |
| **C2-01** | **Sales Lab Scenario Launch & Greeting Gate** | Headless smoke & Emulator<br>`integration_test/app_test.dart` | Launches consultative sales scenario from Sales Lab, verifies caller profile ribbon and phase indicator, enforces Turn 1 greeting gate before advancing to customer Turn 2. | `PASS` |
| **C2-02** | **Product-Fit Tool Guardrails & Qualification** | Headless smoke & Emulator<br>`integration_test/app_test.dart` | Verifies explainable product recommendations, enforces Fiber address qualification guardrail (unverified -> `REQUIRES VERIFICATION`), toggles qualification switch. | `PASS` |
| **C2-03** | **90-Day Adaptive Academy & Duration Selection** | Headless smoke & Emulator<br>`integration_test/app_test.dart` | Verifies 90-day syllabus header, phase progression bar, Day 1 workout details, and duration pill selection (10/20/30 min). | `PASS` |
| **C3-01** | **Today Screen Launches Full WorkoutSessionScreen** | Headless smoke & Emulator<br>`integration_test/app_test.dart` | Launches `WorkoutSessionScreen` from Today workout bottom sheet, verifies queue navigation, interactive step deck, auto-advancing, and evidence-based scorecard/coaching review. | `PASS` |

---

## 🔍 Independent Audit Findings Verification (Post-C2-R1 Audit Resolution)

| Finding | Audit Finding Description | C3-MEGA Implementation & Verification | Status |
| :--- | :--- | :--- | :--- |
| **1. Care Days 1–30 Completion** | Days 1–30 did not propagate `curriculumDay` to `MultiTurnSimulatorScreen`; `MultiTurnController` never recorded curriculum day completion. | Added `curriculumDay` parameter to `MultiTurnSimulatorScreen` and `MultiTurnController`. When `avgScore >= 70.0`, `recordCurriculumDayCompletion` is awaited and advances day without streak inflation. Verified in `multi_turn_controller_test.dart` and `c3_mega_acceptance_test.dart`. | `RESOLVED & VERIFIED` |
| **2. Active Workout Session Engine** | Workout queue was a passive bottom sheet closing after 1 tap with no state tracking or scored review. | Built `WorkoutSessionState`, `WorkoutStepResult`, `WorkoutSessionController`, and `WorkoutSessionScreen` interactive workstation tracking pending/in_progress/completed/skipped steps, auto-advancing across drills/scenarios, and rendering evidence-based scorecard review. Verified in `workout_session_controller_test.dart`, `workout_session_screen_test.dart`, and `app_smoke_test.dart` (C3-01). | `RESOLVED & VERIFIED` |
| **3. Prohibited Promises in Fictional Content** | Scenarios (`sales-01` Turns 5A & 7A, `retention_scenarios` Turn 5) and objection drills (`obj-03`) contained hard pricing/fee-waiver/rate-lock promises. | Audited and refactored all scenario dialogues and drills to conditional framing (`[Fictional / Simulation Only]`) strictly barring fixed rate guarantees and supervisor callbacks. Verified in `sales_scenario_catalog_test.dart`. | `RESOLVED & VERIFIED` |
| **4. Ethical Sales Qualification Gates** | `SalesSimulatorController` did not check `SalesScenario.mandatoryDisclosures`, eligibility, or customer consent before awarding `qualifiedAccept`. | Implemented `_hasMandatoryDisclosuresCovered` and customer consent verification in `SalesSimulatorController`. Sales missing disclosures or consent are strictly downgraded to `needsVerification`. Verified in `sales_ethical_gates_and_branching_test.dart`. | `RESOLVED & VERIFIED` |
| **5. Branch Key Mismatches in Sales Scenarios** | Catalogs included `high_value`, `budget_decline`, `qualified`, `needs_check`, `accept`, `decline`, `verify` which fell back to `branches.first`. | Enhanced `_evaluateCustomerBranch` in `SalesSimulatorController` to recognize all condition keys accurately. Created unit tests proving all 3 terminal outcomes are reachable via distinct user speech evidence. Verified in `c3_mega_acceptance_test.dart`. | `RESOLVED & VERIFIED` |
| **6. Awaited, Idempotent Persistence** | Unawaited background futures in `_completeCall` caused potential race conditions upon app teardown or cold restart. | Made `_completeCall` in `SalesSimulatorController`, `MultiTurnController`, and `FloorSkillsController` fully awaited and idempotent. Proved state persistence across cold restarts in `c3_mega_acceptance_test.dart`. | `RESOLVED & VERIFIED` |
| **7. Real Integration & Cold Restart Coverage** | CI integration tests only checked Today screen rendering without testing full daily workout navigation or data persistence after restart. | Added `C3-01` integration test to `app_smoke_test.dart` and `integration_test/app_test.dart`, and added cold-restart persistence test in `c3_mega_acceptance_test.dart`. | `RESOLVED & VERIFIED` |

---

## 🔒 Provenance & Technical Boundaries

1. **Automated & Hosted Emulator Verification (`VERIFIED`)**:
   - Code formatting, static analysis, 157 unit/widget/integration tests, and debug APK compilation are fully automated, reproducible, and passing locally and in CI.
2. **Deterministic Speech Simulation (`SIMULATED IN CI`)**:
   - Automated tests and hosted emulator runs utilize deterministic doubles (`MockSpeechService`) for speech-to-text recognition and text-to-speech output.
3. **Untested Real Hardware Audio Behaviors (`NOT TESTED / UNVERIFIED`)**:
   - Physical microphone hardware acoustics, room ambient noise suppression, real physical speaker audio fidelity, and vendor-specific Android offline speech recognition packs remain `NOT TESTED / UNVERIFIED (Awaiting Real Device or Simulated Hardware Environment)`.
   - The application does not claim native acoustic pronunciation scoring or employer QA certification.
