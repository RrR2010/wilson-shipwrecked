# Asset Pipeline

## Goal

Make 3D content production repeatable enough that humans and coding/Blender agents can create compatible assets without relying on hidden artistic assumptions.

```text
Asset Catalog + Visual Guide + Asset Spec
                 |
                 v
         Blender source / bpy generator
                 |
                 v
        structural + artistic validation
                 |
                 v
           canonical previews
                 |
                 v
            GLB export
                 |
                 v
        Godot import verification
                 |
                 v
      optional Godot .tscn wrapper
```

## Canonical format ownership

Use the following project contract:

```text
.blend = editable/manual Blender source
.py    = reproducible bpy generator source
.glb   = canonical 3D interchange/runtime model imported by Godot
.tscn  = optional Godot integration wrapper for engine-specific composition
```

Godot can import `.blend` files directly by invoking an installed Blender and converting the scene through Blender's glTF exporter. This is useful for local experimentation, but it is not the project runtime contract because it adds an external Blender dependency to every importing machine and is unavailable in Godot web/Android editors.

For production assets, export and commit `.glb` files under `assets/models/`.

## Blender as an asset compiler

For repeatable low-poly families, prefer procedural `bpy` generators over one-off manual mesh editing. Manual Blender work remains appropriate for Wilson, rigs, key animations and hero assets.

A generator is source code. Generated meshes are build outputs unless there is a clear reason to version an intermediate as authored source.

## Agent workflow

An autonomous 3D agent should use this loop:

1. start from the normalized row in `docs/asset-catalog/`;
2. read `VISUAL_GUIDE.md`, `ASSET_SPEC.md`, relevant `docs/art/` references and `docs/art/AGENT_ART_PRODUCTION.md`;
3. inspect existing toolkit/generators before creating helpers;
4. define the simplest valid asset/family and required semantic anchors/sockets;
5. generate/model a blockout that already reads from the gameplay camera;
6. run structural checks;
7. render the canonical artistic preview package;
8. self-review, iterate within the documented guard, and run independent artistic review;
9. triangulate/apply transforms where needed for deterministic export;
10. export GLB to the deterministic `assets/models/` destination;
11. verify Godot import, hierarchy, anchors/sockets, scale, materials and required animation/skin data;
12. create a `.tscn` wrapper only when Godot-specific nodes/resources are required;
13. update catalog production status/notes.

The pipeline is not complete merely because Blender reported a successful export.

## Repository layout

The repository layout is now a contract, not a proposal:

```text
assets/
├── README.md
├── source/
│   └── .gdignore
├── generators/
│   └── .gdignore
├── generated/
│   └── .gdignore
├── previews/
│   └── .gdignore
└── models/
    └── README.md

tools/
└── blender/
    ├── validate.py        # when implemented
    ├── export.py          # when implemented
    ├── preview.py         # when implemented
    └── build_assets.py    # when implemented
```

Create semantic category subfolders only when needed, typically:

```text
characters/
environment/
props/
structures/
```

Do not create empty folder taxonomies merely for ceremony.

### Godot import boundary

The repository root is the Godot project root (`res://`). Only assets intended for Godot import should live under `assets/models/`.

The `.gdignore` files under `source/`, `generators/`, `generated/` and `previews/` ensure those authoring/intermediate directories are hidden from Godot's FileSystem dock, not imported, and not exported with the game.

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

Helpers should expose semantic parameters and deterministic seeds. They must not assume active selection or undocumented scene state.

## Visual references and AI image generation

Image models are best used for concept/reference sheets, not as authoritative 3D truth.

A concept/reference request should specify:

- invariant project style from `VISUAL_GUIDE.md`;
- gameplay camera;
- asset function and approximate scale;
- required variants/states;
- modular decomposition;
- interaction anchors/sockets that must remain plausible;
- clear form/construction rather than polished illustration effects.

AI-generated visual sheets communicate shape intent. Textual contracts and catalog/domain semantics remain authoritative when an image contains accidental artifacts.

## Character pipeline

Wilson receives a stricter pipeline:

```text
approved concept
→ base model
→ topology review
→ skeleton/rig
→ attachment anchors
→ reusable animation library
→ GLB import validation
→ Godot animation integration
```

Do not procedurally regenerate Wilson's identity for normal variations. Clothing/accessories may become modular later.

## Animation reuse

Animations belong to semantic action families. Generic interactions should align the actor to an object anchor and then play a reusable animation.

