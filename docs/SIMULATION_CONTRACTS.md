# Simulation Contract Catalog

## Status and purpose

This document defines the semantic contracts that connect the validated Wilson Shipwrecked systems before concrete data models, package layout or implementation technology are chosen.

It is the canonical contract-level companion to:

1. `BEHAVIORAL_MODEL.md` — behavioral meaning;
2. `STATE_REQUIREMENTS.md` — persistence/lifetime requirements;
3. `SCENE_VALIDATION.md` — behavioral evidence and regression scenes;
4. `ARCHITECTURE.md` — responsibility boundaries and authority;
5. `GUARDS_AND_CALIBRATION.md` — numerical and systemic guardrails.

The contracts here are **semantic boundaries**, not mandated classes, structs, ECS components, event-bus messages, database records or network packets.

The design goal is:

> Make every important cross-system handoff explicit enough that authority, observation, learning, replay and debugging remain unambiguous.

This document intentionally does **not** yet define concrete field types, IDs, serialization schemas, formulas, scheduler APIs, Godot nodes, package names or storage technology.

---

# 1. Contract design rules

## 1.1 Authority must remain explicit

A contract may describe authoritative truth, an observation, a proposal, a derived interpretation or a presentation request. Those categories must not be silently interchangeable.

Examples:

```text
WorldEvent           authoritative fact about what occurred
ObservedEvent        Wilson-accessible projection of an event
BeliefEvidence       proposal to Wilson's belief owner
PresentationEvent    projection for rendering/UI/narrative only
```

No observational or presentation contract may mutate authoritative world truth by itself.

## 1.2 Producers do not gain consumer authority

Producing `BeliefEvidence` does not allow the learning pipeline to edit the belief store directly unless orchestration explicitly delegates the mutation to the belief owner.

Likewise:

```text
ProjectContribution
```

may request/describe a valid contribution opportunity but does not make the project system authoritative over Wilson's intention or world physics.

## 1.3 Derived contracts are ephemeral by default

Contracts representing perception, salience, expectations, candidate evaluations, causal weights, reactions and presentation projections are normally recomputed and not persisted as independent truth.

If later implementation needs a debug log or replay trace, store the trace as diagnostic history, not as canonical domain state.

## 1.4 Contracts must preserve provenance

Where learning or interpretation depends on evidence quality, the contract must preserve enough provenance to distinguish at least:

```text
direct authoritative outcome
clear direct observation
partial/ambiguous observation
repeated observation
category inference
coincidence
player suggestion without confirmation
```

The exact representation is deferred.

## 1.5 Contracts must remain finite and guardable

Any contract carrying normalized state changes, confidence changes, evaluation contributions or update strengths must support declared finite bounds.

No contract may rely on:

```text
+Infinity
-Infinity
huge sentinel utilities
NaN as meaning
```

Immediate emergency is represented by a separate decision regime/trigger, not an extreme contribution.

## 1.6 Replay-relevant randomness must be attributable

When a semantic decision uses gameplay randomness, the resulting trace must be reproducible from seeded deterministic state.

Contracts do not need to persist raw RNG internals, but debug/replay infrastructure must be able to associate stochastic selection with a deterministic simulation step/decision context.

Optional LLM output is never required to replay authoritative physical truth.

---

# 2. Contract taxonomy

The catalog uses five broad semantic categories.

| Category | Meaning | Typical lifetime |
|---|---|---|
| **Fact/result** | Authoritative outcome or owned state transition result | Moment; durable consequence stored by owner |
| **Observation** | What Wilson or another observer could perceive | Moment/short |
| **Proposal/evidence** | Input requesting validation or owner-local mutation | Moment |
| **Derived decision value** | Recomputed cognition/evaluation output | One reconsideration cycle |
| **Projection** | Presentation/debug/narrative representation | Moment |

A single event may therefore appear through several contracts without duplication of authority:

```text
WorldEvent
→ ObservedEvent
→ LearningEvidence
→ owner-local state updates
→ ReactionIntent / PresentationEvent
```

---

# 3. World and perception contracts

## 3.1 WorldEvent

### Purpose

Represent an authoritative semantic world change or occurrence that may be relevant to perception, learning, director logic, analytics or presentation.

### Producer

Primarily:

- World Simulation;
- Action Resolution after validated physical resolution;
- Player Intervention when an intervention directly changes world truth;
- Event/Scene Director when it legitimately causes an authoritative world occurrence through normal world mutation paths.

### Consumers

- Perception;
- orchestration/event collection;
- debug/replay;
- presentation projection where appropriate;
- director context aggregation.

### Authority

**Authoritative fact/result.** It describes what actually happened, not what Wilson knows.

### Required semantics

Must be able to express:

- semantic event kind;
- involved authoritative entities/subjects;
- authoritative changed properties/state;
- authoritative causal provenance where known to the simulation;
- simulation time/order identity;
- observability-relevant physical facts such as location/range/intensity where needed.

### Optional semantics

May include:

- source action/outcome reference;
- environmental source;
- consequence severity classification;
- visibility/audibility/other sensory channels available for projection;
- diagnostic tags.

