# Functional Asset Catalog — Interpretation Guide

The files in this directory are brainstorming artifacts for functional object breadth, visual production and systemic opportunity discovery.

They are intentionally broader and less normalized than the canonical domain documents.

## Reading order

Use the rounds as exploratory source material:

1. `ROUND_01_PHYSICAL_ISLAND_GRAMMAR.md`
2. `ROUND_02_FOOD_WATER_COOKING_STORAGE.md`
3. `ROUND_03_TOOLS_CRAFTING_WORKSTATIONS_CONSTRUCTION.md`
4. `ROUND_04_FLORA_FAUNA_HABITATS_RENEWABLE_RESOURCES.md`
5. `ROUND_05_SHIPWRECK_DEBRIS_FOUND_RARE_ABSURD_OBJECTS.md`
6. `ROUND_06_LARGE_PROJECTS_TRANSPORT_NAVIGATION_STRUCTURES.md`
7. `ROUND_07_COMFORT_HABITS_DECORATION_COLLECTIONS_PERSONALIZATION.md`
8. `ROUND_08_WEATHER_HAZARDS_DAMAGE_OPPORTUNITY_OBJECTS.md`
9. `ROUND_09_CONSOLIDATION_PRODUCTION_MATRIX.md`

Then read:

10. `ROUND_10_DOMAIN_NORMALIZATION.md`

Round 10 is the canonical interpretation layer for domain-facing terminology in this brainstorming set.

## Authority boundary

The asset catalog may propose:

- object families;
- visual states;
- anchors/sockets;
- reusable physical roles;
- procedural generator opportunities;
- interactions worth supporting;
- cheap regression variants.

It does **not** define authoritative domain schemas.

Canonical domain semantics live in:

- `../../DOMAIN_MODEL.md`;
- `../../DOMAIN_VOCABULARY.md`;
- `../../DOMAIN_CATALOGS.md`;
- `../../DOMAIN_OPERATIONS.md`;
- `../../DOMAIN_PROCEDURAL_COMPOSITION.md`.

When terminology conflicts, preserve the asset idea but use the canonical domain interpretation.

## Common shorthand warnings

Earlier rounds may use words such as:

```text
heavy
throwable
portable
wet
unexplored
collectible
```

as convenient brainstorming labels.

They should not automatically become one-for-one domain flags.

Examples:

```text
heavy
→ property.mass_class

throwable
→ usually derived affordance from mass/bulk/grasp/body context

wet
→ presentation band over property.moisture

unexplored
→ Wilson-relative lack of evidence, not object world state

collectible
→ authoring/presentation metadata or emergent personal significance
```

See Round 10 for the complete normalization.

## Procedurality goal

The target is not to maximize the number of unique object interactions.

The target is:

```text
small domain vocabulary
+ reusable asset families
+ material/property differences
+ bounded assembly
+ world relations
+ environment response
+ gradual knowledge
→ many plausible interactions
```

A new asset is especially valuable when it exercises an existing semantic rule in a surprising way rather than requiring new bespoke simulation code.
