# Functional Asset Catalog Brainstorming — Round 5

## Scope

This round explores shipwreck remnants, washed-up debris, found objects, rare objects, absurd physical opportunities, and reusable object families that can support systemic comedy, experimentation, player intervention, and persistent object history.

This is a brainstorming artifact, not a canonical implementation schema.

The goal is to identify object families that are visually distinctive but still participate in shared physical capabilities such as carrying, impact, rolling, covering, containing, wearing, attaching, floating, cutting, weighing down, or becoming project material.

---

# 1. Design principle: found objects should be semantically surprising, not mechanically bespoke

A rare or absurd object is most valuable when it participates in the same world grammar as ordinary resources.

Prefer:

```text
bowling ball
  + heavy
  + rollable
  + impact-capable
  + awkward-to-carry
```

rather than:

```text
special_coconut_breaking_bowling_ball
```

The humor should come from Wilson discovering that a strange object satisfies an existing requirement.

Useful shared capability vocabulary:

```text
portable
heavy
lightweight
rollable
throwable
impact-capable
sharp
blunt
flat
flexible
rigid
hollow
container
liquid-compatible
floatable
wearable
covering
binding-compatible
flammable
heat-resistant
reflective
sound-producing
stackable
attachable
```

---

# 2. Shipwreck remains as a persistent landmark family

The wreck should not be only background scenery. It can function as a material source, landmark, habitat, hazard, memory location, and staged excavation/harvesting site.

## 2.1 Wreck structural pieces

Potential families:

- hull section;
- rib/frame section;
- deck plank cluster;
- broken mast;
- mast segment;
- spar;
- railing fragment;
- hatch;
- broken door/panel;
- rope rigging cluster;
- sailcloth remnant;
- metal fitting;
- pulley/block;
- chain segment;
- anchor fragment;
- intact or partial anchor;
- ship wheel fragment;
- cabin furniture fragment.

Potential states:

```text
embedded
partially exposed
weathered
loose
salvaged
stripped
collapsed
storm-shifted
burned
```

Potential functions:

- salvage wood;
- salvage rope;
- salvage cloth;
- salvage metal;
- climbing/standing location;
- shade/shelter candidate;
- animal habitat;
- dangerous sharp geometry;
- tide-dependent access;
- long-term visual depletion.

A wreck can visibly become more stripped over time as Wilson reuses parts.

---

# 3. Salvage extraction states

Instead of replacing the wreck with arbitrary meshes, use removable components when practical.

Conceptual progression:

```text
intact wreck cluster
→ obvious loose pieces removed
→ secondary useful fittings removed
→ structural pieces stripped
→ skeletal wreck remains
```

Potential removable sockets:

```text
SOCKET_PLANK_*
SOCKET_ROPE_*
SOCKET_METAL_*
SOCKET_CLOTH_*
SOCKET_FITTING_*
```

This supports visual history and avoids the wreck feeling like an infinite resource node.

---

# 4. Crates and cargo containers

Crates should form a family rather than one opening prop.

## 4.1 Wooden crate family

Potential variants:

- small cargo crate;
- medium cargo crate;
- large cargo crate;
- reinforced crate;
- slatted crate;
- partially broken crate;
- waterlogged crate.

States:

```text
sealed
closed
opened
partially emptied
empty
damaged
broken down
```

Functions:

- storage;
- sitting;
- work surface;
- obstacle;
- stacking;
- material source;
- animal barrier;
- player rearrangement target.

Potential anchors:

```text
ANCHOR_OPEN
ANCHOR_INSPECT
ANCHOR_PICKUP (small variants)
ANCHOR_BREAK
SOCKET_STACK_TOP
```

---

# 5. Barrels, drums and cylindrical containers

Potential families:

- wooden barrel;
- small cask;
- metal drum;
- plastic-like washed-up drum if setting permits;
- sealed chemical-looking but non-authoritative mystery container;
- floating barrel.

States:

```text
sealed
closed
open
empty
partial
full
leaking
dented
split
waterlogged
```

Capabilities:

- liquid storage;
- dry storage;
- floatation;
- rollable;
- heavy when full;
- seat/table candidate;
- raft float candidate;
- obstacle;
- trap/barrier component.

Important comedy opportunity:

