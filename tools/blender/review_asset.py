from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

import bpy
import mathutils

SCRIPT_DIR = Path(__file__).resolve().parent
if str(SCRIPT_DIR) not in sys.path:
    sys.path.insert(0, str(SCRIPT_DIR))

from _workflow_common import (
    argv_after_double_dash,
    camera_direction,
    create_contact_sheet,
    create_material,
    create_review_scene,
    create_scale_mannequin,
    default_asset_id,
    ensure_supported_blender,
    find_repo_root,
    make_view_camera,
    next_iteration_directory,
    remove_review_scene,
    render_scene_still,
    repo_relative,
    resolve_scope,
    validate_asset_id,
    world_bounds,
    write_json,
)
from _workflow_profiles import REVIEW_PROFILES
from build_review_index import build_index


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Render deterministic canonical review views for a Blender asset scope."
    )
    parser.add_argument(
        "--asset-id",
        default="",
        help="Stable asset identifier. Defaults to active object/file stem only for interactive convenience.",
    )
    parser.add_argument(
        "--scope-kind",
        choices=("auto", "object", "hierarchy", "collection"),
        default="auto",
    )
    parser.add_argument(
        "--scope-name",
        default="",
        help="Explicit object/root/collection name. Prefer ASSET_<asset_id> collections for composites.",
    )
    parser.add_argument(
        "--object-name",
        default="",
        help="Backward-compatible alias for a hierarchy root.",
    )
    parser.add_argument(
        "--profile",
        choices=tuple(REVIEW_PROFILES.keys()),
        default="grounded",
    )
    parser.add_argument("--output-root", default="")
    parser.add_argument("--iteration", type=int, default=0)
    parser.add_argument("--resolution-x", type=int, default=1280)
    parser.add_argument("--resolution-y", type=int, default=720)
    parser.add_argument(
        "--include-scale",
        choices=("true", "false"),
        default="true",
        help="Render a gameplay-angle scale comparison with a neutral 1.72 m mannequin.",
    )
    parser.add_argument(
        "--allow-unsupported-blender",
        choices=("true", "false"),
        default="false",
    )
    return parser


def raw_object_bounds(obj: bpy.types.Object) -> dict:
    points = [obj.matrix_world @ mathutils.Vector(corner) for corner in obj.bound_box]
    min_v = mathutils.Vector(
        (
            min(p.x for p in points),
            min(p.y for p in points),
            min(p.z for p in points),
        )
    )
    max_v = mathutils.Vector(
        (
            max(p.x for p in points),
            max(p.y for p in points),
            max(p.z for p in points),
        )
    )
    size = max_v - min_v
    center = (min_v + max_v) / 2.0
    return {
        "min": [float(min_v.x), float(min_v.y), float(min_v.z)],
        "max": [float(max_v.x), float(max_v.y), float(max_v.z)],
        "center": [float(center.x), float(center.y), float(center.z)],
        "size": [float(size.x), float(size.y), float(size.z)],
        "radius": float(max(size.length / 2.0, 0.001)),
    }


def cleanup_review_orphans() -> None:
    orphan_data = []
    for obj in list(bpy.data.objects):
        if not obj.name.startswith("__review_"):
            continue
        if len(obj.users_collection) != 0:
            continue
        orphan_data.append(getattr(obj, "data", None))
        bpy.data.objects.remove(obj, do_unlink=True)

    for datablock in orphan_data:
        if datablock is None or getattr(datablock, "users", 0) != 0:
            continue
        for group in (bpy.data.meshes, bpy.data.cameras, bpy.data.lights):
            try:
                if datablock.name in group:
                    group.remove(datablock)
                    break
            except Exception:
                continue

    for material in list(bpy.data.materials):
        if material.name.startswith("__review_") and material.users == 0:
            bpy.data.materials.remove(material)


