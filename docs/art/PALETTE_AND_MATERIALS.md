# Palette and Materials

## Purpose

Keep different asset families visually coherent without requiring unique textures or hand-painted surface work.

The palette is role-based first. Exact production RGB/hex values should be calibrated in the canonical preview scene before becoming hard constraints.

## Palette strategy

Use a compact set of semantic color families:

- sand;
- stone;
- vegetation;
- wood;
- rope/fiber;
- metal;
- cloth;
- water;
- fire/ember;
- Wilson skin/hair/clothing.

Each family should normally contain a small tonal ladder rather than many unrelated colors.

Recommended structure:

```text
base
light
shadow/dark
state accent (optional)
```

Variation should remain recognizably inside the family.

## Tropical color behavior

The world should feel warm and colorful without becoming neon.

Prefer:

- warm sand;
- turquoise-to-blue water;
- yellow-green through deep green vegetation;
- warm brown wood;
- neutral-to-warm gray rocks;
- orange fire as a controlled high-saturation focal color.

Avoid filling the scene with equally saturated colors. Focal events should retain visual priority.

## Material model

Common environment assets should use simple reusable materials with low slot counts.

Default expectations:

- opaque materials;
- simple albedo/base color;
- restrained roughness variation;
- limited metallic response only for actual metal;
- no baked lighting in base color;
- no high-frequency normal maps;
- no unique texture maps unless they solve a specific visual problem that geometry/material blocks cannot solve.

## Suggested shared material concepts

```text
mat_sand_dry
mat_sand_wet
mat_stone_warm
mat_stone_wet
mat_leaf_green_a
mat_leaf_green_b
mat_leaf_dry
mat_wood_fresh
mat_wood_dry
mat_wood_weathered
mat_rope_fiber
mat_metal_dull
mat_metal_rusted
mat_cloth_neutral
mat_water_shallow
mat_water_deep
mat_charred
```

These names are conceptual. Final implementation may use a smaller shader/material set with palette parameters.

## State through materials

Material states should support large readable changes:

### Wet

- darker value;
- slightly stronger specular response where useful;
- preserve family hue identity.

### Dry / weathered

- slightly lighter/desaturated;
- avoid noisy scratch textures.

### Burned

- strongly reduced saturation/value;
- pair with geometry loss/deformation when gameplay-significant.

### Damaged

Damage should not rely on color alone. Prefer geometry/silhouette change plus material variation.

## Faceted shading

The low-poly identity may use flat or selectively flat shading on environment forms where it reinforces large planes.

Do not force universal flat shading if it harms Wilson, small rounded props or animation readability.

Recommended direction:

- rocks/cliffs: predominantly visible planar shading;
- trunks/logs: visible faceting with controlled normals;
- leaves: broad readable faces;
- manufactured containers: mostly clean planar surfaces;
- Wilson: smoother normal transitions than the environment.

## Color variation in procedural assets

Procedural generators may select among approved palette variants using deterministic seeds.

Variation should be bounded by family. For example, a palm generator may choose from approved trunk and leaf variants but must not invent arbitrary RGB colors.

## Texture policy

Textures are optional support, not the primary source of visual identity.

Potential valid uses later:

- subtle broad ground breakup;
- low-frequency water effects;
- a small shared atlas for character facial/clothing details;
- authored hero-object markings.

Invalid default uses:

- photographic bark;
- detailed sand grains;
- individual leaf veins;
- realistic rock noise;
- scratches covering every manufactured object;
- texture-driven rope fibers.

## Calibration deliverable

Before mass production, build a material swatch scene containing:

- one primitive or representative mesh per material family;
- daylight;
- dusk/night sample;
- wet/rain sample;
- Wilson mannequin for relative contrast.

Once approved, record exact color and shader parameters in this document or a machine-readable palette manifest.
