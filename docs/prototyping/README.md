# Prototyping

## Purpose

This area documents **prototype asset production only**. Prototype assets support executable engine and gameplay tests before production art exists.

Runtime scene composition, assertions and visual checkpoints live under `tests/scenes/`. Prototype content may simplify production objects while preserving dimensions, pivots and semantic readability required by a test. It does not redefine production asset requirements.

Prototype documents do not replace:

- `ASSET_SPEC.md` / `ASSET_PIPELINE.md` for production asset contracts;
- `VISUAL_GUIDE.md` / `art/` for final visual direction;
- `asset-catalog/` for the durable content backlog;
- `tools/blender/README.md` for production Blender review/validation/export automation;
- `tests/scenes/` / `tests/headless/` for executable runtime truth.

## Structure

```text
docs/prototyping/
├── README.md
└── blender/
    ├── BLENDER_PROTOTYPING_GUIDE.md
    └── MCP_AGENT_WORKFLOW.md
```

The Blender documents here are for local smoke-test modeling. Production modeling agents should use the asset catalog + production contracts instead.

## Repository shape for prototype assets

```text
prototypes/
└── <fixture-name>/
    ├── source/
    └── exports/
```

Production source ownership is different and chosen explicitly:

```text
independent manual asset
→ one .blend per asset

shared authored family/rig/stages
→ one family .blend + multiple AssetScopes

procedural family
→ generator/config is source; optional one workbench .blend
```

See `../ASSET_PIPELINE.md`, `../ASSET_SPEC.md`, `../../assets/README.md` and `../../tools/blender/README.md`.

Executable scenes belong in `tests/scenes/<fixture-name>/`; stable automated wrappers may live in `tests/headless/`.

Do not create a parallel `godot/` subtree under each prototype.

## Prototype authority

A prototype may intentionally represent Wilson as a capsule, a wall as a box or an object as a simple colored primitive. Those choices prove integration only.

Prefer explicit, inspectable geometry over visual realism. Every added modeling detail should support a concrete test or readability requirement.

## Modeling handoff

A local **prototype** modeling agent should receive:

1. this README;
2. `blender/BLENDER_PROTOTYPING_GUIDE.md`;
3. `blender/MCP_AGENT_WORKFLOW.md` when MCP is used;
4. a compact object manifest supplied by the implementing agent.

A production modeling agent should instead start from the asset catalog and production contracts, then use `tools/blender/README.md`.

The prototype modeling agent returns source geometry plus exports. It does not author navigation, collision semantics, runtime identity, perception logic or test assertions.
