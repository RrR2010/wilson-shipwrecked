# Discovery Status

## Current phase

Product/behavior discovery, architecture contracts, the language-neutral functional domain, and the normalized cross-cutting asset catalog are complete enough to proceed to concrete domain types and implementation scaffolding.

The typed semantic graph/index refactor and language-neutral module-layout pass are now **consolidated into existing canonical owners** rather than maintained as additional override/specification files.

Current implementation sequence:

```text
concrete core/domain types
→ immutable content registries + validation/index compilation
→ World + typed relation indexes
→ physical/assembly/attemptability services
→ action execution / ActionOutcome
→ perception/evidence + minimal cognition
→ decision loop
→ persistence/reconstruction
→ Godot presentation adapters
→ deterministic fixture/headless regressions
```

Model/content production may proceed independently from the normalized [`asset-catalog/`](asset-catalog/).

For documentation navigation and authority use [`README.md`](README.md).

---

# Closed gates

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
Gradual exploration / evidence              PASS
Composite-object semantics                 PASS
Environmental protection / exposure        PASS
Scientific Method micro-loop               PASS
Falling Palm hazard micro-loop              PASS
Sabotaged Storage epistemic micro-loop     PASS
Improvised hammer fixture                  PASS
Cloth/shelter/weather fixture              PASS

Typed semantic graph/index contracts       PASS
Language-neutral module dependency layout  PASS
Documentation consolidation for this pass  PASS
```

**Functional-domain stabilization gate: PASS.**

**Asset-catalog functional normalization gate: PASS for current P0/P1 breadth.**

**Module/dependency-layout gate: PASS.**

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
CompositionDependencyProjection
EpistemicGraphProjection
bounded SemanticPattern matcher
```

Core graph invariant:

```text
graph representation / index / projection
!= authority owner
```

`ARCHITECTURE.md` owns graph placement/dependency boundaries. `DOMAIN_OPERATIONS.md` owns public graph-aware traversal/matching/query operations.

There is intentionally no separate generic GraphSystem/EverythingGraph.

---

# Module-layout result

`ARCHITECTURE.md` now defines the language-neutral module families:

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

These names are conceptual responsibilities, not a mandated one-directory/one-class implementation.

Key dependency rules:

```text
World never depends on Cognition
physical truth never reads Wilson belief
Cognition consumes perceived contracts, not hidden World truth
Projects query physical World truth instead of duplicating it
Graph indexes never own mutation
Presentation depends inward; domain never depends on Godot
Persistence format does not define domain semantics
```

Canonical fixture dependency review remains PASS for Scientific Method, Falling Palm, Sabotaged Storage, Improvised Hammer and Cloth Shelter Weather.

---

# Canonical operation surface

`DOMAIN_OPERATIONS.md` is now the **single** canonical operation surface and includes the formerly separate refinement semantics:

```text
ResolveEffectivePhysicalProfile
PropertyDependencyGraph compilation/invalidation
WorldRelationGraph traversal queries
SemanticPattern matching
QueryAttemptableActions / QueryActionAttemptability
DerivePerceivedTacticalOpportunities
tactical vs intentional candidate operations
InteractionRegion queries
AssemblyValidity / compatible-component operations
Protection / exposure operations
Environmental response operations
Hazard / PerceivedThreat operations
Perception / PerceptualEvidence
immediate same-chain learning
epistemic graph/belief queries
project/director/player lifecycle operations
explainability diagnostics
```

`DOMAIN_OPERATION_REFINEMENTS.md` has been retired after consolidation.

---

# Documentation consolidation result

This pass deliberately avoided adding permanent canonical files when existing owners could absorb the semantics.

Result:

```text
DOMAIN_MODULE_LAYOUT.md          not created
DOMAIN_OPERATION_REFINEMENTS.md retired / absorbed
DOMAIN_SEMANTIC_GRAPHS.md       retired / absorbed
```

Ownership now is:

```text
ARCHITECTURE.md
  architecture + module/package layout + dependency direction
  + graph/index placement

DOMAIN_OPERATIONS.md
  single public domain operation/query surface
  + graph-aware traversal/matching semantics

existing domain documents
  own relation/property/composition/epistemic meanings
```

`docs/README.md` now explicitly prefers updating canonical owners over creating `*_REFINEMENTS`, `*_V2` or permanent override chains.

---

# Current content/catalog state

The normalized `docs/asset-catalog/` provides:

- independent functional `Spec` and production `Status` lifecycles;
- normalized material/property/capability/affordance/relation/assembly/action/evidence semantics;
- P0/P1 entity/project/living-world coverage;
- semantic project/component roles rather than recipes;
- scene-regression ownership for all accepted representative phenomena;
- art/production information as a parallel concern.

The catalog's semantic density is a primary practical consumer of local typed indexes/pattern matching; it should not cause global Cartesian affordance scans or combinatorial entity subclasses.

---

# Remaining non-blocking implementation questions

These may be resolved while defining concrete types/fixtures:

1. exact spatial topology/navigation representation;
2. body mutation proposer API beneath World authority;
3. concrete shallow animal behavior representation;
4. environmental/dynamic-process persistence thresholds;
5. final bounded property catalogue/registered derivation policies;
6. exact `SemanticConceptId` boundaries;
7. concrete content serialization format;
8. presentation adapters for InteractionRegion, anchors, body-slot qualifiers and assembly sockets;
9. exact deterministic tie-break encoding for simultaneous semantic boundaries;
10. minimal reconstruction policy for saves mid-investigation;
11. coarse representation for protection coverage/gaps;
12. internal relation/property/capability index structures;
13. exact derived-cache invalidation implementation;
14. concrete GDScript mapping of typed IDs/unions/value objects without weakening semantic validation.

These are implementation choices, not evidence for new state owners.

---

# Recommended next work

Proceed to **concrete domain types and implementation scaffolding**.

Recommended first vertical slice of types/infrastructure:

```text
1. typed IDs / refs / bounded values
2. Definition registries + bootstrap validation
3. EntityInstance / WorldRelation / WorldState
4. typed World relation indexes and bounded traversal
5. material/property derivation + PropertyDependencyGraph
6. assembly bindings + AssemblyValidity / EffectivePhysicalProfile
7. ActionDefinition / InteractionRule / SemanticPattern candidate matching
8. QueryActionAttemptability + ActionExecution / ActionOutcome
9. minimal BeliefStore + EpistemicGraphProjection
10. deterministic fixture harness
```

The implementation may favor direct GDScript, but it should preserve these language-neutral boundaries rather than mirror Godot scene structure.