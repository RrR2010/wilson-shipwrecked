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
RESULT: 44 PASS / 44 TOTAL
PASS headless_suite (44 tests)
```

Manual real-engine validation also passed for `tests/scenes/spatial_navigation_perception/spatial_navigation_perception.tscn` with:

```text
PASS spatial_navigation_perception_scene
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
→ Godot/domain spatial-query, motion, physical-observation, and simulation-cadence boundary
→ trigger-gated cognition with NONE as a normal steady state
→ bounded passive spatial perception while MOVING
→ perceived-threat evidence → same-chain THREAT reconsideration trigger
→ real CharacterBody3D / NavigationAgent3D / navmesh / Area3D / raycast integration fixture
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
Perceived-threat same-chain wake-up               PASS
Shallow non-Wilson actors                         PASS
Director opportunity lifecycle                    PASS
Player suggestions / bounded insistence           PASS
Physical player intervention boundary             PASS
Run lifecycle                                     PASS
Resurrection transaction boundary                 PASS
PlayerProfile / cross-run Legacy admission        PASS
Owner-local persistence for implemented owners    PASS
Godot spatial / engine boundary                    PASS
Godot motion / navmesh integration                 PASS
Passive spatial perception while MOVING            PASS
Real LOS / occlusion integration                   PASS
Generic reconsideration gate / trigger coalescing PASS
Strict headless suite                              PASS — 44 tests
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

Routing remains separated by regime. `ReconsiderationGate` coalesces semantic triggers and permits `NONE` as the ordinary steady state so broad candidate competition is skipped when no meaningful trigger exists.

Accessible evidence that matches an authored `ThreatInterpretationRule` now derives `ReconsiderationGate.Trigger.THREAT` through the same `PerceivedThreatService` interpretation boundary used by `ImmediateThreatCandidateSource`. Ordinary perceptual evidence still derives no trigger, so perception/learning does not imply broad reconsideration.

Director and player suggestions participate in ordinary bounded competition and cannot force Wilson.

Physical intervention remains:

```text
permission + affordability
→ explicit World admission
→ successful World mutation
→ only then spend God Power
```

Player-private intent does not directly mutate Wilson psychology.

---

# Godot spatial / engine boundary

Implemented and locally validated:

```text
SimulationCadenceClock
SemanticDueScheduler
ReconsiderationGate
PerceivedThreatTriggerSource
SpatialQueryPort
MotionPort
PhysicalObservation / PhysicalObservationPort
GodotSceneSpatialRegistry
GodotSpatialQueryAdapter
GodotMotionAdapter
GodotPassiveSpatialSensor
PassiveSpatialPerceptionSource
GodotPhysicalObservationBuffer
GodotSimulationHost
```

Validated boundary semantics:

- render/physics frame partitioning does not define semantic simulation cadence;
- stable `RuntimeWorldRef` identity maps explicitly to live scene references rather than node-name inference;
- navigation origin may remain at the actor's feet/navmesh plane while a separate spatial query reference represents LOS/distance height;
- metric/spatial queries remain behind an application port rather than leaking Godot nodes into domain state;
- `CharacterBody3D` movement progresses through `GodotMotionAdapter` and real `NavigationAgent3D` path following;
- real NavigationServer routing detours around physical obstacles and produces semantic `MOVING → ARRIVED` status;
- real raycasts validate clear and wall-occluded LOS, excluding the observer's own collision root;
- passive broadphase uses Godot overlap events as a fast path plus bounded direct-shape reconciliation when overlap cache/signals are insufficient;
- active passive candidates are revalidated while Wilson moves because metric range/LOS can change without a membership edge;
- passive perceptual evidence is edge-driven: unchanged accessibility does not emit repeated evidence every refresh;
- passive evidence can be produced while motion remains `MOVING` and does not by itself force broad intentional reconsideration;
- authored immediate-threat evidence can wake the threat routing regime while motion is still `MOVING`, without a pre-injected external `THREAT` trigger;
- collision/overlap/grounding/fall observations remain typed engine facts and do not directly mutate World;
- queued physical observations drain at an explicit semantic boundary;
- fine transforms, navigation paths and physics observations remain non-persisted infrastructure facts.

The validated `SimulationCadenceClock` is only an engine-to-semantic bridge primitive. Its current `0.1 s` default is **not** a universal update rate for perception, cognition, drives, environment, projects, Director or maintenance.

The current passive sensor uses approximately 10 Hz bounded reconciliation while moving and a slower static fallback. These are calibration defaults, not domain-time contracts.

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

Owner-local snapshots currently preserve the authoritative/minimal lifecycle causes required by their implemented areas. Generated candidates, live navigation paths, passive candidate sets and reconstructible projections are excluded.

A future full run-save boundary still needs to compose these owner snapshots into one deterministic save/load transaction without creating another authority store.

---

# Known correctness/support limitations

Still open:

```text
physical observation → validated World consequence resolution
collision/overlap + grounded Wilson body consequences
semantic threshold/coalescing for gradual physical/environmental changes
owner/service due scheduling fully wired across drives/processes/maintenance
drive hysteresis-band memory persistence
Wilson-relative route/escape evaluation
intervention causal windows
automatic habit-disuse/context producers
Presence causal-attribution production
full run-save composition across owner-local snapshots
full new-run bootstrap/reset
Legacy-to-new-Wilson seeding policy
orientation/view-cone passive refresh
negative/absence perceptual evidence on passive exit
```

Timing/decision-specific known issues:

1. `SemanticDueScheduler` exists, but drives and other elapsed-time owners are not yet fully routed through one general due-scheduling policy;
2. passive spatial perception now works during `MOVING`, but orientation/view-cone refresh and negative/absence evidence remain open;
3. authored perceived threats now synthesize the same-chain `THREAT` reconsideration trigger; other semantic trigger families still need representative producers rather than a generic "any perception changed" rule;
4. the Godot/domain event boundary still needs explicit threshold/coalescing policy for continuously changing physical/environment values;
5. drive persistence stores numeric values but not hysteresis-band memory, so deadband state can reconstruct differently after save/load;
6. physical observation callbacks still need an authoritative World consequence resolver and richer accident integration coverage;
7. the immediate-threat slice commits a defensive intention but does not yet cancel/redirect concrete Godot motion or execute an escape route.

---

# Remaining major verticals

Recommended sequence from the validated 44-test checkpoint:

```text
1. physical observations → authoritative World/body consequences
   - grounding/fall/collision consequence admission
   - semantic threshold/coalescing
2. representative immediate-threat interruption scenario
   - physical hazard observation/consequence
   - perceived threat wake-up (now available)
   - concrete motion cancellation/redirection/escape
3. deterministic playable scenario/bootstrap tooling
4. representative multi-system timing/scenario suites
   - longer movement traces
   - accident / immediate-threat routing
   - seed-population tests
5. full run-save/new-run composition
```

The open design review at `docs/design-reviews/2026-09-01-simulation-cadence-engine-domain-integration.md` is now partially consumed by the validated motion/perception/trigger work from PRs #17, #18, #19 and #21. It remains OPEN only for the still-unimplemented due-scheduling, gradual-threshold and representative accident/timing items recorded there.

Cross-cutting correctness slices above should be pulled forward whenever a representative scenario requires them.

Food/fire/cooking/freshness-specific breadth should continue to use generic World/property/process boundaries where sufficient and add new primitives only when representative behavior proves them necessary.

---

# Admission rule

A runtime capability is marked PASS here only after the corresponding strict local Godot gate has been reported successful.

Do not record inferred test counts, unexecuted smoke results or architectural intent as validated runtime behavior.