def render_normal_views(
    *,
    scene: bpy.types.Scene,
    bounds: dict,
    profile,
    output_dir: Path,
    asset_id: str,
    resolution_x: int,
    resolution_y: int,
) -> tuple[dict[str, Path], bpy.types.Object]:
    scene.render.resolution_x = resolution_x
    scene.render.resolution_y = resolution_y
    scene.render.resolution_percentage = 100
    aspect = resolution_x / max(resolution_y, 1)

    views = {
        "gameplay": camera_direction(45.0, 35.0),
        "front": mathutils.Vector((0.0, 1.0, 0.0)),
        "side": mathutils.Vector((1.0, 0.0, 0.0)),
        "top": mathutils.Vector((0.0, 0.0, 1.0)),
    }

    paths: dict[str, Path] = {}
    gameplay_camera = None
    for name, direction in views.items():
        camera = make_view_camera(
            scene=scene,
            name=f"__review_cam_{asset_id}_{name}",
            bounds=bounds,
            direction=direction,
            aspect=aspect,
            margin=profile.camera_margin,
        )
        path = output_dir / f"{asset_id}_{name}.png"
        render_scene_still(scene, camera, path)
        paths[name] = path
        if name == "gameplay":
            gameplay_camera = camera

    if gameplay_camera is None:
        raise RuntimeError("Gameplay camera was not created.")
    return paths, gameplay_camera


def render_silhouette(
    *,
    scene: bpy.types.Scene,
    gameplay_camera: bpy.types.Object,
    output_dir: Path,
    asset_id: str,
    ground: bpy.types.Object | None,
) -> Path:
    material = create_material(
        f"__review_silhouette_mat_{asset_id}",
        (0.01, 0.01, 0.01, 1.0),
        roughness=1.0,
    )
    view_layer = scene.view_layers[0]
    previous_override = view_layer.material_override
    ground_hidden = ground.hide_render if ground else None

    try:
        view_layer.material_override = material
        if ground:
            ground.hide_render = True
        output_path = output_dir / f"{asset_id}_silhouette.png"
        render_scene_still(scene, gameplay_camera, output_path)
        return output_path
    finally:
        view_layer.material_override = previous_override
        if ground is not None and ground_hidden is not None:
            ground.hide_render = ground_hidden


def render_scale_view(
    *,
    scene: bpy.types.Scene,
    base_bounds: dict,
    profile,
    output_dir: Path,
    asset_id: str,
    resolution_x: int,
    resolution_y: int,
) -> Path:
    min_v = mathutils.Vector(base_bounds["min"])
    max_v = mathutils.Vector(base_bounds["max"])
    size = mathutils.Vector(base_bounds["size"])
    gap = max(size.x * 0.20, 0.30)

    mannequin = create_scale_mannequin(
        scene,
        name=f"__review_mannequin_{asset_id}",
        location=mathutils.Vector(
            (max_v.x + gap + 0.22, float(base_bounds["center"][1]), min_v.z)
        ),
    )

    mannequin_bounds = raw_object_bounds(mannequin)
    combined = {
        "min": [
            min(base_bounds["min"][i], mannequin_bounds["min"][i])
            for i in range(3)
        ],
        "max": [
            max(base_bounds["max"][i], mannequin_bounds["max"][i])
            for i in range(3)
        ],
    }
    combined["center"] = [
        (combined["min"][i] + combined["max"][i]) / 2.0 for i in range(3)
    ]
    combined["size"] = [
        combined["max"][i] - combined["min"][i] for i in range(3)
    ]
    combined["radius"] = mathutils.Vector(combined["size"]).length / 2.0

    aspect = resolution_x / max(resolution_y, 1)
    camera = make_view_camera(
        scene=scene,
        name=f"__review_cam_{asset_id}_scale",
        bounds=combined,
        direction=camera_direction(45.0, 35.0),
        aspect=aspect,
        margin=max(profile.camera_margin, 1.12),
    )
    output_path = output_dir / f"{asset_id}_scale.png"
    render_scene_still(scene, camera, output_path)
    return output_path


