# CALLFORGE — Voice-First Flutter Academy for AT&T CS & Sales

CALLFORGE is a personal, voice-first Flutter Android training academy specifically designed for an AT&T Customer Service & Sales Representative (working through Sutherland in Egypt, using the mandatory professional agent alias **Alex**).

The purpose of CALLFORGE is to build conversational fluency, call steering, consultative sales confidence, and standard script discipline through structured spoken practice drills, dual-language coaching, and local progress tracking.

---

## 🧭 Source Provenance & Governance Framework

To maintain complete truth in engineering and avoid presenting simulated exercises as corporate policy, all requirements, scripts, and domain logic in CALLFORGE adhere to explicit provenance tiers:

| Tier | Category | Description & Scope in CALLFORGE |
| :--- | :--- | :--- |
| **P-1** | `[User-Confirmed Workflow]` | Verified representative workflow: Agent alias **Alex**, inbound opening greeting, Sutherland offshore call center context, Android-first priority, Windows 8 GB RAM local development constraint. |
| **P-2** | `[Official Public Verified Information]` | Public technical facts: Flutter SDK capabilities, Android SDK 34–37 APIs, Google `SpeechRecognizer` and `TextToSpeech` platform channels, Gradle heap configurations. |
| **P-3** | `[Work-Reported Information]` | Operational observations reported from representative floor experience: Supervisor callbacks are **not** available in the user's specific process; other authorized escalation paths remain `UNKNOWN [Training Context Only]`. |
| **P-4** | `[Derived Training Material]` | Educational methodologies developed for skill building: AERD framework exercises, Egyptian Arabic trainer coaching prompts, P/B phonemic contrast educational drills. |
| **P-5** | `[Fictional / Simulation Only]` | All customer profiles (*e.g., David Miller*), account numbers (*e.g., 902-555-0192*), promotional offers, and dollar balances are strictly fictional simulations. |
| **P-6** | `[UNKNOWN]` | Any employer policy, mandatory carrier script, pricing matrix, or proprietary tool not officially verified is marked `UNKNOWN` rather than invented. |

---

## 🎯 Core Operating Principles & Voice Truth

- **Turn-Based Spoken Simulation (Push-to-Talk)**: Simulated calls operate in discrete audio turns. Inbound calls initiate with the representative's mandatory greeting, followed by customer audio responses. The interaction is half-duplex (push-to-talk / tap-to-speak), not full-duplex.
- **Conditional Voice Engine (Online & Offline Realities)**:
  - Android Text-to-Speech (`flutter_tts`) runs locally via native Android TTS voices (`en-US`).
  - Android Speech-to-Text (`speech_to_text` wrapping `android.speech.SpeechRecognizer`) operates offline **only** if the user's physical Android device has the English (US) offline speech package pre-installed in Google Speech Services. Otherwise, network connectivity is required by the Android operating system.
- **Evidence-Based Evaluation (No Fabricated Metrics)**:
  - Transcribed speech is compared against target scripts using **Recognized-Text Similarity** (normalized Levenshtein distance) and **Token Error Rate (WER)**.
  - CALLFORGE measures text match against reference strings. It **does not** claim to measure acoustic native accent percentages, acoustic formant accuracy, or official employer QA compliance.
  - P/B contrast drills flag recognized text substitutions as awareness prompts; they do not claim laboratory acoustic phoneme detection.
- **Dual-Language Architecture**:
  - **Spoken Practice & Customer Audio**: English (US) (`en-US`).
  - **Coaching & Strategic Explanations**: Natural Egyptian Arabic (عربي مصري معاصر) for deep pedagogical comprehension.

---

## 📚 10 Core Pedagogical Training Modules

The CALLFORGE training curriculum covers 10 targeted operational competencies:

1. **Real Voice Call Simulator**: Interactive spoken turn-by-turn scenarios with realistic caller personas.
2. **Disclosure Reading & Pronunciation Precision**: Verbatim accuracy drills for legal disclosures and P/B contrast awareness.
3. **American English Listening & Speaking**: Fast speech comprehension, dialect variations, and ear-training.
4. **AERD & Call Control**: Systematic execution of Acknowledge, Empathy, Reassure, and Defuse without dead air.
5. **AT&T Product Knowledge (Training Context)**: Fictionalized practice models for fiber, unlimited wireless tiers, and device installments.
6. **Sales Discovery & Conversion**: Consultative open-ended questions, value bridging, and objection handling.
7. **Billing & Technical Troubleshooting**: Deconstructing bill confusion, proration explanations, and device troubleshooting.
8. **Escalation & Angry Customers**: Composure under pressure, de-escalation drills, and authorized transfer etiquette.
9. **KPI & Quality Tracking**: Average handling pace awareness, resolution tracking, and practice scorecards.
10. **Adaptive 90-Day Learning System**: Structured day-by-day practice progression from onboarding to elite mastery.

---

## 🗺️ Engineering Release Strategy (M0–M6)

Technical deliverables are organized into 7 structured milestones:

- **M0: Foundation & Environment Verification**: Toolchains, low-RAM Gradle tuning, governance, and source provenance.
- **M1: Voice Prototype & Inbound Greeting Simulator**: Core turn-by-turn greeting loop (Alex speaks first, customer responds), TTS/STT lifecycle, text similarity scoring, Egyptian Arabic coaching, local attempt persistence, and Android physical smoke checklist.
- **M2: Disclosure Reading & Pronunciation Precision**: Verbatim karaoke tracking and P/B phonemic contrast drill suite.
- **M3: Interactive Multi-Turn Simulator & Branching Flows**: Dynamic multi-turn customer dialogues with caller sentiment shifts.
- **M4: Listening, Fluency & Dialect Comprehension**: Fast-paced American audio listening quizzes and active listening extraction.
- **M5: AERD & Sales Discovery Mastery**: Structured call control, de-escalation practice, and consultative sales roleplay.
- **M6: Comprehensive Academy & 90-Day Adaptive System**: Advanced billing simulations, comprehensive practice dashboards, and full 90-day trajectory.

---

## 🛠️ Technical Specifications & Local Constraints

- **Platform**: Flutter (Android-first).
- **Minimum Android SDK**: API 24 (Android 7.0).
- **Target Android SDK**: API 34–37.
- **Host Development Environment**: Windows 10/11 x64, 8 GB RAM (optimized Gradle heap `-Xmx2048m`, zero emulators/Docker).
- **Dependencies**: Local-first (`speech_to_text`, `flutter_tts`, `shared_preferences`, `permission_handler`). Zero mandatory paid cloud APIs or recurring subscriptions.

---

## 🚀 Getting Started

```bash
# Clone repository
git clone https://github.com/abuhmaid28/callforge-voice-academy.git
cd callforge-voice-academy

# Install dependencies
flutter pub get

# Run test suite
flutter test

# Build debug APK for Android
flutter build apk --debug
```

---

## 🛡️ Disclaimers & Compliance

CALLFORGE is an independent educational training tool built for personal skill enhancement. It is not affiliated with, sponsored by, or an official product of AT&T Inc. or Sutherland Global Services. All customer accounts, telephone numbers, and scenarios are strictly fictional.
