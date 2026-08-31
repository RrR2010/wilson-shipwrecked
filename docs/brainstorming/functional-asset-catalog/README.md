# Functional Asset Catalog Brainstorming

## Purpose

This directory preserves the exploratory rounds that produced the initial breadth of modeled-world content.

It is **not** the operational asset backlog and should not become the long-term source of truth for individual modeled assets.

The cross-cutting catalog derived from this work now lives in:

```text
../../asset-catalog/
```

That catalog is where future agents should consolidate functional, artistic and production requirements for actual models.

## Exploratory source layer

Rounds 1–9 explore breadth: object families, visual states, reusable parts, interaction ideas, construction vocabulary, weather responses, domestic props, salvage, fauna, comfort objects and long-run procedural opportunities.

They are intentionally exploratory. They are **not** a gameplay schema and should not be translated mechanically into enums, capabilities, state machines, recipes or classes.

Round 10 normalizes terminology from the earlier rounds against the functional domain model.

```text
Rounds 1–9
  brainstorming breadth / production possibilities

ROUND_10_DOMAIN_NORMALIZATION.md
  property vs capability vs derived affordance vs metadata

../../asset-catalog/
  cross-cutting modeled-asset source of truth / backlog

../../DOMAIN_MODEL.md
../../DOMAIN_VOCABULARY.md
../../DOMAIN_CATALOGS.md
  canonical domain semantics
```

## Reading rule

When a Round 1–9 term conflicts with canonical vocabulary, treat the round term as descriptive shorthand.

Examples:

```text
heavy
  → property.mass_class

throwable
  → capability or derived affordance according to canonical content/domain semantics

wet / soaked
  → usually presentation bands over moisture/environmental process

unexplored / inspected
  → Wilson-relative evidence/belief/history, not physical entity state

favorite / personal
  → association + habit + history, not physical capability
```

## Procedural-content rule

Prefer new content through recombination:

```text
material
+ properties
+ capabilities
+ condition
+ assembly/components
+ world relations
+ contents
+ interaction regions
+ evidence accessibility
+ environmental response
```

before introducing entity-specific mechanics.

## Cheap regression contrasts

The following remain useful evidence when expanding the cross-cutting catalog:

```text
empty barrel vs water-filled barrel
  → contents alter effective mass/affordances

tight-bound vs loose-bound improvised tool
  → component condition alters effective behavior

loose cloth vs attached/tensioned cloth
  → configuration alters behavior

transparent vs opaque container
  → same contents, different perceptual evidence

intact vs damaged/repaired shelter section
  → project/world composition + history

ordinary heavy stone vs absurd bowling ball
  → same physical interaction grammar, different authored identity
```

Future brainstorming can continue here, but accepted modeled-content requirements should be normalized into `docs/asset-catalog/` rather than turning this directory back into a mutable production list.
