# Artistic 3D Agent Production Contract

## Purpose

This is the execution-first artistic loop for production modeling agents.

Use the smallest context necessary. The agent should spend more effort **modeling and inspecting renders** than rereading documentation.

Functional requirements come from `../asset-catalog/`. Blender/export mechanics come from `../../tools/blender/README.md` and `../ASSET_SPEC.md`.

---

# 1. Production loop

For each asset:

```text
CHOOSE NEXT ASSET
→ READ MINIMUM REFERENCES
→ MODEL / GENERATE
→ RENDER CANONICAL PREVIEWS
→ INSPECT IMAGES
→ FIX HIGHEST-VALUE VISUAL PROBLEM
→ RERENDER / ITERATE
→ FINAL VISUAL CHECK
→ VALIDATE / EXPORT
```

Default creator limit: **up to 4 visual refinement iterations**. Do not spend iterations on detail invisible from gameplay distance.

## Choose the next asset

Start from the cross-cutting catalog and prefer an appropriate `TODO`/ready item according to the current batch plan.

Do not invent a second asset list inside `art/`.

## Minimum reading bundle

Read only:

1. the matching `../asset-catalog/` row;
2. `../VISUAL_GUIDE.md`;
3. the **relevant** textual reference under `reference/`;
4. the corresponding approved visual sheet under `reference/visual/`;
5. this file.

Open `SHAPE_LANGUAGE.md`, `PALETTE_AND_MATERIALS.md`, `SCALE_CAMERA_AND_READABILITY.md` or an art brief only when the current asset needs that detail.

Do not use brainstorming rounds as the normal modeling prompt.

Canonical visual-reference directory, relative to the repository root:

```text
docs/art/reference/
docs/art/reference/visual/
```

Resolve these from the current repository root rather than depending on a machine-specific absolute path.

---

# 2. Before modeling: establish three things

Before creating geometry, state briefly:

```text
PRIMARY READ:
RELATIVE SCALE:
PHYSICAL REST / INSTALLED STATE:
```

Example:

```text
PRIMARY READ: long light branch with a broad readable fork
RELATIVE SCALE: longer than Wilson's forearm, much thinner than a log
PHYSICAL REST: naturally lying on the ground, not standing upright
```

This is enough planning. Do not write a long prose design document before modeling.

---

# 3. Global orientation and physical pose

All production assets use the same local coordinate convention:

```text
+Y = canonical forward/front
+X = canonical right
+Z = up
```

Do **not** let one family use +X as forward and another use +Y.

For assets with a semantic front — character, boat, chair, crate opening, structure entrance, tool head direction — align that logical front consistently to `+Y`.

For rotationally symmetric or effectively orientationless assets, there may be no visually meaningful front, but the authored family must still use a stable canonical orientation. For elongated families, prefer the major longitudinal/functional direction along the family convention rather than choosing a new axis per variant.

World placement may rotate an asset freely at runtime. The rule above defines the **local authored coordinate system**, not a requirement that every placed instance faces world +Y.

## Physical plausibility

The canonical modeled/reviewed pose should be physically meaningful for the asset's normal state.

Examples:

- loose stick/branch/log → normally lies on the ground;
- rock → rests on a believable support face;
- crate/stool/table → stands on intended feet/base;
- palm → upright because it is rooted;
- fallen palm/frond → lies/falls according to gravity;
- wall/shelter panel → use installed pose when the catalog item represents an installed component;
- hanging/floating component → use the appropriate isolated review profile rather than inventing a floor pose.

Do not stand a loose object vertically merely because it frames more conveniently in Blender.

Interaction/attachment poses are runtime uses and do not require the loose asset's natural rest pose to be physically absurd.

---

# 4. Scale is relative, not a per-asset hardcoded art table

Use `1 Blender unit = 1 meter`, but judge most art scale **relationally**.

Check the asset against:

1. Wilson's production mannequin/reference;
2. its intended interaction (held, carried, sat on, entered, climbed, etc.);
3. approved siblings in the same family;
4. familiar neighboring assets (coconut, crate, stool, rock, palm segment) when useful.

The question is:

> Does this object's size make physical and visual sense relative to Wilson and the rest of the world?

Concept sheets may exaggerate proportions. Do not copy apparent image scale blindly.

Readability may justify controlled exaggeration, especially for hand props, tool heads, rope bindings, openings and other interaction-critical forms.

A `scale` review render is required whenever relative size is not obvious.

---

