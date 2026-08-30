# Handoff — Behavioral Architecture → Simulation Contracts

## Purpose

This handoff transfers Wilson Shipwrecked from the completed behavioral/architecture discovery phase into the next design phase: **defining the concrete simulation contracts and update phases that connect the validated systems**.

It is intended for another agent continuing the project without access to the full prior conversation.

Do not restart product discovery from first principles unless implementation evidence contradicts the current documents. The behavioral model has already been stress-tested against representative scenes and regression cases.

---

# 1. Current project phase

The project has moved through:

1. product fantasy and player-role discovery;
2. interaction/property/knowledge discovery;
3. psychology research and reduction;
4. independent representative-scene catalog;
5. scene triage;
6. detailed behavioral analysis;
7. 23 Must-have scene × system matrix;
8. 12-case regression suite;
9. functional persistent-state inventory;
10. first architectural decomposition;
11. guard/self-stabilization analysis.

The next phase is **contract and orchestration design before implementation**.

The goal is to make the responsibility graph concrete enough to answer:

- what semantic data crosses each system boundary;
- which phase owns each state mutation;
- how time/ticks/events trigger updates;
- how reconsideration and action progression interleave;
- what is persisted versus recomputed;
- where deterministic randomness enters;
- how headless simulation observes and explains decisions;
- how guards are enforced without hidden cross-system mutation.

Do not begin by choosing Godot nodes, ECS, GOAP, database schemas or serialization formats.

---

# 2. Required reading order

Read these documents before proposing contracts:

1. `docs/DISCOVERY_STATUS.md`
   - current phase, document precedence and validated conclusions;
2. `docs/BEHAVIORAL_MODEL.md`
   - authoritative functional model of Wilson behavior;
3. `docs/STATE_REQUIREMENTS.md`
   - what state must persist, its scope/lifetime/decay/offline/resurrection semantics;
4. `docs/SCENE_VALIDATION.md`
   - scene evidence, Must-have matrix and regression suite;
5. `docs/ARCHITECTURE.md`
   - system boundaries, composition strategy, contact points and game-loop direction;
6. `docs/GUARDS_AND_CALIBRATION.md`
   - local/global guards, health metrics and bounded self-stabilization rules;
7. `docs/AI.md`
   - LLM authority/fallback boundary;
8. `docs/PRODUCT.md`
   - product fantasy, player role, God Power, UI, rhythm and presentation;
9. `docs/SIMULATION.md`
   - broader world/action/property vocabulary.

For visual/asset work, separately follow `VISUAL_GUIDE.md`, `ASSET_SPEC.md` and `ASSET_PIPELINE.md`.

### Precedence

Where older provisional behavioral language in `PRODUCT.md` or `SIMULATION.md` conflicts with newer behavioral documents, use:

```text
BEHAVIORAL_MODEL.md
STATE_REQUIREMENTS.md
SCENE_VALIDATION.md
```

as the current behavioral source of truth.

---

# 3. Decisions considered closed unless new evidence breaks them

## 3.1 Wilson remains autonomous

The player changes the environment and sends suggestions. The player never directly executes Wilson's actions.

A suggestion enters normal intention competition; it is not an action command.

## 3.2 Behavioral model

Stable traits:

```text
curiosity
risk_tolerance
independence
```

Core drives:

```text
hunger
energy
comfort
stimulation
```

Persistent continuity:

```text
beliefs / knowledge
associations: valence + attachment
selected episodic history
habits
current/suspended intentions
projects
presence relationship:
    presence_belief
    trust
    dependency
```

Derived/transient:

```text
attention / salience
expectations
candidate tendency
prediction error
causal-attribution weights
short-lived emotions/reactions
```

## 3.3 Explicitly rejected independent primitives

Do not reintroduce without a scene or implementation case that existing concepts cannot explain:

```text
sanity
persistence
sociability
loneliness
playfulness
safety as accumulating drive
cleanliness
orderliness
superstitiousness
faith separate from presence_belief
forgiveness
regret
routine
tradition
environmental ownership
global persistent mood
```

The visible phenomena still exist through composition.

## 3.4 Knowledge model

Keep separate:

