# Documentation Map

## Purpose

This file is the entry point for project documentation.

Wilson Shipwrecked accumulated substantial design evidence during discovery. That evidence remains useful, but **not every document is required reading for every task**. The documentation is therefore organized conceptually into four layers:

```text
1. canonical contracts   — current rules and ownership boundaries
2. specialized appendices — detailed rules for narrower concerns
3. validation evidence   — traces, fixtures and regressions proving the contracts
4. historical evidence   — brainstorming and stage-transition handoffs
```

Read the smallest bundle that is sufficient for the task. Validation and historical documents should not silently become competing specifications.

---

# 1. Start here

For almost any substantial task:

1. [`../README.md`](../README.md) — project thesis and current milestone direction;
2. [`DISCOVERY_STATUS.md`](DISCOVERY_STATUS.md) — current phase and closed gates;
3. then use one of the task-specific bundles below.

`AGENTS.md` contains repository workflow/invariant instructions, not the complete design specification.

---

# 2. Product and Wilson behavior

## Canonical

- [`PRODUCT.md`](PRODUCT.md) — player experience, modes, God Power, progression and product rules.
- [`BEHAVIORAL_MODEL.md`](BEHAVIORAL_MODEL.md) — Wilson's functional cognition/behavior model.
- [`STATE_REQUIREMENTS.md`](STATE_REQUIREMENTS.md) — persistent versus derived state, scopes, decay, offline and resurrection semantics.

## Supporting validation

- [`SCENE_VALIDATION.md`](SCENE_VALIDATION.md) — representative-scene behavioral coverage and system matrix.
- [`brainstorming/representative-scene-catalog.md`](brainstorming/representative-scene-catalog.md) — original scene catalog; design evidence, not a runtime script catalog.

## Background

- [`SIMULATION.md`](SIMULATION.md) — broad early simulation/property/action vocabulary. Where its provisional wording conflicts with the stabilized domain/behavior documents, the newer canonical documents win.

Use this bundle when changing the player fantasy, Wilson's long-term behavior, psychology, progression, persistence semantics or the meaning of representative scenes.

---

# 3. Architecture and runtime authority

## Canonical

- [`ARCHITECTURE.md`](ARCHITECTURE.md) — state-owning systems, derived services and high-level boundaries.
- [`SIMULATION_CONTRACTS.md`](SIMULATION_CONTRACTS.md) — semantic cross-system contracts.
- [`SIMULATION_ORCHESTRATION.md`](SIMULATION_ORCHESTRATION.md) — clocks, update ordering, interruption/reconsideration and offline orchestration.
- [`MUTATION_AUTHORITY.md`](MUTATION_AUTHORITY.md) — who may read, propose and mutate durable state.
- [`GUARDS_AND_CALIBRATION.md`](GUARDS_AND_CALIBRATION.md) — bounds, feedback-loop control and allowed adaptive stabilization.
- [`AI.md`](AI.md) — optional runtime LLM authority and deterministic fallback boundary.

## Supporting validation/history

- [`DECISION_TRACES.md`](DECISION_TRACES.md) — representative architecture traces.
- [`IMPLEMENTATION_GATE.md`](IMPLEMENTATION_GATE.md) — historical implementation-readiness gate. The gate passed; use it as evidence/sequence context rather than a current master index.

Use this bundle for module boundaries, dependencies, orchestration, persistence ownership, service composition and runtime AI integration.

---

# 4. Functional domain

The domain documents are language-neutral. They define semantics that implementation and content must respect.

## Core canonical set

Read these first:

1. [`DOMAIN_MODEL.md`](DOMAIN_MODEL.md) — aggregates, runtime identity, durable state and core domain concepts.
2. [`DOMAIN_VOCABULARY.md`](DOMAIN_VOCABULARY.md) — normalized names and semantic distinctions.
3. [`DOMAIN_CATALOGS.md`](DOMAIN_CATALOGS.md) — admitted relation, predicate, effect and proposition families.
4. [`DOMAIN_OPERATIONS.md`](DOMAIN_OPERATIONS.md) — command/query/derivation/lifecycle operation surface.
5. [`DOMAIN_PROCEDURAL_COMPOSITION.md`](DOMAIN_PROCEDURAL_COMPOSITION.md) — material/profile derivation, assembly, exploration evidence and environmental procedurality.

