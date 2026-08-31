# Normalized Domain Vocabulary

## Status and purpose

This document is the canonical glossary and taxonomy for the language-neutral functional domain model.

It normalizes terms used by `DOMAIN_MODEL.md`, `DOMAIN_OPERATIONS.md`, `DOMAIN_SCHEMA.dbml` and the domain regression artifacts so implementation does not accidentally create multiple primitives for the same concept or one generic primitive that hides several different responsibilities.

The goal is not to maximize terminology. It is to establish a small, orthogonal vocabulary with explicit semantic boundaries.

---

# 1. Naming rules

Use these suffixes consistently:

- `Definition` — authored/static semantic content;
- `State` — mutable durable state owned by one aggregate;
- `Instance` — one runtime occurrence/identity;
- `Ref` — stable reference to another domain subject/concept;
- `Spec` — declarative instruction/constraint that is not itself runtime truth;
- `Predicate` — pure boolean condition over a declared evaluation context;
- `Effect` — requested/resolved mutation of authoritative state;
- `Event` — semantic fact that a mutation/occurrence happened;
- `Evidence` — owner-specific proposal derived from observations/outcomes;
- `Query` — pure read/derivation without mutation or RNG;
- `Command` — request to one owner to validate and mutate its own state;
- `Result` / `Outcome` — returned semantic consequence of an operation;
- `Projection` — observer/presentation-specific view of state/facts.

Do not use `Data`, `Info`, `Context`, `State` or `Event` as generic catch-all names when a narrower semantic term exists.

---

# 2. Reference taxonomy

## 2.1 DomainSubjectRef

`DomainSubjectRef` is the normalized reference type for anything that can be the subject/object of a relation, belief, association, event, intention role or project binding.

```text
DomainSubjectRef =
    Wilson
  | Presence
  | Entity(EntityId)
  | EntityType(EntityTypeId)
  | Category(CategoryId)
  | Place(PlaceId)
  | Region(RegionId)
  | Project(ProjectInstanceId)
  | SemanticConcept(SemanticConceptId)
```

Rules:

- `Wilson` is explicit; do not encode Wilson as a magic `EntityId` in cognitive contracts;
- `Presence` is explicit because it is a relationship subject even though it is not an authoritative world entity;
- runtime instance refs and semantic/type refs may share the union, but consumers must declare which variants they accept;
- a predicate/operation must reject unsupported ref variants rather than silently coercing them.

`SubjectRef` is deprecated as an ambiguous alias; use `DomainSubjectRef`.

## 2.2 RuntimeWorldRef

Physical world mutation/query operations use the narrower subset:

```text
RuntimeWorldRef =
    Wilson
  | Entity(EntityId)
  | Place(PlaceId)
  | Region(RegionId)
```

`EntityType`, `Category`, `Presence`, `Project` and abstract concepts are not mutable physical instances.

## 2.3 SemanticConceptId

`SemanticConceptId` names a non-entity semantic concept when no stronger typed ID exists.

Use it sparingly for bounded vocabularies such as:

```text
condition.burned_hand
activity.roam
concept.unseen_agent_response
```

If a concept gains a stable domain family, introduce a typed ID (`ConditionId`, `ActivityId`, etc.) rather than expanding a universal semantic string namespace indefinitely.

---

# 3. Identity taxonomy

Keep identity families distinct:

```text
Definition IDs:
  EntityTypeId
  ActionId
  InteractionRuleId
  TransformationId
  KnowledgeId
  ProjectDefinitionId
  EventDefinitionId

Runtime IDs:
  EntityId
  ProjectInstanceId
  EventInstanceId
  RunId
  EpisodeId
  IntentionId
  ActionExecutionId

Causal/trace IDs:
  SimulationStepId
  DecisionId
  OutcomeId
  WorldEventId
  ObservationId
  LearningBatchId
```

Definition identity must never be substituted for runtime identity.

Example:

```text
EntityTypeId(crab) != EntityId(gerald)
```

---

# 4. Property, category and capability

These three concepts are deliberately different.

## 4.1 Property

A property is a semantic value that can be read/compared and may sometimes vary by instance.

```text
hardness = HIGH
wetness = 0.7
fuel_remaining = 3
edible = true
```

Use a property when **value matters**.

## 4.2 Capability

A capability declares that a subject participates in a reusable behavior/role.

```text
impact_tool
container
receives_impact
throwable
carryable
```

Use a capability when **behavioral participation matters**, not merely classification.

A capability does not imply success; properties/context still determine resolution.

## 4.3 Category

