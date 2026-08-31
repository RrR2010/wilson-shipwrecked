# Functional Asset Catalog Brainstorming — Round 4

## Scope

This round explores functional object families related to:

- flora and plant growth;
- renewable natural resources;
- fauna and recurring animal identities;
- habitats, nests, burrows and ecological landmarks;
- resource depletion and regeneration;
- animal interactions with food, structures and Wilson;
- environmental traces produced by living entities;
- player-visible ecological history.

This is a brainstorming artifact, not a canonical implementation schema.

The goal is to identify reusable asset families and visible state transitions that support a living island whose ecology can become part of Wilson's routines, fears, preferences and projects.

---

# 1. Ecological object philosophy

Plants and animals should not exist only as decorative background.

Whenever practical, living-world assets should support at least one of these roles:

```text
resource source
habitat
navigation landmark
behavioral obstacle
relationship target
project dependency
weather indicator
food-chain participant
persistent-history carrier
```

A useful distinction is:

```text
decorative life
  visual ambience only

functional population
  renewable/depletable resource or hazard

persistent individual
  identity/history/relationship matters
```

Not every plant or animal needs full simulation identity.

---

# 2. Plant lifecycle grammar

Common plant-state vocabulary:

```text
seed
sprout
juvenile
mature
flowering
fruiting
harvested
recovering
damaged
severely damaged
dead
stump / remains
```

Not every species needs all states.

Potential environmental modifiers:

```text
dry
wet
storm-damaged
salt-exposed
trampled
burned
shaded
fertile
stressed
```

The visual system should prioritize clear silhouette/state changes rather than fine botanical accuracy.

---

# 3. Palm / coconut palm family

Round 1 introduced palms as a major family. This round expands ecological behavior.

## Variants

- short broad palm;
- tall leaning palm;
- young palm;
- storm-bent palm;
- sparse-crown palm;
- fruit-heavy palm;
- landmark palm with unusual silhouette.

## States

```text
young
mature
fruiting
partially harvested
fully harvested
recovering
damaged
frond loss
trunk damaged
felled
stump
dead standing
```

## Components

```text
trunk
crown
frond sockets
fruit sockets
fallen-frond objects
fallen-coconut objects
```

## Capabilities

- harvest fruit;
- climb where allowed;
- chop/cut;
- provide shade;
- drop branches/fronds during storms;
- act as landmark;
- provide wood/fiber resources;
- obstruct routes;
- support attached objects or improvised constructions when compatible.

Potential anchors:

```text
ANCHOR_APPROACH
ANCHOR_CHOP
ANCHOR_CLIMB
ANCHOR_HARVEST
ANCHOR_INSPECT
ANCHOR_SHADE
ANCHOR_FRUIT_01...
SOCKET_FROND_01...
```

---

# 4. Bush and shrub family

Potential ecological roles:

- berries/fruit;
- fiber;
- concealment;
- minor obstacle;
- animal habitat;
- thorn hazard;
- visual boundary.

Suggested variants:

- low round shrub;
- tall loose shrub;
- berry shrub;
- thorny shrub;
- flowering shrub;
- dry scrub.

States:

```text
juvenile
mature
flowering
fruiting
harvested
recovering
trampled
cut back
dead
```

Useful properties:

```text
harvestable
cuttable
flammable
concealing
thorny?
animal_attracting
regrows
```

---

# 5. Ground-cover / grass families

Potential families:

- tropical grass clump;
- coarse beach grass;
- broad-leaf ground plant;
- small fern cluster;
- flowering ground cover;
- dry grass patch.

Common states:

```text
healthy
trampled
cut
wet
dry
burned
regrowing
```

Gameplay functions:

- fiber/tinder resource;
- visual path development;
- weather response;
- hiding small objects/animals;
- fire propagation candidate;
- minor movement modifier where dense.

A key visual opportunity is path formation:

```text
healthy vegetation
→ repeatedly traversed
→ bent/trampled
→ sparse
→ persistent path
```

---

# 6. Useful leaf plants

Potential resource roles:

- broad wrapping leaves;
- bedding leaves;
- medicinal-looking plant candidates;
- aromatic herbs;
- edible greens;
- dye/pigment candidates.

Suggested families:

| Family | Useful outputs |
| --- | --- |
| `broad_leaf_plant` | wrapping, roofing patches, food prep |
| `fiber_plant` | fiber, cord input |
| `herb_plant` | edible/experimental/medicine candidate |
| `reed_patch` | weaving, shafts, lightweight construction |

