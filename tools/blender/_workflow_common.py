from __future__ import annotations

import json
import math
import re
import sys
from contextlib import contextmanager
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable

import bpy
import mathutils

SCRIPT_DIR = Path(__file__).resolve().parent
if str(SCRIPT_DIR) not in sys.path:
    sys.path.insert(0, str(SCRIPT_DIR))

from _workflow_profiles import (
    ALLOWED_TOP_CATEGORIES,
    EXPORT_PROFILES,
    SUPPORTED_BLENDER_SERIES,
)


RENDERABLE_TYPES = frozenset({"MESH", "CURVE", "SURFACE", "META", "FONT"})
SEMANTIC_PREFIXES = ("ANCHOR_", "SOCKET_")


@dataclass(frozen=True)
class AssetScope:
    kind: str
    name: str
    objects: tuple[bpy.types.Object, ...]

    @property
    def object_names(self) -> list[str]:
        return [obj.name for obj in self.objects]


@dataclass
class ValidationResult:
    errors: list[str]
    warnings: list[str]

    @property
    def ok(self) -> bool:
        return not self.errors

    def as_dict(self) -> dict:
        return {
            "ok": self.ok,
            "errors": list(self.errors),
            "warnings": list(self.warnings),
        }


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
        seed = start if start.is_dir() else start.parent
        for parent in [seed] + list(seed.parents):
            if (
                (parent / "project.godot").is_file()
                and (parent / "docs").is_dir()
                and (parent / "assets").is_dir()
            ):
                return parent

    raise RuntimeError(
        "Unable to locate repository root containing project.godot, docs/, and assets/."
    )


def repo_relative(path: Path, repo_root: Path) -> str:
    try:
        return path.resolve().relative_to(repo_root.resolve()).as_posix()
    except ValueError:
        return path.resolve().as_posix()


def write_json(path: Path, payload: dict) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(payload, indent=2, sort_keys=True), encoding="utf-8")


def parse_bool(text: str) -> bool:
    return str(text).strip().lower() in {"1", "true", "yes", "on"}


def ensure_supported_blender(allow_unsupported: bool = False) -> None:
    current = tuple(bpy.app.version[:2])
    if current == SUPPORTED_BLENDER_SERIES:
        return
    message = (
        f"Production scripts target Blender {SUPPORTED_BLENDER_SERIES[0]}."
        f"{SUPPORTED_BLENDER_SERIES[1]} LTS; current Blender is {bpy.app.version_string}."
    )
    if allow_unsupported:
        print(f"[WARN] {message} Continuing because override was explicitly enabled.")
        return
    raise RuntimeError(message)


def validate_asset_id(asset_id: str) -> str:
    value = asset_id.strip()
    if not value:
        raise RuntimeError("asset_id must not be empty.")
    if not re.fullmatch(r"[A-Za-z0-9][A-Za-z0-9_.-]*", value):
        raise RuntimeError(
            f"Invalid asset_id '{value}'. Use stable alphanumeric IDs with '.', '_' or '-'."
        )
    return value


def normalize_category(category: str) -> str:
    value = category.replace("\\", "/").strip("/")
    path = Path(value)
    if not value or path.is_absolute() or any(
        part in {"", ".", ".."} for part in path.parts
    ):
        raise RuntimeError(f"Invalid asset category path: {category!r}")
    if path.parts[0] not in ALLOWED_TOP_CATEGORIES:
        allowed = ", ".join(sorted(ALLOWED_TOP_CATEGORIES))
        raise RuntimeError(
            f"Asset category '{value}' must start with one of: {allowed}."
        )
    return "/".join(path.parts)


def default_asset_id() -> str:
    active = bpy.context.active_object
    if active and active.name:
        return active.name
    if bpy.data.filepath:
        stem = Path(bpy.data.filepath).stem
        if stem:
            return stem
    return "asset"


def _hierarchy_objects(root: bpy.types.Object) -> list[bpy.types.Object]:
    result = [root]
    queue = list(root.children)
    while queue:
        obj = queue.pop(0)
        result.append(obj)
        queue.extend(list(obj.children))
    return result


