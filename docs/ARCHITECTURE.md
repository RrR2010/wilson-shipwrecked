# Architecture — Authority, Modules and Orchestration

## Status and purpose

This document is the canonical architecture source for Wilson Shipwrecked.

It owns:

- state-owning responsibility boundaries;
- derived/stateless service boundaries;
- language-neutral module/package responsibilities;
- dependency direction and forbidden dependencies;
- application/orchestration responsibilities;
- Godot/persistence/LLM/authored-content boundaries;
- high-level active/offline lifecycle flow.

It does **not** mandate GDScript vs C#, ECS, one-class-per-module, Godot node layout, database technology, serialization syntax or dependency-injection framework.

Concrete implemented foundation status/schema versions/test checkpoints belong in `DISCOVERY_STATUS.md`.

Governing shape:

```text
few explicit state owners
+ typed semantic contracts
+ derived/composable services
+ deterministic orchestration
+ outer presentation/infrastructure adapters
```

The authoritative simulation remains runnable/testable without rendering.

---

# 1. Architectural invariants

## One normal owner per durable state family

A service may read state and produce a proposal/projection/result, but it does not gain mutation authority over the store it influences.

```text
World                owns physical truth
WilsonCognition      owns Wilson-relative durable cognition
Projects             own project lifecycle state
ActionExecution      owns active/committed action lifecycle
Director             owns directed-opportunity lifecycle
PlayerRunState       owns current-run player-side state
PlayerProfile        owns admitted cross-run state
```

Rendering, graph indexes, effective profiles, assembly validity, salience, expectation, affordance derivation, hazard projection, causal attribution, learning proposals and LLM interpretation are not additional state owners.

## Authority != interpretation

```text
World truth
!= Wilson observation
!= Wilson belief
!= player-private intent/knowledge
!= presentation
```

## Composition over type branching

Prefer reusable typed properties, capabilities, relations, predicates, effects, claims and bounded policies over object-type switch trees or behavior inheritance hierarchies.

## Deterministic authority

Gameplay randomness uses named seeded streams. Presentation randomness is separate. Optional LLM output cannot determine authoritative physical truth.

## Projection/index != owner

Typed graph/index/cache structures accelerate queries/invalidation but never replace their authoritative cause stores.

---

# 2. State-owning responsibility map

