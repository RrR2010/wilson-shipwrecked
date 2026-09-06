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
    normalize_category,
    resolve_scope,
    validate_asset_id,
    validate_basic_scene_contract,
)
from _workflow_profiles import EXPORT_PROFILES
from _workflow_validation import (
    validate_profile_source_state,
    validate_root_contract,
)


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Validate a production asset scope before GLB export."
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
    parser.add_argument("--category", default="props")
    parser.add_argument(
        "--allow-unsupported-blender",
        choices=("true", "false"),
        default="false",
    )
    return parser


def main() -> dict:
    args = build_parser().parse_args(argv_after_double_dash())
    ensure_supported_blender(args.allow_unsupported_blender == "true")
    asset_id = validate_asset_id(args.asset_id or default_asset_id())
    category = normalize_category(args.category)

    scope = resolve_scope(
        asset_id=asset_id,
        scope_kind=args.scope_kind,
        scope_name=args.scope_name,
        object_name=args.object_name,
        allow_active_fallback=True,
    )

    result = validate_basic_scene_contract(scope, args.profile)
    result = validate_root_contract(scope, result)
    result = validate_profile_source_state(scope, args.profile, result)
    payload = {
        "asset_id": asset_id,
        "category": category,
        "blender_version": bpy.app.version_string,
        "export_profile": args.profile,
        "scope": {
            "kind": scope.kind,
            "name": scope.name,
            "objects": scope.object_names,
        },
        **result.as_dict(),
    }

    if not result.ok:
        raise RuntimeError(json.dumps(payload, indent=2, sort_keys=True))

    return payload


if __name__ == "__main__":
    print(json.dumps(main(), indent=2, sort_keys=True))