```text
world truth
Wilson belief / knowledge
Wilson expectation
player knowledge
```

Knowledge uses proposition-level confidence and scope. Category inference may be wrong. Expectations are normally derived.

## 3.5 Associations

Use the conceptual dimensions:

```text
valence    [-1,+1]
attachment [0,1]
```

Negative valence and high attachment are valid and important.

Do not automatically add persistent fear/threat to association; danger is currently represented through beliefs/expected consequences and produces transient fear in context.

## 3.6 Projects

`Project` is a first-class functional concept because it carries visible multi-stage world progress across interruptions.

Projects generate possible intentions; they do not command Wilson.

Systemic history may make an authored project possibility contextually eligible. The simulation does not need infinite procedural crafting.

## 3.7 Player relationship

Use:

```text
presence_belief [0,1]
trust           [-1,+1]
dependency      [0,1]
```

Helpful and harmful unexplained interventions may both increase `presence_belief`; `trust` changes according to Wilson's perceived consequence and attribution.

Player private intent is never passed into Wilson cognition.

## 3.8 LLM

The simulation is behaviorally complete without an LLM.

The LLM may:

- realize sparse Wilson speech/thought;
- realize reaction language;
- produce diary prose from grounded history;
- boundedly reweight valid ambiguous interpretations;
- choose rare grounded embellishments from valid candidates.

It may not decide physics, death, validity, project progress, authoritative knowledge, memories or impossible actions.

Approximate current policy:

```text
~30% of eligible ambiguous interpretation cases may use LLM assistance
```

not 30% of ticks or actions.

---

# 4. Architecture currently accepted

The architecture distinguishes **state-owning systems**, **derived services/pipelines**, and **adapters**.

## State-owning / authoritative systems

```text
World Simulation
Wilson Cognition
Project System
Player Intervention
Event / Scene Director
Action Resolution
```

Persistence stores authoritative/durable state but should not invent domain rules.

## Major pipelines

```text
Decision / Reconsideration Pipeline
Memory & Learning Pipeline
```

## Derived/composable services

```text
Perception
Salience / Attention
Expectation
Candidate Intention Generation
Intention Evaluation / Competition
Causal Attribution
Reaction / Emotion
```

## Adapters

```text
Godot presentation
Persistence backend/serialization
LLM provider
Analytics/debug tooling
```

### Important rule

Do not turn every psychological concept into a state-owning `System`.

Attention, expectation, causal weights and action scores are examples of values that should normally be recalculated rather than persisted as independent truth.

---

# 5. High-value contact points already identified

Three contracts are especially important:

```text
ObservedEvent
SelectedIntention
ActionOutcome
```

They should remain semantic and implementation-independent.

## ObservedEvent

Represents a Wilson-observable event/change, not necessarily the full authoritative event.

It is the bridge from world/player/director effects into perception/cognition.

Must preserve the distinction:

```text
actual event/cause
!=
what Wilson observed
!=
what Wilson later believes caused it
```

## SelectedIntention

Represents the meaningful objective Wilson chose after candidate competition.

Examples:

```text
eat known food
investigate mushroom
continue roof stage
protect food from storm
search for suitable material
```

It is not necessarily a raw animation or one physical action.

## ActionOutcome

Represents the grounded result of executing/advancing an action.

Conceptually needs to support:

```text
actor
semantic action
participants
authoritative physical effects
observable effects
diagnostic feedback
consequence severity
result/timing classification
```

This is the main bridge into learning, project progression and reactions.

---

# 6. Next contracts to define

The next agent should turn the architectural contact map into a minimal **contract catalog**.

Do not jump directly to code structs. First define semantic responsibilities and required/optional information.

At minimum analyze:

### World / perception

```text
WorldEvent
ObservedEvent
PerceptionResult
PerceivedSubject
ObservedChange
```

### Decision

```text
DecisionContext
CandidateIntention
EvaluationContribution
CandidateEvaluation
SelectedIntention
ReconsiderationTrigger
```

### Action

```text
ActionRequest / ActionStep
ActionValidationResult
ActionProgress
ActionOutcome
DiagnosticFeedback
```

### Learning

