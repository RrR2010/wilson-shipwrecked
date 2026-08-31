# Functional Asset Catalog Brainstorming — Round 3

## Scope

This round explores functional asset families related to:

- primitive and improved tools;
- reusable tool components;
- cutting, impact, digging, piercing and gripping actions;
- crafting and assembly;
- work surfaces and workstations;
- project staging and visible construction progress;
- repair and maintenance;
- structural components and modular construction vocabulary;
- tool storage and organization;
- wear, damage and improvisation;
- construction aids such as ladders, scaffolds and hauling supports.

This is a brainstorming artifact, not a canonical implementation schema.

The goal is to identify a compact physical vocabulary that can support many interactions and projects without requiring one bespoke asset per recipe or action.

---

# 1. Tool philosophy

Tools should normally be understood as compositions of physical capabilities rather than fixed recipe keys.

Conceptually:

```text
tool
├── grip / handle
├── working end
├── binding / joint
├── mass / reach / leverage
└── condition
```

A useful simulation-facing distinction is:

```text
object shape/material
      +
assembled configuration
      +
current condition
      ↓
physical capabilities
```

Examples:

```text
stone + hand
→ improvised hammering / crushing

sharp stone + short handle + binding
→ cutting / chopping tool

heavy stone + long handle + binding
→ stronger impact / chopping candidate

straight pole
→ reach / poke / lever / structural member
```

The 3D catalog should therefore favor reusable visual parts and recognizable capability-bearing forms.

Avoid designing every interaction as a unique item such as:

```text
coconut_opener
palm_chopper
crate_breaker
```

Prefer a smaller vocabulary such as:

```text
sharp
heavy
blunt
pointed
long_reach
levering
gripping
cutting
chopping
digging
```

that multiple objects can satisfy with different effectiveness.

---

# 2. Tool condition vocabulary

A shared condition grammar can serve most manufactured tools.

Potential states:

```text
new / well-made
serviceable
worn
loose
chipped
cracked
bent
dull
broken
improvised repair
repaired
wet
rusted / corroded (metal only)
burned / charred (wooden parts)
```

Not every tool needs every state.

Condition should be visible through large changes that survive gameplay distance:

- missing chunk;
- shortened edge;
- visibly loose head;
- replacement binding;
- mismatched repair handle;
- bent silhouette;
- darkened or corroded material block.

A repair should not always reset an object to pristine appearance. Visible repair history is desirable.

---

# 3. Handle family

Handles should be highly reusable across tool families.

| Family | Variants | Expected roles |
| --- | --- | --- |
| `handle_short` | straight, slightly curved | knife, scraper, small hammer |
| `handle_medium` | light/heavy | axe, hammer, adze |
| `handle_long` | straight, reinforced | hoe, digging tool, spear-like tool |
| `pole_long` | thin/thick | reach, lever, structure, carrying |
| `grip_wrapped` | fiber/cloth wrapping | comfort/repair visual |

Potential states:

```text
raw branch
trimmed
shaped
wrapped
cracked
broken
replacement
```

Potential sockets:

```text
SOCKET_HEAD
SOCKET_GRIP
SOCKET_END
```

The same handle generator should be able to serve several tool families with bounded variation.

---

# 4. Working-head family

## 4.1 Stone heads

Potential forms:

- rounded hammer stone;
- wedge-shaped cutting stone;
- sharp flake;
- pointed stone;
- flat scraper stone;
- heavy axe/adze stone.

States:

```text
natural
selected
chipped/shaped
worn
chipped_damaged
broken
```

Capabilities may include:

- impact;
- cutting;
- scraping;
- piercing;
- crushing.

## 4.2 Metal heads / found metal

Potential forms:

- metal shard;
- flat plate fragment;
- sharpened scrap;
- found axe-like head;
- hammer-like metal object;
- hook-like scrap.

Metal should be uncommon enough to feel materially distinct from primitive stone/wood construction.

