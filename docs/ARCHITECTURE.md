# Architecture — Systems, Composition and Game Loop

## Status and scope

This document is the first architecture pass derived from the validated functional requirements in:

1. `BEHAVIORAL_MODEL.md`
2. `STATE_REQUIREMENTS.md`
3. `SCENE_VALIDATION.md`
4. `AI.md`
5. `PRODUCT.md`
6. `SIMULATION.md`

Unlike those documents, this one **does discuss architecture**: responsibilities, system boundaries, composition, points of contact, update flow and authority.

It intentionally does **not** lock the project into a specific Godot node tree, ECS framework, GOAP implementation, database/storage engine or serialization format. Those are subordinate implementation choices after the responsibility graph is accepted.

The main architectural goal is:

> Keep authoritative state mutation centralized and explicit, while deriving perception, expectation, scoring and interpretation through composable services that do not own world truth.

Wilson Shipwrecked remains a **simulation rendered as a game**, not game scenes pretending to be a simulation. Authoritative domain logic must remain runnable and testable without loading the 3D presentation.

---

# 1. Core architectural principles

## 1.1 Few systems should own authoritative mutation

Do not create one state-owning runtime system for every psychological concept.

Concepts such as `attention`, `expectation`, `prediction_error`, `emotion`, `causal attribution` and `action tendency` are mostly derived/transient. They should usually be calculated by services/subsystems and only write durable consequences through explicit mutation boundaries.

Prefer:

```text
read authoritative + Wilson-relative context
→ derive candidates/interpretation
→ resolve authoritative outcome
→ emit structured result
→ apply durable consequences through explicit owners
```

Avoid an architecture where every subsystem can freely modify arbitrary Wilson/world state.

## 1.2 Separate authority from interpretation

- The **world** is authoritative about what physically happened.
- **Wilson cognition** is authoritative about Wilson-relative learned/personal state.
- The **player layer** is authoritative about player-side state such as God Power.
- **Presentation** is authoritative only about presentation.
- The **LLM is never authoritative**.

## 1.3 Composition over inheritance

Behavior should arise from orthogonal state and evaluators rather than inheritance trees.

Avoid:

```text
Wilson
  -> CuriousWilson
    -> RiskyCuriousWilson
      -> AngryRiskyCuriousWilson
```

Prefer composed state/services:

```text
TraitProfile
DriveState
BeliefStore
AssociationStore
HabitStore
MemoryStore
IntentionalState
PresenceRelationship
```

plus evaluators that consume those abstractions.

## 1.4 Semantic contracts between systems

Systems should communicate through typed/domain-semantic queries, commands and results rather than directly manipulating one another's internals.

Examples:

```text
PerceptionResult
ObservedEvent
SelectedIntention
ActionOutcome
BeliefEvidence
AssociationImpact
HabitCueOccurrence
ProjectProgressResult
InterventionObservation
```

The exact type representation is an implementation decision. The semantic boundaries are architectural requirements.

## 1.5 Deterministic core

Gameplay randomness must flow through a seeded RNG abstraction. Optional LLM output and visual-only randomness must not become authoritative physical state.

This supports:

- headless simulation;
- reproducible bugs;
- regression scenes;
- statistical calibration;
- comparison of balance changes under identical seeds.

---

# 2. Responsibility map

A useful top-level decomposition is:

```text
┌──────────────────────────────────────────────────────────┐
│                    GAME ORCHESTRATOR                     │
│ simulation time / phases / scheduling / ordering         │
└──────────────────────────────────────────────────────────┘
          │
          ├── World Simulation System
          ├── Wilson Cognition System
          ├── Action Resolution System
          ├── Project System
          ├── Event / Scene Director
          ├── Player Intervention System
          ├── Memory & Learning Pipeline
          ├── Offline Catch-up Policy/Orchestrator
          └── Presentation / Narrative Projection
```

These are responsibility boundaries, not necessarily one-class-per-box or one-Godot-node-per-box.

