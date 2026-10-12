# Reference 03 — Camp Primitive Props

## Purpose

Define the visual construction language for the first handmade camp objects: stool, table/work surface, crate use, storage, fire site, drying rack, simple containers, rope bindings and early shelter components.

The camp should look improvised, readable and persistent. It should not resemble perfect miniature carpentry or a generic survival-game asset pack.

---

# 1. Construction principle

Most handmade camp props should visibly decompose into a small vocabulary:

```text
post / pole
+ plank / slab / branch
+ binding
+ optional brace
+ optional cloth / thatch
```

The player should be able to infer how an object was assembled from its silhouette.

Texture should not be required to communicate craftsmanship.

---

# 2. Handmade imperfection bounds

Accept:

- slightly mismatched plank lengths;
- mild non-parallel alignment;
- uneven leg spacing when stable;
- oversized rope bindings;
- one replacement or repaired component;
- asymmetry that preserves function.

Avoid:

- chaotic random rotation;
- fragile thin legs;
- excessive crookedness;
- perfectly polished carpentry;
- micro-nails, screws or fibers;
- decorative detail with no gameplay value.

The object should feel improvised by a competent adult, not badly modeled.

---

# 3. Crude stool

Show at least three valid variants:

```text
slab + 3 legs
plank seat + 4 legs
stump-derived stool
```

Shared visual rules:

- thick seat;
- thick supports;
- readable sitting plane;
- stable silhouette;
- bindings only where structurally plausible and visible.

States:

```text
new
worn
loose/damaged
repaired
```

The repaired version should keep visible evidence of the fix.

---

# 4. Table / work surface

Target variants:

- minimal eating/prep table;
- heavier work surface;
- salvaged-panel tabletop variant.

Required traits:

- broad readable top plane;
- thick support structure;
- enough clearance for Wilson animation;
- visual distinction between a casual table and a workbench-capable surface.

Possible sockets:

```text
SOCKET_TOP_*
SOCKET_TOOL_*
SOCKET_ATTACHMENT_*
```

These do not need visible markers in the final mesh, but the visual design should leave plausible attachment areas.

---

# 5. Campfire / fire site

The reference should show a state sequence:

```text
prepared site
→ stone ring + kindling
→ small fire
→ established fire
→ embers
→ ash / cold remains
```

Optional weather states:

```text
wet
smoking
partially extinguished
```

Geometry rules:

- few oversized stones;
- fuel pieces large enough to read;
- no dense twig bundle;
- flame VFX should not be responsible for explaining the structure.

Cooking attachments should read as modular additions rather than part of one monolithic campfire model.

---

# 6. Drying rack

Show progression:

```text
two posts + crossbar
→ reinforced rack
→ rack with hanging food/material
→ covered/improved rack
```

Construction:

- thick posts;
- simple crossbar;
- visible binding;
- sparse hanging objects.

Avoid creating a dense clothesline-like visual mess.

---

# 7. Storage primitives

Reference forms:

- open basket;
- crate;
- simple lidded box;
- raised storage platform;
- shelf.

The visual difference between them should come from function and composition.

## Open basket

- broad woven impression through large bands or material block;
- do not model individual weave fibers.

## Crate

- more manufactured/regular than Wilson-made storage;
- broad plank faces;
- usable as seat/table/obstacle as well as container.

## Raised storage

- platform clearly separated from ground;
- supports thick enough to read;
- obvious role in keeping items away from animals/wet ground.

---

# 8. Primitive containers

Reference:

- coconut shell bowl;
- simple wooden bowl;
- improvised cup;
- bucket-like vessel;
- found metal container.

Visual rule:

containers should be oversized enough that `empty`, `partial`, `full`, `open`, `closed` or `contents visible` can be communicated from gameplay distance where relevant.

---

# 9. Rope binding language

Bindings are one of the signature visual cues of Wilson-made objects.

A binding should usually read as:

```text
2–4 thick wraps
+ simplified knot mass or crossing
```

Do not model rope fibers.

Use bindings at structural junctions:

- pole-to-pole;
- plank-to-frame;
- tool head-to-handle;
- rack crossbar;
- shelter frame.

Bindings should be slightly oversized relative to realism.

---

# 10. Early shelter component vocabulary

This sheet should not define the full shelter evolution yet, but it should introduce the pieces used by later shelter references.

Required primitives:

- foundation stake;
- vertical post;
- horizontal beam;
- ridge beam;
- brace;
- thatch bundle;
- thatch panel;
- cloth panel;
- simple wall panel;
- floor mat/platform piece;
- repair patch.

All should look compatible when assembled together.

---

# 11. Repair language

Reference at least four repair examples:

```text
broken stool leg + replacement leg
loose table joint + rope reinforcement
roof hole + mismatched thatch patch
cracked plank + brace
```

Repair should add visible history rather than restore an asset to pristine state.

Preferred repair cues:

- mismatched material;
- extra binding;
- added brace;
- replacement piece with different proportion;
- patch layered over original component.

---

# 12. State presentation

For camp props, state should primarily affect silhouette or large material blocks.

Priority states:

```text
intact
worn
damaged
repaired
wet/dry where relevant
empty/partial/full where relevant
open/closed where relevant
```

Avoid unique full-mesh variants when a component swap, material state or repair attachment communicates the same thing.

---

# 13. Reference-sheet composition

The canonical Camp Primitive Props sheet should include:

1. three stool variants;
2. two table/work-surface variants;
3. campfire state progression;
4. drying-rack progression;
5. basket, crate, box, shelf and raised storage;
6. primitive containers;
7. isolated binding examples;
8. shelter construction primitives laid out as a kit;
9. four repair examples;
10. Wilson mannequin interacting with one seat, one surface and one container;
11. one compact camp vignette using only objects shown on the sheet.

---

# 14. Acceptance criteria

Camp primitive props are accepted when:

- assembly can be understood visually;
- supports are thick enough for gameplay readability;
- handmade objects look imperfect but competent;
- rope bindings are readable but not detailed;
- repaired states retain history;
- objects expose obvious usable surfaces/volumes;
- crate/salvage objects remain visually distinct from handmade objects;
- all objects remain compatible with the aggressive low-poly world;
- the entire vignette feels like one construction vocabulary rather than unrelated asset-pack pieces.
