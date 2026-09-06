# 3D Asset Specification

This is the machine-facing contract for production assets crossing Blender → GLB → Godot.

Read this as a set of invariants, not as the normal creative workflow. The short modeling loop lives in `art/AGENT_ART_PRODUCTION.md`; exact script usage lives in `../tools/blender/README.md`.

---

# 1. Coordinate, scale and pose

All production assets use:

```text
units:  metric
scale:  1 Blender unit = 1 meter
front:  +Y
right:  +X
up:     +Z
```

This local frame is global across the project. Do not let different asset families redefine forward.

A runtime instance may rotate freely in the world. The rule above defines the **authored local coordinate system**.

For assets without a meaningful semantic front, keep a stable family orientation anyway. Symmetry is not permission to switch axes between variants.

## Canonical physical pose

The authored/review pose should be physically meaningful for the normal loose or installed state represented by the asset.

Examples:

```text
loose branch/log     → lying naturally
rock                 → resting on a plausible support face
crate/table/stool    → on intended base/feet
rooted palm          → upright
fallen vegetation    → gravity-consistent fallen pose
installed wall/panel → installed pose
floating/hanging     → appropriate non-grounded pose/profile
```

Do not stand a loose object vertically only for easier modeling or framing.

Placeable assets normally use a meaningful ground-contact pivot. Normalize transforms in authored/generated source; export does not silently repair them.

Avoid negative scale. If visible faceting depends on face splits, triangulation must be deterministic.

---

# 2. Stable identity

Use semantic IDs:

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

Do not encode ordinary mutable runtime condition into permanent identity when state/configuration already represents it.

---

# 3. Repository and source ownership

```text
assets/source/       manual/family .blend source
assets/generators/   bpy/config procedural source
assets/generated/    reproducible intermediates when useful
assets/previews/     intentionally retained review artifacts
assets/models/       runtime .glb consumed by Godot
```

```text
.blend = editable source when Blender owns an authored asset/family
.py    = generator/toolkit source
.glb   = canonical runtime/interchange model
.tscn  = optional authored Godot integration wrapper
```

Choose source ownership according to editing lifecycle:

```text
independent manual asset
→ source-mode=asset
→ normally one .blend per asset

authored siblings share real editing context
→ source-mode=family
→ one family .blend + multiple AssetScopes/GLBs

reproducible procedural family
→ source-mode=generator
→ generator/config + explicit seed are source
→ optional one workbench .blend, not one .blend per generated variant
```

Use one `.blend` per ordinary manual asset because it isolates pivot/review/export. Do not preserve that rule when it would duplicate a shared rig/base or materialize procedural output unnecessarily.

---

# 4. AssetScope and canonical root

A `.blend` is an authoring container. Review/export operate on an explicit **AssetScope**.

Supported scope forms:

```text
object
hierarchy
collection
```

Preferred convention for composite/family/generated content:

```text
Collection: ASSET_<asset_id>
```

The scope includes every runtime member that must cross glTF:

- render meshes;
- armature when applicable;
- semantic `ANCHOR_*` / `SOCKET_*` nodes;
- required runtime children.

Every production AssetScope has **exactly one top-level root**.

```text
simple single-object prop
→ mesh itself may be root

composite static asset
→ one root Empty at canonical pivot
→ geometry + semantic nodes below it

rigged asset
→ armature may be root, or one identity root above the rig
```

Root world transform:

```text
location = (0,0,0)
rotation = identity
scale    = (1,1,1)
```

Collection defines membership; root defines pivot/transform.

Production export must not depend on accidental active selection.

---

# 5. Relative scale

Do not maintain an art-only hardcoded dimension for every prop.

Resolve scale using, in order:

1. explicit catalog/domain physical requirement when one exists;
2. Wilson mannequin/adult reference;
3. intended interaction;
4. approved family siblings;
5. familiar neighboring world objects.

Concept images are references for visual language, not authoritative measurement drawings.

Controlled exaggeration is allowed for gameplay readability while preserving believable physical relationships.

Use the canonical `scale` review render when size is not obvious.

---

# 6. Semantic nodes

Interaction points and assembly sockets are named nodes/empties that survive GLB import with stable transforms.

```text
ANCHOR_APPROACH
ANCHOR_CHOP
ANCHOR_CLIMB
ANCHOR_COOK
ANCHOR_PICKUP
ANCHOR_INSPECT
ANCHOR_HAND_R
ANCHOR_HAND_L

SOCKET_WALL_N
SOCKET_WALL_E
SOCKET_ROOF
SOCKET_DOOR
SOCKET_ATTACHMENT_01
```