```text
empty barrel = manageable
full barrel = unexpectedly immovable
slope + barrel = rolling hazard
```

---

# 6. Bottles and jars

Potential variants:

- glass bottle;
- opaque bottle;
- corked bottle;
- screw-cap found bottle;
- jar;
- wide-mouth jar;
- broken bottle;
- bottle with message.

States:

```text
sealed
open
empty
contains liquid
contains small object
broken
cloudy/dirty
cleaned
```

Capabilities:

- liquid container;
- message/event carrier;
- small-item container;
- reflective/glinting object;
- breakable;
- sharp shard source;
- sound-producing when struck.

A bottle can support authored hints without becoming a recipe UI.

---

# 7. Metal salvage family

Metal is especially useful because it introduces strong physical capabilities that natural island materials may lack.

Potential families:

- metal sheet scrap;
- bent plate;
- metal strip;
- rod;
- pipe short;
- pipe long;
- bracket;
- hinge;
- hook;
- ring;
- chain link/segment;
- nail/spike-like salvage;
- bolt-like part;
- wire coil;
- metal cup/tin;
- pan;
- lid;
- mesh/grid fragment.

Shared states:

```text
clean-ish
weathered
rusted
bent
sharp-edged
dented
heated
blackened
```

Capabilities vary by piece:

```text
hard
sharp
blunt
heat-resistant
reflective
conductive (only if simulation needs it)
rigid
bendable
attachable
```

Avoid exposing fine-grained metallurgy visually unless gameplay actually uses it.

---

# 8. Cloth and textile salvage

Potential families:

- sailcloth sheet;
- torn cloth sheet;
- cloth strip;
- rope-frayed cloth;
- blanket-like fabric;
- clothing remnant;
- sack;
- canvas bag;
- flag fragment.

States:

```text
dry
wet
dirty
clean
torn
patched
sun-faded
burned edge
```

Functions:

- covering;
- rain protection;
- wrapping;
- bedding;
- carrying bundle;
- shade;
- wind screen;
- clothing repair;
- filter candidate where appropriate;
- project panel.

Potential composition:

```text
cloth + poles + bindings
→ awning / windscreen / rain catch / screen
```

---

# 9. Rope, cordage and rigging salvage

Shipwreck-derived rope can supplement island-made fiber rope.

Variants:

- short rope;
- long rope;
- thick rope;
- frayed rope;
- rope coil;
- knot cluster;
- net fragment;
- rigging line.

States:

```text
dry
wet
frayed
damaged
cut
knotted
tensioned
```

Functions:

- binding;
- hauling;
- suspension;
- drying/hanging infrastructure;
- raft construction;
- climbing aid;
- animal barrier;
- securing cargo.

Visual distinction between manufactured rope and improvised plant-fiber cord can reinforce progression.

---

# 10. Nets and mesh

Potential variants:

- fishing net fragment;
- intact small net;
- cargo net;
- metal mesh;
- woven improvised net.

States:

```text
folded
spread
hanging
wet
torn
patched
loaded
```

Functions:

- fishing;
- carrying bundle;
- drying;
- storage;
- barrier;
- trap component;
- hammock-like experiment;
- shade texture without relying on alpha-heavy detail.

---

# 11. Containers with unknown contents

A reusable mystery-container family is highly valuable for exploration scenes.

Potential visual archetypes:

- sealed metal box;
- locked-looking case;
- waterproof pouch;
- tin;
- small trunk;
- suitcase;
- tool case;
- cooler-like container;
- cylindrical canister.

Required state vocabulary:

```text
unexplored
inspected
attempted_opening
dented
damaged
opened
contents_revealed
empty
```

Important rule:

The visual asset should support physical experimentation without implying the correct opening method.

Potential anchors:

```text
ANCHOR_INSPECT
ANCHOR_OPEN
ANCHOR_HIT
ANCHOR_PRY
ANCHOR_HOLD
```

---

# 12. Luggage and personal cargo

Potential families:

- suitcase;
- travel trunk;
- duffel-like bag;
- satchel;
- waterproof bag;
- small case;
- lunchbox-like container.

States:

```text
closed
open
empty
packed
damaged
waterlogged
repurposed
```

Functions:

- storage;
- seat;
- surface;
- clothing/textile source;
- rare-object source;
- persistent sentimental object candidate.

