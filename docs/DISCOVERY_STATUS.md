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
RESULT: 48 PASS / 48 TOTAL
PASS headless_suite (48 tests)
```

The strict suite includes the real-engine `tests/scenes/spatial_navigation_perception/spatial_navigation_perception.tscn` fixture. Its validated coverage now includes ordinary movement/perception plus defensive motion redirection.

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
→ authored physical-observation admission → authoritative semantic WorldEvent
→ admitted impact → World-owned WilsonBodyState mutation → SemanticChangeSet → injury/death WorldEvent
→ grounded Wilson death WorldEvent → RunLifecycleState ACTIVE→DEAD
→ committed defensive intention → deterministic escape selection → MotionPort cancellation/redirection → concrete Godot escape movement
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
Shallow non-Wilson actors                         PASS
Director opportunity lifecycle                    PASS
Player suggestions / bounded insistence           PASS
Physical player intervention boundary             PASS
Run lifecycle                                     PASS
Resurrection transaction boundary                 PASS
Grounded Wilson death lifecycle propagation       PASS
PlayerProfile / cross-run Legacy admission        PASS
Owner-local persistence for implemented owners    PASS
Godot spatial / engine boundary                   PASS
Godot motion / navmesh integration                PASS
Passive spatial perception while MOVING           PASS
Real LOS / occlusion integration                  PASS
Physical observation semantic admission           PASS
Grounded Wilson body impact consequences          PASS
Generic reconsideration gate / trigger coalescing PASS
Strict headless suite                             PASS — 48 tests
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
!= Wilson desirability
!= player-private intent
!= Director intent
!= cross-run profile state
!= presentation
```

`WilsonBodyState` owns minimal physical body truth for Wilson: clamped `vitality ∈ [0,1]` plus `alive`. Authored impact consequences mutate that state before body `SemanticChangeSet` and injury/death semantics are emitted. Repeated damage while dead is rejected, so the `alive → dead` edge occurs once.

`RunLifecycleState` does **not** replace Wilson body truth. `GroundedDeathLifecycleCoordinator` admits only an already-committed authored Wilson death event into lifecycle, preserving `World body death → WorldEvent → lifecycle DEAD`. Resurrection remains the inverse transaction: physical truth must be restored before lifecycle may return to `ACTIVE`.

`PlayerProfile` remains outside active-run state. Cross-run admission is allow-listed through `RunProfileProjection`; Wilson episodes, habits, associations, Presence state and autobiographical causal history are not copied wholesale across runs.

---

# Runtime decision and motion boundaries

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

`ReconsiderationGate` coalesces semantic triggers and permits `NONE` as the normal steady state. Ordinary perception/learning therefore does not imply broad reconsideration.

Accessible evidence matching an authored `ThreatInterpretationRule` derives `ReconsiderationGate.Trigger.THREAT` through `PerceivedThreatService`. The same interpreted threat feeds `ImmediateThreatCandidateSource`.

PR #29 closes the next boundary after cognition selection:

```text
threat evidence
→ PerceivedThreat
→ THREAT trigger
→ immediate-threat candidate routing
→ committed defensive CurrentIntention
→ DefensiveMotionExecutionCoordinator
→ EscapeDestinationResolver
→ cancel prior MotionPort move
→ request escape move
→ GodotMotionAdapter
```

`EscapeDestinationResolver` uses authored `RuntimeWorldRef` candidates and `SpatialQueryPort`, not scene-node names. It requires route availability and a minimum increase in distance from the threat. Among valid candidates it deterministically prefers:

1. greater threat distance;
2. lower route cost;
3. stable reference key.

