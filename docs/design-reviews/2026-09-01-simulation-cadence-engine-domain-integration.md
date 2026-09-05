# Design Review — Simulation Cadence and Engine/Domain Integration

**Status:** OPEN  
**Date:** 2026-09-01  
**Reviewed target:** PR #14 — `Establish Godot spatial and simulation-loop boundary`  
**Primary evidence:** `docs/brainstorming/representative-scene-catalog.md`, `docs/SIMULATION_ORCHESTRATION.md`, `docs/DOMAIN_MICRO_LOOP.md`

## Purpose

Calibrate the proposed Godot/domain timing boundary against the representative scene catalog before the engine-integration work becomes deeper and harder to change.

This review is advisory evidence, not a canonical architecture owner. If implementation work consumes this review, the consuming agent must resolve the checklist below and then change this file to `Status: COMPLETED`, recording the consuming PR/commit and any deliberately rejected recommendation with rationale. If only part of the checklist is consumed, keep the review `OPEN` and annotate only the resolved items.

---

# Executive assessment

The PR #14 direction is sound and is capable of supporting the representative scenes validated so far.

The strongest choices are:

- render/physics cadence does not define cognition cadence;
- a deterministic semantic bridge accumulates fine engine time;
- movement progresses in the engine without forcing cognition every physics frame;
- physical callbacks become typed observations rather than direct World mutation;
- fine distance/navigation/visibility remains behind explicit semantic ports;
- Godot scene identity remains distinct from durable domain identity.

The main calibration remains:

> The current `0.1 s` cadence is a deterministic physics-to-semantic bridge, not a universal frequency for perception, cognition or every simulation system.

The representative scenes require different classes of work to advance for different reasons: some by continuous engine progression, some by elapsed semantic time, some by bounded spatial sampling, and many only when a meaningful event/boundary occurs.

---

# Recommended timing model

Use one authoritative simulation time and a small number of semantic scheduling concepts rather than one independent clock per subsystem.

| Concern | Preferred driver | Initial order of magnitude | Example |
| --- | --- | --- | --- |
| rendering | engine frame | display FPS | interpolation, VFX, camera |
| physics / motion | Godot physics | physics FPS | movement, fall, collision |
| physics → semantic bridge | fixed semantic step | ~0.1 s | drain observations, advance fine semantic progression |
| passive spatial perception | bounded sampling + events | up to ~10 Hz while moving; slower while static | notice fruit while walking |
| immediate threat | event / next semantic boundary | as soon as admitted evidence exists | falling palm |
| gradual drives | elapsed time | ~1 Hz initially | hunger, fatigue |
| slow environment/processes | elapsed time / semantic thresholds | ~1 Hz or slower as appropriate | spoilage, drying, weather drift |
| tactical reconsideration | meaningful event/boundary | no fixed frequency | failed tactic, new evidence |
| intentional reconsideration | meaningful event/boundary | no fixed frequency | urgent drive band, project completion |
| maintenance | sparse elapsed-time work | infrequent | memory consolidation, disuse/decay |

These are calibration defaults, not permanent numeric contracts.

The important rule is:

> If nothing semantically important changed, Wilson should normally continue what he is already doing.

---

# Perception must have two paths

The scene catalog requires both event-driven perception and bounded passive spatial refresh.

## 1. Event-driven perceptual opportunities

Use engine/domain events when something can naturally announce a meaningful change:

- collision or overlap;
- object breakage;
- weather threshold transition;
- an animal entering/leaving a relevant local region;
- a loud event;
- player world manipulation;
- action completion/outcome;
- an object becoming unsecured or starting to move dangerously.

These events should not themselves imply Wilson perceived or understood the fact. They trigger the normal accessibility/perception boundary.

PR #23 validates the engine side of this path for discrete physical facts: queued `PhysicalObservation` values drain only at a semantic boundary, an authored consequence rule may admit a matching observation as an authoritative non-action `WorldEvent`, and only then can the normal accessibility/perception path produce evidence. Below-threshold contacts remain non-authoritative and produce no event.

