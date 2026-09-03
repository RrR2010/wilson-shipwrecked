# Prototyping

## Purpose

This area owns **temporary, implementation-facing prototype instructions** used to prove engine, spatial, interaction and presentation contracts before production assets exist.

Prototype content is deliberately simpler than production content. It must preserve the dimensions, pivots, semantic roles and physical distinctions required by a test, but it does not need final topology, texturing, art direction or animation quality.

Prototype documents do not replace:

- `ASSET_SPEC.md` / `ASSET_PIPELINE.md` for production asset contracts;
- `VISUAL_GUIDE.md` / `art/` for final visual direction;
- `asset-catalog/` for the durable object/content backlog;
- source/tests for executable runtime truth.

## Structure

```text
docs/prototyping/
├── README.md
├── blender/
│   ├── BLENDER_PROTOTYPING_GUIDE.md
│   └── MCP_AGENT_WORKFLOW.md
└── smoke-tests/
    └── <smoke-test>/
        ├── README.md
        ├── ASSET_SPEC.md
        └── SCENE_SPEC.md
```

The Blender documents are reusable instructions for local modeling agents. Each smoke-test folder is an incremental work order: read the generic guide first, then only the test-specific documents.

## Repository shape for prototype artifacts

Create prototype artifact directories only when a smoke test actually needs them. Preferred shape:

```text
prototypes/
└── <smoke-test>/
    ├── source/       # intentional .blend source
    ├── exports/      # GLB assets consumed by Godot
    └── godot/        # prototype-only scenes/resources when not better placed in tests
```

Do not create empty directory trees. Do not place prototype objects in the production asset catalog merely because a smoke test needs a box, capsule or marker.

## Prototype authority

A smoke-test specification may intentionally simplify a production object. For example, Wilson may be represented by a capsule and a crate by a box. The prototype geometry proves runtime integration only; it does not redefine the corresponding production asset.

Prefer explicit, inspectable primitives over visual realism. Every added modeling detail must answer: **which contract does this help validate?**

## Agent handoff

A local Blender/Godot agent should receive:

1. this README;
2. the relevant generic tool guide;
3. the smoke test `README.md`;
4. its `ASSET_SPEC.md` or `SCENE_SPEC.md` depending on responsibility.

The agent should not need the entire Wilson design corpus to execute a bounded prototype task.