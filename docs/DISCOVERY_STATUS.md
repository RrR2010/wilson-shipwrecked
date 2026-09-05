# Discovery Status

## Purpose

This file records the **currently implemented and locally validated runtime baseline** for Wilson Shipwrecked. Canonical semantics remain in the architecture/domain documents.

---

# Current validated baseline

Strict external runner: **Godot 4.7.1**.

Latest locally validated checkpoint:

```text
RESULT: 69 PASS / 69 TOTAL
PASS headless_suite (69 tests)
```

The strict suite now covers the engine/runtime foundation, deterministic scenario tooling, shared bootstrap for all authoritative owners persisted by `SimulationSnapshotService`, content-dependent action-execution reconstruction, full current-run restore composition, and reset/rebootstrap determinism.

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
→ deterministic scenario definition / persisted snapshot
→ SimulationBootstrapDefinition
→ SimulationOwnerBootstrapper
→ authoritative simulation owners
→ RunRuntimeComposer
→ reconstructible runtime services
→ ActionExecutionSnapshotService restore against sealed authored content
→ RunLifecycleState + DirectorStateStore + PlayerRunState restore
→ equivalent full-run rebootstrap from identical durable causes
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
Snapshot/bootstrap equivalence                    PASS
EngineScenarioHarness core                         PASS
Engine scenario AUTOMATED adapter                  PASS
Engine scenario ASSISTED checkpoint flow           PASS
Current-intention motion resume                    PASS
Deterministic playable/bootstrap 3D scenario       PASS
WilsonBodyState shared bootstrap/persistence       PASS
DriveState shared bootstrap                        PASS
ProjectStore shared bootstrap                      PASS
Learning owners shared bootstrap                   PASS
Environment / dynamic-process shared bootstrap    PASS
ActorStateStore shared bootstrap                   PASS
Content-dependent ActionExecution restore          PASS
Full current-run restore composition               PASS
Full-run reset/rebootstrap determinism              PASS
Strict headless suite                             PASS — 69 tests
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

`WilsonBodyState` owns clamped vitality plus derived `alive`. Snapshot schema v10 persists vitality only. `RunLifecycleState` does not duplicate body truth; it records grounded current-run lifecycle transitions. `PlayerProfile` remains cross-run state and is intentionally excluded from current-run runtime composition.

---

# Runtime composition / bootstrap baseline

Validated application boundaries include:

```text
SimulationBootstrapDefinition
SimulationOwnerBootstrapper
SimulationOwnerSet
DeterministicScenarioDefinition
DeterministicScenarioBootstrapService
SimulationSnapshotBootstrapDecoder
RunRuntimeComposer
RunRuntimeRestoreService
RunRuntimeRestoreResult
CurrentIntentionExecutionCoordinator
DirectTargetMotionExecutionCoordinator
```

The shared simulation-owner path is:

```text
deterministic scenario ─┐
                        ├→ SimulationBootstrapDefinition
simulation snapshot ────┘
                               ↓
                    SimulationOwnerBootstrapper
                               ↓
                    authoritative owner set
```

The common owner bootstrap now reconstructs:

```text
EntityStore
WorldRelationStore
WilsonWorldState
WilsonBodyState
BeliefStore
CurrentIntentionStore
DriveState
ProjectStore
AssociationStore
HabitStore
EpisodeStore
PresenceRelationship
EnvironmentState
DynamicProcessStore
ActorStateStore
```

Runtime reconstruction then proceeds in dependency order:

```text
authoritative simulation owners
→ RunRuntimeComposer + sealed ContentRegistry
→ fresh reconstructible runtime services
→ ActionExecutionSnapshotService restores active executions against authored definitions
→ RunLifecycleState / DirectorStateStore / PlayerRunState restored for a full current run
```

`ActionExecution` deliberately remains outside `SimulationOwnerBootstrapper`: restoring execution state requires authored `ActionDefinition` and `ActionResolutionDefinition`, so it belongs after runtime/content composition rather than inside the content-independent owner bootstrap boundary.

`PlayerProfile` deliberately remains outside `RunRuntimeRestoreResult` because it is cross-run state.

Validated properties include fresh ownership, no bootstrap aliasing, semantic equivalence from equivalent durable causes, duplicate-admission rejection, insertion-order-independent runtime composition, current-intention resume, content-dependent action lifecycle reconstruction without outcome duplication, and two independent full-run reconstructions from the same serialized durable causes.

---

# Persistence baseline

Current development schemas:

```text
SimulationSnapshotService schema:      v10
DirectorPlayerSnapshotService schema:  v1
RunProfileSnapshotService schema:      v1
ActionExecutionSnapshotService schema: v2
ContentPackLoader schema:              v1
```

`SimulationSnapshotService` persists authoritative/minimal causes and restores every owner it contains through `SimulationSnapshotBootstrapDecoder → SimulationOwnerBootstrapper`. Reconstructible projections are rebuilt after owner restoration.

`RunProfileSnapshotService` still stores `RunLifecycleState` and `PlayerProfile` in one persistence format for compatibility, but exposes separate reconstruction paths so current-run runtime restore consumes only lifecycle state. Cross-run profile restoration remains independent.

Snapshot v10 is currently strict; v9 compatibility/migration is not implemented.

---

# Engine scenario harness baseline

`EngineScenarioHarness` remains generic test support only. It owns semantic checkpoints, opaque probes, structured trace, assisted pause/continue state, bounded waits, and explicit completion/failure. It does not own gameplay semantics.

The deterministic playable/bootstrap fixture validates:

```text
BOOTSTRAPPED
→ INTENTION_RESUMED
→ MOVING
→ ARRIVED
→ COMPLETE
```

through real Godot navigation under `GodotSimulationHost`.

---

# Known limitations / follow-ups

Still open:

```text
snapshot v9 → v10 compatibility migration policy
capture API cleanup: SimulationSnapshotService.capture currently has a long positional compatibility signature
bootstrap definition cleanup: SimulationBootstrapDefinition has grown a long positional constructor; grouped owner-specific definitions may be preferable if the contract expands again
drive hysteresis-band memory persistence
Legacy-to-new-Wilson seeding policy
production new-run orchestration above the validated deterministic bootstrap primitives
collision/grounding/fall-specific policies beyond current impact damage
richer Wilson-relative learned route/escape evaluation
intervention causal windows
automatic habit-disuse/context producers
Presence causal-attribution production
orientation/view-cone passive refresh
negative/absence perceptual evidence on passive exit
richer Gerald behavior/relationship semantics
production falling-palm rigid-body authoring
```

The long positional APIs are now documented debt rather than blockers. They should be refactored when another owner/schema expansion creates pressure, not merely for cosmetic churn after the validated 69-test convergence.

---

# Recommended next major verticals

From the validated 69-test checkpoint:

```text
1. production new-run orchestration
   - instantiate current-run lifecycle + deterministic/bootstrap causes
   - compose runtime through the same validated boundaries
   - bind Godot scene adapters and start the simulation host

2. richer representative gameplay semantics driven by scene-catalog needs
   - Gerald behavior/relationships
   - physical accident authoring where needed
   - learned route/escape reasoning

3. persistence evolution when product requirements require it
   - decide v9 compatibility policy
   - introduce grouped capture/bootstrap request objects only when the schemas expand again
```

---

# Admission rule

A runtime capability is marked PASS here only after the corresponding strict local Godot gate has been reported successful.

Do not record inferred test counts, unexecuted smoke results, or architectural intent as validated runtime behavior.
