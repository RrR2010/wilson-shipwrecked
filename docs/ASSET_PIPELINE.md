# Asset Pipeline

## Goal

Make 3D content production repeatable enough that humans and modeling agents can create compatible assets without relying on hidden artistic assumptions.

```text
Asset Catalog + Visual Guide + Asset Spec
                 |
                 v
      choose source ownership
       asset | family | generator
                 |
                 v
      model/generate named AssetScope
                 |
                 v
       canonical review iterations
                 |
                 v
         structural validation
                 |
                 v
       profile-based GLB export
                 |
                 v
        Godot import verification
                 |
                 v
      optional Godot .tscn wrapper
```

The pipeline is not complete merely because Blender reported a successful export.

---

# 1. Canonical format ownership

```text
.blend = editable Blender source when Blender file is the canonical authoring unit
.py    = reproducible bpy generator/toolkit source
.glb   = canonical interchange/runtime 3D model imported by Godot
.tscn  = optional Godot integration wrapper for engine-specific composition
```

Godot can import `.blend` files directly by invoking an installed Blender and converting through Blender's glTF exporter. This is useful for local experiments but is not the project runtime contract.

Production assets export and commit `.glb` under `assets/models/`.

---

# 2. Supported production Blender

Automation under `tools/blender/` targets:

```text
Blender 5.2 LTS
```

Use the latest 5.2.x patch available to the team.

The scripts fail on another major/minor Blender series unless an explicit override is supplied. This intentionally trades broad compatibility for stable Python/glTF-exporter behavior.

---

# 3. Source ownership

Blender is an authoring/compiler environment, but the canonical source unit depends on the asset family.

## Independent manual asset

Use:

```text
source-mode=asset
one independently authored asset → one .blend
```

This is the default because it gives an agent excellent isolation for:

- origin/pivot;
- local hierarchy;
- review;
- validation;
- export.

Examples include crates, rare salvage, a unique container and hero props.

## Authored family

Use:

```text
source-mode=family
several tightly related authored exports → one family .blend
```

Choose this only when siblings genuinely share editing context:

- rig/topology;
- modular parts;
- lifecycle/stage construction;
- shared authored base geometry;
- coordinated variants.

Each exported asset still gets an independent `AssetScope` and GLB.

## Procedural family

Use:

```text
source-mode=generator
generator + deterministic parameters/seed → canonical source
```

Preferred for bounded variant families such as:

- rocks;
- branches/logs;
- palms;
- debris clusters;
- simple construction pieces.

Do **not** commit one generated `.blend` per procedural variant.

One optional family/workbench `.blend` may exist for visual comparison, parameter tuning or generator debugging.

The authoritative decision table lives in `assets/README.md` and `tools/blender/README.md`.

---

# 4. AssetScope is the export boundary

File isolation is not sufficient once a family `.blend` or generator workbench contains several outputs.

Review/validation/export operate on an explicit `AssetScope`.

Supported scope types:

```text
object
hierarchy
collection
auto
```

Preferred convention for composites, family files and generated assets:

```text
Collection: ASSET_<asset_id>
```

Include every runtime member that must cross glTF:

- render meshes;
- armature when applicable;
- `ANCHOR_*`;
- `SOCKET_*`;
- required runtime child nodes.

`auto` prefers this collection, then a hierarchy root named `<asset_id>`. Active-object fallback is for interactive convenience only and emits a warning.

---

# 5. Agent production workflow

An autonomous modeling agent should:

1. start from the normalized row in `docs/asset-catalog/`;
2. read `VISUAL_GUIDE.md`, `ASSET_SPEC.md`, relevant `docs/art/` references and `docs/art/AGENT_ART_PRODUCTION.md`;
3. choose source ownership: `asset`, `family` or `generator`;
4. inspect existing generators/toolkit before creating helpers;
5. create the simplest valid asset/family;
6. keep every exported runtime member in a named AssetScope;
7. render the canonical review package through `tools/blender/review_asset.py`;
8. self-review and iterate within the artistic iteration guard;
9. run independent art review;
10. run `tools/blender/validate_asset.py`;
11. correct validation defects **in source**;
12. export through the correct export profile with `tools/blender/export_asset.py`;
13. verify actual Godot import, hierarchy, anchors/sockets, scale, materials and any animation/skin/morph data;
14. create a `.tscn` wrapper only when Godot-specific composition is required;
15. update asset-catalog production status/notes.

