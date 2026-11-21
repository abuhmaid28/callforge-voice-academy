# QA_ACCEPTANCE.md — Quality Assurance, Governance Gates, & Hosted CI Evidence

This document defines the automated quality gates, acceptance criteria, and hosted verification evidence for CALLFORGE.

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

## 🏆 Verified GitHub Actions CI Evidence

- **Repository**: `abuhmaid28/callforge-voice-academy`
- **Branch**: `feat/m1-voice-prototype`
- **Commit**: `f2e1513e7ddee5196c34722b33b52503d37f798b`
- **CI Run URL**: https://github.com/abuhmaid28/callforge-voice-academy/actions/runs/44938049356
- **CI Execution Verdict**: **ALL JOBS PASSED (GREEN)**

### Job 1: Flutter quality and debug APK (ID: `136948923949`)
- **Duration**: 6m 4s on `ubuntu-latest`
- **Gate 1 (Formatting)**: `dart format --set-exit-if-changed .` -> **PASS** (0 deviations)
- **Gate 2 (Static Analysis)**: `flutter analyze` -> **PASS** (0 issues found)
- **Gate 3 (Test Suite)**: `flutter test --coverage` -> **PASS** (31 / 31 unit, widget, and integration smoke tests passed)
- **Gate 4 (APK Compilation)**: `flutter build apk --debug` -> **PASS** (Generated `build/app/outputs/flutter-apk/app-debug.apk`)
- **Artifact Upload**: `callforge-debug-apk` archived with 3-day retention

### Job 2: Android API 34 hosted emulator (mocked speech) (ID: `136948924229`)
- **Duration**: 11m 17s on `ubuntu-latest` (KVM accelerated)
- **Device Profile**: Pixel 6 AVD, Android API 34 (`google_apis`, `x86_64`)
- **APK Installation**: `app-debug.apk` installed on `emulator-5554` (589ms)
- **Test Command**: `flutter test integration_test/app_test.dart -d emulator-5554 --reporter expanded`
- **Result**: **00:06 +4: All tests passed!**

---

## 📱 Canonical Integration & Smoke-Test Matrix (ST-01 – ST-11)

The matrix below maps the required M1 voice prototype scenarios to their verified automated & hosted execution:

| Test ID | Test Scenario | Verification Mechanism & Test File | Expected Outcome | Actual Hosted CI Result | Status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **ST-01** | **Cold Launch & Startup Stability** | Hosted Android Emulator (API 34)<br>`integration_test/app_test.dart` | App launches cleanly, renders "CALLFORGE SIMULATOR", "Agent: Alex (AT&T)", Turn 1 Opening without crash. | Verified on `emulator-5554` in CI run 44938049356. | `PASS (HOSTED EMULATOR)` |
| **ST-02** | **Microphone Permission Handling** | Deterministic simulation<br>`test/presentation/simulator_controller_test.dart` & `integration_test/app_test.dart` | Permission denial catches gracefully, shows guidance banner ("Microphone permission is required..."), mic resets to idle. | Verified on `emulator-5554` in CI run 44938049356. | `PASS (SIMULATED UI / EMULATOR)` |
| **ST-03** | **Missing Anchor Rejection & Coaching** | Hosted Android Emulator (API 34)<br>`integration_test/app_test.dart` | Omitting "Alex" or "AT&T" triggers `DRILL TARGET UNMET`, displays missing anchor guidance, customer Turn 2 is NOT triggered. | Verified on `emulator-5554` in CI run 44938049356. | `PASS (HOSTED EMULATOR)` |
| **ST-04** | **English-US Speech Recognition** | Deterministic voice double (`MockSpeechService`)<br>`integration_test/app_test.dart` | Simulated standard greeting transcribes into live transcript display in real-time. | Verified on `emulator-5554`. Note: Software simulation; not real acoustic microphone input. | `PASS (MOCKED / DETERMINISTIC)` |
| **ST-05** | **Recognized-Text Coaching & Progression** | Hosted Android Emulator (API 34)<br>`integration_test/app_test.dart` | Evaluates verbatim greeting, renders `VERBATIM TRANSCRIPT MATCH (100% Text Match)`, unlocks Turn 2. | Verified on `emulator-5554` in CI run 44938049356. | `PASS (HOSTED EMULATOR)` |
| **ST-06** | **Customer TTS Response Playback** | Deterministic TTS simulation<br>`integration_test/app_test.dart` | Transitions to `customerSpeaking`, displays customer response ("David Miller"), completes cleanly to idle. | Verified on `emulator-5554`. Note: Software simulation; not physical speaker acoustic quality. | `PASS (MOCKED TTS / EMULATOR)` |
| **ST-07** | **User-Initiated Stop/Cancel** | Unit & Controller lifecycle test<br>`test/presentation/simulator_controller_test.dart` | Canceling listening increments session generation, discards pending callbacks, returns cleanly to idle. | Verified in CI test suite (31/31 passed). | `PASS (AUTOMATED)` |
| **ST-08** | **Silence & Recognizer Timeout** | Unit & Controller lifecycle test<br>`test/presentation/simulator_controller_test.dart` | Watchdog detects silence, displays informative banner ("No speech was captured..."), resets state to idle. | Verified in CI test suite (31/31 passed). | `PASS (AUTOMATED)` |
| **ST-09** | **Offline Behavior & Guidance** | Unit & Controller lifecycle test<br>`test/presentation/simulator_controller_test.dart` | Offline recognizer failure catches cleanly, displays explicit guidance banner regarding offline language pack prerequisites. | Verified in CI test suite (31/31 passed). | `PASS (AUTOMATED)` |
| **ST-10** | **Retry & Interruption Recovery** | Hosted Android Emulator (API 34)<br>`integration_test/app_test.dart` | Tapping "Try Again" halts active audio, clears live transcript, resets evaluation card, mic restores to tap-to-speak. | Verified on `emulator-5554` in CI run 44938049356. | `PASS (HOSTED EMULATOR)` |
| **ST-11** | **Local Persistence Across Navigation** | Hosted Android Emulator (API 34)<br>`integration_test/app_test.dart` | Practice attempts persist in `SharedPreferences` with timestamps, score %, and Arabic notes; retrieved in `HistoryScreen`. | Verified on `emulator-5554`. Note: Tests local data persistence across navigation; not an OS process kill/reboot. | `PASS (HOSTED EMULATOR)` |

---

## 🔍 Provenance & Technical Boundaries

1. **Automated & Hosted Emulator Verification (`VERIFIED`)**:
   - Code formatting, static analysis, 31 unit/widget/integration tests, and debug APK compilation are fully automated, reproducible, and passing in GitHub Actions.
   - Hosted Android Emulator (API 34) verifies real Android APK installation, runtime rendering, navigation, and state machines on standard Linux runners.
2. **Untested Real Hardware Audio Behaviors (`NOT TESTED / UNVERIFIED`)**:
   - Physical microphone hardware acoustics, room ambient noise suppression, real physical speaker audio fidelity, and vendor-specific Android offline speech recognition packs remain `NOT TESTED / UNVERIFIED (Awaiting Real Device or Simulated Hardware Environment)`.
   - The application does not claim native acoustic pronunciation scoring or employer QA certification.

---

## 📋 M1 Acceptance Verdict Criteria

- **Automated Gates**: **PASS** (Format, Analyze, 31 Tests, APK Build).
- **Hosted Android Emulator Gate**: **PASS** (CI Run 44938049356, 4/4 integration scenarios passed on API 34).
- **Merge Recommendation**: **DO NOT MERGE PR #2** without explicit Product Owner authorization. M2 development remains unauthorized until M1 is officially accepted.
