# Engine Scenario Testing Methodology

## Purpose

This document defines a reusable methodology for developing and debugging Godot-facing scenarios when the implementation agent cannot interact with the live editor/debugger directly.

The methodology is intended for any future work involving:

```text
Godot physics
navigation
spatial queries
perception
scene bindings
engine/domain integration
runtime composition
playable/bootstrap scenarios
asset integration
```

It is not specific to one handoff or one representative scene.

The central operating model is:

> The agent builds a complete deterministic scenario; the local operator executes it; the scenario emits structured evidence that the agent can reason about without remote live-debug access.

---

# Core principles

## 1. Engine scenarios must be reproducible from Git

The implementation agent owns the complete fixture.

A scenario should normally be representable by committed files such as:

```text
scene.tscn
scenario.gd
headless wrapper/test
optional small scenario definition/data
```

Do not require the operator to manually move nodes, tweak inspector values or repair layers before a test can run.

The expected operator workflow should be as close as practical to:

```powershell
git checkout <branch>
git pull --ff-only
.\tests\run_headless_tests.ps1
```

For visual/assisted diagnosis:

```text
open the committed test scene
run current scene
advance semantic checkpoints when requested
copy structured output
```

---

## 2. Prefer primitive geometry for semantic/engine correctness

For gameplay and engine-boundary tests, use native Godot primitives by default.

Examples:

```text
CapsuleMesh / CapsuleShape3D
BoxMesh / BoxShape3D
CylinderMesh
SphereMesh
Plane/Quad primitives where useful
NavigationRegion3D
Area3D
Node3D anchors
```

Primitive fixtures reduce unrelated variables such as import transforms, pivots, artistic topology and asset-version changes.

Use production/imported assets only when the test question depends on asset-specific facts, such as:

```text
pivot/origin
import scale
skeleton/animation/root motion
production collider geometry
asset-authored sockets/anchors
visual occlusion from final geometry
```

A missing art asset must not block testing of domain/gameplay semantics.

---

## 3. Every substantial engine scenario should support automated and assisted modes

### Automated mode

Purpose: strict regression.

Properties:

```text
pause_at_checkpoints = false
operator input = none
deterministic assertions = required
PASS/FAIL = machine readable
strict runner compatible = required
```

This is the merge gate for runtime/engine behavior.

### Assisted mode

Purpose: diagnose a failure that cannot be explained by headless assertions alone.

Properties:

```text
pause_at_checkpoints = true
semantic checkpoint label visible
structured checkpoint state printed
single simple continue input
visual scene available
```

The recommended continue interaction is one stable input such as `Space`.

Automated and assisted modes should exercise the same scenario logic where practical. Do not maintain two behaviorally different test architectures.

---

# EngineScenarioHarness

The reusable harness is implemented under:

```text
tests/support/engine_scenario/
```

Its boundary is intentionally infrastructure-only. It supports:

```text
AUTOMATED / ASSISTED mode
semantic checkpoints
opaque probe dictionaries
structured trace/log records
optional JSONL console output
explicit assisted continue
completion/failure state
bounded waits
```

It does not interpret gameplay semantics and must not gain knowledge of Wilson, Gerald, threats, hunger, motion targets or particular intentions.

For an existing scene that already emits checkpoint and completion signals, prefer an adapter rather than embedding harness behavior into gameplay logic. `EngineScenarioSceneAdapter` translates the generic scene protocol:

```text
checkpoint_reached(name, details)
continue_requested()
smoke_finished(success, report)
```

into the harness contract.

The spatial/navigation/perception fixture is the reference consumer:

```text
Automated:
tests/headless/spatial_navigation_perception_harness_test.gd

Assisted:
tests/scenes/spatial_navigation_perception/spatial_navigation_perception_harness_assisted.tscn
```

Run the assisted reference scenario with:

```powershell
godot --path . tests/scenes/spatial_navigation_perception/spatial_navigation_perception_harness_assisted.tscn
```

At each semantic checkpoint, inspect the visible scene if useful and press `Space` once to continue. Both modes execute the same underlying `spatial_navigation_perception.gd` scenario logic.

---

# Semantic checkpoints

