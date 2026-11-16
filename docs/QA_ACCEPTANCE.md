# QA_ACCEPTANCE.md — Quality Assurance & Acceptance Criteria

This document defines the strict quality gates, testing requirements, and acceptance criteria required for code to merge into `main` and be released.

---

## 🚦 Quality Gates

Every Pull Request must satisfy the following 5 gates before merging:

### Gate 1: Static Analysis & Code Formatting
- `dart format --set-exit-if-changed .` must pass with 0 formatting deviations.
- `flutter analyze` must pass with **0 errors, 0 warnings, and 0 lints**.

### Gate 2: Automated Unit & Domain Tests
- Pure Dart domain models, scoring algorithms, and text evaluation utilities must achieve $\ge 90\%$ test coverage.
- All edge cases (silence, empty strings, casing, punctuation, homophones, P/B substitutions) must have dedicated test cases.
- All tests must pass: `flutter test`.

### Gate 3: Widget & UI State Tests
- Core widgets (`MicButton`, `CoachingCard`, `GreetingSimulatorScreen`) must verify visual state changes between `Idle`, `TTS_Speaking`, `STT_Listening`, and `Evaluation_Ready`.
- No memory leaks or uncancelled timers / streams.

### Gate 4: Android Build Validation
- Gradle build must successfully produce a debug APK without memory exhaustion:
  ```bash
  flutter build apk --debug
  ```
- Android Manifest permissions must include `RECORD_AUDIO` and `INTERNET` (for recognition services).

### Gate 5: Physical Hardware Verification Policy
- **Strict Rule**: An agent or developer must **NEVER** claim physical device verification unless ADB shows a connected physical device and the APK was actually installed and executed on hardware.
- If physical hardware is disconnected during automated CI or offline development, the status must clearly state:
  > *"Verified via automated unit/widget tests and headless APK compilation; physical device runtime verification pending hardware attachment."*

---

## 📋 M1 Prototype Acceptance Criteria Checklist

- [ ] **AC-01 (Greeting Script Verification)**: The engine verifies spoken input against the user-confirmed greeting:
  *"Hello, thank you for calling AT&T. This is Alex. May I have your first and last name, please?"*
- [ ] **AC-02 (Acoustic Playback)**: Customer prompts play cleanly via Android TTS in an American English accent.
- [ ] **AC-03 (Microphone Input & Transcription)**: Alex's spoken response is captured via microphone and transcribed into text.
- [ ] **AC-04 (Evidence-Based Scoring)**:
  - Transcript is normalized and compared via edit distance.
  - Presence of semantic anchors (`AT&T`, `Alex`, `first`, `last`, `name`) is checked.
  - No synthetic/fake score percentages are invented.
- [ ] **AC-05 (Egyptian Arabic Coaching)**: Specific, encouraging feedback is generated in Egyptian Arabic explaining exact missed words or pronunciation tips.
- [ ] **AC-06 (Retry & Persistence)**: User can retry the drill immediately, and their attempt history is saved locally.
- [ ] **AC-07 (Error & Permission Resilience)**: Missing mic permissions or speech recognizer timeouts are caught gracefully with actionable UI prompts.
