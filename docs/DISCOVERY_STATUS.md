# Discovery Status

## Current phase

The product/behavior discovery, architecture contracts, language-neutral functional domain, normalized cross-cutting asset catalog, and **structural runtime foundation** are complete enough to hand off into system implementation.

The authoritative runtime foundation is validated end-to-end under **Godot 4.7.1** with a strict external headless runner that rejects engine/script errors even when an individual Godot process exits `0`.

Current validated implementation chain:

```text
typed DomainId / RuntimeWorldRef
→ immutable authored content registry
→ versioned bounded JSON ContentPack loading
→ bounded PropertyDefinition schemas
→ authoritative EntityStore / WorldRelationStore / WilsonWorldState
→ exact qualified relation identity + reconstructible indexes
→ coarse PlaceId spatial query boundary
→ property dependency DAG + EffectivePhysicalProfile
→ AssemblyBindingProjection + AssemblyValidity
→ CompositionDependencyProjection + transitive derived invalidation
→ SemanticPattern / RequirementPredicate + ActionAttemptability
→ ActionExecution lifecycle + explicit commit checkpoint
→ exact World owner commit + transactional prevalidation for supported effect batches
→ SemanticChangeSet + derived-state invalidation
→ typed EventDefinitionId / WorldEvent / ObservedEvent
→ spatially-derived PerceptionAccess
→ typed EpistemicClaim(PROPERTY | RELATION | EVENT)
→ PerceptualEvidence → BeliefStore → EpistemicGraphProjection
→ candidate generation + decision routing
→ durable CurrentIntention
→ application micro-loop orchestration + semantic trace
→ JSON snapshot / restore / rebuild of authoritative runtime causes
→ mid-action reconstruction across pre/post-commit checkpoints
→ heavier causal reconstruction and structural-scale regression scenarios
```

Model/content production may proceed independently from the normalized [`asset-catalog/`](asset-catalog/).

For documentation navigation and authority use [`README.md`](README.md).

---

# Closed gates

## Discovery / design gates

```text
Product / behavioral discovery             PASS
Architecture responsibility boundaries     PASS
Simulation contracts / orchestration       PASS
Mutation authority                         PASS
Guards / bounded calibration               PASS
Structural functional domain               PASS
Vocabulary normalization                   PASS
Representative-scene regression            PASS
Canonical operation surface                PASS
Functional asset breadth                   PASS
Asset catalog functional normalization     PASS
Asset catalog scene-coverage regression    PASS
Gradual exploration / evidence             PASS
Composite-object semantics                 PASS
Environmental protection / exposure        PASS
Scientific Method micro-loop               PASS
Falling Palm hazard micro-loop              PASS
Sabotaged Storage epistemic micro-loop     PASS
Improvised hammer fixture                  PASS
Cloth/shelter/weather fixture              PASS
Typed semantic graph/index contracts       PASS
Language-neutral module dependency layout  PASS
Documentation consolidation                PASS
```

## Structural runtime foundation gates

```text
World relation runtime                     PASS — Godot 4.7.1 headless
Effective physical profile                 PASS — Godot 4.7.1 headless
Semantic pattern / attemptability           PASS — Godot 4.7.1 headless
Committed action execution                  PASS — Godot 4.7.1 headless
Action lifecycle / interruption             PASS — Godot 4.7.1 headless
Perception projection                       PASS — Godot 4.7.1 headless
Spatial perception access                   PASS — Godot 4.7.1 headless
Belief learning / epistemic                 PASS — Godot 4.7.1 headless
Typed epistemic claim persistence           PASS — Godot 4.7.1 headless
Decision routing                            PASS — Godot 4.7.1 headless
End-to-end simulation micro-loop            PASS — Godot 4.7.1 headless
Save/load/rebuild reconstruction            PASS — Godot 4.7.1 headless
Mid-action reconstruction                   PASS — Godot 4.7.1 headless
Causal reconstruction scenario              PASS — Godot 4.7.1 headless
Structural-scale reconstruction             PASS — Godot 4.7.1 headless
Derived invalidation                        PASS — Godot 4.7.1 headless
Composition-dependent invalidation          PASS — Godot 4.7.1 headless
Semantic snapshot immutability              PASS — Godot 4.7.1 headless
Assembly validity                           PASS — Godot 4.7.1 headless
Improvised hammer composition               PASS — Godot 4.7.1 headless
Property schema/bootstrap                   PASS — Godot 4.7.1 headless
Property runtime schema/comparison          PASS — Godot 4.7.1 headless
Authored content-pack loading               PASS — Godot 4.7.1 headless
Qualified relation identity / exact command PASS — Godot 4.7.1 headless
Strict headless suite                       PASS — 23 tests
```

