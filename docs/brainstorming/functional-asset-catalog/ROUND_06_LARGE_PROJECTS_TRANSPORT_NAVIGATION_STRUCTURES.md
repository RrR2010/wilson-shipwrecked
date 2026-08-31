# Functional Asset Catalog Brainstorming — Round 6

## Scope

This round explores larger constructed objects and infrastructure related to:

- major projects;
- transport and hauling;
- local navigation aids;
- bridges, platforms and docks;
- shelters and auxiliary structures;
- water / garden / storage infrastructure;
- modular growth and expansion;
- project staging;
- visible repair, reinforcement and repurposing;
- anchors and sockets for large interactive assemblies.

This is a brainstorming artifact, not a canonical implementation schema.

The goal is to identify large object families that remain compatible with the project's systemic philosophy: structures should emerge from reusable construction grammar rather than from large numbers of unrelated monolithic assets.

---

# 1. Large-project philosophy

Large projects should be understood as persistent assemblies with visible construction history.

Preferred conceptual model:

```text
site
→ marked footprint
→ staged materials
→ partial frame
→ partial functionality
→ complete structure
→ expanded / modified
→ damaged
→ repaired / reinforced / repurposed
```

Important design principle:

> A large structure should communicate how it was built, repaired and extended through visible components whenever practical.

Avoid treating all large structures as indivisible final meshes.

---

# 2. Shared modular structural vocabulary

Most large projects should reuse the same structural families introduced in earlier rounds.

Core pieces:

```text
stake
post
pole
beam
brace
plank
panel
platform
binding
rope
thatch panel
cloth panel
salvaged metal panel
float / buoyant module
ladder rung
rail
hook / pulley point
```

Useful structural sockets:

```text
SOCKET_POST_*
SOCKET_BEAM_*
SOCKET_BRACE_*
SOCKET_PANEL_*
SOCKET_PLATFORM_*
SOCKET_RAIL_*
SOCKET_LADDER_*
SOCKET_EXTENSION_*
SOCKET_ROPE_*
SOCKET_FLOAT_*
SOCKET_ATTACHMENT_*
```

Compatibility should be semantic and bounded, not universal.

---

# 3. Shelter expansion family

Round 1 introduced the basic shelter project. This round expands it into a family of persistent camp architecture.

Potential progression:

```text
basic lean-to
→ enclosed shelter
→ raised sleeping shelter
→ extended shelter
→ storage annex
→ covered work annex
→ reinforced storm-ready shelter
→ personalized long-lived dwelling
```

Potential modules:

- foundation / ground anchors;
- posts;
- roof frame;
- thatch roof panels;
- salvaged cloth panels;
- plank walls;
- partial wall screens;
- door / flap;
- sleeping platform;
- interior shelf;
- hooks;
- external awning;
- rain-gutter attachment;
- windbreak extension;
- repair braces;
- salvaged patch panels.

Suggested states:

```text
planned
frame_partial
frame_complete
cover_partial
functional_basic
expanded
reinforced
storm_damaged
patched
heavily_repaired
```

Anchors:

```text
ANCHOR_APPROACH
ANCHOR_BUILD
ANCHOR_REPAIR
ANCHOR_SLEEP
ANCHOR_ENTER
ANCHOR_INSPECT
```

Optional sockets:

```text
SOCKET_ANNEX_LEFT
SOCKET_ANNEX_RIGHT
SOCKET_AWNING
SOCKET_GUTTER
SOCKET_STORAGE
```

The shelter should become one of the strongest visual records of Wilson's accumulated history.

---

# 4. Covered work area / workshop shelter

Potential progression:

```text
open workbench
→ shade canopy
→ covered workstation
→ organized workshop
→ enclosed storage/work annex
```

Modules:

- posts;
- canopy frame;
- cloth/thatch cover;
- workbench;
- tool rack;
- shelves;
- parts bins;
- hanging hooks;
- material staging zones;
- lighting/fire attachment if supported later.

