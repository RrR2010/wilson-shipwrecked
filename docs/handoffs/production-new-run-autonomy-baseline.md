# Handoff — Production New Run and Autonomous Action Baseline

Status: **ACTIVE**

## Transition

This handoff transfers runtime work from the completed bootstrap/composition/autonomy phase into the next representative runtime vertical.

Validated transition point:

```text
structural runtime owners
→ shared bootstrap/restore composition
→ deterministic engine scenario harness
→ real Godot spatial/navigation/perception adapters
→ drive-backed autonomous intention selection
→ target motion
→ authored ActionExecution
→ World-accepted grounded outcome
→ drive consequence
→ production-facing fresh-run bootstrap
→ real Godot-hosted autonomous scenario from that fresh-run boundary
```

The next agent should treat those boundaries as established unless new representative evidence exposes a defect.

---

# Integrated baseline

`main` includes PR #47 squash merge:

```text
b4cedd29117c581cdf3e80b120618c589ab6cd2f
```

Latest strict local validation reported under Godot 4.7.1:

```text
RESULT: 79 PASS / 79 TOTAL
PASS headless_suite (79 tests)
```

`docs/DISCOVERY_STATUS.md` is authoritative for the concrete implementation checkpoint, schema versions, closed gates and open limitations. Do not copy its test count into canonical domain documents.

---

# Required reading

Start with:

```text
AGENTS.md
docs/README.md
docs/DISCOVERY_STATUS.md
this handoff
```

Then read only the canonical bundle required by the chosen vertical.

For runtime/bootstrap/orchestration work:

```text
docs/ARCHITECTURE.md
docs/SIMULATION_CONTRACTS.md
docs/SIMULATION_ORCHESTRATION.md
docs/MUTATION_AUTHORITY.md
docs/DOMAIN_MODEL.md
docs/DOMAIN_MICRO_LOOP.md
```

For engine-facing scenario work also inspect:

```text
docs/ENGINE_SCENARIO_TESTING.md
tests/support/engine_scenario/
tests/scenes/perception_learned_new_run_autonomy/
tests/headless/perception_learned_new_run_autonomy_scenario_test.gd
```

Source/tests win over historical handoffs for constructor signatures and implementation detail.

---

# Closed runtime decisions

## Authority separation

Keep distinct:

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

Application services coordinate owners but do not become durable authority stores.

Do not introduce `GameState`, `RuntimeState` or a similar universal owner merely to simplify composition.

## Common bootstrap/composition boundary

Fresh runs, deterministic fixtures and restore converge on the same owner construction/runtime composition seams.

Validated shape:

```text
deterministic scenario ─┐
production new run ─────┼→ SimulationBootstrapDefinition
simulation snapshot ────┘
                               ↓
                    SimulationOwnerBootstrapper
                               ↓
                    authoritative owner set
                               ↓
                    RunRuntimeComposer
                               ↓
                    reconstructible runtime
```

`NewRunDefinition` is bootstrap input metadata, not runtime authority.

`NewRunBootstrapService` additionally creates fresh current-run owners:

```text
RunLifecycleState(ACTIVE)
DirectorStateStore
PlayerRunState
```

`PlayerProfile` remains outside active current-run composition because it is cross-run state.

## Action causality

Preserve:

```text
committed intention
→ semantic movement
→ matching ARRIVED
→ authored ActionExecution starts
→ ActionExecution crosses commit
→ ActionOutcome
→ World validates/applies outcome
→ WorldEvent + SemanticChangeSet
→ explicit grounded cross-owner consequences
```

Godot motion/arrival does not directly mutate World or drives.

`ActionExecution` remains authoritative for execution progress/commit. A committed execution emits its outcome exactly once.

## Grounded drive consequence

A Wilson drive change is not a World `ActionEffect` merely because it follows a physical action.

Validated boundary:

```text
ActionOutcome
→ WorldCommitResult.ok
→ GroundedDriveConsequenceService
→ DriveState mutation
```

The service applies only after accepted World grounding and is idempotent by execution identity.

## Targeted action execution