## Checkpoint names describe causal state, not frame numbers

Good checkpoint names:

```text
SCENE_READY
MOVE_REQUESTED
GERALD_PERCEIVED
THREAT_ADMITTED
DEFENSE_COMMITTED
MOTION_REDIRECTED
IMPACT_COMMITTED
RUN_DEAD
COMPLETE
```

Avoid checkpoint identities such as:

```text
FRAME_175
STEP_63
AFTER_WAIT_2
```

Frame/step/time may appear as diagnostic fields, but they are not the semantic identity of the checkpoint.

## Checkpoint contract

A checkpoint should expose:

```text
name
instruction for operator, when assisted
simulation time
semantic step id when relevant
physics frame when relevant
selected structured probes
```

A scenario should stop only at checkpoints useful for understanding causality. Too many pauses make assisted operation noisy and brittle.

---

# Structured probes

Engine scenarios should expose a small common vocabulary of probes rather than inventing arbitrary logging for every failure.

Not every checkpoint must emit every probe.

## Time probe

Useful fields:

```text
simulation_time
semantic_step
semantic_elapsed
physics_frame
```

Use authoritative simulation time for semantic reasoning. Physics frame is diagnostic only.

## Spatial probe

Useful fields:

```text
runtime_ref
world position
relevant target positions
metric distances
line-of-sight result
route availability
route cost
```

Transforms remain engine facts, not domain identity or authoritative semantic placement truth.

## Motion probe

Useful fields:

```text
actor_ref
MotionStatus
current motion target ref
navigation next point/path size when diagnostic
last request/cancel summary
```

## Perception probe

Useful fields:

```text
broadphase candidate count
accessible refs
emitted evidence identities
modality
revalidation diagnostics
```

Avoid dumping hidden World truth as though it were Wilson evidence.

## Cognition probe

Useful fields:

```text
reconsideration triggers
routing regime
candidate semantic ids
selected candidate/intention
current intention
intention bindings
```

## World probe

Useful fields:

```text
committed WorldEvent identities
SemanticChangeSet summary
relevant authoritative owner values
```

Do not use debug probes to mutate World.

## Scheduling probe

Useful fields:

```text
owner due keys
released elapsed by owner
next due time
```

This is especially useful when diagnosing accidental coupling to the semantic heartbeat.

## Physical observation probe

Useful fields:

```text
queued observation count
observation kinds in insertion order
drained observations
admitted consequence events
```

## Lifecycle/body probe

Useful fields:

```text
WilsonBody vitality/alive
RunLifecycleState
relevant death/resurrection count/cause
```

---

# Log format

Human-readable logs should be one-line and copy-friendly.

Recommended shape:

```text
[SCENARIO][MOTION_REDIRECTED] sim=6.100 step=semantic_061 frame=366 actor=wilson status=MOVING target=escape_west intention=dodge_threat threat=palm_01 distance=4.27
```

Rules:

- stable field names;
- stable semantic ids rather than display labels where possible;
- avoid enormous object dumps;
- include only the state needed to reconstruct the causal question;
- preserve ordering of emitted lines.

When an agent asks the operator for evidence, it should be able to request a bounded range such as:

> Copy the console from `GERALD_PERCEIVED` through `MOTION_REDIRECTED`.

That is preferable to asking the operator to inspect arbitrary debugger internals.

---

# Machine-readable trace

For representative scenarios, prefer producing an additional deterministic structured trace when practical.

A JSONL-style record is suitable:

```json
{"checkpoint":"MOTION_REDIRECTED","simulation_time":6.1,"physics_frame":366,"motion_status":"MOVING","motion_target":"escape_west","current_intention":"dodge_threat"}
```

Potential output location during local execution:

```text
user://scenario_trace.jsonl
```

The exact persistence mechanism is infrastructure, not gameplay authority.

Trace guidance:

- deterministic field ordering where practical;
- stable semantic ids;
- avoid engine object instance ids as durable comparison keys;
- include checkpoints and important transitions, not every render/physics frame;
- do not persist trace files as game state.

A future harness may expose the same trace in-memory to headless assertions and optionally write it for operator diagnosis.

---

