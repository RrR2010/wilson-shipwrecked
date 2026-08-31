# Functional Domain Model

## Status and purpose

This document is the canonical **language-neutral functional domain model** for Wilson Shipwrecked.

It defines aggregates/ownership, semantic identities, authoritative versus Wilson-relative state, action/composition/cognition/project/director/player concepts and persistence-relevant boundaries. It intentionally does not mandate implementation language, Godot node/resource layout, database technology, exact formulas or serialization syntax.

`DOMAIN_VOCABULARY.md` owns normalized terminology; `DOMAIN_OPERATIONS.md` owns public operation semantics; `DISCOVERY_STATUS.md` records the currently implemented/proven subset.

---

# 1. Domain boundaries

```text
Run
├── World
│   ├── entities / places / relations
│   ├── environment / weather / time / physical processes
│   ├── WilsonBody
│   └── shallow non-Wilson actor runtime state
├── WilsonCognition
├── Projects
├── Director
├── PlayerRunState
└── ActionExecution

PlayerProfile
├── LegacyKnowledge
├── DiaryArchive
├── LifetimeStatistics
└── GlobalUnlocks
```

Derived services do not own durable truth:

```text
Perception / PerceptionAccess
Salience / Expectation
EffectivePhysicalProfile / AssemblyValidity
Affordance / ActionAttemptability
Candidate generation/evaluation
Hazard / protection projections
Causal attribution / investigation
Reaction
Learning proposal derivation
Luck
```

Every durable family has one normal mutation owner. Services return semantic results/proposals rather than acquiring store authority.

---

# 2. Identity and references

Domain identity never depends on Godot nodes, scene paths, display strings or asset filenames.

Representative typed IDs:

```text
EntityId / EntityTypeId
PlaceId / RegionId
PropertyId / CapabilityId / CategoryId
RelationTypeId
ActionId
InteractionRuleId / TransformationId
AssemblyDefinitionId / AssemblySlotId / AssemblyRoleId
KnowledgeId / SemanticIntentionId
ProjectDefinitionId / ProjectInstanceId
EventDefinitionId
DirectedEventDefinitionId / DirectedEventInstanceId
ActorProfileId
RunId / EpisodeId / ActionExecutionId
DecisionId / OutcomeId / ObservationId / LearningBatchId
```

## DomainSubjectRef

Broad Wilson-relative semantic subject family:

```text
Wilson
Presence
Entity(EntityId)
EntityType(EntityTypeId)
Category(CategoryId)
Place(PlaceId)
Region(RegionId)
Project(ProjectInstanceId)
SemanticConcept(SemanticConceptId)
```

## RuntimeWorldRef

Narrow physical runtime family:

```text
Wilson
Entity(EntityId)
Place(PlaceId)
Region(RegionId)
```

Physical operations reject non-world subject kinds rather than coercing them.

---

# 3. Core values and property schema

## Bounded numeric values

Conceptual families include:

```text
UnitInterval   [0,1]
SignedUnit     [-1,+1]
Probability    [0,1]
FiniteScalar   finite numeric
NonNegative    finite >= 0
Duration       finite >= 0
```

NaN, infinity and giant sentinel priorities are invalid.

## PropertyValue

Authoritative semantic properties/qualifiers use bounded scalar/symbol/typed-ID values, not arbitrary executable/container values.

Conceptually:

```text
BoolValue
Int/ScalarValue
OrderedGradeValue
SemanticIdValue
```

`PropertyDefinition` declares a property's admitted value family and optional bounds. Numeric semantic identity must not change merely because persistence reconstructs `3` as `3.0`.

Current structural implementation proves NUMBER / BOOLEAN / SYMBOL schema families; the model may admit stronger typed value wrappers later without changing ownership semantics.

---

# 4. Definition versus runtime occurrence

```text
EntityDefinition            != EntityInstance
ActionDefinition            != ActionExecutionState
ProjectDefinition           != ProjectInstance
EventDefinition             != WorldEvent
DirectedEventDefinition     != DirectedEventInstance
InteractionRuleDefinition   != resolved interaction
AssemblyDefinition          != AssemblyBinding projection
```

