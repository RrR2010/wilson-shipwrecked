# Reference 08 — Weather & Damage

## Purpose

Define how weather, exposure, damage, repair and environmental opportunity should read visually in Wilson Shipwrecked while preserving the project's aggressive low-poly, flat-material and performance-first art direction.

This reference is not a simulation specification. It constrains how state changes should be communicated visually so agents do not invent expensive texture-heavy solutions.

---

# 1. Core direction

Weather should change the scene through a combination of:

```text
material state
+ large geometric state
+ object displacement
+ accumulated debris/history
```

Avoid relying on:

- unique damage textures;
- per-object grunge maps;
- high-frequency wetness masks;
- realistic splintering;
- dense particle residue;
- micro-scratches or surface noise.

The scene should remain readable at the canonical orthographic gameplay camera.

---

# 2. Shared visual state vocabulary

Preferred reusable states:

```text
dry
wet
soaked
drying

intact
stressed
loose
damaged
failed
repaired
reinforced

clean
muddy
charred

stable
displaced
obstructed

empty
partial
full
```

Not every asset needs every state.

These should be implemented through shared material parameters and interchangeable geometry where possible.

---

# 3. Wetness

## 3.1 Material treatment

Wetness should usually use shared shader/material parameters rather than textures.

Expected visual changes:

- darker base value;
- slightly increased specular response;
- slightly reduced roughness where appropriate;
- preserve original hue family;
- no high-frequency droplets or streak textures by default.

## 3.2 Geometry treatment

Only add geometry when wetness changes shape or behavior visibly.

Examples:

- cloth sags;
- leaves/fronds bend lower;
- puddles appear;
- soaked bedding compresses;
- water fills containers.

Do not add wetness geometry to every object.

---

# 4. Rain scene language

A readable rainy state should be constructed from a small number of large cues:

```text
cooler lighting
+ darker ground/material values
+ puddles / shallow standing water
+ selected dripping/sagging objects
+ weaker/smoking fire
```

The rain itself may be visually lightweight. The world response is more important than dense precipitation rendering.

## Reference-sheet requirements

Show the same compact camp scene in:

1. dry daylight;
2. active rain;
3. immediately after rain;
4. drying state.

The comparison should demonstrate that state readability does not depend on texture detail.

---

# 5. Ground response

## Dry sand

- warm matte color;
- broad planar terrain;
- no grain texture required.

## Wet sand

- darker value;
- slightly smoother response;
- shoreline/wet boundaries should be broad and readable.

## Mud

Use:

- darker, slightly saturated earth color;
- broad depressed patches;
- optional simple footprint/path decals only if systemically valuable.

Avoid sculpting detailed mud displacement.

## Puddles

Puddles should be simple shallow shapes with clean silhouettes and shared water material.

Use a few meaningful puddles rather than covering the scene with many tiny ones.

---

# 6. Wind response hierarchy

Objects should visually fall into four categories.

## Wind-insensitive

Examples:

- large rocks;
- heavy logs;
- fixed posts;
- large containers.

These remain visually stable.

## Wind-reactive flexible

Examples:

- palm fronds;
- cloth;
- rope;
- hanging objects;
- broad leaves.

Use broad bending or rotation, not dense cloth simulation unless specifically justified.

## Wind-displaceable

Examples:

- loose leaves;
- light scraps;
- papers;
- small cloth pieces;
- empty lightweight containers.

These may change position and contribute to post-storm history.

## Wind-dangerous

Examples:

- unsecured panels;
- loose roof parts;
- hanging heavy debris.

Their danger should come from recognizable mass and displacement, not special effects.

---

# 7. Structural damage grammar

Preferred progression:

```text
intact
→ stressed
→ loose
→ partially damaged
→ detached / failed
→ repaired
→ reinforced
```

A single structure should expose enough modular pieces that these states can be created without replacing the whole asset.

## Visual signs of stress

Use:

- changed angle;
- slight sag;
- loosened binding;
- shifted panel;
- missing component;
- temporary brace.

Avoid micro-cracks unless they are large enough to change silhouette/readability.

---

# 8. Damage by material

## Wood

Good damage cues:

- broken end;
- missing section;
- snapped plank;
- replacement plank;
- brace added;
- binding retied.

Avoid modeled splinters unless they are few and silhouette-significant.

## Rope / fiber

Good cues:

- loosened wrap;
- missing binding;
- additional wrap;
- visibly thicker repair bundle.

## Thatch / foliage panels

Good cues:

- missing chunk;
- uneven roof edge;
- sagging section;
- mismatched replacement panel.

## Metal

Good cues:

- large dent;
- bend;
- missing panel;
- repaired strap;
- different material piece attached.

Rust should primarily be represented with a material/color variant or occasional shared decal, not unique texture sets.

## Cloth

Good cues:

- torn silhouette;
- shortened edge;
- patch panel;
- sag;
- retied corner.

---

# 9. Fire and heat states

Shared campfire visual progression:

```text
prepared
→ smoking
→ burning
→ low fire
→ embers
→ extinguished
→ charred remains
```

Weather interactions should remain readable:

- rain weakens flame;
- wet fuel increases smoke;
- soaked fire may retain darkened/charred state;
- drying fuel may visually return to normal material state.

Avoid simulation-driven surface burn textures as a baseline.

---

# 10. Storm aftermath

Post-storm scenes should gain visual richness through composition rather than surface detail.

Useful aftermath objects/states:

- fallen branch;
- fallen frond;
- displaced crate;
- loose rope;
- broken roof piece;
- debris pile;
- puddle;
- flooded container;
- washed-up salvage;
- temporary brace;
- repair patch;
- blocked path.

This should make the island visibly different even after weather VFX stop.

---

# 11. Environmental opportunity objects

Weather should sometimes create useful assets rather than only damage.

Examples:

```text
fallen branch → wood / obstacle / bridge candidate
fallen frond → thatch / bedding / fuel
rain-filled container → water source
storm debris → salvage
exposed buried object → discovery
washed-up crate → storage / parts
```

Reference sheets should show at least one example where a hazard state becomes a resource state.

---

# 12. Repair language

Repair should be additive and visually obvious.

Preferred repair cues:

- extra rope wrap;
- mismatched plank;
- visible brace;
- patch panel;
- replacement cloth section;
- metal strap;
- shortened/repositioned component.

Repairs should usually remain visible after functionality is restored.

This is a major source of visual history and should not be polished away.

---

# 13. Material budget

Weather/damage must not cause uncontrolled material proliferation.

Preferred approach:

```text
shared base material
+ state parameter
+ optional alternate material variant
+ geometry state
```

Example:

```text
mat_wood
  dry
  wet
  charred
```

Do not create a unique material for each individual damaged asset unless required by a rare semantic object.

---

# 14. Shader policy

Allowed shared shader features:

- wetness parameter;
- low-frequency broad noise for weathering breakup;
- vertex/world-space variation where subtle;
- simple wind deformation for approved flexible families;
- water/fresnel effects;
- controlled emissive for fire/embers.

Avoid:

- per-object procedural grunge complexity;
- expensive layered shaders;
- screen-space damage effects that obscure silhouettes;
- dense tessellation/displacement.

---

# 15. Reference-sheet layout

The Weather & Damage sheet should include:

## Row A — Material state

- dry rock / wet rock;
- dry wood / wet wood / charred wood;
- dry cloth / soaked cloth;
- dry sand / wet sand / mud.

## Row B — Structural progression

One shelter section shown as:

```text
intact → loose → damaged → repaired → reinforced
```

## Row C — Displacement

- normal camp object placement;
- windy/storm displacement;
- post-storm cleanup pile.

## Row D — Opportunity

- branch attached to tree;
- fallen branch;
- collected/staged branch resource.

All examples should be rendered with the production material policy: flat color, low texture dependency, gameplay-scale readability.

---

# 16. Acceptance criteria

Approve a weather/damage visual solution only if:

- the state reads from gameplay distance;
- silhouette or large-value changes carry the meaning;
- the solution does not depend on unique textures;
- repaired state retains visible history;
- shared material/shader reuse remains high;
- weather remains visually coherent with the base art direction;
- performance cost is proportional to gameplay value.

Reject solutions that look impressive only in close-up renders.
