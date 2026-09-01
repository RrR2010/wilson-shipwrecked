# AGENTS.md

## Mission

Build Wilson Shipwrecked as a coherent systemic simulation and living 3D diorama. Optimize for reusable rules, explicit authority and modular content rather than maximum feature count.

## Current project phase

The **structural runtime foundation and planned system-breadth owners through run lifecycle / PlayerProfile are implemented and locally validated**.

Current strict baseline is recorded in `docs/DISCOVERY_STATUS.md`. Do not copy test counts/schema versions into this file.

The remaining major implementation sequence is:

```text
1. fine spatial/nav/occlusion + Godot presentation adapters
2. deterministic playable scenario/bootstrap tooling
3. representative multi-system scenarios + seed-population tests
```

Cross-cutting correctness items listed in `DISCOVERY_STATUS.md` should be pulled forward when a representative scenario requires them. Do not hide a real domain gap behind scenario-specific code.

Before substantial work, read:

1. [`docs/README.md`](docs/README.md) — documentation map/authority hierarchy;
2. [`docs/DISCOVERY_STATUS.md`](docs/DISCOVERY_STATUS.md) — concrete validated baseline and remaining work;
3. only the canonical bundle relevant to the task.

Do not reopen foundation ownership, replace established typed contracts with generic containers, or introduce a new universal framework merely because one new adapter/scenario needs implementation.

---

# Documentation workflow

Read the smallest canonical bundle sufficient for the task. Fixtures/regressions are evidence, not competing specifications.

## Simulation/domain/architecture

Core canonical bundle:

```text
ARCHITECTURE.md
SIMULATION_CONTRACTS.md
SIMULATION_ORCHESTRATION.md
MUTATION_AUTHORITY.md
DOMAIN_MODEL.md
DOMAIN_VOCABULARY.md
DOMAIN_CATALOGS.md
DOMAIN_OPERATIONS.md
DOMAIN_PROCEDURAL_COMPOSITION.md
```

Specialized appendices only when affected:

```text
DOMAIN_ENVIRONMENTAL_PROTECTION.md
DOMAIN_HAZARD_DYNAMICS.md
DOMAIN_EPISTEMIC_INVESTIGATION.md
DOMAIN_MICRO_LOOP.md
```

## Spatial / Godot presentation work

Read at minimum:

```text
docs/ARCHITECTURE.md
docs/SIMULATION_ORCHESTRATION.md
docs/SIMULATION_CONTRACTS.md
docs/MUTATION_AUTHORITY.md
docs/ASSET_SPEC.md
docs/ASSET_PIPELINE.md
```

Then inspect the relevant domain ports/tests before adding infrastructure adapters.

## Asset/content catalog

```text
docs/asset-catalog/README.md
→ relevant catalog tables
→ PRODUCT.md / domain core as needed
→ art contracts when visual requirements are affected
```

`docs/asset-catalog/` is the cross-cutting source of truth for modeled-content requirements/backlog. `docs/art/` must not maintain a second object catalog.

## Visual / 3D production

```text
docs/asset-catalog/<relevant row>
→ docs/VISUAL_GUIDE.md
→ docs/art/README.md + relevant references
→ docs/ASSET_SPEC.md
→ docs/ASSET_PIPELINE.md
→ docs/art/AGENT_ART_PRODUCTION.md
```

Brainstorming asset rounds are historical breadth evidence, not normal production authority.

---

# Documentation rules

- Prefer one canonical owner per concern; `docs/README.md` defines the map.
- Update an existing canonical owner rather than creating a new top-level document for every fixture/edge case/system.
- Validation traces/fixtures prove sufficiency; they do not create scene-specific APIs.
- `docs/brainstorming/` is exploratory/historical evidence.
- `docs/handoffs/` is stage-transition context, not durable design authority.
- `docs/design-reviews/` contains temporary calibration/review evidence intended to be consumed by implementation work; it is not canonical authority.
- Do not recreate permanent `*_REFINEMENTS`, `*_NOTES`, `*_V2` override chains.
- Concrete schema versions/test counts belong in `DISCOVERY_STATUS.md`.

