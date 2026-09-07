# Discovery Status

## Purpose

This file records the **currently implemented and locally validated runtime baseline** for Wilson Shipwrecked. Canonical product/domain/architecture semantics remain in their owning documents.

---

# Current validated baseline

Strict external runner: **Godot 4.7.1**.

Latest locally validated checkpoint:

```text
RESULT: 104 PASS / 104 TOTAL
PASS headless_suite (104 tests)
```

Current integrated `main` checkpoint after the last runtime block:

```text
f92d98543db5d73c1bb9de47ca7a270ca45eea54
```

The structural/runtime-foundation phase is closed. The validated runtime now supports enough causal breadth to shift the leading work from proving fundamental ownership boundaries to **composing those foundations into richer persistent systemic gameplay**.

---

# Validated causal breadth

The strict suite covers, among other lower-level regressions, these representative verticals:

```text
shared new-run / deterministic-fixture / snapshot owner bootstrap
→ authoritative simulation owners
→ reconstructible runtime composition

passive perception
→ Wilson learning
→ drive/project/habit candidate pressure
→ trigger-gated decision
→ CurrentIntention
→ Godot motion
→ authored ActionExecution
→ accepted World consequence
→ grounded cross-owner consequences

physical Godot observation
→ semantic event admission
→ authored body consequence
→ WilsonBodyState
→ accessible injury evidence
→ Wilson learning
→ later route preference change

physical falling-body observation
→ admitted falling event
→ perception access
→ PerceivedThreat
→ immediate-threat routing
→ committed defensive intention
→ physical escape redirection

ongoing ordinary intention
→ immediate threat selected
→ prior intention suspended
→ defensive motion
→ defense completes
→ suspended intention restored
→ original physical activity resumes

player physical intervention
→ committed World consequence
→ perception
→ causal attribution evidence
→ Presence relationship learning

historical learned habit
+
current perceptual context
→ perceived semantic cue
→ context-matching habit candidate
→ ordinary decision competition

World truth changes while Wilson is absent
→ BeliefStore remains stale
→ Wilson later perceives current property state
→ new belief receives support
→ mutually exclusive prior property belief is contradicted
```

---

# Major closed implementation gates

The following capability families are implemented and regression-backed:

```text
Structural World/runtime foundation                         PASS
Explicit owner/query/service/command boundaries             PASS
Shared SimulationBootstrapDefinition owner construction     PASS
Production fresh-run bootstrap                              PASS
Deterministic product-level world/run generation            PASS
Full current-run restore/rebootstrap                        PASS
Content-dependent ActionExecution reconstruction            PASS
Godot spatial/query/navigation/motion bridge                PASS
Passive spatial perception                                  PASS
Grounded autonomous action causality                        PASS
Drives and grounded drive consequences                      PASS
Projects and project candidate pressure                     PASS
Associations / habits / episodes                            PASS
Perceived-context habit activation                          PASS
Belief learning / epistemic projection                      PASS
Unseen-world-change belief reconciliation                   PASS
Presence relationship learning                             PASS
Perceived-consequence Presence causal attribution           PASS
Environment / gradual dynamic processes                     PASS
Protection / exposure                                       PASS
Hazard projection kept separate from Wilson knowledge       PASS
Perceived threat / immediate-threat routing                 PASS
Real Godot falling-threat defensive response                PASS
Intention interruption / suspension / physical resumption   PASS
WilsonBody impact / injury / death causality                PASS
Real RigidBody3D contact observation                        PASS
Post-accident learning and remembered route avoidance       PASS
Player intervention causal-window validation                PASS
Shallow non-Wilson actor behavior                           PASS
Shallow non-Wilson physical locomotion                      PASS
ActorRelationshipStore authority                            PASS
Relationship-conditioned Gerald behavior                    PASS
Director opportunity lifecycle                              PASS
Player suggestions / bounded insistence                     PASS
Run lifecycle / resurrection                                PASS
PlayerProfile cross-run separation                          PASS
Deterministic EngineScenarioHarness                         PASS
Strict headless suite                                       PASS — 104 tests
```

This list is intentionally capability-oriented rather than a duplicate of every test name.

---

# Authority model

```text
World
  physical truth
  environment / dynamic processes
  Wilson body truth
  shallow non-Wilson actor runtime state
  non-Wilson actor relationship state

WilsonCognition
  drives / beliefs / associations / habits / episodes
  Presence relationship
  current intention
  optional suspended prior intention during authored interruption

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

Important proven refinements:

- `HazardProjection` is authoritative future-risk projection, not Wilson knowledge. Wilson reacts through `PerceivedThreat` derived from accessible perceptual evidence.
- `AssociationStore` is Wilson-relative cognition. Non-Wilson actor affinity belongs to `ActorRelationshipStore`.
- current perceived context is not historical `HabitStore`; perceptual cues activate learned tendencies without becoming durable habit state.
- player-private intent is never Presence evidence by itself; attribution starts from a perceived World consequence.
- an immediate-threat commitment may suspend an ordinary current intention, but does not create a generic arbitrary intention stack.
- hidden World changes do not synchronize into `BeliefStore`; contradictory property values are reconciled only after accessible perceptual evidence arrives.

---

# Runtime composition / bootstrap baseline

Validated common construction remains:

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
                                 ↓
                      RunRuntimeComposer
                                 ↓
                      reconstructible runtime
```

