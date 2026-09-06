# Discovery Status

## Purpose

This file records the **currently implemented and locally validated runtime baseline** for Wilson Shipwrecked. Canonical semantics remain in the architecture/domain documents.

---

# Current validated baseline

Strict external runner: **Godot 4.7.1**.

Latest locally validated checkpoint:

```text
RESULT: 79 PASS / 79 TOTAL
PASS headless_suite (79 tests)
```

The strict suite now covers the engine/runtime foundation, deterministic scenario tooling, shared bootstrap for all authoritative owners persisted by `SimulationSnapshotService`, content-dependent action-execution reconstruction, full current-run restore composition, reset/rebootstrap determinism, autonomous drive-backed and perception-learned behavior, grounded action consequences, and production-facing fresh-run bootstrap through a real Godot-hosted scenario.

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
→ drive-backed autonomous target selection
→ passive perception → durable learned opportunity belief
→ target intention → Godot motion → matching ARRIVED
→ authored ActionExecution start → World-accepted outcome/event
→ grounded drive consequence → hunger reduction
→ action reconstruction without duplicate outcome emission
→ NewRunDefinition → NewRunBootstrapService
→ fresh RunLifecycleState + DirectorStateStore + PlayerRunState
→ production new-run result feeds real Godot bindings and GodotSimulationHost
→ autonomous perception/decision/motion/consume behavior from the production-facing new-run boundary
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
Deterministic scenario owner bootstrap            PASS
Snapshot/bootstrap equivalence                    PASS
EngineScenarioHarness core                        PASS
Engine scenario AUTOMATED adapter                 PASS
Engine scenario ASSISTED checkpoint flow          PASS
Current-intention motion resume                   PASS
Deterministic playable/bootstrap 3D scenario      PASS
WilsonBodyState shared bootstrap/persistence      PASS
DriveState shared bootstrap                       PASS
ProjectStore shared bootstrap                     PASS
Learning owners shared bootstrap                  PASS
Environment / dynamic-process shared bootstrap    PASS
ActorStateStore shared bootstrap                  PASS
Content-dependent ActionExecution restore         PASS
Full current-run restore composition              PASS
Full-run reset/rebootstrap determinism            PASS
Drive-backed new-run autonomy                     PASS
Perception-learned new-run autonomy               PASS
Grounded drive consequences                       PASS
Targeted action execution after arrival           PASS
Grounded autonomous consume sequence              PASS
Targeted action reconstruction/idempotency        PASS
Production-facing fresh-run bootstrap             PASS
Production new-run → Godot host autonomous flow   PASS
Strict headless suite                             PASS — 79 tests
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
NewRunDefinition
NewRunBootstrapService
NewRunBootstrapResult
SimulationSnapshotBootstrapDecoder
RunRuntimeComposer
RunRuntimeRestoreService
RunRuntimeRestoreResult
CurrentIntentionExecutionCoordinator
DirectTargetMotionExecutionCoordinator
TargetedActionExecutionCoordinator
GroundedDriveConsequenceService
```

The shared simulation-owner path is:

```text
deterministic scenario ─┐
production new run ─────┼→ SimulationBootstrapDefinition
simulation snapshot ────┘
                               ↓
                    SimulationOwnerBootstrapper
                               ↓
                    authoritative owner set
```

The common owner bootstrap reconstructs:

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
→ ActionExecutionSnapshotService restores active executions against authored definitions when restoring
→ RunLifecycleState / DirectorStateStore / PlayerRunState restored for an existing current run
```

Fresh production-facing runs use:

```text
NewRunDefinition
→ SimulationOwnerBootstrapper
→ RunRuntimeComposer
→ fresh RunLifecycleState(ACTIVE)
→ fresh DirectorStateStore
→ fresh PlayerRunState
→ NewRunBootstrapResult
```

`NewRunDefinition` is bootstrap input metadata, not an authority store. `NewRunBootstrapService` owns no gameplay truth and deliberately converges on the same owner/bootstrap and runtime-composition boundaries used by deterministic scenarios and restore.