def resolve_scope(
    *,
    asset_id: str,
    scope_kind: str = "auto",
    scope_name: str = "",
    object_name: str = "",
    allow_active_fallback: bool = True,
) -> AssetScope:
    kind = scope_kind.strip().lower()
    name = scope_name.strip()

    if object_name and not name:
        name = object_name
        if kind == "auto":
            kind = "hierarchy"

    if kind == "auto":
        candidates: list[tuple[str, str]] = []
        if name:
            if bpy.data.collections.get(name):
                candidates.append(("collection", name))
            if bpy.data.objects.get(name):
                candidates.append(("hierarchy", name))
        else:
            preferred_collection = f"ASSET_{asset_id}"
            if bpy.data.collections.get(preferred_collection):
                candidates.append(("collection", preferred_collection))
            if bpy.data.objects.get(asset_id):
                candidates.append(("hierarchy", asset_id))

        if candidates:
            kind, name = candidates[0]
        elif allow_active_fallback and bpy.context.active_object:
            kind = "hierarchy"
            name = bpy.context.active_object.name
            print(
                f"[WARN] Scope resolved from active object '{name}'. "
                "Use --scope-name or ASSET_<asset_id> for deterministic production calls."
            )
        else:
            raise RuntimeError(
                "Unable to resolve asset scope. Use --scope-kind/--scope-name or create "
                f"collection ASSET_{asset_id}."
            )

    if kind == "collection":
        if not name:
            name = f"ASSET_{asset_id}"
        collection = bpy.data.collections.get(name)
        if collection is None:
            raise RuntimeError(f"Asset collection not found: {name}")
        objects = list(collection.all_objects)

    elif kind == "hierarchy":
        if not name:
            name = asset_id
        root = bpy.data.objects.get(name)
        if root is None:
            raise RuntimeError(f"Asset hierarchy root not found: {name}")
        objects = _hierarchy_objects(root)

    elif kind == "object":
        if not name:
            name = asset_id
        obj = bpy.data.objects.get(name)
        if obj is None:
            raise RuntimeError(f"Asset object not found: {name}")
        objects = [obj]

    else:
        raise RuntimeError(
            "scope_kind must be one of: auto, object, hierarchy, collection"
        )

    objects = sorted(set(objects), key=lambda item: item.name_full)
    if not objects:
        raise RuntimeError(f"Resolved scope '{name}' contains no objects.")

    return AssetScope(kind=kind, name=name, objects=tuple(objects))


def scope_renderables(scope: AssetScope) -> list[bpy.types.Object]:
    return [obj for obj in scope.objects if obj.type in RENDERABLE_TYPES]


def scope_roots(scope: AssetScope) -> list[bpy.types.Object]:
    member_ids = {id(obj) for obj in scope.objects}
    return [
        obj
        for obj in scope.objects
        if obj.parent is None or id(obj.parent) not in member_ids
    ]


def object_has_shape_keys(obj: bpy.types.Object) -> bool:
    if obj.type != "MESH" or obj.data is None:
        return False
    shape_keys = getattr(obj.data, "shape_keys", None)
    return bool(shape_keys and len(shape_keys.key_blocks) > 1)


def world_bounds(objects: Iterable[bpy.types.Object]) -> dict[str, list[float] | float]:
    depsgraph = bpy.context.evaluated_depsgraph_get()
    points: list[mathutils.Vector] = []

    for original in objects:
        if original.type not in RENDERABLE_TYPES:
            continue
        obj = original.evaluated_get(depsgraph)
        if not hasattr(obj, "bound_box"):
            continue
        for corner in obj.bound_box:
            points.append(obj.matrix_world @ mathutils.Vector(corner))

    if not points:
        raise RuntimeError(
            "Unable to compute bounds: scope has no renderable geometry."
        )

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
    radius = max(size.length / 2.0, 0.001)

    return {
        "min": [float(min_v.x), float(min_v.y), float(min_v.z)],
        "max": [float(max_v.x), float(max_v.y), float(max_v.z)],
        "center": [float(center.x), float(center.y), float(center.z)],
        "size": [float(size.x), float(size.y), float(size.z)],
        "radius": float(radius),
    }


