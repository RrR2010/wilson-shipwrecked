# Architecture — Authority, Modules and Orchestration

## Status and purpose

This document is the canonical architecture source for Wilson Shipwrecked.

It owns:

- state-owning responsibility boundaries;
- derived/stateless service boundaries;
- language-neutral module/package responsibilities;
- dependency direction and forbidden dependencies;
- application/orchestration responsibilities;
- integration boundaries with Godot, persistence, LLMs and authored content;
- high-level active/offline lifecycle flow.

It does **not** mandate GDScript vs C#, one-class-per-module, ECS, Godot node layout, database technology, serialization format or dependency-injection framework.

The governing principle is:

```text
few explicit state owners
+ typed semantic contracts
+ derived/composable services
+ deterministic orchestration
+ outer presentation/infrastructure adapters
```

The authoritative simulation must remain runnable and testable without rendering.

---

# 1. Architectural invariants

## 1.1 One normal owner per durable state family

A service may read state and produce a proposal/projection/result, but it does not gain mutation authority over the stores it influences.

```text
World                owns physical truth
WilsonCognition      owns Wilson-relative durable cognition
Projects             own project lifecycle state
ActionExecution      owns active/committed action lifecycle
Director             owns directed-event lifecycle
PlayerRunState       owns current-run player-side state
PlayerProfile        owns admitted cross-run state
```

Rendering, graph indexes, salience, expectation, affordance derivation, hazard projection, causal attribution, learning proposals and LLM interpretation are not additional state owners.

## 1.2 Authority != interpretation

```text
world truth
!= Wilson observation
!= Wilson belief
!= player knowledge
!= presentation
```

Player-private intent never becomes Wilson evidence.

## 1.3 Composition over inheritance/type branching

Prefer reusable properties, capabilities, relations, predicates, effects and bounded policies over object-type switch trees or behavior inheritance hierarchies.

## 1.4 Deterministic authority

Gameplay randomness uses named seeded RNG streams. Rendering randomness is separate. Optional LLM output cannot determine authoritative physical truth.

## 1.5 Graph representation != owner

Typed graph/index structures may accelerate traversal, dependency invalidation and knowledge queries, but they never replace the owning state stores.

---

# 2. State-owning responsibility map

```text
Run
├── World
│   ├── entities / places / relations
│   ├── environment / active dynamic processes
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

## 2.1 World

Owns authoritative physical facts:

- entity identity/lifecycle;
- places/transforms;
- mutable physical properties;
- world relations and assembly bindings;
- contents/possession truth;
- environment/weather;
- Wilson body state;
- active time-extended physical processes when persistence is justified;
- grounded physical effects and transformations.

World never depends on Wilson beliefs, preferences, intentions or player-private intent.

## 2.2 Wilson Cognition

Owns:

```text
TraitProfile
DriveState
BeliefStore
AssociationStore
HabitStore
EpisodeStore
IntentionalState
PresenceRelationship
```

Derived attention, expectations, reactions, causal hypotheses and candidate scores do not become durable stores by default.

Cross-effects arrive as semantic evidence/proposals. Each cognition store applies only owner-local mutations.

## 2.3 Projects

Owns project lifecycle, bindings and bounded project metadata.

Physical structures remain World truth. Project state must not duplicate roof integrity, component moisture, assembly bindings or other physical facts.

## 2.4 Action Execution

Owns active action execution and commitment state.

It determines action lifecycle/commit semantics and produces `ActionOutcome` plus validated World mutation plans. It does not learn, update projects or choose Wilson's next intention.

## 2.5 Director

Owns directed-event opportunity lifecycle, cooldown/rarity state and bounded scene framing.

It may introduce opportunities and bounded candidate bias. It never commits Wilson's final intention or edits cognition directly.

## 2.6 Player Run State / Intervention

Owns God Power, non-intervention progress, game-mode permissions and suggestion-window state.

Intervention mutates World only through explicit validated transactions. Suggestions enter Wilson decision competition as signals, not commands.

## 2.7 Player Profile

Owns cross-run admitted state such as Legacy Knowledge, Diary archive, lifetime statistics and global unlocks. It does not leak autobiography into Wilson's new-run cognition.

---

# 3. Derived/composable service families

These services answer questions without owning durable truth.

```text
Perception / PerceptualEvidence
Expectation / prediction error
Salience
EffectivePhysicalProfile
AssemblyValidity
ProtectionProjection / ExposureResult
Affordance / ActionAttemptability
InteractionRegion projection
HazardProjection / PerceivedThreat
Tactical candidate generation/evaluation
Intentional candidate generation/evaluation
Causal investigation / attribution
Reaction
Learning proposal derivation
Luck
```

A service may maintain reconstructible caches/indexes for performance, but save/load truth remains the owner's durable causes.

---

# 4. Language-neutral module layout

The implementation should preserve the following conceptual module families even if exact directories/classes differ.

```text
domain/
  core
  content
  world
  graphs
  physical
  actions
  cognition
  projects
  director
  player
  actors

