# Simulation Orchestration and Update Phases

## Status and purpose

This document defines the runtime ordering, clock categories, reconsideration semantics, interruption rules, post-outcome processing, maintenance passes and offline substitutions that connect the contracts in `SIMULATION_CONTRACTS.md`.

It is the canonical orchestration-level companion to:

1. `BEHAVIORAL_MODEL.md` — functional behavior;
2. `STATE_REQUIREMENTS.md` — persistence/lifetime semantics;
3. `ARCHITECTURE.md` — responsibility boundaries;
4. `SIMULATION_CONTRACTS.md` — semantic cross-system contracts;
5. `GUARDS_AND_CALIBRATION.md` — bounded update and stability rules.

The design goal is:

> Keep authoritative mutation ordered and deterministic while allowing cognition, action, learning, projects and presentation to run at the cadence appropriate to their semantics rather than at render-frame frequency.

This document intentionally does **not** choose concrete frequencies, engine callbacks, thread models, ECS schedules, async frameworks, serialization schemas or Godot node APIs.

---

# 1. Orchestration principles

## 1.1 Rendering is not the simulation clock

Rendered frames may interpolate and present simulation state, but they do not define authoritative time progression.

The domain must support:

```text
headless simulation
variable render FPS
pause/resume
save/load
coarse offline catch-up
seeded deterministic replay
```

without changing the meaning of Wilson's decisions.

## 1.2 The orchestrator owns ordering, not domain policy

The orchestrator decides **when** an owner/service is invoked and in what deterministic order.

It does not decide:

- whether an action is physically valid;
- what Wilson believes;
- which association update is justified;
- how a project advances;
- what a player intervention costs;
- what a director scene means.

Those remain domain-owner responsibilities.

## 1.3 Mutation happens at explicit phase boundaries

Critical state mutation must not arise from uncontrolled subscriber order.

Preferred pattern:

```text
read phase context
→ derive proposals/results
→ owner applies mutation
→ next phase reads updated authoritative state
```

A broad event bus may mirror outcomes to presentation/analytics, but it must not determine authoritative cross-system mutation order.

## 1.4 Cognition is event-driven, not continuously rescored

Wilson normally continues the current intention/action.

Full reconsideration occurs on meaningful boundaries, not every simulation step.

## 1.5 Learning follows grounded evidence

Persistent Wilson-relative updates occur only after an observable/grounded event or outcome exists.

The simulation must never perform:

```text
expected action
→ preemptively update belief/habit/project as if success occurred
```

## 1.6 Immediate threat is a separate regime

Emergency response bypasses ordinary candidate breadth and hysteresis rules where necessary, but still uses authoritative action validation and learned/perceived risk information.

It is not represented as a huge utility contribution.

---

# 2. Clock and scheduling categories

The architecture requires semantic clock classes rather than one universal tick.

Concrete frequencies are intentionally deferred to implementation/calibration.

## 2.1 Authoritative simulation time

One monotonic domain time source orders authoritative events and state transitions.

Requirements:

- independent from render time;
- deterministic under replay;
- capable of fixed-step or equivalent deterministic stepping;
- supports coarse advancement under offline policy;
- provides stable ordering identity for events/outcomes/decisions.

This is the reference time for all other clock categories.

---

## 2.2 Physical/action progression cadence

Used for state requiring relatively fine temporal resolution:

```text
current action progress
movement/navigation domain progression
collision/consequence resolution
environmental hazards
immediate threat detection
action validity changes
```

Properties:

- relatively high frequency during active play;
- independent from render FPS;
- deterministic;
- may produce meaningful `WorldEvent`, `ActionProgress` or `ActionOutcome` records.

This cadence does **not** imply cognition reevaluation at every step.

---

## 2.3 Slow simulation cadence

Used for gradual state:

```text
hunger
energy
comfort
stimulation
passive God Power progression
ordinary weather/environment drift
growth/rot/ecology where supported
```

Properties:

