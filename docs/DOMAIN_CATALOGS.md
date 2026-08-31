# Canonical Domain Catalogs

## Purpose

This document turns the normalized vocabulary in `DOMAIN_VOCABULARY.md` into a minimal initial catalogue of supported relation, predicate, effect and result semantics.

It is language-neutral and content-oriented. It does not prescribe enums, classes, resources or persistence representation.

A catalogue entry is admitted only when it is required by the current representative-scene regression or by a core domain invariant.

---

# 1. Relation catalogue

Relation types are authored definitions with accepted ref kinds and cardinality/inverse/exclusivity metadata.

## 1.1 Containment and support

### `inside`

```text
subject: Entity
object: Entity with capability.container
cardinality: subject max 1 active containment parent in containment exclusive group
inverse: contains
```

Used by:

- storage;
- containers;
- shelter/container contents;
- project/resource lookup.

### `contains`

Derived/inverse of `inside`; need not be persisted separately if relation queries can invert.

### `on_top_of`

```text
subject: Entity
object: Entity | Place
cardinality: many-to-many unless content constrains support occupancy
```

Used by Missing Spoon, Gift Test and arrangements.

### `attached_to`

```text
subject: Entity
object: Entity | Place
cardinality: subject normally max 1 attachment in attachment exclusive group unless definition permits multiple
```

Used by laundry, project pieces and loose-object environmental interactions.

### `part_of`

```text
subject: Entity
object: Entity
cardinality: subject max 1 semantic whole by default
```

Used by lids/components and composite authored objects.

---

# 2. Possession/manipulation relations

### `carried_by`

```text
subject: Entity
object: Wilson | Entity(actor)
exclusive group: possession_location
```

### `held_by`

```text
subject: Entity
object: Wilson | Entity(actor)
qualifier: optional hand/slot semantic value
exclusive group: possession_location
```

`held_by` is more specific than `carried_by`. Implementations may derive `carried_by` from `held_by` rather than persist both.

---

# 3. Spatial semantic relations

### `near`

Usually **derived**, not persisted.

Use a persisted `near` relation only when a semantic arrangement itself is authoritative content/state and cannot be reconstructed from spatial queries.

### `at_place`

Normally derived from entity/place state rather than persisted as a duplicate relation.

### `adjacent_to`

Derived spatial relation by default.

Rule:

> Do not persist derived spatial relations merely because predicates need them.

Predicates may query spatial services directly.

---

# 4. Traversal relations

### `blocks_route`

Prefer derived route obstruction from geometry/world state.

Persist only if the obstruction is itself semantic state that cannot be reconstructed cheaply/accurately.

### `connects`

Used for authored semantic connectivity between stable places/regions when navigation topology requires it.

Examples:

```text
temporary sandbar connects home_island, neighbor_island
wreck_access connects beach, wreck_deck
```

---

# 5. Relation non-catalogue

Do not add relation types for Wilson-relative expectations such as:

```text
favorite
hated
expected_at
owned_by_wilson psychologically
trusted
feared
```

These belong to associations/belief propositions, not world truth.

---

# 6. Predicate catalogue

## 6.1 World predicates

Canonical initial kinds:

```text
HasCapability(ref, CapabilityId)
HasCategory(ref, CategoryId)
PropertyExists(ref, PropertyId)
PropertyCompare(ref, PropertyId, ComparisonOperator, PropertyValue)
PropertyCompareRefs(left_ref, left_property, op, right_ref, right_property)
RelationExists(RelationTypeId, subject, object)
RelationAbsent(RelationTypeId, subject, object)
SpatialCondition(left_ref, SpatialRelation, right_ref, optional threshold)
BodyConditionPredicate(ConditionId, comparison/severity)
EnvironmentCondition(EnvironmentConditionId, parameters)
```

Comparison operators initially:

```text
EQ
NEQ
LT
LTE
GT
GTE
```

Do not add fuzzy operators to physical truth. Fuzzy interpretation belongs in derived cognition/evaluation.

## 6.2 Cognition predicates

Canonical initial kinds:

```text
BeliefMatches(PropositionPattern, optional ConfidenceCondition)
Knows(KnowledgeId)
AssociationCondition(DomainSubjectRef, AssociationDimension, Comparison)
HabitCondition(HabitPattern, Comparison)
DriveCondition(DriveId, Comparison)
IntentionCondition(SemanticIntentionPattern, IntentionLifecycleCondition)
PresenceCondition(PresenceDimension, Comparison)
```

`Knows` is sugar over `KnowledgeDefinition` satisfaction by the belief store, not a second store lookup.

## 6.3 Lifecycle predicates

```text
ProjectCondition(ProjectRef/DefinitionId, ProjectLifecycleCondition)
DirectedEventCondition(DirectedEventRef/DefinitionId, DirectedEventLifecycleCondition)
RunCondition(RunLifecycleCondition)
```

## 6.4 Composition

```text
AllOf
AnyOf
Not
```

No other generic combinators admitted yet.

---

# 7. Predicate context matrix

Legend:

```text
✓ allowed
— forbidden by authority boundary
B bounded/explicitly approved only
```

| Predicate family | PhysicalRuleContext | CognitionContext | ContentEligibilityContext | InterventionContext |
|---|:---:|:---:|:---:|:---:|
| capability/category/property | ✓ | perceived/believed projection only | ✓ | ✓ target-side |
| authoritative relation | ✓ | perceived projection only | ✓ | ✓ target-side |
| spatial/world environment | ✓ | perceived projection only | ✓ | ✓ when intervention requires |
| body condition | ✓ when physical | perceived bodily projection | B | — |
| belief/knowledge | — | ✓ | B | B only for player-visible discovery rules |
| association/habit/drives | — | ✓ | B | — |
| current intention | — | ✓ | B | — |
| presence relationship | — | ✓ | B | — |
| project lifecycle | — | ✓ via bounded projection | ✓ | B |
| directed-event lifecycle | — | ✓ via DirectorContext | ✓ | B |
| run lifecycle | B | B | B | B |
| RegisteredDomainPredicate | declared context only | declared context only | declared context only | declared context only |

The matrix is an authority constraint, not an optimization hint.

---

# 8. Effect catalogue

Effects describe authoritative mutation requests/results only.

## 8.1 EntityLifecycleEffect

Kinds:

```text
CREATE_ENTITY
DESTROY_ENTITY
TRANSFORM_ENTITY
```

`TRANSFORM_ENTITY` must use a validated `TransformationDefinition` and transfer policy.

## 8.2 PropertyMutationEffect

Kinds:

```text
SET_PROPERTY
MODIFY_PROPERTY
CLEAR_OVERRIDE
```

Only mutable instance properties may be targeted.

## 8.3 RelationMutationEffect

Kinds:

```text
CREATE_RELATION
REMOVE_RELATION
```

Owner validates relation-definition cardinality/exclusivity.

## 8.4 SpatialMutationEffect

Kinds:

```text
MOVE_ENTITY
RELOCATE_ENTITY
```

The distinction may collapse in implementation if both preserve the same domain semantics. Do not create separate public operations without a behavioral difference.

## 8.5 QuantityMutationEffect

Kinds:

```text
TRANSFER_QUANTITY
CONSUME_QUANTITY
PRODUCE_QUANTITY
```

Used only for entities/resources modeled quantitatively.

## 8.6 BodyMutationEffect

Kinds:

```text
APPLY_CONDITION
MODIFY_CONDITION
REMOVE_CONDITION
MODIFY_VITALITY
MODIFY_EXERTION
MODIFY_WETNESS
MODIFY_MOBILITY
SET_DEAD
```

`SET_DEAD` is only valid as the resolved consequence of authoritative body/world rules, never a Director/cognition shortcut.

## 8.7 EnvironmentalProcessEffect

Kinds:

```text
START_PROCESS
MODIFY_PROCESS
STOP_PROCESS
```

Examples: spoilage, drying, fire consumption, storm weakening.

---

# 9. Things that are not effects

Explicitly not effect families:

```text
WorldEvent
ObservedEvent
BeliefEvidence
AssociationImpact
HabitEvidence
EpisodeCandidate
PresenceEvidence
ReactionState
PresentationEvent
DirectorOpportunity
EvaluationContribution
```

