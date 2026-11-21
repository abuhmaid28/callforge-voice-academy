# PROJECT_STATE.md — Current Project Status

**Repository**: `https://github.com/abuhmaid28/callforge-voice-academy`  
**Current Branch**: `feat/m1-voice-prototype` (M1 Remediation, Reliability & Truth Audit)  
**Pull Request**: [#2](https://github.com/abuhmaid28/callforge-voice-academy/pull/2) (`mergeable: MERGEABLE`, `mergeStateStatus: CLEAN`)  
**Last Updated**: 2026-11-21

---

## 🚦 System & Environment Verification

| Component | Status | Details |
| :--- | :--- | :--- |
| **Flutter SDK** | `VERIFIED` | Flutter 3.47.0 (Channel stable, Dart 3.13.0) at `C:\src\flutter` |
| **Android SDK** | `VERIFIED` | Android SDK 36.0.0, Platform android-37.0 at `C:\Android\Sdk` |
| **Java JDK** | `VERIFIED` | OpenJDK 25.0.2 at `C:\Program Files\Android\Android Studio\jbr` |
| **Android Licenses**| `VERIFIED` | All Android licenses accepted |
| **GitHub CLI** | `VERIFIED` | Authenticated as `abuhmaid28` via git operations protocol HTTPS |
| **Hardware** | `VERIFIED` | Windows 10 Enterprise x64 (8 GB RAM constraint managed with `-Xmx2048m`) |
| **Connected Device**| `PENDING USB` | 0 physical Android devices currently attached via ADB; Windows/Chrome desktop active |
| **PR Mergeability**| `CLEAN` | Verified via GitHub API (`mergeable: MERGEABLE`, zero git merge conflicts) |

---

## 🎯 Active Milestone: M1 — Voice Prototype & Inbound Greeting Simulator

- [x] Phase 1: Environment verification & Git origin connection.
- [x] Phase 2: Bootstrap project documentation & GitHub milestones/issues (Milestone #1, Issue #1).
- [x] Phase 3: Production-quality voice architecture & Android prototype design.
- [x] Phase 4: Implement Flutter M1 voice prototype on `feat/m1-voice-prototype`.
- [x] Task 002 Remediation & Foundation Truth Audit:
  - [x] Source Provenance Framework established across documentation (`[User-Confirmed Workflow]`, `[Official Public Verified Information]`, `[Work-Reported Information]`, `[Derived Training Material]`, `[Fictional / Simulation Only]`, `[UNKNOWN]`).
  - [x] Removed invented employer policies (supervisor callbacks are not available in user's process `[Work-Reported Information]`; arbitrary 2-attempt de-escalation rule and promotional delay claims removed).
  - [x] Restored technical roadmap structure (M0–M6) while preserving all 10 pedagogical modules.
  - [x] Corrected speech evaluation integrity: Recognized-Text Similarity, Token Error Rate, estimated session pace, educational P/B awareness alerts. Removed false claims of acoustic native pronunciation or official employer QA compliance.
  - [x] Corrected inbound simulation sequence: Alex delivers opening greeting first (Turn 1), customer responds via TTS upon target confirmation (Turn 2).
  - [x] Hardened audio lifecycle and speech recognizer resilience (specific error translations, timeout watchdog, permission handling, offline guidance, cancel/retry cleanup).
  - [x] Clarified synthetic waveform as a simulated activity visualizer, not a hardware microphone amplitude meter.
- [x] Task 003 Final M1 Reliability & Review Hardening:
  - [x] Replaced substring anchor matching with token-boundary evaluation to eliminate false positives (`matter`, `Alexander`, `firstname`, `lastname`).
  - [x] Added recognition of AT&T speech-to-text rendering variations (`att`, `at&t`, `at and t`, `at t`, `a t and t`).
  - [x] Audio session generation IDs (`_sessionGeneration`) preventing duplicate callbacks and stale completions.
  - [x] Reconciled M0–M6 technical roadmap with product requirements and all 10 curriculum modules in `docs/ROADMAP.md`.
- [x] Task 004 Physical Android Voice Acceptance & Review Hardening:
  - [x] Unified canonical ST-01 through ST-11 checklist in `docs/QA_ACCEPTANCE.md`.
  - [x] Renamed verbatim banner to `VERBATIM TRANSCRIPT MATCH (100% Text Match)` to avoid misrepresenting transcript match as acoustic pronunciation.
  - [x] Removed uncalibrated WPM badge from coaching UI until calibrated audio timing is integrated.
  - [x] Fixed audio lifecycle races: `retry()` awaits `stopSpeaking()` and cancels listening; `_handleSpeechError` ignores stale errors outside listening/processing; `_deliverFinalTranscript` preserves `customerSpeaking` state.
  - [x] Rebuilt and fingerprinted debug APK at verified HEAD:
    - Path: `build/app/outputs/flutter-apk/app-debug.apk`
    - Size: 171,416,911 bytes
    - SHA-256: `C516B51EDAF0E88BC1D3B2C620872332DE8D1CAC63F3994D50330CBA98193D01`
    - Timestamp: 2026-11-21 06:52:04
  - [x] Automated test suite: 27 / 27 unit & widget tests passing (100%).
  - [x] ADB device status: 0 physical devices attached via ADB. Smoke-test matrix ST-01 through ST-11 is `PENDING HARDWARE`.

---

## 📊 Module Implementation Matrix (M0–M6 Technical Roadmap)

| Module | Curriculum Focus | Technical Milestone | Status | Notes |
| :--- | :--- | :--- | :--- | :--- |
| **1. Real Voice Call Simulator** | Spoken roleplay | M1 & M3 | `IN PROGRESS` | M1 delivers Turn 1 greeting & customer response; M3 expands to full multi-turn branching. |
| **2. Disclosure Reading & Pronunciation** | Legal disclosures & phonetics | M2 | `PLANNED` | Verbatim karaoke tracking and P/B phonemic contrast learning suite. |
| **3. American English Listening & Speaking** | Dialects & fast speech | M3 | `PLANNED` | Conversational pacing & active listening extraction. |
| **4. AERD and Call Control** | Steering & de-escalation | M3 | `PLANNED` | Acknowledge, Empathy, Reassure, Defuse framework without dead air. |
| **5. AT&T Product Knowledge** | Plan & device training | M4 | `PLANNED` | Fictionalized Fiber, Unlimited, and EIP trade-in catalog (`[Fictional / Simulation Only]`). |
| **6. Sales Discovery and Conversion** | Consultative sales | M4 | `PLANNED` | Open-ended discovery questioning and value bridging. |
| **7. Billing and Technical Troubleshooting** | Bill breakdown & tech reset | M3 | `PLANNED` | Fictionalized proration and diagnostic drills. |
| **8. Escalation and Angry Customers** | High stress calls | M3 | `PLANNED` | De-escalation matrix & authorized transfer etiquette (`[UNKNOWN]` proprietary rules omitted). |
| **9. KPI and Quality Tracking** | Handling pace & scorecard | M5 | `PLANNED` | Practice metrics; not official employer QA. |
| **10. Adaptive 90-Day Learning System** | Long-term progression | M5 | `PLANNED` | Progressive 90-day trajectory from Nesting to Elite Master. |

---

## 🔍 Known Blockers & Physical Testing Gate

1. **Physical Device Pending**:
   - `adb devices -l` reports 0 connected devices (`List of devices attached` empty).
   - Automated checks pass: 27/27 tests passing, `flutter analyze` 0 issues, debug APK compiled and fingerprinted.
   - Physical smoke test matrix ST-01 through ST-11 in `docs/QA_ACCEPTANCE.md` remains `PENDING HARDWARE` until an authorized physical Android device is attached via USB debugging.
2. **Merge Recommendation**:
   - **DO NOT MERGE PR #2** until physical Android smoke-test checklist is validated on attached hardware.
