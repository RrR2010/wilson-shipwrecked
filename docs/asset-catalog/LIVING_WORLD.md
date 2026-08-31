# Asset Catalog — Living World

This is the operational content/model backlog for place/terrain presentation, flora, fauna and habitat families. It also records **cross-family environmental presentation requirements** that must be produced but must not become fake entity types.

See [`README.md`](README.md) for semantic tokens, authority boundaries, `Spec`, production status and priority.

A living-world row may map to an `EntityDefinition`, `ActorProfileDefinition`, `PlaceDefinition`, or explicitly to a **PlaceState/presentation family**. Presentation-only rows are valid when they describe reusable authored geometry/visual vocabulary; they must state that mapping instead of masquerading as world entities.

---

## Terrain and place presentation

| Status | Spec | Pri | Family | Domain mapping | Authoritative / derived semantics | Lifecycle / environment / evidence | Interactions / coverage | Art / production |
|---|---|---:|---|---|---|---|---|---|
| TODO | ALIGNED | P0 | `terrain.sand` | `PlaceDefinition` / terrain presentation family | prop: support/surface form; place dryness/moisture where gameplay needs it; ordinary spatial support, not an entity capability | band: dry/damp/wet and disturbed surface; env: rain/tide/wind may alter local presentation; evidence: footprints/disturbance only where simulation actually preserves them | act: traverse, place, dig where local predicates allow; scene: navigation, ordinary placement, Faster Than Walking slope context | Ref 02; procedural terrain grammar |
| TODO | ALIGNED | P0 | `terrain.mud_patch` | `PlaceState` / presentation family, **not an entity type** | prop: local moisture/softness/slipperiness semantics only where authoritative traversal rules need them | band: forming/wet/muddy/drying; env: rain/drying; evidence: visually legible wet/soft surface | act: traverse; scene: rain aftermath, changed route risk | Ref 08; procedural patch/decal-free geometry where possible |
| TODO | ALIGNED | P0 | `terrain.puddle` | `PlaceState` / shallow-water presentation, **not an entity type** | authoritative shallow-water presence/extent at a place; no universal `puddle_state` object | band: forming/full/draining; env: rain/evaporation/drainage | act: traverse/inspect; scene: weather aftermath, minor obstacle/opportunity | Ref 08; procedural shallow geometry |
| TODO | ALIGNED | P0 | `shoreline.shallow_water_edge` | `PlaceDefinition` / aquatic-edge presentation | place categories/properties represent shallow water and shoreline traversal context | band: calm/disturbed/rain/tide presentation; env: wave/tide processes may move ordinary loose entities | act: wade/traverse, collect washed-up entities; scene: shore resource/discovery | Ref 02; procedural shoreline grammar |
| TODO | ALIGNED | P0 | `place.tide_pool` | `PlaceDefinition` + aquatic presentation | stable semantic place/habitat location; local traversal/hazard/resource context belongs to place/world properties, not Wilson fear state | band: calm/disturbed, water-level/occupancy presentation as needed; evidence: persistent recognizable geography supports Wilson place history | act: approach/traverse/inspect/forage; scene: Long Way Around, Gerald geography | Ref 02; authored/procedural recognizable landmark variants |
| TODO | ALIGNED | P1 | `terrain.soil_plot` | stable `PlaceDefinition`; mutable surface condition in `PlaceState` | prop: soil moisture/fertility only if cultivation rules consume them; plot identity may bind to a project/place | band: dry/damp/cultivated/depleted; env: rain/drying/growth context | act: dig/cultivate/plant; project: `project.cultivated_plot` | Ref 02; procedural patch |
| TODO | ALIGNED | P1 | `terrain.path_worn` | `PlaceState` / presentation projection, **not an independent place/entity by default** | repeated traversal/history may produce a bounded world/place presentation mutation when persistence is desired | band: faint/established/worn; no Wilson habit or preference stored here | act: traverse; scene: routines/history becomes scenery | Ref 02; procedural path dressing |
| TODO | ALIGNED | P1 | `terrain.dig_site` | `PlaceState` / presentation associated with grounded digging/project outcomes | authoritative disturbed/excavated ground geometry/state; buried contents remain ordinary entities/relations | band: untouched/marked/disturbed/excavated/filled; env: rain may flood/soften | act: dig, inspect, fill; project: cultivation/drainage/construction | Ref 02/11; procedural staged geometry |
| TODO | ALIGNED | P1 | `terrain.shallow_hole` | `PlaceState` / hazard geometry presentation | authoritative local depression/obstruction geometry; hazard is contextual and may produce `HazardProjection`, not a `hole_hazard` entity | band: open/partially filled/flooded; env: rain/fill/erosion | act: traverse/fill; scene: Victory Lap secondary accident | Ref 08; procedural |

