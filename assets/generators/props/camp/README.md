# Reference 03 camp props

Deterministic Blender 5.2 source for the eight individual sheets in
`docs/art/reference/03/`. Seed `3` is the authored production selection.

```powershell
$blender = 'C:/Program Files/Blender Foundation/Blender 5.2/blender.exe'
& $blender --background --factory-startup --threads 2 --python-exit-code 1 --python assets/generators/props/camp/generate_camp.py -- --stage review
# Inspect the canonical renders before exporting.
& $blender --background --factory-startup --threads 2 --python-exit-code 1 --python assets/generators/props/camp/generate_camp.py -- --stage export
& godot --headless --editor --path . --import --quit 2>&1 | Out-Host
& godot --headless --path . --script tools/blender/check_reference_03_import.gd 2>&1 | Out-Host
```

Use `--asset <asset_id>` to regenerate one scope. `--stage build` performs
structural validation without rendering or exporting. All stages save one
disposable generated workbench under `assets/generated/props/camp/`.
The Python source owns geometry; generated Blender files are not canonical.

| Individual sheet | Asset ID | Catalog family |
|---|---|---|
| Stool | `stool_crude_slab_01` | `stool_crude` |
| Bench | `bench_simple_plank_01` | `bench_simple` |
| Basket | `basket_small_woven_01` | `basket_small` |
| Bowl | `bowl_wood_01` | `bowl` |
| Crate | `ship_crate_wood_01` | `ship_crate` |
| Raised shelf | `display_shelf_raised_01` | `display_shelf` |
| Drying rack | `drying_rack_basic_01` | `project.drying_rack_basic` |
| Fire ring | `fire_site_stone_01` | `project.fire_site` |

These are the illustrated configurations, not completion of every state and
variant in the broader catalog. Fire is a prepared unlit site; runtime fire VFX
belong in Godot. Rack sample strips are removable presentation meshes, not
authoritative food entities. Crate lid meshes are parented to `SOCKET_LID`;
containers remain hollow beneath their opening/closure. Anchors are presentation
attachment points, not domain identities or mutation APIs.

Semantic node names use `<ROLE>__<asset_id>` and carry the unsuffixed role as
`semantic_role` metadata. This prevents Blender's global naming from introducing
order-dependent `.001` suffixes when multiple scopes share a workbench.
The workbench opens a separate display scene with collection instances laid out
side by side; canonical AssetScope roots remain at the origin.

Canonical review images and the browsable index live in `temp/blender-review/`.
An overview is retained in `assets/previews/props/camp/reference_03_overview.png`.
Export provenance and checksums are in `temp/blender-export/<asset_id>/`.

Physical scale: stool/bench seats approximately 0.48/0.50 m high; shelf top
0.79 m; rack crossbar 1.29 m. All asset roots retain identity transforms,
meter units, authored +Y front and +Z up. No textures are required.

Validation: all eight scopes passed structural validation and static GLB export
in Blender 5.2.1. Canonical six-view sheets were visually inspected and refined
for plank shape, basket intersections and fire-ring stone shape. Godot 4.7.2
import checks passed for geometry, scale, identity roots, every anchor position
and the crate lid hierarchy. No simulation/runtime behavior was changed.

On a fresh Godot profile, the unrelated legacy prototype `.blend` under
`prototypes/spatial-navigation-perception/source/` may block headless imports
until Blender's executable path is configured in the editor. This validation
temporarily excluded that source directory with `.gdignore`, then removed the
exclusion. The generated camp workbench already lives under an ignored source
directory and is not used for runtime import.
