# 3D Asset Repository Layout

This directory separates editable authoring sources from Godot runtime-imported models.

## Canonical format ownership

```text
.blend = editable/manual Blender source
.py    = reproducible bpy generator source
.glb   = canonical 3D interchange/runtime model imported by Godot
.tscn  = optional Godot integration wrapper when engine-specific nodes/resources are needed
```

Direct `.blend` import in Godot is allowed for local experimentation, but it is not the project runtime contract. Runtime model assets should be committed as `.glb` under `assets/models/`.

## Source organization

Default source layout is **one `.blend` per asset**.

Use semantic paths that mirror the runtime asset ID and family, for example:

```text
assets/source/props/stone_small_01.blend
assets/source/props/branch_small_01.blend
assets/source/props/flat_rock_01.blend
```

This makes it obvious which asset lives in which source file and keeps review/export scripts token-efficient. Shared multi-asset `.blend` files should be the exception, not the default.

## Directory contract

```text
assets/
├── source/       editable manual .blend sources; ignored by Godot via .gdignore
├── generators/   bpy generators/toolkit; ignored by Godot via .gdignore
├── generated/    reproducible intermediates when needed; ignored by Godot via .gdignore
├── previews/     review renders; ignored by Godot via .gdignore
└── models/       runtime-ready .glb assets imported by Godot
```

Use semantic subfolders as production requires them, normally:

```text
characters/
environment/
props/
structures/
```

Do not create empty taxonomy folders merely for ceremony; create them when the first asset in that category exists.

## Godot boundary

Only files intended for Godot import should live under `assets/models/`.

The `.gdignore` files in authoring/intermediate directories prevent Godot from importing, showing, or exporting those directories as `res://` resources.

Godot-generated `.import` metadata beside runtime assets is version-controlled. The generated `.godot/` cache remains ignored.

## Typical asset flow

```text
catalog row
→ Blender source or bpy generator
→ canonical artistic previews/review
→ deterministic GLB export
→ Godot import verification
→ optional .tscn integration wrapper
→ catalog status update
```

See `docs/ASSET_SPEC.md`, `docs/ASSET_PIPELINE.md`, `docs/art/AGENT_ART_PRODUCTION.md`, and `docs/asset-catalog/` for the full contracts.
