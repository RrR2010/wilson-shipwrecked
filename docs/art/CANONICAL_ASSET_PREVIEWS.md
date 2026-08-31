# Canonical Asset Preview Standard

## Purpose

Define a stable visual review package so assets created by different agents can be judged under comparable conditions.

This is an artistic preview contract. It does not prescribe Blender automation or rendering implementation.

---

# 1. Required preview views

Every reviewable asset should provide, at minimum:

1. **Front Orthographic**
2. **Side Orthographic**
3. **Top Orthographic**
4. **Gameplay Orthographic 3/4**
5. **Gameplay Silhouette**
6. **Scale Comparison** when dimensions are not obvious

Optional when needed:

- rear orthographic;
- alternate gameplay 3/4;
- exploded modular view;
- state progression strip;
- anchor/socket diagnostic overlay.

---

# 2. Coordinate convention

Use a stable production convention for preview orientation:

- `+Y` = nominal asset front;
- `+X` = nominal asset right;
- `+Z` = world up.

If the runtime project later adopts a different technical convention, preview labels should still preserve an unambiguous visual front/side definition.

For naturally orientationless assets such as rocks, choose the most characteristic silhouette as the nominal front and keep it stable across variants.

---

# 3. Front orthographic

Purpose:

- inspect silhouette width;
- vertical proportions;
- symmetry/asymmetry;
- construction hierarchy;
- contact with the ground.

Rules:

- orthographic projection;
- centered asset;
- no dramatic perspective;
- neutral lighting;
- enough margin to see the whole silhouette.

---

# 4. Side orthographic

Purpose:

- inspect depth;
- reveal accidental flatness;
- validate handles, supports, roofs and lean;
- expose clipping or weak construction.

Keep camera height aligned with the front view unless the family needs a special diagnostic angle.

---

# 5. Top orthographic

Purpose:

- inspect footprint;
- composition;
- radial organization;
- interaction clearance;
- roof/deck/surface readability;
- modular arrangement.

This view is especially important for:

- palms;
- vegetation clusters;
- shelters;
- workstations;
- rafts;
- docks;
- storage layouts;
- terrain modules.

---

# 6. Canonical gameplay orthographic 3/4

This is the **authoritative artistic review view**.

Until gameplay calibration changes the project contract, use the following target:

- projection: orthographic;
- azimuth: approximately **45°** relative to the asset front;
- elevation: approximately **35° downward**;
- world vertical remains visually clear;
- no perspective distortion;
- frame the object at representative gameplay size.

This angle is deliberately aligned with the project visual target of a readable miniature 3/4 diorama.

Exact engine calibration may later adjust azimuth/elevation slightly. When that happens, update this document and use the calibrated view for all subsequent assets.

---

# 7. Gameplay-distance rule

The review image should not show only a close-up.

For small and medium props, include enough surrounding neutral ground so the reviewer can judge the asset at approximately the visual importance it will have in normal play.

For large structures, show the complete silhouette without filling the frame so tightly that construction reads better than it would in game.

A second close-up diagnostic image may be added, but it never replaces the gameplay-distance view.

---

# 8. Silhouette pass

Render the asset as a single dark silhouette from the canonical gameplay camera.

Purpose:

- verify recognizable outer form;
- identify tangencies;
- detect thin elements disappearing;
- compare family variants;
- expose overcomplicated edges.

Do not use internal color/material differences in this pass.

If the function becomes unreadable as silhouette and cannot be recovered by a few major color blocks, revise the geometry.

---

# 9. Scale comparison

When scale is important, render next to the approved Wilson production mannequin.

Useful comparisons include:

- Wilson standing beside asset;
- hand/prop relationship for small tools;
- seating contact for stools/benches;
- work-surface height;
- shelter entrance and sleeping length;
- carry size for logs/crates;
- climb or reach relation for interactive structures.

The comparison should use the same world scale, not manual image resizing.

---

# 10. Neutral review environment

The baseline diagnostic environment should contain:

- simple neutral ground plane;
- restrained neutral background;
- one soft dominant directional light;
- ambient fill;
- contact shadow;
- no cinematic depth of field;
- no dramatic fog;
- no post-processing that hides geometry.

The review environment exists to expose the asset, not beautify weaknesses.

---

# 11. Material review mode

Use the production-intended flat-color material blocks.

Do not compensate for weak form using:

- high-contrast texture;
- dramatic rim light;
- complex procedural noise;
- heavy outlines;
- baked highlights.

A family should look coherent under ordinary daylight before weather/night variants are considered.

---

# 12. Optional state strip

Assets with meaningful states should show them side-by-side under identical camera and lighting.

Examples:

```text
healthy → harvested → damaged
intact → damaged → repaired
empty → partial → full
raw → cooked → burned
site → partial project → complete
```

The goal is to verify **state readability**, not create a marketing render.

---

# 13. Optional exploded composition view

Use for modular/composite assets such as:

- shelter;
- raft;
- dock;
- workbench attachments;
- modular storage;
- tool assembly.

Show major components separated enough to communicate construction.

Do not explode individual vertices or tiny hardware.

---

# 14. Anchor/socket diagnostic view

When useful for artistic validation, show semantic anchors and sockets as simple overlay markers.

This is useful to answer:

- does the interaction location correspond to visible geometry?
- is a seat anchor actually at sitting height?
- are project extension sockets visually plausible?
- does a tool grip align with the handle?

The overlay is diagnostic only and should not be part of beauty/reference images.

---

# 15. Naming recommendation

A review package may use names such as:

```text
<asset_id>__front.png
<asset_id>__side.png
<asset_id>__top.png
<asset_id>__gameplay.png
<asset_id>__silhouette.png
<asset_id>__scale.png
<asset_id>__states.png
<asset_id>__diagnostic.png
```

This is a naming recommendation for human/agent clarity, not an engine contract.

---

# 16. Review priority

When views disagree, prioritize them in this order:

1. canonical gameplay 3/4;
2. gameplay silhouette;
3. scale comparison;
4. front/side/top diagnostics;
5. optional close-up.

The game camera is authoritative.