States should support partial harvesting rather than binary disappearance where practical.

---

# 7. Fruit trees beyond palms

Potential families:

- small tropical fruit tree;
- medium broad-canopy fruit tree;
- rare introduced/wash-up tree if the setting later supports it.

Components:

```text
trunk
branch clusters
leaf clusters
fruit sockets
fallen fruit
```

States:

```text
juvenile
mature
flowering
unripe fruit
ripe fruit
partially harvested
recovering
damaged
pruned
storm-damaged
dead
```

Potential functions:

- food source;
- shade;
- climbing candidate;
- animal attraction;
- landmark;
- wood source;
- project location.

---

# 8. Vines and climbing plants

Potential variants:

- ground vine;
- tree-climbing vine;
- hanging vine;
- flowering vine;
- fibrous vine.

Functions:

- rope/binding source;
- visual entanglement;
- climb/descend aid where appropriate;
- route obstacle;
- structure overgrowth;
- habitat connector.

States:

```text
fresh
cut
harvested
regrowing
dry/dead
overgrown
```

A persistent camp can visibly become overgrown if neglected.

---

# 9. Fungi and transient growth

Potential role should be modest but useful for weather/time readability.

Families:

- small mushroom cluster;
- shelf fungus on wood;
- mold-like food/storage growth represented through state pieces/materials.

Possible functions:

- experimental edible/non-edible resource;
- decomposition cue;
- dampness indicator;
- rare collectible.

Avoid requiring microscopic ecological simulation.

---

# 10. Fallen natural materials

Renewability should often produce physical world objects rather than abstract counters.

Potential drops:

- fallen frond;
- dry branch;
- twig bundle;
- fallen fruit;
- seed;
- nut;
- bark strip;
- drift vegetation;
- washed seaweed.

Useful lifecycle:

```text
attached
→ fallen fresh
→ dry/weathered
→ decayed / consumed / collected
```

This provides resources without requiring Wilson to destroy every plant.

---

# 11. Regeneration philosophy

Renewable resources should usually regenerate through visible ecological logic.

Examples:

```text
fruit harvested
→ empty fruit sockets
→ recovery period
→ new unripe fruit
→ ripe fruit
```

```text
grass cut
→ short stubble
→ regrowth
→ mature clump
```

```text
branch harvested
→ visible missing branch
→ optional later regrowth
```

Avoid instant replacement where the player can observe the location frequently.

---

# 12. Depletion and overuse states

Potential ecological consequences:

```text
healthy resource site
→ frequently harvested
→ sparse
→ depleted
→ recovering
```

This can apply to:

- berry bushes;
- shellfish areas;
- driftwood accumulation sites;
- fishing spots;
- fiber plants;
- edible roots;
- fruit trees.

The goal is not punitive survival micromanagement, but visible consequence and spatial history.

---

# 13. Animal presentation tiers

A critical distinction:

## Tier A — ambient animals

Examples:

- tiny fish silhouettes;
- distant birds;
- insects;
- small shore movement.

Role:

- ambience;
- weather/time cues;
- occasional simple reactions.

No persistent identity required.

## Tier B — functional generic animals

Examples:

- generic crab;
- generic bird;
- fish school;
- small reptile;
- shellfish population.

Role:

- resource competition;
- food source where appropriate;
- hazard/nuisance;
- ecosystem behavior.

Individual persistence optional.

## Tier C — persistent individuals

Examples:

- Gerald-like crab;
- unusual recurring seabird;
- animal Wilson repeatedly feeds or fears.

Role:

- relationship target;
- running gag;
- memory/history carrier.

These should have stable visual identity and entity persistence.

---

# 14. Crab family

The representative scenes make crab behavior especially important.

## Generic crab variants

- small pale crab;
- medium red/orange crab;
- dark rock crab;
- larger aggressive-looking crab.

## States

```text
idle
foraging
carrying item
threatened
hiding
injured?
dead (if supported)
```

## Functional capabilities

- steal/carry small food;
- react to Wilson;
- occupy tide pools;
- hide in burrows/under rocks;
- block or cross paths;
- be chased;
- attract Wilson's attention.

Potential anchors on habitats rather than the animal itself:

```text
ANCHOR_BURROW_ENTRY
ANCHOR_FORAGE
ANCHOR_HIDE
```

---

# 15. Persistent crab identity / Gerald pattern

Persistent individuals should differ through low-cost visual identity cues:

```text
size
shell color variant
one asymmetrical claw
small shell chip
movement tendency
favorite habitat
```

Avoid expensive unique high-detail models.

Potential relationship-visible states are mainly behavioral rather than cosmetic, but visual traces may include:

- favorite burrow;
- stolen object nearby;
- feeding location;
- Wilson-built barrier around food;
- recurring path.

---

# 16. Crab burrows and tide-pool habitat

Potential habitat families:

| Habitat | States | Functions |
| --- | --- | --- |
| `crab_burrow` | open, occupied, disturbed, collapsed | spawn/hide landmark |
| `tide_pool` | low/high water, occupied, empty | crab/shellfish habitat |
| `rock_crevice` | empty, occupied | hide point |
| `shore_debris_hide` | intact/disturbed | temporary animal refuge |

The habitat can carry history even when the animal is absent.

---

# 17. Bird family

Potential roles:

- ambient life;
- food thief;
- scavenger;
- warning/weather cue;
- collectible feather source;
- recurring tolerated neighbor.

Variants:

- small shore bird;
- medium seabird;
- bright tropical bird;
- scavenger-like bird.

States/actions:

```text
perched
walking
foraging
flying
carrying item
feeding
startled
nesting
```

Key attachment/interaction points:

- perch sockets on rocks/trees/structures;
- nest sockets;
- food pickup compatibility.

---

# 18. Bird perch system

Rather than authoring bespoke bird locations, expose semantic perch points on compatible assets:

```text
SOCKET_PERCH_01
SOCKET_PERCH_02
```

Potential hosts:

- palm branches;
- large rocks;
- shelter roof ridge;
- fence posts;
- driftwood;
- boat mast/remains.

This creates cheap scene variation.

---

# 19. Bird nests

Potential states:

```text
site selected
partial nest
complete nest
empty
with eggs
with chicks
abandoned
damaged
```

Potential functions:

- habitat;
- resource temptation;
- Wilson curiosity;
- ethical/refusal scenarios;
- weather damage;
- persistent landmark.

Nest construction can visibly progress over time without requiring narrative text.

---

# 20. Fish populations

Represent fish at two levels:

## Ambient fish school

- low-cost group representation;
- visible in shallow water;
- reacts to disturbance.

## Catchable fish entity

- small/medium fish family;
- alive/dead/cleaned states from Round 2;
- can be caught, dropped, stolen.

Potential habitat regions:

```text
shallow_school_zone
reef_edge_zone
rock_pool_zone
```

Fishing spots may become temporarily depleted and later recover.

---

# 21. Shellfish / shoreline populations

Potential families:

- clam-like shellfish;
- mussel-like cluster;
- small edible snails;
- non-edible decorative shells.

States:

```text
submerged
exposed at low tide
collected
depleted
recovering
```

This makes tide cycles materially visible if later implemented.

---

# 22. Small reptile / lizard family

Potential role:

- ambient movement;
- insect hunter;
- food thief only rarely;
- Wilson curiosity;
- recurring harmless animal.

States/actions:

```text
basking
foraging
hiding
startled
climbing
```

Habitats:

- warm rocks;
- log piles;
- shelter edges;
- vegetation cover.

These animals can be functional without needing survival-critical mechanics.

---

# 23. Insect groups

Keep insects largely aggregate/ambient.

Potential families:

- flies around spoiled food;
- butterflies around flowers;
- mosquitoes near stagnant water;
- ants around food scraps;
- fireflies at night if style supports it.

Functions:

- spoilage cues;
- cleanliness cues;
- weather/time ambience;
- minor nuisance;
- animal-food interactions.

Use particle/group abstractions rather than individual modeled simulation unless a specific scene requires otherwise.

---

# 24. Scavenger behavior and food competition

Shared capability model:

```text
food object
+ exposed
+ reachable
+ attractive
→ animal may investigate / steal / consume
```

Potential animal competitors:

- crab;
- bird;
- ants/insects;
- small reptile;
- other future fauna.

This should drive physical solutions:

```text
raise food
cover food
hang food
barrier
sealed container
```

rather than animal-specific storage recipes.

---

# 25. Animal path traces

Persistent or temporary traces may include:

- footprints in wet sand;
- dragged food marks;
- shell fragments;
- feathers;
- burrow openings;
- disturbed storage;
- gnawed food;
- nest material trails.

These traces can make off-screen activity legible when the player returns.

---

# 26. Wildlife interaction with structures

Animals should be able to exploit generic structural affordances.

Examples:

