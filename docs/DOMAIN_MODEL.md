# Concrete Domain Model

## Status and purpose

This document is the first concrete domain-model pass for Wilson Shipwrecked.

It translates the accepted product, behavioral, state, contract, orchestration and mutation-authority decisions into a minimal set of typed domain concepts suitable for implementation.

It intentionally remains **runtime-language neutral**. The repository has not yet committed to GDScript, C# or another implementation language for the simulation core. The types below are therefore semantic records/value objects, not mandated syntax.

This document is concrete about:

- identity;
- content definitions versus runtime instances;
- properties and capabilities;
- generic interaction rules;
- requirements/predicates;
- effects and transformations;
- affordance queries;
- learned semantic interactions;
- Wilson persistent state;
- player-profile state;
- run lifecycle;
- contract identifiers and deterministic randomness.

It does **not** define package layout, persistence encoding, Godot nodes, exact numeric formulas or content-authoring file format.

---

# 1. Modeling principles

## 1.1 Stable semantic IDs

Domain identity must not depend on Godot nodes, resource paths, display strings or asset filenames.

Use small typed IDs conceptually equivalent to:

```text
EntityId
EntityTypeId
CategoryId
PropertyId
CapabilityId
ActionId
InteractionRuleId
TransformationId
KnowledgeId
ProjectDefinitionId
ProjectInstanceId
EventDefinitionId
EventInstanceId
RunId
EpisodeId
DecisionId
OutcomeId
PlayerProfileId
```

Concrete representation may initially be validated strings or interned symbols. Stronger wrappers are preferred where the chosen language makes them cheap.

Rules:

- IDs are stable across save/load;
- content IDs are stable across releases unless migrated deliberately;
- runtime instance IDs are unique within the owning scope;
- presentation names are not IDs;
- content registries validate references at startup/content-load time.

## 1.2 Definition versus instance

Keep authored/static content separate from mutable runtime state.

```text
EntityDefinition
  describes what a type of thing is

EntityInstance
  describes one concrete thing currently in the world
```

Likewise:

```text
InteractionRuleDefinition
TransformationDefinition
ProjectDefinition
EventDefinition
```

are content definitions, while current action/project/event execution state belongs to the active run.

## 1.3 Data-driven composition, not recipe enumeration

The generic interaction model must not require authoring every compatible object pair.

Preferred:

```text
roles + capabilities + properties + state/context requirements
→ valid interaction
→ resolved effect/transformation
```

Rejected as the general model:

```text
stone + coconut -> opened_coconut
hammer + coconut -> opened_coconut
bowling_ball + coconut -> opened_coconut
```

The same rule should accept any concrete participant set satisfying its predicates.

---

# 2. Core value types

## 2.1 Finite normalized values

Use dedicated bounded value concepts where semantics require ranges.

```text
UnitInterval     // [0, 1]
SignedUnit       // [-1, +1]
NonNegative      // >= 0
Probability      // [0, 1]
```

Construction/update must enforce invariants. Do not store NaN/Infinity or use huge sentinel values.

## 2.2 Discrete grades

Some physical/content properties should use ordered finite grades rather than false precision.

Initial example:

```text
Grade5:
  VERY_LOW
  LOW
  MEDIUM
  HIGH
  VERY_HIGH
```

Use only where ordering/comparison is behaviorally useful. Do not force every property into `Grade5`.

## 2.3 Property values

A property value needs a finite supported value family.

Conceptually:

```text
PropertyValue =
    BoolValue(bool)
  | IntValue(int)
  | ScalarValue(finite number)
  | GradeValue(Grade5)
  | IdValue(stable semantic id)
```

Do not introduce an unrestricted arbitrary object/variant payload into authoritative domain state.

---

# 3. World content model

## 3.1 EntityDefinition

