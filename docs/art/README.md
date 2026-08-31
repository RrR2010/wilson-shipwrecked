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

## Documents

- [`ART_DIRECTION.md`](ART_DIRECTION.md) — overall visual target and decision rules.
- [`SHAPE_LANGUAGE.md`](SHAPE_LANGUAGE.md) — geometry and silhouette grammar.
- [`PALETTE_AND_MATERIALS.md`](PALETTE_AND_MATERIALS.md) — palette roles and material strategy.
- [`SCALE_CAMERA_AND_READABILITY.md`](SCALE_CAMERA_AND_READABILITY.md) — scale, camera and gameplay-readability rules.
- [`ASSET_FAMILIES.md`](ASSET_FAMILIES.md) — initial asset-family taxonomy derived from the milestone and representative scenes.

## Production principle

Aim for **maximum systemic variety inside a narrow visual grammar**.

Agents may vary proportion, lean, part selection, seed, state and palette within documented bounds. They should not invent a new rendering style, topology language, material philosophy or proportion system per asset.

## Next pack layers

The following should be added after visual review:

1. approved golden reference renders;
2. reference sheets for vegetation, rocks, structures and common props;
3. Wilson character concept sheet;
4. material swatch sheet;
5. asset-family briefs with required states, anchors and variants;
6. canonical Blender/Godot preview scene.
