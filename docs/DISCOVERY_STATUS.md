# Discovery Status

## Purpose

This file records the **currently implemented and locally validated runtime baseline** for Wilson Shipwrecked. Canonical product/domain/architecture semantics remain in their owning documents.

---

# Current validated baseline

Strict external runner: **Godot 4.7.1**.

Current integrated `main` checkpoint after PR #74:

```text
e9cf01aab57a18520a4a2d0a52fa7f3a91a839dd
```

Latest operator-reported strict local validation before squash integration:

```text
RESULT: 131 PASS / 131 TOTAL
PASS headless_suite (131 tests)
```

No GitHub Actions status check currently replaces this runtime gate; the operator-run strict Godot suite remains authoritative.

The structural/runtime-foundation phase is closed. The first observable continuous living-simulation phase is also closed: the repository now contains a real Godot living-island playground that runs the production-style runtime continuously, exposes 1x/4x/16x observation controls, and composes several autonomous pressures in one watchable scene.

The leading phase is now **entertaining systemic-diorama calibration**: use the validated playground to create richer self-generated situations, reduce dead time, make shallow actors/environment/history matter more to visible behavior, and judge readability/surprise/comedy rather than adding foundation abstractions.

---

# Validated living-island slice

Current playable/calibration scene:

```text
tools/living_simulation/living_simulation.tscn
```

Validated continuous behavior includes:

```text
Hunger
→ seek food
→ physical movement
→ grounded consume action
→ bounded hunger relief

Energy
→ seek rest
→ physical movement
→ grounded rest action
→ bounded energy relief

Stimulation
→ seek curiosity
→ physical movement
→ grounded inspection
→ bounded stimulation relief

persistent shelter project
→ repeated grounded contributions
→ interruption by stronger pressures
→ later return to same project
→ eventual completion

clear ↔ rain weather
→ ambient context transition
→ perceived tactical rain response
→ seek shelter cover
→ response remains selectable after project completion / from idle

Gerald shallow actor
→ authored mode cycle
→ deferred physical transit through GodotMotionAdapter
→ semantic place commit only after arrival
→ persisted actor→Wilson relationship baseline
```

Presentation remains non-authoritative:

```text
primitive island geometry
staged shelter visuals
weather lighting/rain projection
Wilson intention bubbles/emojis
compact calibration panel
```

The operator manually validated the final scene as coherent and increasingly interesting. Remaining flatness is now product/calibration pressure rather than proof that the runtime cannot sustain a living loop.

---

# Important implementation refinements proven during the living-simulation phase

The integrated scene exposed and closed several real orchestration gaps:

## Active execution uniqueness

A new intention must not create a second active `ActionExecution` for Wilson when an earlier interruptible execution still exists, including post-commit tails whose `CurrentIntention` has already been cleared.

## Same-intention continuation

```text
same intention + same bindings + active execution
→ continue current execution
```

but:

```text
same intention + previous execution terminal
→ a fresh decision step may create the next sequential action
```

This allows persistent work such as repeated shelter contributions without duplicating active executions or freezing on an old terminal execution id.

## Tactical routing from idle

Routing precedence is now effectively:

```text
IMMEDIATE_THREAT
→ TACTICAL
→ INTENTIONAL
→ NONE
```

A tactical response is not conditional on there already being a `CurrentIntention`. A context-local response such as `rain → seek_safer_cover` may begin from idle as well as interrupt/refine ongoing ordinary activity.

## Weather context

Weather transitions are produced through the production runtime composition and exposed through ordinary ambient perception/context trigger paths. The living scene does not own a weather-specific gameplay controller.

## Time acceleration

The living scene uses `Engine.time_scale` for operator 1x/4x/16x controls because the current Godot motion adapter relies on engine physics cadence. Semantic time remains explicit and the long-running headless gate verifies cadence stability under accelerated observation.

---

# Major closed capability families

