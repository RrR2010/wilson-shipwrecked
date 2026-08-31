# Functional Asset Catalog Brainstorming — Round 9

## Scope

This final round consolidates the previous brainstorming rounds into a production-oriented matrix for Wilson Shipwrecked.

It is still a brainstorming artifact rather than a canonical implementation schema.

The purpose is to answer four practical questions:

1. Which asset families provide the highest systemic leverage?
2. Which states and capabilities should be standardized across families?
3. Which families should be procedural, modular, manually authored, or hybrid?
4. Which assets and reference sheets should be built first so future 3D-generation agents converge rather than drift?

The previous rounds are treated as source material:

- Round 1: physical island grammar;
- Round 2: food, water, cooking and storage;
- Round 3: tools, crafting, workstations and construction;
- Round 4: flora, fauna, habitats and renewable resources;
- Round 5: shipwreck, debris, found, rare and absurd objects;
- Round 6: large projects, transport, local navigation and structures;
- Round 7: comfort, habits, decoration, collections and personalization;
- Round 8: weather, hazards, damage states and opportunity objects.

---

# 1. Production philosophy

The asset catalog should optimize for **systemic coverage per authored primitive**, not raw object count.

A useful target is:

```text
few visual grammars
+ reusable components
+ visible state changes
+ broad physical capabilities
+ persistent placement/history
= many believable situations
```

The goal is not to model every possible object Wilson may ever touch.

The goal is to build a vocabulary from which many object roles can emerge.

---

# 2. Consolidated priority tiers

## P0 — vertical-slice systemic vocabulary

These families should exist before broad asset expansion because they support many representative scenes and validate the production pipeline itself.

### Environment and natural resources

- sand / wet sand / disturbed ground;
- rock family;
- flat rock / sit-work surface variant;
- pebble / throwable stone;
- palm family;
- palm frond;
- branch / stick;
- short and long log;
- basic fiber / vine / rope;
- coconut family;
- small generic tropical ground vegetation;
- tide pool;
- shallow water edge.

### Camp and construction vocabulary

- stake;
- post;
- pole;
- beam;
- plank;
- brace;
- binding;
- thatch bundle;
- thatch panel;
- simple platform/surface;
- project marker;
- material stack;
- repair patch.

### Core projects

- modular shelter;
- fire site / campfire;
- crude stool;
- simple table / work surface;
- crate / basic storage;
- basic food storage setup;
- rain-water container;
- drying rack;
- tool rack.

### Tools and manipulation

- generic handle;
- sharp stone;
- heavy stone;
- stone cutting head;
- stone impact head;
- improvised knife;
- improvised hatchet;
- improvised hammer;
- digging stick;
- spoon / eating utensil.

### Food and domestic props

- whole fruit generic family;
- prepared food chunk/slice;
- fish family;
- bowl / coconut-shell bowl;
- cup;
- pot;
- food skewer;
- water container;
- small basket;
- food pile / material pile presentation.

### Fauna and habitat

- crab;
- crab burrow;
- simple bird;
- perch socket vocabulary.

### Shipwreck and salvage

- ship crate;
- rope coil;
- cloth/sailcloth sheet;
- metal scrap;
- bottle/jar;
- sealed metal container;
- generic shipwreck structural section.

### Weather/history states

- wet material state;
- fire smoke / extinguished state;
- puddle;
- mud patch;
- fallen branch;
- fallen frond;
- damaged roof component;
- displaced light prop;
- storm debris pile.

### Character support

- Wilson scale mannequin for production previews;
- semantic hand/grip/carry/reference anchors;
- sit, inspect, pickup and work-height references.

---

## P1 — broad systemic expansion

P1 adds meaningful depth once P0 proves the grammar.

### Environment

- soil/cultivated plot;
- rock ledge;
- shallow hole/dig site;
- worn path states;
- mud/flood variations;
- fallen tree;
- additional palm/tree variants;
- fruit-bearing plants;
- berry/fiber patches;
- shells/shellfish;
- seaweed.

### Domestic and survival infrastructure

- pantry/storage locker;
- raised storage;
- covered drying rack;
- smoking rack;
- wash station;
- clothesline;
- bedding/sleeping mat;
- hammock;
- shelf/display surface;
- bench;
- improved chair;
- cooking support / grill;
- covered cooking area.

### Work and construction

- workbench;
- tool-head variants;
- ladder;
- fence/gate;
- canopy;
- raised platform;
- storage shed;
- workshop shelter;
- scaffolding;
- drainage trench;
- reinforced repair variants.

