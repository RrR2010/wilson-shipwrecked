# Production Catalog — Projects & Structures

This is the operational backlog for persistent composed projects and structures. See [`README.md`](README.md) for status and column semantics.

A project row normally maps to `ProjectDefinition` plus one or more world `EntityDefinition` components. Project lifecycle and world-component truth remain distinct.

## Shelter / camp projects

| Status | Pri | Project family | Domain mapping | Required world components | Relevant properties / capabilities | Required visual lifecycle | Relations / composition | Generic interactions / scene value | Reference |
|---|---|---|---|---|---|---|---|---|---|
| TODO | P0 | `project.shelter_basic` | ProjectDefinition + structural entities | stakes, posts, beams, braces, bindings, roof/thatch or cloth, floor/support pieces | structural_integrity; binding_integrity; covering; structural_member; sleepable when functional | marked → frame_partial → frame_complete → roof_partial → basic_complete; damaged → repaired/reinforced | part_of components; attached_to bindings/panels | build, add material, repair, sleep; One More Piece | Ref 06; asset-specific family brief required |
| TODO | P1 | `project.shelter_improvement` | ProjectDefinition | wall panels, extension posts/beams, storage adjacency, porch/platform | covering; structural_member; work_surface where added | base shelter → enclosure/extension → modified long-lived shelter | part_of; attached_to; on_top_of contents | comfort/weather improvement; history becomes scenery | Ref 06 |
| TODO | P1 | `project.covered_cooking_area` | ProjectDefinition | posts, roof/cloth, fire/cooking components, prep surface | covering; work_surface; heat-safe placement | marked → supports → partial cover → functional | attached_to roof; arranged around fire | cooking/weather routines | Ref 06/11 |
| TODO | P1 | `project.workshop_area` | ProjectDefinition | workbench, tool rack, material stacks, optional canopy | work_surface; covering optional | crude surface → workbench → organized/covered area | on_top_of tools; attached_to rack | work/crafting routines | Ref 11 |
| TODO | P1 | `project.storage_shed` | ProjectDefinition | frame, roof, walls, shelves/containers | covering; structural_member; container hosts | frame → roof → enclosed/organized | inside storage entities; part_of structural components | storage protection/history | Ref 06/10/11 |

## Fire / food / water utility projects

| Status | Pri | Project family | Domain mapping | Required components | Properties / capabilities | Required visual lifecycle | Relations / composition | Scene value | Reference |
|---|---|---|---|---|---|---|---|---|---|
| TODO | P0 | `project.fire_site` | ProjectDefinition + fire-site entities/process | ground site, stone ring, fuel/kindling | impact-resistant stones; fuel/tinder; fire process host | empty/prepared → unlit → lit → smoking/embers/extinguished/ash | on_top_of fuel at site | light, add fuel, cook, warm, inspect; Traitorous Fire | Ref 03/08/11 |
| TODO | P0 | `project.drying_rack_basic` | ProjectDefinition | posts, beam, bindings, hang points | structural_member | marked → frame → functional → damaged/repaired | attached_to food/material items | dry/preserve food; weather interactions | Ref 11 |
| TODO | P0 | `project.rain_catch_basic` | ProjectDefinition/configuration | cloth/catch surface, supports, liquid container | covering; liquid_container host | loose parts → tensioned catch → functional; storm damage | attached_to cloth/supports; container below | collect rain; configuration regression | Ref 10/11 |
| TODO | P1 | `project.water_station` | ProjectDefinition | vessel stand, containers, wash/prep surface, drainage | liquid_container; work_surface | crude vessel → stand → organized station → drainage improvement | on_top_of containers; inside liquid; attached_to accessories | drink/refill/wash/routine | Ref 10/11 |
| TODO | P1 | `project.smoking_preservation_rack` | ProjectDefinition | rack, cover/smoke relationship, hanging food | structural_member; covering | rack → covered/smoke-capable → damaged/repaired | attached_to food; arranged near smoke source | preserve food | Ref 11 |

## Storage / protection projects

| Status | Pri | Project family | Domain mapping | Components | Properties / capabilities | Visual lifecycle | Relations / composition | Scene value | Reference |
|---|---|---|---|---|---|---|---|---|---|
| TODO | P0 | `project.food_storage_basic` | ProjectDefinition/configuration | crate/basket/container + stable placement | container | exposed pile → containerized → covered/raised | inside food; on_top_of raised support | Breakfast First; animal conflict | Ref 10 |
| TODO | P1 | `project.raised_storage` | ProjectDefinition | posts, shelf/platform, containers | structural_member; work_surface/container hosts | ground storage → raised → secured | on_top_of containers; attached_to support | reduce animal access | Ref 10/11 |
| TODO | P1 | `project.hanging_storage` | ProjectDefinition/configuration | support frame, rope, basket/container | binding_component; container | basic frame → hanging functional → repaired | attached_to basket/support | animal protection, organization | Ref 10/11 |
| TODO | P1 | `project.food_barrier` | ProjectDefinition/configuration | stones/branches/posts/panels | structural_member / blocking geometry | improvised → reinforced/damaged | attached_to/part_of where assembled | Gerald conflict; emergent physical protection | Ref 10 |