```text
bird + perch socket → perch
crab + low opening → enter
small animal + exposed food shelf → investigate
bird + loose thatch → steal nesting material
crab + dropped utensil → push/move candidate
```

Avoid bespoke one-off animation/logic where generic anchors suffice.

---

# 27. Habitat attachment grammar

Potential semantic sockets:

```text
SOCKET_PERCH_*
SOCKET_NEST_*
SOCKET_HIDE_*
SOCKET_BURROW_*
SOCKET_CLIMB_ANIMAL_*
```

Potential habitat regions:

```text
REGION_FORAGE
REGION_BASK
REGION_NEST
REGION_SHALLOW_WATER
REGION_TIDE_POOL
REGION_COVER
```

These are conceptual brainstorming terms, not finalized runtime schema.

---

# 28. Renewable drift resources

The shoreline itself can function as a renewable resource system.

Potential arrivals:

- driftwood;
- seaweed;
- coconuts;
- shells;
- rope scraps;
- cloth scraps;
- ship debris;
- rare manufactured objects.

State chain:

```text
offshore opportunity
→ washed ashore
→ wet
→ drying/weathering
→ collected / buried / washed away
```

This bridges ecology with the rare-object/debris round later.

---

# 29. Storm ecological aftermath

Storms should leave reusable visible aftermath pieces rather than only changing parameters.

Potential results:

- fallen fronds;
- broken branches;
- fallen fruit;
- uprooted small plant;
- damaged nest;
- flooded burrow;
- shifted driftwood;
- washed seaweed line;
- damaged tree crown;
- newly exposed shellfish/debris.

This creates natural post-weather scenes and resource opportunities.

---

# 30. Fire ecological aftermath

If fire propagation is supported, vegetation can transition through:

```text
healthy
→ singed
→ burned
→ dead remains
→ cleared patch
→ regrowth
```

Potential derived assets:

- charred branch;
- blackened stump;
- ash patch;
- sparse regrowth.

Do not overbuild wildfire simulation unless proven necessary.

---

# 31. Shade as ecological/spatial property

Trees and structures can create semantic shade regions.

Possible uses:

- Wilson chooses a cooler resting place;
- food dries differently;
- animals bask outside shade;
- certain plants prefer/avoid exposure;
- rain shelter overlaps partially.

No dedicated visible object is required, but asset footprint/canopy shape matters.

---

# 32. Water-dependent habitat objects

Potential families:

- tide pool;
- shallow lagoon edge;
- puddle after rain;
- stagnant small pool;
- wet rock shelf.

Potential functions:

- animal spawn/habitat;
- drinking candidate depending on water quality;
- washing;
- insect cue;
- slip hazard;
- resource site.

States:

```text
full
partial
drying
dry
muddy
clear
occupied
```

---

# 33. Planting and cultivation candidates

Even if Wilson never develops farming-heavy gameplay, simple cultivation can create strong persistent scenery.

Potential progression:

```text
wild edible plant discovered
→ seed collected
→ planting site chosen
→ planted
→ sprout
→ mature
→ harvest
→ replanted / expanded patch
```

Potential assets:

- planted mound;
- small cultivated plot;
- plant marker;
- simple protective ring;
- watering container already covered by Round 2.

This should remain small-scale and characterful rather than becoming farm management.

---

# 34. Cultivated plot family

States:

```text
unprepared ground
cleared
loosened soil
planted
sprouting
growing
mature
harvested
fallow
overgrown
```

Possible attachments:

```text
SOCKET_PLANT_01...
SOCKET_MARKER
SOCKET_SIMPLE_FENCE
```

Visible irregularity should preserve improvised island character.

---

# 35. Plant protection projects

Potential simple compositions:

- stone ring;
- stick markers;
- low branch fence;
- shade cover;
- animal deterrent strands;
- raised planter/container.

These can reuse Round 1 and Round 3 construction vocabulary.

---

# 36. Animal feeding locations

Wilson may unintentionally or deliberately create recurring feeding sites.

Potential physical forms:

- flat rock with scraps;
- shallow bowl;
- ground patch;
- platform edge;
- hanging feeder-like improvised object.

History can transform a generic location into a relationship landmark.

---

# 37. Wildlife deterrents

Avoid species-specific bespoke devices when possible.

Potential generic deterrent components:

- raised surface;
- hanging storage;
- barrier;
- cover;
- noisy dangling scrap;
- visual marker;
- scare object;
- trap-like obstacle if supported.

Animal reactions can vary by behavior traits rather than requiring unique props.

