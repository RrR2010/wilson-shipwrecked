# Documentation Map

## Purpose

This file is the entry point for project documentation.

Wilson Shipwrecked accumulated substantial design evidence during discovery. Not every document is required reading for every task. Use four conceptual layers:

```text
1. canonical contracts    — current rules and ownership boundaries
2. specialized appendices — narrow semantic detail
3. validation evidence    — traces/fixtures/regressions proving sufficiency
4. historical evidence    — brainstorming and handoffs
```

Read the smallest bundle sufficient for the task. Validation/history must not become competing specifications.

---

# 1. Start here

For substantial work:

1. [`../README.md`](../README.md) — project thesis;
2. [`DISCOVERY_STATUS.md`](DISCOVERY_STATUS.md) — current phase/closed gates;
3. then use the relevant bundle below.

`AGENTS.md` owns repository workflow/invariants, not the full design specification.

---

# 2. Product and Wilson behavior

## Canonical

- [`PRODUCT.md`](PRODUCT.md) — player experience, modes, God Power, progression and product rules.
- [`BEHAVIORAL_MODEL.md`](BEHAVIORAL_MODEL.md) — Wilson functional cognition/behavior.
- [`STATE_REQUIREMENTS.md`](STATE_REQUIREMENTS.md) — persistence, scope, lifetime, decay, offline and resurrection semantics.

## Validation/background

- [`SCENE_VALIDATION.md`](SCENE_VALIDATION.md) — representative-scene behavioral coverage.
- [`brainstorming/representative-scene-catalog.md`](brainstorming/representative-scene-catalog.md) — original scene-design evidence.
- [`SIMULATION.md`](SIMULATION.md) — broad early simulation vocabulary; newer stabilized behavior/domain docs win on conflicts.

---

# 3. Architecture and runtime authority

## Canonical

- [`ARCHITECTURE.md`](ARCHITECTURE.md) — **state owners, derived services, language-neutral module/package layout, dependency direction, graph/index placement, application/infrastructure/presentation boundaries**.
- [`SIMULATION_CONTRACTS.md`](SIMULATION_CONTRACTS.md) — semantic cross-system contracts.
- [`SIMULATION_ORCHESTRATION.md`](SIMULATION_ORCHESTRATION.md) — clocks, update ordering, reconsideration/interruption/offline orchestration.
- [`MUTATION_AUTHORITY.md`](MUTATION_AUTHORITY.md) — read/propose/mutate ownership matrix.
- [`GUARDS_AND_CALIBRATION.md`](GUARDS_AND_CALIBRATION.md) — bounds, feedback-loop control and adaptive-policy constraints.
- [`AI.md`](AI.md) — optional runtime LLM authority/fallback boundary.

## Validation/history

- [`DECISION_TRACES.md`](DECISION_TRACES.md) — representative architecture traces.
- [`IMPLEMENTATION_GATE.md`](IMPLEMENTATION_GATE.md) — historical readiness gate; passed.

Use this bundle for modules, dependencies, orchestration, persistence ownership, graph/index placement and external adapters.

---

# 4. Functional domain

The domain documents are language-neutral.

## Core canonical set

1. [`DOMAIN_MODEL.md`](DOMAIN_MODEL.md) — aggregates, runtime identity, durable state and core domain concepts.
2. [`DOMAIN_VOCABULARY.md`](DOMAIN_VOCABULARY.md) — normalized semantic terminology.
3. [`DOMAIN_CATALOGS.md`](DOMAIN_CATALOGS.md) — relation/predicate/effect/proposition vocabulary.
4. [`DOMAIN_OPERATIONS.md`](DOMAIN_OPERATIONS.md) — **single canonical command/query/derivation/lifecycle surface**, including graph-aware traversal/pattern matching, effective-physical queries, attemptability, tactical/intentional operations, assembly, protection/exposure, hazards and epistemic queries.
5. [`DOMAIN_PROCEDURAL_COMPOSITION.md`](DOMAIN_PROCEDURAL_COMPOSITION.md) — materials, effective physical composition, assembly, gradual exploration and environmental procedurality.

`DOMAIN_SCHEMA.dbml` is a visualization projection only; it is not a persistence/database mandate.

The former `DOMAIN_OPERATION_REFINEMENTS.md` has been absorbed into `DOMAIN_OPERATIONS.md`. Do not recreate an override layer for operation signatures.

Typed semantic graph/index concerns are intentionally **not a separate canonical document**. Their responsibility/placement lives in `ARCHITECTURE.md`; their public query/matching semantics live in `DOMAIN_OPERATIONS.md`; detailed relation/property/composition/epistemic meaning remains owned by the corresponding domain documents.

## Specialized canonical appendices

Read only for affected concerns:

- [`DOMAIN_ENVIRONMENTAL_PROTECTION.md`](DOMAIN_ENVIRONMENTAL_PROTECTION.md) — configuration-relative protection/exposure.
- [`DOMAIN_HAZARD_DYNAMICS.md`](DOMAIN_HAZARD_DYNAMICS.md) — committed dynamic processes, hazard projections, perceived threats and causal windows.
- [`DOMAIN_EPISTEMIC_INVESTIGATION.md`](DOMAIN_EPISTEMIC_INVESTIGATION.md) — expectation mismatch, bounded investigation and causal attribution.
- [`DOMAIN_MICRO_LOOP.md`](DOMAIN_MICRO_LOOP.md) — semantic frame-group execution, tactical vs intentional cadence and same-chain learning.

