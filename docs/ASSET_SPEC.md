# 3D Asset Specification

This is the machine-facing contract for Blender and Godot assets. Agents generating 3D content must satisfy this document even when a visually attractive alternative would be easier.

## Coordinate and scale conventions

- Units: metric.
- Scale: 1 unit = 1 meter.
- Up axis: follow the Blender/Godot glTF-compatible workflow and verify imported orientation; do not compensate with unexplained root rotations.
- Object origin for placeable world assets: ground-contact reference, centered sensibly within the footprint unless the asset class requires otherwise.
- Apply/normalize transforms before final export where appropriate.
- If visible faceting depends on face splits, ensure triangulation is deterministic before/finalized during export.

## Asset identity

Use stable semantic IDs, not descriptive prose.

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

## Source, generated and runtime ownership

Canonical file ownership is:

```text
assets/source/       editable manual .blend sources
assets/generators/   bpy procedural generator/toolkit source
assets/generated/    reproducible intermediates when needed
assets/previews/     canonical/diagnostic review renders
assets/models/       runtime-ready .glb outputs imported by Godot
```

The authoring/intermediate directories contain `.gdignore` and are not part of the Godot runtime import surface.

Format contract:

```text
.blend = editable Blender source
.py    = procedural generator source
.glb   = canonical interchange/runtime 3D model
.tscn  = optional authored Godot integration wrapper
```

Direct `.blend` import may be used for local experiments, but approved runtime assets must have a validated `.glb` representation under `assets/models/`.

Generated assets must be reproducible from committed generators/configuration whenever practical.

## Semantic nodes

Interaction points and assembly sockets are represented as named empty/nodes in the Blender source and must survive GLB import with stable names and transforms.

### Interaction anchors

Prefix: `ANCHOR_`

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

An interaction anchor defines a semantic transform. Orientation matters when the actor should face a direction.

### Assembly sockets

Prefix: `SOCKET_`

Examples:

```text
SOCKET_WALL_N
SOCKET_WALL_E
SOCKET_ROOF
SOCKET_DOOR
SOCKET_ATTACHMENT_01
```

Sockets connect modular geometry. Socket transforms must be stable across variants claiming compatibility.

### Character attachment anchors

Examples:

```text
ANCHOR_HAND_R
ANCHOR_HAND_L
ANCHOR_BACK
ANCHOR_CARRY
ANCHOR_HEAD
```

Prefer bone attachments when the anchor follows a skeleton; expose a stable semantic mapping to gameplay code.

## Anchor rules

- Anchors are metadata, not visible geometry.
- Names are semantic and stable across visual variants.
- Do not add object-specific anchor names when an existing semantic role fits.
- An `APPROACH` anchor must provide enough clearance for the intended actor.
- Interaction animation should align to the anchor, not rely on hardcoded world offsets.
- Variants in one family must expose the same required anchor contract unless explicitly documented.
- Anchor/socket validation happens on the imported GLB/Godot scene, not only in the Blender source.

## Footprints and clearance

Every placeable gameplay object needs a logical footprint independent from decorative overhang. Runtime representation may use collision/navigation geometry or generated metadata.

Separate concepts where needed:

- physical collision;
- navigation obstacle;
- interaction clearance;
- placement footprint.

Do not use detailed render meshes as gameplay collision by default.

## Collision

Use simple primitives or deliberately simplified collision meshes. Collision complexity should correspond to gameplay need, not visual geometry.

Examples:

- tree trunk: cylinder/capsule-like collision;
- rock: simple convex shape;
- crate: box;
- complex shelter: small composition of boxes/convex pieces.

Collision/navigation composition may live in an authored Godot `.tscn` wrapper when it is engine-specific rather than portable model data.

## Materials

- keep material slots minimal;
- prefer reusable/shared material concepts;
- avoid external texture dependencies for simple low-poly props;
- material names should describe semantic surface (`mat_wood`, `mat_leaf`) rather than generated color values;
- runtime palette variants should not require duplicate geometry;
- expect only glTF-compatible material properties to transfer reliably from Blender;
- Blender-only procedural shaders are authoring previews, not runtime contracts;
- special runtime shaders/effects should normally be assigned in Godot.

For normally opaque solid assets, use backface culling where appropriate. Keep double-sided rendering only when the family genuinely requires it, such as selected leaf/cloth constructions.

