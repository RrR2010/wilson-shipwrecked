# Asset Catalog Difficulty Index

This is a derived production aid, not a new catalog source of truth.

Use it to route simple rows to `GPT-5.4 mini`, routine modular rows to `MiMo V2.5`, and the hardest rows to `GPT-5.6 Luna` or `DeepSeek V4 Pro`.

## Tier guide

- `Low` - simple primitives, shared materials, mostly procedural output.
- `Medium` - modular or stateful assets with one or two readable attachments or closures.
- `High` - hybrid/authored, landmark, recognition-critical, multi-part, or adapter-heavy assets.

When a `High` row is especially distinctive or scene-defining, start with `GPT-5.6 Luna` or `DeepSeek V4 Pro` rather than the lighter models.

---

## Low

### Entities

- `stone_small`
- `rock_medium`
- `flat_rock`
- `branch_small`
- `log_short`
- `log_long`
- `stake_wood`
- `post_wood`
- `pole_wood`
- `beam_wood`
- `plank_wood`
- `brace_wood`
- `palm_frond`
- `fiber_vine`
- `rope`
- `tinder_bundle`
- `metal_scrap`
- `coconut_whole`
- `coconut_shell_half`
- `coconut_meat_piece`
- `water_fresh`
- `fruit_generic`
- `mushroom_generic`
- `fish_food_small_medium`
- `food_piece_generic`
- `bowl`
- `cup`
- `spoon_utensil`
- `food_skewer`
- `ship_crate`
- `basket_small`
- `bucket`
- `tool_handle_prepared`
- `tool_head_sharp_stone`
- `tool_head_heavy_stone`
- `digging_stick`
- `sign_panel`
- `pipe_salvage`
- `sports_ball_generic`
- `garment_cloth_basic`
- `shell_decorative`
- `stool_crude`
- `bench_simple`
- `sleeping_mat`
- `route_marker`
- `decorative_arrangement`

### Living world

- `terrain.sand`
- `terrain.mud_patch`
- `terrain.puddle`
- `shoreline.shallow_water_edge`
- `terrain.soil_plot`
- `terrain.path_worn`
- `terrain.dig_site`
- `terrain.shallow_hole`
- `plant.ground_cluster`
- `plant.fiber_patch`
- `plant.seaweed`
- `plant.sapling_generic`
- `habitat.crab_burrow`
- `habitat.bird_nest`
- `habitat.rock_crevice`
- `habitat.forage_patch`
- `animal.shellfish_generic`

### Projects

- `project.route_marker`

## Medium

### Entities

- `thatch_bundle`
- `thatch_panel`
- `cloth_sheet` / sailcloth
- `pot`
- `cooking_grate_support`
- `water_container_basic`
- `bottle_jar`
- `sealed_metal_container`
- `barrel_drum`
- `storage_box_secured`
- `net_salvage`
- `suitcase_luggage`
- `buoy_life_ring`
- `umbrella_found`
- `display_shelf`

### Living world

- `place.tide_pool`
- `plant.fruit_bush`
- `animal.crab_generic`
- `animal.fish_small`

### Projects

- `project.work_surface_basic`
- `project.tool_rack_basic`
- `project.clothesline`
- `project.drying_rack_basic`
- `project.fire_site`
- `project.water_station`
- `project.smoking_preservation_rack`
- `project.food_storage_basic`
- `project.raised_storage`
- `project.hanging_storage`
- `project.food_barrier`
- `project.fence_gate`
- `project.windbreak`
- `project.canopy`
- `project.ladder`
- `project.cultivated_plot`
- `project.trellis`

## High

### Entities

- `tool_improvised_knife`
- `tool_improvised_hatchet`
- `tool_improvised_hammer`
- `shipwreck_structural_section`
- `hammock`
- `hatlike_salvage`
- `bowling_ball_rare`

### Living world

- `plant.palm_coconut`
- `animal.crab_recurring`
- `animal.bird_simple`
- `directed.distant_human_contact`
- `place.neighbor_islet`

### Projects

- `project.shelter_basic`
- `project.shelter_improvement`
- `project.covered_cooking_area`
- `project.workshop_area`
- `project.storage_shed`
- `project.rain_catch_basic`
- `project.raft_basic`
- `project.dock_basic`
- `project.bridge_basic`
- `project.cargo_sled`
- `project.drainage`
- `project.lookout`
- `project.signal_beacon`
- `project.canoe_boat`
- `project.cart`

---

## Notes

- `Low` and most `Medium` rows are good candidates for the lighter models.
- `High` rows are where stronger models pay off most, especially when the asset must read clearly at gameplay distance and still support adapters, multiple states, or a recognizable silhouette.
- Deferred rows stay classified by likely production difficulty, even if they are not the next build priority.