---

## Plant families

| Status | Spec | Pri | Family | Domain / material | Physical semantics | Composition / regions | Lifecycle / environment / evidence | Actions / coverage | Art / production |
|---|---|---:|---|---|---|---|---|---|---|
| TODO | ALIGNED | P0 | `plant.palm_coconut` | `EntityDefinition`; mat: wood/plant matter profile | prop: rigidity, structural integrity, size/mass profile, growth/fruit quantity where modeled; cap: `harvestable`, `climbable`, `perchable` where adapter/geometry supports | rel: coconuts `attached_to` palm; fronds `part_of`/`attached_to`; region: fruit cluster, trunk/chop target, optional climb/perch regions | band: young/mature/fruiting/partially harvested/damaged/felled/stump/dead where authoritative causes justify; env: storm weakening, wind, moisture; `DynamicProcessState` for committed falling palm; detached fronds/coconuts become ordinary entities; evidence: cracks/lean/damage must be perceivable before/while hazard escalates when scene requires | act: inspect, harvest, climb, hit/chop; scene: Falling Palm, resource landmark, route geography | Ref 02/08; procedural family with strong silhouette; stable fruit/perch/interaction adapters |
| TODO | ALIGNED | P0 | `plant.ground_cluster` | **presentation-only vegetation family by default; no `EntityDefinition`** | visual density/readability only; if a future variant becomes harvestable or otherwise interactive, give that gameplay content its own explicit entity row/ID | visual variants may show healthy/dry/storm-disturbed vegetation, but no persistent simulation state is implied by this dressing row | scene: island visual density and resource readability around real interactive families | Ref 02; procedural dressing grammar; do not register needless runtime entities |
| TODO | ALIGNED | P1 | `plant.fruit_bush` | `EntityDefinition`; mat: plant matter | prop: growth/resource quantity, integrity; cap: `harvestable`; fruit may be separate attached entities when individual manipulation/history is needed | rel: fruit `attached_to` bush; region: fruit cluster | band: juvenile/mature/fruiting/harvested/recovering/damaged/dead; env: growth/regrowth/weather | act: inspect/harvest; project: food routine/cultivation | Ref 02; procedural family |
| TODO | ALIGNED | P1 | `plant.fiber_patch` | `EntityDefinition` renewable resource patch | prop: resource quantity/growth; cap: `harvestable`; harvested output becomes `fiber_vine`/compatible fiber content as authored | clustered geometry belongs to this resource entity/family; no separate `cluster` relation required | band: abundant/harvested/sparse/depleted/recovering; env: regrowth/weather | act: harvest/inspect; project: binding/tool/structure supply | Ref 02; procedural |
| TODO | ALIGNED | P1 | `plant.seaweed` | `EntityDefinition` family; mat: plant matter | prop: moisture, flexibility, freshness; cap: `harvestable`; edible variants may become food content and `cookable` after collection | shoreline/aquatic placement | band: fresh/rinsed/dried/spoiled; env: drying/spoilage/wave relocation | act: collect, carry, dry/cook/eat where variant permits | Ref 02; procedural |
| TODO | ALIGNED | P1 | `plant.sapling_generic` | `EntityDefinition`; mat: wood/plant matter | prop: growth, rigidity, integrity; cap: `harvestable` where authored | ordinary world placement; may transform/grow into later family only when content definition admits | band: juvenile/mature/damaged/dead; env: growth/weather damage | act: inspect/harvest; scene: ecological continuity | Ref 02; procedural |

---

## Animals

Non-Wilson animals use shallow `ActorRuntimeState`. Their psychological meaning remains in **Wilson's** beliefs, associations, habits and episodes.

