# 3D Asset Specification

This is the machine-facing contract for Blender and Godot assets. Agents generating 3D content must satisfy this document even when a visually attractive alternative would be easier.

---

# 1. Coordinate and scale conventions

- Units: metric.
- Scale: 1 unit = 1 meter.
- Up axis: use the Blender/glTF/Godot-compatible workflow and verify imported orientation.
- Visual orientation convention: `+Y = nominal front`, `+X = nominal right`, `+Z = up`.
- Placeable world assets normally use a sensible ground-contact reference.
- Apply/normalize transforms **in source** where the asset class requires it.
- Do not rely on the export script to move geometry or repair transforms.
- If visible faceting depends on face splits, ensure triangulation is deterministic before/finalized during export.

Do not compensate for import mistakes with unexplained root rotations.

---

# 2. Asset identity

Use stable semantic IDs.

Examples:

```text
palm_coconut_01
rock_large_02
crate_wood_01
shelter_wall_bamboo_01
```

Naming pattern:

```text
<family>_<variant>[_<index>]
```

Do not encode mutable world state into the permanent entity ID.

---

# 3. Source ownership

Canonical repository areas:

```text
assets/source/       manual/family .blend authoring sources
assets/generators/   bpy procedural generator/config source
assets/generated/    reproducible intermediates when needed
assets/previews/     non-authoritative review output
assets/models/       runtime-ready .glb imported by Godot
```

The authoring/intermediate directories contain `.gdignore`.

Format contract:

```text
.blend = Blender authoring source when a Blender file owns the asset/family
.py    = procedural generator source
.glb   = canonical runtime/interchange 3D model
.tscn  = optional authored Godot integration wrapper
```

Choose source ownership deliberately:

```text
independent manually authored asset
→ source-mode=asset
→ normally one .blend per asset

several tightly related authored variants/stages/rig siblings
→ source-mode=family
→ one family .blend, multiple named AssetScopes

procedural/bounded generated family
→ source-mode=generator
→ generator + deterministic parameters are canonical source
→ optional one family/workbench .blend, not one .blend per generated variant
```

See `assets/README.md` and `tools/blender/README.md`.

---

# 4. AssetScope

The export/review boundary is the **AssetScope**, not the `.blend` file and not an accidental selection.

Supported production scope forms:

```text
object
hierarchy
collection
```

Recommended for composites, family files and generator outputs:

```text
Collection: ASSET_<asset_id>
```

The scope must include every runtime object that is expected to survive GLB export:

- render meshes;
- armature when applicable;
- semantic empties/nodes;
- required child nodes.

A trivial single-object asset may use object scope only when it has no required children/anchors omitted by that choice.

Agents must not depend on active selection for final production export.

---

# 5. Semantic nodes

Interaction points and assembly sockets are represented as named empty/nodes and must survive GLB import with stable names/transforms.

## Interaction anchors

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

Orientation matters when an actor should face a direction.

## Assembly sockets

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

Socket transforms must be stable across variants claiming compatibility.

## Character attachment anchors

Examples:

```text
ANCHOR_HAND_R
ANCHOR_HAND_L
ANCHOR_BACK
ANCHOR_CARRY
ANCHOR_HEAD
```

Prefer bone attachments when the transform follows a skeleton and expose a stable semantic mapping to gameplay.

## Anchor rules

- Anchors are metadata, not visible geometry.
- Names are semantic and stable.
- Do not invent object-specific anchor names when a reusable role fits.
- `APPROACH` anchors must provide enough physical clearance.
- Interaction animation aligns to anchors rather than hardcoded world offsets.
- Family variants expose the same required anchor contract unless explicitly documented.
- Validate names, positions and orientations **after GLB/Godot import**, not only in Blender.
- Do not allow Blender duplicate suffixes (`ANCHOR_X.001`) to silently create competing semantic transforms.

---

# 6. Footprints, collision and clearance

Every placeable gameplay object needs a logical footprint independent from decorative overhang.

Keep separate:

- physical collision;
- navigation obstacle;
- interaction clearance;
- placement footprint.

Do not use detailed render meshes as gameplay collision by default.

Examples:

- tree trunk: cylinder/capsule-like collision;
- rock: simple convex shape;
- crate: box;
- shelter: a small composition of boxes/convex pieces.

Godot-specific collision/navigation composition may live in an authored `.tscn` wrapper.

---

# 7. Materials

- keep material slots minimal;
- prefer reusable/shared material concepts;
- avoid unique texture dependencies for common low-poly assets;
- name materials semantically (`mat_wood`, `mat_leaf`);
- runtime palette variants should not require duplicate geometry;
- expect only glTF-compatible material features to transfer reliably;
- Blender-only procedural shaders are authoring previews, not runtime contracts;
- special runtime shaders/effects normally belong in Godot.

For normally opaque solid assets, use backface culling where appropriate. Keep double-sided rendering only when the family genuinely requires it, such as selected leaf/cloth constructions.

---

# 8. Blender procedural features

Modifiers and Geometry Nodes may be used to author/generate assets, but Godot consumes evaluated/exported glTF geometry.

Do not make runtime correctness depend on preserving:

- modifier stacks;
- Geometry Nodes graphs;
- Blender-only shader behavior;
- Blender scene lighting.

Procedural generators are canonical source when using `source-mode=generator`.

A generator must:

1. accept explicit bounded parameters;
2. use/derive a deterministic seed;
3. own and clean only its objects/collections;
4. create stable names;
5. create one named AssetScope for every exported output;
6. generate required anchors/sockets;
7. reuse shared material helpers;
8. validate output;
9. be reproducible from committed source/configuration.

