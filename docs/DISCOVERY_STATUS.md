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

The strict external runner is validated under **Godot 4.7.1**.

Latest locally validated checkpoint:

```text
RESULT: 39 PASS / 39 TOTAL
PASS headless_suite (39 tests)
```

Validated breadth now includes:

```text
structural World/runtime foundation
→ Wilson drives + bounded drive candidates
→ Projects runtime + project candidates
→ Wilson learning state
→ EnvironmentState + dynamic processes
→ protection/exposure + hazard/immediate-threat boundaries
→ shallow non-Wilson actor runtime behavior
→ Director opportunity lifecycle
→ PlayerRunState + bounded suggestions + physical intervention boundary
→ current-run lifecycle + resurrection transaction boundary
→ cross-run PlayerProfile / Legacy admission
```

---

# Closed implementation gates

```text
Structural World/runtime foundation              PASS
Drives                                           PASS
Projects                                         PASS
Associations / habits / episodes                 PASS
Presence relationship learning boundary          PASS
EnvironmentState / dynamic processes              PASS
Protection / exposure                             PASS
Hazard projection / perceived threat              PASS
Immediate-threat routing                          PASS
Shallow non-Wilson actors                         PASS
Director opportunity lifecycle                    PASS
Player suggestions / bounded insistence           PASS
Physical player intervention boundary             PASS
Run lifecycle                                     PASS
Resurrection transaction boundary                 PASS
PlayerProfile / cross-run Legacy admission        PASS
Owner-local persistence for implemented owners    PASS
Strict headless suite                              PASS — 39 tests
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
  directed-opportunity lifecycle

PlayerRunState
  God Power
  run-local permissions
  non-intervention progress
  active suggestion

RunLifecycleState
  current-run ACTIVE / DEAD / ENDED lifecycle metadata
  death/resurrection counts
  semantic death/end reasons

PlayerProfile
  Legacy knowledge
  diary/archive
  lifetime statistics
  global unlocks
```

Core invariant:

```text
World truth
!= Wilson observation
!= Wilson belief
!= player-private intent
!= Director intent
!= cross-run profile state
```

`RunLifecycleState` does **not** replace Wilson body truth. Physical death/injury remains World-owned. Resurrection is a lifecycle transaction that first requires an explicit World/body resurrection port to accept the physical restoration; only then may the run lifecycle return from `DEAD` to `ACTIVE`.

`PlayerProfile` is outside active Run state. Cross-run admission is deliberately allow-listed through `RunProfileProjection`; the projection does not contain Wilson episodes, habits, associations, Presence state, autobiographical causal history or death memories.

---

# Runtime decision/intervention boundaries

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

Routing remains separated by regime. Director and player suggestions participate in ordinary bounded competition and cannot force Wilson.

Physical intervention remains:

```text
permission + affordability
→ explicit World admission
→ successful World mutation
→ only then spend God Power
```

Player-private intent does not directly mutate Wilson psychology.

---

# Environment / hazard / actor boundaries

World/environment progression composes authoritative environment, dynamic-process and shallow-actor causes. Derived protection, exposure, hazard and perceived-threat values remain non-owning/reconstructible.

A committed environmental process is not a committed future collision victim/result. Wilson emergency cognition is produced from accessible perceptual evidence rather than hidden HazardProjection state.

Shallow non-Wilson actors remain World-owned and deliberately do not receive Wilson-like cognition, projects, Presence or long-horizon planning.

---

# Run lifecycle / profile baseline

Implemented runtime:

```text
RunLifecycleState
ResurrectionService
RunProfileProjection
EndRunService
PlayerProfile
RunProfileSnapshotService
```

Lifecycle:

```text
ACTIVE
→ DEAD
→ ACTIVE     via admitted resurrection transaction

ACTIVE or DEAD
→ ENDED      via EndRun
```

Validated semantics:

- resurrection cannot revive lifecycle when the World/body port rejects restoration;
- successful physical restoration precedes lifecycle revival;
- EndRun ends the current run before admitting cross-run profile data;
- Legacy knowledge is typed and deduplicated;
- diary/archive, lifetime statistics and global unlocks are profile-owned;
- cross-run admission is explicit rather than copying Wilson cognition wholesale;
- run lifecycle and PlayerProfile survive JSON round-trip reconstruction.

This vertical intentionally does **not** yet implement:

- grounded injury/death production from WilsonBody/vitality;
- resurrection visuals/presentation;
- full new-run bootstrap/reset;
- Legacy-to-new-Wilson belief seeding;
- Diary narrative generation;
- offline catch-up.

---

# Persistence baseline

Current development schemas:

```text
SimulationSnapshotService schema:      v9
DirectorPlayerSnapshotService schema:  v1
RunProfileSnapshotService schema:      v1
ActionExecutionSnapshotService schema: v2
ContentPackLoader schema:              v1
```

Owner-local snapshots currently preserve the authoritative/minimal lifecycle causes required by their implemented areas. Generated candidates and reconstructible projections are excluded.

A future full run-save boundary still needs to compose these owner snapshots into one deterministic save/load transaction without creating another authority store.

---

# Known correctness/support limitations

Still open:

```text
collision/overlap + grounded Wilson body consequences
generic reconsideration gating
drive hysteresis-band memory persistence
Wilson-relative route/escape evaluation
intervention causal windows
automatic habit-disuse/context producers
Presence causal-attribution production
full run-save composition across owner-local snapshots
full new-run bootstrap/reset
Legacy-to-new-Wilson seeding policy
```

Drive-specific known issues remain:

1. the application orchestrator still performs decision routing every simulation tick; generic reconsideration gating is not yet implemented;
2. drive persistence stores numeric values but not hysteresis-band memory, so deadband state can reconstruct differently after save/load.

---

# Remaining major verticals

Recommended sequence from the validated 39-test checkpoint:

```text
1. fine spatial/nav/occlusion + Godot presentation adapters
2. deterministic playable scenario/bootstrap tooling
3. representative multi-system scenario suites + seed-population tests
```

Cross-cutting correctness slices above should be pulled forward whenever a representative scenario requires them.

Food/fire/cooking/freshness-specific breadth should continue to use generic World/property/process boundaries where sufficient and add new primitives only when representative behavior proves them necessary.

---

# Admission rule

A runtime capability is marked PASS here only after the corresponding strict local Godot gate has been reported successful.

Do not record inferred test counts, unexecuted smoke results or architectural intent as validated runtime behavior.
