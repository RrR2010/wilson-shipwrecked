# Handoff — Runtime Composition and Deterministic Bootstrap

## Transition

This handoff transfers the project from the completed **simulation cadence / engine-domain integration** phase into the next composition phase:

```text
validated domain/runtime owners
+ validated Godot adapters
+ validated representative timing behavior
→ deterministic runtime composition
→ new-run/bootstrap boundary
→ reusable playable scenario construction
→ later full run-save/reconstruction composition
```

The next agent should not reopen the cadence/engine-domain architecture unless new representative evidence proves a real defect.

---

## Validated baseline at handoff

Main includes PR #35 squash merge:

```text
61798688c44b5e5206dc57b84515f3f502cf3ff0
```

Authoritative local strict validation reported under Godot 4.7.1:

```text
RESULT: 51 PASS / 51 TOTAL
PASS headless_suite (51 tests)
```

The design review at:

```text
docs/design-reviews/2026-09-01-simulation-cadence-engine-domain-integration.md
```

is **COMPLETED**.

`docs/DISCOVERY_STATUS.md` owns the current implementation baseline, schema versions and open limitations. Read it instead of relying on copied counts in older handoffs.

---

# Objective of the next phase

The immediate objective is to build a **deterministic playable/bootstrap composition boundary** that assembles already-existing owners, services and Godot adapters into a coherent run.

Target shape:

```text
named deterministic scenario / new-run parameters
→ common bootstrap/restore validation boundary
→ authoritative owner state
→ derived projections rebuilt
→ application services composed
→ Godot scene bindings registered
→ simulation host starts
→ Wilson exhibits observable autonomous behavior
```

This is primarily a **composition-root and bootstrap problem**, not a new gameplay-system phase.

The first useful output should be a small but real runnable world assembled from the same contracts the eventual game will use.

---

# Recommended sequence

## 1. Reusable engine scenario harness

Before adding more bespoke engine scenes, establish or extract a small reusable harness for engine-facing scenarios.

The durable methodology is documented separately in:

```text
docs/ENGINE_SCENARIO_TESTING.md
```

The harness should support at least:

```text
AUTOMATED mode
→ no pauses
→ deterministic assertions
→ strict runner compatible

ASSISTED mode
→ semantic checkpoints
→ pause/resume
→ structured diagnostics
→ operator can copy requested evidence
```

Do not build a general-purpose test framework larger than current representative needs. Extract only the primitives already proven useful by the existing spatial and integrated Gerald/palm fixtures.

## 2. Deterministic new-run/bootstrap fixture

Create one named scenario that composes a valid run through the common bootstrap path.

Use primitive Godot nodes/meshes unless a test specifically depends on final asset geometry.

A representative initial fixture may contain:

```text
Wilson
one ordinary perceptible actor/object
one food/resource opportunity
one obstacle/navmesh constraint
one environmental gradual owner
one authored hazard/threat opportunity
one or more authored escape destinations
```

The exact content matters less than proving composition.

Required causal shape:

```text
bootstrap
→ owners valid
→ derived state rebuilt
→ stable runtime refs bound to scene nodes
→ simulation starts
→ Wilson receives evidence / drive progression
→ cognition can select an intention
→ concrete Godot motion can execute
→ semantic trace remains inspectable
```

## 3. Reset/rebootstrap determinism

The same scenario should be constructible twice from the same durable causes + seed and reproduce the same authoritative initial state and stable semantic decisions.

Do not reset by mutating private stores in place.

Preferred boundary:

```text
destroy runtime composition
→ call common bootstrap again
→ reconstruct owners/projections/adapters
→ compare authoritative state + selected deterministic checkpoints
```

## 4. Full run-save/reconstruction composition

Only after bootstrap composition is coherent, extend persistence to the missing owners and compose a full run transaction.

Likely pressure points already known:

```text
WilsonBodyState persistence
run-wide owner snapshot composition
new-run reset semantics
Legacy/profile admission into new Wilson/run
reconstruction of indexes/caches/projections
resume of deterministic scenario after load
```

