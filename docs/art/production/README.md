# Art Production Catalog

## Purpose

This is the operational 3D-production backlog derived from the functional-asset brainstorming rounds and normalized against the canonical domain vocabulary.

The brainstorming rounds remain historical design evidence in `../../brainstorming/functional-asset-catalog/`. Agents should use this directory for day-to-day production selection and status updates.

## Catalogs

- [`ENTITIES.md`](ENTITIES.md) — physical entity families, resources, props, tools, containers and salvage.
- [`PROJECTS.md`](PROJECTS.md) — composed/persistent projects and structures.
- [`LIVING_WORLD.md`](LIVING_WORLD.md) — terrain/place presentation, flora, fauna, habitats and environmental opportunity families.

## Status vocabulary

`Status` is art-production metadata, never runtime/domain state:

```text
TODO
BRIEFED
BLOCKOUT
SELF_REVIEW
INDEPENDENT_REVIEW
APPROVED
DEFERRED
```

| Status | Meaning |
|---|---|
| `TODO` | Identified; production has not started. |
| `BRIEFED` | Required reference/brief inputs are ready. |
| `BLOCKOUT` | Model exists but has not passed artistic review. |
| `SELF_REVIEW` | Creator is iterating against canonical previews/rubric. |
| `INDEPENDENT_REVIEW` | Independent reviewer is evaluating it. |
| `APPROVED` | Artistically accepted for the current milestone. |
| `DEFERRED` | Explicitly outside current scope. |

Agents may update status and implementation-note fields unless explicitly asked to redesign catalog semantics.

## Domain-aligned columns

Keep these concepts separate:

- **Domain mapping** — closest authored concept such as `EntityDefinition`, `ProjectDefinition`, `ActorProfileDefinition` or `PlaceDefinition`; the art asset itself is not the domain definition.
- **Properties** — value-bearing semantics such as mass, hardness, rigidity, moisture, integrity or fill.
- **Capabilities** — reusable semantic participation roles such as `graspable`, `container`, `structural_member`, `covering`, `sittable` or `harvestable`.
- **Derived affordances** — contextual expectations such as carry, throw, roll, drag, push, stack or hang; do not automatically convert these into authored capability flags.
- **Relations / composition** — canonical world/configuration semantics such as `inside`, `on_top_of`, `attached_to`, `part_of`, `carried_by`, `held_by` and `connects`.
- **Visual states / contrasts** — art presentation bands/regression contrasts; many are projections of underlying properties/processes rather than separate entity types.
- **Interactions / scene value** — coverage notes, not bespoke object APIs.

## Priority

- `P0` — vertical-slice/systemic vocabulary; model first.
- `P1` — meaningful systemic expansion after P0 grammar works.
- `P2` — authored richness/long-run expansion; defer unless requested.

## Selection rule

Prefer work that is P0, unlocks shared components/generators, has approved references, exercises a domain regression contrast and supports several representative scenes.

```text
Rounds 1–10
→ Production Catalog
→ family/asset brief when needed
→ AGENT_ART_PRODUCTION.md
→ approved asset
→ Status = APPROVED
```