def bounds_corners(bounds: dict[str, list[float] | float]) -> list[mathutils.Vector]:
    min_v = mathutils.Vector(bounds["min"])
    max_v = mathutils.Vector(bounds["max"])
    return [
        mathutils.Vector((x, y, z))
        for x in (min_v.x, max_v.x)
        for y in (min_v.y, max_v.y)
        for z in (min_v.z, max_v.z)
    ]


def look_at(obj: bpy.types.Object, target: mathutils.Vector) -> None:
    direction = target - obj.location
    if direction.length <= 1e-9:
        return
    obj.rotation_euler = direction.to_track_quat("-Z", "Y").to_euler()


def create_camera(
    scene: bpy.types.Scene,
    name: str,
    location: mathutils.Vector,
    target: mathutils.Vector,
) -> bpy.types.Object:
    cam_data = bpy.data.cameras.new(name)
    cam = bpy.data.objects.new(name, cam_data)
    scene.collection.objects.link(cam)
    cam.location = location
    look_at(cam, target)
    cam_data.type = "ORTHO"
    cam_data.clip_start = 0.01
    cam_data.clip_end = max(1000.0, location.length * 100.0)
    return cam


def fit_orthographic_camera(
    camera: bpy.types.Object,
    bounds: dict[str, list[float] | float],
    aspect: float,
    margin: float,
) -> float:
    inv = camera.matrix_world.inverted()
    local = [inv @ point for point in bounds_corners(bounds)]
    width = max(p.x for p in local) - min(p.x for p in local)
    height = max(p.y for p in local) - min(p.y for p in local)
    required_vertical = max(height, width / max(aspect, 1e-6), 0.001)
    scale = required_vertical * margin
    camera.data.ortho_scale = scale
    return scale


def camera_direction(
    azimuth_degrees: float, elevation_degrees: float
) -> mathutils.Vector:
    az = math.radians(azimuth_degrees)
    el = math.radians(elevation_degrees)
    horizontal = math.cos(el)
    return mathutils.Vector(
        (
            math.sin(az) * horizontal,
            math.cos(az) * horizontal,
            math.sin(el),
        )
    ).normalized()


def create_light(
    scene: bpy.types.Scene,
    *,
    name: str,
    light_type: str,
    location: mathutils.Vector,
    target: mathutils.Vector,
    energy: float,
    size: float = 1.0,
    angle_radians: float = 0.0,
) -> bpy.types.Object:
    light_data = bpy.data.lights.new(name=name, type=light_type)
    light = bpy.data.objects.new(name, light_data)
    scene.collection.objects.link(light)
    light.location = location
    light_data.energy = energy

    if light_type == "AREA":
        light_data.shape = "SQUARE"
        light_data.size = size
        look_at(light, target)
    elif light_type == "SUN":
        light_data.angle = angle_radians
        look_at(light, target)
    return light


def create_material(
    name: str,
    base_color: tuple[float, float, float, float],
    roughness: float = 1.0,
) -> bpy.types.Material:
    material = bpy.data.materials.new(name=name)
    material.use_nodes = True
    bsdf = material.node_tree.nodes.get("Principled BSDF")
    if bsdf:
        bsdf.inputs["Base Color"].default_value = base_color
        bsdf.inputs["Roughness"].default_value = roughness
        if "Metallic" in bsdf.inputs:
            bsdf.inputs["Metallic"].default_value = 0.0
    return material


