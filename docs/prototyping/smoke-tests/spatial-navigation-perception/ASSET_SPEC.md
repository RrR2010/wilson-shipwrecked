# Asset Spec — Spatial / Navigation / Perception Smoke

## Purpose

This file is the exact Blender work order for the first physical engine smoke test. All geometry is diagnostic placeholder content.

## Asset manifest

| Asset | Blender object | Primitive / construction | Dimensions (m) | Origin | Diagnostic material |
|---|---|---|---|---|---|
| ground | `GEO_ground` | low-resolution grid/plane with bounded vertical deformation | 20 x 20 footprint; vertical variation <= ±0.20 | world/reference center | `MAT_ground_green` |
| Wilson placeholder | `GEO_wilson` | capsule-like mesh; cylinder + hemispherical/capsule form is acceptable | 0.60 diameter x 1.80 total height | bottom-center / ground contact | `MAT_wilson_blue` |
| blocking wall | `GEO_wall` | cube/box | 4.00 x 0.50 x 2.00 | bottom-center | `MAT_wall_red` |
| target marker | `GEO_target` | short cylinder | 0.60 diameter x 0.20 height | bottom-center | `MAT_target_yellow` |
| perceptible object | `GEO_perceptible` | cube/box | 0.50 x 0.50 x 0.50 | bottom-center | `MAT_perceptible_orange` |

Dimension ordering for boxes is local X, Y, Z after canonical rotation. Z is vertical.

## Ground construction

The ground must be non-flat enough to reveal obvious grounding/navmesh mistakes but not become a terrain-system test.

Requirements:

- footprint: 20 m x 20 m;
- centered around the scene origin;
- low subdivision, approximately 8–12 segments per horizontal axis;
- deterministic deformation;
- maximum absolute vertex Z displacement: 0.20 m;
- no cliffs, holes, overhangs or disconnected islands;
- boundary vertices may remain near Z=0 to avoid surprising edge geometry.

Do not use a nondeterministic displacement modifier. If using a modifier temporarily, apply/bake it before export and record the parameters/seed.

## Wilson placeholder

This is visible geometry only. The runtime collider will be a Godot `CapsuleShape3D`.

The mesh should make orientation readable without becoming a character model. If a perfectly symmetric capsule makes forward direction impossible to inspect, add **one minimal geometric orientation cue** such as a tiny flattened/front wedge or asymmetry. Keep it part of the same asset and report it. Do not create a face, limbs or character detail.

Origin must be at ground contact so placing the imported mesh at a body's local origin is predictable.

## Wall

The wall is both a navigation obstacle and an LOS occluder in the Godot scene. Blender supplies only the visible red box. Godot supplies the static collider.

No bevel is required. Sharp edges are desirable diagnostically.

## Target marker

The target is a visual destination marker, not an authoritative domain entity requirement. Keep it low and visually distinct from the perceptible object.

## Perceptible object

The orange cube exists to cross Wilson's perception `Area3D` and to be tested both visible and occluded. Do not add semantic anchors or interaction geometry yet.

## Materials

Use flat, clearly distinct colors. Exact RGB values are not a durable contract, but keep the semantic intent:

```text
ground       muted green
Wilson       blue
wall         red
navigation target yellow
perceptible  orange
```

One Principled BSDF material per listed asset category. No textures.

## Source and exports

Save:

```text
prototypes/spatial-navigation-perception/source/spatial_navigation_perception.blend
```

Export:

```text
prototypes/spatial-navigation-perception/exports/ground.glb
prototypes/spatial-navigation-perception/exports/wilson_placeholder.glb
prototypes/spatial-navigation-perception/exports/wall.glb
prototypes/spatial-navigation-perception/exports/target_marker.glb
prototypes/spatial-navigation-perception/exports/perceptible_object.glb
```

Each export should contain only the corresponding visible asset and required material data.

## Completion report

The Blender agent must report a table containing final object name, dimensions, origin rule, scale, rotation state, material and export path, followed by the validation checklist from the generic Blender guide.