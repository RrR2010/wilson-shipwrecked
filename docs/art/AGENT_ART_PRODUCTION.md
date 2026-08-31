# Artistic 3D Agent Production Contract

## Purpose

This is the single operational **artistic** contract for autonomous 3D modeling agents. It covers visual source precedence, modeling iteration, canonical previews, self-review, independent art review and artistic acceptance.

It does not define the asset's full functional contract. Start from the cross-cutting row in `../asset-catalog/`. Technical Blender/MCP/export details remain in `../ASSET_PIPELINE.md` and `../ASSET_SPEC.md`.

## 1. Source precedence

For a modeling task, read only what is needed, in this order:

1. Matching `../asset-catalog/` row — what the modeled asset/family must support across concerns.
2. `../VISUAL_GUIDE.md` — project visual source of truth.
3. `ART_DIRECTION.md`, `SHAPE_LANGUAGE.md`, `PALETTE_AND_MATERIALS.md`, `SCALE_CAMERA_AND_READABILITY.md` — project-wide art constraints.
4. Relevant `reference/REFERENCE_*.md` plus approved `reference/visual/*.png` sheet.
5. Optional family/asset **art brief** when catalog + references leave a visual ambiguity.

An art brief may narrow shape/variation decisions but cannot override the cross-cutting asset catalog, domain contracts or higher-tier visual rules.

Do not read Rounds 1–10 as the default modeling prompt. They are historical design evidence.

## 2. Art-brief granularity

Use the smallest sufficient art brief:

- **No separate brief / grammar-only task** — trivial variant fully covered by catalog + approved reference.
- **Family art brief** — family needs extra visual construction/variation bounds not worth repeating in every catalog row.
- **Asset-specific art brief** — visually high-risk or unusually authored asset such as Wilson or rare hero salvage.

Functional requirements, capabilities, states, interactions and composition belong in the cross-cutting asset catalog/domain contracts rather than being hidden inside an art brief.

## 3. Modeling loop

```text
READ ASSET CONTRACT
→ STATE PRIMARY VISUAL READ
→ BLOCK OUT
→ APPLY FAMILY GRAMMAR
→ APPLY MATERIAL BLOCKS
→ RENDER CANONICAL PREVIEWS
→ SELF-REVIEW
→ FOCUSED REVISION
→ INDEPENDENT ART REVIEW
→ FINAL CORRECTION
→ ART ACCEPT OR ESCALATE
```

### Primary read

Before modeling, describe the asset in one silhouette-oriented sentence. Examples:

- rock: broad irregular faceted mass;
- palm: tapered segmented trunk + radial broad-frond crown;
- hammer: readable handle + heavy head + visible binding;
- shelter: structural frame + dominant roof mass + visible assembly;
- raft: tied buoyant longitudinal members + broad usable deck.

If the primary read is unclear, simplify before adding detail.

### Blockout rule

The blockout must already establish silhouette, scale, ground contact, mass distribution and modular arrangement from the gameplay camera.

Do not begin with bevels, scratches, rope fibers, leaf veins, tiny hardware, decorative cuts or unique textures.

### Geometry rule

Use intentional planes. An added edge should improve at least one of:

- silhouette;
- planar/form read;
- deformation;
- interaction contact;
- state readability.

Aggressive low-poly does not mean random triangulation.

### Material rule

Default to shared flat-color materials, low slot counts and restrained roughness/specular differences. Common assets should require no unique texture map.

Decals/shared low-frequency noise are exceptions for semantic markings or broad state communication, never a substitute for weak form.

## 4. Canonical preview package

Every reviewable asset should provide:

1. `front` — orthographic;
2. `side` — orthographic;
3. `top` — orthographic;
4. `gameplay` — canonical orthographic 3/4;
5. `silhouette` — single dark silhouette from gameplay camera;
6. `scale` — Wilson mannequin comparison when scale is not trivial.

Optional when relevant:

- rear/alternate 3/4;
- exploded composition;
- state progression strip;
- art anchor/socket overlay.

### Orientation convention

```text
+Y = nominal front
+X = nominal right
+Z = world up
```

For orientationless objects, choose the most characteristic front and keep it stable across variants.

### Gameplay camera

Until calibrated in the final game scene:

```text
projection: orthographic
azimuth: ~45° relative to nominal front
elevation: ~35° downward
```

The gameplay view is authoritative. Exact values are provisional calibration targets.

### Review environment

Use neutral ground/background, one soft dominant directional light, ambient fill and contact shadows. No cinematic depth of field, dramatic fog or post-processing that hides geometry.