`DOMAIN_SCHEMA.dbml` is a visualization projection of the domain; it is **not** a database/persistence mandate.

## Specialized canonical appendices

Read only when the task touches the concern:

- [`DOMAIN_OPERATION_REFINEMENTS.md`](DOMAIN_OPERATION_REFINEMENTS.md) — newer operation signatures/clarifications discovered after the original operation document. **Consolidation target:** when `DOMAIN_OPERATIONS.md` is next structurally revised, absorb these rules there and retire this override layer.
- [`DOMAIN_ENVIRONMENTAL_PROTECTION.md`](DOMAIN_ENVIRONMENTAL_PROTECTION.md) — protection/exposure derivation from world configuration.
- [`DOMAIN_HAZARD_DYNAMICS.md`](DOMAIN_HAZARD_DYNAMICS.md) — committed dynamic processes, perceived threats and causal windows.
- [`DOMAIN_EPISTEMIC_INVESTIGATION.md`](DOMAIN_EPISTEMIC_INVESTIGATION.md) — expectation mismatch, bounded investigation and causal attribution.
- [`DOMAIN_MICRO_LOOP.md`](DOMAIN_MICRO_LOOP.md) — semantic frame-group execution, tactical versus intentional reconsideration and same-chain learning.

These appendices refine the core set but do not create additional state-owning systems.

## Validation evidence

These prove coverage and are **not default required reading**:

- [`DOMAIN_REGRESSION.md`](DOMAIN_REGRESSION.md) — structural regression against representative scenes.
- [`DOMAIN_OPERATION_TRACES.md`](DOMAIN_OPERATION_TRACES.md) — integration traces.
- [`DOMAIN_VOCABULARY_REGRESSION.md`](DOMAIN_VOCABULARY_REGRESSION.md) — vocabulary regression.
- [`DOMAIN_MICRO_LOOP_FALLING_PALM.md`](DOMAIN_MICRO_LOOP_FALLING_PALM.md) — immediate-threat fixture.
- [`DOMAIN_MICRO_LOOP_SABOTAGED_STORAGE.md`](DOMAIN_MICRO_LOOP_SABOTAGED_STORAGE.md) — epistemic-investigation fixture.
- [`DOMAIN_FIXTURE_IMPROVISED_HAMMER.md`](DOMAIN_FIXTURE_IMPROVISED_HAMMER.md) — composite-object/repair fixture.
- [`DOMAIN_FIXTURE_CLOTH_SHELTER_WEATHER.md`](DOMAIN_FIXTURE_CLOTH_SHELTER_WEATHER.md) — environment + assembly + protection fixture.

The Scientific Method fixture remains inside `DOMAIN_MICRO_LOOP.md` because that document also owns canonical execution semantics.

---

# 5. Cross-cutting asset/content catalog

- [`asset-catalog/README.md`](asset-catalog/README.md) — catalog ownership, row dimensions, status and production workflow.
- [`asset-catalog/ENTITIES.md`](asset-catalog/ENTITIES.md) — physical entity/resource/tool/container/salvage families.
- [`asset-catalog/PROJECTS.md`](asset-catalog/PROJECTS.md) — persistent composed projects/structures.
- [`asset-catalog/LIVING_WORLD.md`](asset-catalog/LIVING_WORLD.md) — terrain/place, flora, fauna, habitats and environment/opportunity families.

This directory is the **cross-cutting source of truth for modeled content requirements**. It belongs outside `art/` because each row may connect domain semantics, interactions, composition, states, art requirements, anchors and production status.

