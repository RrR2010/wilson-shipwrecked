# Palette and Materials

## Purpose

Keep different asset families visually coherent without requiring unique textures or hand-painted surface work.

The project deliberately favors **flat-color reusable materials, geometry, silhouette and lighting over texture-driven detail**. This is both an art-direction decision and a production/performance constraint.

The palette is role-based first. Exact production RGB/hex values should be calibrated in the canonical preview scene before becoming hard constraints.

## Core material rule

Default asset construction should assume:

```text
geometry
+ shared flat-color material
+ lighting
+ optional state parameter
```

not:

```text
unique texture set
+ baked surface detail
+ per-asset shader complexity
```

An asset that only looks convincing after a detailed texture has been added should normally be redesigned at the shape/material-block level.

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
- flat or parameterized base color;
- restrained roughness variation;
- limited metallic response only for actual metal;
- no baked lighting in base color;
- no high-frequency normal maps;
- no unique texture maps by default;
- no per-object texture painting required for production acceptance.

A typical common prop should ideally use **one to three shared material slots**, and many simple props should use only one.

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

These names are conceptual. Final implementation should prefer a smaller number of shared shader/material implementations with palette parameters where practical.

## Material blocks instead of textures

When an object needs multiple visual regions, prefer intentional material blocks or separate simple geometry.

Examples:

- coconut: husk vs exposed shell;
- tool: handle vs head vs binding;
- crate: wood vs optional metal fitting;
- repaired shelter: original thatch vs replacement patch;
- Wilson: skin, hair and clothing color regions.

Use these regions sparingly. A checkerboard of material slots is not a substitute for textures.

## State through materials

Material states should support large readable changes.

### Wet

- darker value;
- slightly stronger specular response where useful;
- preserve family hue identity;
- preferably implemented as a shared shader/state parameter rather than a new texture.

### Dry / weathered

- slightly lighter/desaturated;
- optionally shift roughness;
- avoid noisy scratch textures.

### Burned

- strongly reduced saturation/value;
- pair with geometry loss/deformation when gameplay-significant.

### Damaged

Damage should not rely on color alone. Prefer geometry/silhouette change plus optional material variation.

### Dirty / stained

Use only when functionally useful. Prefer a broad reusable mask/noise/decal treatment rather than hand-authored per-object dirt maps.

## Faceted shading

The low-poly identity may use flat or selectively flat shading on environment forms where it reinforces large planes.

Do not force universal flat shading if it harms Wilson, small rounded props or animation readability.

Recommended direction:

- rocks/cliffs: predominantly visible planar shading;
- trunks/logs: visible faceting with controlled normals;
- leaves: broad readable faces;
- manufactured containers: mostly clean planar surfaces;
- Wilson: smoother normal transitions than the environment.

## Procedural color variation

Procedural generators may select among approved palette variants using deterministic seeds.

Variation should be bounded by family. For example, a palm generator may choose from approved trunk and leaf variants but must not invent arbitrary RGB colors.

Prefer:

- shared material instance + parameter override;
- approved discrete palette choice;
- vertex color only if it meaningfully simplifies implementation and remains controlled.

Avoid generating unique materials for every procedural instance.

## Texture policy

### Default: no texture

Environment props, vegetation, rocks, construction pieces and most salvage should be designed to work with no texture maps.

### Allowed shared procedural surface treatment

Low-frequency shader noise may be used when it adds material distinction without becoming the source of object identity.

Potential uses:

- broad sand breakup;
- subtle water variation;
- very restrained wear modulation;
- broad wetness irregularity;
- subtle cloth/wood value breakup when required.

Noise must remain low-frequency at gameplay distance. Avoid procedural visual static.

### Allowed decals

Decals are valid for **specific semantic information or occasional authored wear**, especially when geometry would be wasteful.

Potential uses:

- faded manufactured labels;
- numbers/letters/sign markings;
- one-off salvage identity;
- broad rust/stain patch;
- repair marking;
- Wilson-specific authored details if later approved.

Prefer a small shared decal atlas over unique texture sets.

Decals should be optional enhancement. Removing them should not make the underlying asset visually incoherent.

### Functional texture exceptions

Textures may be justified when they enable a concrete function that cannot be represented efficiently through flat materials/geometry, for example:

- character facial expression atlas;
- readable map/paper content;
- signs or written clues;
- specific UI-like information embedded in a physical object;
- specialized water/effect masks;
- rare hero-object markings.

Such exceptions should be explicit rather than becoming precedent for ordinary props.

## Explicitly avoid

- photographic bark;
- detailed sand grains;
- individual leaf veins;
- realistic rock noise;
- scratches covering every manufactured object;
- texture-driven rope fibers;
- per-prop baked AO maps as a dependency;
- unique PBR texture sets for common props;
- texture painting as a required step in the standard agent pipeline;
- large texture atlases containing ordinary color information that could be material parameters.

## Performance direction

The material strategy should reduce:

- texture memory;
- asset download size;
- material/shader proliferation;
- authoring time;
- procedural-generation complexity;
- visual inconsistency between agents.

Performance should not be pursued by making every asset visually identical. Variation should come cheaply from:

```text
shape variants
part selection
bounded transforms
palette parameters
state attachments
shared shader parameters
```

## Art-direction implication

Because texture detail is intentionally constrained, visual quality must come from:

1. silhouette;
2. proportion;
3. shape rhythm;
4. controlled faceting;
5. composition/negative space;
6. coherent palette relationships;
7. soft readable lighting;
8. material roughness/specular contrast;
9. visible construction and repair history;
10. selective high-value accents.

This constraint should make the style stronger and more recognizable rather than merely cheaper.

## Calibration deliverable

Before mass production, build a material swatch scene containing:

- one primitive or representative mesh per material family;
- flat-color baseline version;
- daylight;
- dusk/night sample;
- wet/rain sample;
- one restrained procedural-noise example;
- one decal example;
- Wilson mannequin for relative contrast.

Once approved, record exact color and shader parameters in this document or a machine-readable palette manifest.
