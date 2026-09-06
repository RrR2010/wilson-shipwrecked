# Blender MCP Agent Workflow

## Purpose

Use this only for **prototype/smoke-test geometry** controlled through an MCP bridge. Production asset review/export mechanics live in `tools/blender/README.md`.

MCP is an execution/inspection bridge. Prefer short, inspectable `bpy` operations over long fragile UI sequences.

## Safety

- operate only inside the intended project/workspace;
- do not run downloaded/unreviewed scripts;
- do not access unrelated files, credentials or user data;
- do not install packages/add-ons unless explicitly requested;
- do not overwrite intentional source/export files without checking them first;
- save a checkpoint before destructive scene-wide prototype operations.

## Required reading

For a smoke-test modeling task:

1. `docs/prototyping/README.md`;
2. `docs/prototyping/blender/BLENDER_PROTOTYPING_GUIDE.md`;
3. the fixture's README/spec;
4. then inspect Blender.

Do not substitute general Blender assumptions for explicit test dimensions/naming.

## Loop

1. **Inspect** Blender version, current file, objects, transforms, materials and target output paths.
2. **Plan** the requested primitive/object mapping.
3. **Construct deterministically** with numeric `bpy` operations and explicit object references.
4. **Normalize** dimensions/origins/transforms only according to the smoke-test spec.
5. **Assign diagnostic materials** only as requested.
6. **Validate** names, count, dimensions, scale, origin and exportable geometry.
7. **Save source** to the fixture's `source/` path.
8. **Export** only requested objects to `exports/`.
9. **Reinspect** the GLB/Godot import when tooling allows.
10. **Report** source, exports, dimensions and deviations.

For production assets, do not extend this smoke workflow. Use:

```text
docs/asset-catalog/
→ docs/ASSET_PIPELINE.md
→ docs/ASSET_SPEC.md
→ docs/art/AGENT_ART_PRODUCTION.md
→ tools/blender/README.md
```

## Forbidden behavior

- beautifying primitives without a test need;
- downloading/replacing requested geometry;
- inventing runtime/domain semantics in Blender;
- modifying production assets while working on smoke fixtures;
- claiming Godot integration passed without actually checking it.
