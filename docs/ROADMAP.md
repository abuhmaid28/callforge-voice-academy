# ROADMAP.md — Technical Release Milestones (M0–M6)

This document defines the technical release milestones for CALLFORGE (M0 through M6), reconciling the technical architecture directly with the original training academy charter while preserving all 10 pedagogical training modules.

---

## 🗺️ Reconciled Milestone Architecture (M0–M6)

| Milestone | Target Scope | Associated Academy Modules | Core Deliverables |
| :--- | :--- | :--- | :--- |
| **M0** | Foundation & Environment Verification | Governance & Architecture | Environment verification, Windows 8 GB RAM tuning (`-Xmx2048m`), Android SDK setup, source provenance framework. |
| **M1** | Voice Prototype & Inbound Greeting Simulator | Module 1 (Turn 1 Opening) | Turn-based greeting loop (Alex opening first -> customer audio response), push-to-talk STT, TTS playback, token-aware anchor verification, recognized-text scoring, local storage, session generation guards, Android physical smoke checklist. |
| **M2** | Disclosure Reading & Pronunciation Precision | Module 2 | Verbatim legal disclosure reading (CPNI, auto-pay, return windows), timing tracker, and P/B phonemic contrast educational drill suite. |
| **M3** | Core Floor Care Simulator (Listening, AERD & Billing) | Modules 1, 3, 4, 7, 8 | Multi-turn conversational state machine, American English listening comprehension, AERD call control, billing explanation drills (proration, fees), and customer escalation de-escalation. |
| **M4** | Consultative Sales Mastery | Modules 5 & 6 | Open-ended discovery questions, value bridging, plan upgrade scenarios (Fiber, Unlimited Wireless, EIP trade-ins), and consultative closing. |
| **M5** | Quality Tracking & Adaptive 90-Day Learning System | Modules 9 & 10 | Practice QA scorecard, handling pace awareness, resolution mindset, and structured 90-day trajectory from Nesting to Elite Master. |
| **M6** | Advanced Voice Evaluation & Acoustic Research (Optional) | Research Extension | Exploration of on-device acoustic phonetics, open-source embedded phoneme models (e.g. Vosk / TFLite), and acoustic-timed WPM without paid cloud APIs. |

---

## 🎯 Active Milestone: M1 — Voice Prototype & Inbound Greeting Simulator

### Scope & Technical Acceptance Criteria:
1. **Inbound Call Turn Sequence**:
   - Turn 1: Call connects -> Alex delivers standard greeting:
     *"Hello, thank you for calling AT&T. This is Alex. May I have your first and last name, please?"*
   - Turn 2: Once recognized and drill target is confirmed, customer (*David Miller*) responds with first-bill inquiry via TTS.
2. **Audio Pipeline & Concurrency Reliability**:
   - `NativeSpeechService` integrating Android `flutter_tts` and `speech_to_text`.
   - Token-aware semantic anchor validation (`alex`, `first`, `last`, `name`, and AT&T STT variations: `att`, `at&t`, `at and t`, `at t`, `a t t`).
   - Session generation tracking (`_sessionGeneration`) guarding against duplicate final callbacks, late events, and old-session results.
   - Awaited asynchronous callback completion.
   - Distinction between TTS playback failure (`onError`) and successful completion (`onFinished`).
   - Explicit offline error handling and guidance when offline speech models are unavailable.
3. **Evidence-Based Evaluation Engine**:
   - **Recognized-Text Similarity** (normalized Levenshtein edit distance).
   - **Token Error Rate (WER)**.
   - Distinction between **Verbatim Target Met (100% exact text match)** and **Drill Target Met (70%+ Practice Threshold)**.
   - Unvalidated session pace (words per active session duration; displayed without performance grading).
   - Educational P/B contrast awareness reminders (text heuristics, not acoustic phonetics).
   - Zero claims of acoustic native pronunciation or official employer QA compliance.
4. **Bilingual Coaching & Local Persistence**:
   - English transcript analysis + natural Egyptian Arabic trainer guidance.
   - Local offline attempt records saved to `SharedPreferences` with retry flow.
5. **Verification & Physical Hardware Gate**:
   - Automated unit, controller, and widget tests passing with 0 failures.
   - Headless debug APK compilation verified.
   - 11-step Physical Android Device Smoke-Test Checklist (`ST-01` to `ST-11` in `docs/QA_ACCEPTANCE.md`).

---

## 🔮 Milestone Sequencing & Governance Rules

- M1 must be validated on physical hardware prior to merging PR #2 or starting M2.
- Subsequent milestones (M2 through M6) will be executed sequentially using dedicated feature branches and verified pull requests.
