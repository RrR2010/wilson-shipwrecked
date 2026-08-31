# AGENTS.md

## Mission

Build Wilson Shipwrecked as a coherent systemic simulation and living 3D diorama. Optimize for reusable rules, explicit authority and modular content rather than maximum feature count.

## Current project phase

The **structural runtime foundation is complete** and has passed the strict Godot 4.7.1 headless gate.

Before substantial work, read:

1. [`docs/README.md`](docs/README.md) — documentation map/authority hierarchy;
2. [`docs/DISCOVERY_STATUS.md`](docs/DISCOVERY_STATUS.md) — current concrete foundation/test/schema baseline;
3. only the canonical bundle relevant to the task.

The next phase is predominantly **system/content/presentation breadth** on the stabilized foundation: drives/body, projects, richer cognition learning/candidate producers, environment/processes, hazards/protection, shallow actors, Director/player/run lifecycle and Godot adapters.

Do not reopen foundation ownership, replace established typed contracts with generic containers, or introduce a new universal framework merely because one new system needs implementation.

---

# Documentation workflow

Do **not** read every document linearly by default. Read the smallest canonical bundle sufficient for the task; use fixtures/regressions as evidence rather than competing specifications.

## Simulation/domain/architecture

Relevant canonical core:

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

Read specialized appendices only when affected:

```text
DOMAIN_ENVIRONMENTAL_PROTECTION.md
DOMAIN_HAZARD_DYNAMICS.md
DOMAIN_EPISTEMIC_INVESTIGATION.md
DOMAIN_MICRO_LOOP.md
```

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
- Do not recreate permanent `*_REFINEMENTS`, `*_NOTES`, `*_V2` override chains when the accepted result belongs in an existing owner.
- Concrete schema versions/test counts belong in `DISCOVERY_STATUS.md`, not duplicated across domain documents.

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

# Structural foundation invariants

These contracts are already regression-backed. Preserve them unless new representative evidence proves a canonical change is required.

## Authority

```text
World truth
!= Wilson observation
!= Wilson belief
!= player-private intent
!= presentation
```

State owners conceptually remain:

```text
World
Wilson Cognition
Projects
Player Run State / Intervention
Director
Action Execution / Resolution
Player Profile across runs
```

A projection/service/index does not become an owner because it is convenient to mutate it.

## Typed semantic identity

- Use `DomainId`/typed semantic IDs rather than display strings/scene paths as identity.
- Durable belief identity uses typed `EpistemicClaim`, currently `PROPERTY | RELATION | EVENT`.
- Do **not** restore generic `predicate + arbitrary Variant arguments` as durable epistemic identity.
- Numeric semantic identity must survive JSON representation changes such as `3` ↔ `3.0`.
- Property/qualifier semantic values are bounded; NaN/infinity are invalid.

## Event naming

- `EventDefinition` = semantic/perceptual definition of an ordinary `WorldEvent` kind.
- `WorldEvent` = authoritative occurrence fact after successful owner commit.
- `ObservedEvent` = Wilson-accessible projection.
- Director-owned lifecycle uses `DirectedEventDefinition` / `DirectedEventInstance`.

Do not overload unqualified `EventDefinition` for Director state.

## World relations

`WorldRelation` exact identity includes:

```text
RelationTypeId + subject + object + optional qualifier
```

Qualifier is a bounded semantic scalar/symbol/typed ID — never an arbitrary Dictionary/Array.

Broad endpoint queries may return multiple differently qualified relations. Exact create/remove includes qualifier identity.

Assembly bindings use ordinary World relations, currently:

```text
attached_to(component, host, qualifier = AssemblySlotId)
```

There is no `AssemblyStore`.

## Composition / derived physical state

- `EffectivePhysicalProfile`, `AssemblyValidity`, `CompositionDependencyProjection` are reconstructible derived semantics.
- `AssemblyValidity != performance`.
- component changes invalidate dependent host profiles through composition dependency projection; do not scatter manual host invalidation.
- do not create target-specific crafting recipes when capabilities/properties/assembly semantics suffice.

## Action causality

- `ActionAttemptability` is a pure authoritative read; it does not guarantee goal success.
- `ActionExecution` owns progress/commit/terminal lifecycle but does not mutate World.
- crossing commit emits one `ActionOutcome` exactly once.
- World owner separately validates/applies the outcome.
- supported effect batches are prospectively/sequentially prevalidated before mutation.
- committed physical truth cannot be rewound by reconsideration, suggestion, Luck or load/reconstruction.
- restore of an already-started action restores historical causal state and does not rerun current attemptability.

Current coarse interruption classes:

```text
PRE_COMMIT_ONLY
NEVER
ANYTIME
```

If richer safe checkpoints become necessary, add them explicitly through canonical review; do not encode them as animation/frame timing hacks.

## Perception / learning

- Event perceptibility + runtime spatial access determine accessible roles/modalities.
- cognition receives only accessible `ObservedEvent`/`PerceptualEvidence` semantics.
- `PerceptualEvidence` carries a typed `EpistemicClaim` + bounded confidence/provenance.
- `EpistemicGraphProjection` indexes only `BeliefStore`; never import hidden World truth.
- relevant same-chain learning happens before the next tactical choice when it can change that choice.

## Derived maintenance