```text
Run
├── World
│   ├── entities / places / relations
│   ├── environment / active physical processes
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

## World

Owns entity identity/lifecycle, authoritative placement, mutable physical properties, qualified world relations/assembly bindings, contents/possession, environment/weather, Wilson body, shallow actors and grounded physical processes/effects.

World never depends on Wilson beliefs/preferences/intentions or player-private intent.

## Wilson Cognition

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

## Projects

Owns project lifecycle, bindings and bounded project metadata. Physical structures/components remain World truth.

## Action Execution

Owns active/committed/interrupted/completed execution lifecycle. It determines commit semantics and produces `ActionOutcome`; it does not mutate cognition/projects or choose the next intention.

## Director

Owns directed-opportunity eligibility/active/cooldown/rarity lifecycle. It may add opportunities/bounded bias, never commit Wilson's final intention.

## Player Run State / Intervention

Owns God Power, non-intervention progress, mode permissions and suggestion-window state. Physical intervention reaches World only through explicit validated operations; suggestions are signals, not commands.

## Player Profile

Owns admitted cross-run Legacy Knowledge, Diary/archive, lifetime stats and unlocks. It does not leak autobiographical memory into a new Wilson run.

---

# 3. Derived/composable service families

```text
Perception / PerceptionAccess / PerceptualEvidence
Expectation / prediction error
Salience
EffectivePhysicalProfile
AssemblyValidity
ProtectionProjection / ExposureResult
Affordance / ActionAttemptability
InteractionRegion projection
HazardProjection / PerceivedThreat
Tactical / intentional candidate derivation
Causal investigation / attribution
Reaction
Learning proposal derivation
Luck
```

Reconstructible caches/indexes are allowed for performance if deterministic invalidation/rebuild is explicit.

---

# 4. Language-neutral module layout

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

These are conceptual responsibility families, not a one-directory/one-class mandate.

## domain/core

Stable typed IDs/refs, bounded semantic scalar identity, result envelopes and lowest-dependency primitives.

## domain/content

Immutable authored definitions and validated registries. Bootstrap validates references, bounded predicates/selectors/policies, property schemas, graph cycles and content invariants before simulation.

Current/future examples include:

```text
PropertyDefinition
EntityDefinition
EventDefinition
ActionDefinition / ActionResolutionDefinition
AssemblyDefinition
PropertyDerivationDefinition
InteractionRuleDefinition
TransformationDefinition
ProjectDefinition
DirectedEventDefinition
ActorProfileDefinition
```

The asset catalog is an authoring/backlog source, not runtime state or the serialization specification.

## domain/world

World owner plus narrow authoritative query/command surfaces. Relation indexes are reconstructible from `WorldRelationStore` truth.

## domain/graphs

Typed graph/index/query concepts such as relation traversal, property dependencies, composition dependencies, epistemic projection and bounded pattern matching. Implementations may physically place owner-specific projections near their owner/domain package; the architectural concern remains non-authoritative.

## domain/physical

Pure/derived physical semantics: effective profile, assembly, protection/exposure, environmental response, hazards, interaction regions and authoritative attemptability.

## domain/actions

Action execution lifecycle, role binding, committed outcome generation and action-specific resolution definitions.

## domain/cognition

Cognition owners + bounded perception/evidence/expectation/decision/investigation/learning services. Epistemic indexes derive only from cognition-owned beliefs.

## projects/director/player/actors

Each preserves its owner and narrow services; none becomes a shortcut to mutate another owner's state.

---

# 5. Typed semantic graph/index placement

## World relation view

```text
WorldRelationStore (authoritative)
→ reconstructible outgoing/incoming/type indexes
→ bounded relation queries/traversal
```

Exact relation identity includes optional bounded qualifier. Broad endpoint queries may return multiple qualified edges.

## Property dependency graph

`PropertyDerivationDefinition[]` compile to a validated DAG supporting topological derivation, cycle rejection, localized invalidation and property provenance.

## Composition dependency projection

Derived from admitted structural/assembly relations and used to find hosts whose derived physical profiles depend on a changed component.

```text
component change
→ CompositionDependencyProjection
→ dependent hosts
→ derived-cache invalidation
```

## Epistemic graph projection

Indexed read view over `BeliefStore` typed claims. It never imports World truth.

## Semantic pattern matching

Bounded typed matcher for candidate discovery. Pattern match never becomes final authority.

---

# 6. Dependency direction

Canonical semantic direction:

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

### Allowed dependency intent

| From | May depend on |
|---|---|
| core | nothing higher |
| content | core + validation/compiler primitives |
| world | core + immutable content + relation-index primitives |
| physical | core + content + narrow World query + graph projections |
| actions | core + content + physical/attemptability queries + explicit outcome contracts |
| cognition | core + content + perceived contracts + cognition-owned projections + bounded project/director/player signals |
| projects | core + content + World queries + grounded outcomes + bounded Wilson-history projections |
| director | core + content + approved World/Cognition projections |
| player | core + content + intervention World port + cognition suggestion/evidence boundary |
| application | explicit owner/query/service ports |
| presentation/infrastructure | inward contracts only |

Implementation-level ports may reverse imports while preserving semantic direction.

### Forbidden dependencies

```text
WorldState → BeliefStore
EntityInstance → favorite/known flags
Physical resolver → AssociationStore
cognition decision → raw hidden WorldState
EpistemicGraph → World relation truth import
ProjectInstance → duplicate physical integrity
Director → CommitSelectedIntention
Godot UI → direct World mutation
asset socket → AssemblyRole identity
index/cache → mutation authority
persistence DTO → define domain meaning
```

---

# 7. Application/orchestration

Application coordinates owners but owns no gameplay truth.

Canonical active semantic order:

```text
advance due World/body/environment/process state
→ advance active ActionExecution
→ cross commit boundary if due
→ World owner validates/applies ActionOutcome effects
→ collect WorldEvent + SemanticChangeSet
→ invalidate/rebuild affected derived projections
→ derive perception access
→ Perceive / PerceptualEvidence
→ immediate relevant learning when required
→ immediate-threat / tactical / intentional routing
→ commit selected intention
→ validate/start next action when required
→ grounded project/director consequences
→ maintenance
→ presentation/debug projection
```

Rendering FPS is never the authoritative clock.

## SemanticChangeSet

A committed owner mutation may produce a bounded internal change set solely for reconstructible derived maintenance.

```text
property/relation changed
→ affected local property outputs / composite hosts
→ invalidate derived profile caches
```

It is **not** a generic event bus for gameplay reactions. Those flow through explicit outcomes/events/perception/learning.

## Multi-owner lifecycle orchestration

Application owns deterministic ordering, not durable state, for intervention, death/resurrection, End Run, offline catch-up and save/load reconstruction.

---

# 8. Contact contracts

Keep cross-boundary contracts small and semantic.

```text
World/action commit → cognition:
  WorldEvent → PerceptionAccess → ObservedEvent / PerceptualEvidence