PR #25 extends that boundary for Wilson body impacts: authored impact policy may mutate World-owned `WilsonBodyState` first; only a successful mutation produces a body `SemanticChangeSet` plus injury/death `WorldEvent`. Raw callbacks still do not own body truth.

PR #33 validates the gradual environment side: successful numeric World transitions remain authoritative changes and invalidate derived state normally, while only authored threshold crossings are projected into non-action `WorldEvent` facts; duplicate crossings for the same rule/subject within one semantic step coalesce.

## 2. Passive spatial refresh

Some important discoveries have no originating event. Example: in **Breakfast First**, fruit may already be lying on the route and Wilson notices it only because he walks into a useful viewing position.

The architecture therefore needs a bounded way to refresh nearby perceptibles when, for example:

- Wilson moved far enough;
- Wilson orientation/view context changed materially;
- local spatial membership changed;
- a periodic low-cost refresh is due.

Conceptual shape:

```text
movement/context change
→ bounded nearby perceptible query
→ range / modality / line-of-sight filtering
→ newly accessible subjects/evidence
→ optional reconsideration trigger
```

Do not wait for `MotionStatus.ARRIVED` before perception can observe the current engine-backed position.

Validated implementation now uses Godot overlap signals as the fast path plus bounded shape reconciliation while moving. Broadphase membership remains only a candidate source; metric distance and LOS are revalidated through `SpatialQueryPort`, and positive evidence is edge-driven so the same continuously visible object does not emit evidence every refresh.

---

# Representative-scene checks

## The Good Chair

Required behavior:

```text
bird lands nearby
→ Wilson perceives it
→ brief local reaction/glance
→ current restful intention continues
```

This demonstrates that perception must not imply broad intentional reconsideration.

**Assessment:** supported. Passive evidence can be admitted without opening broad candidate competition when no reconsideration trigger exists.

## Breakfast First

Required behavior:

```text
Wilson walks toward storage
→ fruit becomes visible during movement
→ Wilson notices it
→ habit/current intention may still win
→ movement can continue
```

**Assessment:** validated at the engine boundary. The real integration fixture produces perceptual evidence while `GodotMotionAdapter` remains `MOVING`, then continues to `ARRIVED`.

## The Long Way Around

Godot can report objective route cost while Wilson's cognition adds learned subjective aversion/history.

Example:

```text
short route = 8 m + strong learned aversion
long route  = 14 m + no learned aversion
```

**Assessment:** the engine/domain separation is suitable. Real route cost/path availability is now validated, but Wilson-relative learned route aversion remains a later cognition slice.

## Scientific Method

The scene depends primarily on semantic boundaries, not a high-frequency cognition clock:

```text
action commit
→ grounded outcome
→ World consequence
→ perception/evidence
→ same-chain learning
→ tactical reconsideration
```

**Assessment:** aligned with the existing micro-loop contract. Same-chain learning exists; generic consequence-trigger synthesis remains incomplete.

## The Missing Spoon

Wilson does not need to continuously perceive the moved spoon while asleep. The important boundary can be an expectation mismatch when the habitual reach fails, followed by a bounded search/perception refresh.

**Assessment:** event/anomaly-driven cognition remains preferable to continuous polling.

## Gerald

Useful perceptual boundaries include:

- Gerald entering a relevant nearby region;
- Gerald becoming visible;
- Gerald changing trajectory in a semantically relevant way, such as approaching protected food.

**Assessment:** broadphase + bounded revalidation now supports the spatial side. Gerald-specific semantic trigger production remains open.

## Storm Priorities

Continuous physical/weather values should normally emit semantic events only when useful thresholds or facts change.

Prefer:

```text
object_started_sliding
possession_became_unsecured
wind_became_dangerous
```

rather than emitting every tiny numeric wind change.

**Assessment:** validated for gradual environment values by PR #33. Dynamic-process numeric mutations expose successful previous/current transitions; authored property/direction thresholds project only actual crossings to semantic events, and duplicate same-step crossings coalesce by rule/subject. Equivalent gradual physical-owner policies remain future authored applications, not an architectural gap.

## Falling Palm / Victory Lap / Faster Than Walking / Brilliant Shortcut / Unwanted Rescue

These scenes contain accidents that develop across multiple physics frames and may require timely intervention/reaction.

