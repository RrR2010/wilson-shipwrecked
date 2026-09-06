# 3D Asset Specification

This is the machine-facing contract for production assets crossing Blender → GLB → Godot. Agents must satisfy it even when a visually attractive shortcut would be easier.

## 1. Coordinate / transform contract

```text
units:      metric
scale:      1 Blender unit = 1 meter
up:         +Z
front:      +Y
right:      +X
```

- Placeable assets normally use a meaningful ground-contact pivot.
- Normalize required transforms **in authored/generated source**, not as a hidden export repair.
- Production root transform is identity; see AssetScope below.
- Avoid negative scale.
- If visible faceting depends on face splits, triangulation must be deterministic before/finalized during export.
- Verify imported orientation in Godot; never hide an import mistake behind unexplained wrapper rotations.

## 2. Stable asset identity

Use stable semantic IDs:

```text
palm_coconut_01
rock_large_02
crate_wood_01
shelter_wall_bamboo_01
```

Pattern:

```text
<family>_<variant>[_<index>]
```

Do not encode mutable runtime condition into permanent identity when ordinary state/configuration already represents it.

## 3. Repository / format ownership

```text
assets/source/       manual or family .blend authoring sources
assets/generators/   bpy/config procedural source
assets/generated/    reproducible intermediates when useful
assets/previews/     review artifacts when deliberately retained
assets/models/       runtime .glb consumed by Godot
```

```text
.blend = editable Blender source when Blender owns the authored asset/family
.py    = generator/toolkit source
.glb   = canonical 3D interchange/runtime model
.tscn  = optional authored Godot integration wrapper
```

Direct `.blend` import may be used for experiments. Approved runtime content must have a validated `.glb` under `assets/models/`.

## 4. Source ownership mode

Source ownership is independent from export count.

### `asset`

Default for an independently edited manual asset:

```text
one independent asset → one .blend
```

This is preferred when file isolation simplifies pivot, review and export with no real benefit from sharing authored context.

### `family`

Use one `.blend` for several outputs only when they genuinely share an editing lifecycle, such as:

- common rig/topology;
- modular kit;
- lifecycle/stage construction;
- authored base mesh;
- deliberately coordinated variants.

Each exported asset still has its own AssetScope and GLB.

### `generator`

Use generator/configuration as source of truth for reproducible bounded variants.

```text
generator + explicit parameters/config + stable seed
→ generated AssetScope
→ GLB
```

Do not version one `.blend` per procedural variant. One optional family/workbench `.blend` may exist for tuning, comparison or debugging.

See `assets/README.md` and `tools/blender/README.md` for examples.

## 5. AssetScope and canonical root

The `.blend` is only an authoring container. Review/export operate on an explicit **AssetScope**.

Supported forms:

```text
object
hierarchy
collection
```

Preferred collection convention for composites/family/generated content:

```text
ASSET_<asset_id>
```

The scope includes every runtime member that must cross glTF:

- render meshes;
- armature when applicable;
- semantic empties/nodes;
- required runtime children.

### Single-root invariant

Every production AssetScope has **exactly one top-level root**.

```text
simple single-object prop
→ mesh itself may be root

composite static asset
→ one root Empty at canonical pivot
→ meshes / ANCHOR_* / SOCKET_* below it

rigged asset
→ armature may be root, or one explicit identity root above the authored rig
→ still exactly one top-level root
```

Root world transform:

```text
location = (0, 0, 0)
rotation = identity
scale    = (1, 1, 1)
```

Collection controls **membership**; root controls **pivot/transform**. A family `.blend` may contain several `ASSET_*` collections without making their working placement part of runtime transforms.

Production export must not depend on active selection. `scope-kind=object` is valid only when no required children/anchors would be omitted.

## 6. Semantic nodes

Interaction points and assembly sockets are named Blender nodes/empties that survive GLB import with stable transforms.

### Interaction anchors

Prefix:

```text
ANCHOR_
```

Examples:

```text
ANCHOR_APPROACH
ANCHOR_CHOP
ANCHOR_CLIMB
ANCHOR_COOK
ANCHOR_PICKUP
ANCHOR_INSPECT
ANCHOR_FRUIT_01
```

