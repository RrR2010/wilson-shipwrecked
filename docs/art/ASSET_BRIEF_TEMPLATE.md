# Artistic Brief Template

## Purpose

An art brief is an optional **visual refinement** of a cross-cutting asset-catalog entry.

It exists only when `docs/asset-catalog/` + approved art references do not resolve an artistic ambiguity. It must not become a second source for functional requirements.

Do **not** duplicate into an art brief:

- domain identity;
- capabilities/properties;
- required gameplay interactions;
- project semantics;
- authoritative state definitions;
- anchor/socket requirements already defined by the cross-cutting catalog or `ASSET_SPEC.md`.

Link to the catalog row and record only visual decisions that are genuinely task-specific.

## Minimal template

```yaml
catalog_entry: <asset/family id from docs/asset-catalog>
brief_level: family_art | asset_art

primary_read: <one short silhouette/function-visible sentence>

references:
  textual:
    - <relevant docs/art/reference file>
  visual:
    - <relevant approved sheet>

visual_scale:
  compare_against: <Wilson / crate / coconut / sibling asset>
  exaggeration_notes: <only if catalog/runtime dimensions need artistic readability guidance>

shape_constraints:
  dominant_forms:
    - <form>
  required_visible_connections:
    - <connection if relevant>
  asymmetry_or_variation_bounds: <optional>

materials:
  preferred_roles:
    - <wood / stone / rope / metal / etc.>
  unique_texture_allowed: false
  exceptions: <semantic decal/special shader only if justified>

visible_state_notes:
  - <only how a catalog-required state should read visually>

must_read_from_gameplay_camera:
  - <critical visual feature>

avoid:
  - <task-specific visual trap>

review_extras:
  state_strip: true | false
  scale_comparison: true | false
  exploded_view: true | false
  anchor_diagnostic: true | false
```

Fields that add no information beyond the catalog/reference should be omitted.

## When no brief is needed

Do not create a brief for a simple variant when the catalog row + reference grammar already specify enough information.

Typical no-brief examples:

```text
rock variant
simple log
plank
rope coil
coconut variant
basic bowl
```

The task may simply name the catalog entry and requested variant/seed.

## Family art brief

Use when several catalog entries share a visual rule not already cleanly expressed by an approved reference.

Examples:

- bounded silhouette variation among generated rocks;
- allowed trunk/crown proportion ranges for palms;
- shared visual joinery language for a seating family.

A family art brief must not redefine the functional family taxonomy.

## Asset-specific art brief

Use rarely, for assets with unusual visual risk or identity:

- Wilson final character design;
- distinctive recurring animal if required;
- rare hero salvage;
- a landmark whose exact silhouette needs explicit approval.

Large projects such as shelter/raft/dock do **not** automatically require a separate art brief if the cross-cutting project catalog + project reference sheet already resolve their visual construction.

## Example

```yaml
catalog_entry: tool_improvised_hammer
brief_level: asset_art

primary_read: Thick wooden handle, oversized heavy stone head and one broad readable binding zone.

references:
  textual:
    - reference/REFERENCE_05_TOOL_GRAMMAR.md
  visual:
    - reference/visual/REFERENCE_05_TOOL_GRAMMAR.png

visual_scale:
  compare_against: Wilson hand
  exaggeration_notes: Head should read clearly at gameplay distance without becoming comedic unless the catalog variant says so.

shape_constraints:
  dominant_forms:
    - thick faceted handle
    - chunky low-plane stone head
  required_visible_connections:
    - binding must visibly explain head-to-handle attachment

materials:
  preferred_roles:
    - wood
    - stone
    - fiber
  unique_texture_allowed: false

visible_state_notes:
  - Loose/repaired binding should change the broad binding silhouette, not rely on tiny fray texture.

must_read_from_gameplay_camera:
  - head mass
  - grip direction
  - binding connection

avoid:
  - thin realistic handle
  - tiny rope strands
  - many random stone facets

review_extras:
  state_strip: true
  scale_comparison: true
  exploded_view: false
  anchor_diagnostic: false
```

## Storage recommendation

If briefs become necessary:

```text
docs/art/briefs/
├── families/
└── assets/
```

Create them just-in-time. Do not pre-author hundreds of art briefs.

## Rule

```text
Asset Catalog
  = what the model is and must support across concerns

Art references
  = shared visual language

Art brief
  = exceptional task-specific visual clarification
```

If an art brief starts restating the asset catalog, delete the duplicated fields rather than maintaining both.