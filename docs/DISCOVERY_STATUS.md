# Discovery Status

## Purpose

This file records the **currently implemented and locally validated runtime baseline** for Wilson Shipwrecked. Canonical semantics remain in the architecture/domain documents.

---

# Current validated baseline

Strict external runner: **Godot 4.7.1**.

Latest locally validated checkpoint:

```text
RESULT: 88 PASS / 88 TOTAL
PASS headless_suite (88 tests)
```

The strict suite covers the structural runtime foundation, shared simulation-owner bootstrap/restore, deterministic engine-scenario tooling, Godot spatial/navigation/perception/physics adapters, grounded Wilson action causality, production-facing fresh-run bootstrap, deterministic product-level generation, Wilson-relative remembered-route preference, shallow non-Wilson actor behavior, durable Gerald relationship behavior, and real Godot dynamic-contact authoring into grounded Wilson body consequences.

Validated causal breadth includes:

```text
structural World/runtime foundation
→ Wilson drives/projects/learning
→ environment dynamic processes
→ shallow non-Wilson actors
→ actor relationship authority
→ Director + PlayerRunState
→ run lifecycle/resurrection/profile boundaries
→ Godot spatial/query/motion/perception/physics observation boundary
→ trigger-gated cognition with NONE as steady state
→ passive perception while MOVING
→ perceived-threat evidence → THREAT reconsideration
→ physical observation → authored semantic WorldEvent
→ admitted impact → WilsonBodyState → injury/death WorldEvent
→ grounded Wilson death → RunLifecycleState DEAD
→ defensive intention → deterministic escape → concrete Godot redirection
→ shared SemanticDueScheduler → due-only gradual owner progression
→ deterministic scenario/new-run/snapshot causes
→ SimulationBootstrapDefinition
→ SimulationOwnerBootstrapper
→ authoritative simulation owners
→ RunRuntimeComposer
→ reconstructible runtime services
→ content-dependent ActionExecution reconstruction
→ autonomous perception/decision/motion/action/world consequence
→ product parameters + authored generation profile + gameplay seed
→ deterministic bounded world/bootstrap causes
→ physical route viability/cost from SpatialQueryPort
→ Wilson-relative remembered route valence from AssociationStore
→ remembered route preference without changing navigation truth
→ real Godot navigation visibly executes the longer preferred route
→ Gerald actor state + ActorRelationshipStore
→ repeated interaction changes durable Gerald affinity
→ relationship-conditioned actor rule selection
→ semantic Gerald placement changes
→ Godot presentation visibly reflects later relationship-driven behavior
→ RigidBody3D collision callback
→ explicit Node3D → RuntimeWorldRef reverse binding
→ PhysicalObservation.CONTACT
→ authored contact-event admission
→ authored Wilson body-impact policy
→ WilsonBodyState vitality mutation
```

---

# Closed implementation gates

