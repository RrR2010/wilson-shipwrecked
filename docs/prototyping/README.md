# Prototyping

## Purpose

This area documents **prototype asset production only**. Prototype assets support executable engine and gameplay tests before production art exists.

Runtime scene composition, assertions and visual checkpoints do not live here. They live under `tests/scenes/` so executable test code is the integration truth.

Prototype content may simplify production objects while preserving dimensions, pivots and semantic readability required by a test. It does not redefine production asset requirements.

Prototype documents do not replace:

- `ASSET_SPEC.md` / `ASSET_PIPELINE.md` for production asset contracts;
- `VISUAL_GUIDE.md` / `art/` for final visual direction;
- `asset-catalog/` for the durable object/content backlog;
- `tests/scenes/` and `tests/headless/` for executable runtime truth.

## Structure

```text
docs/prototyping/
├── README.md
└── blender/
    ├── BLENDER_PROTOTYPING_GUIDE.md
    └── MCP_AGENT_WORKFLOW.md
```

The Blender documents are reusable instructions for a local modeling agent. Keep that agent constrained to visible geometry/source/export work; Godot interpretation and runtime semantics stay in repository-owned scenes/scripts.

## Repository shape for prototype assets

```text
prototypes/
└── <fixture-name>/
    ├── source/       # intentional modeling source such as .blend
    └── exports/      # GLB assets consumed by executable scenes
```

Executable scenes belong in:

```text
tests/scenes/<fixture-name>/
```

A stable automated wrapper may additionally live in:

```text
tests/headless/<fixture-name>_scene_test.gd
```

Do not create a parallel `godot/` subtree under each prototype. This avoids splitting scene authority between prototype work orders and the test suite.

## Prototype authority

A prototype may intentionally represent Wilson as a capsule, a wall as a box or an object as a simple colored primitive. Those choices prove integration only.

Prefer explicit, inspectable geometry over visual realism. Every added modeling detail should support a concrete test or readability requirement.

## Modeling handoff

A local modeling agent should receive:

1. this README;
2. `blender/BLENDER_PROTOTYPING_GUIDE.md`;
3. `blender/MCP_AGENT_WORKFLOW.md` when MCP is used;
4. a compact object manifest supplied by the human/implementing agent.

The modeling agent should return source geometry plus exports. It should not author navigation, collision semantics, runtime identity, perception logic or test assertions.
