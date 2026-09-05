# Discovery Status

## Purpose

This file records the **currently implemented and locally validated runtime baseline** for Wilson Shipwrecked. Canonical semantics remain in the architecture/domain documents.

---

# Current validated baseline

Strict external runner: **Godot 4.7.1**.

Latest locally validated checkpoint:

```text
RESULT: 60 PASS / 60 TOTAL
PASS headless_suite (60 tests)
```

The strict suite includes real-engine spatial/navigation/perception coverage, the integrated Gerald/falling-palm timing regression, deterministic runtime composition/bootstrap coverage, snapshot/bootstrap equivalence coverage, automated engine-scenario harness coverage, current-intention motion-resume coverage, and the first deterministic playable/bootstrap 3D scenario driven end-to-end by the shared bootstrap/runtime path. The representative spatial/navigation/perception scenario was also operator-validated in assisted mode with one `Space` continue per semantic checkpoint.

Validated causal breadth includes:

```text
structural World/runtime foundation
→ Wilson drives/projects/learning
→ environment dynamic processes
→ shallow non-Wilson actors
→ Director + PlayerRunState
→ run lifecycle/resurrection/profile boundaries
→ Godot spatial/query/motion/physics observation boundary
→ trigger-gated cognition with NONE as steady state
→ passive perception while MOVING
→ perceived-threat evidence → THREAT reconsideration
→ physical observation → authored WorldEvent
→ admitted impact → WilsonBodyState → injury/death WorldEvent
→ grounded Wilson death → RunLifecycleState DEAD
→ defensive intention → deterministic escape → concrete Godot redirection
→ shared SemanticDueScheduler → due-only gradual owner progression
→ gradual environment transition → authored threshold → coalesced WorldEvent
→ integrated long movement → Gerald ordinary perception → later falling-palm threat → defensive redirection
→ authoritative core owner state → deterministic runtime composition
→ deterministic scenario definition → common owner bootstrap → runtime composition
→ simulation snapshot v9 → common core owner bootstrap
→ engine scenario → generic checkpoints/probes/trace → automated or assisted execution
→ deterministic scenario definition → authoritative current intention → shared bootstrap/runtime composition
  → intention resume → real Godot motion → GodotSimulationHost progression → observable ARRIVED
```

---

# Closed implementation gates

```text
Structural World/runtime foundation               PASS
Drives                                            PASS
Projects                                          PASS
Associations / habits / episodes                  PASS
Presence relationship learning boundary           PASS
EnvironmentState / dynamic processes              PASS
Protection / exposure                             PASS
Hazard projection / perceived threat              PASS
Immediate-threat routing                          PASS
Perceived-threat same-chain wake-up               PASS
Immediate-threat concrete motion redirection      PASS
Shared due scheduling — drives/processes          PASS
Gradual environment semantic thresholds           PASS
Integrated Gerald/falling-palm timing scenario    PASS
Shallow non-Wilson actors                         PASS
Director opportunity lifecycle                    PASS
Player suggestions / bounded insistence           PASS
Physical player intervention boundary             PASS
Run lifecycle / resurrection                      PASS
Grounded Wilson death lifecycle propagation       PASS
PlayerProfile / cross-run Legacy admission        PASS
Owner-local persistence for implemented owners    PASS
Godot spatial / navmesh / LOS integration         PASS
Passive spatial perception while MOVING           PASS
Physical observation semantic admission           PASS
Grounded Wilson body impact consequences          PASS
Generic reconsideration gate / trigger coalescing PASS
Core runtime composition                          PASS
Deterministic scenario owner bootstrap             PASS
Snapshot/core-bootstrap equivalence               PASS
EngineScenarioHarness core                         PASS
Engine scenario AUTOMATED adapter                  PASS
Engine scenario ASSISTED checkpoint flow           PASS
Current-intention motion resume                    PASS
Deterministic playable/bootstrap 3D scenario       PASS
Strict headless suite                             PASS — 60 tests
```

---

# Authority model

```text
World
  physical truth
  environment / dynamic processes
  Wilson body truth
  shallow actor runtime state

WilsonCognition
  drives / beliefs / associations / habits / episodes
  Presence relationship
  current intention

Projects
  project lifecycle

ActionExecution
  execution lifecycle / committed outcomes

Director
  directed-opportunity lifecycle

PlayerRunState
  run-local player powers / suggestions / progress

RunLifecycleState
  ACTIVE / DEAD / ENDED metadata

PlayerProfile
  cross-run Legacy / diary / statistics / unlocks
```

