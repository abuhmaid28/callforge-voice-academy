# CALLFORGE C3-MEGA — Independent Post-C2-R1 Acceptance Audit

Source pinned to merged `main`: `38496aec5292ec31fbe04cff7f4b80682e505a0d`.  
Full instructions and acceptance: [Issue #11](https://github.com/abuhmaid28/callforge-voice-academy/issues/11).  
Last actual CI evidence: [Run 45079203526](https://github.com/abuhmaid28/callforge-voice-academy/actions/runs/45079203526) — success: 138 Flutter tests, 12 hosted Android API34 integration tests, debug APK, **mocked speech only**.

**This audit commit is documentation/handoff ONLY; it delivers no feature fixes.**

## Independently reproduced source findings

1. **Day 1–30 cannot complete through Today:** `HomeScreen._launchScenario` constructs `MultiTurnSimulatorScreen(scenario: arenaScenario)` without `curriculumDay`. `MultiTurnSimulatorScreen` has no such argument. `MultiTurnController._completeCall` records `recordSimulationCompletion` but never `recordCurriculumDayCompletion`. Days 1–30 use care IDs. Correct source ID lookup from C2-R1 does not solve day advancement.
2. **Workout queue not a session:** `HomeScreen._showWorkoutQueueSheet` renders independently tappable steps; tapping closes sheet and opens only one step. No persisted next/pending/completed step, resume or end-to-end workout completion; coaching review displays objectives rather than scored attempt feedback.
3. **Hard promises still taught:** `wireless_scenarios.dart` `sales-01` Turn 5A states exact plan allowance and monthly price delta, Turn 7A guarantees zero plan-change fees and immediate change; `objection_drills.dart` claims fixed plan/equipment pricing without surcharges. Default `fictionalSimulation` metadata does not prevent unqualified model responses from being repeated in a real call.
4. **No actual disclosure/consent qualification:** `SalesSimulatorController._completeCall` evaluates `hasDiscovery`, prohibited-promise blacklist and overall score, but does **not** verify `SalesScenario.mandatoryDisclosures`, eligibility checks, or explicit simulated customer consent before `qualifiedAccept`.
5. **Branch-key mismatches:** six sales scenario catalogs include `high_value`, `budget_decline`, `qualified`, `needs_check` in addition to `accept`/`decline`/`verify`. `_evaluateCustomerBranch` lacks explicit handling for several and falls back to `branches.first`; two declared terminal outcomes existing in static data does not prove reachability via agent spoken evidence. `sales-01` Turn 4 has `high_value`/`budget_decline`/`needs_check` even though no direct `accept` branch exists there.
6. **Unawaited persisted completion:** `SalesSimulatorController._completeCall` fires `saveAttempt`, `recordSalesSimulationCompletion`, `recordCurriculumDayCompletion` without awaiting. `ProgressRepositoryImpl._synchronized` serializes updates within the instance, but UI refresh/restart can race those unfinished writes. A dedicated idempotent awaited attempt+workout boundary is needed.
7. **Green CI only covers surface M5:** current hosted integration `C2-03` asserts Today renders, 10m selection, and Start button existence. It does NOT run a full daily workout, complete day 1, exercise distinct branch outcomes, or prove saved local state after restart.

## Recovery contract

All findings should be resolved **in the same C3-MEGA branch and draft PR**, by one autonomous eight-phase campaign described in Issue #11. The goal is a functioning voice-first 90-day course and ethical conversation training, not increasing the test count by itself. Tests must execute actual 48×3 path outcomes, 90-day step navigation/completion, no false sale consent, no source-unsupported employee claims, mock audio stop/cancel/retry, data recovery and mobile UX.

No owner's phone/USB/ADB/local emulator, no paid voice service, no proprietary employer policy/customer data, no app publication. The last verified emulator tests use mocks, not native mic/acoustic pronunciation.

Record real independent review evidence. Don't call mock CI a certification. Only squash merge if all blocking objective acceptance tests, content reviews and actual exact-head CI are green.