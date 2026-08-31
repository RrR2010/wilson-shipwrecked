# Functional Asset Catalog Brainstorming — Round 8

## Scope

This round explores functional object families and visible world states related to:

- rain, wind, storms, heat and tide;
- temporary environmental conditions;
- damage, breakage, flooding and erosion;
- slippery / unstable surfaces;
- fire interaction with weather;
- wind-driven and water-driven objects;
- storm debris and post-weather opportunities;
- temporary hazards created by weather, terrain or Wilson's own projects;
- visual persistence after major environmental events.

This is a brainstorming artifact, not a canonical implementation schema.

The goal is to make weather and hazards alter the physical opportunity space rather than functioning only as lighting or stat modifiers.

---

# 1. Weather object philosophy

Weather should create visible world consequences.

Conceptually:

```text
weather condition
+ exposed world state
+ object capabilities
→ temporary state changes
→ new risks / affordances
→ persistent traces where useful
```

Examples:

```text
rain + cloth → wet cloth → heavier / less useful as tinder
wind + loose sheet → moving sheet → obstruction / collection opportunity
storm + palm → damaged fronds → fallen resource
high tide + beach debris → relocation / wash-up event
```

Avoid treating all weather effects as abstract global modifiers.

---

# 2. Shared environmental state vocabulary

Reusable states across many assets:

```text
dry
wet
soaked
damp
muddy
wind-exposed
wind-displaced
heated
sun-dried
charred
burning
smoldering
extinguished
flooded
submerged
salt-wet
storm-damaged
loosened
fallen
buried
uncovered
blocked
```

Not every object needs every state.

The visual system should reuse a small set of readable material / geometry changes.

---

# 3. Rain states and rain-exposed objects

Potential world-visible consequences:

| Family | Rain response |
| --- | --- |
| `sand_ground` | darkened / compacted / puddled |
| `soil_patch` | damp / muddy / waterlogged |
| `cloth_sheet` | wet sag / darker material |
| `rope` | wet darker state |
| `wood` | wet surface state |
| `fire_site` | weak / smoking / extinguished |
| `food_exposed` | wet / contaminated candidate |
| `open_container` | accumulates water |
| `shelter_roof` | runoff / leak states |
| `path_ground` | muddy / slippery sections |

Rain should create opportunities:

- filling water containers;
- revealing shelter leaks;
- testing drainage;
- extinguishing fires;
- creating mud;
- washing loose debris downhill;
- changing animal behavior;
- causing Wilson to relocate activities.

---

# 4. Puddles and temporary water accumulation

Potential family:

```text
puddle_small
puddle_medium
flooded_patch
```

States:

```text
forming
full
draining
drying
muddy
clear
```

Capabilities:

- reflectivity / visual landmark;
- splash;
- wash candidate;
- slip / stumble opportunity;
- temporary animal attraction;
- small-item displacement;
- path obstruction.

Puddles can be generated from terrain regions rather than unique authored meshes where possible.

---

# 5. Shelter leak vocabulary

Shelters should visibly expose weather weakness.

Potential leak states:

```text
sealed
minor leak
active drip
multiple leaks
roof breach
```

Components:

- displaced thatch panel;
- broken tie;
- torn cloth patch;
- missing roof segment;
- drip point marker/effect;
- wet sleeping area.

Potential anchors:

```text
ANCHOR_INSPECT_LEAK
ANCHOR_REPAIR_ROOF
```

A leak can become a project trigger without creating a unique shelter asset.

---

# 6. Wind interaction categories

Objects can be grouped by wind response rather than by type.

## 6.1 Wind-insensitive

Examples:

- rocks;
- heavy logs;
- structural posts;
- large crates.

## 6.2 Wind-reactive flexible

Examples:

- palm fronds;
- cloth;
- flags;
- hanging decorations;
- clothesline items;
- rope ends.

## 6.3 Wind-displaceable

Examples:

- leaves;
- paper;
- lightweight bowls;
- cloth scraps;
- small debris;
- empty baskets.

## 6.4 Wind-dangerous

Examples:

- loose panel;
- unsecured sheet metal;
- falling branch;
- unsecured tool;
- top-heavy sign.

This classification can guide both animation and simulation affordances.

---

# 7. Loose-object security states

Potential reusable condition:

```text
secured
loosely placed
unstable
wind-displaced
fallen
lost / relocated
```

