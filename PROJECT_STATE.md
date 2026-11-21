# PROJECT_STATE.md — Current Project Status

**Repository**: `https://github.com/abuhmaid28/callforge-voice-academy`  
**Base Commit**: `40f2c0438c415b53b961d353a7c67b62494266a0` (Approved M1 Squash Merge on `main`)  
**Current Branch**: `feat/c1-mega-disclosure-floor-skills` (C1-R1 MEGA Autonomous Recovery Campaign)  
**Active PR**: [#5](https://github.com/abuhmaid28/callforge-voice-academy/pull/5)  
**Active Issue**: [#6](https://github.com/abuhmaid28/callforge-voice-academy/issues/6) (C1-R1 MEGA Recovery: Adaptive Branching, Order-Safe Alignment, & Product Journeys)  
**Active Milestone**: C1-R1 MEGA (M2 Disclosure Studio + M3 Floor Skills Remediation)  
**Test Suite**: 76 automated tests passing (`flutter test`) | Static Analysis: Clean (`flutter analyze`) | Dart Format: 100%  
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
| **Automated Tests** | `VERIFIED` | 76 tests passing (unit, widget, integration) |

---

## 🎯 Active Milestone: C1-R1 MEGA Remediation & Completion

- [x] **Phase 1 — Genuine Adaptive Branching Across All 30 Scenarios**:
  - Replaced all 120 default-branching placeholders across 30 scenarios with complete 6-turn adaptive dialogue trees.
  - Structured every scenario with two reachable, distinct branches: Turn 4A / 5A (high-AERD resolution) and Turn 4B / 5B (low-AERD objection/recovery).
  - Tailored customer TTS responses and rich Egyptian Arabic trainer coaching for every turn; supervisor callbacks explicitly documented as absent.
- [x] **Phase 2 — Sequence-Aware Dynamic Programming Disclosure Alignment**:
  - Replaced unordered token matching in `DisclosureEvaluator` with sequence-aware Needleman-Wunsch / Levenshtein alignment.
  - Added explicit token tracking: matched, substituted, missing (deleted), and inserted (`TokenMatchStatus.inserted`).
  - Added strict negation word tracking (`not`, `no`, `never`, `without`, `only`, `unless`, `cannot`, etc.); any omitted or substituted negation immediately invalidates target met.
  - Added 6th fictional script `disc-cpni-06` (`Customer Account Privacy & CPNI Authentication`) in `DisclosureCatalog`.
- [x] **Phase 3 — Disclosure Studio Local Draft Management & Reference Audio**:
  - Added custom draft editing bottom sheet and delete confirmation dialogs in `DisclosureStudioScreen`.
  - Added reference audio playback (`playReferenceAudio`, `stopReferenceAudio`) in `DisclosureController` and screen header.
  - Replaced misleading WPM/compliance labels with honest indicators: `RECOGNIZED TRANSCRIPT MATCH`, `PRACTICE TARGET MET/UNMET`.
- [x] **Phase 4 — Hardened Multi-Turn Dialogue & Keyword Matching**:
  - Enforced word-boundary regex (`\b(att|at and t|at t)\b`) in `MultiTurnEvaluator` to eliminate substring false positives like `matter`.
  - Added `retryCurrentTurn()` in `MultiTurnController` to reset failed turns cleanly without history pollution.
- [x] **Phase 5 — Spoken Floor Skills Evaluation**:
  - Evaluated recognized speech against target vs contrast words in `FloorSkillsController`, detecting bilabial confusion instead of hardcoding 100%.
- [x] **Phase 6 — Cross-Tab Audio Safety**:
  - Added automatic audio stopping and cancellation on bottom navigation destination changes in `MainScaffold`.
- [x] **Phase 7 — Comprehensive Product Journey Integration Tests**:
  - Created canonical `C1-01` through `C1-04` integration tests in `test/integration/app_smoke_test.dart` and `integration_test/app_test.dart` exercising the complete 5-tab user journeys.
  - 76 total automated tests passing cleanly with 0 static analysis issues and 100% formatted Dart code.

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
