# Typed Semantic Graph Infrastructure

## Status and purpose

This document is a canonical language-neutral **specialized domain appendix**.

It formalizes graph-shaped structures that were already implicit in the stabilized domain and makes them explicit enough to support larger content breadth, bounded procedural composition, efficient affordance discovery, Wilson knowledge generalization and explainable dependency traversal.

The goal is **not** to redesign Wilson Shipwrecked as a generic graph engine or graph database.

The governing rule is:

```text
graph representation / index / projection
!=
authority owner
```

Existing authority remains unchanged:

```text
World owns physical truth
WilsonCognition owns Wilson-relative durable cognition
Projects own project lifecycle state
Action Resolution owns committed action execution/resolution state
other established owners remain unchanged
```

Graphs provide typed traversal, matching, dependency and explanation surfaces over those facts.

This appendix refines, but does not replace:

- `DOMAIN_MODEL.md`;
- `DOMAIN_VOCABULARY.md`;
- `DOMAIN_CATALOGS.md`;
- `DOMAIN_OPERATIONS.md` / `DOMAIN_OPERATION_REFINEMENTS.md`;
- `DOMAIN_PROCEDURAL_COMPOSITION.md`;
- `DOMAIN_EPISTEMIC_INVESTIGATION.md`.

---

# 1. Why explicit graphs now

The normalized content catalog now expresses a large number of reusable semantics per content family:

```text
material
properties
capabilities
relations
assembly roles
interaction regions
transformations
environmental responses
evidence affordances
actions
project participation
```

The current domain can represent these semantics, but several high-scale operations are naturally graph problems:

```text
what is inside this nested container?
what components transitively belong to this structure?
what effective profiles depend on this damaged component?
what local subjects satisfy an action-role pattern?
what does Wilson believe about this individual versus its category?
what evidence supports or contradicts a causal hypothesis?
```

Without explicit graph/query contracts, implementations are likely to recreate ad-hoc traversals and global scans in multiple systems.

The graph refactor therefore targets **representation and query scale**, not new gameplay semantics.

---

# 2. Non-goals

Do not introduce:

```text
EverythingGraph
GenericTripleStore as the authoritative domain
one universal graph node type for all state
arbitrary string predicates
arbitrary graph rewrite scripts
graph traversal that bypasses mutation authority
Wilson cognition edges mixed with world-truth edges
persisted caches that become a second source of truth
```

Do not convert scalar properties into graph edges merely because a graph can represent them.

For example, prefer:

```text
EntityInstance state override:
  moisture = 0.7
```

rather than requiring:

```text
entity --moisture--> scalar-node-0.7
```

unless a specific analytical projection needs that representation temporarily.

---

# 3. Graph families

The domain admits five graph-oriented concerns with deliberately different authority and lifetime semantics.

```text
1. WorldRelationGraph
   authoritative indexed view over WorldRelation truth

2. PropertyDependencyGraph
   static validated DAG over derived-property dependencies

3. CompositionDependencyProjection
   derived runtime graph of physical/composite dependency

4. EpistemicGraphProjection
   indexed/projection view over Wilson beliefs and learned propositions

5. SemanticPattern
   bounded typed pattern vocabulary used to query/match the above where applicable
```

These are not five new state-owning systems.

---

# 4. WorldRelationGraph

## 4.1 Authority

`WorldRelationGraph` is an indexed graph view of the existing authoritative `WorldRelationStore`.

Conceptually:

```text
WorldRelationGraph
  nodes: RuntimeWorldRef
  edges: WorldRelation
```

The edge payload remains the canonical typed relation:

```text
WorldRelation
  type: RelationTypeId
  subject: RuntimeWorldRef
  object: RuntimeWorldRef
  qualifier: optional PropertyValue
```

The graph does not replace `RelationDefinition` validation.

## 4.2 Typical edge families

```text
inside
on_top_of
attached_to
part_of
carried_by
held_by
at_place when materially persisted
connects where semantically authored
other admitted relation definitions
```

Derived relations such as route obstruction may be projected/indexed when useful but must retain their declared derived-versus-durable semantics.

## 4.3 Required query shape

The implementation should support bounded typed queries conceptually equivalent to:

```text
GetOutgoingRelations(subject, relation_filter?)
GetIncomingRelations(object, relation_filter?)
GetRelated(subject, relation_type, direction, constraints?)
TraverseRelations(start, allowed_relation_types, max_depth, constraints?)
```