### Lifetime / persistence

Ephemeral as a transport contract. Durable world consequences belong in world state. Selected events may additionally become episodic history through the learning/memory pipeline.

### Replay implications

Order and causal origin must be deterministic for authoritative simulation replay.

### Example

`Sabotaged Storage`:

```text
container contents displaced
storage arrangement changed
```

The `WorldEvent` says the arrangement actually changed; it does not say Wilson noticed it or attributes it to the unseen presence.

---

## 3.2 ObservedEvent

### Purpose

Represent the Wilson-observable projection of an event/change.

This is the central boundary preserving:

```text
what actually happened
!=
what Wilson observed
!=
what Wilson later believes caused it
```

### Producer

Perception, from world truth/current context plus relevant `WorldEvent` input.

### Consumers

- Decision/Reconsideration Pipeline;
- Memory & Learning Pipeline;
- causal attribution;
- reaction derivation;
- presentation/debug explanation.

### Authority

**Observational, Wilson-relative.** Authoritative only as a record of what the perception pipeline determined Wilson had access to in that moment; not authoritative about world cause or Wilson belief.

### Required semantics

Must be able to express:

- observed subject(s);
- observed semantic change/effect;
- observation channel/context;
- degree/quality/completeness of observation;
- observed timing/order;
- relation to a world event when one exists.

### Optional semantics

May include:

- apparent direction/location;
- ambiguity/occlusion;
- novelty relative to expectation;
- whether Wilson observed the action, only the result, or both;
- diagnostic perception reasons.

### Lifetime / persistence

Normally ephemeral. It may produce a persisted `EpisodeCandidate` or belief update, but is not itself required as canonical save state.

### Replay implications

Given the same authoritative state, perception context and deterministic inputs, the same observation should be reproducible.

### Example

`Missing Spoon`:

```text
Wilson observes: expected spoon is absent from cooking area
Wilson may not observe: player moved spoon earlier
```

---

## 3.3 PerceptionResult

### Purpose

Bundle the perception pass that defines the small Wilson-accessible context for a reconsideration or reaction cycle.

### Producer

Perception service/pipeline.

### Consumers

- salience/attention;
- candidate generation;
- expectation derivation;
- immediate-threat detection;
- causal attribution where relevant;
- debug trace.

### Authority

Derived/observational.

### Required semantics

Must include enough to identify:

- currently perceived subjects;
- observed changes/events;
- perception limitations relevant to interpretation;
- local environmental context available to Wilson.

### Optional semantics

- sensory channel confidence;
- spatial relations;
- provenance back to authoritative entities/events;
- perception diagnostic reasons.

### Lifetime / persistence

One cognition/perception pass. Not persisted as canonical state.

### Replay implications

Must be deterministic under the same perception inputs.

---

## 3.4 PerceivedSubject

### Purpose

Represent a subject as available to Wilson's current cognition without exposing arbitrary world internals.

### Producer

Perception.

### Consumers

- salience;
- affordance/candidate generation;
- expectation;
- risk evaluation;
- reaction derivation.

### Authority

Observational projection.

### Required semantics

Must support:

- stable subject reference where Wilson can individuate it;
- perceived category/type/capabilities rather than hidden ground truth;
- perceived spatial relation/accessibility;
- perceptible state relevant to available actions.

### Optional semantics

- familiarity/recognition status;
- uncertainty in classification;
- currently visible affordance hints;
- direct link to observation provenance for debugging.

### Lifetime / persistence

One perception/decision context.

### Example

`Scientific Method` may expose an unfamiliar stone-like object as a perceived subject with uncertain hardness-related expectations rather than directly exposing authoritative hardness.

---

## 3.5 ObservedChange

### Purpose

Represent a semantically comparable before/after difference available to Wilson, especially for anomaly detection and arrangement expectations.

### Producer

Perception/expectation comparison.

### Consumers

- prediction-error derivation;
- salience;
- causal attribution;
- learning evidence generation.

### Authority

Derived observational value.

### Required semantics

- subject/scope;
- expected or previously observed condition when available;
- currently observed condition;
- qualitative/quantitative difference relevant to Wilson.

### Optional semantics

- anomaly strength;
- uncertainty;
- temporal gap;
- arrangement/location relation.

### Lifetime / persistence

Ephemeral. Persistent consequences belong in beliefs, episodes, habits or associations.

---

# 4. Decision and reconsideration contracts

## 4.1 DecisionContext

### Purpose

Provide the bounded read-only context from which one reconsideration cycle derives candidates and evaluations.

### Producer

Game Orchestrator / Wilson Cognition coordinator.

### Consumers

- candidate intention sources;
- expectation service;
- intention evaluators;
- selection logic;
- debug tracing.

### Authority

Derived read model. It must not own mutable state.

### Required semantics

Must expose, directly or through queries:

- current/suspended intention state;
- relevant drives;
- traits;
- relevant beliefs/associations/habits/memories;
- current project opportunities;
- current perception/salient subjects;
- recent meaningful events/triggers;
- player suggestion signals currently eligible;
- relevant temporal/environmental context;
- decision regime: normal or immediate threat.

