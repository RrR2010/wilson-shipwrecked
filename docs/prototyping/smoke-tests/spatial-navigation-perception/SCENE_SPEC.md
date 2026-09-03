# Scene Spec — Spatial / Navigation / Perception Smoke

## Purpose

This is the Godot work order for assembling the first real physics/navigation/perception scene from the Blender prototype assets.

The scene proves engine adapter boundaries. Godot physical facts are infrastructure inputs; they do not become authoritative World truth merely because a collider, navigation agent or raycast reports them.

## Inputs

Consume the GLBs from `prototypes/spatial-navigation-perception/exports/` defined by `ASSET_SPEC.md`.

Do not generate replacement meshes in Godot unless import is being isolated as the failing stage. If a temporary primitive replacement is necessary for debugging, do not treat that as completion of the import smoke.

## Intended composition

Names below describe roles; exact node names may follow existing repository conventions when stronger.

```text
SpatialNavigationPerceptionSmoke (Node3D)
├── Ground (StaticBody3D or navigation-compatible static composition)
│   ├── Visual (imported ground GLB)
│   └── CollisionShape3D / generated simple ground collision
├── NavigationRegion3D
│   └── NavigationMesh
├── Wall (StaticBody3D)
│   ├── Visual (imported wall GLB)
│   └── CollisionShape3D (BoxShape3D ~ 4.0 x 0.5 x 2.0)
├── Wilson (CharacterBody3D)
│   ├── Visual (imported Wilson GLB)
│   ├── CollisionShape3D (CapsuleShape3D matching ~0.6 x 1.8)
│   ├── NavigationAgent3D
│   └── PerceptionArea (Area3D)
│       └── CollisionShape3D (SphereShape3D)
├── TargetMarker (Node3D)
│   └── Visual (imported target GLB)
└── PerceptibleObject (StaticBody3D or Area3D as appropriate)
    ├── Visual (imported perceptible GLB)
    └── CollisionShape3D (BoxShape3D ~0.5 cubed)
```

The navigation region must cover traversable ground and account for the wall as an obstacle using the simplest Godot-supported setup that gives a real valid route. Do not encode a hand-authored waypoint route.

## Initial layout

Use a simple layout with Wilson and target on opposite sides of the wall so the direct line is blocked but a path exists around an end.

Illustrative top view:

```text
          perceptible object
                 O

 W  -------- WALL --------     T

       traversable space
       around both ends
```

Exact coordinates may be chosen during integration, but once validated they should be committed explicitly and kept deterministic. Keep all objects comfortably inside the 20 x 20 m ground.

## Runtime ownership

### Wilson

Use the existing `GodotMotionAdapter` and explicit `RuntimeWorldRef` ↔ scene mapping. Do not make node path/name the domain identity.

Expected physical status progression:

```text
request_move(target)
→ MOVING
→ multiple physics ticks / navigation steering
→ ARRIVED
```

The smoke must demonstrate that passive perception can occur before `ARRIVED`.

### Collision

Use Godot primitive collision resources for Wilson, wall and perceptible object where possible. Blender geometry is not authoritative collision geometry in this smoke.

### Passive perception broadphase

Configure a real `Area3D` around Wilson and connect it through `GodotPassiveSpatialSensor`.

An overlap means only:

```text
candidate entered/leaved broadphase
```

It does **not** mean visible, perceived, dangerous or reconsideration-worthy.

The sensor must map collision objects explicitly to `RuntimeWorldRef`; do not infer identity from node names.

### LOS

Exercise `GodotSpatialQueryAdapter.has_line_of_sight()` against a real physics `direct_space_state` / raycast path.

Prove both cases:

1. no occluder between Wilson and perceptible object → LOS true;
2. wall between them → LOS false.

If Wilson's own collider causes self-hit, fix the adapter/integration with explicit exclusions rather than weakening the assertion.

### Navigation

Exercise the real navigation map used by `GodotMotionAdapter`. At minimum prove:

- map is valid/active;
- target is reachable;
- returned/agent path goes around the wall rather than through it;
- Wilson progresses under physics ticks.

Do not assert an exact path vertex list unless Godot determinism requires a stronger fixture. Prefer route existence, meaningful detour and final arrival.

## Godot 4.7 implementation notes

These notes answer the first implementation pass questions and should be treated as practical diagnostics for this smoke test, not as new domain rules.

### 1. `NavigationAgent3D` placement

`NavigationAgent3D` does **not** need to be a descendant of `NavigationRegion3D`.