- lower frequency or analytically integrated over elapsed time;
- saturating bounded updates;
- may emit `ReconsiderationTrigger` only when meaningful bands/context change, not every small numerical delta.

---

## 2.4 Event-driven cognition cadence

Runs when one or more reconsideration triggers survive coalescing/gating.

Typical inputs:

```text
intention completion
action invalidation
drive urgency transition
major novelty/anomaly
prediction error
player suggestion
noticed intervention
directed opportunity
project checkpoint
important context transition
immediate threat
```

Cognition is therefore logically scheduled by meaningful changes rather than a fixed decision Hz.

---

## 2.5 Event-driven learning cadence

Runs after grounded Wilson-accessible outcomes/events.

Typical sources:

```text
ActionOutcome
ObservedEvent
InterventionObservation
project/world consequence observed by Wilson
```

Learning may process several related evidence items as one semantic batch when they belong to the same outcome chain.

---

## 2.6 Maintenance cadence

Used for slow consolidation/decay/eligibility concerns that do not require immediate visible reaction:

```text
episode consolidation/retention
weak association drift
habit weakening/disuse
belief weakening where admitted
project opportunity aging
director cooldown/eligibility maintenance
bounded health metrics aggregation
```

Maintenance should not manufacture major narrative events merely because time passed.

---

## 2.7 Presentation cadence

Presentation may run every rendered frame, but it consumes domain snapshots/events and interpolates between them.

Presentation may not create authoritative outcomes from missed/interpolated frames.

---

# 3. Active-play orchestration macrocycle

A deterministic active-play cycle conceptually follows this ordering:

```text
A. Advance authoritative time
B. Advance world/environment
C. Advance slow state due in this interval
D. Advance current action
E. Collect authoritative outcomes/events
F. Detect immediate threats
G. Build/coalesce reconsideration triggers
H. Run required reconsideration regime
I. Start/continue/validate next action step
J. Process grounded outcome/observation learning
K. Apply project/presence/other owner-local persistent updates
L. Emit presentation/debug projections
M. Run due maintenance work
```

Not every phase performs work every cycle.

The critical requirement is deterministic **relative ordering**, not universal invocation.

---

# 4. Phase A — Advance authoritative time

## Purpose

Advance the domain clock by the current simulation interval.

## Rules

- time advancement occurs before time-dependent systems for that interval;
- the interval identity/order is stable for deterministic replay;
- render interpolation does not modify this time;
- offline stepping uses the same semantic time axis through a different policy/cadence.

## Outputs

A phase context containing elapsed authoritative time and deterministic step identity.

No Wilson/world domain mutation beyond time itself occurs here.

---

# 5. Phase B — Advance world and environment

## Purpose

Apply due non-Wilson authoritative environmental progression.

Examples:

```text
weather evolution
fire decay
rot/growth
moving hazards
animal/environment movement where domain-owned
active director-instantiated world opportunity progression
```

## Rules

1. World Simulation mutates only world-owned state.
2. Resulting meaningful changes produce `WorldEvent`s.
3. Wilson does not automatically learn those facts.
4. Threat-relevant changes are available to immediate-threat detection after perception constraints are considered.
5. Director logic may instantiate valid opportunities, but it does not choose Wilson's response.

---

# 6. Phase C — Advance slow Wilson/player state

## Purpose

Advance gradual persistent state whose update is due.

Wilson examples:

```text
hunger
energy
comfort
stimulation
```

Player examples:

```text
passive God Power / non-intervention progression
```

## Rules

- each owner mutates only its own state;
- update curves are bounded/saturating;
- ordinary small changes do not trigger reconsideration individually;
- semantic urgency-band transitions or threshold-crossing events may produce one `ReconsiderationTrigger`;
- immediate danger remains distinct from drive urgency.

## Urgency-band principle

Implementation may later choose exact bands/formulas, but the orchestration contract requires hysteretic transitions such as conceptually:

```text
comfortable
meaningful
urgent
extreme
```

A value hovering near a boundary must not generate repeated trigger spam.

---

# 7. Phase D — Advance current action

