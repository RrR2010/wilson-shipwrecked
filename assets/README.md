# 3D Asset Repository Layout

This directory separates editable authoring sources from Godot runtime-imported models.

## Canonical format ownership

```text
.blend = editable/manual Blender source when Blender file is the canonical authoring unit
.py    = reproducible bpy generator/toolkit source
.glb   = canonical 3D interchange/runtime model imported by Godot
.tscn  = optional Godot integration wrapper when engine-specific nodes/resources are needed
```

Direct `.blend` import in Godot is allowed for local experimentation, but it is not the project runtime contract. Runtime model assets are committed as `.glb` under `assets/models/`.

---

# Source ownership

Do **not** interpret "one `.blend` per asset" as a universal rule.

Choose the source unit according to the asset's editing lifecycle.

## Independent manually authored asset

Default:

```text
one asset
→ one .blend
```

Use when the model is edited independently and isolation makes origin/review/export safer.

Example:

```text
assets/source/props/containers/crate_wood_01.blend
assets/models/props/containers/crate_wood_01.glb
```

## Tightly related authored variants/family

Use one family `.blend` when multiple exported assets genuinely share:

- rig/topology;
- modular pieces;
- lifecycle stages;
- common authored base geometry;
- coordinated editing.

Example:

```text
assets/source/characters/crabs/crab_family.blend

collections:
  ASSET_crab_generic
  ASSET_crab_recurring

exports:
  assets/models/characters/crabs/crab_generic.glb
  assets/models/characters/crabs/crab_recurring.glb
```

Do not collect unrelated assets in a family `.blend` merely to reduce file count.

## Procedural family

For procedural content, generator/configuration is the canonical source:

```text
assets/generators/<category>/...
+ deterministic seed/parameters
→ generated asset
→ GLB
```

Do not commit one generated `.blend` for every procedural variant.

A single optional family/workbench `.blend` is useful when it helps:

- compare variants;
- tune parameters/materials;
- debug generator output;
- inspect family scale/style together.

Example:

```text
assets/generators/environment/rocks/generate_rocks.py
assets/source/environment/rocks/rocks_workbench.blend   # optional
assets/models/environment/rocks/rock_medium_01.glb
assets/models/environment/rocks/rock_medium_02.glb
```

Rule of thumb:

```text
independent manual identity
→ one blend per asset

authored siblings share real editing context
→ one blend per family

reproducible from code + bounded parameters
→ generator is source; optional one family workbench blend
```

---

# Directory contract

```text
assets/
├── source/       manual/family .blend authoring sources; .gdignore
├── generators/   bpy generators/toolkit; .gdignore
├── generated/    reproducible intermediates when needed; .gdignore
├── previews/     non-authoritative review renders; .gdignore
└── models/       runtime-ready .glb assets imported by Godot
```

Use semantic subfolders as production requires them. The top-level production categories are:

```text
characters/
environment/
props/
structures/
```

Nested categories are encouraged when useful:

```text
props/containers/
props/tools/
environment/rocks/
environment/vegetation/
structures/shelter/
characters/crabs/
```

Do not create folder synonyms such as:

```text
items/
objects/
misc/
game_props/
```

when an existing category already expresses the asset.

---

# Asset scope convention

A `.blend` may contain one asset or several family variants, so file isolation is not the export boundary.

The explicit export/review boundary is the **asset scope**.

Preferred for composites, family files and generator outputs:

```text
Collection: ASSET_<asset_id>
```

That collection should contain every runtime member of the exported asset, including required `ANCHOR_*` / `SOCKET_*` nodes.

A trivial single-object asset may use a named object/hierarchy directly.

See `tools/blender/README.md` for scope resolution and profiles.

---

# Godot boundary

Only files intended for Godot import should live under `assets/models/`.

The `.gdignore` files in authoring/intermediate directories prevent Godot from importing/showing/exporting those directories as `res://` resources.

Godot-generated `.import` metadata beside runtime assets is version-controlled. The generated `.godot/` cache remains ignored.

---

# Typical asset flow

```text
catalog row
→ choose source ownership: asset | family | generator
→ model/generate named AssetScope
→ canonical artistic review
→ structural validation
→ deterministic GLB export
→ Godot import verification
→ optional .tscn integration wrapper
→ catalog status update
```

See:

- `docs/ASSET_SPEC.md`
- `docs/ASSET_PIPELINE.md`
- `docs/art/AGENT_ART_PRODUCTION.md`
- `docs/asset-catalog/`
- `tools/blender/README.md`