The critical distinction is between:

```text
STATE-OWNING SYSTEMS
vs
DERIVED / STATELESS SERVICES
```

---

# 3. State-owning systems

## 3.1 World Simulation System

### Owns

Authoritative non-Wilson world truth:

- entity identity/lifecycle;
- authoritative locations/transforms;
- physical and semantic properties/capabilities;
- object transformed forms/state;
- inventory/container truth;
- weather/environment state;
- physical structures and project-built world state;
- authoritative causes/effects.

### Does not own

- Wilson beliefs;
- Wilson preferences/associations;
- Wilson expectations;
- action desirability;
- trust in the unseen presence;
- narrative prose.

### Typical interfaces

Queries:

```text
IWorldQuery
IAffordanceProvider
get_entity_state(...)
get_visible_environment(...)
get_property_truth(...)
```

Commands/results:

```text
apply_validated_action(...)
apply_environment_advance(...)
apply_transformation(...)
```

Outputs:

```text
EntityChanged
EntityCreated
EntityDestroyed
EnvironmentChanged
ActionPhysicalOutcome
```

Domain logic should refer to semantic capabilities such as `container`, `throwable`, `impact_tool`, `flammable`, not concrete assets such as `palm_tree_03.glb`.

---

## 3.2 Wilson Cognition System

This owns durable Wilson-relative state, but should be **internally composed** rather than implemented as one giant `WilsonBrain`.

### Owns

- traits;
- drives;
- associations;
- beliefs/knowledge;
- habits;
- selected episodic history;
- current/suspended intentional state;
- presence relationship.

### Recommended internal composition

```text
TraitProfile
DriveState
AssociationStore
BeliefStore
HabitStore
MemoryStore
IntentionalState
PresenceRelationship
```

No module should directly mutate another module's private state.

Cross-effects should arrive as semantic evidence/update requests through a coordinator/learning pipeline.

Bad:

```text
BeliefStore directly calls HabitStore
HabitStore directly edits AssociationStore
AssociationStore changes trust
```

Preferred:

```text
ObservedOutcome
→ LearningPipeline
    → BeliefEvidence
    → AssociationImpact
    → HabitEvidence
    → EpisodeCandidate
    → PresenceEvidence when applicable
```

Each owner applies only its own mutation.

---

## 3.3 Project System

Projects cross Wilson desire and physical world progress, so this boundary must remain explicit.

### Project System owns

- project instance/lifecycle;
- desired authored/systemic project outcome;
- available semantic contributions/stages;
- project-level progress not already wholly represented by physical entities;
- resource/capability requirements;
- active/paused/completed/abandoned semantics.

### World Simulation owns

The physical result:

- placed supports;
- roof sections;
- damaged table;
- statue structure;
- resulting object properties.

### Wilson Cognition owns

Whether Wilson currently wants to contribute to the project.

Desired interaction:

```text
Project System:
"roof has a valid next contribution using suitable covering"

Cognition:
"Wilson currently considers/chooses that contribution"

Action Resolution:
"the chosen material/action is valid and produces result X"

World:
"the physical roof changed"

Project System:
"project progress/lifecycle updated from the grounded result"
```

This prevents a project manager from becoming a hidden planner controlling Wilson.

---

## 3.4 Player Intervention System

### Owns

- God Power;
- passive non-intervention streak state;
- game-mode intervention permissions;
- suggestion insistence windows/counts;
- validation of player-side intervention requests.

### Responsibilities

- validate supported intervention and cost;
- consume/update God Power;
- convert UI intent into constrained world command or Wilson suggestion;
- never force Wilson's body/action;
- expose intervention consequences to perception only when Wilson could notice them.

Important:

```text
PLAYER PRIVATE INTENT:
"I was trying to help Wilson"
```

must not be passed to cognition.

Wilson receives observable facts such as:

```text
resource appeared unexpectedly
support disappeared
object moved
suggestion signal occurred
```

