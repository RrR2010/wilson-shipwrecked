# Functional Asset Catalog Brainstorming — Round 2

## Scope

This round explores functional object families related to:

- food acquisition and edible resources;
- food preparation and transformation;
- water collection, transport and storage;
- cooking and heating;
- eating and drinking objects;
- food preservation and spoilage;
- storage infrastructure;
- washing / basic hygiene support where it overlaps with the same physical object vocabulary;
- recurring routine locations and visible domestic organization.

This is a brainstorming artifact, not a canonical implementation schema.

The goal is to identify reusable asset families and visible state transitions that can support both survival logic and persistent everyday behavior.

---

# 1. Food object philosophy

Food should not be treated only as an inventory quantity.

Whenever practical, food objects should preserve enough physical identity to support:

- discovery;
- carrying;
- dropping;
- stealing by animals;
- cooking;
- spoilage;
- preference;
- storage habits;
- player relocation/intervention;
- accidental loss;
- visual accumulation.

A useful conceptual distinction is:

```text
food source
  ↓ harvest / collect
raw food item
  ↓ preparation
prepared ingredient
  ↓ cooking / processing
meal / preserved food
  ↓ time / exposure
spoiled remains / waste
```

Not every food requires every stage.

---

# 2. Fruit families

## 2.1 Generic tropical fruit family

Potential examples:

- banana-like fruit;
- papaya-like fruit;
- mango-like fruit;
- guava-like fruit;
- berries / small tropical fruits;
- rare washed-up or introduced fruit.

Suggested states:

```text
unripe
ripe
overripe
bruised
cut/opened
partially eaten
spoiled
dried
cooked/roasted (where plausible)
```

Potential capabilities:

- harvestable;
- portable;
- edible;
- throwable;
- perishable;
- cuttable;
- cookable;
- animal-attracting;
- seed-producing.

Visual variation should prioritize silhouette and color-state readability rather than texture detail.

## 2.2 Fruit cluster / plant attachment

For fruit-bearing plants, separate:

```text
plant
fruit socket
fruit cluster
individual harvested fruit
```

Potential anchors:

```text
ANCHOR_HARVEST
ANCHOR_INSPECT
ANCHOR_FRUIT_01...
```

This allows visible partial harvesting rather than replacing an entire plant mesh.

---

# 3. Coconut food/liquid transformation chain

Round 1 introduced the coconut family. Round 2 expands its food/water role.

Potential transformation chain:

```text
whole coconut
 ↓ dehusk
hard coconut
 ↓ crack / pierce
opened coconut
 ├── coconut water
 └── coconut flesh
      ↓ process
      pieces / mash / dried flesh / cooked ingredient
```

Potential derived objects:

- `coconut_water_portion`;
- `coconut_flesh_piece`;
- `coconut_half_full`;
- `coconut_half_empty`;
- `coconut_shell_bowl`;
- `coconut_shell_cup`.

This family has unusually high reuse because the same physical object can transition from food source to container/crafting material.

---

# 4. Nuts, seeds and small edible resources

| Family | States | Functions |
| --- | --- | --- |
| `nut_small` | whole, cracked, eaten, spoiled | food, throwable, seed candidate |
| `seed_edible` | dry, wet, planted | food, planting |
| `seed_planting` | viable, damaged, germinating | planting/project |
| `berry_cluster` | unripe, ripe, spoiled | harvest, food |
| `edible_root` | raw, cleaned, cut, cooked | food, planting candidate |

These should use shared transformation patterns where possible rather than bespoke per-item logic.

---

# 5. Fishing / shoreline edible resources

Potential families:

| Family | States | Functions |
| --- | --- | --- |
| `small_fish` | alive, dead, cleaned, raw, cooked, spoiled | food, bait, animal target |
| `medium_fish` | alive, dead, cleaned, filleted, cooked | food/project resource |
| `shellfish` | alive, opened, cooked, empty shell | food, shell material |
| `crab_food` | alive, dead, cooked, shell remains | food, animal/relationship complication |
| `seaweed` | fresh, rinsed, dried, spoiled | food, wrapping, material candidate |

Important distinction:

- animals such as Gerald should remain identifiable world entities;
- generic edible crabs/shellfish need not share the same presentation/identity contract.

This avoids accidentally reducing recurring animals to generic food pickups.

---

