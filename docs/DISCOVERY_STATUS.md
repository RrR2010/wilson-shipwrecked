# Discovery Status

## Purpose

This file records the **currently implemented and locally validated runtime baseline** for Wilson Shipwrecked.

Canonical semantics remain in the domain/architecture documents. This file should not restate those documents in full; it answers:

- what is implemented now;
- what has passed the strict Godot gate;
- which persistence versions are current;
- which known limitations remain;
- what vertical comes next.

---

# Current phase

Product/behavior discovery, architecture contracts, the language-neutral functional domain, normalized cross-cutting asset catalog, and the structural runtime foundation are complete enough for active system implementation.

The validated runtime currently includes:

```text
structural World/runtime foundation
→ Wilson drives + drive candidate production
→ Projects runtime + project candidate production
→ Wilson learning state (associations / habits / episodes / Presence)
→ authoritative environment state + persisted dynamic processes
→ protection/exposure projections
→ hazard projections + Wilson-relative immediate-threat production
→ shallow non-Wilson actor runtime behavior
```

The strict external runner is validated under **Godot 4.7.1** and rejects script/engine errors even when an individual Godot process exits `0`.

Latest locally validated checkpoint:

```text
RESULT: 35 PASS / 35 TOTAL
PASS headless_suite (35 tests)
```

---

# Closed implementation gates

## Structural runtime foundation

The following foundation areas remain covered by strict headless regressions:

```text
World relation runtime
qualified relation identity
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

## System breadth verticals

```text
Drives                                       PASS — Godot 4.7.1 headless
Projects                                     PASS — Godot 4.7.1 headless
Associations / habits / episodes             PASS — Godot 4.7.1 headless
Presence relationship learning boundary      PASS — Godot 4.7.1 headless
EnvironmentState                             PASS — Godot 4.7.1 headless
Dynamic World processes                      PASS — Godot 4.7.1 headless
Dynamic-process derived invalidation         PASS — Godot 4.7.1 headless
Environment/process persistence              PASS — Godot 4.7.1 headless
Protection projection / exposure resolution  PASS — Godot 4.7.1 headless
Hazard projection                            PASS — Godot 4.7.1 headless
Perceived-threat interpretation              PASS — Godot 4.7.1 headless
Immediate-threat candidate routing           PASS — Godot 4.7.1 headless
Shallow non-Wilson actor behavior            PASS — Godot 4.7.1 headless
Shallow actor persistence                    PASS — Godot 4.7.1 headless
Strict headless suite                        PASS — 35 tests
```

---

# Current validated implementation chain

```text
typed DomainId / RuntimeWorldRef
→ immutable authored content registry
→ bounded property/content schemas
→ authoritative World stores
→ relation / assembly / physical projections
→ action attemptability
→ action execution
→ successful World commit
→ SemanticChangeSet
→ derived invalidation
→ WorldEvent
→ PerceptionAccess
→ PerceptualEvidence
→ belief + Wilson-local learning
→ drive progression
→ bounded candidate sources
   - perceptual opportunities
   - drives
   - projects
   - habits / additional composed sources
   - immediate-threat defenses from PerceivedThreat
→ DecisionRouter
→ CurrentIntention
```

World/environment progression includes:

```text
EnvironmentState + DynamicProcessStore + shallow actor state
→ DynamicProcessAdvanceService + ShallowActorAdvanceService
→ authoritative bounded World mutation
→ WorldAdvanceResult.change_set
→ derived invalidation
→ remaining simulation micro-loop
```

Hazard/emergency interpretation remains explicitly split:

```text
active/committed World process
→ HazardProjection (authoritative derived risk envelope)

