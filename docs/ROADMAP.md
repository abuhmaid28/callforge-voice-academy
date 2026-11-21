# ROADMAP.md — Technical Release Milestones (M0–M6)

This document defines the technical release milestones for CALLFORGE (M0 through M6), reconciling the technical architecture directly with the original training academy charter while preserving all 10 pedagogical training modules.

---

## 🗺️ Reconciled Milestone Architecture (M0–M6)

| Milestone | Target Scope | Associated Academy Modules | Status | Core Deliverables |
| :--- | :--- | :--- | :--- | :--- |
| **M0** | Foundation & Environment Verification | Governance & Architecture | `COMPLETED` | Environment verification, Windows 8 GB RAM tuning (`-Xmx2048m`), Android SDK setup, source provenance framework. |
| **M1** | Voice Prototype & Inbound Greeting Simulator | Module 1 (Turn 1 Opening) | `COMPLETED` | Approved & merged to `main` at `40f2c0438c415b53b961d353a7c67b62494266a0`. Turn-based greeting loop, token-aware anchors, session generation guards, CI. |
| **M2** | Disclosure Reading & Pronunciation Precision | Module 2 | `IMPLEMENTED (C1-MEGA)` | Fictional legal disclosure catalog, karaoke word tracking, critical terms validation, simulated consent outcomes, local draft editor. |
| **M3** | Core Floor Care Simulator (Listening, AERD & Billing) | Modules 1, 3, 4, 7, 8 | `IMPLEMENTED (C1-MEGA)` | 30-scenario Voice Arena, multi-turn branching cockpit, AERD scoring engine, P/B contrast drills, fast numbers active listening drills. |
| **M4** | Consultative Sales Mastery | Modules 5 & 6 | `IN PROGRESS` | Open-ended discovery questions, value bridging, plan upgrade scenarios (Fiber, Unlimited Wireless, EIP trade-ins), and consultative closing. |
| **M5** | Quality Tracking & Adaptive 90-Day Learning System | Modules 9 & 10 | `IN PROGRESS` | Practice QA scorecard, handling pace awareness, daily workout coach, and structured 90-day trajectory. |
| **M6** | Advanced Voice Evaluation & Acoustic Research (Optional) | Research Extension | `PLANNED` | Exploration of on-device acoustic phonetics, open-source embedded phoneme models (e.g. Vosk / TFLite), and acoustic-timed WPM. |

---

## 🎯 Active Milestone: C1-MEGA (M2 Disclosure Studio + M3 Floor Skills)

### Delivered Scope & Technical Criteria:
1. **M2 Disclosure Studio**:
   - 5 built-in fictional legal copy practice scripts (AutoPay, 36-mo EIP, Fiber installation window, Trade-in promotion deadline, Protect Advantage insurance).
   - Token-by-token karaoke visualizer highlighting matched (green), substituted (amber), and missing (red) words.
   - Critical legal terms presence check (prices, timeframes, obligations, conditions).
   - Simulated customer consent outcomes (agreed, questioned, refused) with TTS playback and Egyptian Arabic coaching.
   - Offline local custom draft editor persisted in `SharedPreferences`.
2. **M3 Floor Skills & 30-Scenario Voice Arena**:
   - 30 distinct fictional multi-turn scenarios covering billing proration, fiber troubleshooting, supervisor de-escalation, hold frustration, fast numbers, bereavement care, move orders, eSIM, warranty vs insurance, tablet add-a-line, and objection handling.
   - Multi-turn conversation cockpit with conversation history bubbles, push-to-talk mic button, and animated waveform indicator.
   - Multi-turn evaluation combining semantic anchor coverage, AT&T speech variations, AERD (Acknowledge, Empathy, Reassure, Defuse) scoring, and dynamic branch resolution.
   - P/B Bilabial contrast drills with minimal pairs (`payment/bayment`, `plan/blan`, `paperless/baperless`, `problem/broblem`, `postpaid/bostpaid`).
   - Fast numbers & active listening dictation drills with audio dictation, digit verification, and instant Arabic coaching.
3. **Architecture & Governance**:
   - 6-tier typed provenance system in `lib/core/models/provenance.dart`.
   - 5-destination navigation scaffold (`MainScaffold`: Today/Home, Arena, Disclosures, Floor Skills, Progress).
   - Rule-based deterministic Daily Workout Coach based on the user's weakest skill tag.
   - 67 automated tests passing with 0 errors and clean static analysis.