# 6. Raw / prepared ingredient states

Common transformation vocabulary:

```text
whole
cleaned
peeled
cut
chopped
crushed
mashed
mixed
skewered
wrapped
```

Potential reusable visual families:

- `food_piece_chunk`;
- `food_slice`;
- `food_mash`;
- `mixed_food_bowl`;
- `wrapped_food_bundle`;
- `food_skewer`.

Rather than creating every possible recipe as unique geometry, combine a limited number of prepared-food presentation forms with role-based material/color variants.

---

# 7. Meals and prepared foods

Meals should support a compact presentation vocabulary.

Potential forms:

| Family | Typical use |
| --- | --- |
| `roasted_whole_food` | fruit, root, fish-like item |
| `roasted_piece` | chunks/slices |
| `food_skewer` | mixed small items |
| `soup_stew` | liquid meal in bowl/pot |
| `grilled_food` | flat cooked item |
| `wrapped_cooked_food` | leaf-wrapped cooking |
| `dried_food` | preserved strips/pieces |
| `simple_plate_meal` | combination presentation |

Suggested state modifiers:

```text
undercooked
cooked
well_cooked
burned
cold
spoiling
spoiled
```

Avoid requiring subtle texture changes to communicate these states. Use geometry/color/char level differences that survive gameplay distance.

---

# 8. Fire-cooking attachments

The Round 1 campfire should accept modular cooking attachments.

## 8.1 Pot support

Progression:

```text
no support
 ↓
tripod / crossbar
 ↓
hanging hook
 ↓
pot attached
```

Potential sockets:

```text
SOCKET_COOK_SUPPORT
SOCKET_HOOK
SOCKET_POT
```

## 8.2 Grill rack

States:

```text
frame_partial
complete
clean
greasy/used
warped/damaged
```

Functions:

- supports food;
- can be removed/moved;
- can burn or degrade if improvised.

## 8.3 Skewer support

Potential components:

- forked sticks;
- crossbar;
- skewer;
- rotating food item.

## 8.4 Hot-stone cooking surface

Potential states:

- cold;
- heating;
- hot;
- occupied;
- soot/grease marked.

This can reuse `flat_rock` while adding heat state and cooking affordance.

---

# 9. Cooking vessel family

Containers used for cooking should be distinct from generic storage only where capabilities require it.

| Family | Variations | States | Functions |
| --- | --- | --- | --- |
| `metal_pot_found` | small/medium | clean, soot-darkened, dented, damaged | boil, cook, carry liquid |
| `improvised_pot` | shell/metal salvage | intact, leaking | heat liquids/food |
| `pan_found` | shallow | clean, soot, damaged | frying/grilling-like cooking |
| `stone_bowl` | crude | intact, cracked | mixing, holding, maybe heating if valid |
| `coconut_shell_bowl` | half shell | fresh, dry, charred | eating, holding liquid |

Potential anchors:

```text
ANCHOR_PICKUP
ANCHOR_FILL
ANCHOR_POUR
ANCHOR_STIR
ANCHOR_EAT_FROM
SOCKET_FIRE_HANG
```

Important visible states:

- empty;
- partially filled;
- full;
- boiling;
- spilled/overturned.

Exact liquid rendering can remain abstracted, but occupancy should be readable.

---

# 10. Water sources

Water requires persistent geography plus portable objects.

Potential source families:

| Family | States | Functions |
| --- | --- | --- |
| `freshwater_pool` | full, low, muddy, contaminated-looking | drink, fill, wash |
| `spring` | active, reduced | drink/fill, landmark |
| `rain_puddle` | forming, full, evaporating | temporary source |
| `rain_catch_surface` | dry, collecting, overflowing | project/input |
| `leaf_cup_natural` | wet/dry | tiny temporary water collection |
| `coconut_water` | sealed/opened/consumed | drinkable resource |

If the island has no permanent freshwater source in early content, rain collection and coconuts become more important visually and systemically.

---

# 11. Water containers

Potential families:

| Family | States | Functions |
| --- | --- | --- |
| `coconut_shell_cup` | empty/full | drink, scoop |
| `bottle_found` | sealed/open/empty/full | carry liquid, message/event content |
| `jar_found` | empty/full | storage, liquid |
| `bucket_improvised` | empty/full/damaged | collect/transport |
| `waterskin_improvised` | empty/partial/full | portable water |
| `metal_can` | empty/full | collect/boil/store |
| `large_water_vessel` | empty/full | camp storage |