### Transport / navigation

- cargo sled;
- raft;
- paddle;
- simple dock;
- stepping-stone crossing;
- bridge;
- mooring point;
- route markers / signs.

### Fauna

- additional crab/body variants;
- additional bird family;
- small fish;
- recurring/persistent animal presentation variants;
- nest;
- additional hide/perch/burrow habitat props.

### Salvage

- barrel/drum;
- luggage;
- bucket;
- net;
- pipe;
- flat panel/sign;
- wearable debris;
- domestic utensil variants;
- marine safety object;
- umbrella-like object;
- sports ball family.

### Personalization

- diary/writing surface;
- tally/day markers;
- shell/stone collections;
- trophy/display objects;
- personal storage;
- leisure target;
- hanging decoration/chime;
- retired-tool display support.

---

## P2 — authored richness and long-run expansion

P2 should only be added after the systemic grammar demonstrates enough reuse.

Potential families include:

- canoe/boat;
- handcart/wheelbarrow;
- pulley/hoist;
- lookout tower;
- larger dock;
- signal/beacon structure;
- advanced garden infrastructure;
- severe erosion assets;
- large flood states;
- lightning-struck variants;
- advanced fire-spread damage;
- complex fish/shore fauna;
- highly distinctive rare salvage;
- toys and curiosities;
- office/industrial absurdities;
- sophisticated musical/leisure props;
- large authored landmarks;
- highly personalized late-run shelter extensions.

---

# 3. Standardized state vocabulary

The following states appeared repeatedly across rounds and should become a shared art-direction vocabulary.

They do not imply a single technical implementation.

## 3.1 Condition

```text
intact
worn
damaged
broken
repaired
reinforced
```

## 3.2 Moisture

```text
dry
wet
soaked
drying
```

## 3.3 Exposure / containment

```text
exposed
covered
sealed
open
closed
```

## 3.4 Fill

```text
empty
partial
full
overfilled
```

## 3.5 Food/resource condition

```text
unripe
ripe
overripe
fresh
aging
spoiled
raw
prepared
cooked
burned
```

## 3.6 Fire

```text
unlit
smoking
small_fire
burning
embers
extinguished
charred
```

## 3.7 Project

```text
planned
marked
materials_staged
partial
functional_partial
complete
damaged
repaired
modified
```

## 3.8 Ecological resource

```text
abundant
harvested
sparse
depleted
recovering
```

## 3.9 Plant growth

```text
seed
sprout
juvenile
mature
flowering
fruiting
harvested
recovering
dead
```

## 3.10 Placement / stability

```text
secured
loose
displaced
stacked
hanging
raised
grounded
```

The art pipeline should avoid creating separate bespoke visual languages for semantically equivalent states.

---

# 4. Consolidated capability vocabulary

The following capabilities offer high reuse across the catalog.

## Physical manipulation

- portable;
- throwable;
- rollable;
- drag-able;
- pushable;
- carry-small;
- carry-large;
- two-hand-carry;
- stackable;
- hangable;
- placeable-on-surface.

## Material interaction

- cuttable;
- choppable;
- breakable;
- crushable;
- impact-capable;
- sharp;
- heavy;
- flexible;
- bindable;
- burnable;
- absorbent;
- waterproof-ish;
- floatable.

## Domestic/resource use

- edible;
- drinkable-source;
- cookable;
- container;
- liquid-container;
- storage;
- fuel;
- tinder;
- construction-material;
- crafting-material;
- tool-component.

## Spatial use

- sittable;
- sleepable;
- work-surface;
- climbable;
- perchable;
- shade-providing;
- sheltering;
- blocking;
- landmark;
- route-marker.

## Ecological use

- harvestable;
- renewable;
- animal-attracting;
- habitat;
- nest-support;
- hide-support;
- burrow-support.

## History/social use

- inspectable;
- collectible;
- displayable;
- preference-capable;
- personal-location-capable;
- persistent-instance-worthy;
- repair-history-visible.

Capabilities should drive behavior compatibility more than object-specific interaction lists wherever possible.

---

# 5. Anchor vocabulary consolidation

Not every asset needs all anchors. The purpose is to converge naming and interaction geometry.

## Common interaction anchors

```text
ANCHOR_APPROACH
ANCHOR_INSPECT
ANCHOR_PICKUP
ANCHOR_PLACE
ANCHOR_USE
```

## Resource anchors

```text
ANCHOR_HARVEST
ANCHOR_CHOP
ANCHOR_CUT
ANCHOR_DIG
ANCHOR_BREAK
```