# Evidence escalation order

When diagnosing engine behavior, use this escalation order:

```text
1. deterministic automatic assertion
2. structured trace
3. checkpoint probe state
4. bounded console excerpt
5. screenshot
```

Screenshots are a last-mile geometry/presentation diagnostic, not the primary semantic debugging format.

Good reasons for a screenshot:

```text
actor appears embedded in floor
collider and mesh appear offset
object is visually on unexpected side of obstacle
camera/frustum/visibility mismatch is suspected
navmesh visualization contradicts logged routing
production asset appears at wrong scale/pivot
```

Bad reasons for a screenshot:

```text
what was the current intention?
which WorldEvent committed?
what due owner ran?
which runtime ref was selected?
```

Those should be structured text.

---

# Three levels of engine-facing tests

## Level A — Adapter test

Scope: one engine/domain adapter or port implementation.

Examples:

```text
GodotMotionAdapter
GodotSpatialQueryAdapter
GodotPhysicalObservationBuffer
GodotSceneSpatialRegistry
```

Question:

> Does this adapter translate engine facts into the established semantic contract correctly?

Prefer focused deterministic fixtures.

## Level B — Engine fixture

Scope: small real Godot scene containing only enough geometry to prove an engine assumption.

Example:

```text
Wilson
wall
navigation target
perceptible
Area3D
navmesh
```

Questions:

```text
Does CharacterBody3D collide as expected?
Does NavigationServer return the route we assume?
Does real LOS distinguish clear/blocked geometry?
Does passive perception occur while MOVING?
```

This level validates Godot behavior that mocks cannot prove.

## Level C — Representative scenario

Scope: several already-validated systems composed into one meaningful player-visible causal trace.

Example:

```text
long movement
→ ordinary perception
→ due progression
→ threat evidence
→ immediate-threat cognition
→ concrete redirect
```

Question:

> Do the existing contracts compose into the intended experience without hidden coupling?

Representative scenarios should not become scripted gameplay implementations. They expose missing primitives; they do not justify scene-specific production APIs.

---

# Scenario construction rules

## Build the whole fixture in committed code/data

The agent should define:

```text
node hierarchy
primitive mesh sizes
collision shapes
collision layers/masks
positions
navigation geometry
stable RuntimeWorldRef bindings
anchors
scenario seed
semantic ids
```

The local operator must not be part of fixture construction.

## Use stable semantic refs

Never rely on node names or scene paths as domain identity.

Preferred shape:

```text
RuntimeWorldRef / DomainId
↔ explicit registry/adapter binding
↔ Node3D / collider / anchor
```

## Separate navigation origin from spatial-query anchors where needed

A character root may remain on the navigation plane while LOS/distance queries use a body-height spatial reference.

Do not distort domain truth merely to satisfy engine coordinate convenience.

## Determinism

Scenario-relevant randomness must be seeded.

Stable semantic ordering should precede seeded tie-breaking where applicable.

Do not assert gameplay semantics using wall-clock time.

---

# Operator script

Every assisted scenario should document a tiny operator procedure, preferably printed at startup or included next to the fixture.

Example:

```text
Expected checkpoints:
1. SCENE_READY
2. GERALD_PERCEIVED
3. THREAT_ADMITTED
4. MOTION_REDIRECTED
5. COMPLETE

If the scenario fails or stops unexpectedly:
- copy the checkpoint name shown;
- copy console output from the previous successful checkpoint onward;
- include the generated structured trace if requested;
- provide a screenshot only if the failure appears geometric/visual.
```

The operator should not need domain knowledge to collect useful evidence.

---

# Agent debugging protocol

When a local run fails, the implementation agent should proceed in this order.

## 1. Classify the failure

Examples:

```text
parse/compile
fixture construction
adapter binding
navigation
physics/collision
spatial query
perception
semantic orchestration
cognition
motion execution
assertion expectation
purely visual
```

## 2. Ask for the minimum additional evidence

Good request:

> Run assisted mode and send the structured output from `MOVE_REQUESTED` through `THREAT_ADMITTED`.

Poor request:

> Open the remote debugger and inspect everything related to Wilson.