`TargetedActionExecutionCoordinator` bridges a committed target-bearing intention into:

```text
motion request
→ wait for matching semantic ARRIVED target
→ deterministic authored action start
```

Execution identity derives from the intention selection step plus action id. This allows restore/reconstruction to recognize the same execution rather than starting a duplicate.

## Restore/idempotency

`ActionExecutionSnapshotService` persists the commit/outcome-emitted markers required to prevent duplicate outcomes.

A restored post-commit execution:

```text
remains committed
→ can finish its post-commit tail
→ never re-emits the committed outcome
```

A coordinator observing the same restored intention/arrival recognizes the existing deterministic execution id and does not start another action.

## Engine boundary

Stable `RuntimeWorldRef` identities are explicitly bound to Godot nodes through `GodotSceneSpatialRegistry`.

Godot node names, paths, transforms, colliders, navmesh RIDs and instance IDs are infrastructure facts, not domain identity.

`GodotSimulationHost` bridges engine physics cadence into semantic steps. Rendering/physics frame cadence does not become a universal cognition/system tick.

## Scenario harness

`EngineScenarioHarness` remains generic test support. It may own:

```text
semantic checkpoints
opaque probes
trace capture
bounded waits
assisted pause/continue
completion/failure
```

It must not own gameplay semantics or mutate domain owners to make a scenario pass.

---

# Representative validated autonomous slice

The current strongest engine-facing regression starts as a production-facing fresh run and reaches a grounded consequence:

```text
NewRunDefinition
→ NewRunBootstrapService
→ explicit Godot runtime-ref bindings
→ GodotSimulationHost
→ passive perception of food
→ durable relation belief
→ hunger becomes PRESSING
→ seek_food intention
→ Godot motion MOVING
→ matching ARRIVED
→ consume_food ActionExecution starts
→ ActionExecution commits
→ World accepts food_consumed
→ hunger decreases
```

Semantic scenario checkpoints:

```text
BOOTSTRAPPED
→ PERCEPTION_LEARNED
→ DRIVE_PRESSING
→ INTENTION_SELECTED
→ MOVING
→ ARRIVED
→ ACTION_STARTED
→ ACTION_COMMITTED
→ HUNGER_REDUCED
→ COMPLETE
```

The scene only observes checkpoints. It does not implement the causal transitions itself.

---

# Current implementation seams worth knowing

Application/bootstrap:

```text
SimulationBootstrapDefinition
SimulationOwnerBootstrapper
SimulationOwnerSet
DeterministicScenarioDefinition
DeterministicScenarioBootstrapService
NewRunDefinition
NewRunBootstrapService
NewRunBootstrapResult
```

Application/runtime:

```text
RunRuntimeComposer
RunRuntimeComposition
SimulationOrchestrator
CurrentIntentionExecutionCoordinator
DirectTargetMotionExecutionCoordinator
TargetedActionExecutionCoordinator
GroundedDriveConsequenceService
SemanticDueScheduler
DueElapsedGate
```

Infrastructure:

```text
RunRuntimeRestoreService
ActionExecutionSnapshotService
GodotSceneSpatialRegistry
GodotSpatialQueryAdapter
GodotMotionAdapter
GodotPassiveSpatialSensor
GodotSimulationHost
```

Inspect current source before depending on constructor signatures.

---

# Open work / candidate next verticals

The next agent should choose the smallest representative vertical that advances the product rather than mechanically implementing every item below.

## 1. Product-level new-run/world-generation input

This is the most direct continuation of the newly validated production fresh-run boundary.

Target:

```text
product run parameters
+ authored content
+ explicit gameplay seed
→ deterministic generation of durable run/world causes
→ NewRunDefinition
→ existing NewRunBootstrapService
```

The generation layer must stay upstream of authority. Do not let scene nodes/transforms become generated World truth.

Useful acceptance properties:

- identical product inputs + seed produce semantically equivalent bootstrap causes;
- different seeds produce bounded, valid variation;
- generated causes pass ordinary bootstrap/content validation;
- invalid generation fails explicitly rather than being repaired by hidden post-bootstrap mutation;
- generation does not introduce a new runtime owner.