Definitions describe semantic possibility. Instances/events/executions describe current/run occurrences.

---

# 5. World aggregate

World owns authoritative physical facts.

Conceptually:

```text
WorldState
  simulation_time
  entities
  places / coarse placement
  relations
  environment / active physical processes
  actors
  WilsonBody
```

Wilson cognition may contain incomplete/wrong beliefs about any perceivable subset.

## EntityDefinition

```text
EntityDefinition
  id: EntityTypeId
  categories: Set<CategoryId>
  base_properties: Map<PropertyId, PropertyValue>
  capabilities: Set<CapabilityId>
  intervention_capabilities: Set<InterventionCapabilityId>
  anchors: Set<AnchorId>
  actor_profile_id?: ActorProfileId
```

Not every implementation slice must materialize every optional field before representative content requires it.

## EntityInstance

```text
EntityInstance
  id: EntityId
  type_id: EntityTypeId
  place_id: PlaceId
  transform?: SpatialTransform
  state_overrides: Map<PropertyId, PropertyValue>
  quantity?: NonNegative
  lifecycle
```

Effective direct lookup:

```text
instance override
?? authored base value
?? absent
```

The current structural foundation treats `place_id` as authoritative coarse placement. Fine `SpatialTransform`/navigation remains an outer spatial adapter concern until required.

## Place / region

Stable semantic places support spatial history and coarse access without persisting arbitrary coordinate snapshots in cognition.

## WorldRelation

```text
WorldRelation
  type: RelationTypeId
  subject: RuntimeWorldRef
  object: RuntimeWorldRef
  qualifier?: PropertyValue
```

Exact identity includes the qualifier:

```text
type + subject + object + qualifier
```

Therefore two admitted edges may share endpoints while differing by qualifier. Broad query identity and semantic admissibility/cardinality are separate concerns.

Examples:

```text
inside(item, container)
on_top_of(spoon, rock)
attached_to(component, host, AssemblySlotId)
part_of(lid, container)
held_by(item, Wilson, hand_slot)
```

Relations are World truth. Wilson may believe differently.

## Containers / carried state

Use capabilities/properties + relations rather than a universal inventory owner.

---

# 6. Wilson body

Wilson cognition is not authoritative about his physical body.

```text
WilsonBodyState
  alive
  vitality
  exertion
  wetness
  mobility
  conditions[]
```

Grounded World/action effects mutate body truth. Cognition perceives/interprets accessible consequences.

`hunger`, `energy`, `comfort`, `stimulation` remain motivational drives rather than replacements for physical condition.

Death derives from grounded body/world consequences. Resurrection applies product rules while preserving only admitted cognitive/run state.

---

# 7. Non-Wilson actors

Animals need only shallow autonomous continuity unless future scenes prove otherwise.

```text
ActorProfileDefinition
  behavior capabilities/rules
  persistence class

ActorRuntimeState
  entity_id
  profile_id
  current_activity?
  target?
  bounded transient state
```

Gerald's emotional/psychological meaning lives in **Wilson's** cognition, not Gerald's actor state.

---

# 8. Environment and dynamic processes

```text
EnvironmentState
  weather
  daylight_phase
  active_environmental_processes[]
```

Reusable process examples:

```text
fruit_ripening
food_spoilage
wet_item_drying
fire_fuel_consumption
storm_weakening_palm
wave_washing_object
wind_moving_loose_object
```

These are world evolution rules, not authored scene scripts.

Committed process progression must remain distinct from unresolved future consequences such as which target a falling/moving object may later hit.

---

# 9. Action grammar

## ActionDefinition

```text
ActionDefinition
  id: ActionId
  roles
  requirements: RequirementPredicate
  interruption_class
```

Actions are reusable verbs, not target-specific recipes.

Current coarse interruption classes are:

```text
PRE_COMMIT_ONLY
NEVER
ANYTIME
```

- `PRE_COMMIT_ONLY`: interruptible before commit only;
- `NEVER`: no ordinary interruption;
- `ANYTIME`: execution tail may terminate even after commit, but committed truth is never rewound.