Suggested generic liquid state vocabulary:

```text
empty
low
half
full
overflowing
leaking
```

Potential content distinctions:

```text
fresh water
salt water
rain water
dirty water
unknown liquid
```

Visual presentation should distinguish important categories only when needed for gameplay readability.

---

# 12. Rainwater collection projects

## 12.1 Simple leaf collector

Progression:

```text
chosen site
 ↓
support stakes
 ↓
leaf/fabric catch surface
 ↓
drain channel
 ↓
container attached
```

States:

- dry;
- collecting;
- sagging;
- overflowing;
- damaged by wind;
- collapsed.

## 12.2 Roof runoff collector

A shelter upgrade can expose:

```text
SOCKET_GUTTER
SOCKET_DRAIN
SOCKET_CONTAINER
```

This creates useful cross-project composition: shelter geometry can later support water collection without replacing the shelter.

## 12.3 Ground catchment

Potential forms:

- lined pit;
- basin;
- rock depression;
- tarp/cloth depression.

---

# 13. Food storage hierarchy

Storage should evolve from incidental surfaces to dedicated infrastructure.

Suggested progression:

```text
ground pile
 ↓
raised surface
 ↓
container
 ↓
covered container
 ↓
raised storage
 ↓
protected food locker
```

This progression can naturally emerge from problems such as animals, rain, spoilage and routine organization.

---

# 14. Ground piles and stacks

Do not underestimate loose accumulation as a visual system.

Potential piles:

- fruit pile;
- coconut pile;
- firewood stack;
- fish/food temporary pile;
- stone pile;
- shell pile;
- mixed-resource pile.

States:

```text
1 item
small pile
medium pile
large pile
scattered / disturbed
```

A small number of representative visible items may communicate a larger logical quantity if necessary for performance.

Animal interaction and player rearrangement make physical piles valuable for storytelling.

---

# 15. Basket family

Potential construction:

```text
fiber bundle
 ↓
base ring
 ↓
partial weave
 ↓
complete basket
 ↓
handle/lid upgrade
```

Variants:

- shallow basket;
- deep basket;
- handled basket;
- lidded basket.

States:

- empty;
- partially filled;
- full;
- damaged;
- repaired.

Functions:

- portable storage;
- food transport;
- resource organization;
- habitual location object.

---

# 16. Food crate / locker family

Potential progression:

```text
crate reused as storage
 ↓
crate with lid
 ↓
raised crate
 ↓
secured food box
 ↓
ventilated / protected locker
```

Potential features:

- lid;
- latch;
- weight/stone on top;
- elevated legs;
- rope securing;
- animal barrier;
- shade cover.

Potential anchors:

```text
ANCHOR_OPEN
ANCHOR_INSPECT
ANCHOR_PUT
ANCHOR_TAKE
ANCHOR_SECURE
```

This should support the morning-routine scene where Wilson checks storage automatically.

---

# 17. Raised storage and animal protection

Potential structures:

| Family | Function |
| --- | --- |
| `raised_food_platform` | keep food off ground |
| `hanging_food_bag` | reduce animal access |
| `suspended_basket` | food/resource storage |
| `food_cage` | animal barrier |
| `covered_food_rack` | shade + drying/storage |

These can evolve from Wilson learning that Gerald or other animals steal food.

Potential composition:

```text
post(s)
+ crossbar
+ rope
+ container/platform
+ optional cover
```

This is preferable to one bespoke anti-crab object.

---

# 18. Drying and preservation infrastructure

## 18.1 Drying rack

Progression:

```text
posts
 ↓
crossbar/frame
 ↓
rack complete
 ↓
food attached
 ↓
covered rack upgrade
```

States:

- empty;
- loaded;
- wet/rained on;
- partially dried;
- damaged;
- collapsed.

Potential anchors:

```text
ANCHOR_HANG
ANCHOR_REMOVE
ANCHOR_INSPECT
```

## 18.2 Smoking rack

Can compose with fire site:

```text
fire
+ elevated rack
+ optional cover
```

States:

- cold;
- smoking;
- loaded;
- overheated/burning.

## 18.3 Salt / brine preservation

