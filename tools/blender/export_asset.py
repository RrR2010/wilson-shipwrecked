from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

import bpy

SCRIPT_DIR = Path(__file__).resolve().parent
if str(SCRIPT_DIR) not in sys.path:
    sys.path.insert(0, str(SCRIPT_DIR))

from _workflow_common import (
    argv_after_double_dash,
    default_asset_id,
    ensure_supported_blender,
    find_repo_root,
    normalize_category,
    preserved_selection_state,
    repo_relative,
    resolve_scope,
    select_scope,
    validate_asset_id,
    validate_basic_scene_contract,
    write_json,
)
from _workflow_profiles import EXPORT_PROFILES


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Non-destructively export a named Blender asset scope to canonical GLB."
    )
    parser.add_argument("--asset-id", default="")
    parser.add_argument(
        "--scope-kind",
        choices=("auto", "object", "hierarchy", "collection"),
        default="auto",
    )
    parser.add_argument("--scope-name", default="")
    parser.add_argument("--object-name", default="")
    parser.add_argument(
        "--profile",
        choices=tuple(EXPORT_PROFILES.keys()),
        default="static",
    )
    parser.add_argument(
        "--category",
        default="props",
        help="Runtime/source subpath beginning with characters, environment, props, or structures.",
    )
    parser.add_argument(
        "--source-mode",
        choices=("asset", "family", "generator"),
        default="asset",
        help="Ownership of the editable source. See tools/blender/README.md.",
    )
    parser.add_argument(
        "--source-id",
        default="",
        help="Required for family source mode; names the shared .blend source.",
    )
    parser.add_argument(
        "--generator-source",
        default="",
        help="Repository-relative generator path for source-mode=generator.",
    )
    parser.add_argument(
        "--save-source",
        choices=("auto", "true", "false"),
        default="auto",
        help="Save a non-destructive .blend copy for asset/family modes. Defaults true except generator mode.",
    )
    parser.add_argument(
        "--skip-validation",
        choices=("true", "false"),
        default="false",
    )
    parser.add_argument(
        "--allow-unsupported-blender",
        choices=("true", "false"),
        default="false",
    )
    parser.add_argument(
        "--manifest-root",
        default="",
        help="Defaults to temp/blender-export/<asset_id>.",
    )
    return parser


def resolve_source_output(
    *,
    repo_root: Path,
    category: str,
    source_mode: str,
    asset_id: str,
    source_id: str,
) -> Path | None:
    if source_mode == "generator":
        return None

    if source_mode == "asset":
        source_name = asset_id
    else:
        if not source_id:
            raise RuntimeError("--source-id is required for source-mode=family.")
        source_name = validate_asset_id(source_id)

    return repo_root / "assets" / "source" / category / f"{source_name}.blend"


def should_save_source(source_mode: str, save_source: str) -> bool:
    if save_source == "true":
        return True
    if save_source == "false":
        return False
    return source_mode != "generator"


def ensure_scope_in_active_view_layer(scope) -> None:
    available = {obj.name for obj in bpy.context.view_layer.objects}
    missing = [obj.name for obj in scope.objects if obj.name not in available]
    if missing:
        raise RuntimeError(
            "Asset scope contains objects outside/excluded from the active View Layer: "
            + ", ".join(missing)
            + ". Export is aborted rather than silently omitting them."
        )


def export_glb(*, glb_path: Path, scope, profile) -> None:
    glb_path.parent.mkdir(parents=True, exist_ok=True)

    with preserved_selection_state():
        select_scope(scope)
        bpy.ops.export_scene.gltf(
            filepath=str(glb_path),
            check_existing=False,
            use_selection=True,
            export_format="GLB",
            export_cameras=False,
            export_lights=False,
            export_extras=True,
            export_yup=True,
            export_apply=profile.apply_modifiers,
            export_materials="EXPORT",
            export_image_format="AUTO",
            export_texcoords=True,
            export_normals=True,
            export_tangents=False,
            export_attributes=False,
            export_animations=profile.export_animations,
            export_skins=profile.export_skins,
            export_morph=profile.export_morphs,
            export_morph_normal=profile.export_morphs,
            export_morph_tangent=False,
            export_morph_animation=profile.export_morphs,
            export_rest_position_armature=True,
            export_force_sampling=profile.export_animations,
            export_optimize_animation_size=True,
            export_gpu_instances=False,
            export_gn_mesh=False,
            will_save_settings=False,
        )

    if not glb_path.is_file() or glb_path.stat().st_size == 0:
        raise RuntimeError(
            f"GLB export did not produce a non-empty file: {glb_path}"
        )