## Purpose

Progress Wilson's already-selected action step before considering ordinary new intentions.

This preserves continuity and prevents every physical micro-step from becoming a new decision.

## Inputs

- current `SelectedIntention`;
- active `ActionStep` if one exists;
- authoritative world state;
- elapsed action-progress time.

## Outputs

Potentially:

```text
ActionProgress
ActionOutcome
WorldEvent
ReconsiderationTrigger(action invalidated/completed/checkpoint)
```

## Rules

1. Action Resolution validates authoritative preconditions when required.
2. Continuous actions may advance through multiple physical steps without cognition.
3. Physical intermediate effects are written to world state when they genuinely exist.
4. If action completion produces a grounded outcome, it is collected before learning/reconsideration decisions that depend on it.
5. Action invalidation does not silently change Wilson's intention; it creates a trigger and explicit outcome/validation result.

---

# 8. Phase E — Collect meaningful events and outcomes

## Purpose

Create an ordered semantic batch of things that happened during the interval and may matter to threat detection, perception, reconsideration, learning or presentation.

Possible items:

```text
WorldEvent
ActionOutcome
ActionProgress checkpoint
ValidatedIntervention result
TemporaryOpportunity appearance/expiry
SuggestionSignal
project/world checkpoint
```

## Rules

- preserve authoritative order;
- preserve causal/provenance references;
- do not yet conflate actual events with Wilson observation;
- semantically related low-level changes may be grouped for perception/debugging, but authoritative mutation history remains reconstructable.

---

# 9. Phase F — Immediate-threat detection and fast path

## 9.1 Threat detection

Immediate threat must be based on **Wilson-perceivable** danger or an authoritative bodily consequence already in progress, not omniscient world knowledge that Wilson could not react to.

Examples:

```text
falling palm entering Wilson's danger zone
a sudden fire spread Wilson can perceive
collapsing support
animal attack already perceptible
```

## 9.2 Fast-path regime

When an actionable immediate threat exists:

```text
PerceptionResult(threat-relevant subset)
→ narrow defensive CandidateIntention set
→ feasibility + learned threat expectation + risk response
→ rapid selection
→ action validation/execution
```

Ordinary candidates such as decorating, checking a project or following a suggestion are excluded from this regime unless directly relevant to survival.

## 9.3 Fast-path priorities

The regime must distinguish:

- unavoidable consequence already resolving;
- defensive action possible;
- multiple defensive alternatives;
- player intervention opportunity independent from Wilson's own response.

## 9.4 Exit

After the threat is resolved, escaped or no longer immediate:

- produce grounded outcomes;
- run reaction/learning as applicable;
- generate a normal reconsideration trigger;
- determine whether the pre-threat intention is resumed, suspended or discarded under normal interruption rules.

Emergency does not permanently erase ordinary intentional continuity by default.

---

# 10. Phase G — Reconsideration trigger collection and coalescing

## 10.1 Trigger classes

At minimum, orchestration recognizes:

```text
THREAT
INVALIDATION
COMPLETION
STRONG_ANOMALY
MAJOR_EVENT_OR_OPPORTUNITY
PLAYER_SIGNAL
DRIVE_URGENCY_CHANGE
PROJECT_CHECKPOINT
CONTEXT_TRANSITION
PERIODIC_REVIEW
```

Exact implementation names may differ.

## 10.2 Coalescing rule

Multiple triggers in the same interval should generally cause **one** reconsideration pass with all relevant reasons attached.

Example:

```text
action completes
+ hunger becomes urgent
+ rescue boat appears
```

should become one `DecisionContext` containing all three facts, not three sequential rescoring passes whose order accidentally determines behavior.

## 10.3 Priority classes

Trigger priority affects **when** reconsideration must occur, not candidate score magnitude.

Conceptual urgency:

```text
immediate threat      → fast path now
action invalidation   → reconsider before continuing invalid action
intention completion  → reconsider before selecting new objective
major anomaly/event   → reconsider at next safe interruption boundary unless explicitly urgent
drive/context change  → reconsider at normal boundary
periodic review       → lowest urgency
```