The executor resolves a destination **before** cancelling the current move, so an unavailable escape route does not destroy valid ongoing movement. Non-defensive intentions are ignored by this boundary.

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
EscapeDestinationResolver
DefensiveMotionExecutionCoordinator
PhysicalObservation / PhysicalObservationPort
PhysicalObservationConsequenceRule
PhysicalObservationConsequenceResolver
PhysicalConsequenceResolution
PhysicalConsequenceWorldAdvanceDecorator
WilsonBodyImpactRule
WilsonBodyImpactConsequenceResolver
GodotSceneSpatialRegistry
GodotSpatialQueryAdapter
GodotMotionAdapter
GodotPassiveSpatialSensor
PassiveSpatialPerceptionSource
GodotPhysicalObservationBuffer
GodotSimulationHost
```

Validated engine/domain semantics:

- render/physics cadence does not define semantic cognition cadence;
- stable `RuntimeWorldRef` identity maps explicitly to live scene references;
- navigation origin may remain at actor feet/navmesh plane while a separate spatial reference represents metric/LOS height;
- metric distance, route availability/cost, LOS and interaction reachability remain behind `SpatialQueryPort`;
- `GodotMotionAdapter` drives `CharacterBody3D` through real `NavigationAgent3D` paths;
- real NavigationServer routing detours around obstacles and reports semantic motion status;
- real raycasts distinguish clear and occluded LOS while excluding the observer collision root;
- passive broadphase uses overlap events as a fast path plus bounded direct-shape reconciliation;
- active candidates are revalidated while Wilson moves because range/LOS can change without membership edges;
- unchanged positive passive access does not emit duplicate evidence every refresh;
- passive evidence can occur while `MOVING` without forcing broad cognition;
- authored threat evidence can wake immediate-threat routing while `MOVING` without an external pre-injected `THREAT` trigger;
- a committed defensive intention can now change the live navigation target and physically redirect Wilson toward an authored escape point;
- collision/overlap/grounding/fall observations remain engine facts until an authored semantic consequence admits them;
- queued physical observations drain only at an explicit semantic boundary;
- admitted impacts mutate World-owned body truth before semantic injury/death events;
- fine transforms, navigation paths, passive candidate sets and physics observations remain non-persisted infrastructure facts.

`SimulationCadenceClock` remains a physics→semantic bridge primitive. Its current ~`0.1 s` default is **not** a universal update rate for perception, cognition, drives, environment, projects, Director or maintenance.

The passive sensor's moving/static refresh rates remain calibration defaults rather than domain-time contracts.

---

# Run lifecycle / profile baseline

Implemented runtime:

```text
WilsonBodyState
RunLifecycleState
GroundedDeathLifecycleCoordinator
ResurrectionService
RunProfileProjection
EndRunService
PlayerProfile
RunProfileSnapshotService
```

Lifecycle/body relationship:

```text
WilsonBodyState alive
→ lethal admitted body consequence
→ WilsonBodyState dead
→ authored wilson_died WorldEvent
→ GroundedDeathLifecycleCoordinator
→ RunLifecycleState DEAD

RunLifecycleState DEAD
→ ACTIVE via admitted resurrection transaction

ACTIVE or DEAD
→ ENDED via EndRun
```

Validated semantics include one-shot death admission, idempotent duplicate grounded-death handling, physical restoration before lifecycle revival, and explicit cross-run profile admission.

Still intentionally absent are detailed injury anatomy, bleeding/infection/healing, resurrection presentation, full new-run bootstrap, Diary narrative generation and offline catch-up.

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

Owner-local snapshots preserve authoritative/minimal causes for implemented owners. Generated candidates, live nav paths, passive candidate sets and reconstructible projections are excluded.

`WilsonBodyState` is not yet integrated into the save schema. Full run-save composition still needs to combine owner snapshots into one deterministic transaction without creating another authority store.

---

# Known correctness/support limitations

Still open:

```text
collision/grounding/fall-specific consequence policies beyond impact damage
semantic threshold/coalescing for gradual physical/environmental changes
owner/service due scheduling fully wired across drives/processes/maintenance
drive hysteresis-band memory persistence
richer Wilson-relative route/escape evaluation beyond deterministic objective safety
intervention causal windows
automatic habit-disuse/context producers
Presence causal-attribution production
Wilson body persistence/full run-save composition
full new-run bootstrap/reset
Legacy-to-new-Wilson seeding policy
orientation/view-cone passive refresh
negative/absence perceptual evidence on passive exit
```

Timing/decision-specific notes:

1. `SemanticDueScheduler` exists, but elapsed-time owners are not yet broadly wired through one due policy;
2. passive perception works during `MOVING`, but orientation/view-cone refresh and negative/absence evidence remain open;
3. authored perceived threats synthesize same-chain `THREAT`; other semantic trigger families still need representative producers rather than a generic “any perception changed” rule;
4. discrete physical observations can be threshold-admitted, but continuously changing physical/environment values still need semantic coalescing;
5. drive persistence stores values but not hysteresis-band memory;
6. body injury/death and lifecycle propagation are grounded, but body persistence/full save composition remain open;
7. immediate-threat motion execution is now concrete, but escape choice is still objective/configured rather than Wilson-relative learned route reasoning.

---

# Remaining major verticals

Recommended sequence from the validated 48-test checkpoint:

```text
1. semantic threshold/coalescing for gradual physical/environmental changes
2. owner/service due scheduling wired across gradual systems
3. deterministic playable scenario/bootstrap tooling
4. representative integrated timing/scenario suite
   - longer movement trace
   - Gerald ordinary perception
   - falling-palm threat wake-up
   - concrete escape execution
   - admitted impact/death branch where appropriate
5. Wilson body + full run-save/new-run composition
```

The open design review at `docs/design-reviews/2026-09-01-simulation-cadence-engine-domain-integration.md` is partially consumed through PR #29. Concrete motion interruption/redirection is now validated; the review remains OPEN for general due scheduling, gradual threshold/coalescing and the integrated 20 m / Gerald / falling-palm timing scenario.

Cross-cutting correctness slices should continue to be pulled forward only when a representative scenario requires them.

---

# Admission rule

A runtime capability is marked PASS here only after the corresponding strict local Godot gate has been reported successful.

Do not record inferred test counts, unexecuted smoke results or architectural intent as validated runtime behavior.
