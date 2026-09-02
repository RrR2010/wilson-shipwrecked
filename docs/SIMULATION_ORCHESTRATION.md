# Simulation Orchestration and Update Phases

## Status and purpose

This document is the canonical orchestration-level contract for runtime ordering, semantic clocks, action progression/commit, perception/learning order, reconsideration, maintenance, reconstruction/bootstrap and offline substitutions.

It complements `ARCHITECTURE.md`, `SIMULATION_CONTRACTS.md`, `STATE_REQUIREMENTS.md`, `GUARDS_AND_CALIBRATION.md` and `DOMAIN_MICRO_LOOP.md`.

Concrete implementation/schema/test status belongs in `DISCOVERY_STATUS.md`.

The key rule is:

> Authoritative mutation and causal interpretation happen in explicit deterministic order; cognition does not continuously rescore at render-frame cadence.

---

# 1. Orchestration principles

## Rendering is not the simulation clock

The authoritative domain supports headless execution, variable render FPS, pause/resume, save/load, coarse offline catch-up and deterministic replay without changing decision meaning.

## Orchestrator owns ordering, not policy

The orchestrator decides **when** owners/services run. It does not decide physical validity, belief truth, project semantics, Director meaning or intervention cost.

## Mutation occurs at explicit boundaries

Preferred pattern:

```text
read bounded context
→ derive proposal/result
→ owning aggregate validates/applies mutation
→ downstream phases read updated truth
```

Do not use uncontrolled subscriber order for authoritative cross-owner mutation.

## Cognition is event/semantic-boundary driven

Wilson normally continues current intention/action. Broad reconsideration happens on meaningful boundaries, not every simulation tick.

## Learning follows grounded accessible evidence

No belief/habit/project update occurs because an action was merely intended/expected.

## Immediate threat is a separate regime

Emergency response narrows candidate space; it is not a huge utility contribution.

---

# 2. Clock categories

One monotonic authoritative simulation-time source orders gameplay state/events.

Useful semantic cadences:

### Physical/action progression

Relatively fine progression for active actions, movement/navigation semantics, dynamic hazards and commit boundaries.

### Slow simulation

Drives, ordinary environment/process drift, passive player progression and similar gradual state. Updates remain bounded/saturating and trigger cognition only on meaningful band/context transitions.

### Event-driven cognition

Runs when meaningful reconsideration triggers survive gating/coalescing.

### Event-driven learning

Runs after grounded Wilson-accessible observations/evidence and before a same-chain decision when the new evidence can change the next tactic.

### Maintenance

Memory consolidation, habit disuse, weak admitted decay, project/director aging/cooldowns and aggregate health metrics.

### Presentation

May run every rendered frame but consumes semantic snapshots/events and never determines authoritative success.

## Engine-to-semantic bridge is not a universal subsystem tick

A concrete Godot host may use a fixed bridge such as `SimulationCadenceClock(0.1)` to convert variable/fine engine progression into deterministic semantic boundaries. That bridge frequency does **not** define a universal frequency for perception, cognition, drives, projects, Director evaluation, environment drift or maintenance.

Prefer:

```text
one authoritative simulation time
+ deterministic semantic bridge
+ owner/service due scheduling
+ event/semantic-boundary triggers
+ sparse maintenance
```

Avoid independent subsystem clocks by default. Gradual owners/services may keep bounded due metadata or receive elapsed time only when the orchestrator determines they are due. Numeric frequencies remain calibration policy, not domain identity.

If nothing semantically relevant changed and no due work exists, a semantic boundary may legitimately perform little or no cognition work.

---

# 3. Canonical active semantic cycle

Not every phase performs work every iteration, but relative causal ordering is:

```text
A. advance authoritative time
B. advance due World/body/environment/dynamic processes
C. advance active ActionExecution
D. if commit crossed: World owner validates/applies ActionOutcome effects
E. consume SemanticChangeSet and invalidate/rebuild affected derived state
F. collect ordered authoritative WorldEvents/outcomes
G. derive perception access and PerceptionResult
H. derive/apply immediate relevant learning from accessible evidence
I. derive immediate threat + reconsideration triggers
J. route IMMEDIATE_THREAT / TACTICAL / INTENTIONAL / NONE
K. generate/evaluate/select within the routed regime
L. owner commits intentional transition when selection changes it
M. validate/start/continue next action when required
N. apply grounded project/director/player consequence processing in declared owner order
O. run due maintenance
P. emit presentation/debug projection
```

