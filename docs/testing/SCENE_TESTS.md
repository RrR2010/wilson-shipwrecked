# Executable Scene Tests

## Purpose

`tests/scenes/` contains small, real-engine Godot fixtures used to validate spatial, physics, navigation, interaction and presentation boundaries that cannot be proven by pure headless domain tests alone.

These fixtures are executable test infrastructure, not gameplay scenes and not a second architecture.

## Repository structure

```text
tests/
├── headless/
│   └── <fixture>_scene_test.gd      # strict-runner wrapper when deterministic
└── scenes/
    └── <fixture>/
        ├── <fixture>.tscn           # real Godot scene
        └── <fixture>.gd             # harness, assertions, diagnostics/checkpoints

prototypes/
└── <fixture>/
    ├── source/                      # optional modeling source
    └── exports/                     # optional visible prototype assets
```

Do not create a separate smoke-test documentation tree for each fixture. The scene harness owns executable expectations; add durable documentation here only when the testing convention itself changes.

## Fixture rules

A scene fixture should:

- exercise existing application/infrastructure adapters instead of bypassing them merely to make the visual demo work;
- keep exact domain/runtime identity explicit through normal mapping boundaries;
- distinguish engine facts from authoritative World truth;
- use simple deterministic geometry/collision/navigation where possible;
- assert semantic outcomes or bounded physical facts, not exact render frames or exact nav path vertices;
- expose enough diagnostics to identify import, physics, navigation, mapping, perception or orchestration failures independently;
- remain launchable as a normal Godot scene for paired visual inspection;
- add a `tests/headless/*_test.gd` wrapper only when the fixture is deterministic enough for the strict runner.

## Manual visual checkpoints

A fixture may pause at named checkpoints for paired debugging. The preferred contract is:

```text
scene runs
→ console prints [SMOKE][PASS]/[SMOKE][FAIL] diagnostics
→ harness emits a named checkpoint
→ overlay explains what should be visible
→ human captures the viewport if useful
→ Space continues
```

Checkpoints are observation aids, not assertions. Headless wrappers must disable checkpoint pauses and consume the same executable harness.

Keep checkpoints sparse. Good examples are:

- initial layout before motion;
- a multi-system event while an actor is moving;
- final arrival/state;
- deliberately occluded/blocked arrangement;
- final PASS/FAIL summary.

## Spatial / navigation / perception fixture

Current fixture:

```text
tests/scenes/spatial_navigation_perception/spatial_navigation_perception.tscn
```

It is intended to prove this chain with real Godot mechanics:

```text
NavigationServer3D + NavigationAgent3D + CharacterBody3D
        ↓
GodotMotionAdapter

Area3D overlap
        ↓
GodotPassiveSpatialSensor
        ↓
PassiveSpatialPerceptionSource

NavigationServer3D / PhysicsDirectSpaceState3D
        ↓
GodotSpatialQueryAdapter
```

The fixture separately probes wall collision, then drives Wilson through the real motion adapter, observes real broadphase evidence while motion is still `MOVING`, reaches `ARRIVED`, and validates both clear and wall-blocked LOS.

Launch it as the current scene in Godot for visual pairing. Its default manual mode pauses at useful checkpoints; press **Space** to continue. The strict wrapper disables pauses automatically.

## Tooling boundary

Local editor/MCP tooling is not part of the game runtime contract. Local plugin state, OpenCode configuration and Godot import caches should remain ignored. Prototype source and intentionally consumed exports may be versioned; generated import state should not be.