accessible EVENT PerceptualEvidence
→ PerceivedThreat (Wilson-relative)
→ bounded defensive candidates
→ IMMEDIATE_THREAT routing regime
```

A committed process is deliberately **not** a committed collision victim/result, and a `HazardProjection` is deliberately **not** Wilson knowledge.

---

# Validated owner boundaries

```text
World truth != Wilson observation != Wilson belief != player-private intent
```

Current regressions support these boundaries:

- World/action mutations emit semantic invalidation only after admitted mutation.
- Rejected World commits do not trigger derived invalidation.
- `WorldEvent` exists only for committed authoritative facts.
- Perception exposes only accessible roles/semantics.
- Belief and learning consume Wilson-accessible evidence rather than hidden World bindings.
- Projects own project metadata/lifecycle; physical structures remain World-owned.
- Project progress is accepted only after a successful grounded World commit.
- Habits are bounded candidate bias, not commands.
- Presence psychology is not updated merely because a WorldEvent exists; it requires Wilson-relative attribution evidence.
- Environment and dynamic process state are World-owned.
- Dynamic process definitions are authored; process instances/lifecycle/elapsed state are durable runtime causes.
- Dynamic process property changes participate in the same derived-invalidation boundary as action-driven World changes.
- `ProtectionProjection`, `ExposureResult`, `HazardProjection` and `PerceivedThreat` are derived/non-owning state.
- Protection depends on current World configuration/properties rather than shelter-specific authority flags.
- `HazardProjection` does not commit a future victim or collision result.
- Wilson emergency cognition is produced only from accessible perceptual evidence, not directly from authoritative hazard projections.
- Immediate threat wins through a separate routing regime rather than infinity/oversized candidate scores.
- Shallow non-Wilson actor runtime state belongs to World; actor profiles/rules are authored definitions.
- Shallow actors do not receive Wilson cognition stores, projects, Presence psychology or long-horizon planning state.
- Coarse actor locomotion/state progression occurs through World-owned progression; material interactions still require normal grounded action/outcome semantics.

---

# Implemented cognition breadth

## Drives

Accepted drives:

```text
hunger
energy
comfort
stimulation
```

Values remain finite and bounded within `[0,1]`. Urgency uses hysteretic bands and drive candidates participate in ordinary decision competition.

### Known drive correctness limitations

Two details are **not yet closed** and must not be overstated:

1. The current application orchestrator still performs decision routing every simulation tick. Upward drive-band crossings expose a meaningful signal, but generic reconsideration gating has not yet been implemented across all causes.
2. Persistence currently stores drive values but not hysteresis-band memory. Inside a hysteresis deadband, save/load can reconstruct a different band from the same numeric value. Exact behavioral round-trip therefore requires persisting the band/hysteresis memory or equivalent authoritative state.

These are follow-up correctness items, not reasons to reopen the validated bounded drive/candidate vertical.

## Associations

Durable Wilson-relative association state currently separates:

```text
valence: [-1,+1]
attachment: [0,1]
```

Updates are bounded/saturating and the dimensions remain independent.

## Habits

Habits currently model bounded:

```text
cue + semantic intention + bindings → strength [0,1]
```

Evidence may strengthen or weaken them. Habit candidate production contributes through normal decision competition.

## Episodes

The current episode store supports:

- importance threshold;
- causal/provenance deduplication;
- bounded capacity;
- deterministic pruning of lower-importance history.

It is not an unlimited autobiographical event log.

## Presence

Current durable dimensions are:

```text
presence_belief: [0,1]
trust: [-1,+1]
dependency: [0,1]
```

Presence updates require explicit Wilson-relative attribution evidence; player-private intent never mutates this state directly.

## Immediate threat

Current threat cognition includes:

```text
ThreatInterpretationRule
PerceivedThreatService
PerceivedThreat
DefensiveCandidateDefinition
ImmediateThreatCandidateSource
```

Only accessible typed EVENT evidence that satisfies an authored confidence threshold produces `PerceivedThreat`. Defensive candidate contributions remain bounded and ordinary within the emergency regime.

---

# Projects baseline

Current project runtime includes:

```text
ProjectDefinition
ProjectInstance
ProjectStore
ProjectContributionService
ProjectCandidateSource
```

Canonical implemented flow:

```text
project candidate
→ ordinary decision competition
→ action
→ successful World commit
→ grounded project contribution validation
→ ProjectStore mutation
```

Definitions remain authored content. Runtime project instances persist lifecycle, subject bindings and bounded contribution metadata.

---

# Environment / dynamic-process baseline

`EnvironmentState` currently persists coarse semantic environment state:

```text
weather
daylight_phase
```

The first generic dynamic-process runtime consists of:

```text
DynamicProcessDefinition
DynamicProcessInstance
DynamicProcessStore
DynamicProcessAdvanceService
```

Current lifecycle:

```text
ACTIVE
PAUSED
COMPLETED
```

The generic property progression can represent first-order processes such as drying, ripening, spoilage, fuel consumption or gradual weakening without adding recipe-specific runtime classes.

---

# Protection / exposure baseline

Current environmental protection is derived rather than owner state:

```text
ProtectionRuleDefinition
ProtectionProjectionService
ProtectionProjection
ExposureResolver
ExposureResult
```

The first implementation uses ordinary World relations plus bounded physical properties to derive configuration-relative shielding.

Validated semantics include:

- a covering object does not protect a target merely by type/capability;
- admitted World configuration is required;
- degrading a cover's bounded protection property increases resolved exposure;
- protection layers compose in a bounded derivation;
- no universal `indoors`, `leak_level`, `ShelterSystem` or persisted protection cache is required.

---

# Hazard / immediate-threat baseline

Current hazard support includes:

```text
HazardRuleDefinition
HazardProjectionService
HazardProjection
```

Hazard projections are authoritative derived risk envelopes over active dynamic processes. They do not select or persist future victims/results.

Wilson-relative emergency interpretation is separate:

```text
PerceptualEvidence(EVENT)
→ ThreatInterpretationRule
→ PerceivedThreat
→ ImmediateThreatCandidateSource
→ DecisionRouter(IMMEDIATE_THREAT)
```

The regression explicitly proves that a lower-scoring defensive candidate wins against a higher-scoring intentional candidate because the routing regime has priority.

This vertical intentionally does **not** yet implement:

- collision/overlap resolution;
- grounded body injury/death;
- Wilson-relative route planning;
- intervention windows / causal-window validation;
- continuous geometry/future physics prediction.

---

# Shallow non-Wilson actor baseline

Current actor breadth is deliberately shallow and World-owned:

```text
ActorProfileDefinition
ActorBehaviorRule
ActorRuntimeState
ActorStateStore
ShallowActorAdvanceService
```

Validated behavior includes:

- authored profiles/rules rather than actor-specific subclasses;
- bounded rule priority with stable deterministic tie-breaking;
- optional externally supplied coarse stimulus tags;
- durable mode, decision cooldown and last-rule provenance;
- coarse relocation between `PlaceId`s through the authoritative entity owner;
- composition into the same World/environment advance boundary used by dynamic processes;
- persistence/reconstruction of actor runtime state.

This is not a second Wilson-like cognition stack. It intentionally does **not** add:

- beliefs or episodic memory for animals;
- project/Presence state;
- long-horizon planning;
- combat AI;
- direct shortcuts for material interactions such as stealing, biting, consuming or breaking objects.

Those material consequences must remain grounded through the normal physical/action contracts when added.

---

# Persistence baseline

Current development schemas:

```text
SimulationSnapshotService schema: v9
ActionExecutionSnapshotService schema: v2
ContentPackLoader schema: v1
```

`SimulationSnapshotService v9` currently persists/reconstructs tested authoritative/runtime causes including:

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

Actor runtime persistence includes profile binding, current mode, decision cooldown and last selected rule. Authored actor profiles/rules are not duplicated into the save.

Reconstructible state remains excluded from durable snapshots, including:

```text
relation / epistemic / physical projections
ProtectionProjection
ExposureResult
HazardProjection
PerceivedThreat
defensive candidates
```

These are development schemas; unsupported versions fail fast and there is no current requirement to migrate early development snapshots.

---

# Strict runner

The PowerShell headless runner rejects:

```text
SCRIPT ERROR
parse/compile failures
generic Godot ERROR output
explicit FAIL
missing expected PASS marker
nonzero process exit status
```

It emits one compact result per test plus a final suite summary.

---

# Remaining major verticals

The remaining work is primarily system breadth and presentation rather than unresolved foundational ownership.

Recommended sequence from the current checkpoint:

```text
1. Director + player intervention / suggestions
2. run lifecycle / death / resurrection / Legacy / PlayerProfile
3. fine spatial/nav/occlusion + Godot presentation adapters
4. deterministic playable scenario/bootstrap tooling
5. representative multi-system scenario suites + seed-population tests
```

Cross-cutting correctness/support slices still required before or alongside those verticals include:

```text
collision/overlap + grounded body consequence for hazards
generic reconsideration gating
drive hysteresis-memory persistence
Wilson-relative route/escape evaluation
intervention causal windows
automatic habit-disuse/context producers
Presence causal-attribution production
```

Food/fire/cooking/freshness-specific breadth should use the generic World/property/process boundaries where sufficient and add new primitives only when representative behavior proves they are necessary.

---

# Admission rule for future status claims

A new runtime capability should be marked PASS here only after the corresponding strict local Godot gate has been reported successful.

Do not record inferred test counts, unexecuted smoke results, or architectural intent as validated runtime behavior.
