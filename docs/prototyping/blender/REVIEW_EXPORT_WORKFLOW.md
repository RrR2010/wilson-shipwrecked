# Blender Review / Export Workflow

## Purpose

This document proposes the scripted workflow for asset production in Blender.

The goal is to let a modeling agent work creatively in the current Blender session, while a deterministic script handles the repetitive inspection/export loop.

## Workflow split

### `review_asset.py`

Inputs:

- current open `.blend` session;
- active object or a small selected set;
- optional asset ID / output name.

Responsibilities:

- inspect the active asset and its bounds;
- frame the asset automatically for review;
- render a small canonical set of views;
- save review images into a gitignored temp path;
- optionally assemble a contact sheet or comparison sheet.

Recommended outputs:

```text
temp/blender-review/<asset_id>/<asset_id>_gameplay.png
temp/blender-review/<asset_id>/<asset_id>_front.png
temp/blender-review/<asset_id>/<asset_id>_side.png
temp/blender-review/<asset_id>/<asset_id>_top.png
```

Recommended framing views:

- gameplay 3/4 orthographic;
- front orthographic;
- side orthographic;
- top orthographic.

### `export_asset.py`

Inputs:

- current open `.blend` session;
- active object or selected asset;
- asset ID and destination paths.

Responsibilities:

- normalize origin according to asset class;
- apply only the transforms needed for stable export;
- export runtime `.glb` to `assets/models/`;
- save the source `.blend` to `assets/source/`;
- preserve the live modeling session state.

Recommended outputs:

```text
assets/source/<category>/<asset_id>.blend
assets/models/<category>/<asset_id>.glb
```

## Session model

Both scripts should run against the **current Blender session**.

They should not depend on closing Blender, reopening a file, or rebuilding the scene from scratch. The live scene is the source of truth for what is being reviewed.

That matters because modeling and automation may happen in parallel, and the artist/modeling agent may already have unsaved changes.

## Blender API building blocks

Likely operators / APIs:

- `bpy.ops.view3d.camera_to_view_selected()` for framing the selected asset when a 3D view context is available;
- `bpy.ops.render.render(write_still=True)` for the final still render path;
- `bpy.ops.render.opengl(write_still=True)` when viewport capture is preferable;
- `bpy.ops.object.origin_set(...)` for origin normalization;
- `bpy.ops.export_scene.gltf(...)` for deterministic GLB export.

Operator choice can vary by context, but the scripts should keep the logic short, inspectable and repeatable.

## Visual reference alignment

Review output should be judged against the approved visual references under:

```text
docs/art/reference/visual/
```

Especially:

- `REFERENCE_02_NATURAL_ISLAND_VOCABULARY.png`
- `REFERENCE_03_CAMP_PRIMITIVE_PROPS.png`

The script should make it easy to compare the current asset with these references.
