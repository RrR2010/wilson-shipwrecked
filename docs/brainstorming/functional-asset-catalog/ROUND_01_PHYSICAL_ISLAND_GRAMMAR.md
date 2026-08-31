# Functional Asset Catalog Brainstorming — Round 1

## Scope

This round catalogs the physical grammar of the island: terrain, natural resources, primitive construction materials, basic structures, seating, containers, barriers and other foundational objects.

This is a brainstorming artifact, not a canonical implementation schema. The goal is to identify useful **asset families** and the states, evolution paths, composition rules, anchors and expected capabilities that later art briefs and Blender generators should support.

## Guiding principle

Prefer a small number of reusable functional families over a large number of bespoke object models.

A family should answer:

- What is it?
- What can happen to it?
- What can Wilson do with it?
- What can it become?
- What can attach to it?
- What other systems can use it?

---

# 1. Terrain and physical geography

| Family | Variations / states | Composition / anchors | Expected functions |
| --- | --- | --- | --- |
| `sand_ground` | dry, wet, compacted, disturbed | terrain region | walk, dig, place, footprints/path evidence |
| `soft_sand_patch` | normal, churned, waterlogged | region/volume | slows movement, footprints, digging |
| `rock_ground` | dry, wet, mossy | terrain surface | walk, place objects, slip potential |
| `soil_patch` | dry, damp, fertile, depleted, cultivated | plot anchors | dig, plant, grow |
| `mud_patch` | damp, deep, drying | region | slow/stumble, tracks, dirty state |
| `shallow_water` | calm, wave, tide variation | aquatic region | wade, wash, retrieve |
| `tide_pool` | low/high water, occupied, disturbed | aquatic spawn/interaction anchors | inspect, collect, crab habitat, memory landmark |
| `shoreline` | dry, incoming tide, debris accumulation | beach spawn region | wash-up events, resource collection |
| `rock_ledge` | dry, wet | optional sitting/standing anchors | sit, observe, landmark |
| `small_cliff` | intact, loose debris | edge anchors | navigation barrier, falling objects |
| `slope` | sand, rock, vegetated | physics surface | rolling objects, accidents |
| `shallow_hole` | open, filled, flooded | ground depression | trip hazard, trap, project input |
| `dig_site` | untouched → disturbed → excavated → filled | `ANCHOR_DIG` | projects, experiments, storage/traps |
| `path_ground` | faint → established → worn | spline/region | persistent movement history |

A `flat_rock` should not need a bespoke `wilson_chair` identity. If its geometry supports sitting, it can acquire social/personal meaning through history.

---

# 2. Stone family

| Family | Variations | States / evolution | Functions |
| --- | --- | --- | --- |
| `stone_small` | round, angular, flat | dry, wet, hot | pickup, throw, impact, weight |
| `stone_medium` | angular, slab | intact, chipped | impact, prop, construction |
| `rock_large` | several silhouettes | dry, wet, mossy | obstacle, landmark, sitting |
| `flat_rock` | low, wide | clean, occupied, wet | sit, work surface, place objects |
| `sharp_stone` | natural variants | dull, chipped | cut/scrape candidate |
| `heavy_stone` | compact/heavy | intact | hammering, crushing, weight |
| `stone_slab` | flat | intact, cracked | foundation, tabletop, cover |

Desired overlapping capabilities can include:

- portable;
- hard;
- impact-capable;
- heavy;
- flat;
- sharp-ish.

Avoid pair-specific identities such as `stone_for_coconut`.

---

# 3. Natural wood family

| Object | Evolution / state | Composition | Functions |
| --- | --- | --- | --- |
| `twig` | fresh, dry, wet, burned | unit | kindling, poke, small crafting |
| `branch_small` | fresh, dry, broken | optional grip | fuel, handle candidate |
| `branch_large` | fresh, dry | grip/carry | construction, fuel |
| `stick_straight` | natural, prepared | tool attach socket | handles, stakes |
| `log_short` | fresh, dry, wet, burned | carry + optional sit anchor | fuel, seat, construction |
| `log_long` | fresh, dry | dual carry | beams, bridges, construction |
| `split_wood` | dry, wet | stackable | firewood |
| `wood_chunk` | irregular | — | impact, fuel |
| `bark_piece` | fresh, dry | — | tinder, container/craft candidate |
| `driftwood` | dry, wet, weathered | variable | construction, decoration, fuel |

Useful conceptual progression:

```text
natural wood
  ↓ preparation
prepared wood
  ↓ assembly
construction component
```

---

# 4. Processed wood

```text
tree
 ↓ cut
log
 ↓ split
wood pieces
 ↓ shape
plank / pole / stake
 ↓ assembly
structure
```