The same suitcase can evolve from mystery object to permanent camp storage.

---

# 13. Kitchen and domestic found objects

Potential found items:

- spoon;
- fork;
- knife;
- ladle;
- spatula;
- metal cup;
- mug;
- plate;
- bowl;
- pan;
- pot;
- pot lid;
- kettle;
- colander;
- tray;
- cutting board;
- bottle opener;
- can opener;
- thermos.

Important principle:

A modern object can be mechanically better than Wilson's improvised equivalent without making the improvised object obsolete in emotional or habitual terms.

Possible persistent outcomes:

- Wilson prefers handmade spoon despite finding metal cutlery;
- found pan becomes prized cooking equipment;
- tray becomes project surface rather than food object;
- pot lid becomes shield-like or covering object.

---

# 14. Clothing and wearable debris

The scene catalog already establishes comedic potential for objects Wilson can attempt to wear.

Potential families:

- hat;
- cap;
- bucket-like headwear;
- torn shirt;
- jacket;
- scarf;
- belt;
- glove;
- boot/shoe;
- rain poncho-like sheet;
- life vest;
- goggles;
- mask-like debris;
- helmet;
- absurd hat-shaped debris.

States:

```text
clean
dirty
wet
dry
torn
patched
worn
misworn
```

Potential anchors:

```text
ANCHOR_WEAR_HEAD
ANCHOR_WEAR_BODY
ANCHOR_WEAR_HAND
ANCHOR_WEAR_FOOT
```

Not every object needs to be a formally supported clothing item. Some can merely satisfy a broad `wearable_like` exploration affordance.

---

# 15. Footwear

Footwear has unusually high narrative potential because it can affect Wilson's silhouette and daily routines.

Possible objects:

- intact shoe pair;
- single shoe;
- boot pair;
- mismatched shoes;
- sandal;
- improvised foot wrap.

States:

```text
dry
wet
worn
damaged
repaired
missing_pair
```

Potential uses:

- clothing;
- container for small objects;
- throwing object;
- animal target;
- joke object when single/mismatched.

Avoid overbuilding equipment stats unless validated later.

---

# 16. Marine safety objects

Potential families:

- life ring;
- life vest;
- buoy;
- float;
- small emergency raft fragment;
- flare casing (visual prop only unless functionality deliberately supported);
- whistle;
- signal mirror;
- waterproof emergency box.

Capabilities:

- floatation;
- wearable;
- throwable;
- highly visible marker;
- signal-related opportunity;
- raft/project component.

A life ring is especially reusable:

```text
float
seat-like object
rollable-ish
throwable target
wall decoration
animal obstacle
```

---

# 17. Furniture fragments

Potential found pieces:

- chair seat;
- chair leg;
- small stool;
- table plank;
- drawer;
- cabinet door;
- shelf;
- bed frame fragment;
- mattress/cushion fragment.

Functions:

- immediate comfort;
- material salvage;
- repair candidate;
- work surface;
- shelter component;
- sentimental or absurd decoration.

An intact chair washing ashore late in a run can be comically significant if Wilson has spent weeks improving a crude stool.

---

# 18. Sports objects

Sports objects are excellent rare-object candidates because their recognizable shape implies unexpected physics.

Potential families:

- bowling ball;
- soccer ball;
- basketball-like ball;
- tennis ball;
- golf ball;
- baseball;
- bat;
- racket;
- frisbee;
- skateboard-like board;
- dumbbell;
- exercise weight plate.

Shared capability variety:

```text
rollable
bouncy
throwable
heavy
impact-capable
flat/board-like
swingable
```

Examples:

```text
bowling ball → heavy impact / rolling hazard
soccer ball → lightweight rolling distraction
frisbee → throwable / plate-like / animal attraction
bat → club / lever / pole-like material
weight plate → heavy flat weight
```

Rare objects should create new combinations, not require bespoke minigames.

---

# 19. Toys and leisure objects

Potential candidates:

- rubber duck;
- toy boat;
- doll;
- stuffed toy;
- yo-yo;
- kite fragment;
- playing cards;
- dice;
- chess/checker piece;
- beach bucket;
- plastic shovel;
- toy shovel;
- toy dinosaur;
- wind-up toy.

Potential value:

- decoration;
- curiosity;
- habit/preference;
- player-Wilson running gag;
- throwable/lightweight physics;
- container/tool misuse;
- sentimental attachment.

A useless object can still become high-value content if Wilson develops a relationship with it.

---

# 20. Office / industrial absurdities

A few mundane out-of-place objects can strongly reinforce shipwrecked surrealism.

Potential rare objects:

- stapler;
- clipboard;
- desk lamp body;
- keyboard;
- mouse;
- calculator;
- wrench;
- hard hat;
- safety cone;
- measuring tape;
- toolbox;
- paint can;
- brush;
- bucket;
- small sign;
- rubber mallet.

The key is physical reuse:

```text
clipboard → flat surface / fan / paddle experiment
safety cone → hat-like / funnel-like / marker
keyboard → absurd object / panel / breakable plastic source
hard hat → wearable / bowl-like / rain protection
```

Avoid contemporary branded detail.

---

# 21. Signs, labels and symbol-bearing objects

Potential families:

- warning sign;
- direction sign;
- ship placard;
- number plate;
- cargo stencil panel;
- buoy marking;
- generic printed board.

Uses:

- decoration;
- marker;
- project panel;
- shelter patch;
- player-arranged message-like patterns;
- Wilson superstition/interpretation.

Text should be minimal or abstract enough to avoid localization dependence unless deliberately authored.

---

# 22. Reflective objects

Potential families:

- mirror shard;
- polished metal plate;
- compact mirror;
- shiny lid;
- reflective emergency panel.

Functions:

- visual novelty;
- Wilson inspecting appearance;
- signal experiment;
- light reflection if supported;
- player-arranged oddity.

A mirror-like object also supports the scene variation where Wilson is encouraged to inspect absurd headwear.

---

# 23. Sound-producing objects

Potential families:

- bell;
- metal pan;
- bottle;
- whistle;
- hollow pipe;
- can with loose contents;
- small radio shell / dead device;
- chime-like debris.

Capabilities:

```text
strikeable
shakeable
blowable
sound-producing
animal-attracting/scaring candidate
marker/alarm candidate
```

Sound objects could become habits, experiments or primitive alarms.

---

# 24. Dead electronics and devices

Potential objects:

- dead radio;
- flashlight;
- camera;
- phone-like device;
- watch;
- small fan;
- alarm clock;
- GPS-like unit.

States:

```text
intact
wet
damaged
opened
disassembled
repurposed
```

Important boundary:

Do not imply functional electricity unless simulation deliberately supports it.

Even dead devices can provide:

- reflective pieces;
- glass;
- casing;
- wire;
- screws/fittings;
- curiosity;
- ritual/sentimental behavior.

---

# 25. Books, papers and maps

Potential families:

- notebook;
- book;
- magazine-like object;
- waterproof map;
- paper sheet;
- shipping manifest;
- label bundle.

States:

```text
dry
wet
warped
torn
burned
annotated (if authored)
```

Functions:

- hint/event content;
- tinder;
- wrapping;
- decoration;
- ritual/reading behavior;
- map-like planning prop.

Avoid turning every readable object into mandatory narrative exposition.

---

# 26. Umbrellas and parasols

Potential states:

```text
closed
open
broken
inverted
patched
```

Capabilities:

- rain cover;
- shade;
- wind hazard;
- carried object;
- shelter attachment;
- absurd sailing/drag experiment.

This is a good example of a rare object that creates several emergent physical scenes with minimal special content.

---

# 27. Buckets, cones and funnel-like objects

A reusable broad family can cover several found shapes.

Potential objects:

- bucket;
- pail;
- safety cone;
- funnel;
- lampshade;
- large cup/container.

Shared opportunities:

```text
container
headwear-like
rain collector
pouring aid
marker
sand scoop
cover
```

The same physical grammar can generate intentionally silly experiments.

---

# 28. Boards and flat panels

Potential found variants:

- surfboard-like board;
- door panel;
- signboard;
- tray;
- sheet metal;
- cabinet door;
- skateboard deck.

Capabilities:

- flat surface;
- bridge/plank;
- sled-like experiment;
- raft component;
- wind screen;
- table surface;
- carried shield-like cover;
- slope sliding hazard.

Flat panels are high-value because they compose easily with many projects.