Trust therefore follows **perceived consequences + attribution**, not player intent.

---

## 3.5 Event / Scene Director

### Owns

- event eligibility/cooldowns;
- rare-event scheduling state;
- active authored scene state;
- scene-specific opportunities/constraints;
- authored premise progression where needed.

### Does not own

- Wilson's final chosen action;
- physical action outcome;
- Wilson beliefs/associations.

Its influence enters cognition through bounded context:

```text
DirectorContext
  → salience contribution
  → temporary candidate source
  → bounded desirability bias
  → opportunity urgency
```

A directed scene may strongly bias Wilson without becoming a cutscene.

---

# 4. Derived / stateless services

These are the strongest candidates for SOLID composition because they answer a question without owning durable truth.

## 4.1 Perception Service

Input:

- authoritative nearby world state;
- Wilson location/orientation/senses;
- current action context.

Output:

```text
PerceptionResult
PerceivedEntity
ObservedChange
```

It decides what Wilson can observe, not what he believes it means.

## 4.2 Salience / Attention Service

Input may include:

- perceived subjects;
- current intention;
- drive relevance;
- novelty;
- attachment;
- threat;
- expectation mismatch;
- opportunity urgency;
- habitual cues;
- selected relevant memories;
- director framing.

Output:

```text
small bounded salient set
```

It should not require permanent salience values for every entity.

## 4.3 Expectation Service

Input:

- beliefs;
- selected history;
- current context;
- recurring patterns/habit knowledge where predictive;
- active project/event context.

Output:

```text
ExpectedState / ExpectedOutcome
confidence
```

Expectation is derived and normally not persistent.

## 4.4 Candidate Intention Generator

Compose multiple sources:

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

Then normalize/deduplicate semantically equivalent candidates.

Input includes the salient set, known interactions, affordances and current durable Wilson state.

Output:

```text
small set of meaningful candidate intentions
```

Key invariant:

```text
physically possible != psychologically considered
```

## 4.5 Intention Evaluation / Competition Service

This should be one of the most composition-heavy parts of the codebase.

Candidate evaluators may include:

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

Each evaluator:

- reads a candidate + bounded evaluation context;
- returns a bounded contribution/annotation;
- does not mutate durable state.

Conceptually:

```text
Candidate
+ EvaluationContext
→ EvaluationContribution[]
→ normalized tendency/distribution
→ stochastic selection among plausible candidates
```

This is preferable to a giant `decide_action()` function.

### Trait composition

Traits modify relevant evaluators rather than entering through one generic personality score:

```text
CuriosityEvaluator reads curiosity
RiskEvaluator reads risk_tolerance
Suggestion/Dependency logic reads independence
```

## 4.6 Causal Attribution Service

Input:

- observed anomaly;
- Wilson-visible context;
- beliefs/history;
- long-term presence belief;
- known actors/opportunities.

Output:

```text
candidate causes
bounded weights/confidence
selected interpretation
```

Semantic candidate classes currently required:

- natural;
- self;
- known actor;
- unknown ordinary;
- unseen presence.

The probability distribution is transient. Durable consequences are recorded through episode/belief/presence updates.

Optional LLM-assisted reweighting can happen here only for eligible ambiguous cases and inside a plausibility envelope.

## 4.7 Reaction / Emotion Service

Input:

- grounded outcome;
- expectation mismatch;
- causal attribution;
- danger belief;
- association;
- current goal relevance.

Output:

```text
short-lived emotion/reaction
behavioral modifiers
presentation/speech intent
```

It should not persist week-long fear/anger bars. Durable consequences are emitted through the learning pipeline.

---

# 5. Action Resolution System

This is a critical authority boundary.

Given a selected semantic intention, it:

1. resolves the next applicable physical/semantic action step;
2. validates authoritative preconditions;
3. reserves participants/resources only where actual action semantics require it;
4. executes/advances the action;
5. applies authoritative physical effects;
6. emits a structured grounded outcome.