Core invariant:

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

`WilsonBodyState` owns clamped vitality plus `alive`. Authored impact consequences mutate body truth before semantic injury/death facts. `RunLifecycleState` does not duplicate body truth; it admits an already-committed Wilson death event. Resurrection restores physical truth before lifecycle returns to ACTIVE.

---

# Timing / engine boundary

Implemented and validated primitives include:

```text
SimulationCadenceClock
SemanticDueScheduler
DueElapsedGate
ReconsiderationGate
PerceivedThreatTriggerSource
SpatialQueryPort
MotionPort
EscapeDestinationResolver
DefensiveMotionExecutionCoordinator
DirectTargetMotionExecutionCoordinator
CurrentIntentionExecutionCoordinator
PhysicalObservation / PhysicalObservationPort
PhysicalObservationConsequenceResolver
PhysicalConsequenceWorldAdvanceDecorator
WilsonBodyImpactConsequenceResolver
GradualSemanticBoundaryRule
GradualSemanticEventProjector
GodotSceneSpatialRegistry
GodotSpatialQueryAdapter
GodotMotionAdapter
GodotPassiveSpatialSensor
PassiveSpatialPerceptionSource
GodotPhysicalObservationBuffer
GodotSimulationHost
EngineScenarioHarness
EngineScenarioSceneAdapter
```

Validated semantics:

- render/physics cadence does not define cognition cadence;
- the ~0.1 s semantic bridge is **not** a universal subsystem update rate;
- `RuntimeWorldRef` identity maps explicitly to live Godot references;
- metric distance, route cost/availability, LOS and reachability stay behind `SpatialQueryPort`;
- `GodotMotionAdapter` uses real `CharacterBody3D` + `NavigationAgent3D` motion;
- passive broadphase can produce evidence while Wilson remains MOVING;
- ordinary evidence does not automatically open broad reconsideration;
- authored threat evidence wakes THREAT routing at the next semantic boundary;
- committed defense can cancel the old route and redirect real Godot motion;
- raw physical callbacks remain engine facts until authored consequence admission;
- admitted Wilson impacts mutate body truth before semantic events;
- drives and dynamic processes share one scheduler while retaining independent due keys;
- skipped heartbeat elapsed is conserved and released only when the owner is due;
- gradual environment truth changes numerically without event spam; authored crossings produce deterministic coalesced semantic events;
- the integrated timing regression proves long physical movement, semantic heartbeats, due-only gradual work, Gerald perception while MOVING, later falling-palm threat wake-up, and concrete escape redirection in one trace;
- engine scenarios can expose the same deterministic scenario logic through AUTOMATED strict execution or ASSISTED semantic checkpoints without placing gameplay semantics in the harness;
- an already-authoritative current intention can be re-applied after bootstrap/restore through a narrow application coordinator without re-selecting cognition or making the scene call `MotionPort` directly;
- the deterministic playable/bootstrap fixture proves that reconstructed current intention can drive real Godot navigation under `GodotSimulationHost` through observable `BOOTSTRAPPED → INTENTION_RESUMED → MOVING → ARRIVED → COMPLETE` checkpoints.

Fine transforms, nav paths, passive candidate sets and physics observations remain infrastructure facts and are not persisted as domain truth.

---

# Runtime composition / bootstrap baseline

Validated application boundaries now include:

```text
SimulationBootstrapDefinition
SimulationOwnerBootstrapper
RunRuntimeComposer
DeterministicScenarioDefinition
DeterministicScenarioBootstrapService
SimulationSnapshotBootstrapDecoder
CurrentIntentionExecutionCoordinator
DirectTargetMotionExecutionCoordinator
```

The shared core path is:

```text
scenario definition ─┐
                     ├→ SimulationBootstrapDefinition
snapshot v9 decode ──┘
                            ↓
                 SimulationOwnerBootstrapper
                            ↓
                  authoritative core owners
                            ↓
                     RunRuntimeComposer
                            ↓
                  reconstructible runtime services
```

The common owner bootstrap currently covers `EntityStore`, `WorldRelationStore`, `WilsonWorldState`, `BeliefStore`, and `CurrentIntentionStore`. Snapshot restoration for the remaining persisted owners still stays in `SimulationSnapshotService`; full-run/new-run composition remains open.