The catalog may reference domain primitives; it must not invent new domain semantics merely to make a row convenient.

For catalog/domain validation work, the recommended minimum reading path is:

```text
README.md / PRODUCT.md
→ DOMAIN_MODEL.md
→ DOMAIN_VOCABULARY.md
→ DOMAIN_CATALOGS.md
→ DOMAIN_PROCEDURAL_COMPOSITION.md
→ asset-catalog/README.md
→ the catalog tables being modified
```

Then consult specialized domain appendices only for affected rows (hazard, investigation, environmental protection, etc.).

---

# 6. Art and asset production

## Visual language

- [`VISUAL_GUIDE.md`](VISUAL_GUIDE.md) — top-level visual thesis/source of truth.
- [`art/README.md`](art/README.md) — operational visual-production map.
- `art/ART_DIRECTION.md`, `art/SHAPE_LANGUAGE.md`, `art/PALETTE_AND_MATERIALS.md`, `art/SCALE_CAMERA_AND_READABILITY.md` — focused visual appendices.
- `art/reference/` — family grammar/reference sheets and approved visual references.

## Runtime production contract

- [`ASSET_SPEC.md`](ASSET_SPEC.md) — runtime model/anchor/socket conventions.
- [`ASSET_PIPELINE.md`](ASSET_PIPELINE.md) — Blender → validation → GLB → Godot workflow.
- [`art/AGENT_ART_PRODUCTION.md`](art/AGENT_ART_PRODUCTION.md) — artistic generation/review loop.

`art/` must not maintain a second list of objects. Asset identity/backlog lives in `asset-catalog/`.

---

# 7. Historical / exploratory material

- `brainstorming/functional-asset-catalog/` — Rounds 1–10 that generated breadth and normalization evidence before the cross-cutting catalog was created.
- `brainstorming/representative-scene-catalog.md` — original player-visible scene exploration.
- `handoffs/` — stage-transition context. Handoffs are operational/history documents and must point back to canonical contracts.

Historical material is valuable for recovering intent and finding omitted content, but it must not override stabilized canonical contracts.

---

# 8. Current authority rules

When documents appear to disagree:

1. **Product experience:** `PRODUCT.md` + validated `BEHAVIORAL_MODEL.md` / `STATE_REQUIREMENTS.md` own the current behavior semantics.
2. **Architecture:** `ARCHITECTURE.md` + Contracts + Orchestration + Mutation Authority own runtime responsibility boundaries.
3. **Functional semantics:** the stabilized `DOMAIN_*` canonical set owns language-neutral domain meaning.
4. **Asset/content requirements:** `asset-catalog/` owns which modeled content families are required and their cross-cutting requirements; it references rather than supersedes the domain/art contracts.
5. **Art:** `VISUAL_GUIDE.md` + `art/` own visual language; `ASSET_SPEC.md`/`ASSET_PIPELINE.md` own technical asset production constraints.
6. **Validation/fixtures:** prove that canonical contracts are sufficient; they do not become scene-specific APIs.
7. **Brainstorming/handoffs:** historical evidence only unless a decision is explicitly promoted into a canonical owner document.

If implementation evidence invalidates a canonical rule, update the owning canonical document rather than adding another permanent override file.

---

# 9. Documentation growth policy

To prevent renewed fragmentation:

- do **not** create a new top-level canonical document for every fixture, content family or discovered edge case;
- extend the existing owning document when the concern fits an established authority;
- place scenario evidence in a validation/fixture artifact, not in a competing specification;
- use `asset-catalog/` for cross-cutting modeled-content requirements and production status;
- use `brainstorming/` only for exploratory breadth that is not yet canonical;
- use `handoffs/` for transition instructions, not durable design ownership;
- when a refinement permanently supersedes an older contract, consolidate it into the older contract when practical rather than maintaining an indefinite precedence chain.

A future mechanical cleanup may move existing validation files into a dedicated subdirectory. Do that only as an atomic link-update refactor; their current root location does not make them canonical required reading.