**Functional-domain stabilization gate: PASS.**

**Asset-catalog functional normalization gate: PASS for current P0/P1 breadth.**

**Module/dependency-layout gate: PASS.**

**Structural runtime foundation gate: PASS.**

---

# Validated runtime invariants

The implementation has explicit regression coverage for these boundaries:

```text
World truth != Wilson observation != Wilson belief != player-private intent

ActionAttemptability is pure
ActionExecution does not mutate World directly
commit checkpoint emits one ActionOutcome
pre/post-commit save/load does not rewind or duplicate committed outcomes
interruption is explicit terminal execution state and never rewinds committed truth
terminal execution cleanup is explicit

WorldEvent appears only after successful owner commit
ActionOutcome / WorldEvent snapshot transient RoleBinding defensively
supported World effect batches are prevalidated as a sequence before mutation
invalid batches do not leave intentional partial relation/property mutation

World mutations emit SemanticChangeSet for reconstructible derived-state maintenance
component property changes invalidate dependent composite hosts transitively
relation changes invalidate direct/dependent physical profiles
SemanticChangeSet is an invalidation contract, not a gameplay event bus

WorldRelation qualifier is a bounded semantic value and participates in exact identity
same relation endpoints may coexist with distinct admitted qualifiers
exact CREATE_RELATION / REMOVE_RELATION includes qualifier identity
numeric qualifier identity canonicalizes int/float representation

Assembly bindings are projected from authoritative World relations
AssemblyValidity is derived and separate from effective performance
component condition may degrade performance while assembly remains VALID
component-aware property derivation does not require recipe-specific runtime types

PropertyDefinition validates authored values during sealed content bootstrap
SET_PROPERTY validates typed values/bounds before authoritative mutation
numeric PropertyValue rejects NaN/infinity
ordered comparisons are limited to compatible ordered families
invalid property mutations emit no WorldEvent or SemanticChange

EventDefinitionId remains typed through World → observation → evidence
Perception projects only spatially accessible/perceptible roles
PerceptualEvidence carries a typed EpistemicClaim
EpistemicClaim has closed current kinds: PROPERTY, RELATION, EVENT
numeric epistemic identity is stable across JSON int/float round-trips
Belief learning is bounded and revisable
EpistemicGraphProjection is reconstructible from BeliefStore and never imports hidden World truth

Decision routing separates immediate-threat / tactical / intentional regimes
external bias is bounded and cannot become a command
selected intention is owner-local durable cognition state
simulation trace is diagnostic-only

save stores authoritative/runtime causes, not reconstructible indexes/caches
save → JSON → load → rebuild preserves tested semantic queries
Wilson coarse PlaceId truth survives reconstruction
active/completed action execution reconstructs without re-running past attemptability
```

The strict PowerShell runner rejects `SCRIPT ERROR`, parse/compile failures, generic engine `ERROR:` output, explicit `FAIL`, missing expected `PASS`, or nonzero process exit status. This prevents Godot false-green results.

---

# Concrete foundation baseline

## Spatial boundary

The current foundation deliberately uses coarse semantic placement:

```text
EntityInstance.place_id
WilsonWorldState.place_id
→ DefaultWorldQuery co-location / bounded nearby queries
→ CoarsePerceptionAccessResolver
```

Fine metric distance, occlusion, navmesh/pathfinding and Godot transforms remain infrastructure/presentation concerns behind the same semantic boundary.

## Action lifecycle

