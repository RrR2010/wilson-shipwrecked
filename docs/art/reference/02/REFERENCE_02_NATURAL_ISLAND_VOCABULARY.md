# Reference 02 — Natural Island Vocabulary

## Purpose

Define the visual vocabulary for terrain, rocks, palms, ground vegetation, water-edge forms and renewable natural resources.

This reference is intentionally production-oriented. It should help an agent generate multiple compatible natural families without inventing a new style for every biome element.

The island should feel tropical, readable and authored, but not lush through micro-detail. Variety comes from silhouette, clustering, scale, lean, state and composition.

---

# 1. Natural hierarchy

Natural assets should generally follow:

```text
large land mass
→ medium landmark masses
→ resource-bearing families
→ small readable clusters
→ sparse accents
```

The environment should not depend on dense scatter to feel alive.

A good composition should still read if 30–50% of small decorative elements are removed.

---

# 2. Terrain vocabulary

## Required terrain roles

- dry sand;
- wet shoreline sand;
- compacted/worn path;
- soil patch;
- mud/puddle state;
- shallow water edge;
- tide pool;
- low rock shelf;
- low slope;
- small cliff/raised mass.

## Visual treatment

Terrain should use broad elevation changes and a low-frequency silhouette.

Avoid:

- noisy sculpted sand;
- procedural micro-dunes everywhere;
- realistic beach displacement;
- dense pebble scatter as a requirement for readability.

Persistent history states such as paths, disturbed soil and puddles should be communicated with broad shape/material regions.

---

# 3. Rock family sheet

A canonical natural sheet should show these six roles together:

| Role | Key visual property |
| --- | --- |
| throwable stone | hand-readable, compact |
| heavy stone | dense squat mass |
| medium irregular rock | general obstacle/resource |
| flat rock | usable top plane |
| landmark rock | unique silhouette |
| rock formation | 2–4 composed masses |

## Variation axes

Allowed:

- width/height ratio;
- dominant plane angle;
- top flattening;
- 1–2 bounded protrusions;
- palette role;
- wet/mossy state;
- composition count.

Avoid vertex noise as the main source of variants.

---

# 4. Palm family sheet

The palm is a signature family and should receive stronger consistency constraints.

## Trunk variants

Target at least:

- short/upright;
- medium/slight lean;
- tall/leaning;
- bent landmark variant.

Shared rules:

- faceted sections;
- moderate taper;
- broad readable lean;
- no high-frequency bark rings;
- trunk damage represented by missing/chipped large pieces if needed.

## Crown variants

Target:

- compact crown;
- wide radial crown;
- asymmetric wind-shaped crown.

Use a small number of large fronds.

## Fruit states

Show:

```text
no fruit
small cluster
full fruiting cluster
partially harvested
```

Fruit should be slightly oversized to remain readable.

## Damage states

Show:

```text
healthy
missing fronds
damaged trunk
felled
stump
```

The family should preserve recognizable identity through state changes.

---

# 5. Bush and shrub vocabulary

Use a small set of family archetypes instead of dozens of species.

Recommended:

- broad-leaf shrub;
- low dense bush;
- sparse spiky tropical plant;
- fruit-bearing bush;
- fiber-bearing plant.

Each family should be built from a few major leaf masses with visible negative space.

States may include:

```text
young
mature
harvestable
harvested
recovering
dry/damaged
```

---

# 6. Ground vegetation

Ground vegetation should support composition without becoming visual noise.

Recommended families:

- grass clump;
- broad-leaf clump;
- small fern-like clump;
- coastal plant cluster;
- small flowering accent.

Rules:

- 3–9 major blades/leaves per clump;
- thick readable silhouettes;
- low density by default;
- cluster scale differences more important than individual blade detail.

---

# 7. Tide pool vocabulary

Tide pools matter functionally and narratively, so they should read as places, not water decals.

A tide-pool composition may include:

- shallow irregular basin;
- 2–5 framing rocks;
- distinct water region;
- optional shell/seaweed accents;
- crab/burrow interaction zone;
- wet-state border.

States:

```text
low water
normal
high water
disturbed
occupied
```

The location should remain recognizable when no animal is present.

---

# 8. Natural resource piles and remains

The island should visibly retain natural by-products.

Reference families:

- fallen branch;
- fallen palm frond;
- driftwood;
- coconut cluster on ground;
- shell cluster;
- small stone pile;
- harvested plant remains;
- stump;
- dead/dry plant.

These help communicate weather, harvesting and history without UI.

---

# 9. Natural color blocking

Natural families should remain separable through broad material roles:

- sand/light warm neutral;
- wet sand darker/cooler neutral;
- rock charcoal/gray-brown range;
- trunk warm muted brown;
- foliage olive/jungle green range;
- dry foliage straw/ochre;
- water teal/turquoise role;
- fruit/accent colors used sparingly.

Exact palette values belong to the palette reference. The key rule here is that color should reinforce large forms rather than add speckled variation.

---

# 10. Natural reference sheet requirements

The visual sheet should include:

1. six rock roles side by side;
2. four palm trunks with three crown variants;
3. palm fruit and damage states;
4. four shrub/plant families;
5. four ground clump families;
6. one tide-pool composition;
7. one shoreline strip showing dry → wet → water transition;
8. a small set of fallen/natural remains;
9. Wilson mannequin for scale;
10. one small gameplay-camera vignette combining all families.

The vignette should not use post-processing or dense decoration to hide inconsistencies.

---

# 11. Acceptance criteria

Natural vocabulary is accepted when:

- rocks do not look like repeated ico-spheres;
- palms remain recognizable with few fronds;
- foliage does not require alpha-card micro-detail;
- terrain reads through large masses;
- natural families remain distinct at gameplay scale;
- harvest/damage states alter silhouette where relevant;
- the environment feels tropical without relying on dense scatter;
- all families can plausibly be generated procedurally with bounded variation.
