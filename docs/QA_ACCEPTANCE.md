# QA_ACCEPTANCE.md — Quality Assurance, Governance Gates, & Hosted CI Evidence

This document defines the automated quality gates, acceptance criteria, and verification evidence for CALLFORGE across M1, M2, and M3 (C1-MEGA).

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

## 🏆 C1-R1 MEGA Automated Verification Evidence

- **Repository**: `abuhmaid28/callforge-voice-academy`
- **Active Branch**: `feat/c1-mega-disclosure-floor-skills`
- **Active PR**: [#5](https://github.com/abuhmaid28/callforge-voice-academy/pull/5)
- **Target Issue**: [#6](https://github.com/abuhmaid28/callforge-voice-academy/issues/6) (C1-R1 MEGA Autonomous Recovery Campaign)
- **Base Commit**: `40f2c0438c415b53b961d353a7c67b62494266a0` (Approved M1 Squash Merge on `main`)
- **Total Automated Tests**: **96 / 96 PASSING**
- **Static Analysis**: **0 issues found** (`flutter analyze`)
- **Code Formatting**: **100% compliant** (`dart format --set-exit-if-changed .`)

### Test Suite Execution Summary (96 Tests)

| Test Suite File | Scope & Target Capabilities | Tests Passed | Status |
| :--- | :--- | :--- | :--- |
| `test/data/scenario_catalog_test.dart` | 30 scenario uniqueness, non-empty Arabic guidance, 6-turn adaptive branches (4A/5A vs 4B/5B), graph reachability, end-to-end evaluation, and Policy Guard B4 (zero unauthorized fee waivers/rate locks/guarantees) | 8 | `PASS` |
| `test/core/evaluation/disclosure_evaluator_test.dart` | DP sequence alignment, verbatim evaluation, missing critical terms, P/B detection, negation alteration invalidation, CPNI disclosure | 7 | `PASS` |
| `test/core/evaluation/multi_turn_evaluator_test.dart` | Word-boundary regex anchor matching, AT&T variants, AERD scoring, branch resolution (success vs low_aerd), P/B alerts | 3 | `PASS` |
| `test/core/evaluation/speech_evaluator_test.dart` | Text normalization, hyphen stripping, Levenshtein distance, WER, P/B bilabial detection, token anchors, greeting evaluation | 13 | `PASS` |
| `test/data/attempt_repository_test.dart` | Local attempt storage, retrieval ordering, data clearing | 3 | `PASS` |
| `test/data/progress_repository_test.dart` | User progress persistence, consecutive calendar-day streak calculation (same-day, next-day, multi-day gap reset, month/year boundaries), moving average skill mastery, data reset | 10 | `PASS` |
| `test/presentation/simulator_controller_test.dart` | M1 Simulator lifecycle, audio state machine, error handling, retry | 10 | `PASS` |
| `test/presentation/disclosure_controller_test.dart` | Disclosure Studio controller, script selection, listening, locked consent simulation (Finding B3), versioned attempt snapshot saving (Finding B5), custom draft CRUD, reference audio, delayed-final STT transcript capture without loss, failed attempt persistence with scriptVersion, cancel listening reset | 11 | `PASS` |
| `test/presentation/multi_turn_controller_test.dart` | Multi-turn scenario orchestration, Turn 1 mandatory opening gate (Finding B1), final turn completion safety (Finding B2), versioned attempt recording (Finding B5), customer TTS turn, adaptive branching, delayed-final STT transcript capture without loss, resetAudioSession cancellation | 8 | `PASS` |
| `test/presentation/floor_skills_controller_test.dart` | Spoken P/B contrast drill evaluation against target vs contrast word, fast number audio playback, digit precision verification, delayed-final STT transcript capture without loss, resetAudioSession | 7 | `PASS` |
| `test/presentation/screens_widget_test.dart` | MainScaffold 5-tab navigation, VoiceArenaScreen, MultiTurnSimulatorScreen, DisclosureStudioScreen, FloorSkillsScreen, HistoryScreen WPM absence and versioned attempt badges, MainScaffold tab switching active-listening teardown | 7 | `PASS` |
| `test/widget_test.dart` | SimulatorScreen M1 greeting rendering and voice drill loop | 2 | `PASS` |
| `test/integration/app_smoke_test.dart` | Headless app smoke integration lifecycle tests (ST-01..06, ST-10, ST-02, ST-11), C1 full product journeys (C1-01..04), and C1-05 Negative & Recovery Journey with active-listening tab teardown | 8 | `PASS` |

---

## 📱 Canonical Integration & Smoke-Test Matrix (ST-01 – ST-11 & C1-01 – C1-05)

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
| **C1-01** | **MainScaffold 5-Tab Navigation** | Headless smoke & Emulator<br>`integration_test/app_test.dart` | Renders Home, Voice Arena, Disclosure Studio, Floor Skills, and Progress tabs cleanly with bottom navigation bar. | `PASS` |
| **C1-02** | **Multi-Turn Adaptive Branching Journey** | Headless smoke & Emulator<br>`integration_test/app_test.dart` | Launches Voice Arena scenario, captures Turn 1 greeting, triggers Turn 2 customer TTS, routes Turn 3 high-AERD response along Turn 4A success path. | `PASS` |
| **C1-03** | **Disclosure Studio Consent & Draft CRUD** | Headless smoke & Emulator<br>`integration_test/app_test.dart` | Tests reference audio playback, unlocks consent buttons only after 100% target met, simulates Agreed outcome, adds custom draft via bottom sheet, persists draft chip. | `PASS` |
| **C1-04** | **Floor Skills P/B Drills & Fast Numbers** | Headless smoke & Emulator<br>`integration_test/app_test.dart` | Evaluates spoken P/B contrast pair against target/contrast words, verifies 100% digit accuracy on fast number dictation drill. | `PASS` |
| **C1-05** | **Negative & Recovery Journey** | Headless smoke & Emulator<br>`integration_test/app_test.dart` | Verifies Turn 1 greeting failure (missing Alex/AT&T) remains on Turn 1 without playing customer Turn 2; valid greeting recovers; verifies consent outcome simulation is locked prior to practice; verifies rapid tab transitions safely cancel audio. | `PASS` |
| **ST-09** | **Offline Behavior & Guidance** | Unit & Controller lifecycle test<br>`test/presentation/simulator_controller_test.dart` | Offline recognizer failure catches cleanly, displays explicit guidance banner regarding offline language pack prerequisites. | `PASS` |
| **ST-10** | **Retry & Interruption Recovery** | Headless smoke test<br>`test/integration/app_smoke_test.dart` | Tapping "Try Again" halts active audio, clears live transcript, resets evaluation card, mic restores to tap-to-speak. | `PASS` |
| **ST-11** | **Local Persistence Across Navigation** | Headless smoke test<br>`test/integration/app_smoke_test.dart` | Practice attempts and progress persist in `SharedPreferences` with timestamps, score %, and Arabic notes. | `PASS` |

---

## 🔍 Provenance & Technical Boundaries

1. **Automated & Hosted Emulator Verification (`VERIFIED`)**:
   - Code formatting, static analysis, 67 unit/widget/integration tests, and debug APK compilation are fully automated, reproducible, and passing locally and in CI.
2. **Untested Real Hardware Audio Behaviors (`NOT TESTED / UNVERIFIED`)**:
   - Physical microphone hardware acoustics, room ambient noise suppression, real physical speaker audio fidelity, and vendor-specific Android offline speech recognition packs remain `NOT TESTED / UNVERIFIED (Awaiting Real Device or Simulated Hardware Environment)`.
   - The application does not claim native acoustic pronunciation scoring or employer QA certification.