### Optional semantics

- director bias/opportunity context;
- transient emotion modifiers;
- explanation/debug sink;
- deterministic decision identity.

### Lifetime / persistence

One reconsideration cycle.

### Replay implications

Must be reconstructible from authoritative/persistent state plus deterministic current inputs.

---

## 4.2 ReconsiderationTrigger

### Purpose

Explain why the current intention is being reconsidered now rather than recomputing the entire decision every tick.

### Producer

Orchestrator and relevant systems/services detecting meaningful conditions.

### Consumers

- reconsideration gate/coalescer;
- action/intention interruption policy;
- decision trace/debugging.

### Authority

Derived control signal. It does not itself mutate intentional state.

### Required semantics

Must classify triggers such as:

```text
intention completed
current action invalidated
meaningful drive threshold crossed
major novelty/anomaly
prediction error
player suggestion
noticed intervention
directed event
immediate threat
project checkpoint
important temporal/context transition
```

Must also carry:

- source/context;
- urgency/interruptibility class;
- simulation time/order.

### Optional semantics

- coalescing key;
- diagnostic reason;
- affected current intention/action.

### Lifetime / persistence

Ephemeral until consumed/coalesced.

### Guard implications

Trigger frequency must not become a hidden substitute for utility magnitude. Near-continuous low-value triggers should be coalesced/debounced rather than causing ping-pong.

---

## 4.3 CandidateIntention

### Purpose

Represent a meaningful objective Wilson could plausibly pursue now.

Examples:

```text
eat known food
investigate mushroom
continue roof stage
protect food from storm
search for suitable material
inspect displaced storage
```

### Producer

Composable candidate sources such as need, affordance, project, habit, suspended interest, event, suggestion and stimulation sources.

### Consumers

- expectation derivation;
- intention evaluators;
- candidate competition/selection;
- debug trace.

### Authority

Derived proposal. It does not command Wilson or mutate the world.

### Required semantics

- semantic objective;
- target/participants when applicable;
- source reason(s) for candidacy;
- feasibility/plausibility basis available to cognition;
- continuity relation to current/suspended intention when relevant.

### Optional semantics

- project contribution reference;
- suggestion reference;
- unresolved curiosity reference;
- expected prerequisite/search step;
- candidate family/category for health metrics.

### Lifetime / persistence

One decision cycle. The selected result becomes intentional state through `SelectedIntention`.

### Guard implications

Candidate generation must remain bounded/contextual. Wilson should not enumerate every possible action over every world entity.

---

## 4.4 EvaluationContribution

### Purpose

Preserve one semantically distinct reason that increases, decreases or otherwise shapes a candidate's tendency.

### Producer

Composable intention evaluators.

### Consumers

- candidate evaluation combiner;
- debug/explanation tooling;
- health/calibration analysis.

### Authority

Derived value.

### Required semantics

- evaluator/reason identity;
- semantic direction/effect;
- finite bounded magnitude or equivalent bounded influence representation;
- explanation/provenance sufficient for debugging.

### Optional semantics

- trait modulation applied to this contribution;
- confidence/uncertainty;
- guard/saturation metadata;
- normalized family/category.

### Lifetime / persistence

One evaluation cycle; may be retained in diagnostic traces only.

### Guard implications

Every contribution family must have a declared finite influence envelope. Traits modulate only semantically related contributions.

---

## 4.5 CandidateEvaluation

### Purpose

Collect the explainable evaluation of one candidate before stochastic/competitive selection.

### Producer

Intention evaluation/competition pipeline.

### Consumers

- selection policy;
- debug trace;
- calibration tooling.

### Authority

Derived.

### Required semantics

- candidate reference;
- individual semantic contributions;
- final comparable tendency/selection weight representation;
- eligibility/invalidity state if evaluation discovers a cognition-level disqualifier.

### Optional semantics

- current-intention continuity advantage;
- uncertainty;
- guard activations;
- candidate-family metadata.

### Lifetime / persistence

One decision cycle.

### Replay implications

Selection must be reproducible from the same evaluations and seeded RNG state.

---

## 4.6 SelectedIntention

### Purpose

Represent the meaningful objective Wilson chose after competition.

It is more abstract than a raw animation or one physical step.

### Producer

Intention selection policy.

### Consumers

- Wilson intentional-state owner;
- action planning/step derivation;
- project contribution flow;
- presentation/debugging.

### Authority

Authoritative **Wilson-relative choice result** once committed by the cognition owner. It is not authoritative about physical success.

### Required semantics

- semantic objective;
- target/participants when applicable;
- originating candidate;
- commitment/continuity classification such as new/continue/resume;
- selection time/decision identity;
- enough explanation linkage to reconstruct why it won.

### Optional semantics

- associated project contribution;
- expected high-level outcome;
- suspension/resumption metadata;
- selection randomness trace reference.

### Lifetime / persistence

Persists as current intention when required by `STATE_REQUIREMENTS.md`; may become suspended intention across interruptions.

### Replay implications