application/
  simulation
  lifecycle
  queries

infrastructure/
  persistence
  random
  spatial
  content_loading
  diagnostics

presentation/
  godot
  ui
  asset_adapters
```

## 4.1 `domain/core`

Lowest-dependency semantic primitives:

```text
stable IDs / refs
bounded value types
PropertyValue
DomainSubjectRef / RuntimeWorldRef
RequirementPredicate algebra
SemanticPattern algebra
Effect/result envelopes
outcome classifications
trace/causal IDs
registered policy IDs
```

No runtime owner state lives here.

## 4.2 `domain/content`

Immutable authored definitions and validated registries:

```text
EntityDefinition
MaterialDefinition
RelationDefinition
ActionDefinition
InteractionRuleDefinition
TransformationDefinition
PropertyDerivationDefinition
AssemblyDefinition
InteractionRegionDefinition
EnvironmentalResponseRule
EvidenceRuleDefinition
ProjectDefinition
EventDefinition
KnowledgeDefinition / learned interaction definitions
ActorProfileDefinition
Intervention definitions
```

Bootstrap responsibilities include:

```text
reference validation
predicate/pattern validation
capability/category/action-role indexes
PropertyDependencyGraph compilation
cycle checks
relation invariant checks
transformation ambiguity checks
assembly slot predicate validation
registered policy validation
```

The asset catalog is an authoring/backlog source for content requirements, not runtime state or necessarily the serialization format.

## 4.3 `domain/world`

Contains the World state owner and narrow authoritative query/command surface.

Graph indexes over world relations are maintained from committed World mutations but do not become separate authority.

## 4.4 `domain/graphs`

Reusable typed graph/index/query primitives:

```text
WorldRelationGraph indexed view
PropertyDependencyGraph
CompositionDependencyProjection
EpistemicGraphProjection support
SemanticPattern matcher
bounded traversal/result sets
stable semantic ordering
provenance paths
```

This module owns no World or cognition state.

Owner-specific adapters/projections remain attached to the owner supplying facts.

## 4.5 `domain/physical`

Pure/derived physical-semantic services:

```text
effective physical profile
assembly compatibility/validity
protection/exposure
environmental responses
hazards
interaction regions
authoritative affordance/attemptability discovery
```

Typical operations:

```text
ResolveEffectivePhysicalProfile
GetEffectiveProperty
HasEffectiveCapability
QueryAssemblyValidity
QueryCompatibleComponents
ValidateAssemblyBinding
DeriveProtectionProjections
ResolveExposure
QueryApplicableEnvironmentalResponses
DeriveHazardProjection
ResolveInteractionRegion
QueryActionAttemptability
QueryAttemptableActions
```

Never reads Wilson beliefs to decide physical truth.

## 4.6 `domain/actions`

Action execution state owner + committed resolution boundary.

Consumes immutable action/rule definitions and physical queries. Produces grounded `ActionOutcome`, causal identity and World mutation plans.

## 4.7 `domain/cognition`

Wilson cognition owner plus bounded cognition services:

```text
perception
evidence
expectation
salience
decision
investigation
learning
reaction
```

`EpistemicGraphProjection` is only an indexed/projection view over cognition-owned beliefs/propositions. It must not import hidden World facts.

## 4.8 `domain/projects`, `domain/director`, `domain/player`, `domain/actors`

Each contains its established owner and its narrow domain services. None may become a shortcut to mutate another owner's state.

---

# 5. Typed semantic graph placement

Graph-shaped structures are explicit because the normalized content breadth makes traversal/indexing important, but their authority is unchanged.

## 5.1 World relation graph

```text
WorldRelationStore (authoritative)
        ↓ indexed view