Only if salt availability becomes part of content. Potential objects:

- shallow evaporation tray;
- salt pile;
- brining container.

This should remain optional until product scope proves it useful.

---

# 19. Spoilage visual grammar

Spoilage should be readable but not visually disgusting enough to break the cozy ambient target.

Suggested generic stages:

```text
fresh
aging
stale / overripe
spoiled
inedible remains
```

Possible large-scale visual signals:

- color desaturation/darkening;
- slumping silhouette;
- one or two blemish geometry/material patches;
- flies/insects as optional world effect;
- reduced fullness;
- dried/shriveled form.

Avoid high-frequency mold textures or realistic decay.

Environmental factors that may influence visual state:

- exposed vs covered;
- wet vs dry;
- cooked vs raw;
- shade vs sun;
- container state.

---

# 20. Food remnants and waste

Food consumption should sometimes leave objects behind.

Potential remains:

| Source | Remnant |
| --- | --- |
| coconut | shell halves |
| fish | bones/skeleton |
| shellfish | empty shell |
| fruit | peel/core/seed |
| cooked meal | dirty bowl/skewer |
| fire cooking | ash/charred scraps |

Possible functions for remnants:

- trash;
- crafting input;
- animal attraction;
- evidence of habits;
- compost/fertilizer candidate later;
- collectible/decorative object.

This makes eating part of the persistent scenery rather than an invisible stat update.

---

# 21. Eating utensil family

The representative-scene catalog explicitly gives value to a habitual handmade spoon.

Potential utensils:

| Family | Variations | States |
| --- | --- | --- |
| `spoon_wood` | crude/refined | clean, dirty, damaged, lost/recovered |
| `fork_wood` | crude | clean, broken |
| `chopstick_pair` / sticks | improvised | clean, broken |
| `knife_food` | stone/metal | sharp, dull, dirty |
| `skewer` | wood | clean, used, burned |
| `ladle` | coconut shell/wood | clean, dirty |

Important roles:

- reusable routine prop;
- stable habitual location;
- object preference;
- player-intervention target;
- wear/history carrier.

These objects may have disproportionately high narrative value despite tiny geometry.

---

# 22. Eating surfaces and table-setting grammar

Potential elements:

- bowl;
- plate/slab;
- cup;
- spoon;
- food portion;
- napkin/leaf wrap;
- serving pot.

This enables visually recognizable routines such as:

```text
prepare
→ place meal
→ sit
→ eat
→ leave dirty items
→ clean / reorganize later
```

A habitual breakfast location can become visually identifiable without UI.

---

# 23. Drinking behavior props

Potential forms:

- drink directly from coconut;
- cup;
- bottle;
- shell cup;
- ladle/scoop;
- drink directly from source.

Useful anchors:

```text
ANCHOR_PICKUP
ANCHOR_DRINK
ANCHOR_FILL
ANCHOR_POUR
```

Readable fill-state and container identity are more important than detailed fluid simulation.

---

# 24. Washing and cleaning objects

Keep this lightweight and compositional.

Potential objects:

| Object | Function |
| --- | --- |
| `water_basin` | wash hands/items |
| `cloth_rag` | wipe/dry/filter candidate |
| `scrub_brush_improvised` | clean containers/surfaces |
| `sand_scrub` | cleaning method, may not need unique asset |
| `drying_line` | cloth drying |
| `washing_bucket` | wash/carry |

Potential states:

- clean;
- dirty;
- wet;
- drying;
- worn.

Cleaning can also restore habitual organization and visually distinguish a maintained camp from a neglected one.

---

# 25. Cloth and napkin-like objects

Found cloth scraps can serve multiple domestic roles:

- wiping;
- wrapping food;
- filtering;
- drying;
- shade cover;
- clothing repair;
- bandage candidate;
- marker/flag.

States:

```text
clean
dirty
wet
dry
torn
patched
```

This should remain one reusable cloth family with bounded shape variants rather than many purpose-specific meshes.

---

# 26. Food preparation workstation

Rather than one magical crafting table, food preparation may emerge from surfaces plus tools.

Possible arrangements:

```text
flat rock + cutting tool
stump + bowl
simple table + knife + container
workbench + preparation props
```

Potential dedicated `food_prep_table` only if habitual/readability value warrants it.

Possible anchors on any compatible work surface:

```text
ANCHOR_WORK
SOCKET_ITEM_01
SOCKET_ITEM_02
SOCKET_CONTAINER
```

---

# 27. Cutting / chopping support objects

Potential objects:

| Family | Role |
| --- | --- |
| `chopping_stump` | robust cutting surface |
| `flat_cutting_stone` | primitive cutting surface |
| `wood_cutting_board` | later refinement |

States:

- clean;
- used/stained;
- scarred;
- cracked;
- wet.

Persistent wear can communicate long-term routine without extra UI.

---

# 28. Food tools

Potential tools, focusing on reusable physical capability:

| Tool | Capabilities |
| --- | --- |
| `stone_knife` | cut, scrape |
| `metal_knife_found` | cut, pierce |
| `wooden_mallet` | crush, tenderize, impact |
| `heavy_stone` | crush, crack |
| `grinding_stone` | grind/crush |
| `pestle` | crush/mash |
| `mortar_bowl` | contain while grinding |
| `skewer` | pierce, cook |
| `tongs_improvised` | handle hot items |

Do not define these solely around food. Capabilities should remain reusable in other domains.

---

# 29. Grinding / crushing station

Possible family:

```text
flat grinding stone
+ hand stone / pestle
```

Potential uses:

- mash food;
- crack shells;
- process plant fibers;
- grind pigments/minerals later.

This is a good example of one object family crossing multiple future rounds.

---

# 30. Cooking project evolution

The cooking area itself can become an evolving domestic project.

Possible progression:

```text
bare fire
 ↓
stone-ring fire
 ↓
pot support
 ↓
work surface nearby
 ↓
food storage nearby
 ↓
drying/smoking attachment
 ↓
covered cooking area
 ↓
organized outdoor kitchen
```

This should happen compositionally rather than through swapping `kitchen_level_1.glb` for `kitchen_level_2.glb`.

Potential environmental anchors:

```text
SOCKET_COOKING_SURFACE
SOCKET_STORAGE
SOCKET_DRYING
SOCKET_COVER
SOCKET_WATER
```

The accumulated area becomes a visible record of Wilson's domestic progression.

---

# 31. Covered cooking area

Potential components:

- posts;
- small roof/thatch;
- wind screen;
- work surface;
- hanging hooks;
- shelf.

States:

- partial frame;
- roof partial;
- complete;
- storm damaged;
- repaired;
- expanded.

This could emerge because rain repeatedly interrupts fire/cooking activities.

---

# 32. Shelf / domestic storage family

Potential forms:

- one-plank shelf;
- two-tier shelf;
- wall-mounted shelter shelf;
- freestanding rack.

States:

- empty;
- sparsely occupied;
- full;
- disorganized;
- damaged;
- repaired.

Potential sockets:

```text
SOCKET_ITEM_01...
```

Shelves are especially valuable for ambient readability because they expose stored objects instead of hiding everything inside inventory containers.

---

# 33. Hanging hooks and rails

Small modular infrastructure:

- single hook;
- peg;
- horizontal rail;
- rope loop;
- hanging line.

Functions:

- hang tools;
- hang utensils;
- hang food;
- dry cloth;
- organize containers.

Potential sockets:

```text
SOCKET_HANG_01...
```

This creates visual evidence that Wilson has developed routines and assigned places to belongings.

---

# 34. Bottle family

Bottles deserve dedicated treatment because they can bridge survival and narrative events.

States:

```text
sealed
open
empty
full
broken
corked
message_inside
unknown_contents
```

Potential functions:

- liquid container;
- message/event carrier;
- found object;
- improvised tool;
- breakable sharp-material source;
- decorative/collectible object.

Potential derived pieces:

- cork;
- glass shard;
- message paper.

This supports diegetic hints without introducing recipe UI.

---

# 35. Pot / kettle history

A reusable cooking vessel should visibly accumulate history:

```text
new/found
→ soot-darkened
→ dented
→ repaired / patched
→ heavily worn
```

A familiar vessel can become preferred even when a technically better one appears later.

The same principle can apply to spoon, cup, bowl and food storage.

---

# 36. Serving and portion objects

Potential logical-to-visual mapping:

```text
large source container
 ↓ serve
individual portion
```

Visual portion families:

- bowl portion;
- plate portion;
- leaf-wrapped portion;
- hand-held piece;
- skewer.

