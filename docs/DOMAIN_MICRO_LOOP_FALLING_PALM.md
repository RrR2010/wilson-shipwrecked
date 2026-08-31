# Falling Palm — Hazard Micro-Loop Fixture

## Status and purpose

This document stress-tests the language-neutral functional domain with representative scene **37 — The Falling Palm**.

The scene pressures a different part of the runtime than `Scientific Method`:

- latent environmental danger;
- incomplete Wilson knowledge;
- sensory warning cues;
- escalation into the immediate-threat regime;
- route obstruction;
- defensive action selection under time pressure;
- concurrent player intervention;
- committed environmental motion whose final collision is not yet determined;
- grounded injury/death resolution;
- post-event learning and persistent spatial behavior.

The fixture is not a scripted scene. It demonstrates that ordinary domain rules can converge on the visible sequence and its variations.

---

# 1. Scene truth before Wilson notices danger

Example authoritative state:

```text
palm_17
  category: palm
  structural_integrity: LOW
  stability: LOW
  effective_mass: VERY_HIGH
  height_class: HIGH
  capabilities: structural_member, falling_hazard_candidate

storm
  wind_strength: HIGH
  gust_variability: MEDIUM

camp_clutter_04
  effective_mass: MEDIUM
  blocks one local escape corridor

Wilson
  place: work_area
  current_intention: continue_work_project
  current_action: work_at_surface
  body: healthy enough to run
```

Wilson cognition may still contain only:

```text
storm is active
palm_17 is nearby
no strong belief that palm_17 is about to fall
```

The world is already dangerous without Wilson knowing it.

---

# 2. Required hazard concepts

The scene requires four concepts that should remain distinct.

## 2.1 HazardSource

An authoritative world subject/process capable of causing harmful future overlap.

Examples:

```text
falling palm
rolling barrel
flying debris
fire front
collapsing panel
sliding rock
```

This is not a persisted universal `hazard=true` flag. Hazard relevance is derived from current dynamics and context.

## 2.2 DynamicProcessState

Longer-than-instant authoritative physical evolution needs explicit phase semantics.

```text
DynamicProcessState
  id: DynamicProcessId
  kind: DynamicProcessKindId
  subjects: RuntimeWorldRef[]
  phase: PREPARING | COMMITTED | RESOLVING | COMPLETE
  started_at
  parameters: bounded semantic values
```

For the palm:

```text
storm stress
→ trunk yielding
→ COMMITTED fall
→ trajectory advances
→ collision/resolution
```

Once `COMMITTED`, the process itself cannot be rewound by reconsideration or ordinary intervention. Its *future consequences* may still vary because other world subjects can move before resolution.

## 2.3 HazardProjection

A derived authoritative projection of possible harmful future occupancy/effect.

```text
HazardProjection
  source_process_id
  horizon: bounded Duration
  affected_region / semantic corridor
  severity_range
  confidence/uncertainty from physical model
  resolvable_before_impact: bool
```

This may be coarse. It is not a full rigid-body future simulator.

Examples:

```text
fall corridor of palm crown/trunk
rolling barrel downhill corridor
likely debris cone
```

## 2.4 PerceivedThreat

Wilson must not consume `HazardProjection` directly unless perception provides corresponding evidence.

```text
world dynamic process / cues
→ PerceptualEvidence
→ PerceivedThreat
→ immediate-threat path
```

Wilson may react late, incorrectly, or not at all if cues are inaccessible.

---

# 3. Frame-group sequence

## FG0 — Ordinary work under latent risk

Normal loop:

```text
advance storm
advance current work action
advance palm stress process
```

No immediate-threat decision occurs yet because Wilson has no sufficient perceptual evidence.

Authoritative mutation may gradually reduce:

```text
palm structural_integrity
palm stability
```

via `EnvironmentalResponseRule` / environmental process semantics.

Possible branch:

- palm recovers/no dangerous gust arrives;
- Wilson leaves naturally before danger;
- player moves Wilson-relevant objects for unrelated reasons;
- danger continues to build.

No `FallingPalmScene` state exists.

---

## FG1 — First crack: anomaly, not yet necessarily emergency

A gust crosses a structural threshold.

Authoritative event:

```text
WorldEvent:
  palm_joint_shifted / structural_crack
```

Perception may generate auditory + visual evidence:

```text
AUDITORY: sharp crack nearby
VISUAL: trunk movement / crown sway anomaly
```

Wilson learning/interpretation may produce:

```text
likely_unstable(palm_17) confidence +=
```

Trigger routing can still choose `TACTICAL` or `INTENTIONAL` reconsideration if the threat estimate remains below emergency threshold.