For this smoke, the intended structure is correct:

```text
Wilson (CharacterBody3D)
└── NavigationAgent3D

NavigationRegion3D
└── NavigationMesh
```

The important condition is that the agent and the region are assigned to the same navigation map. A normal `NavigationAgent3D` inside the same `World3D` automatically joins that world's default navigation map unless code explicitly assigns a different map.

Diagnostic checks should compare the map used by the scene/agent, not the tree ancestry. Prefer:

```gdscript
var world_map := wilson_body.get_world_3d().get_navigation_map()
```

and, if necessary, inspect the agent RID/map through the server API. Do not reparent Wilson under `NavigationRegion3D` merely to make navigation work.

### 2. Direct `NavigationServer3D` diagnostics

These are appropriate Godot 4.7 diagnostics:

```gdscript
NavigationServer3D.map_get_closest_point(map_rid, position)
NavigationServer3D.map_get_path(map_rid, from, to, true)
```

`NavigationServer3D` is used as the engine singleton in GDScript, so this call style is correct.

Interpret results carefully:

- an empty path usually means the synchronized map has no connected route for the query/layers;
- the first/last path points are snapped to the closest available navigation surface, so a non-empty path does not prove the original endpoints were already on-navmesh;
- `map_get_closest_point()` is especially useful to log endpoint-to-navmesh distance before blaming `NavigationAgent3D`.

**Important:** navigation map/region/agent changes are synchronized by `NavigationServer3D` on a later physics frame. Do not bake/add/configure the region and immediately conclude the map is empty in the same frame. For diagnostics, wait at least one navigation/physics synchronization boundary after the scene enters the tree or after navigation data changes before querying. Two physics frames is acceptable for this smoke when trying to remove initialization ambiguity.

Recommended diagnostic order:

```text
scene enters tree
→ wait physics/navigation synchronization
→ confirm map RID valid
→ log closest nav point for Wilson
→ log closest nav point for target
→ query map_get_path directly
→ only then diagnose NavigationAgent3D path following
```

This separates a bad navmesh/map from an agent-following problem.

### 3. Project settings

There is no required project switch such as `navigation/3d/default_agent_radius` that must be enabled for ordinary `NavigationRegion3D` + `NavigationMesh` pathfinding to function.

For this smoke, the meaningful radius/cell configuration belongs on the **`NavigationMesh` resource used for baking**, particularly:

```text
cell_size
cell_height
agent_radius
agent_height
agent_max_climb
agent_max_slope
```

Do not add speculative global project settings to make the test pass. If a setting is changed, document exactly which engine behavior requires it.

Navigation layers are separate from physics collision layers. Ensure the `NavigationRegion3D.navigation_layers` and `NavigationAgent3D.navigation_layers` overlap; the default layer `1` is sufficient here unless the scene deliberately changed it.

### 4. `cell_size=0.25`, `agent_radius=0.3`, and terrain edges

`agent_radius` erodes the walkable bake away from obstructions/edges. During bake it is rounded **up** to a multiple of `cell_size`. Therefore with:

```text
cell_size   = 0.25 m
agent_radius = 0.30 m
```

the effective rasterized erosion can behave like approximately `0.50 m`, not exactly `0.30 m`.

That does trim the outer navigation boundary. However, on a correctly centered 20 x 20 m ground spanning roughly `-10..+10` in X/Z, Wilson at approximately `(-7, 0, 1)` is about 3 m from the nearest X boundary. He should **not** be outside solely because of a 0.3/0.5 m agent-radius erosion.

If `map_get_closest_point()` reports Wilson far from the navmesh at that position, investigate these before enlarging the ground:

1. actual imported ground transform/scale and global bounds;
2. which geometry the NavigationMesh bake parsed;
3. bake filtering/AABB/source-geometry mode;
4. whether the region contains a baked mesh at all after synchronization;
5. ground slope after deformation versus `agent_max_slope`;
6. vertical offset between query point and baked surface;
7. navigation layers/map mismatch;
8. whether the wall or another parsed source accidentally destroys more bake area than expected.

For this smoke, keeping `cell_size=0.25` is reasonable. An `agent_radius` aligned to the raster, e.g. `0.25` or `0.50`, can make the fixture easier to reason about, but do not change it merely to mask an empty/unsynchronized bake.

### 5. `CharacterBody3D.move_and_slide()` versus sibling `StaticBody3D`

