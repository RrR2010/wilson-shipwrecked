# Visual Guide

This document is the visual source of truth for humans and 3D-generation agents. Do not interpret `low-poly` as permission to produce arbitrary low-poly styles.

## Target

**A charming miniature tropical diorama rendered in real-time 3D through an orthographic 3/4 camera.** It should read with the immediacy of 2D while retaining the composability, anchors, rotation, lighting and procedural placement advantages of 3D.

The visual language should support humor and clear actions more than visual spectacle.

## Style keywords

Use:

- stylized;
- low-poly;
- chunky / simplified forms;
- miniature diorama;
- playful proportions;
- clean silhouettes;
- soft environmental shapes;
- restrained detail;
- readable at gameplay distance;
- coherent modular pieces.

Avoid:

- photorealism;
- PBR showcase aesthetics;
- noisy micro-detail;
- realistic human anatomy;
- high-frequency textures;
- thin fragile geometry;
- generic mobile-game asset-pack inconsistency;
- voxel or strict pixel-art appearance;
- excessive outlines unless adopted globally later.

## Camera

Initial target is a fixed or gently moving **orthographic 3/4 view**. Exact production values must be established by the vertical slice and then recorded here.

Until calibrated:

- elevation: roughly 30–40 degrees;
- world vertical remains visually clear;
- avoid extreme isometric flattening;
- important silhouettes must work from the gameplay camera, not only in turntables;
- assets should tolerate modest camera rotation but need not look equally optimal from every angle.

## Shape language

### Environment

Use broad, slightly irregular masses. Perfect primitives should normally be modified enough to feel authored. Rocks should have a few large planes rather than many tiny facets. Vegetation should use clusters rather than individually modeled leaves where possible.

### Manufactured objects

More geometric than nature but still imperfect. Wood can be slightly uneven; handmade structures should visibly communicate improvisation through shape rather than texture detail.

### Wilson

Wilson is the visual focal point. Target caricatured proportions with a large readable head/hands and short-to-medium limbs suitable for expressive generic actions. His silhouette must remain recognizable at the default camera distance.

Do not finalize Wilson's design through autonomous generation without explicit review. Character identity has a higher quality bar than environmental props.

## Materials

Prefer geometry and material blocks over texture detail.

- low material count per asset;
- mostly simple colors;
- subtle roughness differences only when useful;
- no photographic textures;
- no baked lighting in albedo;
- avoid tiny painted details that disappear at gameplay scale;
- palette variations should be parameterized where possible.

A formal palette may be added after visual exploration. Until then, optimize for harmonious tropical readability rather than hardcoded RGB values.

## Lighting

Target soft, readable lighting:

- one dominant soft directional source for sun/moon;
- ambient/environment fill;
- contact shadows that ground objects;
- day/night/weather may alter lighting but must preserve silhouettes;
- avoid dramatic contrast that makes ambient viewing tiring.

## Scale and proportions

Use a consistent Godot/Blender scale: **1 Blender unit = 1 meter** unless a later architecture decision changes it.

Gameplay readability may exaggerate dimensions. A coconut, axe handle or hand can be larger than realistic if this improves recognition and interaction animation.

## Geometry budget philosophy

Budgets are guardrails, not targets. Use the fewest polygons that preserve the intended silhouette.

Provisional ranges:

| Asset class | Typical triangle range |
| --- | ---: |
| Tiny prop | 20–300 |
| Common prop | 100–1,000 |
| Tree / vegetation hero | 300–2,000 |
| Modular structure piece | 100–2,000 |
| Character | define after prototype |

Agents must not add geometry merely to approach a budget.

## Modular visual design

Favor interchangeable families:

```text
Palm
├── trunk variants
├── crown/leaf-cluster variants
├── fruit sockets
└── state variants: healthy / damaged / stump

Shelter
├── foundation
├── wall sockets
├── door socket
└── roof socket
```

Procedural variation should primarily use:

1. part selection;
2. bounded scale changes;
3. bounded rotation/lean;
4. material/palette variants;
5. state-dependent parts.

Random deformation must preserve interaction anchors and recognizable silhouettes.

## Animation language

Favor a small library of expressive reusable actions over object-specific animation.

Initial vocabulary may include:

- idle variants;
- walk / jog;
- look / inspect;
- reach low / middle / high;
- pick up / put down;
- carry small / large;
- push / pull;
- swing/chop;
- hammer/work;
- dig;
- eat / drink;
- sit / sleep;
- talk / gesture;
- celebrate / frustrated reaction;
- stumble / fall.

Animation may be exaggerated. Props should attach to semantic character anchors rather than being baked into every animation.

## Visual state communication

Prefer visible world changes over labels:

- damaged tree loses parts or changes silhouette;
- project visibly accumulates components;
- wet objects may use a material state;
- storage physically accumulates objects when feasible;
- frequently traversed areas may develop paths;
- structures retain repairs, additions and improvisations.

## AI concept-generation prompt contract

When using an image or multimodal model for concepts, prompts should include this invariant block conceptually:

```text
Stylized low-poly game asset for Wilson Shipwrecked.
Miniature tropical diorama visual language.
Orthographic 3/4 gameplay view.
Chunky simplified geometry, large readable shapes, clean silhouette.
Minimal surface detail, no photographic textures, no micro-detail.
Designed to be recreated as modular real-time 3D geometry.
Show construction clearly; prioritize form over illustration effects.
```

Then specify asset role, gameplay scale, required states/variants, modular parts and semantic anchors. Avoid asking an image model for effects that cannot be reproduced by the runtime style.

## Visual review checklist

Every new asset family should be reviewed at gameplay camera distance for:

- silhouette;
- relative scale;
- style consistency;
- material simplicity;
- grounding/contact;
- anchor plausibility;
- interaction clearance;
- modular compatibility;
- visual distinction between relevant states;
- absence of unnecessary geometry/detail.

A technically valid GLB is not an accepted visual asset until it passes visual review.