def main() -> dict:
    args = build_parser().parse_args(argv_after_double_dash())
    ensure_supported_blender(args.allow_unsupported_blender == "true")

    asset_id = validate_asset_id(args.asset_id or default_asset_id())
    scope = resolve_scope(
        asset_id=asset_id,
        scope_kind=args.scope_kind,
        scope_name=args.scope_name,
        object_name=args.object_name,
        allow_active_fallback=True,
    )
    profile = REVIEW_PROFILES[args.profile]

    repo_root = find_repo_root()
    review_root = (
        Path(args.output_root).resolve()
        if args.output_root
        else repo_root / "temp" / "blender-review"
    )
    asset_root = review_root / asset_id
    iteration, output_dir = next_iteration_directory(asset_root, args.iteration)

    source_scene = bpy.context.scene
    bounds = world_bounds(scope.objects)
    review_scene, temp = create_review_scene(
        source_scene=source_scene,
        scope=scope,
        profile=profile,
        bounds=bounds,
    )
    if temp["ground"] is not None:
        temp["ground"].location.x = float(bounds["center"][0])
        temp["ground"].location.y = float(bounds["center"][1])

    manifest: dict = {
        "asset_id": asset_id,
        "blender_version": bpy.app.version_string,
        "iteration": iteration,
        "review_profile": profile.name,
        "scope": {
            "kind": scope.kind,
            "name": scope.name,
            "objects": scope.object_names,
        },
        "bounds": bounds,
        "renders": {},
        "canonical_view_order": [
            "gameplay",
            "silhouette",
            "scale",
            "front",
            "side",
            "top",
        ],
    }

    try:
        normal_paths, gameplay_camera = render_normal_views(
            scene=review_scene,
            bounds=bounds,
            profile=profile,
            output_dir=output_dir,
            asset_id=asset_id,
            resolution_x=args.resolution_x,
            resolution_y=args.resolution_y,
        )

        silhouette_path = render_silhouette(
            scene=review_scene,
            gameplay_camera=gameplay_camera,
            output_dir=output_dir,
            asset_id=asset_id,
            ground=temp["ground"],
        )

        render_paths = {
            "gameplay": normal_paths["gameplay"],
            "silhouette": silhouette_path,
            "front": normal_paths["front"],
            "side": normal_paths["side"],
            "top": normal_paths["top"],
        }

        if args.include_scale == "true":
            render_paths["scale"] = render_scale_view(
                scene=review_scene,
                base_bounds=bounds,
                profile=profile,
                output_dir=output_dir,
                asset_id=asset_id,
                resolution_x=args.resolution_x,
                resolution_y=args.resolution_y,
            )

        contact_order = [
            key for key in manifest["canonical_view_order"] if key in render_paths
        ]
        contact_paths = [render_paths[key] for key in contact_order]
        contact_sheet = output_dir / f"{asset_id}_review_sheet.png"
        if create_contact_sheet(
            contact_paths, contact_sheet, columns=3, tile_scale=0.5
        ):
            manifest["review_sheet"] = repo_relative(contact_sheet, repo_root)

        manifest["renders"] = {
            key: repo_relative(path, repo_root)
            for key, path in render_paths.items()
        }

    finally:
        remove_review_scene(review_scene)
        cleanup_review_orphans()

    manifest_path = output_dir / f"{asset_id}_review_manifest.json"
    write_json(manifest_path, manifest)
    write_json(
        asset_root / "latest.json",
        {
            "asset_id": asset_id,
            "latest_iteration": iteration,
            "manifest": repo_relative(manifest_path, repo_root),
            "review_sheet": manifest.get("review_sheet", ""),
        },
    )

    try:
        build_index(review_root, repo_root=repo_root)
    except Exception as exc:
        print(f"[WARN] Review index generation failed: {exc}")

    return manifest


if __name__ == "__main__":
    print(json.dumps(main(), indent=2, sort_keys=True))