## 10.4 Debounce / hysteresis

Repeated equivalent triggers should coalesce while the underlying condition remains unchanged.

Examples:

- hunger remaining urgent does not fire every slow tick;
- a visible stationary novel object does not continuously trigger novelty;
- one unresolved anomaly remains part of context rather than causing infinite immediate replans;
- repeated identical suggestion presses are represented by bounded insistence semantics, not unlimited trigger multiplication.

---

# 11. Phase H — Normal reconsideration pipeline

When reconsideration is required and no immediate-threat fast path owns the decision, run one bounded normal cycle.

## 11.1 Perceive

Create `PerceptionResult`, `PerceivedSubject`s and relevant `ObservedEvent`s from current authoritative context.

Perception may include meaningful events that occurred since the last reconsideration if they remain observable/relevant.

## 11.2 Compute salience

Produce a small bounded salient set based on:

```text
proximity/visibility
current intention
need relevance
novelty
attachment
expected threat
prediction error
opportunity urgency
habitual cues
relevant memory
director framing
```

## 11.3 Derive expectations/anomalies

For salient subjects/candidate contexts derive Wilson-relative expected state/outcome and prediction error where applicable.

Expectations are derived from Wilson beliefs/history, not authoritative hidden truth.

## 11.4 Generate candidates

Composable sources propose `CandidateIntention`s.

Sources must support semantic deduplication.

Example:

```text
NeedIntentionSource: eat stored coconut
HabitIntentionSource: eat stored coconut
```

should normally become one candidate with multiple reasons, not duplicate lottery tickets.

## 11.5 Evaluate candidates

Each candidate receives bounded `EvaluationContribution`s.

Normal contributions may include:

```text
need pressure
project value
preference/association
curiosity
habit
perceived risk
effort
opportunity urgency
suggestion influence
continuity
transient emotion
director bias
```

No evaluator may directly mutate state.

## 11.6 Apply intention hysteresis

If the current intention remains valid and incomplete, it receives bounded continuity protection.

A new candidate must be meaningfully preferable to interrupt it.

Hysteresis must not override:

- immediate threat;
- authoritative action invalidation;
- completed intention;
- impossible continuation.

## 11.7 Select

Selection is probabilistic among plausible candidates where product behavior calls for variation, using seeded deterministic randomness.

Selection produces `SelectedIntention` plus diagnostic linkage to candidates/contributions.

## 11.8 Commit intentional transition

Only after selection does the Wilson intentional-state owner mutate:

```text
current intention
suspended intention(s)
completion/discard status
```

according to the interruption semantics below.

---

# 12. Action versus intention semantics

A central distinction:

```text
INTENTION = meaningful objective
ACTION STEP = concrete executable progress toward it
```

Examples:

```text
Intention: investigate mushroom
Action steps: approach → inspect → smell → taste tiny amount

Intention: continue roof stage
Action steps: fetch material → carry → place → fasten
```

An action step can complete while the intention continues.

An action step can fail while the intention remains meaningful and generates an alternative step.

An intention can be interrupted while the current action step must finish to a safe checkpoint.

---

# 13. Interruption classes

Concrete actions should declare semantic interruption behavior rather than using one global interruptible flag.

At minimum distinguish:

## 13.1 Immediate-safe interruption

Can stop with no problematic physical intermediate state.

Examples may include:

```text
walking/searching
looking/inspecting
idle/leisure observation
```

## 13.2 Checkpoint interruption

Should stop only at a safe semantic checkpoint.

Examples may include:

```text
placing/fastening a structure component
carrying out a multi-part manipulation
some food preparation steps
```

A major non-emergency reconsideration may mark the intention for interruption and wait until the checkpoint.

## 13.3 Committed atomic consequence

Once authoritative commitment occurs, the physical consequence resolves before ordinary reconsideration can change it.

Examples:

```text
released throw
committed jump/fall
impact already occurring
bite/taste already taken
```