---

# 38. Non-lethal traps / observation setups

Potential project families:

- simple basket trap;
- food lure setup;
- fish trap;
- crab trap;
- observation marker.

States:

```text
planned
set
baited
triggered
occupied
empty
broken
```

These are high-value systemic objects because they involve placement, bait, animal behavior and delayed outcomes.

---

# 39. Fish trap family

Potential composition:

```text
woven body
entrance funnel
weight/anchor
bait socket
retrieval anchor
```

States:

```text
crafted
set dry
set submerged
baited
occupied
empty after check
damaged
```

Anchors/sockets:

```text
SOCKET_BAIT
ANCHOR_SET
ANCHOR_CHECK
ANCHOR_RETRIEVE
```

---

# 40. Crab trap family

Potential composition can reuse container/basket geometry.

States:

```text
empty
baited
triggered
occupied
escaped/damaged
```

This can create interesting Gerald scenarios without requiring the game to force capture.

---

# 41. Nesting-material economy

Loose natural materials can be shared between Wilson and birds:

- grass;
- fiber;
- twigs;
- cloth scrap;
- rope fibers;
- dry leaves.

This creates emergent competition:

```text
Wilson stages project material
→ bird steals one piece
→ nest gains visible foreign material
```

A very low-cost systemic story.

---

# 42. Ecological landmarks

Some living objects should be allowed to become memorable even if they are not mechanically unique.

Examples:

- crooked palm;
- giant flat-canopy tree;
- crab-infested tide pool;
- bird nesting rock;
- unusually dense berry patch;
- dead tree silhouette.

Landmark value can come from silhouette + history, not special UI labeling.

---

# 43. Seasonal / long-cycle variation

If later desired, use subtle bounded cycles rather than full seasonal simulation.

Potential cycles:

- fruit abundance;
- flowering;
- nesting;
- tide-related shoreline exposure;
- storm aftermath frequency;
- dry/wet vegetation tone.

No need to model four real-world seasons on a tropical island.

---

# 44. Off-screen ecological catch-up

When the game simulates elapsed time, visible catch-up results may include:

- fruit regrown;
- bush recovered;
- nest completed;
- drift resources arrived;
- path vegetation partially recovered;
- food scavenged;
- planted crop advanced;
- burrow reopened;
- storm debris accumulated.

Important principle:

> Offline simulation should leave visible evidence, not only numeric changes.

---

# 45. Shared visible state vocabulary

A compact shared ecology vocabulary can cover many families:

```text
young / mature
healthy / stressed / damaged / dead
empty / occupied
unripe / ripe / harvested / recovering
wild / cultivated
open / hidden
wet / dry
intact / disturbed / collapsed
abundant / sparse / depleted / recovering
```

This vocabulary should influence later reference sheets and generator parameterization.

---

# 46. Generator implications

Potential procedural helpers emerging from this round:

```text
create_tree_trunk
create_tree_crown
create_frond_cluster
create_fruit_socket_cluster
create_bush_cluster
create_grass_clump
create_reed_patch
create_vine_segment
create_nest
create_burrow
create_tide_pool
create_perch_socket
create_habitat_region_marker
create_cultivated_plot
create_fish_trap
create_crab_trap
create_fallen_natural_debris
```

Animal base-model helpers may eventually include:

```text
create_crab_variant
create_simple_bird_variant
create_small_lizard_variant
```

but persistent-character animals should receive stricter visual review than generic fauna.

---

# 47. High-value reusable families from Round 4

Priority candidates for early visual support:

## P0

- coconut palm;
- generic shrub;
- ground grass/clump;
- fruit-bearing plant;
- fallen natural debris;
- crab;
- tide pool;
- crab burrow;
- shore bird;
- perch socket system.

## P1

- fruit tree;
- reed/fiber patch;
- vine family;
- bird nest;
- fish school;
- catchable fish;
- shellfish patch;
- small lizard;
- cultivated plot;
- fish trap;
- crab trap.

## P2

- transient fungi;
- insect group cues;
- specialized feeding structures;
- rare ecological landmarks;
- long-cycle flowering/nesting variants.

---

# 48. Core conclusion

The ecological asset strategy should optimize for:

```text
few biological families
+ clear lifecycle states
+ habitat anchors
+ renewable resource logic
+ selective persistent identity
= living island with strong visual history
```

The most important art-production consequence is that plants and habitats should be built to lose, regain and exchange modular parts rather than relying on unrelated complete meshes for every condition.
