# Functional Asset Production Catalog

## Purpose

This is the operational production surface derived from Rounds 1–10.

The brainstorming rounds remain preserved as discovery/history. Agents should **not** use the rounds themselves as the day-to-day modeling backlog. Use the consolidated production tables linked below.

Canonical domain language comes from `main` domain documentation, especially:

- `DOMAIN_MODEL.md`;
- `DOMAIN_VOCABULARY.md`;
- `DOMAIN_CATALOGS.md`.

Round 10 remains the interpretation bridge between broad brainstorming shorthand and the domain vocabulary.

## Catalog split

- [`PRODUCTION_CATALOG_ENTITIES.md`](PRODUCTION_CATALOG_ENTITIES.md) — physical entity families, resources, props, tools, containers and salvage.
- [`PRODUCTION_CATALOG_PROJECTS.md`](PRODUCTION_CATALOG_PROJECTS.md) — composed/persistent projects and structures.
- [`PRODUCTION_CATALOG_LIVING_WORLD.md`](PRODUCTION_CATALOG_LIVING_WORLD.md) — flora/fauna, habitats, terrain/place presentation and environmental opportunity families.

## Production status

`Status` is **art-production metadata**, not domain/runtime state.

Use exactly one of:

```text
TODO
BRIEFED
BLOCKOUT
SELF_REVIEW
INDEPENDENT_REVIEW
APPROVED
DEFERRED
```

Meaning:

| Status | Meaning |
|---|---|
| `TODO` | Family/asset is identified but production has not started. |
| `BRIEFED` | Required art brief/reference inputs are ready. |
| `BLOCKOUT` | A model exists but has not passed the artistic loop. |
| `SELF_REVIEW` | Creator is iterating against canonical previews/rubric. |
| `INDEPENDENT_REVIEW` | Creator considers it ready; independent reviewer is evaluating it. |
| `APPROVED` | Passed artistic acceptance for the current milestone. |
| `DEFERRED` | Explicitly outside the current production scope. |

Agents may update only the `Status` column and implementation-note fields unless the task explicitly authorizes catalog redesign.

## Domain-aligned column semantics

The catalog deliberately separates concepts that were mixed together during brainstorming.

### `Domain mapping`

The closest canonical authored concept, normally one of:

```text
EntityDefinition
ProjectDefinition
ActorProfileDefinition
PlaceDefinition / presentation family
```

The art asset is not itself the domain definition; this column only keeps content naming aligned.

### `Properties`

Value-bearing physical semantics such as:

```text
mass_class
bulk_class
hardness
sharpness
rigidity
flexibility
absorbency
water_resistance
buoyancy
flammability
structural_integrity
binding_integrity
stability
moisture
freshness
cooking_progress
fill_ratio
```

Values in these tables are design intent, not implementation constants unless a canonical content definition later fixes them.

### `Capabilities`

Reusable semantic participation roles. Prefer small vocabulary, for example:

```text
graspable
container
liquid_container
receives_impact
impact_surface
cutting_edge
binding_component
structural_member
covering
fuel
tinder
cookable
sittable
sleepable
work_surface
climbable
perchable
harvestable
habitat
```

Do not convert every adjective into a capability.

### `Derived affordances`

Expected contextual opportunities used for production reasoning, such as:

```text
one-hand carry
two-hand carry
throw
roll
drag
push
stack
hang
place on surface
```

These are separated because many should derive from effective properties + body/context rather than being authored flags.

### `Relations / composition`

Relevant world/configuration semantics, using canonical relation language where applicable:

```text
inside
on_top_of
attached_to
part_of
carried_by
held_by
connects
```

Assembly semantics are domain-facing; Blender/Godot sockets remain art/runtime adapter concerns.

### `Visual states / contrasts`

Art-production states and regression contrasts. Many are presentation bands over properties/processes rather than separate domain entity types.

Examples:

```text
dry / wet / soaked
intact / damaged / repaired
empty / partial / full
raw / cooked / burned
loose / attached+tensioned
whole / opened / reused
```

### `Interactions / scene value`

High-value generic actions or representative-scene roles. These are **coverage notes**, not bespoke object interaction APIs.

## Priority

- `P0` — vertical-slice/systemic vocabulary; model first.
- `P1` — meaningful systemic expansion after P0 grammar works.
- `P2` — authored richness/long-run expansion; defer unless specifically requested.

## Production rule

When selecting work, prefer rows that:

1. are `P0`;
2. unlock multiple other rows through shared generators/components;
3. have an approved reference sheet;
4. exercise a domain regression contrast;
5. support several representative scenes.

The intended relationship is:

```text
Rounds 1–10
  → broad design discovery

Production Catalog
  → consolidated production backlog

Asset/family brief
  → exact modeling task

Agent modeling workflow
  → build + render + review

Approved asset
  → Status = APPROVED
```
