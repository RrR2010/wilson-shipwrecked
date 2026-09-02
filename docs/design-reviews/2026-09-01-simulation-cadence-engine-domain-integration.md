# Design Review — Simulation Cadence and Engine/Domain Integration

**Status:** OPEN  
**Date:** 2026-09-01  
**Reviewed target:** PR #14 — `Establish Godot spatial and simulation-loop boundary`  
**Primary evidence:** `docs/brainstorming/representative-scene-catalog.md`, `docs/SIMULATION_ORCHESTRATION.md`, `docs/DOMAIN_MICRO_LOOP.md`

## Purpose

Calibrate the proposed Godot/domain timing boundary against the representative scene catalog before the engine-integration work becomes deeper and harder to change.

This review is advisory evidence, not a canonical architecture owner. If implementation work consumes this review, the consuming agent must resolve the checklist below and then change this file to `Status: COMPLETED`, recording the consuming PR/commit and any deliberately rejected recommendation with rationale.

---

# Executive assessment

The PR #14 direction is sound and is potentially capable of supporting the representative scenes.

The strongest choices are:

- render/physics cadence does not define cognition cadence;
- a deterministic semantic bridge accumulates fine engine time;
- movement progresses in the engine without forcing cognition every physics frame;
- physical callbacks become typed observations rather than direct World mutation;
- fine distance/navigation/visibility remains behind explicit semantic ports;
- Godot scene identity remains distinct from durable domain identity.

The main calibration required is this:

> The current `0.1 s` cadence should be treated as a deterministic physics-to-semantic bridge, not as a universal frequency for perception, cognition or every simulation system.

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

**Assessment:** supported by the proposed boundary if event perception can produce a small reaction without forcing global candidate competition.

## Breakfast First

Required behavior:

```text
Wilson walks toward storage
→ fruit becomes visible during movement
→ Wilson notices it
→ habit/current intention may still win
→ movement can continue
```

**Assessment:** requires perception during `MOVING`, using current Godot-backed spatial state rather than only arrival events.

## The Long Way Around

Godot can report objective route cost while Wilson's cognition adds learned subjective aversion/history.

Example:

```text
short route = 8 m + strong learned aversion
long route  = 14 m + no learned aversion
```

**Assessment:** the engine/domain separation is especially suitable for this scene. Objective navigation truth and Wilson-relative desirability should remain separate.

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

**Assessment:** strongly aligned with the existing micro-loop contract.

## The Missing Spoon

Wilson does not need to continuously perceive the moved spoon while asleep. The important boundary can be an expectation mismatch when the habitual reach fails, followed by a bounded search/perception refresh.

**Assessment:** event/anomaly-driven cognition is preferable to continuous polling.

## Gerald

Useful perceptual boundaries include:

- Gerald entering a relevant nearby region;
- Gerald becoming visible;
- Gerald changing trajectory in a semantically relevant way, such as approaching protected food.

**Assessment:** supported, but avoid requiring cognition to inspect raw trajectory every physics frame.

## Storm Priorities

Continuous physical/weather values should normally emit semantic events only when useful thresholds or facts change.

Prefer:

```text
object_started_sliding
possession_became_unsecured
wind_became_dangerous
```

rather than emitting every tiny numeric wind change.

**Assessment:** requires semantic thresholding/coalescing, otherwise the event stream will become noisy.

## Falling Palm / Victory Lap / Faster Than Walking / Brilliant Shortcut / Unwanted Rescue

These scenes contain accidents that develop across multiple physics frames and may require timely intervention/reaction.

**Assessment:** the 0.1 s semantic bridge is fast enough as an initial default, but physical observations inside one semantic batch should preserve enough causal ordering to resolve complex accidents deterministically.

---

# Physical observation ordering

PR #14 currently preserves callback insertion order in `GodotPhysicalObservationBuffer`, which is a good minimum.

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

`MotionPort` is correctly minimal at this stage, but the simulation must be able to observe semantically relevant spatial facts while motion remains `MOVING`.

The following must be possible:

```text
Wilson starts a long move
→ engine progresses continuously
→ current transform changes
→ passive/event perception can query current distance/visibility
→ meaningful evidence may trigger tactical/threat reconsideration
→ movement may continue, redirect or cancel
```

Do not reduce movement semantics to only:

```text
request_move
→ wait
→ ARRIVED
→ think again
```

That model would make several representative scenes impossible or visibly late.

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

A critical threat does not require a second simulation architecture. It should use the same causal path with a high-priority routing regime and reach it at the next admitted semantic boundary.

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

Likewise, do not make cognition run at 10 Hz merely because the physics-to-semantic bridge runs at 10 Hz.

---

# Proposed integration test

A representative timing regression should eventually prove a trace similar to:

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

The test should assert semantic ordering and routing, not exact render-frame counts.

---

# Review checklist

The consuming implementation agent should resolve each item below.

- [ ] Treat `SimulationCadenceClock(0.1)` as a deterministic engine→semantic bridge, not a cognition frequency.
- [ ] Preserve one authoritative simulation-time model rather than creating independent subsystem clocks by default.
- [ ] Define/implement bounded passive spatial perception during movement; perception must not wait for `ARRIVED`.
- [ ] Keep event-driven perception for meaningful engine/world changes alongside passive refresh.
- [ ] Ensure perception can occur without automatically triggering broad intentional reconsideration.
- [ ] Ensure immediate threats reach the threat routing regime at the next admissible semantic boundary.
- [ ] Keep gradual systems due/time-driven and cognition boundary/event-driven.
- [ ] Coalesce/threshold gradual physical/environmental changes before producing semantic event spam.
- [ ] Confirm complex same-step physical observations preserve deterministic causal ordering; add sequence/time metadata only if representative cases prove it necessary.
- [ ] Add or plan an integrated timing scenario similar to the proposed 20 m walk / Gerald / falling-palm trace.

## Completion record

When all applicable items are resolved, replace the status at the top with `COMPLETED` and fill this section.

**Consumed by:** _pending_  
**Completion date:** _pending_  
**Rejected/deferred recommendations and rationale:** _pending_
