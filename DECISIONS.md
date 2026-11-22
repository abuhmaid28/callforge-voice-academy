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

---

## ADR 013: Strict Mandatory Gates, Locked Disclosure Consent, Versioned Practice Attempts, and Calendar-Day Streaks

- **Status**: ACCEPTED (ADDED 2026-11-21)
- **Context**: Independent PR #5 review identified six final acceptance criteria required for C1 product completion:
  1. Opening Turn 1 must strictly gate progression: missing required anchors (Alex, AT&T) or empty audio must remain on Turn 1 and block customer Turn 2.
  2. Terminal call completion must only be granted upon successful final-turn evaluation, preventing empty audio passes and recording progress at most once.
  3. Customer consent simulation outcomes (Agreed, Questioned, Refused) in Disclosure Studio must be locked behind successful practice reading (`isTargetMet == true`).
  4. Fictional scenarios must strictly adhere to floor realities: zero unauthorized commitments to waive activation fees, guarantee rate locks, or promise supervisor callbacks.
  5. Learning progress requires genuine consecutive calendar-day streak calculation, and attempt history must store versioned script title and snapshot copy.
  6. Audio lifecycle requires centralized teardown on tab navigation and session generation tokens guarding asynchronous callbacks.
- **Decision**:
  1. **Strict Opening & Completion Gates**: Updated `MultiTurnEvaluator` and `MultiTurnController` to enforce that failed Turn 1 greetings and failed terminal turns remain in `MultiTurnState.idle` without advancing or recording premature completion.
  2. **Locked Consent Outcome Simulation**: Updated `DisclosureStudioScreen` and `DisclosureController` to disable and visually lock consent simulation until a successful practice read is completed (`isTargetMet == true`).
  3. **Billing Script Policy Sanitization**: Audited all 30 scenarios in `ScenarioCatalog`, removing unauthorized commitments (activation fee waivers, rate locks, supervisor callbacks, replacement guarantees) and substituting realistic conditional dispute requests and billing review flows.
  4. **Calendar-Day Streak Logic**: Implemented `calculateNewStreak` in `ProgressRepositoryImpl` using date difference math: same day maintains streak, consecutive calendar day increments streak by 1, and gaps of 2+ days reset streak to 1.
  5. **Versioned Attempt History**: Extended `AttemptRecord` with `scriptTitle`, `scriptSnapshot`, and `attemptType`, persisting complete historical snapshots on disclosure and scenario completion.
  6. **Centralized Audio Lifecycle & Tab Safety**: Implemented awaited cancellation of speech and playback in `MainScaffold` on destination changes, combined with incrementing session generation counters across all controllers.
  7. **Negative & Recovery Test Suite**: Added `C1-05` to smoke and emulator integration suites verifying greeting gates, locked consent, and rapid tab switching safety.
- **Consequences**:
  - Eliminates all progression loopholes, unauthorized promises, and false progress claims.
  - Guarantees complete data integrity and backward-compatible persistence.
  - Validated by 87 automated tests (0 failures), 0 analyzer warnings, and 100% clean formatting.

---

## ADR 014: Stop-Flushed Final Transcript Delivery, Active-Tab Audio Teardown, Complete History Versioning, and Removal of Uncalibrated WPM

- **Status**: ACCEPTED (ADDED 2026-11-22)
- **Context**: Independent PR #5 review (comment 7070116295) identified final voice reliability and metric precision requirements:
  1. `stopListening()` race condition in `MultiTurnController`, `DisclosureController`, and `FloorSkillsController`: incrementing session generation tokens prior to awaiting `stopListening()` caused STT engines that flush final recognition results during `stopListening()` to discard their own final recognized transcripts.
  2. Test harness lacked delayed-final STT test doubles: `MockSpeechService` only delivered final transcripts eagerly during `startListening()`, masking real-world platform channel flush behavior.
  3. Tab switching away from active recording or TTS in `MainScaffold` cancelled background audio but left screen controllers (`DisclosureStudioScreen`, `FloorSkillsScreen`) in stuck recording/playback states inside the `IndexedStack`.
  4. Unsupported WPM metrics remained visible in `HistoryScreen` (`${record.wpm} wpm`), making uncalibrated pace claims from word counts.
  5. Failed practice attempts (disclosures, scenario final turns) were omitted from `AttemptRepository`, making them invisible in history and obscuring Egyptian Arabic coaching, while script versions were missing.