### Owns authority over

- whether the physical action is valid;
- authoritative action effects;
- transformations;
- injury/death consequences;
- physical success/partial result/failure.

### Does not decide

- whether Wilson wanted the action;
- what Wilson learns;
- how much Wilson likes the result;
- whether Wilson attributes the result to the player.

Canonical output contract:

```text
ActionOutcome
  actor
  semantic action
  participants
  authoritative effects
  observable effects
  diagnostic feedback
  consequence severity
  timing/result classification
```

`ActionOutcome` is one of the main contact points of the architecture.

---

# 6. Memory & Learning Pipeline

Do not let each physical system independently modify every psychological store.

Preferred post-outcome flow:

```text
ActionOutcome / ObservedEvent
        ↓
Outcome Interpretation
        ↓
Learning Evidence
        ↓
┌─────────────────────────────────────────┐
│ Belief learner                          │
│ Association learner                     │
│ Habit learner                           │
│ Episode recorder/consolidator           │
│ Presence relationship learner           │
│ Project outcome processor               │
└─────────────────────────────────────────┘
```

Each processor returns mutations only for the state it owns.

This prevents architecture such as:

```text
FireSystem edits BeliefStore
FireSystem edits AssociationStore
FireSystem creates memory
FireSystem edits HabitStore
FireSystem edits trust
```

The fire/action code emits grounded facts once; learning translates those facts into Wilson-relative consequences.

---

# 7. Contact map / dependency edges

The system graph should have deliberately few high-value contact points.

## World → Cognition

Through:

```text
PerceptionResult
ObservedEvent
AffordanceQuery
```

Wilson must not read arbitrary authoritative internals.

## Cognition → World

Through:

```text
SelectedIntention
→ Action Resolution
```

Cognition does not mutate entities directly.

## Action Resolution → Learning

Through:

```text
ActionOutcome
```

## Player → World

Through:

```text
ValidatedInterventionCommand
```

## Player → Cognition

Only through:

```text
SuggestionSignal
ObservableInterventionEvent
```

## Director → Cognition

Through:

```text
DirectorContext
TemporaryOpportunity
SceneBias
```

not direct Wilson commands.

## Cognition → Presentation

Through semantic events/intents:

```text
SelectedIntention
ReactionIntent
SpeechAct
```

not hidden-score UI leakage.

---

# 8. SOLID/composition strategy

## 8.1 Depend on stable questions

Useful conceptual ports/interfaces include:

```text
IWorldQuery
IAffordanceProvider
IPerceptionQuery
IExpectationProvider
IIntentionSource
IIntentionEvaluator
IActionResolver
ILearningProcessor
IProjectQuery
IPlayerInfluenceQuery
IRandomSource
```

Names are illustrative. The architectural principle is to depend on abstractions representing a domain question rather than a concrete subsystem implementation.

## 8.2 Evaluator composition

Avoid:

```text
if hungry ...
if curious ...
if project ...
if player suggested ...
if Gerald ...
if storm ...
```

Prefer:

```text
for candidate in candidates:
    contributions = evaluator_set.evaluate(candidate, context)
    candidate.tendency = combiner.combine(contributions)
```

This allows each concern to be independently tested, bounded and calibrated.

## 8.3 Intention-source composition

Candidate generation should be extensible by adding a source rather than editing one universal planner.

A new authored event can provide an `EventIntentionSource`/temporary opportunities without knowing the internals of hunger, habit or project selection.

## 8.4 Learning composition

Learning similarly composes bounded consequence processors:

```text
BeliefLearner
AssociationLearner
HabitLearner
EpisodeRecorder
PresenceRelationshipLearner
ProjectOutcomeProcessor
```

All consume grounded semantic outcome/context.

## 8.5 Randomness injection

All gameplay stochasticity should use an injected seeded random source rather than global random calls.

This is required for deterministic tests and later statistical calibration.

---

# 9. Active-play game loop