| Status | Spec | Pri | Family | Domain mapping | Actor / physical semantics | Habitat / composition | Lifecycle / evidence | Actions / scene coverage | Art / production |
|---|---|---:|---|---|---|---|---|---|---|
| TODO | ALIGNED | P0 | `animal.crab_generic` | `EntityDefinition` + `ActorProfileDefinition` (`EPISODIC` default) | small autonomous coastal actor; authored shallow activities may include roam, flee, approach food, carry/steal a small compatible entity; ordinary body/entity properties govern movement/manipulation | associated with tide pool/burrow/shore through ordinary place/activity state; stolen item uses ordinary carried/held/spatial truth | states: idle/walk/alert/flee/carry-small-item as presentation projections; no Wilson-level memory; evidence: movement/targeting must be observable enough for attribution | scene: animal conflict, Long Way Around variants, Gerald precursor | simple manual/rigged family; readable claws/carry pose |
| TODO | ALIGNED | P0 | `animal.crab_recurring` | crab `EntityDefinition` grammar + recurring `ActorProfileDefinition` + persistent `EntityId` | no extra psychology system; recurring identity is runtime persistence + recognizable presentation | stable tide-pool geography is ordinary world placement/history, not a `rival` relation | one recognizable variant; repeated appearances preserve identity; evidence: Wilson must be able to distinguish this individual when intended | scene: Gerald, Victory Lap, Gerald Is Missing | manual identifiable variant sharing crab rig/grammar |
| TODO | ALIGNED | P0 | `animal.bird_simple` | `EntityDefinition` + `ActorProfileDefinition` | small flying/perching actor; shallow activities may include fly, perch, ground forage and carry/steal very small compatible items | uses hosts with `cap:perchable` plus presentation adapter/interaction region; nest optional | presentation states: perch/fly/ground/alert/carry; no `perch_socket_vocabulary` world entity | scene: Good Chair ambience, material theft, living island | simplified rigged family; adapters supplied on compatible hosts |
| TODO | ALIGNED | P1 | `animal.fish_small` | `EntityDefinition` + shallow `ActorProfileDefinition` | aquatic actor/resource; ordinary physical identity while alive; capture/death/processing may transform into `fish_food_small_medium` | shallow-water/tide-pool habitats | states: swim/alert/captured as needed; xform: living actor -> non-actor food form through grounded transformation; no single alive/dead/cooked enum spanning actor and food identities | act: observe/catch where future action grammar permits; project: food | simple silhouette family; preserve visual ancestry into food result |
| TODO | ALIGNED | P1 | `animal.shellfish_generic` | non-autonomous `EntityDefinition` resource baseline | coastal edible/resource family; species that require meaningful autonomous movement should receive a separate actor-backed family rather than making this row conditional | tide-pool/shore placement | xform: closed/living resource -> opened/food/shell result only where independent descendant semantics justify it; cooking/freshness stay on food descendants | act: collect/open/cook/eat where applicable | low-cost family; Ref 02/03 |

---

## Habitat families

| Status | Spec | Pri | Family | Domain mapping | Functional semantics | Relations / evidence | Lifecycle / environment | Coverage | Art / production |
|---|---|---:|---|---|---|---|---|---|---|
| TODO | ALIGNED | P0 | `habitat.crab_burrow` | `EntityDefinition` habitat feature | cap: `habitat`; stable local refuge/spawn/activity support for crab behavior | ordinary spatial association with tide-pool/shore; occupancy is actor/world truth, not Wilson knowledge | band: open/occupied presentation/disturbed only where occupancy or damage is perceivable; env: tide/weather presentation | scene: Gerald persistence cues / living geography | Ref 02; procedural small feature |
| TODO | ALIGNED | P1 | `habitat.bird_nest` | `EntityDefinition`; plant/fiber material | cap: `habitat`; ordinary container-like holding only if gameplay genuinely manipulates contents | rel: `attached_to` tree/structure; host must provide compatible attachment adapter | band: empty/occupied/damaged/repaired; stolen/added material history can remain visible through ordinary components where modeled | scene: recurring bird life/material competition | Ref 02; manual/procedural hybrid |
| TODO | ALIGNED | P1 | `habitat.rock_crevice` | `EntityDefinition` habitat feature associated with rock geometry | cap: `habitat`/hide support where actor rules consume it | spatially associated with rock formation; hidden occupants are not automatically perceptible | band: empty/occupied only if visual evidence exists; otherwise occupancy remains hidden world truth | scene: small-fauna hiding/discovery | Ref 02; procedural rock-feature grammar |
| TODO | ALIGNED | P1 | `habitat.forage_patch` | `PlaceDefinition` / resource-location presentation | stable resource-location semantics; actual forage resources remain entities/quantities owned by their families | resources spatially associated with place; Wilson familiarity is cognition, not place state | band: abundant/depleted/recovering only when grounded by resource truth/regrowth | scene: repeated routes/routines | Ref 02; procedural placement grammar |

---

# Cross-family environmental and presentation requirements

The following requirements **replace former fake asset rows**. They are production/runtime contracts over real families, properties, relations and processes. They deliberately do not receive `EntityTypeId`s.