These are facts, projections, proposals or derived values.

---

# 10. Action outcome catalogue

`ActionOutcome.classification` initial values:

```text
SUCCESS
PARTIAL
NO_EFFECT
BLOCKED
FAILURE
```

Semantics:

- `SUCCESS` — intended action-level physical objective occurred;
- `PARTIAL` — meaningful grounded progress/change occurred without full objective;
- `NO_EFFECT` — valid attempt committed but produced no meaningful target change;
- `BLOCKED` — action could not proceed because a runtime precondition failed before relevant physical resolution;
- `FAILURE` — committed action resolved adversely/incorrectly relative to its physical action objective.

Classification is not Wilson satisfaction and not project completion.

---

# 11. Semantic outcome tag catalogue policy

Outcome tags are open content vocabulary but must belong to a validated registry.

Initial vertical-slice examples:

```text
sufficient_breaking_impact
insufficient_breaking_impact
container_dented
container_opened
food_cooked
food_consumed
material_placed
object_moved
body_injured
```

Rules:

- use tags for transformation/project/learning matching;
- do not encode arbitrary prose;
- a tag should describe what occurred, not why Wilson wanted it;
- repeated content-specific tags should be generalized when the semantic is genuinely reusable.

---

# 12. Diagnostic feedback catalogue policy

Feedback kinds explain grounded causal detail useful to learning/debugging.

Initial examples:

```text
material_too_soft
material_broke_first
target_shifted
lid_shifted
partial_progress
insufficient_force
blocked_by_obstacle
```

Feedback may reference observable and authoritative detail, but Wilson learning only consumes the subset available through observation.

---

# 13. Proposition predicate catalogue

Propositions are Wilson-relative claims, not world relations.

Initial reusable proposition predicates:

```text
expected_relation(subject, relation_pattern, object)
likely_property(subject_scope, property, expected_value/range)
causes_or_enables(subject/action pattern, semantic_outcome)
dangerous(subject)
beneficial(subject)
likely_targets(actor_subject, target_scope)
likely_at(subject, place)
presence_caused(event/anomaly pattern)
presence_likely_responds_to(test_pattern)
```

Avoid object-specific proposition predicate IDs such as:

```text
spoon_should_be_by_fire
Gerald_steals_food
```

Those are instances of reusable predicates + arguments.

---

# 14. Knowledge definition catalogue for first fixture

Minimum operational knowledge needed for the first headless property/discovery regression:

```text
knowledge.open_breakable_with_impact_tool
```

Possible definition:

```text
KnowledgeDefinition
  id: knowledge.open_breakable_with_impact_tool
  proposition pattern:
    causes_or_enables(
      action.hit with tool capability impact_tool,
      sufficient_breaking_impact on breakable target
    )
  known threshold: authored bounded confidence
  learned semantic interaction:
    intention.open_breakable_with_impact_tool
  legacy_eligible: true/false per content decision
```

A coconut-specific semantic interaction may be added as a narrower presentation/intention specialization if needed, but physical knowledge should generalize when evidence/content semantics justify it.

---

# 15. Catalogue admission rule

Before introducing a new entry, ask:

1. Can an existing property/capability/category express it?
2. Can an existing relation type express it?
3. Can an existing predicate + different arguments express it?
4. Can an existing effect family + semantic payload express it?
5. Is the desired distinction Wilson-relative (belief/association) rather than world truth?
6. Is it merely presentation wording?
7. Which representative scene or implementation invariant becomes impossible without the new entry?

If no concrete requirement exists, do not add it yet.

---

# 16. Catalogue gate

The initial catalogues are sufficient to model the current representative scene suite without introducing object-pair recipes, scene-specific state primitives or unbounded extension callbacks.

The next useful functional-domain step is to build **concrete scenario schemas/fixtures** for a small set of integration scenes using only these catalogues:

```text
Scientific Method
Missing Spoon
Sabotaged Storage
Falling Palm
Brilliant Shortcut
```

Those fixtures should instantiate definitions/state/predicates/effects/propositions in a serialization-neutral notation and expose any remaining schema ambiguity before language/package implementation begins.
