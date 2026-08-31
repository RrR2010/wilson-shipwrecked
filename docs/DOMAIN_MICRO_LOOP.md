# Canonical Domain Micro-Loop

## Status and purpose

This document is the canonical language-neutral micro-orchestration companion to:

- `DOMAIN_MODEL.md`;
- `DOMAIN_OPERATIONS.md`;
- `DOMAIN_PROCEDURAL_COMPOSITION.md`;
- `SIMULATION_ORCHESTRATION.md`.

It expands the macro simulation loop into semantic **frame groups** and validates the domain against the `Scientific Method` representative scene.

A frame group is not a rendered frame. It is a bounded interval during which the current action/intention semantics remain stable until a meaningful boundary occurs.

This document also closes procedural gaps exposed by the micro-loop. Where terminology here is more specific than older `DOMAIN_OPERATIONS.md` wording, this document owns the refined semantics until those older sections are consolidated.

---

# 1. Why a micro-loop exists

The macro orchestrator answers:

> In what deterministic order do domain owners/services run?

The micro-loop answers:

> What causes Wilson to continue, refine a tactic, reconsider the objective, learn, or branch at this exact semantic boundary?

The game must not run a hidden scene script such as:

```text
if scene == scientific_method:
  pull
  hit_with_wood
  hit_with_stone
  open_container
```

Instead, a recognizable scene must emerge from reusable domain semantics:

```text
persistent intention
+ bounded local action grammar
+ imperfect beliefs
+ grounded physical outcomes
+ immediate evidence/learning
+ tactical reconsideration
+ occasional intentional reconsideration
```

---

# 2. FrameGroup

Conceptual trace type:

```text
FrameGroup
  id: FrameGroupId
  entry_snapshot_ref
  active_intention_ref?
  active_action_ref?
  due_world_progress
  authoritative_results[]
  perception_result?
  immediate_learning_batch?
  trigger_batch[]
  reconsideration_scope?
  selected_tactic_or_intention?
  exit_reason
```

`FrameGroup` is a trace/debug/orchestration concept. It is not required as durable gameplay state.

A frame group ends on a semantic boundary such as:

```text
action completion
action checkpoint
action invalidation
action commitment/consequence boundary
meaningful world event
perceived anomaly
prediction error
new perceptual evidence that changes local options
immediate threat
drive urgency-band transition
major player/director signal
current intention completion
```

Rendering may produce any number of visual frames inside one frame group.

---

# 3. Three cadence/scoping levels

The micro-loop requires three distinct decision scopes.

```text
PHYSICAL_PROGRESSION
TACTICAL_RECONSIDERATION
INTENTIONAL_RECONSIDERATION
```

Immediate threat remains a separate fast-path regime.

## 3.1 Physical progression

Question:

> What happens while the already-started action progresses?

Examples:

```text
approach object
reach
pick up
pull
swing tool
carry
wait for process checkpoint
```

This phase may produce physical mutation and outcomes without running cognition globally.

## 3.2 Tactical reconsideration

Question:

> Given the current intention, what should Wilson try next?

Candidate space remains local to the current intention.

Examples for `investigate/open container`:

```text
inspect visually
shake
pull lid
pull at another angle
strike using nearby wood
strike using nearby stone
inspect dented edge
pause at safe checkpoint
```

## 3.3 Intentional reconsideration

Question:

> Is this intention still worth pursuing compared with Wilson's other concerns?

Examples:

```text
continue investigating container
eat
rest
return to roof project
respond to storm
inspect newly arrived debris
```

Do not run this broad competition after every ordinary failed tool strike.

---

# 4. Critical refinement: truth, attemptability and believed opportunity

Older domain wording can make `physical affordance` ambiguous. The micro-loop requires three explicit layers.

## 4.1 ActionAttemptability

Authoritative, world-owned derivation.

```text
QueryActionAttemptability(action_id, role_binding, PhysicalRuleContext)
→ AttemptabilityResult
```

It answers:

> Can Wilson physically initiate/perform this action form far enough to obtain a grounded result?

It may read:

```text
reach/accessibility
gross role compatibility
grip/interaction possibility
current body constraints
hard authoritative impossibilities
```

It does **not** answer whether the attempt will achieve Wilson's goal.

Examples:

```text
Wilson can pull a sealed lid even if it will not move
Wilson can hit a metal container with a weak stick even if the stick will break
Wilson can try lifting a deceptively heavy object if he can grip and exert against it
```

A hidden resistance/property should usually be resolved by the attempt, not used to erase the attempt before Wilson can learn from it.

## 4.2 ResolutionApplicability

Authoritative action resolution reads the complete physical truth necessary to determine consequences.

```text
attemptable action
+ EffectivePhysicalProfile participants
+ world relations/context
→ ActionOutcome
```

Possible grounded results include:

```text
SUCCESS
PARTIAL
NO_EFFECT
BLOCKED_AFTER_ATTEMPT
FAILURE
```

`BLOCKED_AFTER_ATTEMPT` is semantic shorthand for an attempt that Wilson could initiate but whose hidden/runtime resistance prevented meaningful progression. Implementations may map it into the existing `BLOCKED` classification plus a committed/attempted diagnostic flag rather than adding a public enum if that distinction can be represented unambiguously.

## 4.3 PerceivedTacticalOpportunity

Wilson-relative derivation.

```text
DerivePerceivedTacticalOpportunities(
  current_intention,
  PerceptionResult,
  WilsonCognition
)
→ TacticalOpportunity[]
```

It answers:

> What tactics does Wilson currently believe are plausible/relevant enough to consider?

It may use:

```text
perceived subjects
beliefs
known semantic interactions
category expectations
curiosity/information value
prior outcomes
current intention bindings
```

It must not read hidden effective properties directly.

Therefore these states are all valid:

```text
attemptable + Wilson expects success
attemptable + Wilson is uncertain
attemptable + Wilson expects failure but tests anyway
not goal-effective + Wilson expects success
physically effective + Wilson has not discovered the tactic
```

This distinction is essential for experimentation.

---

# 5. EffectivePhysicalProfile resolution contract

`EffectivePhysicalProfile` must be deterministic, acyclic and traceable.

## 5.1 Resolution layers

For each property/capability, resolve conceptually in this order:

```text
1. material defaults
2. entity-definition authored semantics
3. instance authoritative overrides/condition
4. validated assembly/component derivation
5. validated contents aggregation where property declares it
6. derived capability rules over the resolved properties/configuration
```

Later layers do not mean arbitrary replacement. Each property definition declares its admitted combination policy.

Examples:

```text
mass_class:
  base + contents aggregation

impact_capacity:
  derived from head/handle/binding semantics

covering:
  derived capability from cloth + attached/tensioned configuration
```

## 5.2 PropertyDerivationDefinition

Introduce the authored definition concept:

```text
PropertyDerivationDefinition
  property_id: PropertyId
  input_dependencies: bounded property/relation/slot selectors
  combination_policy: registered bounded semantic policy
  output_domain: declared PropertyValue family
```

Rules:

- no arbitrary executable content callbacks;
- dependency graph is validated at content load;
- cyclic property derivation dependencies are invalid;
- unsupported/missing inputs produce an explicit absent/insufficient result, not silent zero/default coercion;
- derivation provenance is available in debug builds/traces.

## 5.3 Structural graph invariants

Relations used for composition must not create impossible recursive ownership.

At minimum:

```text
part_of graph is acyclic
assembly-slot host/component containment is acyclic
an entity cannot contain itself transitively
mass/content aggregation detects/rejects containment cycles
one component cannot occupy mutually exclusive assembly slots simultaneously
```

This prevents recursive mass, capability and persistence bugs.

## 5.4 Environmental context

Environment should normally mutate/query ordinary authoritative properties/processes rather than invisibly alter `EffectivePhysicalProfile` through an untraceable global modifier.

Preferred:

```text
rain
→ EnvironmentalResponseRule
→ moisture increases
→ EffectivePhysicalProfile reads moisture
```

rather than:

```text
GetEffectivePhysicalProfile silently checks weather and changes every object
```

Context-only semantics such as slope-dependent rolling remain affordance/resolution context, not intrinsic profile state.

---

# 6. Perception and evidence contract

`PerceptionResult` is refined to:

```text
PerceptionResult
  perceived_subjects: PerceivedSubject[]
  observed_events: ObservedEvent[]
  perceptual_evidence: PerceptualEvidence[]
  accessible_environmental_context
```

The distinction is:

```text
PerceivedSubject
  what Wilson can currently locate/identify coarsely

ObservedEvent
  Wilson-accessible projection of something that happened

PerceptualEvidence
  bounded sensory/action evidence about current state/properties/relations
```

Static properties do not require fake `WorldEvent`s merely to become observable.

---

# 7. Evidence accessibility is rule-driven

`EvidenceRuleDefinition` controls what each exploration modality may reveal.

Examples:

## Visual inspection

```text
action.inspect_visual
+ visible target
→ evidence(color)
→ evidence(coarse shape)
→ evidence(surface appearance)
→ evidence(visible components)
```

Does not automatically reveal:

```text
hardness
exact mass
sealed hidden contents
internal attachment strength
```

## Touch

```text
action.touch
→ tactile roughness
→ surface temperature
→ rigidity clue
```

## Lift

```text
action.lift
+ proprioceptive/action feedback
→ mass-class evidence
```

## Shake

```text
action.shake
+ internal response
→ auditory/proprioceptive evidence
→ likely_contains_something proposition evidence
```

Absence of rattle reduces support for movable contents; it does not prove emptiness.

## Strike

```text
relative deformation / breakage / rebound
→ action-feedback evidence
→ relative resistance/material suitability beliefs
```

---

# 8. Evidence accessibility must not imply exact truth

Perceptual evidence carries resolution/quality.

Conceptually:

```text
EvidenceQuality
  DIRECT_HIGH
  DIRECT_COARSE
  INFERENTIAL_STRONG
  INFERENTIAL_WEAK
  AMBIGUOUS
```

These are semantic quality bands, not necessarily public enums; an implementation may represent equivalent bounded dimensions.

Example:

```text
visual metallic appearance
→ likely material = metal-like, medium confidence

wood breaks against target
→ target has higher relative impact resistance, strong confidence
```

Learning decides the proposition scope and confidence mutation. Perception does not write beliefs directly.

---

# 9. Scientific Method fixture

## 9.1 Initial authoritative state

```text
container_42
  material = metal
  sealed = true
  structural_integrity = HIGH
  deformation = LOW

lid_43
  part_of(container_42)
  closure_resistance = HIGH

wood_17
  material = wood
  structural_integrity = MEDIUM
  mass_class = LOW

stone_08
  material = stone
  structural_integrity = HIGH
  mass_class = MEDIUM

inside(note_91, container_42)
```

The container is opaque.

Wilson does not receive these hidden values directly.

## 9.2 Initial Wilson-relative state

```text
stimulation_need = meaningful
hunger_urgency = low
energy_need = low
current intention = none

beliefs may include:
  stone-like objects tend to be hard       medium/high confidence
  pulling lids sometimes opens containers medium confidence
  impacts sometimes open/break containers low/medium confidence
```

---

# 10. FG0 — noticing the object

### World progression

No important mutation.

### Perception

```text
PerceivedSubject(container_42)
PerceptualEvidence:
  visible coarse shape
  gray/metal-like surface appearance
  visible lid/component boundary
```

No evidence for exact hardness, closure resistance or contents.

### Trigger

```text
NOVELTY
+ stimulation relevance
```

### Intentional reconsideration

Candidates may include:

```text
investigate(container_42)
continue previous leisure/routine
gather food
other salient activity
```

If investigation wins:

```text
current intention = investigate/open container_42
```

Possible branch: a stronger hunger/project opportunity wins, leaving the object merely remembered/salient for later.

---

# 11. FG1 — visual inspection

### Tactical opportunities

Under current intention:

```text
inspect visually
approach/touch
pull visible lid
shake if manipulable
```

Select `inspect_visual`.

### Action

Attemptability validates visibility/access and inspection action roles.

### Perceptual evidence

```text
color/appearance
coarse material-like surface
lid boundary
no direct contents visibility because opaque
```

### Learning

Immediate belief evidence may raise confidence that:

```text
container has a separable lid
container surface is metal-like
```

### Exit

Action completes; current intention remains coherent.

Route to `TACTICAL` reconsideration, not broad intentional competition.

---

# 12. FG2 — first pull

### Tactical selection

Wilson selects:

```text
pull(lid_43)
```

because the visible lid + generic prior knowledge make it plausible.

### Attemptability

```text
reachable
can grip/manipulate lid
→ ATTEMPTABLE
```

The hidden `closure_resistance = HIGH` does not filter the attempt.

### Physical progression

