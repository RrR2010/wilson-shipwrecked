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
3. [`DEVELOPMENT_STAGES.md`](DEVELOPMENT_STAGES.md) — canonical macro maturity map from systemic foundation through productization;
4. [`handoffs/observable-living-simulation-to-entertaining-systemic-diorama.md`](handoffs/observable-living-simulation-to-entertaining-systemic-diorama.md) — **active tactical handoff**;
5. then use the relevant canonical bundle below.

## Current phase

The structural/runtime foundation and the first continuously observable Godot living-simulation phase are complete.

The validated living island composes real runtime behavior for:

```text
hunger / food
energy / rest
stimulation / exploration
persistent shelter construction
weather / tactical shelter response
Gerald shallow physical locomotion
operator observability and time acceleration
```

The leading work is now **Stage 3 — Entertaining autonomous diorama**.

The target is no longer merely “more systems running together.” The living scene must increasingly demonstrate:

```text
quiet personal/non-utility behavior
physical experimentation / discovery
actor or environment interference
history that visibly changes later behavior
post-project life
bounded anti-stagnation
semantic action/reaction timing that remains visually legible
```

`DEVELOPMENT_STAGES.md` owns this macro maturity contract. The active handoff owns only the next bounded implementation cut.

The previous handoff [`handoffs/systemic-runtime-to-observable-godot-living-simulation.md`](handoffs/systemic-runtime-to-observable-godot-living-simulation.md) is completed historical context.

Primitive shapes, bubbles and debug overlays remain presentation projections over the real runtime. They are not semantic identity or a second World/cognition model.

However, do not interpret “presentation is non-authoritative” as “presentation timing is irrelevant.” Important action/reaction phases may require semantic duration or interruption semantics so the player can actually perceive them. The concrete animation clip remains presentation-owned; the gameplay meaning/timing contract belongs in `SIMULATION_ORCHESTRATION.md`.

Asset/modeling production remains a parallel workstream and is outside the active runtime handoff unless the operator explicitly changes scope.

`AGENTS.md` owns repository workflow/global invariants; `DISCOVERY_STATUS.md` owns concrete test/schema/checkpoint facts.

---

# 2. Product and Wilson behavior

## Canonical

- [`PRODUCT.md`](PRODUCT.md) — player experience, modes, God Power, progression and product rules.
- [`BEHAVIORAL_MODEL.md`](BEHAVIORAL_MODEL.md) — Wilson functional cognition/behavior. In particular, Stimulation already owns anti-stagnation/boredom pressure; do not create a second generic boredom system without new evidence.
- [`STATE_REQUIREMENTS.md`](STATE_REQUIREMENTS.md) — persistence, scope, lifetime, decay, offline and resurrection semantics.
- [`DEVELOPMENT_STAGES.md`](DEVELOPMENT_STAGES.md) — macro product-development maturity stages and completion gates; not a feature backlog.

## Validation/background

- [`SCENE_VALIDATION.md`](SCENE_VALIDATION.md) — representative-scene behavioral coverage.
- [`brainstorming/representative-scene-catalog.md`](brainstorming/representative-scene-catalog.md) — original scene-design evidence.
- [`SIMULATION.md`](SIMULATION.md) — broad early vocabulary; newer stabilized behavior/domain docs win on conflicts.

Stage 3 should prove a narrow example of several core phenomenon families before Stage 6 expands them. In particular, do not postpone all experimentation/discovery, quiet preference or history-dependent behavior until the breadth stage.

---

# 3. Architecture and runtime authority

## Canonical

- [`ARCHITECTURE.md`](ARCHITECTURE.md) — owners, derived services, dependency direction, Godot/persistence and common bootstrap/restore boundaries.
- [`SIMULATION_CONTRACTS.md`](SIMULATION_CONTRACTS.md) — semantic cross-system contracts.
- [`SIMULATION_ORCHESTRATION.md`](SIMULATION_ORCHESTRATION.md) — semantic clocks, update ordering, commit/perception/learning/reconsideration/offline orchestration **and semantic presentation timing boundaries**.
- [`MUTATION_AUTHORITY.md`](MUTATION_AUTHORITY.md) — read/propose/mutate ownership matrix.
- [`GUARDS_AND_CALIBRATION.md`](GUARDS_AND_CALIBRATION.md) — bounds, feedback-loop control and adaptive-policy constraints.
- [`AI.md`](AI.md) — optional runtime LLM authority/fallback boundary.