Recommended semantic parameters:

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

Avoid exposing vertex-level noise knobs as the primary family API.

---

# 9. Review profiles

Artistic requirements live in `docs/art/AGENT_ART_PRODUCTION.md`; deterministic implementation lives under `tools/blender/`.

Approved generic review profiles:

```text
grounded   normal props/tools/rocks/palms/structures
character  Wilson/rigged animals
isolated   hanging/floating/exploded diagnostics
terrain    terrain/island/ground patches
```

Canonical review must not mutate the source asset.

Normal review output includes:

```text
gameplay
silhouette
scale
front
side
top
review_sheet
```

Gameplay review uses the canonical orthographic 3/4 convention.

---

# 10. Export profiles

Use the smallest correct profile.

## `static`

For ordinary props, structures, terrain and evaluated procedural output.

```text
apply modifiers: yes
animations: no
skins: no
morph targets: forbidden
armature: forbidden
```

A static export with shape keys is an error, not an invitation to silently drop them.

## `deformable`

For non-armature assets that intentionally carry shape keys/morph animation.

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

Blender's glTF `Apply Modifiers` option prevents safe shape-key export, which is why static/deformable/rigged are not the same profile.

---

# 11. Rigged/animated assets

For rigged assets:

- export from the intended rest/reference state;
- keep armature within the AssetScope;
- verify skeleton hierarchy in Godot;
- verify actual skin deformation in Godot;
- verify clip names/ranges/playback;
- verify blend shapes/morph targets;
- do not assume Blender interpolation/material behavior transferred identically.

Wilson and recurring rigged animals must use the `rigged` profile unless a later explicit contract supersedes it.

---

# 12. Asset states and variants

When state changes require different geometry, prefer coherent state pieces/variants rather than unrelated models.

Examples:

```text
palm healthy
palm damaged
palm stump
```

One catalog family may map to several GLBs or modular pieces.

Do not create a new semantic catalog identity merely because a presentation band needs different geometry.

For authored variants that share a true editing lifecycle, a family `.blend` with separate AssetScopes is preferred over duplicated independent `.blend` files.

For procedural variants, regenerate from code/seed instead of versioning one `.blend` per variant.

---

# 13. Validation

Production validation should check mechanically provable invariants before export.

Current `tools/blender/validate_asset.py` covers:

- supported Blender series;
- resolvable AssetScope;
- renderable geometry exists;
- export-profile compatibility;
- armature/shape-key mismatch;
- camera/light/speaker accidentally inside runtime scope;
- leaked review objects;
- negative scales;
- normalized top-level scale;
- suspicious duplicate semantic-node suffixes;
- basic scene-unit expectations.

Future/engine-side validation should additionally cover:

- material count guardrails;
- triangle count guardrails;
- invalid external texture paths;
- required anchors/sockets from catalog/integration manifest;
- imported GLB hierarchy;
- imported semantic transforms;
- required collision/integration wrapper;
- rig/animation/morph integrity.

Validation **fails** when source must be fixed. It must not mutate geometry to force success.

---

# 14. Non-destructive export

`tools/blender/export_asset.py` must preserve the live authored session.

It may:

- temporarily select scope objects;
- write a `.blend` copy for `asset`/`family` source modes;
- export GLB;
- write a temporary manifest.

It must not:

- delete unrelated scene objects;
- delete family siblings;
- move geometry to bottom-center;
- zero rotations/locations to make validation pass;
- apply source transforms as a hidden repair step;
- remove anchors/sockets.

If the source contract is wrong, fix the source explicitly and re-run.

---

# 15. Godot import metadata

Godot creates `<asset>.import` metadata beside imported runtime assets.

Commit:

```text
assets/models/**/*.glb
assets/models/**/*.glb.import
```

Do not commit:

```text
.godot/
```

---

# 16. Godot integration wrapper

Use an authored `.tscn` wrapper when engine-specific composition is needed:

- collision/navigation;
- adapter scripts;
- runtime material/shader overrides;
- particles/effects;
- engine-only animation composition;
- placement/runtime helpers.

Keep raw GLB reusable.

---

# 17. Asset manifest boundary

Gameplay capabilities live in domain/content definitions, not in filenames or Blender custom properties alone.

A manifest may map content to presentation requirements:

```json
{
  "archetype": "coconut_tree",
  "visual_family": "palm_coconut",
  "required_anchors": ["APPROACH", "CHOP", "CLIMB"],
  "optional_anchor_prefixes": ["FRUIT_"]
}
```

`cuttable` belongs to simulation/content semantics.

`ANCHOR_CHOP` belongs to presentation compatibility.

Both should be validated at integration boundaries without collapsing them into one concept.

---

# 18. Definition of done

A 3D asset is done only when:

1. its catalog row/spec is sufficiently aligned;
2. source ownership (`asset`, `family`, or `generator`) is explicit;
3. canonical source/generator is saved in the expected location;
4. runtime members are contained in a stable AssetScope;
5. visual style matches `VISUAL_GUIDE.md` and relevant art references;
6. semantic nodes satisfy this spec;
7. canonical artistic review passes;
8. structural validation passes;
9. the correct export profile is used;
10. GLB exports without mutating the source asset;
11. Godot imports scale/orientation/hierarchy/materials correctly;
12. anchors/sockets are verified after import;
13. rig/animation/morph data is verified when applicable;
14. relevant interactions work without hardcoded per-instance offsets;
15. Godot `.import` metadata and required `.tscn` wrapper are committed;
16. the cross-cutting asset-catalog production status is updated.