The game loop should separate **continuous simulation**, **reconsideration**, **action resolution** and **post-outcome learning**.

Wilson should not rescore the entire world every render frame.

Conceptually:

```text
SIMULATION ADVANCE
│
├─ 1. Advance authoritative world time
│     environment/weather/ongoing physical state
│
├─ 2. Advance slow Wilson state
│     hunger/energy/comfort/stimulation
│
├─ 3. Advance current action/intention
│     simulation progress independent of rendering FPS
│
├─ 4. Collect meaningful events/interrupts
│     action completed
│     target invalidated
│     strong new salient event
│     immediate threat
│     player intervention/suggestion
│     director opportunity
│
├─ 5. Test whether reconsideration is required
│     if no:
│       continue current intention
│     if yes:
│       perceive
│       derive salient set
│       derive expectations/anomalies
│       generate candidates
│       evaluate candidates
│       optionally bounded contextual reweight
│       select intention
│
├─ 6. Resolve next action step when due
│     validate against authoritative world
│     apply grounded outcome
│
├─ 7. Post-outcome processing
│     reaction/emotion
│     causal attribution when relevant
│     learning/memory/association/habit
│     project progress
│     presence relationship update
│
├─ 8. Emit presentation events
│     animation/reaction/speech/diary candidate
│
└─ 9. Continue
```

The orchestrator controls ordering, not domain policy.

---

# 10. Reconsideration instead of constant replanning

Wilson should recalculate a decision on meaningful boundaries such as:

- current intention completes;
- action becomes impossible;
- immediate threat appears;
- a drive crosses a meaningful urgency band;
- strong novelty/anomaly becomes salient;
- director opportunity appears;
- player suggestion/intervention occurs;
- natural action/project checkpoint is reached;
- significant project stage completes;
- sufficient time/context change accumulates.

## 10.1 Hysteresis / intention inertia

Current intention receives continuity bias. A competing intention must exceed it enough to justify interruption, except for immediate threat.

This prevents behavioral thrashing without making actions globally uninterruptible.

---

# 11. Update cadences

Different domains should update at different cadences/event boundaries.

## High-frequency / event-driven

- current physical action progress;
- immediate threat;
- player intervention;
- collision/consequence resolution;
- action validity.

## Decision cadence / event-driven

- perception/salience;
- expectation;
- candidate generation;
- intention evaluation;
- causal attribution.

## Slow cadence

- hunger/energy/comfort/stimulation drift;
- passive God Power generation;
- supported ecology/growth/rot.

## Post-event only

- belief updates;
- association updates;
- habit reinforcement/suppression;
- episode creation;
- presence relationship update.

## Maintenance cadence

- episode consolidation/forgetting;
- habit weakening/disuse;
- weak association drift;
- project salience aging;
- event cooldown/eligibility maintenance.

Concrete frequencies are calibration/implementation choices; the architectural requirement is that these are not all tied to render FPS or one universal tick.

---

# 12. Immediate-threat fast path

Emergencies such as a falling palm should not compete normally with checking the fire or finishing a table.

Conceptually:

```text
ImmediateThreatDetected
→ narrow defensive candidate set
→ evaluate feasibility + learned threat response
→ select/execute rapidly
→ resume normal cognition after danger
```

Relevant traits/knowledge may still affect response, but ordinary low-priority motives are excluded from this path.

This is not a separate `safety` need.

---

# 13. Project flow

Project System should expose contribution opportunities rather than directly scheduling Wilson.

```text
Project System
  exposes valid contribution opportunities
        ↓
Candidate Intention Generator
  creates project-related candidates when salient
        ↓
normal competition
        ↓
selected project intention
        ↓
Action Resolution
        ↓
physical world outcome
        ↓
Project System consumes grounded result
```

This preserves interruptions by hunger, novelty, Gerald, weather, player intervention, etc.

---

# 14. Player intervention flow

Physical/environmental intervention:

