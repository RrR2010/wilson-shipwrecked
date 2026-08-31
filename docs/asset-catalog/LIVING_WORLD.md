# Asset Catalog — Living World

This is the operational model/content backlog for terrain/place presentation, flora, fauna, habitats and environmental opportunity families. See [`README.md`](README.md) for ownership, status and column semantics.

## Terrain / place presentation

| Status | Pri | Family | Domain mapping | Core semantics | Visual states / contrasts | Relations / configuration | Scene value | Reference |
|---|---|---|---|---|---|---|---|---|
| TODO | P0 | `terrain.sand` | PlaceDefinition / presentation family | support surface; dryness/moisture presentation | dry/wet/disturbed | entities on spatial surface | navigation/placement | Ref 02 |
| TODO | P0 | `terrain.mud_patch` | PlaceState/presentation | moisture/high softness | wet/muddy/drying | spatial condition | rain aftermath, tracks | Ref 08 |
| TODO | P0 | `terrain.puddle` | PlaceState/presentation | shallow water presence | forming/full/draining | spatial condition | weather opportunity/hazard | Ref 08 |
| TODO | P0 | `shoreline.shallow_water_edge` | PlaceDefinition/presentation | shallow aquatic edge | calm/rain/tide presentation | spatial relation to beach | wash-up, wading | Ref 02 |
| TODO | P0 | `place.tide_pool` | PlaceDefinition + aquatic presentation | habitat/resource/location semantics | calm/disturbed; occupancy variants | hosts fauna where applicable | Long Way Around, Gerald geography | Ref 02 |
| TODO | P1 | `terrain.soil_plot` | PlaceDefinition/State | soil moisture/fertility | dry/damp/cultivated/depleted | supports planted entities | cultivation | Ref 02 |
| TODO | P1 | `terrain.path_worn` | PlaceState/presentation | traversal-history presentation | faint/established/worn | derived from repeated movement/history | history becomes scenery | Ref 02 |
| TODO | P1 | `terrain.dig_site` | PlaceState/presentation | disturbed/excavated ground | untouched/marked/disturbed/excavated/filled | project/contents spatial relation | digging/projects | Ref 02/11 |
| TODO | P1 | `terrain.shallow_hole` | PlaceState/presentation | depression/hazard geometry | open/filled/flooded | spatial condition | fall/opportunity scenes | Ref 08 |

## Plant families

| Status | Pri | Family | Domain mapping | Core properties | True capabilities | Derived responses | Required states | Relations / composition | Scene value | Reference |
|---|---|---|---|---|---|---|---|---|---|---|
| TODO | P0 | `plant.palm_coconut` | EntityDefinition | rigidity/integrity; growth/fruit state | harvestable; climbable; habitat/perch support when authored | chop/harvest; storm damage | young/mature/fruiting/partially harvested/damaged/felled/stump/dead | fruit attached_to palm; fronds part_of/attached_to | landmark, resource, route geography | Ref 02 |
| TODO | P0 | `plant.ground_cluster` | EntityDefinition family | low mass/bulk; flexible | harvestable only on resource variants | trample/wind response if modeled | healthy/dry/damaged | clustered placement | visual fill | Ref 02 |
| TODO | P1 | `plant.fruit_bush` | EntityDefinition family | freshness/fruit quantity/growth | harvestable; habitat optional | harvest/regrow | juvenile/mature/fruiting/harvested/recovering/damaged/dead | fruit attached_to plant | renewable food | Ref 02 |
| TODO | P1 | `plant.fiber_patch` | EntityDefinition/Place-associated resource | resource abundance/growth | harvestable | collect/regrow | abundant/harvested/sparse/depleted/recovering | clustered placement | renewable fiber | Ref 02 |
| TODO | P1 | `plant.seaweed` | EntityDefinition family | moisture/flexibility/freshness | harvestable; cookable on edible variants | collect/dry | fresh/rinsed/dried/spoiled | shoreline/aquatic placement | food/material | Ref 02 |
| TODO | P1 | `plant.sapling_generic` | EntityDefinition | growth/integrity | harvestable where appropriate | environmental damage | sapling/juvenile/mature/damaged/dead | world placement | ecological continuity | Ref 02 |

## Animals and habitats