This prevents causality-breaking player/AI timing where an action vanishes after commitment.

Immediate threat may still influence downstream response, but cannot rewind committed physics.

---

# 14. Intention continuation, suspension and discard

After interruption/reconsideration, the current intention transitions explicitly.

## 14.1 Continue

Use when the same intention wins again or no meaningful competing candidate exceeds hysteresis.

```text
current → current
```

## 14.2 Suspend

Use when:

- the intention remains meaningful;
- interruption is caused by another temporary higher-priority pressure/opportunity;
- resumption is plausible later;
- enough context exists to resume without inventing hidden planner state.

Canonical examples:

```text
Bottle curiosity interrupted by hunger
roof work interrupted by storm protection
experiment interrupted by sleep/energy pressure
```

Suspension should preserve semantic objective/context, not an arbitrary service call stack.

## 14.3 Complete

Use when the intention's meaningful objective is achieved or explicitly resolved.

Completion may produce a reconsideration trigger for the next objective.

## 14.4 Discard

Use when:

- target/objective permanently disappears or becomes irrelevant;
- project/opportunity expires with no meaningful residual goal;
- Wilson explicitly chooses to abandon after evidence/learning;
- the intention is superseded in a way that removes its semantic purpose.

Discard is stronger than interruption and should be explainable.

## 14.5 Suspended-intention bounds

Do not accumulate an unbounded backlog of every interrupted whim.

Suspended intentions should be limited to semantically meaningful unresolved interests/projects/goals justified by `STATE_REQUIREMENTS.md`.

Retention/aging may consider:

```text
importance
recency
attachment
project continuity
unresolved information value
opportunity validity
```

but must remain bounded.

---

# 15. Phase I — Start/continue next action step

After a `SelectedIntention` is committed:

1. derive the next concrete semantic `ActionStep`;
2. validate authoritative preconditions;
3. if invalid, produce `ActionValidationResult` and a reconsideration trigger;
4. if valid, begin/continue action progression;
5. physical resolution remains owned by Action Resolution/World Simulation.

The orchestrator must not loop indefinitely within one macrocycle trying candidate after candidate if execution repeatedly fails.

Use bounded retry/reconsideration semantics and diagnostic failure reasons.

---

# 16. Phase J — Grounded post-outcome processing

Post-outcome processing happens after an authoritative outcome/change exists.

Preferred order for one semantic outcome batch:

```text
1. project/world authoritative result already applied
2. determine Wilson observation
3. compare expectation / derive prediction error
4. causal attribution if relevant
5. derive ReactionIntent
6. derive LearningEvidence
7. derive owner-specific update proposals
8. owners apply bounded persistent mutations
9. emit resulting reconsideration trigger(s) for future decision cycle when needed
```

Reaction may be projected immediately while persistent learning applies in the same semantic outcome batch.

---

# 17. Learning mutation order

Learning processors derive proposals from the same grounded evidence snapshot before owner-local application where practical.

This avoids accidental order dependence such as:

```text
Belief update changes context
→ Association learner sees already-mutated belief
→ Habit learner sees already-mutated association
```

when all three were meant to interpret the same event.

Preferred pattern:

```text
LearningEvidence snapshot
├→ BeliefEvidence
├→ AssociationImpact
├→ HabitEvidence
├→ EpisodeCandidate
└→ PresenceEvidence

then owner-local mutations apply in declared deterministic order
```

If one learning effect legitimately depends on another updated state, that dependency must be explicit and documented rather than emerging from subscriber order.

---

# 18. Project progression timing

Project state advances only from grounded outcomes.

Required sequence:

```text
ProjectOpportunity
→ ProjectContribution candidate
→ SelectedIntention
→ ActionStep
→ ActionOutcome
→ Project System validates contribution against grounded result
→ ProjectProgressResult
→ project lifecycle/progress mutation
→ optional project-checkpoint ReconsiderationTrigger
```

Project checkpoint reconsideration should usually occur when:

- a stage completes;
- next required contribution materially changes;
- the project becomes blocked;
- the whole project completes;
- new visible world state changes the available alternatives.

Do not reconsider merely because a tiny internal progress scalar changed.

---

# 19. Player intervention ordering

## 19.1 Physical/environment intervention

```text
player input
→ validate permission/cost
→ mutate player-owned God Power/streak atomically with accepted request
→ ValidatedIntervention
→ apply authoritative world effect through world mutation path
→ WorldEvent
→ perception determines Wilson observation
→ anomaly/causal attribution if applicable
→ reaction + learning/presence evidence
```

If world application can fail after player-side validation, implementation must define atomic/refund semantics explicitly. Silent resource loss is not acceptable.

## 19.2 Suggestion

```text
player suggestion
→ SuggestionSignal
→ ReconsiderationTrigger(PLAYER_SIGNAL)
→ normal candidate/evaluation pipeline
```

Suggestions do not interrupt committed atomic physical consequences and do not force action validity.

---

# 20. Director ordering

The Event/Scene Director evaluates only at declared opportunity/cooldown boundaries, not continuously every render frame.

When it introduces content:

```text
DirectorContext
→ eligibility decision
→ TemporaryOpportunity / bounded SceneBias
→ world/perception/candidate pipeline
→ Wilson remains autonomous
```

Rare opportunity appearance may trigger reconsideration, but ordinary action interruption still respects action interruption class unless the opportunity itself is an immediate threat.

A rescue boat appearing does not magically cancel a physically committed throw or jump.

---

# 21. Presentation synchronization

Presentation consumes an ordered projection of domain changes.

## 21.1 Snapshot + event model

Presentation should be able to use both:

- current authoritative/domain snapshot for durable visible state;
- ordered `PresentationEvent`s/`ReactionIntent`s for transient expression.

This avoids depending on receiving every transient event to reconstruct basic world truth.

## 21.2 Multiple events in one simulation interval

If coarse stepping produces several authoritative events before a render frame, presentation receives deterministic ordering and may:

- queue semantic animations;
- collapse visually redundant updates;
- interpolate final state;
- surface only narratively relevant reactions.

Presentation choices may not change authoritative outcomes.

## 21.3 Animation timing

Animation may request/reflect action timing through an explicit semantic timing contract, but visual animation completion is not authoritative evidence that physics succeeded.

---

# 22. Maintenance and consolidation passes

Maintenance work is explicitly separated from immediate post-event learning.

## 22.1 Memory consolidation

May:

- retain meaningful episodes;
- compress repeated ordinary events into beliefs/associations/habits;
- remove low-value episodic detail;
- preserve source accessibility distinctions required by resurrection semantics.

Must remain bounded in storage growth.

## 22.2 Habit maintenance

May weaken disused habits gradually where admitted.

Must not erase a habit merely to hit target behavior distributions.

## 22.3 Association maintenance

May perform weak drift toward neutral/irrelevance where justified.

Contradictory lived evidence remains the primary reversal mechanism for strong associations.

## 22.4 Belief maintenance

Only weak/contextual beliefs should decay where behavior requires it.

High-confidence basic knowledge should not be periodically normalized downward.

## 22.5 Director/project maintenance

May update:

```text
cooldowns
eligibility windows
stale opportunities
project aging/salience metadata
```

without directly changing Wilson desire.

---

# 23. Offline catch-up policy

Offline simulation reuses normal domain ownership under a conservative scheduler/policy.

It is not a second behavioral model.

## 23.1 Offline macrostep

Conceptually:

```text
elapsed offline time
→ divide into bounded coarse intervals / analytical updates
→ advance allowed world state
→ advance drives/player passive state
→ advance ordinary safe actions/projects where policy permits
→ process ordinary grounded learning where represented
→ run maintenance/consolidation
→ produce structured catch-up history
```

## 23.2 Forbidden offline outcomes

Current requirements forbid or suppress at least:

```text
Wilson death
rare spectacle resolution without player presence
major discovery whose payoff should be witnessed
high-impact directed scene consumption
opaque extreme relationship swings
```

