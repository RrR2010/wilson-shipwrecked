# Functional Asset Catalog Brainstorming — Round 7

## Scope

This round explores functional object families related to:

- comfort and rest;
- recurring habits and personal routines;
- favorite places and personal geography;
- decoration and personalization;
- collections and trophies;
- sentimental or persistent personal objects;
- diary / writing / reflection areas;
- lighting and atmosphere;
- clothing and wearable organization;
- repeated object placement and camp organization;
- leisure, boredom relief and non-survival behavior.

This is a brainstorming artifact, not a canonical implementation schema.

The goal is to identify object families that make the island feel inhabited by one particular person rather than merely occupied by a survival agent.

---

# 1. Design principle: habit should leave scenery

Objects in this category often have modest survival utility but high narrative value.

A useful progression is:

```text
available object
→ repeated use
→ preferred use
→ stable location
→ visible wear / arrangement
→ personal meaning
```

The visual system should support this without requiring a bespoke scripted scene for every habit.

Examples:

```text
flat rock
→ sitting location
→ favorite sitting location
→ cleared / worn area around it

cup
→ drinking vessel
→ always stored beside water station
→ recognizable personal object

shelf
→ storage surface
→ shell collection
→ curated display
```

---

# 2. Rest and sleeping family

## 2.1 Primitive sleep surfaces

Potential progression:

```text
bare ground
→ leaf pile
→ woven mat
→ raised sleeping platform
→ padded bedroll
→ improvised bed
```

Potential families:

- `leaf_bedding`;
- `grass_bedding`;
- `woven_sleep_mat`;
- `cloth_bedroll`;
- `raised_sleep_platform`;
- `improvised_bed`.

Shared states:

```text
fresh
flattened / used
wet
dirty
damaged
patched
rolled / unrolled
```

Potential anchors:

```text
ANCHOR_SLEEP
ANCHOR_SIT
ANCHOR_MAKE_BED
ANCHOR_INSPECT
```

A sleeping object should visibly communicate whether Wilson has made the area part of his routine.

---

# 3. Pillow / headrest / soft comfort items

Potential families:

- bundled cloth pillow;
- leaf-stuffed pillow;
- folded sailcloth;
- rolled clothing;
- soft salvage cushion.

Functions:

- comfort;
- sleep preference;
- sitting support;
- sentimental object candidate;
- repair / restuff project.

Possible states:

```text
full
flattened
wet
patched
stuffing_exposed
```

These are good low-cost objects for communicating gradual domesticity.

---

# 4. Seating family expansion

Round 1 introduced primitive seating. This round expands the social/personal layer.

Potential families:

| Family | Role |
| --- | --- |
| `flat_rock_seat` | natural favorite spot |
| `log_seat` | opportunistic seat |
| `stump_seat` | work/rest hybrid |
| `crude_stool` | first built furniture |
| `wood_bench` | camp furniture |
| `improvised_chair` | later comfort project |
| `salvaged_chair` | found / repaired furniture |
| `hammock` | high-value comfort object |

Shared states:

```text
intact
wobbly
broken
repaired
wet
personalized
```

Potential anchors:

```text
ANCHOR_SIT
ANCHOR_REPAIR
ANCHOR_MOVE
ANCHOR_INSPECT
```

A chair does not become personal because of an explicit ownership flag alone. Repeated selection among alternatives should be able to make one seat meaningful.

---

# 5. Hammock family

A hammock is a particularly suitable island project because it combines:

- comfort;
- rope/fiber construction;
- attachment sockets;
- weather exposure;
- location preference;
- visual comedy when badly built.

Composition:

```text
support A
+ support B
+ rope ends
+ fabric/net bed
```

Potential states:

```text
planned
hung_loose
usable
sagging
torn
repaired
wet
```

Required attachment concept:

```text
SOCKET_HAMMOCK
```

compatible candidates might include:

- palm trunk;
- shelter post;
- dedicated post;
- sturdy tree;
- structural beam.

---

# 6. Small personal tables and surfaces

Potential families:

- bedside crate/table;
- low eating table;
- writing table;
- side table;
- personal shelf;
- stump table.

Functions:

- habitual object placement;
- diary station;
- meal routine;
- lamp placement;
- collection display;
- player-intervention comedy.

The important capability is not a special table type but a stable surface with clear placement sockets / zones.