```text
EntityDefinition
  id: EntityTypeId
  categories: Set<CategoryId>
  base_properties: Map<PropertyId, PropertyValue>
  capabilities: Set<CapabilityId>
  transformation_tags: Set<SemanticTagId>
  player_intervention_capabilities: Set<PlayerInterventionCapabilityId>
  semantic_anchors: Set<AnchorId>
```

Examples of properties/capabilities:

```text
property.hardness = HIGH
property.break_resistance = LOW
property.flammability = HIGH
property.edible = true

capability.impact_tool
capability.throwable
capability.container
capability.receives_impact
capability.can_burn
```

`EntityDefinition` contains authoritative type-level content facts. Wilson does not automatically know them.

## 3.2 EntityInstance

```text
EntityInstance
  id: EntityId
  type_id: EntityTypeId
  location: WorldLocation
  state_overrides: Map<PropertyId, PropertyValue>
  quantity: optional NonNegative
  lifecycle_state: EntityLifecycleState
```

Only mutable/instance-specific values belong in `state_overrides`.

Effective property lookup is conceptually:

```text
instance override
  ?? definition base property
  ?? absent
```

Do not duplicate all definition properties into every entity instance.

## 3.3 Categories

Categories support semantic grouping and knowledge generalization.

Examples:

```text
category.stone
category.food
category.raw_meat
category.coconut
category.liquid
category.tool
```

Categories are not inheritance classes. An entity type may belong to multiple categories.

---

# 4. Generic interaction model

## 4.1 ActionDefinition

An action defines a reusable verb and its semantic participant roles.

```text
ActionDefinition
  id: ActionId
  roles: ordered RoleDefinition[]
  interruption_class: ActionInterruptionClass
```

Example:

```text
action.hit
  roles:
    actor
    target
    tool
```

The action itself does not encode coconut-specific behavior.

## 4.2 RoleBinding

At runtime, a candidate interaction binds concrete entities/context to roles.

```text
RoleBinding
  role_id -> DomainSubjectRef
```

`DomainSubjectRef` may reference an entity, Wilson, a place/region or another explicitly supported domain subject.

## 4.3 RequirementPredicate

Interaction legality is expressed through a small composable predicate vocabulary.

Minimum required predicate classes:

```text
HasCapability(role, capability)
HasCategory(role, category)
PropertyExists(role, property)
PropertyCompare(role.property, operator, literal)
PropertyCompareRoles(left_role.property, operator, right_role.property)
StatePredicate(role, state/property condition)
SpatialPredicate(role_a, relation, role_b)
KnowledgePredicate(actor, knowledge)
ContextPredicate(registered semantic predicate id)
AllOf(predicates)
AnyOf(predicates)
Not(predicate)
```

The initial implementation should keep `ContextPredicate` registered/typed rather than accepting arbitrary authored scripts.

This predicate vocabulary is intentionally small. Add a new predicate kind only when representative content cannot be expressed cleanly with the existing set.

## 4.4 InteractionRuleDefinition

```text
InteractionRuleDefinition
  id: InteractionRuleId
  action_id: ActionId
  requirements: RequirementPredicate
  resolution: ResolutionSpec
  discovery: DiscoverySpec
  semantic_interaction: optional SemanticInteractionSpec
```

Example conceptually:

```text
rule.break_breakable_by_impact

roles:
  tool
  target

requirements:
  HasCapability(tool, impact_tool)
  HasCapability(target, receives_impact)
  PropertyCompareRoles(
      tool.hardness,
      >=,
      target.break_resistance
  )

resolution:
  classify impact
  if transformation target exists for resulting semantic outcome:
    apply transformation
```

This rule may work for stone, hammer, bowling ball or future objects without adding pair recipes.

## 4.5 Eligibility versus desirability

`InteractionRuleDefinition` answers whether an interaction can be attempted/resolved.

It must not answer whether Wilson wants to do it.

Keep the pipeline:

```text
possible
→ considered
→ evaluated/desirable
→ selected
→ resolved
```

---

# 5. Resolution and transformations

## 5.1 ResolutionSpec

Interaction rules produce semantic outcomes before presentation.

