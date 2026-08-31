# Production Catalog — Entity Families

This file is the consolidated production backlog for physical entity families.

See [`PRODUCTION_CATALOG.md`](PRODUCTION_CATALOG.md) for column semantics and status rules.

## Foundational natural/material entities

| Status | Pri | Family / intended content ID | Domain mapping | Core properties | True capabilities | Derived affordances | Visual states / required contrasts | Relations / composition | Interactions / scene value | Art contract / reference |
|---|---|---|---|---|---|---|---|---|---|---|
| TODO | P0 | `stone_small` / pebble family | EntityDefinition | low mass/bulk; high hardness | graspable; receives_impact; impact_surface | one-hand carry; throw; stack | dry/wet; round/angular/flat | on_top_of support/ground | throw, test, marker, impact experiment | Ref 02; procedural rock grammar |
| TODO | P0 | `rock_medium` | EntityDefinition | medium mass; high hardness; high stability | receives_impact; impact_surface | push/limited drag depending size | dry/wet; broad silhouette variants | on_top_of ground | impact tool candidate, obstacle, landmark support | Ref 01/02; procedural |
| TODO | P0 | `flat_rock` | EntityDefinition | high stability; broad top surface | sittable; work_surface; receives_impact | place items on top | dry/wet; clean/occupied presentation | on_top_of(item, rock) | Good Chair, prep/work surface | Ref 02/03; procedural family variant |
| TODO | P0 | `branch_small` | EntityDefinition | low-medium mass; medium rigidity; flammable | graspable; fuel; structural_member | one-hand carry; throw; stack | fresh/dry/wet/broken/charred | part_of tree when attached | fuel, poke, tool/material candidate | Ref 02/04; procedural |
| TODO | P0 | `log_short` | EntityDefinition | medium-high mass; rigid; flammable | structural_member; fuel; sittable | two-hand carry/drag/roll depending profile | fresh/dry/wet/burned | on_top_of ground; part_of project | seat, construction, fuel | Ref 03/06; procedural |
| TODO | P0 | `log_long` | EntityDefinition | high mass/bulk; rigid; flammable | structural_member | two-hand carry; drag; roll | fresh/dry/wet/damaged | part_of structure/raft | beams, raft, bridge, cargo | Ref 06/12; procedural |
| TODO | P0 | `palm_frond` | EntityDefinition | low mass; flexible; absorbent; flammable | covering; fuel | carry; drag; stack | fresh/dry/wet/fallen/damaged | attached_to palm or project | roofing, bedding, storm opportunity | Ref 02/08; procedural |
| TODO | P0 | `fiber_vine` | EntityDefinition | low mass; flexible; variable binding integrity | binding_component; graspable | carry; coil; hang | fresh/dry/wet/frayed | attached_to components | bindings, repair, rope precursor | Ref 01/05; procedural |
| TODO | P0 | `rope` | EntityDefinition | flexible; medium tensile/binding integrity | binding_component; graspable | carry; hang; coil | intact/frayed/wet/repaired | attached_to; part_of assemblies | tool and structure composition | Ref 05/07; procedural/shared |
| TODO | P0 | `cloth_sheet` / sailcloth | EntityDefinition | low mass; flexible; absorbency/water resistance by profile | covering; graspable | carry; drag; hang | loose vs attached+tensioned; dry/wet/torn/patched | attached_to supports | shelter, rain catch, bedding, wind response | Ref 07/08; authored silhouette + shared material |
| TODO | P0 | `metal_scrap` | EntityDefinition | medium mass; high hardness/rigidity; variable sharpness | receives_impact; cutting_edge or impact_surface by form | carry; place | flat/bent/dented/rusted presentation | part_of repaired objects/tools | salvage, tool-head candidate, repairs | Ref 07; procedural bounded shapes |

## Coconut / food / domestic entities

