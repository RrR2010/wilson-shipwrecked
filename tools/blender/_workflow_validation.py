from __future__ import annotations

import math

from _workflow_common import AssetScope, ValidationResult, scope_roots


def validate_root_contract(scope: AssetScope, result: ValidationResult) -> ValidationResult:
    roots = scope_roots(scope)

    if len(roots) != 1:
        result.errors.append(
            f"AssetScope must contain exactly one top-level root; found {len(roots)}: "
            + ", ".join(obj.name for obj in roots)
            + ". Parent composite members under one canonical root before export."
        )
        return result

    root = roots[0]
    if root.parent is not None and root.parent not in scope.objects:
        result.errors.append(
            f"Asset root '{root.name}' is parented outside the AssetScope to '{root.parent.name}'."
        )

    location, rotation, scale = root.matrix_world.decompose()
    if location.length > 1e-4:
        result.errors.append(
            f"Asset root '{root.name}' world location must be (0,0,0); found {tuple(round(v, 6) for v in location)}. "
            "Move/fix the source explicitly; export will not repair it."
        )

    if any(abs(float(v) - 1.0) > 1e-4 for v in scale):
        result.errors.append(
            f"Asset root '{root.name}' world scale must be (1,1,1); found {tuple(round(float(v), 6) for v in scale)}."
        )

    identity_angle = float(rotation.angle)
    if not math.isfinite(identity_angle) or abs(identity_angle) > 1e-4:
        result.errors.append(
            f"Asset root '{root.name}' world rotation must be identity; quaternion angle is {identity_angle:.6f} rad."
        )

    return result
