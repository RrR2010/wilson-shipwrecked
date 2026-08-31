# Canonical Domain Catalogs

## Purpose

This document turns `DOMAIN_VOCABULARY.md` into the minimal admitted catalogue of relation, predicate, effect, outcome and epistemic semantics required by current representative behavior.

It is language-neutral and content-oriented. It does not prescribe enums/classes/resources/persistence representation. New entries require either a current representative-scene need or a core invariant.

---

# 1. Relation catalogue

Relation types are authored semantic definitions with accepted ref kinds and eventual cardinality/inverse/exclusivity metadata.

A concrete `WorldRelation` has exact identity:

```text
relation_type
+ subject
+ object
+ optional qualifier
```

The qualifier is a bounded `PropertyValue` / typed semantic ID, not an arbitrary Dictionary. Broad queries may intentionally return multiple relations with the same endpoints when qualifiers differ; exact mutation includes the qualifier.

## 1.1 Containment and support

### `inside`

```text
subject: Entity
object: Entity with capability.container
cardinality: subject max 1 active containment parent in containment exclusive group
inverse: contains
```

Used by storage, containers, shelter contents and resource lookup.

### `contains`

Derived/inverse of `inside`; need not be persisted separately when relation queries can invert.

### `on_top_of`

```text
subject: Entity
object: Entity | Place
cardinality: many-to-many unless content constrains support occupancy
```

### `attached_to`

```text
subject: Entity
object: Entity | Place
qualifier: optional semantic attachment/assembly slot ID
```

Used by laundry, project pieces, assemblies and loose-object configurations.

A relation may encode an assembly binding as:

```text
attached_to(component, host, qualifier = AssemblySlotId)
```

The relation store admits exact qualified edges; `AssemblyValidity` decides whether the resulting configuration is semantically valid.

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

`held_by` is more specific than `carried_by`; implementations may derive the latter from the former.

---

# 3. Spatial semantic relations

### `near`

Usually derived, not persisted. Persist only when a semantic arrangement itself is authoritative and cannot be reconstructed from spatial truth.

### `at_place`

Normally derived from entity/place state.

### `adjacent_to`

Derived spatial relation by default.

Rule:

> Do not persist derived spatial relations merely because predicates need them.

The current structural foundation uses `PlaceId` co-location/bounded nearby queries; fine metric/nav semantics remain behind spatial adapters.

---

# 4. Traversal relations

### `blocks_route`

Prefer derived route obstruction from geometry/world state. Persist only when obstruction itself is semantic authoritative state.

### `connects`

Used for authored semantic connectivity between stable places/regions when coarse topology requires it.

---

# 5. Relation non-catalogue

Do not add World relation types for Wilson-relative meaning such as:

```text
favorite
hated
trusted
feared
psychologically_owned_by
```

Those belong to cognition.

---

# 6. Predicate catalogue

## 6.1 World predicates

Canonical initial families:

```text
HasCapability(ref, CapabilityId)
HasCategory(ref, CategoryId)
PropertyExists(ref, PropertyId)
PropertyCompare(ref, PropertyId, ComparisonOperator, PropertyValue)
PropertyCompareRefs(left_ref, left_property, op, right_ref, right_property)
RelationExists(RelationTypeId, subject, object)
RelationAbsent(RelationTypeId, subject, object)
SpatialCondition(left_ref, SpatialRelation, right_ref, optional threshold)
BodyConditionPredicate(...)
EnvironmentCondition(...)
```

Comparison operators:

```text
EQ
NEQ
LT
LTE
GT
GTE
```

Ordered comparison is valid only for compatible ordered property families.

## 6.2 Cognition predicates

Canonical conceptual families:

```text
BeliefMatches(EpistemicClaimPattern, optional ConfidenceCondition)
Knows(KnowledgeId)
AssociationCondition(...)
HabitCondition(...)
DriveCondition(...)
IntentionCondition(...)
PresenceCondition(...)
```

`Knows` is sugar over `KnowledgeDefinition` satisfaction by `BeliefStore`; it is not a second truth store.

## 6.3 Lifecycle predicates

```text
ProjectCondition(...)
DirectedEventCondition(...)
RunCondition(...)
```

## 6.4 Composition

```text
AllOf
AnyOf
Not
```

## 6.5 Registered extension

`RegisteredDomainPredicate` is permitted only as a bounded, authority-declared semantic extension. It cannot execute arbitrary authored code.

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
| spatial/world environment | ✓ | perceived projection only | ✓ | ✓ when required |
| body condition | ✓ when physical | perceived bodily projection | B | — |
| belief/knowledge | — | ✓ | B | B only for player-visible discovery rules |
| association/habit/drives | — | ✓ | B | — |
| current intention | — | ✓ | B | — |
| presence relationship | — | ✓ | B | — |
| project lifecycle | — | ✓ via bounded projection | ✓ | B |
| directed-event lifecycle | — | ✓ via DirectorContext | ✓ | B |
| run lifecycle | B | B | B | B |
| RegisteredDomainPredicate | declared context only | declared context only | declared context only | declared context only |