This can support eating animations without requiring Wilson to consume directly from a large pot every time.

---

# 37. Hot / cold object state communication

Some food/cooking items benefit from readable temperature state.

Possible visual signals:

- simple steam particles;
- subtle emissive/fire-adjacent glow only for very hot objects;
- soot/char state;
- cold state generally has no special effect unless frozen content exists later.

Do not require temperature shaders for every item. Use only where the state affects immediate interaction readability.

---

# 38. Spills and dropped food

Potential transient/persistent objects:

- spilled water patch;
- spilled soup/food patch;
- scattered fruit;
- dropped meal;
- overturned container.

These can support:

- accidents;
- animal attraction;
- cleanup;
- player sabotage;
- visible consequences.

Liquid spills can use simple decals/meshes or surface states rather than simulation-heavy fluid systems.

---

# 39. Animal-food interaction support

Food assets should expose enough physical semantics to support animal interactions.

Possible attributes/capabilities:

- scent/attraction category;
- reachable height;
- container protection;
- exposed/covered;
- portable by small animal;
- portable by larger animal;
- spillable.

Visual infrastructure for animal protection:

```text
raise it
cover it
hang it
enclose it
block the path
```

These reusable physical strategies are preferable to hard-coded animal-specific containers.

---

# 40. Habit and organization affordances

Food/water objects are major carriers of domestic habit.

Useful support concepts:

- preferred storage location;
- preferred eating location;
- assigned utensil location;
- morning check route;
- favorite cup/bowl;
- backup water source;
- trusted vs disliked fire site;
- cleanliness/organization habit.

These do not necessarily require new meshes. They require enough object persistence and visual stability that behavioral history can become recognizable.

---

# 41. Candidate visible project chains

## 41.1 Water collection

```text
found container
→ simple rain catch
→ larger vessel
→ shelter runoff collector
→ organized water station
```

## 41.2 Food storage

```text
ground pile
→ crate/basket
→ raised storage
→ covered/secured storage
→ organized pantry/rack
```

## 41.3 Cooking

```text
bare fire
→ stone ring
→ pot/skewer support
→ preparation surface
→ covered cooking area
→ expanded outdoor kitchen
```

## 41.4 Preservation

```text
exposed food
→ raised/dry surface
→ drying rack
→ covered drying rack
→ smoking rack / improved preservation
```

These chains are especially useful for later reference sheets because they establish which intermediate visual states must be designed.

---

# 42. High-value functional families from Round 2

The strongest candidates for early production are:

```text
Food resources
  coconut states
  generic fruit
  fish / shellfish
  edible root

Preparation
  cutting surface
  grinding stone
  simple knife
  bowl
  skewer

Cooking
  campfire attachments
  pot
  grill/rack

Water
  bottle
  cup
  bucket/container
  rain collector components

Storage
  basket
  crate/locker
  shelf
  raised platform
  hanging storage

Preservation
  drying rack
  smoking rack

Routine props
  spoon
  bowl
  cup
  habitual eating surface
```

---

# 43. Cross-round reusable primitives identified

This round reinforces a compact set of construction primitives from Round 1:

```text
pole
stake
plank
rope
hook
frame
surface
container
cover
rack
```

It also introduces high-value reusable state concepts:

```text
empty / partial / full
open / closed
clean / dirty
wet / dry
fresh / aging / spoiled
raw / prepared / cooked / burned
intact / damaged / repaired
exposed / covered
low / raised / hanging
```

These state grammars should eventually inform shared asset-generation helpers and material variants.

---

# Round 2 synthesis

The key art-production insight is that food and water do not require hundreds of bespoke models if the project establishes a compact physical vocabulary of:

- source objects;
- portable items;
- generic preparation forms;
- containers;
- surfaces;
- cooking attachments;
- storage compositions;
- visible transformation states.

The domestic camp should progressively look **used, organized and personally inhabited**, not merely more technologically advanced.

A successful asset system should allow the player to recognize things such as:

- where Wilson usually eats;
- where he keeps his spoon;
- which container holds water;
- where breakfast is stored;
- whether food is being dried;
- whether a familiar pot has been heavily used;
- whether animal pressure has changed how Wilson stores food;
- whether rain has caused Wilson to upgrade the cooking/water area.

This is a major part of turning persistent simulation history into scenery.
