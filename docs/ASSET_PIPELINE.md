# Asset Pipeline

## Goal

Make 3D content production repeatable enough that humans and coding/Blender agents can create compatible assets without relying on hidden artistic assumptions.

```text
Visual Guide + Asset Spec
          |
          v
 concept / reference
          |
          v
 Blender source or bpy generator
          |
          v
 structural validation
          |
          v
 gameplay-camera preview
          |
          v
 visual critique / iteration
          |
          v
 GLB export
          |
          v
 Godot import + interaction test
```

## Blender as an asset compiler

For repeatable low-poly families, prefer procedural `bpy` generators over one-off manual mesh editing. Manual Blender work remains appropriate for Wilson, rigs, key animations and hero assets.

A generator is source code. Generated meshes are build outputs unless there is a clear reason to version them as source.

## Agent workflow

An autonomous 3D agent should use this loop:

1. read `VISUAL_GUIDE.md`, `ASSET_SPEC.md` and the relevant task;
2. inspect existing toolkit/generators before creating helpers;
3. define the asset family and required semantic anchors;
4. generate/model the simplest valid version;
5. run structural checks;
6. render from the canonical gameplay camera plus an optional diagnostic view;
7. inspect the render, identify concrete visual defects and iterate;
8. export GLB;
9. verify Godot import and anchor discovery when tooling exists;
10. report compromises or unresolved visual uncertainty.

Do not perform endless autonomous aesthetic iteration. Use a bounded iteration count and escalate uncertain art-direction choices for review.

## Proposed repository layout

```text
assets/
├── source/
│   ├── characters/
│   ├── environment/
│   ├── structures/
│   └── props/
├── generators/
│   ├── toolkit/
│   ├── vegetation/
│   ├── terrain/
│   ├── structures/
│   └── props/
├── previews/
└── dist/

tools/
└── blender/
    ├── validate.py
    ├── export.py
    ├── preview.py
    └── build_assets.py
```

Do not create this full tree until implementation needs it; it is the intended shape, not empty-folder ceremony.

## Shared Blender toolkit

Build reusable primitives before mass asset generation. Candidate helpers:

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
validate_asset
render_preview
export_glb
```

Helpers should expose semantic parameters and deterministic seeds. They should not assume active selection or undocumented scene state.

## Visual references and AI image generation

Image models are best used for **concept/reference sheets**, not as the authoritative source of animation frames.

A concept request should specify:

- invariant project style from `VISUAL_GUIDE.md`;
- gameplay camera;
- asset function and approximate scale;
- required variants/states;
- modular decomposition;
- interaction anchors/sockets that must remain plausible;
- request for clear form/construction rather than polished illustration effects.

Concept art can inspire geometry; it does not override the Asset Spec.

## Character pipeline

Wilson receives a stricter pipeline:

```text
approved concept
 -> base model
 -> topology review
 -> skeleton/rig
 -> attachment anchors
 -> reusable animation library
 -> Godot animation integration
```

Do not procedurally regenerate Wilson's identity for normal variations. Clothing/accessories can be modular later.

## Animation reuse

Animations belong to semantic action families. Generic interactions should align the actor to an object anchor and then play a reusable animation.

Example:

```text
CUT target
 -> navigate to ANCHOR_CHOP
 -> orient to anchor
 -> attach tool to hand
 -> play swing/chop animation
 -> trigger authoritative action timing/effect
 -> play target feedback
```

Do not create `chop_palm`, `chop_crate`, `chop_vine` animations unless a specific object genuinely needs unique staging.

## Preview scene

Create a canonical Blender or Godot preview setup early with:

- gameplay orthographic camera;
- standard neutral ground;
- project-standard lighting;
- Wilson scale reference or mannequin;
- known reference props.

All asset-family reviews should include this view. Turntables are diagnostic only; gameplay view determines readability.

## Export

Target GLB/glTF 2.0. Preserve semantic nodes. Keep export settings centralized in tooling rather than relying on each agent remembering Blender UI settings.

After export, validate by re-importing or inspecting the GLB when practical. The pipeline is not complete merely because Blender reported a successful export.

## Blender MCP / CLI strategy

Prefer scripted, reproducible operations:

```text
LLM/agent
 -> edit generator/tool code
 -> execute in Blender through MCP or CLI
 -> render preview
 -> inspect result
 -> revise code
```

Avoid long sequences of fragile UI-level operations or vertex-by-vertex tool calls. MCP is an execution/inspection bridge; `bpy` code should carry most repeatable construction logic.

## Version-control policy

Commit:

- generator source;
- intentional `.blend` source for manually authored assets;
- configuration/manifests;
- approved small reference previews when useful;
- runtime assets required to build/run the project unless build automation reliably regenerates them.

Avoid committing:

- temporary renders;
- Blender backup/autosave files;
- duplicated intermediate exports;
- high-resolution AI reference dumps without clear project value.

## First pipeline experiment

Before producing a large library, build one coherent tropical diorama containing:

- terrain/island;
- water;
- at least two vegetation families;
- rock family;
- crate;
- campfire;
- simple shelter;
- placeholder character.

At least one family (preferably palm trees or rocks) must be procedurally generated with several seed variants. At least two assets must expose semantic anchors and be exercised from Godot.

The experiment is successful if a second agent can read the documentation, generate a new compatible prop/family, and integrate it without inventing a new pipeline.