Cognition → action execution:
  SelectedIntention / selected tactic + RoleBinding

Action execution → World/application:
  ActionOutcome

World mutation → derived maintenance:
  SemanticChangeSet

Grounded outcome → projects/director/cognition:
  explicit consequence/result projection only

Player → cognition:
  SuggestionSignal or perceivable intervention consequence

Director → cognition:
  temporary opportunity / bounded bias
```

No owner receives another owner's private store for unrestricted mutation.

---

# 9. Action lifecycle and causality

Action execution separates:

```text
attemptability at start
progress
commit point
post-commit tail
terminal completion/interruption
cleanup
```

Committed physical truth cannot be rewound by later reconsideration, suggestion or Luck.

The current coarse interruption contract uses `PRE_COMMIT_ONLY`, `NEVER`, `ANYTIME`; richer safe checkpoints may be introduced later only with representative evidence.

Reconstruction restores past execution causality without rerunning current attemptability against history.

---

# 10. Spatial/perception boundary

Domain physical identity does not depend on Godot transforms.

The structural foundation admits coarse semantic placement (`PlaceId`) as authoritative World truth and derives co-location/bounded nearby access from it.

Fine distance, navigation, occlusion, visibility/hearing geometry and transform interpolation belong behind infrastructure/presentation adapters.

`EventDefinition` describes an ordinary WorldEvent kind's potentially perceptible roles/modalities; runtime spatial access decides what Wilson actually observes.

---

# 11. Epistemic boundary

Durable belief identity is typed:

```text
EpistemicClaim
  PROPERTY
  RELATION
  EVENT
