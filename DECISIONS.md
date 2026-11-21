# DECISIONS.md — Architecture Decision Records (ADR)

This document records the key architectural, technical, and domain decisions made for CALLFORGE.

---

## ADR 001: Mobile Framework — Flutter Android-First

- **Status**: ACCEPTED
- **Context**: The user requires a personal, voice-first mobile training academy on Android. The development machine is a Windows PC with 8 GB RAM. The application must support smooth animations, responsive audio state visualizations, and cross-platform architecture while prioritizing Android hardware.
- **Decision**: Use Flutter (Dart 3.13+) targeting Android (API 24 to 37).
- **Consequences**:
  - Direct integration with native Android audio and speech APIs via platform channels.
  - Fast test execution via `flutter test` without needing an emulator or Docker.
  - Clean modular code layers (domain, data, presentation).

---

## ADR 002: Local-First Audio Pipeline & Real-World Recognizer Boundaries

- **Status**: ACCEPTED (UPDATED 2026-11-16)
- **Context**: User requires no mandatory paid APIs, no recurring subscriptions, and offline capability wherever practical.
- **Decision**:
  - **Speech-to-Text (STT)**: Use `speech_to_text` (wrapping Android `SpeechRecognizer`).
  - **Text-to-Speech (TTS)**: Use `flutter_tts` (wrapping Android `TextToSpeech` engine using installed high-quality `en-US` voice data).
- **Consequences**:
  - Zero recurring API fees or token expenses.
  - **Offline Reality**: TTS is fully offline. STT is offline **only** if the physical Android device has the Google Speech Services English (US) offline pack installed. If not installed and the device is offline, recognizer errors are caught and surfaced with explicit user instructions.
  - Mobile speech recognizers are turn-based (push-to-talk), not full-duplex continuous streams.

---

## ADR 003: Bilingual Pedagogical Framework (English Simulation + Egyptian Arabic Coaching)

- **Status**: ACCEPTED
- **Context**: The representative operates in an offshore environment (Sutherland in Egypt), handling American AT&T customer calls. Spoken English fluency, American colloquialisms, and fast-paced listening are critical. Simultaneously, psychological coaching, linguistic error analysis, and strategic reinforcement are most deeply internalized when delivered in natural Egyptian Arabic.
- **Decision**:
  - All simulated customer personas and representative spoken drills use **English (US)**.
  - All coaching cards, tips, grammatical/phonetic explanations, and de-escalation psychology use natural, motivational **Egyptian Arabic (عربي مصري)**.
- **Consequences**:
  - High emotional resonance, clear understanding of nuanced call center tactics.
  - Cultural bridging between Egyptian pronunciation patterns (e.g., P vs. B) and American customer expectations.

---

## ADR 004: Recognized-Text Similarity Integrity (No False Pronunciation or QA Claims)

- **Status**: ACCEPTED (UPDATED 2026-11-16)
- **Context**: An independent audit noted that evaluating transcribed text via Levenshtein distance measures *text recognition similarity*, NOT acoustic pronunciation precision, native accent, or employer QA compliance.
- **Decision**:
  - Never equate recognized-text similarity with acoustic pronunciation precision or native accent scoring.
  - Never label a simulated response as "QA Compliant" or claim employer certification.
  - Relabel all metrics to **Recognized-Text Similarity** and **Token Error Rate (WER)**.
  - Frame P/B contrast checks as educational learning awareness reminders, not laboratory phonetic diagnostics.
- **Consequences**:
  - Complete engineering honesty and pedagogical integrity.
  - Clear, auditable feedback that points to actual transcribed words without misleading claims.

---

## ADR 005: Low-RAM Development Optimization for Windows (8 GB)

- **Status**: ACCEPTED
- **Context**: The host development machine has 8 GB RAM. Running heavy Android emulators or Docker containers causes severe memory paging, freezing, and build failure.
- **Decision**:
  - No Android emulators or Docker containers.
  - Direct testing on physical Android devices via USB ADB or direct APK sideloading.
  - Gradle JVM max heap configured to `-Xmx2048m` in `android/gradle.properties`.
  - Flutter headless tests (`flutter test`) used for rapid inner-loop validation.