Traversal must always be bounded by at least one of:

```text
max_depth
local scope / region
accepted relation types
result limit
specific target predicate
```

Unbounded arbitrary graph walks are not a gameplay primitive.

## 4.4 Useful examples

```text
all direct contents of crate_4
all contents recursively reachable through nested containers to depth N
all direct components part_of shelter_3
all bindings attached_to post_2
all carried/held entities reachable from Wilson possession relations
```

## 4.5 Mutation

Graph mutation is not a separate authority surface.

Commands such as:

```text
CreateRelation
RemoveRelation
AttachAssemblyComponent
DetachAssemblyComponent
Move/transfer operations that change containment/possession
```

still pass through World authority.

The relation graph/index is updated transactionally from committed World mutations.

---

# 5. PropertyDependencyGraph

## 5.1 Purpose

`PropertyDerivationDefinition` already forms a dependency graph. This is now explicitly named and treated as a validated directed acyclic graph.

Conceptually:

```text
PropertyDependencyGraph
  nodes: PropertyDerivationNode
  edges: depends_on
```

A node may depend on bounded selectors such as:

```text
subject property
component property
slot-bound component property
contained quantity/property aggregate
relation/configuration fact
other already-derived property
```

## 5.2 Invariants

At content bootstrap:

```text
all property IDs known
all selector families admitted
output domains compatible
all registered combination policies bounded
no dependency cycle
no structural containment cycle admitted into recursive aggregation
```

The graph must support deterministic topological ordering.

## 5.3 Incremental invalidation

The graph exists not only for validation but also to allow bounded invalidation.

Example:

```text
binding_integrity(binding_7) changed
→ invalidates stability(tool_3)
→ invalidates impact_capacity(tool_3)
→ may change use_as_impact_tool affordance
```

This does not require persisting `stability` or `impact_capacity` as authoritative state.

An implementation may cache derived values for performance if:

```text
cache is reconstructible
cache invalidation is deterministic
cache cannot become authoritative after save/load
```

## 5.4 Explainability

The dependency graph should support provenance:

```text
ExplainEffectiveProperty(subject, property_id)
```

Example output shape:

```text
impact_capacity(tool_3) = HIGH
because:
  head.mass_class = MEDIUM
  head.hardness = HIGH
  handle.leverage = MEDIUM
  binding_integrity = MEDIUM
  combination_policy = impact_capacity_v1
```

This remains a pure diagnostic projection.

---

# 6. CompositionDependencyProjection

## 6.1 Purpose

Physical composition is represented authoritatively through ordinary component identities, relations and assembly bindings.

For efficient dependency queries, derive a runtime graph projection:

```text
CompositionDependencyProjection
  nodes: RuntimeWorldRef
  edges: physical_dependency
```

Inputs may include admitted structural semantics such as:

```text
part_of
attached_to
inside when contents affect effective properties
AssemblyBinding host → component
configured support dependencies
```

Not every world relation creates a physical dependency.

For example:

```text
near(a, b)
```

normally does not imply effective-profile dependency.

## 6.2 Direction

The useful dependency direction is normally:

```text
component/source
→ dependent host/profile/configuration
```

Example:

```text
fiber_binding_7
→ improvised_hammer_3

water_quantity_2
→ barrel_4

cloth_9
→ shelter_roof_configuration_1
```

## 6.3 Uses

```text
find effective profiles affected by one component mutation
find assembly hosts affected by detachment
find protection projections affected by roof component degradation
find downstream dependent structures after support failure
bound save/load reconstruction work
produce causal/provenance debug traces
```

## 6.4 Lifetime

This is derived runtime infrastructure.

Persist:

```text
entities
mutable properties
relations
assembly bindings
active authoritative processes
```

Do not persist the dependency graph as an independent truth source unless an implementation stores a reconstructible cache transparently.

---

# 7. EpistemicGraphProjection

## 7.1 Core rule

Wilson's knowledge is graph-shaped but must remain separate from World truth.

```text
WorldRelationGraph
!=
EpistemicGraphProjection
```

The epistemic projection is built from `BeliefEntry`, learned semantic interactions and other admitted cognitive state.

It does not copy the World graph and then mark edges visible.

## 7.2 Belief representation remains proposition-based

Canonical durable belief shape remains conceptually:

```text
BeliefEntry
  proposition
  confidence
  source_accessibility
```

