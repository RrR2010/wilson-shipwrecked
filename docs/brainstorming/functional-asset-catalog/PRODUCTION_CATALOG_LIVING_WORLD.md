# Production Catalog — Living World

This file consolidates flora, fauna, habitats, terrain/place presentation and environmental opportunity families.

See [`PRODUCTION_CATALOG.md`](PRODUCTION_CATALOG.md) for status rules and domain-aligned column semantics.

## Terrain / place presentation families

| Status | Pri | Family | Domain mapping | Core properties / semantics | Visual states / contrasts | Relations / configuration | Interaction / scene value | Art strategy / reference |
|---|---|---|---|---|---|---|---|---|
| TODO | P0 | `terrain.sand` | PlaceDefinition / presentation family | support surface; dryness/moisture presentation | dry/wet/disturbed | entities on spatial surface | baseline navigation/placement | Ref 02; broad flat-color masses |
| TODO | P0 | `terrain.mud_patch` | PlaceState/presentation | moisture/high softness/slower traversal as runtime derives | wet/muddy/drying | spatial condition | rain aftermath, tracks | Ref 08 |
| TODO | P0 | `terrain.puddle` | PlaceState/presentation | shallow water presence | forming/full/draining | spatial condition | weather opportunity/hazard | Ref 08 |
| TODO | P0 | `shoreline.shallow_water_edge` | PlaceDefinition/presentation | shallow aquatic edge | calm/rain/tide presentation | spatial relation to beach | wash-up events, wading | Ref 02 |
| TODO | P0 | `place.tide_pool` | PlaceDefinition + aquatic presentation | habitat/resource/location semantics | calm/disturbed; occupancy variants | contains/hosts fauna where applicable | Long Way Around, Gerald geography | Ref 02 |
| TODO | P1 | `terrain.soil_plot` | PlaceDefinition/State | moisture/fertility authored later | dry/damp/cultivated/depleted | supports planted entities | cultivation | Ref 02 |
| TODO | P1 | `terrain.path_worn` | PlaceState/presentation | traversal-history presentation | faint/established/worn | derived from repeated movement/history | history becomes scenery | Ref 02 |
| TODO | P1 | `terrain.dig_site` | PlaceState/presentation | disturbed/excavated ground | untouched/marked/disturbed/excavated/filled | spatial relation to project/contents | digging, projects, hazards | Ref 02/11 |
| TODO | P1 | `terrain.shallow_hole` | PlaceState/presentation | depression/hazard geometry | open/filled/flooded | spatial condition | Victory Lap/fall opportunities | Ref 08 |

## Palm / plant families

| Status | Pri | Family | Domain mapping | Core properties | True capabilities | Derived affordances / responses | Required states | Relations / composition | Interaction / scene value | Reference |
|---|---|---|---|---|---|---|---|---|---|---|
| TODO | P0 | `plant.palm_coconut` | EntityDefinition | rigidity/integrity; growth/fruit state | harvestable; climbable; habitat/perch support as authored | chop/harvest; storm damage response | young/mature/fruiting/partially harvested/damaged/felled/stump/dead | fruit attached_to palm; fronds part_of/attached_to | landmark, resource, shade, route geography | Ref 02 |
| TODO | P0 | `plant.ground_cluster` | EntityDefinition family | low mass/bulk; flexible | harvestable only on resource variants | trample/wind response if modeled | healthy/dry/damaged variants | clustered placement | visual fill without grass carpet | Ref 02 |
| TODO | P1 | `plant.fruit_bush` | EntityDefinition family | freshness/fruit quantity/growth | harvestable; habitat optional | harvest/regrow | juvenile/mature/fruiting/harvested/recovering/damaged/dead | fruit attached_to plant | renewable food | Ref 02 |
| TODO | P1 | `plant.fiber_patch` | EntityDefinition/Place-associated resource family | resource abundance/growth | harvestable | collect/regrow | abundant/harvested/sparse/depleted/recovering | clustered placement | renewable fiber | Ref 02 |
| TODO | P1 | `plant.seaweed` | EntityDefinition family | moisture/flexibility/freshness | harvestable; cookable on edible variants | collect/dry | fresh/rinsed/dried/spoiled | shoreline/aquatic placement | food/material candidate | Ref 02 |
| TODO | P1 | `plant.sapling_generic` | EntityDefinition | growth/integrity | harvestable where appropriate | environmental damage | sapling/juvenile/mature/damaged/dead | world placement | ecological continuity | Ref 02 |

## Animal families

