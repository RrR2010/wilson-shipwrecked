# Reference 04 — Materials, Lighting & Performance

## Purpose

Define how Wilson Shipwrecked should remain visually appealing while using an intentionally constrained rendering vocabulary:

- predominantly flat-color shared materials;
- minimal texture dependence;
- restrained shared shader effects;
- low material counts;
- geometry-led readability;
- soft lighting that reveals form;
- web-friendly asset size and runtime cost.

The goal is not merely to make production cheaper. The constraint should become part of the visual identity.

---

# 1. Art-direction thesis

The project should look authored because of:

```text
silhouette
+ proportion
+ color relationships
+ planar rhythm
+ lighting
+ composition
+ visible state/history
```

not because every surface contains hand-painted detail.

A strong Wilson Shipwrecked frame should remain attractive in a diagnostic render where all texture maps are disabled.

---

# 2. Default material stack

For most world assets, target:

```text
shared shader
+ flat base-color parameter
+ roughness parameter
+ optional state parameter
```

Optional state parameters may include:

- wetness;
- burn/char amount;
- broad weathering;
- highlight/accent variant.

Common props should not require dedicated material graphs.

---

# 3. Material-family contrast

Even with flat colors, different materials should feel distinct through controlled combinations of color, roughness, metallic response and geometry.

| Family | Visual response |
| --- | --- |
| sand | matte, warm, low specular emphasis |
| stone | matte-to-medium roughness, broad planar lighting |
| dry wood | matte, warm, faceted |
| wet wood | darker, modest specular lift |
| foliage | matte/satin, strong color blocking |
| rope/fiber | matte, slightly lighter/desaturated than wood |
| dull metal | cool/neutral, lower roughness than wood, restrained metallic response |
| rusty/weathered metal | warmer/duller with optional broad wear mask |
| cloth | matte, softer silhouette behavior |
| water | dedicated simple shader; visually distinct from solids |

Material identity should never depend on tiny surface noise.

---

# 4. Palette architecture

Use a compact role-based palette with bounded variants.

Recommended semantic groups:

```text
sand
stone
wood
fiber
leaf
leaf_dry
water
metal
cloth
charcoal
fire
skin
hair
Wilson_clothes
rare_accent
```

Each group should normally provide only a few approved values.

A useful production structure is:

```text
base
lighter variant
darker variant
state variant
```

Avoid dozens of near-identical material colors that create material-instance sprawl.

---

# 5. Value hierarchy

A scene needs value separation even without texture.

Target a stable hierarchy:

- Wilson should remain clearly separable from the ground;
- interaction props should not disappear into same-value backgrounds;
- rocks should remain distinguishable from both wet sand and tree trunks;
- shelter interiors should remain readable without becoming black holes;
- fire and rare objects may use stronger local contrast;
- foliage clusters should contain enough value variation to separate overlapping silhouettes.

Value relationships should be validated in grayscale screenshots.

---

# 6. Saturation hierarchy

Do not distribute saturation uniformly.

Suggested hierarchy:

```text
low-to-medium:
  sand, rock, wood, rope, common salvage

medium:
  foliage, cloth, Wilson clothing

high but controlled:
  fruit, crab, fire, rare found object, interaction/event accents
```

This gives the game focal hierarchy without outlines or texture detail.

---

# 7. Facet lighting as visual detail

Because geometry is aggressively low-poly, light across broad planes becomes a major source of visual richness.

This means:

- plane orientation should be intentional;
- random triangulation is harmful;
- rocks need useful dominant faces;
- logs/trunks benefit from controlled visible sides;
- foliage planes should create readable light/dark grouping;
- flat/split normals should be authored by family rather than globally forced.

Good low-poly lighting produces visual complexity almost for free.

---

# 8. Canonical daylight lighting

Recommended baseline:

- one dominant directional sun;
- broad ambient/sky fill;
- soft but visible contact shadows;
- restrained ambient occlusion if runtime implementation supports it cheaply;
- no heavy cinematic grading;
- no permanent rim lights attached to characters/props.

The sun angle should reveal facets without causing every object to split into extreme black/white halves.

Target a comfortable ambient-viewing scene rather than dramatic concept-art contrast.

---

# 9. Shadow strategy

Shadows are important because flat materials otherwise risk looking ungrounded.

Priority:

1. Wilson contact shadow;
2. structural object grounding;
3. palm/tree shadows;
4. large prop shadows;
5. small-prop shadows only where performance allows.

Avoid extremely high-resolution shadow requirements for tiny objects.

If necessary, optimize shadow casting by asset class rather than degrading all lighting equally.

---

# 10. Night and dusk

Night should preserve silhouette readability.

Use:

- cooler ambient fill;
- warm campfire/local-light contrast;
- restrained overall darkness;
- readable ground plane;
- no dependence on emissive texture detail.

The game is an ambient diorama, so the scene should remain legible when viewed casually rather than requiring adaptation to near-black values.

---

# 11. Wetness without textures

Wetness can be communicated through shared shader parameters:

```text
base color → darker
roughness → lower
specular → modestly stronger
```

Geometry/state may reinforce it through:

- puddles;
- dripping/leaning cloth if implemented;
- darkened ground regions;
- displaced/flattened materials.

Do not require bespoke wet maps per object.

---

# 12. Weathering without textures

Preferred order of techniques:

1. component replacement / repair geometry;
2. large color-block change;
3. shared low-frequency shader noise;
4. small reusable decal;
5. unique texture only as an explicit exception.

Examples:

- aged shelter: mismatched patch + slightly desaturated material;
- rusted salvage: broad warm rust region/noise, not hundreds of scratches;
- old crate: broken plank or faded decal, not unique wood texture;
- used stool: replacement binding or slightly darker contact surface.

---

# 13. Decal strategy

Decals should be rare enough to remain meaningful.

Use them for:

- labels;
- signage;
- numbers;
- broad stains/rust patches;
- occasional salvage markings;
- authored clues;
- identity on rare objects.

Prefer one or a few small shared atlases.

Common natural assets should almost never need decals.

---

# 14. Noise strategy

Shader noise is not a substitute for authored materials.

Valid noise should be:

- low frequency;
- low contrast;
- reusable;
- stable in world/object space as appropriate;
- invisible as 'noise' from gameplay distance.

Potential applications:

- broad sand value variation;
- slight water breakup;
- subtle wetness irregularity;
- restrained wear on common materials.

Avoid noise that makes low-poly facets look dirty or visually busy.

---

# 15. Material-slot discipline

Recommended targets:

| Asset class | Typical target |
| --- | ---: |
| single-material natural prop | 1 slot |
| simple constructed prop | 1–3 slots |
| tool | 2–3 slots |
| modular structure piece | 1–2 slots |
| found manufactured prop | 1–3 slots |
| Wilson | define separately, but keep compact |

Slot count should not grow merely to add local color variation.

---

# 16. Draw-call / instance direction

Art production should favor reuse:

- shared materials;
- repeated modular parts;
- procedural variants based on transforms and part selection;
- instancing where supported;
- bounded palette parameters rather than duplicated resources.

Avoid creating visually identical materials as separate resources because two agents generated them independently.

Material naming and registration should be centralized.

---

# 17. Texture-memory direction

Default common world assets should contribute essentially no unique texture memory.

Texture budget should be reserved for high-value functions:

- Wilson face/expression needs;
- signs/writing/maps;
- rare semantic decals;
- water/effect masks;
- UI-linked physical objects if required.

This should keep downloads small and allow a broader object vocabulary without proportional texture growth.

---

# 18. Geometry vs texture trade-off

The project may spend a small amount of extra geometry when it replaces a recurring texture-authoring burden and improves gameplay silhouette.

Good geometry spending:

- broad rock planes;
- visible rope bindings;
- shelter repair patch;
- oversized tool head;
- separated fruit cluster;
- bent/dented silhouette.

Bad geometry spending:

- modeled scratches;
- wood grain grooves;
- rope fibers;
- tiny leaf veins;
- decorative rivet fields;
- micro-bevels on every edge.

The rule is to spend geometry on **semantic shape**, not surface texture simulation.

---

# 19. What makes a flat-material scene beautiful

Reference reviews should explicitly judge:

## Shape rhythm

Mix vertical palms, low rocks, horizontal logs, triangular shelter masses and sparse round props.

## Negative space

Do not fill every patch of ground. Empty sand/water regions make silhouettes readable.

## Scale contrast

Combine large landmarks, medium functional props and a few small accents.

## Color grouping

Use coherent clusters instead of random prop colors.

## Focal hierarchy

Wilson, active projects, fire, rare finds and animals should naturally attract attention.

## Imperfect composition

Camp layouts should feel accumulated rather than grid-aligned, while still remaining readable.

## Persistent history

Repairs, material stacks, project stages and preferred locations provide richness that textures normally try to fake.

---

# 20. Visual QA diagnostics

Every golden/reference scene should be reviewed using:

1. normal final material view;
2. grayscale screenshot;
3. flat unlit/base-color view;
4. silhouette view;
5. material-slot count report;
6. texture-dependency report;
7. gameplay-camera screenshot.

An asset should fail review if it only looks good in close-up or after a texture/noise effect is enabled.

---

# 21. Reference-sheet deliverable

The canonical Materials & Lighting sheet should show:

- flat-color swatches for all semantic material families;
- representative rock, wood, foliage, rope, metal and cloth objects;
- the same objects under daylight and wet state;
- one dusk/night comparison;
- one subtle procedural-noise example beside an intentionally excessive rejected example;
- one decal example on manufactured salvage;
- a grayscale composition test;
- Wilson mannequin among representative materials;
- a compact camp vignette with all textures disabled except explicitly functional exceptions.

---

# 22. Acceptance criteria

The rendering direction is accepted when:

- common assets look complete with no texture maps;
- materials remain distinguishable through color/roughness/form;
- facets produce attractive lighting variation;
- scene readability survives grayscale review;
- wet/weathered states use shared parameters effectively;
- decals remain occasional rather than ubiquitous;
- noise is subtle and low-frequency;
- material counts stay compact;
- the style feels intentional rather than merely under-detailed;
- the runtime/download cost remains compatible with a persistent web-friendly diorama.