The review/export scripts do not silently repair an asset.

---

# 6. Repository layout

```text
assets/
├── README.md
├── source/        # manual/family .blend source; .gdignore
├── generators/    # bpy/config source; .gdignore
├── generated/     # reproducible intermediates; .gdignore
├── previews/      # optional non-authoritative review output; .gdignore
└── models/        # runtime-ready .glb imported by Godot

tools/
└── blender/
    ├── README.md
    ├── _workflow_common.py
    ├── _workflow_profiles.py
    ├── review_asset.py
    ├── validate_asset.py
    ├── export_asset.py
    └── build_review_index.py
```

Top-level asset categories are constrained to:

```text
characters/
environment/
props/
structures/
```

Nested semantic paths are allowed and encouraged.

Do not invent competing synonyms such as `items/`, `objects/`, `misc/` or `game_props/`.

---

# 7. Shared Blender toolkit strategy

For repeatable families, prefer `bpy` generators over UI micro-operations.

Reusable candidates include:

```text
create_stylized_cylinder
create_irregular_rock
create_leaf_cluster
create_plank
create_rope_segment
create_anchor
create_socket
assign_material
apply_bounded_variation
```

Generator helpers should expose semantic parameters and deterministic seeds.

A generator must:

- own/clean only its own objects/collections;
- create stable names;
- create a named AssetScope for each exported output;
- preserve required anchors/sockets;
- avoid depending on active selection;
- be reproducible from committed code/configuration.

---

# 8. Canonical review implementation

The artistic review contract remains `docs/art/AGENT_ART_PRODUCTION.md`.

`tools/blender/review_asset.py` is the deterministic implementation for ordinary production review.

It produces:

```text
gameplay
silhouette
scale
front
side
top
review_sheet
manifest
```

Iterations are retained under:

```text
temp/blender-review/<asset_id>/iter_XX/
```

and the script refreshes:

```text
temp/blender-review/index.json
temp/blender-review/index.html
```

The catalog remains the authoritative backlog/status. These outputs are review evidence only.

## Review renderer

Canonical review uses EEVEE scene renders because they are:

- deterministic;
- scriptable;
- headless-compatible;
- independent of viewport/UI context.

Native Blender Material Preview is allowed as an interactive/MCP diagnostic but is not canonical acceptance evidence because it depends on VIEW_3D/studio-light state.

## Lighting

The canonical rig deliberately avoids a dramatic hero three-point setup.

Default:

```text
dominant SUN key
+ broad AREA fill
+ fixed neutral world/background
+ optional restrained rim for character profile
```

This should reveal planes, silhouette, material blocks and grounding rather than beautify a weak asset.

## Review profiles

```text
grounded   normal props/tools/rocks/palms/structures
character  Wilson/rigged animals; grounded + restrained rim
isolated   hanging/floating/exploded diagnostics; no artificial floor
terrain    ground/island patches; no second artificial floor
```

Ground is useful for contact, footprint and shadow. It is intentionally absent when it would obscure terrain boundaries or is semantically meaningless.

---

# 9. Export profiles

Do not use one set of glTF flags for all asset types.

## `static`

For ordinary props, structures, terrain and evaluated procedural output.

```text
apply modifiers: yes
animations: no
skins: no
morph targets: forbidden
armature: forbidden
```

## `deformable`

For non-armature content that intentionally carries morph targets/shape-key animation.

```text
apply modifiers: no forced application
animations: yes
skins: no
morph targets: yes
armature: forbidden
```

## `rigged`