Selection must be deterministic under the same seed/context. The persisted intentional state is canonical; the full evaluation trace is diagnostic.

---

# 5. Action contracts

## 5.1 ActionRequest / ActionStep

### Purpose

Represent one physically actionable step used to advance a selected intention.

The contract may later split into separate request/step types if implementation proves the distinction useful.

### Producer

Action derivation/planning layer operating under a `SelectedIntention`.

### Consumers

- Action Resolution;
- World validation/query services;
- action-progress tracking;
- debug/presentation adapters.

### Authority

Proposal/command request. It is not proof that the action is physically valid or successful.

### Required semantics

- actor;
- semantic action;
- targets/participants;
- intended relation to current intention;
- required capabilities/preconditions known to the action layer.

### Optional semantics

- movement/navigation prerequisite;
- project contribution reference;
- expected observable feedback;
- estimated duration/effort class;
- interruption class.

### Lifetime / persistence

Moment-to-short while active. Whether an in-progress action needs persistence depends on later concrete action/save semantics; the contract itself is transient.

---

## 5.2 ActionValidationResult

### Purpose

Express whether a proposed action step is currently executable against authoritative world rules.

### Producer

Action Resolution / World validation.

### Consumers

- action progression;
- reconsideration trigger generation;
- debug explanation.

### Authority

Authoritative validation result for the current world state.

### Required semantics

- valid/invalid classification;
- validated action/participants;
- semantic failure reason when invalid.

### Optional semantics

- recoverable prerequisite;
- changed-world invalidation source;
- diagnostic physical constraints.

### Lifetime / persistence

Momentary.

### Example

If the player moves a required support before Wilson physically commits, validation can fail and produce an action-invalidated reconsideration trigger without pretending Wilson chose differently earlier.

---

## 5.3 ActionProgress

### Purpose

Represent deterministic progress of a valid ongoing action without conflating every simulation tick with a new intention decision.

### Producer

Action Resolution.

### Consumers

- orchestrator;
- presentation;
- interruption policy;
- eventual action outcome construction.

### Authority

Authoritative action-execution state/result for the active step.

### Required semantics

Must distinguish at least:

```text
started
continuing
checkpoint reached
completed
failed
interrupted
invalidated
```

and identify the active semantic action/participants.

### Optional semantics

- normalized progress where meaningful;
- physical intermediate effects;
- next safe interruption point;
- timing/effort diagnostics.

### Lifetime / persistence

While the action step is active. Durable physical intermediate effects belong to world state, not this transport object.

---

## 5.4 ActionOutcome

### Purpose

Represent the grounded result of executing or advancing a semantic action.

This is the primary bridge from action resolution into learning, project progression, reaction and presentation.

### Producer

Action Resolution, after authoritative validation/physical resolution.

### Consumers

- World event collection;
- Memory & Learning Pipeline;
- Project System;
- reaction/causal attribution;
- presentation/debugging.

### Authority

Authoritative result for what the action physically achieved or failed to achieve.

### Required semantics

Must support:

- actor;
- semantic action;
- participants;
- authoritative physical effects/result;
- observable effect candidates;
- result classification;
- consequence severity;
- simulation timing/order.

### Optional semantics

- diagnostic feedback;
- project contribution relation;
- failure reason;
- partial-success classification;
- action duration/effort;
- causal chain reference.

### Lifetime / persistence

Ephemeral transport result. Durable consequences are persisted by their owning systems; selected meaningful outcomes may produce episodic history.

### Example

`Scientific Method`:

```text
Wilson strikes coconut using unfamiliar stone
→ coconut not opened
→ stone chips/cracks
→ partial observable feedback
```

The outcome must preserve both the failed goal and the diagnostic physical feedback so the next experiment can differ.

---

## 5.5 DiagnosticFeedback

### Purpose

Represent information-bearing result detail that can support partial learning even when the action's primary goal failed.

### Producer

Action Resolution from authoritative physical effects.

### Consumers

- perception;
- expectation/prediction-error derivation;
- learning evidence generation;
- debug trace.

### Authority

Authoritative about the physical diagnostic fact, observational only after perception projects it to Wilson.

### Required semantics

- feedback subject/property/effect;
- semantic direction or qualitative result;
- relation to attempted action/expected outcome.

### Optional semantics

- intensity;
- ambiguity;
- diagnostic relevance hints grounded in domain semantics.

### Lifetime / persistence

Ephemeral; persistent effect belongs in learned beliefs if evidence justifies it.

---

# 6. Learning and persistent-consequence contracts

## 6.1 LearningEvidence

### Purpose

Aggregate grounded Wilson-accessible evidence from outcomes, observations and interpreted context before it is decomposed into owner-specific update proposals.

### Producer

Memory & Learning Pipeline.

### Consumers

- belief evidence derivation;
- association impact derivation;
- habit evidence derivation;
- episode selection;
- presence evidence derivation.

### Authority

Derived evidence bundle. It cannot directly rewrite persistent state.

### Required semantics

- observed event/outcome basis;
- evidence quality/provenance;
- Wilson-relative consequence interpretation;
- relevant subjects/scopes;
- timing/context.