`SemanticChangeSet` exists to invalidate/rebuild reconstructible derived state. It is not a generic gameplay event bus.

---

# General engineering invariants

1. Keep authoritative simulation independent from rendering.
2. Prefer composition/data-driven semantics over concrete-type branching.
3. Route authoritative mutation through validated owner operations/effects.
4. Keep gameplay randomness seeded/reproducible; presentation randomness separate.
5. Do not couple game correctness to LLM availability.
6. Prefer the smallest reusable primitive proven by current cases; avoid premature universal frameworks.
7. Add deterministic/headless regressions for domain/system changes.
8. Preserve explainability: decisions/derivations must expose useful provenance/diagnostics.
9. Keep code/comments/docs in English.
10. Persist only state justified by state/domain contracts; do not persist reconstructible projections for convenience.
11. Keep critical mutation order explicit; no broad event-bus authority.
12. Keep evaluator contributions finite/bounded; no infinity/huge-score priority hacks.
13. Keep physical truth, Wilson knowledge/belief and desirability distinct.
14. Keep player-private intent distinct from Wilson observation/attribution.
15. Prefer effective properties/capabilities from material + condition + composition + contents over combinatorial entity variants.
16. Do not model exploration as a universal percentage.
17. Keep committed dynamic-process evolution distinct from unresolved future collision/consequence.
18. Wilson emergency decisions consume perceived threat, never hidden hazard projections.
19. Stable semantic ordering precedes deterministic tie-break/seeded random selection where order matters.
20. Reconstruct indexes/caches from authority after load; never let a cache become truth.

---

# Standard test gate

For runtime/domain changes, the standard local checkpoint is:

```powershell
.\tests\run_headless_tests.ps1
```

The runner is stricter than Godot process exit status. It rejects:

```text
nonzero exit
SCRIPT ERROR
parse/compile errors
generic engine ERROR:
explicit FAIL
missing expected PASS marker
```

Do not claim a runtime slice green until the strict suite passes locally. `DISCOVERY_STATUS.md` records the latest validated count.

When adding a test:

- use deterministic semantic assertions rather than wall-clock performance assertions;
- include edge/reconstruction branches when causal state/persistence changes;
- prefer representative integrated scenarios in addition to isolated unit slices;
- test bounds/truncation/stable ordering explicitly for scalable queries;
- never print PASS after an incomplete/erroring test body.

---

# Architecture and system implementation

Preserve:

```text
state-owning authoritative systems
derived/composable services
explicit application/orchestration
presentation/infrastructure adapters
```

Do not create one state-owning `System` for every psychology noun/content family/procedural mechanic.

When adding behavior, ask in order:

1. Is this an existing action applied to a new compatible property/material/profile?
2. Is one reusable property/capability/relation/typed claim/evidence rule enough?
3. Can runtime composition derive it?
4. Can existing belief/history/habit/project/decision composition explain it?
5. Can an environmental/dynamic-process rule express it parametrically?
6. Does it genuinely require a new primitive/owner?

A large `if entity_type == ...` interaction chain is normally a design smell.

## Current breadth sequence

Default next sequence, unless representative evidence suggests otherwise:

```text
1. Wilson body/drives + bounded candidate producers
2. Project runtime/lifecycle + project candidate source
3. associations/habits/episodes/Presence learning producers
4. environment/weather + persisted dynamic processes
5. protection/exposure + hazards/immediate-threat production
6. shallow non-Wilson actors/animals
7. Director + player intervention/suggestions
8. death/resurrection/Legacy/Profile run lifecycle
9. Godot spatial/presentation adapters
10. broader multi-system scenario + seed-population tests
```

Implement breadth through existing ports first. Introduce a new core owner/framework only when an existing contract cannot express required behavior cleanly.

## Catalog versus domain

The asset catalog may state required properties, capabilities, interaction roles, assembly slots, states, contrasts and production assets.

It must not silently introduce:

```text
new psychological primitives
new authoritative property families
new action semantics
object-pair recipes
hidden exploration flags
scene-specific state machines
```

If catalog work exposes a real domain gap, update the correct canonical domain owner as a separate reviewed decision.

---

# Guards and calibration

Follow `docs/GUARDS_AND_CALIBRATION.md` for numeric accumulation/adaptive control.

- hard finite bounds are invariants;
- prefer saturating/diminishing updates before clamp;
- use semantic counter-pressure before hidden normalization;
- strong contradiction must remain able to revise beliefs;
- do not normalize psychology/history toward target averages invisibly;
- evaluate health across deterministic run populations instead of forcing each run to one distribution;
- adaptive control is bounded/whitelisted;
- immediate threat uses a separate regime.

---

# Godot / implementation boundary

- Godot nodes are presentation/infrastructure adapters, not domain identities.
- Map stable domain entity IDs to scene instances explicitly.
- Query simulation attemptability/affordances; do not duplicate legality in UI.
- Use semantic animation/action names.
- Use semantic interaction regions/anchors rather than object-specific offsets.
- Render frame rate is not authoritative time.
- Keep web-export constraints in mind and measure before adding expensive techniques.
- Fine transforms/nav/occlusion may implement the spatial port; they do not replace coarse/domain semantic placement identity.

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
- persistence/reconstruction implications are tested when affected;
- canonical docs are updated only if a contract actually changed.

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
