# Handoff — Gerald Relationship → Physical Accident Authoring

## Status

The persistent Gerald relationship vertical is complete and locally validated.

Latest strict local gate reported by the operator:

```text
RESULT: 86 PASS / 86 TOTAL
PASS headless_suite (86 tests)
```

This handoff is transition context only. Canonical architecture/domain rules remain in their owning documents; concrete implementation status belongs in `docs/DISCOVERY_STATUS.md`.

---

# What this vertical added

A separate non-Wilson actor relationship authority now exists alongside actor runtime state and Wilson cognition.

Validated chain:

```text
ActorRelationshipImpact
→ ActorRelationshipStore
→ relationship-conditioned ActorBehaviorRule eligibility
→ ShallowActorAdvanceService
→ authoritative semantic actor place change
→ Godot presentation reflects changed semantic placement
```

The Gerald scenario proves:

```text
Gerald starts neutral toward Wilson
→ neutral relationship selects neutral behavior
→ repeated positive interactions accumulate durable affinity/evidence
→ later decision selects approach behavior
→ Gerald semantic place changes near Wilson
→ presentation visibly reflects the relationship consequence
```

---

# Authority boundaries

## Actor relationship != Wilson association

`AssociationStore` remains Wilson-relative cognition. Gerald's affinity toward Wilson must not be stored there.

`ActorRelationshipStore` owns actor→subject affinity/evidence for non-Wilson actors.

## Actor relationship != actor runtime state

`ActorStateStore` continues to own mode, decision cooldown and last selected rule. Relationship evidence is a separate durable concern.

## Presentation != actor-world truth

The current Gerald fixture intentionally proves semantic placement plus presentation reflection. It does **not** claim continuous physical locomotion for non-Wilson actors.

Do not promote Node3D transforms or NavigationAgent3D state into actor/world authority.

---

# Persistence

Actor relationships enter the ordinary shared bootstrap and persistence path:

```text
ActorRelationshipBootstrapSeed
→ SimulationBootstrapDefinition
→ SimulationOwnerBootstrapper
→ ActorRelationshipStore
→ SimulationOwnerSet
```

`SimulationSnapshotService` schema is now **v11** and persists `actor_relationships`.

Round-trip validation proves affinity, evidence count and last source execution id restore into a fresh relationship owner.

The existing v9/v10 migration policy remains intentionally unresolved; do not add compatibility work unless product requirements require it.

---

# Deliberately not implemented

This vertical does not yet define:

```text
continuous physical locomotion for non-Wilson actors
actor pathfinding/motion adapters
relationship decay/generalization
relationship-specific memory episodes
complex social graphs
NPC planning trees
relationship effects on Wilson cognition
production interaction producers for every relationship change
```

Add these only under representative scene pressure.

---

# Recommended next major vertical

Use a representative **physical accident** scene, preferably the existing falling-palm evidence, to force the smallest reusable physical-event authoring primitive.

Desired causal shape:

```text
world/engine physical cause
→ admitted semantic accident event
→ grounded World/body consequence
→ Wilson perception/reconsideration
→ later memory/behavior consequence when required by the scene
```

The slice should distinguish:

```text
physical engine observation
!= semantic World event admission
!= body consequence
!= Wilson belief/memory
```

Avoid fixture-specific rigid-body scripts that directly mutate cognition or health.

Before implementation, read in this order:

```text
docs/SCENE_VALIDATION.md
→ relevant falling-palm scene evidence
→ docs/DOMAIN_HAZARD_DYNAMICS.md
→ docs/DOMAIN_MICRO_LOOP_FALLING_PALM.md
→ existing physical observation / impact / body consequence runtime
→ choose the smallest missing reusable primitive
```

---

# Likely decision point

The repository already contains validated physical observation, admitted impact and WilsonBodyState consequence paths. The next agent should determine whether the genuine missing piece is:

1. production-style authoring/binding of a dynamic falling object into that path; or
2. a reusable accident-event admission service between engine physics and semantic World consequences.

Do not assume a new physics framework is required before inspecting the existing adapters/tests.

---

# Persistent deferrals

Still deferred unless the next scenario creates direct pressure:

```text
snapshot migration compatibility
capture/bootstrap positional API cleanup
drive hysteresis memory persistence
Legacy-to-new-Wilson seeding policy
production scene-binding/host composer
continuous non-Wilson actor motion
intervention causal windows
habit disuse producers
Presence production attribution
view-cone / negative passive evidence
route-memory acquisition/decay/generalization
```

---

# Workflow

```text
latest origin/main
→ short-lived task branch
→ smallest physical-accident vertical
→ focused tests
→ strict .\tests\run_headless_tests.ps1
→ update status/docs after operator-reported green gate
→ PR to main
→ merge only after explicit operator authorization
```