def create_plane(
    scene: bpy.types.Scene,
    *,
    name: str,
    size: float,
    z: float,
    material: bpy.types.Material,
) -> bpy.types.Object:
    half = size / 2.0
    vertices = [
        (-half, -half, 0.0),
        (half, -half, 0.0),
        (half, half, 0.0),
        (-half, half, 0.0),
    ]
    faces = [(0, 1, 2, 3)]
    mesh = bpy.data.meshes.new(f"{name}_mesh")
    mesh.from_pydata(vertices, [], faces)
    mesh.update()
    obj = bpy.data.objects.new(name, mesh)
    scene.collection.objects.link(obj)
    obj.location.z = z
    obj.data.materials.append(material)
    return obj


def _append_box(
    vertices: list[tuple[float, float, float]],
    faces: list[tuple[int, int, int, int]],
    center: tuple[float, float, float],
    size: tuple[float, float, float],
) -> None:
    cx, cy, cz = center
    sx, sy, sz = (value / 2.0 for value in size)
    start = len(vertices)
    vertices.extend(
        [
            (cx - sx, cy - sy, cz - sz),
            (cx + sx, cy - sy, cz - sz),
            (cx + sx, cy + sy, cz - sz),
            (cx - sx, cy + sy, cz - sz),
            (cx - sx, cy - sy, cz + sz),
            (cx + sx, cy - sy, cz + sz),
            (cx + sx, cy + sy, cz + sz),
            (cx - sx, cy + sy, cz + sz),
        ]
    )
    faces.extend(
        [
            (start + 0, start + 1, start + 2, start + 3),
            (start + 4, start + 7, start + 6, start + 5),
            (start + 0, start + 4, start + 5, start + 1),
            (start + 1, start + 5, start + 6, start + 2),
            (start + 2, start + 6, start + 7, start + 3),
            (start + 4, start + 0, start + 3, start + 7),
        ]
    )


def create_scale_mannequin(
    scene: bpy.types.Scene,
    *,
    name: str,
    location: mathutils.Vector,
) -> bpy.types.Object:
    vertices: list[tuple[float, float, float]] = []
    faces: list[tuple[int, int, int, int]] = []

    for center, size in [
        ((-0.11, 0.0, 0.43), (0.15, 0.20, 0.86)),
        ((0.11, 0.0, 0.43), (0.15, 0.20, 0.86)),
        ((0.0, 0.0, 1.11), (0.42, 0.24, 0.56)),
        ((-0.31, 0.0, 1.09), (0.13, 0.17, 0.62)),
        ((0.31, 0.0, 1.09), (0.13, 0.17, 0.62)),
        ((0.0, 0.0, 1.55), (0.29, 0.27, 0.34)),
    ]:
        _append_box(vertices, faces, center, size)

    mesh = bpy.data.meshes.new(f"{name}_mesh")
    mesh.from_pydata(vertices, [], faces)
    mesh.update()
    obj = bpy.data.objects.new(name, mesh)
    scene.collection.objects.link(obj)
    obj.location = location
    material = create_material(
        f"{name}_mat",
        (0.42, 0.44, 0.46, 1.0),
        roughness=0.95,
    )
    obj.data.materials.append(material)
    return obj


