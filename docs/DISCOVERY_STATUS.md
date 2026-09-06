# Discovery Status

## Purpose

This file records the **currently implemented and locally validated runtime baseline** for Wilson Shipwrecked. Canonical semantics remain in the architecture/domain documents.

---

# Current validated baseline

Strict external runner: **Godot 4.7.1**.

Latest locally validated checkpoint:

```text
RESULT: 80 PASS / 80 TOTAL
PASS headless_suite (80 tests)
```

The strict suite now covers the engine/runtime foundation, deterministic scenario tooling, shared bootstrap for all authoritative owners persisted by `SimulationSnapshotService`, content-dependent action-execution reconstruction, full current-run restore composition, reset/rebootstrap determinism, autonomous drive-backed and perception-learned behavior, grounded action consequences, production-facing fresh-run bootstrap through a real Godot-hosted scenario, and product-level deterministic world/run generation feeding the ordinary fresh-run boundary.

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
→ product run parameters + authored generation profile + explicit gameplay seed
→ deterministic bounded entity/relation/environment/bootstrap causes
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
Product-level deterministic new-run generation    PASS
Strict headless suite                             PASS — 80 tests
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
ProductNewRunParameters
ProductEntityGenerationRule
ProductRelationGenerationRule
ProductWorldGenerationProfile
ProductNewRunGenerator
ProductNewRunGenerationResult
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
product parameters + authored generation profile + gameplay seed
  → ProductNewRunGenerator
  → NewRunDefinition ─────┐
deterministic scenario ───┼→ SimulationBootstrapDefinition
simulation snapshot ──────┘
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
ProductNewRunParameters + ProductWorldGenerationProfile + sealed ContentRegistry
→ ProductNewRunGenerator
→ NewRunDefinition
→ SimulationOwnerBootstrapper
→ RunRuntimeComposer
→ fresh RunLifecycleState(ACTIVE)
→ fresh DirectorStateStore
→ fresh PlayerRunState
→ NewRunBootstrapResult
```

`ProductNewRunParameters`, generation profiles/rules and `NewRunDefinition` are bootstrap inputs/content, not authority stores. `ProductNewRunGenerator` and `NewRunBootstrapService` own no gameplay truth and deliberately converge on the same owner/bootstrap and runtime-composition boundaries used by deterministic scenarios and restore.

Product generation validates against sealed authored content, applies stable semantic ordering before seeded selection, produces bounded entity populations and unique semantic relations, and fails explicitly when authored constraints cannot be satisfied. Godot nodes/transforms/navigation state are absent from generation authority.

`ActionExecution` deliberately remains outside `SimulationOwnerBootstrapper`: restoring execution state requires authored `ActionDefinition` and `ActionResolutionDefinition`, so it belongs after runtime/content composition rather than inside the content-independent owner bootstrap boundary.

`PlayerProfile` deliberately remains outside current-run bootstrap/restore results because it is cross-run state.

Validated properties include fresh ownership, no bootstrap aliasing, semantic equivalence from equivalent durable causes, duplicate-admission rejection, insertion-order-independent runtime composition, deterministic generation under equivalent authored set ordering, bounded variation across deterministic seed populations, current-intention resume, content-dependent action lifecycle reconstruction without outcome duplication, deterministic targeted-action execution identity, and independent fresh-run constructions from identical durable causes.

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

The product-generation profile intentionally does not mirror every `SimulationBootstrapDefinition` seed family. Add another generated cause family only when a product-visible run configuration requires it; do not expand generation for structural completeness alone.

---

# Recommended next major verticals

From the validated 80-test checkpoint:

```text
1. richer representative gameplay semantics driven by scene-catalog needs
   - prefer one non-food autonomous slice exposing a real missing reusable primitive
   - leading candidates: Gerald behavior/relationships, learned route/escape reasoning, or physical accident authoring when required by the chosen scene

2. persistence evolution when product requirements require it
   - decide v9 compatibility policy
   - introduce grouped capture/bootstrap request objects only when schemas expand again

3. production scene-binding/host composition only after a second real use
   - extract shared engine composition only when another production-facing scenario proves the common shape
```

Active transition context: `docs/handoffs/world-generation-to-representative-gameplay-semantics.md`.

---

# Admission rule

A runtime capability is marked PASS here only after the corresponding strict local Godot gate has been reported successful.

Do not record inferred test counts, unexecuted smoke results, or architectural intent as validated runtime behavior.
