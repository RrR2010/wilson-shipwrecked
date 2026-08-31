# Hazard Dynamics Domain

## Status and purpose

This document is the canonical language-neutral refinement for time-extended physical hazards exposed by the `Falling Palm` micro-loop.

It complements:

- `DOMAIN_PROCEDURAL_COMPOSITION.md`;
- `DOMAIN_MICRO_LOOP.md`;
- `DOMAIN_OPERATION_REFINEMENTS.md`;
- `SIMULATION_ORCHESTRATION.md`;
- `MUTATION_AUTHORITY.md`.

The goal is to support dangerous moving/collapsing world processes without introducing a full future physics simulator or scripted hazard scenes.

---

# 1. Core distinction

A hazard may be physically committed before its final consequence is determined.

```text
committed process
!=
committed collision victim/result
```

Example:

```text
palm has begun falling irreversibly
```

while:

```text
Wilson may still escape
player may still clear clutter
secondary debris may follow different paths
camp objects may move before impact
```

This distinction is required for causal, interactive emergencies.

---

# 2. DynamicProcessState

Use `DynamicProcessState` when authoritative world evolution spans more than one semantic boundary and must survive orchestration/save-load boundaries.

```text
DynamicProcessState
  id: DynamicProcessId
  kind: DynamicProcessKindId
  subjects: RuntimeWorldRef[]
  phase: PREPARING | COMMITTED | RESOLVING | COMPLETE
  started_at: SimulationTime
  parameters: bounded semantic values
```

Examples:

```text
falling palm
rolling barrel
sliding rock
collapsing panel
wind-driven sheet
```

A process is not automatically dangerous; danger is contextual.

---

# 3. Process commitment

`PREPARING` may still be prevented by ordinary physical change when rules permit.

`COMMITTED` means the process's core physical transition cannot be silently rewound.

Examples:

```text
standing palm → yielding
PREPARING

palm rotational fall begins
COMMITTED
```

After commitment:

- Wilson cognition cannot cancel it;
- Director cannot cancel it;
- ordinary reconsideration cannot cancel it;
- presentation callbacks cannot cancel it;
- player intervention may only alter later physical state if a declared intervention capability supports doing so.

---

# 4. HazardProjection

`HazardProjection` is a derived authoritative estimate of future harmful overlap/effect from current world dynamics.

```text
HazardProjection
  source_process_id: DynamicProcessId
  horizon: Duration
  affected_region: SemanticSpatialRegion
  severity_range
  uncertainty
  next_causal_boundary
```

It is intended for:

- physical collision/resolution planning;
- authoritative validation;
- debug traces;
- bounded opportunity queries.

It is not automatically Wilson knowledge.

The implementation may use coarse semantic corridors/volumes rather than continuous rigid-body prediction.

---

# 5. PerceivedThreat

Wilson's emergency cognition consumes `PerceivedThreat`, derived only from accessible sensory/belief context.

```text
PerceivedThreat
  source_subjects
  estimated_direction/region
  estimated_severity
  estimated_urgency
  confidence
  evidence_refs
```

Pipeline:

```text
world dynamics / WorldEvent
→ sensory accessibility
→ PerceptualEvidence
→ threat interpretation
→ PerceivedThreat
→ IMMEDIATE_THREAT candidate generation
```

Do not pass `HazardProjection` directly into Wilson cognition.

---

# 6. Threat escalation

Not every hazard cue immediately invokes emergency behavior.

Example:

```text
first crack
→ anomaly / concern

second crack + visible rapid movement
→ immediate threat
```

Threat routing may therefore be:

```text
NORMAL
→ TACTICAL / INTENTIONAL concern
→ IMMEDIATE_THREAT
```

based on accessible urgency/severity evidence.

---

# 7. Defensive candidates

Immediate-threat candidates remain ordinary semantic intentions/actions under a constrained regime.

Typical actions:

```text
run
dodge
drop held object
move behind cover
duck/protect
```