def create_review_scene(
    *,
    source_scene: bpy.types.Scene,
    scope: AssetScope,
    profile,
    bounds: dict[str, list[float] | float],
) -> tuple[bpy.types.Scene, dict[str, bpy.types.Object | None]]:
    scene = bpy.data.scenes.new(f"__review_scene_{scope.name}")
    scene.frame_set(source_scene.frame_current)

    for obj in scope.objects:
        if obj.name not in scene.objects:
            scene.collection.objects.link(obj)

    scene.render.engine = "BLENDER_EEVEE"
    scene.render.film_transparent = False
    scene.render.image_settings.file_format = "PNG"
    scene.render.image_settings.color_mode = "RGB"
    scene.render.image_settings.color_depth = "8"

    try:
        scene.view_settings.view_transform = "AgX"
    except Exception:
        pass
    scene.view_settings.exposure = 0.0
    scene.view_settings.gamma = 1.0

    world = bpy.data.worlds.new(f"__review_world_{scope.name}")
    world.use_nodes = True
    bg = world.node_tree.nodes.get("Background")
    if bg:
        bg.inputs[0].default_value = profile.background_color
        bg.inputs[1].default_value = profile.background_strength
    scene.world = world

    center = mathutils.Vector(bounds["center"])
    size = mathutils.Vector(bounds["size"])
    max_dim = max(size.x, size.y, size.z, 0.10)
    ground = None

    if profile.ground:
        ground_material = create_material(
            f"__review_ground_mat_{scope.name}",
            profile.ground_color,
            roughness=1.0,
        )
        ground = create_plane(
            scene,
            name=f"__review_ground_{scope.name}",
            size=max(max(size.x, size.y) * 6.0, max_dim * 5.0, 4.0),
            z=float(bounds["min"][2]),
            material=ground_material,
        )

    key_dir = mathutils.Vector((4.0, 3.0, 6.0)).normalized()
    key_location = center + key_dir * max_dim * 6.0
    key = create_light(
        scene,
        name=f"__review_key_{scope.name}",
        light_type="SUN",
        location=key_location,
        target=center,
        energy=profile.key_energy,
        angle_radians=math.radians(profile.key_angle_degrees),
    )

    fill_location = (
        center
        + mathutils.Vector((-4.0, 1.5, 3.0)).normalized() * max_dim * 5.0
    )
    fill = create_light(
        scene,
        name=f"__review_fill_{scope.name}",
        light_type="AREA",
        location=fill_location,
        target=center,
        energy=profile.fill_energy_per_square_meter * (max_dim**2),
        size=max_dim * profile.fill_size_factor,
    )

    rim = None
    if profile.rim_light:
        rim_location = (
            center
            + mathutils.Vector((-2.0, -4.0, 4.5)).normalized() * max_dim * 5.0
        )
        rim = create_light(
            scene,
            name=f"__review_rim_{scope.name}",
            light_type="AREA",
            location=rim_location,
            target=center,
            energy=profile.rim_energy_per_square_meter * (max_dim**2),
            size=max_dim * 3.5,
        )

    return scene, {
        "ground": ground,
        "key": key,
        "fill": fill,
        "rim": rim,
    }


def make_view_camera(
    *,
    scene: bpy.types.Scene,
    name: str,
    bounds: dict[str, list[float] | float],
    direction: mathutils.Vector,
    aspect: float,
    margin: float,
) -> bpy.types.Object:
    center = mathutils.Vector(bounds["center"])
    radius = float(bounds["radius"])
    distance = max(radius * 8.0, 4.0)
    location = center + direction.normalized() * distance
    camera = create_camera(scene, name, location, center)
    fit_orthographic_camera(camera, bounds, aspect, margin)
    return camera


def render_scene_still(
    scene: bpy.types.Scene,
    camera: bpy.types.Object,
    output_path: Path,
) -> None:
    output_path.parent.mkdir(parents=True, exist_ok=True)
    scene.camera = camera
    scene.render.filepath = str(output_path)
    bpy.ops.render.render(write_still=True, scene=scene.name)


def remove_datablock_if_unused(datablock) -> None:
    if datablock is None or getattr(datablock, "users", 0) != 0:
        return
    for group in (
        bpy.data.meshes,
        bpy.data.cameras,
        bpy.data.lights,
        bpy.data.materials,
        bpy.data.worlds,
    ):
        try:
            if datablock.name in group:
                group.remove(datablock)
                return
        except Exception:
            continue


def remove_review_scene(scene: bpy.types.Scene) -> None:
    temp_data = []
    for obj in list(scene.objects):
        if obj.name.startswith("__review_"):
            temp_data.append(getattr(obj, "data", None))
    world = scene.world
    bpy.data.scenes.remove(scene)

    for datablock in temp_data:
        remove_datablock_if_unused(datablock)
    remove_datablock_if_unused(world)

    for material in list(bpy.data.materials):
        if material.name.startswith("__review_") and material.users == 0:
            bpy.data.materials.remove(material)