The owner bootstrap includes the implemented World, Wilson cognition, project, environment/process and actor relationship owners. `ActionExecution` reconstruction remains content-dependent and outside generic owner construction. `PlayerProfile` remains outside current-run composition.

`NewRunDefinition` and scenario definitions are bootstrap causes, not runtime authority.

---

# Representative gameplay evidence

## Autonomous consume loop

```text
passive perception
→ target learning
→ hunger pressure
→ food-seeking intention
→ Godot traversal
→ matching ARRIVED
→ authored consume action
→ World commit/event
→ hunger reduction
```

## Long Way Around / accident learning

```text
physical short route is cheaper
→ falling palm causes real contact/injury
→ injury is perceived and learned
→ palm/route association becomes negative
→ physical route truth remains unchanged
→ Wilson later chooses the longer remembered-preferred route
```

## Gerald relationship

Gerald has owner-local actor state plus a separate `ActorRelationshipStore`. Repeated interaction can change Gerald's affinity toward Wilson and alter later behavior. A later vertical also validates non-Wilson semantic destination selection followed by physical transit and semantic arrival commit.

## Threat interruption and continuity

```text
ordinary physical activity in progress
→ perceived threat
→ ordinary intention suspended
→ defensive intention committed
→ physical redirect to safety
→ defense completion
→ original intention restored
→ original destination physically resumed
```

This establishes continuity of autonomy across an emergency rather than a sequence of disconnected reactions.

## Unseen World change / later belief revision

```text
Wilson believes fire_lit=true
→ World changes fire_lit=false while inaccessible
→ belief remains stale
→ Wilson returns and perceives false
→ current value is supported
→ prior mutually exclusive property belief is weakened
```

This is the strongest current regression for `World truth != Wilson knowledge`.

---

# Persistence baseline

Current development schemas remain:

```text
SimulationSnapshotService schema:      v11
DirectorPlayerSnapshotService schema:  v1
RunProfileSnapshotService schema:      v1
ActionExecutionSnapshotService schema: v2
ContentPackLoader schema:              v1
```

Historical development-snapshot migration remains requirement-driven; current schema handling is intentionally strict.

---

# Known limitations / deferred pressures

Still open, but **not the leading phase by default**:

```text
snapshot compatibility/migration policy for earlier development schemas
SimulationSnapshotService.capture positional API cleanup
SimulationBootstrapDefinition positional constructor cleanup
drive hysteresis-band memory persistence
Legacy-to-new-Wilson seeding policy
generalized production scene-binding/host composition
relationship decay/generalization/social-graph breadth
broader production interaction producers for actor relationships
effect-oriented stale player-intervention rejection beyond validated causal windows
orientation/view-cone passive refresh
negative/absence perceptual evidence
habit disuse/decay/context-generalization producers
route-memory acquisition/decay/generalization
broader collision/grounding/fall consequence policies
snapshot support for newly introduced suspended-intention semantics if product save pressure requires mid-interruption persistence guarantees
```

Do not implement these merely to clear a backlog. Pull one forward when representative gameplay or product requirements create concrete pressure.

---

# Current phase: systemic gameplay expansion

The next block should **compose existing foundations into player-visible living-world sequences**, not continue adding architecture in isolation.

Target question:

> Can Wilson now live through coherent multi-system situations that produce readable history, routines, interruptions, learning and persistent environmental change?

Good pressure areas include:

```text
needs / routines / habits interacting over time
multi-step projects with visible persistent partial progress
resource acquisition / transport / contribution / interruption / resumption
Gerald or another shallow actor interfering with Wilson activity
weather/environment changing what is attractive or possible
learned preferences changing later decisions
return-to-game situations where the player can infer what happened
```

Prefer one representative scene that composes several already-proved systems over five new isolated primitives.

A strong example target is:

```text
Wilson wakes hungry
→ acts from a known food source / routine
→ Gerald or environment interferes
→ Wilson adapts from relationship/history
→ resolves or fails the need
→ weather/context changes
→ Wilson redirects
→ later resumes an existing project
```

This is an example pressure shape, not a required scripted sequence.

---

# Recommended next-agent objective

Active transition context:

`docs/handoffs/foundational-causality-to-systemic-gameplay-expansion.md`

The next agent should:

1. select the next representative player-visible situation from product/scene evidence;
2. attempt to compose existing runtime primitives first;
3. add the smallest new primitive only when the scene proves a real semantic gap;
4. keep all established authority boundaries intact;
5. validate both focused semantics and at least one integrated player-visible/headless scenario;
6. prefer progress toward a coherent living-day loop over infrastructure breadth.

The phase is successful when representative sequences feel like one continuous autonomous simulation rather than separate subsystem demonstrations.

---

# Admission rule

A runtime capability is marked PASS here only after the corresponding strict local Godot gate has been reported successful.

Do not record inferred test counts, unexecuted smoke results, or architectural intent as validated runtime behavior.