WorldRelationGraph
```

Supports bounded typed traversal such as nested contents, component membership, attachment and possession queries.

## 5.2 Property dependency graph

`PropertyDerivationDefinition` compiles into a validated DAG.

Uses:

```text
topological derivation order
cycle validation
localized invalidation
provenance / ExplainEffectiveProperty
```

Derived values may be cached only if reconstructible and deterministically invalidated.

## 5.3 Composition dependency projection

Derived from `part_of`, `attached_to`, contents and assembly bindings.

Used to identify which composite hosts/projections depend on a changed component.

## 5.4 Epistemic graph projection

Indexed view over Wilson propositions/beliefs for bounded subject/type/category and proposition-pattern queries.

```text
WorldRelationGraph != EpistemicGraphProjection
```

No automatic truth leakage or category inheritance is allowed.

## 5.5 Semantic pattern matching

A bounded typed matcher may accelerate:

```text
interaction-rule candidate discovery
assembly component discovery
learned interaction applicability
belief/proposition lookup
project/event eligibility candidate discovery
```

A pattern match only creates candidates. Final validation remains with the owning domain operation.

---

# 6. Dependency direction

Canonical direction:

```text
presentation / external adapters
            ↓
application / orchestration
            ↓
domain owners + derived domain services
            ↓
domain core semantic primitives

content registries supply immutable definitions inward
infrastructure implements outward-facing ports
```

## 6.1 Allowed semantic dependencies

| From | May depend on |
|---|---|
| `core` | nothing higher |
| `content` | core + graph compiler primitives |
| `world` | core + content + relation-index primitives |
| `physical` | core + content + authoritative World query ports + graph projections |
| `actions` | core + content + physical queries + World query/mutation-plan ports |
| `cognition` | core + content + perceived contracts + cognition-owned graph indexes + bounded project/director/player signals |
| `projects` | core + content + World queries + grounded outcomes + bounded Wilson-history projections |
| `director` | core + content + approved World/Cognition projections |
| `player` | core + content + intervention World port + cognition suggestion/evidence boundary |
| application | explicit owner/query/service ports |
| presentation/infrastructure | inward contracts only |

Implementation-level interfaces/ports may reverse imports while preserving this semantic direction.

## 6.2 Forbidden dependencies

```text
WorldState → BeliefStore
EntityInstance → favorite/known flags
PhysicalProfileResolver → AssociationStore
Cognition decision → raw hidden WorldState
EpistemicGraph → WorldRelationGraph truth import
ProjectInstance → duplicate structure integrity
Director → CommitSelectedIntention
Godot UI → direct World property mutation
Asset socket → domain AssemblyRole identity
Graph index → mutation authority
Persistence DTO → define domain meaning
```

---

# 7. Application/orchestration layer

Application coordinates domain owners but owns no gameplay truth.

## 7.1 Active semantic loop

```text
advance due World/body/environment/dynamic processes
→ advance current ActionExecution
→ commit owner-local authoritative mutations in deterministic causal order
→ collect ActionOutcome / WorldEvent
→ Perceive / derive PerceptualEvidence
→ immediate-threat check
→ immediate relevant learning when required
→ route TACTICAL vs INTENTIONAL reconsideration
→ select/validate/start next action when required
→ process grounded project/director consequences
→ maintenance
→ presentation/debug projection
```

The render frame is never the authoritative simulation clock.

## 7.2 Reconsideration

Normal scopes:

```text
TACTICAL
INTENTIONAL
IMMEDIATE_THREAT
```

Tactical asks how to continue the current intention. Intentional asks whether to continue/suspend/change objectives. Immediate threat uses a narrow defensive regime rather than extreme utility constants.

## 7.3 Semantic change sets for derived index maintenance

A committed owner mutation may produce a bounded internal `SemanticChangeSet` used only to invalidate/rebuild reconstructible derived indexes.

Example:

```text
binding_integrity(binding_7) changed
→ PropertyDependencyGraph identifies downstream property families
→ CompositionDependencyProjection identifies affected host(s)
→ invalidate cached EffectivePhysicalProfile(tool_3)
```

This is **not** a generic event bus for gameplay side effects. Gameplay reactions still flow through explicit outcomes/events/perception/learning.

## 7.4 Multi-owner lifecycle transactions

Application lifecycle orchestration owns ordering, not durable state, for:

```text
player intervention transaction
death/resurrection
End Run / Legacy extraction
offline catch-up
save/load reconstruction
```

---

# 8. Contact contracts

Keep cross-boundary contacts deliberately small and semantic.

```text
World → cognition:
  PerceptionResult / ObservedEvent / PerceptualEvidence