Useful for:

- roof panels;
- signs;
- containers;
- ladders;
- cloth covers;
- stacked materials;
- drying racks;
- temporary project pieces.

This lets storms test Wilson's construction quality visually.

---

# 8. Storm damage family

Shared damage sequence:

```text
intact
→ stressed
→ loosened
→ partially damaged
→ broken / detached
→ repairable remains
```

Potential structural targets:

- shelter roof;
- fence;
- canopy;
- drying rack;
- dock;
- raft;
- lookout;
- clothesline;
- garden trellis.

Damage should preferentially produce reusable detached pieces:

- plank;
- pole;
- thatch bundle;
- cloth sheet;
- rope segment;
- metal panel.

Do not turn damaged structures into pure visual rubble if their components can remain interactive.

---

# 9. Fallen branch / fallen tree opportunities

Potential family states:

```text
standing tree
→ wind-damaged
→ broken limb
→ fallen branch
```

For severe cases:

```text
standing tree
→ leaning damaged
→ fallen tree
→ trunk + crown debris
→ salvage / decomposition
```

Capabilities of a fallen tree:

- obstacle;
- bridge-like crossing candidate;
- wood source;
- seating;
- landmark;
- animal perch;
- project material.

A storm therefore generates content rather than only destroying content.

---

# 10. Palm storm-state vocabulary

Potential states:

```text
healthy
wind-bent temporary
frond loss
fruit loss
damaged crown
leaning
fallen
stump / remains
```

Potential detachable outputs:

- fronds;
- coconuts;
- trunk sections;
- fiber/bark material.

Storms can therefore accelerate or relocate harvesting opportunities.

---

# 11. Heat / sun exposure

Heat should be simpler than rain but still visible where meaningful.

Potential state changes:

```text
wet → drying → dry
fresh plant matter → wilted
mud → cracked/dry
food → warmed / spoiled faster
cloth → dried
wood → dry fuel candidate
```

Potential world objects:

- shaded area;
- sun-exposed rock;
- drying surface;
- overheated metal scrap.

Sun exposure can create both comfort preferences and processing opportunities.

---

# 12. Shade as environmental functionality

Shade-producing families:

- palm crown;
- tree canopy;
- shelter roof;
- cloth canopy;
- rock overhang;
- umbrella-like salvage.

Potential capabilities:

```text
provides_shade
protects_from_rain
partial_wind_protection
```

Shade regions need not be represented as explicit meshes; the asset contract may expose appropriate coverage geometry/metadata.

---

# 13. Tide variation

Potential shoreline states:

```text
low tide
normal tide
high tide
storm surge
```

Consequences:

- tide pools change area;
- new shoreline resources become accessible;
- debris is moved;
- beach routes narrow;
- low objects may become wet/submerged;
- raft/dock access changes;
- animal habitats shift.

Avoid requiring fully simulated ocean hydrodynamics.

The visual requirement is coherent shoreline state transition.

---

# 14. Wash-up events

Reusable beach-arrival vocabulary:

```text
object offshore
→ floating near shore
→ beached
→ partially buried / wet
→ dried / discovered
```

Potential arrivals:

- driftwood;
- crate;
- bottle;
- rope;
- cloth;
- buoy;
- rare object;
- dead vegetation;
- unusual salvage.

This is a core route for introducing found objects without inventory spawning.

---

# 15. Erosion / burial states

Potential beach object states:

```text
exposed
partially buried
mostly buried
uncovered again
```

Useful for:

- crates;
- bottles;
- wreck fragments;
- stones;
- shells;
- metal salvage.

Burial can use simple transform/terrain masking rather than bespoke meshes when feasible.

---

# 16. Slippery surfaces

Potential sources:

- wet rock;
- mud;
- seaweed-covered rock;
- wet wood;
- algae-like shoreline surface.

Shared capability:

```text
slippery
```

Visual communication should be broad:

- darker wet material;
- simplified sheen;
- visible seaweed mass;
- puddle/mud presence.

Avoid relying on subtle specular changes alone.

---

# 17. Trip hazards

Potential families:

- shallow hole;
- exposed root;
- loose rope;
- scattered log;
- fallen branch;
- unstable plank;
- rolling coconut;
- rolling ball;
- low crate/debris;
- collapsed project component.

Trip hazards are especially valuable for physical comedy because they can emerge from ordinary world state.