Potential surface roles:

```text
SOCKET_SURFACE_GENERAL_*
SOCKET_LAMP
SOCKET_DIARY
SOCKET_CUP
```

These should not require every placed prop to snap mechanically during normal play, but stable semantic placement locations are useful for habits and procedural staging.

---

# 7. Diary / writing / reflection objects

Potential families:

- diary/notebook;
- loose paper bundle;
- writing board;
- charcoal writing stick;
- pencil/pen found object;
- map sheet;
- note pinned/tied to structure.

Potential states:

```text
closed
open
pages_used
wet
creased
damaged
protected
```

Potential station evolution:

```text
write on lap
→ flat rock / crate
→ small table
→ sheltered writing corner
```

Potential anchors:

```text
ANCHOR_WRITE
ANCHOR_READ
ANCHOR_INSPECT
```

The visual importance is the routine location rather than readable page text at gameplay camera distance.

---

# 8. Lighting objects

Lighting can become part of domestic routine even if the game uses broader environmental illumination.

Potential families:

- torch;
- standing torch;
- small oil-like lamp if plausible salvage exists;
- candle-like improvised light;
- ember pot;
- hanging lantern found object;
- reflective signal lamp.

Shared states:

```text
unlit
lit
low_fuel
smoking
wet
damaged
```

Potential anchors:

```text
ANCHOR_LIGHT
ANCHOR_EXTINGUISH
ANCHOR_REFUEL
SOCKET_HANG
SOCKET_PLACE
```

The game does not need dozens of decorative lights. A compact family can support camp atmosphere, night habits and project history.

---

# 9. Clothing storage and personal organization

Potential families:

- peg / hook;
- rope clothesline;
- small clothing rack;
- folded clothing stack;
- hanging clothing;
- footwear pair;
- storage basket for personal items.

Potential states:

```text
clean
dirty
wet
drying
patched
worn
```

Potential functions:

- drying after rain;
- changing clothes/accessories;
- habitual placement;
- visualizing weather history;
- player rearrangement opportunities.

A simple `SOCKET_HANG` vocabulary can support clothing, tools, bags and decorations.

---

# 10. Clothesline family

Composition:

```text
support
+ line
+ optional pegs
+ hanging items
```

States:

```text
empty
partially_used
full
sagging
damaged
repaired
```

Potential attachment candidates:

- shelter post;
- palm;
- dedicated stake;
- fence post.

The same system can later support drying food, cloth or small salvage when semantically appropriate.

---

# 11. Wearables and accessories as personal objects

Round 5 introduced wearable debris. Here the important layer is persistence and preference.

Potential categories:

- hat;
- improvised hat;
- head cloth;
- necklace/amulet;
- belt;
- wrist item;
- backpack/satchel;
- rain covering;
- sandals / found shoes.

Potential states:

```text
stored
worn
dirty
wet
damaged
patched
favorite / frequently_worn (behavioral, not necessarily asset state)
```

The same accessory should visually age rather than being replaced by a pristine version after every use.

---

# 12. Mirror / reflective grooming point

Possible implementations:

- metal mirror fragment;
- polished metal panel;
- still-water reflection point;
- found compact mirror.

Functions:

- inspect appearance;
- test wearable objects;
- rare self-directed humor;
- routine grooming.

Potential station:

```text
reflective object
+ personal shelf/table
→ grooming corner
```

This can support scenes in which Wilson reacts to absurd clothing without requiring a dedicated character-customization interface.

---

# 13. Washing and grooming personal items

Potential families:

- wash cloth;
- comb-like carved tool;
- brush;
- shaving/cutting improvised tool;
- soap-like found object, if plausible;
- water bowl;
- drying towel/cloth.

Potential states:

```text
clean
dirty
wet
dry
worn
```

These are low priority individually but useful for making long-lived routines believable.

---

# 14. Collection display family

Wilson should be able to accumulate objects for reasons other than utility.

Potential display infrastructure:

- shelf;
- display board;
- hanging line;
- small rack;
- flat display stone;
- crate-top display;
- wall hooks;
- trophy pole.

Potential anchors:

```text
SOCKET_DISPLAY_01...
SOCKET_HANG_01...
```

Possible collectible categories:

- shells;
- unusual stones;
- feathers;
- bottle caps / small metal pieces;
- interesting driftwood;
- rare debris;
- animal-related remains that are not tied to persistent named animals;
- player-gifted oddities;
- objects associated with memorable events.

---

# 15. Shell collection family

Shells are especially suitable because they are:

- naturally available;
- visually varied;
- cheap to model;
- collectible;
- arrangeable;
- potentially functional as scoops, containers or sharp edges.

Potential forms:

- spiral shell;
- clam-like shell;
- flat shell;
- tiny shell cluster.

Potential states:

```text
whole
chipped
wet
dry
cleaned
```

A collection can grow visually through simple placement rather than a UI counter.

---

# 16. Stone collection / curiosity objects

Potential variants:

- smooth stone;
- unusually colored stone;
- flat skipping stone;
- crystalline-looking but stylized stone;
- oddly shaped stone.

Functions:

- collectible;
- throwable;
- work material;
- paperweight;
- marker;
- decoration.

This is another good example of avoiding a strict distinction between "decorative" and "functional" items.

---

# 17. Trophy / memory display

A trophy does not need to mean achievement-system reward.

Potential examples:

- broken tool from a memorable failure;
- strange hat Wilson eventually liked;
- unusual bottle;
- repaired object;
- rare shell;
- odd piece of salvage;
- harmless animal-associated found object;
- first successful tool;
- first fish-hook equivalent;
- bowling ball.

Possible progression:

```text
useful / incidental object
→ event association
→ retained rather than discarded
→ placed in stable location
→ display object
```

This lets history become scenery without a dedicated trophy menu.

---

# 18. Object memorialization and retirement

Tools or objects that outlive their usefulness may become:

- decoration;
- spare material;
- memory object;
- marker;
- joke prop;
- display piece.

Potential visual state:

```text
retired
```

This need not be a literal asset-state enum. The key requirement is that old objects can remain present and be placed intentionally instead of being automatically deleted.

---

# 19. Camp personalization through arrangement

Personalization should not require hundreds of unique decorative models.

A large part can come from arrangement of ordinary objects:

```text
symmetrical storage
messy storage
favorite cup beside bed
shells lined on shelf
boots always outside shelter
tools hung in a preferred order
stones arranged around a seat
rope coil always beside workbench
```

This suggests preserving stable placement where useful and allowing Wilson's habits to influence object organization.

---

# 20. Cleanliness / mess visual vocabulary

Possible environmental states:

```text
organized
slightly_cluttered
messy
recently_cleaned
```

Rather than materializing this as one global camp state, use object arrangement and debris density.

Potential clutter pieces:

- wood offcuts;
- coconut shells;
- fiber scraps;
- empty bowls;
- cloth pieces;
- tool left on surface;
- ash;
- food remains.

Wilson may develop local cleanup habits without the entire island needing a cleanliness simulator.

---

# 21. Waste basket / discard pile

Potential forms:

- designated ground pile;
- woven waste basket;
- burnable scrap pile;
- salvage sorting pile.

Functions:

- organization;
- future reuse;
- fire fuel;
- animal attraction;
- cleanup routine.

Potential states:

```text
empty
partial
full
sorted
scattered
wet
```

A discard pile can later become resource storage if Wilson changes his mind about what is useful.

---

# 22. Personal storage family

Separate from bulk food/resource storage.

Potential families:

- small box;
- pouch;
- basket;
- suitcase reused as personal chest;
- shelf cubby;
- hanging bag.

Potential contents:

- diary;
- accessories;
- sentimental items;
- writing tools;
- small rare objects.

Potential states:

```text
open
closed
empty
partial
full
messy
organized
```

This can reinforce a distinction between "camp resources" and "Wilson's things" without requiring a conventional inventory UI.

---

# 23. Favorite-object placement

Some object families should expose a simple stable resting place to support repeated habits.

Examples:

```text
cup → water station socket
spoon → cooking station socket
diary → writing table socket
hat → peg
bag → shelter hook
favorite stone → shelf
```

The system should not require every object to be hard-snapped. It mainly needs repeatable, readable placement targets.

---

# 24. Leisure objects

The game benefits from Wilson doing things that solve no urgent need.

Potential families:

- skipping stone;
- simple ball;
- improvised target;
- tossing ring;
- carved figurine;
- simple puzzle object;
- board/marking game;
- found toy;
- musical/noise object;
- kite-like project if wind systems justify it.