## 23.3 Offline action substitution

When exact high-frequency physical simulation is unnecessary, offline policy may replace an eligible safe routine with a grounded coarse outcome class.

Such substitution must still respect:

- authoritative world preconditions;
- resource availability;
- project rules;
- bounded learning;
- no impossible teleporting/inventory creation;
- deterministic seeded outcome where stochasticity remains.

## 23.4 Offline reconsideration

Offline cognition may be coarser and limited to ordinary safe candidate families.

It should not burn CPU simulating every fine-grained decision or consume rare narrative opportunities merely because a long time elapsed.

## 23.5 Return-to-active boundary

On resume:

1. complete catch-up mutations;
2. build a coherent final authoritative snapshot;
3. create summary/catch-up presentation data;
4. generate one normal reconsideration trigger if current context materially changed;
5. resume normal active-play cadence.

---

# 24. Save/load boundary

Saving may occur between macrocycles or at defined safe orchestration points.

If saving during an active action is supported, persist enough semantic state to resume coherently:

```text
current/suspended intention
active semantic action identity when required
authoritative physical intermediate state
remaining timing/progress only when not reconstructible
seed/RNG state required for deterministic continuation
```

Do not serialize arbitrary salience caches, candidate sets, evaluator objects or service internals.

After load, reconstruct derived contexts from canonical state.

---

# 25. Determinism and trace ordering

Every headless/replayable decision cycle should have stable identities sufficient to relate:

```text
simulation step/time
reconsideration trigger batch
perception result
candidate set
expectations
EvaluationContribution[]
selection RNG decision
SelectedIntention
ActionStep
ActionOutcome
ObservedEvent
LearningEvidence
owner-local updates
guard/saturation activations
```

Exact trace schema is deferred, but the orchestration must not destroy this causal chain.

When seeded randomness is used, consumption order must be deterministic. Optional presentation randomness must use a separate non-authoritative stream or otherwise be prevented from changing gameplay RNG consumption.

Optional LLM assistance must not be required for authoritative replay.

---

# 26. Failure containment rules

## 26.1 Invalid action loop

If an intention repeatedly produces invalid action steps, orchestration must escalate to reconsideration with diagnostic context rather than retry indefinitely.

## 26.2 No candidates

If normal candidate generation yields no meaningful executable candidate:

- preserve physical safety/idle baseline;
- allow bounded rest/observe/idle behavior;
- record a diagnostic health signal;
- do not invent impossible actions or invoke an LLM as authority.

## 26.3 Trigger storm

If many equivalent triggers occur, coalesce by semantic key/time window and expose a health/debug metric.

Do not solve trigger storms by dropping all event provenance.

## 26.4 Learning storm

Many repeated equivalent events should be batched/diminished under existing learning guards, preventing numeric runaway and unbounded memory creation.

---

# 27. Representative sequence checks

## 27.1 Scientific Method

```text
slow/world phases: no special trigger required
current intention: open coconut / investigate method
ActionStep: strike with unfamiliar stone
ActionOutcome: coconut remains closed; stone chips
ObservedEvent: Wilson sees both effects
trigger batch: action result + prediction error + unresolved goal
post-outcome learning: bounded belief evidence about stone/material response
normal reconsideration: revised expectation produces alternate experimental candidate
intentional continuity: experiment goal may continue while physical tactic changes
```

This requires learning to happen before the next reconsideration that depends on the new evidence.

Therefore, when an `ActionOutcome` completes an experimental step and immediately causes strategy refinement, ordering is:

```text
outcome
→ observe
→ learn relevant immediate belief evidence
→ reconsider unresolved intention
```

not reconsider first using stale beliefs.

## 27.2 Sabotaged Storage

```text
player intervention validated
→ world arrangement mutates
→ later Wilson enters/observes storage
→ perception detects expected-vs-observed arrangement mismatch
→ STRONG_ANOMALY trigger
→ reconsideration creates inspect/search/adapt candidates
→ causal attribution uses only Wilson-visible evidence/history
→ reaction + PresenceEvidence after interpretation
→ persistent presence_belief/trust updates by owner
→ future storage/project/habit candidates may change
```

