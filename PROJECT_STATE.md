# PROJECT_STATE.md — Current Project Status

**Repository**: `https://github.com/abuhmaid28/callforge-voice-academy`  
**Current Branch**: `feat/m1-voice-prototype` (M1 Remediation & Truth Audit Phase)  
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
| **Hardware** | `VERIFIED` | Windows 10 Enterprise x64 (8 GB RAM constraint recognized) |
| **Connected Device**| `PENDING USB` | 0 physical Android devices currently attached via ADB; Windows/Chrome desktop active |

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
  - [x] Unit and widget tests expanded to 22 tests (100% passing).
  - [x] Debug APK build verified (`build/app/outputs/flutter-apk/app-debug.apk`, 171.4 MB).
  - [x] Physical Android smoke-test checklist documented in `docs/QA_ACCEPTANCE.md`.

---

## 📊 Module Implementation Matrix (M0–M6 Technical Roadmap)

| Module | Curriculum Focus | Technical Milestone | Status | Notes |
| :--- | :--- | :--- | :--- | :--- |
| **1. Real Voice Call Simulator** | Spoken roleplay | M1 & M3 | `IN PROGRESS` | M1 delivers Turn 1 greeting & customer response; M3 expands to full multi-turn branching. |
| **2. Disclosure Reading & Pronunciation** | Legal disclosures & phonetics | M2 | `PLANNED` | Verbatim karaoke tracking and P/B phonemic contrast learning suite. |
| **3. American English Listening & Speaking** | Dialects & fast speech | M4 | `PLANNED` | Conversational pacing & active listening extraction. |
| **4. AERD and Call Control** | Steering & de-escalation | M5 | `PLANNED` | Acknowledge, Empathy, Reassure, Defuse framework without dead air. |
| **5. AT&T Product Knowledge** | Plan & device training | M5 | `PLANNED` | Fictionalized Fiber, Unlimited, and EIP trade-in catalog (`[Fictional / Simulation Only]`). |
| **6. Sales Discovery and Conversion** | Consultative sales | M5 | `PLANNED` | Open-ended discovery questioning and value bridging. |
| **7. Billing and Technical Troubleshooting** | Bill breakdown & tech reset | M6 | `PLANNED` | Fictionalized proration and diagnostic drills. |
| **8. Escalation and Angry Customers** | High stress calls | M3 & M6 | `PLANNED` | De-escalation matrix & authorized transfer etiquette (`[UNKNOWN]` proprietary rules omitted). |
| **9. KPI and Quality Tracking** | Handling pace & scorecard | M6 | `PLANNED` | Practice metrics; not official employer QA. |
| **10. Adaptive 90-Day Learning System** | Long-term progression | M6 | `PLANNED` | Progressive 90-day trajectory from Nesting to Elite Master. |

---

## 🔍 Known Blockers & Physical Testing Gate

1. **Physical Device Pending**:
   - `adb devices` shows 0 devices. Unit and widget testing (22/22) and headless APK compilation succeed. Physical runtime verification of microphone, TTS, permissions, and offline mode is pending hardware attachment via USB.
2. **Merge Recommendation**:
   - **DO NOT MERGE PR #2** until physical Android smoke-test checklist (ST-01 through ST-11 in `docs/QA_ACCEPTANCE.md`) is verified on attached hardware.
