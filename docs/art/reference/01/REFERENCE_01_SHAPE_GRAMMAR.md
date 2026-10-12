# Reference 01 — Shape Grammar

## Purpose

This document translates the approved Wilson Shipwrecked visual direction into a comparison-oriented reference specification for artists and 3D-generation agents.

It supplements `docs/art/SHAPE_LANGUAGE.md`. That file defines the rules; this file defines what a visual reference sheet should demonstrate and how geometry should be judged.

The target is **aggressive low-poly, not voxel**: few large forms, broad intentional planes, strong silhouettes, restrained detail, and a softer faceting treatment for Wilson than for the environment.

---

# 1. Reference-sheet composition

A canonical Shape Grammar sheet should contain the following rows or zones.

## 1.1 Primitive reduction ladder

Show the same semantic form at several geometric intensities:

```text
TOO SMOOTH
    ↓
ACCEPTED BASELINE
    ↓
AGGRESSIVE BUT VALID
    ↓
TOO CRUDE / VOXEL-LIKE
```

Required examples:

- rock;
- log;
- palm trunk;
- broad palm frond;
- coconut;
- crate;
- stool;
- simple metal container.

The sheet should make the accepted range obvious without requiring text interpretation.

## 1.2 Silhouette families

Show black silhouettes only for:

- 4–6 rock variants;
- 3 palm variants;
- 3 bush/ground vegetation variants;
- 3 logs/branches;
- 3 crate/container forms;
- Wilson mannequin.

The purpose is to verify that variation is achieved by proportion and part selection rather than surface noise.

## 1.3 Plane hierarchy

For 2–3 representative assets, show a diagnostic version where dominant planes are visually separated.

Recommended assets:

- medium rock;
- palm trunk;
- crate.

The image should demonstrate that the eye reads:

```text
primary mass
→ secondary planes
→ optional tertiary construction detail
```

not dozens of equally important facets.

---

# 2. Global shape hierarchy

Every asset should be understandable in three passes.

## Pass A — primary mass

Recognizable at a small thumbnail.

Examples:

- rock = low irregular mass;
- crate = box;
- palm = leaning vertical trunk + radial crown;
- stool = seat plane + short support legs;
- shelter = triangular/leaning frame + roof mass.

## Pass B — structural decomposition

Readable at gameplay distance.

Examples:

- crate plank grouping;
- palm trunk segmentation;
- shelter poles and roof panels;
- tool head vs handle;
- rope bindings.

## Pass C — state / identity detail

Visible only where semantically valuable.

Examples:

- broken plank;
- repair brace;
- missing frond;
- fruit cluster;
- dent in metal container;
- rope replacement.

If an asset needs Pass C details to be recognizable, its primary shape is too weak.

---

# 3. Faceting targets by family

These are visual targets, not hard topology budgets.

| Family | Target treatment |
| --- | --- |
| small pebble | 5–10 dominant outer planes |
| medium rock | 8–20 dominant outer planes |
| large rock formation | 2–4 composed masses, each with broad planes |
| log / pole | visibly faceted cylinder, usually 5–8 sides |
| tool handle | 5–8 sides, slightly tapered |
| palm trunk | 5–8 sided sections, bounded bend/lean |
| coconut | chunky faceted ellipsoid, not smooth sphere |
| broad leaf | 1–3 intentional bends/folds |
| crate | planar; bevel only when silhouette/contact benefits |
| rope | simplified thick band/cylinder; fibers never modeled |
| Wilson | reduced faceting appearance; broader curved transitions |

These values should be interpreted from the gameplay camera, not from close-up wireframes.

---

# 4. Rock grammar

The reference sheet should compare at least these archetypes:

```text
small throwable
medium irregular
flat sittable
heavy impact stone
large landmark
rock formation
```

## Required visual traits

- asymmetrical profile;
- broad top/side planes;
- stable or slightly flattened ground contact;
- no uniform ico-sphere appearance;
- no spiky crystalline silhouette unless explicitly required;
- no high-frequency triangulation.

## Family differentiation

`flat sittable` must visibly provide a usable top plane.

`heavy impact stone` should look compact and dense.

`small throwable` should read clearly in Wilson's hand.

