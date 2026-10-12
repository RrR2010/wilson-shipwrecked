# Reference 06 — Shelter Evolution

## Purpose

Define how shelters and related structures evolve visually through composition rather than replacement.

The shelter is a persistent project and landmark. It should accumulate decisions, repairs, extensions and material history.

## Core equation

```text
site
+ structural frame
+ cover
+ enclosure
+ attachments
+ repairs
= shelter state
```

The shelter should never depend on a single monolithic `shelter.glb` as the authoritative visual concept.

## Visual goals

- readable construction progression from gameplay camera;
- aggressive low-poly geometry;
- large modular pieces;
- flat-color shared materials;
- visible assembly and bindings;
- partial functionality before completion;
- repairs remain visible;
- later stages may become more complex without becoming visually noisy.

## Primary construction vocabulary

### Site markers

Possible pieces:

- stakes;
- stone markers;
- rope outline;
- staged material pile.

### Structural members

```text
post
pole
beam
ridge beam
brace
crossbar
```

### Surface/enclosure pieces

```text
thatch panel
cloth panel
wood panel
floor/platform section
windbreak panel
```

### Connection pieces

```text
rope binding
peg/joint block
repair wrap
brace reinforcement
```

## Baseline evolution

Recommended progression:

```text
0. chosen site
1. site marked
2. first posts
3. partial frame
4. complete primary frame
5. partial roof
6. basic shelter
7. enclosed/reinforced shelter
8. expanded shelter
9. repaired/personalized long-lived shelter
```

Not every run must pass through identical parts, but the visual stages should remain recognizable.

## Stage guidance

### Stage 0 — Chosen site

Visual evidence may include:

- cleared patch;
- moved rocks;
- small marker stakes;
- nearby staged wood.

Functionality: none or minimal.

### Stage 1 — Marked foundation

Add:

- corner stakes;
- rope/string outline where appropriate;
- material stack.

The player should understand that Wilson intends to build something before walls exist.

### Stage 2 — First posts

Add 2–4 structural verticals.

Important:

- posts visibly planted in ground;
- thickness exaggerated enough for camera readability;
- irregular but stable spacing.

### Stage 3 — Partial frame

Add:

- beams;
- ridge member;
- one or more braces;
- visible bindings.

Partial frame should be spatially understandable as the future shelter.

### Stage 4 — Complete primary frame

Frame should now communicate:

- entrance side;
- roof direction;
- internal sleeping volume;
- expansion sockets where applicable.

### Stage 5 — Partial roof

Add modular roof panels.

Roof progression should be physically visible:

```text
0%
25%
50%
75%
100%
```

Exact internal representation may differ, but avoid instantaneous replacement from frame to complete roof.

### Stage 6 — Basic shelter

Minimum useful shelter includes:

- roof coverage;
- readable entrance;
- sleeping anchor;
- partial weather protection.

### Stage 7 — Reinforced/enclosed

Potential additions:

- side wall panels;
- floor/platform;
- entrance flap;
- stronger braces;
- drainage improvement;
- storage attachment.

### Stage 8 — Expanded

Possible modules:

- covered work area;
- storage extension;
- cooking canopy;
- rain-catch attachment;
- porch/platform;
- hammock posts;
- secondary roof bay.

### Stage 9 — Long-lived shelter

History should become visible through:

- mismatched replacement parts;
- additional rope wraps;
- patched roof panel;
- reused salvage sheet;
- reinforced post;
- attached shelf/tool rack;
- personal objects;
- accumulated footprint/path around entrance.

## Composition rules

Prefer large interchangeable modules.

Avoid:

- hundreds of tiny planks;
- decorative trim;
- texture-driven thatch detail;
- invisible assembly logic;
- perfect symmetry.

Recommended complexity hierarchy:

```text
primary frame → few large members
roof → few broad panels
walls → broad panels
bindings → only at semantically important joints
```

## Roof grammar

Preferred roof material families:

- broad thatch panels;
- palm-frond panels;
- cloth/sailcloth panel;
- salvaged flat sheet as patch.

Thatch should be represented as chunky layered masses or broad low-poly blades, not individually modeled fibers.

## Damage states

Shared progression:

```text
intact
stressed
loose panel
partial failure
broken member
exposed interior
repaired
reinforced
```

Examples:

- one roof panel lifted/missing;
- post leaning;
- snapped brace;
- torn cloth panel;
- detached wall section;
- roof sagging.

Damage should affect silhouette where practical.

## Repair language

Repairs should add history rather than erase it.

Preferred repair pieces:

```text
replacement plank/pole
extra brace
rope wrap
patch panel
salvage sheet
support stake
```

A repaired shelter should often look slightly more complex than before.

## Materials

Default material roles:

```text
mat_wood_*
mat_rope_*
mat_thatch_*
mat_cloth_*
mat_metal_*
```

No unique texture maps by default.

Visual richness comes from:

- material-block contrast;
- overlapping large shapes;
- planar shading;
- light/shadow;
- mismatched repair colors within approved palette.

## Sockets

Suggested structural sockets:

```text
SOCKET_POST_*
SOCKET_BEAM_*
SOCKET_BRACE_*
SOCKET_ROOF_*
SOCKET_WALL_*
SOCKET_ENTRANCE
SOCKET_PLATFORM_*
SOCKET_EXTENSION_*
SOCKET_STORAGE
SOCKET_RAIN_CATCH
SOCKET_HAMMOCK
```

These are conceptual names; implementation may consolidate them.

## Interaction anchors

Potential anchors:

```text
ANCHOR_APPROACH
ANCHOR_BUILD
ANCHOR_REPAIR
ANCHOR_SLEEP
ANCHOR_INSPECT
ANCHOR_ENTER
ANCHOR_EXIT
```

Construction anchors should remain reachable as the shelter evolves.

## Partial functionality

Projects should become useful before final completion where sensible.

Examples:

```text
partial roof → partial rain/shade protection
frame → structural landmark / possible attachment support
one wall → windbreak
platform → dry sleeping/work surface
```

This makes intermediate states meaningful rather than cosmetic.

## Generator decomposition

Recommended helpers:

```text
create_post
create_beam
create_brace
create_binding
create_thatch_panel
create_cloth_panel
create_wall_panel
create_platform_section
create_repair_patch
assemble_shelter_stage
apply_shelter_damage
apply_shelter_repair
```

## Reference-sheet requirements

A shelter reference sheet should show:

1. complete stage progression from site to basic shelter;
2. one expanded later-stage example;
3. intact / storm-damaged / repaired comparison;
4. natural-material and salvage-patched variants;
5. canonical gameplay-camera views;
6. silhouette-only progression;
7. Wilson scale comparison;
8. exploded composition view showing frame, roof and wall modules;
9. socket/anchor diagram.

## Acceptance tests

Approve only if:

- every major stage is distinguishable at gameplay scale;
- frame logic is visually understandable;
- roof progression reads without texture detail;
- repair additions remain visible;
- modular pieces do not create noisy seams;
- expansions preserve the original shelter identity;
- flat-color materials are sufficient to make the shelter attractive;
- the structure looks handmade without looking unstable or random.
