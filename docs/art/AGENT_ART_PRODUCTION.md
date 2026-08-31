# Artistic 3D Agent Production Contract

## Purpose

This is the single operational art contract for autonomous 3D modeling agents. It covers artistic source precedence, modeling iteration, canonical previews, self-review, independent review and acceptance.

It intentionally excludes Blender/MCP/export implementation details. Those remain in `../ASSET_PIPELINE.md` and `../ASSET_SPEC.md`.

## 1. Source precedence

For a modeling task, read only what is needed, in this order:

1. `../VISUAL_GUIDE.md` — project visual source of truth.
2. `ART_DIRECTION.md`, `SHAPE_LANGUAGE.md`, `PALETTE_AND_MATERIALS.md`, `SCALE_CAMERA_AND_READABILITY.md` — art-system constraints.
3. The relevant `reference/REFERENCE_*.md` plus its approved `reference/visual/*.png` sheet.
4. The matching row in `production/`.
5. The family/asset brief, when one exists.

The brief is the immediate task contract, but it cannot override higher-tier visual rules.

Do not read Rounds 1–10 as the default modeling prompt. They are historical design evidence.

## 2. Brief granularity

Use the smallest sufficient brief:

- **Grammar-only task** — trivial variant fully covered by an approved family grammar; needs ID, family, approximate dimensions, state/variant and required art anchors.
- **Family brief** — reusable family with shared construction, variation bounds and states.
- **Asset-specific brief** — modular/stateful/rare/high-risk asset such as shelter, raft, dock, mystery container or Wilson.

Do not create one long bespoke document for every rock, plank, bowl or coconut.

## 3. Modeling loop

```text
READ TASK
→ STATE PRIMARY VISUAL READ
→ BLOCK OUT
→ APPLY FAMILY GRAMMAR
→ APPLY MATERIAL BLOCKS
→ RENDER CANONICAL PREVIEWS
→ SELF-REVIEW
→ FOCUSED REVISION
→ INDEPENDENT REVIEW
→ FINAL CORRECTION
→ ACCEPT OR ESCALATE
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

Use:

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

The gameplay view is authoritative. The exact values are provisional calibration targets, not immutable world-domain constants.

### Review environment

Use neutral ground/background, one soft dominant directional light, ambient fill and contact shadows. No cinematic depth of field, dramatic fog or post-processing that hides geometry.

### Review priority

When views disagree:

```text
1. gameplay 3/4
2. gameplay silhouette
3. scale comparison
4. front / side / top
5. close-up diagnostics
```

A close-up cannot rescue an unreadable gameplay asset.

## 5. Stateful and modular assets

For meaningful states, render side-by-side under identical camera/light, e.g.:

```text
intact → damaged → repaired
empty → partial → full
healthy → harvested → damaged
site → partial project → complete
```

For large projects, review at minimum:

- early stage;
- recognizable partial stage;
- complete stage;
- damage/repair state when relevant.

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
| Silhouette | 3 | Is the object recognizable and functionally legible at gameplay distance? |
| Family/style consistency | 3 | Does it belong to the approved Wilson Shipwrecked grammar? |
| Proportion/scale | 3 | Is it correctly scaled and sufficiently exaggerated for interaction readability? |
| Form economy | 2 | Can geometry/detail be removed without losing value? |
| Faceting/planar language | 2 | Do facets describe form intentionally rather than add noise? |
| Material simplicity | 2 | Are shared flat materials sufficient? |
| Construction readability | 2 | If assembled, can major connections be understood? |
| State readability | 2 | If stateful, are required states distinguishable at gameplay distance? |
| Grounding/contact | 1 | Does it sit/use/contact the world convincingly? |
| Reference alignment | 2 | Does it follow textual + visual family references without copying AI artifacts? |

Default acceptance heuristic:

- no `0` in silhouette, family consistency or scale;
- no more than one `1` among weighted criteria;
- weighted average approximately `>= 2.35 / 3`;
- gameplay view independently acceptable.

Hard-fail examples include wrong style, texture-led identity, smooth generic asset-pack appearance, noisy faceting, unreadable silhouette, obviously wrong scale, unexplained monolithic project construction, invisible important states or fragile/thin forms inconsistent with the grammar.

Minor invisible topology imperfections and absence of decorative micro-detail do not block acceptance.

## 7. Creator iteration guard

Use up to **4 self-review cycles** by default. Each cycle targets the largest remaining visual problem.

Do not spend iterations on details invisible from gameplay distance.

If a major criterion still fails after four cycles, report the unresolved design conflict instead of polishing indefinitely.

## 8. Independent review

Use a fresh reviewer context/subagent where practical. Give it:

- asset brief;
- relevant textual + visual references;
- canonical preview renders.

Do **not** initially provide the creator's self-justification. The reviewer evaluates requested intent versus rendered result.

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

- `PASS` → accept.
- `CONDITIONAL PASS` → one focused creator correction.
- `FAIL` → up to two focused corrections, rerender and review again.
- Repeated failure for the same structural reason → escalate to human/design review.

## 9. Family consistency

When modeling later family members, inspect at least two approved siblings when available.

Variation should primarily come from:

- proportion;
- part selection;
- bounded asymmetry;
- state;
- palette variant;
- composition.

Never use increased detail as the primary variant mechanism.

## 10. Acceptance definition

An asset is artistically accepted when:

- function/identity reads without explanatory text;
- silhouette works in the canonical gameplay view;
- family style and low-poly intensity are consistent;
- scale/contact are credible for Wilson interactions;
- materials use the simplest sufficient strategy;
- required states and composition are readable;
- no unnecessary new visual language was introduced;
- independent review passes.

Prefer a simpler model that survives all review views over a sophisticated model that only looks good in isolation.