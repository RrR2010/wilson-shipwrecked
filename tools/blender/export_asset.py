from __future__ import annotations

import argparse
import sys
from pathlib import Path

import bpy

SCRIPT_DIR = Path(__file__).resolve().parent
if str(SCRIPT_DIR) not in sys.path:
    sys.path.insert(0, str(SCRIPT_DIR))

from _workflow_common import (
    argv_after_double_dash,
    default_asset_id,
    find_repo_root,
    get_target_object,
    ensure_single_user,
    move_group_to_origin,
    parse_bool,
    remove_temp_datablocks,
    remove_temp_objects,
    write_json,
)


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="Normalize and export the active Blender asset as .blend + .glb.")
    parser.add_argument("--asset-id", default="", help="Asset identifier; defaults to the current blend file stem or active object name.")
    parser.add_argument("--object-name", default="", help="Object name to export; defaults to active/selected object.")
    parser.add_argument("--category", default="props", help="Semantic category subfolder under assets/source and assets/models.")
    parser.add_argument("--purge-scene", default="true", help="Remove non-target objects before saving/exporting (true/false).")
    return parser


def delete_non_targets(target_name: str) -> list[str]:
    removed = []
    for obj in list(bpy.data.objects):
        if obj.name != target_name:
            removed.append(obj.name)
            bpy.data.objects.remove(obj, do_unlink=True)
    return removed


def main() -> dict:
    parser = build_parser()
    args = parser.parse_args(argv_after_double_dash())

    scene = bpy.context.scene
    obj = get_target_object(args.object_name or None)
    asset_id = args.asset_id or default_asset_id()
    repo_root = find_repo_root()
    category = args.category.strip("/\\") or "props"
    source_dir = repo_root / "assets" / "source" / category
    model_dir = repo_root / "assets" / "models" / category
    source_dir.mkdir(parents=True, exist_ok=True)
    model_dir.mkdir(parents=True, exist_ok=True)

    purge_scene = parse_bool(str(args.purge_scene))

    if purge_scene:
        remove_temp_objects("__review_")
        remove_temp_datablocks("__review_")
        delete_non_targets(obj.name)
        obj = bpy.data.objects.get(obj.name)
        if obj is None:
            raise RuntimeError("Target object was removed during scene purge.")

    if obj.type != "MESH":
        raise RuntimeError(f"Export script currently expects a mesh object, got {obj.type}.")

    bpy.ops.object.select_all(action="DESELECT")
    obj.select_set(True)
    bpy.context.view_layer.objects.active = obj
    ensure_single_user(obj)

    # Normalize geometry so the asset rests on the ground with its origin at the bottom center.
    bpy.ops.object.mode_set(mode="OBJECT")
    bpy.ops.object.transform_apply(location=False, rotation=True, scale=True)
    move_group_to_origin(obj)

    source_path = source_dir / f"{asset_id}.blend"
    glb_path = model_dir / f"{asset_id}.glb"

    bpy.ops.wm.save_as_mainfile(filepath=str(source_path), copy=True)

    bpy.ops.object.select_all(action="DESELECT")
    obj.select_set(True)
    bpy.context.view_layer.objects.active = obj

    bpy.ops.export_scene.gltf(
        filepath=str(glb_path),
        use_selection=True,
        export_format="GLB",
        export_apply=True,
        export_materials="EXPORT",
        export_cameras=False,
        export_lights=False,
        export_animations=False,
        export_texcoords=True,
        export_normals=True,
        export_yup=True,
        will_save_settings=False,
        export_image_format="NONE",
    )

    manifest = {
        "asset_id": asset_id,
        "object_name": obj.name,
        "source_blend": str(source_path),
        "export_glb": str(glb_path),
        "object_dimensions": [round(d, 6) for d in obj.dimensions],
        "object_location": [round(c, 6) for c in obj.location],
        "object_scale": [round(c, 6) for c in obj.scale],
        "category": category,
        "purge_scene": purge_scene,
    }

    write_json(source_dir / f"{asset_id}_export_manifest.json", manifest)
    return manifest


if __name__ == "__main__":
    result = main()
    print(result)