Example:

```text
CUT target
→ navigate to ANCHOR_CHOP
→ orient to anchor
→ attach tool to hand
→ play swing/chop animation
→ trigger authoritative action timing/effect
→ play target feedback
```

Do not create `chop_palm`, `chop_crate`, `chop_vine` animations unless an object genuinely needs unique staging.

## Canonical preview scene

Create a canonical Blender or Godot preview setup early with:

- gameplay orthographic camera;
- standard neutral ground;
- project-standard lighting;
- Wilson scale reference/mannequin;
- known reference props.

Use the full preview/review contract in `docs/art/AGENT_ART_PRODUCTION.md`. Turntables and close-ups are diagnostic only; gameplay view determines readability.

## Blender -> glTF/GLB compatibility rules

Godot 4.x recommends glTF 2.0 for 3D scene interchange. `.blend` direct import is itself a Blender-to-glTF conversion before Godot imports the result.

Production rules:

- export `.glb` / glTF 2.0;
- preserve semantic hierarchy/nodes used as anchors and sockets;
- apply/normalize transforms where appropriate before export;
- use deterministic triangulation for assets whose planar/faceted appearance depends on face splits;
- keep the rig in its proper rest/export pose;
- use glTF-compatible material features only when expecting Blender material data to transfer;
- prefer Godot-authored runtime lighting and special shaders rather than relying on Blender-specific shading setups;
- enable backface culling for normally opaque solid materials where appropriate, while deliberately keeping double-sided rendering only for families such as leaves/cloth when required;
- treat Blender modifiers/Geometry Nodes as authoring/generation tools: the evaluated/exported geometry is authoritative, not preservation of the procedural graph in Godot.

For complex animation/character exports, validate actual imported animation clips, skeletons, skin weights and blend shapes rather than assuming Blender preview behavior transferred exactly.

## Materials and shaders

The project art direction intentionally favors simple shared flat-color materials, which aligns well with glTF/Godot interchange.

Use Blender materials primarily as a portable preview approximation for:

- base color;
- roughness;
- metallic response where relevant;
- simple compatible texture inputs when explicitly allowed.

Do not make asset correctness depend on Blender-only procedural node graphs, generated surface micro-detail, or cinematic lighting.

Runtime-specific water, wetness, wind, fire, environmental response and other special effects should normally be implemented/assigned on the Godot side using the imported semantic mesh/material structure.

## Godot integration wrapper

Imported `.glb` is the canonical raw runtime model. Use a `.tscn` wrapper when the asset needs Godot-specific composition such as:

- collision/navigation nodes;
- presentation adapter scripts;
- runtime material overrides;
- particles/effects;
- engine-only animation setup;
- higher-level scene composition.

Do not edit or rely on generated imported resources inside `.godot/`. Keep authored Godot integration in normal `.tscn`/`.tres` files.

## Godot import metadata and version control

Godot creates `<asset>.import` files beside imported source assets. These files contain per-asset import configuration and **must be committed**.

The generated `.godot/` directory remains ignored and must not be committed.

Therefore the project policy is:

```text
commit:   assets/models/**/*.glb
commit:   assets/models/**/*.glb.import (after Godot imports them)
ignore:   .godot/
```

When import parameters matter, verify the committed `.import` metadata reflects the approved settings.

## Blender MCP / CLI strategy

Prefer scripted, reproducible operations:

```text
LLM/agent
→ edit generator/tool code
→ execute in Blender through MCP or CLI
→ render preview
→ inspect result
→ revise code
```

Avoid long sequences of fragile UI-level operations or vertex-by-vertex tool calls. MCP is an execution/inspection bridge; `bpy` code should carry most repeatable construction logic.

## Version-control policy

Commit:

- generator source;
- intentional `.blend` sources for manually authored assets;
- configurations/manifests;
- approved small reference previews when useful;
- runtime `.glb` assets required by the project;
- Godot `<asset>.import` metadata for imported runtime assets;
- authored `.tscn`/`.tres` integration wrappers.

Avoid committing:

- `.godot/` generated cache;
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

At least one family (preferably palms or rocks) should be procedurally generated with several seed variants. At least two assets must expose semantic anchors and be exercised after Godot import.

The experiment succeeds when a second agent can read the catalog/contracts, create a compatible new prop/family, export it, import it into Godot and validate it without inventing a second pipeline.