- **Consequences**:
  - Fast, stable developer workflow without system starvation.

---

## ADR 006: Compliance, Fictionalized Data, & Carrier Protection

- **Status**: ACCEPTED
- **Context**: The app trains representatives for AT&T scenarios, but must not violate proprietary information agreements, store customer PII, or present unverified training scripts as binding corporate policy.
- **Decision**:
  - All customer identities, telephone numbers, account balances, and addresses are strictly fictional.
  - Representative greeting is standardized to the user-confirmed script:
    *"Hello, thank you for calling AT&T. This is Alex. May I have your first and last name, please?"*
  - All plan details, promotions, and disclosure scripts are designated as `Training Context Only`. Missing or unverified procedures are marked `UNKNOWN` rather than hallucinated.
- **Consequences**:
  - 100% legal, compliance-safe, and risk-free for the user's professional employment.

---

## ADR 007: Inbound Simulation Turn Sequence (Agent Speaks First)

- **Status**: ACCEPTED (ADDED 2026-11-16)
- **Context**: In real-world customer service inbound queues, when a call arrives and connects, the representative delivers the mandatory opening greeting before the customer explains their inquiry. The initial M1 prototype inverted this sequence.
- **Decision**:
  - Turn 1: Call connects -> Alex speaks the mandatory greeting:
    *"Hello, thank you for calling AT&T. This is Alex. May I have your first and last name, please?"*
  - Turn 2: Once Alex's greeting is evaluated and target script is confirmed, the simulated customer responds via TTS:
    *"Hi Alex, my name is David Miller. I'm calling because I just opened my first bill and it's 40 dollars higher than what the rep in the retail store told me..."*
- **Consequences**:
  - High fidelity to real-world call center workflows.
  - Reinforces prompt, confident call opening habits.

---

## ADR 008: Explicit Source Provenance System

- **Status**: ACCEPTED (ADDED 2026-11-16)
- **Context**: Distinguish user-verified facts from operational reports, derived pedagogical materials, and fictional simulations.
- **Decision**: Every requirement and script is categorized under one of 6 provenance tiers (`[User-Confirmed Workflow]`, `[Official Public Verified Information]`, `[Work-Reported Information]`, `[Derived Training Material]`, `[Fictional / Simulation Only]`, `[UNKNOWN]`).
- **Consequences**:
  - Eliminates invented policies or hallucinated employer rules.


---

## ADR 009: Technical Milestone Architecture Reconciled with Original Charter (M0–M6)

- **Status**: ACCEPTED (ADDED 2026-11-21)
- **Context**: An independent audit noted that the project roadmap had drifted from the original training charter scope. Specifically, M3 was intended as the integrated floor care module (combining American English listening, AERD call control, billing breakdown, and customer de-escalation), M4 for Consultative Sales Mastery, M5 for Quality Tracking & 90-Day Adaptive System, and M6 for Optional Advanced On-Device Acoustic Research.
- **Decision**: Reconcile the technical milestone architecture directly with this charter:
  - **M0**: Foundation & Environment Verification
  - **M1**: Voice Prototype & Inbound Greeting Simulator
  - **M2**: Disclosure Reading & Pronunciation Precision (verbatim karaoke tracking & P/B phonetic awareness drills)
  - **M3**: Core Floor Care Simulator (Listening, AERD, Billing & De-escalation)
  - **M4**: Consultative Sales Mastery (Discovery, Value Bridging, Plan Upgrades)
  - **M5**: Quality Tracking & Adaptive 90-Day Learning System
  - **M6**: Advanced Voice Evaluation & Acoustic Research (Optional On-Device Extension)
- **Consequences**:
  - Direct traceability between pedagogical training modules and engineering deliverables.
  - Transparent release trajectory avoiding ad-hoc milestone proliferation.