If later behavior requires named safe checkpoints, extend interruption semantics explicitly rather than encoding hidden timing hacks.

## RoleBinding

```text
role_id → RuntimeWorldRef / admitted domain ref
```

Candidate binding may be partial during discovery; action start requires the roles needed by the definition/resolution.

---

# 10. Predicate and interaction grammar

Eligibility/applicability uses validated typed predicates, not authored executable callbacks.

Representative families:

```text
HasCapability
HasCategory
PropertyExists / PropertyCompare
RelationExists / RelationAbsent
SpatialCondition
Body / Environment conditions
Belief / Knowledge conditions
Association / Habit / Drive / Presence conditions
Project / DirectedEvent lifecycle conditions
RegisteredDomainPredicate (bounded extension)
AllOf / AnyOf / Not
```

Physical legality must not depend on hidden cognition.

## InteractionRuleDefinition

```text
Action + semantic role requirements
+ capabilities/properties/relations/context
→ grounded semantic outcome
```

Not:

```text
specific object pair → bespoke recipe
```

## ActionResolutionDefinition

Binds an action to duration/commit point/effects and one typed `EventDefinitionId` describing the committed occurrence kind.

---

# 11. Effects, commit and WorldEvent

Authoritative effect families may include:

```text
entity lifecycle
property mutation
relation mutation
spatial mutation
quantity mutation
body mutation
environmental-process mutation
```

There is no generic `execute_script` effect.

A `WorldEvent` is **not** an effect. It is emitted only after authoritative owner commit succeeds.

Canonical causal boundary:

```text
ActionExecution crosses commit point
→ ActionOutcome (effects + EventDefinitionId)
→ World owner validates/apply effects
→ SemanticChangeSet for derived maintenance
→ WorldEvent authoritative fact
```

Supported effect batches must be validated as a prospective ordered batch before mutation so a contradictory later effect does not intentionally leave earlier mutation behind.

`SemanticChangeSet` exists for reconstructible invalidation, not as a generic gameplay event bus.

---

# 12. Transformations

```text
TransformationDefinition
  id
  source_requirements
  trigger outcome semantics
  result EntityTypeId
  transfer policy
```

The generic interaction decides what happened physically; the transformation describes how a particular content form changes.

Transfer policy explicitly controls location, quantity, selected relations/history continuity and whitelisted state. Do not copy arbitrary state wholesale.

---

# 13. Effective physical semantics and assembly

## EffectivePhysicalProfile

Derived physical view over authored/base state, instance condition, composition and contents.

It is reconstructible and never reads Wilson cognition.

## PropertyDerivationDefinition

Validated DAG rule using bounded selectors + registered policy to produce a typed property.

Current proven selector families:

```text
self.property
assembly_slot(slot_id).property
```

## AssemblyDefinition

```text
AssemblyDefinition
  id
  slots[]

AssemblySlotDefinition
  id
  semantic_role
  accepted_component_predicate
  cardinality
  optional
```

Runtime assembly truth remains ordinary World relations, commonly:

```text
attached_to(component, host, qualifier = AssemblySlotId)
```

`AssemblyBindingProjection` derives bindings; `AssemblyValidity` derives configuration validity.

```text
VALID
INCOMPLETE
INCOMPATIBLE_COMPONENT
BROKEN_BINDING
INVALID_CONFIGURATION
```

Validity is not quality. Component degradation can reduce `impact_capacity`, `stability`, `coverage`, etc. while configuration remains `VALID`.

## Composition dependency

Component changes may invalidate dependent host profiles through a reconstructible `CompositionDependencyProjection`.

---

# 14. Affordance / attemptability

An affordance/attemptable action means physically enactable enough to consider/attempt, not that Wilson wants it and not that it will achieve his goal.

Candidate discovery is locally bounded; never enumerate global entity × action × entity products.

Authoritative `ActionAttemptability` is separate from Wilson-relative `PerceivedTacticalOpportunity`.

---

# 15. Wilson cognition aggregate

```text
WilsonCognitionState
  traits
  drives
  beliefs
  associations
  habits
  episodes
  intentions
  presence
```

