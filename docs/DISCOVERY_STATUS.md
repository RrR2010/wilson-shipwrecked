# Discovery Status

## Current phase

Product/behavior discovery, architecture contracts, the language-neutral functional domain, and the normalized cross-cutting asset catalog are complete enough to support concrete implementation.

The first authoritative vertical implementation is now validated end-to-end under **Godot 4.7.1** with a strict external headless runner that rejects engine/script errors even when an individual test process exits `0`.

Current validated implementation chain:

```text
typed IDs / runtime refs
→ immutable content bootstrap
→ authoritative entities + relations
→ reconstructible relation indexes
→ property dependency DAG + EffectivePhysicalProfile
→ SemanticPattern + ActionAttemptability
→ ActionExecution + committed World mutation
→ WorldEvent → Perception → PerceptualEvidence
→ BeliefStore + EpistemicGraphProjection
→ candidate generation + decision routing
→ durable CurrentIntention
→ application micro-loop orchestration + semantic trace
→ JSON snapshot / restore / rebuild of authoritative runtime causes
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

World relation runtime slice               PASS — Godot 4.7.1 headless
Effective physical profile slice           PASS — Godot 4.7.1 headless
Semantic pattern / attemptability slice     PASS — Godot 4.7.1 headless
Committed action execution slice            PASS — Godot 4.7.1 headless
Perception projection slice                 PASS — Godot 4.7.1 headless
Belief learning / epistemic slice           PASS — Godot 4.7.1 headless
Decision routing slice                      PASS — Godot 4.7.1 headless
End-to-end simulation micro-loop            PASS — Godot 4.7.1 headless
Save/load/rebuild reconstruction slice      PASS — Godot 4.7.1 headless
Strict headless suite                       PASS — 9 tests
```

**Functional-domain stabilization gate: PASS.**

**Asset-catalog functional normalization gate: PASS for current P0/P1 breadth.**

**Module/dependency-layout gate: PASS.**

**First authoritative runtime vertical gate: PASS.**

---

# Validated runtime invariants

The current implementation has explicit regression coverage for these boundaries:

```text
World truth != Wilson observation != Wilson belief

ActionAttemptability is pure
ActionExecution does not mutate World directly
committed action checkpoints emit one ActionOutcome
WorldEvent appears only after successful owner commit
Perception projects only accessible event roles
PerceptualEvidence does not mutate cognition directly
Belief learning is bounded and revisable
EpistemicGraphProjection is reconstructible, never authority
Decision routing separates immediate-threat / tactical / intentional regimes
external bias is bounded and cannot become a command
selected intention is owner-local durable cognition state
simulation trace is diagnostic-only
save stores authoritative runtime causes, not reconstructible indexes/caches
save → JSON → load → rebuild preserves tested semantic queries
```

Property derivation policies are now validated during dependency-graph compilation; unknown authored policies fail bootstrap instead of asserting only during runtime resolution.

The strict PowerShell runner additionally rejects `SCRIPT ERROR`, parse/compile failures, generic engine `ERROR:` output, explicit `FAIL`, missing expected `PASS`, or nonzero process exit status. This prevents the previously observed Godot false-green class where a script error could be printed before `PASS`.

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

`ARCHITECTURE.md` defines the language-neutral module families:

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

`DOMAIN_OPERATIONS.md` is the **single** canonical operation surface and includes:

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

Ownership remains:

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

`docs/README.md` explicitly prefers updating canonical owners over creating `*_REFINEMENTS`, `*_V2` or permanent override chains.

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

# Remaining implementation questions

These are now predominantly concrete runtime/content concerns rather than discovery blockers:

1. exact spatial topology/navigation representation;
2. body mutation proposer API beneath World authority;
3. concrete shallow animal behavior representation;
4. environmental/dynamic-process persistence thresholds;
5. final bounded `PropertyValue` catalogue/schema beyond the current numeric derivation fixture;
6. exact `SemanticConceptId` boundaries;
7. concrete authored-content serialization/loading format;
8. presentation adapters for InteractionRegion, anchors, body-slot qualifiers and assembly sockets;
9. exact deterministic tie-break encoding for simultaneous semantic boundaries beyond current stable-key routing;
10. reconstruction policy for an **action execution in progress**, especially across committed checkpoints;
11. coarse representation for protection coverage/gaps;
12. composition dependency projection / AssemblyValidity implementation;
13. exact derived-cache invalidation optimization beyond conservative subject invalidation;
14. candidate source services for drives, projects, habits, Presence and Director;
15. action interruption classes and broader runtime action lifecycle;
16. richer physical provenance distinguishing authored base value from runtime override;
17. bounded type-safe property comparisons instead of unrestricted `Variant` comparison;
18. spatial/perception access implementation replacing the current explicit access-policy fixture.

These are implementation choices, not evidence for new state owners.

---

# Recommended next work

Continue from the validated vertical rather than adding parallel scaffolds.

Recommended sequence:

```text
1. authored ActionDefinition / ActionResolutionDefinition registry
2. mid-action save/load reconstruction with committed-checkpoint invariants
3. composition dependency projection + AssemblyValidity
4. bounded PropertyValue schema / comparison policies
5. concrete spatial query + perception-access adapter
6. project / drive / habit candidate producers
7. presentation adapters + representative scene rendering fixtures
8. deterministic larger regression scenarios
```

The implementation may favor direct GDScript, but it should preserve the language-neutral ownership and dependency boundaries rather than mirror Godot scene structure.