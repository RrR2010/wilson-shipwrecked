# Normalized Domain Vocabulary

## Status and purpose

This document is the canonical glossary/taxonomy for the language-neutral functional domain.

It keeps implementation from creating multiple primitives for one meaning or one overly generic primitive that hides distinct responsibilities. `DOMAIN_MODEL.md` owns structures/owners; `DOMAIN_OPERATIONS.md` owns public operations; `DISCOVERY_STATUS.md` records the current concrete implementation subset.

---

# 1. Naming rules

Use these suffixes consistently:

- `Definition` — authored/static semantic content;
- `State` — mutable durable state owned by one aggregate;
- `Instance` — one runtime occurrence/identity;
- `Ref` — stable reference;
- `Spec` — declarative instruction/constraint, not runtime truth;
- `Predicate` — pure boolean condition over a declared context;
- `Effect` — requested/resolved authoritative mutation description;
- `Event` — semantic fact that an occurrence/mutation happened;
- `Evidence` — owner-specific proposal derived from observation/outcome;
- `Query` — pure read/derivation without mutation;
- `Command` — request to one owner to validate/mutate its state;
- `Result` / `Outcome` — returned semantic consequence;
- `Projection` — reconstructible observer/read view.

Do not use `Data`, `Info`, `Context`, `State` or `Event` as generic catch-all names when a narrower term exists.

---

# 2. Reference taxonomy

## 2.1 DomainSubjectRef

`DomainSubjectRef` is the broad Wilson-relative semantic reference family:

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

- Wilson is explicit; do not encode him as a magic entity ID in cognition;
- Presence is explicit but is not an authoritative world entity;
- consumers declare accepted variants and reject unsupported ones;
- `SubjectRef` is deprecated as an ambiguous alias.

## 2.2 RuntimeWorldRef

Physical world operations use the narrower family:

```text
RuntimeWorldRef =
    Wilson
  | Entity(EntityId)
  | Place(PlaceId)
  | Region(RegionId)
```

`EntityType`, `Category`, `Presence`, `Project` and abstract concepts are not mutable physical instances.

## 2.3 SemanticConceptId

Use a generic semantic concept only when no stronger typed ID exists. Promote recurring families to typed IDs rather than growing a universal string namespace.

---

# 3. Identity taxonomy

Keep identity families distinct.