## Domestic anchors

```text
ANCHOR_SIT
ANCHOR_SLEEP
ANCHOR_EAT
ANCHOR_DRINK
ANCHOR_COOK
ANCHOR_WASH
```

## Work anchors

```text
ANCHOR_WORK
ANCHOR_BUILD
ANCHOR_REPAIR
ANCHOR_ADD_MATERIAL
ANCHOR_ADD_FUEL
```

## Character-height references

When useful, variants may include:

```text
ANCHOR_REACH_LOW
ANCHOR_REACH_MID
ANCHOR_REACH_HIGH
```

## Large-object navigation anchors

```text
ANCHOR_ENTER
ANCHOR_EXIT
ANCHOR_CLIMB_START
ANCHOR_CLIMB_END
ANCHOR_BOARD
ANCHOR_DISEMBARK
ANCHOR_MOOR
```

Anchor count should remain minimal. Do not add semantic nodes merely because the vocabulary exists.

---

# 6. Socket vocabulary consolidation

Sockets are most valuable where interchangeable physical pieces produce visible composition.

## Structural

```text
SOCKET_POST_*
SOCKET_BEAM_*
SOCKET_BRACE_*
SOCKET_PANEL_*
SOCKET_ROOF_*
SOCKET_FLOOR_*
SOCKET_EXTENSION_*
```

## Linear components

```text
SOCKET_END_A
SOCKET_END_B
SOCKET_EDGE_L
SOCKET_EDGE_R
SOCKET_TOP
SOCKET_BOTTOM
```

## Tool assembly

```text
SOCKET_TOOL_HEAD
SOCKET_HANDLE
SOCKET_BINDING
```

## Containers / storage

```text
SOCKET_CONTENT_*
SOCKET_LID
SOCKET_HANG
```

## Ecology

```text
SOCKET_FRUIT_*
SOCKET_PERCH_*
SOCKET_NEST_*
SOCKET_HIDE_*
SOCKET_BURROW_*
```

## Comfort / camp

```text
SOCKET_HAMMOCK
SOCKET_CLOTHESLINE
SOCKET_LANTERN
SOCKET_DISPLAY_*
```

Socket contracts should be stable enough that procedural variants remain interchangeable.

---

# 7. Production strategy by family type

## 7.1 Strong procedural-generator candidates

These families benefit from bounded variation and low authoring complexity:

- rocks;
- pebbles;
- palms;
- generic vegetation clusters;
- branches;
- logs;
- stakes;
- posts;
- poles;
- beams;
- planks;
- braces;
- rope/bindings;
- thatch bundles/panels;
- crates;
- baskets;
- barrels;
- bottles;
- material stacks;
- debris clusters;
- simple fences;
- simple platforms;
- repair patches;
- puddles/mud visual geometry where geometry-based;
- basic project staging.

## 7.2 Modular assembly candidates

These should mostly be composed from generator-produced parts:

- shelter;
- workshop;
- storage shed;
- drying/smoking racks;
- cooking area;
- fences;
- canopy;
- bridge;
- dock;
- raft;
- lookout;
- garden infrastructure;
- water collection infrastructure;
- storage systems.

## 7.3 Hybrid authored + procedural candidates

These benefit from one strong authored silhouette plus parameterized states/attachments:

- fire pit;
- stool/chair families;
- workbench;
- tool families;
- containers with mechanisms;
- shipwreck sections;
- large salvage;
- hammock;
- recurring-animal habitats;
- rare curiosities.

## 7.4 Primarily manually authored candidates

- Wilson;
- Wilson rig and character-specific animation support;
- identifiable recurring animals if they need personality-level silhouettes;
- hero rare objects where recognition matters strongly;
- high-value shipwreck landmark sections;
- unusually complex vehicles if introduced later.

---

# 8. High-leverage primitive generators

A relatively small generator toolkit can cover a large portion of the catalog.

Suggested early toolkit:

```text
create_irregular_rock
create_flat_rock
create_branch
create_log
create_stake
create_post
create_pole
create_beam
create_plank
create_brace
create_rope_segment
create_binding
create_thatch_bundle
create_thatch_panel
create_platform
create_material_stack
create_container_body
create_crate
create_basket
create_barrel
create_bottle
create_cloth_sheet
create_metal_scrap
create_tool_handle
create_tool_head
assemble_tool
create_project_marker
create_repair_patch
create_debris_cluster
create_simple_fence
```

Then assembly helpers:

```text
assemble_shelter
assemble_rack
assemble_work_surface
assemble_storage
assemble_raft
assemble_dock
assemble_bridge
```

The first objective is not to automate everything. It is to establish a reusable visual construction vocabulary.

---

# 9. Highest-leverage families

The following families deserve disproportionate attention because they appear in many systems and scenes.

## Tier A — foundational

### Rock

Supports:

- scenery;
- sitting;
- landmarks;
- impact tools;
- throwing;
- crushing;
- construction;
- fire rings;
- markers;
- hazards.

### Wood

Supports:

- fuel;
- tools;
- construction;
- furniture;
- barriers;
- transport;
- project staging;
- repairs.

### Rope / fiber

Supports:

- tools;
- structures;
- transport;
- hanging storage;
- hammocks;
- clotheslines;
- traps/barriers;
- repairs.

### Surface / platform

Supports:

- eating;
- work;
- storage;
- drying;
- sitting;
- display;
- projects.

### Container

Supports:

- food;
- water;
- salvage;
- mystery/discovery;
- routines;
- animal conflict;
- player intervention.

### Cloth / sheet

Supports:

- shelter;
- shade;
- rain collection;
- bedding;
- clothing;
- repair;
- wind response;
- repurposed salvage.

These six grammar families should be treated as foundational art-system vocabulary.

---

# 10. Visual-history leverage

Some families offer unusually high value because their history can remain visible.

Highest-priority history-bearing assets:

1. shelter;
2. fire site;
3. shipwreck;
4. workbench/work area;
5. storage area;
6. raft/dock;
7. favorite seating locations;
8. recurring animal habitats;
9. tools with repair/wear history;
10. paths and repeated-use terrain;
11. collections/displays;
12. repaired furniture;
13. drainage/weather adaptations.

These should not be aggressively reset to pristine visual states.

---

# 11. Representative-scene coverage matrix

A compact set of P0 families can already support a large percentage of the representative catalog.

| Scene pattern | Required asset vocabulary |
| --- | --- |
| preferred sitting spot | flat rock, stool, log, sit anchors |
| breakfast routine | storage, food item, bowl/utensil, eating surface |
| feared tide pool | tide pool, crab/habitat, palm/terrain landmarks |
| physical experimentation | container, wood piece, stone, damage states |
| absurd heavy tool | rare heavy object + generic impact capability |
| player suggestion/refusal | inspectable/movable mystery object |
| wearable debris | wearable salvage + character attachment |
| missing spoon | utensil, habitual placement surface |
| benefactor/dependence | portable resources + project staging |
| hated fire pit | persistent fire-site instance + fire states |
| recurring crab | persistent animal + food + habitat |
| project interruption | partial project composition + material staging |
| storm aftermath | damage states + displaced props + repair components |
| collection/personalization | shelf/display + collectible objects |

This reinforces that broad reusable capabilities are more valuable than one-off scene props.

---

# 12. Recommended golden-reference sequence

The production reference pack should now be generated in this order.

## Reference Sheet 1 — Shape Grammar

Show together:

- rock variants;
- branch/log variants;
- stake/post/pole/beam/plank/brace;
- rope binding;
- thatch;
- cloth;
- simple containers.

Purpose: lock the basic low-poly construction language.

## Reference Sheet 2 — Natural Island Vocabulary

Show:

- palms;
- shrubs;
- ground vegetation;
- rocks;
- coconuts;
- tide pool;
- fallen natural resources.

Purpose: establish nature density and silhouette rules.

## Reference Sheet 3 — Camp Primitive Props

Show:

- crate;
- stool;
- table/work surface;
- fire pit;
- pot;
- bowls/cups;
- basket;
- drying rack;
- tool rack;
- water container.

Purpose: lock prop scale and handmade-object grammar.

## Reference Sheet 4 — Tool Grammar

Show:

- handles;
- sharp/heavy heads;
- bindings;
- assembled knife/hatchet/hammer/digging tool;
- intact/worn/repaired variations.

Purpose: lock tool modularity and readable capability silhouettes.

## Reference Sheet 5 — Shelter Evolution

Show a single shelter lineage:

```text
site
→ marked
→ partial frame
→ full frame
→ partial roof
→ basic shelter
→ improved shelter
→ damaged
→ patched/reinforced shelter
```

Purpose: validate composition and history retention.

## Reference Sheet 6 — Salvage & Repurposing

Show:

- crate;
- barrel;
- bottle;
- metal scrap;
- cloth;
- luggage;
- flat panel;
- unusual wearable;
- one absurd heavy object;
- examples of repurposing in camp structures.

