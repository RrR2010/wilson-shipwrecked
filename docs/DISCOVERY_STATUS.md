# Discovery Status

## Purpose

This file records the **currently implemented and locally validated runtime baseline** for Wilson Shipwrecked. Canonical product/domain/architecture semantics remain in their owning documents.

---

# Current validated baseline

Strict external runner: **Godot 4.7.1**.

Current integrated `main` checkpoint:

```text
7900c158f4733bc1040e0666a798b2722d5cff51
```

Latest strict validation reported for that integrated checkpoint:

```text
RESULT: 118 PASS / 118 TOTAL
PASS headless_suite (118 tests)
```

Current validated feature candidate:

```text
branch: feat/effective-protection-feedback
RESULT: 122 PASS / 122 TOTAL
PASS headless_suite (122 tests)
```

The feature candidate is **not integrated main** until its pull request is explicitly approved and merged.

The structural/runtime-foundation phase remains closed. The leading work is composing those foundations into richer persistent systemic gameplay while admitting new primitives only when a representative causal vertical proves a real semantic gap.

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

World truth changes while Wilson is absent
→ BeliefStore remains stale
→ Wilson later perceives current property state
→ new belief receives support
→ mutually exclusive prior property belief is contradicted

procedural weather
→ elapsed regime segmentation
→ generic environmental response
→ assembly-slot target
→ binding degradation
→ transitive EffectivePhysicalProfile invalidation

binding integrity degradation
→ effective protection strength decreases
→ ProtectionProjection worsens
→ residual rain exposure increases

binding integrity crosses authored failure threshold
→ attached_to relation removed
→ relation SemanticChange
→ assembly-derived protection disappears

wind response mutates binding integrity in production runtime
→ same world advance evaluates authored relation failure
→ combined PROPERTY + RELATION change set
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
Drives / projects / habits / episodes                       PASS
Belief learning / epistemic projection                      PASS
Presence relationship learning                             PASS
Environment / gradual dynamic processes                     PASS
Procedural weather and coarse-step segmentation             PASS
Protection / exposure                                       PASS
Shared effective-property read boundary                     PASS
Assembly-composed effective protection feedback             PASS
Authored structural relation failure                        PASS
Relation-failure production runtime composition             PASS
Relation-failure content-pack authoring                     PASS
Hazard projection kept separate from Wilson knowledge       PASS
Perceived threat / immediate-threat routing                 PASS
Intention interruption / suspension / physical resumption   PASS
WilsonBody impact / injury / death causality                PASS
Real RigidBody3D contact observation                        PASS
Player intervention causal-window validation                PASS
Shallow non-Wilson actor behavior / locomotion              PASS
ActorRelationshipStore authority                            PASS
Director opportunity lifecycle                              PASS
Player suggestions / bounded insistence                     PASS
Run lifecycle / resurrection                                PASS
PlayerProfile cross-run separation                          PASS
Deterministic EngineScenarioHarness                         PASS
Strict feature-branch suite                                 PASS — 122 tests
```

This list is capability-oriented rather than a duplicate of every test name.

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
!= player-private intent
!= Director intent
!= derived physical projection
!= presentation
```

Important proven refinements:

- `HazardProjection` is authoritative future-risk projection, not Wilson knowledge. Wilson reacts through `PerceivedThreat` derived from accessible perceptual evidence.
- current perceived context is not historical `HabitStore`; perceptual cues activate learned tendencies without becoming durable habit state.
- player-private intent is never Presence evidence by itself; attribution starts from a perceived World consequence.
- hidden World changes do not synchronize into `BeliefStore`; contradictory property values are reconciled only after accessible perceptual evidence arrives.
- `EffectivePhysicalProfile`, `ProtectionProjection` and `ExposureResult` are reconstructible derived state, not authoritative copies of World truth.
- shared effective-property reads use derived profile output when present and ordinary `WorldQuery` property truth otherwise.
- relation-failure thresholds currently consume authoritative subject properties only; derived thresholds require an explicit mid-step invalidation boundary before admission.

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

`RunRuntimeComposer` now shares one effective-property resolver across action predicates, environmental susceptibility and protection projection.

When environment/process owners are present, production world advancement composes:

```text
weather progression
→ environmental responses
→ authored relation-failure evaluation
→ gradual dynamic-process advancement
→ combined SemanticChangeSet
```

Derived invalidation remains application-layer work after the authoritative world advance returns its changes.

---

# Environmental composition evidence

The cloth-shelter weather fixture now has regression-backed causal continuity through both degradation and structural failure:

```text
rain / moisture
→ effective physical properties
→ wind susceptibility
→ binding stress
→ binding integrity decreases
→ effective rain protection decreases
→ residual rain exposure increases
```

and:

```text
binding_integrity <= authored threshold
→ attached_to removed
→ assembly dependency invalidated
→ derived protection disappears
→ exposure rises to unprotected level
```

No `ShelterSystem`, entity-subtype callback, or weather-specific structural controller is required.

A detached component does **not** automatically become a hazard. Moving dangerous geometry remains a later boundary expressed through ordinary dynamic-process/hazard semantics when warranted.

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

The content schema remains v1 because the new `relation_failures` field is additive and optional.

Historical development-snapshot migration remains requirement-driven; current schema handling is intentionally strict.

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
relationship decay/generalization/social-graph breadth
broader production interaction producers for actor relationships
effect-oriented stale player-intervention rejection beyond validated causal windows
orientation/view-cone passive refresh
negative/absence perceptual evidence
habit disuse/decay/context-generalization producers
route-memory acquisition/decay/generalization
broader collision/grounding/fall consequence policies
snapshot support for newly introduced suspended-intention semantics if product save pressure requires mid-interruption persistence guarantees
derived component properties feeding assembly-slot derivations (currently slot reads raw component property)
explicit mid-step invalidation if a future rule must consume freshly mutated derived state in the same world advance
automatic detached-component dynamic-process creation only if a representative scene proves the need
```

Do not implement these merely to clear a backlog.

---

# Current phase: systemic gameplay expansion

The next blocks should compose existing foundations into player-visible living-world sequences rather than continue adding architecture in isolation.

Target question:

> Can Wilson live through coherent multi-system situations that produce readable history, routines, interruptions, learning and persistent environmental change?

Strong pressure areas include:

```text
needs / routines / habits interacting over time
multi-step projects with visible persistent partial progress
resource acquisition / transport / contribution / interruption / resumption
Gerald or another shallow actor interfering with Wilson activity
weather/environment changing what is attractive or possible
weather physically degrading constructed configuration
repair/maintenance emerging from persistent structural consequences
learned preferences changing later decisions
return-to-game situations where the player can infer what happened
```

Prefer one representative scene that composes several already-proved systems over isolated new primitives.

---

# Admission rule

A runtime capability is marked PASS here only after the corresponding strict local Godot gate has been reported successful.

Do not record inferred test counts, unexecuted smoke results, or architectural intent as validated runtime behavior.
