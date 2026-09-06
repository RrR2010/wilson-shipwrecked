# 3D Asset Repository Layout

This directory separates editable authoring sources from Godot runtime-imported models.

## Canonical format ownership

```text
.blend = editable Blender source when Blender owns the authored asset/family
.py    = reproducible bpy generator/toolkit source
.glb   = canonical 3D interchange/runtime model imported by Godot
.tscn  = optional Godot integration wrapper for engine-specific composition
```

Direct `.blend` import is acceptable for local experiments; runtime model assets are committed as `.glb` under `assets/models/`.

---

# Source ownership

Do **not** treat "one `.blend` per asset" as universal. Choose the source unit by editing lifecycle.

## Independent manual asset

Default when the model is edited independently and file isolation makes pivot/review/export safer:

```text
one independent asset → one .blend
```

Example:

```text
assets/source/props/containers/crate_wood_01.blend
assets/models/props/containers/crate_wood_01.glb
```

## Tightly related authored family

Use one family `.blend` only when outputs genuinely share authored context:

- rig/topology;
- modular pieces;
- lifecycle stages;
- common base geometry;
- coordinated editing.

Example:

```text
assets/source/characters/crabs/crab_family.blend

ASSET_crab_generic
ASSET_crab_recurring

→ assets/models/characters/crabs/crab_generic.glb
→ assets/models/characters/crabs/crab_recurring.glb
```

Do not collect unrelated assets in a family file merely to reduce file count.

Because every exported AssetScope keeps its canonical root at the origin, do **not** move production roots merely to lay variants side-by-side. For family comparison use either:

```text
separate canonical asset scenes inside the same .blend
```

or:

```text
one non-export WORKBENCH scene
+ linked/instanced display copies placed side-by-side
```

The workbench is presentation/debug layout only. Export scopes keep canonical transforms.

## Procedural family

For procedural content, canonical source is:

```text
generator
+ optional committed config/parameters
+ explicit deterministic seed
→ generated AssetScope
→ GLB
```

Do not commit one generated `.blend` for every procedural variant.

A single optional family/workbench `.blend` is useful only when it helps compare variants, tune materials/parameters or debug the generator.

Example:

```text
assets/generators/environment/rocks/generate_rocks.py
assets/generators/environment/rocks/medium.json
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
├── generators/   bpy generators/config/toolkit; .gdignore
├── generated/    reproducible intermediates when needed; .gdignore + gitignored
├── previews/     non-authoritative review renders; .gdignore + normally gitignored
└── models/       runtime-ready .glb assets imported by Godot
```

Top-level production categories are constrained to:

```text
characters/
environment/
props/
structures/
```

Use nested semantic paths when helpful:

```text
props/containers/
props/tools/
environment/rocks/
environment/vegetation/
structures/shelter/
characters/crabs/
```

Do not create synonyms such as `items/`, `objects/`, `misc/` or `game_props/` when an existing category already expresses the asset.

---

# AssetScope and root convention

A `.blend` may contain one asset or several family variants, so file isolation is not the export boundary.

The explicit review/export boundary is the **AssetScope**.

Preferred for composites, family files and generated outputs:

```text
Collection: ASSET_<asset_id>
```

The collection contains every runtime member, including required `ANCHOR_*` / `SOCKET_*` nodes and armature where applicable.

Every AssetScope also has **exactly one top-level root**:

```text
simple prop
→ mesh itself may be root

composite
→ one identity Empty/root
→ all runtime meshes/anchors/sockets parented below it

rigged asset
→ armature may be root or live under one identity root
→ still exactly one top-level root
```

Root world transform is canonical:

```text
location = (0, 0, 0)
rotation = identity
scale    = (1, 1, 1)
```

Collection defines **membership**. Root defines **pivot/transform**.

A trivial single-object asset may use a named object/hierarchy directly when no required child would be omitted.

See `tools/blender/README.md` for resolution, review profiles and export profiles.

---

# Godot boundary

Only files intended for Godot import should live under `assets/models/`.

The `.gdignore` files in authoring/intermediate directories prevent Godot from importing/showing/exporting those directories as `res://` resources.

Godot-generated `.import` metadata beside runtime assets is version-controlled. `.godot/` remains ignored.

---

# Typical asset flow

```text
catalog row
→ choose source ownership: asset | family | generator
→ model/generate named AssetScope with one canonical root
→ canonical artistic review
→ structural validation
→ deterministic profile-based GLB export
→ provenance/hash manifest under temp/
→ Godot import verification
→ optional .tscn wrapper
→ catalog status update
```

See:

- `docs/ASSET_SPEC.md`
- `docs/ASSET_PIPELINE.md`
- `docs/art/AGENT_ART_PRODUCTION.md`
- `docs/asset-catalog/`
- `tools/blender/README.md`