```text
Structural World/runtime foundation                 PASS
Drives                                              PASS
Projects                                            PASS
Associations / habits / episodes                    PASS
Presence relationship learning boundary             PASS
EnvironmentState / dynamic processes                PASS
Protection / exposure                               PASS
Hazard projection / perceived threat                PASS
Immediate-threat routing                            PASS
Perceived-threat same-chain wake-up                 PASS
Immediate-threat concrete motion redirection        PASS
Shared due scheduling — drives/processes            PASS
Gradual environment semantic thresholds             PASS
Integrated Gerald/falling-palm timing scenario      PASS
Shallow non-Wilson actors                           PASS
Actor relationship authority                        PASS
Relationship-conditioned actor behavior             PASS
Actor relationship bootstrap/persistence            PASS
Gerald relationship real-Godot presentation slice   PASS
Director opportunity lifecycle                      PASS
Player suggestions / bounded insistence             PASS
Physical player intervention boundary               PASS
Run lifecycle / resurrection                        PASS
Grounded Wilson death lifecycle propagation         PASS
PlayerProfile / cross-run Legacy admission          PASS
Owner-local persistence for implemented owners      PASS
Godot spatial / navmesh / LOS integration           PASS
Passive spatial perception while MOVING             PASS
Physical observation semantic admission             PASS
Grounded Wilson body impact consequences            PASS
Godot dynamic contact observer                      PASS
Physical accident real-Godot consequence slice      PASS
Generic reconsideration gate / trigger coalescing   PASS
Core runtime composition                            PASS
Deterministic scenario owner bootstrap              PASS
Snapshot/bootstrap equivalence                      PASS
EngineScenarioHarness core                          PASS
Engine scenario AUTOMATED adapter                   PASS
Engine scenario ASSISTED checkpoint flow            PASS
Current-intention motion resume                     PASS
Deterministic playable/bootstrap 3D scenario        PASS
WilsonBodyState shared bootstrap/persistence        PASS
DriveState shared bootstrap                         PASS
ProjectStore shared bootstrap                       PASS
Learning owners shared bootstrap                    PASS
Environment / dynamic-process shared bootstrap      PASS
ActorStateStore shared bootstrap                    PASS
Content-dependent ActionExecution restore           PASS
Full current-run restore composition                PASS
Full-run reset/rebootstrap determinism              PASS
Drive-backed new-run autonomy                       PASS
Perception-learned new-run autonomy                 PASS
Grounded drive consequences                         PASS
Targeted action execution after arrival             PASS
Grounded autonomous consume sequence                PASS
Targeted action reconstruction/idempotency          PASS
Production-facing fresh-run bootstrap               PASS
Production new-run → Godot host autonomous flow     PASS
Product-level deterministic new-run generation      PASS
Remembered route preference                         PASS
Remembered multi-waypoint motion progression        PASS
Long Way Around real-Godot scenario                 PASS
Strict headless suite                               PASS — 88 tests
```

---

# Authority model

```text
World
  physical truth
  environment / dynamic processes
  Wilson body truth
  shallow actor runtime state
  non-Wilson actor relationship state

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
!= non-Wilson actor relationship state
!= player-private intent
!= Director intent
!= cross-run profile state
!= presentation
```

`AssociationStore` remains Wilson-relative cognition. `ActorRelationshipStore` owns actor→subject affinity/evidence for non-Wilson actors and must not be collapsed into Wilson cognition or `ActorStateStore`.

`WilsonBodyState` owns clamped vitality plus derived `alive`. `RunLifecycleState` records grounded run lifecycle and does not duplicate body truth. `PlayerProfile` remains cross-run state and is intentionally excluded from current-run simulation ownership.

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
RememberedRouteOption
RememberedRoutePreferenceService
RememberedRouteMotionCoordinator
ActorRelationshipBootstrapSeed
```

Shared owner construction:

```text
product parameters + generation profile + gameplay seed
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
ActorRelationshipStore
```

`ActionExecution` remains outside `SimulationOwnerBootstrapper` because restoring active executions depends on sealed authored action content. `PlayerProfile` remains outside current-run bootstrap/restore because it is cross-run state.

---

# Representative gameplay baselines

## Grounded autonomous food slice

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

## Wilson-relative route preference

```text
GodotSpatialQueryAdapter / SpatialQueryPort
→ physical route viability + route cost

AssociationStore
→ Wilson-relative remembered valence

RememberedRoutePreferenceService
→ stateless adjusted route comparison

