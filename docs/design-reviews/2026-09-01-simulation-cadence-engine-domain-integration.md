# Design Review — Simulation Cadence and Engine/Domain Integration

**Status:** COMPLETED  
**Date:** 2026-09-01  
**Reviewed target:** PR #14 — `Establish Godot spatial and simulation-loop boundary`  
**Primary evidence:** `docs/brainstorming/representative-scene-catalog.md`, `docs/SIMULATION_ORCHESTRATION.md`, `docs/DOMAIN_MICRO_LOOP.md`

## Purpose

Calibrate the Godot/domain timing boundary against representative scenes before deeper engine integration. This review is advisory evidence; canonical semantics remain in the architecture/domain documents.

---

# Final assessment

The original direction is validated and the review is complete.

Core conclusions now backed by implementation and strict local regression:

- render/physics cadence does not define cognition cadence;
- the ~`0.1 s` semantic step is an engine→semantic bridge, not a universal subsystem clock;
- one authoritative simulation-time model plus shared due scheduling is sufficient for representative gradual work;
- passive spatial perception can occur while Wilson is MOVING;
- perception does not imply broad reconsideration;
- immediate threats enter THREAT routing at the next admissible semantic boundary;
- defensive cognition can cancel/redirect concrete Godot motion;
- raw engine observations do not directly mutate semantic World truth;
- gradual numeric truth can change without semantic event spam; authored crossings are thresholded/coalesced;
- the integrated Gerald/falling-palm scenario proves these boundaries coexist correctly in one temporal trace.

---

# Validated timing model

| Concern | Driver | Representative behavior |
| --- | --- | --- |
| rendering | engine frame | camera/VFX/interpolation |
| physics / motion | Godot physics | movement, collision, falling |
| physics → semantic bridge | fixed semantic boundary (~0.1 s default) | drain observations / admit semantic work |
| passive perception | events + bounded spatial refresh | notice Gerald/fruit while moving |
| immediate threat | admitted semantic evidence | falling-palm threat wakes THREAT routing |
| gradual drives | shared due scheduling | e.g. ~1 Hz without 10 Hz cognition |
| slow environment/processes | shared due scheduling + thresholds | numeric drift without event spam |
| cognition | meaningful semantic boundary | NONE when nothing important changed |
| sparse maintenance | due scheduling when introduced | no separate subsystem clock required |

Calibration rule:

> If nothing semantically important changed, Wilson normally continues what he is already doing.

---

# Perception paths

Two complementary paths are validated.

## Event-driven facts

```text
engine/world fact
→ authored admission
→ authoritative WorldEvent
→ accessibility/perception
→ evidence
```

PR #23 validates discrete physical observation admission. PR #25 extends this to Wilson body impacts. PR #33 validates gradual environment threshold facts.

## Passive spatial refresh

```text
movement/context change
→ bounded nearby candidate refresh
→ metric/LOS revalidation
→ new accessible evidence
→ optional semantic trigger
```

PRs #18/#19 validate evidence while MOVING using real Godot broadphase/query infrastructure.

---

# Representative scene conclusions

## Breakfast First / ordinary route perception

Wilson can notice something while moving and continue his current route. Ordinary evidence alone does not imply broad intentional reconsideration.

## Gerald

PR #35 validates Gerald as an ordinary perceptual interruption in the integrated trace: Gerald becomes perceptible while Wilson is still MOVING, learning receives the evidence, no broad decision is opened, and the original movement target remains active.

Richer Gerald relationship/behavior semantics remain future gameplay work, not a cadence-boundary issue.

## Storm Priorities

PR #33 validates gradual environment numeric mutation plus authored semantic threshold projection and same-step coalescing. Equivalent physical gradual-value policies can reuse the same pattern when representative physical owners exist.

## Falling Palm

The integrated path is now validated:

```text
long movement
→ ordinary Gerald perception while MOVING
→ movement continues
→ later falling-palm threat evidence
→ THREAT reconsideration
→ defensive intention
→ cancel original motion
→ concrete Godot redirect
→ escape movement
```

Production rigid-body palm authoring and an impact/death failure branch remain separate gameplay/physics slices.

