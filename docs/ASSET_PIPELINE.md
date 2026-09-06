# Asset Pipeline

## Purpose

Define the production sequence and ownership boundaries for 3D assets without turning routine modeling into a documentation exercise.

Canonical owners:

```text
docs/asset-catalog/            what must exist / functional requirements
docs/VISUAL_GUIDE.md + art/    how it should look
docs/ASSET_SPEC.md             machine-facing invariants
tools/blender/README.md         review/validation/export mechanics
```

---

# Production loop

The normal modeling-agent loop is:

```text
1. choose next ready asset from catalog
2. read its catalog row + minimum visual references
3. choose source ownership: asset | family | generator
4. model/generate a named AssetScope
5. render canonical previews
6. inspect the images
7. fix the highest-value visible problem
8. rerender and iterate (bounded)
9. final visual check
10. validate
11. export GLB
12. update catalog status/notes
```

The agent should spend most of the task **building and inspecting**, not summarizing documents.

## Minimum reading for an ordinary asset

```text
matching docs/asset-catalog row
docs/VISUAL_GUIDE.md
docs/art/reference/<relevant reference>.md
docs/art/reference/visual/<relevant sheet>.png
docs/art/AGENT_ART_PRODUCTION.md
```

Use `ASSET_SPEC.md` and `tools/blender/README.md` as execution contracts; open deeper art/domain documents only when the asset needs them.

Do not read brainstorming rounds by default.

---

# Visual inspection

After every meaningful modeling pass, generate canonical previews with `tools/blender/review_asset.py`.

If the active model can inspect images, it should review the renders itself against `docs/art/reference/visual/`.

If it cannot inspect images, delegate the visual comparison to the dedicated `vs` subagent using the prompt contract in `docs/art/AGENT_ART_PRODUCTION.md`.

Do not delegate visual inspection merely by habit when the active model already has vision.

Iteration should target the highest-value visible defect, not accumulate polish indefinitely.

---

# Source ownership

```text
independent manual asset
→ source-mode=asset
→ normally one .blend per asset

authored siblings share rig/base/stages/editing context
→ source-mode=family
→ one family .blend, independent AssetScopes/GLBs

procedural reproducible family
→ source-mode=generator
→ generator/config + explicit seed are canonical source
→ optional one family workbench .blend
```

One `.blend` per ordinary manual asset is preferred for isolation. One `.blend` per generated variant is specifically discouraged.

See `assets/README.md` for examples.

---

# AssetScope

The file is not the export boundary. A named AssetScope is.

Preferred convention:

```text
ASSET_<asset_id>
```

Include all runtime members that must cross GLB: geometry, armature when applicable, required anchors/sockets and runtime child nodes.

Every scope has one canonical root. See `ASSET_SPEC.md`.

---

# Global authored coordinates

All asset families share:

```text
+Y = forward/front
+X = right
+Z = up
```

Runtime placement may rotate instances freely. Do not let families redefine the authored forward axis.

The canonical modeled/review pose must also make physical sense for the represented state: a loose stick normally lies down; a rooted palm stands; an installed wall is shown installed.

---

# Relative scale

Use meter units, but do not create arbitrary hardcoded dimensions for every art asset.

Resolve scale against:

1. explicit functional requirement when one exists;
2. Wilson/mannequin;
3. intended interaction;
4. approved family siblings;
5. familiar world references.

Use the canonical scale render when the relationship is not obvious.

---

# Blender automation

Production automation targets **Blender 5.2 LTS**.

```text
tools/blender/review_asset.py
tools/blender/validate_asset.py
tools/blender/export_asset.py
```

Review/export are non-destructive. Validation defects are fixed in source rather than repaired silently by export.

Review uses deterministic EEVEE scene renders. Native Material Preview is useful interactively but is not canonical acceptance evidence.

Profiles cover ordinary grounded assets, characters, isolated/floating content, terrain, and static/deformable/rigged export differences.

Exact commands and profile details live only in `tools/blender/README.md`.

---

# Repository boundary

```text
assets/source/        manual/family Blender source
assets/generators/    procedural source/config
assets/generated/     reproducible intermediates
assets/previews/      deliberately retained preview artifacts
assets/models/        runtime GLB imported by Godot
```

Runtime interchange is GLB/glTF 2.0. Direct `.blend` import is an experiment convenience, not the production contract.

Imported raw GLB remains reusable. Use a `.tscn` wrapper only for Godot-specific composition such as collision/navigation, presentation adapters, special shaders/effects or engine-only animation setup.

Commit Godot `.import` metadata beside runtime GLBs; ignore `.godot/` cache.

---

# Pipeline proof gate

Before scaling across the catalog, verify locally in Blender/Godot with:

```text
1. independent static manual prop
2. procedural family with multiple explicit seeds
3. multi-object composite with anchor/socket
4. authored family with multiple AssetScopes
5. rigged actor when character production starts
```

Once those cases pass, ordinary assets should use the same workflow rather than inventing per-asset pipelines.
