# Visual Production Support Pack

This directory turns the project visual direction into operational guidance for humans and autonomous 3D agents.

It does **not** replace the canonical contracts in:

- `../VISUAL_GUIDE.md` — visual source of truth;
- `../ASSET_SPEC.md` — runtime asset contract;
- `../ASSET_PIPELINE.md` — Blender/export workflow.

The files here reduce aesthetic ambiguity and provide repeatable production guidance.

## Locked baseline

The current approved direction is:

> A colorful tropical miniature diorama with an orthographic 3/4 gameplay camera, intentionally aggressive low-poly environment geometry, broad readable silhouettes, restrained surface detail, and a softer caricatured Wilson who remains visually distinct from the more faceted world.

The environment should be easy to recreate through procedural Blender generators and simple manual modeling. Complexity should come from composition, state changes, modularity and lighting rather than dense geometry or texture work.

Common assets should default to **shared flat-color materials with no unique texture maps**. Decals, low-frequency shared noise and special shaders are exceptions for semantic markings, state communication or object-specific functionality.

## Core direction documents

- [`ART_DIRECTION.md`](ART_DIRECTION.md) — overall visual target and decision rules.
- [`SHAPE_LANGUAGE.md`](SHAPE_LANGUAGE.md) — geometry and silhouette grammar.
- [`PALETTE_AND_MATERIALS.md`](PALETTE_AND_MATERIALS.md) — palette roles and material strategy.
- [`SCALE_CAMERA_AND_READABILITY.md`](SCALE_CAMERA_AND_READABILITY.md) — scale, camera and gameplay-readability rules.
- [`ASSET_FAMILIES.md`](ASSET_FAMILIES.md) — asset-family taxonomy derived from functional requirements and representative scenes.

## Reference pack

Textual reference specifications live in [`reference/`](reference/), with approved visual sheets in `reference/visual/` when available.

The current reference sequence is:

1. Shape Grammar
2. Natural Island Vocabulary
3. Camp Primitive Props
4. Materials, Lighting & Performance
5. Tool Grammar
6. Shelter Evolution
7. Salvage & Repurposing
8. Weather & Damage
9. Wilson Scale & Interaction
10. Storage & Containers
11. Workstations & Utilities
12. Transport, Raft & Dock

These references define family languages and should be preferred over inventing asset-specific style rules.

## Agent production workflow

Use these documents when assigning 3D work to an autonomous modeling agent:

- [`AGENT_MODELING_WORKFLOW.md`](AGENT_MODELING_WORKFLOW.md) — artistic creation, iteration and independent-review loop;
- [`CANONICAL_ASSET_PREVIEWS.md`](CANONICAL_ASSET_PREVIEWS.md) — standard front/side/top/gameplay/silhouette/scale preview package;
- [`VISUAL_REVIEW_RUBRIC.md`](VISUAL_REVIEW_RUBRIC.md) — creator and independent-review scoring criteria;
- [`ASSET_BRIEF_TEMPLATE.md`](ASSET_BRIEF_TEMPLATE.md) — compact grammar/family/asset-specific task specification.

The default artistic loop is:

```text
read brief + references
→ block out
→ apply family grammar
→ apply flat material blocks
→ render canonical previews
→ creator visual review
→ focused revision
→ independent subagent review
→ final correction
→ artistic acceptance
```

## Brief strategy

Do not write a large bespoke instruction document for every prop.

Use:

- **grammar-only tasks** for trivial variants fully defined by an approved grammar;
- **family briefs** for reusable families such as rocks, palms, seating, containers and tool parts;
- **asset-specific briefs** for high-risk or strongly stateful assets such as shelter, raft, dock, rare salvage and Wilson.

The brainstorming catalog is upstream design evidence, not the immediate modeling prompt.

## Production principle

Aim for **maximum systemic variety inside a narrow visual grammar**.

Agents may vary proportion, lean, part selection, seed, state and palette within documented bounds. They should not invent a new rendering style, topology language, material philosophy or proportion system per asset.

The canonical gameplay camera is authoritative. A close-up render cannot rescue an asset that is unreadable in normal gameplay.

## Remaining art-block work

The art direction itself is now substantially specified. Remaining work is production-oriented rather than exploratory:

1. ensure all approved visual reference PNGs are present in `reference/visual/`;
2. calibrate exact shared palette/material values in a real preview scene;
3. calibrate the final gameplay camera and update canonical preview values if needed;
4. create the first production family briefs and high-risk asset briefs just before modeling batches;
5. validate the workflow on a small representative batch and refine the rubric only if repeated problems emerge;
6. build the golden scene from approved production assets rather than concept-only imagery.