```text
Definition IDs:
  EntityTypeId
  PropertyId
  CapabilityId
  CategoryId
  RelationTypeId
  ActionId
  InteractionRuleId
  TransformationId
  KnowledgeId
  ProjectDefinitionId
  EventDefinitionId
  AssemblyDefinitionId
  AssemblySlotId
  AssemblyRoleId

Runtime IDs:
  EntityId
  ProjectInstanceId
  DirectedEventInstanceId
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

Definition identity must never substitute for runtime identity.

---

# 4. Property, category and capability

## 4.1 Property

A property is a typed semantic value whose value matters.

```text
hardness = HIGH
wetness = 0.7
fuel_remaining = 3
sealed = true
```

`PropertyDefinition` declares the admitted value family/bounds. Numeric values are finite; NaN/infinity are invalid.

## 4.2 Capability

A capability declares reusable behavioral participation.

```text
impact_surface
container
receives_impact
graspable
covering
```

A capability does not imply success; properties/configuration/context still determine resolution.

## 4.3 Category

A category supports semantic grouping/generalization.

```text
food
mushroom
stone
shell
crab
```

Do not use categories as behavior inheritance.

## 4.4 PropertyValue

Canonical semantic property/qualifier values are bounded scalars/symbols/typed semantic IDs, not arbitrary Dictionaries, Arrays or executable values.

Current concrete foundation supports numeric, boolean and symbol property schemas plus typed nominal IDs where a semantic qualifier/reference requires them. Representation details such as `int(3)` versus `float(3.0)` must not create distinct semantic identity when the value family is numeric.

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

The **exact relation identity includes the qualifier**. Therefore two admitted relations may share type/subject/object while differing by qualifier. Broad relation queries may intentionally return both; exact mutation addresses the qualified relation.

Examples:

```text
inside(item, container)
on_top_of(item, support)
attached_to(component, host, qualifier = AssemblySlotId)
part_of(part, whole)
held_by(item, Wilson, qualifier = hand_slot)
```

### Containment/support

`inside`, `on_top_of`, `attached_to`, `part_of`.

### Possession/manipulation

`carried_by`, `held_by`.

### Spatial semantic relations

`near`, `adjacent_to`, `at_place` are normally derived from spatial truth unless the semantic arrangement itself must be authoritative.

### Traversal/obstruction

`blocks_route`, `connects` where stable semantic topology requires them.

`RelationDefinition` should eventually declare accepted endpoint kinds, cardinality, inverse/exclusive groups and rare symmetric/transitive semantics. Relation identity and relation admissibility are distinct questions.

---

# 6. Predicate algebra

`RequirementPredicate` is the umbrella pure predicate algebra.

## 6.1 World predicates

```text
HasCapability(ref, capability)
HasCategory(ref, category)
PropertyExists(ref, property)
PropertyCompare(ref.property, op, literal)
PropertyCompareRefs(left.property, op, right.property)
RelationExists(type, subject, object)
RelationAbsent(type, subject, object)
SpatialCondition(a, relation/operator, b)
BodyConditionPredicate(...)
EnvironmentCondition(...)
```

## 6.2 Cognition predicates

```text
BeliefMatches(claim/pattern, confidence_condition?)
Knows(knowledge_id)
AssociationCondition(...)
HabitCondition(...)
DriveCondition(...)
IntentionCondition(...)
PresenceCondition(...)
```

Physical rule contexts must not use hidden cognition.

## 6.3 Lifecycle predicates

```text
ProjectCondition(...)
DirectedEventCondition(...)
RunCondition(...)
```

## 6.4 RegisteredDomainPredicate

A bounded registered extension point may be used when standard typed semantics are insufficient. It declares its authority/dependency context and cannot execute arbitrary authored code.

## 6.5 Composition

```text
AllOf
AnyOf
Not
```

Do not add generic combinators without representative evidence.

---

# 7. Action, intention and affordance

## 7.1 ActionDefinition

A reusable physical/semantic verb with participant roles, requirements and interruption semantics.

Examples: `hit`, `carry`, `put`, `inspect`, `eat`, `throw`.

It answers: **what authoritative operation can be attempted?**

## 7.2 SemanticIntention

A Wilson-relative purposeful objective/framing.

Examples: `open_unknown_container`, `check_fire_before_sleep`, `continue_roof_project`.

It answers: **what does Wilson mean/want to accomplish?**

One intention may use many actions; one action may serve many intentions.

## 7.3 Affordance / ActionAttemptability

An affordance is a derived opportunity. `ActionAttemptability` is authoritative physical legality for a grounded binding. Neither is authored knowledge nor desirability.

## 7.4 LearnedSemanticInteraction

Links operational knowledge to a semantic intention/applicability pattern. It never bypasses authoritative action validation.

---

# 8. Interaction rule, transformation and project

## 8.1 InteractionRuleDefinition

Reusable action + participant/property/capability/context semantics producing grounded outcome semantics.

## 8.2 TransformationDefinition

Content-specific form/state transition triggered by grounded semantic outcomes.

## 8.3 ProjectDefinition

Persistent desired world outcome with multiple possible grounded contributions over time.

A project is not a long interaction rule; an interaction rule is not a one-step project.

---

# 9. Effect taxonomy

An `Effect` describes authoritative mutation. It is not an event, observation or presentation instruction.

Normalized families:

```text
EntityLifecycleEffect
PropertyMutationEffect
RelationMutationEffect
SpatialMutationEffect
QuantityMutationEffect
BodyMutationEffect
EnvironmentalProcessEffect
```

Relation mutation includes the exact optional qualifier in the relation identity.

`EmitWorldSemanticEvent` is not an effect family: authoritative events are emitted from committed outcome/mutation facts.

---

# 10. Outcome, event, observation and evidence

Use this causal vocabulary consistently:

```text
ActionOutcome
  authoritative result produced at an action commit boundary

WorldEvent
  authoritative semantic occurrence/fact emitted after owner commit

ObservedEvent
  Wilson-accessible projection of a WorldEvent

PerceptualEvidence
  Wilson-accessible evidence proposal carrying a typed EpistemicClaim

BeliefEvidence / AssociationImpact / HabitEvidence / EpisodeCandidate / PresenceEvidence
  owner-specific learning proposals