## Transport / crossing / shore projects

| Status | Pri | Project family | Domain mapping | Components | Properties / capabilities | Visual lifecycle | Relations / composition | Scene value | Reference |
|---|---|---|---|---|---|---|---|---|---|
| TODO | P1 | `project.raft_basic` | ProjectDefinition + composite world entity | logs/planks, lashings, optional float/cargo elements | structural_member; binding_component; buoyancy-effective profile | materials_staged → tied_bundle → basic raft → improved/cargo; damaged/repaired | part_of components; attached_to lashings/cargo | board, load, move, repair | Ref 12; family brief required |
| TODO | P1 | `project.dock_basic` | ProjectDefinition + structural entities | shore posts, deck planks, bindings, mooring post | structural_member; work_surface | landing markers → short dock → improved/repaired | part_of deck/supports; connects shore/water access when semantically required | board/moor/access shore | Ref 12 |
| TODO | P1 | `project.bridge_basic` | ProjectDefinition | logs/planks, supports, optional rope | structural_member | stepping support → plank bridge → reinforced | part_of components; connects stable places if required | crossing/navigation | Ref 12 |
| TODO | P1 | `project.cargo_sled` | ProjectDefinition or composite EntityDefinition | runners/frame, rope/tie-down | structural_member; binding_component | frame → functional → repaired | part_of components; attached_to cargo | drag heavy materials | Ref 12 |
| DEFERRED | P2 | `project.canoe_boat` | ProjectDefinition/composite entity | authored hull + paddle/accessories | buoyancy; cargo support as applicable | build/repair variants TBD | part_of components | future transport | defer |
| DEFERRED | P2 | `project.cart` | ProjectDefinition/composite entity | frame/wheels/handles | structural_member | staged → complete → damaged/repaired | part_of | future bulk transport | defer |

## Navigation / infrastructure / garden

| Status | Pri | Project family | Domain mapping | Components | Core semantics | Visual lifecycle | Relations / scene value | Reference |
|---|---|---|---|---|---|---|---|---|
| TODO | P1 | `project.fence_gate` | ProjectDefinition | posts, rails/branches, bindings, gate | structural_member; blocking from geometry/configuration | partial → complete → damaged/repaired | part_of; attached_to; route shaping | Ref 06/11 |
| TODO | P1 | `project.windbreak` | ProjectDefinition | posts + cloth/panels/fronds | covering; structural_member | partial → functional → storm damaged | attached_to covering/supports | Ref 06/08 |
| TODO | P1 | `project.canopy` | ProjectDefinition | supports, bindings, covering | covering | frame → partial cover → functional → damaged | attached_to; shade/work extension | Ref 06/11 |
| TODO | P1 | `project.ladder` | ProjectDefinition or composite EntityDefinition | rails/rungs/bindings | climbable; structural_member | basic → repaired/reinforced | part_of components; attached_to host | Ref 06 |
| TODO | P1 | `project.route_marker` | ProjectDefinition or simple entity arrangement | posts/stones/sign panel | landmark semantics | simple → weathered/repaired | attached_to signs; on_top_of ground | Ref 07/12 |
| TODO | P1 | `project.cultivated_plot` | ProjectDefinition + PlaceState/presentation | soil plot, markers, planted entities | harvestable entities; soil properties | marked → cultivated → planted → growing/harvested | plot-associated plants; food routine | Ref 02 |
| TODO | P1 | `project.trellis` | ProjectDefinition | posts, cross-members, bindings | structural_member; plant support | frame → plant-occupied → damaged/repaired | attached_to plant/supports | Ref 11 |
| TODO | P1 | `project.drainage` | ProjectDefinition + PlaceState/presentation | trench/channel presentation, optional supports | terrain/environment response | marked → dug → functional → eroded/repaired | affects place/environment semantics | Ref 08/11 |
| DEFERRED | P2 | `project.lookout` | ProjectDefinition | posts, platform, ladder, braces | climbable; work_surface; structural_member | frame → platform → complete → damage | long-run landmark | defer |
| DEFERRED | P2 | `project.signal_beacon` | ProjectDefinition | platform/fire/signaling parts | structural_member; fire host | staged → functional | future directed opportunity | defer |

## Project acceptance rule

A project is not `APPROVED` until required structural families are approved or explicitly temporary, required lifecycle states read from gameplay camera, damage/repair history remains legible, component interchangeability is preserved, construction does not rely on textures, and partial stages look intentionally incomplete.