```text
LearningEvidence
BeliefEvidence
AssociationImpact
HabitEvidence
EpisodeCandidate
PresenceEvidence
```

### Projects

```text
ProjectOpportunity
ProjectContribution
ProjectProgressResult
```

### Player

```text
SuggestionSignal
ValidatedIntervention
InterventionObservation
```

### Director

```text
DirectorContext
TemporaryOpportunity
SceneBias
```

### Presentation

```text
ReactionIntent
SpeechAct
PresentationEvent
```

The exact names may change. Prefer fewer contracts with clear semantics over a large DTO taxonomy.

---

# 7. Game-loop/update-phase work to do next

Refine the provisional loop into explicit phases and ownership rules.

Current direction:

```text
advance simulation time
    ↓
advance world / environment
    ↓
advance slow Wilson state
    ↓
advance current action
    ↓
collect meaningful events
    ↓
check immediate threat
    ↓
check reconsideration triggers
    ↓
if reconsidering:
    perceive
    compute salience
    derive expectations
    generate candidates
    evaluate candidates
    select intention
    resolve/continue action
    ↓
process grounded outcome
    ↓
reaction / causal attribution when relevant
    ↓
learning + memory + habit + project + presence updates
    ↓
presentation projection
```

This should **not** mean every phase runs every rendered frame.

The next agent should explicitly define update frequencies/categories, likely including:

```text
high-frequency action/physical progression
slow simulation state ticks
event-driven cognition/reconsideration
event-driven learning
maintenance/consolidation passes
offline coarse stepping
```

Immediate threat should remain a separate fast-path decision regime rather than a `+infinity` utility contribution.

---

# 8. Reconsideration is central

Wilson should not recompute his entire decision every tick.

Current intention continues unless a meaningful reconsideration trigger occurs.

Candidate triggers include:

```text
intention completed
current action invalidated
meaningful need threshold crossed
major novelty
prediction error / anomaly
player suggestion
noticed player intervention
directed event
immediate threat
project checkpoint
important temporal/context transition
```

The next phase should define:

- trigger semantics;
- coalescing multiple triggers;
- hysteresis/current-intention advantage;
- what may interrupt actions versus only intentions;
- what becomes a suspended intention;
- what is discarded.

Avoid ping-pong between near-equal candidates.

---

# 9. Candidate composition direction

Candidate generation should be compositional rather than centralized branching.

Current candidate-source concepts:

```text
NeedIntentionSource
AffordanceIntentionSource
ProjectIntentionSource
HabitIntentionSource
SuspendedInterestSource
EventIntentionSource
SuggestionIntentionSource
StimulationIntentionSource
```

Evaluation should likewise be compositional:

```text
NeedEvaluator
ProjectValueEvaluator
PreferenceEvaluator
AttachmentEvaluator
CuriosityEvaluator
HabitEvaluator
RiskEvaluator
EffortEvaluator
OpportunityUrgencyEvaluator
SuggestionEvaluator
ContinuityEvaluator
EmotionModifier
DirectorBiasEvaluator
```

These are concepts, not mandatory interfaces/classes.

Do not create interface/factory boilerplate unless genuine variation/testing value exists.

Traits modulate only semantically related evaluations:

```text
curiosity       → information value
risk_tolerance  → perceived-risk inhibition
independence    → suggestion/dependency influence
```

Do not multiply every trait into every final score.

---

# 10. Guards must shape the contract design

Read `GUARDS_AND_CALIBRATION.md` before fixing numeric contracts.

Important constraints:

- normalized states need hard finite bounds;
- normal update curves should saturate before clamping;
- evaluator contributions must have declared finite influence envelopes;
- strong contradictory evidence must remain able to move high-confidence beliefs;
- repeated identical evidence should have diminishing returns;
- no `+999999` score hacks;
- immediate emergency uses a separate regime;
- history-derived extremes are allowed if legitimately earned;
- the health monitor should be read-only by default;
- adaptive runtime control should act only on explicitly whitelisted pacing/opportunity variables.

Do not design contracts that require systems to reach into one another's values to normalize them.

---

# 11. Headless/debug requirements to preserve

The domain must remain runnable without Godot rendering.

Future implementation should support deterministic headless runs with a seeded RNG and enough explanation data to answer:

```text
What candidates existed?
Why did candidate X enter consideration?
What contributions affected each candidate?
Why did Wilson switch or not switch intention?
What did Wilson expect?
What did he observe?
What evidence updated a belief/association/habit?
What guard bounded an update?
```

Debug explanation is a development requirement, not player-facing UI.

Do not design the decision contract as an opaque scalar-only API that destroys these explanations.

---

# 12. Important anti-decisions

Do not silently reintroduce these assumptions:

### Global GOAP as the whole brain

Planning may be useful locally for some intentions, but the architecture does not currently require all behavior to become GOAP goals/plans.

### One universal rational utility

Final comparable tendencies may be numeric, but semantic contributions must remain distinguishable and bounded.

### Every subsystem mutates through an event bus

Events are useful for presentation/logging/analytics. Critical authoritative mutation should follow explicit orchestration/processing order.

### Monolithic `WilsonBrain`

Cognition should be composed into stores/state plus pure/mostly pure services.

### One `System` per psychology noun

Do not create state-owning systems for attention, expectation, surprise, regret, forgiveness, routine, etc.

### Runtime adaptive rewriting of Wilson history

Autocalibration must not silently normalize traits, beliefs, associations, habits, trust, dependency, project progress or memories.

### LLM-generated authoritative world/mental truth

Never required and explicitly rejected.

---

# 13. Suggested concrete deliverables for the next agent

Produce these in order:

## Deliverable A — Contract catalog

For each central contract specify:

- purpose;
- producer;
- consumers;
- authoritative vs observational;
- required semantic fields;
- optional fields;
- lifetime;
- persisted or ephemeral;
- replay/determinism implications;
- examples from representative scenes.

## Deliverable B — Update-phase specification

Define:

- simulation clocks;
- fixed/coarse/event-driven update categories;
- ordering constraints;
- action progress semantics;
- reconsideration timing;
- learning timing;
- project timing;
- maintenance/consolidation timing;
- presentation synchronization;
- offline substitutions.

## Deliverable C — Mutation authority matrix

Rows: state families.

Columns: systems/pipelines.

Mark:

```text
read
propose
mutate
observe only
```

The purpose is to expose hidden circular authority before coding.

## Deliverable D — Decision trace example

Run at least three representative sequences through the proposed contracts/phases:

1. `Scientific Method` — knowledge/partial feedback;
2. `Sabotaged Storage` — anomaly/causal attribution/player relationship;
3. `Brilliant Shortcut` or `Falling Palm` — risk/immediate threat/death.

If the contract design cannot express these cleanly, revise it before implementation.

## Deliverable E — Architecture gate

State explicitly whether the system is ready to move into:

```text
concrete data model
Godot/domain package layout
first implementation vertical slice
```

and list unresolved blockers.

---

# 14. Recommended gate before implementation

Architecture is ready for implementation only when the following are true:

- no central state family has ambiguous mutation ownership;
- `ObservedEvent`, `SelectedIntention`, `ActionOutcome` and learning flow are semantically clear;
- normal vs immediate-threat decision regimes are clear;
- reconsideration/interruption semantics are clear;
- persistent vs derived state is clear;
- update phases do not depend on rendered frame rate;
- deterministic RNG entry points are identified;
- offline stepping has a defined substitution strategy;
- evaluator outputs remain explainable and bounded;
- guards do not rely on hidden cross-system normalization;
- the three decision-trace scenarios work without bespoke architecture hacks.

Only then derive concrete schemas/classes/packages.

---

# 15. Working style for the continuation

Do not optimize for theoretical elegance at the expense of the player-visible scenes.

When an architectural abstraction is proposed, ask:

> Which validated scene or invariant needs this abstraction?

When adding a new state/property, ask:

> What behavior becomes impossible without persisting this?

When adding a new system boundary, ask:

> Does this component own independent authority/lifecycle, or is it merely a calculation that should be composed into an existing pipeline?

When adding adaptive behavior, ask:

> Does this preserve the causal history of the run, or secretly normalize Wilson toward a target?

The project should remain:

> **mathematically bounded, systemically reversible, historically permissive, and behaviorally legible.**