---

# 29. Tubes, pipes and hollow cylinders

Potential families:

- short pipe;
- long pipe;
- hose fragment;
- tube;
- hollow bamboo-like manufactured piece;
- snorkel-like object.

Functions:

- conduit;
- handle;
- lever;
- blow tube experiment;
- sound object;
- structural member;
- water routing component;
- storage for narrow items.

If fluid routing is not implemented, the shape can remain useful structurally without requiring simulation depth.

---

# 30. Hooks, rings and attachment hardware

Potential salvage:

- hook;
- carabiner-like clip;
- ring;
- eye bolt;
- pulley;
- cleat;
- hinge;
- clamp.

These are valuable as modular attachment language for advanced projects.

Potential sockets:

```text
SOCKET_HOOK
SOCKET_RING
SOCKET_LINE
SOCKET_HINGE
```

They can visually explain why later constructions are more sophisticated than early rope-only assemblies.

---

# 31. Heavy absurd objects

Potential rare candidates:

- bowling ball;
- dumbbell;
- small safe;
- engine part;
- anchor piece;
- large gear;
- weight plate;
- dense metal block.

Shared properties:

```text
very_heavy
impact-capable
weight/ballast
hard_to_carry
rollable? (some)
```

Potential uses:

- crushing;
- anchoring;
- ballast;
- holding down cloth;
- testing structures;
- accidental injury;
- slope comedy.

Heavy-object comedy should arise from consistent physics expectations.

---

# 32. Lightweight wind-sensitive debris

Potential candidates:

- paper;
- cloth;
- plastic-like sheet;
- hat;
- empty box;
- umbrella;
- inflatable object;
- foam panel.

States:

```text
grounded
loose
wind-blown
caught
wet/heavy
```

Functions:

- environmental animation;
- chase scenes;
- accidental relocation;
- shelter material;
- animal interaction.

This gives weather a way to rearrange meaningful objects without requiring destruction.

---

# 33. Floating debris family

Potential examples:

- plank;
- coconut;
- bottle;
- barrel;
- crate fragment;
- buoy;
- foam object;
- life ring;
- toy boat.

Shared states:

```text
floating
grounded
beached
waterlogged
sunk (where appropriate)
```

Floating behavior supports:

- wash-up events;
- retrieval;
- loss at sea;
- raft experiments;
- tide-dependent object movement.

---

# 34. Rare-object arrival grammar

Rather than hand-authoring each arrival scene, a general washed-up object event can vary by:

```text
object family
arrival location
condition
container contents
rarity
Wilson familiarity
physical capability novelty
```

Possible arrival conditions:

```text
ordinary tide
post-storm debris
large-wave event
floating object visible offshore
partially buried object
object tangled in vegetation
```

The important design question is not only "what object arrived?" but "what existing capabilities does it unexpectedly unlock?"

---

# 35. Object condition progression

Found objects can share a compact condition vocabulary.

```text
new-ish
weathered
rusted/faded
wet
waterlogged
dirty
dented
cracked
torn
broken
repaired
repurposed
```

Condition should affect silhouette or large material blocks where gameplay needs to read it.

Avoid cosmetic micro-damage systems with no player-visible consequence.

---

# 36. Repurposing as visible history

Repurposed found objects should remain visually identifiable.

Examples:

```text
metal sign
→ shelter wall patch

life ring
→ raft float

suitcase
→ permanent food storage

umbrella
→ rain-catch component

bucket
→ water vessel

chair fragment
→ workbench brace

hard hat
→ bowl / rain collector / wearable
```

The joke and narrative value come from still recognizing the original object.

---

# 37. Rare-object preference and superstition

A rare object can become important without superior mechanics.

Potential persistent roles:

```text
favorite possession
lucky object
unlucky object
ritual location marker
trusted tool
hated object
decoration
player-associated object
```

Examples:

- bowling ball becomes Wilson's preferred impact tool after one spectacular success;
- a broken compass becomes a lucky charm;
- a metal box becomes hated after repeated failed opening attempts;
- a rubber duck becomes inexplicably protected from player rearrangement.

These roles should use existing memory/preference systems rather than bespoke object AI.

---

# 38. Found-object storage pressure

Rare objects create a useful camp-development problem: where does Wilson put all this junk?

