# ROADMAP.md — Technical Release Milestones (M0–M6)

This document defines the technical release milestones for CALLFORGE (M0 through M6), reconciling the technical architecture directly with the original training academy charter while preserving all 10 pedagogical training modules.

---

## 🗺️ Reconciled Milestone Architecture (M0–M6)

| Milestone | Target Scope | Associated Academy Modules | Status | Core Deliverables |
| :--- | :--- | :--- | :--- | :--- |
| **M0** | Foundation & Environment Verification | Governance & Architecture | `COMPLETED` | Environment verification, Windows 8 GB RAM tuning (`-Xmx2048m`), Android SDK setup, source provenance framework. |
| **M1** | Voice Prototype & Inbound Greeting Simulator | Module 1 (Turn 1 Opening) | `COMPLETED` | Approved & merged to `main` at `40f2c0438c415b53b961d353a7c67b62494266a0`. Turn-based greeting loop, token-aware anchors, session generation guards, CI. |
| **M2** | Disclosure Reading & Pronunciation Precision | Module 2 | `IMPLEMENTED (C1-R1)` | 6 fictional disclosure scripts, DP sequence alignment, negation alteration check, critical terms validation, simulated consent outcomes, draft CRUD, reference audio. |
| **M3** | Core Floor Care Simulator (Listening, AERD & Billing) | Modules 1, 3, 4, 7, 8 | `IMPLEMENTED (C1-R1)` | 30-scenario Voice Arena, 6-turn adaptive branching dialogue trees (high-AERD 4A/5A vs low-AERD 4B/5B), AERD scoring, spoken P/B contrast drills, fast numbers active listening drills. |
| **M4** | Consultative Sales Mastery | Modules 5 & 6 | `IMPLEMENTED (C2-MEGA)` | 48 Consultative branching scenarios, 8 objection drills, 12 discovery drills, Needs->Fit->Value matching engine, on-device custom offers, 7-dimension ethical scorecard. |
| **M5** | Quality Tracking & Adaptive 90-Day Learning System | Modules 9 & 10 | `IMPLEMENTED (C2-MEGA)` | 90-Day structured syllabus (3 phases, 13 milestones), 10/20/30m daily workout plans, skipped-day recovery mode, calendar-day streak tracking, timeline UI. |
| **M6** | Advanced Voice Evaluation & Acoustic Research (Optional) | Research Extension | `PLANNED` | Exploration of on-device acoustic phonetics, open-source embedded phoneme models (e.g. Vosk / TFLite), and acoustic-timed WPM. |

---

## 🎯 Active Milestone: C1-R1 MEGA Remediation (M2 Disclosure Studio + M3 Floor Skills)

### Delivered Scope & Technical Criteria:
1. **M2 Disclosure Studio (Remediated)**:
   - 6 built-in fictional legal copy practice scripts (AutoPay, 36-mo EIP, Fiber installation window, Trade-in promotion deadline, Protect Advantage insurance, CPNI Privacy Authentication).
   - Sequence-aware dynamic programming Needleman-Wunsch / Levenshtein alignment tracking matched (green), substituted (amber), missing (red), and inserted (`[+word]`, purple) tokens.
   - Strict negation alteration detection (`not`, `no`, `never`, `without`, `only`, `unless`, `cannot`, etc.); any omitted or substituted negation immediately invalidates target met.
   - Critical legal terms presence check (prices, timeframes, obligations, conditions).
   - Simulated customer consent outcomes (agreed, questioned, refused) with TTS playback and Egyptian Arabic coaching.
   - Full local custom draft management (Add, Edit, Delete with confirmation dialogs) persisted in `SharedPreferences`.
   - Native reference audio playback via speech engine.
   - Honest labeling: `RECOGNIZED TRANSCRIPT MATCH`, `PRACTICE TARGET MET/UNMET`.
2. **M3 Floor Skills & 30-Scenario Voice Arena (Remediated)**:
   - 30 distinct fictional multi-turn scenarios covering billing proration, fiber troubleshooting, supervisor de-escalation, hold frustration, fast numbers, bereavement care, move orders, eSIM, warranty vs insurance, tablet add-a-line, and objection handling.
   - Genuine 6-turn adaptive dialogue trees with two distinct reachable paths: Turn 4A / 5A (high-AERD resolution) and Turn 4B / 5B (low-AERD objection/recovery). Non-empty Egyptian Arabic coaching on all turns; supervisor callbacks explicitly marked absent.
   - Multi-turn conversation cockpit with conversation history bubbles, push-to-talk mic button, animated waveform indicator, and turn retry capability.
   - Token-aware regex keyword matching (`\b(att|at and t|at t)\b`) eliminating substring false positives.
   - Spoken P/B transcript matching detecting bilabial confusion.
   - Fast numbers & active listening dictation drills with audio dictation, digit verification, and instant Arabic coaching.
3. **Architecture & Governance**:
   - 6-tier typed provenance system in `lib/core/models/provenance.dart`.
   - 5-destination navigation scaffold (`MainScaffold`: Today/Home, Arena, Disclosures, Floor Skills, Progress) with cross-tab audio safety.
   - Rule-based deterministic Daily Workout Coach based on the user's weakest skill tag.
   - 76 automated tests passing with 0 static analysis errors and 100% formatted Dart code.
