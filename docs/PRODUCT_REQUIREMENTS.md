# PRODUCT_REQUIREMENTS.md — Product Requirements Document (PRD)

## 1. Executive Summary

- **Product Name**: CALLFORGE (CallForge Voice Academy)
- **Target Audience**: Offshore Customer Service & Sales Representatives handling AT&T inbound voice queues (specifically at Sutherland Global Services, Egypt).
- **Core User Persona**: **Alex** (the designated agent professional alias).
- **Primary Objective**: Build supreme confidence, conversational mastery, call control, objection handling, and sales conversion through realistic spoken voice simulations.
- **Platform**: Flutter mobile application (Android-first).

---

## 2. Pedagogical Framework & Language Strategy

CALLFORGE employs a targeted dual-language cognitive architecture:
1. **Simulation Domain (Spoken & Auditory)**:  
   - **Language**: English (US) — `en-US`.
   - **Acoustic Characteristics**: Authentic American regional accents, natural conversational velocity (140–180 WPM), casual contractions ("gonna", "wanna", "I'd"), hesitation pauses, and varied emotional states (frustrated, confused, hurried, analytical).
2. **Coaching & Strategic Domain (Visual & Instructional)**:  
   - **Language**: Natural Egyptian Arabic (عربي مصري معاصر وسلس).
   - **Tone**: Direct, encouraging, tactical, and psychologically empathetic (like a veteran team lead sitting right next to Alex on the production floor).
   - **Examples**:
     - *"خد نفس، العميل متعصب من الفاتورة مش منك شخصياً. طبق قاعدة AERD فوراً."*
     - *"ركز في نطق حرف P في كلمة 'Plan' و 'Payment'. طلع هوا خفيف من شفايفك عشان العميل ميفهمهاش 'B'."*

---

## 3. Mandatory Protocol & Guardrails

- **Mandatory Inbound Greeting**:  
  > *"Hello, thank you for calling AT&T. This is Alex. May I have your first and last name, please?"*
- **AERD Framework**:
  - **A**cknowledge: Explicitly confirm hearing the customer's specific issue.
  - **E**mpathy: Genuine statement validating their emotional frustration.
  - **R**eassure: Clear declaration of personal ownership to solve the problem.
  - **D**efuse: Transition smoothly into actionable discovery without escalating tension.
- **Fictional Data & Compliance Guardrails**:
  - All names (e.g., "John Miller", "Sarah Jenkins"), account numbers (e.g., `902-555-0192`), billing balances, and device models are fictional.
  - Internal proprietary AT&T systems (e.g., internal billing engines or non-public tools) will never be emulated or stored.
  - Any missing carrier procedure is designated as `UNKNOWN [Training Context Only]`.

---

## 4. Detailed Specification of the 10 Training Modules

### Module 1: Real Voice Call Simulator
- **Description**: Full-duplex interactive voice role-playing engine. The simulated customer speaks via Android TTS; the agent listens, presses the mic, and speaks their response.
- **Key Features**:
  - Turn-based conversational state machine.
  - Realistic caller interruptions and pauses.
  - Multi-path branching: depending on Alex's tone and keywords, the customer's mood score shifts.

### Module 2: Disclosure Reading & Pronunciation Precision
- **Description**: Drill verbatim accuracy on mandatory legal disclosures (e.g., auto-pay terms, 36-month installment agreements, return window policies, and credit authorization).
- **Key Features**:
  - Word-by-word visual karaoke tracker.
  - Real-time detection of omitted words, inserted words, or phonetic ambiguities.
  - Dedicated **P vs. B Contrast Drill**: Focus on typical Arabic language transfer issues (e.g., "Price/Bice", "Payment/Bayment", "Paperless/Baperless", "Pro/Bro").

### Module 3: American English Listening & Speaking
- **Description**: Ear-training for fast-paced American speech, regional dialects (Southern, Midwestern, New York), slang, and background noise (car speakers, crying babies, barking dogs).
- **Key Features**:
  - Fast-speech comprehension quizzes.
  - Active listening drills: Extract customer names, phone numbers, and root problems from 20-second rambling caller monologues.

### Module 4: AERD and Call Control
- **Description**: Master the art of steering the call without interrupting the customer or letting them derail handling time.
- **Key Features**:
  - Dead air prevention: Drills for filling 5–10 second system pauses professionally (*"While my system loads your billing breakdown, Mr. Jenkins..."*).
  - Polite interruptions: Reclaiming the floor from chronically talking callers.
  - Real-time AERD scorecard for every response.

### Module 5: AT&T Product Knowledge (Training Context)
- **Description**: Understanding fiber tiers (300M, 500M, 1 GIG), unlimited wireless tiers, trade-in value ladders, and international roaming features (fictionalized training models).
- **Key Features**:
  - Feature-to-Benefit translation: Converting technical specs into tangible customer life improvements.
  - Plan comparison drills: Answering "Why is my bill higher than my neighbor's?"

### Module 6: Sales Discovery & Conversion
- **Description**: Moving from pure customer care to ethical, consultative sales generation.
- **Key Features**:
  - Discovery questions: *"How many devices stream simultaneously in your house during the evening?"*
  - Overcoming objections: Handling "I don't need it", "It's too expensive", or "I need to check with my spouse".
  - Assumptive and alternative closes.

### Module 7: Billing & Technical Troubleshooting
- **Description**: Deconstructing complex first-bill surprises, activation fees, proration, promotional credits lag (takes 2–3 billing cycles), and basic device troubleshooting (eSIM setup, network reset).
- **Key Features**:
  - Line-by-line bill explanation simulator.
  - Technical diagnostic call flows (no service, slow data, Wi-Fi calling issues).

### Module 8: Escalation & Angry Customers
- **Description**: High-stress de-escalation practice.
- **Key Features**:
  - Dealing with abusive, screaming, or demanding callers.
  - De-escalation matrix: Refusal of immediate supervisor transfer until minimum 2 de-escalation attempts are made in accordance with standard call center protocols.
  - Clear supervisor hand-off briefing generation.

### Module 9: KPI and Quality Tracking
- **Description**: Comprehensive analytics dashboard reflecting representative performance against standard BPO metrics.
- **Key Metrics Tracked**:
  - **AHT (Average Handling Time)**: Measuring conciseness and pace.
  - **FCR (First Call Resolution)**: Did Alex solve the issue without requiring repeat calls?
  - **QA Scorecard**: Adherence to greeting, verification, AERD, disclosure, and closing.
  - **Empathy Index**: Keyword and sentiment verification.

### Module 10: Adaptive 90-Day Learning System
- **Description**: Personalized curriculum guiding Alex from day 1 on the floor to elite representative rank.
- **Phases**:
  - **Days 1–30 (Nesting & Foundation)**: Flawless greeting, account verification, P/B pronunciation, basic billing explanations.
  - **Days 31–60 (Proficiency & Speed)**: Call control, AERD under pressure, AHT reduction, technical resets.
  - **Days 61–90 (Elite Sales & Escalation)**: Consultative selling, high-value trade-ins, de-escalating supervisor demands, advanced retention.

---

## 5. Technical & Non-Functional Requirements

- **Local-First & Offline**: Core drills must run without internet access using Android's offline STT/TTS engine.
- **Low Footprint**: App memory usage strictly controlled to operate smoothly on resource-constrained devices.
- **Zero Cost**: No third-party paid subscriptions (OpenAI, ElevenLabs, etc.) required for normal operation.