`ActionExecution` deliberately remains outside `SimulationOwnerBootstrapper`: restoring execution state requires authored `ActionDefinition` and `ActionResolutionDefinition`, so it belongs after runtime/content composition rather than inside the content-independent owner bootstrap boundary.

`PlayerProfile` deliberately remains outside current-run bootstrap/restore results because it is cross-run state.

Validated properties include fresh ownership, no bootstrap aliasing, semantic equivalence from equivalent durable causes, duplicate-admission rejection, insertion-order-independent runtime composition, current-intention resume, content-dependent action lifecycle reconstruction without outcome duplication, deterministic targeted-action execution identity, and independent fresh-run constructions from identical durable causes.

---

# Autonomous action baseline

A validated representative causal slice now reaches an actual grounded consequence:

```text
passive Godot perception
→ Wilson learns durable target relation
→ hunger crosses PRESSING
→ seek_food intention selected
→ TargetedActionExecutionCoordinator requests Godot motion
→ matching target ARRIVED
→ authored consume_food ActionExecution starts
→ execution crosses commit checkpoint
→ ActionOutcome applied through World command boundary
→ food_consumed WorldEvent accepted
→ GroundedDriveConsequenceService reduces DriveState.HUNGER
```

The fixture does not detect `ARRIVED` and directly mutate World or hunger. Godot remains an outer adapter; action progress remains `ActionExecution` authority; drive mutation occurs only after an accepted World commit.

Targeted action execution uses a deterministic execution identity derived from the committed intention selection step plus authored action id. Snapshot/restore regression proves that a post-commit execution does not restart or emit its outcome a second time when the same intention remains arrived at the same target.

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

The representative perception-learned fresh-run fixture now validates:

```text
BOOTSTRAPPED
→ PERCEPTION_LEARNED
→ DRIVE_PRESSING
→ INTENTION_SELECTED
→ MOVING
→ ARRIVED
→ ACTION_STARTED
→ ACTION_COMMITTED
→ HUNGER_REDUCED
→ COMPLETE
```

through real Godot navigation under `GodotSimulationHost`.

The same engine-facing scenario now boots through `NewRunBootstrapService`, proving that the production-facing fresh-run boundary can feed explicit runtime-ref scene bindings, Godot adapters and the semantic host without using scene identity as domain identity.

---

# Known limitations / follow-ups

Still open:

```text
snapshot v9 → v10 compatibility migration policy
capture API cleanup: SimulationSnapshotService.capture currently has a long positional compatibility signature
bootstrap definition cleanup: SimulationBootstrapDefinition has grown a long positional constructor; grouped owner-specific definitions may be preferable if the contract expands again
drive hysteresis-band memory persistence
Legacy-to-new-Wilson seeding policy
production content/world-generation layer that constructs NewRunDefinition from product-level run parameters
reusable production scene-binding/host composition only after a second real use proves the abstraction shape
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

The long positional APIs remain documented debt rather than blockers. Refactor them when another owner/schema expansion creates real pressure, not for cosmetic churn.

A dedicated engine composition abstraction remains intentionally deferred. One production-facing scenario now proves the required seams, but extracting a generalized scene-binding/host composer before a second real use would risk encoding fixture-specific assumptions as production architecture.

---

# Recommended next major verticals

From the validated 79-test checkpoint:

```text
1. product-level new-run definition/world-generation input
   - derive durable bootstrap causes from actual product run parameters
   - keep world generation/content authoring upstream of NewRunBootstrapService
   - avoid scene nodes/transforms becoming bootstrap authority

2. richer representative gameplay semantics driven by scene-catalog needs
   - Gerald behavior/relationships
   - physical accident authoring where needed
   - learned route/escape reasoning

3. persistence evolution when product requirements require it
   - decide v9 compatibility policy
   - introduce grouped capture/bootstrap request objects only when schemas expand again
```

---

# Admission rule

A runtime capability is marked PASS here only after the corresponding strict local Godot gate has been reported successful.

Do not record inferred test counts, unexecuted smoke results, or architectural intent as validated runtime behavior.