### Optional semantics

- expectation mismatch;
- causal-attribution result;
- transient emotional intensity;
- repetition/context similarity.

### Lifetime / persistence

One learning pass.

---

## 6.2 BeliefEvidence

### Purpose

Propose a bounded update to one or more Wilson belief propositions from grounded evidence.

### Producer

Learning pipeline / belief-evidence derivation.

### Consumers

Belief store owner.

### Authority

Proposal/evidence. The belief store remains authoritative for Wilson's persistent beliefs.

### Required semantics

- proposition/claim scope;
- support vs contradiction semantics;
- evidence strength/quality;
- source/provenance;
- generalization scope constraint.

### Optional semantics

- exception/subtype relationship;
- source accessibility/narratability;
- causal-attribution confidence;
- repeated-evidence identity for diminishing returns.

### Lifetime / persistence

Ephemeral input. Resulting updated belief is persistent when required by state rules.

### Guard implications

Must support:

- confidence saturation;
- strong contradictions near saturation;
- bounded generalization;
- diminishing identical evidence;
- exception handling before category collapse where appropriate.

---

## 6.3 AssociationImpact

### Purpose

Propose valence/attachment consequences for a Wilson-relative subject association.

### Producer

Learning/reaction pipeline.

### Consumers

Association store owner.

### Authority

Proposal. Association store owns the persistent result.

### Required semantics

- subject;
- subjective consequence direction;
- consequence/relevance intensity;
- whether the experience is attachment-relevant;
- provenance/repetition context.

### Optional semantics

- emotional intensity;
- uniqueness;
- directness;
- current-need amplification context.

### Lifetime / persistence

Ephemeral input; association result persists.

### Guard implications

Must permit negative-valence/high-attachment outcomes and diminishing repeated reinforcement.

---

## 6.4 HabitEvidence

### Purpose

Propose reinforcement, weakening or contextual differentiation of a habit from repeated cue-action-outcome experience.

### Producer

Learning pipeline.

### Consumers

Habit store owner.

### Authority

Proposal.

### Required semantics

- cue/context;
- performed semantic behavior/intention;
- outcome/repetition relevance;
- reinforcement direction/strength.

### Optional semantics

- context similarity;
- expectation consistency;
- interruption/failure classification.

### Lifetime / persistence

Ephemeral input; habit state persists when admitted by state requirements.

### Guard implications

Habit evidence must support bounded strength and anti-lock-in interaction with stimulation/preferences.

---

## 6.5 EpisodeCandidate

### Purpose

Represent a meaningful experience that may deserve durable episodic memory rather than immediate discard/consolidation.

### Producer

Memory & Learning Pipeline.

### Consumers

Memory store/consolidation policy;
- diary/narrative projection if admitted later.

### Authority

Proposal. Memory owner decides persistence/retention under bounded memory policy.

### Required semantics

- event/outcome summary grounded in observation;
- involved subjects;
- Wilson-relative significance;
- temporal context;
- links to expectation/reaction/learning where relevant.

### Optional semantics

- causal interpretation;
- emotional intensity;
- project/presence relevance;
- source-accessibility semantics for resurrection/consolidation.

### Lifetime / persistence

Momentary candidate; selected episode may persist medium/run-long according to memory policy.

---

## 6.6 PresenceEvidence

### Purpose

Propose updates to Wilson's unseen-presence relationship from perceived anomalies/interventions and causal attribution.

### Producer

Learning/causal-attribution pipeline.

### Consumers

Presence relationship owner.

### Authority

Proposal. Persistent `presence_belief`, `trust` and `dependency` remain owned by Wilson cognition.

### Required semantics

Must distinguish evidence relevant to:

```text
presence existence/plausibility
helpfulness/harmfulness → trust
learned reliance/expected assistance → dependency
```

and include:

- observed consequence;
- attribution strength/confidence;
- intervention/suggestion pattern where Wilson could infer it;
- subjective benefit/harm.

### Optional semantics

- omission/non-intervention expectation;
- repeated-help context;
- independence modulation input where semantically appropriate.

### Lifetime / persistence

Ephemeral evidence; relationship state persists.

### Guard implications

Helpful and harmful anomalies may both increase `presence_belief`. Trust direction follows Wilson's perceived consequence. Player private intent must never appear here.

---

# 7. Project contracts

## 7.1 ProjectOpportunity

### Purpose

Expose a currently meaningful project possibility or next contribution without commanding Wilson to pursue it.

### Producer

Project System, optionally influenced by authored/systemic history eligibility.

### Consumers

- Project intention source;
- director/context systems;
- debug/presentation where appropriate.

### Authority

Authoritative about project lifecycle/available project semantics, not about Wilson's desire or physical success.

### Required semantics

- project identity;
- semantic desired outcome/stage;
- currently available contribution families;
- relevant capability/resource requirements;
- lifecycle/status context.

### Optional semantics

- urgency/window;
- authored-history eligibility reason;
- completion proximity;
- visible world anchors.

### Lifetime / persistence

Opportunity is derived from persistent project/world state. Project state itself persists.

