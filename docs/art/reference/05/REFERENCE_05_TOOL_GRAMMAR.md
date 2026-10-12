# Reference 05 — Tool Grammar

## Purpose

Define a reusable visual and construction grammar for hand tools so different agents can generate coherent tool families without relying on unique textures or one-off aesthetics.

This is a reference specification, not an implementation schema.

## Core equation

```text
handle
+ working head
+ binding / join
+ condition
= tool
```

Tools should look assembled from a small vocabulary of parts rather than modeled as unrelated bespoke props.

## Visual goals

- readable at canonical gameplay distance;
- chunky enough for Wilson's hand interactions;
- aggressive low-poly geometry without voxel appearance;
- flat-color shared materials by default;
- visible assembly logic;
- clear distinction between improvised and salvaged/manufactured tools;
- strong silhouette first, detail second.

## Handle grammar

Handles may be:

- natural branch;
- shaped wood handle;
- straight pole;
- short grip;
- reused manufactured handle.

Preferred characteristics:

- visibly faceted cross-section when large enough;
- thicker than realistic if necessary for readability;
- slight taper;
- bounded bend/irregularity for improvised handles;
- simple ends, no decorative carving by default.

Avoid:

- excessive smoothness;
- wood-grain textures;
- micro-bevels;
- thin realistic handles that disappear at gameplay distance.

## Working-head grammar

### Stone

Use few dominant planes.

Typical families:

- sharp flake;
- wedge;
- heavy blunt stone;
- pointed stone.

Stone heads should communicate capability through silhouette:

```text
thin / sharp edge → cutting / scraping
wedge → chopping / splitting
large blunt mass → hammering / crushing
pointed mass → piercing / digging
```

### Metal salvage

Metal heads should be more geometric and regular than stone.

Possible sources:

- bent plate;
- sharpened scrap;
- salvaged blade fragment;
- pipe/fitting;
- manufactured tool head.

Use large bends/dents rather than scratch textures.

### Wood

Wood may itself form a working end for:

- club;
- digging stick;
- mallet;
- probe;
- paddle-like tool.

## Binding grammar

Bindings are important semantic shapes.

Preferred:

- thick simplified rope bands;
- 2–5 visible wraps rather than dozens of fibers;
- small knot mass when readable;
- contrasting material block from handle/head.

Bindings should communicate:

- improvised assembly;
- repair;
- reinforcement;
- material upgrade.

## Tool archetypes

Use archetypes as composition targets, not isolated art styles.

| Archetype | Typical composition | Primary silhouette cue |
| --- | --- | --- |
| knife/cutter | short handle + sharp head | narrow forward edge |
| hatchet | medium handle + wedge head | offset wedge |
| axe | long handle + larger wedge | long lever + broad head |
| hammer | medium handle + blunt head | compact heavy top mass |
| mallet | wood handle + wood head | broad rectangular/cylindrical head |
| digging stick | long pointed wood | long tapered silhouette |
| shovel-like tool | long handle + broad plate | broad terminal scoop/plate |
| pry tool | long rigid bar | slim rigid lever |
| club | thick handle + heavy end | asymmetric heavy end |
| spear/probe | long pole + point | extended linear silhouette |

## Evolution language

A useful visual progression is:

```text
found material
→ improvised tool
→ stabilized tool
→ repaired tool
→ salvaged-material upgrade
```

Examples:

```text
sharp stone
→ hand-held stone cutter
→ stone + short handle + rope
→ replacement binding
→ metal scrap + reused handle
```

The upgraded version should still reveal lineage where possible.

## Condition states

Shared states:

```text
intact
worn
dull
loose binding
cracked handle
broken head
repaired
reinforced
wet
charred
```

Damage should be communicated through geometry/state parts first.

Examples:

- shortened handle;
- missing chip on stone head;
- visibly loosened binding;
- replacement rope color/material block;
- mismatched salvaged head;
- obvious brace or wrap.

Avoid relying on scratches or grunge textures.

## Materials

Default shared material roles:

```text
mat_wood_*
mat_stone_*
mat_rope_*
mat_metal_*
mat_charred
```

No unique texture maps should be required for normal tools.

Decals are unnecessary unless a found manufactured tool has a meaningful marking.

## Scale and readability

Tool proportions should be calibrated against the Wilson mannequin.

Guidelines:

- handle thickness should remain visible from gameplay camera;
- working heads may be 10–30% larger than realistic when needed;
- bindings may be exaggerated;
- silhouette must remain recognizable when rendered black;
- interaction contact points must not depend on tiny geometry.

## Attachment anchors

Common semantic anchors may include:

```text
ANCHOR_GRIP_PRIMARY
ANCHOR_GRIP_SECONDARY
ANCHOR_WORKING_END
ANCHOR_INSPECT
```

Two-handed tools should expose stable secondary grip placement.

## Generator decomposition

Recommended reusable generator helpers:

```text
create_tool_handle
create_stone_tool_head
create_metal_tool_head
create_wood_tool_head
create_binding
assemble_tool
apply_tool_damage_state
apply_tool_repair_state
```

Variation should come primarily from:

- handle family;
- head family;
- proportions;
- bounded angle/offset;
- binding style;
- material variant;
- condition state.

## Reference-sheet requirements

A generated reference sheet should show:

1. 4–6 handle variants;
2. 4–6 working-head variants;
3. 3 binding treatments;
4. at least one tool from each major archetype;
5. improvised versus salvaged comparison;
6. intact / damaged / repaired progression;
7. Wilson scale comparison;
8. canonical gameplay-camera render;
9. silhouette-only row.

## Acceptance tests

Approve a tool family only if:

- archetypes remain distinguishable without texture;
- the same part grammar is visibly shared across families;
- bindings read clearly without excessive detail;
- improvised and manufactured origins are visually distinct;
- condition states remain legible at gameplay scale;
- the family works with shared flat-color materials;
- the tool looks plausible in Wilson's hands without realistic thinness.
