# Shape Language

## Purpose

This document constrains geometry so assets created by different humans or agents look like members of the same world.

## Global rules

1. Build from few, large forms before secondary pieces.
2. Prefer broad planes over smooth curvature.
3. Preserve asymmetry and authored irregularity, but keep it bounded.
4. Exaggerate gameplay-relevant dimensions when needed for recognition.
5. Avoid thin geometry unless the object semantically requires it.
6. Do not add bevels or subdivisions automatically. Every extra edge must earn its place in silhouette, deformation or state readability.

## Faceting level

The chosen baseline is **aggressive low-poly, not voxel**.

- circular objects should usually use low side counts;
- cylindrical trunks, logs, handles and poles should visibly facet at gameplay distance when large enough;
- large rocks should expose a small number of dominant planes;
- broad leaf surfaces may bend through 1–3 intentional folds rather than many subdivisions;
- curves may be approximated by segmented arcs.

Avoid two extremes:

- perfectly smooth primitive surfaces that hide the low-poly language;
- arbitrary triangulation noise that makes surfaces visually busy.

Facets should describe the form, not merely advertise polygon count.

## Nature grammar

### Rocks

Construct rocks from irregular convex masses.

Preferred:

- low vertex count;
- broad top/side planes;
- slightly flattened ground contact;
- asymmetrical silhouette;
- optional 2–3-piece compositions for larger formations.

Avoid:

- uniform ico-sphere appearance;
- hundreds of tiny facets;
- needle-like points;
- realistic erosion micro-detail.

### Palms

Trunk:

- 4–8-sided or similarly simple faceted cross section;
- several tapered vertical segments;
- slight bounded lean or bend;
- thickness exaggerated enough to remain readable.

Crown:

- small number of large fronds;
- fronds use broad blades or a few large segments;
- clear radial silhouette;
- avoid dozens of narrow leaflets.

Coconuts:

- chunky and slightly oversized;
- grouped in readable clusters;
- attachment locations stable enough for state variants and sockets.

### Bushes and ground vegetation

Prefer cluster assets composed from 3–9 large leaf masses or blades.

Use negative space between clusters. Do not create dense grass carpets from thousands of blades.

### Terrain and cliffs

Terrain should read as broad elevation masses. Cliff faces may be represented by large planar sections and modular rock compositions.

Do not sculpt realistic geological noise across every surface.

## Manufactured grammar

### Wood

Wooden construction should reveal assembly through geometry:

- logs;
- planks;
- poles;
- bindings;
- pegs only when visually useful.

Pieces may be uneven in length, width or alignment within controlled bounds.

Avoid perfect carpentry unless the source object is manufactured debris.

### Rope

At gameplay distance, rope is usually a semantic binding shape rather than a physically modeled fiber bundle.

Preferred:

- thick simplified loop/band;
- low-segment cylinder or curve;
- clearly visible knot mass only where useful.

### Metal

Metal debris and containers should be more geometric and regular than handmade wood, creating material contrast through form.

Use simple dents, bent panels or large deformations for damage states rather than surface scratches.

## Wilson grammar

Wilson uses the same low-detail philosophy but a **lower apparent faceting intensity**.

- head: simplified rounded/cranium mass with controlled planar transitions;
- torso: compact readable volume, not an ultra-thin caricature;
- hands: deliberately oversized enough to communicate manipulation;
- feet: stable readable forms for locomotion poses;
- hair: one coherent mass with a few major tufts;
- facial features: minimal but expressive.

Wilson should not look like he belongs to a different rendering engine; the distinction comes from smoother shape transitions and proportion, not from high-poly realism.

## Proportion exaggeration

Acceptable exaggerations include:

- coconut larger than realistic;
- hand tools thicker than realistic;
- rope bindings oversized;
- campfire stones larger and fewer;
- stool legs thicker;
- fruit larger;
- crab body/claws larger;
- shelter structural members thicker.

Exaggeration should improve recognition or animation contact.

## Silhouette tests

Before visual approval, render each family as:

1. filled black silhouette from canonical gameplay camera;
2. normal material render;
3. one scaled comparison beside Wilson mannequin.

Reject or revise assets whose family variants collapse into the same unreadable silhouette or whose important parts disappear at gameplay distance.

## Procedural variation bounds

Recommended variation sources:

- overall scale: small bounded range;
- nonuniform scale: subtle only;
- lean: moderate for vegetation;
- axial rotation: broad when anchors permit;
- part selection: preferred source of variation;
- material palette variant: bounded family-specific choice;
- damage/state pieces.

Avoid unrestricted vertex noise. Procedural variation must preserve the recognizable family identity and anchor contract.