Minimum outcome classes:

```text
SUCCESS
PARTIAL
NO_EFFECT
BLOCKED
FAILURE
```

A resolution must be able to emit:

```text
ResolvedEffect[]
DiagnosticFeedback[]
SemanticOutcomeTag[]
ConsequenceSeverity
```

## 5.2 EffectSpec / ResolvedEffect

Initial effect families:

```text
TransformEntity
ModifyProperty
TransferQuantity
MoveEntity
CreateEntity
DestroyEntity
ApplyBodyEffect
EmitWorldSemanticEvent
```

Definitions describe possible effects; authoritative resolution produces concrete `ResolvedEffect` instances with actual participants/values.

Avoid one generic `execute_script` effect in the domain model.

## 5.3 TransformationDefinition

Transformations describe meaningful form changes.

```text
TransformationDefinition
  id: TransformationId
  source_requirements: RequirementPredicate
  trigger_tags: Set<SemanticOutcomeTag>
  result_type: EntityTypeId
  transfer_policy: TransferPolicy
```

Example:

```text
coconut
+ semantic outcome: sufficient_breaking_impact
→ opened_coconut
```

The transformation is specific to the source/result form, while the interaction that produces `sufficient_breaking_impact` remains generic.

This separation is central:

```text
GENERIC PHYSICS/INTERACTION RULE
  determines what happened semantically

CONTENT TRANSFORMATION
  determines how this object form changes when that outcome occurs
```

## 5.4 TransferPolicy

A transformation declares which runtime metadata survives.

Minimum concerns:

```text
quantity
selected instance identity/history linkage
location
ownership/container relation
explicit transferable state properties
```

Do not blindly copy every state field to a transformed entity.

---

# 6. Affordances

## 6.1 AffordanceQuery

World/domain services must be able to answer:

```text
query_affordances(initiator, local_context)
→ Affordance[]
```

## 6.2 Affordance

```text
Affordance
  action_id: ActionId
  partial_binding: RoleBinding
  missing_roles: RoleId[]
  source_rule_ids: InteractionRuleId[]
  mode: EXPLORATORY | LEARNED_SEMANTIC | DIRECT_PHYSICAL
```

An affordance means the action is materially available enough to consider/complete binding. It does not imply Wilson will choose it.

For UI/context generation, the initiating entity should constrain the search so the system does not enumerate the Cartesian product of all world entities.

---

# 7. Discovery and knowledge

## 7.1 KnowledgeId

Knowledge is identified semantically, not by UI text.

Examples:

```text
knowledge.cook_food_at_fire
knowledge.open_coconut_with_impact_tool
knowledge.category_stone_expected_hard
knowledge.palm_fruit_can_fall
```

## 7.2 KnowledgeEntry

```text
KnowledgeEntry
  id: KnowledgeId
  scope: KnowledgeScope
  confidence: UnitInterval
  source_accessibility: SourceAccessibility
```

Possible scopes:

```text
UNIVERSAL
CATEGORY(CategoryId)
TYPE(EntityTypeId)
INSTANCE(EntityId)
PLACE(PlaceId)
RELATION(SemanticRelationId)
```

## 7.3 Learned semantic interaction

A useful discovered relationship may expose a purposeful semantic interaction.

```text
SemanticInteractionSpec
  knowledge_id: KnowledgeId
  display/action_intent_id: SemanticIntentionId
  applicability: RequirementPredicate
  legacy_eligible: bool
  legacy_weight: finite non-negative weight
```

Important: this is **knowledge of an interaction pattern**, not a physical recipe table.

Example:

```text
knowledge.open_coconut_with_impact_tool

applicability:
  target category coconut
  tool capability impact_tool
  physical interaction rules still validate actual success
```

Knowing the interaction does not bypass authoritative requirements. A soft or broken tool can still fail if the physical rule says it fails.

## 7.4 Discovery pipeline

There is no separate random discovery roll after successful observation.

