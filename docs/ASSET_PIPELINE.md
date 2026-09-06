# Asset Pipeline

## Purpose

Define the **production sequence and ownership boundaries** for 3D content.

This document does not duplicate every machine invariant or command-line flag:

- `ASSET_SPEC.md` owns the Blender/GLB/Godot asset contract;
- `tools/blender/README.md` owns deterministic review/validation/export mechanics;
- `art/AGENT_ART_PRODUCTION.md` owns artistic review/acceptance;
- `asset-catalog/` owns what modeled content must exist and what it must support.

The pipeline is:

```text
asset-catalog row
→ choose source ownership
→ model/generate named AssetScope
→ canonical artistic review iterations
→ structural validation
→ profile-based GLB export
→ Godot import verification
→ optional authored .tscn wrapper
→ update catalog production status
```

A successful Blender export message is not completion.

---

# 1. Canonical format boundary

```text
.blend = editable source when Blender owns an authored asset/family
.py    = reproducible generator/toolkit source
.glb   = canonical runtime/interchange model imported by Godot
.tscn  = optional authored Godot integration composition
```

Godot may import `.blend` directly for local experiments, but production uses committed GLB so importing/build machines do not depend on Blender merely to consume runtime assets.

---

# 2. Production Blender version

Automation in `tools/blender/` targets:

```text
Blender 5.2 LTS
```

Use the latest 5.2.x patch available to the team. A different major/minor series is unvalidated unless deliberately tested and the contract is updated.

---

# 3. Choose source ownership first

The source unit is not always one `.blend` per exported model.

```text
independent manual asset
→ source-mode=asset
→ normally one .blend per asset

authored variants share real editing context
→ source-mode=family
→ one family .blend + independent AssetScopes/GLBs

procedural bounded family
→ source-mode=generator
→ generator/config + explicit seed are canonical source
→ optional one workbench .blend, not one generated .blend per variant
```

Use `assets/README.md` for the decision examples.

The reason to keep one `.blend` per ordinary manual asset is **operational isolation**: origin, source cleanup, review and export are simple. Do not preserve that isolation rule when it would duplicate a real family rig/base or materialize procedural output unnecessarily.

---

# 4. AssetScope is the runtime-model boundary

A source file may contain one or many authored assets. Review/export therefore target a named `AssetScope`, not accidental selection.

Preferred composite/family/generated convention:

```text
ASSET_<asset_id>
```

Every scope has exactly one canonical top-level root. Collection membership answers **what belongs to the asset**; the root answers **what its pivot/transform is**.

See `ASSET_SPEC.md` for root/anchor/socket invariants and `tools/blender/README.md` for scope resolution.

---

# 5. Agent production sequence

For an autonomous modeling task:

1. Read the matching normalized `docs/asset-catalog/` row.
2. Read `VISUAL_GUIDE.md`, the relevant art references and `art/AGENT_ART_PRODUCTION.md`.
3. Read `ASSET_SPEC.md` and `tools/blender/README.md`.
4. Choose source ownership: `asset`, `family` or `generator`.
5. Inspect existing generators/toolkit before creating new helpers.
6. Create the simplest valid blockout and named AssetScope.
7. Ensure required semantic `ANCHOR_*` / `SOCKET_*` nodes are in the scope.
8. Render canonical review evidence with `review_asset.py`.
9. Iterate visually within the bounded art-review loop.
10. Run independent art review when required.
11. Run `validate_asset.py`.
12. Fix validation defects in source; do not ask the exporter to repair them.
13. Export with `export_asset.py` and the correct profile.
14. Verify the actual imported GLB in Godot.
15. Add a `.tscn` wrapper only for engine-specific composition.
16. Update catalog status/notes.

An agent should infer paths from repository contracts rather than asking the user where each ordinary source/export belongs.

---

# 6. Repository layout