For Wilson and rigged animals.

```text
apply modifiers: no forced application
animations: yes
skins: yes
morph targets: yes
armature: required
```

This distinction matters because Blender glTF `Apply Modifiers` cannot preserve shape keys safely.

---

# 10. Non-destructive export rule

`export_asset.py` is not a cleanup script.

It must not:

- purge unrelated scene objects;
- move geometry to bottom-center;
- zero transforms to make validation pass;
- delete family siblings;
- remove anchors/sockets;
- change the authored asset before export.

Instead:

```text
validate
→ fail with explicit mechanical issue
→ agent fixes source
→ validate again
→ export
```

It may temporarily select scope members because the glTF operator needs an export set, but previous selection is restored.

Saving a canonical `.blend` uses `copy=True`; the live session remains the current working session.

---

# 11. Blender -> glTF/GLB rules

Godot 4.x recommends glTF 2.0 for interchange. Production rules:

- export GLB/glTF 2.0;
- preserve hierarchy and semantic nodes;
- use stable AssetScope membership;
- normalize transforms in source where the asset contract requires it;
- use deterministic triangulation when the visual faceting depends on face splits;
- keep rigs in their intended rest/reference state;
- use glTF-compatible material features when expecting transfer;
- enable backface culling for normally opaque solids where appropriate;
- deliberately keep double-sided only for families that require it, such as selected leaves/cloth;
- treat Geometry Nodes/modifiers as authoring tools; evaluated exported geometry is runtime truth;
- validate imported skeletons, skins, clips and morph targets in Godot rather than assuming Blender behavior transferred exactly.

## Materials

The project flat-material direction aligns well with glTF.

Use Blender materials mainly for portable preview values:

- base color;
- roughness;
- metallic when relevant;
- explicitly allowed simple textures.

Do not depend on Blender-only procedural shader networks.

Runtime water, wetness, wind, fire and other special effects belong primarily in Godot.

---

# 12. Godot integration wrapper

GLB is the canonical raw runtime model.

Use a `.tscn` wrapper for Godot-specific composition such as:

- collision/navigation;
- presentation adapter scripts;
- material/shader overrides;
- particles/effects;
- engine-only animation composition;
- placement/runtime helpers.

Do not edit generated resources inside `.godot/`.

---

# 13. Godot import metadata and source control

Commit:

```text
assets/models/**/*.glb
assets/models/**/*.glb.import
```

Ignore:

```text
.godot/
```

When import parameters matter, inspect the committed `.import` file after Godot imports the GLB.

---

# 14. Character pipeline

Wilson receives a stricter pipeline:

```text
approved concept
→ base model
→ topology review
→ skeleton/rig
→ attachment anchors
→ reusable animation library
→ rigged export profile
→ GLB import validation
→ Godot animation integration
```

Do not procedurally regenerate Wilson's identity for normal variations.

Animations belong to semantic action families. Avoid target-specific animation proliferation when a generic action + semantic anchor solves the interaction.

---

# 15. Version-control policy

Commit:

- generator source/configuration;
- intentional manual/family `.blend` sources;
- runtime GLBs;
- Godot `.import` metadata;
- authored `.tscn`/`.tres` wrappers;
- approved small reference artifacts when deliberately useful.

Avoid committing:

- `.godot/`;
- `temp/` review/export outputs;
- Blender backup/autosave files;
- reproducible generated intermediates without explicit value;
- duplicated generated `.blend` files for procedural variants;
- high-resolution AI reference dumps without clear project value.

---

# 16. First production batch success criterion

Before mass production, prove the pipeline across multiple categories:

1. one simple manual static prop;
2. one procedural static family with several deterministic variants;
3. one multi-object/composite scope with anchors/sockets;
4. one structure using a family/source file;
5. one rigged/animated actor when character production starts.

The pipeline succeeds when another agent can read the catalog/contracts, create a compatible asset, produce review iterations, validate/export it and verify Godot import without inventing a second workflow.