```text
requirements/context make exploration possible
→ Wilson performs physical/generic action
→ authoritative result occurs
→ Wilson observes sufficient evidence
→ learning produces KnowledgeEntry/update
→ learned semantic interaction becomes available
```

The player-side normal discovery UI follows Wilson's learned interaction knowledge. It does not expose undiscovered semantic interactions from an omniscient catalog.

---

# 8. Wilson aggregate state

Wilson Cognition remains the owner family for durable Wilson-relative state, but concrete storage should remain composed.

```text
WilsonState
  identity: WilsonIdentity
  traits: TraitProfile
  drives: DriveState
  beliefs: BeliefStore
  associations: AssociationStore
  habits: HabitStore
  episodes: EpisodeStore
  intentions: IntentionalState
  presence: PresenceRelationship
```

## 8.1 TraitProfile

```text
TraitProfile
  curiosity: UnitInterval
  risk_tolerance: UnitInterval
  independence: UnitInterval
```

Traits do not drift from ordinary outcomes.

## 8.2 DriveState

```text
DriveState
  hunger: UnitInterval
  energy: UnitInterval
  comfort: UnitInterval
  stimulation: UnitInterval
```

Exact directionality (`1 = urgent` versus `1 = satisfied`) must be chosen once and used consistently in implementation. Prefer domain names that make the direction obvious if separate value objects are introduced.

## 8.3 AssociationEntry

```text
AssociationEntry
  subject: SubjectRef
  valence: SignedUnit
  attachment: UnitInterval
```

## 8.4 HabitEntry

```text
HabitEntry
  cue: HabitCue
  intention_pattern: SemanticIntentionId
  strength: UnitInterval
```

`HabitCue` should use semantic context references, not serialized executable predicates.

## 8.5 Episode

```text
Episode
  id: EpisodeId
  time: SimulationTime
  subjects: SubjectRef[]
  event_kind: SemanticEventId
  expected_outcome: optional OutcomeSummary
  observed_outcome: OutcomeSummary
  importance: UnitInterval
  meaningful_choice: optional ChoiceSummary
  source_accessibility: SourceAccessibility
```

Only selected meaningful episodes are persisted.

## 8.6 PresenceRelationship

```text
PresenceRelationship
  presence_belief: UnitInterval
  trust: SignedUnit
  dependency: UnitInterval
```

---

# 9. Intentional state

```text
IntentionalState
  current: optional IntentionInstance
  suspended: bounded list<IntentionInstance>
```

```text
IntentionInstance
  id: IntentionId
  semantic_intention: SemanticIntentionId
  subjects: RoleBinding
  origin: IntentionOrigin
  commitment: IntentionCommitmentState
  started_at: SimulationTime
```

The candidate set/evaluation scores do not belong here; they remain derived/trace data.

---

# 10. Project domain

```text
ProjectDefinition
  id: ProjectDefinitionId
  eligibility: RequirementPredicate
  contribution_patterns: ProjectContributionSpec[]
  completion: RequirementPredicate
```

```text
ProjectInstance
  id: ProjectInstanceId
  definition_id: ProjectDefinitionId
  lifecycle: ACTIVE | PAUSED | COMPLETED | ABANDONED
  subject_bindings: RoleBinding
  project_metadata: bounded definition-specific semantic values
```

Physical project state remains in world entities. Do not duplicate roof sections/material placement into project metadata if the world already represents them authoritatively.

---

# 11. Player-side domain

Separate active-run intervention state from cross-run profile state.

```text
PlayerDomainState
  run_intervention: PlayerInterventionState
  profile: PlayerProfile
```

## 11.1 PlayerInterventionState

```text
PlayerInterventionState
  god_power: bounded non-negative value
  non_intervention_streak: bounded duration/progression
  suggestion_windows: SuggestionWindowState[]
  game_mode: GameMode
```

God Power capacity does not unlock intervention capability. Validity comes from authored intervention capabilities and mode permissions.

## 11.2 PlayerProfile