---

## 7.2 ProjectContribution

### Purpose

Represent one semantic contribution Wilson may choose to make toward a project.

### Producer

Project System from project state + world capabilities.

### Consumers

- candidate generation;
- selected intention/action derivation;
- Action Outcome linkage.

### Authority

Proposal about valid project contribution semantics. It does not execute the contribution.

### Required semantics

- project identity;
- contribution/stage identity;
- semantic requirement/outcome;
- compatible capability/resource constraints.

### Optional semantics

- partial contribution amount/category;
- prerequisite relation;
- completion proximity.

### Lifetime / persistence

Ephemeral opportunity derived from persistent project state.

---

## 7.3 ProjectProgressResult

### Purpose

Represent the project owner's accepted interpretation of a grounded `ActionOutcome` as project progress/lifecycle change.

### Producer

Project System after consuming grounded world/action outcome.

### Consumers

- orchestrator;
- cognition for reconsideration/project checkpoint;
- presentation/debugging.

### Authority

Authoritative about project lifecycle/progress not already wholly represented by world physical state.

### Required semantics

- project identity;
- contribution accepted/rejected/partial;
- progress/lifecycle change;
- relation to grounded action outcome.

### Optional semantics

- next available stage/opportunity;
- completion/pause/abandonment reason;
- world-state references.

### Lifetime / persistence

Result is ephemeral; resulting project state persists.

---

# 8. Player contracts

## 8.1 SuggestionSignal

### Purpose

Represent a player suggestion as bounded external influence entering normal intention competition.

### Producer

Player Intervention System.

### Consumers

- Suggestion intention source/evaluator;
- presence/dependency learning where subsequent outcomes justify it;
- debug trace.

### Authority

Player-side authoritative signal that a suggestion was issued. It is **not** authoritative over Wilson behavior or world truth.

### Required semantics

- suggested semantic objective/subject;
- issue time;
- validity/eligibility under game mode;
- insistence/repetition context if supported.

### Optional semantics

- expiry/window;
- presentation source;
- player-side cost if the product later ties suggestions to cost.

### Lifetime / persistence

Short-lived unless current product rules require an insistence window/count. Wilson's resulting choice remains separate.

### Guard implications

Influence is bounded by suggestion semantics, `independence`, relationship/dependency context and normal competition. No forced action command.

---

## 8.2 ValidatedIntervention

### Purpose

Represent an approved player intervention after player-side permissions/cost validation and before/while authoritative world application.

### Producer

Player Intervention System.

### Consumers

- World Simulation / Action Resolution path responsible for applying the physical effect;
- player-state owner for cost/streak update;
- debug/replay.

### Authority

Authoritative about the player-side request being validated and paid/allowed; not by itself authoritative that the physical effect succeeded unless paired with world result.

### Required semantics

- intervention semantic type;
- authoritative target(s);
- validated magnitude/scope;
- cost/permission result;
- issue time/order.

### Optional semantics

- world command parameters;
- intervention cause reference for later observation provenance;
- game mode.

### Lifetime / persistence

Momentary. Player resource consequences persist in the Player Intervention System; world consequences persist in World Simulation.

---

## 8.3 InterventionObservation

### Purpose

Represent the Wilson-observable evidence that may be associated with a player intervention without leaking player private intent.

### Producer

Perception from resulting world events/effects.

### Consumers

- causal attribution;
- presence evidence;
- reaction/learning;
- debug trace.

### Authority

Observational Wilson-relative projection.

### Required semantics

- observed effect/change;
- temporal/spatial relation to prior context;
- ambiguity of natural vs unexplained cause.

### Forbidden semantics

Must not contain hidden player intent such as:

```text
"the player was trying to help"
"the player meant to save Wilson"
```

unless that meaning is independently inferred by Wilson from observable evidence.

### Lifetime / persistence

Ephemeral; persistent presence relationship changes occur through `PresenceEvidence`.

---

# 9. Director contracts

## 9.1 DirectorContext

### Purpose

Provide a read-only, bounded context that lets the Event/Scene Director decide which authored/systemic opportunities may become available without taking over Wilson's cognition.

### Producer

Orchestrator from world, Wilson, player and project read models.

### Consumers

Event/Scene Director.

### Authority

Derived read model.

### Required semantics

May expose:

- simulation time/season/weather window;
- recent scene/opportunity history;
- project/world eligibility;
- broad Wilson state needed for content gating;
- current intervention capacity where product rules require it;
- cooldown/rarity state owned by the director.

### Forbidden authority

The director may not rewrite Wilson beliefs, traits, associations, habits, trust or intentions to manufacture a scene.

### Lifetime / persistence

One director evaluation pass. Director-owned cooldown/history may persist separately.

---

## 9.2 TemporaryOpportunity

### Purpose

Represent a time-bounded world/content opportunity introduced or surfaced by the director.

Examples:

```text
rescue boat visible offshore
rare weather window
washed-up object
animal/event opportunity
```

### Producer

Event/Scene Director through valid world/content paths.

### Consumers

- World Simulation;
- perception;
- candidate generation;
- presentation.