## Traits

```text
curiosity
risk_tolerance
independence
```

Stable dispositions, not ordinary learned state.

## Drives

```text
hunger urgency
energy need
discomfort
stimulation need
```

Higher values mean stronger motivational pressure.

## Typed epistemic model

`BeliefStore` contains `BeliefEntry`s keyed by typed Wilson-relative claims.

```text
BeliefProposition
  claim: EpistemicClaim

BeliefEntry
  proposition
  confidence
  evidence/provenance summary
```

Current closed structural claim algebra:

```text
PROPERTY(subject, PropertyId, PropertyValue)
RELATION(subject, RelationTypeId, object)
EVENT(subject, EventDefinitionId, perceived_role)
```

Durable identity must be deterministic/persistence-stable and cannot fall back to arbitrary `predicate + Variant arguments` serialization.

Future epistemic concepts such as explicit causal claims may be added as new typed claim kinds only when representative reasoning requires them.

### Expectations

Expected arrangements/locations are Wilson-relative relation/property claims with confidence, not duplicate World relations or an ownership/routine primitive.

### Knowledge

`KnowledgeDefinition` is authored metadata satisfied by typed belief patterns/confidence. `KnowledgeId` never creates a second epistemic truth store.

## Associations

```text
subject
valence: SignedUnit
attachment: UnitInterval
```

## Episodes

Persist selected meaningful Wilson-accessible history only, with subject/event/context/importance and provenance sufficient for resurrection rules.

## Habits

Bounded cue → semantic-intention bias. Habits are not commands.

## PresenceRelationship

```text
presence_belief: UnitInterval
trust: SignedUnit
dependency: UnitInterval
```

Player-private intent never mutates these directly.

---

# 16. Perception and evidence boundary

```text
WorldEvent / current World truth
→ PerceptionAccess
→ ObservedEvent / PerceptualEvidence
→ Wilson learning/decision
```

`EventDefinition` describes an ordinary WorldEvent kind's potentially perceptible roles/modalities and bounded baseline confidence.

Actual access is runtime/spatial/observer-relative.

Current evidence contract:

```text
PerceptualEvidence
  EpistemicClaim
  confidence
  source execution
  modality
```

Only accessible roles/semantics enter claims. Hidden bindings/provenance do not leak into cognition.

Static property/relation discovery may create typed claims directly through future modality/evidence rules without fake WorldEvents.

---

# 17. Intentions and decision state

```text
IntentionalState
  current?
  bounded suspended intentions
```

An intention is a purposeful semantic objective; an action is concrete execution toward it.

Candidate sources may include drives, known interactions, exploration, habits, projects, suspended interests, player suggestions, Director opportunities and transient reactions.

Derived candidates/evaluations are not canonical save state.

Decision regimes remain:

```text
IMMEDIATE_THREAT
TACTICAL
INTENTIONAL
```

Immediate threat is separate rather than represented by extreme utility values.

---

# 18. Projects

```text
ProjectDefinition
  eligibility
  contribution patterns
  completion condition
  abandonment policy

ProjectInstance
  id / definition_id
  lifecycle
  subject bindings
  bounded metadata
```

Physical structure truth remains World-owned. Projects update only from grounded outcomes/contributions.

---

# 19. Event / Director domain

Do not overload `EventDefinition`.

- `EventDefinition` = ordinary WorldEvent semantic/perceptual kind.
- `WorldEvent` = authoritative occurrence fact.
- `ObservedEvent` = Wilson-accessible projection.
- `DirectedEventDefinition` / `DirectedEventInstance` = Director-owned opportunity lifecycle.

Director-owned opportunities may introduce world content or bounded candidate bias through normal contracts but never force Wilson's final intention or directly rewrite psychology.

---

# 20. Player suggestions and interventions

## Suggestion

```text
SuggestionSignal
→ bounded contribution to normal decision competition
→ ordinary physical validation
```

It is never a command.

## Intervention

```text
PlayerInterventionRequest
→ permission/capability/cost validation
→ explicit transaction
→ World mutation
→ WorldEvent
→ Wilson cognition only if perceivable/inferable
```

