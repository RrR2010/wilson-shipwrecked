# Handoff — Long Way Around → Next Representative Gameplay Primitive

## Status

The **Long Way Around** representative gameplay vertical is complete and locally validated.

Latest strict local gate reported by the operator:

```text
PASS long_way_around_scenario_test

RESULT: 83 PASS / 83 TOTAL
PASS headless_suite (83 tests)
```

Do not reinterpret this handoff as durable architecture authority. Canonical rules remain in the architecture/domain documents; concrete implementation status lives in `docs/DISCOVERY_STATUS.md`.

---

# What this vertical added

The new reusable primitive is a Wilson-relative route preference layer that preserves the distinction between physical route truth and remembered desirability.

Validated chain:

```text
SpatialQueryPort / GodotSpatialQueryAdapter
→ physical route viability + route cost

AssociationStore
→ Wilson-relative remembered valence

RememberedRoutePreferenceService
→ stateless adjusted route comparison

RememberedRouteMotionCoordinator
→ multi-waypoint MotionPort progression

GodotMotionAdapter
→ real navigation and visible detour
```

The concrete scenario proves:

```text
short route remains physically valid
+ short route remains physically cheaper
+ Wilson has a strong negative association with its semantic route subject
→ adjusted preference reverses
→ Wilson chooses a longer route
→ Wilson visibly leaves the direct corridor
→ Wilson still reaches the ordinary goal
```

---

# New implementation surface

Application-layer types:

```text
src/application/simulation/remembered_route_option.gd
src/application/simulation/remembered_route_preference_service.gd
src/application/simulation/remembered_route_motion_coordinator.gd
```

Validation:

```text
tests/headless/remembered_route_preference_test.gd
tests/headless/remembered_route_motion_coordinator_test.gd
tests/headless/long_way_around_scenario_test.gd
tests/scenes/long_way_around/long_way_around.gd
tests/scenes/long_way_around/long_way_around.tscn
```

---

# Important contracts

## 1. Physical route truth remains spatial authority

`SpatialQueryPort` answers whether a route exists and what it physically costs.

A negative memory must **not** make `has_route()` false, mutate a navmesh, or alter World truth.

## 2. Remembered desirability remains cognition-owned

The current slice reads `AssociationStore` valence for semantic route subjects.

A remembered aversion affects route preference only through a derived score.

## 3. Route preference is reconstructible

`RememberedRoutePreferenceService` owns no persistent state.

Given equivalent:

```text
spatial truth
+ route options
+ cognition-owned associations
```

it reconstructs the same preference.

## 4. Motion progression is not a second authority store

`RememberedRouteMotionCoordinator` persists no waypoint index.

Progress is inferred from:

```text
MotionPort status
+ MotionPort current target
+ selected route waypoint sequence
```

This avoids a parallel `RouteState` authority that could drift from actual motion.

## 5. Godot remains an outer adapter

The Godot scene binds stable `RuntimeWorldRef`s through `GodotSceneSpatialRegistry`.

Node names, transforms, navigation agents and scene paths do not become domain identity or cognition state.

---

# Lessons from the real-engine fixture

The initial fixture exposed a navigation readiness issue: a valid navigation-map RID and nonzero iteration id were not sufficient by themselves to guarantee immediately queryable paths at scene startup.

The stable fixture pattern is now:

```text
scene enters tree
→ allow initial physics frames
→ construct/bind runtime adapters
→ wait for valid navigation map / iteration
→ allow a short additional settle
→ prove raw NavigationServer3D path exists
→ run SpatialQueryPort-based evaluation
```

Do not generalize this into a new production engine composer yet. It is test/adapter evidence, not sufficient pressure for another abstraction.

Also avoid rigid coordinate assertions for visible route behavior. `NavigationAgent3D` may cut corners within path/target tolerances. Prefer assertions about material spatial deviation from a direct corridor plus final goal arrival.

---

# Deliberately not implemented

This slice does **not** yet define:

```text
how route aversion is initially learned
route-memory decay
route-memory generalization to related places/features
urgency vs aversion tradeoffs
habitual route formation
full path graph learning
persistent authored route plans
scene/node-derived semantic route identity
```

Add these only when a representative product-visible scenario requires them.

---

# Recommended next major vertical

Choose **one** representative scene that introduces a distinct missing primitive rather than another route variation.

Leading candidates:

### A. Richer Gerald relationship / behavior semantics

Good if the goal is to exercise:

```text
non-Wilson actor state
+ Wilson perception/belief
+ relationship/association state
+ repeated interaction changing future behavior
```

Avoid simply adding more hardcoded `ActorBehaviorRule`s. The desired slice should prove an actual persistent relationship consequence visible in later autonomous behavior.

### B. Physical accident authoring

Good if the goal is to exercise:

```text
dynamic physical event
→ semantic observation/admission
→ grounded body/world consequence
→ later Wilson behavior or memory
```

Prefer a concrete falling-palm or similar accident only if it forces a reusable physical-event authoring primitive rather than fixture-specific rigid-body scripting.

Do **not** implement Gerald + route learning + accident authoring in the same branch.

---

# Persistent deferrals

Still deferred unless the next scenario creates direct product pressure:

```text
snapshot v9 → v10 migration
long positional capture/bootstrap API cleanup
drive hysteresis memory persistence
Legacy-to-new-Wilson seeding policy
production scene-binding/host composer
intervention causal windows
habit disuse producers
Presence production attribution
view-cone / negative passive evidence
production falling-palm rigid-body authoring
```

---

# Workflow for the next agent

Use the standard repository discipline:

```text
latest origin/main
→ short-lived task branch
→ smallest representative vertical
→ focused tests
→ strict .\tests\run_headless_tests.ps1
→ update DISCOVERY_STATUS only after operator-reported green gate
→ PR to main
→ merge only after explicit operator authorization
```

The next agent should read:

```text
docs/DISCOVERY_STATUS.md
docs/README.md
this handoff
relevant representative-scene evidence
only the canonical domain/architecture files needed by the chosen slice
```
