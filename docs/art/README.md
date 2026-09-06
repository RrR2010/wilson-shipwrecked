# Visual Production Support Pack

This directory turns the project visual direction into focused production guidance for humans and 3D agents.

Canonical owners:

```text
../VISUAL_GUIDE.md                  global visual source of truth
../asset-catalog/                   what modeled content must exist/support
../ASSET_SPEC.md                    technical asset invariants
../ASSET_PIPELINE.md                production sequence
AGENT_ART_PRODUCTION.md             short artistic modeling/review loop
reference/ + reference/visual/      family-specific written/visual references
```

`art/` must not maintain a second asset backlog.

## Locked baseline

A colorful tropical miniature diorama with an orthographic 3/4 gameplay camera, intentionally aggressive low-poly environment geometry, broad readable silhouettes, restrained surface detail, and a softer caricatured Wilson.

Common assets default to shared flat-color materials with no unique texture maps. Complexity should come from form, composition, state, lighting and persistent history rather than surface detail.

Global authored orientation is:

```text
+Y = forward/front
+X = right
+Z = up
```

Runtime instances may rotate in the world; asset families do not redefine their local forward axis.

## Core visual appendices

Open only when relevant:

- [`ART_DIRECTION.md`](ART_DIRECTION.md) — visual identity/mood/hierarchy.
- [`SHAPE_LANGUAGE.md`](SHAPE_LANGUAGE.md) — silhouette/faceting grammar.
- [`PALETTE_AND_MATERIALS.md`](PALETTE_AND_MATERIALS.md) — flat-material/texture policy.
- [`SCALE_CAMERA_AND_READABILITY.md`](SCALE_CAMERA_AND_READABILITY.md) — relative scale, orientation, physical pose, camera/readability.

## Reference pack

Text references live under [`reference/`](reference/) and approved visual sheets under `reference/visual/`.

Current sequence:

1. Shape Grammar
2. Natural Island Vocabulary
3. Camp Primitive Props
4. Materials, Lighting & Performance
5. Tool Grammar
6. Shelter Evolution
7. Salvage & Repurposing
8. Weather & Damage
9. Wilson Scale & Interaction
10. Storage & Containers
11. Workstations & Utilities
12. Transport, Raft & Dock

Use only the references relevant to the current asset. Visual sheets communicate shape intent; textual contracts win when generated imagery contains accidental details.

## Normal modeling-agent reading path

```text
matching asset-catalog row
→ ../VISUAL_GUIDE.md
→ relevant REFERENCE_*.md + visual sheet
→ AGENT_ART_PRODUCTION.md
```

Open a core appendix or optional art brief only if the current task needs it.

Do not read brainstorming rounds by default.

## Agent loop

`AGENT_ART_PRODUCTION.md` owns the execution loop:

```text
choose asset
→ inspect written + visual references
→ model/generate
→ render canonical previews
→ inspect images
→ refine/iterate
→ final visual check
→ validate/export
```

If the active model has vision, it reviews the images itself. If it cannot inspect images, it delegates the visual check to the `vs` subagent using the prompt defined there.

## Brief strategy

Use no separate brief when catalog + reference already define the asset.

Use a family/asset art brief only for unresolved visual decisions. Functional requirements belong in the cross-cutting asset catalog/domain contracts, not in an art-only brief.

## Production principle

Prefer the simplest asset that is coherent in style, relative scale, physical pose and gameplay readability.

A close-up render cannot rescue an asset that fails from the gameplay camera.