God Power amount does not itself create new intervention capabilities.

---

# 21. Player profile, Legacy and Diary

`PlayerProfile` is outside active Run state.

```text
legacy KnowledgeIds
diary/archive
lifetime statistics
global unlocks
```

Legacy may seed operational knowledge into a new Wilson through authored typed belief criteria but does not transfer episodes, personal relationships, Presence state, habits, death facts or autobiographical source history.

Diary player-level archive and Wilson-flavored narrative remain distinct where omniscient metadata would violate Wilson accessibility.

---

# 22. Luck

Luck is a derived bounded chance-favorability query, not a Wilson trait/drive.

It may bias only declared unresolved random alternatives. It cannot create eligibility, alter Wilson decision scores, reverse committed physics or become directly visible as a numeric cognition fact.

---

# 23. ActionExecution state and causality

Conceptually:

```text
ActionExecutionState
  execution_id
  action definition
  resolution definition
  RoleBinding snapshot
  elapsed/progress
  committed
  outcome_emitted
  completed
  interrupted
```

Committed outcome emits exactly once. `completed` and `interrupted` are terminal; cleanup is explicit/separate.

Persistence reconstruction restores causal state and does not rerun current attemptability to rewrite history.

---

# 24. Persistence model

Persist durable causes/minimal active lifecycle state. Rebuild reconstructible indexes/projections/caches.

Conceptually persist:

```text
World authoritative state
Wilson durable cognition
Current/suspended intentions where justified
ActionExecution causality needed for continuity
Projects
Director continuity
PlayerRunState / PlayerProfile
required deterministic RNG state
```

Normally reconstruct:

```text
relation indexes
PropertyDependencyGraph runtime caches
CompositionDependencyProjection
EffectivePhysicalProfile
AssemblyValidity
protection/hazard projections
EpistemicGraphProjection
salience/expectations/candidate evaluations
```

Development schema/version details live in `DISCOVERY_STATUS.md`.

---

# 25. Seeded randomness

Gameplay randomness uses injected deterministic semantic streams, e.g. world generation, decision selection, Director events, actor behavior, luck-sensitive resolution and Legacy selection.

Presentation randomness is separate and must not perturb gameplay RNG order.

---

# 26. Content registries / bootstrap

Validated immutable content includes the semantic definitions required by implemented/next systems.

Bootstrap rejects duplicate/missing references, property type/bound violations, unsupported policies/selectors, malformed predicates, dangling action/event references, graph cycles, non-finite values and illegal extension callbacks.

The current content-loading implementation proves properties, entities, ordinary event definitions, actions/resolutions, assemblies and property derivations can load from a bounded versioned authored pack before registry sealing.

Serialization syntax is infrastructure and does not define domain meaning.

---

# 27. Scene-driven invariants

Representative scenes require at least:

1. body truth separate from cognition;
2. places/relations as first-class semantic world subjects;
3. persistent animal identity without deep animal psychology;
4. reusable environmental processes rather than scene scripts;
5. partial/failure action feedback usable as evidence;
6. directed events as opportunities, not Wilson commands;
7. containers/assemblies as World relation/composition truth;
8. explicit action commitment;
9. composition-dependent invalidation;
10. typed observation/belief identity without hidden truth leakage.

---

# 28. Explicit anti-models

Do not implement:

```text
Dictionary<String, Variant> as universal semantic identity
object-pair recipe tables as generic crafting
large entity-type switch chains for reusable physics
full autobiographical memory
Wilson-level psychology for every animal
full rigid-body realism as prerequisite for semantic interaction
Director scripts commanding Wilson
presentation callbacks committing domain outcomes
persistence repair inventing domain truth
Luck as permanent Wilson stat
candidate utility/salience as canonical save state
AssemblyStore duplicating World bindings
EverythingGraph as authority
```

---

# 29. Domain gate

The structural functional model and concrete structural runtime foundation have passed their current regression gates.

Further work should add system breadth through these owners/contracts. A new primitive or owner is justified only when representative behavior cannot be expressed cleanly by existing composition and the conflict is promoted into the appropriate canonical document.