The intervention itself does not trigger Wilson cognition if he could not perceive it when it happened.

## 27.3 Brilliant Shortcut

```text
normal reconsideration
→ known shortcut and safer route both become candidates
→ changed conditions alter perceived risk expectation
→ bounded risk/effort/habit/continuity contributions
→ seeded selection chooses shortcut
→ committed traversal action begins
→ weather/physical progression may create consequence
→ once jump/fall is physically committed, ordinary reconsideration cannot rewind it
→ injury/death outcome is authoritative, not RNG hidden behind cognition
→ reaction/learning/resurrection policy follows grounded result
```

If a perceivable immediate hazard appears before commitment, THREAT fast path may interrupt at the allowed action boundary.

---

# 28. Ordering invariants

The following rules are canonical:

1. authoritative world change precedes Wilson observation of that change;
2. observation precedes belief/presence learning from that observation;
3. grounded action outcome precedes project progress from that outcome;
4. action validation precedes physical execution;
5. committed physical consequence cannot be undone by late ordinary reconsideration;
6. immediate threat detection occurs before ordinary reconsideration when both are pending;
7. multiple normal triggers in one interval are coalesced into one decision context;
8. learning needed to interpret the next step of the **same just-completed outcome chain** applies before that reconsideration;
9. unrelated slow maintenance does not interleave inside one semantic outcome chain;
10. presentation observes domain order but never determines it;
11. owner-local persistent mutations are explicit and deterministic;
12. render FPS never changes simulation decision frequency or authoritative timing.

---

# 29. Implementation-neutral pseudoflow

```text
advance_time(dt)

advance_world_due(dt)
advance_slow_state_due(dt)

progress_current_action_due(dt)
collect_authoritative_events_and_outcomes()

project_observations_needed_for_threat_detection()
if immediate_threat_detected:
    run_threat_reconsideration_and_action()
    collect_new_outcomes()

process_immediate_outcome_learning_needed_for_same_chain()

triggers = collect_and_coalesce_normal_reconsideration_triggers()
if triggers.require_reconsideration:
    perception = perceive_current_context()
    salience = derive_salience(perception)
    expectations = derive_expectations(salience)
    candidates = generate_and_deduplicate_candidates(...)
    evaluations = evaluate_bounded_contributions(...)
    selected = select_with_hysteresis_and_seeded_rng(...)
    commit_intentional_transition(selected)

start_or_continue_next_action_step_when_due()
process_remaining_grounded_learning_batches()
apply_project_and_owner_local_persistent_results()
emit_presentation_and_debug_projection()
run_due_maintenance_outside_active_outcome_chain()
```

This is a semantic ordering sketch, not mandated implementation code.

---

# 30. Gate for Deliverable B

The orchestration specification is ready to feed the mutation-authority matrix when:

- each clock category is semantically distinct from render FPS;
- authoritative ordering is explicit;
- Wilson does not constantly replan;
- trigger coalescing/debounce/hysteresis are explicit;
- action-step interruption differs from intention interruption;
- committed physical consequences cannot be rewound by cognition;
- suspension/continue/complete/discard semantics are explicit;
- immediate threat has a separate fast path;
- learning follows grounded observation/outcome and can precede same-chain reconsideration where required;
- project progress occurs only from grounded action results;
- player private intent remains inaccessible to cognition;
- maintenance is separated from immediate learning;
- offline simulation reuses normal owners under conservative substitution policy;
- deterministic trace/RNG ordering can reconstruct behavior.

Next work:

1. produce the **mutation authority matrix** across state families and systems/pipelines;
2. run detailed phase/contract traces for `Scientific Method`, `Sabotaged Storage` and `Brilliant Shortcut`/`Falling Palm`;
3. perform the architecture gate for concrete data model/package layout/first implementation vertical slice.