The following are implemented and regression-backed at the current baseline:

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
Drives: hunger / energy / comfort / stimulation foundation  PASS
Projects with persistent grounded progress                  PASS
Habits / episodes / belief learning                         PASS
Environment / gradual dynamic processes                     PASS
Procedural weather                                           PASS
Protection / exposure                                       PASS
Assembly-composed protection/degradation foundations        PASS
Authored structural relation failure                        PASS
Hazard / perceived threat separation                        PASS
Immediate-threat interruption/resumption                    PASS
Tactical response from idle                                 PASS
WilsonBody impact / injury / death causality                PASS
Real RigidBody3D contact observation                        PASS
Player intervention causal-window validation                PASS
Presence relationship learning                              PASS
Shallow non-Wilson actor behavior / physical locomotion     PASS
ActorRelationshipStore authority                            PASS
Director opportunity lifecycle                              PASS
Player suggestions / bounded insistence                     PASS
Run lifecycle / resurrection                                PASS
PlayerProfile cross-run separation                          PASS
Deterministic EngineScenarioHarness                         PASS
Continuous observable living-island playground              PASS
10-minute accelerated living-simulation stress gate         PASS
Strict integrated feature suite                             PASS — 131 tests
```

---

# Authority model

```text
World
  physical truth
  environment / weather / dynamic processes
  entity properties
  relations / assembly bindings
  Wilson body truth
  shallow non-Wilson actor runtime state
  non-Wilson actor relationship state

Wilson Cognition
  drives / beliefs / associations / habits / episodes
  Presence relationship
  current intention
  bounded suspended prior intention where authored

Projects
  project lifecycle / progress

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
!= non-Wilson relationship state
!= player-private intent
!= Director intent
!= derived physical projection
!= presentation
```

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

The living-island scene uses the same authoritative owners/runtime composition and explicit semantic-to-Godot bindings; it is not a parallel dev-only simulation architecture.

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

Historical development-snapshot migration remains requirement-driven.

---

# Known limitations / deferred pressures

Still open, but not leading by default:

```text
snapshot compatibility/migration policy for earlier development schemas
SimulationSnapshotService.capture positional API cleanup
SimulationBootstrapDefinition positional constructor cleanup
drive hysteresis-band memory persistence
Legacy-to-new-Wilson seeding policy
generalized production scene-binding/host composition
orientation/view-cone passive refresh
negative/absence perceptual evidence
habit disuse/decay/context-generalization producers
route-memory acquisition/decay/generalization
broader collision/grounding/fall consequence policies
relationship decay/generalization/social-graph breadth
broader production interaction producers for actor relationships
snapshot guarantees for mid-interruption suspended intention
derived component properties feeding assembly-slot derivations
explicit mid-step invalidation for rules consuming freshly mutated derived state
automatic detached-component dynamic-process creation
```

Do not implement these merely to clear a backlog.

---

# Current calibration pressures

The validated playground exposed product-facing opportunities rather than foundation blockers.

Most important next pressures:

```text
1. idle / boredom
   stimulation should plausibly rise faster during genuine inactivity,
   with bounded acceleration rather than random action injection

2. post-project life
   after shelter completion Wilson still needs optional routines/interests so the
   scene does not collapse into eat / rest / occasional explore / idle

3. Gerald meaning
   Gerald currently proves independent shallow movement and relationship state,
   but is mostly ambient; the next useful vertical should make his presence alter
   a Wilson-visible situation without turning him into a second full Wilson

4. history changing later choice
   learning/habits/associations are implemented, but the playground should make at
   least one acquired experience visibly change a later decision in the same run

5. environmental consequence
   weather changes behavior and presentation; protection/degradation foundations
   are stronger than what the playground currently exposes visually/behaviorally

6. player influence later
   Presence/intervention foundations are available, but should be added only after
   the autonomous scene is interesting enough to perturb rather than rescue
```

`BEHAVIORAL_MODEL.md` already treats stimulation/boredom as anti-stagnation pressure; do not add a separate generic `boredom` owner merely to implement idle acceleration.

---

# Current phase: entertaining systemic diorama

Target question:

> Can several minutes of autonomous play produce understandable situations that feel like small stories rather than a rotation through maintenance meters?

The next active transition context is:

```text
docs/handoffs/observable-living-simulation-to-entertaining-systemic-diorama.md
```

The previous observable-living-simulation handoff is complete and historical.

---

# Admission rule

A runtime capability is marked PASS here only after the corresponding strict local Godot gate has been reported successful.

Do not record inferred test counts, unexecuted smoke results or architectural intent as validated runtime behavior.
