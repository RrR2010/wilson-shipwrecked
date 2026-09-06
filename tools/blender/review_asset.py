from __future__ import annotations

import argparse
import math
import sys
from pathlib import Path

import bpy
import mathutils

SCRIPT_DIR = Path(__file__).resolve().parent
if str(SCRIPT_DIR) not in sys.path:
    sys.path.insert(0, str(SCRIPT_DIR))

from _workflow_common import (
    argv_after_double_dash,
    create_camera,
    create_light,
    create_plane,
    default_asset_id,
    find_repo_root,
    get_target_object,
    preserved_scene_state,
    remove_temp_datablocks,
    remove_temp_objects,
    world_bounds,
    write_json,
)


def render_view(scene: bpy.types.Scene, camera: bpy.types.Object, output_path: Path) -> None:
    output_path.parent.mkdir(parents=True, exist_ok=True)
    scene.camera = camera
    scene.render.filepath = str(output_path)
    bpy.ops.render.render(write_still=True)


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="Render canonical review views for the active Blender asset.")
    parser.add_argument("--asset-id", default="", help="Asset identifier; defaults to the current blend file stem or active object name.")
    parser.add_argument("--object-name", default="", help="Object name to review; defaults to active/selected object.")
    parser.add_argument("--output-root", default="", help="Override output root; defaults to repo temp/blender-review.")
    parser.add_argument("--resolution-x", type=int, default=1280)
    parser.add_argument("--resolution-y", type=int, default=720)
    return parser


def main() -> dict:
    parser = build_parser()
    args = parser.parse_args(argv_after_double_dash())

    scene = bpy.context.scene
    obj = get_target_object(args.object_name or None)
    bounds = world_bounds([obj])
    center = mathutils.Vector(bounds["center"])
    size = mathutils.Vector(bounds["size"])
    max_dim = max(size.x, size.y, size.z, 0.001)

    asset_id = args.asset_id or default_asset_id()
    repo_root = find_repo_root()
    output_root = Path(args.output_root) if args.output_root else repo_root / "temp" / "blender-review" / asset_id
    output_root.mkdir(parents=True, exist_ok=True)

    with preserved_scene_state(scene):
        scene.render.engine = "BLENDER_EEVEE"
        scene.render.resolution_x = args.resolution_x
        scene.render.resolution_y = args.resolution_y
        scene.render.film_transparent = False
        scene.render.image_settings.file_format = "PNG"

        if scene.world is None:
            world = bpy.data.worlds.new(f"__review_world_{asset_id}")
            world.use_nodes = True
            scene.world = world

        if scene.world and scene.world.use_nodes:
            bg = scene.world.node_tree.nodes.get("Background")
            if bg:
                bg.inputs[0].default_value = (0.80, 0.82, 0.84, 1.0)
                bg.inputs[1].default_value = 0.8

        ground = create_plane(scene, "__review_ground", size=max_dim * 10.0, location=(center.x, center.y, bounds["min"][2]))
        ground_mat = bpy.data.materials.new(name="__review_ground_mat")
        ground_mat.use_nodes = True
        bsdf = ground_mat.node_tree.nodes.get("Principled BSDF")
        if bsdf:
            bsdf.inputs["Base Color"].default_value = (0.66, 0.62, 0.54, 1.0)
            bsdf.inputs["Roughness"].default_value = 1.0
        ground.data.materials.append(ground_mat)

        create_light(scene, "__review_sun", "SUN", (center.x + 4.0, center.y - 4.0, center.z + 6.0), 2.5)
        create_light(scene, "__review_fill", "AREA", (center.x - 4.0, center.y + 4.0, center.z + 4.0), 40.0, size=max_dim * 5.0)

        dist = max_dim * 4.0 + 1.0
        camera_specs = [
            ("gameplay", center + mathutils.Vector((dist, -dist, dist * 0.8)), max_dim * 2.4),
            ("front", center + mathutils.Vector((0.0, -dist, dist * 0.05)), max(size.x, size.z) * 2.2 + 0.25),
            ("side", center + mathutils.Vector((dist, 0.0, dist * 0.05)), max(size.y, size.z) * 2.2 + 0.25),
            ("top", center + mathutils.Vector((0.0, 0.0, dist)), max(size.x, size.y) * 2.2 + 0.25),
        ]

        manifest = {
            "asset_id": asset_id,
            "object_name": obj.name,
            "bounds": bounds,
            "renders": [],
        }

        for suffix, location, ortho_scale in camera_specs:
            camera = create_camera(scene, f"__review_cam_{suffix}", location, center, ortho_scale)
            output_path = output_root / f"{asset_id}_{suffix}.png"
            render_view(scene, camera, output_path)
            manifest["renders"].append({"view": suffix, "path": str(output_path)})

        write_json(output_root / f"{asset_id}_review_manifest.json", manifest)

    remove_temp_objects("__review_")
    remove_temp_datablocks("__review_")
    return manifest


if __name__ == "__main__":
    result = main()
    print(result)
