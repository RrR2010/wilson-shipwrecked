# 3D Asset Specification

This is the machine-facing contract for Blender and Godot assets. Agents generating 3D content must satisfy this document even when a visually attractive alternative would be easier.

## Coordinate and scale conventions

- Units: metric.
- Scale: 1 unit = 1 meter.
- Up axis: follow Blender/Godot glTF-compatible workflow and verify imported orientation; do not compensate with unexplained root rotations.
- Object origin for placeable world assets: ground-contact reference, centered sensibly within the footprint unless the asset class requires otherwise.
- Apply/normalize transforms before final export where appropriate.

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

## Blender source vs runtime output

```text
assets/source/       editable .blend sources
assets/generated/    generated intermediate assets, if needed
assets/dist/         runtime-ready .glb outputs
assets/generators/   bpy procedural generators
```

Generated assets must be reproducible from committed generators/configuration whenever practical.

## Semantic nodes

Interaction points and assembly sockets are represented as named empty/nodes in the source and preserved through GLB import.

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

## Materials

- keep material slots minimal;
- prefer reusable/shared material concepts;
- avoid external texture dependencies for simple low-poly props;
- material names should describe semantic surface (`mat_wood`, `mat_leaf`) rather than generated color values;
- runtime palette variants should not require duplicate geometry.

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

## Procedural generator contract

A generator should:

1. accept explicit typed/configurable parameters;
2. accept or derive a deterministic seed;
3. clean up only objects/collections it owns;
4. create stable names;
5. generate required anchors/sockets;
6. apply materials through shared helpers;
7. validate its output;
8. optionally render a preview;
9. export to a deterministic destination.

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
- collision presence when required;
- export success;
- GLB re-import sanity.

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

1. source/generator is saved in the expected location;
2. visual style matches `VISUAL_GUIDE.md`;
3. semantic nodes satisfy this spec;
4. automated structural validation passes;
5. GLB exports and imports into Godot correctly;
6. it is inspected from gameplay camera distance;
7. relevant interactions are tested without hardcoded per-instance offsets.