Functions:

- dry working area;
- tool organization;
- material storage;
- project staging;
- routine location;
- weather protection.

---

# 5. Storage shed / pantry structure

Potential progression:

```text
ground storage area
→ raised rack
→ covered storage
→ enclosed storage shed
→ organized pantry / material store
```

Modules:

- raised platform;
- wall panels;
- roof;
- door/flap;
- shelves;
- hooks;
- baskets/crates;
- hanging storage;
- animal barriers.

Functional states:

```text
empty
partially stocked
full
messy
organized
animal-raided
damaged
repaired
```

Visual accumulation should be preferred over abstract fullness indicators where feasible.

---

# 6. Raft family

Rafts should be modular and visibly improvised.

Potential progression:

```text
floating debris bundle
→ tied log raft
→ stable raft
→ raft with deck
→ raft with storage
→ raft with simple sail / propulsion support
→ repaired / reinforced raft
```

Core modules:

- buoyant logs;
- driftwood beams;
- bindings;
- plank deck;
- flotation salvage (life ring, barrel, buoy);
- mast socket;
- sail/cloth panel;
- paddle/oar storage;
- cargo tie-down points;
- repair patches.

Sockets:

```text
SOCKET_FLOAT_*
SOCKET_DECK_*
SOCKET_MAST
SOCKET_CARGO_*
SOCKET_PADDLE
SOCKET_TOW
```

Anchors:

```text
ANCHOR_BOARD
ANCHOR_PUSH
ANCHOR_PULL
ANCHOR_REPAIR
ANCHOR_PADDLE
ANCHOR_CARGO
```

States:

```text
under_construction
launch_ready
floating
beached
loaded
waterlogged
damaged
patched
```

Even if offshore travel remains limited, a raft has high narrative and physical value as a project and local transport object.

---

# 7. Canoe / improvised small boat possibility

Potential family, likely later than raft.

Variants:

- hollowed-log canoe;
- salvaged dinghy fragment repaired into usable craft;
- improvised plank boat.

Possible states:

```text
hull_partial
hull_complete
leaking
patched
stable
loaded
beached
moored
```

This should not be prioritized unless gameplay proves a need for more capable water transport.

---

# 8. Paddle / oar family

Modular tool/transport crossover.

Composition:

```text
long handle
+ broad blade
+ optional binding / salvage patch
```

Functions:

- propulsion;
- push-off pole;
- digging/shoving candidate;
- large awkward improvised tool;
- emergency weapon/impact candidate if simulation permits.

States:

```text
intact
cracked
repaired
waterlogged
```

---

# 9. Dock / landing platform

Potential progression:

```text
shore marker
→ stepping logs
→ short landing platform
→ crude dock
→ reinforced dock
→ dock with mooring and storage
```

Modules:

- posts;
- cross beams;
- planks;
- rope bindings;
- rails;
- ladder;
- mooring posts;
- cargo platform.

Anchors:

```text
ANCHOR_APPROACH
ANCHOR_BOARD
ANCHOR_MOOR
ANCHOR_REPAIR
ANCHOR_FISH
```

Sockets:

```text
SOCKET_EXTENSION
SOCKET_MOORING_*
SOCKET_RAIL_*
SOCKET_LADDER
```

Useful functions:

- water access;
- fishing position;
- raft/boat staging;
- cargo handling;
- landmark/routine location.

---

# 10. Bridge family

Potential uses:

- tide pool crossing;
- muddy area crossing;
- small ravine/gap;
- stream crossing if later introduced.

Progression:

```text
single log
→ two-log crossing
→ plank bridge
→ reinforced bridge
→ bridge with rails
```

Modules:

- logs/beams;
- planks;
- bindings;
- anchors/stakes;
- rail posts;
- hand rope.

States:

```text
unstable
usable
reinforced
wet
partially_broken
repaired
```

Potential comedy derives from imperfect construction, slippery surfaces and Wilson's learned trust/distrust of a specific bridge.