States:

```text
clean
rusted
bent
sharpened
dull
chipped
repaired / rehandled
```

Metal found in shipwreck debris can create capability jumps without requiring a conventional technology tree.

## 4.3 Bone / shell working ends

Potential forms:

- bone point;
- bone needle;
- shell scraper;
- shell edge;
- hook-like bone.

These expand material vocabulary while remaining visually simple.

---

# 5. Binding and joints

Bindings should be a first-class visual language for improvised tools.

Potential families:

| Family | Use |
| --- | --- |
| `binding_fiber_small` | small tools |
| `binding_rope_medium` | axes, hammers, joints |
| `binding_cross_lash` | structural frames |
| `binding_wrap` | handle reinforcement |
| `binding_repair` | visible field repair |

States:

```text
tight
loose
frayed
wet
replaced
reinforced
```

A bound tool should visibly communicate how it is constructed. This is particularly important for an aggressive low-poly style where material joints can replace texture detail.

---

# 6. Cutting tool families

## 6.1 Hand cutting edge

Possible assets:

- sharp stone flake;
- shell edge;
- metal shard;
- improvised knife.

Functions:

- cut fiber;
- trim plants;
- prepare food;
- carve wood;
- scrape;
- open/cut compatible materials.

States:

```text
sharp
dull
chipped
broken
```

## 6.2 Knife family

Composition:

```text
handle_short
+ cutting_head
+ binding / tang connection
```

Variants:

- stone knife;
- shell knife;
- scrap-metal knife;
- repaired knife.

Potential anchors:

```text
ANCHOR_PICKUP
ANCHOR_INSPECT
```

Character attachment should use semantic hand anchors rather than tool-specific character rigs.

## 6.3 Axe / hatchet family

Composition:

```text
handle_medium
+ chopping_head
+ binding
```

Variants:

- primitive stone hatchet;
- larger stone axe;
- found/rehandled metal hatchet;
- repaired axe.

Possible progression:

```text
hand stone
→ hafted stone tool
→ improved hafted stone axe
→ found metal head + improvised handle
→ maintained/repaired preferred axe
```

Visible states:

```text
serviceable
loose_head
dull
chipped_handle
rebound
replacement_handle
```

This family should expose chopping capability rather than palm-specific behavior.

## 6.4 Adze / carving tool

Potential role:

- flatten timber;
- hollow wood;
- prepare planks;
- shape construction components.

This can reuse axe components with a different head orientation.

---

# 7. Impact and crushing tools

## 7.1 Hand stone / improvised hammer

The simplest impact tool may just be a portable stone.

Use cases:

- crack shell;
- strike container;
- drive stake;
- crush food/material;
- break brittle object.

## 7.2 Mallet family

Composition:

```text
wood_head
+ handle_medium
```

Variants:

- simple wood mallet;
- heavy root/branch mallet;
- repaired mallet.

Functions:

- drive stakes;
- assembly;
- impact without cutting;
- construction work.

## 7.3 Hammer family

Composition:

```text
stone_or_metal_head
+ handle
+ binding
```

Functions:

- impact;
- driving;
- breaking;
- shaping.

Potential distinction from mallet should be physical/material, not arbitrary recipe access.

## 7.4 Crushing surface + striker

Not every crushing action needs a handheld tool family.

Potential setup:

```text
flat stone / bowl-like stone
+ hand stone
```

Functions:

- crush seeds;
- mash food;
- grind pigment/material;
- experiment with brittle objects.

This could become an early workstation precursor.

---

# 8. Digging and ground-working tools

## 8.1 Digging stick

One of the simplest constructed tools.

States:

```text
raw stick
sharpened
worn
broken
```

Functions:

- dig soft soil;
- probe ground;
- plant;
- pry small objects.

## 8.2 Improvised shovel / spade

Composition:

```text
long_handle
+ broad head
```