---

# Physical observation ordering

Current minimum remains accepted:

- `GodotPhysicalObservationBuffer` preserves insertion order;
- PR #23 preserves order through semantic drain/admission;
- PR #25 preserves it through body consequence resolution.

Stable sequence/physics timestamp metadata remains deliberately deferred. The representative integrated scenario did not expose an ambiguity requiring it.

---

# Integrated timing regression — final evidence

PR #35 adds the representative single-trace regression requested by this review.

The validated trace composes real Godot motion/navigation/perception with semantic orchestration:

```text
Wilson starts a long route
→ physics progresses continuously
→ semantic boundaries advance independently
→ drives/environment progress only at their due deadlines
→ Gerald becomes perceptible while Wilson is MOVING
→ ordinary evidence learns but does not reconsider/redirect
→ route continues
→ later falling-palm evidence is admitted
→ PerceivedThreatTriggerSource derives THREAT
→ immediate-threat candidate is selected and committed
→ DefensiveMotionExecutionCoordinator cancels the original route
→ GodotMotionAdapter redirects toward authored escape
→ physical movement reaches escape and increases distance from the threat
```

The regression also proves cognition is not run simply because ~0.1 s semantic heartbeats occur; meaningful cognition appears only at the representative evidence boundaries.

Strict local validation reported for PR #35:

```text
RESULT: 51 PASS / 51 TOTAL
PASS headless_suite (51 tests)
```

---

# Review checklist

- [x] Treat `SimulationCadenceClock(0.1)` as a deterministic engine→semantic bridge, not a cognition frequency.
- [x] Preserve one authoritative simulation-time model rather than independent subsystem clocks by default.
- [x] Implement bounded passive spatial perception during movement; perception does not wait for `ARRIVED`.
- [x] Keep event-driven perception for meaningful engine/world changes alongside passive refresh.
- [x] Ensure perception can occur without automatically triggering broad intentional reconsideration.
- [x] Ensure immediate threats reach THREAT routing at the next admissible semantic boundary.
- [x] Keep gradual systems due/time-driven and cognition boundary/event-driven.
- [x] Coalesce/threshold gradual physical/environmental changes before semantic event spam. Environment path is validated generically; discrete physical thresholds are separately validated.
- [x] Confirm deterministic same-step physical observation ordering; sequence/timestamp metadata remains deferred because representative scenarios did not require it.
- [x] Add the integrated 20 m-style walk / Gerald / falling-palm timing scenario. **Closed by PR #35.**

---

# Consumption record

- PR #16 — canonical cadence/trigger/passive-perception guidance.
- PR #17 — semantic due scheduler, reconsideration gate, host/motion boundary.
- PR #18 — application passive spatial perception while MOVING.
- PR #19 — real Godot navigation/LOS/perception fixture.
- PR #21 — perceived-threat same-chain THREAT trigger.
- PR #23 — physical observation → authored semantic event.
- PR #25 — impact → Wilson body truth → injury/death event.
- PR #27 — grounded Wilson death → run lifecycle.
- PR #29 — committed defense → concrete route cancellation/redirection.
- PR #31 — shared due scheduling for drives/dynamic processes.
- PR #33 — gradual environment threshold/coalescing.
- PR #35 — integrated Gerald/falling-palm timing trace; final review consumption.

**Consumed by:** PR #16, #17, #18, #19, #21, #23, #25, #27, #29, #31, #33, #35  
**Latest validated consumption:** PR #35 — strict runner `51 PASS / 51 TOTAL` under Godot 4.7.1  
**Completion date:** 2026-09-05  
**Completion status:** COMPLETED

## Deferred recommendations / non-blocking future work

- stable monotonic sequence/physics timestamps for physical observations: defer until an actual ambiguous same-step accident requires them;
- sparse maintenance owners: wire through the existing shared due scheduler when representative behavior requires them;
- gradual physical-value policies: apply the validated threshold/coalescing pattern when a suitable physical owner exists;
- richer Gerald semantics, production falling-palm rigid-body behavior, learned escape reasoning, body persistence and full run-save composition: future product/runtime work, not unresolved items in this review.
