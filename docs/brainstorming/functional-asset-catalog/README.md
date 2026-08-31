# Functional Asset Catalog Brainstorming

## Purpose

This directory contains both the exploratory functional-asset brainstorming and the consolidated production backlog derived from it.

The two layers have different purposes.

## Operational production layer

Agents and humans deciding **what to model next** should start here:

- [`PRODUCTION_CATALOG.md`](PRODUCTION_CATALOG.md) — status vocabulary, column semantics and selection rules;
- [`PRODUCTION_CATALOG_ENTITIES.md`](PRODUCTION_CATALOG_ENTITIES.md) — physical entities, resources, props, tools, containers and salvage;
- [`PRODUCTION_CATALOG_PROJECTS.md`](PRODUCTION_CATALOG_PROJECTS.md) — composed projects and structures;
- [`PRODUCTION_CATALOG_LIVING_WORLD.md`](PRODUCTION_CATALOG_LIVING_WORLD.md) — terrain/place presentation, flora, fauna, habitats and environmental opportunity families.

The production tables are the preferred backlog surface. Their `Status` column may be updated as assets move through briefing, blockout, review and approval.

`Status` is art-production metadata only; it is not simulation/domain state.

## Exploratory source layer

Rounds 1–9 explore breadth: object families, visual states, reusable parts, interaction ideas, construction vocabulary, weather responses, domestic props, salvage, fauna, comfort objects and long-run procedural opportunities.

They are intentionally exploratory. They are **not** a gameplay schema and should not be translated mechanically into enums, capabilities, state machines, recipes or classes.

Round 10 normalizes the terminology used in the earlier rounds against the functional domain model.

Canonical interpretation is layered as follows:

```text
Rounds 1–9
  brainstorming breadth / production possibilities

ROUND_10_DOMAIN_NORMALIZATION.md
  normalization of brainstorming terminology
  property vs capability vs derived affordance vs metadata

PRODUCTION_CATALOG*.md
  consolidated art-production backlog
  domain-aligned terminology
  progress tracking

../../DOMAIN_MODEL.md
../../DOMAIN_VOCABULARY.md
../../DOMAIN_CATALOGS.md
  canonical domain semantics on the authoritative domain branch
```

## Reading rule

When a Round 1–9 term conflicts with the canonical domain vocabulary, treat the round term as descriptive shorthand.

Examples:

```text
heavy
  brainstorming shorthand
  → property.mass_class

throwable
  brainstorming shorthand
  → capability or derived affordance according to the canonical content/domain definition and effective physical context

wet / soaked
  visual shorthand
  → normally presentation bands over an authoritative moisture/wetness property/process

unexplored / inspected
  brainstorming exploration shorthand
  → Wilson-relative beliefs/evidence/history, not world entity state

favorite / personal
  narrative shorthand
  → association + habit + history, not physical capability
```

## Domain alignment rule

Production catalogs deliberately keep these concepts separate:

```text
Property
Capability
Category
Derived affordance expectation
World relation / configuration
Project lifecycle
Presentation band
Art anchor/socket
Wilson-relative history/knowledge
```

Do not use an art socket name as a domain concept, and do not turn a presentation state into a new entity type unless gameplay semantics require it.

## Procedural-content rule

Prefer adding new content by recombining existing domain semantics:

```text
material
+ properties
+ capabilities
+ condition
+ assembly slots/components
+ world relations
+ contents
+ interaction regions
+ evidence accessibility
+ environmental response
```

before introducing a new entity-specific interaction rule.

The strongest proof of a new asset family is not that it has a unique action. It is that it creates new situations while obeying existing reusable rules.

## Cheap regression contrasts

When producing functional variants, favor pairs that stress the domain without multiplying assets:

```text
empty barrel vs water-filled barrel
  → contents alter effective mass/affordances

tight-bound vs loose-bound improvised tool
  → component condition alters effective behavior

loose cloth vs attached/tensioned cloth
  → relation/configuration alters behavior

transparent vs opaque container
  → same contents, different perceptual evidence

intact vs damaged/repaired shelter section
  → project/world composition + history

ordinary heavy stone vs absurd bowling ball
  → same physical interaction grammar, different authored identity
```

These contrasts should be preferred over creating bespoke mechanics merely to justify a visual variant.

## Status

The functional asset catalog has passed a domain-level breadth review and now has a consolidated production layer.

Future brainstorming may continue, but new ideas should be merged into the production catalogs only after they are normalized against canonical domain vocabulary and have clear systemic or artistic value.