Possible functions:

- boredom reduction;
- habit formation;
- preferences;
- comedy;
- player interference;
- animal interaction.

---

# 25. Throwing / target-play objects

Potential target families:

- marked stump;
- hanging target;
- stacked cans/containers;
- ring target;
- target board.

Potential projectile candidates:

- stones;
- nuts;
- balls;
- shells;
- harmless lightweight debris.

This can reuse normal physics/interaction capabilities instead of a bespoke minigame.

---

# 26. Carved / handmade figurines

Potential progression:

```text
wood scrap
→ roughly carved shape
→ recognizable figurine
→ painted/marked variant if later supported
```

Functions:

- leisure project;
- decoration;
- sentimental object;
- gift-like object toward the unexplained player presence;
- collection.

Keep geometry extremely simple and readable.

---

# 27. Music and noise objects

Potential families:

- whistle;
- hollow-tube flute;
- simple drum/container;
- shaker;
- hanging shells;
- chime from salvage;
- found bell.

Potential states:

```text
intact
damaged
wet
hung
stored
```

Functions:

- leisure;
- signal;
- animal reaction;
- wind-driven ambient movement/sound;
- habit.

A wind chime made from later salvage could become a strong visual marker of camp age.

---

# 28. Wind-driven decoration

Potential families:

- cloth strip;
- streamer;
- shell chime;
- hanging bottle pieces;
- small flag;
- windsock-like salvage;
- simple mobile.

Functions:

- weather readability;
- decoration;
- sound;
- location identity.

Potential attachments:

```text
SOCKET_HANG
SOCKET_FLAG
```

These objects can communicate breeze without additional UI.

---

# 29. Camp signs and labels

Potential families:

- carved wood sign;
- painted/marked salvage panel;
- tied marker tag;
- simple symbol board.

Functions:

- mark storage;
- mark hazards;
- personalize locations;
- running joke;
- player-facing readable iconography if needed.

Detailed textual writing should not be required at gameplay scale. Shape/symbol/color can carry most information.

---

# 30. Ritual-like repeated arrangements

Without introducing supernatural mechanics, Wilson may develop odd repeated arrangements:

- three stones beside bed;
- shoes aligned perfectly;
- tools ordered by size;
- shells arranged around a favorite rock;
- a specific object always placed near the fire;
- daily marker on a post.

These require little new geometry but greatly expand perceived personality.

The asset system should not prevent ordinary movable objects from being used this way.

---

# 31. Day-count / time-marking objects

Potential families:

- tally post;
- marked plank;
- stacked stones;
- shell row;
- notched stick.

Functions:

- personal ritual;
- visual passage of time;
- project progress;
- camp storytelling.

A day-counting behavior should remain optional and character-driven rather than mandatory UI replacement.

---

# 32. Maps and local planning surfaces

Potential forms:

- paper map;
- charcoal sketch on board;
- stone/shell arrangement representing locations;
- marked sand plan;
- pinned notes.

Potential functions:

- planning animation;
- route memory;
- project staging;
- decoration.

The representation does not need authoritative readable cartography at gameplay distance.

---

# 33. Weather-driven comfort objects

Potential families:

- shade cloth;
- rain flap;
- wind screen;
- sun hat;
- blanket;
- dry clothing cache;
- towel.

Potential states:

```text
stored
deployed
wet
dry
damaged
patched
```

These provide visible evidence that Wilson adapts not only for survival but for comfort.

---

# 34. Shade and lounging spots

Potential compositions:

```text
natural shade + seat
shelter overhang + chair
cloth canopy + mat
palm + hammock
```

A "favorite spot" should ideally emerge from these affordances rather than from one special asset.

---

# 35. Camp zones as emergent composition

Repeated object placement may form recognizable functional zones:

```text
sleep zone
cooking zone
work zone
storage zone
wash zone
leisure zone
display zone
```

These should not necessarily be explicit bounded gameplay entities.

The visual asset catalog should simply provide enough small furniture, surfaces, racks and hooks for these zones to become readable.

---

# 36. Personalization through repair choices

A repair can become decoration unintentionally.

Examples:

```text
blue cloth patch on brown shelter
bright rope around old chair
metal sign used as table reinforcement
odd plank on storage door
shell tied to a tool handle
```

