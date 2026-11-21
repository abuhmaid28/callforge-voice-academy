# PROJECT_STATE.md — Current Project Status

**Repository**: `https://github.com/abuhmaid28/callforge-voice-academy`  
**Base Commit**: `40f2c0438c415b53b961d353a7c67b62494266a0` (Approved M1 Squash Merge on `main`)  
**Current Branch**: `feat/c1-mega-disclosure-floor-skills` (C1-MEGA Autonomous Campaign)  
**Active Issue**: [#4](https://github.com/abuhmaid28/callforge-voice-academy/issues/4) (C1-MEGA — M2 Disclosure Studio + M3 Floor Skills & 30-scenario Voice Arena)  
**Active Milestone**: C1-MEGA (M2 + M3 Integration)  
**Test Suite**: 67 automated tests passing (`flutter test`) | Static Analysis: Clean (`flutter analyze`)  
**Last Updated**: 2026-11-21

---

## 🚦 System & Environment Verification

| Component | Status | Details |
| :--- | :--- | :--- |
| **Flutter SDK** | `VERIFIED` | Flutter 3.47.0 (Channel stable, Dart 3.13.0) at `C:\src\flutter` |
| **Android SDK** | `VERIFIED` | Android SDK 36.0.0, Platform android-37.0 at `C:\Android\Sdk` |
| **Java JDK** | `VERIFIED` | OpenJDK 25.0.2 at `C:\Program Files\Android\Android Studio\jbr` |
| **GitHub CLI** | `VERIFIED` | Authenticated as `abuhmaid28` via git operations protocol HTTPS |
| **Hardware Environment**| `VERIFIED` | Windows 10 Enterprise x64 (8 GB RAM constraint managed with `-Xmx2048m`) |
| **Verification Strategy**| `VERIFIED` | Phone-free hosted Linux CI (GitHub Actions) & Android Emulator integration tests (ADR 010) |
| **Automated Tests** | `VERIFIED` | 67 tests passing (unit, widget, integration) |

---

## 🎯 Active Milestone: C1-MEGA (M2 Disclosure Studio + M3 Floor Skills)

- [x] **Phase A — Governance & Typed Provenance**:
  - Established typed 6-tier provenance system in `lib/core/models/provenance.dart` (`ProvenanceTier` enum).
  - Attached explicit source provenance metadata to all scenarios, disclosures, and progress models.
- [x] **Phase B — 30-Scenario Voice Arena & Multi-Turn Engine**:
  - Implemented `ScenarioCatalog` containing all 30 distinct fictional multi-turn customer care scenarios across 5 categories.
  - Authored branching dialogue trees with agent and customer turns, required keywords, and Egyptian Arabic coaching cards.
  - Implemented `MultiTurnEvaluator` combining token-aware keyword matching, AT&T transcription variants, AERD (Acknowledge, Empathy, Reassure, Defuse) scoring, and branch resolution.
- [x] **Phase C — M2 Disclosure Studio**:
  - Created 5 self-contained fictional legal disclosure scripts in `DisclosureCatalog` (`[Fictional / Simulation Only]`).
  - Implemented `DisclosureEvaluator` with token-by-token alignment, Levenshtein similarity, WER, critical terms extraction, and P/B phonemic alerts.
  - Implemented `DisclosureKaraokeView` with dynamic color-coded word highlights and critical terms badge checklist.
  - Simulated customer consent outcomes (agreed, questioned, refused) with TTS playback and Egyptian Arabic trainer next-step coaching.
  - Local user draft creation and offline persistence via `SharedPreferences`.
- [x] **Phase D — M3 Floor Skills & Drills**:
  - P/B Bilabial contrast drills with minimal pairs (`payment/bayment`, `plan/blan`, `paperless/baperless`, `problem/broblem`, `postpaid/bostpaid`) and phonemic coaching.
  - Fast numbers & active listening dictation drills with audio dictation, digit precision validation, and instant feedback.
- [x] **Phase E — Learning Progress & Daily Coach**:
  - Tracked daily streaks, completed simulations, disclosure attempts, and floor drill scores.
  - Dynamic skill mastery radar calculating moving average mastery per skill tag.
  - Deterministic rule-based Daily Coach ("Today's Workout") recommending targeted scenarios and drills based on weakest skill tag.
- [x] **Phase F — Feature-First Main Navigation & UX Polish**:
  - Built `MainScaffold` connecting 5 bottom navigation destinations (Today, Arena, Disclosures, Floor Skills, Progress).
  - Wired lightweight `ServiceLocator` dependency injection.
  - High-contrast, dark/light theme, accessible typography, and synthetic waveform activity indicator.
- [x] **Phase G — Comprehensive Automated Test Suite**:
  - 67 tests passing across unit, widget, and integration suites.
  - 100% backward-compatible with M1 greeting tests.

---

## 📊 Module Implementation Matrix (M0–M6 Technical Roadmap)

| Module | Curriculum Focus | Technical Milestone | Status | Notes |
| :--- | :--- | :--- | :--- | :--- |
| **1. Real Voice Call Simulator** | Spoken roleplay | M1 & M3 | `IMPLEMENTED` | Multi-turn branching simulation cockpit with 30 scenarios. |
| **2. Disclosure Reading & Pronunciation** | Legal disclosures & phonetics | M2 | `IMPLEMENTED` | Karaoke tracking, critical terms checking, customer consent, P/B drills. |
| **3. American English Listening & Speaking** | Dialects & fast speech | M3 | `IMPLEMENTED` | Fast numbers & IMEI active listening dictation drills. |
| **4. AERD and Call Control** | Steering & de-escalation | M3 | `IMPLEMENTED` | AERD scoring engine with Egyptian Arabic coaching cards. |
| **5. AT&T Product Knowledge** | Plan & device training | M4 | `IMPLEMENTED (PARTIAL)` | Fictionalized Fiber, Unlimited, and EIP trade-in scenarios (`[Fictional / Simulation Only]`). |
| **6. Sales Discovery and Conversion** | Consultative sales | M4 | `IMPLEMENTED (PARTIAL)` | Discovery questioning in scenarios 20, 24, 27, 28, 30. |
| **7. Billing and Technical Troubleshooting** | Bill breakdown & tech reset | M3 | `IMPLEMENTED` | Proration, billing cycles, red light gateway, and move orders. |
| **8. Escalation and Angry Customers** | High stress calls | M3 | `IMPLEMENTED` | Supervisor demand, transfer frustration, and line suspension care. |
| **9. KPI and Quality Tracking** | Handling pace & scorecard | M5 | `IN PROGRESS` | Local progress tracking, daily streaks, and skill mastery radar. |
| **10. Adaptive 90-Day Learning System** | Long-term progression | M5 | `IN PROGRESS` | Daily workout recommendations based on weakest skill tag. |