## Blender procedural features

Modifiers and Geometry Nodes may be used to author/generate assets, but Godot consumes the evaluated/exported glTF geometry rather than the Blender procedural graph itself.

Do not make runtime correctness depend on preserving:

- Blender modifier stacks;
- Geometry Nodes graphs;
- Blender-only shader-node behavior;
- Blender scene lighting.

## Animation and character export

For rigged assets:

- export from the intended rest/reference pose;
- verify skeleton hierarchy after Godot import;
- verify skin weights/deformation in Godot;
- verify animation clip names/ranges and actual playback after import;
- verify blend shapes/morph targets when used;
- do not assume Blender interpolation/material behavior transfers identically without inspection.

## LOD

Do not create LODs prematurely for tiny props. Establish profiling evidence first. Asset generators should nevertheless keep geometry simple enough that future LOD generation is possible.

## Asset states

When state changes require different geometry, prefer explicit state pieces/variants:

```text
palm healthy
palm damaged
palm stump
```

Where feasible, represent state through modular parts rather than entirely unrelated models so transitions remain visually coherent.

One catalog family may therefore map to several GLBs or modular state pieces. Do not create a new semantic catalog identity merely because a visual state requires different geometry.

## Procedural generator contract

A generator should:

1. accept explicit typed/configurable parameters;
2. accept or derive a deterministic seed;
3. clean up only objects/collections it owns;
4. create stable names;
5. generate required anchors/sockets;
6. apply materials through shared helpers;
7. validate its output;
8. optionally render the canonical preview package;
9. export GLB to a deterministic destination under `assets/models/`.

Avoid scripts that depend on whatever object happens to be selected in an interactive Blender session.

## Recommended generator parameters

Prefer bounded semantic parameters:

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

Avoid exposing dozens of vertex-level knobs unless they are reusable infrastructure.

## Validation

Automated validation should eventually check:

- expected root/collection exists;
- naming conventions;
- unit scale/transforms;
- required anchors/sockets;
- duplicate semantic anchors;
- material count;
- triangle count guardrail;
- invalid external texture paths;
- collision presence when required by the integration contract;
- deterministic/export-safe triangulation where visually relevant;
- export success;
- GLB re-import/Godot import sanity;
- imported hierarchy and semantic-node names/transforms;
- rig/animation/blend-shape integrity for animated assets.

## Godot import metadata

Godot creates `<asset>.import` files beside imported runtime assets. These contain per-asset import configuration and are part of the project source-control contract.

Commit:

```text
assets/models/**/*.glb
assets/models/**/*.glb.import
```

Do not commit the generated `.godot/` cache.

## Godot integration wrapper

Use a `.tscn` wrapper only when engine-specific composition is needed, for example:

- collision/navigation nodes;
- presentation adapters/scripts;
- runtime shader/material overrides;
- particles/effects;
- Godot-only animation composition;
- placement/runtime helpers.

Keep the raw imported GLB reusable; avoid burying portable model semantics in object-specific Godot workarounds.

## Asset manifest

Gameplay capabilities should live in domain/data definitions, not be inferred solely from filenames. A manifest may map an archetype to visual assets and required anchors:

```json
{
  "archetype": "coconut_tree",
  "visual_family": "palm_coconut",
  "required_anchors": ["APPROACH", "CHOP", "CLIMB"],
  "optional_anchor_prefixes": ["FRUIT_"]
}
```

`cuttable` belongs to the simulation definition. `ANCHOR_CHOP` belongs to presentation compatibility. Both should be validated together at integration boundaries.

## Definition of done for a 3D asset

An asset is done only when:

1. source/generator is saved in the canonical `assets/` location;
2. its catalog row requirements are satisfied;
3. visual style matches `VISUAL_GUIDE.md` and relevant art references;
4. semantic nodes satisfy this spec;
5. artistic preview/review in `docs/art/AGENT_ART_PRODUCTION.md` passes;
6. automated structural validation passes when tooling exists;
7. GLB exports and imports into Godot correctly;
8. imported scale/orientation/hierarchy/materials/anchors are inspected;
9. relevant rig/animation data is validated for animated assets;
10. relevant interactions are tested without hardcoded per-instance offsets;
11. Godot `.import` metadata and any required authored `.tscn` wrapper are committed;
12. the cross-cutting asset catalog production status is updated.