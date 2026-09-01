# Discovery Status

## Purpose

This file records the **currently implemented and locally validated runtime baseline** for Wilson Shipwrecked.

Canonical semantics remain in the domain and architecture documents. This file answers only:

- what is implemented now;
- what has passed the strict Godot gate;
- which persistence schemas are current;
- which known limitations remain;
- what vertical comes next.

---

# Current validated baseline

The strict external runner is validated under **Godot 4.7.1** and rejects script/engine errors even when an individual Godot process exits `0`.

Latest locally validated checkpoint:

```text
RESULT: 37 PASS / 37 TOTAL
PASS headless_suite (37 tests)
```

Validated breadth now includes:

```text
structural World/runtime foundation
→ Wilson drives + bounded drive candidates
→ Projects runtime + project candidates
→ Wilson learning state (associations / habits / episodes / Presence boundary)
→ authoritative EnvironmentState + persisted dynamic processes
→ protection/exposure projections
→ hazard projection + Wilson-relative immediate-threat production
→ shallow non-Wilson actor runtime behavior
→ Director opportunity lifecycle
→ PlayerRunState + bounded suggestions
→ validated physical player-intervention boundary
```

---

# Closed implementation gates

## Structural/runtime foundation

Strict regressions continue to cover:

```text
World relation runtime + qualified identity
PropertyDefinition/runtime property validation
EffectivePhysicalProfile
AssemblyBindingProjection / AssemblyValidity
CompositionDependencyProjection / derived invalidation
SemanticPattern / RequirementPredicate / ActionAttemptability
ActionExecution lifecycle / interruption / commit checkpoint
transactional supported World effect batches
WorldEvent commit boundary
coarse spatial PerceptionAccess
Perception / PerceptualEvidence
BeliefStore / EpistemicGraphProjection
DecisionRouter / CurrentIntention
save/load/rebuild reconstruction
mid-action causal reconstruction
structural-scale reconstruction
```

## System breadth

```text
Drives                                         PASS
Projects                                       PASS
Associations / habits / episodes               PASS
Presence relationship learning boundary        PASS
EnvironmentState                               PASS
Dynamic World processes                        PASS
Dynamic-process derived invalidation           PASS
Protection projection / exposure resolution    PASS
Hazard projection                              PASS
Perceived-threat interpretation                PASS
Immediate-threat candidate routing             PASS
Shallow non-Wilson actor behavior              PASS
Shallow actor persistence                      PASS
Director opportunity lifecycle                 PASS
Director bounded candidate production          PASS
Player suggestion / bounded insistence         PASS
Player physical intervention commit boundary   PASS
Director + PlayerRunState persistence           PASS
Strict headless suite                          PASS — 37 tests
```

---

# Current authority map

```text
World
  physical truth
  environment / dynamic processes
  Wilson body truth
  shallow non-Wilson actor runtime state

WilsonCognition
  drives / beliefs / associations / habits / episodes
  Presence relationship
  current intention

Projects
  project lifecycle + bounded metadata

ActionExecution
  execution lifecycle / committed outcomes

Director
  directed-opportunity lifecycle only

PlayerRunState
  God Power
  run-local intervention permissions
  non-intervention progress
  active suggestion state
```

Validated invariants:

```text
World truth
!= Wilson observation
!= Wilson belief
!= player-private intent
!= Director intent
```

- Projects mutate only after successful grounded World outcomes.
- Environment and actor progression remain World-owned.
- Protection, exposure, hazard and perceived-threat values remain derived/non-owning.
- Immediate threat wins through a separate routing regime rather than oversized scores.
- Shallow actors do not receive a second Wilson-like cognition stack.
- Director opportunities provide bounded candidate bias; Director never commits Wilson's intention.
- Player suggestions provide bounded ordinary `INTENTIONAL` bias; they are signals, not commands.
- Physical player intervention must pass an explicit World admission boundary.
- God Power is spent only after World accepts the physical intervention.
- Permission, affordability or World rejection leaves God Power and non-intervention progress unchanged.
- Player-private intent does not directly mutate Wilson psychology; any psychological consequence still requires ordinary perception/attribution paths.

---

# Runtime decision inputs

Current bounded candidate sources include:

```text
perceptual opportunities
drives
projects
habits / additional composed sources
Director opportunities
active player suggestion
immediate-threat defenses from PerceivedThreat
```

Routing remains:

```text
IMMEDIATE_THREAT
  wins by regime

TACTICAL
  considered when appropriate to current intention

INTENTIONAL
  ordinary competition among bounded candidates
```

Director and player suggestion candidates participate in the ordinary intentional regime and therefore cannot bypass autonomy.

---

# Environment, hazards and actors

World/environment progression currently composes:

```text
EnvironmentState
+ DynamicProcessStore
+ shallow ActorStateStore
→ authoritative World progression
→ SemanticChangeSet when applicable
→ derived invalidation
→ remaining simulation micro-loop
```