Possible heads:

- shaped wood;
- shell;
- flat scrap metal.

Functions:

- dig;
- move sand/soil;
- clear debris;
- fill holes.

## 8.3 Hoe-like tool

Functions:

- cultivate soil;
- clear shallow vegetation;
- prepare planting area.

Could share handle and head infrastructure with adze/digging tools.

## 8.4 Scoop / hand trowel

Small-scale digging and transferring.

Useful for gardening and domestic tasks without requiring a full shovel animation every time.

---

# 9. Piercing, poking and reach tools

Potential families:

| Family | Roles |
| --- | --- |
| `pointed_stick` | poke, probe, skewer, simple defense |
| `long_pole` | reach, knock fruit, lever, push |
| `hook_pole` | retrieve, pull, hang |
| `spear_like_tool` | fishing/hunting/defense candidate |
| `short_awl` | puncture, craft holes |
| `needle_bone` | sewing / fine fiber work |

Important: these should derive value from shape and reach, not be locked to one target type.

A long pole might plausibly:

- knock down fruit;
- retrieve floating debris;
- push something away;
- test dangerous ground;
- support a tarp;
- become a structural member later.

This is exactly the kind of cross-context reuse the project should favor.

---

# 10. Levers, wedges and simple machines

A systemic physical sandbox benefits from a few non-obvious but powerful primitive objects.

## 10.1 Lever pole

Potentially just a sufficiently strong long pole used against an appropriate support.

Functions:

- move heavy object;
- pry crate/container;
- lift construction component;
- roll rock.

## 10.2 Wedge

Possible materials:

- shaped wood;
- stone wedge;
- metal scrap.

Functions:

- splitting;
- holding gap;
- stabilizing;
- construction alignment.

## 10.3 Roller logs

Small logs placed beneath a heavy object.

Functions:

- transport heavy crate/stone;
- project staging;
- comedic failure if alignment is poor.

## 10.4 Rope hauling setup

Potential objects:

- rope;
- fixed post/tree anchor;
- hauling loop;
- improvised pulley found later.

Even if full rope physics is not implemented, visible hauling setups can support authored/systemic heavy-object actions.

---

# 11. Measuring, marking and planning objects

Construction becomes much more readable when Wilson visibly prepares before assembling.

Potential families:

- marking stick;
- charcoal piece;
- line/string;
- stake marker;
- measuring cord;
- template frame;
- stone markers.

Functions:

- mark project site;
- establish footprint;
- align components;
- leave persistent construction intention visible.

These can make a project legible before any major structure exists.

Example visual progression:

```text
empty ground
→ corner markers
→ connecting cord / layout
→ staged materials
→ first structural component
```

This supports the living-diorama requirement particularly well because intention becomes scenery.

---

# 12. Work surface family

Work surfaces should be generic enough to support many tasks.

## 12.1 Natural work surface

Examples:

- flat rock;
- stump;
- large log.

Capabilities:

- place object;
- cut/process;
- hammer;
- inspect;
- eat.

## 12.2 Crude work table

Composition:

```text
top planks
+ supports/legs
+ bindings
```

States:

```text
partial
complete
unstable
reinforced
damaged
repaired
cluttered
```

## 12.3 Workbench

A more intentional project station.

Potential components:

- stable top;
- lower shelf;
- tool hooks;
- simple clamp/wedge slot;
- material rack.

Potential anchors:

```text
ANCHOR_WORK_FRONT
ANCHOR_WORK_SIDE
ANCHOR_PLACE
SOCKET_TOOL_01...
SOCKET_MATERIAL_01...
```

The workbench should not magically enable recipes. It should provide a better physical context for tasks that require stable support, organization or repeated work.

---

# 13. Tool storage and organization

Tool storage is useful both functionally and narratively because Wilson can develop habits around where he keeps things.

Potential families:

| Family | Description |
| --- | --- |
| `tool_pile` | earliest loose organization |
| `tool_basket` | small tools/components |
| `tool_crate` | general storage |
| `tool_rack_wall` | hanging long tools |
| `tool_rack_floor` | axe/shovel/poles |
| `peg_strip` | small hanging tools |
| `workbench_tool_slots` | integrated workstation storage |

States:

```text
empty
partially occupied
full
disorganized
organized
damaged
```

A preferred tool can have a recognizable recurring storage position, supporting scenes similar to the missing-spoon pattern.

---

# 14. Material staging

Projects should visibly accumulate materials before and during construction.

Potential staging asset families:

- log pile;
- pole bundle;
- plank stack;
- stone pile;
- rope coil;
- leaf/frond stack;
- thatch bundle stack;
- scrap pile;
- selected project parts laid out on ground.

Important distinction:

```text
inventory abstraction
≠
visible staged project material
```

For important projects, some proportion of committed materials should physically appear at the site when feasible.

States may include:

```text
small
medium
large
depleted
mixed
organized
scattered
wet
```

---

# 15. Generic project-site family

Large projects need a visible persistent identity before completion.

Conceptual project site:

```text
project_site
├── footprint / layout
├── required sockets
├── installed components
├── staged materials
├── active work anchors
└── damage / abandonment state
```

Potential states:

```text
planned
marked
materials_staged
foundation_partial
frame_partial
structure_partial
near_complete
complete
abandoned
damaged
repairing
modified
```

Possible anchors:

```text
ANCHOR_WORK_01...
ANCHOR_INSPECT
ANCHOR_CARRY_DROP
ANCHOR_REPAIR
```

Sockets should describe assembly compatibility, for example:

```text
SOCKET_POST_NW
SOCKET_POST_NE
SOCKET_BEAM_N
SOCKET_ROOF_A
SOCKET_EXTENSION_E
```

A project should not need a separate monolithic mesh for every completion percentage if modular installed parts can communicate progress more naturally.

---

# 16. Structural construction primitives

Round 1 introduced processed wood. This round expands the actual assembly grammar.

## 16.1 Vertical supports

Families:

- stake;
- short post;
- tall post;
- forked post;
- reinforced post.

States:

```text
loose
placed
driven
leaning
reinforced
damaged
```

## 16.2 Horizontal members

Families:

- pole;
- beam;
- crossbeam;
- ridge beam;
- brace.

Possible socket grammar:

```text
SOCKET_END_A
SOCKET_END_B
SOCKET_BIND_A
SOCKET_BIND_B
```

## 16.3 Panels

Families:

- plank panel;
- thatch panel;
- woven fiber panel;
- cloth/tarp panel;
- mixed repair panel.

Roles:

- wall;
- roof;
- screen;
- floor;
- door/flap.

## 16.4 Platforms

Families:

- floor platform;
- raised platform;
- small deck;
- storage platform;
- sleeping platform.

Platforms should expose edge sockets for extension where appropriate.

---

# 17. Joinery / connection language

The art should make structure understandable without engineering detail.

Potential joint visuals:

- cross-lashed poles;
- forked support resting beam;
- rope-wrapped overlap;
- pegged plank;
- wedged component;
- stacked stone foundation;
- fitted notch represented with simple geometry;
- improvised metal fastener for later/found-material construction.

A useful visual hierarchy:

```text
primitive construction
→ obvious lashings and overlaps

improved construction
→ cleaner alignment + fewer redundant lashings

repaired construction
→ mismatched replacement component + visible added binding
```

This communicates Wilson's increasing competence without requiring ornate models.

---

# 18. Shelter construction expansion

Round 1 defined shelter as a project rather than a monolithic model. Round 3 expands the project vocabulary.

Potential shelter component families:

- corner stake;
- vertical post;
- A-frame support;
- ridge pole;
- side beam;
- diagonal brace;
- roof frond;
- thatch panel;
- wall panel;
- entrance flap;
- floor mat;
- raised floor section;
- storage shelf;
- rain gutter attachment;
- repair patch;
- extension frame.

