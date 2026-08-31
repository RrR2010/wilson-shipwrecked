# Handoff — Structural Runtime Foundation → System Implementation

## Purpose

This handoff transfers Wilson Shipwrecked from the completed **structural runtime foundation** phase into **system implementation / gameplay breadth**.

It is operational transition context, not new design authority. When this handoff conflicts with a canonical document, the canonical document wins. Use [`../README.md`](../README.md) for documentation authority and [`../DISCOVERY_STATUS.md`](../DISCOVERY_STATUS.md) for the current implementation baseline.

---

# 1. Current phase

The project has closed:

```text
FUNCTIONAL DOMAIN               COMPLETE
STRUCTURAL RUNTIME FOUNDATION   COMPLETE
DOCUMENTATION CONSOLIDATION     COMPLETE
```

Current strict runtime checkpoint:

```text
Godot 4.7.1
PASS headless_suite (23 tests)
```

The next task is **not** another architecture-discovery pass. The task is to make Wilson's simulation broader by implementing missing owner/service families through the already-validated contracts.

Guiding rule:

```text
expand gameplay breadth through existing contracts
before introducing new primitives or state owners
```

---

# 2. Required reading

Always start with:

```text
AGENTS.md
README.md
docs/README.md
docs/DISCOVERY_STATUS.md
```

For runtime/system work, then read:

```text
docs/ARCHITECTURE.md
docs/SIMULATION_CONTRACTS.md
docs/SIMULATION_ORCHESTRATION.md
docs/MUTATION_AUTHORITY.md
docs/DOMAIN_OPERATIONS.md
```

Add only the relevant semantic owners for the slice:

```text
BEHAVIORAL_MODEL.md
STATE_REQUIREMENTS.md
GUARDS_AND_CALIBRATION.md
DOMAIN_MODEL.md
DOMAIN_VOCABULARY.md
DOMAIN_CATALOGS.md
DOMAIN_PROCEDURAL_COMPOSITION.md
DOMAIN_ENVIRONMENTAL_PROTECTION.md
DOMAIN_HAZARD_DYNAMICS.md
DOMAIN_EPISTEMIC_INVESTIGATION.md
DOMAIN_MICRO_LOOP.md
```

Fixtures/regressions are behavioral evidence. They do not override canonical contracts.

---

# 3. Foundation that must not regress

## Authority

Durable owner families remain:

```text
World
Wilson Cognition
Projects
Player Run State / Intervention
Director
Action Execution / Resolution
Player Profile across runs
```

Derived services/indexes/projections do not become authorities because they are convenient to cache.

Keep separate:

```text
world truth
!= Wilson observation
!= Wilson belief
!= Wilson desirability
!= player-private intent
```

## World boundary

Preserve:

```text
owner stores   = authoritative state
query ports    = narrow semantic reads
domain services = derivation/proposals
commands        = validated owner-local mutation
```

Do not pass unrestricted stores into components that only need a query.

Do not let presentation, cognition, projects or Director mutate World directly.

## Mutation causality

The validated direction is:

```text
ActionExecution
→ ActionOutcome
→ validated World commit
→ WorldEvent + SemanticChangeSet
→ derived invalidation
→ Perception
→ PerceptualEvidence
→ owner-local learning
→ reconsideration / decision
→ CurrentIntention
```

`SemanticChangeSet` is an invalidation contract, not a gameplay event bus.

## Action commitment

Committed physical consequence cannot be rewound by:

```text
reconsideration
player suggestion
Luck
save/load
```

Current interruption classes are:

```text
PRE_COMMIT_ONLY
NEVER
ANYTIME
```

Do not collapse them back to a single `interruptible` boolean.

## Relations

World relation identity is exact and includes admitted qualifier semantics.

Do not restore APIs that remove a relation only by:

```text
(type, subject, object)
```

when distinct qualified relations can coexist.

Do not reintroduce arbitrary qualifier Dictionaries.

## Physical composition

Use the existing primitives:

```text
PropertyDefinition
PropertyValue
PropertyDependencyGraph
EffectivePhysicalProfile
AssemblyValidity
AssemblyBindingProjection
CompositionDependencyProjection
```

A structurally `VALID` assembly may still perform poorly. Do not add universal `tool_quality`, `assembly_quality` or `structure_quality` shortcuts.

Component property changes must continue to invalidate dependent composite hosts transitively.

## Epistemics

Durable epistemic identity currently uses:

```text
EpistemicClaim.PROPERTY
EpistemicClaim.RELATION
EpistemicClaim.EVENT
```

Do not restore generic persisted:

```text
predicate + Variant[] arguments
```

If a new durable claim family becomes necessary, add an explicit typed claim kind with bounded semantics and tests.

Causal hypotheses/investigation working sets remain derived unless new evidence proves persistence is necessary.

## Event terminology

Use:

```text
EventDefinition
  authored semantic definition for a WorldEvent kind

WorldEvent
  authoritative occurrence fact

ObservedEvent
  Wilson-accessible projection

DirectedEventDefinition / DirectedEventInstance
  Director-owned opportunity lifecycle
```

Do not overload `EventDefinition` for Director-owned content.

## Spatial boundary

The coarse semantic spatial foundation is already implemented and tested:

```text
EntityInstance.place_id
WilsonWorldState.place_id
→ bounded nearby/co-location queries
→ CoarsePerceptionAccessResolver
```

Fine distance, occlusion, route planning, navmesh and Godot transforms remain future adapters behind the same semantic boundary.

Do **not** repeat the coarse spatial/perception foundation as the next vertical.

## Persistence

Persist causes. Rebuild projections/indexes/caches.

Current development schema versions are documented in `DISCOVERY_STATUS.md`. Unsupported development schemas may fail fast; do not add migration machinery for abandoned pre-foundation snapshots unless explicitly required.

## Godot / presentation

Godot nodes, scene paths, sockets, navmesh IDs, colliders, meshes and animation names are adapters, never domain identity.

Render FPS is not the authoritative simulation clock.

---

# 4. What the 23-test foundation already proves

The existing runtime covers:

```text
typed DomainId / RuntimeWorldRef
immutable content registry
bounded JSON ContentPack loading
PropertyDefinition validation
EntityStore / WorldRelationStore / WilsonWorldState
qualified relation identity + reconstructible indexes
coarse semantic spatial query/perception access
PropertyDependencyGraph / EffectivePhysicalProfile
AssemblyBindingProjection / AssemblyValidity
CompositionDependencyProjection / transitive invalidation
SemanticPattern / RequirementPredicate
ActionAttemptability
ActionExecution commit/interruption/reconstruction
prevalidated supported World effect batches
SemanticChangeSet
EventDefinitionId → WorldEvent → ObservedEvent
EpistemicClaim → PerceptualEvidence → BeliefStore
EpistemicGraphProjection
candidate generation / decision routing
CurrentIntention
application micro-loop / semantic trace
save → JSON → load → rebuild
larger causal/structural reconstruction scenarios
```

Before adding a new abstraction in one of these areas, inspect the existing implementation/tests and reuse the established primitive.

---

# 5. Recommended next implementation sequence

Default order:

```text
1. body/drives + bounded candidate producers
2. Project runtime + project candidate producer
3. habits / associations / episodes / Presence learning producers
4. environment + persisted dynamic processes
5. protection / exposure + hazards / immediate-threat production
6. shallow non-Wilson actor behavior
7. Director + player intervention / suggestions
8. run lifecycle / death / resurrection / Legacy / PlayerProfile
9. fine spatial/nav/occlusion + Godot presentation adapters
10. representative multi-system scenarios + seed-population tests
```

Do not attempt all systems at once. Prefer one vertical that creates player-visible systemic behavior and exercises the existing end-to-end chain.

---

# 6. First recommended vertical — body/drives → candidate production

Unless current repository changes clearly supersede this handoff, start here.

The goal is **not** a giant `WilsonBrain`.