| Pri | Requirement | Owning semantics | Affected real content | Required visible/runtime contrast | Production consequence |
|---:|---|---|---|---|---|
| P0 | Moisture presentation | prop: `moisture` + `EnvironmentalResponseRule`; drying is a process | wood, fiber, cloth, plants, food, terrain and other absorbent materials where visible | dry / damp / wet / soaked, with drying inferred from process + current moisture | shared material/geometry treatment; former `state.wet_material` row removed |
| P0 | Fire-site weather response | fire process + fuel/moisture/burn properties + resolved exposure | `project.fire_site`, `tinder_bundle`, fuel entities, cooking participants | lit / smoking / reduced / embers / extinguished / charred when grounded | shared fire presentation; former `state.fire_site_weather` row removed |
| P0 | Branch/frond detachment | relation mutation (`part_of`/`attached_to` removed) + ordinary entity spatial state; dynamic process if moving hazard spans a boundary | `branch_small`, `palm_frond`, source plant/tree | attached -> falling/moving when applicable -> grounded; fresh/wet/dry afterward | reuse the same entity model; no `opportunity.fallen_branch` or `opportunity.fallen_frond` type |
| P0 | Storm debris arrangement | environmental processes spatially displace ordinary loose entities | branches, fronds, cloth, salvage, containers/contents and other eligible props | coherent mixed displaced/wet/scattered arrangement | procedural **placement generator** may create a cluster presentation; no cluster entity unless later independent lifecycle is proven |
| P0 | Shelter/roof damage readability | component `structural_integrity`, bindings/relations, `AssemblyValidity`, `ProtectionProjection`/gaps | shelter coverings, beams, bindings, panels | intact coverage -> sag/gap/torn/detached -> mismatched repair/reinforcement | damage variants/adapters live on actual components; former `state.roof_damage` row removed |
| P0 | Light-object wind displacement | effective mass + stability + exposure -> environmental/dynamic process -> spatial mutation | cloth, fronds, light containers/props, loose panels where predicates match | stable placement -> shifting/moving -> displaced grounded result | model pivot/collision/readability must support ordinary displacement; former `state.light_prop_displacement` row removed |
| P1 | Fallen-tree outcome | plant/tree integrity + environmental/chop outcome; `DynamicProcessState` while falling; final entity orientation/component results afterward | `plant.palm_coconut`, future tree families, reusable trunk/log outputs | standing -> yielding/falling -> fallen or stump + detached reusable components | no generic `opportunity.fallen_tree` type; preserve reusable trunk/branch pieces where transformation policy creates them |
| P1 | Shore wash-up | wave environmental process moves/creates eligible ordinary salvage/resource entities | bottle, rope, crate fragments/salvage, buoy, rare objects, branches etc. | newly arrived/wet -> weathered/dried through ordinary state | authoring may define wash-up eligibility/placement metadata; former `shoreline.washup_debris` pseudo-family removed |
| P1 | Perch placement adapters | host `cap:perchable` + semantic interaction region/anchor mapped to presentation transform | palms, posts, shelters, rocks and other admitted hosts; `animal.bird_simple` | bird can select a semantic perch and render at a stable compatible pose | adapter vocabulary belongs to asset/runtime contract; former `perch_socket_vocabulary` row removed |
| P2 | Lightning-damage presentation | future grounded environmental effect on integrity/burn properties | trees/structures/objects only if lightning is admitted | struck/charred/broken derived from effects | no `state.lightning_damage` asset family; deferred |
| P2 | Severe erosion presentation | future `PlaceState`/terrain change process | shoreline/slopes/soil | before/eroded/adapted | no independent erosion entity; deferred |

---

## Living-world normalization notes

- `wet`, `fallen`, `displaced`, `leaky`, `storm debris` and `perch socket` are no longer represented as pseudo-entity rows.
- A placement generator or art adapter may be a valid production artifact without becoming a world-domain subject.
- Persistent animal identity is a persistent `EntityId` + shallow actor state. Wilson's affection, rivalry, suspicion or expectations remain cognition/history.
- A hidden habitat occupant or opaque/occluded resource does not become known merely because the world row records it.
- Environmental opportunities should emerge from ordinary entities after world processes mutate their condition/relations/location whenever possible.

---

## Acceptance rule

A living-world family is not production `APPROVED` until applicable requirements are satisfied:

- real entity/place/actor identity is explicit, or the row clearly states presentation-only mapping;
- recurring actors remain recognizable without introducing a second psychology system;
- plant detachments and hazards preserve ordinary component identity/relations;
- terrain presentation does not duplicate Wilson knowledge or project state;
- environmental cross-family contrasts are supplied on the actual affected families;
- interaction-region/art adapters remain separate from domain identity;
- `Spec` and production `Status` are both accurate.
