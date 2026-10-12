# Functional Asset Factory — Parallel Blender Agent

## Mission and boundaries

Build an individually authored, reusable **3D asset library ahead of runtime demand**, guided by the approved visual references and anticipated interactions. The modeling agent is a **functional asset designer**, not just a mesh creator: predict likely states, attachments, interactions, and the cheapest Godot-compatible representation before modeling.

This is the project's exceptional **parallel production lane**. Runtime integration remains demand-driven and belongs to runtime TASKs. The art agent must not wire gameplay, introduce domain rules, or make Godot the art completion gate. It may run optional import probes when useful and label evidence accurately.

Read, in order: this document → relevant row in `asset-catalog/` → `VISUAL_GUIDE.md` → exact individual reference image and reference description → `ASSET_SPEC.md` and `ASSET_PIPELINE.md` → Blender tooling instructions as needed.

## Progress ownership

One long-lived **art EPIC** is an overview; each execution unit is **one individually modeled asset**, with its own checklist/status recorded on a GitHub Issue or a compact row in the existing asset catalog. Batch PRs are permitted only for several completed *individually approved* assets that touch nonconflicting files. Use short-lived art branches and PRs; never maintain an indefinite unmerged mega-branch. When sharing one Blender worktree, operate on one task at a time; runtime agents should not edit art-owned files concurrently.

For each asset, track this finite progression in the Issue (without a separate permanent status document):

```text
QUEUED → FUNCTION BRIEF → OPERATOR CONSULTED → MODELING
→ VISUAL SELF-REVIEW → EXPORT VERIFIED → PR READY → MERGED
```

Mark `BLOCKED` when operator input or a contract decision is required. In the catalog preserve its established production `Status` vocabulary (TODO/BRIEFED/BLOCKOUT/SELF_REVIEW/INDEPENDENT_REVIEW/APPROVED/DEFERRED); **Issue execution state is not a replacement for catalog status**. A model can be approved and merged without being imported by Godot.

Separate evidence dimensions:
- **Art completion**: editable Blender source, GLB, canonical views, visual review, stable structure/scale.
- **Import readiness**: plausible GLB hierarchy, pivots, names and sockets under `ASSET_SPEC.md` (not a guarantee until tested).
- **Runtime integration**: instance, engine-specific materials/collision/animation adapters, functional smoke tests — another agent and another TASK.

Do not mark untested Godot import as PASS. No mandatory Godot run for an art-only PR.

## Prioritized queue and selection

This ordering is the default **production preference, not authorization to model every catalog row**. Re-evaluate after each 3–5 completed assets with the macro architect; prefer visual references already approved and objects with broad reusability. Avoid long batches with duplicate roles.