# 5. Modeling rules

Start with silhouette, mass and contact.

The blockout should already establish:

- recognizable primary form;
- relative scale;
- physical rest/installed state;
- broad proportions;
- major assembly relationships;
- gameplay-camera readability.

Use intentional broad planes and bounded asymmetry. An added edge should improve silhouette, form read, deformation, interaction contact or visible state.

Default materials are shared flat-color materials with few slots. Do not compensate for weak geometry with texture noise or micro-detail.

For repeated families, prefer reusable scripted `bpy` construction and deterministic parameters/seeds over repetitive UI manipulation.

---

# 6. Canonical image review

Use `tools/blender/review_asset.py` to generate the standard evidence:

```text
gameplay
silhouette
scale
front
side
top
review_sheet
```

The gameplay view is the primary art test.

`front` always means the global canonical `+Y` front convention. It is still useful as a consistent diagnostic view even when the object itself is nearly symmetric.

## If the active model can inspect images

The modeling agent should inspect the generated images itself. Do not delegate merely by habit.

Compare the renders with the relevant sheets in:

```text
docs/art/reference/visual/
```

Then identify the **single highest-value correction**, modify the model and rerender.

## If the active model cannot inspect images

Delegate visual inspection to the dedicated subagent named **`vs`**.

Give `vs` a precise request rather than `look at these images`.

Recommended delegation prompt:

```text
Review the 3D asset <asset_id> for Wilson Shipwrecked.

Generated review images:
<repo-root>/temp/blender-review/<asset_id>/<iteration>/

Canonical visual references:
<repo-root>/docs/art/reference/visual/
Relevant textual reference:
<repo-root>/docs/art/reference/<REFERENCE_FILE>.md

Validate only the visible result against these criteria:
1. silhouette/readability from gameplay 3/4;
2. relative scale versus the mannequin and familiar world objects;
3. consistency with the approved low-poly family grammar;
4. physically plausible rest/installed state;
5. global authored orientation (+Y forward, +X right, +Z up) where visually meaningful;
6. broad-plane/faceting quality and absence of noisy micro-detail;
7. material simplicity and color grouping;
8. construction/state readability when applicable.

Return:
OUTCOME: PASS | REVISE
TOP ISSUE: one highest-value visible problem
OPTIONAL SECOND ISSUE: only if materially important
REFERENCE MISMATCH: brief note if any

Do not propose implementation/runtime changes. Do not redesign the asset beyond the project references.
```

The modeling agent remains responsible for deciding and applying the correction.

---

# 7. Visual acceptance checklist

Before export, inspect the latest canonical renders and confirm:

```text
[ ] primary identity reads from gameplay view
[ ] silhouette remains clear at reduced size
[ ] relative scale makes sense beside Wilson
[ ] physical rest/installed state is plausible
[ ] local forward/right/up convention is consistent where applicable
[ ] family style matches approved references
[ ] broad facets describe form rather than noise
[ ] material strategy is simple and consistent
[ ] major assembly/construction reads when applicable
[ ] required visible states read when applicable
[ ] no detail was added only to improve close-up beauty
```

If one of the first six items clearly fails, revise before export.

## Catalog status mapping

The catalog's review statuses describe **what actually happened**, not a mandatory reviewer topology.

```text
SELF_REVIEW
= the active modeling agent inspected the canonical renders itself

INDEPENDENT_REVIEW
= a separate reviewer was actually used, including the `vs` fallback
```

When the active model has vision and its required final visual check passes, `INDEPENDENT_REVIEW` is not an artificial mandatory stop. The asset may move from `SELF_REVIEW` to the next production gate/approval according to the batch policy.

Use `INDEPENDENT_REVIEW` when a separate visual opinion is deliberately required or when the active model cannot inspect images and delegates to `vs`.

---

# 8. Stateful, modular and family assets

When catalog-required states are visually distinct, compare them under the same camera/light:

```text
intact → damaged → repaired
healthy → harvested → damaged
partial project → complete project
empty → partial → full
```

For later family members, compare against approved siblings. Variation should come mainly from proportion, part selection, bounded asymmetry, state, palette and composition — not increased detail.

For procedural variants, inspect representative seeds rather than assuming one successful seed proves the family.

---

# 9. Final principle

Prefer a simpler asset that:

- belongs to the same world;
- has believable scale and physical state;
- reads from the gameplay camera;
- exports predictably;

rather than a more sophisticated model that only looks good in isolation.