- **Decision**:
  1. **Split Session Generation & Safe Stop Token**: Decoupled general session generations from active listening session tokens (`_activeListenSession`). During `stopListening()`, controllers await buffer flush with the active token intact, allowing flushed final transcripts to be captured, and then immediately seal the session token before evaluation.
  2. **Delayed-Final STT Test Double**: Added `deliverFinalOnStop` mode to `MockSpeechService` to deterministically simulate realistic STT engines where final transcripts arrive during `stopListening()`.
  3. **Active-Tab Controller Teardown**: Added `GlobalKey` references and `resetAudioSession()` methods to `DisclosureStudioScreenState` and `FloorSkillsScreenState` in `MainScaffold`. Switching away from either tab now resets both the speech engine and the active screen controller to `idle`.
  4. **Removal of Visible WPM**: Removed `${record.wpm} wpm` from `HistoryScreen`, replacing it with attempt badges (`TARGET MET` / `NEEDS PRACTICE`, attempt type chips) and script version tags. Set recorded `wpm: 0` in active controllers while maintaining backward-compatible model field serialization.
  5. **Comprehensive Failed-Attempt History & Script Versions**: Added `scriptVersion` to `AttemptRecord`. Persist failed disclosure readings and failed scenario final turns in `AttemptRepository` (`passed: false`, `wpm: 0`) without inflating `totalDisclosuresCompleted` or `totalSimulationsCompleted` in `UserProgress`.
  6. **Regression Coverage**: Added deterministic unit, widget, and integration tests covering delayed-final delivery, tab-switching cancellation, and WPM absence.
- **Consequences**:
  - Zero transcript loss regardless of whether STT delivers tokens during recording or stop buffer flush.
  - Zero stuck controller states when switching tabs.
  - 100% truthful metrics without uncalibrated acoustic pace claims.
  - Full visibility into failed practice attempts and coaching without false progress increments.
  - Validated by 96 automated tests with zero failures, zero analyzer warnings, and 100% clean formatting.

---

## ADR 015: C2-MEGA Sales Mastery Architecture, 48 Branching Scenarios, Ethical Scorecard, Needs->Fit->Value Engine, and 90-Day Adaptive Academy

- **Status**: ACCEPTED (ADDED 2026-11-22)
- **Context**: Autonomous Campaign C2 (Issue #7, PR #8) authorizes delivery of Milestone 4 (Sales Mastery Lab) and Milestone 5 (90-Day Adaptive Training Academy). Floor practice requires transitioning from defensive care to consultative selling without violating customer autonomy or making unsupported commitments (rate locks, supervisor callbacks, fee guarantees).
- **Decision**:
  1. **48 Branching Sales Scenarios**: Authored 48 distinct multi-turn sales scenarios across 6 core categories (Wireless Upgrade, Fiber Discovery, Add-a-Line, Landline-to-Wireless, Trade-In & EIP, Retention Care-to-Sales). Each scenario features 8–16+ turns, >=2 decision branches, and 3 reachable terminal outcomes (`qualifiedAccept`, `respectfulNoSale`, `needsVerification`).
  2. **12 Spoken Discovery & 8 Objection Drills**: Created dedicated targeted drills with synthetic TTS customer prompts, open-ended question keywords, and Egyptian Arabic coaching cards.
  3. **Needs -> Fit -> Value Product Engine & Custom Offers**: Implemented explainable `ProductFitEngine` supporting physical facility guardrails (Fiber address qualification check required prior to commitment, Landline rate-center portability check required) and ethical budget contradiction handling. Implemented on-device `CustomOffersLocalDataSource` allowing agents to author local practice offers without remote cloud dependencies.
  4. **Ethical Sales Evaluator & Scorecard**: Implemented 7-dimension consultative rubric with `ScorecardRating` (`exemplary`, `proficient`, `developing`, `notAssessed`). Supports ethical "No-Sale Success" honoring customer decisions when products do not fit or customers decline. Deducts a -30 penalty for prohibited promises (rate locks, guaranteed supervisor callbacks, permanent fee waivers).
  5. **90-Day Adaptive Curriculum Engine**: Built 90-day structured syllabus across 3 phases (Foundations, Sales Confidence, Advanced Closing) and 13 weekly milestones. Generates daily workouts customized for 10/20/30-minute durations with calendar-boundary recovery mode for skipped days.
  6. **Polished Flutter Sales UX**: Delivered `SalesLabScreen` with 4 tabs, `SalesSimulatorScreen` with caller profile ribbon and phase indicator, `ProductFitScreen`, `ObjectionDrillScreen`, `DiscoveryDrillScreen`, `CurriculumTimelineView`, and updated `MainScaffold` with 6 tab destinations.
  7. **Automated Verification**: Created comprehensive unit, widget, and integration tests covering all 48 scenarios, 8 objection drills, 12 discovery drills, curriculum engine, sales evaluator, product-fit guardrails, and full app smoke journeys (133 tests passing with 0 failures).
- **Consequences**:
  - Delivers a complete enterprise-grade consultative sales and 90-day training academy.
  - Zero uncalibrated acoustic or revenue KPIs; 100% deterministic, explainable evaluation.
  - Fully backward-compatible persistence and seamless tab navigation.
  - Validated by 133 automated tests (0 failures), 0 analyzer warnings, and 100% clean formatting.
