# Blender Production Tools

## Purpose

`tools/blender/` is the operational layer for deterministic production-asset review, validation and GLB export.

```text
asset catalog + art contracts
→ model/generate asset
→ named AssetScope
→ canonical review iterations
→ validate
→ profile-based GLB export
→ Godot import validation
```

These tools must fail on ambiguous mechanical state rather than silently repair production art.

## Supported Blender version

Production automation is pinned to:

```text
Blender 5.2 LTS
```

Use the latest 5.2.x patch available to the team. Another major/minor series requires the explicit `--allow-unsupported-blender true` escape hatch and should be treated as unvalidated.

---

# 1. Source ownership

Do **not** force one `.blend` per exported GLB universally. Choose the source unit according to the editing lifecycle.

| Source mode | Use when | Canonical source |
|---|---|---|
| `asset` | independently authored manual asset | one `.blend` per asset |
| `family` | siblings share real authored context: rig, topology, modular kit, lifecycle stages, common base | one family `.blend`, multiple AssetScopes |
| `generator` | bounded variants are reproducible from code + parameters | generator/config + explicit seed; optional one family workbench `.blend` |

## `source-mode=asset`

Default for isolated manual assets because it gives agents the simplest origin/review/export boundary.

Good examples:

```text
crate_wood_01
sealed_metal_container_01
bowling_ball_rare
umbrella_found
```

```text
assets/source/<category>/<asset_id>.blend
```

## `source-mode=family`

Use only when siblings genuinely benefit from being authored together.

Good examples:

```text
crab_family.blend
shelter_family.blend
tool_component_kit.blend
```

Each runtime output still gets its own scope and GLB.

Do not use a family `.blend` as a miscellaneous asset warehouse.

## `source-mode=generator`

Preferred for procedural families such as rocks, branches/logs, palm variants, bounded debris and simple construction pieces.

Canonical provenance is:

```text
generator source
+ optional committed config/parameter file
+ explicit stable seed
→ generated AssetScope
→ GLB
```

`export_asset.py` requires `--generator-seed` in this mode. Use seed `0` when randomness is intentionally disabled; the provenance should still be explicit.

Do **not** commit one generated `.blend` per procedural variant. One optional workbench/family `.blend` may be useful for comparison, parameter tuning and generator debugging.

Rule of thumb:

```text
independent manual identity
→ one blend per asset

authored siblings share real editing context
→ one blend per family

reproducible from code + bounded parameters
→ generator is source; optional one workbench blend
```

---

# 2. AssetScope: membership versus root

The `.blend` file is an authoring container. The **AssetScope** is the review/export boundary.

Supported scope kinds:

```text
object
hierarchy
collection
auto
```

For composites, family files and generated assets, prefer:

```text
Collection: ASSET_<asset_id>
```

The collection contains every runtime member that must cross glTF:

- render meshes;
- armature when applicable;
- `ANCHOR_*` empties;
- `SOCKET_*` empties;
- other required runtime children.

`auto` prefers `ASSET_<asset_id>`, then a hierarchy root named `<asset_id>`. Active-object fallback exists only for interactive convenience and emits a warning.

## Canonical root contract

Every production AssetScope must have **exactly one top-level root**.

```text
single simple prop
→ the mesh itself may be the root

composite/static structure
→ one identity Empty/root at the asset pivot
→ all meshes/anchors/sockets parented below it

rigged asset
→ armature or an explicit identity root, according to the authored hierarchy
→ still exactly one top-level scope root
```

The root world transform must be:

```text
location = (0, 0, 0)
rotation = identity
scale    = (1, 1, 1)
```

This is how pivot/origin stays deterministic even when a family `.blend` contains several assets.

The AssetScope collection controls **membership**. The root controls **asset transform/pivot**. Do not use collection placement as a substitute for a canonical root.

Use `scope-kind=object` only when a genuinely single-object runtime asset has no required children that would be omitted.

---

# 3. Review profiles

Profiles change neutral presentation only; they never alter the asset.

| Profile | Intended use | Artificial ground | Rim |
|---|---|---:|---:|
| `grounded` | props, tools, containers, rocks, palms, normal structures | yes | no |
| `character` | Wilson and rigged animals | yes | restrained |
| `isolated` | hanging/floating pieces, selected exploded diagnostics | no | no |
| `terrain` | terrain/island/ground patches | no | no |

Ground is useful for contact, footprint, stability and contact shadow. Avoid it when the asset already **is** the ground or when ground contact has no semantic value.

The background is fixed and neutral across assets. Do not adapt the background per asset merely to make an image prettier.

---

# 4. Canonical rendering

Canonical review uses a normal **EEVEE scene render**, not viewport Material Preview.

```text
EEVEE scene render
= deterministic + scriptable + headless-capable + independent of VIEW_3D UI state

Material Preview
= fast interactive diagnostic + useful through MCP, but studio-light/HDRI/context dependent
```

Material Preview is allowed during modeling, but it is not canonical acceptance evidence.

## Neutral light rig

Default review uses:

```text
one explicitly oriented SUN key
+ one broad AREA fill
+ fixed neutral world/background
+ optional subtle rim for character profile
```

This is deliberately less flattering than a classic hero three-point rig. It should reveal:

- silhouette;
- intentional facets/planes;
- material blocks;
- construction;
- grounding.

No depth of field, cinematic fog or grading should hide geometry.

---

# 5. Canonical views

`review_asset.py` generates:

```text
gameplay
silhouette
scale
front
side
top
review_sheet
review_manifest.json
```

Orientation contract:

```text
+Y = nominal front
+X = nominal right
+Z = up
```

Therefore:

- front camera looks from `+Y`;
- side camera looks from `+X`;
- gameplay uses orthographic ~45° azimuth / ~35° elevation.