Hazard interpretation remains deliberately split:

```text
active/committed World process
→ HazardProjection

accessible EVENT PerceptualEvidence
→ PerceivedThreat
→ bounded defensive candidates
→ IMMEDIATE_THREAT routing
```

A committed process is not a committed future collision victim/result, and `HazardProjection` is not Wilson knowledge.

Shallow actors currently support authored profiles/rules, bounded deterministic rule priority, coarse stimulus tags, mode/cooldown state and coarse `PlaceId` relocation. Material interactions such as stealing, biting, consuming or breaking objects still require normal grounded physical/action contracts.

---

# Director baseline

Implemented runtime:

```text
DirectedOpportunityDefinition
DirectorOpportunityState
DirectorStateStore
DirectorOpportunityService
DirectorCandidateSource
```

Lifecycle:

```text
ELIGIBLE
→ ACTIVE
→ COOLDOWN
→ ELIGIBLE

or

ACTIVE
→ EXHAUSTED
```

Authored definitions provide bounded candidate bias, cooldown and maximum activation count. Runtime state owns lifecycle, cooldown remaining and activation count.

Director does not:

- mutate World;
- mutate Wilson cognition;
- select the final intention;
- force an authored scene sequence.

---

# Player intervention baseline

Implemented run-local state and services:

```text
PlayerRunState
PlayerSuggestion
PlayerSuggestionService
PlayerSuggestionCandidateSource
InterventionDefinition
PhysicalInterventionRequest
PlayerInterventionService
```

Suggestions:

```text
semantic intention + bindings
→ bounded external_bias
→ normal INTENTIONAL competition
```

Insistence is explicitly bounded. A suggestion remains rejectable because higher-priority or higher-value Wilson-relative candidates can still win.

Physical intervention boundary:

```text
permission
+ affordability
→ explicit World intervention port
→ World accepts
→ spend God Power
→ reset non-intervention progress
```

If the World port rejects the request, no God Power is spent.

This slice does **not** yet implement:

- UI or drag/drop adapters;
- natural-language suggestion interpretation;
- concrete God Power-specific World mutation recipes;
- passive God Power generation/balance curve;
- intervention causal windows;
- automatic Presence attribution from interventions.

---

# Persistence baseline

Current development schemas:

```text
SimulationSnapshotService schema: v9
DirectorPlayerSnapshotService schema: v1
ActionExecutionSnapshotService schema: v2
ContentPackLoader schema: v1
```

`SimulationSnapshotService v9` persists/reconstructs tested run causes including:

```text
entities + runtime property overrides
qualified World relations
Wilson coarse PlaceId
BeliefStore typed claims
CurrentIntention
DriveState values
ProjectInstance state
AssociationStore
HabitStore
EpisodeStore
PresenceRelationship
EnvironmentState
DynamicProcessInstance state
ActorRuntimeState
```

`DirectorPlayerSnapshotService v1` currently persists/reconstructs owner-local causes for:

```text
Director opportunity lifecycle
Director cooldown remaining
Director activation count
God Power
player permissions
non-intervention progress
active suggestion
suggestion bindings / bounded bias / remaining insistence
```

Director/PlayerRunState persistence is intentionally owner-local in this slice. A future full run-save boundary may compose these owner snapshots without changing authority semantics.

Reconstructible state remains excluded, including relation/epistemic/physical projections, protection/exposure, hazard projections, perceived threats and generated decision candidates.

These are development schemas. Unsupported versions fail fast; early-development migration is not currently required.

---

# Known correctness/support limitations

## Drives

Two known issues remain open:

1. The application orchestrator still performs decision routing every simulation tick. Upward drive-band crossings expose a reconsideration signal, but generic reconsideration gating across all causes is not implemented.
2. Drive persistence stores numeric values but not hysteresis-band memory. A value inside a deadband can reconstruct a different urgency band after save/load.

## Other cross-cutting work

Still required before or alongside later breadth:

```text
collision/overlap + grounded Wilson body consequences
generic reconsideration gating
drive hysteresis-memory persistence
Wilson-relative route/escape evaluation
intervention causal windows
automatic habit-disuse/context producers
Presence causal-attribution production
full run-save composition across owner-local snapshots
```

---

# Remaining major verticals

Recommended sequence from the validated 37-test checkpoint:

```text
1. run lifecycle / death / resurrection / Legacy / PlayerProfile
2. fine spatial/nav/occlusion + Godot presentation adapters
3. deterministic playable scenario/bootstrap tooling
4. representative multi-system scenario suites + seed-population tests
```

Food/fire/cooking/freshness-specific breadth should continue to use generic World/property/process boundaries where sufficient and add new primitives only when representative behavior proves them necessary.

---

# Admission rule

A runtime capability is marked PASS here only after the corresponding strict local Godot gate has been reported successful.

Do not record inferred test counts, unexecuted smoke results or architectural intent as validated runtime behavior.