Implement owner-local drive state, bounded progression and small semantic candidate producers feeding the existing decision competition.

Accepted primitive drives are:

```text
hunger
energy
comfort
stimulation
```

Accepted stable traits are:

```text
curiosity
risk_tolerance
independence
```

Do not introduce `sanity`, `safety`, `loneliness`, `cleanliness`, `fun`, global `mood` or similar meters merely because one behavior is easier to express with another scalar.

## Intended shape

```text
DriveState owner
→ bounded time/outcome updates
→ urgency projection / semantic trigger
→ DriveCandidateSource
→ CandidateIntention[]
→ existing evaluation/routing/selection
→ cognition owner commits CurrentIntention
```

Physical body truth remains separate from motivational state:

```text
injury / wetness / poisoning / vitality
→ World/Wilson body truth

hunger / energy / comfort / stimulation
→ Wilson cognition drive state
```

Drive updates may consume admitted body/environment consequences, but a drive store does not become authoritative over body physics.

## Required guards

Follow `GUARDS_AND_CALIBRATION.md`:

```text
finite bounds
saturating/diminishing updates where appropriate
hysteretic urgency bands
no huge/infinite candidate scores
no threshold-trigger spam
no hidden normalization toward target behavior distributions
```

## Suggested regression coverage

At minimum prove:

```text
1. drive progression remains bounded;
2. hunger/energy urgency can produce semantic candidates;
3. ordinary small drive changes do not trigger reconsideration every tick;
4. urgency-band crossing emits one meaningful reconsideration trigger;
5. immediate threat still wins by regime, not giant score;
6. a drive candidate can lose to another legitimate candidate;
7. save/load preserves durable drive/current-intention continuity;
8. selected drive-related behavior still passes authoritative ActionAttemptability.
```

Prefer focused pure tests plus one application-loop regression.

---

# 7. Projects

Project physical truth remains World-owned.

A Project owner may persist:

```text
project instance identity
lifecycle
semantic bindings
bounded project metadata
```

It must not duplicate:

```text
roof/component integrity
moisture
assembly bindings
world placement
contents
```

Expected flow:

```text
ProjectDefinition / ProjectInstance
→ contribution opportunity
→ project candidate source
→ normal decision competition
→ normal action
→ World commit
→ grounded ActionOutcome
→ project owner validates contribution
→ lifecycle/progress mutation
```

Projects do not command Wilson and do not pre-reserve arbitrary world resources merely because a project might use them.

A good first project vertical is a small shelter contribution using existing entities/relations/composition rather than a bespoke building subsystem.

---

# 8. Cognition breadth

Add the remaining owner-local cognition families incrementally:

```text
AssociationStore
HabitStore
EpisodeStore
PresenceRelationship
```

Learning remains proposal-based:

```text
WorldEvent / ActionOutcome
→ Perception
→ typed evidence
→ BeliefEvidence / AssociationImpact / HabitEvidence / EpisodeCandidate / PresenceEvidence
→ each owner mutates only its own store
```

Do not let a learning coordinator cascade direct writes into sibling stores.

Useful regressions should prove contradictory evidence, diminishing repetition, bounded relationship updates and different Wilson histories producing different interpretations of the same current World result.

---

# 9. Environment and dynamic processes

Implement reusable World-owned processes such as:

```text
drying
spoilage
fire consumption
weather effects
structural weakening
wave/wind movement where admitted
```

Keep:

```text
committed process evolution
!= predetermined future victim/collision outcome
```

Persist only dynamic-process state required for coherent reconstruction.

Environmental rules should normally mutate ordinary authoritative properties/processes such as moisture, temperature or structural integrity rather than secretly altering effective profiles through invisible global context.

Offline policies remain conservative:

```text
no death offline
no rare spectacle/discovery consumption
no opaque extreme relationship swings
```

---

# 10. Protection, hazards and immediate threat

Reuse the specialized contracts.

Keep distinct:

```text
covering capability
ProtectionProjection
ExposureResult
HazardProjection
PerceivedThreat
```

