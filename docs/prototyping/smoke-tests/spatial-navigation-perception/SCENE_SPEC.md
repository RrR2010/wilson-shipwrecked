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