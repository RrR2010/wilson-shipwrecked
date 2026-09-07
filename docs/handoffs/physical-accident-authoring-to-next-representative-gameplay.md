# Handoff — Physical Accident Authoring → Next Representative Gameplay

## Status

The physical-accident authoring vertical is complete and locally validated.

Latest strict local gate reported by the operator:

```text
RESULT: 88 PASS / 88 TOTAL
PASS headless_suite (88 tests)
```

This handoff is transition context only. Canonical architecture/domain rules remain in their owning documents; implementation status belongs in `docs/DISCOVERY_STATUS.md`.

---

# What this vertical proved

The repository already had the reusable admission/resolution path from non-authoritative engine observations into semantic and body consequences.

The genuine missing primitive was a production-shaped Godot contact observer with stable semantic identity.

Validated chain:

```text
RigidBody3D contact
→ GodotDynamicContactObserver
→ GodotSceneSpatialRegistry reverse identity lookup
→ PhysicalObservation.CONTACT
→ GodotPhysicalObservationBuffer
→ authored PhysicalObservationConsequenceRule
→ PhysicalObservationConsequenceResolver
→ semantic WorldEvent
→ authored WilsonBodyImpactRule
→ WilsonBodyImpactConsequenceResolver
→ WilsonBodyState vitality mutation
→ injury/death WorldEvent + SemanticChangeSet
```

Real-Godot fixture sequence:

```text
BOOTSTRAPPED
→ CONTACT_OBSERVED
→ EVENT_ADMITTED
→ BODY_DAMAGED
→ COMPLETE
```

The fixture uses an actual falling `RigidBody3D` collision. No physics callback mutates Wilson vitality directly.

---

# New infrastructure boundary

`GodotSceneSpatialRegistry` now supports explicit reverse lookup:

```text
Node3D → RuntimeWorldRef
```

This reverse mapping is populated only by explicit semantic binding. Node names, scene paths, instance IDs or metadata are not interpreted as domain identity.

`GodotDynamicContactObserver`:

- binds only semantically registered `RigidBody3D` nodes;
- enables Godot contact monitoring;
- converts `body_entered` into `PhysicalObservation.CONTACT`;
- records the impacted body as `subject` and the dynamic source as `other`;
- records relative speed and a coarse observed contact point;
- never decides whether contact is harmful;
- never mutates World, body, cognition or lifecycle state.

---

# Authority boundaries

Keep the chain distinct:

```text
Godot physics observation
!= admitted semantic event
!= authored body-effect policy
!= WilsonBodyState mutation
!= Wilson perception/belief/memory
```

A contact existing in Godot is not automatically damage.

Damage remains authored semantic policy through `WilsonBodyImpactRule`.

The engine adapter must not contain category-specific logic such as:

```text
if palm hits Wilson: vitality -= ...
```

---

# Deliberately not implemented

This vertical does not add:

```text
new accident-event admission framework
universal collision damage model
impulse/energy damage formulas
hazard projection changes
immediate-threat AI changes
dynamic-process persistence changes
Wilson memory acquisition from accidents
route-memory generalization
player intervention causal-window expansion
continuous non-Wilson actor motion
```

The existing `PhysicalObservationConsequenceResolver` and `WilsonBodyImpactConsequenceResolver` remain the reusable semantic boundaries.

---

# Recommended next step

Return to representative scene pressure rather than extending physics generically.

A useful next vertical should prove a player-visible causal consequence that is not already covered by the current 88-test baseline. Good candidates include:

1. post-accident Wilson learning/behavior from accessible evidence;
2. production player intervention during a committed accident with causal-window validation;
3. another representative scene that forces a distinct missing gameplay primitive.

Do not add another generic physics abstraction unless a concrete scene demonstrates a real gap.

---

# Persistent deferrals

Still deferred unless representative evidence creates direct pressure:

```text
snapshot compatibility/migration policy
SimulationSnapshotService.capture positional API cleanup
SimulationBootstrapDefinition positional constructor cleanup
drive hysteresis-band memory persistence
Legacy-to-new-Wilson seeding policy
generalized production scene-binding/host composer
continuous physical locomotion for non-Wilson actors
actor relationship decay/generalization
intervention causal windows
habit disuse/context producers
Presence production attribution
orientation/view-cone passive refresh
negative/absence perceptual evidence
route-memory acquisition/decay/generalization
```

---

# Workflow

```text
latest origin/main
→ short-lived task branch
→ representative gameplay pressure
→ smallest reusable missing primitive
→ focused tests
→ strict .\tests\run_headless_tests.ps1
→ update status/docs after operator-reported green gate
→ PR to main
→ merge only after explicit operator authorization
```