Potential evolution paths:

```text
lean-to
→ closed basic shelter
→ reinforced shelter
→ raised/drier shelter
→ shelter with storage
→ shelter with rain collection
→ shelter with work/cooking awning
```

Evolution does not need to be a strict linear tier system. Components may be added in different orders according to circumstances.

Damage states:

```text
missing roof panel
loose roof
collapsed side
broken support
wet interior
storm-damaged
patched
reinforced after failure
```

This is a high-value area for persistent visual history.

---

# 19. Small construction projects

The same component grammar can support many projects.

Potential project families:

| Project | Typical components |
| --- | --- |
| stool | short legs + seat |
| bench | supports + long top |
| table | posts/legs + top |
| shelf | supports + plank |
| storage platform | posts + deck |
| drying rack | posts + crossbars + lines |
| tool rack | posts/frame + holders |
| low fence | stakes + rails/bindings |
| wind screen | frame + panel |
| shade canopy | posts + roof/tarp |
| rain collector frame | posts + catch surface |
| marker/sign | stake + panel |

These should reuse generators and sockets rather than each becoming an unrelated art family.

---

# 20. Ladders, climbing aids and access structures

Potential families:

## 20.1 Simple ladder

Composition:

```text
2 long poles
+ repeated rungs
+ bindings
```

States:

```text
partial
complete
unstable
damaged
repaired
```

Capabilities:

- climb;
- access elevated storage;
- construction support;
- fruit harvesting.

## 20.2 Step stool / block

Small access aid with broad reuse.

## 20.3 Rope ladder

Later/found-material variant with storage implications.

## 20.4 Climbing rope

Can attach to compatible anchor points rather than requiring a bespoke tree variant.

---

# 21. Scaffolding and temporary construction aids

Even a small diorama can benefit from temporary objects that make projects look active.

Potential families:

- scaffold frame;
- temporary support brace;
- sawhorse-like support;
- material trestle;
- temporary rope line;
- lifting tripod;
- support wedge/block.

States:

```text
assembled
in_use
partially dismantled
stored components
```

Temporary construction infrastructure is valuable because it can appear during a project and disappear/recombine afterward, making building activity visually richer without requiring unique animations.

---

# 22. Carrying and hauling aids

## 22.1 Carry bundle

Visual bundling for:

- sticks;
- poles;
- fronds;
- tools.

Can attach to `ANCHOR_CARRY` or shoulder/back anchors.

## 22.2 Shoulder pole

Potentially supports balanced carrying of containers/materials.

## 22.3 Drag sled / travois

Composition:

```text
long poles
+ cross pieces
+ binding
```

Uses:

- logs;
- heavy debris;
- multiple resources.

## 22.4 Simple handcart — later possibility

Potentially too technologically/artistically expensive for early scope, but worth cataloging as a later project if wheel-like debris/resources exist.

## 22.5 Rope drag harness

Minimal geometry supporting drag interactions.

---

# 23. Repair material family

Repair should be composed from ordinary resources whenever possible.

Potential repair visuals:

- replacement plank;
- splint wood;
- rope wrap;
- fiber patch;
- thatch patch;
- metal strap found later;
- support brace;
- replacement handle;
- wedge reinforcement.

A repaired object's state can be represented by adding these pieces rather than swapping to a completely unrelated model.

Conceptually:

```text
base asset
+ damage state
+ repair attachment(s)
```

This approach is extremely compatible with procedural asset generation.

---

# 24. Sharpening, maintenance and tool-care objects

Tools become more believable if maintenance has physical representation.

Potential objects:

- sharpening stone;
- abrasive rock;
- cleaning cloth;
- oil-like found substance/container, if later justified;
- repair fiber;
- spare handle;
- binding material;
- maintenance block/work surface.