---

# 11. Stepping-stone / crossing route

Low-cost navigation project.

Composition:

- flat stones;
- logs;
- planks;
- stakes/markers.

Progression:

```text
natural crossing
→ deliberately placed stones
→ stabilized stepping route
→ bridge replacement
```

This supports visible path optimization without requiring a formal road system.

---

# 12. Ladders

Reusable ladder family.

Variants:

- branch ladder;
- rope ladder;
- rigid pole-and-rung ladder;
- salvaged ladder fragment.

States:

```text
partial
complete
loose
secured
damaged
repaired
```

Sockets/anchors:

```text
SOCKET_TOP_ATTACH
SOCKET_BOTTOM_ATTACH
ANCHOR_CLIMB_BOTTOM
ANCHOR_CLIMB_TOP
ANCHOR_REPAIR
```

Uses:

- shelter loft;
- lookout;
- palm access;
- dock access;
- raised storage;
- cliffs/ledges where appropriate.

---

# 13. Lookout / observation platform

Potential progression:

```text
preferred high rock
→ improvised standing platform
→ small lookout
→ raised lookout with shade
```

Modules:

- posts;
- platform;
- ladder;
- rail;
- small canopy;
- marker/flag.

Functions:

- observe sea/weather;
- routine/preference location;
- scouting;
- signaling;
- narrative staging.

Anchors:

```text
ANCHOR_CLIMB
ANCHOR_STAND
ANCHOR_LOOK_OUT
ANCHOR_SIT
```

---

# 14. Signal structure / beacon

Potential project family:

```text
stone/wood ground marker
→ large SOS arrangement
→ signal pole
→ flag marker
→ signal fire platform
→ combined lookout/signal station
```

Components:

- stones;
- logs;
- cloth flag;
- reflective salvage;
- fire bowl/platform;
- rope.

Possible functions:

- signaling;
- personal project;
- landmark;
- player-visible long-term goal;
- later abandonment/repurposing.

Important: it need not imply an actual escape objective.

---

# 15. Garden / cultivation infrastructure

Potential progression:

```text
single dug patch
→ marked planting bed
→ cultivated plot
→ fenced plot
→ organized garden
→ irrigated / rain-fed garden
```

Modules:

- soil plots;
- border stones/logs;
- stakes;
- simple fence;
- plant supports;
- water vessel;
- rain catch;
- mulch/compost area;
- tool rest.

States:

```text
unprepared
prepared
planted
growing
harvested
dry
watered
overgrown
damaged
```

Sockets:

```text
SOCKET_PLANT_*
SOCKET_SUPPORT_*
SOCKET_BORDER_*
```

A garden should visibly accumulate order, mistakes and improvisation.

---

# 16. Trellis / plant support

Reusable plant infrastructure.

Variants:

- single stake;
- tripod support;
- horizontal trellis;
- fence-trellis hybrid.

States:

```text
empty
partially_covered
fully_covered
damaged
repaired
```

Uses:

- vine crops;
- drying materials;
- improvised barrier;
- decorative growth.

---

# 17. Water infrastructure

Round 2 covered collection/storage objects. This round covers assembled systems.

Potential progression:

```text
open container
→ rain catch surface
→ elevated catchment
→ shelter gutter
→ gutter + storage vessel
→ organized water station
```

Modules:

- cloth/thatch catchment;
- gutter/channel;
- funnel;
- rope/support frame;
- vessel;
- overflow channel;
- lid/cover;
- dispensing cup/container.

Anchors:

```text
ANCHOR_COLLECT
ANCHOR_FILL
ANCHOR_DRINK
ANCHOR_CLEAN
ANCHOR_REPAIR
```

Visual states:

```text
empty
partial
full
overflowing
contaminated
covered
leaking
patched
```

---

# 18. Wash station

Potential progression:

```text
water bowl on ground
→ raised basin
→ basin + shelf/hook
→ sheltered wash station
```

Components:

- water basin;
- stand;
- drainage area;
- cloth/hanging hook;
- soap-like or abrasive resource if introduced;
- storage shelf.

Functions:

- washing objects;
- personal routine;
- cleaning food/tools;
- water use sink.

---

# 19. Drying / preservation structure expansion

Round 2 introduced drying racks.

Potential progression:

```text
simple hanging line
→ rack
→ covered drying rack
→ smoke rack
→ preservation shelter
```

Modules:

- posts;
- crossbars;
- rope lines;
- hooks;
- cover;
- fire/smoke source;
- shelves.

States:

```text
empty
loaded
partially_dried
complete
wet_from_rain
animal_disturbed
repaired
```

---

# 20. Fence family

Fences should be physical barriers rather than abstract territory markers.

Variants:

- stone line;
- stake fence;
- branch weave;
- rope fence;
- plank fence;
- salvage panel fence.

Progression:

```text
markers
→ partial barrier
→ continuous fence
→ reinforced / patched fence
```

Sockets:

```text
SOCKET_SEGMENT_L
SOCKET_SEGMENT_R
SOCKET_GATE
SOCKET_CORNER
```

Functions:

- animal exclusion;
- garden protection;
- camp organization;
- hazard marking;
- route shaping.

---

# 21. Gate / movable barrier

Potential variants:

- branch gate;
- rope gate;
- plank gate;
- removable panel.

States:

```text
open
closed
latched
broken
repaired
```

Anchors:

```text
ANCHOR_OPEN
ANCHOR_CLOSE
ANCHOR_REPAIR
```

---

# 22. Windbreak family

Potential forms:

- branch wall;
- woven panel;
- cloth screen;
- salvage panel wall.

Progression:

```text
single screen
→ multi-panel barrier
→ integrated shelter extension
```

Functions:

- weather protection;
- fire protection;
- camp zoning;
- privacy/comedy staging.

---

# 23. Canopy / shade structure

Potential progression:

```text
cloth tied between supports
→ framed canopy
→ reinforced covered area
```

Uses:

- cooking area;
- work area;
- food storage;
- resting area;
- rain protection.

Modules:

- posts;
- rope;
- cloth/thatch;
- drainage/gutter attachment.

---

# 24. Raised platform family

Reusable structural base.

Potential uses:

- sleeping platform;
- food storage;
- lookout;
- drying rack;
- work platform;
- dock;
- flood/wet-ground avoidance.

Progression:

```text
posts
→ beams
→ partial deck
→ complete deck
→ rails / ladder / cover
```

This should be one of the highest-value modular construction families.

---

# 25. Cargo sled / drag frame

Simple terrestrial transport aid.

Potential progression:

```text
rope drag
→ branch drag frame
→ crude sled
→ reinforced sled
```

Modules:

- runners / branches;
- crossbars;
- rope;
- cargo tie-down points.

Anchors:

```text
ANCHOR_LOAD
ANCHOR_PULL
ANCHOR_PUSH
ANCHOR_REPAIR
```

Functions:

- move logs;
- move heavy salvage;
- move multiple resources;
- accidental sliding on slopes.

This may offer more systemic value than an early wheeled cart.

---

# 26. Handcart / wheelbarrow possibility

Potential later project.

Variants:

- one-wheel barrow;
- two-wheel cart;
- salvaged-wheel cart.

Requires additional wheel grammar and may be disproportionately expensive compared with a sled.

States:

```text
partial
complete
loaded
wheel_damaged
repaired
```

Recommendation: treat as later/P2 until transport needs justify it.

---

# 27. Roller / log-moving aid

Primitive heavy-object transport.

Objects:

- small rollers;
- lever poles;
- rope harness;
- skids.

These need not become a formal named machine. They can be temporary project aids assembled from existing assets.

This supports visibly clever problem solving without requiring advanced technology.

---

# 28. Pulley / hoist family

Potential later mechanical aid.

Components:

- pulley wheel/block;
- rope;
- overhead beam;
- hook;
- counterweight/load point.