## Validation evidence

Not default required reading:

- [`DOMAIN_REGRESSION.md`](DOMAIN_REGRESSION.md)
- [`DOMAIN_OPERATION_TRACES.md`](DOMAIN_OPERATION_TRACES.md)
- [`DOMAIN_VOCABULARY_REGRESSION.md`](DOMAIN_VOCABULARY_REGRESSION.md)
- [`DOMAIN_MICRO_LOOP_FALLING_PALM.md`](DOMAIN_MICRO_LOOP_FALLING_PALM.md)
- [`DOMAIN_MICRO_LOOP_SABOTAGED_STORAGE.md`](DOMAIN_MICRO_LOOP_SABOTAGED_STORAGE.md)
- [`DOMAIN_FIXTURE_IMPROVISED_HAMMER.md`](DOMAIN_FIXTURE_IMPROVISED_HAMMER.md)
- [`DOMAIN_FIXTURE_CLOTH_SHELTER_WEATHER.md`](DOMAIN_FIXTURE_CLOTH_SHELTER_WEATHER.md)

The Scientific Method fixture remains in `DOMAIN_MICRO_LOOP.md` because that document also owns canonical execution semantics.

---

# 5. Cross-cutting asset/content catalog

- [`asset-catalog/README.md`](asset-catalog/README.md) — catalog schema/authority/status rules.
- [`asset-catalog/ENTITIES.md`](asset-catalog/ENTITIES.md) — physical entity/resource/tool/container/salvage families.
- [`asset-catalog/PROJECTS.md`](asset-catalog/PROJECTS.md) — composed projects/structures.
- [`asset-catalog/LIVING_WORLD.md`](asset-catalog/LIVING_WORLD.md) — terrain/place, flora, fauna, habitats and environment/opportunity families.
- [`asset-catalog/SCENE_COVERAGE.md`](asset-catalog/SCENE_COVERAGE.md) — representative-scene content regression evidence.

The catalog is the cross-cutting source of truth for modeled-content requirements/backlog. It references rather than supersedes product/domain/art contracts.

For functional catalog work:

```text
README.md / PRODUCT.md
→ DOMAIN_MODEL.md
→ DOMAIN_VOCABULARY.md
→ DOMAIN_CATALOGS.md
→ DOMAIN_OPERATIONS.md when interactions/matching matter
→ DOMAIN_PROCEDURAL_COMPOSITION.md
→ asset-catalog/README.md
→ relevant catalog tables
```

---

# 6. Art and asset production

## Visual language

- [`VISUAL_GUIDE.md`](VISUAL_GUIDE.md)
- [`art/README.md`](art/README.md)
- focused `art/` direction/reference documents.

## Runtime production contract

- [`ASSET_SPEC.md`](ASSET_SPEC.md)
- [`ASSET_PIPELINE.md`](ASSET_PIPELINE.md)
- [`art/AGENT_ART_PRODUCTION.md`](art/AGENT_ART_PRODUCTION.md)

`art/` must not maintain a second object catalog. Asset identity/backlog lives in `asset-catalog/`.

---

# 7. Historical / exploratory material

- `brainstorming/functional-asset-catalog/` — historical breadth exploration.
- `brainstorming/representative-scene-catalog.md` — original scene exploration.
- `handoffs/` — transition context, never durable design authority.

Use these for intent/recall, not precedence over canonical contracts.

---

# 8. Authority rules

When documents appear to disagree:

1. **Product/behavior:** `PRODUCT.md` + `BEHAVIORAL_MODEL.md` + `STATE_REQUIREMENTS.md`.
2. **Architecture/responsibility/module boundaries:** `ARCHITECTURE.md` + Contracts + Orchestration + Mutation Authority.
3. **Functional semantics:** the core `DOMAIN_*` set and affected specialized appendix.
4. **Operations:** `DOMAIN_OPERATIONS.md` is the single canonical public operation surface.
5. **Asset/content requirements:** `asset-catalog/` owns required modeled families/cross-cutting content requirements.
6. **Art:** `VISUAL_GUIDE.md` + `art/`; technical production in `ASSET_SPEC.md`/`ASSET_PIPELINE.md`.
7. **Fixtures/regressions:** evidence only.
8. **Brainstorming/handoffs:** historical/operational evidence only.

If implementation evidence invalidates a canonical rule, update the owning document instead of adding another permanent override.

---

# 9. Documentation growth policy

To prevent renewed fragmentation:

- prefer updating an existing canonical owner over creating a new top-level document;
- create a new canonical document only when the concern has a genuinely distinct authority/lifecycle and cannot remain readable in an existing owner;
- do not create permanent `*_REFINEMENTS`, `*_NOTES`, `*_V2` or edge-case override chains when the accepted result can be merged into the owning contract;
- keep scenario evidence in fixtures/regressions;
- keep cross-cutting content requirements in `asset-catalog/`;
- keep exploratory breadth in `brainstorming/`;
- keep stage-transfer instructions in `handoffs/`;
- after consolidating a superseding document, remove the old override and repair the documentation map in the same change.

A future mechanical move of validation artifacts into subdirectories is optional and should be atomic with link updates.