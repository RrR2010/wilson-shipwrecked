from __future__ import annotations

import json
import math
import os
import sys
from contextlib import contextmanager
from pathlib import Path

import bpy
import mathutils


def argv_after_double_dash() -> list[str]:
    if "--" in sys.argv:
        return sys.argv[sys.argv.index("--") + 1 :]
    return []


def find_repo_root() -> Path:
    candidates: list[Path] = []

    script_file = globals().get("__file__")
    if script_file:
        candidates.append(Path(script_file).resolve())

    if bpy.data.filepath:
        candidates.append(Path(bpy.data.filepath).resolve())

    candidates.append(Path.cwd().resolve())

    for start in candidates:
        for parent in [start] + list(start.parents):
            if (parent / "docs").is_dir() and (parent / "assets").is_dir():
                return parent

    return Path.cwd().resolve()


def default_asset_id() -> str:
    if bpy.data.filepath:
        stem = Path(bpy.data.filepath).stem
        if stem:
            return stem

    active = bpy.context.active_object
    if active:
        return active.name

    return "asset"


def get_target_object(object_name: str | None = None) -> bpy.types.Object:
    if object_name:
        obj = bpy.data.objects.get(object_name)
        if obj:
            return obj
        raise RuntimeError(f"Object not found: {object_name}")

    selected = list(bpy.context.selected_objects)
    if len(selected) == 1:
        return selected[0]

    active = bpy.context.active_object
    if active:
        return active

    raise RuntimeError("No target object found. Select one object or pass --object-name.")


def ensure_single_user(obj: bpy.types.Object) -> None:
    data = getattr(obj, "data", None)
    if data is not None and getattr(data, "users", 0) > 1:
        obj.data = data.copy()


def world_bounds(objects: list[bpy.types.Object]) -> dict[str, list[float] | float]:
    if not objects:
        raise RuntimeError("No objects provided for bounds calculation.")

    points = []
    for obj in objects:
        if not hasattr(obj, "bound_box"):
            continue
        for corner in obj.bound_box:
            points.append(obj.matrix_world @ mathutils.Vector(corner))

    if not points:
        raise RuntimeError("Unable to compute bounds.")

    min_v = mathutils.Vector((min(p.x for p in points), min(p.y for p in points), min(p.z for p in points)))
    max_v = mathutils.Vector((max(p.x for p in points), max(p.y for p in points), max(p.z for p in points)))
    size = max_v - min_v
    center = (min_v + max_v) / 2.0
    radius = max(size.x, size.y, size.z) / 2.0

    return {
        "min": [min_v.x, min_v.y, min_v.z],
        "max": [max_v.x, max_v.y, max_v.z],
        "center": [center.x, center.y, center.z],
        "size": [size.x, size.y, size.z],
        "radius": radius,
    }


def write_json(path: Path, payload: dict) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(payload, indent=2), encoding="utf-8")


def create_camera(scene: bpy.types.Scene, name: str, location: mathutils.Vector, target: mathutils.Vector, ortho_scale: float) -> bpy.types.Object:
    cam_data = bpy.data.cameras.new(name)
    cam = bpy.data.objects.new(name, cam_data)
    scene.collection.objects.link(cam)
    cam.location = location
    direction = target - location
    cam.rotation_euler = direction.to_track_quat("-Z", "Y").to_euler()
    cam_data.type = "ORTHO"
    cam_data.ortho_scale = ortho_scale
    cam_data.clip_start = 0.01
    cam_data.clip_end = max(1000.0, ortho_scale * 100.0)
    return cam


def create_light(scene: bpy.types.Scene, name: str, light_type: str, location: tuple[float, float, float], energy: float, size: float = 1.0):
    light_data = bpy.data.lights.new(name=name, type=light_type)
    light = bpy.data.objects.new(name, light_data)
    scene.collection.objects.link(light)
    light.location = location
    light_data.energy = energy
    if light_type == "AREA":
        light_data.shape = "SQUARE"
        light_data.size = size
    return light


def create_plane(scene: bpy.types.Scene, name: str, size: float, location: tuple[float, float, float]):
    bpy.ops.mesh.primitive_plane_add(size=size, location=location)
    plane = bpy.context.active_object
    plane.name = name
    plane.data.name = f"{name}_mesh"
    if plane.data and plane.data.materials:
        plane.data.materials.clear()
    return plane


@contextmanager
def preserved_scene_state(scene: bpy.types.Scene):
    state = {
        "camera": scene.camera,
        "engine": scene.render.engine,
        "resolution_x": scene.render.resolution_x,
        "resolution_y": scene.render.resolution_y,
        "film_transparent": scene.render.film_transparent,
        "filepath": scene.render.filepath,
        "image_file_format": scene.render.image_settings.file_format,
        "world": scene.world,
        "world_use_nodes": scene.world.use_nodes if scene.world else None,
    }

    bg_color = None
    bg_strength = None
    if scene.world and scene.world.use_nodes:
        bg = scene.world.node_tree.nodes.get("Background")
        if bg:
            bg_color = tuple(bg.inputs[0].default_value)
            bg_strength = bg.inputs[1].default_value

    try:
        yield
    finally:
        scene.camera = state["camera"]
        scene.render.engine = state["engine"]
        scene.render.resolution_x = state["resolution_x"]
        scene.render.resolution_y = state["resolution_y"]
        scene.render.film_transparent = state["film_transparent"]
        scene.render.filepath = state["filepath"]
        scene.render.image_settings.file_format = state["image_file_format"]
        if scene.world is not state["world"]:
            scene.world = state["world"]
        if scene.world and scene.world.use_nodes and bg_color is not None and bg_strength is not None:
            bg = scene.world.node_tree.nodes.get("Background")
            if bg:
                bg.inputs[0].default_value = bg_color
                bg.inputs[1].default_value = bg_strength


def remove_temp_objects(prefix: str = "__review__") -> None:
    to_remove = [obj for obj in bpy.data.objects if obj.name.startswith(prefix)]
    for obj in to_remove:
        bpy.data.objects.remove(obj, do_unlink=True)


def remove_temp_datablocks(prefix: str = "__review__") -> None:
    datablock_groups = [
        bpy.data.meshes,
        bpy.data.cameras,
        bpy.data.lights,
        bpy.data.materials,
        bpy.data.worlds,
    ]

    for group in datablock_groups:
        for datablock in list(group):
            if datablock.name.startswith(prefix) and datablock.users == 0:
                group.remove(datablock)


def parse_bool(text: str) -> bool:
    return text.lower() in {"1", "true", "yes", "on"}


def move_group_to_origin(obj: bpy.types.Object) -> None:
    if obj.type != "MESH":
        return

    mesh = obj.data
    mesh.update()
    min_x = min(v[0] for v in obj.bound_box)
    max_x = max(v[0] for v in obj.bound_box)
    min_y = min(v[1] for v in obj.bound_box)
    max_y = max(v[1] for v in obj.bound_box)
    min_z = min(v[2] for v in obj.bound_box)
    offset = mathutils.Matrix.Translation((-(min_x + max_x) / 2.0, -(min_y + max_y) / 2.0, -min_z))
    mesh.transform(offset)
    mesh.update()
    obj.location = (0.0, 0.0, 0.0)
    obj.rotation_euler = (0.0, 0.0, 0.0)
    obj.scale = (1.0, 1.0, 1.0)