A `CharacterBody3D` can collide normally with a `StaticBody3D` anywhere in the same physics world. Parent/sibling relationships do not create or prevent physics collision.

No special hierarchy is required. The relevant requirements are:

- both bodies are inside the same active `World3D`;
- both have enabled `CollisionShape3D` shapes with valid geometry;
- their transforms actually overlap along the movement path;
- the moving `CharacterBody3D` collision mask includes the `StaticBody3D` collision layer;
- movement is performed through physics (`velocity` + `move_and_slide()`), not by manually teleporting `position/global_position` through the wall.

The default physics configuration places bodies on collision layer `1` with mask `1`, which is sufficient if neither object was changed. For the smoke test, set the intended layer/mask explicitly anyway so the fixture does not depend on editor defaults.

Suggested minimal convention for this scene:

```text
Wilson CharacterBody3D
  collision_layer = 1
  collision_mask  = 1

Ground / Wall StaticBody3D
  collision_layer = 1
  collision_mask  = 1   # mask is not important for being hit by Wilson, but explicit is fine
```

If Wilson still crosses the wall, log `get_slide_collision_count()` after `move_and_slide()` and inspect each collider. A zero count while the visible meshes intersect usually points to collision-shape placement/dimensions/layers rather than navigation.

Also keep visual and collision transforms separate in diagnosis: an imported red wall mesh can look correct while its `BoxShape3D` is offset, rotated incorrectly or sized on the wrong local axes.

### Additional implementation guidance from the first pass

The current first pass already has useful direct NavigationServer diagnostics and working LOS. Preserve those diagnostics while fixing navigation/collision rather than rewriting the scene wholesale.

Prefer this isolation sequence:

```text
A. prove collision without navigation
   Wilson velocity directly toward wall
   → move_and_slide()
   → assert/log slide collision with Wall

B. prove navmesh without movement
   synchronized map
   → closest-point distances small
   → map_get_path() non-empty
   → path has meaningful detour

C. prove NavigationAgent path following
   assign target
   → get_next_path_position()
   → motion over physics ticks

D. combine navigation + collision
   path-following body cannot cross Wall

E. then reconnect passive Area3D + LOS assertions
```

Do not debug all five boundaries simultaneously.

For navigation baking, use the simplest deterministic source geometry possible. If the deformed imported ground makes the first bake ambiguous, it is acceptable to temporarily diagnose with a flat 20 x 20 navigation source while keeping the imported visual ground present. Once navigation mechanics are proven, restore the intended deformed ground as the navigation source and verify it separately. This temporary isolation is not completion of the final smoke.

For LOS, exclude the querying actor's own collider explicitly. If the intended semantic question is "can Wilson see the perceptible object?", decide whether a hit on the target object's own collider counts as successful visibility rather than treating any ray hit as occlusion. The adapter should distinguish **target hit** from **intervening occluder hit**.

## MCP agent workflow

A Godot MCP agent should:

1. inspect project/version and current scene before mutation;
2. inspect existing spatial adapters and current tests;
3. import/verify GLBs;
4. assemble the smallest scene matching this spec;
5. use explicit node/resource properties rather than editor defaults when test-critical;
6. run the scene and inspect runtime state/errors;
7. capture concrete diagnostics for navigation, overlaps and LOS;
8. only then add/adjust executable regression tests;
9. report every deviation from this spec.

Do not let MCP convenience create a second runtime architecture. The scene must consume the existing ports/adapters where applicable.

## Required assertions

The executable smoke should eventually establish, without render-frame-count coupling:

```text
[ ] imported visual scale/orientation is plausible
[ ] real Wilson collider is grounded and does not pass through wall
[ ] real navigation map is valid
[ ] route around wall exists
[ ] Wilson remains MOVING for at least one semantic observation opportunity
[ ] real Area3D overlap updates passive candidate state
[ ] visible candidate passes real LOS
[ ] wall-occluded candidate fails real LOS
[ ] overlap alone does not assert perception
[ ] ordinary passive evidence alone does not force broad reconsideration
[ ] Wilson can ultimately ARRIVE at target
```

## Diagnostics

On failure, expose enough data to distinguish:

- GLB import/transform error;
- collision/layer-mask error;
- navigation map/bake/synchronization error;
- motion steering error;
- Area3D monitoring/layer error;
- RuntimeWorldRef mapping error;
- raycast/self-collision/occluder error;
- semantic bridge/perception integration error.

Avoid a single opaque `smoke failed` assertion.