Current validated routing refinement: `TACTICAL` responses may begin from idle as well as refine/interrupt an active ordinary intention. Concrete checkpoint evidence lives in `DISCOVERY_STATUS.md` and tests.

For action/reaction presentation work, preserve this split:

```text
semantic meaning / duration / checkpoints / interruption
!= concrete animation clip / blend / facial pose / audio
!= decorative renderer-only motion
```

Never make `animation_finished` authoritative proof that a World consequence occurred. Conversely, do not let an important semantic reaction be visually erased by starting unrelated physical behavior immediately when that reaction is supposed to occupy Wilson.

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

Manual observation now evaluates a different risk than the strict suite. Use the maturity vocabulary in `DEVELOPMENT_STAGES.md` (`works → legible → interesting → memorable → fun`) rather than treating test count as a proxy for entertainment.

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

Content planning should increasingly consider **systemic role coverage**, not only modeled-asset count. Useful roles include need relief, curiosity, tool use, project participation, hazard, preference/attachment, actor interaction, player intervention, weather response and transformation/discovery.

Prefer additions that create new cross-system combinations or functional alternatives over several visually distinct objects with identical simulation roles.

## Visual / 3D production

- `VISUAL_GUIDE.md`
- `art/README.md`
- `ASSET_SPEC.md`
- `ASSET_PIPELINE.md`
- `art/AGENT_ART_PRODUCTION.md`
- `prototyping/`

The asset catalog owns modeled-content requirements/backlog; art docs own visual direction; prototype geometry does not override product/domain semantics.

Production animation assets may arrive later, but semantic action/reaction timing must be validated before final animation polish. Animation work should map authored clips onto existing semantic phases rather than silently define gameplay causality.

---

# 7. Historical / exploratory material

- `brainstorming/` — exploratory/historical evidence.
- `design-reviews/` — temporary calibration/review evidence.
- `handoffs/` — transition context, never durable design authority. Only the handoff explicitly identified in **Start here** is active.

---

# 8. Authority rules

When documents appear to disagree:

1. Product/behavior: `PRODUCT.md` + `BEHAVIORAL_MODEL.md` + `STATE_REQUIREMENTS.md`.
2. Macro development maturity/stage gates: `DEVELOPMENT_STAGES.md`.
3. Architecture/orchestration/authority: `ARCHITECTURE.md` + `SIMULATION_CONTRACTS.md` + `SIMULATION_ORCHESTRATION.md` + `MUTATION_AUTHORITY.md`.
4. Functional semantics: core `DOMAIN_*` set and affected appendix.
5. Operations: `DOMAIN_OPERATIONS.md`.
6. Concrete implementation checkpoint: `DISCOVERY_STATUS.md` + source/tests.
7. Asset/content requirements: `asset-catalog/`.
8. Art: `VISUAL_GUIDE.md` + `art/`; technical production in `ASSET_SPEC.md` / `ASSET_PIPELINE.md`.
9. Fixtures/regressions: evidence only.
10. Brainstorming/handoffs/reviews: historical or operational context only.

If implementation evidence invalidates a canonical rule, update the owning document rather than creating a permanent override chain.

---

# 9. Documentation growth policy

- prefer updating an existing canonical owner;
- create a new canonical document only for a genuinely distinct authority/lifecycle;
- keep `DEVELOPMENT_STAGES.md` macro-level; do not turn it into a feature backlog;
- do not create permanent `*_REFINEMENTS`, `*_NOTES` or `*_V2` chains;
- keep executable engine validation under `tests/`;
- keep prototype modeling guidance under `prototyping/`;
- keep cross-cutting modeled-content requirements under `asset-catalog/`;
- keep exploratory breadth under `brainstorming/`;
- keep transition instructions under `handoffs/`;
- after a handoff completes, mark it completed and point this map at the next active transition.