| Status | Pri | Family / intended content ID | Domain mapping | Core properties | True capabilities | Derived affordances | Visual states / required contrasts | Relations / composition | Interactions / scene value | Art contract / reference |
|---|---|---|---|---|---|---|---|---|---|---|
| TODO | P0 | `coconut_whole` | EntityDefinition | medium mass; break resistance; edible contents | graspable; receives_impact; harvestable | carry; throw; roll | green/mature; whole/opened transform contrast | attached_to palm before harvest | food, water, Scientific Method regression | Ref 02/10; chunky oversized |
| TODO | P0 | `coconut_opened` | EntityDefinition / transformation result | lower integrity; edible/liquid contents | container or liquid_container where form permits; cookable content | carry; place | full/partial/empty | inside(contents, shell) | eat/drink; shell reuse | Ref 10; preserve visual ancestry |
| TODO | P0 | `coconut_shell_bowl` | EntityDefinition / repurposed result | low-medium mass; rigid | container; graspable | carry; place | empty/full; dry/wet | inside(food/liquid, shell) | routine object, food prep | Ref 03/10 |
| TODO | P0 | `fruit_generic` | EntityDefinition family | low mass; freshness; softness | graspable; harvestable; cookable | carry; throw | unripe/ripe/overripe/spoiled; whole/cut | attached_to plant before harvest | Breakfast First, animal attraction | Ref 02; low-detail palette states |
| TODO | P0 | `fish_small_medium` | EntityDefinition family | low-medium mass; freshness | graspable; cookable | carry | alive/dead/cleaned/raw/cooked/spoiled | inside container; on drying rack | fishing/food/preservation | Ref 03/11; simple family |
| TODO | P0 | `food_piece_generic` | EntityDefinition/presentation family | freshness; cooking progress | cookable; graspable where chunk form | carry/place | raw/prepared/cooked/burned/spoiled | inside bowl/pot; on_top_of surface | generic meal presentation | Ref 03/04 |
| TODO | P0 | `bowl` | EntityDefinition | low mass; rigid | container; graspable | carry; place | empty/full; dry/wet | inside(food/liquid, bowl) | eat/prep/routine | Ref 03/10 |
| TODO | P0 | `cup` | EntityDefinition | low mass | liquid_container; graspable | one-hand carry | empty/full; dry/wet | inside(liquid, cup) | drink/routine | Ref 03/10 |
| TODO | P0 | `pot` | EntityDefinition | medium mass; heat resistance | container; cookable-host / cooking participant | carry when empty/light | empty/full; cold/hot; clean/dirty | inside(food, pot); attached/on support | cooking | Ref 03/11 |
| TODO | P0 | `spoon_utensil` | EntityDefinition | very low mass; rigid | graspable | carry; place | clean/dirty; intact/broken | on_top_of cooking surface | Missing Spoon, eating routine | Ref 03; intentionally readable oversized form |
| TODO | P0 | `food_skewer` | EntityDefinition / assembly | low mass; rigidity; heat resistance | graspable; cookable | carry; place | raw/cooked/burned | part_of food+stick assembly | cooking | Ref 03/11 |

## Containers and storage entities

| Status | Pri | Family | Domain mapping | Core properties | True capabilities | Derived affordances | Visual states / regression contrasts | Relations / composition | Interactions / scene value | Reference |
|---|---|---|---|---|---|---|---|---|---|---|
| TODO | P0 | `ship_crate` | EntityDefinition | medium mass/bulk; rigid; capacity class | container; work_surface; receives_impact | push/drag; sit depending dimensions | closed/open/broken/repaired; empty/full | inside(contents, crate); on_top_of items | opening, storage, seat/table, salvage | Ref 03/07/10 |
| TODO | P0 | `basket_small` | EntityDefinition | low mass; flexible-ish; capacity class | container; graspable | carry; hang | empty/full; intact/damaged | inside(contents); attached_to hanging support | food/material storage | Ref 10 |
| TODO | P0 | `water_container_basic` | EntityDefinition | base mass + contents-derived effective mass; capacity | liquid_container; container | carry empty/partial; push when heavy | empty vs water-filled mandatory regression | inside(liquid, host) | rain catch, storage, weight change | Ref 10 |
| TODO | P0 | `bottle_jar` | EntityDefinition family | low mass; rigidity; transparency varies | container; liquid_container; graspable | carry | transparent vs opaque; sealed/open; empty/full | inside(contents) | perception/exploration regression | Ref 07/10 |
| TODO | P0 | `sealed_metal_container` | EntityDefinition | medium mass; high hardness/resistance; sealed | container; receives_impact | carry/drag depending size | sealed/dented/opened | part_of lid; inside(contents) | Scientific Method | Ref 07/10; asset-specific brief recommended |
| TODO | P1 | `barrel_drum` | EntityDefinition | high bulk; effective mass from contents; buoyancy profile | container; liquid_container; receives_impact | roll/push; carry only when light | empty vs water-filled mandatory regression; intact/dented | inside(contents) | storage, hazard, raft float | Ref 07/10/12 |
| TODO | P1 | `storage_box_secured` | EntityDefinition | medium bulk; capacity; closure integrity | container | push/drag | open/closed/secured/damaged/repaired | inside(contents) | animal-resistant storage | Ref 10 |
| TODO | P1 | `bucket` | EntityDefinition | low-medium mass; capacity | liquid_container; container; graspable | carry | empty/full/damaged/patched | inside(contents) | water/wash/salvage | Ref 10/11 |

## Tool components and assembled tools