```

`PerceptualEvidence` carries a typed claim + confidence/provenance. `BeliefStore` owns confidence mutation. `EpistemicGraphProjection` indexes only those beliefs.

Future epistemic families extend typed claim semantics explicitly; do not reintroduce generic arbitrary predicate/argument identity.

---

# 12. Project and intervention flows

## Project

```text
Project definition/state
→ eligible semantic contribution opportunity
→ ordinary Wilson candidate competition
→ action validation/execution
→ World mutation/outcome
→ Project owner validates grounded contribution
→ project lifecycle mutation
```

Resources are not globally reserved because a project could use them.

## Player intervention

```text
player request
→ permission/capability/cost validation
→ explicit transaction
→ World mutation
→ WorldEvent
→ perception
→ cognition changes only from observable/inferable evidence
```

Suggestion remains a bounded decision signal.

---

# 13. Offline simulation

Offline catch-up reuses the same domain semantics under conservative policy. It may coarse-step ordinary processes/drives/projects while suppressing forbidden classes such as death, rare spectacle consumption and opaque major relation swings.

Offline is policy around the same simulation, not a second architecture.

---

# 14. Presentation / Godot boundary

Godot realizes navigation geometry, animation, sound/particles, UI/camera, interpolation, visual state bands, semantic anchors/regions and assembly/body/perch adapters.

Godot nodes, scene paths, meshes and sockets are not domain identity. UI queries authoritative attemptability/affordances instead of duplicating legality.

---

# 15. Persistence boundary

Persist durable causes/minimal active lifecycle state; reconstruct derived projections.

Persist conceptually:

```text
World authoritative state / required active processes
Wilson durable cognition
meaningful current/suspended intention state
ActionExecution lifecycle required for causality
Projects
Director continuity state
PlayerRunState / PlayerProfile
required gameplay RNG state
```

Reconstruct normally:

```text
relation indexes
compiled property graph/cache
CompositionDependencyProjection
EffectivePhysicalProfile
AssemblyValidity
Protection/Exposure projections
HazardProjection
EpistemicGraph indexes
salience/expectations/candidate evaluations
most transient reactions
```

Persistence schema versions are implementation contracts and may evolve during development; incompatible development schemas fail explicitly rather than silently reinterpret meaning.

---

# 16. Authored-content boundary

Authoring format is infrastructure, not domain authority.

A loader may parse JSON/resources/etc. into typed definitions, but simulation starts only after registry/bootstrap validation succeeds.

Authoring must remain bounded/declarative:

```text
no arbitrary callbacks
no arbitrary Dictionary semantic qualifiers
no unbounded graph selectors
no unknown property families/policies
no dangling semantic references
```

---

# 17. External AI boundary

Optional LLM use is outer-layer bounded interpretation/expression only: reweight already plausible hypotheses/candidates, generate grounded wording, or select among admitted variants.

Every path has a deterministic fallback. LLM output never directly mutates World or invents authoritative memories/knowledge/physical validity.

---

# 18. Testing architecture

## Pure service tests

Examples: property derivation/invalidation, assembly validity, predicate/attemptability, belief revision, candidate evaluation, causal weighting.

## Contract tests

Examples:

```text
ActionExecution never mutates World
World never reads cognition
suggestion never bypasses selection
Project never executes Wilson action
EpistemicGraph never imports hidden World truth
player-private intent never updates trust
LLM failure never changes authoritative physical result
```

## Reconstruction tests

Save/load must rebuild equivalent semantic queries and must not replay committed outcomes.

## Scenario/scale tests

Use representative causal scenarios, larger relation/belief sets, bounded traversal/query checks and deterministic seed populations. Avoid wall-clock assertions as gameplay semantics.

The strict headless runner is the implementation gate; `DISCOVERY_STATUS.md` records the current count.

---

# 19. Architectural anti-patterns

Reject by default:

```text
Giant WilsonBrain
one mutable System per noun
cross-store mutation
EverythingGraph / universal triple store
pair-specific recipes
universal GOAP hierarchy
presentation authority
one global utility god-function
unbounded global event bus
persisted derived caches becoming truth
object-type branching where composition suffices
arbitrary Variant/Dictionary semantic identity
```

---

# 20. Phase boundary

The **structural runtime foundation is complete**. This document should no longer carry an implementation roadmap for that foundation.

New work should implement system breadth — drives/body, projects, richer cognition producers, environment/processes, hazards/protection, shallow animals, Director/player/run lifecycle and Godot adapters — through the established owners/contracts.

A new owner/framework/core primitive requires concrete representative evidence that the existing architecture cannot express the behavior cleanly.