## 2. Richer representative gameplay semantics

Good candidates already called out in `DISCOVERY_STATUS.md` include:

```text
richer Gerald behavior/relationships
physical accident authoring where representative scenes require it
Wilson-relative learned route/escape reasoning
orientation/view-cone passive perception
negative/absence perceptual evidence
Presence causal-attribution production
```

Prefer a scenario that forces several existing systems to cooperate and exposes one real missing primitive.

## 3. Persistence evolution under product pressure

Current full-run restore/rebootstrap and action execution reconstruction are already closed gates.

Remaining candidates include:

```text
snapshot v9 → v10 compatibility policy
drive hysteresis-band memory persistence
grouped capture/bootstrap request objects if schema breadth expands again
```

Do not refactor the long positional APIs solely for cosmetic reasons.

---

# Explicitly deferred work

## Generalized production scene-binding/host composer

Do **not** extract a universal engine composition root yet merely because the current scenario contains explicit scene bindings.

Only one production-facing engine scenario currently proves the shape. Extract a reusable composer after a second real use reveals stable repeated inputs/responsibilities.

The intended future abstraction, if evidence justifies it, should remain composition only:

```text
already-bootstrapped run
+ concrete scene binding inputs
→ registries/adapters/host wiring
```

It must not become gameplay authority.

## Universal frameworks

Do not introduce:

```text
universal event bus
generic EverythingGraph
new global RuntimeState/GameState
scene-specific domain APIs
unbounded utility priority hacks
LLM authority over gameplay truth
```

---

# Documentation audit at this transition

The runtime documentation was reviewed against the integrated PR #47 baseline while intentionally excluding art/modeling documents that are being changed independently.

Updated in the handoff-closing docs PR:

```text
README.md
AGENTS.md
docs/README.md
this handoff
```

`docs/DISCOVERY_STATUS.md` had already been updated by PR #47 to the current 79-test baseline and production fresh-run/autonomous-action capabilities.

The canonical language-neutral architecture/domain documents were checked for authority/semantic conflicts with the implementation. No new owner or domain-contract contradiction was found that requires redefining those contracts. Concrete class names, schema versions, exact test counts and implementation progress remain intentionally centralized in `DISCOVERY_STATUS.md` and source/tests rather than copied through every canonical document.

Historical handoffs remain historical evidence. `docs/README.md` now identifies this file as the active transition handoff so older handoffs are not mistaken for current sequencing.

---

# Git / multi-agent continuation

Follow `AGENTS.md`.

Normal continuation:

```text
latest origin/main
→ new short-lived task branch
→ implementation + coherent commits
→ focused validation
→ strict headless suite
→ PR targeting main
→ explicit operator authorization
→ squash merge
→ branch cleanup/prune
```

Do not reuse the merged runtime feature branches.

Concurrent agents should remain isolated in separate worktrees/branches. Avoid stacked PR dependencies; if a task depends on another unmerged task, merge the dependency first and start/synchronize from the resulting `main`.

A PR passing tests is not integrated until it is merged into `main`.

Merge authorization is per PR. Do not infer authorization from earlier merges.

---

# Validation protocol

For runtime/domain changes, the final strict gate remains:

```powershell
.\tests\run_headless_tests.ps1
```

When adding an engine-facing scenario, first run its focused headless wrapper and only then the full suite.

For cross-owner/action/persistence changes, add reconstruction/idempotency coverage when causal state can survive a load boundary.

Do not claim a new validated baseline or update `DISCOVERY_STATUS.md` until the operator has reported the strict local gate successful.

---

# Completion condition for this handoff

This handoff is consumed when a later runtime vertical establishes a new coherent transition point beyond the production fresh-run + grounded autonomous-action baseline.

At that point:

1. update `DISCOVERY_STATUS.md` with only actually validated capabilities;
2. update canonical docs only if a contract changed;
3. create the next stage-transition handoff if context transfer is useful;
4. update `docs/README.md` so only the new handoff is presented as active.