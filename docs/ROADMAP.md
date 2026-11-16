# ROADMAP.md — Project Milestones & Release Trajectory

This roadmap outlines the iterative development trajectory for CALLFORGE, divided into 10 structured milestones mapping to the 10 core academy modules.

---

## 🗺️ Milestone Overview

| Milestone | Target Module | Objective | Core Deliverable |
| :--- | :--- | :--- | :--- |
| **M1** | Foundations & Voice Prototype | Core audio loop: TTS customer + STT mic + Greeting verification + local progress | Working Android voice prototype & test suite |
| **M2** | Module 1: Real Voice Call Simulator | Multi-turn conversational engine with branching states & customer emotion | Full interactive call flow simulator |
| **M3** | Module 2: Disclosures & Pronunciation | Verbatim karaoke tracker & P/B phonetic contrast drill suite | Disclosure accuracy & phonetics engine |
| **M4** | Module 3: American English Listening | Dialect comprehension, fast speech, background noise ear-training | Audio listening comprehension quiz suite |
| **M5** | Module 4: AERD & Call Control | Acknowledge, Empathy, Reassure, Defuse scoring & dead-air reduction | Call control & pacing evaluator |
| **M6** | Module 5: AT&T Product Knowledge | Fictionalized Fiber, Unlimited Wireless, EIP & Trade-in training catalog | Product mastery drills & plan comparisons |
| **M7** | Module 6: Sales Discovery & Conversion | Consultative questioning, value bridging, and objection handling | Sales roleplay simulator & close analyzer |
| **M8** | Module 7: Billing & Technical Care | Bill proration breakdown, first bill surprises & device network resets | Bill explanation & tech triage module |
| **M9** | Modules 8 & 9: Escalation & QA KPIs | De-escalation matrix, supervisor transfer etiquette, AHT & FCR dashboard | Escalation room & QA scorecard analytics |
| **M10**| Module 10: Adaptive 90-Day System | 90-day progressive curriculum from Nesting to Elite Master | Complete adaptive academy & graduation report |

---

## 🎯 Active Milestone: M1 — Core Voice Prototype Details

- **Deliverables**:
  1. Flutter project scaffolding with Clean Architecture (`core`, `data`, `domain`, `presentation`).
  2. Android permissions configuration for microphone access and audio focus.
  3. Native Android TTS playback for simulated customer.
  4. Native Android STT voice recording and transcript capture for Alex.
  5. Mandatory greeting verification engine against:
     > *"Hello, thank you for calling AT&T. This is Alex. May I have your first and last name, please?"*
  6. Evidence-based scoring engine (Levenshtein similarity, missing anchor tokens, WPM).
  7. Dual-language feedback card (English accuracy audit + Egyptian Arabic tactical coaching).
  8. Local persistence of attempt history.
  9. Automated unit, widget, and architecture tests passing with 0 errors.
  10. Debug APK build verification.

---

## 🔮 Future Milestones (M2–M10)

Detailed requirements for each subsequent milestone will be expanded into dedicated GitHub milestones and issues as M1 completes QA acceptance.