```text
grip
apply force
commit attempt
resolve
```

### Outcome

```text
NO_EFFECT
DiagnosticFeedback:
  lid_did_not_move
  exertion_applied
```

### Evidence

```text
ACTION_FEEDBACK:
  ordinary pull insufficient on this instance
```

### Learning-before-next-choice

Update instance-level belief first.

Then emit coalesced trigger:

```text
ACTION_COMPLETION
+ prediction error
```

Route to `TACTICAL` reconsideration.

---

# 13. FG3 — stronger pull / technique variation

Tactical opportunities may include:

```text
pull harder
change angle/bracing
shake
inspect closure
use impact
pause
```

A small technique change can win because continuity and low extra cost remain favorable.

If stronger pull again produces no target movement:

```text
NO_EFFECT
+ exertion increase
+ transient frustration
```

Learning reduces expected value of repeated pulling.

### Escalation check

Do not globally reconsider solely because this second attempt failed.

Escalate to `INTENTIONAL` only if a meaningful condition exists, e.g.:

```text
energy becomes urgent
repeated-failure evidence makes all local tactics implausible
major external event arrives
risk/cost materially changes
```

Otherwise remain tactical.

---

# 14. FG4 — alternative-method search

The tactical generator now sees revised beliefs.

Nearby `wood_17` can become salient as a manipulable object because current intention requires an alternative way to affect the closure.

Important boundary:

- world truth may know wood is too weak;
- Wilson does not;
- candidate generation uses perceived/believed properties.

Candidate tactic:

```text
strike container/lid using wood_17
```

may be selected for experimentation/information value.

---

# 15. FG5 — wood strike

### Attemptability

```text
wood graspable
container reachable
swing can be executed
→ ATTEMPTABLE
```

### Effective profiles

Authoritative resolution derives:

```text
wood effective impact capacity
container/lid effective resistance
```

### Outcome

Example canonical variant:

```text
FAILURE or PARTIAL
wood_17 structural integrity crosses break threshold
container/lid unchanged or negligibly affected
```

Authoritative effects:

```text
Transform/Modify wood_17 → broken/damaged
```

Diagnostic semantics:

```text
material_broke_first
target_resisted_impact
```

### Perception

Wilson observes the broken wood and lack of meaningful lid movement.

### Learning

Strong instance-level evidence:

```text
wood_17 unsuitable for this high-impact use
```

Weaker scoped generalization:

```text
wood-like tools may be less suitable than expected for this target class
```

Do not conclude `all wood useless`.

### Salience consequence

`stone_08` can become newly salient even if it was already physically visible, because revised beliefs increase its contextual relevance.

No world mutation is needed for salience to change.

---

# 16. FG6 — stone tactic

Tactical opportunities include:

```text
inspect stone
strike with stone
inspect container damage
abandon/pause
```

Wilson's category belief about stone hardness makes `strike with stone_08` plausible.

The actual stone profile is still hidden until evidence supports it.

Select the stone tactic.

---

# 17. FG7 — first stone strike

### Attemptability

Valid.

### Authoritative resolution

Example:

```text
stone survives
container/lid deformation increases
closure remains engaged
```

Outcome:

```text
PARTIAL
semantic tag: container_dented
DiagnosticFeedback:
  target_shifted/deformed
  closure_not_released
```

### Immediate evidence/learning

Wilson obtains strong evidence that:

```text
stone-mediated impact affects this target
```

and potentially weaker evidence that:

```text
particular edge/dented region may be vulnerable
```

### Reaction

Transient excitement/surprise may increase; frustration may fall.

### Reconsideration scope

TACTICAL.

The presence of grounded partial progress strongly protects intention continuity.

---

# 18. FG8 — local tactic refinement

This group demonstrates why tactical scope must exist.

Current intention stays:

```text
open/investigate container
```

Current tool may stay:

```text
stone_08
```

Local tactical variants can include:

```text
hit same spot
hit dented edge
change angle
increase force
inspect deformation first
```

The game does not regenerate unrelated `sleep/eat/build roof` candidates unless a broad trigger requires it.

A tactical candidate may bind an authored action to a **target region/semantic interaction point** without requiring arbitrary mesh-level reasoning.

Conceptual bounded reference:

```text
InteractionRegionRef
  host: EntityId
  semantic_region_id: InteractionRegionId
```

Examples:

