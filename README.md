# CALLFORGE — Voice-First Flutter Academy for AT&T CS & Sales

CALLFORGE is an autonomous, voice-first Flutter Android training academy specifically engineered for an AT&T Customer Service & Sales Representative (working through Sutherland, using required agent alias **Alex**).

The mission of CALLFORGE is to transform the representative into a confident, highly skilled, top-tier performer through high-fidelity, evidence-based spoken call simulations, pronunciation mastery, real-time call control coaching, and systematic sales conversion drills.

---

## 🎯 Core Product Mission & Philosophy

- **Target User**: AT&T Customer Service & Sales Representative (Sutherland partner operations).
- **Mandatory Agent Alias**: `Alex`
- **Standard Inbound Greeting**:  
  > *"Hello, thank you for calling AT&T. This is Alex. May I have your first and last name, please?"*
- **Pedagogical Dual-Language Approach**:
  - **Spoken Practice & Customer Persona**: Native American English (en-US) simulation with authentic pacing, colloquialisms, rate-of-speech variations, and caller emotion.
  - **Coaching & Strategic Explanations**: Natural Egyptian Arabic (عربي مصري) for actionable psychological insights, dialect coaching, and empathetic motivation.
- **Evidence-Based Feedback**: No fabricated pronunciation algorithms or synthetic percentages without phonetic grounding. Rigorous comparison against phonetic anchors (such as Egyptian Arabic P vs. B phonemic contrast drills), disclosure precision, acoustic timing, and AERD compliance.
- **Privacy & Compliance**: Fictionalized customer profiles and simulated data only. Never stores real customer PII or confidential proprietary client data. All mock plans and promotions are labeled as simulation training contexts, never official carrier binding policies.

---

## 📚 10 Core Training Modules

1. **Real Voice Call Simulator**: Interactive, multi-turn inbound call flows with dynamic customer personas (frustrated, inquiring, upgrading, canceling).
2. **Disclosure Reading & Pronunciation Precision**: Strict timing, verbatim accuracy, and phoneme contrast training (especially P vs. B distinctions for Arabic speakers).
3. **American English Listening & Speaking**: Dialect comprehension, active listening, handling fast speech, colloquial contractions, and background noise.
4. **AERD & Call Control**: Systematic execution of **A**cknowledge, **E**mpathy, **R**eassure, and **D**efuse while maintaining call steering and avoiding dead air.
5. **AT&T Product Knowledge**: Fictionalized representations of fiber tiers, unlimited wireless plans, equipment installment plans, trade-ins, and add-on services (*all marked as training simulations*).
6. **Sales Discovery & Conversion**: Open-ended discovery questions, value bridging, identifying unmet needs, and confident closing without high-pressure tactics.
7. **Billing & Technical Troubleshooting**: De-escalating bill confusion, explaining proration, one-time fees, equipment cycles, and network restarts.
8. **Escalation & Angry Customers**: Managing de-escalation pyramids, supervisor call transfer protocol, and maintaining composure under high stress.
9. **KPI & Quality Tracking**: Scoring Average Handling Time (AHT) awareness, First Call Resolution (FCR), QA scorecard compliance, and empathy indices.
10. **Adaptive 90-Day Learning System**: Structured day-by-day progression tracking from nesting/onboarding to veteran master representative status.

---

## 🛠️ Technical Specifications & Constraints

- **Platform**: Flutter (Android-first).
- **Target Device**: Physical Android phone via USB debugging / direct APK deployment. (Windows PC development environment with 8 GB RAM; avoiding heavy emulators and Docker).
- **Voice Stack**:
  - Local-first Android Speech-to-Text (`speech_to_text`) utilizing Google Voice Recognition engines.
  - Local Android Text-to-Speech (`flutter_tts`) configured with `en-US` locale voices.
  - Zero mandatory paid API subscriptions; completely offline-functional where practical.
- **Local Persistence**: Embedded SQLite / Hive / SharedPreferences for offline progress tracking, scenario completion records, and performance analytics.

---

## 📂 Repository Architecture

```text
callforge-voice-academy/
├── AGENTS.md                  # Autonomous agent roles and development contracts
├── PROJECT_STATE.md           # Real-time state of features, tests, and milestones
├── DECISIONS.md               # Architecture Decision Records (ADRs)
├── README.md                  # Project overview and quickstart
├── docs/
│   ├── PRODUCT_REQUIREMENTS.md # Exhaustive PRD for all 10 modules
│   ├── ARCHITECTURE.md        # Technical architecture, audio pipeline & state
│   ├── VOICE_STRATEGY.md       # STT/TTS pipeline, phonetic contrasts & NLP logic
│   ├── ROADMAP.md             # Milestones M1 through M10
│   └── QA_ACCEPTANCE.md       # Quality gates, test criteria, and verification
├── lib/                       # Flutter production source code
└── test/                      # Unit, widget, and integration tests
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.47+ (Dart 3.13+)
- Android SDK 36+ with command-line tools & platform tools
- Java OpenJDK 25 (bundled with Android Studio)
- Windows 10/11 x64 (8 GB RAM environment optimized)

### Setup & Run
```bash
# Clone repository
git clone https://github.com/abuhmaid28/callforge-voice-academy.git
cd callforge-voice-academy

# Install dependencies
flutter pub get

# Run tests
flutter test

# Build debug APK for Android
flutter build apk --debug
```

---

## 🛡️ License & Disclaimers

CALLFORGE is an independent training tool built for educational and personal skill development purposes. It is not an official product of AT&T Inc. or Sutherland Global Services. All account profiles, customer dialogues, and scenarios are strictly fictional.
