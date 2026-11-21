# PRODUCT_REQUIREMENTS.md — Product Requirements Document (PRD)

## 1. Executive Summary & Source Provenance

- **Product Name**: CALLFORGE (CallForge Voice Academy)
- **Target Audience**: Offshore Customer Service & Sales Representatives handling AT&T inbound queues (specifically at Sutherland Global Services, Egypt).
- **Core User Persona**: **Alex** `[User-Confirmed Workflow]`.
- **Primary Objective**: Build conversational confidence, call steering, consultative sales discovery, and mandatory script adherence through structured spoken voice practice.
- **Platform**: Flutter mobile application (Android-first) `[User-Confirmed Workflow]`.

### Source Provenance Legend:
- `[User-Confirmed Workflow]`: Verified directly by user.
- `[Official Public Verified Information]`: Verifiable via official documentation.
- `[Work-Reported Information]`: Reported from operational floor practice.
- `[Derived Training Material]`: Instructional design created for skill building.
- `[Fictional / Simulation Only]`: Simulated scenario context.
- `[UNKNOWN]`: Missing policy or technical detail.

---

## 2. Voice Simulation Reality & Technical Boundaries

1. **Simulation Model**:
   - **Mode**: Push-to-Talk / Tap-to-Speak turn-based roleplaying `[Technical Fact]`. (The system is **not** full-duplex continuous open-mic).
   - **Turn Sequence**: For inbound calls, the representative **Alex** initiates the turn with the mandatory opening greeting upon call arrival. Once recognized and evaluated, the simulated customer responds via Text-to-Speech `[Derived Training Material]`.
2. **Audio Stack & Availability**:
   - **TTS**: Native Android `TextToSpeech` (`en-US`) `[Official Public Verified Information]`.
   - **STT**: Native Android `SpeechRecognizer` (`en_US`) `[Official Public Verified Information]`.
   - **Offline Realities**: Offline STT is **conditional** on the physical Android device having the Google Speech Services English (US) offline model pre-installed. When offline and without the local model, the Android recognizer will report an error; the app must catch this and display clear user instructions `[Official Public Verified Information]`.

---

## 3. Mandatory Protocol & Guardrails

- **Mandatory Inbound Greeting** `[User-Confirmed Workflow]`:
  > *"Hello, thank you for calling AT&T. This is Alex. May I have your first and last name, please?"*
- **AERD Framework** `[Derived Training Material]`:
  - **A**cknowledge: Explicitly confirm hearing the caller's concern.
  - **E**mpathy: Validate customer frustration without accepting legal liability.
  - **R**eassure: State personal ownership to assist.
  - **D**efuse: Transition smoothly into discovery questions.
- **Escalation Realities & Boundaries**:
  - In the user's specific operational process, **supervisor callbacks are not available** `[Work-Reported Information]`.
  - Authorized supervisor transfer mechanisms (e.g. warm transfers, internal support desks) remain `UNKNOWN [Training Context Only]`.
  - CALLFORGE **does not** mandate arbitrary de-escalation quotas (such as forcing exactly two de-escalation attempts before a transfer) because employer policies vary and are not verified.
- **Fictional Data & Compliance Guardrails** `[Fictional / Simulation Only]`:
  - All customer identities (*e.g., David Miller*), account numbers (*e.g., 902-555-0192*), bill balances, and device models are strictly fictional simulations.
  - Fictional billing examples (*e.g., promotional credit timing*) are training drills, not binding carrier policy.
  - Proprietary AT&T tools, intranet systems, or confidential employer documentation are never stored or simulated.

---

## 4. Specification of the 10 Pedagogical Training Modules

### Module 1: Real Voice Call Simulator
- **Focus**: Turn-based interactive voice roleplay.
- **Simulation Flow**: Alex speaks opening greeting -> Customer responds via TTS -> Alex executes AERD discovery -> Turn progression.
- **Evaluation**: Recognized-text similarity and mandatory semantic anchor verification.

### Module 2: Disclosure Reading & Pronunciation Precision
- **Focus**: Verbatim delivery of mandatory legal disclosures and phonemic awareness drills.
- **Components**:
  - Verbatim text comparison against target disclosure scripts.
  - P/B Phonemic Contrast Learning Drills (educational awareness for Arabic speakers regarding `/p/` vs `/b/` confusion pairs like *plan/blan*, *payment/bayment*). Note: Evaluated via text recognition heuristics, not laboratory acoustic analysis.

### Module 3: American English Listening & Speaking
- **Focus**: Comprehending American conversational velocity, idioms, and caller emotional states.
- **Components**: Listening comprehension drills, active listening extraction (capturing customer name, phone number, issue from customer audio prompt).

### Module 4: AERD and Call Control
- **Focus**: De-escalating tense calls and preventing dead air.
- **Components**: Acknowledge/Empathy/Reassure/Defuse verification, professional filler phrases during system lookup pauses.

### Module 5: AT&T Product Knowledge (Training Context)
- **Focus**: Understanding wireless plans, fiber broadband tiers, and trade-in concepts (*all modeled as fictional training constructs* `[Fictional / Simulation Only]`).
- **Components**: Feature-to-benefit translation exercises.

### Module 6: Sales Discovery & Conversion
- **Focus**: Transitioning customer service calls into consultative sales opportunities.
- **Components**: Asking open-ended discovery questions, value bridging, and ethical closing.

### Module 7: Billing & Technical Troubleshooting
- **Focus**: Deconstructing customer billing questions (e.g., first bill proration, activation fees) and basic device troubleshooting (e.g., restart, network reset).
- **Status**: All billing values are fictional simulations `[Fictional / Simulation Only]`.

### Module 8: Escalation & Angry Customers
- **Focus**: Maintaining emotional composure under high stress.
- **Components**: De-escalation language, handling abusive language professionally, and authorized transfer etiquette (`[UNKNOWN]` proprietary policies omitted).

### Module 9: KPI and Quality Tracking
- **Focus**: Developing personal awareness of standard call center metrics (Average Handling Time awareness, First Call Resolution mindset, practice script compliance).
- **Status**: Practice tracking only; not official employer QA certification.

### Module 10: Adaptive 90-Day Learning System
- **Focus**: Structured curriculum guiding Alex through 90 days of progressive practice from onboarding to veteran confidence.

---

## 5. Non-Functional & Operational Requirements

- **Local-First**: Core drills run locally on device with zero required cloud subscriptions or token costs.
- **Hardware Optimization**: Runs smoothly on low-memory physical Android devices without requiring heavy emulation.
- **Truth in Evaluation**: All scoring reflects recognized-text similarity, never fabricated acoustic metrics or official QA compliance certifications.