Possible Wilson reaction:

```text
look up / inspect source
pause work
move slightly
ignore as ordinary storm noise
```

This allows the scene to remain uncertain before the second crack.

---

## FG2 — Second crack / dynamic commitment

The palm crosses a physical commitment threshold.

```text
DynamicProcessState(palm_fall_17)
  PREPARING → COMMITTED
```

Authoritative facts now include:

```text
palm is falling
fall direction/corridor constrained by current world geometry + force state
```

Important invariant:

```text
COMMITTED fall != Wilson will be hit
```

The fall cannot simply return to standing, but Wilson, clutter and vulnerable camp objects may still move before collision.

A `HazardProjection` is derived for authoritative resolution/debugging.

Perception produces strong accessible cues:

```text
large trunk rotation
rapid crown movement
second crack
falling direction relative to Wilson
```

`DetectImmediateThreat` now receives **PerceivedThreat**, not omniscient hidden trajectory data.

If the accessible evidence crosses the emergency threshold:

```text
ReconsiderationScope = IMMEDIATE_THREAT
```

The ordinary work intention is interrupted/suspended if interruption semantics permit it.

---

## FG3 — Defensive candidate generation

Immediate-threat candidate generation is bounded and local.

Examples:

```text
run_clear_corridor_A
run_clear_corridor_B
dodge_short_left
dodge_short_right
duck/protect_head if escape insufficient
drop_held_item_then_run
```

The generator may use Wilson-accessible spatial projection plus body/action state.

It must not use hidden exact future collision truth.

Candidate feasibility uses authoritative **attemptability** before start:

```text
Can Wilson release held item?
Can Wilson accelerate/run?
Is corridor physically traversable now?
```

Candidate evaluation prioritizes survival regime semantics without infinity scores.

Typical bounded contributions:

```text
estimated threat reduction
estimated time-to-safety
route effort
known obstruction
body mobility
carried-load penalty
uncertainty
```

---

## FG4 — Drop object / begin escape

If Wilson is holding something bulky/heavy, a defensive action may be:

```text
action.drop(item)
```

This is not a special panic mechanic. It is an ordinary physical action selected by the threat regime because it improves movement affordances.

Effects:

```text
remove held_by / carried_by relation
place item at current world location
```

Then:

```text
action.run(destination/corridor)
```

starts and progresses.

The palm's committed dynamic process advances concurrently.

This is an important orchestration case:

```text
Wilson action progression
+
committed environmental process progression
+
possible player intervention
```

all exist during the same semantic interval.

---

# 4. Concurrent process ordering

The scene requires deterministic ordering for concurrent authoritative changes.

Within one simulation step/group boundary, use the conceptual ordering:

```text
1. accept/validate already-issued commands at their legal boundary
2. advance actor actions up to the next semantic boundary
3. advance committed dynamic processes up to the same boundary
4. apply committed mutations in deterministic causal order
5. resolve overlaps/collisions produced by those committed states
6. emit WorldEvents / ActionOutcomes
7. perceive / learn / reconsider for the next boundary
```

A presentation frame does not determine authority ordering.

If two consequences occur at the same semantic instant, deterministic tie-break rules must exist and be traceable; do not use render callback order.

---

# 5. Player intervention during the fall

The player may intervene only through declared `InterventionCapability` on valid targets.

Possible interventions include:

```text
move/remove camp_clutter_04
move a vulnerable loose prop
alter a physically supported environmental subject
```

The player cannot directly set:

```text
Wilson.current_intention = escape
Wilson.trust += ...
palm_fall_17.phase = cancelled
```

unless an authored intervention truly changes the world such that the physical process resolves differently.

## 5.1 Intervention window semantics

An intervention is valid only if it commits before the relevant causal boundary.

Example:

```text
clutter moved before Wilson reaches blocked corridor
→ route becomes physically clear
```

But:

```text
clutter moved after Wilson collides with it
→ cannot retroactively clear the collision
```

Similarly:

```text
palm-support intervention before fall commitment
→ may prevent the fall if supported by authored physics/intervention

palm-support intervention after fall commitment
→ may influence later trajectory only if the capability explicitly supports doing so;
  it may not silently restore the standing palm
```

This preserves causality while still making God Power valuable.

---

# 6. Route obstruction

Route queries need two distinct projections.

## 6.1 Authoritative route state

Used for actual movement attemptability/resolution:

```text
QueryRoutePhysical(...)
```

It sees actual clutter/geometry.

## 6.2 Wilson route estimate

Used for defensive candidate evaluation:

```text
DerivePerceivedRouteOptions(...)
```