Potential visual evolution:

```text
random debris pile
→ sorted material piles
→ shelves/racks
→ special-object display area
→ organized salvage corner
```

This can make long-lived camps visually richer without requiring traditional inventory UI exposure.

---

# 39. Display and trophy objects

Potential infrastructure:

- shelf;
- display plank;
- hanging hook;
- wall peg;
- pedestal rock;
- trophy pole;
- special crate.

Possible displayed objects:

- favorite tool;
- rare shell;
- bizarre washed-up object;
- Gerald-related trophy attempt;
- player-associated object;
- repaired relic.

This supports Wilson assigning meaning to objects beyond utility.

---

# 40. Interaction anchors for found objects

A common optional anchor vocabulary could include:

```text
ANCHOR_APPROACH
ANCHOR_INSPECT
ANCHOR_PICKUP
ANCHOR_CARRY
ANCHOR_OPEN
ANCHOR_HIT
ANCHOR_PRY
ANCHOR_PUSH
ANCHOR_PULL
ANCHOR_ROLL
ANCHOR_WEAR
ANCHOR_POUR
ANCHOR_ATTACH
```

Not every family requires every anchor. Variants within a family should maintain stable contracts when claiming the same capability.

---

# 41. Absurd-object selection criteria

A rare absurd object is especially valuable if it scores well on several dimensions:

1. recognizable silhouette;
2. mechanically distinct physical property;
3. can participate in existing verbs;
4. can be repurposed visibly;
5. supports slapstick or unexpected utility;
6. can become a persistent possession;
7. cheap enough to model in the project's low-poly language.

High-value examples:

- bowling ball;
- umbrella;
- safety cone;
- life ring;
- hard hat;
- rubber duck;
- dumbbell;
- surfboard-like panel;
- suitcase;
- metal pot lid;
- mirror shard;
- traffic/sign panel;
- mannequin head/torso fragment if tone review approves.

The last category should be used carefully to avoid pushing the tone toward horror.

---

# 42. Suggested rarity tiers

## Common salvage

- planks;
- rope;
- cloth;
- bottles;
- crates;
- simple metal scraps;
- buckets;
- domestic utensils.

## Uncommon found objects

- suitcase;
- pot/pan;
- intact tool;
- life ring;
- umbrella;
- mirror;
- intact chair;
- fishing net.

## Rare memorable objects

- bowling ball;
- sports equipment;
- rubber duck/toy;
- hard hat;
- safety cone;
- dead electronics;
- weird signage;
- unusual luggage;
- dumbbell/weight;
- absurd wearable debris.

## Very rare authored curiosities

Objects with special visual identity but still grounded in existing capabilities.

These should be few enough to feel memorable.

---

# 43. Candidate generator families

Potential Blender/toolkit generators emerging from this round:

```text
create_crate
create_barrel
create_bottle
create_metal_scrap
create_cloth_sheet
create_rope_coil
create_net
create_luggage
create_domestic_utensil
create_wearable
create_ball
create_flat_panel
create_pipe
create_hook_hardware
create_sign
create_debris_cluster
create_shipwreck_section
create_salvage_socket_cluster
```

Some rare objects may be manual or semi-manual, but should still reuse shared materials and primitive helpers.

---

# 44. Round 5 consolidation

The core grammar introduced here is:

```text
ordinary physical capability
+ unusual recognizable object
= emergent comedy opportunity
```

Found objects should expand the possibility space without creating a parallel bespoke interaction system.

A long-lived island should gradually accumulate visible evidence of salvage:

```text
wreck
→ stripped wreck

beach
→ found debris

camp
→ sorted salvage
→ reused components
→ odd possessions
→ repaired/improved projects
```

This strongly supports the project's principle that history becomes scenery.

---

# 45. Questions to revisit after later rounds

- How many rare objects should exist in the initial content set?
- Should rare-object arrival be globally bounded to avoid visual clutter?
- Which modern materials are allowed by the tone/world fiction?
- How much realistic buoyancy/rolling physics is desirable versus authored approximation?
- When should a found object gain persistent identity/history?
- How should salvage depletion interact with offline simulation?
- Which found objects require unique animations versus generic semantic interactions?
- Should Wilson automatically sort salvage, or should organization emerge only after repeated clutter problems?