def next_iteration_directory(
    asset_root: Path, requested: int = 0
) -> tuple[int, Path]:
    asset_root.mkdir(parents=True, exist_ok=True)
    if requested > 0:
        iteration = requested
    else:
        existing = []
        for child in asset_root.iterdir():
            match = re.fullmatch(r"iter_(\d+)", child.name)
            if child.is_dir() and match:
                existing.append(int(match.group(1)))
        iteration = max(existing, default=0) + 1

    directory = asset_root / f"iter_{iteration:02d}"
    directory.mkdir(parents=True, exist_ok=True)
    return iteration, directory


def create_contact_sheet(
    image_paths: list[Path],
    output_path: Path,
    *,
    columns: int = 3,
    tile_scale: float = 0.5,
) -> bool:
    if not image_paths:
        return False
    try:
        import numpy as np
    except Exception as exc:
        print(f"[WARN] Contact sheet skipped because NumPy is unavailable: {exc}")
        return False

    loaded: list[bpy.types.Image] = []
    try:
        arrays = []
        target_width = None
        target_height = None

        for path in image_paths:
            image = bpy.data.images.load(str(path), check_existing=False)
            loaded.append(image)
            width = max(1, int(image.size[0] * tile_scale))
            height = max(1, int(image.size[1] * tile_scale))
            image.scale(width, height)

            data = np.empty(width * height * 4, dtype=np.float32)
            image.pixels.foreach_get(data)
            arrays.append(data.reshape((height, width, 4)))
            target_width = width
            target_height = height

        if target_width is None or target_height is None:
            return False

        rows = math.ceil(len(arrays) / columns)
        canvas = np.ones(
            (rows * target_height, columns * target_width, 4),
            dtype=np.float32,
        )
        canvas[:, :, :3] *= 0.12

        for index, data in enumerate(arrays):
            row = rows - 1 - (index // columns)
            col = index % columns
            y0 = row * target_height
            x0 = col * target_width
            canvas[
                y0 : y0 + target_height,
                x0 : x0 + target_width,
                :,
            ] = data

        sheet = bpy.data.images.new(
            "__review_contact_sheet",
            width=columns * target_width,
            height=rows * target_height,
            alpha=True,
        )
        sheet.pixels.foreach_set(canvas.ravel())
        sheet.filepath_raw = str(output_path)
        sheet.file_format = "PNG"
        sheet.save()
        bpy.data.images.remove(sheet)
        return True

    except Exception as exc:
        print(f"[WARN] Contact sheet generation failed: {exc}")
        return False
    finally:
        for image in loaded:
            if image.name in bpy.data.images:
                bpy.data.images.remove(image)


@contextmanager
def preserved_selection_state():
    view_layer = bpy.context.view_layer
    active = view_layer.objects.active
    selected = list(bpy.context.selected_objects)
    try:
        yield
    finally:
        try:
            bpy.ops.object.select_all(action="DESELECT")
        except Exception:
            pass
        for obj in selected:
            if obj.name in bpy.data.objects:
                obj.select_set(True)
        if active and active.name in bpy.data.objects:
            view_layer.objects.active = bpy.data.objects[active.name]


def select_scope(scope: AssetScope) -> None:
    if bpy.context.mode != "OBJECT":
        raise RuntimeError(
            f"Export requires OBJECT mode; current mode is {bpy.context.mode}. "
            "Finish/exit the edit/pose operation before export."
        )
    bpy.ops.object.select_all(action="DESELECT")
    for obj in scope.objects:
        if obj.name in bpy.context.view_layer.objects:
            obj.select_set(True)
    if not bpy.context.selected_objects:
        raise RuntimeError(
            "Resolved scope is not present in the active View Layer; cannot export deterministically."
        )
    bpy.context.view_layer.objects.active = bpy.context.selected_objects[0]


def validate_scope_for_export(
    scope: AssetScope, profile_name: str
) -> ValidationResult:
    if profile_name not in EXPORT_PROFILES:
        raise RuntimeError(f"Unknown export profile: {profile_name}")
    profile = EXPORT_PROFILES[profile_name]
    errors: list[str] = []
    warnings: list[str] = []

    renderables = scope_renderables(scope)
    if not renderables:
        errors.append("Scope contains no renderable geometry.")

    armatures = [obj for obj in scope.objects if obj.type == "ARMATURE"]
    shape_key_objects = [obj for obj in scope.objects if object_has_shape_keys(obj)]

    if profile.require_armature and not armatures:
        errors.append(f"Export profile '{profile_name}' requires an armature.")
    if profile.forbid_armature and armatures:
        errors.append(
            f"Export profile '{profile_name}' forbids armatures; found: "
            + ", ".join(obj.name for obj in armatures)
        )
    if profile.forbid_shape_keys and shape_key_objects:
        errors.append(
            f"Export profile '{profile_name}' applies modifiers and cannot safely export "
            "shape keys; found: "
            + ", ".join(obj.name for obj in shape_key_objects)
        )

    unsupported = [
        obj for obj in scope.objects if obj.type in {"CAMERA", "LIGHT", "SPEAKER"}
    ]
    if unsupported:
        errors.append(
            "Asset scope contains presentation-only object types that should not be part "
            "of runtime scope: "
            + ", ".join(f"{obj.name}({obj.type})" for obj in unsupported)
        )

    for obj in scope.objects:
        if obj.name.startswith("__review_"):
            errors.append(f"Temporary review object leaked into asset scope: {obj.name}")
        if any(value < 0.0 for value in obj.scale):
            errors.append(
                f"Negative scale is not allowed for production export: "
                f"{obj.name} {tuple(obj.scale)}"
            )

    semantic_names = [
        obj.name
        for obj in scope.objects
        if obj.name.startswith(SEMANTIC_PREFIXES)
    ]
    semantic_base: dict[str, list[str]] = {}
    for name in semantic_names:
        base = re.sub(r"\.\d{3}$", "", name)
        semantic_base.setdefault(base, []).append(name)
    for base, names in semantic_base.items():
        if len(names) > 1:
            errors.append(
                f"Duplicate semantic node intent '{base}' detected through Blender suffixing: "
                + ", ".join(names)
            )

    if scope.kind == "object" and len(scope.objects) == 1:
        obj = scope.objects[0]
        if obj.children:
            warnings.append(
                f"Object-only scope '{obj.name}' has children that will be omitted. "
                "Use hierarchy or collection scope if they belong to the asset."
            )

    roots = scope_roots(scope)
    if len(roots) > 1:
        warnings.append(
            "Scope has multiple top-level roots. This is valid for collection-scoped "
            "composites, but a single ASSET root Empty is easier to validate and integrate."
        )

    return ValidationResult(errors=errors, warnings=warnings)


def validate_basic_scene_contract(
    scope: AssetScope, profile_name: str
) -> ValidationResult:
    result = validate_scope_for_export(scope, profile_name)
    errors = result.errors
    warnings = result.warnings

    scene = bpy.context.scene
    if scene.unit_settings.system not in {"METRIC", "NONE"}:
        warnings.append(
            f"Scene unit system is {scene.unit_settings.system}; project convention is "
            "metric / 1 unit = 1 meter."
        )
    if abs(scene.unit_settings.scale_length - 1.0) > 1e-6:
        warnings.append(
            f"Scene unit scale_length is {scene.unit_settings.scale_length}; "
            "project convention is 1.0."
        )

    roots = scope_roots(scope)
    for root in roots:
        scale = tuple(float(v) for v in root.scale)
        if any(abs(v - 1.0) > 1e-4 for v in scale):
            errors.append(
                f"Top-level root '{root.name}' scale is {scale}; apply/normalize scale "
                "in source before export."
            )

    for obj in scope.objects:
        if obj.type != "MESH":
            continue
        for material in obj.data.materials:
            if material is None or not material.use_nodes or not material.node_tree:
                continue
            if len(material.node_tree.nodes) > 32:
                warnings.append(
                    f"Material '{material.name}' is unusually complex for the project "
                    "flat-material policy."
                )

    return result