Camera framing projects the evaluated bounding box into camera space and fits the orthographic scale with a stable margin.

The scale view adds a neutral 1.72 m production mannequin. It is a diagnostic scale reference, not Wilson's final character design.

---

# 6. Review history and batch visibility

Default output:

```text
temp/blender-review/<asset_id>/
├── iter_01/
│   ├── <asset_id>_gameplay.png
│   ├── <asset_id>_silhouette.png
│   ├── <asset_id>_scale.png
│   ├── <asset_id>_front.png
│   ├── <asset_id>_side.png
│   ├── <asset_id>_top.png
│   ├── <asset_id>_review_sheet.png
│   └── <asset_id>_review_manifest.json
├── iter_02/
│   └── ...
└── latest.json
```

Each review run creates the next iteration unless `--iteration` is explicit.

The tool also refreshes:

```text
temp/blender-review/index.json
temp/blender-review/index.html
```

The HTML index is a human visual dashboard; JSON/manifests are agent-readable evidence. The asset catalog remains the authoritative production `Status` and is not replaced by this dashboard.

---

# 7. Export profiles

## `static`

Use for normal props, tools, structures, terrain and evaluated procedural output.

```text
modifiers: evaluated/applied by glTF export
animations: off
skins: off
morph targets: forbidden
armature: forbidden
```

A mesh with shape keys fails this profile rather than losing them.

## `deformable`

Use for a non-armature asset intentionally carrying morph targets/shape-key animation.

```text
modifiers: not force-applied
animations: on
skins: off
morph targets: on
armature: forbidden
```

## `rigged`

Use for Wilson and rigged animals.

```text
modifiers: not force-applied
animations: on
skins: on
morph targets: on
armature: required
```

This split exists because the Blender glTF `Apply Modifiers` path cannot safely preserve shape keys.

---

# 8. Validation

Run `validate_asset.py` before final export. `export_asset.py` runs the same validation unless explicitly bypassed for debugging.

Current checks include:

- supported Blender series;
- deterministic scope resolution;
- renderable geometry exists;
- exactly one canonical top-level root;
- root location/rotation/scale are canonical;
- static/deformable/rigged profile compatibility;
- no accidental camera/light/speaker in runtime scope;
- no leaked `__review_*` objects;
- no negative scale;
- suspicious duplicated semantic nodes such as `ANCHOR_X.001`;
- basic scene-unit expectations.

Validation **does not** move origins, zero transforms or remove objects. Fix source explicitly and run again.

---

# 9. Non-destructive export

`export_asset.py`:

1. resolves the scope;
2. validates it;
3. optionally writes a `.blend` **copy** for `asset`/`family` source ownership;
4. temporarily selects exactly the scope;
5. exports with the chosen profile;
6. restores selection;
7. hashes the resulting GLB with SHA-256;
8. writes a temporary provenance manifest.

It must not:

- delete unrelated scene objects;
- delete family siblings;
- move geometry to bottom-center;
- repair transforms;
- strip anchors/sockets;
- export a partial scope because some members are excluded from the active View Layer.

The export manifest lives at:

```text
temp/blender-export/<asset_id>/<asset_id>_export_manifest.json
```

It stores repository-relative paths plus:

```text
Blender version
source ownership
AssetScope membership
generator source/config/seed when procedural
export profile
validation result
runtime GLB SHA-256
```

This makes later reproduction/debugging substantially easier without creating a second production-status database.

---

# 10. Procedural provenance

A procedural export must be reproducible from repository-owned inputs.

Required:

```text
--generator-source <repo-relative path>
--generator-seed <stable value>
```

Optional:

```text
--generator-config <repo-relative committed config/parameter file>
```

If a generator does not use randomness, pass `--generator-seed 0`. Explicit provenance is still preferred over an implicit "there is no seed" assumption.

`assets/generated/` is ignored except for its `.gdignore`; reproducible intermediate materializations should not become accidental source artifacts.

---

# 11. Typical commands

## Independent static prop

```text
review_asset.py --
  --asset-id crate_wood_01
  --scope-kind collection
  --scope-name ASSET_crate_wood_01
  --profile grounded
```

```text
validate_asset.py --
  --asset-id crate_wood_01
  --scope-kind collection
  --scope-name ASSET_crate_wood_01
  --profile static
  --category props/containers
```

```text
export_asset.py --
  --asset-id crate_wood_01
  --scope-kind collection
  --scope-name ASSET_crate_wood_01
  --profile static
  --category props/containers
  --source-mode asset
```

## Authored rigged family

```text
export_asset.py --
  --asset-id crab_generic
  --scope-kind collection
  --scope-name ASSET_crab_generic
  --profile rigged
  --category characters/crabs
  --source-mode family
  --source-id crab_family
```

## Procedural rock

```text
export_asset.py --
  --asset-id rock_medium_03
  --scope-kind collection
  --scope-name ASSET_rock_medium_03
  --profile static
  --category environment/rocks
  --source-mode generator
  --generator-source assets/generators/environment/rocks/generate_rocks.py
  --generator-config assets/generators/environment/rocks/medium.json
  --generator-seed 3003
```

---

# 12. Agent rule

A modeling agent should not ask where to save an asset when repository contracts determine it.

It should:

1. read the catalog row;
2. choose `asset`, `family` or `generator` source ownership;
3. reuse the nearest existing semantic category path;
4. create a named AssetScope with one canonical root;
5. choose the smallest correct review/export profile;
6. run review → validation → export;
7. report unresolved contracts instead of inventing a workaround.

Do not create folder synonyms such as `items/`, `objects/`, `misc/` or `game_props/` when an existing category already expresses the asset.
