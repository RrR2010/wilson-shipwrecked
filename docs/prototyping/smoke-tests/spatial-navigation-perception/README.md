# Spatial / Navigation / Perception Smoke Test

## Goal

Build the smallest real Godot 3D scene that exercises the engine-facing contracts already established by the runtime:

1. imported Blender prototype geometry has predictable dimensions/origins;
2. Wilson can be represented by a real `CharacterBody3D` and move through Godot physics;
3. a real navigation map can route around a static obstacle;
4. a real `Area3D` collision volume can produce passive-perception broadphase candidates while Wilson is still moving;
5. real physics raycasts can distinguish clear vs occluded line of sight;
6. these engine facts remain non-authoritative until translated through the existing adapters/application contracts.

This is an **engine integration smoke test**, not a representative gameplay scene and not an art review.

## Required reading

Blender agent:

1. `docs/prototyping/README.md`
2. `docs/prototyping/blender/BLENDER_PROTOTYPING_GUIDE.md`
3. `docs/prototyping/blender/MCP_AGENT_WORKFLOW.md`
4. this file
5. `ASSET_SPEC.md`

Godot agent:

1. `docs/prototyping/README.md`
2. this file
3. `SCENE_SPEC.md`
4. `docs/SIMULATION_ORCHESTRATION.md` sections relevant to engine/domain cadence and perception
5. current spatial adapters/tests

## Non-goals

Do not add:

- final Wilson model/rig/animation;
- final island terrain;
- imported Blender collision meshes;
- procedural vegetation;
- production lighting/camera composition;
- broad gameplay AI;
- new authoritative World position semantics;
- continuous every-frame cognition/perception scans.

## Artifact location

When implementation starts, use:

```text
prototypes/spatial-navigation-perception/
├── source/
│   └── spatial_navigation_perception.blend
├── exports/
│   ├── ground.glb
│   ├── wall.glb
│   ├── wilson_placeholder.glb
│   ├── target_marker.glb
│   └── perceptible_object.glb
└── godot/
    └── spatial_navigation_perception_smoke.tscn
```

If the executable test architecture makes a different Godot scene location materially cleaner, keep source/exports here and document the runtime scene path rather than duplicating it.

## Success criteria

The slice is complete only when executable validation proves the relevant claims. Intended observations:

```text
Wilson starts on one side of a blocking wall
→ target lies on the other side
→ NavigationAgent3D receives a route that goes around the obstacle
→ CharacterBody3D remains MOVING over multiple physics frames
→ perceptible object enters the sensor Area3D while Wilson is MOVING
→ overlap creates only a passive candidate
→ spatial adapter checks metric access + real LOS
→ ordinary visible object can produce evidence without forcing broad reconsideration
→ wall placed between Wilson and object makes LOS false
```

Do not assert exact render-frame counts. Assert semantic ordering/status and engine facts.

## Validation stages

Prefer incremental proof:

1. **Import:** GLBs import with expected scale/orientation.
2. **Physics:** Wilson body and static wall collide as expected.
3. **Navigation:** a valid nav map/path exists around the obstacle.
4. **Broadphase:** real `Area3D` overlap enters/exits for the perceptible object.
5. **LOS:** real physics query returns clear/blocked appropriately.
6. **Adapter integration:** current Godot spatial/motion/passive-perception adapters consume those facts.
7. **Headless regression:** add a stable smoke test if the physics/nav setup is deterministic enough for the strict runner.

If a stage fails, fix that boundary before layering later stages.