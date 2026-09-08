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

## Presentation is non-authoritative but temporal readability may be semantic

Rendering assets, animation clips, blends, facial poses, particles and audio do not determine authoritative outcomes.

However, some player-visible behavior requires Wilson to remain in an authored semantic phase long enough for the action/reaction to be legible. Such duration/checkpoint/interruption semantics belong to gameplay orchestration or ActionExecution-like lifecycle state, not to a renderer callback.

Keep distinct:

```text
semantic meaning / duration / checkpoint / interruption
!= concrete animation clip / blend / asset
!= decorative presentation-only motion
```

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
C. invalidate affected derived state when World progression changed authority
D. advance active ActionExecution / admitted semantic expression execution
E. if commit crossed: World owner validates/applies ActionOutcome effects
F. consume SemanticChangeSet and invalidate/rebuild affected derived state
G. apply explicit grounded cross-owner consequences from accepted outcomes
H. progress already-committed current-intention execution when applicable
I. propagate committed lifecycle events
J. derive event-driven + passive spatial PerceptionResult
K. derive/apply immediate relevant learning from accessible evidence
L. advance due gradual cognition such as drives
M. derive/coalesce immediate-threat and other reconsideration triggers
N. route IMMEDIATE_THREAT / TACTICAL / INTENTIONAL / NONE
O. generate/evaluate/select only within an admitted routed regime
P. owner commits intentional transition when selection changes it
Q. optionally start/redirect execution for the newly committed intention
R. run due maintenance
S. emit presentation/debug projection
```

Critical invariants:

```text
commit before grounded consequence
World acceptance before cross-owner consequence
World mutation before derived invalidation consumers re-query
current committed intention may continue without broad reconsideration
perception after authoritative consequence
same-chain learning before next tactical choice when relevant
selection before intentional-state mutation
semantic expression timing may delay incompatible physical execution without changing past authority
presentation after domain meaning is established
```

The concrete implementation may split a conceptual phase into more than one recorded stage, but it must preserve these causal boundaries.

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
→ progress / anticipation
→ optional interruption before/after commit according to class
→ commit checkpoint emits ActionOutcome exactly once
→ remaining execution/recovery tail
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

An execution tail may exist partly to preserve meaningful physical/reaction readability after a commit. The duration is semantic only when starting an incompatible new physical behavior immediately would contradict the intended player-visible action lifecycle. Do not lengthen domain execution merely to match a particular clip frame-for-frame.

ActionExecution does not mutate World. At commit it produces `ActionOutcome`; the World owner separately validates/applies the supported effect batch.

Deterministic reconstruction must preserve whether an outcome was already emitted. A restored committed execution may continue its tail but must never emit the same committed outcome again.

---

# 6. World commit, derived maintenance and grounded cross-owner consequence

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

A World-accepted outcome may also ground an explicit consequence in another owner, for example a cognition drive or a project contribution. That consequence must be applied through an application-level service after the World acceptance result, not smuggled into World effects merely because it is causally downstream of the action.

Conceptual shape:

```text
ActionOutcome
→ WorldCommitResult.ok
→ explicit consequence policy
→ owning aggregate validates/applies its mutation
```

Cross-owner consequence services must be deterministic and idempotent where the same committed execution can be observed again after reconstruction.

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

# 12. Current-intention execution and newly selected action start

A committed intention may require continuous semantic execution progression even when no new reconsideration occurs. For example, a target-bearing intention may request movement, wait while `MOVING`, and only start its authored action after a matching semantic `ARRIVED` state.

Conceptual shape:

```text
current intention
→ execution coordinator progress
→ continue existing movement/action OR
→ admit grounded transition such as matching ARRIVED → ActionExecution start
```

After a newly selected intention/tactic is committed:

```text
derive concrete action/binding or movement target
→ authoritative attemptability/validation where relevant
→ start/redirect execution or emit explicit failure/reconsideration trigger
```

Execution coordinators do not own durable gameplay truth. They derive requests/transitions from the current intention and explicit ports/authoritative action state.

A newly selected intention does not imply that incompatible physical execution must start in the same instant. If Wilson is still inside a semantic action/reaction recovery or expression beat that is defined as occupying him, the next physical execution may remain pending until that phase completes or is validly interrupted. This is semantic scheduling, not renderer authority.

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

# 16. Presentation synchronization and semantic expression beats

Presentation consumes current semantic state plus ordered transient projections.

It may queue/collapse/interpolate visual events but cannot alter domain outcomes.

Animation timing may reflect semantic timing through adapters, but concrete animation completion is not authoritative proof of physical success, action commit, perception, learning or intention selection.

## 16.1 Two presentation classes

Distinguish ordinary decorative presentation from player-visible behavior that has semantic temporal meaning.

### Presentation-only motion

Examples:

```text
blink
breathing
small idle variation
cloth sway
ambient particles
pure cosmetic anticipation/recovery that does not constrain behavior
```

These are presentation-owned and never block or schedule authoritative gameplay.

### Semantic expression beat

Examples where representative behavior may require Wilson to occupy time:

```text
orient toward an unexpected object
surprise / confusion
hesitation before a risky attempt
recoil after impact
frustration after failed experiment
brief celebration
inspection / looking between subject and tool
recovery after a physical action
```

A semantic expression beat is admitted only when removing its temporal occupancy would make behavior materially different or player-visible causality unreadable.

Do not create a durable `EmotionAnimationStore` or generic cinematic timeline merely because presentation needs timing. Prefer existing action/execution semantics or the smallest deterministic transient execution primitive proven necessary by representative scenes.

## 16.2 Direction of authority

Preferred direction:

```text
semantic event/action/reaction
→ authored semantic phase/duration/checkpoint/interruption policy
→ presentation projection
→ animation / pose / gaze / facial / audio adapter
```

Forbidden dependency:

```text
AnimationPlayer.animation_finished
→ decides whether World effect happened
→ decides what Wilson perceived/learned
→ becomes the only way semantic execution can complete
```

The domain/application layer may know that Wilson is still in an authored semantic phase. It must not depend on a particular clip name, frame count, skeleton or renderer callback.

## 16.3 Commit and visual tail

An action may commit before its player-visible execution is finished:

```text
anticipation
→ commit
→ authoritative consequence
→ recovery / readable tail
→ semantic completion
```

The tail cannot rewind the committed consequence. It may prevent an incompatible new physical action from visibly starting until completion if that occupancy is part of the authored action semantics.

If the tail is purely cosmetic, it must not block gameplay.

## 16.4 Reaction ordering

A perceived event may produce both cognition and an embodied reaction.

Conceptually:

```text
World consequence
→ accessible perception
→ learning / reconsideration as applicable
→ admitted semantic reaction beat when needed for readability
→ next physical execution starts when compatible
```

The next intention may be known before the expression beat ends, but do not introduce separate pre-planning/execution queues unless representative behavior proves that distinction necessary. The simplest valid implementation may treat Wilson as occupied by the beat.

Immediate threat may interrupt an ordinary reaction beat when its explicit interruption semantics allow it.

## 16.5 Determinism, time scale and fallback

Semantic action/reaction ordering must remain equivalent under supported observation speed/time-scale changes.

A missing, replaced or shorter animation asset must degrade presentation rather than change authoritative gameplay or deadlock the run.

Headless simulation must be able to advance the same semantic lifecycle without an animation system present.

Useful regressions include:

```text
same semantic action commits/completes deterministically without presentation
post-commit recovery blocks incompatible physical execution only when authored semantic occupancy requires it
important reaction beat completes without animation callbacks
immediate threat can interrupt an admitted ordinary beat when allowed
1x / accelerated observation preserves semantic ordering
missing animation does not freeze semantic completion
```

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

If a semantic expression beat becomes reconstructibly necessary for mid-beat save/load correctness, persist only the minimal semantic lifecycle cause required by its admitted contract. Never persist a concrete animation playback position as authoritative gameplay state.

---

# 19. Offline catch-up

Offline uses the same semantic domain under conservative coarse policy.

It may advance ordinary environment/drives/projects/learning where justified but suppresses forbidden classes such as death, rare spectacle consumption and opaque extreme relationship changes.

Offline is not a second simulation architecture.

Presentation-only timing is absent offline. A semantic action/reaction phase that is genuinely part of authoritative causal time may be coarsely advanced according to its semantic lifecycle, not by simulating animation frames.

---

# 20. Trace requirements

Important semantic boundaries remain explainable:

```text
simulation step
→ authoritative progression
→ action commit/outcome
→ World commit/change set/event
→ grounded cross-owner consequences
→ current-intention execution progression
→ perception access/observation
→ learning proposals/mutations
→ reconsideration trigger/regime
→ candidates/contributions
→ selection/intention transition
→ semantic action/reaction phase when it delays incompatible physical execution
```

Trace should make skipped due work and `NONE` reconsideration observable enough to diagnose cadence mistakes without turning those diagnostics into gameplay authority.

Trace is diagnostic evidence, not gameplay authority.

---

# 21. Fresh-run / deterministic fixture bootstrap ordering

Production fresh runs and representative development scenarios must converge on the same owner construction/runtime composition semantics used by normal restore rather than direct post-bootstrap store mutation.

Canonical shape:

```text
production new run ----------┐
real save -------------------┼→ shared owner/bootstrap + runtime composition → authoritative owners
valid deterministic fixture -┘                                               → rebuilt derived state
```

A fresh-run or fixture/debug definition may provide durable causes plus explicit deterministic seed/input metadata. It may intentionally place a run in an artificial but valid state such as:

```text
hungry_wilson_near_food
wilson_mid_shelter_project
storm_with_bad_roof
```

Those input definitions are not runtime authority and do not need to simulate all earlier gameplay that would normally lead there.

Admission order follows the same principles as save/load:

```text
load compatible authored content
→ parse/generate fresh-run or scenario input
→ validate IDs, bounds, owner invariants and causal lifecycle state
→ construct/restore owner state through the shared bootstrap services
→ compose reconstructible runtime services
→ rebuild indexes/projections/caches
→ execute post-bootstrap semantic assertions/queries
→ only then begin simulation or presentation
```

Forbidden shortcuts:

```text
set private owner fields after bootstrap to force a scene
serialize EffectivePhysicalProfile/HazardProjection/routes as scenario truth
skip action/process causal validation because the fixture is test-only
use Godot node transforms as authoritative fresh-run/fixture state
allow debug commands to write arbitrary stores directly
```

A development scenario launcher, production world-generation layer and future debug console are adapters around these same boundaries and normal commands. They do not constitute separate simulation architectures.

For scenario/generation validation, deterministic reproducibility must coexist with **intentional variability**. Run fixed seed populations and vary boundary conditions/data density so results are not accidentally correct for one handcrafted ordering or tiny dataset.