RememberedRouteMotionCoordinator
→ ordinary MotionPort requests over selected waypoints
```

The `Long Way Around` fixture proves the shortcut remains physically valid and cheaper while remembered aversion makes the longer route preferable and visibly executed.

## Non-Wilson actor relationship

```text
ActorRelationshipImpact
→ ActorRelationshipStore
→ optional relationship condition on ActorBehaviorRule
→ ShallowActorAdvanceService
→ semantic actor placement consequence
→ Godot presentation reflects placement
```

The Gerald fixture proves repeated positive interactions can change durable Gerald affinity and later visible behavior. It does not claim continuous physical locomotion for non-Wilson actors.

## Physical accident authoring

The production-shaped physical-contact boundary is now validated:

```text
GodotSceneSpatialRegistry explicit binding
→ reverse Node3D → RuntimeWorldRef lookup
→ GodotDynamicContactObserver
→ GodotPhysicalObservationBuffer
→ PhysicalObservation.CONTACT
→ PhysicalObservationConsequenceResolver
→ authored semantic WorldEvent
→ WilsonBodyImpactConsequenceResolver
→ WilsonBodyState
→ injury/death WorldEvent + SemanticChangeSet
```

The real-Godot fixture uses an actual falling `RigidBody3D` collision. Physics callbacks never mutate vitality directly. Contact itself is non-authoritative evidence; semantic admission and body damage remain separately authored policies.

---

# Persistence baseline

Current development schemas:

```text
SimulationSnapshotService schema:      v11
DirectorPlayerSnapshotService schema:  v1
RunProfileSnapshotService schema:      v1
ActionExecutionSnapshotService schema: v2
ContentPackLoader schema:              v1
```

`SimulationSnapshotService` persists authoritative/minimal causes and restores owners through:

```text
SimulationSnapshotBootstrapDecoder
→ SimulationBootstrapDefinition
→ SimulationOwnerBootstrapper
```

Snapshot v11 includes `actor_relationships`. Current schema handling remains strict; historical snapshot migration compatibility is requirement-driven and not implemented merely because development schemas advanced.

---

# Engine scenario harness baseline

`EngineScenarioHarness` is test support only. It owns checkpoints/probes/trace/assisted control, not gameplay semantics.

Representative validated sequences include:

```text
Long Way Around:
BOOTSTRAPPED
→ LONG_ROUTE_SELECTED
→ DETOUR_ENTERED
→ DETOUR_CROSSED
→ ARRIVED
→ COMPLETE

Gerald relationship:
BOOTSTRAPPED
→ NEUTRAL_WATCH
→ RELATIONSHIP_WARMED
→ APPROACHED_WILSON
→ COMPLETE

Physical accident:
BOOTSTRAPPED
→ CONTACT_OBSERVED
→ EVENT_ADMITTED
→ BODY_DAMAGED
→ COMPLETE
```

---

# Known limitations / follow-ups

Still open:

```text
snapshot compatibility/migration policy for earlier development schemas
SimulationSnapshotService.capture positional API cleanup
SimulationBootstrapDefinition positional constructor cleanup
drive hysteresis-band memory persistence
Legacy-to-new-Wilson seeding policy
production scene-binding/host composition only when a real production use proves it
collision/grounding/fall-specific policies beyond current authored impact damage
post-accident Wilson learning/behavior acquisition
route-memory acquisition/decay/generalization
continuous physical locomotion for non-Wilson actors
actor relationship decay/generalization/social-graph breadth
production interaction producers for actor relationship changes
intervention causal windows
automatic habit-disuse/context producers
Presence causal-attribution production
orientation/view-cone passive refresh
negative/absence perceptual evidence on passive exit
```

The long positional APIs remain documented debt, not blockers. Refactor them only when another owner/schema expansion creates real pressure.

A generalized production scene-binding/host composer remains deferred until a genuine production composition use forces a stable abstraction.

---

# Recommended next major verticals

From the validated 88-test checkpoint:

```text
1. representative gameplay pressure beyond already-proved accident grounding
   - post-accident Wilson learning/behavior from accessible evidence; or
   - committed-accident player intervention with causal-window validation; or
   - another representative scene exposing a distinct missing primitive

2. persistence evolution only when product requirements require it
   - decide historical snapshot compatibility policy
   - grouped capture/bootstrap request objects only if expansion creates sufficient pressure

3. continuous non-Wilson actor motion only when a representative scenario requires physical traversal
```

Active transition context: `docs/handoffs/physical-accident-authoring-to-next-representative-gameplay.md`.

---

# Admission rule

A runtime capability is marked PASS here only after the corresponding strict local Godot gate has been reported successful.

Do not record inferred test counts, unexecuted smoke results, or architectural intent as validated runtime behavior.