They should not all be scripted traps.

---

# 18. Rolling-object hazard/opportunity

Potential rollable families:

```text
coconut
round stone
barrel
bowling ball
log segment
buoy
```

Relevant environmental conditions:

- slope;
- impact;
- wind where light enough;
- player relocation;
- collision.

Potential outcomes:

- crack/break target;
- knock over object;
- fall into water;
- trip Wilson;
- dislodge construction;
- produce comedy.

---

# 19. Fire + weather interaction

Fire site states:

```text
dry_unlit
wet_unlit
small_flame
stable_flame
wind_blown
smoking
embers
extinguished
flooded
```

Weather effects:

- rain weakens/extinguishes;
- wind alters flame and spark direction;
- dry heat improves fuel readiness;
- wet fuel smokes;
- flooded fire pit becomes temporarily unusable.

The visual vocabulary should reuse fire-site components from Round 1.

---

# 20. Controlled fire spread opportunities

Potential flammable object categories:

- dry leaf pile;
- dry grass;
- cloth;
- dry wood;
- thatch;
- rope/fiber;
- paper.

Potential stages:

```text
unheated
heated
smoldering
burning
charred
ash
```

For the first milestone, full unrestricted fire propagation may be too expensive.

However, asset support should not prevent authored or bounded local propagation later.

---

# 21. Smoke as functional state

Smoke may indicate:

- wet fuel;
- smoldering fire;
- cooking;
- signal fire;
- damaged burning object.

Potential consequences:

- visibility cue;
- animal reaction;
- Wilson discomfort;
- signal project feedback.

Smoke itself is a runtime effect, but source objects need anchors such as:

```text
ANCHOR_SMOKE_SOURCE
```

where useful.

---

# 22. Flooded storage / exposed supplies

Potential storage conditions:

```text
dry
leaking
wet contents
flooded
collapsed
```

Possible consequences:

- food spoilage;
- wet tinder;
- floating lightweight objects;
- relocation project;
- reinforced storage construction.

This supports visible learning from environmental failures.

---

# 23. Drainage projects

Potential project family:

```text
drainage_trench
runoff_channel
raised_floor
raised_storage
```

Evolution:

```text
problem area
→ marked route
→ partial trench
→ functioning drainage
→ eroded / clogged
→ maintained
```

Potential anchors:

```text
ANCHOR_DIG
ANCHOR_CLEAR
ANCHOR_INSPECT
```

This is a useful example of Wilson modifying terrain rather than only building discrete props.

---

# 24. Windbreak / storm reinforcement

Potential temporary reinforcement objects:

- extra rope tie;
- diagonal brace;
- sand/stone weight;
- anchored stake;
- tied cloth edge;
- shutter/panel.

Visual history:

```text
normal structure
+ emergency reinforcement
→ storm-surviving patched structure
```

Emergency solutions should remain visible afterward when plausible.

---

# 25. Lightning / strike consequences

Potential future/rare event support:

Targets:

- tall tree;
- lookout pole;
- isolated structure;
- metal object cluster.

Possible visual states:

```text
scorched
split
smoldering
fallen
```

Do not require a global lightning-damage simulation initially.

This can remain an authored/rare opportunity supported by generic damage states.

---

# 26. Post-storm debris field

Potential generated cluster:

- leaves;
- branches;
- coconuts;
- rope pieces;
- panels;
- washed-up debris;
- displaced possessions.

A storm should make the camp visibly untidy.

Cleanup can itself become autonomous activity.

Potential states:

```text
scattered
collected pile
sorted
reused / discarded
```

---

# 27. Cleanup pile family

Useful generic families:

```text
leaf_pile
branch_pile
debris_pile
mixed_salvage_pile
ash_pile
```

Capabilities:

- collect;
- sort;
- burn where appropriate;
- reuse materials;
- trip/obstruction when scattered.

These also communicate Wilson's domestic habits.

---

# 28. Fallen / displaced possessions

Weather can alter personal organization:

```text
object in habitual place
→ storm displaced
→ Wilson notices mismatch
→ retrieves / relocates / secures
```

This links weather to persistent habit systems without special narrative events.

Objects especially suited:

- spoon;
- cup;
- lightweight tool;
- cloth;
- hat;
- basket;
- diary cover / paper if protected appropriately;
- decorations.

---