### Authority

Authoritative only after the opportunity is instantiated/accepted through the owning world/director rules. It never forces Wilson to care about it.

### Required semantics

- opportunity kind;
- availability window/conditions;
- world manifestation or affordance;
- director provenance.

### Optional semantics

- rarity/cooldown category;
- related scene bias;
- expiration behavior.

### Lifetime / persistence

Short/time-bounded. If it creates durable world state, that state transfers to the world owner.

---

## 9.3 SceneBias

### Purpose

Provide a bounded, explainable nudge that can make contextually appropriate content/intention candidates more legible without overriding Wilson's autonomous decision model.

### Producer

Event/Scene Director.

### Consumers

- candidate/evaluation pipeline where explicitly allowed.

### Authority

Derived bounded modifier, never state authority.

### Required semantics

- target candidate family/opportunity;
- bounded influence;
- reason/expiry.

### Guard implications

Must have a finite declared envelope and may not suppress immediate needs/threats through hidden enormous values.

### Lifetime / persistence

Short-lived.

---

# 10. Presentation contracts

## 10.1 ReactionIntent

### Purpose

Represent a grounded transient Wilson reaction that presentation may realize through animation, facial/body expression, sound, speech or silence.

### Producer

Reaction/emotion derivation from observed outcomes, expectation mismatch and Wilson context.

### Consumers

- presentation adapter;
- optional speech/thought realization;
- debug trace.

### Authority

Derived Wilson-expression intent. It does not mutate persistent state by itself.

### Required semantics

- reaction category/semantic direction;
- target/subject when relevant;
- intensity/duration class;
- grounding event/outcome.

### Optional semantics

- communicative intent;
- suppression/priority;
- speech eligibility.

### Lifetime / persistence

Moment/short. Persistent consequences are handled separately by learning contracts.

---

## 10.2 SpeechAct

### Purpose

Represent the semantic communicative act Wilson may express before any deterministic or LLM wording realization.

### Producer

Presentation/narrative projection from grounded reaction/intention/history.

### Consumers

- deterministic text realization;
- optional LLM realization;
- subtitles/UI/audio pipeline.

### Authority

Presentation/narrative semantic projection only.

### Required semantics

- act kind such as refusal, surprise, complaint, triumph, hypothesis, diary reflection;
- grounded subject/context;
- allowed factual content derived from Wilson knowledge/history.

### Optional semantics

- tone constraints;
- brevity;
- callback candidates;
- wording exclusions.

### Guard implications

LLM realization may not introduce new authoritative facts, memories, causes or action results.

### Lifetime / persistence

Momentary unless separately stored as presentation history; not canonical cognition.

---

## 10.3 PresentationEvent

### Purpose

Project authoritative/observational domain events into renderable, audible or UI-consumable presentation semantics without coupling the domain to Godot nodes/assets.

### Producer

Presentation projection layer.

### Consumers

Godot/UI/audio adapters.

### Authority

Presentation only.

### Required semantics

- semantic presentation event;
- involved domain entity references;
- timing/order;
- grounding domain event/outcome/reaction.

### Optional semantics

- animation/action semantic key;
- intensity;
- camera/UI hints when product-approved;
- narration/speech link.

### Lifetime / persistence

Momentary. Visual state should be reconstructible from authoritative domain state where possible.

---

# 11. Cross-contract flow invariants

## 11.1 World change to belief update

Required direction:

```text
WorldEvent
→ PerceptionResult / ObservedEvent
→ expectation comparison / causal interpretation
→ LearningEvidence
→ BeliefEvidence
→ BeliefStore applies bounded owner-local mutation
```

Forbidden shortcut:

```text
WorldEvent
→ directly edit Wilson belief because the simulation knows the truth
```

## 11.2 Intention to physical outcome

Required direction:

```text
CandidateIntention
→ CandidateEvaluation
→ SelectedIntention
→ ActionRequest / ActionStep
→ ActionValidationResult
→ ActionProgress
→ ActionOutcome
```

A selected intention is never proof of a valid or successful physical action.

## 11.3 Project progress

Required direction:

```text
ProjectOpportunity
→ ProjectContribution candidate
→ Wilson may select intention
→ grounded ActionOutcome
→ ProjectProgressResult
→ project owner mutates project lifecycle/progress
```

Project System may not directly command Wilson or fabricate physical success.

## 11.4 Player intervention

Required direction:

```text
player UI intent
→ ValidatedIntervention
→ authoritative world effect/result
→ Wilson-perceivable InterventionObservation only if observable
→ causal attribution
→ PresenceEvidence
→ presence relationship owner applies bounded update
```

Player private intent never enters Wilson cognition.

## 11.5 Reaction versus persistence

Transient reaction and durable consequence are parallel consequences of grounded experience:

```text
ObservedEvent / ActionOutcome
├→ ReactionIntent → presentation
└→ LearningEvidence → persistent owner-local updates
```

Do not persist every transient emotion merely because presentation needs it for a few seconds.

---

# 12. Contract trace — representative scenes

These are compact contract-level checks. Full phase-by-phase traces belong in the later decision-trace deliverable.

