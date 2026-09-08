# Documentation Map

## Purpose

This file is the entry point for project documentation.

Use four conceptual layers:

```text
1. canonical contracts    — current product/domain/architecture rules
2. specialized appendices — narrow semantic detail
3. validation evidence    — traces/fixtures/tests proving sufficiency
4. historical evidence    — brainstorming, reviews and completed handoffs
```

Read the smallest bundle sufficient for the task. Validation/history must not become competing specifications.

---

# 1. Start here

For substantial runtime/gameplay work:

1. [`../README.md`](../README.md) — project thesis;
2. [`DISCOVERY_STATUS.md`](DISCOVERY_STATUS.md) — current validated implementation/test/schema baseline;
3. [`handoffs/observable-living-simulation-to-entertaining-systemic-diorama.md`](handoffs/observable-living-simulation-to-entertaining-systemic-diorama.md) — **active stage-transition handoff**;
4. then use the relevant canonical bundle below.

## Current phase

The structural/runtime foundation and the first continuously observable Godot living-simulation phase are complete.

The validated living island now composes real runtime behavior for:

```text
hunger / food
energy / rest
stimulation / exploration
persistent shelter construction
weather / tactical shelter response
Gerald shallow physical locomotion
operator observability and time acceleration
```

The leading work is now **entertaining systemic-diorama calibration**: reduce inert idle, make Gerald/environment/history create visible situations, and make prior experience change later behavior while preserving existing authority boundaries.

The previous handoff [`handoffs/systemic-runtime-to-observable-godot-living-simulation.md`](handoffs/systemic-runtime-to-observable-godot-living-simulation.md) is completed historical context.

Primitive shapes, bubbles and debug overlays remain presentation projections over the real runtime. They are not semantic identity or a second World/cognition model.

Asset/modeling production remains a parallel workstream and is outside the active runtime handoff unless the operator explicitly changes scope.

`AGENTS.md` owns repository workflow/global invariants; `DISCOVERY_STATUS.md` owns concrete test/schema/checkpoint facts.

---

# 2. Product and Wilson behavior

## Canonical

- [`PRODUCT.md`](PRODUCT.md) — player experience, modes, God Power, progression and product rules.
- [`BEHAVIORAL_MODEL.md`](BEHAVIORAL_MODEL.md) — Wilson functional cognition/behavior. In particular, Stimulation already owns anti-stagnation/boredom pressure; do not create a second generic boredom system without new evidence.
- [`STATE_REQUIREMENTS.md`](STATE_REQUIREMENTS.md) — persistence, scope, lifetime, decay, offline and resurrection semantics.

## Validation/background

- [`SCENE_VALIDATION.md`](SCENE_VALIDATION.md) — representative-scene behavioral coverage.
- [`brainstorming/representative-scene-catalog.md`](brainstorming/representative-scene-catalog.md) — original scene-design evidence.
- [`SIMULATION.md`](SIMULATION.md) — broad early vocabulary; newer stabilized behavior/domain docs win on conflicts.

---

# 3. Architecture and runtime authority

## Canonical

- [`ARCHITECTURE.md`](ARCHITECTURE.md) — owners, derived services, dependency direction, Godot/persistence and common bootstrap/restore boundaries.
- [`SIMULATION_CONTRACTS.md`](SIMULATION_CONTRACTS.md) — semantic cross-system contracts.
- [`SIMULATION_ORCHESTRATION.md`](SIMULATION_ORCHESTRATION.md) — semantic clocks, update ordering, commit/perception/learning/reconsideration/offline orchestration.
- [`MUTATION_AUTHORITY.md`](MUTATION_AUTHORITY.md) — read/propose/mutate ownership matrix.
- [`GUARDS_AND_CALIBRATION.md`](GUARDS_AND_CALIBRATION.md) — bounds, feedback-loop control and adaptive-policy constraints.
- [`AI.md`](AI.md) — optional runtime LLM authority/fallback boundary.

Current validated routing refinement: `TACTICAL` responses may begin from idle as well as refine/interrupt an active ordinary intention. Concrete checkpoint evidence lives in `DISCOVERY_STATUS.md` and tests.

## Validation/history

- [`DECISION_TRACES.md`](DECISION_TRACES.md) — representative architecture traces.
- [`IMPLEMENTATION_GATE.md`](IMPLEMENTATION_GATE.md) — historical pre-foundation readiness gate; passed.

---

# 4. Functional domain

The domain documents are language-neutral. Concrete GDScript/schema/test details belong in `DISCOVERY_STATUS.md` and source/tests.

## Core canonical set