| Family | Variations | Functions |
| --- | --- | --- |
| `wood_pole` | short, medium, long | structural frame |
| `wood_stake` | short, tall | anchor, fence, trap, marker |
| `plank_short` | narrow, wide | furniture/project component |
| `plank_long` | narrow, wide | floor, raft, workbench |
| `wood_beam` | several lengths | heavy structural member |
| `wood_panel` | crude joined planks | wall/floor/door |
| `wood_frame` | square/rectangular | modular project skeleton |

Potential reusable sockets:

```text
SOCKET_END_A
SOCKET_END_B
SOCKET_EDGE_L
SOCKET_EDGE_R
SOCKET_TOP
SOCKET_BOTTOM
```

---

# 5. Fibers, leaves and bindings

| Family | State / evolution | Functions |
| --- | --- | --- |
| `leaf_large` | fresh → wilted → dry | cover, wrap, fuel |
| `palm_frond` | fresh, dry, damaged | roofing, shade, bedding |
| `grass_bundle` | fresh, dry | thatch, tinder |
| `plant_fiber` | raw, prepared | crafting input |
| `vine` | fresh, dry | tie, drag, craft |
| `fiber_bundle` | raw, combed | intermediate material |
| `cord` | short, long | binding |
| `rope` | short, medium, long | structural binding, hauling |
| `rope_coil` | full, partial | storage/pickup visual |
| `thatch_bundle` | loose, prepared | roof construction |
| `thatch_panel` | intact, damaged, wet | modular roofing |

**Visual rule:** binding should be a visible construction language. Improvised objects should visibly communicate how Wilson assembled them.

---

# 6. Coconut palm family

Suggested modular composition:

```text
palm
├── trunk
├── crown
├── fronds
├── fruit cluster
└── state pieces
```

Suggested states:

```text
sapling
young
mature
fruiting
partially harvested
damaged
severely damaged
felled
stump
dead
```

Variation parameters:

- height;
- lean;
- trunk thickness;
- crown variant;
- frond count;
- fruit count;
- damage pattern.

Potential anchors/sockets:

```text
ANCHOR_APPROACH
ANCHOR_CHOP
ANCHOR_CLIMB
ANCHOR_INSPECT
ANCHOR_FRUIT_01...
SOCKET_FROND_01...
```

Potential capabilities:

- climbable;
- cuttable;
- harvestable;
- impact-reactive;
- provides shade;
- landmark;
- drops resources.

---

# 7. Coconut family

Suggested states:

| State | Visual intent |
| --- | --- |
| `coconut_green` | green husk |
| `coconut_mature` | brown/tan |
| `coconut_dehusked` | smaller brown shell |
| `coconut_cracked` | visible fracture |
| `coconut_half` | two halves |
| `coconut_empty_half` | empty shell |
| `coconut_spoiled` | degradation |
| `coconut_burned` | darkened shell |

Potential capabilities:

- portable;
- throwable;
- rollable;
- impactable;
- breakable;
- food source;
- liquid source;
- fuel candidate;
- craft material.

---

# 8. Shelter as an evolving project

Avoid treating shelter primarily as one finished model. Treat it as a project that accumulates visible components.

Suggested progression:

```text
none
 ↓
chosen_site
 ↓
foundation markers
 ↓
partial frame
 ↓
complete frame
 ↓
partial roof
 ↓
basic shelter
 ↓
reinforced shelter
 ↓
improved shelter
 ↓
patched / repaired / personalized shelter
```

Suggested components:

| Component | Function |
| --- | --- |
| foundation stake | layout |
| vertical pole | frame |
| ridge beam | roof structure |
| side beam | frame |
| rope binding | joint |
| thatch panel | roofing |
| wall panel | protection |
| floor mat/platform | comfort |
| entrance flap/door | protection |
| repair patch | visible history |

Potential sockets:

```text
SOCKET_FOUNDATION_*
SOCKET_POST_*
SOCKET_BEAM_*
SOCKET_ROOF_*
SOCKET_WALL_*
SOCKET_DOOR
SOCKET_EXTENSION_*
```

The visual goal is that shelters can differ because their histories differ, not only because a random mesh variant was selected.

---

# 9. Fire site / campfire family

Separate the concepts of site, structure, fuel, fire state and remains.

Suggested visible evolution:

```text
empty site
 ↓
prepared ground
 ↓
stone ring
 ↓
kindling
 ↓
unlit prepared fire
 ↓
small flame
 ↓
normal fire
 ↓
large fire
 ↓
embers
 ↓
ash
```

Additional states:

- wet;
- smoking;
- poorly arranged;
- wind affected;
- partially extinguished.

Potential anchors:

```text
ANCHOR_APPROACH
ANCHOR_LIGHT
ANCHOR_ADD_FUEL
ANCHOR_COOK
ANCHOR_WARM
ANCHOR_INSPECT
```

A specific fire-site instance should be able to retain object history and reputation.

---

# 10. Primitive seating

| Object | Origin | Functions |
| --- | --- | --- |
| `flat_rock` | natural | sit/place |
| `log_seat` | natural | sit |
| `stump` | tree state | sit/work surface |
| `crude_stool` | project | sit |
| `wood_bench` | later project | multiple seating |
| `ground_mat` | fiber project | sit/sleep |
| `improvised_chair` | later project | sit/preference |

Comparable alternatives are important because Wilson should be able to form persistent preferences between functionally similar locations or objects.

---

# 11. Basic surfaces

| Object | Function |
| --- | --- |
| `flat_rock_surface` | primitive work/eating place |
| `stump_surface` | chopping/work |
| `crate_top` | temporary surface |
| `simple_table` | food/work |
| `workbench` | crafting/project |
| `drying_rack` | food/material drying |
| `shelf` | display/storage |

Surfaces increase combinatorial value because small objects can acquire stable habitual locations.

---

# 12. Primitive containers

Useful conceptual capabilities:

```text
container
├── open / closed
├── capacity
├── contents
├── portable?
├── liquid-compatible?
└── inspectable?
```

| Family | Function |
| --- | --- |
| `coconut_shell_bowl` | food/liquid |
| `woven_basket` | light resources |
| `wood_box` | general storage |
| `crate` | general storage/found object |
| `bucket_improvised` | liquid/objects |
| `pouch` | small resources |
| `jar_found` | liquid/small items |
| `metal_container` | found storage/experiment object |

Containers may participate in exploration and physical experimentation rather than existing only as inventory abstractions.

---

# 13. Crate family

Suggested states / derived pieces:

```text
ship_crate_small
ship_crate_medium
damaged_crate
opened_crate
broken_crate
crate_planks
```

Potential roles:

- container;
- seat;
- table;
- obstacle;
- construction-material source;
- player-intervention target.

Broken crates should preferably transform into usable remnants rather than simply disappear.

---

# 14. Small generic physical objects

| Object | Main systemic value |
| --- | --- |
| pebble | throwable |
| shell | collectible / sharp-ish |
| stick | poke/fuel/tool |
| bone | found material/tool candidate |
| seed | planting |
| nut | food/throwable |
| leaf | lightweight/wind-reactive |
| feather | collectible/lightweight |
| small scrap metal | hard/sharp |
| cloth scrap | absorb/wrap |
| rope scrap | binding |
| wood scrap | fuel/impact |
| ceramic shard | sharp/breakable |

These generic objects support unexpected experiments without bespoke interaction assets.

---

# 15. Marker objects

Potential families:

```text
stone marker
stick marker
pile of stones
wooden sign
notched tree
rope marker
```

Potential uses:

- mark an important location;
- mark danger;
- remember a resource site;
- define a project area;
- create a "do not touch" signal;
- attempt communication with the player;
- reinforce spatial habits.

---

# 16. Simple barriers

| Object | Evolution |
| --- | --- |
| line of stones | loose → arranged |
| branch barrier | loose → tied |
| low fence | partial → complete |
| food barrier | improvised |
| crab blocker | improvised |
| wind screen | frame → covered |

Prefer compositional solutions such as surface height + barrier + container + placement over bespoke one-purpose objects.

---

# Round 1 synthesis

The future production pipeline should prioritize a reusable construction vocabulary:

```text
natural:
  rock
  branch
  log
  leaf
  fiber
  coconut

processed:
  pole
  stake
  plank
  beam
  rope
  thatch

assembled:
  binding
  frame
  panel
  surface
  container

projects:
  shelter
  fire site
  stool
  table
  storage
  barrier
```

The core target is:

> many perceived behaviors from relatively few artistic primitives.

## Provisional per-family brainstorming template

```yaml
family: shelter_basic

role:
  - shelter
  - project
  - persistent_landmark

composition:
  foundation:
    sockets: 4
  posts:
    interchangeable: true
  roof:
    modular: true

states:
  - site
  - frame_partial
  - frame_complete
  - roof_partial
  - complete
  - damaged
  - repaired

capabilities:
  - protects_from_rain
  - sleep_location
  - repairable
  - expandable

anchors:
  - APPROACH
  - BUILD
  - REPAIR
  - SLEEP
  - ENTER

visual_history:
  preserve_repairs: true
  preserve_added_parts: true
```

This is not yet a technical schema; it is a consistent structure for the brainstorming rounds.
