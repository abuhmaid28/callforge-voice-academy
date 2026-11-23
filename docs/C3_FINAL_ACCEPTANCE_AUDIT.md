# CALLFORGE C3-FINAL — Independent Post-Merge Training Evidence Audit

**Audited merge:** `main` at `ff83dacdced92534be45226d225e2ee5b907532d`  
**Historical PR:** [#12](https://github.com/abuhmaid28/callforge-voice-academy/pull/12) (already merged)  
**CI verified:** [45085981967](https://github.com/abuhmaid28/callforge-voice-academy/actions/runs/45085981967), 157 Flutter tests, 13 mocked hosted Android API34 integration tests, debug APK, both jobs SUCCESS. No native mic/real acoustic validation.
**One-campaign correction spec:** [Issue #13](https://github.com/abuhmaid28/callforge-voice-academy/issues/13).  
**Status:** AUDIT ONLY. No C3-FINAL product code has been fixed by this handoff.

## Evidence-backed blockers

1. `WorkoutSessionScreen._executeDrillStep` unconditionally records score=85 and passed=true after returning from any drill, even on Back/cancel with no answer.
2. `WorkoutSessionScreen._executeScenarioStep` initializes score=75, passed=true, and if it finds no fresh attempt on return still passes. If attempts exist, it reads the last attempt without linking it to this workout's start, so stale history can be reused.
3. `WorkoutSessionController.completeEntireWorkout` loops over all non-skipped steps marking them completed regardless of evidence. This is invoked via Review, conflating viewing feedback with verified completion.
4. `WorkoutSessionController.startOrResumeSession` keeps session only in memory; its singleton in `main.dart` does not make session survive app/process restart. `WorkoutSessionState` has no durable read/write source integration.
5. `SalesSimulatorController._completeCall` checks `hasCustomerConsent = outcome == qualifiedAccept` after already conditioning on `qualifiedAccept`, so consent check is not independent. `_hasMandatoryDisclosuresCovered` treats one loose non-stopword shared token per mandatory sentence as fulfillment. This can award unearned "qualified simulated sale".
6. C3 test `test/core/c3_mega_acceptance_test.dart` checks terminal enum *existence for 6 representative scenarios*, not 48×3 actual graph/controller trajectories. `sales_ethical_gates_and_branching_test.dart` executes three paths for sales-01 only; default selector still favors acceptance on ambiguous answers.
7. `MultiTurnController._completeCall` computes `callPassed` from average scores but stores `AttemptRecord.accuracyPercentage` from latest turn score; workout evidence may contradict call result.
8. Hosted C3-01 `integration_test/app_test.dart` only opens WorkoutSessionScreen and checks key `btn_launch_workout_step`; does not actually run a step, finish workout, verify Day1→2, restart persistence, or negative path.

## Required work
Follow Issue #13 as one **finite acceptance hardening campaign** with failing tests, no fabricated scores, real durable practice session IDs, pass/partial completion policy, independent consent/eligibility/disclosure evidence, executed 48×3 branch trajectories, correct aggregate score and genuine hosted emulator end-to-end journeys. Maintain existing workflows and no phone/USB/local Windows emulator/paid voice API/employer secrets/customer PII. Finish same branch/PR, exact-head CI and genuine independent review. Only merge with objective gates satisfied; otherwise remain Draft and repair.

**This file is evidence-only and does not imply any tested code change.**