Critical invariants:

```text
commit before WorldEvent
World mutation before derived invalidation consumers re-query
perception after authoritative consequence
same-chain learning before next tactical choice when relevant
selection before intentional-state mutation
presentation after domain meaning is established
```

---

# 4. World/environment progression

Advance due non-Wilson authoritative state such as weather, fire, rot/growth, moving hazards, shallow actors and active physical processes.

Meaningful changes may produce `WorldEvent`s. Wilson does not automatically learn those facts.

Continuously changing physical/environmental values should normally cross semantic threshold/coalescing boundaries before producing event traffic. Prefer facts such as:

```text
wind_became_dangerous
object_started_sliding
possession_became_unsecured
```

rather than one event for every small numeric change. Thresholding/coalescing must preserve grounded causality and must not hide a transition needed by action validity, perception or immediate-threat handling.

Dynamic-process commitment does not imply a future collision/victim is already committed. Consequence resolution remains grounded at its actual boundary.

---

# 5. Action progression and commit

Action execution progresses before ordinary new intention selection.

Canonical action lifecycle:

```text
start after attemptability
→ progress
→ optional interruption before/after commit according to class
→ commit checkpoint emits ActionOutcome exactly once
→ remaining execution tail
→ completed or interrupted terminal state
→ explicit cleanup
```

Current coarse interruption classes:

```text
PRE_COMMIT_ONLY
NEVER
ANYTIME
```

- `PRE_COMMIT_ONLY` may terminate only before commit;
- `NEVER` rejects ordinary interruption;
- `ANYTIME` may terminate a post-commit tail, but cannot rewind the committed outcome.

If future behavior needs semantic safe checkpoints distinct from commit, add explicit checkpoint semantics rather than relying on frame timing.

ActionExecution does not mutate World. At commit it produces `ActionOutcome`; the World owner separately validates/applies the supported effect batch.

---

# 6. World commit and derived maintenance

The World command boundary validates the prospective ordered effect batch before mutation.

On successful commit:

```text
World authoritative state updated
→ SemanticChangeSet
→ WorldEvent
```

`SemanticChangeSet` drives reconstructible maintenance only.

Example:

```text
component binding_integrity changes
→ CompositionDependencyProjection finds host
→ invalidate host EffectivePhysicalProfile
```

This maintenance completes before downstream logic relies on affected derived physical queries.

---

# 7. Perception access and observation

Perception does not receive omniscient World state as cognition truth.

Conceptual event-driven boundary:

```text
WorldEvent + current authoritative placement/context
→ PerceptionAccess
→ ObservedEvent / PerceptualEvidence
```

`EventDefinition` describes potentially perceptible roles/modalities. Runtime access decides what Wilson actually receives.

The current structural model uses coarse semantic `PlaceId` co-location; fine range/occlusion/nav perception may replace/refine the adapter behind the same contract.

Hidden event bindings/provenance must not reappear in Wilson evidence.

## Event-driven and passive spatial perception coexist

Not every perceptual opportunity originates from a `WorldEvent`. Wilson may move into a useful viewing/hearing position relative to an already-existing object or actor. The engine/domain boundary therefore supports a bounded passive spatial refresh path alongside event-driven perception.

Conceptual shape:

```text
movement / orientation / local-membership change
→ bounded nearby perceptible query
→ modality + range + occlusion/access filtering
→ newly accessible subjects/evidence
→ optional reconsideration trigger
```

A passive refresh may be requested when, for example:

- Wilson moved far enough since the previous spatial sample;
- orientation/view/hearing context changed materially;
- local spatial membership changed;
- an explicit low-cost fallback refresh becomes due.

Perception must be able to use the **current engine-backed spatial state while motion is still `MOVING`**. It must not wait for `MotionStatus.ARRIVED`.

Passive refresh remains bounded: do not turn every physics frame into an omniscient world scan.

Perception itself does not imply broad reconsideration. Evidence may produce no decision trigger, a local/tactical reaction, an intentional reconsideration, or immediate-threat routing depending on semantic significance.

---

# 8. Learning order

For one grounded accessible evidence batch:

```text
PerceptionResult
→ derive owner-specific proposals
   ├─ BeliefEvidence
   ├─ AssociationImpact
   ├─ HabitEvidence
   ├─ EpisodeCandidate
   └─ PresenceEvidence
→ owners apply bounded mutations in declared deterministic order
→ revised cognition projection becomes available to same-chain decision
```

