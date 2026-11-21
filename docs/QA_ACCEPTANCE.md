# QA_ACCEPTANCE.md — Quality Assurance, Governance Gates, & Smoke-Test Checklist

This document defines the quality gates, acceptance criteria, and physical hardware verification protocols for CALLFORGE.

---

## 🚦 Automated Quality Gates

Every Pull Request must satisfy all automated quality gates prior to merging:

### Gate 1: Code Formatting & Static Analysis
- `dart format --set-exit-if-changed .` must pass with 0 deviations.
- `flutter analyze` must pass with **0 errors, 0 warnings, and 0 lints**.

### Gate 2: Automated Unit & Domain Test Suite
- Domain logic, scoring algorithms, and repository persistence must pass with 0 failures: `flutter test`.
- All edge cases (empty speech, punctuation, homophones, P/B substitutions, error handling) must be covered.

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

## 📱 Physical Android Device Smoke-Test Checklist (M1 Hardware Gate)

> [!IMPORTANT]
> In accordance with `AGENTS.md`, an agent or reviewer must **NEVER** declare M1 physically verified unless tested on actual attached Android hardware. The following checklist must be physically executed on device:

| Test ID | Test Scenario | Procedure | Expected Physical Outcome | Status |
| :--- | :--- | :--- | :--- | :--- |
| **ST-01** | **Permission Request** | Launch app fresh, tap microphone button. | Android OS runtime permission dialog for `RECORD_AUDIO` appears. | `PENDING HARDWARE` |
| **ST-02** | **Permission Denial** | Deny microphone permission when prompted. | UI catches denial, displays friendly error message, and does not crash. | `PENDING HARDWARE` |
| **ST-03** | **Opening Greeting STT** | Tap mic, speak standard greeting into physical microphone. | Spoken audio is transcribed into live transcript box; final text matches speech. | `PENDING HARDWARE` |
| **ST-04** | **Text Evaluation & Coaching** | Complete greeting delivery. | Recognized-text similarity %, missing anchors, and Egyptian Arabic coaching render accurately. | `PENDING HARDWARE` |
| **ST-05** | **Customer Audio Playback (TTS)**| Complete greeting meeting target script. | Phone speaker plays American customer audio response (*David Miller*) clearly. | `PENDING HARDWARE` |
| **ST-06** | **User-Initiated Stop** | Tap mic to start listening, tap mic again after 2 seconds. | Recording stops immediately, transitions to processing, and evaluates spoken slice. | `PENDING HARDWARE` |
| **ST-07** | **Silence Timeout** | Tap mic, remain completely silent for 5 seconds. | Recognizer detects silence, does not freeze, and resets to idle with retry prompt. | `PENDING HARDWARE` |
| **ST-08** | **Offline Airplane Mode** | Enable Airplane mode (Wi-Fi and Cellular off), tap mic to speak. | If Google offline English pack is installed: transcribes offline. If missing: catches error and displays offline guidance. | `PENDING HARDWARE` |
| **ST-09** | **Retry Flow** | Tap "Try Again" after an evaluation. | Resets transcript and evaluation card, restoring mic to tap-to-speak state. | `PENDING HARDWARE` |
| **ST-10** | **Local Persistence & History** | Perform 2 drills, open History screen from app bar. | Both attempts appear in history with timestamp, score %, and transcript. | `PENDING HARDWARE` |
| **ST-11** | **History Clear** | In History screen, tap clear icon and confirm dialog. | Attempt logs are cleared from local storage. | `PENDING HARDWARE` |

---

## 📋 M1 Acceptance Verdict Criteria

- **Automated Gates**: PASS (Format, Analyze, 19+ Tests, APK Build).
- **Physical Device Gate**: PENDING physical phone attachment.
- **Merge Recommendation**: **DO NOT MERGE** until physical smoke-test checklist ST-01 through ST-11 is executed on real Android hardware.