| Status | Pri | Family | Domain mapping | Core authored semantics | Required visual states | Habitat / relations | Scene value | Art strategy |
|---|---|---|---|---|---|---|---|---|
| TODO | P0 | `animal.crab_generic` | EntityDefinition + ActorProfileDefinition | small coastal actor; episodic by default | idle/walk/alert/carry-small-item as needed | tide pool/burrow | animal conflict, Long Way Around | simple manual/rigged family |
| TODO | P0 | `animal.crab_recurring` / Gerald presentation | EntityDefinition + recurring ActorProfile | persistent EntityId presentation; visually distinguishable within same physical grammar | one recognizable variant | stable tide-pool geography as runtime history emerges | Gerald/Victory Lap | manual identifiable variant; no extra cognition system |
| TODO | P0 | `animal.bird_simple` | EntityDefinition + ActorProfileDefinition | small flying/perching actor | perch/fly/ground states | perch locations on suitable hosts | ambient life, Good Chair, material theft | simplified rigged family |
| TODO | P1 | `animal.fish_small` | EntityDefinition + ActorProfileDefinition or resource representation | aquatic actor/resource | alive/dead/food transform | shallow-water habitats | fishing/food | simple silhouettes |
| TODO | P1 | `animal.shellfish_generic` | EntityDefinition or shallow actor | coastal edible/resource family | alive/opened/cooked/shell remains | tide pools/shore | food/resource | low-cost family |
| TODO | P0 | `habitat.crab_burrow` | EntityDefinition / Place-associated habitat | habitat | open/occupied/disturbed | tide-pool geography | persistence cues | Ref 02 |
| TODO | P0 | `perch_socket_vocabulary` | Art/runtime adapter contract | host placement contract, not world entity | n/a | art sockets on palms/posts/shelters/rocks | reusable bird placement | Ref 02 |
| TODO | P1 | `habitat.bird_nest` | EntityDefinition | habitat | empty/occupied/damaged/repaired/material-theft history | attached_to tree/structure | recurring life/material competition | Ref 02 |
| TODO | P1 | `habitat.rock_crevice` | EntityDefinition/Place feature | habitat/hide support | empty/occupied | host/spatial relation | small-fauna hiding | Ref 02 |
| TODO | P1 | `habitat.forage_patch` | PlaceDefinition/presentation | resource-location semantics | abundant/depleted/recovering | place-associated resources | repeated routes/routines | Ref 02 |

## Environmental opportunity / damage

| Status | Pri | Family | Domain mapping | Underlying semantics | Required visual bands | Generic cause | Scene value | Reference |
|---|---|---|---|---|---|---|---|---|
| TODO | P0 | `state.wet_material` | presentation band over properties/processes | moisture | dry/wet/soaked/drying | rain/exposure/drying | weather readability | Ref 04/08 |
| TODO | P0 | `state.fire_site_weather` | entity/process presentation | burn/fuel/moisture | lit/smoking/extinguished/embers/charred | rain/fuel consumption | Traitorous Fire | Ref 08 |
| TODO | P0 | `opportunity.fallen_branch` | EntityDefinition instance/state outcome | branch integrity/detachment | fresh fallen/dry/wet | storm/tree damage | obstacle + resource | Ref 08 |
| TODO | P0 | `opportunity.fallen_frond` | EntityDefinition instance/state outcome | frond detachment | fresh/wet/dry | storm/palm damage | roofing/fuel/bedding opportunity | Ref 08 |
| TODO | P0 | `opportunity.storm_debris_cluster` | presentation/composed cluster | displaced loose objects | dry/wet/mixed | wind/waves/storm | cleanup/salvage | Ref 08 |
| TODO | P0 | `state.roof_damage` | project/world component presentation | structural_integrity / attachment condition | intact/leaky/torn/missing/repaired/reinforced | storm/rain/repair | shelter history | Ref 06/08 |
| TODO | P0 | `state.light_prop_displacement` | runtime transform + presentation | low stability/effective mass | normal/displaced | wind | environmental causality | Ref 08 |
| TODO | P1 | `opportunity.fallen_tree` | entity state/transformation outcome | structural_integrity | standing/damaged/fallen/stump | storm/chop | resource/obstacle/bridge candidate | Ref 02/08 |
| TODO | P1 | `shoreline.washup_debris` | entity placement/opportunity | buoyancy/effective mass/world process | fresh/weathered | wave process | discovery/salvage | Ref 07/08 |
| DEFERRED | P2 | `state.lightning_damage` | presentation over authoritative effects | integrity/burn | struck/charred/broken | future lightning process | rare history | Ref 08 |
| DEFERRED | P2 | `terrain.severe_erosion` | PlaceState/presentation | terrain change | before/eroded/adapted | severe weather | long-run history | Ref 08 |

## Acceptance rule

A living-world family is not `APPROVED` until it satisfies its functional/content expectations and applicable visual/runtime contracts. Art sockets remain distinct from domain semantics, and terrain presentation must not become a duplicate gameplay-state model.