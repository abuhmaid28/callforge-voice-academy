# QA_ACCEPTANCE.md — Quality Assurance, Governance Gates, & Hardware Smoke-Test Checklist

This document defines the automated quality gates, acceptance criteria, and physical hardware verification protocols for CALLFORGE.

---

## 🚦 Automated Quality Gates

Every Pull Request must satisfy all automated quality gates prior to merging:

### Gate 1: Code Formatting & Static Analysis
- `dart format --set-exit-if-changed .` must pass with 0 deviations.
- `flutter analyze` must pass with **0 errors, 0 warnings, and 0 lints**.

### Gate 2: Automated Unit & Domain Test Suite
- Domain logic, scoring algorithms, and repository persistence must pass with 0 failures: `flutter test`.
- All edge cases (empty speech, punctuation, homophones, P/B substitutions, error handling, session generation guards) must be covered.

### Gate 3: Widget & UI State Test Suite
- Core widgets (`MicControlButton`, `CoachingCard`, `SimulatorScreen`) must verify state transitions across `idle`, `listening`, `processing`, `customerSpeaking`, and `error`.
- Scrolling, retry buttons, and history list rendering must be verified.

### Gate 4: Android Build Validation
- Headless Gradle compilation must successfully produce a debug APK:
  ```bash
  flutter build apk --debug
  ```
- Memory heap must remain within `-Xmx2048m` without Windows system thrashing.

---

## 📱 Physical Android Device Smoke-Test Checklist (Canonical ST-01 – ST-11)

> [!IMPORTANT]
> In accordance with `AGENTS.md` Rule 6, an agent or reviewer must **NEVER** declare M1 physically verified unless tested on actual attached Android hardware.
> The canonical checklist below defines the mandatory physical hardware acceptance test matrix:

| Test ID | Test Scenario | Execution Procedure | Expected Physical Outcome | Device Condition & Evidence | Status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **ST-01** | **Cold Launch & Startup Stability** | Launch app fresh from app drawer or via `adb shell am start -n com.callforge.callforge/.MainActivity`. | App opens smoothly, splash completes, renders "CALLFORGE SIMULATOR", "Agent: Alex (AT&T)", and Turn 1 Inbound Opening without ANR or crash. | Requires attached Android hardware via ADB | `PENDING HARDWARE` |
| **ST-02** | **Microphone Permission Granting** | Tap mic button on fresh install when system prompt appears. Select "While using the app". | Android OS grants `RECORD_AUDIO`, mic transitions from idle to listening state, animated activity indicator activates. | Requires attached Android hardware via ADB | `PENDING HARDWARE` |
| **ST-03** | **Microphone Permission Denial & Recovery** | Deny mic permission when prompted, or revoke via Android Settings and tap mic button. | UI catches denial, displays friendly banner ("Microphone permission is required to practice spoken calls"), mic resets to idle, does not crash. | Requires attached Android hardware via ADB | `PENDING HARDWARE` |
| **ST-04** | **Real English-US Speech Recognition** | Tap mic, speak standard greeting into physical microphone: *"Hello, thank you for calling AT&T. This is Alex. May I have your first and last name, please?"* | Android speech recognizer transcribes spoken English into live transcript display in real-time. | Requires attached Android hardware via ADB | `PENDING HARDWARE` |
| **ST-05** | **Recognized-Text Coaching & Progression** | Complete Turn 1 greeting attempt. Test verbatim delivery and test missing mandatory anchor (e.g. omit "Alex"). | Coaching card displays recognized-text similarity %, token error rate %, missing anchors, and Egyptian Arabic feedback. Verbatim delivery shows `VERBATIM TRANSCRIPT MATCH (100% Text Match)`; missing anchor prevents progression. | Requires attached Android hardware via ADB | `PENDING HARDWARE` |
| **ST-06** | **Real Customer TTS Playback** | Complete Turn 1 greeting meeting target script. | Phone speaker or earpiece plays clear American English synthesized customer response (*David Miller*). UI displays "Customer Speaking" state. | Requires attached Android hardware via ADB | `PENDING HARDWARE` |
| **ST-07** | **User-Initiated Stop/Cancel** | Tap mic to start listening, speak 2 words, tap mic again after 2 seconds before speech completes. | Recording stops immediately, transitions to processing, evaluates captured words without crashing or hanging. | Requires attached Android hardware via ADB | `PENDING HARDWARE` |
| **ST-08** | **Silence & Recognizer Timeout** | Tap mic, remain completely silent for 5+ seconds. | Recognizer/watchdog detects silence, displays "No speech detected. Please speak clearly into the microphone", resets mic to idle without freezing. | Requires attached Android hardware via ADB | `PENDING HARDWARE` |
| **ST-09** | **Airplane Mode & Offline Limitations** | Enable Airplane mode (Wi-Fi and mobile data off). Tap mic and attempt to speak. | If Google offline English pack is installed: transcribes offline. If missing: catches error and displays offline guidance banner. | Requires attached Android hardware via ADB | `PENDING HARDWARE` |
| **ST-10** | **Retry & Interruption Recovery** | Tap "Try Again" during customer TTS playback, or tap mic repeatedly during state transitions. | Active TTS audio stops immediately, session generation invalidates stale callbacks, state resets to idle, no duplicate evaluations. | Requires attached Android hardware via ADB | `PENDING HARDWARE` |
| **ST-11** | **Local Persistence Across Relaunch** | Complete 2 drills, verify in History, force-stop app (`am force-stop`), then relaunch. | Both attempts remain persisted in local storage with timestamps, recognized-text scores, and Arabic coaching notes. | Requires attached Android hardware via ADB | `PENDING HARDWARE` |

---

## 📋 M1 Acceptance Verdict Criteria

- **Automated Gates**: PASS (Formatting, Analyze, 27 Unit/Widget Tests, APK Compilation).
- **Physical Device Gate**: PENDING physical Android device connection via ADB.
- **Merge Recommendation**: **DO NOT MERGE PR #2** until physical smoke-test checklist ST-01 through ST-11 is verified on real Android hardware.