`large landmark` should be identifiable by silhouette from across the island.

---

# 5. Wood grammar

The sheet should show a progression:

```text
branch
→ straight stick
→ log
→ pole
→ plank
→ beam
→ assembled frame
```

## Natural wood

- irregular but bounded;
- tapered;
- broad faceting;
- occasional fork only when silhouette remains clean.

## Prepared wood

- straighter;
- still handmade;
- slightly uneven width/ends;
- no perfect industrial milling unless the piece is salvage.

## Manufactured salvage wood

- more regular dimensions;
- sharper planar construction;
- may retain paint/material role if visually simple.

The difference between natural, prepared, and salvaged wood should primarily come from geometry and proportion, not texture grain.

---

# 6. Foliage grammar

The reference should explicitly reject individually modeled tropical micro-leaves.

## Palm frond

Preferred construction:

```text
central broad blade / spine
+ a few large leaf segments
+ 1–3 intentional folds
```

The gameplay silhouette matters more than botanical accuracy.

## Bush

Preferred:

```text
3–9 large overlapping leaf masses
+ visible negative spaces
```

Avoid spherical green blobs and dense grass-card noise.

## Ground plants

Use a small number of thick readable blades/leaves. Variation should come from cluster proportions and lean.

---

# 7. Manufactured object grammar

Manufactured and improvised objects should contrast with nature through stronger planar logic.

## Handmade objects

Examples:

- stool;
- table;
- shelter;
- drying rack;
- tool rack.

Visual cues:

- slightly uneven lengths;
- imperfect alignment;
- oversized visible bindings;
- thick structural members;
- assembly visible from gameplay camera.

## Found manufactured objects

Examples:

- metal container;
- suitcase;
- barrel;
- bottle;
- bowling ball.

Visual cues:

- more regular geometry;
- simpler, cleaner symmetry;
- damage expressed with one or two large deformations;
- retain recognizable real-world identity.

This contrast is important: Wilson's constructions should look improvised beside washed-up manufactured objects.

---

# 8. Wilson vs world

Wilson must belong to the same world without inheriting the environment's harshest faceting.

Reference comparison should show Wilson beside:

- a palm trunk;
- a rock;
- a crate;
- a stool;
- a coconut.

Wilson target:

- head slightly oversized but not gothic/gaunt;
- torso compact and human-readable;
- hands large enough for manipulation readability;
- legs short-to-medium, not stick-thin;
- hair as one coherent mass with a few tufts;
- facial features minimal;
- smoother large transitions than rocks/props;
- no Don't-Starve-like needle limbs, extreme jaw/nose, or sinister silhouette.

Wilson should be the softest major shape in the scene, not a high-poly exception.

---

# 9. Negative examples to show explicitly

Every production reference sheet should include a small `AVOID` strip containing examples of:

- smooth rounded mobile-game rock;
- noisy triangulated rock;
- voxel/block object;
- palm with dozens of thin leaflets;
- perfect cylindrical log;
- tiny rope fibers;
- realistic wood grain doing the visual work;
- very thin furniture legs;
- excessive beveling;
- Wilson with exaggerated gothic/gaunt anatomy.

These examples are useful because agents often drift toward familiar low-poly conventions unless the rejected space is explicit.

---

# 10. Canonical render conditions

Reference comparisons must use:

- orthographic 3/4 camera;
- approximately 30–40 degree elevation until final calibration;
- neutral readable daylight;
- soft shadows;
- neutral ground plane;
- no depth-of-field;
- no dramatic rim lighting;
- no post-process that hides topology;
- Wilson mannequin for scale where relevant.

Render at both:

1. gameplay framing;
2. closer diagnostic framing.

Gameplay framing is authoritative.

---

# 11. Acceptance checklist

A reference asset is accepted when:

- the primary silhouette works as a thumbnail;
- facets describe volume rather than polygon noise;
- the form is clearly low-poly without becoming voxel-like;
- important interaction surfaces remain readable;
- thin geometry has been avoided unless necessary;
- family variants differ through proportion/parts;
- the asset works beside Wilson at canonical scale;
- manufactured vs natural construction remains distinguishable;
- no texture detail is required to explain the object;
- the asset still reads in a flat-color diagnostic render.