### Assembly sockets

Prefix:

```text
SOCKET_
```

Examples:

```text
SOCKET_WALL_N
SOCKET_WALL_E
SOCKET_ROOF
SOCKET_DOOR
SOCKET_ATTACHMENT_01
```

### Character attachments

Examples:

```text
ANCHOR_HAND_R
ANCHOR_HAND_L
ANCHOR_BACK
ANCHOR_CARRY
ANCHOR_HEAD
```

Prefer bone attachments when a transform follows a skeleton.

Rules:

- anchors are metadata, not visible geometry;
- names are semantic/stable across compatible variants;
- orientation matters when an actor should face a direction;
- `APPROACH` requires usable actor clearance;
- animation aligns to semantic transforms rather than per-instance offsets;
- do not invent object-specific anchor names when a reusable role fits;
- Blender duplicate suffixes such as `ANCHOR_X.001` must not silently create competing semantics;
- validate names/positions/orientations after GLB/Godot import, not only in Blender.

## 7. Footprint / collision / clearance

Keep separate:

```text
physical collision
navigation obstacle
interaction clearance
placement footprint
```

Do not use detailed render geometry as gameplay collision by default.

Typical collision approximation:

- trunk → cylinder/capsule-like;
- rock → simple convex;
- crate → box;
- shelter → small composition of boxes/convex shapes.

Engine-specific collision/navigation normally belongs in an authored `.tscn` wrapper rather than portable GLB geometry unless explicitly required otherwise.

## 8. Material contract

- minimize material slots;
- reuse shared semantic material families (`mat_wood`, `mat_leaf`, etc.);
- avoid unique texture dependencies for ordinary low-poly assets;
- palette variants should not require duplicate geometry;
- rely only on glTF-compatible material properties when expecting transfer;
- Blender procedural shaders are authoring previews, not runtime contracts;
- runtime water/wetness/wind/fire/special effects normally belong in Godot;
- use backface culling for normally opaque solids when appropriate;
- keep double-sided rendering only where required, such as selected leaves/cloth.

## 9. Procedural Blender features

Modifiers and Geometry Nodes may author/generate content, but Godot consumes evaluated/exported glTF output.

Runtime correctness must not depend on preserving:

- modifier stacks;
- Geometry Nodes graphs;
- Blender-only shader nodes;
- Blender lighting.

A production generator must:

1. accept bounded semantic parameters;
2. use an explicit deterministic seed;
3. own/clean only its objects/collections;
4. create stable names;
5. create one AssetScope per exported output;
6. create required anchors/sockets;
7. reuse shared material/toolkit functions;
8. validate output;
9. be reproducible from committed generator/configuration inputs.

Typical parameters:

```text
height
width/radius
lean
part_variant
cluster_count
wear/state
palette_variant
seed
```

For export provenance, `source-mode=generator` records generator source, optional committed config, explicit seed and resulting GLB SHA-256.

## 10. Review profiles

Artistic acceptance rules live in `docs/art/AGENT_ART_PRODUCTION.md`. The deterministic implementation lives in `tools/blender/`.

Profiles:

```text
grounded   props/tools/rocks/palms/normal structures
character  Wilson/rigged animals
isolated   hanging/floating/exploded diagnostics
terrain    terrain/island/ground patches
```

Canonical review is non-destructive and normally produces:

```text
gameplay
silhouette
scale
front
side
top
review_sheet
```

## 11. Export profiles

Use the smallest correct profile.

### `static`

For ordinary props, terrain, structures and evaluated procedural outputs.

```text
apply modifiers: yes
animations: no
skins: no
morph targets: forbidden
armature: forbidden
```

A shape-key mesh must fail rather than lose morph data.

### `deformable`

For non-armature content intentionally carrying morph targets/shape-key animation.

```text
apply modifiers: not force-applied
animations: yes
skins: no
morph targets: yes
armature: forbidden
```

### `rigged`

For Wilson and rigged animals.