Purpose: define contrast between natural/handmade/found objects.

## Reference Sheet 7 — Weather and Damage

Show shared families in:

- dry/wet;
- intact/damaged;
- loose/secured;
- fire burning/extinguished;
- storm aftermath states.

Purpose: establish how much state difference must be visible at gameplay distance.

## Reference Sheet 8 — Wilson Scale and Interaction

Not final character design.

Show approved Wilson direction beside:

- coconut;
- crate;
- stool;
- table;
- palm;
- shelter;
- hand tool;
- large carried log.

Include reach/carry/sit reference positions.

Purpose: prevent scale drift.

---

# 13. Golden scene recommendation

After the reference sheets, build one canonical gameplay-camera scene containing:

- Wilson or approved mannequin;
- 2–3 palms;
- vegetation clusters;
- multiple rock roles including one flat sitting rock;
- tide-pool edge;
- basic shelter with visible repair/extension;
- fire pit;
- crate/storage;
- work surface;
- drying rack;
- water container;
- stool/log seat;
- coconut/resources;
- several tools;
- material staging pile;
- one small salvage curiosity;
- one crab;
- one visible weather/history trace.

This scene should be used as the primary compatibility test for new assets.

---

# 14. Agent asset-brief template

Each production brief should eventually capture at least:

```yaml
family: example_family
priority: P0

role:
  - world_role
  - gameplay_role

variants:
  - variant_a
  - variant_b

states:
  - intact
  - damaged

capabilities:
  - portable
  - breakable

composition:
  modular: true
  parts:
    - part_a
    - part_b

anchors:
  - ANCHOR_APPROACH
  - ANCHOR_INSPECT

sockets:
  - SOCKET_END_A
  - SOCKET_END_B

generator_strategy:
  type: procedural
  parameters:
    - seed
    - scale
    - part_variant

visual_history:
  persistent_repairs: true

scene_coverage:
  - representative_scene_name
```

This is a briefing format, not yet an implementation contract.

---

# 15. Production-order recommendation

A practical first production sequence is:

```text
1. shared material palette
2. rock family
3. wood primitive family
4. rope/binding family
5. palm + simple vegetation
6. crate/container family
7. campfire
8. tool grammar
9. shelter components + staged evolution
10. primitive domestic props
11. tide pool + crab
12. salvage vocabulary
13. weather/damage state pass
14. canonical golden scene
```

This order deliberately postpones broad decoration and rare-object variety until the core grammar has proven visual consistency.

---

# 16. Scope guards

The brainstorming produced a large possibility space. The following guards should prevent it from becoming an asset-content trap.

## Guard 1 — capability before novelty

Do not author a new prop if an existing family can satisfy the scene through shared physical capabilities.

## Guard 2 — state before replacement

Prefer visible state/component changes over full replacement meshes where practical.

## Guard 3 — composition before monolith

For projects and structures, prefer reusable pieces and sockets over bespoke complete structures.

## Guard 4 — identity only where valuable

Do not make every animal/object persistent and unique. Promote instances to meaningful identity only when repeated history warrants it.

## Guard 5 — gameplay camera is authoritative

A state or capability distinction that cannot be read from the gameplay camera should not drive unnecessary geometry.

## Guard 6 — rare remains rare

Absurd or highly recognizable found objects should remain sparse enough that they retain surprise value.

## Guard 7 — history should accumulate selectively

Preserve repairs, favorite locations, project evolution and meaningful wear. Do not persist every trivial visual disturbance indefinitely.

---

# 17. Final synthesis

Across all nine rounds, the strongest production direction is not a giant object catalog.

It is a **small visual-physical vocabulary with high combinatorial reuse**.

The most important grammar is:

```text
NATURAL MATERIALS
rock
wood
fiber
leaf
food/water resources

PROCESSED COMPONENTS
stake
post
pole
beam
plank
rope
panel
container
surface

ASSEMBLIES
binding
frame
rack
platform
storage
work surface

PROJECTS
shelter
fire site
cooking area
storage
raft
dock
bridge
workshop

FOUND OBJECTS
crate
metal
cloth
bottle
barrel
luggage
rare curiosity

VISIBLE HISTORY
wear
damage
repair
extension
replacement
reorganization
habit
collection
```

The desired production outcome is:

> many stories and recognizable situations generated from a narrow, coherent library of visual building blocks.

This should be the basis for the next art-production layer: golden references, reference sheets, concrete family briefs and procedural Blender generator work.