Thus personalization does not need a cosmetic crafting system.

It can emerge from the material history of repairs.

---

# 37. Color-accent personal objects

Most world assets should stay within a controlled palette, but a few found/personal objects can carry stronger accent colors:

- hat;
- cup;
- bottle;
- cloth patch;
- buoy fragment;
- toy;
- sign fragment.

This can make favorites recognizable at gameplay distance.

Accent saturation should remain constrained so the island does not become visually noisy.

---

# 38. Sentimental object candidates

Any durable portable object can potentially acquire sentimental value.

Good candidates:

- first tool;
- repaired cup;
- strange shell;
- bottle with message;
- player-provided object;
- memorable debris;
- unusual wearable;
- carved figurine;
- old broken tool;
- object associated with an animal relationship.

No unique "sentimental object" mesh family is required.

The production requirement is that ordinary props remain visually persistent enough to be recognized later.

---

# 39. Player intervention and personal organization

Small personal items are excellent player-intervention targets.

Potential situations:

- move Wilson's cup;
- swap two display objects;
- place something on his chair;
- hide a hat;
- rearrange shell collection;
- put an absurd object on his bedside table.

These interactions work only if Wilson's normal arrangement is visually stable enough for the disturbance to be meaningful.

---

# 40. Object ownership visual cues

Avoid explicit floating ownership icons.

Possible indirect cues:

- stable storage location;
- repeated proximity to bed/shelter;
- repair history;
- customized binding;
- display placement;
- habitual carrying/wearing;
- dedicated hook or shelf position.

Ownership is primarily behavioral/history state, not mesh identity.

---

# 41. Personal space evolution

Possible visual progression:

```text
survival camp
→ organized camp
→ comfortable camp
→ personalized camp
→ eccentric long-lived home
```

Importantly, later stages should not look architecturally polished.

They should look accumulated:

- repaired furniture;
- hanging objects;
- collections;
- favorite spots;
- improvised shelves;
- mismatched materials;
- long-used pathways;
- retired objects.

---

# 42. Functional overlaps from this round

High-value overlaps include:

```text
cloth
→ clothing / bedding / shade / patch / decoration

rope line
→ clothesline / hanging storage / decoration / drying

shelf
→ storage / collection / personal organization

chair
→ comfort / habit / preference / repair history

lamp
→ light / routine / camp identity

shell
→ collectible / tool candidate / decoration / sound object

old tool
→ functional item / retired memory / display
```

This overlap is desirable because it reduces unique asset count while increasing narrative possibilities.

---

# 43. Candidate reusable generators implied by this round

Potential Blender helpers/generators:

```text
create_sleep_mat
create_bedroll
create_pillow_bundle
create_stool
create_bench
create_improvised_chair
create_hammock
create_small_table
create_shelf
create_wall_hook
create_clothesline
create_lamp
create_personal_box
create_display_rack
create_shell_variant
create_curiosity_stone
create_trophy_mount
create_wind_chime
create_flag_or_streamer
create_sign
create_target
create_simple_toy
create_carved_figurine
create_tally_marker
```

These should reuse Round 1–3 primitives such as plank, rope, cloth, binding, post and surface generators.

---

# 44. Recommended early support set

High-value early comfort/personalization assets:

1. sleeping mat;
2. simple stool;
3. bench/log seat variants;
4. small table / crate surface;
5. shelf;
6. hook / peg;
7. clothesline;
8. diary/notebook;
9. cup + spoon stable placement;
10. small lamp/torch family;
11. shell collectible variants;
12. personal storage box/basket;
13. hammock as first higher-comfort project;
14. one simple leisure object such as ball/target;
15. one hanging decorative/noise object.

This set provides disproportionate visible domesticity for a relatively small modeling cost.

---

# 45. Round conclusion

The strongest conclusion from this round is:

> Personalization should emerge primarily from repeated use, arrangement, repair history, collections and repurposed ordinary objects—not from a large catalog of purely cosmetic decorations.

A useful visual equation is:

```text
ordinary functional props
+ stable placement
+ repeated behavior
+ wear / repairs
+ occasional unusual finds
= personal home
```

This fits the living-diorama premise better than a conventional decoration/build mode and keeps the 3D production burden bounded.