A category supports semantic grouping/generalization.

```text
food
mushroom
stone
shell
crab
```

Use a category when **classification/knowledge generalization matters**.

Do not use categories as pseudo-inheritance to encode behavior that belongs in capabilities.

---

# 5. Relation taxonomy

A `WorldRelation` is an authoritative binary semantic relationship between supported `RuntimeWorldRef`s.

```text
WorldRelation
  type: RelationTypeId
  subject: RuntimeWorldRef
  object: RuntimeWorldRef
  qualifier: optional PropertyValue
```

Relations are classified by semantics, not by different storage systems.

## 5.1 Containment / support

Examples:

```text
inside(item, container)
on_top_of(item, support)
attached_to(item, anchor/host)
part_of(part, whole)
```

## 5.2 Possession / manipulation

Examples:

```text
carried_by(item, Wilson)
held_by(item, Wilson)
```

Hand/slot detail belongs in a qualifier or a narrower supported relation definition rather than a new inventory subsystem.

## 5.3 Spatial semantic relation

Examples:

```text
near(a, b)
adjacent_to(a, b)
at_place(entity, place)
```

Exact metric position remains world/spatial state; these relations exist only when the semantic relationship itself matters as authoritative state.

## 5.4 Traversal / obstruction

Examples:

```text
blocks_route(entity, place/route-subject)
connects(place_a, place_b)
```

Derived path membership itself should normally be a route-query result rather than persisted relations for every navigation edge.

## 5.5 RelationDefinition

Each relation type should declare invariants:

```text
RelationDefinition
  id: RelationTypeId
  accepted_subject_kinds
  accepted_object_kinds
  cardinality
  inverse_relation_id?
  exclusive_group_id?
  symmetric: bool
  transitive: bool // rare; false by default
```

This prevents relation semantics from being hidden in scattered validation code.

---

# 6. Predicate algebra

`RequirementPredicate` is the umbrella algebra. Predicate kinds are normalized into four families plus composition.

## 6.1 WorldPredicate

Reads authoritative world/body facts only.

```text
HasCapability(ref, capability)
HasCategory(ref, category)
PropertyExists(ref, property)
PropertyCompare(ref.property, op, literal)
PropertyCompareRefs(left.property, op, right.property)
RelationExists(type, subject, object)
RelationAbsent(type, subject, object)
SpatialCondition(a, relation/operator, b)
BodyConditionPredicate(condition/severity)
EnvironmentCondition(predicate_id, declared parameters)
```

## 6.2 CognitionPredicate

Reads Wilson-relative durable or projected state.

```text
BeliefMatches(proposition_pattern, confidence_condition?)
Knows(knowledge_id)
AssociationCondition(subject, valence/attachment condition)
HabitCondition(cue/intention pattern, strength condition)
DriveCondition(drive_id, comparison)
IntentionCondition(pattern/state)
PresenceCondition(dimension, comparison)
```

## 6.3 LifecyclePredicate

Reads project/director/run lifecycle state.

```text
ProjectCondition(project/definition, lifecycle/progress condition)
EventCondition(event/definition, lifecycle condition)
RunCondition(lifecycle condition)
```

## 6.4 RegisteredDomainPredicate

A bounded extension point for semantics that genuinely cannot be represented by the standard algebra.

```text
RegisteredDomainPredicate
  id: DomainPredicateId
  context_family: PHYSICAL | COGNITION | CONTENT_ELIGIBILITY | INTERVENTION
  parameters: validated finite semantic values/refs
```

Rules:

- replaces the vague `ContextPredicate` name;
- every registered predicate declares its dependency/authority context;
- it cannot execute arbitrary authored code;
- repeated use is a signal to promote the semantic into the standard predicate algebra.

## 6.5 Composition

Only these generic combinators are needed initially:

```text
AllOf(predicates)
AnyOf(predicates)
Not(predicate)
```

Avoid adding implication/XOR/counting operators until a representative requirement proves them necessary.

---

# 7. Action, intention and affordance

These terms must not be used interchangeably.

## 7.1 ActionDefinition

A reusable physical/semantic verb with participant roles and interruption semantics.

Examples:

```text
hit
carry
put
inspect
eat
throw
```

An action answers:

> What authoritative operation can be attempted?

## 7.2 SemanticIntention

A Wilson-relative purposeful goal/action framing.

Examples:

```text
open_unknown_container
open_coconut_with_impact_tool
check_fire_before_sleep
restore_favorite_rock
continue_roof_project
```

An intention answers:

> What does Wilson currently mean/want to accomplish?

One intention may resolve through multiple actions; the same action may serve different intentions.

## 7.3 Affordance

An affordance is a **derived available opportunity**, not authored knowledge and not an action instance.

```text
Affordance
  action_id
  role_binding / missing_roles
  source_rule_ids
  mode
```

It answers:

> What can be materially attempted with this local context?

## 7.4 LearnedSemanticInteraction

A learned operational pattern links a `KnowledgeDefinition` to a `SemanticIntention` and applicability predicate.

It answers:

> What purposeful interaction pattern does Wilson know exists?

It never bypasses `ActionDefinition`/`InteractionRule` validation.

---

# 8. Interaction rule, transformation and project

These represent three different levels of semantics.

## 8.1 InteractionRuleDefinition

Reusable cause/effect rule over actions + participant properties/capabilities/context.

Example:

```text
sufficient hard impact against breakable target
→ semantic outcome sufficient_breaking_impact
```

## 8.2 TransformationDefinition

Content-specific form/state transition triggered by semantic outcomes.

Example:

```text
coconut + sufficient_breaking_impact
→ opened_coconut
```

## 8.3 ProjectDefinition

Persistent desired world outcome with multiple possible grounded contributions across time.

Example:

```text
improve shelter roof
build Gerald statue
```

A project is not a long interaction rule and an interaction rule is not a one-step project.

---

# 9. Effect taxonomy

An `Effect` is an authoritative mutation description. It is not an event, observation or presentation instruction.

Normalized effect families:

```text
EntityLifecycleEffect
  create / destroy / transform

PropertyMutationEffect
  set / bounded semantic modification

RelationMutationEffect
  create / remove relation

SpatialMutationEffect
  move / relocate authoritative subject

QuantityMutationEffect
  transfer / consume / produce bounded quantity

BodyMutationEffect
  injury / poisoning / wetness / exertion / recovery / death consequence

EnvironmentalProcessEffect
  start / modify / stop reusable world process
```

`EmitWorldSemanticEvent` is **not** an effect family.

Events are emitted from committed mutation/outcome facts after authoritative application.

This preserves:

```text
mutation != fact that mutation happened
```

---

# 10. Outcome, event, observation and evidence

Use this causal vocabulary consistently:

```text
ActionOutcome
  authoritative result of action resolution

WorldEvent
  authoritative semantic occurrence/fact emitted by world/action lifecycle

ObservedEvent
  Wilson-accessible projection of a WorldEvent/current world change

LearningEvidence
  owner-specific proposed interpretation/update derived from observation/outcome
```

Canonical chain:

```text
ActionOutcome / authoritative world occurrence
→ committed state mutation
→ WorldEvent
→ Perception
→ ObservedEvent
→ interpretation
→ BeliefEvidence / AssociationImpact / HabitEvidence / EpisodeCandidate / PresenceEvidence
→ owner-local mutation
```

Do not call observations `events` without the `Observed` qualifier when authority matters.

---

# 11. Belief, knowledge and proposition

## 11.1 Proposition

A proposition is a structured Wilson-relative claim.

```text
Proposition
  predicate: PropositionPredicateId
  arguments: DomainSubjectRef[] / bounded semantic values
```

Examples:

```text
expected_at(spoon, cooking_area)
dangerous(tide_pool)
likely_edible(mushroom_category)
presence_may_move_objects
impact_tool_can_open(coconut_category)
```

A proposition may be true, false or uncertain relative to world truth.

## 11.2 BeliefEntry

```text
BeliefEntry
  proposition
  confidence
  source_accessibility
```

Belief is the persisted Wilson-relative confidence in a proposition.

## 11.3 KnowledgeDefinition

`KnowledgeDefinition` is authored metadata identifying an operationally meaningful concept that may unlock purposeful semantic behavior or be Legacy-eligible.

```text
KnowledgeDefinition
  id: KnowledgeId
  proposition_pattern(s)
  learned_interaction?
  legacy_eligible
  legacy_weight
```

`KnowledgeId` is **not** a second truth store.

A knowledge item is considered known when the Wilson belief store satisfies its declared proposition/confidence criterion.

This keeps:

```text
belief/knowledge = one epistemic state model
```

while still allowing content to reference stable operational `KnowledgeId`s.

## 11.4 Legacy Knowledge

Player-profile Legacy stores `KnowledgeId`s only.

At run bootstrap, each ID seeds the corresponding canonical proposition(s) into Wilson's belief store with an authored initial confidence/source accessibility.

It does not copy old `BeliefEntry` evidence history.