```text
lid_edge
handle
dented_region
weak_joint
```

These regions are authored/derived semantic affordance targets and presentation adapters may map them to transforms/collision geometry.

Do not require pixel/triangle-level autonomous planning.

---

# 19. FG9 — opening consequence

A later stone strike may satisfy:

```text
sufficient impact
+ vulnerable closure region
+ accumulated deformation/current closure state
```

Authoritative effects may include:

```text
ModifyProperty(container_42, sealed=false)
RemoveRelation(part_of/attached closure relation as appropriate)
MoveEntity(lid_43, resulting position)
```

and WorldEvents such as:

```text
container_opened
lid_detached/moved
```

Committed action consequences resolve before late reconsideration.

Possible grounded variants:

```text
lid hits Wilson lightly
contents spill
contents damaged
container opens cleanly
```

No scene script decides which variant; resolution rules do.

---

# 20. FG10 — reveal and learning

Once open, perception rules may expose previously hidden contents.

```text
PerceivedSubject(note_91)
PerceptualEvidence / observed relation projection:
  item visible inside/open container
```

Learning can strengthen:

```text
impact with sufficiently resistant tool can open this closure kind
```

Operational knowledge becomes known only if the relevant `KnowledgeDefinition` proposition criteria are satisfied.

No discovery lottery occurs after the evidence.

If the container is empty, Wilson learns/ reacts to that instead; the physical opening chain remains valid.

---

# 21. FG11 — intention completion

If the semantic intention was:

```text
open container_42
```

then it completes.

Now an `INTENTIONAL` reconsideration is appropriate because the objective lifecycle changed.

Possible next intentions:

```text
inspect contents
collect useful content
brief celebratory/reactive behavior
rest/eat
return to suspended project
```

A transient reaction may influence the next selection but does not become a permanent mood primitive.

---

# 22. Branch matrix

The canonical trace above is one path, not a required sequence.

## 22.1 Opens early

If a weaker container or stronger wood makes the wood strike sufficient:

```text
FG5 → container opens
```

The later stone groups never occur.

## 22.2 Suspended investigation

At any safe boundary:

```text
hunger becomes urgent
storm begins
major player/director opportunity appears
energy cost rises
```

can route to `INTENTIONAL` reconsideration.

The container intention may become suspended and later re-enter through `SuspendedInterestSource`.

## 22.3 Wrong inference

A rattle or deformation pattern may lead Wilson to an incorrect belief.

Future contradictory evidence must be able to revise it.

## 22.4 Contents damaged

Impact can mutate hidden contents before opening if interaction rules admit force transfer.

Wilson does not learn this until evidence becomes accessible.

## 22.5 Opaque versus transparent variant

Same physical contents, different evidence accessibility:

```text
transparent container
→ visual evidence may expose coarse contents before opening

opaque container
→ requires shake/open/other modalities
```

No separate cognition code path is required.

---

# 23. New bounded semantic primitive: InteractionRegion

The micro-loop exposes one additional low-cost concept useful beyond this scene.

```text
InteractionRegionDefinition
  id: InteractionRegionId
  host_role/type applicability
  semantic categories
  accepted action-role semantics
  optional physical-property projection/overrides
```

Runtime:

```text
InteractionRegionRef(host_entity_id, region_id)
```

Use cases:

```text
lid edge
container handle
weak joint
cutting notch
rope knot
shelter repair point
tool grip
fruit cluster
```

Rules:

- regions are bounded authored/derived semantics, not arbitrary mesh triangles;
- region identity does not require a separate world entity unless it has independent lifecycle/relations;
- presentation maps region IDs to anchors/colliders/transforms;
- physical resolution may use region-local modifiers where content explicitly defines them;
- Wilson must perceive/discover a region before cognition may intentionally target hidden semantic weakness unless the action is exploratory/randomly broad.

This greatly increases procedural tactic variation without requiring general spatial reasoning.

---

# 24. Trigger routing contract

Default routing after a semantic boundary:

| Boundary | Default scope |
|---|---|
| ordinary action checkpoint | none / continue |
| action completes, intention unresolved | TACTICAL |
| useful partial progress | TACTICAL |
| ordinary failed tactic with alternatives | TACTICAL |
| new evidence relevant to current intention | TACTICAL |
| no plausible local tactics remain | INTENTIONAL |
| current intention completes | INTENTIONAL |
| current intention becomes impossible | INTENTIONAL |
| urgent drive-band transition | INTENTIONAL |
| major external opportunity/signal | INTENTIONAL at safe boundary |
| immediate perceptible threat | IMMEDIATE_THREAT |

