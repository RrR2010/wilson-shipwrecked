# Reference 07 — Salvage & Repurposing

## Purpose

Define how manufactured debris, shipwreck pieces and rare found objects integrate into the island's visual language without breaking style consistency or creating texture-heavy production work.

The goal is to preserve the original identity of a found object while allowing Wilson to reuse it in visibly improvised ways.

## Core equation

```text
recognizable source object
+ simple physical capability
+ new attachment/context
= repurposed object
```

Repurposing should usually preserve enough silhouette or material identity that the player can still recognize what the object used to be.

## Visual goals

- strong source-object silhouette;
- simplified low-poly reconstruction;
- flat-color shared materials;
- no dependence on detailed labels or textures;
- reuse should be visible through placement, bindings and added structure;
- manufactured salvage should contrast with handmade island construction through cleaner geometry;
- rare absurd objects should remain visually memorable without becoming more detailed than the rest of the game.

## Source-object categories

### Structural salvage

Examples:

- plank sections;
- crate panels;
- broken railing;
- hatch cover;
- ship frame fragment;
- flat metal panel;
- pipe/tube;
- chain/hook hardware.

### Containers

Examples:

- crate;
- barrel/drum;
- bottle;
- jar;
- suitcase;
- metal box;
- sealed mystery container.

### Flexible materials

Examples:

- sailcloth;
- rope;
- net;
- strap;
- bag/pouch.

### Domestic/manufactured objects

Examples:

- pan;
- cup;
- spoon;
- chair fragment;
- umbrella;
- bucket;
- signage;
- mirror-like panel.

### Rare/absurd objects

Examples:

- bowling ball;
- sports ball;
- traffic/sign object;
- office object;
- toy;
- unusual footwear/headwear;
- dead electronics.

## Manufactured-vs-handmade contrast

Manufactured salvage should generally use:

- straighter edges;
- more regular symmetry;
- cleaner planar surfaces;
- fewer organic bends;
- simple stamped/industrial silhouette cues.

Wilson-made attachments should generally use:

- wood poles/planks;
- rope bindings;
- simple braces;
- irregular alignment;
- visibly improvised composition.

The contrast itself communicates history without textures.

## Repurposing vocabulary

Common reuse operations:

```text
attach
bind
brace
hang
raise
cover
seal
weight
counterweight
float
roll
strike
store
sit
stand-on
reflect
signal
```

A useful object should participate through these generic capabilities rather than object-specific scripts whenever possible.

## Examples

```text
sailcloth
+ frame
→ shelter wall / rain cover

flat metal panel
+ roof socket
→ shelter patch

suitcase
+ stable placement
→ storage

life ring / float
+ raft frame
→ buoyancy component

umbrella
+ container
→ rain-catching experiment

bowling ball
+ heavy + impact-capable
→ absurd crushing tool

chair fragment
+ workbench frame
→ brace / seat / structural salvage
```

## Recognition rule

When repurposed, preserve at least one major recognition cue where feasible:

- characteristic silhouette;
- handle;
- opening;
- rim;
- holes;
- proportions;
- original color family;
- manufactured symmetry.

Do not reshape every salvaged object until it looks like generic wood/metal scrap.

## Texture policy

Normal salvage should require no unique texture map.

Use material roles such as:

```text
mat_metal_dull
mat_metal_rusted
mat_cloth_*
mat_wood_manufactured
mat_glass_simple
mat_plastic_*
```

Permitted decal exceptions:

- one large numeral;
- warning stripe;
- shipping mark;
- directional arrow;
- simple icon;
- meaningful label;
- story-critical marking.

Decals should be reusable and sparse.

Avoid:

- fake printed microtext;
- complex branding;
- high-resolution grunge;
- scratch atlases covering all salvage;
- realistic rust textures.

## Wear and aging

Communicate aging primarily with:

- bent silhouette;
- dented panel;
- missing corner;
- cracked lid;
- faded/desaturated material variant;
- simple rust-state material;
- rope repair;
- replacement piece.

Large low-frequency shader noise may be used sparingly for broad weathering, but must not become the object's visual identity.

## Shipwreck evolution

The wreck itself should behave as a persistent salvage source.

Suggested visual evolution:

```text
recognizable wreck section
→ loose contents removed
→ detachable fittings removed
→ reusable panels/planks stripped
→ partial structural skeleton
→ long-lived skeletal landmark
```

Removed resources should correspond to visible missing pieces where practical.

## Rare-object hierarchy

Use rarity to preserve contrast.

### Common

- rope;
- plank;
- crate;
- bottle;
- cloth;
- metal scrap.

### Uncommon

- suitcase;
- pan;
- bucket;
- umbrella;
- sign fragment;
- manufactured tool part.

### Rare

- bowling ball;
- intact chair;
- unusual toy;
- distinctive sports object;
- strange wearable.

### Very rare authored curiosity

Reserved for memorable one-off finds that justify special behavior or narrative weight.

Rare should remain rare. Do not fill normal scenes with curiosities.

## Absurd-object rule

An absurd object should be funny because its real physical properties happen to be useful.

Good:

```text
bowling ball is heavy → crushing works
umbrella catches water → rain experiment works
metal sign is flat → patch works
bucket holds liquid → storage works
```

Bad:

```text
object gets a magical bespoke function only because it is funny
```

## Attachment language

Repurposed objects should use familiar handmade connection cues:

- oversized rope wraps;
- wood braces;
- hooks;
- simple pegs;
- compression/weight placement.

This visually brings manufactured salvage into Wilson's construction language.

## Generator decomposition

Recommended helpers:

```text
create_crate
create_barrel
create_bottle
create_flat_panel
create_pipe
create_hook_hardware
create_luggage
create_bucket
create_sign
create_cloth_sheet
create_net
create_sports_object
create_rare_curiosity_base
create_debris_cluster
apply_large_dent
apply_missing_piece
apply_salvage_weathering_state
attach_salvage_to_structure
```

## Reference-sheet requirements

A salvage reference sheet should show:

1. common salvage family lineup;
2. manufactured vs handmade geometry comparison;
3. intact / damaged / repurposed progression;
4. 4–6 repurposing examples;
5. at least two rare/absurd objects kept at the same polygon-detail level as common assets;
6. decal examples demonstrating maximum acceptable marking density;
7. flat-material-only render;
8. canonical gameplay-camera comparison;
9. Wilson scale reference.

## Acceptance tests

Approve only if:

- source objects remain recognizable without texture;
- manufactured salvage is visually distinct from primitive handmade parts;
- repurposed forms visibly show how they were attached;
- rare objects do not introduce a different rendering/detail style;
- decals remain optional and sparse;
- damage uses large form changes rather than micro-surface noise;
- the family can be reproduced procedurally or with simple manual modeling;
- absurd reuse follows physical capabilities rather than bespoke visual magic.