Cognition → action execution:
  SelectedIntention / SelectedTactic + role binding

Action execution → World/application:
  ActionOutcome + WorldMutationPlan

Action outcome → cognition/projects/director:
  grounded semantic consequence only

Player → cognition:
  SuggestionSignal or perceivable intervention consequence

Director → cognition:
  temporary opportunity / bounded bias
```

No owner receives another owner's private store for unrestricted mutation.

---

# 9. Project flow

```text
Project definition/state
→ exposes eligible semantic contribution opportunity
→ normal Wilson candidate generation/competition
→ selected intention/tactic
→ physical action validation/resolution
→ World mutation
→ grounded ActionOutcome/world facts
→ Project owner updates lifecycle/progress
```

Resources are not globally reserved merely because a project could use them.

---

# 10. Player intervention flow

Physical/environmental intervention:

```text
player request
→ permission + capability + cost validation
→ atomic PlayerRunState/World transaction
→ WorldEvent
→ perception
→ attribution/reaction/learning only if Wilson can observe/infer it
```

Suggestion:

```text
SuggestionSignal
→ candidate source/evaluator contribution
→ normal competition
→ normal physical validation
```

---

# 11. Offline simulation

Offline catch-up reuses normal domain semantics under a conservative policy.

It may coarse-step ordinary environment, drives, projects and learning while suppressing forbidden outcome classes such as death, rare spectacle and major discovery consumption.

Offline is a policy around the same domain, not a second simulation architecture.

---

# 12. Presentation / Godot boundary

Godot consumes semantic state/projections and realizes:

```text
navigation geometry
animation
sound/particles
camera/UI
visual interpolation
state-band presentation
interaction anchors/regions
assembly/body/perch presentation adapters
```

Godot nodes, scene paths, meshes and sockets are not domain identity.

UI queries authoritative attemptability/affordances; it does not duplicate legality rules.

---

# 13. Persistence boundary

Persist durable causes; reconstruct derived projections/indexes.

Persist conceptually:

```text
World authoritative state and active required dynamic processes
Wilson cognition durable stores
meaningful current/suspended intention state
Projects
Director state required for continuity
PlayerRunState / PlayerProfile
required deterministic RNG state
```

Normally reconstruct:

```text
WorldRelationGraph indexes
PropertyDependencyGraph compiled runtime caches
CompositionDependencyProjection
EffectivePhysicalProfile
AssemblyValidity
ProtectionProjection / ExposureResult
HazardProjection
EpistemicGraph indexes
salience / expectations / candidate evaluations
most transient reactions
```

Save/load of active semantic processes keeps only state required for coherent deterministic reconstruction.

---

# 14. External AI boundary

Optional LLM use is outer-layer bounded interpretation/expression only.

Allowed examples:

```text
bounded reweight among already plausible causal hypotheses
bounded reweight among eligible ambiguous intention candidates
speech/thought/diary wording from structured grounded state
rare authored-variant embellishment
```

Every path has a deterministic fallback. LLM output never directly mutates World or invents authoritative memories/knowledge.

---

# 15. Testing architecture

## Pure service tests

Examples:

```text
property derivation / graph invalidation
assembly validity
expectation inference
candidate evaluator contributions
belief/association/habit updates
causal hypothesis weighting
semantic pattern matching
```

## Contract tests

Examples:

```text
Action Resolution never mutates beliefs
World never reads Wilson cognition
suggestion never bypasses selection
Project never executes Wilson action
EpistemicGraph never imports hidden World truth
player private intent never updates trust
LLM failure never changes authoritative physical result
```

## Fixture/regression tests

Use the canonical scenario fixtures for integration coverage:

```text
Scientific Method
Falling Palm
Sabotaged Storage
Improvised Hammer
Cloth Shelter Weather
representative scene suite
```

## Headless statistical simulation

Measure behavior distributions, stagnation, lock-in, belief/association saturation, project dynamics, death/risk rates, event frequency and God Power economy across deterministic seeds rather than forcing each run toward the same outcome.

---

# 16. Fixture dependency review

## Scientific Method — PASS

```text
content rules/regions
→ physical attemptability
→ action resolution
→ World mutation/outcome
→ perception/evidence/learning
→ tactical decision
```

No physical service needs cognition internals.

## Falling Palm — PASS

```text
World DynamicProcessState
→ HazardProjection
→ perception
→ PerceivedThreat
→ immediate-threat decision
→ ordinary action/world resolution
```

Wilson never reads hidden authoritative hazard projection directly.

## Sabotaged Storage — PASS

```text
World relation truth
→ observation coverage/evidence
→ expectation mismatch/investigation
→ EpistemicGraphProjection for Wilson-relative lookup
```

Actual cause remains distinct from Wilson attribution.

## Improvised Hammer — PASS

```text
World bindings
→ CompositionDependencyProjection
→ AssemblyValidity / EffectivePhysicalProfile
→ action attemptability/resolution
```

No Crafting owner is needed.

## Cloth Shelter Weather — PASS

```text
World/environment
→ ResolveExposure / EnvironmentalResponse
→ World property/relation mutation
→ graph-aware localized invalidation
→ effective profile / protection recomputation
```

Projects continue to query rather than duplicate physical truth.

---

# 17. Architectural anti-patterns

Reject by default:

```text
Giant WilsonBrain
one mutable System per noun
cross-store mutation
EverythingGraph / universal triple store
pair-specific interaction recipes
universal GOAP hierarchy
presentation authority
one global utility god-function
unbounded global event bus
persisted derived caches becoming truth
object-type branching where property/capability composition suffices
```

---

# 18. Implementation sequence

The architecture/domain are now ready for concrete implementation planning.

Recommended sequence:

```text
1. concrete core IDs/refs/value types
2. immutable content definitions + bootstrap validation/index compilation
3. World state + relation graph/index query surface
4. physical profile / assembly / attemptability services
5. action execution + ActionOutcome
6. perception/evidence + minimal cognition stores
7. tactical/intentional decision loop
8. project/player/director integration
9. persistence/reconstruction
10. Godot presentation adapters
11. deterministic fixture/headless regression harness
```

The first vertical slice should exercise the existing fixtures rather than invent a parallel simplified architecture.