Where practical, proposals are derived from one evidence snapshot before mutations to avoid accidental processor-order dependence.

A later learning stage may legitimately depend on an earlier updated owner only when that dependency is explicit.

Repeated equivalent evidence uses saturation/diminishing updates; strong contradiction must remain able to revise beliefs.

---

# 9. Reconsideration triggers and routing

Typical triggers:

```text
THREAT
ACTION_INVALIDATION
ACTION/INTENTION_COMPLETION
STRONG_ANOMALY / PREDICTION_ERROR
MAJOR_EVENT_OR_OPPORTUNITY
PLAYER_SIGNAL
DRIVE_URGENCY_CHANGE
PROJECT_CHECKPOINT
CONTEXT_TRANSITION
PERIODIC_REVIEW
```

Triggers may enter the semantic step from already-known boundary facts (for example `SimulationStepContext.trigger_set`) or be derived during the same causal chain from newly admitted outcomes/perception. The orchestrator must combine them deterministically rather than treating the presence of a simulation step itself as a trigger.

Equivalent triggers are coalesced/debounced. Trigger priority determines **when** to reconsider, not utility magnitude.

Routing result:

```text
IMMEDIATE_THREAT
TACTICAL
INTENTIONAL
NONE
```

When no meaningful trigger survives gating, ordinary behavior continues and broad candidate competition is skipped. `NONE` is an expected steady-state routing result, not an error condition.

### Immediate threat

Uses perceived threat/body consequences and a narrow defensive candidate space. Hidden `HazardProjection` is not a cognition input.

A newly accessible immediate threat must be able to reach this regime at the next admissible semantic boundary without waiting for ordinary periodic review or motion arrival.

### Tactical

Asks how to continue/refine the current intention after new evidence/outcome.

### Intentional

Asks whether the broader objective remains preferable to other needs/projects/opportunities.

Do not run broad intentional competition after every ordinary tactic failure, every perceptual update, or every fixed semantic bridge step.

---

# 10. Candidate generation/evaluation/selection

Composable candidate sources may include drives, learned interactions, exploration, habits, projects, suspended interests, suggestions, Director opportunities and transient reaction.

Candidate generation should respect the routed reconsideration regime. Expensive or broad candidate sources need not run when routing is `NONE`, and narrow threat/tactical routing should not implicitly become a full intentional competition pass.

Equivalent semantic candidates should deduplicate and preserve multiple provenance reasons rather than become duplicate lottery tickets.

Evaluation contributions are finite/bounded and explainable, e.g. need pressure, project value, association, curiosity, habit, perceived risk, effort, information gain, continuity, suggestion influence and Director bias.

No evaluator mutates state.

Selection may use seeded deterministic randomness among plausible options. Stable semantic ordering precedes tie-break/random choice.

---

# 11. Intention transitions

Only the intentional-state owner mutates:

```text
current intention
bounded suspended intentions
completion/discard state
```

Transitions:

### Continue

Current objective remains valid/preferred.

### Suspend

Objective remains meaningful but a temporary stronger pressure/opportunity interrupts it; preserve only semantic resume context, not an arbitrary service call stack.

### Complete

Meaningful objective achieved/resolved.

### Discard

Objective permanently irrelevant/impossible/abandoned.

Suspended intentions remain bounded/selective.

---

# 12. Start/continue next action

After an intention/tactic is selected:

```text
derive concrete action/binding
→ authoritative attemptability/validation
→ start execution or emit explicit failure/reconsideration trigger
```

The orchestrator must not spin indefinitely inside one macrocycle trying candidate after candidate. Retry/reconsideration is bounded and traceable.

---

# 13. Projects

Project state advances only from grounded outcomes/world facts:

```text
ProjectOpportunity
→ candidate/intention
→ action
→ World commit
→ grounded outcome/facts
→ Project validates contribution
→ Project owner mutation
→ optional checkpoint trigger
```

Tiny internal progress deltas should not create constant reconsideration.

Physical structure state remains World-owned.

---

# 14. Player intervention ordering

## Physical/environmental intervention

```text
player request
→ validate permission/capability/cost
→ explicit player/World transaction policy
→ World authoritative mutation
→ WorldEvent
→ perception
→ Wilson attribution/reaction/learning only if accessible/inferable
```

If player resource consumption and World application can fail separately, atomic/refund behavior must be explicit.

## Suggestion