## Design reviews

Design/calibration reviews live under `docs/design-reviews/` and should begin with an explicit `Status: OPEN` or `Status: COMPLETED` marker.

When an implementation task or PR consumes a design review:

1. read the review as advisory evidence against the current canonical contracts and representative behavior;
2. resolve every applicable checklist/recommendation through implementation, tests, canonical-document updates, or an explicit justified rejection/deferment;
3. do not silently work around a review finding or leave consumed guidance looking open;
4. before considering the consuming work complete, change the review to `Status: COMPLETED` and record the consuming PR/commit plus any rejected/deferred recommendation and rationale;
5. if only part of a review is in scope, leave it `OPEN` and check/annotate only the items actually resolved rather than falsely closing the whole review.

A completed review remains historical calibration evidence. It must not become a second canonical specification; durable decisions discovered while consuming it belong in the appropriate canonical owner document.

## Handoffs

Stage-transition handoffs live under `docs/handoffs/` and should be named for the transition/problem transferred.

A handoff should:

1. identify the exact phase/objective;
2. give a minimal required-reading path;
3. list closed decisions/invariants and explicit anti-decisions;
4. identify deliverables/acceptance gates;
5. point to canonical sources instead of duplicating them extensively;
6. record open questions separately from accepted contracts;
7. record the exact validated strict-test checkpoint.

---

# Global authority invariants

These contracts are already regression-backed. Preserve them unless representative evidence proves a canonical change is required.

## Owners

```text
World
Wilson Cognition
Projects
Director
PlayerRunState / Intervention
RunLifecycleState
ActionExecution / Resolution
PlayerProfile across runs
```

A projection/service/index/adapter does not become an owner because it is convenient to mutate it.

Keep separate:

```text
World truth
!= Wilson observation
!= Wilson belief
!= Wilson desirability
!= player-private intent
!= Director intent
!= cross-run profile state
!= presentation
```

## Owner/query/service/command split

```text
owner stores     = authoritative state
query ports      = narrow semantic reads
derived services = deterministic proposals/projections
commands         = validated owner-local mutation
```

No presentation, debug, fixture or scenario path may bypass this split.

## Typed semantic identity

- Use `DomainId`/typed semantic IDs rather than display strings/scene paths as identity.
- Durable belief identity uses typed `EpistemicClaim`, currently `PROPERTY | RELATION | EVENT`.
- Do not restore generic `predicate + arbitrary Variant arguments` as durable epistemic identity.
- Numeric semantic identity must survive JSON representation changes such as `3` ↔ `3.0`.
- Property/qualifier semantic values are bounded; NaN/infinity are invalid.

## Event naming

- `EventDefinition` = semantic/perceptual definition of an ordinary `WorldEvent` kind.
- `WorldEvent` = authoritative occurrence fact.
- `ObservedEvent` = Wilson-accessible projection.
- Director-owned lifecycle uses directed-opportunity definitions/state.

Do not overload ordinary event semantics for Director state.

## World relations / composition

`WorldRelation` exact identity includes:

```text
RelationTypeId + subject + object + optional qualifier
```

Qualifier is a bounded semantic scalar/symbol/typed ID, never an arbitrary Dictionary/Array.

Assembly bindings use ordinary World relations. There is no `AssemblyStore`.

`EffectivePhysicalProfile`, `AssemblyValidity`, `CompositionDependencyProjection`, protection/exposure and hazard projections are reconstructible derived semantics, not authority.

## Action causality

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

- `ActionAttemptability` is a pure authoritative read; it does not guarantee goal success.
- ActionExecution owns progress/commit/terminal lifecycle but does not mutate World.
- crossing commit emits one `ActionOutcome` exactly once.
- committed physical truth cannot be rewound by reconsideration, suggestion, Luck, load or debug tools.
- `SemanticChangeSet` is an invalidation contract, not a generic event bus.