Wilson's emergency path consumes `PerceivedThreat`, never hidden `HazardProjection` directly.

Expected flow:

```text
World process
→ authoritative hazard/protection projection
→ perception access
→ PerceivedThreat
→ IMMEDIATE_THREAT routing
→ ordinary validated action
```

Falling Palm exists specifically to protect the distinction between a committed process and an unresolved future consequence.

---

# 11. Shallow non-Wilson actors

Animals should remain materially simpler than Wilson unless representative behavior proves otherwise.

Target shape:

```text
stable EntityId where narratively needed
+ ActorProfileDefinition
+ shallow current activity/target
+ bounded deterministic behavior rules
```

Do not create a second Wilson-level cognition architecture for Gerald or ordinary fauna.

Gerald's psychological significance belongs mainly in Wilson's beliefs, associations, habits and episodes about Gerald.

---

# 12. Director and player intervention

## Director

Director owns opportunity lifecycle, rarity/cooldown and bounded framing.

```text
DirectorContext
→ DirectedEvent eligibility
→ temporary opportunity / normal World manifestation / bounded bias
→ perception + ordinary candidate competition
```

Director never directly selects Wilson's final intention.

## Player physical intervention

```text
player request
→ player-side permission/cost validation
→ World command path
→ WorldEvent
→ perception
→ Wilson attribution/learning only if observable/inferable
```

## Player suggestion

```text
SuggestionSignal
→ bounded candidate/evaluation influence
→ normal competition
→ ordinary ActionAttemptability
```

Suggestion is not a command.

Private player intent never becomes Wilson evidence. A helpful intended intervention does not automatically increase Wilson trust unless Wilson's observed/inferred evidence supports that interpretation.

---

# 13. Run lifecycle / resurrection / Legacy

Implement explicit lifecycle orchestration rather than hidden cross-owner callbacks.

Product constraints include:

```text
resurrection is free and unlimited
no conscious memory of death itself
grounded danger/legacy learning may remain in admitted bounded form
End Run permanently closes that world
Legacy transfers selected operational knowledge, not autobiography
```

PlayerProfile remains outside active Run state.

Legacy seeds a new Wilson through explicit bootstrap logic; it is not a second writable copy of current-run cognition.

---

# 14. Fine spatial/navigation and presentation

The coarse semantic spatial boundary is already closed. Future spatial work should refine infrastructure behind it:

```text
metric distance
occlusion
route/path queries
navmesh integration
InteractionRegion anchors
body/assembly socket adapters
```

Domain/application layers should continue consuming narrow spatial/perception ports.

Godot presentation may realize:

```text
meshes
animation
VFX/audio
camera/UI
navigation geometry
semantic anchors/sockets
```

but none of these become domain identity or action-legality authority.

The cross-cutting content source is `docs/asset-catalog/`, not a second catalog under `docs/art/`.

---

# 15. Persistence rules for every new slice

Before persisting a field ask:

> Is this a durable cause required for continuity, or a reconstructible projection?

Persist when required:

```text
authoritative owner state
active physical/dynamic process continuation state
meaningful current/suspended intention
project/director/player lifecycle state
required deterministic RNG state
```

Normally rebuild:

```text
graph indexes
candidate lists
salience
expectations
routes
perception snapshots
EffectivePhysicalProfile
AssemblyValidity
CompositionDependencyProjection
EpistemicGraphProjection
HazardProjection
ProtectionProjection
most transient reactions
```

Save/load tests should verify semantic queries after reconstruction, not only raw JSON equality.

---

# 16. Testing workflow

Use the strict external runner:

```powershell
.\tests\run_headless_tests.ps1
```

It runs `tests/headless/*_test.gd` independently and rejects:

```text
nonzero process exit
SCRIPT ERROR
parse/compile errors
engine ERROR:
explicit FAIL
missing expected PASS
```

Do not accept Godot process exit `0` alone as success.

For each vertical:

```text
small pure/domain tests where useful
+ one focused end-to-end regression
+ persistence/reconstruction coverage if state is durable
+ full strict suite
```