Do not create another authority store called `GameState`, `RuntimeState`, or similar merely to make save composition convenient.

---

# Why bootstrap before full save

The project already has owner-local persistence boundaries, but not all runtime owners are yet composed into a complete run transaction.

Building the bootstrap composition first reveals:

- which owners actually constitute a run;
- which services are reconstructible infrastructure;
- which Godot bindings must be rebuilt rather than saved;
- what deterministic seed state is durable;
- where profile/Legacy admission belongs;
- which current gaps are real persistence requirements rather than fixture conveniences.

The desired architecture remains:

```text
normal authoritative owner state
            ↑
common restore/bootstrap boundary
            ↑
real save | deterministic fixture | development scenario
```

A fixture is not allowed to bypass the same construction/validation semantics that a real load/new-run path uses.

---

# Asset policy for this phase

Final art assets are **not required** for the bootstrap/composition phase.

Prefer native primitives for structural engine tests:

```text
CapsuleMesh / capsule collider      Wilson
BoxMesh / box collider              crates / barriers
CylinderMesh                        trunks / palms
SphereMesh                          fruit / simple items
simple primitive actor silhouettes Gerald / animals
NavigationRegion3D                  navigation
Area3D                              broadphase/perception
Node3D                              semantic anchors / targets
```

Use imported production assets only when the question under test depends on asset-specific behavior, for example:

```text
pivot/origin correctness
import scale
skeleton/animation/root motion
final collider geometry
asset-authored sockets/interaction anchors
visual occlusion caused by final mesh geometry
```

Gameplay/domain correctness must not depend on final art availability.

---

# Closed decisions to preserve

## Authority separation

Keep distinct:

```text
World truth
!= Wilson observation
!= Wilson belief
!= Wilson desirability
!= player-private intent
!= Director intent
!= cross-run profile state
!= presentation
```

Godot transforms, colliders, navmesh paths and overlap sets are infrastructure facts, not domain authority.

## Action causality

Preserve:

```text
ActionExecution
→ ActionOutcome
→ validated World commit
→ WorldEvent + SemanticChangeSet
→ derived invalidation
→ Perception
→ PerceptualEvidence
→ owner-local learning
→ reconsideration / decision
→ CurrentIntention
```

## Immediate threat

Threat routing is a separate regime. Do not convert it back into giant utility scores.

Validated execution boundary:

```text
accessible threat evidence
→ PerceivedThreat
→ THREAT trigger
→ defensive candidate
→ committed defensive CurrentIntention
→ DefensiveMotionExecutionCoordinator
→ cancel/redirect MotionPort
→ GodotMotionAdapter
```

## Simulation timing

The ~0.1 s semantic bridge is not a universal subsystem frequency.

Representative gradual owners use shared due scheduling. Cognition wakes at meaningful boundaries/triggers.

## Gradual semantic events

Numeric truth may change without semantic event spam. Authored threshold crossings project meaningful events; same-step duplicates coalesce.

## Physical observations

Engine callbacks remain observations until authored consequence policy admits them.

Insertion order is the current deterministic minimum. Sequence/timestamp infrastructure remains deferred until a representative accident proves insertion order insufficient.

## Bootstrap invariant

Fixtures may declare durable causes and deterministic seeds, but must not:

```text
mutate hidden stores after bootstrap
persist derived projections/caches as fixture truth
use transforms as authoritative placement truth
invent debug-only mutation paths
skip normal action/process validation
```

---

# Current engine/runtime capabilities available for composition

Inspect current source before assuming constructor signatures, but the validated stack includes these concepts:

```text
SimulationCadenceClock
SemanticDueScheduler
DueElapsedGate
ReconsiderationGate
PerceivedThreatTriggerSource
SimulationOrchestrator
GodotSimulationHost

SpatialQueryPort
MotionPort
GodotSceneSpatialRegistry
GodotSpatialQueryAdapter
GodotMotionAdapter
GodotPassiveSpatialSensor
PassiveSpatialPerceptionSource

PhysicalObservation / PhysicalObservationPort
GodotPhysicalObservationBuffer
PhysicalObservationConsequenceResolver
PhysicalConsequenceWorldAdvanceDecorator
WilsonBodyImpactConsequenceResolver

EscapeDestinationResolver
DefensiveMotionExecutionCoordinator

GradualSemanticBoundaryRule
GradualSemanticEventProjector
```

The integrated Gerald/falling-palm regression proves that real Godot motion, passive perception, shared due scheduling, semantic threat wake-up, cognition commit and concrete redirection can coexist in one deterministic trace.

---

# Important known limitations

`docs/DISCOVERY_STATUS.md` is authoritative. At this handoff, notable unresolved areas include:

```text
WilsonBodyState persistence/full run-save composition
full new-run bootstrap/reset
Legacy-to-new-Wilson seeding policy
richer Wilson-relative route/escape evaluation
orientation/view-cone passive refresh
negative/absence passive evidence
sparse maintenance/other gradual owners not yet representative
collision/grounding/fall-specific policies beyond current impact path
intervention causal windows
automatic habit disuse/context producers
Presence causal-attribution production
```

Do not solve these preemptively unless the bootstrap scenario exposes them as necessary.

---

# Required reading for the next agent

Start with the smallest relevant bundle:

```text
AGENTS.md
docs/README.md
docs/DISCOVERY_STATUS.md
docs/ENGINE_SCENARIO_TESTING.md
this handoff
```

Then read the canonical composition/runtime bundle:

```text
docs/ARCHITECTURE.md
docs/SIMULATION_CONTRACTS.md
docs/SIMULATION_ORCHESTRATION.md
docs/MUTATION_AUTHORITY.md
docs/DOMAIN_MODEL.md
docs/DOMAIN_MICRO_LOOP.md
```

For bootstrap/persistence work also inspect the existing snapshot services and tests rather than designing from documentation alone.

For Godot work inspect the existing real fixture first:

```text
tests/scenes/spatial_navigation_perception/
tests/headless/spatial_navigation_perception_scene_test.gd
tests/headless/integrated_gerald_palm_timing_test.gd
```

Reuse proven patterns where they remain appropriate.

---

# First implementation proposal

A good first issue for the next agent is:

> **Extract reusable engine scenario checkpoints/probes and build one deterministic bootstrap fixture through the common run composition boundary.**

Keep it vertically bounded.

Suggested acceptance:

```text
1. A named deterministic scenario constructs all required authoritative owners through normal bootstrap validation.
2. A real Godot scene binds runtime refs to primitive nodes without using scene identity as domain identity.
3. The scenario can run headlessly without operator input.
4. The same scene can run in assisted checkpoint mode.
5. Structured checkpoints expose time, spatial, motion, perception, cognition and World/event state relevant to failures.
6. Rebooting the same scenario from the same seed reconstructs equivalent authoritative initial state.
7. No final art asset is required.
8. Existing 51-test baseline remains green plus new regressions.
```

Do not promise a specific resulting test count before implementation exists.

---

# Operator collaboration model

The local operator can run Godot and return evidence, but the agent must assume it cannot interact with the live debugger directly.

The agent must therefore make engine scenarios self-diagnosing.

Preferred evidence order:

```text
automatic assertion
→ structured trace/checkpoint output
→ requested console excerpt
→ screenshot only for visual/geometry ambiguity
```

The operator should not be asked to manually reposition scene objects, inspect private runtime state, or reverse-engineer the failure.

See `docs/ENGINE_SCENARIO_TESTING.md` for the reusable protocol.

---

# Completion condition for this handoff

This handoff is consumed when the project has a coherent deterministic bootstrap/composition boundary demonstrated by at least one playable primitive-node scenario and backed by strict headless regression.

At that point, record the consuming PR/commit, update `DISCOVERY_STATUS.md`, and prepare the next transition around full run-save/new-run reconstruction or whichever representative gap the bootstrap work exposes.