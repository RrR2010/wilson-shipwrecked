from __future__ import annotations

from dataclasses import dataclass


SUPPORTED_BLENDER_SERIES = (5, 2)
ALLOWED_TOP_CATEGORIES = frozenset({"characters", "environment", "props", "structures"})


@dataclass(frozen=True)
class ReviewProfile:
    name: str
    ground: bool
    rim_light: bool
    camera_margin: float
    background_color: tuple[float, float, float, float]
    background_strength: float
    ground_color: tuple[float, float, float, float]
    key_energy: float
    key_angle_degrees: float
    fill_energy_per_square_meter: float
    fill_size_factor: float
    rim_energy_per_square_meter: float = 0.0


@dataclass(frozen=True)
class ExportProfile:
    name: str
    apply_modifiers: bool
    export_animations: bool
    export_skins: bool
    export_morphs: bool
    require_armature: bool
    forbid_armature: bool
    forbid_shape_keys: bool


REVIEW_PROFILES: dict[str, ReviewProfile] = {
    "grounded": ReviewProfile(
        name="grounded",
        ground=True,
        rim_light=False,
        camera_margin=1.18,
        background_color=(0.33, 0.36, 0.39, 1.0),
        background_strength=0.8,
        ground_color=(0.24, 0.21, 0.17, 1.0),
        key_energy=3.0,
        key_angle_degrees=18.0,
        fill_energy_per_square_meter=140.0,
        fill_size_factor=4.5,
    ),
    "character": ReviewProfile(
        name="character",
        ground=True,
        rim_light=True,
        camera_margin=1.16,
        background_color=(0.30, 0.33, 0.36, 1.0),
        background_strength=0.8,
        ground_color=(0.22, 0.20, 0.18, 1.0),
        key_energy=2.8,
        key_angle_degrees=20.0,
        fill_energy_per_square_meter=150.0,
        fill_size_factor=4.5,
        rim_energy_per_square_meter=60.0,
    ),
    "isolated": ReviewProfile(
        name="isolated",
        ground=False,
        rim_light=False,
        camera_margin=1.15,
        background_color=(0.34, 0.37, 0.40, 1.0),
        background_strength=0.8,
        ground_color=(0.0, 0.0, 0.0, 1.0),
        key_energy=3.0,
        key_angle_degrees=18.0,
        fill_energy_per_square_meter=140.0,
        fill_size_factor=4.5,
    ),
    "terrain": ReviewProfile(
        name="terrain",
        ground=False,
        rim_light=False,
        camera_margin=1.08,
        background_color=(0.34, 0.37, 0.40, 1.0),
        background_strength=0.75,
        ground_color=(0.0, 0.0, 0.0, 1.0),
        key_energy=3.0,
        key_angle_degrees=18.0,
        fill_energy_per_square_meter=120.0,
        fill_size_factor=5.5,
    ),
}


EXPORT_PROFILES: dict[str, ExportProfile] = {
    "static": ExportProfile(
        name="static",
        apply_modifiers=True,
        export_animations=False,
        export_skins=False,
        export_morphs=False,
        require_armature=False,
        forbid_armature=True,
        forbid_shape_keys=True,
    ),
    "deformable": ExportProfile(
        name="deformable",
        apply_modifiers=False,
        export_animations=True,
        export_skins=False,
        export_morphs=True,
        require_armature=False,
        forbid_armature=True,
        forbid_shape_keys=False,
    ),
    "rigged": ExportProfile(
        name="rigged",
        apply_modifiers=False,
        export_animations=True,
        export_skins=True,
        export_morphs=True,
        require_armature=True,
        forbid_armature=False,
        forbid_shape_keys=False,
    ),
}