It sees only Wilson-accessible/remembered obstruction state.

In this scene the clutter is normally visible/known, so both agree.

But the distinction prevents future scenes from granting Wilson omniscient route knowledge around unseen hazards.

---

# 7. Collision resolution

The committed palm process eventually produces a collision query against current authoritative world state.

Possible outcomes:

### Escape

```text
Wilson outside hazardous occupancy at collision time
→ no body impact
```

### Debris injury

```text
secondary debris overlaps Wilson
→ BodyMutationEffect(APPLY_CONDITION / vitality change)
→ serious injury possible
```

### Direct impact

```text
palm/trunk harmful region overlaps Wilson
→ grounded body resolution
→ injury or death according to bounded physical semantics
```

Death remains a world/body consequence, never an emergency decision output.

---

# 8. Camp damage

The same dynamic process can collide with ordinary entities/structure pieces.

Examples:

```text
roof panel detached
work surface damaged
storage displaced
materials scattered
```

Use ordinary effects/relations/property mutations.

This means the hazard creates persistent history even if Wilson escapes.

No separate `scene_damage_state` is required.

---

# 9. Post-event perception and learning

After danger resolves, normal cognition resumes.

Wilson can perceive:

```text
fallen palm
impact location
camp damage
his injury if any
cleared/moved obstruction
```

Learning may generate:

```text
dangerous(damaged_palm_category/context)
likely_property(palm_17, stability, low)
causes_or_enables(strong_storm + weakened_tall_structure, falling_hazard)
expected_relation(escape corridor, should_remain_clear, ...)
```

The exact proposition vocabulary should remain generic.

Persistent behavior may later emerge as:

```text
avoid visibly damaged palms during storms
prefer work locations away from unstable tall structures
clear clutter from commonly used escape/access corridors
```

These are beliefs/habits/project opportunities, not a new `storm_safety` personality primitive.

---

# 10. Player attribution after intervention

If the player clears clutter during the emergency, Wilson does not receive private intervention intent.

He may observe:

```text
clutter unexpectedly moved
route became clear
```

Then ordinary causal attribution may consider:

```text
natural displacement
self-caused movement
unseen presence
unknown cause
```

Presence relationship changes only through accessible observation + attribution evidence.

---

# 11. Variations proved by the fixture

## 11.1 Wilson escapes alone

```text
threat perceived early enough
+ viable corridor
+ sufficient mobility
→ escape
```

## 11.2 Player clears route

```text
valid intervention commits before route conflict
→ authoritative route changes
→ Wilson movement succeeds where it otherwise would fail/slow
```

Wilson need not know why.

## 11.3 Player affects falling environment

Allowed only where a specific intervention capability changes current world dynamics without violating process commitment.

No generic `cancel hazard` power exists.

## 11.4 Wilson injured by debris

Secondary hazard projection/process resolves independently from the main trunk impact.

## 11.5 Wilson dies

Grounded collision/body consequence enters normal death lifecycle.

## 11.6 Wilson never notices first crack

Sensory evidence below threshold delays threat transition; later cues may still trigger emergency behavior.

---

# 12. Domain refinements exposed

The fixture proves the need for these normalized concepts:

```text
DynamicProcessState
HazardProjection
PerceivedThreat
InterventionWindow / causal-boundary validation
QueryRoutePhysical
DerivePerceivedRouteOptions
```

They are refinements of existing environment/action/perception/orchestration responsibilities, not new state-owning systems.

`HazardProjection` and `PerceivedThreat` are derived.

`DynamicProcessState` is durable only while a multi-step authoritative world process must survive simulation boundaries/save-load/offline policy.

---

# 13. Anti-models rejected

Do not introduce:

```text
FallingPalmSceneState
panic_score = infinity
AI reads hidden exact collision time
player intervention rewinds committed collision
render animation callback decides death
hazard=true permanent entity flag everywhere
universal physics trajectory simulator
storm_safety personality trait
```

---

# 14. Fixture gate

`Falling Palm` passes when:

- latent danger can exist without Wilson knowledge;
- cues can progressively escalate perceived threat;
- emergency selection is bounded and local;
- Wilson may drop ordinary carried objects to improve escape;
- route obstruction is physical truth while Wilson uses only perceived route knowledge;
- committed palm motion cannot be rewound;
- future collision remains sensitive to legitimate concurrent movement/intervention;
- player intervention obeys causal windows;
- injury/death is grounded in body/world resolution;
- camp damage persists through ordinary world mutations;
- post-event safety behavior emerges through beliefs/habits rather than a new psychology subsystem.

Result after this fixture: **PASS with hazard-dynamics refinements.**