## Perception / learning

- Event perceptibility + runtime spatial access determine accessible roles/modalities.
- cognition receives only accessible observation/evidence semantics.
- `EpistemicGraphProjection` indexes only cognition-owned beliefs; never import hidden World truth.
- same-chain learning happens before the next tactical choice when it can affect that choice.
- Presence/association/habit/episode updates remain Wilson-relative; player-private intent is never evidence by itself.

## Immediate threat

Immediate threat wins through a separate routing regime, never giant/infinite utility scores. Wilson consumes `PerceivedThreat`, not hidden `HazardProjection` directly.

## Run/Profile

`RunLifecycleState` does not replace WilsonBody truth. Resurrection first passes the physical World/body boundary.

`PlayerProfile` is outside active Run state. Legacy/profile admission is explicit and must not copy Wilson autobiography wholesale.

---

# Common restore/bootstrap invariant

Every meaningful gameplay subsystem must be testable from an artificial but valid authoritative state without replaying all prior gameplay.

Canonical architecture:

```text
normal authoritative owner state
            ↑
common restore/bootstrap boundary
            ↑
real save | deterministic test fixture | debug scenario
```

This is a global project invariant.

A fixture/debug scenario may declare durable owner causes and deterministic seed state, but must pass the same validation/construction/reconstruction semantics as normal restore/bootstrap.

Do not:

```text
mutate private stores after bootstrap to manufacture a scenario
persist derived projections/caches as fixture truth
skip action/process causal validation because the fixture is test-only
use Godot transforms as authoritative scenario state
build a debug console with arbitrary direct-store mutation
create a second debug-only simulation architecture
```

A development scenario launcher and future debug console are adapters over the common bootstrap boundary and normal commands.

Prefer declarative named scenarios such as:

```text
hungry_wilson_near_food
wilson_mid_shelter_project
storm_with_bad_roof
```

Scenario names are development identifiers, not domain identity.

---

# General engineering invariants

1. Keep authoritative simulation independent from rendering.
2. Prefer composition/data-driven semantics over concrete-type branching.
3. Route authoritative mutation through validated owner operations/effects.
4. Keep gameplay randomness seeded/reproducible; presentation randomness separate.
5. Do not couple game correctness to LLM availability.
6. Prefer the smallest reusable primitive proven by current cases; avoid premature universal frameworks.
7. Add deterministic/headless regressions for domain/system changes.
8. Preserve explainability: decisions/derivations expose useful provenance/diagnostics.
9. Keep code/comments/docs in English.
10. Persist only durable causes; rebuild reconstructible projections/indexes/caches.
11. Keep critical mutation order explicit; no broad event-bus authority.
12. Keep evaluator contributions finite/bounded; no infinity/huge-score priority hacks.
13. Keep physical truth, Wilson knowledge/belief and desirability distinct.
14. Keep player-private intent distinct from Wilson observation/attribution.
15. Prefer effective properties/capabilities from material + condition + composition + contents over combinatorial entity variants.
16. Do not model exploration as a universal percentage.
17. Keep committed dynamic-process evolution distinct from unresolved future collision/consequence.
18. Stable semantic ordering precedes deterministic tie-break/seeded random selection.
19. Reconstruct indexes/caches from authority after load/bootstrap; never let a cache become truth.
20. Fine spatial/nav/occlusion adapters refine semantic queries; they do not replace `PlaceId`/relations or become action-legality authority.

---

# Standard test gate

For runtime/domain changes:

```powershell
.\tests\run_headless_tests.ps1
```

The runner rejects:

```text
nonzero exit
SCRIPT ERROR
parse/compile errors
generic engine ERROR:
explicit FAIL
missing expected PASS marker
```

Do not claim a runtime slice green until the strict suite passes locally. `DISCOVERY_STATUS.md` records the latest validated count.

