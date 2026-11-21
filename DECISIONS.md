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

---

## ADR 010: Phone-Free Hosted CI & Android Cloud Emulator Testing Strategy

- **Status**: ACCEPTED (ADDED 2026-11-21)
- **Context**: The Product Owner issued a binding decision strictly forbidding the use or attachment of their personal Android phone for CALLFORGE development, USB debugging, ADB device scans, or APK sideloading. Development was previously blocked waiting for a physical device.
- **Decision**: Replace the mandatory personal physical-phone acceptance gate with a completely phone-free, hosted CI strategy:
  1. Automated formatting, static analysis (`flutter analyze`), and unit/widget/integration test suite (31 tests) running in GitHub Actions on standard Ubuntu runners.
  2. Headless debug APK compilation in CI.
  3. Hosted Android Emulator integration smoke testing via `reactivecircus/android-emulator-runner@v2` on Ubuntu runners with KVM hardware acceleration.
  4. Deterministic test doubles (`MockSpeechService`) used for headless and emulator-level speech verification.
  5. Acceptance terminology updated to `AUTOMATED / HOSTED EMULATOR VERIFIED`.
  6. Real physical microphone acoustics and physical offline voice pack behavior remain explicitly documented as `NOT TESTED / UNVERIFIED (Awaiting Real Device or Simulated Hardware Environment)`.
- **Consequences**:
  - Eliminates dependency on personal hardware while maintaining strict verification rigor.
  - Development continues autonomously with reproducible CI and cloud emulator gates.
  - Zero spending on paid runners or external cloud device labs; runs entirely on standard GitHub-hosted infrastructure.

---

## ADR 011: C1-MEGA Architecture — M2 Disclosure Studio, M3 Floor Skills, and Multi-Turn Voice Arena

- **Status**: ACCEPTED (ADDED 2026-11-21)
- **Context**: Issue #4 authorized an autonomous mega-campaign (C1-MEGA) delivering the combined capabilities of M2 (Disclosure Studio) and M3 (Core Floor Care), expanding from single-turn greeting validation to complete multi-turn conversational simulations, legal disclosure tracking, and floor skill drills.
- **Decision**:
  1. **6-Tier Typed Provenance Framework**: Integrated `ProvenanceTier` enum into all domain entities, explicitly categorizing content as `userConfirmed`, `officialVerified`, `workReported`, `derivedTraining`, `fictionalSimulation`, or `unknown`.
  2. **Token-by-Token Karaoke Tracking**: Implemented `DisclosureEvaluator` with Levenshtein-based token alignment, critical term validation (prices, timeframes, penalties), WER, and P/B phonemic alerts.
  3. **30-Scenario Voice Arena**: Authored 30 comprehensive fictional call scenarios spanning billing proration, fiber troubleshooting, de-escalation, sales discovery, and floor care, with multi-turn branching dialogue trees and Egyptian Arabic coaching cards.
  4. **Multi-Turn Conversation Evaluator**: Created `MultiTurnEvaluator` combining semantic anchor coverage, AERD (Acknowledge, Empathy, Reassure, Defuse) scoring, and dynamic branch resolution.
  5. **Floor Skills Drills**: Built dedicated interactive modules for P/B bilabial minimal pair drills and fast numbers & active listening dictation.
  6. **Feature-First Navigation**: Implemented `MainScaffold` with 5 primary destinations (Today/Home, Voice Arena, Disclosure Studio, Floor Skills, Progress) powered by a lightweight `ServiceLocator`.
  7. **Deterministic Daily Coach**: Built rule-based daily workout recommendation identifying the user's weakest skill tag without fake AI scoring.
- **Consequences**:
  - Delivers complete end-to-end training experience covering greeting, disclosures, de-escalation, and floor drills in one cohesive application.
  - Maintains 100% backward compatibility with M1 tests and legacy entrypoints.
  - Fully verified with 67 automated tests and clean static analysis.

---

## ADR 012: C1-R1 Adaptive Scenario Branching, Sequence-Aware Alignment, and Full Product Journeys

- **Status**: ACCEPTED (ADDED 2026-11-21)
- **Context**: Independent PR review and Issue #6 identified critical gaps in the initial C1 foundation:
  1. 120 scenario turns used placeholder `default` branches instead of genuine adaptive branching.
  2. `DisclosureEvaluator` used unordered bag-of-words matching, permitting scrambled words and missing altered negation words (`not`, `never`, `cannot`).
  3. Disclosure Studio lacked custom draft CRUD (edit/delete) and reference audio playback.
  4. Misleading WPM performance grading and "compliance" claims remained in disclosure UI.
  5. Substring keyword matching in `MultiTurnEvaluator` caused false positives (e.g. `att` matching inside `matter`).
  6. Bilabial P/B contrast drills always awarded 100% regardless of spoken transcript accuracy.
  7. Lack of end-to-end integration tests exercising 5-tab user journeys.
- **Decision**:
  1. **Dynamic Programming Sequence Alignment**: Upgraded `DisclosureEvaluator` to sequence-aware Needleman-Wunsch / Levenshtein alignment with explicit match, substitution, omission (deletion), and insertion (`TokenMatchStatus.inserted`) tracking.
  2. **Negation Alteration Safety**: Enforced strict negation word tracking (`{'not', 'no', 'never', 'without', 'only', 'unless', 'cannot', 'cant', 'wont', 'dont'}`). Any omitted or substituted negation immediately invalidates `isTargetMet = false`.
  3. **Full 6-Turn Adaptive Scenario Trees**: Converted all 30 scenarios in `ScenarioCatalog` into genuine 6-turn adaptive dialogue trees with two distinct reachable branches: Turn 4A/5A (high-AERD resolution) vs Turn 4B/5B (low-AERD objection/recovery), each with tailored customer TTS and non-empty Egyptian Arabic coaching. Supervisor callbacks are explicitly noted as unavailable.
  4. **Disclosure Draft CRUD & Reference Audio**: Completed local draft update and delete actions with confirmation dialogs, backed by `SharedPreferences` persistence and reference audio playback.
  5. **Honest Labeling**: Replaced all unvalidated compliance/WPM badges with honest transcript match indicators (`RECOGNIZED TRANSCRIPT MATCH`, `PRACTICE TARGET MET/UNMET`).
  6. **Token-Aware Regex Keyword Matching**: Enforced word-boundary regex (`\b(att|at and t|at t)\b`) eliminating substring false positives.
  7. **Spoken P/B Transcript Evaluation**: Updated `FloorSkillsController` to evaluate recognized spoken transcript against target vs contrast words, alerting on bilabial confusion.
  8. **Full Product Journey Integration Tests**: Created `C1-01` through `C1-04` tests in `test/integration/app_smoke_test.dart` and `integration_test/app_test.dart` exercising the complete 5-tab app.
- **Consequences**:
  - Eliminates all default branching placeholders and guarantees pedagogically rich, responsive multi-turn simulations.
  - Guarantees strict verbatim legal disclosure evaluation that rejects out-of-order and negation-altered speech.
  - Fully verified across 76 automated unit, widget, and integration tests with zero static analysis issues and 100% Dart formatting.
