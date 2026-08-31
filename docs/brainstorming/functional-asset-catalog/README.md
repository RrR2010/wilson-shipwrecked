# Functional Asset Catalog Brainstorming

## Purpose

This directory explores breadth: object families, visual states, reusable parts, interaction ideas, construction vocabulary, weather responses, domestic props, salvage, fauna, comfort objects and long-run procedural opportunities.

Rounds 1–9 are intentionally exploratory. They are **not** a gameplay schema and should not be translated mechanically into enums, capabilities, state machines, recipes or classes.

Canonical interpretation is layered as follows:

```text
Rounds 1–9
  brainstorming breadth / production possibilities

ROUND_10_DOMAIN_NORMALIZATION.md
  normalization of brainstorming terminology
  property vs capability vs derived affordance vs metadata

../../DOMAIN_PROCEDURAL_COMPOSITION.md
  canonical procedural domain semantics
  materials / effective physical profiles / assembly / exploration / environment

../../DOMAIN_MICRO_LOOP.md
  canonical frame-group execution semantics
  Scientific Method fixture / tactical-vs-intentional cadence / interaction regions

../../DOMAIN_OPERATION_REFINEMENTS.md
  canonical refined operation surface for attemptability, evidence and tactical decisions
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
  → normally derived affordance from mass/bulk/grasp/body/context

wet / soaked
  visual shorthand
  → normally presentation bands over property.moisture

unexplored / inspected
  brainstorming exploration shorthand
  → Wilson-relative beliefs/evidence, not world entity state

favorite / personal
  narrative shorthand
  → association + habit + history, not physical capability
```

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
  → component condition alters effective capability

loose cloth vs attached/tensioned cloth
  → relation/configuration alters behavior

transparent vs opaque container
  → same contents, different perceptual evidence

intact vs damaged/repaired shelter section
  → project/world composition + history

ordinary heavy stone vs absurd bowling ball
  → same impact/roll grammar, different authored identity
```

These contrasts should be preferred over creating bespoke mechanics merely to justify a visual variant.

## Status

The functional asset catalog has passed a domain-level breadth review.

The Scientific Method frame-group fixture in `DOMAIN_MICRO_LOOP.md` further validates that procedural exploration, imperfect beliefs, failed experiments, partial progress and tactic refinement can be expressed without scene scripts or object-pair recipes.

Future rounds may continue to brainstorm broadly, but new primitives should only become canonical after a representative scene/fixture or implementation invariant demonstrates that existing composition cannot express the requirement cleanly.