Rules:

- anchors are metadata, not visible geometry;
- names stay semantic and stable across compatible variants;
- orientation matters when interaction direction matters;
- do not invent object-specific names when a reusable role exists;
- Blender duplicate suffixes such as `.001` must not silently create competing semantics;
- verify semantic transforms after GLB/Godot import.

---

# 7. Collision, footprint and clearance

Keep separate:

```text
physical collision
navigation obstacle
interaction clearance
placement footprint
```

Do not use detailed render geometry as gameplay collision by default.

Engine-specific collision/navigation normally belongs in an authored `.tscn` wrapper rather than portable model geometry.

---

# 8. Materials and procedural Blender features

Materials:

- minimize material slots;
- reuse shared semantic material families;
- avoid unique texture dependencies for ordinary low-poly assets;
- use glTF-compatible properties when transfer matters;
- Blender procedural shaders are preview tools, not runtime contracts;
- runtime water/wetness/wind/fire/special effects normally belong in Godot;
- use backface culling for opaque solids where appropriate;
- use double-sided rendering only where the family needs it, e.g. selected leaves/cloth.

Modifiers/Geometry Nodes may author content, but Godot consumes evaluated/exported geometry, not Blender procedural graphs.

A procedural generator must:

1. use bounded semantic parameters;
2. use an explicit deterministic seed;
3. own/clean only its output;
4. create stable names;
5. create one AssetScope per export;
6. create required semantic nodes;
7. reuse shared helpers/materials;
8. be reproducible from committed generator/config inputs.

---

# 9. Review and export profiles

Review profiles:

```text
grounded   ordinary props/tools/rocks/palms/structures
character  Wilson and rigged animals
isolated   floating/hanging/exploded diagnostics
terrain    terrain/island/ground patches
```

Export profiles:

```text
static
  modifiers: evaluated/applied
  animations: no
  skins: no
  morphs: forbidden
  armature: forbidden

deformable
  modifiers: not force-applied
  animations: yes
  skins: no
  morphs: yes
  armature: forbidden

rigged
  modifiers: not force-applied
  animations: yes
  skins: yes
  morphs: yes
  exactly one armature required
```

Do not reuse static export flags for characters or shape-key assets.

---

# 10. Validation and non-destructive export

`tools/blender/validate_asset.py` is the pre-export mechanical gate.

It should reject rather than repair:

- unresolved AssetScope;
- zero renderable geometry;
- multiple/no canonical roots;
- non-identity root transform;
- profile/armature/shape-key mismatch;
- accidental camera/light/speaker inside runtime scope;
- leaked review helpers;
- negative scale;
- suspicious duplicate semantic nodes;
- unsupported Blender series unless explicitly overridden.

`tools/blender/export_asset.py` may temporarily select scope members and save a source copy, but it must not:

- purge unrelated scene objects;
- delete family siblings;
- move geometry to repair origin;
- normalize transforms to force success;
- remove anchors/sockets;
- silently omit excluded scope members.

Procedural export provenance records generator source/config/seed and resulting GLB SHA-256.

---

# 11. Godot boundary

Production runtime model:

```text
assets/models/**/*.glb
```

Commit the corresponding Godot import metadata:

```text
assets/models/**/*.glb.import
```

Ignore generated `.godot/` cache.

Use authored `.tscn` wrappers for Godot-specific composition such as:

- collision/navigation;
- presentation adapters;
- runtime shader/material overrides;
- particles/effects;
- engine-only animation composition;
- placement/runtime helpers.

Verify actual imported scale, hierarchy, orientation and semantic nodes. For rigged assets also verify skeleton, skin deformation, clips and morphs in Godot.

---

# 12. Definition of done

A production asset is done when:

```text
[ ] catalog requirement is aligned
[ ] source ownership is explicit
[ ] source/generator lives in canonical path
[ ] one stable AssetScope exists
[ ] local +Y/+X/+Z convention is respected
[ ] physical rest/installed pose is plausible
[ ] relative scale is visually/functionally coherent
[ ] visual review against references passes
[ ] structural validation passes
[ ] correct export profile is used
[ ] GLB export succeeds non-destructively
[ ] Godot import is inspected
[ ] anchors/sockets survive when required
[ ] rig/animation/morph data survives when applicable
[ ] required .import/.tscn resources are committed
[ ] catalog production status is updated
```