| Priority | Group | Initial individual candidates | Why |
| --- | --- | --- | --- |
| P0 | Existing camp delivery | Finish/merge Reference 03 & 10 camp assets (#79); don't duplicate these 14 | Preserve reviewed work and reusable construction vocabulary |
| P1 | Natural island set | Distinct palm/tree, rocks, fallen log/branch, ground vegetation/tufts | Replace primitive island silhouettes repeatedly seen on screen |
| P1 | Shipwreck/salvage | Hull fragment/plank, mast/sail remnant, rope/wood debris, salvage chest only if not covered by existing model | Core identity and exploration |
| P2 | Shelter lifecycle | Individual pole, frame, wall/roof piece, repair/damage-readable variant where needed | Existing shelter is a frequent staged visual |
| P2 | Functional camp additions | Bed/rest mat, firewood, tool stand, simple utensils/tools not already available | Supports existing needs and projects |
| P3 | Interactive mechanical props | Hinged door, closable container variants, tool mechanisms | More design/operator decisions and scene-specific integration cost |
| P4 | Rigged actors / high-deformation objects | Wilson, Gerald upgrades, complex ropes/cloth | Wait for animation/semantic contracts to stabilize |

**Selection algorithm:** next unmodeled catalog item in the highest appropriate band, adjusted for Stage-3 scene visibility, approved reference quality, reuse across actions/states, and modeling complexity. Never model another variant just to increment the count. Ask the macro architect if requirements or priority conflict.

## Required operator micro-consultation — BEFORE geometry

For each individually modeled asset, send one **brief, specific consultation** to Richard using a visual reference link or asset ID, with a *recommended default* and only decisions that meaningfully affect geometry. Wait for an answer before committing to modeling; do not launch an unrelated task while blocked unless explicitly prioritized.

Suggested message, adapted to the object:

```text
Asset: <ID> — <reference>
Likely use: <placement and 1–3 future interactions>
Potential states: <closed/open, empty/full, intact/damaged, etc.>
Proposed construction: <separable moving parts, pivots, anchors, material/texture choice>
Decision: <one or two concrete questions; give recommended default>
Uncertain and deferred: <actual gameplay/state logic; not part of this PR>
```

Examples:
- **Chest**: lid as an independently pivoted child; open/closed movement range; interior that stays visually valid; `SOCKET_LID`, `SOCKET_CONTENT`, grip point. Ask whether locked state needs an external latch and whether contents should be visible.
- **Door**: separate door leaf, hinge pivot at the correct side, doorway clearance and handle anchors. Ask swing direction/one vs two leaves.
- **Pot/bowl**: true visible interior; empty/filled geometry or contained-surface anchor; optional removable contents/water surface, not a gameplay quantity system. Ask which fill bands matter visually.
- **Tree**: rooting, trunk/fruit/branch sockets and likely fallen/broken states. Ask only when those choices change topology.
- **Crate**: handle/grip slots, storage interior and optionally detachable lid if expected.

For purely decorative rocks/grass, the interaction brief can be one line, but still explicitly confirm simple/non-interactive geometry with Richard; use grouped consultations of **up to 3 similarly trivial objects** only if each ID and default is named. Do not invent user acceptance from silence.

## Godot-aware modeling decisions

1. **Export boundary:** one **individually addressable** `ASSET_<asset_id>` scope and one GLB per asset, even when code generation shares helpers. Prefer **one editable .blend per asset** as Richard's default; shared libraries/generators may be reused without packaging unrelated final assets into one source scene. Existing family workbenches remain valid historical assets; do not break them retroactively.
2. **Coordinates:** meters, +Y forward/+Z up in Blender; transforms/pivots and export-converted positions validated. Root at identity; meaningful ground/contact origin. Pivots for moving parts belong at hinges/joints, not arbitrary mesh centers.
3. **Moving vs deforming:** use separate rigid object children and node-transform animation for lid, doors, drawers, handles and tools; use an armature/bones only when *deformation* (organic joint, cloth-like motion, articulated character) or shared rig warrants it. Name motion elements consistently. Do not bake open/closed states into an inseparable single mesh.
4. **Anchors:** explicit Blender empties within export scope, stable names/semantic roles for grip, attach, place, storage, hinge and interaction positions; ensure they survive GLB export as transform nodes. A named empty is not a gameplay authority. Avoid proliferating unnecessary anchors on inert geometry.
5. **Materials:** default to a small palette of opaque glTF-compatible PBR materials/base colors (or verified vertex colors where appropriate). Use unique texture atlases only when silhouette/material-color cannot convey essential visual information at gameplay camera distance; shared palettes are cheaper. Blender-specific shader node graphs, procedural nodes and modifiers may not export faithfully: bake to supported PBR/texture or simplify first. Reserve alpha, emission, normals and transparency for proven functional readability needs and test them when used. Don't assume Blender Eevee appearance equals Godot.
6. **Topology and performance:** readable 2.5D silhouette, low-poly geometry, bounded material slots/draw calls, no needless hidden detail, physically credible interior where the player can look into it, correctly oriented normals, intentional backface behavior. Prefer rigid alternatives to bones when suitable. Avoid shader complexity and unnecessary unique textures for a web-first game.
7. **Future runtime owners:** do not author collisions, physics ownership, gameplay interaction, World state or semantic animation timing inside GLB. Provide geometry/pivots/anchors and proposed visual states; runtime agent adds appropriate `.tscn` wrapper, import settings, collision and state-to-presentation adapters on demand.
8. **Compatibility proof:** review exported GLB (not just source). For nontrivial mechanisms, use a minimal disposable import/transform probe if Godot is available. Report actual version and observations; optional Godot probes never expand the art TASK scope into gameplay work.

References: [Godot stable available 3D formats](https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_3d_scenes/available_formats.html), [Godot import configuration](https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_3d_scenes/import_configuration.html), [Godot import hints](https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_3d_scenes/node_type_customization.html). Godot recommends glTF 2.0/GLB and supports scene hierarchies, animations and imported materials; custom Blender node graphs should not be assumed portable. Always verify against the engine version pinned for a given task.

## Per-asset acceptance and handoff

- [ ] Catalog ID/reference, intended roles and states identified, micro-consultation approved
- [ ] Individual `.blend` source committed; `.blend1`/`.blend2` excluded
- [ ] One semantic scope and GLB; inspect export geometry, transforms, hierarchy and useful pivots/empties
- [ ] Canonical gameplay/side/front/top/silhouette/scale views inspected; iteration bounded
- [ ] Material/texture approach and future animation/rig mechanism explained briefly
- [ ] V-levels reported accurately (Blender structural/export, optional Godot probe, no invented runtime validation)
- [ ] Catalog production state updated; unresolved functional states and runtime TODOs identified without fabricating gameplay
- [ ] PR references asset Issue(s); no runtime code or permanent mega-handoff

The agent should end each asset task with a 4–8-line operational summary, not a long design report, and then propose the next prioritized asset for consultation. The human approves model-specific functional assumptions and visual choices; macro architecture and integration sequencing stay centralized.