**Assessment:** the 0.1 s semantic bridge is fast enough as an initial default. Accessible authored threat evidence wakes the immediate-threat routing regime at the next semantic orchestration boundary without a pre-injected external trigger. PR #23 closes raw physical observation → authoritative semantic event admission for authored discrete observations. PR #25 closes authored body-impact → Wilson body truth. PR #27 propagates an already-committed Wilson death fact into run lifecycle. PR #29 closes the cognition→motion boundary for an already-selected defensive intention: route-aware escape selection cancels the prior move and redirects `GodotMotionAdapter` toward a safer authored destination. PR #31 validates that representative gradual drive/process work remains due-driven rather than being forced by every 0.1 s semantic boundary. PR #33 validates semantic threshold/coalescing for gradual environment truth. The broader integrated accident timing scenario remains open.

---

# Physical observation ordering

PR #14 preserves callback insertion order in `GodotPhysicalObservationBuffer`, which remains the current minimum. PR #23 preserves that order through semantic-boundary draining and authored consequence admission. PR #25 preserves it through body consequence resolution.

As physical scenarios become more complex, consider whether each observation should also carry a stable monotonic ordering field or semantic/physics timestamp.

Example within one 100 ms semantic interval:

```text
0 ms   foot slips
25 ms  grounding lost
60 ms  contact with obstacle
90 ms  fall/contact consequence boundary
100 ms semantic batch drains
```

The goal is not to replay rendered frames. The goal is to preserve deterministic causal interpretation when several fine physical facts occur before the next semantic orchestration boundary.

Do not add elaborate timestamp infrastructure until a representative accident requires it; however, keep the observation contract extensible enough that insertion order does not become an accidental permanent limitation.

---

# Movement integration requirement

The following is now validated with a real Godot fixture plus deterministic semantic regressions:

```text
Wilson starts a long move
→ engine progresses continuously
→ current transform changes
→ passive perception queries current distance/visibility
→ newly accessible evidence is emitted while MOVING
→ ordinary passive evidence does not automatically force broad reconsideration
→ authored threat evidence derives THREAT at the next semantic boundary
→ immediate-threat routing replaces Wilson's cognitive intention before ARRIVED
→ committed defensive intention selects a route-aware escape destination
→ existing move is cancelled
→ Godot motion is redirected and physically progresses toward escape
```

The real fixture validates obstacle collision, navmesh detour routing, explicit `RuntimeWorldRef` mapping, clear LOS and wall-occluded LOS. PR #21 validates semantic threat wake-up while motion remains `MOVING`. PRs #23/#25 establish the physical-fact → admitted consequence → World/body truth side needed for accident scenarios. PR #29 validates the execution boundary from committed defensive cognition to concrete `NavigationAgent3D` redirection.

The remaining movement-adjacent work is no longer basic cancellation/redirection; it is richer Wilson-relative escape evaluation and a representative integrated hazard timing scenario.

---

# Recommended architecture shape

```text
Godot render frames
        │
Godot physics / navigation
        │
        ├─ continuous transform/motion state
        └─ typed physical/spatial events
                │
        deterministic semantic bridge (~0.1 s)
                │
        ┌───────┴────────┐
        │                │
 due elapsed-time work   meaningful triggers
 drives/processes        evidence/threat/anomaly
        │                │
        └───────┬────────┘
                │
       routed cognition only when needed
                │
       tactical / intentional / threat
```

A critical threat does not require a second simulation architecture. It uses the same causal path with a high-priority routing regime and reaches it at the next admitted semantic boundary.

---

# Anti-overengineering guidance

Avoid introducing independent clocks such as:

```text
PerceptionClock
HungerClock
MemoryClock
EmotionClock
ProjectClock
HabitClock
DirectorClock
```

Prefer:

```text
one authoritative simulation time
+ one deterministic semantic heartbeat/step source
+ owner/service due scheduling
+ event/semantic-boundary triggers
+ sparse maintenance
```

Likewise, do not make cognition run at 10 Hz merely because passive spatial revalidation or the physics-to-semantic bridge can run near that cadence.

---

# Proposed integration test

A broader representative timing regression should eventually prove a trace similar to:

```text
Wilson decides to walk 20 m toward a tree.

For the next 8 seconds:
- physics advances continuously;
- semantic bridge advances at its fixed cadence;
- gradual drives advance only when due;
- broad intentional cognition does not run merely because time passed.

At second 4:
- Gerald becomes perceptible;
- Wilson receives relevant evidence;
- a small/tactical reaction may occur;
- the current movement/intention may continue.

At second 6:
- a palm begins falling toward Wilson;
- accessible threat evidence is produced;
- immediate-threat routing interrupts ordinary behavior;
- Wilson chooses/executes escape movement.
```

The current real-engine fixture covers movement + passive perception + LOS and now also concrete escape redirection. PR #21 covers perception-derived threat wake-up and immediate-threat selection while motion is still `MOVING`. PR #23 covers semantic-boundary admission of authored physical observations. PR #25 covers grounded Wilson body mutation and edge-driven death semantics after admitted impacts. PR #27 covers grounded death → run lifecycle. PR #29 covers committed defense → route-aware concrete motion interruption/redirection. PR #31 covers representative shared due scheduling for drives and dynamic processes with conserved skipped elapsed time. PR #33 covers gradual environment threshold crossing and same-step semantic event coalescing. Gerald semantics and the single integrated accident/timing trace remain deliberately deferred so failures remain attributable to one boundary at a time.

---

# Review checklist

The consuming implementation agent should resolve each item below.

- [x] Treat `SimulationCadenceClock(0.1)` as a deterministic engine→semantic bridge, not a cognition frequency. **Canonicalized in `SIMULATION_ORCHESTRATION.md`; concrete host exists without making the bridge a universal subsystem clock.**
- [x] Preserve one authoritative simulation-time model rather than creating independent subsystem clocks by default. **Canonicalized and preserved; `SemanticDueScheduler` is shared by representative drive/process owners in PR #31 rather than replaced by independent clocks.**
- [x] Define/implement bounded passive spatial perception during movement; perception must not wait for `ARRIVED`. **Validated by PRs #18/#19 with real `Area3D`/shape broadphase, bounded moving refresh, metric/LOS revalidation and evidence while `MOVING`.**
- [x] Keep event-driven perception for meaningful engine/world changes alongside passive refresh. **Event perception remains separate; PR #23 validates authored engine observation admission into that event path, PR #33 validates gradual environment threshold facts entering the same `WorldEvent` path, and passive refresh remains complementary.**
- [x] Ensure perception can occur without automatically triggering broad intentional reconsideration. **Validated by `passive_spatial_perception_test.gd` and PR #21: ordinary evidence keeps reconsideration `NONE`.**
- [x] Ensure immediate threats reach the threat routing regime at the next admissible semantic boundary. **PR #21 adds `PerceivedThreatTriggerSource`; evidence admitted by the same authored `PerceivedThreatService` rules derives `THREAT` before gate coalescing, and PR #29 validates that the resulting committed defensive intention can cancel/redirect concrete Godot motion.**
- [x] Keep gradual systems due/time-driven and cognition boundary/event-driven. **PR #31 wires representative Wilson drives and environment dynamic processes through one shared `SemanticDueScheduler` using owner-local `DueElapsedGate`s. Skipped heartbeat elapsed is conserved, missed periods coalesce into one owner invocation, and drive cognition still wakes only when the existing urgency-band crossing occurs. Sparse maintenance remains deferred until representative work requires it rather than constituting a second clock.**
- [x] Coalesce/threshold gradual physical/environmental changes before producing semantic event spam. **PR #33 validates the general application boundary on gradual environment truth: successful numeric transitions remain World changes, authored property/direction thresholds emit only actual crossings, and duplicate same-step rule/subject crossings coalesce into one deterministic non-action `WorldEvent`. Discrete physical thresholds remain separately covered by PRs #23/#25; future gradual physical owners can reuse the same policy shape when introduced.**
- [x] Confirm complex same-step physical observations preserve deterministic causal ordering; add sequence/time metadata only if representative cases prove it necessary. **PR #14 preserves insertion order; PR #23 preserves it through semantic drain/admission and PR #25 through body consequence resolution. Sequence/timestamp metadata remains deliberately deferred until a representative accident demonstrates ambiguity.**
- [ ] Add or plan an integrated timing scenario similar to the proposed 20 m walk / Gerald / falling-palm trace. **All prerequisite component boundaries are now separately covered through PR #33: movement/passive perception, threat wake-up, defensive execution, physical admission/body consequence, shared due scheduling, and gradual semantic threshold/coalescing. What remains is the single integrated timing scenario plus Gerald-specific scene semantics.**

