# Blender Production Tools

## Purpose

`tools/blender/` is the operational layer for deterministic production-asset review, validation and GLB export.

It is deliberately narrower than the art direction and asset catalog:

```text
asset catalog / art contracts
→ agent models or generates the asset
→ tools/blender validates/reviews/exports it
→ Godot import validation
```

These scripts are expected to run from the current Blender session through MCP, the Text Editor, or Blender CLI. They must not silently redesign or repair production art.

## Supported Blender version

Production automation is pinned to:

```text
Blender 5.2 LTS
```

Use the latest 5.2.x patch available to the team. The scripts fail on another major/minor series unless `--allow-unsupported-blender true` is explicitly supplied.

This pin is intentional. Blender Python and glTF-exporter APIs change between releases; reproducibility is more valuable than opportunistically supporting every installed version.

## Core invariant: review/export must not mutate the authored asset

`review_asset.py` renders from a temporary review scene that links the source objects read-only.

`export_asset.py`:

- never deletes non-target scene objects;
- never moves geometry to repair an origin;
- never applies transforms to repair a source file;
- never strips the live scene;
- preserves selection state;
- fails validation when a production invariant must be corrected in source.

A source `.blend` copy may be written, but saving a copy is not permission to alter the live asset before export.

---

# 1. Source ownership: when to use each approach

Do **not** force one `.blend` per exported GLB in every case.

Choose the source unit according to how the content is authored.

## `source-mode=asset` — one `.blend` per asset

Default for independently authored manual assets.

Use when the model has an independent editing lifecycle and there is little value in keeping sibling variants together.

Good examples:

```text
crate_wood_01
sealed_metal_container_01
bowling_ball_rare
umbrella_found
hero salvage prop
```

Canonical source:

```text
assets/source/<category>/<asset_id>.blend
```

This mode is intentionally easy for agents: opening the file isolates origin, review, validation and export.

## `source-mode=family` — one `.blend` for a tightly related authored family

Use when several exported assets share substantial authored structure and should evolve together.

Typical reasons:

- shared rig;
- shared topology/base mesh;
- modular pieces;
- lifecycle stages edited together;
- deliberately coordinated variants;
- several export scopes inside one source file.

Good examples:

```text
crab_family.blend
shelter_family.blend
tool_component_kit.blend
```

Each runtime asset still receives its own scope and GLB:

```text
ASSET_crab_generic
ASSET_crab_recurring

→ animal/crab_generic.glb
→ animal/crab_recurring.glb
```

Do not use a family file merely to collect unrelated props.

## `source-mode=generator` — generator/config is canonical source

Preferred for procedural families and large bounded variant sets.

Good examples:

```text
rocks
branches/logs
palm variants
bounded debris clusters
simple modular construction pieces
```

Canonical source:

```text
assets/generators/<category>/...
+ deterministic seed/config
```

The generated `.blend` is normally a debugging/workbench artifact, **not** one committed `.blend` per generated variant.

A single optional family/workbench `.blend` may exist when useful for:

- visually comparing generated siblings;
- tuning parameters/materials;
- debugging the generator;
- preserving a deliberate family composition.

Do not create:

```text
rock_001.blend
rock_002.blend
...
rock_087.blend
```

when all of those meshes are reproducible from one generator and bounded parameter set.

### Rule of thumb

```text
independent manual identity
→ one blend per asset

several authored siblings share real editing context
→ one blend per family

mesh is reproducible from code + parameters
→ generator is source; optional one family workbench blend
```

---

# 2. Asset scope

The exporter/reviewer operates on an `AssetScope`, not implicitly on "whatever is selected".

Supported scope kinds:

```text
object
hierarchy
collection
auto
```

## Recommended convention

For composite assets and generator output, create:

```text
Collection: ASSET_<asset_id>
```

and place every runtime member inside it:

- render meshes;
- armature when applicable;
- `ANCHOR_*` empties;
- `SOCKET_*` empties;
- other runtime child nodes that must survive glTF export.

Example:

```text
ASSET_crate_wood_01/
├── crate_body
├── crate_lid
├── ANCHOR_APPROACH
├── ANCHOR_PICKUP
└── SOCKET_ATTACHMENT_01
```

`auto` resolution prefers `ASSET_<asset_id>`, then a hierarchy root named `<asset_id>`. Active-object fallback exists for interactive convenience and emits a warning; production commands should use a stable named scope.

Use `scope-kind=object` only for a genuinely single-object runtime asset with no children/anchors that need export.

---

# 3. Review profiles

Review profiles change only neutral presentation setup. They never alter the asset.

## `grounded`

Default for:

- props;
- tools;
- containers;
- furniture;
- palms/rocks;
- structures that stand on terrain.

Includes a neutral ground plane and contact shadow.

## `character`

For Wilson and rigged animals.

Same neutral grounding, plus a restrained rim light to separate the softer character silhouette without turning the review into a hero render.

## `isolated`

For assets whose contact with a floor is not meaningful:

- hanging pieces;
- suspended attachments;
- floating components;
- selected exploded diagnostics.

No artificial ground plane.

## `terrain`

For terrain/island/ground patches that already define their own support surface.

Adding a second review floor would hide edge thickness or confuse the actual terrain boundary, so no artificial ground is used.

---

# 4. Canonical lighting and rendering

Canonical review uses a normal **EEVEE scene render**, not viewport Material Preview.

Reason:

```text
EEVEE scene render
= deterministic + headless-capable + scriptable + independent of VIEW_3D UI context

Material Preview
= useful interactive diagnostic, but viewport/HDRI/context dependent
```

The canonical neutral rig uses:

- one dominant `SUN` key light with explicit direction;
- one broad `AREA` fill;
- optional restrained rim only for `character`;
- fixed neutral world/background;
- fixed warm-neutral matte ground where the profile uses one;
- contact shadows from the real asset silhouette;
- no depth of field, fog or cinematic grading.

The key/fill setup is intentionally not a dramatic three-point studio rig. The review should expose:

- silhouette;
- planar/faceted form;
- material blocks;
- grounding;
- construction.

It should not beautify a weak asset.

## Material Preview

Blender's native Material Preview is useful during interactive modeling and may be used through MCP/viewport inspection.

It is **diagnostic only**, because it depends on a `VIEW_3D` context and studio-light/HDRI state. Do not use a Material Preview screenshot as the canonical acceptance render.

---

# 5. Canonical views

`review_asset.py` renders:

```text
gameplay
silhouette
scale
front
side
top
review_sheet
```

Orientation contract:

```text
+Y = nominal front
+X = nominal right
+Z = up
```

Therefore:

- `front` camera looks from +Y toward the asset;
- `side` camera looks from +X;
- gameplay is orthographic at ~45° azimuth and ~35° elevation.

Camera framing is calculated by projecting the evaluated bounding box into camera space. It is not based on a fixed `max_dim` guess.

`scale` adds a neutral 1.72 m production mannequin to a separate gameplay-angle comparison. It does not redefine Wilson's final design.

---

# 6. Ground/background policy

Use an artificial ground when the review needs to judge:

- ground contact;
- footprint;
- apparent stability;
- contact shadow;
- Wilson-scale physical use.

Avoid the artificial ground for:

- terrain/ground assets;
- floating/hanging assets;
- silhouette pass;
- selected exploded diagnostics.

The background remains fixed and neutral across assets. Do not adapt it per asset just to increase attractiveness; stable comparison is more important.

---

# 7. Review iterations and visual progress

Default output:

```text
temp/blender-review/<asset_id>/
├── iter_01/
│   ├── <asset_id>_gameplay.png
│   ├── <asset_id>_silhouette.png
│   ├── <asset_id>_scale.png
│   ├── <asset_id>_front.png
│   ├── <asset_id>_side.png
│   ├── <asset_id>_top.png
│   ├── <asset_id>_review_sheet.png
│   └── <asset_id>_review_manifest.json
├── iter_02/
│   └── ...
└── latest.json
```

Each run creates the next iteration unless `--iteration` is supplied.

`review_asset.py` also refreshes:

```text
temp/blender-review/index.json
temp/blender-review/index.html
```

The HTML page is a visual convenience for the human. `index.json` and the manifests are agent-readable projections.

The cross-cutting asset catalog remains the authoritative production `Status`; review folders are not a second backlog.

---

# 8. Export profiles

## `static`

Use for:

- normal props;
- tools;
- structures;
- terrain;
- evaluated procedural outputs.

Contract:

```text
modifiers: evaluated/applied by glTF export
animations: off
skins: off
morph targets: forbidden
armature: forbidden
```

If a mesh has shape keys, this profile fails instead of losing them.

## `deformable`

Use for a non-armature asset that intentionally carries shape keys/morph animation.

Contract:

```text
modifiers: not force-applied by exporter
animations: on
skins: off
morph targets: on
armature: forbidden
```

## `rigged`

Use for Wilson and rigged animals.

Contract:

```text
modifiers: not force-applied by exporter
animations: on
skins: on
morph targets: on
armature: required
```

This separation exists because Blender's glTF `Apply Modifiers` export option cannot safely preserve shape keys.

---

# 9. Validation

Run before final export:

```text
tools/blender/validate_asset.py
```

It checks the mechanical conditions the scripts can safely prove, including:

- supported Blender series;
- scope resolution;
- renderable geometry exists;
- static/rigged/deformable profile compatibility;
- no accidental camera/light in runtime scope;
- no leaked `__review_*` objects;
- no negative scale;
- top-level scale normalized;
- suspicious duplicate semantic nodes such as Blender-generated `.001` anchors;
- basic scene-unit expectations.

Validation intentionally does **not** move origins or repair transforms. If the source is wrong, fix the source and re-run.

---

# 10. Export behavior

`export_asset.py`:

1. resolves the named scope;
2. validates it;
3. optionally saves a `.blend` **copy** according to source ownership;
4. selects only the scope temporarily;
5. exports GLB with the selected export profile;
6. restores selection;
7. writes a temporary export manifest.

The export manifest lives under:

```text
temp/blender-export/<asset_id>/
```

and stores repository-relative paths. Machine-specific absolute paths are not committed.

---

# 11. Typical commands

## Independent static prop

```text
review_asset.py --
  --asset-id crate_wood_01
  --scope-kind collection
  --scope-name ASSET_crate_wood_01
  --profile grounded
```

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

## Procedural rock

```text
export_asset.py --
  --asset-id rock_medium_03
  --scope-kind collection
  --scope-name ASSET_rock_medium_03
  --profile static
  --category environment/rocks
  --source-mode generator
  --generator-source assets/generators/environment/rocks/generate_rocks.py
```

---

# 12. Agent rule

An agent should not ask where to save an asset when the contracts determine it.

It should:

1. read the catalog row;
2. choose the correct source ownership mode;
3. reuse the nearest existing semantic category path;
4. use a named `AssetScope`;
5. choose the smallest correct review/export profile;
6. run review/validation/export;
7. report any contract that the scripts cannot prove rather than invent a workaround.

Do not create new folder synonyms such as `items/`, `objects/`, `misc/` or `game_props/` when an existing category expresses the asset.