## Required robustness beyond happy paths

New scenario/scale work must deliberately exercise **variability, extremes and data volume**, not only one handcrafted success case.

Use relevant combinations of:

```text
minimum/empty state
boundary numeric values
near-threshold hysteresis/bands
maximum admitted values
many entities / relations / beliefs / processes / projects / actors
dense and sparse spatial layouts
conflicting simultaneous candidates/stimuli/events
multiple threats/opportunities at once
long-running bounded accumulation/decay
reconstruction before/at/after commit or lifecycle boundaries
invalid/adversarial fixture input
multiple deterministic seeds / fixed seed populations
stable ordering under insertion-order variation
```

Assertions should prove semantic correctness, finite bounds, deterministic replay, stable ordering and bounded traversal/query behavior. Do not use wall-clock timing as a gameplay-semantic assertion; performance/load profiling is separate.

When adding tests:

- include pure/domain tests where useful;
- include at least one focused integrated scenario for cross-system work;
- include persistence/bootstrap reconstruction when durable state/causality is affected;
- test failure/rejection branches, not only success;
- never print PASS after an incomplete/erroring test body.

---

# Current implementation focus

## 1. Fine spatial/nav/occlusion + Godot presentation adapters

The coarse semantic spatial foundation is already closed:

```text
Entity/ Wilson PlaceId
→ bounded nearby/co-location semantics
→ perception access boundary
```

The next spatial work refines infrastructure behind the ports:

```text
metric distance
route/path queries
navmesh integration
occlusion / visibility / hearing geometry
semantic InteractionRegion anchors
body/assembly/perch sockets
entity ↔ scene-instance mapping
```

Rules:

- Godot nodes/scene paths/navmesh IDs/colliders/meshes are adapters, not domain identity.
- domain/application code consumes narrow spatial/perception ports.
- UI/presentation queries simulation affordances/attemptability rather than duplicating legality.
- render FPS/animation completion are not authoritative time/outcome.
- a visual transform update does not itself commit World placement semantics.

## 2. Deterministic playable scenario/bootstrap tooling

Build the common bootstrap/restore mechanism before a proliferation of bespoke smoke scenes.

Target:

```text
scenario definition
→ common restore/bootstrap
→ authoritative owners + rebuilt projections
→ optional headless run
→ optional Godot presentation scene
```

The same scenario should be usable by headless regression, development launcher and presentation smoke test where practical.

## 3. Representative multi-system scenarios + seed-population tests

Use `docs/SCENE_VALIDATION.md`, `docs/brainstorming/representative-scene-catalog.md` and `docs/asset-catalog/SCENE_COVERAGE.md` as evidence sources, not as new authority.

Prefer representative scenes that force several already-implemented systems to interact and expose missing primitives honestly.

Do not add scene-specific APIs just to make one scripted outcome pass.

---

# Known cross-cutting work

`docs/DISCOVERY_STATUS.md` owns the current list. Pull items forward when required by representative behavior, including areas such as:

```text
grounded collision/body consequences
generic reconsideration gating
drive hysteresis-memory persistence
Wilson-relative route/escape evaluation
intervention causal windows
automatic habit-disuse/context production
Presence attribution production
full run-save composition
new-run bootstrap / Legacy seeding
```

Do not silently mark these solved because an adapter/scenario can work around them.

---

# Guards and calibration

Follow `docs/GUARDS_AND_CALIBRATION.md`.

- hard finite bounds are invariants;
- prefer saturating/diminishing updates before clamp;
- use semantic counter-pressure before hidden normalization;
- strong contradiction must remain able to revise beliefs;
- do not normalize psychology/history toward target averages invisibly;
- evaluate health across deterministic run populations instead of forcing each run to one distribution;
- adaptive control is bounded/whitelisted;
- immediate threat uses a separate regime.

---

# Runtime AI