Multiple triggers in one boundary are coalesced. The strongest required scope wins, except committed physical consequences still resolve first.

---

# 25. Same-chain learning order

For experiments, the normative ordering is:

```text
committed physical resolution
→ authoritative mutation
→ ActionOutcome / WorldEvent
→ PerceptionResult
→ PerceptualEvidence / ObservedEvent
→ immediate relevant LearningProposalBatch
→ owner applies bounded belief/association changes
→ derive tactical opportunities using revised cognition
→ tactical selection
```

This ordering is required for Scientific Method behavior.

Learning that is only maintenance/consolidation may remain deferred, but evidence that materially changes the next tactic must be available before that next tactical decision.

---

# 26. Candidate generation must support information-seeking actions

Exploration requires actions whose value is **information**, not direct goal completion.

Tactical evaluation therefore admits bounded contributions such as:

```text
expected goal progress
expected information gain
cost/effort
perceived risk
continuity
novelty/curiosity
known failure repetition penalty
```

`expected information gain` is derived from uncertainty and available evidence modalities; it is not a persisted curiosity meter per object.

This allows:

```text
inspect before hitting
shake before opening
try a materially different tool after failure
```

without scripts.

---

# 27. Repetition without a generic failure counter

Do not add a universal persisted:

```text
failed_attempt_count(object, action)
```

Ordinary repetition control should derive from:

```text
recent ActionOutcome/episode context
belief that tactic is ineffective
habit/continuity
current execution history
```

A short-lived `DecisionContinuationContext` may carry bounded same-chain tactic history for deduplication and repetition penalties:

```text
DecisionContinuationContext
  intention_id
  recent_tactic_signatures[] // bounded
  recent_outcome_refs[]      // bounded
  started_at
```

It is continuation state for the active intention, not durable autobiographical knowledge.

If repeated failures become narratively important, selected episodes/beliefs preserve the meaningful result.

---

# 28. Trace/debug requirements

A deterministic headless trace for this fixture must answer:

```text
What was authoritative world truth?
Which effective properties were derived and from what provenance?
What could Wilson perceive at each step?
What evidence was direct versus inferred?
Why was an action attemptable even though it failed?
Why did Wilson believe the tactic was plausible?
What physical fact caused the outcome?
Which belief changed and at what scope?
Why did the next decision remain tactical or escalate intentional?
Why did a new object/region become salient?
What RNG stream, if any, selected among valid alternatives?
```

If any answer requires `scene.scientific_method` or an object-pair recipe, the domain regression fails.

---

# 29. Domain completion findings

The Scientific Method micro-loop is expressible after the refinements in this document.

Required domain additions/refinements discovered by the exercise:

```text
FrameGroup                    trace/orchestration concept
ActionAttemptability          authoritative initiation semantics
PerceivedTacticalOpportunity  Wilson-relative tactic semantics
PropertyDerivationDefinition  deterministic effective-profile composition
InteractionRegionDefinition   bounded semantic sub-targets
DecisionContinuationContext   bounded same-intention local history
```

These do not introduce new state-owning systems.

They refine existing boundaries:

```text
World/Action Resolution
Perception
Decision/Reconsideration
Learning
```

---

# 30. Micro-loop gate

The domain passes this fixture when all of the following hold:

- hidden physical truth can make an attempted tactic fail without preventing the attempt;
- Wilson never receives hidden properties directly;
- exploration actions expose modality-specific evidence;
- evidence updates relevant beliefs before the next same-chain tactic decision;
- tactical decisions remain inside the active intention unless escalation criteria are met;
- effective properties/capabilities derive deterministically from material, condition, composition and contents;
- effective-profile derivation is acyclic and traceable;
- semantic sub-targets such as lid edges can be addressed without arbitrary mesh reasoning;
- partial outcomes alter future tactic salience/evaluation;
- broad intentional competition is not run after every physical micro-step;
- scene variation can shorten, suspend, redirect or complicate the canonical sequence without bypass logic;
- no recipe catalog, exploration percentage, scene state machine or omniscient candidate generation is required.

**Result: PASS with the refinements defined above.**