Functions:

- lift heavy salvage;
- construction;
- hanging storage;
- boat/raft handling.

States:

```text
assembled
tensioned
loaded
jammed
damaged
repaired
```

Use sparingly because it introduces rigging complexity, but it has high systemic reuse if implemented.

---

# 29. Mooring / tie-down infrastructure

Potential objects:

- mooring post;
- rope anchor;
- rock anchor;
- cargo tie-down ring/hook;
- ground stake.

Functions:

- secure raft;
- secure tarps;
- secure cargo;
- tension lines;
- stabilize structures.

Useful sockets:

```text
SOCKET_ROPE_ATTACH
SOCKET_TIE_DOWN
```

---

# 30. Path and route infrastructure

The island should accumulate navigation history through both passive wear and deliberate route improvement.

Potential progression:

```text
repeated foot traffic
→ faint path
→ cleared path
→ marked route
→ stabilized route
→ stepped / bridged difficult sections
```

Potential objects:

- path wear decals/geometry state;
- cleared vegetation state;
- stone markers;
- stakes;
- rope guide;
- stepping stones;
- small plank crossings.

This helps convert Wilson's routine into visible geography.

---

# 31. Trail markers / signs

Potential forms:

- stacked stones;
- carved stick;
- tied cloth marker;
- wooden sign;
- salvaged sign panel;
- symbol board.

Functions:

- resource marking;
- hazard marking;
- project marking;
- route marking;
- personal geography.

States:

```text
fresh
weathered
fallen
moved
repaired
```

---

# 32. Hazard barriers / warning structures

Potential forms:

- stones around hole;
- stakes around dangerous area;
- rope line;
- sign/marker;
- temporary cover.

Potential motivations:

- crab area;
- unstable ground;
- falling debris;
- fire danger;
- player-created hazard;
- damaged structure.

This gives Wilson ways to respond physically to remembered danger.

---

# 33. Project material staging areas

Large projects should visibly accumulate material before assembly.

Potential families:

- log pile;
- plank stack;
- rope coil cluster;
- stone pile;
- thatch stack;
- salvage pile;
- tool staging point.

Suggested states:

```text
empty
partial
ready
depleted
messy
weather_damaged
```

This is especially valuable for scenes where Wilson is interrupted before completing a project.

---

# 34. Scaffolding

Potential temporary structure for larger builds.

Modules:

- poles;
- planks;
- rope bindings;
- ladder access.

States:

```text
partial
usable
extended
dismantled
```

The same scaffold pieces could be reused as normal structural assets later.

---

# 35. Temporary braces and construction supports

Large projects should be able to display temporary construction state.

Potential components:

- diagonal braces;
- support poles;
- rope tension lines;
- wedges;
- temporary stakes.

These visual cues make partial projects believable without custom half-built meshes.

---

# 36. Repair and reinforcement language for large structures

Shared repair vocabulary:

```text
replacement plank
sistered beam
rope wrap
cross brace
patch panel
extra support post
metal strap
salvage plate
roof patch
foundation stone
```

Suggested durability-history progression:

```text
clean original
→ worn
→ damaged
→ patched
→ reinforced
→ mismatched long-lived structure
```

A mature camp should look more heterogeneous, not more factory-perfect.

---

# 37. Repurposing large structures

The game should permit some large projects to change role through attachments rather than total replacement.

Examples:

```text
lookout
+ cloth cover
→ shaded observation spot

raised platform
+ walls + roof
→ storage shed

simple dock
+ fish attachment
→ fishing station

fence
+ trellis growth
→ garden support

shelter awning
+ workbench
→ workshop annex
```

This reinforces systemic reuse and visible camp evolution.

---

# 38. Anchors for large structures

Common semantic anchors worth standardizing where applicable:

```text
ANCHOR_APPROACH
ANCHOR_BUILD
ANCHOR_REPAIR
ANCHOR_INSPECT
ANCHOR_ENTER
ANCHOR_EXIT
ANCHOR_CLIMB
ANCHOR_LOAD
ANCHOR_UNLOAD
ANCHOR_PUSH
ANCHOR_PULL
ANCHOR_MOOR
ANCHOR_BOARD
ANCHOR_SIT
ANCHOR_STAND
ANCHOR_WORK
```

Not every structure should expose every anchor.

---

# 39. Large-project state categories

Useful shared state concepts:

## Construction

```text
planned
marked
materials_staged
frame_partial
frame_complete
cover_partial
functional
complete
expanded
```

## Condition

```text
intact
worn
wet
loose
unstable
damaged
partially_broken
patched
reinforced
```

## Usage

```text
empty
loaded
occupied
organized
cluttered
blocked
```

## Environment

```text
storm_affected
flooded
sand_buried
vegetation_encroached
```

These should be applied selectively rather than creating a Cartesian product of variants.

---

# 40. High-value large-project families for early production

Suggested priority candidates based on reuse and representative-scene value:

## P0 / early

- shelter modular family;
- raised platform;
- canopy;
- fence/barrier;
- ladder;
- project staging piles;
- simple path markers;
- water catchment attachments;
- garden plot / border;
- drying rack expansion;
- cargo sled.

## P1

- raft;
- dock;
- bridge;
- lookout;
- storage shed;
- workshop annex;
- signal structure;
- trellis;
- wash station.

## P2 / prove need

- canoe/boat;
- wheelbarrow/cart;
- pulley/hoist;
- extensive scaffold system;
- sophisticated irrigation.

---

# 41. Generator implications

High-value generator/toolkit helpers suggested by this round:

```text
create_platform_frame
create_post_grid
create_plank_deck
create_fence_segment
create_gate
create_ladder
create_canopy_frame
create_roof_module
create_wall_module
create_structure_brace
create_mooring_post
create_raft_float_module
create_raft_frame
create_bridge_segment
create_dock_segment
create_garden_border
create_trellis
create_route_marker
create_material_staging_pile
create_cargo_sled
create_repair_reinforcement
```

Generators should share the same primitive components and material language so a dock, shelter and workbench visibly belong to the same construction culture.

---

# 42. Key design conclusions from Round 6

## 42.1 Structures should be assemblies, not monoliths

The strongest reusable pattern is:

```text
foundation / site
+ structural frame
+ functional surfaces
+ attachments
+ wear / repairs
```

## 42.2 Partial functionality can be interesting

A project does not always need to jump from unusable to complete.

Examples:

- partial shelter already gives some shade;
- partial fence already blocks some approaches;
- crude dock already improves water access;
- basic raft can float before receiving a deck or sail.

This may create richer project interruption scenes.

## 42.3 Transport should begin primitive

A cargo sled and raft are likely more aligned with the project's production constraints than immediately implementing carts and complex vehicles.

## 42.4 Routes are part of persistent scenery

Wilson's repeated movement and deliberate improvements should gradually produce recognizable paths, crossings and marked routes.

## 42.5 Mature structures should become visually heterogeneous

Repairs, salvaged material and extensions should make long-lived structures look more personal and historically layered rather than cleaner and more standardized.

## 42.6 Large projects multiply the value of previous asset rounds

A large project should mostly compose resources and primitives already defined in Rounds 1–5. New bespoke geometry should be introduced only when it adds a genuinely new function or silhouette.

---

# 43. Candidate next-round handoff

The next brainstorming round can focus on:

**Round 7 — Comfort, Habits, Decoration, Collections & Personalization**

Topics may include:

- sleeping comfort;
- seating variety;
- tables/surfaces;
- diary/writing area;
- personal storage;
- trophies/collections;
- found-object decoration;
- ritual/habit objects;
- clothing/accessory storage;
- lighting ambience;
- music/noise-making objects;
- Wilson's favorite places;
- visible evidence of repeated routines;
- camp personalization that emerges without a conventional decorating UI.
