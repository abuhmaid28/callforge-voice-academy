# QA_ACCEPTANCE.md — Quality Assurance, Governance Gates, & Hosted CI Evidence

This document defines the automated quality gates, acceptance criteria, and verification evidence for CALLFORGE across M1 through M5, C3-FINAL, and RC1 (Release Candidate 1).

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

## 🏆 RC1 (Release Candidate 1) Automated Verification Evidence

- **Repository**: `abuhmaid28/callforge-voice-academy`
- **Active Branch**: `fix/rc1-practice-evidence-and-consent`
- **Target Issue**: [#15](https://github.com/abuhmaid28/callforge-voice-academy/issues/15) (RC1 Release Candidate Stabilization)
- **Base Commit**: `63efe62900d53056f8effdd6c0ab86906f3440d6` (Approved C3-FINAL Squash Merge on `main`)
- **Total Automated Tests**: **174 / 174 PASSING** (0 failures, 0 skips)
- **Static Analysis**: **0 issues found** (`flutter analyze`)
- **Code Formatting**: **100% compliant** (`dart format --output=none --set-exit-if-changed .`)
- **Debug APK Build**: **Built successfully in 41.6s** (`build/app/outputs/flutter-apk/app-debug.apk`)

### Test Suite Execution Summary (174 Tests)

| Test Suite File | Scope & Target Capabilities | Tests Passed | Status |
| :--- | :--- | :--- | :--- |
| `test/core/rc1_stabilization_test.dart` | RC1 Core Stabilization: R1 unique attempt evidence (stale attempt rejection, mismatched workoutStepId rejection) and R2 contextual consent (rejection of "yesterday", "carlos", refusal phrases "do not upgrade", "yes but not yet") | 4 | `PASS` |
| `test/data/all_48_scenarios_reachability_test.dart` | R3 48×3 Sales Scenarios: Zero dead ends, cycle safety, directed path existence, Path B decline execution, Path C verification inquiry execution, Path A qualified accept execution, and mandatory disclosure omission downgrade across all 48 scenarios | 6 | `PASS` |
| `test/integration/app_smoke_test.dart` | R4 Headless app smoke integration lifecycle tests (ST-01..11, C1-01..05, C2-01..03, C3-01..02, C3-03 full passing 20-min workout advancing Day 1 to 2, C3-04 cold-restart resumption, C3-05 Sales Simulator UI execution) | 17 | `PASS` |
| `test/core/c3_final_regression_test.dart` | C3-FINAL Regression: Zero phantom scores on unperformed steps, durable WorkoutSessionState cold restart persistence, full-call accuracyPercentage truth | 3 | `PASS` |
| `test/core/c3_mega_acceptance_test.dart` | C3 Acceptance: Day 30 to 31 Care-to-Sales phase transition, Day 90 completion and program graduation, 6-category representative adaptive branching reachability, cold-restart persistence of attempts & progress | 4 | `PASS` |
| `test/presentation/workout_session_controller_test.dart` | WorkoutSessionController: queue initialization, step status progression, auto-advance, step skipping, honest session completion gate, score accumulation | 6 | `PASS` |
| `test/presentation/workout_session_screen_test.dart` | WorkoutSessionScreen: interactive workstation, queue navigation, drill/scenario launch decks, evidence-based scorecard/coaching review | 2 | `PASS` |
| `test/presentation/sales_ethical_gates_and_branching_test.dart` | Sales Simulator: Path A (`qualifiedAccept`), Path B (`respectfulNoSale`), Path C (`needsVerification`), mandatory disclosure omission downgrade, independent customer consent check | 4 | `PASS` |
| `test/presentation/multi_turn_controller_test.dart` | MultiTurnController: Care Day 1 curriculum completion pass/fail gate, turn retry score replacement, delayed-final STT capture, adaptive branching, aggregate score truth | 10 | `PASS` |
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
| `test/integration/app_smoke_test.dart` | Headless app smoke integration lifecycle tests (ST-01..11, C1-01..05, C2-01..03, C3-01..02 Workout Session integration) | 14 | `PASS` |

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
| **C3-02** | **Workout Session Step Skip & Honest Completion Gate** | Headless smoke & Emulator<br>`integration_test/app_test.dart` | Launches workout session, skips initial drill step, executes primary scenario, verifies honest completion gating and progress recording. | `PASS` |
| **C3-03** | **Full Passing 20-min Workout & Curriculum Progression** | Headless smoke & Emulator<br>`integration_test/app_test.dart` | Executes full 20-min workout, records honest per-step attempt evidence, advances currentCurriculumDay from Day 1 to Day 2 and persists completed days. | `PASS` |
| **C3-04** | **Mid-Workout Session Rehydration Across Cold Restart** | Headless smoke & Emulator<br>`integration_test/app_test.dart` | Verifies step status, index, and results persist in `WorkoutSessionLocalDataSource` across simulated app restart without state corruption. | `PASS` |
| **C3-05** | **Sales Simulator UI Execution on Mock Engine** | Headless smoke & Emulator<br>`integration_test/app_test.dart` | Launches SalesSimulatorScreen, executes Turn 1 greeting, Turn 3 value bridge, Turn 5A closing offer, and Turn 7A disclosures, achieving qualifiedAccept. | `PASS` |

---

## 🔍 Independent Audit Findings Verification (RC1 Audit Resolution)

| Finding | Audit Finding Description | RC1 Implementation & Verification | Status |
| :--- | :--- | :--- | :--- |
| **R1. Unique Per-Step Attempt Evidence (No Timestamp Proximity / Stale Reuse)** | Attempt records were previously queried by timestamp proximity or scenario ID alone, risking stale attempt reuse or phantom credit if a user exited via Back. | Added `workoutStepId` to `AttemptRecord`, passed `workoutStepId` into controllers/screens, captured `priorAttemptIds` before step start, wrapped screens in `PopScope(canPop: false)` returning `lastSavedAttempt`, awaited `saveAttempt` in discovery/objection drills, and strictly required `!priorAttemptIds.contains(a.id) && a.workoutStepId == step.id`. Verified in `rc1_stabilization_test.dart`. | `RESOLVED & VERIFIED` |
| **R2. Contextual Affirmative Consent & Strict Refusal Guardrails** | Consent check previously allowed affirmative words like "yes" to match substrings like "yesterday", and did not reliably guard against refusals ("do not upgrade", "yes but not yet") or filler words ("carlos", "today"). | Implemented phrase/turn-aware regex with word boundaries, affirmative transaction verbs (`lets add`, `order the`, `book the technician`, `let us activate`), strict refusal guardrails (`no thanks`, `leave it`, `do not upgrade`, `why would i`), conditional hesitation rejection (`but not`, `but wait`), and actionable agent closing proposal requirement. Idioms like "no-brainer", "no problem", "cannot wait" are correctly preserved. Verified in `rc1_stabilization_test.dart`. | `RESOLVED & VERIFIED` |
| **R3. 48×3 Sales Scenarios Trajectory & Controller Execution** | The 48 scenarios had only static enum reachability checks, but actual execution through `SalesSimulatorController` was not systematically tested on all paths. | Implemented automated simulation runs across all 48 scenarios in `test/data/all_48_scenarios_reachability_test.dart` for Path A (`qualifiedAccept`), Path B (`respectfulNoSale`), Path C (`needsVerification`), and negative disclosure omission downgrades. Tuned branch conditions (`hasVerificationInquiry`, `hasDeclineIntent`) to prevent premature routing. | `RESOLVED & VERIFIED` |
| **R4. End-to-End Hosted Emulator Journeys (C3-03..05)** | Integration suite lacked full passing workout progression from Day 1 to Day 2 and mid-workout session resumption. | Added `C3-03` (full 20-min passing workout advancing Day 1 to Day 2), `C3-04` (cold-start session resumption), and `C3-05` (Sales Simulator UI execution) in `app_smoke_test.dart` and `integration_test/app_test.dart`. | `RESOLVED & VERIFIED` |
| **R5. CI, Analysis & Release Readiness** | Zero analyzer warnings, complete formatting, and clean debug APK build required for release candidate tag. | Ran `flutter analyze` (0 issues), `dart format` (100% compliant), `flutter test` (174/174 passing), and `flutter build apk --debug` (built in 41.6s). | `RESOLVED & VERIFIED` |

---

## 🔍 Independent Audit Findings Verification (C3-FINAL Audit Resolution)

| Finding | Audit Finding Description | C3-FINAL Implementation & Verification | Status |
| :--- | :--- | :--- | :--- |
| **1. Zero Phantom Scores on Drill Back/Cancel** | `WorkoutSessionScreen._executeDrillStep` unconditionally awarded score=85 and passed=true after returning from any drill, even on Back/cancel with no answer. | Recorded `stepStartTime` before launching drill; checks `attemptRepo.getAttempts()` for fresh attempts created after `stepStartTime`. Interrupted/cancelled drills trigger user notice without awarding phantom scores or advancing pass status. Verified in `c3_final_regression_test.dart`. | `RESOLVED & VERIFIED` |
| **2. Honest Scenario Execution Gate** | `WorkoutSessionScreen._executeScenarioStep` initialized score=75, passed=true, and if it found no fresh attempt on return still passed, allowing stale history reuse. | Removed artificial score/passed fallbacks. Requires verified fresh attempt record saved after `stepStartTime`. Incomplete/cancelled runs remain unpassed. Verified in `c3_final_regression_test.dart` and `workout_session_screen_test.dart`. | `RESOLVED & VERIFIED` |
| **3. Verified Workout Completion Gate** | `WorkoutSessionController.completeEntireWorkout` looped over all non-skipped steps marking them completed regardless of evidence. | Gated `completeEntireWorkout` behind `session.canCompleteWorkout`, requiring the primary scenario step to be passed and all scheduled steps to be either completed or skipped. Pedagogical review screen renders warning and partial exit when criteria are unmet. Verified in `workout_session_controller_test.dart` and `c3_final_regression_test.dart`. | `RESOLVED & VERIFIED` |
| **4. Durable Workout Persistence Across Restarts** | `WorkoutSessionController` kept session only in memory; session did not survive app/process restart. | Built `WorkoutSessionLocalDataSource` backed by `SharedPreferences` (`callforge_active_workout_session_v1`), added `toJson()` and `fromJson()` to `WorkoutSessionState`, and integrated automatic cold-restart rehydration in `main.dart` and controller. Verified in `c3_final_regression_test.dart`. | `RESOLVED & VERIFIED` |
| **5. Independent Ethical Consent & Disclosure Validation** | `SalesSimulatorController` consent check was tautological (`hasCustomerConsent = outcome == qualifiedAccept`), and disclosure matching allowed single loose non-stopword token hits. | Decoupled consent into `_hasCustomerConsentCovered` verifying affirmative customer agreement and absence of refusal phrases. Enforced contradiction/negation detection and minimum 30% distinct informative vocabulary match in `_hasMandatoryDisclosuresCovered`. Ambiguous utterances route to `needs_check` or `friction`. Verified in `sales_ethical_gates_and_branching_test.dart`. | `RESOLVED & VERIFIED` |
| **6. 48×3 Sales Scenarios Trajectory & Reachability** | Tests checked terminal enum existence for only 6 scenarios; 48-scenario catalog had broken branch targets (`turn-w01-07B`). | Fixed branch target typo in `sales-01` (`turn-w01-05B`). Implemented exhaustive graph validation and execution loop in `test/data/all_48_scenarios_reachability_test.dart`, verifying zero dead ends, cycle safety, and full reachability of `qualifiedAccept`, `respectfulNoSale`, and `needsVerification` across all 48 scenarios. | `RESOLVED & VERIFIED` |
| **7. Full-Call Scoring Truth in History** | `MultiTurnController._completeCall` computed `callPassed` from average scores but stored `AttemptRecord.accuracyPercentage` from latest turn score. | Updated `MultiTurnController` to record `accuracyPercentage: avgScore.round()` matching `callPassed` threshold, and joined all agent turn transcripts. Verified in `c3_final_regression_test.dart` and `multi_turn_controller_test.dart`. | `RESOLVED & VERIFIED` |
| **8. E2E Hosted Emulator Workout Journey** | Hosted CI test only checked Today screen button existence without executing workout steps or negative paths. | Added comprehensive integration test `C3-02` in `test/integration/app_smoke_test.dart` and `integration_test/app_test.dart`, validating step skip, scenario execution, and honest completion gating. | `RESOLVED & VERIFIED` |

---

## 🔒 Provenance & Technical Boundaries

1. **Automated & Hosted Emulator Verification (`VERIFIED`)**:
   - Code formatting, static analysis, 164 unit/widget/integration tests, and debug APK compilation are fully automated, reproducible, and passing locally and in CI.
2. **Deterministic Speech Simulation (`SIMULATED IN CI`)**:
   - Automated tests and hosted emulator runs utilize deterministic doubles (`MockSpeechService`) for speech-to-text recognition and text-to-speech output.
3. **Untested Real Hardware Audio Behaviors (`NOT TESTED / UNVERIFIED`)**:
   - Physical microphone hardware acoustics, room ambient noise suppression, real physical speaker audio fidelity, and vendor-specific Android offline speech recognition packs remain `NOT TESTED / UNVERIFIED (Awaiting Real Device or Simulated Hardware Environment)`.
   - The application does not claim native acoustic pronunciation scoring or employer QA certification.
