# CALLFORGE C2 Post-Merge Independent Acceptance Audit

**Date:** 2026-11-23  
**Source reviewed:** merged `main` commit `7b773aeb6ba2d3821fcebab1d59d33da906e665f` (PR #8)  
**Review tracking:** [Issue #9](https://github.com/abuhmaid28/callforge-voice-academy/issues/9)  
**Status:** Independent **product acceptance NOT YET PROVEN**. This review does not undo C2's completed GitHub merge.

## Established facts

- C2-MEGA PR #8 merged into `main`, including 48 distinct sales scenarios, 8 objection and 12 discovery drills, Product-Fit engine and a 90-day curriculum skeleton.
- CI [Run 45074944668](https://github.com/abuhmaid28/callforge-voice-academy/actions/runs/45074944668) SUCCESS. Logs verify 133 Flutter tests, 12 hosted Android emulator integration tests, debug APK build. Tests use mocked speech and cannot assess native microphone or actual pronunciation.
- Current C2 user-facing claim of complete sales/milestone readiness requires further functional runtime and policy validation.

## Verified gaps and how to reproduce

1. **Invalid Today workout references:** `CurriculumDataSource` generates `scen-01` … `scen-30`, while `ScenarioCatalog` uses suffixed IDs such as `scen-01-first-bill`. All first 30 primary references are absent. One phase-2 reference, `sales-09-fiber-300-streaming-upgrade`, is absent from the 48 actual SalesScenario IDs. `HomeScreen._startDailyWorkout` silently returns without navigation if a lookup fails. No test asserts all 90 assignments resolve.
2. **Weak C2 greeting gate:** `SalesSimulatorController.stopListening` checks substring `lower.contains('att')` and `lower.contains('alex')`, ignoring first/last/name and allowing accidental substring matches (e.g. "matter"). M1/C1 use stricter canonical token-aware anchors.
3. **Unsupported sale success:** `SalesSimulatorController` ends a call when a terminal fictional customer turn finishes and uses its `qualifiedAccept` enum; neither controller nor evaluator proves all applicable simulated eligibility/consent/disclosure steps were delivered. `SalesEvaluator` writes "Clean qualified close" for that enum without independent evidence.
4. **Outcome heuristic is too shallow:** `SalesSimulatorController._resolveNextTurn` takes the first branch for agent turns, and `_evaluateCustomerBranch` selects decline/verify from substring matches on the previous agent text; all other utterances default to accept. Missing safety-first unknown/ambiguity handling. Catalog tests check terminal outcomes exist, not graph reachability under agent utterances.
5. **Fictional content can teach invented official terms:** Example `sales-01` agent responses claim specific 30GB, 75GB and $10 differential plus zero change fees and immediate activation. They are sourced as fictional practice, but the model sentences are stated as verified real carrier facts; training must use explicit hypothetical/verification framing throughout content.
6. **Completion writes risk lost updates:** `_completeCall` calls `recordSalesSimulationCompletion` and `recordCurriculumDayCompletion` without awaiting or serializing. Both read and replace the same SharedPreferences UserProgress record; race can lose updates. Curriculum completion is invoked for any terminal outcome even when `scorecard.passed == false`.
7. **M5 time selection is not a full workout schedule:** `DailyWorkoutPlan` stores `chosenMinutes`, but `HomeScreen._startDailyWorkout` launches only the primary scenario, never the selected daily drill/review, and the duration choice does not alter actual exercise tasks. Real executable 10/20/30-minute plans and week progression are not established.

## Required closure

See Issue #9 for full one-campaign remediation and acceptance checklists. Add failing reproduction tests first, implement fixes on this branch and single PR, then validate full Flutter suite, APK and hosted Android API34 emulator journey tests on the **final** source, and perform an actual independent product/code/privacy review. Do not claim native acoustic validation, an official employer QA certification, or external offer eligibility. No personal hardware, local Windows emulator, paid voice APIs, customer data or unauthorized publication.

**This file is an evidence-only audit/handoff, not a feature fix.**