with:

```text
Proposition
  predicate
  arguments: DomainSubjectRef[]
  qualifiers
```

The graph view indexes these propositions as annotated semantic edges/hyperedges.

Examples:

```text
Entity(gerald)
  --likely_targets [confidence=.82]--> Category(food)

Entity(crate_4)
  --likely_property(material) [confidence=.63]--> material.metal

Entity(spoon_2)
  --expected_at [confidence=.91]--> Place(cooking_area)

Category(mushroom_red)
  --dangerous [confidence=.57]--> Wilson-context
```

Some propositions are naturally binary edges; others require n-ary/hyperedge or proposition-record representation. Do not distort propositions merely to force binary triples.

## 7.3 Individual versus generalized knowledge

The graph/index must support subject scopes already admitted by `DomainSubjectRef`:

```text
Entity(EntityId)
EntityType(EntityTypeId)
Category(CategoryId)
Place(PlaceId)
Region(RegionId)
Project(ProjectInstanceId)
Presence
SemanticConcept(...)
```

This permits both:

```text
stone_42 is probably hard
```

and:

```text
stone-category objects are usually hard
```

without conflating instance fact and category generalization.

## 7.4 Generalization is an inference policy, not graph inheritance

The existence of graph edges does not automatically propagate truth upward/downward through categories.

Inference must remain explicit and bounded.

For example:

```text
several observed stones are hard
+ enough diverse evidence
→ proposal: Category(stone) likely_property hardness HIGH
```

is allowed through a registered learning/inference policy.

But:

```text
Category(stone) hardness HIGH
→ every stone instance believed HIGH with confidence 1.0
```

is not an automatic graph rule.

## 7.5 Association, episode and habit stores

Do not collapse all Wilson cognition into the epistemic graph.

Keep:

```text
AssociationStore
EpisodeStore
HabitStore
IntentionalState
PresenceRelationship
```

as their canonical semantic families.

They may expose graph/index projections for query/debug if useful.

Examples:

```text
subject → association
Episode → subjects
HabitCue → intention pattern / subject pattern
```

but these projections do not erase their distinct update rules and lifetimes.

---

# 8. SemanticPattern

## 8.1 Purpose

Several existing domain features independently need bounded semantic matching:

```text
WorldRelation predicates
Belief proposition matching
Action role candidate discovery
InteractionRule requirements
Assembly component compatibility
Project/event eligibility
learned interaction applicability
```

Introduce a small shared **pattern vocabulary**, not a universal query language.

Conceptually:

```text
SemanticPattern =
    SubjectPattern
  | RelationPattern
  | PropositionPattern
  | PropertyConstraintPattern
  | CapabilityPattern
  | CategoryPattern
  | AllOfPattern
  | AnyOfPattern
  | NotPattern
```

This may reuse/compile from the existing `RequirementPredicate` algebra rather than becoming a parallel predicate system.

## 8.2 Variables

A pattern may use bounded named role variables:

```text
?actor
?tool
?target
?container
?component
```

Variables are local to one query/matching operation and are not persistent IDs.

Example:

```text
AllOf(
  CapabilityPattern(?tool, impact_surface),
  CapabilityPattern(?target, receives_impact),
  LocalReachabilityPattern(?actor, ?tool),
  LocalReachabilityPattern(?actor, ?target)
)
```

## 8.3 No arbitrary recursion

Patterns may request bounded relation traversal only through explicitly admitted operators.

Avoid an open-ended recursive query language in authored content.

## 8.4 Result

Pattern matching returns bindings and provenance:

```text
PatternMatch
  bindings: variable -> DomainSubjectRef
  supporting_facts/relations/projections
  source_pattern_id?
```

For Wilson-relative matching, provenance must identify which beliefs/evidence made the binding cognitively available.

---

# 9. Affordance generation at scale

## 9.1 Problem

Do not implement local affordance generation as a global Cartesian search:

```text
all actions
× all entities
× all entities
× all role permutations
```

## 9.2 Indexed candidate discovery

Maintain reconstructible indexes/projections such as:

```text
capability → local subjects
category → local subjects
property band/index → local subjects
relation adjacency
place/region membership
interaction-region availability
```

Then compile an `InteractionRule`/action requirement into a bounded candidate query.

Example:

```text
action.hit
requires candidate roles:
  ?tool has effective impact participation
  ?target receives_impact
```

Candidate generation can perform:

```text
local reachable subjects
∩ capability/property indexes
∩ role constraints
→ candidate bindings
→ authoritative QueryActionAttemptability
```

This preserves the existing distinction:

```text
candidate discovery
!= attemptability
!= physical success
!= Wilson desirability
```

## 9.3 Wilson-relative opportunity discovery

Wilson does not query hidden authoritative indexes to decide what he knows.

His tactical discovery uses:

```text
PerceptionResult
+ EpistemicGraphProjection
+ learned semantic interactions
+ current intention/history
→ PerceivedTacticalOpportunity
```

A selected tactic is still validated authoritatively before action execution.

---

# 10. Assembly/crafting as pattern matching

Crafting remains property/capability/configuration-driven, not recipe-driven.

Graph/pattern infrastructure makes assembly candidate discovery explicit.

Example assembly definition:

```text
slot.handle
  accepted_component_predicate:
    structural_member

slot.head
  accepted_component_predicate:
    impact_surface
    hardness >= MEDIUM

slot.binding
  accepted_component_predicate:
    binding_component
```

Candidate discovery becomes:

```text
local component index
→ match slot predicates
→ possible bindings
→ ValidateAssemblyBinding
→ ordinary World relation/binding mutation
→ recompute AssemblyValidity / EffectivePhysicalProfile
```

This is **graph/pattern matching**, not recipe matching.

The graph infrastructure must not encode:

```text
branch + stone + fiber = hammer
```

as an authoritative object-pair formula.

---

# 11. Transformations remain content-specific semantic consequences

Transformation semantics should not be replaced by general graph rewrites.

Keep:

```text
TransformationDefinition
  source requirements
  trigger tags
  result type(s)
  transfer policy
```

The graph/index may efficiently find transformation definitions applicable to a resolved semantic outcome, but the transformation remains a typed content contract.

Do not admit arbitrary authored graph rewrite rules that can mutate any nodes/edges.

---

# 12. Environmental and hazard interactions

Graph infrastructure can improve dependency discovery without changing environmental authority.

Examples:

```text
rain exposure changed for cloth_9
→ dependency graph identifies shelter protection projections affected

post_2 structural_integrity crosses failure boundary
→ composition graph identifies attached/part-of dependents
→ grounded relation failures/processes are resolved through existing World/hazard semantics
```

A dependency edge is not itself permission to mutate the dependent.

Existing `EnvironmentalResponseRule`, `DynamicProcessState`, protection/exposure and hazard contracts remain authoritative.

---

# 13. Causal investigation graph

Epistemic investigation may expose a **temporary derived evidence-hypothesis graph**:

```text
PerceptualEvidence
  --supports / opposes-->
CausalHypothesis
```

This is useful for:

```text
hypothesis discrimination
explanation
LLM-bounded interpretation among valid hypotheses
debugging Sabotaged Storage-like situations
```

It remains part of bounded `InvestigationContext`/derived working state.

Do not persist an ever-growing universal causal graph.

Do not expose actual hidden cause edges to Wilson.

---

# 14. Index lifecycle and persistence

## 14.1 Authoritative persisted facts

Persist according to existing owners:

```text
EntityInstance state
WorldRelation truth
assembly bindings/configuration
active authoritative dynamic/environmental processes
Wilson durable belief/association/habit/episode state
project lifecycle state
other admitted durable state
```

## 14.2 Reconstructible indexes/projections

Normally reconstruct on load:

```text
WorldRelation adjacency indexes
capability/category indexes
PropertyDependencyGraph compiled topology
CompositionDependencyProjection
EffectivePhysicalProfile caches
EpistemicGraph indexes
pattern indexes
```

An implementation may serialize performance caches only if they are verifiably reconstructible and never accepted as a second source of truth.

## 14.3 Determinism

Graph iteration order must never introduce nondeterministic gameplay behavior.

When graph/query result order influences selection:

```text
use stable semantic sort keys
or explicit seeded RandomSource after deterministic candidate construction
```

Hash-map/database iteration order is not a gameplay tie-break contract.

---

# 15. Graph consistency invariants

## World relation graph

```text
all edge endpoint refs valid
RelationDefinition constraints hold
exclusive/cardinality groups hold
forbidden structural cycles rejected
inverse relations remain consistent where materialized
```

## Property dependency graph

```text
acyclic
all selectors resolvable
output types valid
combination policy registered/bounded
```