Validated properties include owner-state preservation, no composition side effects, insertion-order-independent semantic queries, equivalent recomposition from equivalent durable causes, non-empty cognition preservation, fresh-owner deterministic scenario rebootstrap, duplicate admission rejection, snapshot/common-bootstrap semantic equivalence, idempotent current-intention motion resume, and real-engine bootstrap-to-arrival execution.

The first playable/bootstrap 3D fixture deliberately starts with a selected `CurrentIntention` as an authoritative durable cause. It therefore validates resume/reification after reconstruction rather than drive-based intention selection. This avoids creating an unshared scenario-only `DriveState` bootstrap path while the full owner bootstrap remains incomplete.

---

# Engine scenario harness baseline

Validated test-support boundaries now include:

```text
EngineScenarioHarness
EngineScenarioCheckpoint
EngineScenarioBoundedWait
EngineScenarioSceneAdapter
```

The harness owns only generic scenario observability/control:

```text
semantic checkpoints
opaque probes
structured trace / optional JSONL
assisted pause/continue state
explicit completion/failure
bounded waits
```

It does not know Wilson, threat, movement, Gerald, perception, or other gameplay semantics. `EngineScenarioSceneAdapter` translates the existing signal-based scene contract into the harness while the scene remains responsible for its own deterministic behavior and input handling.

The representative `spatial_navigation_perception` fixture has been validated through both modes. AUTOMATED mode is part of the strict headless suite. ASSISTED mode uses the same scene logic and pauses at `SCENE_READY`, `PASSIVE_WHILE_MOVING`, `ARRIVED`, `THREAT_REDIRECT`, `LOS_BLOCKED`, and `COMPLETE`, with one `Space` input releasing each checkpoint.

The deterministic playable/bootstrap 3D fixture is now also part of the AUTOMATED strict suite and uses the harness to expose causal runtime checkpoints rather than frame-perfect assertions.

---

# Persistence baseline

Current development schemas:

```text
SimulationSnapshotService schema:      v9
DirectorPlayerSnapshotService schema:  v1
RunProfileSnapshotService schema:      v1
ActionExecutionSnapshotService schema: v2
ContentPackLoader schema:              v1
```

Owner-local snapshots preserve authoritative/minimal causes. Generated candidates, live navigation paths and reconstructible projections are excluded.

`SimulationSnapshotService` now decodes its core owner state into the shared application bootstrap contract before reconstructing those owners. `WilsonBodyState` is not yet integrated into the save schema. Full run-save composition remains open.

---

# Known limitations

Still open:

```text
collision/grounding/fall-specific policies beyond current impact damage
physical gradual-value threshold policies when a representative owner requires them
sparse maintenance/other gradual owners not yet wired through due scheduling
drive hysteresis-band memory persistence
richer Wilson-relative learned route/escape evaluation
intervention causal windows
automatic habit-disuse/context producers
Presence causal-attribution production
Wilson body persistence/full run-save composition
full new-run lifecycle/reset composition around the validated core bootstrap
shared bootstrap coverage for remaining authoritative owners, including drives where appropriate
Legacy-to-new-Wilson seeding policy
orientation/view-cone passive refresh
negative/absence perceptual evidence on passive exit
richer Gerald behavior/relationship semantics
production falling-palm rigid-body authoring
```

These are future product/runtime slices, not unresolved cadence/engine-domain architecture blockers.

---

# Recommended next major verticals

From the validated 60-test checkpoint:

```text
1. Wilson body + full run-save/new-run composition
   - extend shared reconstruction beyond the current core owners
   - integrate action-execution lifecycle restoration with runtime composition
   - define reset/rebootstrap semantics without parallel authority paths
2. richer representative gameplay semantics driven by scene catalog needs
   - Gerald behavior/relationships
   - physical accident authoring where needed
   - learned route/escape reasoning
3. drive-backed autonomous new-run behavior once drive ownership/bootstrap participates in the common path
```

The design review at `docs/design-reviews/2026-09-01-simulation-cadence-engine-domain-integration.md` is now **COMPLETED** through PR #35. The integrated timing scenario closed its final substantive checklist item.

---

# Admission rule

A runtime capability is marked PASS here only after the corresponding strict local Godot gate has been reported successful.

Do not record inferred test counts, unexecuted smoke results or architectural intent as validated runtime behavior.