---

# 12. Semantic outcome tags and diagnostic feedback

## 12.1 SemanticOutcomeTag

A stable classification of what physically/semantically occurred, intended for transformation/project/learning matching.

Examples:

```text
sufficient_breaking_impact
container_opened
food_cooked
material_placed
```

Outcome tags are authoritative result semantics, not prose and not Wilson knowledge.

## 12.2 DiagnosticFeedback

Grounded details explaining partial/failure mechanics without inventing hidden facts.

Examples:

```text
material_too_soft
wood_broke_first
lid_shifted
partial_progress
```

Use tags for machine-composable consequence matching; use diagnostic feedback for causal/learning detail.

Do not collapse the two into a generic string tag bag.

---

# 13. Event and Director vocabulary

## 13.1 EventDefinition / EventInstance

An event is an authored/directable **opportunity/premise lifecycle**, not every fact that occurs in the world.

To avoid ambiguity:

- use `DirectedEventDefinition` / `DirectedEventInstance` when referring to Director-owned authored opportunities;
- use `WorldEvent` for authoritative occurrence facts.

The generic word `Event` should not appear unqualified in new domain APIs when the distinction matters.

## 13.2 DirectorOpportunity

A bounded opportunity/context emitted by the Director that may influence salience/candidate generation.

It is neither a Wilson command nor a world mutation by itself.

---

# 14. Actor vocabulary

`Actor` means a world entity with autonomous activity capability.

- Wilson is a special actor because cognition/body are first-class aggregates;
- non-Wilson actors use shallow `ActorRuntimeState`;
- `Entity` remains the universal physical world identity;
- do not use `NPC` in core domain terminology because animals/environmental autonomous entities need not be conventional characters.

---

# 15. Context vocabulary

`Context` is allowed only for bounded, ephemeral input bundles. Every context type must declare what authority it may read.

Canonical context families:

```text
PhysicalRuleContext
PerceptionContext
DecisionContext
CognitionContext
ContentEligibilityContext
InterventionContext
LuckContext
```

Avoid generic `DomainContext`, `GameContext`, `WorldContext` objects that expose every owner to every service.

---

# 16. State versus derived values

The following are durable state families:

```text
world physical state
Wilson body
Wilson beliefs / associations / habits / selected episodes / intentions / presence relationship
project lifecycle
Director lifecycle/cooldowns
player run intervention state
player profile / Legacy / Diary metadata
```

The following remain derived/transient:

```text
affordances
perception result
salience
expectations
prediction error
candidate intentions/evaluations
causal hypothesis distribution
transient reactions
Luck effective value
routes
```

Do not suffix derived values with `State` unless they genuinely require persistence across an operation boundary (e.g. `ActionExecutionState`).

---

# 17. Deprecated/ambiguous terms

Avoid or replace:

| Ambiguous term | Normalized term |
|---|---|
| `SubjectRef` | `DomainSubjectRef` |
| `ContextPredicate` | `RegisteredDomainPredicate` |
| `EventDefinition` when Director-owned | `DirectedEventDefinition` |
| generic `Event` occurrence | `WorldEvent` or `ObservedEvent` |
| `execute_script` effect | explicit Effect family |
| `EmitWorldSemanticEvent` effect | owner emits `WorldEvent` after mutation |
| `knowledge store` separate from beliefs | `BeliefStore` + `KnowledgeDefinition` metadata |
| recipe | `InteractionRuleDefinition` + `TransformationDefinition` |
| goal when referring to committed Wilson behavior | `SemanticIntention` |
| action when referring to Wilson motivation | `SemanticIntention` |
| inventory | relation/capability projection unless a narrower bounded abstraction is later justified |
| physical state in cognition | `WilsonBodyState` / world truth |
| generic `Event` director object | `DirectedEventInstance` |

---

# 18. Vocabulary invariants

The normalized vocabulary is acceptable only if these remain true:

1. no term simultaneously represents authoritative truth and Wilson belief;
2. no term simultaneously represents mutation and notification/fact;
3. no term simultaneously represents Wilson purpose and physical execution;
4. no type ID is used as runtime instance identity;
5. capabilities encode participation, categories encode grouping and properties encode values;
6. relation semantics are definition-validated rather than implicit in strings;
7. generic extension predicates remain bounded and dependency-declared;
8. Knowledge IDs identify authored operational concepts but do not create a second epistemic truth store;
9. Director-owned authored opportunities and WorldEvents remain distinct;
10. derived values are not promoted to persistent state by naming convenience.
