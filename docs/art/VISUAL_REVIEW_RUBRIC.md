# Visual Review Rubric

## Purpose

Provide a compact, repeatable artistic review standard for creator agents, reviewer subagents and humans.

The rubric is intentionally biased toward gameplay readability, family consistency and production efficiency rather than close-up polish.

---

# 1. Review outcomes

Use one of:

- **PASS** — production-ready artistically;
- **CONDITIONAL PASS** — strong asset with one focused correction needed;
- **FAIL** — structural visual problem; requires revision before acceptance.

A reviewer should not fail an asset for a minor issue that cannot be seen in the canonical gameplay view.

---

# 2. Scoring scale

Score each criterion from `0` to `3`.

```text
0 = fundamentally wrong / missing
1 = weak / clearly needs revision
2 = acceptable / minor issues
3 = strong / clearly meets project target
```

---

# 3. Core criteria

## A. Primary silhouette — weight 3

Questions:

- is the object recognizable from the canonical gameplay view?
- does the silhouette communicate its dominant function?
- do thin pieces disappear?
- are there accidental tangencies or noisy edges?

Automatic major issue if the asset only reads because of close-up texture/detail.

## B. Family/style consistency — weight 3

Questions:

- does it belong to the approved Wilson Shipwrecked grammar?
- is low-poly intensity consistent with comparable assets?
- are forms chunky, authored and readable rather than generic or arbitrary?
- does it avoid introducing a new visual language?

## C. Proportion and gameplay scale — weight 3

Questions:

- is the size plausible relative to Wilson and related props?
- are interaction-relevant dimensions exaggerated enough to read?
- does it avoid fragile/thin realism?

## D. Form economy — weight 2

Questions:

- does every meaningful piece contribute to silhouette, state, construction or interaction?
- is geometry being used instead of unnecessary texture detail?
- could the asset lose detail and remain equally effective?

Overbuilt assets lose points even when visually attractive.

## E. Faceting / planar language — weight 2

Questions:

- do facets describe the form intentionally?
- is the object neither overly smooth nor arbitrarily noisy?
- do large planes catch light clearly?

## F. Material simplicity — weight 2

Questions:

- are flat/shared material blocks sufficient?
- is the slot count restrained?
- are roughness/specular differences meaningful?
- does the asset avoid unnecessary unique texture dependency?

## G. Construction readability — weight 2 when applicable

For manufactured/improvised objects:

- can the viewer understand how major parts connect?
- are bindings/supports visible enough?
- does modular construction look intentional?

Use `N/A` when not applicable.

## H. State readability — weight 2 when applicable

For stateful assets:

- are important states distinguishable from gameplay distance?
- does damage involve broad visible change rather than micro-detail?
- are repaired states visibly historical rather than reset to pristine?

Use `N/A` when not applicable.

## I. Grounding and contact — weight 1

Questions:

- does the object sit convincingly on the ground/support?
- are contact points stable and legible?
- do furniture/tools/structures feel physically usable?

## J. Reference alignment — weight 2

Questions:

- does it follow relevant textual and visual sheets?
- has it preserved the grammar rather than copying image-generation artifacts?
- does it avoid prohibited traits from the references?

---

# 4. Acceptance heuristic

A practical default:

- no score `0` in A/B/C;
- no more than one score `1` among weighted criteria;
- weighted average roughly `>= 2.35 / 3`;
- canonical gameplay view must be acceptable independently of close-up views.

This is a review aid, not a mathematical substitute for judgment.

---

# 5. Hard-fail conditions

Normally fail the asset when any of the following is visible:

- wrong art style;
- photorealistic or texture-led surface identity;
- smooth generic asset-pack appearance inconsistent with the project;
- noisy arbitrary triangulation;
- unreadable gameplay silhouette;
- obviously wrong scale;
- project/modular object represented as an unexplained monolithic block;
- important state differences invisible at gameplay distance;
- thin fragile construction that conflicts with the approved grammar;
- Wilson character drifting into gothic / excessively angular / different-engine appearance.

---

# 6. Minor issues that should not block acceptance

Usually do not fail solely for:

- tiny asymmetry differences from a sheet;
- hidden topology choices with no visual impact;
- subtle roughness variation;
- small back-side imperfections not relevant to normal views;
- absence of decorative micro-detail;
- differences from concept art caused by simplifying for production.

Production simplification is often desirable.

---

# 7. Reviewer output format

Recommended response:

```text
OUTCOME: PASS | CONDITIONAL PASS | FAIL

SCORES
- Silhouette: 3/3
- Family consistency: 2/3
- Proportion/scale: 3/3
- Form economy: 2/3
- Faceting: 3/3
- Materials: 3/3
- Construction: 2/3
- State readability: N/A
- Grounding: 3/3
- Reference alignment: 2/3

TOP ISSUES
1. ...
2. ...
3. ...

HIGHEST-VALUE CORRECTION
...

OVERBUILT? no | mildly | yes
```

Do not return a long redesign wishlist.

The reviewer should identify at most **three** corrections, ordered by gameplay value.

---

# 8. Independent-review instruction

The reviewer should behave as an art reviewer, not as the original creator defending prior decisions.

It should:

- inspect the images first;
- compare against the brief and relevant references;
- assume any invisible implementation detail is irrelevant to artistic acceptance;
- prefer simpler corrections;
- explicitly call out when the asset is more detailed than necessary;
- prioritize canonical gameplay view over close-up aesthetics.

---

# 9. Family review

When reviewing a generated family rather than one asset, also inspect:

- whether silhouettes vary enough;
- whether variants still share one visual grammar;
- whether scale variation is bounded;
- whether one variant is accidentally much more detailed;
- whether procedural randomness creates outliers;
- whether state variants remain recognizable as the same underlying object.

The best family creates variety without appearing assembled from unrelated asset packs.

---

# 10. Project-stage review

For evolving projects, review the sequence as a whole.

Ask:

- can the viewer see meaningful progress between stages?
- do intermediate stages look intentionally buildable?
- does functionality plausibly increase with visible structure?
- do repairs add history rather than erase it?
- is the final asset still readable despite accumulated additions?

If later stages become visually noisy, simplify instead of continually adding detail.