1. [`DOMAIN_MODEL.md`](DOMAIN_MODEL.md) — aggregates, runtime identity, durable state and core concepts.
2. [`DOMAIN_VOCABULARY.md`](DOMAIN_VOCABULARY.md) — normalized semantic terminology.
3. [`DOMAIN_CATALOGS.md`](DOMAIN_CATALOGS.md) — admitted relation/predicate/effect/outcome/epistemic vocabulary.
4. [`DOMAIN_OPERATIONS.md`](DOMAIN_OPERATIONS.md) — canonical public command/query/derivation/lifecycle surface.
5. [`DOMAIN_PROCEDURAL_COMPOSITION.md`](DOMAIN_PROCEDURAL_COMPOSITION.md) — materials, effective physical composition, assembly, exploration and procedurality.

`DOMAIN_SCHEMA.dbml` is a visualization projection, not a persistence/database mandate.

## Specialized canonical appendices

Read only when affected:

- [`DOMAIN_ENVIRONMENTAL_PROTECTION.md`](DOMAIN_ENVIRONMENTAL_PROTECTION.md)
- [`DOMAIN_HAZARD_DYNAMICS.md`](DOMAIN_HAZARD_DYNAMICS.md)
- [`DOMAIN_EPISTEMIC_INVESTIGATION.md`](DOMAIN_EPISTEMIC_INVESTIGATION.md)
- [`DOMAIN_MICRO_LOOP.md`](DOMAIN_MICRO_LOOP.md)

## Validation evidence

Fixtures/regressions such as `DOMAIN_FIXTURE_*`, `DOMAIN_MICRO_LOOP_*`, `DOMAIN_REGRESSION.md` and executable tests prove sufficiency but do not become parallel specifications.

---

# 5. Concrete implementation status and tests

Use [`DISCOVERY_STATUS.md`](DISCOVERY_STATUS.md) for the authoritative checkpoint, including:

```text
strict headless test count
current integrated commit
snapshot/content schema versions
implemented system breadth
known limitations
current calibration pressures
```

Standard local regression command:

```powershell
.\tests\run_headless_tests.ps1
```

The runner rejects script/engine errors, explicit failures, non-zero processes and missing expected PASS markers.

For real-engine spatial/physics/navigation fixtures, also read [`testing/SCENE_TESTS.md`](testing/SCENE_TESTS.md).

The living-island calibration scene is:

```text
tools/living_simulation/living_simulation.tscn
```

It is a real runtime development/calibration surface, not a substitute for semantic headless tests.

---

# 6. Asset/content and art workstreams

These remain valid repository authorities but are outside the active runtime handoff unless explicitly requested.

## Cross-cutting asset/content catalog

- `asset-catalog/README.md`
- `asset-catalog/ENTITIES.md`
- `asset-catalog/PROJECTS.md`
- `asset-catalog/LIVING_WORLD.md`
- `asset-catalog/SCENE_COVERAGE.md`
- `asset-catalog/DIFFICULTY_INDEX.md`

## Visual / 3D production

- `VISUAL_GUIDE.md`
- `art/README.md`
- `ASSET_SPEC.md`
- `ASSET_PIPELINE.md`
- `art/AGENT_ART_PRODUCTION.md`
- `prototyping/`

The asset catalog owns modeled-content requirements/backlog; art docs own visual direction; prototype geometry does not override product/domain semantics.

---

# 7. Historical / exploratory material

- `brainstorming/` — exploratory/historical evidence.
- `design-reviews/` — temporary calibration/review evidence.
- `handoffs/` — transition context, never durable design authority. Only the handoff explicitly identified in **Start here** is active.

---

# 8. Authority rules

When documents appear to disagree:

1. Product/behavior: `PRODUCT.md` + `BEHAVIORAL_MODEL.md` + `STATE_REQUIREMENTS.md`.
2. Architecture/orchestration/authority: `ARCHITECTURE.md` + `SIMULATION_CONTRACTS.md` + `SIMULATION_ORCHESTRATION.md` + `MUTATION_AUTHORITY.md`.
3. Functional semantics: core `DOMAIN_*` set and affected appendix.
4. Operations: `DOMAIN_OPERATIONS.md`.
5. Concrete implementation checkpoint: `DISCOVERY_STATUS.md` + source/tests.
6. Asset/content requirements: `asset-catalog/`.
7. Art: `VISUAL_GUIDE.md` + `art/`; technical production in `ASSET_SPEC.md` / `ASSET_PIPELINE.md`.
8. Fixtures/regressions: evidence only.
9. Brainstorming/handoffs/reviews: historical or operational context only.

If implementation evidence invalidates a canonical rule, update the owning document rather than creating a permanent override chain.

---

# 9. Documentation growth policy

- prefer updating an existing canonical owner;
- create a new canonical document only for a genuinely distinct authority/lifecycle;
- do not create permanent `*_REFINEMENTS`, `*_NOTES` or `*_V2` chains;
- keep executable engine validation under `tests/`;
- keep prototype modeling guidance under `prototyping/`;
- keep cross-cutting modeled-content requirements under `asset-catalog/`;
- keep exploratory breadth under `brainstorming/`;
- keep transition instructions under `handoffs/`;
- after a handoff completes, mark it completed and point this map at the next active transition.
