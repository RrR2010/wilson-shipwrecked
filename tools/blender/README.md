# Blender Production Tools

## Purpose

`tools/blender/` provides deterministic production-asset review, validation and GLB export.

It does **not** decide what to model or whether the art is good. Use:

```text
docs/asset-catalog/                asset requirements
docs/art/AGENT_ART_PRODUCTION.md   visual loop/review
docs/ASSET_SPEC.md                 invariants
this file                           script usage
```

Production automation is pinned to **Blender 5.2 LTS**. Another major/minor series fails unless explicitly overridden.

---

# Normal loop

```text
model/generate
→ review_asset.py
→ inspect images / refine
→ validate_asset.py
→ export_asset.py
→ Godot import check
```

Review/export must not mutate the authored asset to make it pass.

---

# Source ownership

Choose one:

## `asset`

Independent manual asset:

```text
one asset → one .blend
```

Default because it isolates origin, transforms, review and export.

## `family`

Several authored outputs share real editing context:

- same rig/base topology;
- modular kit;
- lifecycle stages;
- tightly coordinated variants.

Use one family `.blend`, but a separate AssetScope/GLB per exported asset.

## `generator`

Procedural/reproducible family:

```text
generator + config/parameters + explicit seed → AssetScope → GLB
```

Do not save one canonical `.blend` per generated variant. An optional family workbench `.blend` is fine for comparison/debugging.

---

# AssetScope

Scripts operate on an explicit scope, not accidental selection.

Supported:

```text
object
hierarchy
collection
auto
```

Preferred for composite/family/generated assets:

```text
Collection: ASSET_<asset_id>
```

Include every runtime member that must export:

- meshes;
- armature when applicable;
- `ANCHOR_*` / `SOCKET_*` nodes;
- required runtime children.

Every AssetScope has exactly one canonical top-level root. The root must have world location `(0,0,0)`, identity rotation and scale `(1,1,1)`.

Global authored axes:

```text
+Y = forward/front
+X = right
+Z = up
```

Do not redefine forward per family. Assets with weak/symmetric front semantics still use a stable family orientation.

The canonical modeled/reviewed loose or installed pose must also be physically plausible; review framing is not a reason to stand a loose branch vertically.

---

# `review_asset.py`

Creates deterministic EEVEE review renders under:

```text
temp/blender-review/<asset_id>/iter_XX/
```

Outputs normally include:

```text
<asset_id>_gameplay.png
<asset_id>_silhouette.png
<asset_id>_scale.png
<asset_id>_front.png
<asset_id>_side.png
<asset_id>_top.png
<asset_id>_review_sheet.png
<asset_id>_review_manifest.json
```

It also updates:

```text
temp/blender-review/index.json
temp/blender-review/index.html
```

Canonical camera uses orthographic gameplay ~45° azimuth / ~35° elevation. `front` looks from +Y toward the origin.

## Review profiles

```text
grounded   ordinary props/tools/vegetation/structures
character  Wilson and rigged animals
isolated   floating/hanging/exploded diagnostics
terrain    terrain/ground assets
```

Ground exists only when it helps evaluate physical support/contact.

Native Blender Material Preview may be used interactively, but canonical review is EEVEE scene rendering so results do not depend on viewport/HDRI state.

Example:

```text
review_asset.py --
  --asset-id crate_wood_01
  --scope-kind collection
  --scope-name ASSET_crate_wood_01
  --profile grounded
```

The artistic review criteria and `vs` fallback delegation prompt live in `docs/art/AGENT_ART_PRODUCTION.md`.

---

# `validate_asset.py`

Run before final export.

Example:

```text
validate_asset.py --
  --asset-id crate_wood_01
  --scope-kind collection
  --scope-name ASSET_crate_wood_01
  --profile static
  --category props/containers
```

Validation checks mechanical conditions such as:

- supported Blender series;
- scope resolution;
- renderable geometry;
- exactly one canonical root;
- root transform identity;
- no negative scale;
- no accidental camera/light/speaker in runtime scope;
- no leaked `__review_*` helpers;
- suspicious duplicate semantic nodes;
- profile compatibility with armatures/shape keys/modifiers.

Validation reports errors. It does not repair source geometry/transforms.

Visual/semantic checks such as relative size, plausible physical rest pose and visual reference alignment remain part of image review rather than pretending they can be proven mechanically.

---

# `export_asset.py`

Exports the validated scope non-destructively to:

```text
assets/models/<category>/<asset_id>.glb
```

It temporarily selects scope members, exports, restores selection and writes provenance under:

```text
temp/blender-export/<asset_id>/
```

It must not purge the scene, move geometry, normalize a bad root or delete family siblings.

## Export profiles

### `static`

Use for ordinary props, structures, terrain and evaluated procedural output.

```text
animations: off
skins: off
morphs: forbidden
modifiers: evaluated/applied
```

### `deformable`

Use for non-armature shape-key/morph content.

```text
animations: on
skins: off
morphs: on
modifiers: not force-applied
```

### `rigged`

Use for Wilson and rigged animals.

```text
animations: on
skins: on
morphs: on
exactly one armature required
modifiers: not force-applied except the normal armature relationship
```

## Independent manual asset

```text
export_asset.py --
  --asset-id crate_wood_01
  --scope-kind collection
  --scope-name ASSET_crate_wood_01
  --profile static
  --category props/containers
  --source-mode asset
```

## Authored family

```text
export_asset.py --
  --asset-id crab_generic
  --scope-kind collection
  --scope-name ASSET_crab_generic
  --profile rigged
  --category characters/crabs
  --source-mode family
  --source-id crab_family
```

## Procedural output

```text
export_asset.py --
  --asset-id rock_medium_03
  --scope-kind collection
  --scope-name ASSET_rock_medium_03
  --profile static
  --category environment/rocks
  --source-mode generator
  --generator-source assets/generators/environment/rocks/generate_rocks.py
  --generator-config assets/generators/environment/rocks/rock_medium.json
  --generator-seed 3
```

For generator mode, explicit seed is required. Use seed `0` when randomness is intentionally disabled.

The export manifest records repository-relative source/config paths and GLB SHA-256.

---

# Review environment

Canonical review lighting is deliberately neutral:

```text
one directed SUN key
+ one broad AREA fill
+ fixed neutral world/background
+ ground/contact shadow where profile requires it
+ subtle rim only for character profile
```

This is not a cinematic three-point studio setup. It should expose silhouette, planar form, scale and grounding rather than beautify a weak asset.

---

# Agent behavior

The agent should not ask where to save an ordinary asset when repository contracts determine it.

It should:

1. use the nearest existing semantic category path;
2. choose `asset`, `family` or `generator` source ownership;
3. use a stable named AssetScope;
4. keep `+Y/+X/+Z` global orientation;
5. keep the canonical loose/installed pose physically plausible;
6. choose the smallest correct review/export profile;
7. inspect canonical renders and refine before export;
8. report a contract conflict rather than invent a workaround.

Do not create folder synonyms such as `items/`, `objects/`, `misc/` or `game_props/` when an existing category fits.
