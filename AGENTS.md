# AGENTS.md

## Mission

Build Wilson Shipwrecked as a coherent systemic simulation and living 3D diorama. Optimize for reusable rules and modular assets, not maximum feature/content count.

## Required reading

Before substantial work, read the documents relevant to the task:

- `README.md` — project thesis and milestone;
- `docs/PRODUCT.md` — experience and gameplay intent;
- `docs/ARCHITECTURE.md` — technical boundaries;
- `docs/SIMULATION.md` — systemic/procedural model;
- `docs/VISUAL_GUIDE.md` — mandatory for visual/3D work;
- `docs/ASSET_SPEC.md` — mandatory for asset creation/integration;
- `docs/ASSET_PIPELINE.md` — mandatory for Blender/tooling work;
- `docs/AI.md` — mandatory for runtime LLM work.

A more local `AGENTS.md` may add or override instructions for its subtree. Explicit task/spec requirements override generic workflow preferences, but architectural invariants should only be changed deliberately and documented.

## General engineering rules

1. Keep authoritative simulation independent from rendering.
2. Prefer composition/data-driven capabilities over concrete-type branching.
3. Route world mutations through validated domain actions.
4. Keep randomness seeded and reproducible.
5. Do not couple game correctness to LLM availability.
6. Prefer a reusable primitive over multiple bespoke cases when the abstraction is genuine.
7. Avoid premature frameworks/generalization: implement the smallest reusable concept proven by current use cases.
8. Add tests for domain rules and regressions.
9. Preserve debuggability: autonomous decisions must be explainable through observable scores, preconditions and event logs.
10. Keep code/comments/docs in English.

## Godot work

- Treat Godot nodes as presentation/application adapters, not authoritative domain entities.
- Map stable domain entity IDs to scene instances explicitly.
- Query affordances from the simulation; do not duplicate legality rules in UI scripts.
- Prefer semantic animation/action names over asset-specific ones.
- Do not hardcode per-object interaction offsets when an anchor can express them.
- Keep web-export constraints in mind; measure before introducing expensive rendering features.

## Simulation work

When adding behavior, ask in this order:

1. Is this an existing action applied to a new compatible property?
2. Is one new reusable property/action enough?
3. Can an event template express it parametrically?
4. Does it genuinely require a bespoke event?

A large `if entity_type == ...` chain is usually a design smell.

## Runtime AI work

- LLM output is proposal/interpretation, never authority.
- Use structured outputs and strict validation.
- Resolve generated identifiers against registries.
- Persist accepted resolved proposals when they affect future state.
- Provide deterministic fallbacks.
- Never expose private provider keys in a public web client.

## 3D / Blender agent rules

Before creating or changing an asset, read `docs/VISUAL_GUIDE.md`, `docs/ASSET_SPEC.md` and `docs/ASSET_PIPELINE.md`.

### Preferred method

For repeatable props/environment families:

```text
inspect existing toolkit
 -> write/reuse bpy generator
 -> execute Blender
 -> validate structure
 -> render canonical gameplay preview
 -> inspect actual render
 -> iterate
 -> export GLB
 -> verify integration
```

Prefer code-driven reproducibility to long sequences of Blender UI/MCP micro-operations.

### Visual iteration

- Inspect the rendered result; code correctness is not visual correctness.
- Evaluate at gameplay camera distance.
- Use at most a small bounded number of autonomous aesthetic iterations unless the task says otherwise.
- If the remaining choice is subjective art direction rather than a defect, surface alternatives instead of silently redefining the style.

### Asset generation

- Reuse shared primitives/materials.
- Use deterministic seeds for procedural variants.
- Preserve required anchors/sockets across variants.
- Keep geometry simple.
- Do not add texture detail to compensate for weak silhouettes.
- Do not create unique animations when a generic action + semantic anchor solves the interaction.
- Never modify Wilson's core identity/design as incidental work on another asset.

### Blender scene hygiene

- Scripts must not rely on active selection unless selection is explicitly set inside the script.
- Own and clean only generated collections/objects belonging to the task.
- Use stable names.
- Keep units/transforms/export orientation consistent with the asset spec.
- Do not leave temporary cameras/lights/helpers mixed into runtime asset roots.

## Generated assets and source control

Do not commit temporary previews, backups or experimentation debris. Commit source/generators and runtime outputs according to `ASSET_PIPELINE.md` and actual build requirements.

## Definition of done

### Code change

- behavior matches product/architecture intent;
- relevant tests pass;
- no new hidden coupling between simulation and presentation;
- deterministic behavior remains reproducible where applicable;
- docs updated if a contract changed.

### 3D asset change

- visual guide followed;
- asset spec validated;
- canonical preview inspected;
- semantic anchors/sockets correct;
- GLB/Godot integration verified when applicable;
- no bespoke coordinate workaround introduced.

## Architectural change protocol

Documentation describes current intended contracts, not immutable law. If implementation evidence shows a contract is wrong:

1. identify the conflict explicitly;
2. explain the tradeoff;
3. change the relevant design document in the same change;
4. update affected tests/tools/assets;
5. avoid quietly implementing a contradictory second architecture.

## Priority

When tradeoffs conflict, optimize in this order:

1. coherent player experience;
2. simulation correctness and persistence safety;
3. systemic reuse/combinatorial value;
4. visual coherence/readability;
5. developer/agent reproducibility;
6. raw content quantity.
