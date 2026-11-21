# QA_ACCEPTANCE.md — Quality Assurance, Governance Gates, & Smoke-Test Checklist

This document defines the automated quality gates, acceptance criteria, and hosted verification protocols for CALLFORGE.

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

## 🚦 Automated Quality Gates

Every Pull Request must satisfy all automated quality gates prior to merging:

### Gate 1: Code Formatting & Static Analysis
- `dart format --set-exit-if-changed .` must pass with 0 deviations.
- `flutter analyze` must pass with **0 errors, 0 warnings, and 0 lints**.

### Gate 2: Automated Unit & Domain Test Suite
- Domain logic, scoring algorithms, and repository persistence must pass with 0 failures: `flutter test`.
- All edge cases (empty speech, punctuation, homophones, P/B substitutions, error handling, session generation guards) must be covered.

### Gate 3: Widget, UI State & App Smoke Test Suite
- Core widgets (`MicControlButton`, `CoachingCard`, `SimulatorScreen`, `HistoryScreen`) must verify state transitions across `idle`, `listening`, `processing`, `customerSpeaking`, and `error`.
- Scrolling, retry buttons, and history list rendering must be verified.
- Complete application lifecycle smoke suite ([test/integration/app_smoke_test.dart](file:///C:/Users/TopOne%20MM/Documents/callforge-voice-academy/test/integration/app_smoke_test.dart)) must execute and pass in headless CI.

### Gate 4: Android Build Validation
- Headless Gradle compilation must successfully produce a debug APK:
  ```bash
  flutter build apk --debug
  ```
- Memory heap must remain within `-Xmx2048m` without Windows system thrashing.

### Gate 5: Hosted Android Emulator Integration Tests
- Executed on standard GitHub Actions `ubuntu-latest` runners with KVM hardware acceleration via `reactivecircus/android-emulator-runner@v2`.
- End-to-end integration tests ([integration_test/app_test.dart](file:///C:/Users/TopOne%20MM/Documents/callforge-voice-academy/integration_test/app_test.dart)) exercise real APK execution on Android API 34.

---

## 📱 Canonical Integration & Smoke-Test Matrix (ST-01 – ST-11)

The matrix below maps the required M1 voice prototype scenarios to their automated & hosted verification implementation:

| Test ID | Test Scenario | Execution & Verification Mechanism | Expected Automated / Hosted Outcome | Implementation File | Verification Status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **ST-01** | **Cold Launch & Startup Stability** | Launch app fresh via Flutter test harness / hosted Android runner. | App opens smoothly, renders "CALLFORGE SIMULATOR", "Agent: Alex (AT&T)", and Turn 1 Inbound Opening without ANR or crash. | `test/integration/app_smoke_test.dart` & `integration_test/app_test.dart` | `VERIFIED (AUTOMATED/EMULATOR)` |
| **ST-02** | **Microphone Permission Handling** | Test `shouldFailMic` simulation & runtime permission dialog flow. | Permission denial displays clear guidance banner ("Microphone permission is required to practice spoken calls"), mic resets to idle, does not crash. | `test/integration/app_smoke_test.dart` & `test/presentation/simulator_controller_test.dart` | `VERIFIED (AUTOMATED/EMULATOR)` |
| **ST-03** | **Missing Anchor Rejection & Coaching** | Simulate greeting omitting mandatory alias "Alex" or carrier "AT&T". | Evaluation flags missing anchor, Egyptian Arabic guidance appears ("الافتتاحية الإلزامية"), state renders `DRILL TARGET UNMET`, Turn 2 customer response is NOT triggered. | `test/integration/app_smoke_test.dart` & `test/core/evaluation/speech_evaluator_test.dart` | `VERIFIED (AUTOMATED/EMULATOR)` |
| **ST-04** | **English-US Speech Recognition** | Feed standard verbatim greeting through deterministic voice double. | Recognized words transcribe into live transcript box in real-time. | `test/integration/app_smoke_test.dart` & `integration_test/app_test.dart` | `VERIFIED (DETERMINISTIC SIMULATION)` |
| **ST-05** | **Recognized-Text Coaching & Progression** | Evaluate verbatim greeting attempt against reference script. | Coaching card renders `VERBATIM TRANSCRIPT MATCH (100% Text Match)`, 100% similarity, 0% token error rate, and unlocks Turn 2. | `test/integration/app_smoke_test.dart` & `test/widget_test.dart` | `VERIFIED (AUTOMATED/EMULATOR)` |
| **ST-06** | **Customer TTS Response Playback** | Complete Turn 1 greeting meeting target script. | State transitions to `customerSpeaking`, customer card displays synthesized speech ("David Miller"), completes cleanly to idle. | `test/integration/app_smoke_test.dart` & `test/presentation/simulator_controller_test.dart` | `VERIFIED (AUTOMATED/EMULATOR)` |
| **ST-07** | **User-Initiated Stop/Cancel** | Trigger `stopListening()` or `cancelListening()` during active speech session. | Recognizer stops immediately, session generation invalidates stale callbacks, returns to idle without freezing. | `test/presentation/simulator_controller_test.dart` & `lib/core/audio/speech_service.dart` | `VERIFIED (AUTOMATED/EMULATOR)` |
| **ST-08** | **Silence & Recognizer Timeout** | Simulate silence timeout via `shouldTimeoutWithSilence`. | Watchdog timer detects silence, displays informative banner ("No speech was captured..."), resets state to idle. | `test/presentation/simulator_controller_test.dart` & `lib/core/audio/speech_service.dart` | `VERIFIED (AUTOMATED/EMULATOR)` |
| **ST-09** | **Offline Behavior & Guidance** | Simulate offline engine failure via `shouldFailNetwork`. | Catches recognizer error, displays explicit offline guidance banner instructing user on offline English language pack requirements. | `test/presentation/simulator_controller_test.dart` & `lib/core/audio/speech_service.dart` | `VERIFIED (AUTOMATED/EMULATOR)` |
| **ST-10** | **Retry & Interruption Recovery** | Tap "Try Again" during customer speech or rapid tap during transition. | Active TTS speech halts immediately, live transcript clears, evaluation card resets, mic restores to tap-to-speak. | `test/integration/app_smoke_test.dart` & `test/presentation/simulator_controller_test.dart` | `VERIFIED (AUTOMATED/EMULATOR)` |
| **ST-11** | **Local Persistence Across Navigation** | Execute practice drills, navigate to `HistoryScreen`, verify persistence. | Attempt records persist locally with timestamps, 100% Text Match score, and Egyptian Arabic notes; persists across screen navigation and state reloads. | `test/integration/app_smoke_test.dart` & `test/data/attempt_repository_test.dart` | `VERIFIED (AUTOMATED/EMULATOR)` |

---

## 🔍 Provenance & Technical Boundaries

1. **Automated / Hosted Emulator Verification**:
   - Code formatting, static analysis, 31 unit/widget/integration tests, and debug APK compilation are fully automated and verified.
   - Hosted Android Emulator verifies Android runtime execution, widget rendering, state machines, and data persistence on Linux CI.
2. **Untested Real Hardware Audio Behaviors**:
   - Physical microphone hardware acoustics, ambient background noise suppression, real speaker audio quality, and vendor-specific Android offline speech recognition packs remain `NOT TESTED / UNVERIFIED (Awaiting Real Device or Simulated Hardware Environment)`.
   - The application does not claim native acoustic pronunciation scoring or employer QA certification.

---

## 📋 M1 Acceptance Verdict Criteria

- **Automated Gates**: PASS (Format, Analyze, 31 Unit/Widget/Integration Tests, APK Build).
- **Hosted Emulator Gate**: Configured in `.github/workflows/ci.yml`.
- **Merge Recommendation**: **DO NOT MERGE PR #2** without explicit Product Owner authorization. M2 development remains unauthorized until M1 is officially accepted.