# 29. Mud and dirty-state opportunities

Potential dirtyable families:

- Wilson clothing/body presentation;
- tools;
- containers;
- bedding;
- floors/platforms;
- food prep surfaces.

Shared state:

```text
clean
lightly_dirty
muddy
washed
wet_after_washing
```

Do not over-model grime textures.

Large readable material patches/state swaps are preferable.

---

# 30. Temporary natural obstructions

Examples:

- fallen palm frond;
- branch across path;
- flood puddle;
- tide-blocked route;
- driftwood pile;
- collapsed fence;
- washed-up crate.

These can change Wilson's route choice and create new personal geography.

---

# 31. Environmental opportunity objects

Weather-generated or environment-generated objects with high systemic value:

| Object | Opportunity |
| --- | --- |
| fallen branch | wood / obstacle / bridge candidate |
| detached frond | roofing / bedding / fuel |
| rain-filled container | drinking/washing water |
| washed-up crate | storage / salvage |
| storm-loosened panel | repair / repurpose |
| puddle | washing / slipping / animal attraction |
| exposed buried object | discovery |
| driftwood cluster | construction resource |
| high-tide debris | rare found object |

The key principle is that adverse events should sometimes create useful possibilities.

---

# 32. Environmental repair history

After a major event, the island should not return instantly to pristine state.

Potential persistent traces:

- patched roofs;
- additional braces;
- moved storage;
- new drainage channels;
- stump/fallen tree remains;
- repaired dock planks;
- relocated fire pit;
- reinforced ties;
- abandoned damaged object;
- cleanup piles.

This strongly supports the project's history-as-scenery principle.

---

# 33. Visual severity tiers

To control asset explosion, use shared severity tiers where useful:

```text
normal
minor_state_change
major_state_change
damaged
failed
repaired
```

Examples:

```text
shelter:
normal → loose thatch → roof breach → patched

palm:
normal → lost fronds → broken crown → fallen

storage:
normal → wet → flooded/collapsed → raised/repaired
```

Exact simulation values remain outside the asset catalog.

---

# 34. Opportunity-state priority

Not every environmental event needs bespoke assets.

High-value states to support early:

## P0

- wet/dry material state;
- fire extinguished/smoking;
- puddle/mud patch;
- loose/fallen branch;
- fallen frond;
- displaced lightweight object;
- shelter roof damage;
- repair patch;
- rain-filled container;
- storm debris pile.

## P1

- flooded storage;
- drainage trench;
- fallen tree;
- damaged dock/raft;
- wind-displaced panel;
- shoreline burial/exposure;
- high-tide access variants.

## P2

- lightning-struck tree;
- severe erosion;
- larger flood states;
- extensive fire propagation;
- sophisticated wind physics.

---

# 35. Suggested reusable generators / helpers

Candidate Blender/runtime-oriented helpers:

```text
apply_wet_material_state
apply_charred_state
apply_damage_variant
create_puddle_patch
create_mud_patch
create_fallen_branch
create_fallen_frond
create_storm_debris_cluster
create_repair_brace
create_roof_patch
create_drainage_trench
create_cleanup_pile
create_displaced_object_variant
```

These should remain deterministic and visually simple.

---

# 36. Round 8 consolidation

The most valuable environmental vocabulary emerging from this round is:

```text
WEATHER EXPOSURE
 dry / wet / soaked / drying

STRUCTURAL STABILITY
 secured / loose / stressed / damaged / failed / repaired

FIRE
 dry / smoking / burning / embers / extinguished / charred

WATER / TERRAIN
 dry / puddled / muddy / flooded / draining

MOBILITY
 stable / slippery / obstructed / displaced

STORM RESULT
 intact / detached part / debris / salvage opportunity
```

This vocabulary is deliberately cross-family.

The intended pattern is:

```text
same asset family
+ environmental state
+ optional detached/repair pieces
```

rather than a unique model for every weather combination.

---

# 37. Production implication

Weather support should prioritize reusable visual modifiers and detachable pieces before simulation complexity.

An early agent-support toolkit can obtain substantial visual coverage from:

- shared wet/dry material variants;
- broad damage tiers;
- reusable repair attachments;
- puddle/mud terrain patches;
- debris clusters;
- falling/fallen vegetation pieces.

This preserves the aggressive low-poly art direction and keeps environmental storytelling feasible for automated asset generation.