Potential actions:

- sharpen;
- rebind;
- replace handle;
- clean;
- dry;
- straighten compatible metal;
- inspect damage.

This creates room for Wilson to develop preferred tools and invest in maintaining them instead of treating tools as disposable stat objects.

---

# 25. Tool evolution without a conventional tech tree

Tool improvement should ideally emerge from better materials, better construction knowledge and discovered components.

Example:

```text
IMPACT
hand stone
→ hafted stone hammer
→ better balanced hammer
→ found metal head + custom handle

CUTTING
sharp flake
→ stone knife
→ improved hafted edge
→ metal scrap knife

CHOPPING
heavy sharp stone
→ primitive hatchet
→ improved axe
→ rehandled metal axe

DIGGING
stick
→ shaped digging stick
→ wood/shell spade
→ scrap-metal spade
```

This supports progression as expanded capability and reliability rather than arbitrary tier numbers.

The visual language can communicate improvement through:

- better alignment;
- cleaner proportions;
- more intentional handles;
- tighter/reduced bindings;
- more appropriate head geometry;
- use of rare found materials.

---

# 26. Improvised vs intentional construction

A useful visual distinction:

## Improvised

- mismatched material lengths;
- obvious overlap;
- extra bindings;
- asymmetric but stable silhouette;
- reused debris.

## Practiced

- more consistent component length;
- cleaner alignment;
- fewer unnecessary pieces;
- stable silhouette;
- repeated known joint patterns.

## Repaired / historically modified

- old base + new replacement pieces;
- mismatched material/palette;
- extra braces;
- patches;
- partial redesign.

This should not imply that every later object becomes visually sophisticated. Wilson remains an isolated castaway working with limited resources.

---

# 27. Found manufactured tools and components

The island/debris ecosystem can occasionally introduce manufactured objects that interact with the same capability system.

Potential found assets:

- hammer head;
- axe head;
- screwdriver-like tool;
- wrench/spanner;
- saw blade fragment;
- intact small hand saw;
- metal hook;
- nails / spikes;
- bolts;
- wire;
- chain fragment;
- clamp;
- hinge;
- pulley;
- rope block;
- canvas/tarp;
- metal bracket.

These should be rare enough that primitive construction remains visually dominant.

Interesting systemic outcomes include:

- Wilson uses a wrench as a hammer because it is heavy;
- an axe head becomes useful only after he invents a handle;
- a pulley makes a previously awkward hauling project practical;
- wire becomes a superior binding for heat-exposed areas but harder to manipulate.

---

# 28. Sawing family — optional / later

If cutting long wood into prepared construction pieces becomes important, sawing may deserve a family.

Possible progression:

```text
abrasive / chopping methods
→ found saw blade
→ improvised handled saw
→ maintained saw
```

Potential states:

```text
blade_only
handled
dull
bent
rusted
repaired
```

A saw is useful because it changes the efficiency/quality of producing planks and cut lengths, not because it unlocks a list of saw-only recipes.

---

# 29. Fastener family

Primitive construction should rely mostly on bindings and fitted geometry, but found fasteners can broaden options.

Potential families:

- wooden peg;
- wedge;
- nail/spike;
- bolt;
- metal strap;
- hinge;
- hook.

These are small visually, so they should only receive unique geometry where they create visible structural meaning.

A hinge, for example, is more valuable because it enables a visibly functional door/lid than because the hinge itself is visually detailed.

---

# 30. Doors, lids and movable structure parts

Construction assets with simple articulation can provide strong gameplay readability.

Potential families:

- shelter flap;
- plank door;
- crate lid;
- storage hatch;
- hinged panel;
- gate;
- shutter;
- simple trap door/hatch.

States:

```text
open
closed
blocked
broken
detached
repaired
```

Anchors/sockets:

```text
SOCKET_HINGE
ANCHOR_OPEN
ANCHOR_CLOSE
ANCHOR_INSPECT
```