## Composition dependency graph

```text
reconstructible from authoritative world facts
no hidden ownership state
no unsupported recursive structural containment
```

## Epistemic graph

```text
all durable entries trace to WilsonCognition-owned records
confidence remains bounded
contradictory beliefs may coexist when the belief model admits them
world truth is never silently copied as Wilson knowledge
```

## Semantic patterns

```text
bounded variables
bounded traversal
known predicate/relation/capability/property IDs
no arbitrary executable callbacks
query authority context explicit
```

---

# 16. Suggested language-neutral query surface

These operations are conceptual contracts; exact names may be consolidated into `DOMAIN_OPERATIONS.md` during the planned operations-document cleanup.

## Authoritative world graph

```text
QueryRelations(subject, RelationQuery)
→ WorldRelation[]

TraverseWorldRelations(start, BoundedRelationTraversalSpec)
→ RelationTraversalResult
```

## Pattern/index query

```text
MatchWorldPattern(pattern, AuthoritativeLocalScope)
→ PatternMatch[]
```

## Composition dependency

```text
QueryPhysicalDependents(subject, dependency_filter?, max_depth?)
→ RuntimeWorldRef[]

ExplainCompositionDependency(source, dependent)
→ DependencyTrace
```

## Property dependency

```text
ExplainEffectiveProperty(subject, property_id)
→ PropertyDerivationTrace
```

## Wilson epistemic query

```text
MatchBeliefPattern(pattern, WilsonEpistemicScope)
→ BeliefPatternMatch[]

QueryBeliefsAbout(subject, predicate_filter?)
→ BeliefEntry[]
```

The implementation may use one generic internal matching engine, but public/domain operations must preserve authority-specific input/output types.

Do not expose one operation such as:

```text
QueryGraph(any_graph, arbitrary_pattern)
```

as the canonical domain boundary.

---

# 17. Migration from the current model

This refactor is intentionally incremental.

## Phase 1 — semantic contracts

Accepted by this document:

```text
WorldRelationStore has an explicit typed graph/index view
PropertyDerivationDefinition compiles to PropertyDependencyGraph DAG
physical composition exposes a derived dependency projection
BeliefStore exposes an epistemic graph/index projection
RequirementPredicate may compile/use bounded SemanticPattern matching
```

No persistent schema migration is required yet.

## Phase 2 — operation consolidation

When `DOMAIN_OPERATIONS.md` absorbs `DOMAIN_OPERATION_REFINEMENTS.md`, include the graph/index query operations and remove older ambiguous global-affordance signatures.

## Phase 3 — concrete module/type design

Package/module layout should provide distinct boundaries conceptually equivalent to:

```text
world relation storage + indexes
content registries / compiled predicates
property derivation graph
composition dependency projection
Wilson belief store + epistemic indexes
bounded semantic matcher
```

Do not create a `GraphSystem` state owner.

## Phase 4 — deterministic fixture execution

At minimum validate:

```text
nested containment traversal
improvised hammer component invalidation
cloth shelter protection dependency invalidation
local affordance discovery without global Cartesian enumeration
instance-vs-category Wilson belief query
graph indexes rebuild identically after save/load
stable candidate ordering independent of hash iteration
```

---

# 18. Regression against stabilized domain decisions

This graph refactor preserves:

```text
world truth != Wilson observation != Wilson belief
property != capability != affordance
ActionDefinition != SemanticIntention
physical attemptability != perceived tactical opportunity
assembly validity != effective performance
project lifecycle != physical structure truth
player-private cause != Wilson causal attribution
```

It also preserves the rejection of:

```text
recipe catalog as physical authority
universal inventory aggregate
universal exploration percentage
favorite/ownership flags on world entities
universal tool/structure quality scalar
scene-specific action APIs
arbitrary executable predicates/effects
```

---

# 19. Expected benefits

The explicit graph/index layer should improve:

```text
content scale
local affordance candidate discovery
assembly/crafting component matching
incremental effective-property recomputation
nested containment and structural queries
Wilson instance/type/category knowledge generalization
causal investigation explainability
content bootstrap validation
save/load reconstruction checks
debug provenance
procedural generation constrained by semantic compatibility
```

The target architecture remains:

```text
typed authoritative stores
+ reconstructible graph/index projections
+ bounded semantic pattern matching
+ explicit owner mutation commands
```

not:

```text
one generic graph database that owns the game
```