A gate closes only after the behavior is proven by the strict suite.

---

# 17. Implementation discipline

Prefer:

```text
one semantic question per service where practical
narrow query ports
explicit results with diagnostics/provenance
owner-local mutation
seeded gameplay RNG
stable ordering before stochastic choice
bounded graph/world traversal
reusable property/capability/relation semantics
```

Before adding a primitive, try:

```text
existing property
existing capability
existing category
existing relation
RequirementPredicate
SemanticPattern
EpistemicClaim
ActionDefinition
Effect
existing owner state
existing derived projection
```

Add a new primitive only when a concrete invariant or representative behavior cannot be expressed cleanly with existing composition.

---

# 18. Explicit anti-decisions

Do not introduce by convenience:

```text
Giant WilsonBrain
EverythingGraph / universal triple store
AssemblyStore
CraftingSystem as a new physical authority
object-pair recipe tables
one mutable System per psychology noun
universal GOAP planner
one global utility god-function
huge/infinite emergency scores
raw WorldState access from cognition
belief truth imported from hidden World state
persistent derived caches as truth
broad event bus controlling mutation order
arbitrary authored callbacks
arbitrary relation qualifier dictionaries
generic persisted predicate + Variant[] epistemic schema
render FPS as simulation time
Godot node/socket/scene identity as domain identity
LLM-dependent core gameplay
scene-specific progression scripts for representative scenes
```

If implementation pressure appears to require one of these, first document the concrete invariant existing contracts cannot express and update the canonical owner deliberately.

---

# 19. Known open implementation questions

These are implementation decisions, not architecture blockers:

```text
body mutation proposer API
exact drive progression/calibration curves
project runtime metadata shape
habit/episode retention thresholds
dynamic-process persistence thresholds
shallow animal behavior details
protection coverage/gap representation
fine spatial/nav/occlusion implementation
presentation adapters for InteractionRegion / anchors / assembly sockets
larger-scale simultaneous-boundary tie-break policy
exact SemanticConceptId expansion boundaries
broader authored content-pack representation/migration strategy
```

Resolve them with focused vertical evidence and deterministic regressions rather than speculative frameworks.

---

# 20. Acceptance gates for this phase

A new system slice is acceptable when all applicable statements are true:

```text
existing 23-test foundation remains green
new behavior has deterministic regression coverage
one owner mutates each durable state family
world/observation/belief/player-intent separation remains intact
new projections are reconstructible
new randomness is seeded and traceable
candidate influences remain finite/bounded/explainable
no scene-specific bypass replaces reusable semantics
save/load preserves semantics when the new state is durable
Godot/presentation details remain outside domain authority
canonical docs change only when semantic contracts change
DISCOVERY_STATUS changes only when a meaningful gate actually closes
```

Do not mark scaffolding as a closed gate.

---

# 21. Suggested working pattern

For each block:

```text
1. identify one player-visible/systemic behavior
2. map it to existing canonical contracts
3. inspect existing runtime primitives/tests
4. add the smallest missing reusable owner/service
5. write focused deterministic regression
6. integrate through the existing causal chain
7. run the strict suite
8. update canonical docs only if semantics changed
9. update DISCOVERY_STATUS only when the gate is closed
```

Avoid large speculative subsystem scaffolds without executable behavioral proof.

---

# 22. Completion target for the next agent

The next agent does not need to implement every remaining gameplay family in one pass.

A strong next checkpoint is:

```text
body/drives owner
+ bounded progression
+ drive-derived candidate production
+ integration with reconsideration/decision/CurrentIntention
+ save/load continuity
+ deterministic headless regressions
```

After that, proceed vertically into Projects and cognition breadth before spreading into unrelated scaffolding.

---

# 23. Final instruction

Assume the structural foundation is intentional and tested.

The next phase should make the game **richer**, not make the foundation more abstract.

When choosing between:

```text
new framework
```

and

```text
one concrete reusable gameplay slice using existing contracts
```

prefer the concrete slice unless current evidence proves the existing contracts insufficient.