```

Canonical chain:

```text
ActionExecution commit
→ ActionOutcome
→ World owner mutation
→ WorldEvent
→ perception/access projection
→ ObservedEvent / PerceptualEvidence
→ owner-specific learning proposals
→ owner-local mutation
```

Do not call observations `events` without the `Observed` qualifier when authority matters.

---

# 11. Epistemic claim, belief and knowledge

## 11.1 EpistemicClaim

Durable belief identity uses a **typed claim algebra**, not generic `predicate + Variant arguments` serialization.

Current closed foundation:

```text
PropertyClaim(subject, PropertyId, PropertyValue)
RelationClaim(subject, RelationTypeId, object)
EventClaim(subject, EventDefinitionId, perceived_role)
```

Rules:

- claims are Wilson-relative and may be true, false or uncertain relative to world truth;
- claim identity is deterministic and persistence-stable;
- numeric semantic identity does not distinguish integer/float representation;
- future claim families must be introduced explicitly with typed identity/provenance semantics rather than restoring an arbitrary argument bag.

Examples:

```text
PropertyClaim(stone_category, hardness, HIGH)
RelationClaim(spoon, expected_at, cooking_area)
EventClaim(crate, impact_committed, target)
```

More abstract causal/danger/expectation reasoning may derive projections or later justify additional typed claim kinds; those are not generic free-form predicates by default.

## 11.2 BeliefProposition / BeliefEntry

`BeliefProposition` wraps one typed `EpistemicClaim`; `BeliefEntry` stores bounded Wilson-relative confidence and evidence provenance/count metadata.

## 11.3 KnowledgeDefinition

`KnowledgeDefinition` is authored metadata identifying an operationally meaningful concept and its typed claim/pattern satisfaction criteria. `KnowledgeId` is not a second truth store.

## 11.4 Legacy Knowledge

Player-profile Legacy stores admitted `KnowledgeId`s. Run bootstrap seeds the corresponding canonical belief claims without copying prior autobiographical evidence history.

---

# 12. Semantic outcome tags and diagnostic feedback

`SemanticOutcomeTag` is a stable machine-composable classification of what occurred, e.g. `sufficient_breaking_impact`, `container_opened`, `food_cooked`.

`DiagnosticFeedback` explains grounded causal detail such as `material_too_soft`, `wood_broke_first`, `lid_shifted`, `partial_progress`.

Do not collapse either into arbitrary prose/string bags.

---

# 13. Event and Director vocabulary

## 13.1 EventDefinition

`EventDefinition` describes the authored semantic/perceptual envelope of a `WorldEvent` kind, including the roles/modalities that may be perceptible and bounded baseline confidence where applicable.

It is **not** Director lifecycle state.

## 13.2 DirectedEventDefinition / DirectedEventInstance

Director-owned authored opportunities use the qualified names:

```text
DirectedEventDefinition
DirectedEventInstance
```

They own eligibility/rarity/cooldown/opportunity lifecycle semantics and may eventually reference ordinary `EventDefinitionId`s/world effects when they cause real occurrences.

## 13.3 DirectorOpportunity

A bounded opportunity/context emitted by the Director. It is neither a Wilson command nor a World mutation by itself.

Use `WorldEvent` for authoritative occurrence facts; avoid generic unqualified `Event` APIs where the distinction matters.

---

# 14. Actor vocabulary

`Actor` means a world entity with autonomous activity capability.

- Wilson has first-class cognition/body owners;
- non-Wilson actors use shallow runtime behavior state;
- recurring animals may preserve `EntityId` without acquiring Wilson-level psychology;
- avoid `NPC` as a core semantic category.

---

# 15. Context vocabulary

`Context` is allowed only for bounded ephemeral input bundles that declare what authority they may read.

Canonical families include:

```text
PhysicalRuleContext
PerceptionContext
DecisionContext
CognitionContext
ContentEligibilityContext
InterventionContext
LuckContext
```

Avoid generic `GameContext`/`WorldContext` objects exposing every owner.

---

# 16. State versus derived values

Durable state families include world physical state, Wilson body/cognition stores, project lifecycle, Director lifecycle/cooldowns, player run state and player profile.

Derived/transient values include affordances, effective physical profiles, assembly validity, perception result/access, salience, expectations, prediction error, candidate evaluations, causal hypotheses, transient reactions, routes and graph/index projections.

Do not suffix derived values with `State` unless they genuinely require lifecycle persistence, such as `ActionExecutionState`.

---

# 17. Deprecated/ambiguous terms

| Ambiguous/legacy term | Normalized term |
|---|---|
| `SubjectRef` | `DomainSubjectRef` |
| `ContextPredicate` | `RegisteredDomainPredicate` |
| generic durable `Proposition(predicate,args)` identity | typed `EpistemicClaim` wrapped by `BeliefProposition` |
| `EventDefinition` when Director-owned | `DirectedEventDefinition` |
| generic occurrence `Event` | `WorldEvent` or `ObservedEvent` |
| `execute_script` effect | explicit Effect family |
| `EmitWorldSemanticEvent` effect | owner emits `WorldEvent` after mutation |
| separate `knowledge store` | `BeliefStore` + `KnowledgeDefinition` metadata |
| recipe | interaction/transformation/assembly semantics |
| Wilson motivation called action | `SemanticIntention` |
| inventory | relation/capability projection unless later evidence justifies a narrower abstraction |
| physical truth in cognition | World / WilsonBody truth |
| generic Director `EventInstance` | `DirectedEventInstance` |
| arbitrary Dictionary relation qualifier | bounded `PropertyValue` / typed semantic ID qualifier |

---

# 18. Vocabulary invariants

The vocabulary is acceptable only if:

1. authoritative truth and Wilson belief are never one term/type;
2. mutation and occurrence notification are distinct;
3. Wilson purpose and physical execution are distinct;
4. definition IDs are not runtime instance IDs;
5. capabilities encode participation, categories grouping, properties values;
6. relation identity is exact and relation admissibility is separately validated;
7. qualifiers and property values are bounded semantic values, not arbitrary containers/code;
8. generic extension predicates remain bounded and authority-declared;
9. `KnowledgeId` does not create a second epistemic truth store;
10. `EventDefinition`/`WorldEvent` and Director-owned `DirectedEvent*` remain distinct;
11. durable belief identity is typed and deterministic;
12. derived values/projections are not promoted to authority for convenience.