## 3. Improve the fixture's observability when evidence is insufficient

If the agent repeatedly needs an internal value, add a stable probe/checkpoint rather than asking the operator to manually discover it every run.

## 4. Convert a diagnosed failure into an automated regression

A successful diagnosis is incomplete until the important behavior is machine asserted where practical.

Assisted checkpoints are diagnostic support, not a substitute for strict regression.

---

# Headless integration requirements

Every runtime-relevant engine scenario should have a headless wrapper/test when Godot permits it.

The repository strict gate is:

```powershell
.\tests\run_headless_tests.ps1
```

A headless wrapper should:

```text
load the committed scene
force assisted pauses off
run until semantic completion or a bounded frame limit
collect scenario failures
fail on timeout
print PASS only after complete successful execution
```

A timeout should be generous enough for deterministic engine startup/path synchronization, but bounded enough to detect stalls.

Do not turn a timeout into gameplay authority.

---

# Assertions versus diagnostics

Use assertions for contracts.

Examples:

```text
motion remains MOVING when ordinary evidence arrives
original target is preserved after non-triggering evidence
threat trigger occurs before original ARRIVED
redirect changes motion target to authored escape
route is valid
escape increases distance from threat
owner due progression occurs only at due boundaries
```

Use diagnostics for investigation.

Examples:

```text
current path point count
raw position each second
broadphase dirty flag
physics frame index
```

Do not make brittle regression assertions from incidental diagnostics unless they are promoted into real contracts.

---

# Avoid frame-perfect assertions

Prefer semantic ordering:

```text
GERALD_PERCEIVED before THREAT_ADMITTED
THREAT_ADMITTED before MOTION_REDIRECTED
MOTION_REDIRECTED before original ARRIVED
```

Avoid unnecessary expectations such as:

```text
Gerald must be perceived on exactly physics frame 241
```

Engine startup, path synchronization and harmless implementation changes may shift exact frames while preserving semantics.

Use fixed frame/time assertions only when the cadence itself is the contract under test.

---

# Failure observability standard

A useful scenario failure should answer as many of these as possible without live debugging:

```text
What semantic stage failed?
What was authoritative simulation time?
What was Wilson doing?
What relevant refs were involved?
What engine-backed facts were observed?
What semantic evidence/events existed?
Was cognition triggered?
What intention/target was selected?
What should have happened next?
```

If a failure merely reports `Expected true`, improve the assertion label and/or checkpoint evidence.

---

# Recommended reusable harness boundary

The reusable harness centralizes infrastructure such as:

```text
checkpoint(name, probes)
pause/resume assisted mode
structured logging
trace record collection
optional JSONL output
scenario completion/failure state
bounded wait helpers
```

Keep domain semantics outside the harness.

The harness must not know what `Gerald`, `palm`, `hunger` or a particular intention means.

Good harness vocabulary:

```text
checkpoint
probe
trace
failure
complete
bounded wait
assisted/automated mode
```

Bad harness vocabulary:

```text
trigger_palm_attack()
make_wilson_hungry()
force_dodge()
```

Scenario-specific actions belong in the scenario through normal application/domain contracts.

---

# What this methodology explicitly forbids

Do not normalize the agent/operator workflow around:

```text
manual scene edits by the operator
arbitrary debugger inspection as the primary protocol
screenshots for semantic state
fixture-only direct owner mutation
Godot transforms as authoritative domain state
debug-only event buses or simulation clocks
production code branches that exist only to make a scenario pass
frame-perfect assertions for non-frame-perfect semantics
unseeded gameplay randomness in regressions
```

---

# Completion standard for an engine-facing slice

Before an engine-facing implementation is considered complete, prefer evidence in this order:

```text
focused domain/application regression where relevant
+ focused adapter/engine fixture where Godot behavior matters
+ representative scenario when multiple systems interact
+ strict local runner PASS
+ assisted diagnostic path available for difficult engine failures
```

The exact number of layers depends on the change. Do not create a representative 3D scenario for a pure value-object change with no engine relevance.

The goal is not maximum test volume. The goal is to make engine behavior **deterministic, observable, reproducible and debuggable through an asynchronous agent/operator loop**.