- LLM output is bounded proposal/interpretation/expression, never authoritative mutation.
- Core simulation remains behaviorally complete with AI disabled/unavailable.
- Use structured outputs/strict validation where applicable.
- Resolve generated IDs against registries.
- Do not let an LLM invent authoritative memories, knowledge, physical properties, action validity or death outcomes.
- Bounded interpretation may reweight only already admitted candidates/hypotheses.
- Provide deterministic same-function fallbacks.
- Never expose private provider keys in a public web client.

---

# 3D / Blender production

Before producing an asset, start from its cross-cutting catalog row and visual/asset production bundle.

Preferred repeatable workflow:

```text
catalog requirement
→ art grammar/reference
→ inspect existing toolkit
→ deterministic bpy generator where appropriate
→ execute Blender
→ validate structure
→ render gameplay preview
→ inspect actual render
→ bounded iteration
→ export GLB
→ verify integration
→ update catalog status/notes
```

- inspect rendered results; code correctness is not visual correctness;
- evaluate at gameplay camera distance;
- use bounded autonomous aesthetic iterations;
- reuse shared primitives/materials;
- deterministic seeds for procedural variants;
- preserve required semantic anchors/sockets;
- keep geometry simple/silhouettes readable;
- do not add unique animations when generic action + semantic anchor solves it;
- do not modify Wilson's core design incidentally;
- scripts must not rely on active selection unless they set it;
- own/clean only task-generated Blender collections/objects;
- keep units/transforms/export orientation consistent with `ASSET_SPEC.md`;
- do not leave temporary helpers in runtime asset roots;
- do not commit preview/backup/experimentation debris.

---

# Definition of done

## Code/domain change

- matches product/domain/architecture intent;
- relevant strict regressions pass;
- no hidden simulation/presentation coupling;
- deterministic behavior remains reproducible;
- important autonomous decisions/derivations remain explainable;
- numeric guards are explicit;
- persistence/bootstrap implications are tested when affected;
- canonical docs are updated only if a contract actually changed.

## Spatial/presentation adapter change

- preserves domain identity/authority;
- narrow port contract remains usable headlessly;
- coarse semantic placement remains meaningful;
- fine distance/nav/occlusion behavior has deterministic adapter tests where practical;
- Godot integration smoke tests validate mapping/anchors without making presentation authoritative;
- representative dense/sparse/occluded/blocked cases are covered.

## Scenario/bootstrap change

- fixture enters through common restore/bootstrap boundary;
- no direct private-store mutation shortcut;
- invalid fixture admission fails clearly;
- rebuild semantics match real restore;
- deterministic seed is explicit;
- headless and presentation use the same authoritative scenario state where practical;
- edge, extreme, volume and multi-seed validation is included.

## Architecture/design-contract change

- authority owner explicit;
- durable vs derived state explicit;
- producer/consumer boundaries explicit;
- representative fixtures still fit without bespoke hacks;
- guard/calibration implications considered;
- existing canonical owner updated;
- status/handoff updated only when phase/sequencing changed.

## Asset/catalog change

- catalog row captures cross-cutting semantics without redefining domain;
- applicable visual contracts satisfied;
- required states/contrasts/anchors represented;
- gameplay-camera preview reviewed where applicable;
- runtime asset conventions validated;
- catalog status reflects actual completion.

---

# Architectural change protocol

Documentation describes current intended contracts, not immutable law. If implementation/content evidence proves a contract wrong:

1. identify the conflict and representative behavior/invariant;
2. explain the tradeoff;
3. update the canonical owner document;
4. update affected tests/content/assets;
5. update `DISCOVERY_STATUS`/handoff only when sequencing or closed decisions changed;
6. do not quietly implement a contradictory second architecture.

## Priority

When tradeoffs conflict, optimize in this order:

1. coherent player experience;
2. simulation correctness and persistence safety;
3. behavioral legibility/historical continuity;
4. systemic reuse/combinatorial value;
5. visual coherence/readability;
6. developer/agent reproducibility;
7. raw content quantity.