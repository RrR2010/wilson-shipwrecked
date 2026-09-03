# Blender Prototyping Guide

## Scope

Use this guide for **simple 3D geometry built to support Godot smoke/integration tests**. Production assets follow `../../ASSET_SPEC.md`, `../../ASSET_PIPELINE.md` and art direction in addition to any relevant rules here.

The objective is deterministic, dimensionally useful geometry — not attractive placeholder art.

## Coordinate and unit convention

- Work in metric units.
- Treat 1 Blender unit as 1 meter.
- Z is up.
- Keep object dimensions numerically intentional; do not eyeball test-critical sizes.
- Use the smoke-test scene spec as authority for placement/orientation.

Do not invent a global forward-axis convention for an asset unless the smoke test or production Asset Spec requires one. glTF/Godot import conversion must be validated at the integration boundary rather than assumed from viewport appearance.

## Modeling rules

Prefer built-in primitives:

- capsule/cylinder for actor placeholders;
- plane or low-resolution grid for terrain;
- cube for crates, walls and obstacles;
- sphere/icosphere for markers or round objects.

Keep topology minimal. Bevels, subdivisions, sculpting, Geometry Nodes, textures and decorative geometry are forbidden unless a test explicitly needs them.

For terrain distortion, use deterministic numeric deformation. Record dimensions, subdivision and maximum vertical displacement in the smoke-test Asset Spec.

## Transforms

Before export:

- set intended physical dimensions numerically;
- establish the object's canonical local orientation;
- apply scale;
- apply rotation when the asset's local orientation is final;
- normally **do not apply location** merely to make transforms look clean;
- final exported object scale should normally be `(1, 1, 1)`;
- avoid negative scale and mirrored transforms in smoke assets.

If applying rotation would destroy an intentional semantic orientation required by the scene contract, stop and report the conflict instead of guessing.

## Origins

Origins are part of the integration contract.

Default prototype rules:

- actor/character placeholder: horizontally centered at ground contact;
- freestanding prop: bottom-center;
- wall/obstacle: geometric center unless placement requires ground-contact origin;
- terrain: documented stable reference, normally scene/world origin;
- marker: geometric center unless explicitly ground-anchored.

Do not move geometry relative to its origin after validating the pivot without rechecking dimensions and placement.

## Naming

Use semantic names, not Blender defaults.

Recommended prefixes:

```text
GEO_<name>   visible prototype geometry
MAT_<name>   material
ANC_<name>   explicit semantic anchor when required
SCN_<name>   top-level collection/scene grouping when useful
```

Collision primitives for these early smoke tests are normally owned by Godot and should **not** be authored as Blender collision meshes unless the smoke spec explicitly requests them.

## Materials

Use simple Principled BSDF materials:

- one flat Base Color per semantic category;
- Roughness may remain at a simple neutral value;
- Metallic = 0 unless the test specifically distinguishes metal;
- no image textures;
- no procedural texture networks;
- no transparency unless required by the test.

Colors are diagnostic labels, not art-direction decisions. Prefer clearly distinguishable colors over aesthetic palettes.

## Scene hygiene

Before saving/exporting:

- delete unused default objects unless explicitly needed;
- remove accidental duplicate geometry;
- remove unused prototype materials when practical;
- ensure hidden objects are not accidentally exported;
- keep cameras/lights out of per-asset exports unless requested;
- avoid dependencies on active selection, active object or unexplained collection state.

## Export

Default runtime format is GLB/glTF 2.0.

For smoke assets:

- export only intended objects;
- preserve semantic object names;
- do not export Blender-only cameras/lights unless specified;
- prefer one GLB per independently consumed prototype asset unless the scene spec deliberately requests a scene-level GLB;
- re-open or re-import the export when tooling permits;
- verify dimensions/orientation in Godot rather than assuming exporter conversion is correct.

## Blender vs Godot ownership

For early engine smoke tests, Blender owns:

- visible geometry;
- dimensions;
- local origin/pivot;
- simple diagnostic material;
- GLB export.

Godot owns:

- `CharacterBody3D`, `StaticBody3D`, `Area3D` and similar runtime bodies;
- primitive `CollisionShape3D` resources;
- navigation regions/agents;
- perception sensor volumes;
- raycasts/physics queries;
- authoritative runtime/domain identity mapping.

This separation is intentional: do not test imported collision generation at the same time as movement/navigation/perception unless that is the test subject.

## Required validation checklist

Before reporting completion:

```text
[ ] only requested objects exist/export
[ ] semantic names match the spec
[ ] dimensions checked numerically
[ ] origin/pivot checked
[ ] scale is normally 1,1,1
[ ] canonical rotation checked/applied as specified
[ ] no accidental negative scale
[ ] material names and diagnostic colors checked
[ ] no accidental cameras/lights/hidden geometry in export
[ ] GLB export completed
[ ] exported artifact was re-inspected/re-imported when tooling allows
[ ] every deviation from the smoke spec is reported
```

A successful export message alone is not validation.