No `panic action scripting` is required.

Candidate evaluation may use bounded emergency-specific contribution families:

```text
estimated threat reduction
time-to-safety
route effort
known obstruction
mobility
load penalty
uncertainty
```

Do not use infinity scores.

---

# 8. Authoritative versus perceived routing

Physical movement and Wilson planning must remain separate.

Authoritative:

```text
QueryRoutePhysical(...)
ResolveMovement(...)
ResolveCollision(...)
```

Wilson-relative:

```text
DerivePerceivedRouteOptions(...)
EstimateThreatReduction(...)
```

Wilson may choose a route that is actually worse if an obstruction/hazard is unknown.

---

# 9. Causal boundaries and intervention windows

A time-sensitive mutation is valid only before the causal boundary it intends to affect.

```text
InterventionWindow
  target_process/event
  opens_at
  closes_at / causal_boundary_id
  permitted_effect_classes
```

This need not be persisted as a universal object if derivable from current process state; it is a semantic validation concept.

Examples:

```text
move clutter before Wilson reaches it
→ affects route

move clutter after Wilson collision committed
→ cannot retroactively affect route
```

```text
support palm before fall commitment
→ may prevent fall

attempt same support after commitment
→ cannot restore standing state
```

---

# 10. Concurrent semantic-step ordering

When actor action, environmental process and intervention coexist, orchestration must use deterministic semantic boundaries.

Canonical conceptual ordering:

```text
validate commands valid at current boundary
→ advance actor actions to next boundary
→ advance dynamic processes to same boundary
→ apply committed mutations in deterministic causal order
→ resolve overlaps/collisions
→ emit outcomes/events
→ perception / learning / next decision
```

Exact implementation batching may differ, but must preserve equivalent causal semantics.

Render callback order is never authoritative.

---

# 11. Secondary hazards

A primary dynamic process may create secondary processes/events.

Examples:

```text
falling palm
→ detached frond
→ secondary debris process
```

```text
collapsing shelf
→ falling container
→ spilled contents
```

Secondary hazards use the same `DynamicProcessState`/projection semantics where they span boundaries.

Do not introduce scene-specific hazard subclasses unless a reusable rule cannot express the behavior.

---

# 12. Grounded injury/death

Emergency selection never directly causes injury/death.

```text
authoritative overlap/collision
→ physical/body resolution
→ BodyMutationEffect
→ WorldEvent / observation
```

Death remains a grounded body/world consequence entering the normal death lifecycle.

---

# 13. Persistence policy

Persist `DynamicProcessState` only when a process spans a persistence boundary and replay/save-load correctness requires continuity.

Do not persist:

```text
HazardProjection
PerceivedThreat
route estimates
candidate defenses
```

unless a later proven requirement explicitly changes their lifetime.

---

# 14. Debug/explainability

Recommended derived diagnostics:

```text
ExplainDynamicProcess(process_id)
ExplainHazardProjection(process_id)
ExplainPerceivedThreat(threat_ref)
ExplainInterventionWindow(target_ref)
```

Useful trace questions:

- why did the process become committed?
- what future region was physically at risk?
- what evidence did Wilson actually have?
- why did Wilson select this escape action?
- was a player intervention early enough to matter?
- which mutation/collision grounded the injury?

---

# 15. Regression targets

The same semantics should support, without new primitive families:

```text
Falling Palm
rolling full barrel on slope
wind-displaced sheet/panel
falling branch
collapsing damaged shelter component
sliding wet object on incline
secondary storm debris
```

---

# 16. Hazard dynamics gate

PASS when:

- process commitment and consequence commitment are distinct;
- Wilson uses perceived threat rather than omniscient future truth;
- defensive behavior uses ordinary bounded actions;
- routes have authoritative and Wilson-relative projections;
- interventions obey causal windows;
- concurrency ordering is deterministic;
- injury/death is collision/body grounded;
- no universal future physics simulator is required.

Current result after `Falling Palm`: **PASS**.
