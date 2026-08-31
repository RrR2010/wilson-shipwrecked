# Simulation Orchestration and Update Phases

## Status and purpose

This document is the canonical orchestration-level contract for runtime ordering, semantic clocks, action progression/commit, perception/learning order, reconsideration, maintenance and offline substitutions.

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

Conceptual boundary:

```text
WorldEvent + current authoritative placement/context
→ PerceptionAccess
→ ObservedEvent / PerceptualEvidence
```

`EventDefinition` describes potentially perceptible roles/modalities. Runtime access decides what Wilson actually receives.

The current structural model uses coarse semantic `PlaceId` co-location; fine range/occlusion/nav perception can replace/refine the adapter behind the same contract.

Hidden event bindings/provenance must not reappear in Wilson evidence.

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

Equivalent triggers are coalesced/debounced. Trigger priority determines **when** to reconsider, not utility magnitude.

Routing result:

```text
IMMEDIATE_THREAT
TACTICAL
INTENTIONAL
NONE
```

### Immediate threat

Uses perceived threat/body consequences and a narrow defensive candidate space. Hidden `HazardProjection` is not a cognition input.

### Tactical

Asks how to continue/refine the current intention after new evidence/outcome.

### Intentional

Asks whether the broader objective remains preferable to other needs/projects/opportunities.

Do not run broad intentional competition after every ordinary tactic failure.

---

# 10. Candidate generation/evaluation/selection

Composable candidate sources may include drives, learned interactions, exploration, habits, projects, suspended interests, suggestions, Director opportunities and transient reaction.

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
→ restore World owners
→ rebuild relation indexes
→ restore Wilson durable cognition / intention
→ rebuild EpistemicGraphProjection
→ restore action execution causal state
→ leave physical/composition caches empty/reconstructible
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

Trace is diagnostic evidence, not gameplay authority.
