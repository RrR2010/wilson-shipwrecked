# Artistic Asset Brief Template

## Purpose

Provide the smallest practical task-level specification that connects the functional catalog to visual production.

The brief should be concise enough for repeated agent use while still resolving the artistic decisions that should not be reinvented per asset.

Do not duplicate entire project documents inside a brief. Link to the relevant grammar/reference instead.

---

# 1. Recommended brief

```yaml
asset_id: <stable_asset_id>
family: <family_name>
priority: P0 | P1 | P2
brief_level: grammar_only | family | asset_specific

role:
  - <primary gameplay/visual role>

primary_read: <one short silhouette/function sentence>

references:
  textual:
    - <relevant art/reference document>
  visual:
    - <relevant visual sheet filename if available>

scale:
  approximate_dimensions_m: <x/y/z or useful dimensions>
  compare_against: <Wilson / crate / coconut / etc.>

composition:
  major_parts:
    - <part>
  modular: true | false
  notes: <only if needed>

materials:
  families:
    - <wood / stone / rope / metal / etc.>
  unique_texture_allowed: false
  exceptions: <semantic decal or special functional need, otherwise none>

variants:
  required:
    - <variant>
  optional:
    - <variant>

states:
  required:
    - <state>

anchors:
  required:
    - <semantic anchor if relevant>

sockets:
  required:
    - <semantic socket if relevant>

visual_history:
  persistent_repairs: true | false
  persistent_wear: true | false
  notes: <if relevant>

must_read_from_gameplay_camera:
  - <critical feature>

avoid:
  - <asset-specific visual trap>

review_extras:
  state_strip: true | false
  scale_comparison: true | false
  exploded_view: true | false
  anchor_diagnostic: true | false
```

---

# 2. Grammar-only brief example

```yaml
asset_id: stone_small_01
family: rock_small
priority: P0
brief_level: grammar_only

role:
  - portable stone
  - generic impact object

primary_read: Small chunky irregular stone with a few dominant planes.

references:
  textual:
    - reference/REFERENCE_02_NATURAL_ISLAND_VOCABULARY.md
  visual:
    - reference/visual/REFERENCE_02_NATURAL_ISLAND_VOCABULARY.png

scale:
  approximate_dimensions_m: 0.12 x 0.10 x 0.08
  compare_against: Wilson hand

materials:
  families:
    - stone
  unique_texture_allowed: false

variants:
  required:
    - angular

states:
  required:
    - dry
    - wet

must_read_from_gameplay_camera:
  - broad faceted shape

avoid:
  - tiny facets
  - perfect sphere
```

This is enough because the rock grammar already defines most decisions.

---

# 3. Family brief example

```yaml
asset_id: FAMILY_crude_seating
family: crude_seating
priority: P0
brief_level: family

role:
  - sittable locations
  - preference alternatives

primary_read: Thick simple seating forms built from obvious primitive materials.

references:
  textual:
    - reference/REFERENCE_03_CAMP_PRIMITIVE_PROPS.md
  visual:
    - reference/visual/REFERENCE_03_CAMP_PRIMITIVE_PROPS.png

scale:
  compare_against: Wilson seated mannequin

composition:
  major_parts:
    - support
    - sitting surface
  modular: false

materials:
  families:
    - wood
    - stone
  unique_texture_allowed: false

variants:
  required:
    - log seat
    - stump seat
    - crude stool
    - simple bench

anchors:
  required:
    - ANCHOR_SIT

must_read_from_gameplay_camera:
  - stable seat surface
  - distinct alternatives for preference behavior

avoid:
  - thin furniture proportions
  - ornate joinery
```

Individual stool variants should inherit this family brief rather than each receiving a long independent document.

---

# 4. Asset-specific brief example

```yaml
asset_id: shelter_basic
family: shelter
priority: P0
brief_level: asset_specific

role:
  - weather protection
  - sleep location
  - persistent camp landmark
  - evolving project

primary_read: Compact improvised shelter with a readable tied-pole frame and broad roof mass.

references:
  textual:
    - reference/REFERENCE_06_SHELTER_EVOLUTION.md
    - reference/REFERENCE_08_WEATHER_DAMAGE.md
    - reference/REFERENCE_09_WILSON_SCALE_INTERACTION.md
  visual:
    - reference/visual/REFERENCE_06_SHELTER_EVOLUTION.png
    - reference/visual/REFERENCE_08_WEATHER_DAMAGE.png

scale:
  approximate_dimensions_m: 2.3 x 2.0 x 2.1
  compare_against: Wilson standing and sleeping

composition:
  major_parts:
    - foundation markers
    - posts
    - ridge beam
    - braces
    - bindings
    - roof panels
    - optional wall panels
    - floor/sleeping area
  modular: true

materials:
  families:
    - wood
    - rope_fiber
    - thatch
    - optional salvage cloth
  unique_texture_allowed: false

states:
  required:
    - site_marked
    - partial_frame
    - complete_frame
    - partial_roof
    - basic_complete
    - damaged_roof
    - repaired_patch

anchors:
  required:
    - ANCHOR_APPROACH
    - ANCHOR_BUILD
    - ANCHOR_REPAIR
    - ANCHOR_SLEEP

sockets:
  required:
    - SOCKET_ROOF
    - SOCKET_WALL
    - SOCKET_EXTENSION

visual_history:
  persistent_repairs: true
  persistent_wear: true

must_read_from_gameplay_camera:
  - triangular/roof shelter silhouette
  - visible construction progress
  - repair patches

avoid:
  - monolithic hut mesh
  - dense thatch fibers
  - realistic woven textures

review_extras:
  state_strip: true
  scale_comparison: true
  exploded_view: true
  anchor_diagnostic: true
```

---

# 5. Where briefs should live

Recommended future organization:

```text
docs/art/briefs/
├── families/
│   ├── rocks.md
│   ├── palms.md
│   ├── crude-seating.md
│   └── ...
└── assets/
    ├── shelter-basic.md
    ├── raft-basic.md
    └── ...
```

Do not populate hundreds of briefs in advance.

Create them **just before a production batch** using the functional catalog and approved references.

---

# 6. Brief-generation rule

The functional brainstorming rounds are upstream design evidence.

They answer:

> What kinds of things should exist and what should they be capable of?

The art brief answers:

> What exactly should this production task create while staying inside the approved art system?

Therefore:

- rounds should not be fed alone as modeling instructions;
- family briefs should distill repeated rules;
- asset-specific briefs should exist only where ambiguity/risk warrants them.

This prevents both under-specification and documentation explosion.