| Status | Pri | Family | Domain mapping | Core properties | True capabilities | Derived affordances | Visual states / contrasts | Relations / composition | Interactions / scene value | Reference |
|---|---|---|---|---|---|---|---|---|---|---|
| TODO | P0 | `tool_handle` | EntityDefinition / component | rigidity; length; integrity | graspable; structural_member | carry | short/medium/long; intact/cracked/replaced | part_of assembled tool | shared tool grammar | Ref 05 |
| TODO | P0 | `tool_head_sharp_stone` | EntityDefinition / component | hardness HIGH; sharpness HIGH | cutting_edge; receives_impact | carry | intact/chipped/dull | part_of assembled tool | knife/hatchet/piercing | Ref 05 |
| TODO | P0 | `tool_head_heavy_stone` | EntityDefinition / component | high hardness/mass | impact_surface; receives_impact | carry | intact/chipped | part_of assembled tool | hammer/crushing | Ref 05 |
| TODO | P0 | `binding_tool` | EntityDefinition / component | binding_integrity; flexibility | binding_component | — | tight vs loose/repaired mandatory regression | attached_to head+handle; part_of tool | tool effective-profile regression | Ref 05 |
| TODO | P0 | `tool_improvised_knife` | EntityDefinition / semantic assembly | effective sharpness/integrity from components | graspable; cutting_edge | carry | improvised/stabilized/repaired/upgraded | part_of components | cut/prep/experiment | Ref 05; assembly family |
| TODO | P0 | `tool_improvised_hatchet` | EntityDefinition / assembly | effective impact+sharpness | graspable; cutting_edge; impact_surface | carry | binding/handle/head condition variants | part_of components | chop/cut | Ref 05 |
| TODO | P0 | `tool_improvised_hammer` | EntityDefinition / assembly | effective mass/hardness/binding integrity | graspable; impact_surface | carry | tight vs loose binding; repaired handle | part_of components | construction, Scientific Method | Ref 05 |
| TODO | P0 | `digging_stick` | EntityDefinition | low-medium mass; rigidity | graspable | carry | intact/worn/broken | — | dig/probe | Ref 05 |

## Salvage / rare identity entities

| Status | Pri | Family | Domain mapping | Core properties | True capabilities | Derived affordances | Visual states | Relations / composition | Interaction / narrative value | Reference |
|---|---|---|---|---|---|---|---|---|---|---|
| TODO | P0 | `shipwreck_structural_section` | EntityDefinition | very high bulk; wood/metal profile | structural_member; climbable where authored | — | intact/partially salvaged/skeletal | part_of wreck landmark | opening geography, salvage history | Ref 07; hybrid/manual |
| TODO | P1 | `suitcase_luggage` | EntityDefinition | medium bulk; closure/capacity | container | carry/drag | closed/open/damaged/reused | inside(contents) | storage, found-object identity | Ref 07 |
| TODO | P1 | `sign_panel` | EntityDefinition | low-medium mass; rigid | covering or structural_member by configuration | carry; place | intact/weathered/damaged | attached_to structure | shelter/fence patch, marker | Ref 07 |
| TODO | P1 | `buoy_life_ring` | EntityDefinition | low-medium mass; high buoyancy | graspable | carry; float | intact/weathered | attached_to raft/structure | salvage, flotation, decoration | Ref 07/12 |
| TODO | P1 | `umbrella_found` | EntityDefinition | low mass; deployable covering form | graspable; covering | carry | open/closed/damaged | held_by; attached_to collector config | rain opportunity/comedy | Ref 07 |
| TODO | P1 | `sports_ball_generic` | EntityDefinition family | mass/rigidity/bounce profile varies | graspable; receives_impact | roll/throw | intact/damaged | — | leisure/physics | Ref 07 |
| TODO | P1 | `bowling_ball_rare` | EntityDefinition | very high effective mass for hand size; hard; rigid | graspable; impact_surface; receives_impact | two-hand carry; roll; ordinary throw usually unavailable | intact/scuffed only broad accents | — | Perfectly Good Bowling Ball regression | Ref 07; manual hero silhouette |

## Comfort / personal props

| Status | Pri | Family | Domain mapping | Core properties | True capabilities | Derived affordances | Visual states | Relations / composition | Interaction / narrative value | Reference |
|---|---|---|---|---|---|---|---|---|---|---|
| TODO | P0 | `stool_crude` | EntityDefinition | high stability | sittable | carry if light; place | intact/wobbly/repaired | on_top_of ground | Good Chair comparison | Ref 03 |
| TODO | P1 | `bench_simple` | EntityDefinition | stable; medium bulk | sittable | drag | intact/repaired | — | comfort/routine | Ref 03 |
| TODO | P1 | `sleeping_mat` | EntityDefinition | flexible; low mass; absorbency | sleepable | carry/roll | dry/wet/soaked/drying | on_top_of shelter floor | sleep/comfort/weather | Ref 08/09 |
| TODO | P1 | `hammock` | EntityDefinition / configured assembly | flexibility; support integrity | sleepable | — | installed/loose/damaged/repaired | attached_to two supports | comfort/favorite location | family brief recommended |
| TODO | P1 | `display_shelf` | EntityDefinition | stable; rigid | work_surface | place objects | intact/repaired | on_top_of(collection items) | collection/history presentation | Ref 03/11 |

## Production notes

- A row identifies a **semantic/art family**, not necessarily one GLB.
- Prefer generator variants for families whose silhouette can remain inside one grammar.
- Create asset-specific briefs for `sealed_metal_container`, rare hero salvage and any entity whose internal parts/transformations are gameplay-significant.
- Do not mark a family `APPROVED` merely because one variant exists if required regression contrasts in the row are still missing.