```text
assets/
├── README.md
├── source/        # manual/family .blend source; .gdignore
├── generators/    # bpy/config source; .gdignore
├── generated/     # reproducible intermediates; .gdignore + gitignored
├── previews/      # optional/non-authoritative review artifacts; .gdignore
└── models/        # runtime .glb imported by Godot

tools/
└── blender/
    ├── README.md
    ├── _workflow_common.py
    ├── _workflow_profiles.py
    ├── _workflow_validation.py
    ├── review_asset.py
    ├── validate_asset.py
    ├── export_asset.py
    └── build_review_index.py
```

Top-level asset categories are constrained to:

```text
characters/
environment/
props/
structures/
```

Nested semantic paths are encouraged. Do not invent parallel synonyms such as `items/`, `objects/`, `misc/` or `game_props/`.

---

# 7. Procedural production

Prefer deterministic `bpy` generation for repeatable low-poly families.

Generator code should expose bounded semantic parameters rather than low-level vertex noise and should reuse shared primitives/material helpers.

Canonical procedural provenance is:

```text
generator source
+ optional committed config/parameter file
+ explicit seed
+ pinned Blender series
→ AssetScope
→ validated GLB
```

`export_asset.py` records that provenance plus the resulting GLB SHA-256 in a temporary manifest.

`assets/generated/` is intermediate output, not automatic source of truth.

---

# 8. Review loop

Canonical artistic criteria remain in `art/AGENT_ART_PRODUCTION.md`.

The production implementation is `tools/blender/review_asset.py`, which creates iteration-scoped review evidence and a batch index under `temp/blender-review/`.

Use normal deterministic EEVEE scene renders for canonical review. Native Material Preview is useful for fast interactive/MCP diagnosis, but it is not canonical acceptance evidence because it depends on viewport/studio-light state.

Ground/background/light decisions are profile-driven; agents should not rebuild an ad-hoc studio for every object.

---

# 9. Non-destructive validation/export

Review/export tooling does not silently fix modeling defects.

The sequence is:

```text
validate
→ explicit failure when source violates contract
→ fix source
→ validate again
→ export
```

Export may temporarily select scope members and may save a `.blend` copy according to source ownership, but it does not purge the working scene, move geometry, normalize a bad root or delete family siblings.

Static, deformable and rigged assets use different export profiles; do not reuse static flags for characters/morph targets.

---

# 10. Blender → GLB → Godot

Production rules:

- use glTF/GLB 2.0;
- preserve named hierarchy/semantic nodes;
- use source-correct transforms and deterministic faceting/triangulation where visually relevant;
- treat Blender modifiers/Geometry Nodes as authoring/generation tools rather than runtime graphs;
- rely only on portable glTF material features for material transfer;
- keep special runtime shaders/effects primarily on the Godot side;
- validate skeletons, skins, animations and morph targets after actual Godot import;
- verify anchors/sockets after import, not merely in Blender.

Imported GLB is the reusable raw runtime model.

Use a `.tscn` wrapper for Godot-specific composition such as:

- collision/navigation;
- presentation adapters;
- runtime material/shader overrides;
- particles/effects;
- Godot-only animation composition;
- placement/runtime helpers.

---

# 11. Source control

Commit:

- canonical generator/config source;
- intentional manual/family `.blend` source;
- runtime `.glb`;
- Godot `<asset>.import` metadata;
- authored `.tscn` / `.tres` integration resources;
- deliberately approved small reference artifacts when useful.

Ignore/do not commit by default:

- `.godot/` cache;
- `temp/` review/export evidence;
- Blender backups/autosaves;
- reproducible generated intermediates;
- one `.blend` per procedural variant;
- temporary high-resolution render/reference dumps.

---

# 12. Initial pipeline gate

Before scaling to the full catalog, prove the workflow on several fundamentally different cases:

1. one independent manual static prop;
2. one procedural static family with multiple deterministic seeds;
3. one multi-object composite with anchors/sockets;
4. one authored family/structure sharing a source `.blend`;
5. one rigged/animated actor when character production begins.

The production pipeline is proven when a second agent can start from the catalog, choose the correct source ownership/scope/profiles, produce review iterations, export GLB, verify Godot import and update status without inventing another workflow.