| Status | Pri | Family | Domain mapping | Core authored semantics | Behavior capabilities | Required visual variants/states | Habitat / relations | Interaction / narrative value | Art strategy / reference |
|---|---|---|---|---|---|---|---|---|---|
| TODO | P0 | `animal.crab_generic` | EntityDefinition + ActorProfileDefinition | small coastal actor; episodic by default | roam; approach food; flee; pinch/steal only if domain catalog admits behavior semantics | idle/walk/alert/carry-small-item as needed; small body variants | tide pool/burrow habitat | animal conflict, Long Way Around | simple manual/rigged family; Ref 02/09 scale |
| TODO | P0 | `animal.crab_recurring` / Gerald presentation | EntityDefinition + recurring ActorProfile | persistent EntityId presentation; visually distinguishable but same physical grammar | same shallow behavior family; recurrence | one recognizable variant, not extravagant hero complexity | stable relation to tide-pool geography as runtime history emerges | Gerald/Victory Lap | manual identifiable variant; no extra cognition system |
| TODO | P0 | `animal.bird_simple` | EntityDefinition + ActorProfileDefinition | small flying/perching actor | roam/fly/perch; investigate lightweight/food objects if admitted | perch/fly/ground states | attached/perched via perch locations | ambient life, Good Chair, material theft opportunity | simplified rigged family |
| TODO | P1 | `animal.fish_small` | EntityDefinition + ActorProfileDefinition or resource representation | aquatic actor/resource | swim/flee as required | alive/dead/food transformation states | shallow water/tide/shore habitats | fishing/food | simple silhouettes |
| TODO | P1 | `animal.shellfish_generic` | EntityDefinition or shallow actor | coastal edible/resource family | minimal locomotion if needed | alive/opened/cooked/shell remains | tide pools/shore | food/resource | low-cost family |

## Habitat / ecological support entities

| Status | Pri | Family | Domain mapping | Core properties / capabilities | Visual states | Relations / configuration | Interaction / narrative value | Reference |
|---|---|---|---|---|---|---|---|---|
| TODO | P0 | `habitat.crab_burrow` | EntityDefinition / Place-associated habitat | habitat | open/occupied/disturbed | near/at tide pool geography; occupancy derived/runtime-specific | animal persistence cues | Ref 02 |
| TODO | P0 | `perch_socket_vocabulary` | Art/runtime adapter contract; domain behavior uses suitable host capability/configuration | perchable on host where authored | n/a | art socket on palm/post/shelter/rock variants | reusable bird placement | Ref 02; not a world entity itself |
| TODO | P1 | `habitat.bird_nest` | EntityDefinition | habitat; container-like contents only if domain explicitly supports | empty/occupied/damaged/repaired/material-theft history | attached_to tree/structure | construction-material competition, recurring life | Ref 02 |
| TODO | P1 | `habitat.rock_crevice` | EntityDefinition/Place feature | habitat/hide support | empty/occupied | spatial/host relation | small fauna hiding | Ref 02 |
| TODO | P1 | `habitat.forage_patch` | PlaceDefinition/presentation | resource-location semantics | abundant/depleted/recovering | place-associated resources | repeated routes/routines | Ref 02 |

## Environmental opportunity / damage families

| Status | Pri | Family | Domain mapping | Underlying semantics | Required visual bands | Generic causes / responses | Scene value | Reference |
|---|---|---|---|---|---|---|---|---|
| TODO | P0 | `state.wet_material` | presentation band over entity properties/processes | moisture | dry/wet/soaked/drying | rain/exposure/drying process | broad weather readability | Ref 04/08 |
| TODO | P0 | `state.fire_site_weather` | entity/process presentation | burn/fuel/moisture | lit/smoking/extinguished/embers/charred | rain, fuel consumption | Traitorous Fire/weather | Ref 08 |
| TODO | P0 | `opportunity.fallen_branch` | EntityDefinition instance/state outcome | branch integrity/detachment | fresh fallen/dry/wet | storm/tree damage | obstacle + resource | Ref 08 |
| TODO | P0 | `opportunity.fallen_frond` | EntityDefinition instance/state outcome | frond detachment | fresh/wet/dry | storm/palm damage | roofing/fuel/bedding opportunity | Ref 08 |
| TODO | P0 | `opportunity.storm_debris_cluster` | presentation/composed entity cluster | displaced loose objects | dry/wet/mixed | wind/waves/storm | cleanup, salvage | Ref 08; procedural cluster |
| TODO | P0 | `state.roof_damage` | project/world component presentation | structural_integrity / attachment condition | intact/leaky/torn/missing/repaired/reinforced | storm/rain/repair | visible shelter history | Ref 06/08 |
| TODO | P0 | `state.light_prop_displacement` | runtime transform + presentation | low stability/effective mass | normal/displaced | wind | environmental causality | Ref 08 |
| TODO | P1 | `opportunity.fallen_tree` | entity state/transformation outcome | structural_integrity | standing/damaged/fallen/stump | storm/chop | resource/obstacle/bridge candidate | Ref 02/08 |
| TODO | P1 | `shoreline.washup_debris` | entity placement/opportunity | buoyancy/effective mass/world process | freshly washed-up/weathered | wave_washing_object process | discovery/salvage | Ref 07/08 |
| DEFERRED | P2 | `state.lightning_damage` | presentation over authoritative effects | integrity/burn | struck/charred/broken | lightning process future | rare weather history | Ref 08 |
| DEFERRED | P2 | `terrain.severe_erosion` | PlaceState/presentation | terrain change | before/eroded/repair adaptation | severe weather future | long-run environmental history | Ref 08 |

## Living-world acceptance rule

A living-world family is not `APPROVED` until:

1. it reads clearly at gameplay distance without texture dependence;
2. state changes use broad silhouette/color/material differences where possible;
3. ecological variants do not multiply unique mesh families unnecessarily;
4. recurring animals remain visually recognizable without requiring Wilson-level complexity;
5. habitat art sockets are separated conceptually from domain relations/capabilities;
6. terrain/place presentation does not accidentally become a duplicate gameplay state model.