## Consumption progress

- PR #16 canonicalized bridge cadence, trigger gating, passive-moving perception requirements and semantic threshold/coalescing rules.
- PR #17 implemented `SemanticDueScheduler`, `ReconsiderationGate`, trigger coalescing, quiet-step `NONE` behavior, Godot motion host/adapters and semantic/physics separation.
- PR #18 implemented the application-side passive spatial perception path and proved ordinary passive evidence can occur while `MOVING` without forcing broad reconsideration.
- PR #19 added the real-engine integration fixture and validated `CharacterBody3D` collision, `NavigationAgent3D` routing, navmesh detour, bounded passive broadphase/revalidation, edge-driven evidence during `MOVING`, and real clear/occluded LOS.
- PR #21 adds perception-derived threat trigger synthesis through `PerceivedThreatService` and validates that authored threat evidence wakes immediate-threat routing while motion remains `MOVING`, whereas ordinary evidence still leaves cognition at `NONE`.
- PR #23 adds semantic-boundary physical observation draining plus authored consequence admission, validates below-threshold rejection and deterministic observation order, and routes admitted non-action physical facts through ordinary `WorldEvent → perception/evidence` without fabricating an `ActionExecution`.
- PR #25 adds minimal World-owned `WilsonBodyState`, authored impact-to-damage policy, structured physical consequence resolution with `SemanticChangeSet`, clamped vitality, one-shot `alive → dead` transition, and reuse of the existing resurrection port so physical restoration still precedes lifecycle revival.
- PR #27 propagates an already-committed authored Wilson death event into `RunLifecycleState.ACTIVE → DEAD` without lifecycle reading body vitality or Godot callbacks.
- PR #29 adds `EscapeDestinationResolver` and `DefensiveMotionExecutionCoordinator`, validating deterministic route-aware escape selection, cancellation-before-redirection, the same-chain threat-selection→motion boundary, and concrete real-engine `NavigationAgent3D` redirection toward escape.
- PR #31 adds key-local due consumption plus `DueElapsedGate`, validates drives and dynamic processes sharing one scheduler independently, conserves elapsed across skipped semantic heartbeats, coalesces missed due periods, and proves cognition remains boundary-driven rather than heartbeat-driven.
- PR #33 adds authored gradual semantic boundary rules and event projection, exposes successful dynamic-process previous/current transitions, validates sub-threshold numeric changes without event spam, and coalesces duplicate same-step crossings into one deterministic semantic fact.

The review intentionally remains **OPEN** because the remaining unchecked item is the representative integrated timing scenario rather than documentation-only cleanup.

## Completion record

**Consumed by:** PR #16 (partial), PR #17 (partial), PR #18 (partial), PR #19 (partial), PR #21 (partial), PR #23 (partial), PR #25 (partial), PR #27 (partial), PR #29 (partial), PR #31 (partial), PR #33 (partial)  
**Latest validated consumption:** PR #33 — strict runner `50 PASS / 50 TOTAL` under Godot 4.7.1; real-engine spatial fixture remains part of the strict suite  
**Completion date:** _pending integrated timing scenario_  
**Rejected/deferred recommendations and rationale:** stable sequence/physics timestamp metadata for `PhysicalObservation` remains deferred until a representative same-step accident demonstrates that insertion ordering is insufficient. Sparse maintenance due work is deferred until representative behavior requires it; PR #31 establishes the shared mechanism without inventing maintenance work. PR #33 resolves the architectural gradual threshold/coalescing item on the environment path; equivalent future gradual physical owners should author matching policies only when such owners exist. The full 20 m / Gerald / falling-palm regression is now the remaining review item and should be implemented as the next representative integration slice.
