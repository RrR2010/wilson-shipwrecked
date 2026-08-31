# Asset Catalog

## Purpose

This directory is the cross-cutting source of truth for **what modeled world assets exist, what they must support, and what remains to be produced**.

It is intentionally outside `docs/art/` because an asset entry spans multiple concerns:

- domain identity and composition;
- properties, capabilities and derived affordances;
- interactions and representative-scene coverage;
- states, transformations and project evolution;
- art references and visual requirements;
- anchors/sockets and semantic assembly expectations;
- production strategy and status;
- later implementation/export/runtime notes.

The current tables were seeded from Rounds 1–10 and the art-direction work. Another pass may extend their columns into a fuller implementation/content catalog without changing this ownership boundary.

## Catalog split

- [`ENTITIES.md`](ENTITIES.md) — physical entity families, resources, props, tools, containers and salvage.
- [`PROJECTS.md`](PROJECTS.md) — persistent/composed projects and structures.
- [`LIVING_WORLD.md`](LIVING_WORLD.md) — terrain/place presentation, flora, fauna, habitats and environmental opportunity families.

These are the operational model-production lists. The brainstorming rounds in `../brainstorming/functional-asset-catalog/` are upstream historical/design evidence, not a competing backlog.

## Authority boundaries

The catalog **references** other contracts rather than replacing them:

- `../DOMAIN_*.md` owns canonical functional/domain semantics;
- `../VISUAL_GUIDE.md` and `../art/` own visual language;
- `../ASSET_SPEC.md` owns runtime asset structure/anchor conventions;
- `../ASSET_PIPELINE.md` owns technical production/export workflow.

If a catalog row conflicts with a canonical domain or art contract, fix the row rather than treating it as a new primitive.

## Column model

A mature row may contain several independent dimensions. Keep them distinct:

- **Identity / family** — stable content-facing name or family.
- **Domain mapping** — closest `EntityDefinition`, `ProjectDefinition`, `ActorProfileDefinition`, `PlaceDefinition`, etc.
- **Properties** — value-bearing semantics such as mass, hardness, rigidity, moisture, integrity and fill.
- **Capabilities** — reusable participation roles such as `container`, `structural_member`, `covering`, `sittable`, `harvestable`.
- **Derived affordances** — contextual opportunities such as carry, throw, roll, drag, push, stack and hang.
- **Relations / composition** — `inside`, `on_top_of`, `attached_to`, `part_of`, `connects`, and semantic assembly expectations.
- **States / transformations** — visible/runtime-significant variants, lifecycle stages, damage/repair, contents and transformations.
- **Interactions / coverage** — generic actions and representative-scene value; never object-specific API invention.
- **Art contract** — relevant `docs/art/reference/REFERENCE_*.md` and visual sheet.
- **Anchors / sockets** — only when the modeled asset needs stable interaction/assembly transforms.
- **Production strategy** — procedural, modular, hybrid or manual where known.
- **Status / notes** — execution tracking.

The current seed tables do not need every future column populated immediately. Extend them deliberately when the catalog becomes the full content-authoring source.

## Status vocabulary

Status tracks **model/content production**, not domain runtime state:

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
| `BRIEFED` | Required functional/art inputs are sufficiently specified. |
| `BLOCKOUT` | A model exists but has not passed the required review gates. |
| `SELF_REVIEW` | Creator is iterating against its applicable contracts. |
| `INDEPENDENT_REVIEW` | Independent review is in progress. |
| `APPROVED` | Accepted for the current milestone. |
| `DEFERRED` | Explicitly outside current scope. |

## Priority

- `P0` — vertical-slice/systemic vocabulary; model first.
- `P1` — meaningful systemic expansion after P0 grammar works.
- `P2` — authored richness/long-run expansion; defer unless requested.

## Agent consumption

A modeling agent should normally start from a catalog row, then follow linked concerns:

```text
Asset Catalog row
→ relevant domain/functional contract when needed
→ relevant art reference + visual sheet
→ family/asset brief when needed
→ art production review loop
→ technical asset pipeline
→ update catalog status/notes
```

The long-term goal is that an agent never needs to search all brainstorming rounds to discover what an asset must support.