```text
Player input
  ↓
permission + cost validation
  ↓
God Power mutation
  ↓
ValidatedInterventionCommand
  ↓
World authoritative mutation
  ↓
Perception determines whether Wilson notices
  ↓
if noticed:
  anomaly / attribution
  reaction
  learning / presence relationship
```

Suggestion:

```text
Player suggestion
  ↓
SuggestionSignal
  ↓
SuggestionIntentionSource / SuggestionEvaluator
  ↓
normal Wilson competition
  ↓
normal action validation
```

Suggestions never bypass Wilson choice or world legality.

---

# 15. LLM contact points

The LLM adapter stays outside authoritative systems.

Allowed contacts:

```text
CausalAttributionService
  optional bounded reweight of valid hypotheses

IntentionCompetition
  optional bounded reweight for explicitly eligible ambiguous cases

NarrativeProjection
  speech/thought/reaction wording

DiaryProjection
  structured episode → Wilson prose

RareSceneEmbellishment
  choose among grounded authored variants
```

Every path has deterministic fallback. The authoritative simulation must not materially block waiting for an LLM request.

---

# 16. Offline catch-up

Offline simulation should reuse normal domain semantics under a conservative policy rather than become a contradictory second game.

Conceptually:

```text
elapsed offline time
  ↓
Offline Policy
  chooses allowed domains/outcome classes
  ↓
coarse time/event stepping
  ↓
world + drives + ordinary projects + ordinary learning
  ↓
forbid death / rare spectacle / major discovery
  ↓
structured catch-up history
```

The Offline Policy is a guard around the normal domain systems.

It should suppress forbidden outcome categories rather than require every subsystem to contain completely separate offline logic.

---

# 17. Presentation boundary and Godot

Godot presentation consumes semantic simulation output and maps domain IDs to scene objects.

Presentation responsibilities include:

- navigation realization;
- animation;
- sound;
- particles;
- camera;
- UI;
- visual interpolation;
- speech/text presentation.

Presentation must not create hidden simulation facts.

Conceptual scene responsibility remains approximately:

```text
Main
├── WorldPresentation
│   ├── Terrain
│   ├── EntityViews
│   ├── Navigation
│   ├── Effects
│   └── LightingWeather
├── CharacterPresentation
├── CameraRig
├── InteractionUI
└── Application / Simulation Host
```

Exact Godot node layout may evolve.

Domain entity IDs must map explicitly to presentation nodes rather than relying on scene-tree paths as game identity.

Animation duration may influence action timing only through an explicit timing contract; animation code must not decide physical outcome.

---

# 18. Persistence/save boundary

Persist authoritative and Wilson-relative durable state, not every derived service cache.

Must preserve conceptually:

- world authoritative state;
- traits;
- drives;
- associations;
- beliefs;
- selected episodes;
- habits;
- meaningful current/suspended intention;
- projects;
- presence relationship;
- player/God Power state;
- director/event state required to avoid duplication/incoherence;
- deterministic RNG/seed state as required.

Normally reconstruct:

- salience;
- expectations;
- candidate sets;
- evaluator contributions;
- causal probability distributions;
- prediction-error scores;
- most transient emotion/reaction state.

For a save in the middle of a visible scene, preserve only enough action/intentional state to resume coherently rather than serializing arbitrary service internals.

---

# 19. Dependency direction

A useful dependency rule is:

```text
Domain state + semantic contracts
        ↑
Pure evaluation/domain services
        ↑
Application/game orchestration
        ↑
Godot / persistence / LLM / external adapters
```

Invariants:

```text
World truth does not depend on Wilson belief.
Action resolution depends on world queries, not cognition internals.
Cognition sees observations/semantic world queries, not rendering nodes.
Presentation depends on domain output, not vice versa.
LLM adapters are outer-layer dependencies.
Persistence format does not define domain semantics.
```

---

# 20. Testing architecture

The design should support four levels.

## 20.1 Pure service tests

Examples:

- expectation inference;
- intention evaluator contributions;
- causal attribution weighting;
- habit reinforcement/extinction;
- belief-confidence update;
- association update.

## 20.2 System contract tests

Examples:

- Action Resolution never mutates beliefs directly;
- suggestion never bypasses Wilson selection;
- Project System never executes Wilson actions;
- LLM failure never changes authoritative physical result;
- player private intent never reaches trust evaluation.

## 20.3 Representative scene regression

Use catalog scenes as scenario fixtures where practical:

- Good Chair;
- Scientific Method;
- Missing Spoon;
- Benefactor;
- Roof or Table?;
- Mushroom;
- Sabotaged Storage;
- Falling Palm;
- Brilliant Shortcut.

Assertions should target valid distributions/state consequences rather than exact scripted action sequences.

## 20.4 Headless statistical simulation

Run many seeds/days and observe:

- action distribution;
- idle/stagnation frequency;
- repeated-action lock-in;
- belief-confidence saturation;
- association/attachment saturation;
- habit strength distribution;
- dependency growth/recovery;
- project completion/abandonment;
- risk/death rate;
- rare scene frequency/break rate;
- God Power generation/spending;
- behavioral diversity between Wilson seeds.

This level becomes the feedback source for the next guard/self-calibration design pass.

---

# 21. Architectural anti-patterns

## Giant WilsonBrain

One object that reads every store, produces every candidate and contains every special case will be impossible to calibrate safely.

## Every concept as a mutable System

Derived concepts do not become state-owning systems merely because they have names.

## Cross-store mutation

Belief code must not directly rewrite habit/project/trust state.

## Pair-specific interaction explosion

Do not regress from property/effect semantics to bespoke object-pair recipes where generic semantics suffice.

## Universal planning hierarchy

The validated model does not require a universal GOAP task tree. Planning can be introduced only where an intention genuinely needs multi-step action resolution; it should not become the definition of Wilson cognition.

## Presentation authority

Animation, UI and LLM must not determine world truth.

## Global utility god-object

Avoid one hardcoded score function containing every concern. Use evaluator composition and explicit bounded contributions.

## Unbounded global event bus

Events are useful, but a global publish/subscribe channel where arbitrary subscribers mutate arbitrary state becomes hidden coupling. Prefer typed/scoped events and explicit owners/processors.

---

# 22. Recommended first implementation seams

Prototype these seams before committing to detailed class/data architecture because they carry the most integration risk:

1. `WorldQuery + AffordanceProvider`
2. `Perception → Salience`
3. `IIntentionSource[] → CandidateSet`
4. `IIntentionEvaluator[] → bounded contributions → stochastic selection`
5. `SelectedIntention → ActionResolution → ActionOutcome`
6. `ActionOutcome → LearningPipeline → durable updates`
7. `Project opportunity → normal intention competition`
8. `Player intervention → observed anomaly → attribution → presence relationship`
9. save/load reconstruction of derived state
10. seeded headless game loop

If these boundaries stay clean, most future growth should be achievable through composition rather than rewrites.

---

# 23. Next design pass: guards and self-calibration

The next architecture/design pass should define **bounded update contracts and systemic guards** so composition cannot create runaway state or monopolistic behavior.

It should cover at least:

- saturation/diminishing returns;
- bounded evaluator contributions;
- probability normalization and plausibility floors/ceilings;
- belief-confidence ceilings and contradiction handling;
- association/attachment saturation;
- habit lock-in prevention;
- dependency runaway prevention;
- stimulation versus habit anti-stagnation;
- project monopolization prevention;
- event/director cooldowns and quotas;
- episodic-memory growth/consolidation budgets;
- offline delta caps;
- God Power caps/economy stability;
- stochastic exploration bounds;
- death/risk-frequency guards;
- headless metrics and target distributions;
- which parameters may self-adjust safely and which must remain authored/calibrated.

The guard layer should **bound and stabilize existing systems**, not become a second opaque AI that silently rewrites Wilson's personality or physical world rules.
