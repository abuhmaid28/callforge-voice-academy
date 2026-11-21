# ROADMAP.md — Technical Release Milestones (M0–M6)

This roadmap defines the technical milestone delivery plan for CALLFORGE, organized into 7 structured milestones (M0 through M6) that systematically implement the 10 core pedagogical modules.

---

## 🗺️ Technical Milestone Architecture (M0–M6)

| Milestone | Target Scope | Associated Academy Modules | Core Deliverables |
| :--- | :--- | :--- | :--- |
| **M0** | Foundation & Environment Verification | Governance & Architecture | Environment verification, low-RAM Windows tuning, Android SDK setup, source provenance framework. |
| **M1** | Voice Prototype & Inbound Greeting Simulator | Module 1 (Turn 1 Opening) | Turn-based greeting loop (Alex opening first -> customer audio response), push-to-talk STT, TTS playback, recognized-text scoring, local storage, Android physical smoke checklist. |
| **M2** | Disclosure Reading & Pronunciation Precision | Module 2 | Verbatim disclosure karaoke engine, timing tracker, and P/B phonemic contrast educational drill suite. |
| **M3** | Interactive Multi-Turn Simulator & Branching Flows | Module 1 (Full Call) & Module 8 | Multi-turn conversational state machine, branching customer mood states, and de-escalation practice. |
| **M4** | American English Listening & Fluency | Module 3 | Rapid American speech playback, dialect variations, and active listening information extraction quizzes. |
| **M5** | AERD & Sales Discovery Mastery | Modules 4, 5, 6 | Acknowledge/Empathy/Reassure/Defuse rubric, open-ended sales discovery questions, and consultative closing drills. |
| **M6** | Comprehensive Academy & 90-Day Adaptive System | Modules 7, 9, 10 | Billing explanation drills, practice KPI dashboard, and 90-day adaptive learning trajectory. |

---

## 🎯 Active Milestone: M1 — Voice Prototype & Inbound Greeting Simulator

### Scope & Acceptance Criteria:
1. **Inbound Call Turn Sequence**:
   - Call initiates -> Alex delivers standard greeting:
     *"Hello, thank you for calling AT&T. This is Alex. May I have your first and last name, please?"*
   - Once recognized, simulated customer (*David Miller*) responds with first-bill inquiry via TTS.
2. **Local-First Audio Engine**:
   - `NativeSpeechService` integrating Android `flutter_tts` and `speech_to_text`.
   - Explicit offline error handling and guidance when offline speech models are unavailable.
   - Clean lifecycle handling (cancellation, stop, silence timeouts, resource disposal).
3. **Evidence-Based Evaluation Engine**:
   - **Recognized-Text Similarity** (normalized Levenshtein edit distance).
   - **Token Error Rate (WER)** and semantic anchor verification (`att`, `alex`, `first`, `last`, `name`).
   - Estimated speech session pace (tokens per session minute).
   - Educational P/B contrast awareness reminders.
   - Zero claims of acoustic native pronunciation or official employer QA compliance.
4. **Bilingual Coaching Card**:
   - English transcript analysis + natural Egyptian Arabic trainer guidance.
5. **Local Offline Persistence**:
   - Attempt records saved to `SharedPreferences` with retry flow.
6. **Verification & Physical Smoke Test**:
   - Automated unit and widget tests passing.
   - Debug APK compilation verified.
   - Explicit physical Android device smoke-test checklist documented.

---

## 🔮 Subsequent Milestones (M2–M6)

Milestones M2 through M6 will be scheduled and executed sequentially following physical hardware validation and formal acceptance of M1.