```text
PlayerProfile
  id: PlayerProfileId
  legacy_knowledge: Set<KnowledgeId>
  diary: DiaryArchive
  lifetime_stats: LifetimeStats
  global_unlocks: Set<UnlockId>
```

## 11.3 Legacy selection

At `EndRun`:

```text
current Wilson knowledge
→ filter legacy_eligible
→ weighted bounded selection using legacy_weight
→ merge into PlayerProfile.legacy_knowledge
```

The exact count/formula is balance policy, not a domain-model decision.

At `StartRun`:

```text
basic canonical Wilson knowledge
+ PlayerProfile.legacy_knowledge
→ initial Wilson Belief/Knowledge store
```

No episodes, associations, habits, presence relationship or autobiographical source memory transfer cross-run through Legacy Knowledge.

---

# 12. Diary domain

The product has one player-facing Diary surface backed by structured records.

```text
DiaryArchive
  runs: RunDiary[]
```

```text
RunDiary
  run_id: RunId
  started_at: profile-relative timestamp/sequence
  ended_at: optional timestamp/sequence
  milestones: DiaryMilestone[]
  rare_events: DiaryEventRecord[]
  achievements: AchievementRecord[]
  screenshots: ScreenshotRef[]
  run_stats: RunStats
  summary: RunSummaryData
```

The diary projection must preserve epistemic boundaries:

- Wilson-authored prose may only use facts Wilson could know;
- player-facing statistics/history may include allowed structured run metadata outside Wilson narration;
- screenshots are presentation artifacts referenced by domain/profile records, not authoritative simulation truth.

Do not create separate competing global album and diary aggregates.

---

# 13. Luck

Luck is not stored as a Wilson trait or drive.

Model it as a derived query:

```text
LuckContext
  subject: WilsonId
  resolution_kind: LuckSensitiveResolutionId
  world/context refs

LuckModifier
  source_ref
  magnitude: bounded signed value
  applicability

LuckService.evaluate(context, active_modifiers)
→ SignedUnit favorability
```

Rules:

- neutral baseline;
- active world/content effects may add bounded positive/negative modifiers;
- only explicitly luck-sensitive stochastic resolution consumes Luck;
- Luck biases selection among already valid chance outcomes;
- Luck never rewrites established deterministic causality.

---

# 14. Run aggregate and lifecycle

```text
RunState
  id: RunId
  seed: SimulationSeed
  simulation_time: SimulationTime
  world: WorldState
  wilson: WilsonState
  projects: ProjectState
  director: DirectorState
  player_intervention: PlayerInterventionState
  action_execution: optional ActionExecutionState
```

Cross-run `PlayerProfile` is deliberately outside `RunState`.

Lifecycle:

```text
StartRun(profile, seed)
→ bootstrap world + Wilson + run state

WilsonDies
→ finish coherent committed consequence
→ pause for player choice

Resurrect
→ same RunId continues
→ free and unlimited
→ normalize short-lived/body state
→ preserve admitted run continuity

EndRun
→ archive Diary data/statistics
→ select Legacy Knowledge
→ close RunState permanently
```

An ended run is historical data, not a resumable active world.

---

# 15. Contract identity and deterministic traceability

Central cross-system contracts should carry stable causal identity.

Minimum conceptual IDs:

```text
SimulationStepId
DecisionId
ActionExecutionId
OutcomeId
WorldEventId
ObservationId
LearningBatchId
```

Relationships must support tracing:

```text
trigger
→ decision
→ selected intention
→ action execution
→ authoritative outcome
→ world events
→ observation
→ learning batch
→ owner-local mutations
```

Do not use presentation frame IDs as domain ordering.

---

# 16. Seeded randomness

All gameplay randomness enters through an injected deterministic source.

```text
RandomSource
  next(domain_stream, causal_context)
```

Prefer semantic streams/scopes so unrelated presentation changes do not shift gameplay outcomes accidentally.

At minimum separate:

```text
gameplay decision randomness
event/director randomness
world generation randomness
legacy selection randomness
presentation-only randomness
```

Exact PRNG technology is deferred.

---

# 17. Content registries

Concrete implementation should expose validated read-only registries such as:

```text
EntityDefinitionRegistry
ActionDefinitionRegistry
InteractionRuleRegistry
TransformationRegistry
KnowledgeDefinitionRegistry
ProjectDefinitionRegistry
EventDefinitionRegistry
```

Startup/content validation must reject:

- duplicate IDs;
- missing referenced IDs;
- invalid property value types;
- impossible role references;
- malformed predicates;
- transformation targets that do not exist;
- learned interactions referencing nonexistent knowledge/action definitions;
- negative/NaN/infinite weights where forbidden.

Registries are definitions/content lookup, not mutable world state.

---

# 18. First concrete vertical-slice vocabulary

The first implementation should prove the model with the smallest useful vocabulary.

Suggested initial IDs:

```text
Entity types:
  wilson
  coconut
  opened_coconut
  stone
  raw_meat
  cooked_meat
  campfire

Capabilities:
  throwable
  impact_tool
  receives_impact
  food
  cooking_heat_source
  cookable

Properties:
  hardness
  break_resistance
  edible
  food_value
  temperature

Actions:
  observe
  carry
  hit
  throw
  eat
  cook

Knowledge:
  open_coconut_with_impact_tool
  cook_food_at_heat_source
```

This is illustrative vertical-slice scope, not a final content catalog.

A useful first property-driven regression is:

```text
stone.hardness = HIGH
coconut.break_resistance = LOW
stone has impact_tool
coconut receives_impact

hit(coconut, stone)
→ generic impact rule succeeds
→ semantic outcome sufficient_breaking_impact
→ coconut transformation produces opened_coconut
→ observed result creates/reinforces open_coconut_with_impact_tool knowledge
```

Then replace `stone` with another sufficiently hard impact-capable object and require the same rule to work without a new pair-specific recipe.

---

# 19. Explicit anti-models

Do not implement the first domain model as:

```text
Dictionary<string, Variant> everywhere
```

Do not make interaction legality depend on:

```text
if tool.type == stone && target.type == coconut
```

unless a truly unique content exception has been deliberately admitted.

Do not store:

- candidate utility scores as canonical state;
- salience values for every entity;
- full world snapshots inside Wilson memory;
- Godot node references in domain entities;
- presentation assets in authoritative definitions;
- Legacy Knowledge as copied episodes;
- Luck as a permanent Wilson psychology scalar.

---

# 20. Decisions intentionally deferred to package-layout/implementation work

The model above is sufficient to design package boundaries, but these choices remain open:

1. simulation implementation language;
2. exact typed-ID representation;
3. immutable record versus mutable aggregate mechanics;
4. exact property-value encoding and registry authoring format;
5. whether requirements compile into predicate objects, functions or another validated representation;
6. exact WorldLocation/spatial-query representation;
7. persistence schema/versioning;
8. collection/index choices for world queries;
9. exact numeric curves and value scales;
10. exact Legacy selection count/formula;
11. exact Diary screenshot storage adapter.

These should be resolved while designing the package/module layout and headless slice, not by weakening the semantic model above.

---

# 21. Domain-model gate

This first concrete model is acceptable for package-layout work if all of the following remain true:

- object compatibility is property/capability driven rather than recipe-pair driven;
- world truth remains separate from Wilson knowledge;
- learned interactions never bypass physical validation;
- definitions remain separate from runtime instances;
- persistent owners remain aligned with `MUTATION_AUTHORITY.md`;
- derived cognition remains non-persistent by default;
- player profile remains outside active run state;
- Legacy Knowledge seeds new-run knowledge without autobiographical transfer;
- Diary is one player-facing archive surface;
- Luck remains derived and bounded;
- deterministic causal tracing remains possible;
- no Godot/presentation type becomes domain authority.