Current authored interruption classes are:

```text
PRE_COMMIT_ONLY
NEVER
ANYTIME
```

Execution state explicitly tracks running/committed/completed/interrupted causality. `ANYTIME` may terminate a post-commit tail but cannot undo the already-emitted committed outcome.

## Epistemic identity

Durable belief identity no longer uses generic `predicate + Variant arguments` serialization.

Current closed algebra:

```text
EpistemicClaim.PROPERTY(subject, PropertyId, PropertyValue)
EpistemicClaim.RELATION(subject, RelationTypeId, object)
EpistemicClaim.EVENT(subject, EventDefinitionId, perceived_role)
```

Future epistemic families must be added as explicit typed claim kinds/contracts rather than restoring a generic arbitrary-argument identity scheme.

## Authored content

`ContentPackLoader` currently accepts a versioned bounded JSON pack for the implemented foundation families:

```text
properties
entities
events
actions
action resolutions
assemblies
property derivations
bounded predicates/effects/selectors
```

Loading produces typed definitions and ends in `ContentRegistry.seal()` validation. Arbitrary authored callbacks and arbitrary relation-qualifier dictionaries are rejected.

## Persistence versions

Current implementation baseline:

```text
SimulationSnapshotService schema: v4
ActionExecutionSnapshotService schema: v2
ContentPackLoader schema: v1
```

These are development schemas. Unsupported versions fail fast; there is no requirement to migrate pre-foundation development snapshots.

---

# Stabilized architectural shape

State-owning families remain:

```text
World
Wilson Cognition
Projects
Player Run State / Intervention
Director
Action Execution / Resolution
Player Profile across runs
```

Important derived/non-owning concerns include:

```text
Perception / PerceptualEvidence
Expectation / salience
EffectivePhysicalProfile / AssemblyValidity
Protection / exposure
Affordance / ActionAttemptability
HazardProjection / PerceivedThreat
bounded investigation / causal attribution
tactical / intentional decision projections
learning proposals / reaction
Luck

World relation indexes
PropertyDependencyGraph
AssemblyBindingProjection
CompositionDependencyProjection
EpistemicGraphProjection
bounded SemanticPattern matcher
```

Core invariant:

```text
graph representation / index / projection
!= authority owner
```

There is intentionally no generic `GraphSystem`, `EverythingGraph`, `AssemblyStore`, global crafting owner or omniscient Wilson cognition shortcut.

---

# What is intentionally not implemented yet

The remaining work is predominantly **system breadth and presentation**, not unresolved structural ownership.

Major families still to implement include:

1. drive/body progression and concrete candidate producers;
2. project runtime/lifecycle and project candidate sources;
3. habits, associations, episodes and Presence update flows beyond the minimal belief vertical;
4. Director opportunity lifecycle and bounded candidate influence;
5. environment/weather and persisted dynamic processes;
6. protection/exposure runtime;
7. hazards and immediate-threat production from real dynamic processes;
8. shallow non-Wilson actor/animal behavior;
9. food/fire/cooking/freshness processes;
10. player intervention / God Power / suggestions;
11. run death/resurrection/Legacy/Profile lifecycle;
12. fine spatial/nav/occlusion infrastructure;
13. Godot presentation adapters, anchors, InteractionRegions and assembly sockets;
14. broader authored content packs covering the normalized asset catalog;
15. larger multi-system deterministic scenario/population tests.

These systems must preserve the established owners and contact contracts. A new state owner or generic framework requires new evidence, not convenience.

---

# Next phase

The recommended next phase is **system implementation on the completed structural foundation**.

Recommended order:

```text
1. body/drives + their bounded candidate producers
2. Project runtime + project candidate producer
3. habits/associations/episodes/Presence learning producers
4. environment + dynamic-process owner/rules
5. hazards/protection + immediate-threat production
6. shallow animal actors
7. Director + player intervention/suggestions
8. run lifecycle / resurrection / Legacy/Profile
9. Godot presentation/spatial adapters
10. representative multi-system scenario suites and seed-population tests
```

The implementation should expand breadth through existing contracts before adding new primitives.
