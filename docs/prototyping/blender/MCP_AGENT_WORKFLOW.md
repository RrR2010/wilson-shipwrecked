# Blender MCP Agent Workflow

## Purpose

This is a constrained execution workflow for local agents controlling Blender through an MCP bridge. It is intentionally explicit so a smaller model can produce predictable smoke-test geometry without having to infer project-wide art or engine architecture.

MCP is an execution and inspection bridge. Prefer short, inspectable Blender Python (`bpy`) operations for repeatable construction over long sequences of fragile UI actions.

## Safety boundary

Treat MCP-driven Blender scripting as code execution on the local workstation.

- operate only inside the intended project/workspace;
- do not run downloaded/unreviewed scripts;
- do not access unrelated files, credentials or user data;
- do not install packages/add-ons unless the human explicitly requests it;
- do not overwrite an existing `.blend` or export outside the requested prototype path without explicit instruction;
- save checkpoints before destructive scene-wide operations.

## Required reading order

For every smoke-test modeling task:

1. `docs/prototyping/README.md`;
2. `docs/prototyping/blender/BLENDER_PROTOTYPING_GUIDE.md`;
3. the smoke test `README.md`;
4. the smoke test `ASSET_SPEC.md`;
5. only then inspect/change Blender.

Do not substitute general Blender knowledge for explicit project dimensions/naming.

## Execution loop

### 1. Inspect

Before mutation, report or programmatically inspect:

- Blender version;
- current file path;
- scene/collection names;
- existing objects and object types;
- dimensions/transforms of objects that may be reused;
- materials;
- whether the target output paths already exist.

If an existing intentional prototype scene is present, modify it minimally. Do not clear the scene reflexively.

### 2. Plan against the spec

Build a small table before execution:

```text
requested object | primitive | dimensions | origin rule | material | export
```

Every requested object must map to one row. Do not add unrequested decorative objects.

### 3. Construct deterministically

Prefer numeric `bpy` construction:

```python
# Illustrative pattern, not a required literal implementation.
bpy.ops.mesh.primitive_cube_add(location=(0, 0, 0))
obj = bpy.context.object
obj.name = "GEO_wall_a"
obj.dimensions = (4.0, 0.5, 2.0)
# Apply scale after dimensions are established.
```

Use explicit object references after creation. Avoid scripts that depend on whatever happens to be selected several operations later.

For simple repeated assets, a small helper function is preferable to copy/pasted UI operations.

### 4. Normalize transforms and origins

For each object:

1. verify dimensions;
2. establish origin according to the generic guide + smoke spec;
3. establish canonical rotation;
4. apply rotation/scale as required;
5. re-check dimensions, origin and scale.

Do not apply all transforms blindly.

### 5. Assign diagnostic materials

Create/reuse the exact named materials from the smoke spec. Keep material graphs minimal. Do not interpret diagnostic colors as final Wilson art direction.

### 6. Validate inside Blender

Programmatically enumerate final objects and check:

- exact expected names;
- expected count;
- dimensions within a small numeric tolerance;
- scales approximately `(1,1,1)`;
- no negative scales;
- origins consistent with requested placement;
- expected material assignments;
- no unexpected exportable geometry.

Correct mechanical violations before export.

### 7. Save source

Save the intentional `.blend` to the smoke test's `source/` path. Do not treat the exported GLB as the only source artifact.

### 8. Export

Export the exact requested objects to `exports/`. Prefer deterministic scripted export settings. Do not export the whole working scene accidentally.

### 9. Reinspect

When available, re-import into a clean temporary Blender scene or inspect through Godot MCP. Confirm at least:

- file opens/imports;
- object names survive as needed;
- apparent dimensions/orientation are plausible;
- no unintended objects were exported.

### 10. Report

Return a compact manifest:

```text
Blender version:
Source .blend:
Exports:

Object | dimensions | origin | scale | material
...

Validation:
- ...

Deviations / uncertainties:
- none
```

Never silently repair an ambiguity by inventing semantics. Report it.

## Bounded iteration

For smoke assets, stop after mechanical compliance. Do not autonomously iterate for beauty.

A second pass is justified only for a concrete defect such as wrong scale, pivot, export orientation, occlusion shape or runtime readability.

## Forbidden behavior

- adding bevel/detail because the primitive looks too simple;
- replacing requested primitives with downloaded assets;
- generating textures or AI imagery without request;
- authoring collision meshes when Godot primitive collisions are specified;
- changing dimensions to make the composition prettier;
- moving origins for visual convenience;
- creating runtime/domain semantics inside Blender object custom properties unless specified;
- modifying production assets while working on a smoke-test prototype;
- claiming Godot integration passed without actually inspecting/running it.

## Handoff to a Godot agent

The Blender agent's output is geometry plus a manifest. A Godot agent should be able to consume it without asking what the objects mean. The smoke-test `SCENE_SPEC.md` owns runtime node composition, collisions, navigation and perception wiring.