---

# 8. Effect catalogue

Effects describe authoritative mutation requests/results only.

## 8.1 Entity lifecycle

```text
CREATE_ENTITY
DESTROY_ENTITY
TRANSFORM_ENTITY
```

## 8.2 Property mutation

```text
SET_PROPERTY
MODIFY_PROPERTY
CLEAR_OVERRIDE
```

Only admitted mutable instance properties may change; values are schema-validated and finite.

## 8.3 Relation mutation

```text
CREATE_RELATION(type, subject, object, qualifier?)
REMOVE_RELATION(type, subject, object, qualifier?)
```

The owner targets exact qualified identity. Relation-definition cardinality/exclusivity remains a separate semantic validation concern.

## 8.4 Spatial mutation

```text
MOVE_ENTITY
RELOCATE_ENTITY
```

Collapse these if implementation finds no semantic distinction.

## 8.5 Quantity mutation

```text
TRANSFER_QUANTITY
CONSUME_QUANTITY
PRODUCE_QUANTITY
```

## 8.6 Body mutation

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

`SET_DEAD` is only a grounded body/world consequence.

## 8.7 Environmental process mutation

```text
START_PROCESS
MODIFY_PROCESS
STOP_PROCESS
```

---

# 9. Things that are not effects

Explicitly not effect families:

```text
WorldEvent
ObservedEvent
PerceptualEvidence
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

Conceptual `ActionOutcome.classification` values:

```text
SUCCESS
PARTIAL
NO_EFFECT
BLOCKED
FAILURE
```

Classification is physical/action-level result semantics, not Wilson satisfaction and not project completion.

The concrete structural vertical currently focuses on committed effects/event identity rather than requiring every classification field to exist in the minimal GDScript representation. `DISCOVERY_STATUS.md` records the concrete subset.

---

# 11. Semantic outcome-tag policy

Outcome tags are open validated content vocabulary, not prose.

Examples:

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

Use tags for transformation/project/learning matching; generalize repeated content-specific tags when semantics are truly reusable.

---

# 12. Diagnostic feedback policy

Grounded feedback examples:

```text
material_too_soft
material_broke_first
target_shifted
lid_shifted
partial_progress
insufficient_force
blocked_by_obstacle
```

Wilson learning consumes only the subset available through observation.

---

# 13. Epistemic claim catalogue

Durable belief identity is based on typed `EpistemicClaim`, not arbitrary proposition predicate IDs plus Variant argument bags.

Current admitted foundation claim kinds:

### `PropertyClaim`

```text
PropertyClaim(subject, PropertyId, PropertyValue)
```

Examples:

```text
stone_category hardness HIGH
this_firepit structural_integrity LOW
```

### `RelationClaim`

```text
RelationClaim(subject, RelationTypeId, object)
```

Examples:

```text
spoon beside cooking_area
materials inside storage
Gerald near food_area
```

The claim is Wilson-relative; its relation need not currently be true in authoritative World state.

### `EventClaim`

```text
EventClaim(subject, EventDefinitionId, perceived_role)
```

Examples:

```text
crate impact_committed target
palm crack_heard source
```

Future epistemic semantics such as causal attribution, danger abstraction or expectation patterns must be added as explicit typed claim/pattern families when required. Do not restore a generic durable `predicate + arbitrary arguments` identity as a shortcut.

---

# 14. Knowledge-definition policy

`KnowledgeDefinition` identifies an operational concept whose satisfaction is derived from typed belief claims/patterns and confidence thresholds.

Example concept:

```text
knowledge.open_breakable_with_impact_tool
```

It may expose a learned semantic interaction such as:

```text
intention.open_breakable_with_impact_tool
```

but never bypass authoritative physical validation.

Legacy eligibility belongs to knowledge metadata, not to a second knowledge state store.

---

# 15. Catalogue admission rule

Before introducing a new entry, ask:

1. Can an existing property/capability/category express it?
2. Can an existing relation type/qualifier express it?
3. Can an existing typed epistemic claim express it?
4. Can an existing predicate with different bindings express it?
5. Can an existing effect family + semantic payload express it?
6. Is the distinction Wilson-relative rather than World truth?
7. Is it only presentation wording?
8. Which representative behavior or invariant becomes impossible without it?

If no concrete requirement exists, do not add it yet.

---

# 16. Catalogue gate

The initial catalogues have passed the structural-domain and runtime-foundation gates. The next work is to expand authored/system breadth through these semantics and add a new primitive only when a representative scenario cannot be expressed cleanly without it.
