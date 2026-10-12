# Domestic camp continuation — References 03 and 10

This batch complements the eight individual Reference 03 props using the same
wood, rope, metal and broad-plane construction helpers from `generate_camp.py`.
It is part of the same open art production slice. Canonical source is the seeded
generator, not a separate Blender file for each output.

| Asset | Catalog family | Primary read / scale / rest pose |
|---|---|---|
| `work_surface_plank_01` | `project.work_surface_basic` | Heavy plank worktop, roughly waist height, stable four-leg frame and braces |
| `bucket_wood_01` | `bucket` | Tapered wooden staves with two metal hoops and broad handle; carryable, flat base |
| `storage_box_wood_01` | `storage_box_secured` | Low wooden storage box with separate hinged lid and large hasp, grounded base |
| `pot_iron_01` | `pot` | Squat hollow iron cookware with bail handle; two-hand scale, stable bottom |
| `cup_wood_01` | `cup` | Carved wooden drinking vessel with thick rim; hand scale, flat base |
| `spoon_utensil_wood_01` | `spoon_utensil` | Oversized wooden ladle/spoon with real concave scoop; lies down, scoop toward +Y |

```powershell
$blender = 'C:/Program Files/Blender Foundation/Blender 5.2/blender.exe'
& $blender --background --factory-startup --threads 2 --python-exit-code 1 --python assets/generators/props/camp/generate_domestic.py -- --stage review
# Inspect canonical renders, then export the reviewed seed.
& $blender --background --factory-startup --threads 2 --python-exit-code 1 --python assets/generators/props/camp/generate_domestic.py -- --stage export
```

Default seed is `3`; `--asset <asset_id>` limits generation. `--stage build`
performs geometry/scope checks and saves the workbench without rendering/export.

Outputs:

- Generated Blender workbench: `assets/generated/props/camp/domestic_workbench.blend`.
- Separate named AssetScopes and GLBs under the established furniture/container/tool categories.
- Six canonical views per asset under `temp/blender-review/<asset_id>/`.
- Open-lid inspection under `temp/blender-review-domestic-states/`.
- Retained overview: `assets/previews/props/camp/domestic_overview.png`.
- Geometry/bounds report: `temp/domestic-validation.json`.
- Export provenance: `temp/blender-export/<asset_id>/`.

Root transforms stay at identity and display instances are arranged separately
in the workbench. The shared role naming convention is documented in `README.md`.
Opening the storage box is a presentation transform on its lid node; this does
not implement gameplay closure logic.

Production scope deliberately stops at Blender visual/structural validation and
portable GLB export. Godot import, `.import` metadata and runtime integration are
deferred at the operator's request. Empty containers and an intact frame are the
authored configurations; fill, weathering, damage and repair adapters are not
claimed complete. The catalog remains at `SELF_REVIEW` for these families.

Validation completed in Blender 5.2.1: six scopes passed structural checks and
static export; geometry checks confirmed finite vertices, nondegenerate faces,
closed solid components, positive signed volume and grounded bounds. Canonical
renders were inspected for all six assets, including a separate open-box review.