Movable pieces should remain simple enough for reliable procedural assembly.

---

# 31. Construction failure states

Projects should fail in visually legible ways where simulation supports it.

Potential states:

- leaning post;
- loose joint;
- sagging roof;
- detached panel;
- collapsed section;
- broken leg/support;
- scattered staged materials;
- rain-soaked materials;
- fire-damaged component;
- storm-scattered thatch;
- overloaded shelf/platform.

Failure can generate new projects:

```text
inspect
→ stabilize
→ replace component
→ reinforce
→ learn / form preference
```

This supports persistent stories more effectively than simply reducing a hidden durability number.

---

# 32. Construction-site clutter

A working camp should not look like a perfectly staged asset pack.

Potential transient/support objects:

- offcut pile;
- wood shavings/chips represented as coarse clusters;
- discarded binding ends;
- broken component;
- spare stake;
- tool temporarily left on ground;
- partially used rope coil;
- unused panel leaning against structure;
- stone used as temporary weight;
- bucket/container holding small components.

These should be used sparingly to preserve the project's restrained-detail art direction.

They are valuable when they communicate an active project or personal habit.

---

# 33. Reusable workstation vocabulary

Rather than many bespoke crafting stations, consider a small set of context-bearing surfaces/setups.

## Tier A — no constructed station

```text
ground
flat rock
stump
```

Supports basic:

- cutting;
- crushing;
- inspection;
- sorting.

## Tier B — simple stable surface

```text
crude table
simple bench
```

Adds:

- better placement;
- repeated assembly;
- larger components.

## Tier C — organized workbench

```text
stable workbench
+ tool storage
+ material slots
```

Adds visual support for:

- multi-step tool construction;
- repair;
- shaping;
- repeated project work.

## Specialized attachments rather than whole new stations

Potential attachments:

- cutting block;
- clamp/wedge holder;
- sharpening stone slot;
- tool rack;
- small vise-like found clamp;
- measuring guide;
- hanging hooks.

This reduces asset proliferation.

---

# 34. Semantic anchor vocabulary for tools and workstations

Potential tool object anchors:

```text
ANCHOR_PICKUP
ANCHOR_INSPECT
ANCHOR_GRIP
```

Character attachment remains semantic:

```text
ANCHOR_HAND_R
ANCHOR_HAND_L
ANCHOR_CARRY
ANCHOR_BACK
```

Potential workstation anchors:

```text
ANCHOR_APPROACH
ANCHOR_WORK
ANCHOR_WORK_LEFT
ANCHOR_WORK_RIGHT
ANCHOR_PLACE
ANCHOR_INSPECT
ANCHOR_REPAIR
```

Potential project anchors:

```text
ANCHOR_BUILD_01...
ANCHOR_CARRY_DROP
ANCHOR_INSPECT
ANCHOR_REPAIR
```

Assembly sockets should remain distinct from actor interaction anchors.

---

# 35. Candidate generator primitives emerging from this round

This round suggests a particularly valuable procedural toolkit.

Potential helpers:

```text
create_handle
create_tool_head
create_binding
assemble_tool
create_post
create_beam
create_brace
create_plank_panel
create_thatch_panel
create_platform
create_work_surface
create_storage_rack
create_tool_rack
create_ladder
create_project_marker
create_material_stack
create_repair_patch
create_structural_joint
```

Higher-level families can compose these primitives.

For example:

```text
create_axe
  = create_handle
  + create_tool_head
  + create_binding

create_drying_rack
  = create_post xN
  + create_beam xN
  + create_binding xN

create_shelter_frame
  = create_post
  + create_beam
  + create_brace
  + create_binding
```

This is likely more valuable than building many unrelated mesh generators.

---

# 36. Candidate shared state grammar from Round 3

Several recurring states can be standardized conceptually across families:

```text
raw
prepared
assembled
installed

stable
loose
leaning
collapsed

sharp
dull
chipped
broken

intact
damaged
repaired
reinforced

clean
dirty
wet
dry
rusted
charred

empty
partial
complete

planned
marked
staged
in_progress
abandoned
```

These are brainstorming semantics, not a requirement that every object implement identical enums.

---

# 37. High-value first-pass asset families from this round

For the first serious procedural modeling pass, prioritize families with maximum reuse.

## P0 — foundational

1. short / medium / long handles;
2. stone working heads;
3. small/medium bindings;
4. axe/hatchet composition;
5. hammer/mallet composition;
6. digging stick;
7. long pole;
8. stakes/posts;
9. beams/poles/braces;
10. planks;
11. simple panels;
12. project markers;
13. material stacks;
14. crude work table;
15. workbench base;
16. tool rack;
17. ladder;
18. repair brace/patch pieces.

## P1 — strong combinatorial expansion

- knife family;
- adze;
- shovel/spade;
- hoe;
- pointed/hook pole;
- wedges;
- rollers;
- hauling sled/travois;
- scaffold/support frame;
- raised platform;
- doors/flaps;
- found metal tool heads;
- clamp/pulley attachments.

## P2 — later/niche

- saw family;
- handcart;
- more complex articulated joinery;
- large lifting systems;
- specialized fine-crafting tools.

---

# 38. Cross-round implications

Round 3 strongly reinforces several conclusions from Rounds 1 and 2.

## 38.1 Materials should survive transformation

Example:

```text
branch
→ handle
→ axe
→ broken handle
→ repair splint / firewood / scrap
```

Objects should avoid disappearing into abstract crafting whenever a visible transformation is practical.

## 38.2 Projects should visibly own committed materials

A shelter, table, storage platform or drying rack becomes more readable if some materials move through:

```text
collected
→ staged
→ installed
→ damaged/replaced
```

## 38.3 Repair history is content

A patched shelter, rebound axe or reinforced stool is not merely a durability state. It is persistent visual narrative.

## 38.4 Tool identity can become personal history

A particularly successful axe, absurd improvised hammer or repeatedly repaired knife can become individually meaningful to Wilson through existing preference/history systems.

## 38.5 Workstations should provide context, not arbitrary unlocks

The workbench should make certain physical tasks more practical or efficient; it should not act as a magical recipe menu.

---

# 39. Questions to resolve later

This brainstorming intentionally leaves several implementation/design questions open:

1. How much of tool wear should be represented by geometry versus material/state metadata?
2. Which physical properties justify distinct models rather than parameter changes?
3. How granular should project construction stages be for persistence and offline simulation?
4. How much component-level destruction/repair is worthwhile before asset complexity becomes excessive?
5. Should heavy-object hauling be systemic enough to justify rollers/sleds early?
6. Which found manufactured tools fit the intended fiction and rarity rhythm?
7. How many visibly staged resources can the web build support comfortably in a mature camp?
8. How should procedural generators preserve socket compatibility across intentionally imperfect variants?

These should be answered after the full functional catalog is assembled and prioritized.

---

# 40. Round 3 summary

The strongest production conclusion from this round is that tools and construction should be built from a compact reusable grammar:

```text
MATERIALS
stone / wood / fiber / shell / bone / found metal

TOOL PARTS
handle + working head + binding

STRUCTURAL PARTS
stake/post + pole/beam + brace + panel + platform + binding

WORK CONTEXT
natural surface → simple table → workbench + attachments

PROJECT STATE
planned → marked → staged → partial assembly → complete → damaged → repaired/modified
```

This grammar allows a relatively small set of low-poly generators to support a large number of visible tools, projects and persistent histories.

The artistic objective is not to model dozens of highly specific crafting props. It is to make the construction logic readable enough that agents can compose coherent objects from a small vocabulary while preserving style, anchors, sockets and state visibility.