```text
apply modifiers: not force-applied
animations: yes
skins: yes
morph targets: yes
armature: required
```

The profiles differ because Blender glTF `Apply Modifiers` cannot safely preserve shape keys.

## 12. Rigged asset checks

For rigged assets:

- keep armature inside AssetScope;
- export from intended rest/reference state;
- verify skeleton hierarchy after Godot import;
- verify actual skin deformation;
- verify clip names/ranges/playback;
- verify morph targets when used;
- do not assume Blender interpolation/material behavior transferred identically.

## 13. States / variants

When geometry must change with state, prefer coherent variants/modular pieces rather than unrelated replacement art.

```text
palm healthy
palm damaged
palm stump
```

One catalog family may map to several GLBs. Do not create a new semantic catalog identity merely because a presentation band needs new geometry.

Authored variants sharing real editing context may live in a family `.blend`; procedural variants should regenerate from source + seed.

## 14. Validation

`tools/blender/validate_asset.py` is the pre-export mechanical gate.

Current checks include:

- supported Blender series;
- AssetScope resolution;
- renderable geometry exists;
- exactly one canonical root;
- root location/rotation/scale identity;
- export-profile compatibility;
- armature/shape-key mismatch;
- accidental camera/light/speaker in runtime scope;
- review helpers leaking into scope;
- negative scale;
- suspicious duplicate semantic nodes;
- basic scene-unit expectations.

Additional Godot/integration validation should cover:

- material/triangle guardrails when established;
- external texture paths;
- catalog-required anchors/sockets;
- imported hierarchy and semantic transforms;
- required collision/wrapper setup;
- animation/skin/morph integrity.

Validation must **fail** when source needs repair; it must not mutate the model to force success.

## 15. Non-destructive export

`tools/blender/export_asset.py` may:

- temporarily select scope members;
- save a `.blend` copy for `asset`/`family` modes;
- export GLB;
- write temporary provenance metadata.

It must not:

- purge unrelated scene objects;
- delete family siblings;
- move geometry to fix origin;
- zero transforms to pass validation;
- remove anchors/sockets;
- silently omit scope members excluded from the active View Layer.

The generated export manifest stores repository-relative provenance and resulting GLB SHA-256 under `temp/`.

## 16. Godot metadata / wrapper

Commit:

```text
assets/models/**/*.glb
assets/models/**/*.glb.import
```

Ignore:

```text
.godot/
```

Use an authored `.tscn` wrapper when Godot-specific composition is needed, such as:

- collision/navigation;
- presentation adapter scripts;
- shader/material overrides;
- particles/effects;
- engine-only animation composition;
- placement/runtime helpers.

Keep raw GLB reusable.

## 17. Domain / presentation boundary

Gameplay capabilities live in domain/content definitions, not filenames or Blender custom properties alone.

Example presentation manifest concept:

```json
{
  "archetype": "coconut_tree",
  "visual_family": "palm_coconut",
  "required_anchors": ["APPROACH", "CHOP", "CLIMB"],
  "optional_anchor_prefixes": ["FRUIT_"]
}
```

`cuttable` is simulation/content semantics. `ANCHOR_CHOP` is presentation compatibility. Validate them together at integration boundaries without collapsing the concepts.

## 18. Definition of done

A production 3D asset is done only when:

1. catalog spec is sufficiently aligned;
2. source ownership (`asset`, `family`, `generator`) is explicit;
3. canonical source/generator inputs are saved in expected paths;
4. runtime members live in a stable AssetScope with one canonical root;
5. visual style matches `VISUAL_GUIDE.md` + relevant references;
6. semantic nodes satisfy this contract;
7. canonical artistic review passes;
8. structural validation passes;
9. correct export profile is used;
10. GLB export is non-destructive and provenance is recorded;
11. Godot import scale/orientation/hierarchy/materials are inspected;
12. anchors/sockets are verified after import;
13. rig/animation/morph data is verified where applicable;
14. relevant interactions work without hardcoded per-instance offsets;
15. `.import` metadata and required `.tscn` wrappers are committed;
16. asset-catalog production status is updated.