## 12.1 Scientific Method

```text
DecisionContext
→ CandidateIntention(investigate coconut-opening strategy)
→ CandidateEvaluation(curiosity + expected usefulness - effort/risk)
→ SelectedIntention(test unfamiliar stone)
→ ActionStep(strike coconut with stone)
→ ActionOutcome(primary goal failed; stone chipped; coconut response observed)
→ ObservedEvent(partial diagnostic feedback)
→ LearningEvidence(expectation mismatch)
→ BeliefEvidence(stone/material capability evidence, bounded scope)
→ ReconsiderationTrigger(prediction error / unresolved goal)
→ new candidate set using revised expectation
```

The contracts preserve partial feedback and allow strategy refinement without pair-specific recipes.

## 12.2 Sabotaged Storage

```text
WorldEvent(storage arrangement changed by intervention)
→ ObservedEvent(expected objects absent/displaced)
→ ObservedChange(arrangement mismatch)
→ ReconsiderationTrigger(anomaly)
→ CandidateIntention(search / inspect / recover / adapt storage)
→ causal attribution over observed evidence
→ LearningEvidence(pattern across anomalies)
→ PresenceEvidence(presence plausibility + harmful consequence)
→ AssociationImpact / EpisodeCandidate where relevant
→ persistent trust/presence update by owners
```

The actual cause remains separate from Wilson's inferred cause.

## 12.3 Brilliant Shortcut

```text
DecisionContext(normal regime)
→ CandidateIntention(use known shortcut)
→ CandidateIntention(take safer route)
→ CandidateEvaluation includes learned shortcut value, changed-weather perceived risk, effort difference, risk tolerance
→ SelectedIntention(shortcut)
→ ActionStep begins
→ authoritative world/action progression
→ ActionOutcome(physical consequence)
→ ObservedEvent / reaction / learning
```

If a true immediate threat appears during execution:

```text
ReconsiderationTrigger(immediate threat)
→ immediate-threat regime
```

rather than an evaluator returning an extreme utility value.

---

# 13. Persistence summary

The following contracts are **not** canonical persisted state merely because they may be useful for replay/debugging:

```text
WorldEvent
ObservedEvent
PerceptionResult
PerceivedSubject
ObservedChange
DecisionContext
ReconsiderationTrigger
CandidateIntention
EvaluationContribution
CandidateEvaluation
ActionValidationResult
ActionProgress transport snapshot
ActionOutcome transport result
LearningEvidence
BeliefEvidence
AssociationImpact
HabitEvidence
EpisodeCandidate
PresenceEvidence
ProjectOpportunity
ProjectContribution
InterventionObservation
DirectorContext
TemporaryOpportunity transport representation
SceneBias
ReactionIntent
SpeechAct
PresentationEvent
```

Persistence belongs to the owners identified in `STATE_REQUIREMENTS.md` and `ARCHITECTURE.md`, including:

```text
world authoritative state
Wilson traits/drives/beliefs/associations/habits/memory/intentional continuity/presence relationship
project lifecycle/progress
player intervention/progression state
director-owned durable cooldown/history if required
```

Diagnostic traces may persist separately for development tooling without becoming authoritative simulation truth.

---

# 14. Open contract questions deferred to update-phase design

The semantic catalog is sufficient to proceed, but these orchestration questions remain intentionally unresolved until the update-phase specification:

1. exact coalescing rules when multiple `ReconsiderationTrigger`s occur in one simulation interval;
2. action-step interruption classes and safe interruption checkpoints;
3. when current intention becomes suspended versus discarded;
4. exact distinction between action completion, intention completion and project checkpoint;
5. clock categories and ordering between world advance, drive advance, action progression, cognition and learning;
6. offline substitutions for action progression, rare opportunities and learning;
7. presentation synchronization when multiple authoritative events occur within one coarse simulation step;
8. maintenance/consolidation cadence for memory, habits, associations and beliefs;
9. deterministic trace identity / RNG bookkeeping representation;
10. whether `ActionRequest` and `ActionStep`, or `WorldEvent` and some specialized result contracts, should remain separate concrete implementation types.

These are **phase/orchestration concerns**, not reasons to weaken the semantic boundaries above.

---

# 15. Gate for Deliverable A

The contract catalog is ready to feed the update-phase specification when the following statements remain true:

- world truth, observation and Wilson belief remain separate;
- `SelectedIntention` is a committed Wilson-relative objective, not a physical command;
- `ActionOutcome` is grounded authoritative action feedback;
- learning crosses system boundaries as evidence/proposals and owner-local mutation;
- project progress depends on grounded outcomes;
- player private intent never reaches Wilson cognition;
- director and presentation contracts remain non-authoritative over Wilson/world truth;
- every decision contribution can be bounded and explained;
- immediate threat remains a separate regime;
- canonical persistence remains in state owners, not transient transport contracts;
- deterministic headless replay can reconstruct why a decision and update occurred.

The next canonical artifact should define **update phases, clocks, ordering, reconsideration/interruption semantics, maintenance and offline substitution** using this catalog.