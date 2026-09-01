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
```

The strict external runner is validated under **Godot 4.7.1** and rejects script/engine errors even when an individual Godot process exits `0`.

Latest locally validated checkpoint:

```text
RESULT: 31 PASS / 31 TOTAL
PASS headless_suite (31 tests)
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
Strict headless suite                        PASS — 31 tests
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
→ DecisionRouter
→ CurrentIntention
```

World progression now also has a first persistent dynamic-process path:

```text
EnvironmentState + DynamicProcessStore
→ DynamicProcessAdvanceService
→ authoritative bounded property mutation
→ WorldAdvanceResult.change_set
→ derived invalidation
→ remaining simulation micro-loop
```

A committed dynamic process is deliberately **not** a committed unresolved future hazard result. For example, gradual palm weakening may be committed World evolution while a later falling-object victim remains unresolved until the hazard/collision stage.

---

# Validated owner boundaries

```text
World truth != Wilson observation != Wilson belief != player-private intent
```

Current regressions support these boundaries:

- World/action mutations emit semantic invalidation only after admitted mutation.
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
  id
  target_property
  rate_per_second
  lower_bound / upper_bound

DynamicProcessInstance
  id
  definition_id
  subject
  lifecycle
  elapsed

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

This vertical intentionally does **not** yet implement:

- hazard projection;
- collision/victim resolution;
- protection/exposure;
- stochastic environmental response selection;
- detailed food/fire-specific process semantics.

---

# Persistence baseline

Current development schemas:

```text
SimulationSnapshotService schema: v8
ActionExecutionSnapshotService schema: v2
ContentPackLoader schema: v1
```

`SimulationSnapshotService v8` currently persists/reconstructs tested authoritative/runtime causes including:

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
```

Reconstructible indexes/projections/caches remain excluded from durable state and are rebuilt as required.

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
1. protection / exposure + hazards / immediate-threat production
2. shallow non-Wilson actor behavior
3. Director + player intervention / suggestions
4. run lifecycle / death / resurrection / Legacy / PlayerProfile
5. fine spatial/nav/occlusion + Godot presentation adapters
6. deterministic playable scenario/bootstrap tooling
7. representative multi-system scenario suites + seed-population tests
```

Food/fire/cooking/freshness-specific breadth should use the generic World/property/process boundaries where sufficient and add new primitives only when representative behavior proves they are necessary.

---

# Admission rule for future status claims

A new runtime capability should be marked PASS here only after the corresponding strict local Godot gate has been reported successful.

Do not record inferred test counts, unexecuted smoke results, or architectural intent as validated runtime behavior.