```text
SuggestionSignal
→ coalesced PLAYER_SIGNAL trigger
→ ordinary candidate competition
```

Suggestions cannot interrupt/rewind committed physical truth.

---

# 15. Director ordering

Director evaluates at explicit eligibility/cooldown boundaries, not every render frame.

```text
DirectorContext
→ DirectedEvent eligibility/lifecycle
→ temporary opportunity / bounded bias / admitted World setup
→ ordinary perception/candidate/action pipeline
```

Director does not command Wilson. Rare opportunities still respect action causality unless they produce an immediate perceived threat.

---

# 16. Presentation synchronization

Presentation consumes current semantic state plus ordered transient projections.

It may queue/collapse/interpolate visual events but cannot alter domain outcomes.

Animation timing may reflect/request semantic timing through adapters, but animation completion is not authoritative proof of physical success.

---

# 17. Maintenance

Maintenance is separated from immediate post-evidence learning.

Possible work:

```text
episode consolidation/retention
habit disuse weakening where admitted
belief weakening where admitted
association drift where admitted
project opportunity aging
director cooldown maintenance
simulation health metric aggregation
terminal action-execution pruning
```

Maintenance must remain bounded and must not force every run toward a target distribution.

---

# 18. Save/load reconstruction ordering

Persist owner causes/minimal action lifecycle state; rebuild derived indexes/projections/caches.

Restore order conceptually:

```text
load immutable compatible authored content
→ validate bootstrap input/schema
→ restore World owners
→ rebuild relation indexes
→ restore Wilson durable cognition / intention
→ rebuild EpistemicGraphProjection
→ restore projects / Director / PlayerRunState / RunLifecycleState / PlayerProfile as applicable
→ restore ActionExecution causal state
→ leave physical/composition/hazard/perception/routes caches empty/reconstructible
→ rebuild required derived projections
→ resume simulation
```

Restoring an already-started action does not rerun current attemptability against past history. A committed/completed execution never emits its outcome again after load.

---

# 19. Offline catch-up

Offline uses the same semantic domain under conservative coarse policy.

It may advance ordinary environment/drives/projects/learning where justified but suppresses forbidden classes such as death, rare spectacle consumption and opaque extreme relationship changes.

Offline is not a second simulation architecture.

---

# 20. Trace requirements

Important semantic boundaries remain explainable:

```text
simulation step
→ authoritative progression
→ action commit/outcome
→ World commit/change set/event
→ perception access/observation
→ learning proposals/mutations
→ reconsideration trigger/regime
→ candidates/contributions
→ selection/intention transition
```

Trace should make skipped due work and `NONE` reconsideration observable enough to diagnose cadence mistakes without turning those diagnostics into gameplay authority.

Trace is diagnostic evidence, not gameplay authority.

---

# 21. Deterministic fixture/debug bootstrap ordering

Representative development scenarios must use the same reconstruction semantics as normal runtime restore rather than direct post-bootstrap store mutation.

Canonical shape:

```text
real save -------------------┐
deterministic fixture -------┼→ common restore/bootstrap boundary → authoritative owners
named debug scenario --------┘                                → rebuild derived state
```

A fixture/debug scenario may provide a declarative snapshot of durable causes plus explicit deterministic seed state. It may intentionally place the run in an artificial but valid state such as:

```text
hungry_wilson_near_food
wilson_mid_shelter_project
storm_with_bad_roof
```

It must not need to simulate all earlier gameplay that would normally lead there.

Admission order follows the same principles as save/load:

```text
load compatible authored content
→ parse scenario/fixture input
→ validate IDs, bounds, owner invariants and causal lifecycle state
→ construct/restore owner state through the common bootstrap services
→ rebuild indexes/projections/caches
→ execute post-bootstrap semantic assertions/queries
→ only then begin simulation or presentation
```

Forbidden shortcuts:

```text
set private owner fields after bootstrap to force a scene
serialize EffectivePhysicalProfile/HazardProjection/routes as scenario truth
skip action/process causal validation because the fixture is test-only
use Godot node transforms as the authoritative fixture state
allow debug commands to write arbitrary stores directly
```

A development scenario launcher and future debug console are adapters over this same boundary and normal commands. They do not constitute a separate debug simulation architecture.

For scenario validation, deterministic reproducibility must coexist with **intentional variability**. Run fixed seed populations and vary boundary conditions/data density so results are not accidentally correct for one handcrafted ordering or tiny dataset.