### Review priority

```text
1. gameplay 3/4
2. gameplay silhouette
3. scale comparison
4. front / side / top
5. close-up diagnostics
```

A close-up cannot rescue an unreadable gameplay asset.

## 5. Stateful and modular assets

Render meaningful states side-by-side under identical camera/light, for example:

```text
intact → damaged → repaired
empty → partial → full
healthy → harvested → damaged
site → partial project → complete
```

For large projects, review at minimum early, recognizable partial and complete stages, plus damage/repair when required by the catalog.

Intermediate stages must look intentionally incomplete, not like missing exports.

Use exploded composition only for major pieces. Do not explode micro-detail.

## 6. Self-review rubric

Score applicable criteria from `0–3`:

```text
0 = wrong / missing
1 = weak / revision required
2 = acceptable
3 = strong
```

| Criterion | Weight | Core question |
|---|---:|---|
| Silhouette | 3 | Is it recognizable and functionally legible at gameplay distance? |
| Family/style consistency | 3 | Does it belong to the approved project grammar? |
| Proportion/scale | 3 | Is it correctly scaled and sufficiently exaggerated for interaction readability? |
| Form economy | 2 | Can geometry/detail be removed without losing value? |
| Faceting/planar language | 2 | Do facets describe form intentionally rather than add noise? |
| Material simplicity | 2 | Are shared flat materials sufficient? |
| Construction readability | 2 | If assembled, can major connections be understood? |
| State readability | 2 | If stateful, are catalog-required states distinguishable at gameplay distance? |
| Grounding/contact | 1 | Does it sit/use/contact the world convincingly? |
| Reference alignment | 2 | Does it follow textual + visual references without copying AI artifacts? |

Default art acceptance heuristic:

- no `0` in silhouette, family consistency or scale;
- no more than one `1` among weighted criteria;
- weighted average approximately `>= 2.35 / 3`;
- gameplay view independently acceptable.

Hard-fail examples include wrong style, texture-led identity, smooth generic asset-pack appearance, noisy faceting, unreadable silhouette, obviously wrong scale, unexplained monolithic project construction, invisible required states or fragile/thin forms inconsistent with the grammar.

Minor invisible topology imperfections and absence of decorative micro-detail do not block artistic acceptance.

## 7. Creator iteration guard

Use up to **4 self-review cycles** by default. Each cycle targets the largest remaining visual problem.

Do not spend iterations on details invisible from gameplay distance.

If a major criterion still fails after four cycles, report the unresolved visual conflict instead of polishing indefinitely.

## 8. Independent art review

Use a fresh reviewer context/subagent where practical. Give it:

- relevant asset-catalog row;
- optional art brief;
- relevant textual + visual references;
- canonical preview renders.

Do **not** initially provide the creator's self-justification.

The reviewer does not remodel. It returns:

```text
OUTCOME: PASS | CONDITIONAL PASS | FAIL

SCORES
- Silhouette: x/3
- Family consistency: x/3
- Proportion/scale: x/3
- Form economy: x/3
- Faceting: x/3
- Materials: x/3
- Construction: x/3 or N/A
- State readability: x/3 or N/A
- Grounding: x/3
- Reference alignment: x/3

TOP ISSUES
1. ...
2. ...
3. ...

HIGHEST-VALUE CORRECTION
...

OVERBUILT? no | mildly | yes
```

Return at most three corrections, ordered by gameplay value.

### Review outcome loop

- `PASS` → artistic gate passes.
- `CONDITIONAL PASS` → one focused creator correction.
- `FAIL` → up to two focused corrections, rerender and review again.
- Repeated failure for the same structural reason → escalate to human/design review.

Passing this art gate does not imply that functional/runtime validation has passed; the cross-cutting catalog may later track those gates separately.

## 9. Family consistency

When modeling later family members, inspect at least two approved siblings when available.

Variation should primarily come from proportion, part selection, bounded asymmetry, state, palette variant and composition. Never use increased detail as the primary variant mechanism.

## 10. Artistic acceptance definition

The artistic gate passes when:

- function/identity reads visually without explanatory text;
- silhouette works in the canonical gameplay view;
- family style and low-poly intensity are consistent;
- scale/contact are credible for Wilson interactions;
- materials use the simplest sufficient strategy;
- required visible states and composition are readable;
- no unnecessary new visual language was introduced;
- independent art review passes.

Prefer a simpler model that survives all review views over a sophisticated model that only looks good in isolation.