def main() -> dict:
    args = build_parser().parse_args(argv_after_double_dash())
    ensure_supported_blender(args.allow_unsupported_blender == "true")

    if bpy.context.mode != "OBJECT":
        raise RuntimeError(
            f"Production export requires OBJECT mode; current mode is {bpy.context.mode}."
        )

    asset_id = validate_asset_id(args.asset_id or default_asset_id())
    category = normalize_category(args.category)
    profile = EXPORT_PROFILES[args.profile]
    repo_root = find_repo_root()

    generator_path = None
    if args.source_mode == "generator":
        if not args.generator_source:
            raise RuntimeError(
                "--generator-source is required for source-mode=generator so the canonical source is traceable."
            )
        generator_path = (repo_root / args.generator_source).resolve()
        if not generator_path.is_file():
            raise RuntimeError(
                f"Declared generator source does not exist: {args.generator_source}"
            )

    scope = resolve_scope(
        asset_id=asset_id,
        scope_kind=args.scope_kind,
        scope_name=args.scope_name,
        object_name=args.object_name,
        allow_active_fallback=True,
    )

    ensure_scope_in_active_view_layer(scope)
    validation = validate_basic_scene_contract(scope, profile.name)
    if args.skip_validation != "true" and not validation.ok:
        raise RuntimeError(
            "Asset validation failed before export:\n"
            + json.dumps(validation.as_dict(), indent=2, sort_keys=True)
        )

    source_path = resolve_source_output(
        repo_root=repo_root,
        category=category,
        source_mode=args.source_mode,
        asset_id=asset_id,
        source_id=args.source_id,
    )
    glb_path = repo_root / "assets" / "models" / category / f"{asset_id}.glb"

    save_source = should_save_source(args.source_mode, args.save_source)
    if save_source and source_path is None:
        raise RuntimeError(
            "source-mode=generator has no canonical .blend output. "
            "Use --save-source=false or choose asset/family source ownership."
        )

    if save_source and source_path is not None:
        source_path.parent.mkdir(parents=True, exist_ok=True)
        bpy.ops.wm.save_as_mainfile(filepath=str(source_path), copy=True)
        if not source_path.is_file():
            raise RuntimeError(f"Failed to save Blender source copy: {source_path}")

    export_glb(glb_path=glb_path, scope=scope, profile=profile)

    generator_ref = (
        repo_relative(generator_path, repo_root) if generator_path is not None else ""
    )

    manifest_root = (
        Path(args.manifest_root).resolve()
        if args.manifest_root
        else repo_root / "temp" / "blender-export" / asset_id
    )
    manifest_path = manifest_root / f"{asset_id}_export_manifest.json"

    manifest = {
        "asset_id": asset_id,
        "blender_version": bpy.app.version_string,
        "category": category,
        "source_mode": args.source_mode,
        "source_blend": repo_relative(source_path, repo_root) if source_path else "",
        "generator_source": generator_ref,
        "runtime_glb": repo_relative(glb_path, repo_root),
        "export_profile": profile.name,
        "scope": {
            "kind": scope.kind,
            "name": scope.name,
            "objects": scope.object_names,
        },
        "validation": validation.as_dict(),
        "non_destructive_export": True,
    }
    write_json(manifest_path, manifest)
    return manifest


if __name__ == "__main__":
    print(json.dumps(main(), indent=2, sort_keys=True))
