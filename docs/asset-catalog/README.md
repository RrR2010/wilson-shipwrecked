# Asset Catalog

## Purpose

This directory is the cross-cutting source of truth for **what modeled world content exists or is planned, what each family must support, and what remains to be produced**.

It is intentionally outside `docs/art/` because a catalog entry spans multiple concerns:

- domain identity and composition;
- properties, capabilities and derived affordances;
- interactions and representative-scene coverage;
- states, transformations and project evolution;
- art references and visual requirements;
- anchors/sockets and semantic assembly expectations;
- production strategy and status;
- later implementation/export/runtime notes.

The current tables were seeded from Rounds 1–10 and the art-direction work. They are **not yet certified as a functionally complete content-authoring schema**. A dedicated catalog/domain pass may add columns, split overloaded columns, add missing families and normalize rows without changing this ownership boundary.

For the repository-wide documentation map, see [`../README.md`](../README.md).

## Catalog split

- [`ENTITIES.md`](ENTITIES.md) — physical entity families, resources, props, tools, containers and salvage.
- [`PROJECTS.md`](PROJECTS.md) — persistent/composed projects and structures.
- [`LIVING_WORLD.md`](LIVING_WORLD.md) — terrain/place presentation, flora, fauna, habitats and environmental opportunity families.

These are the operational content/model-production lists. The brainstorming rounds in `../brainstorming/functional-asset-catalog/` are upstream historical/design evidence, not a competing backlog.

The split is organizational rather than a domain inheritance hierarchy. If a family fits poorly, prefer moving/reframing the row over inventing a new runtime type merely to match the file structure.

## Authority boundaries

The catalog **references** other contracts rather than replacing them.

For functional semantics, start with the domain bundle defined in [`../README.md`](../README.md):

```text
DOMAIN_MODEL.md
DOMAIN_VOCABULARY.md
DOMAIN_CATALOGS.md
DOMAIN_OPERATIONS.md
DOMAIN_PROCEDURAL_COMPOSITION.md
```

Consult specialized domain appendices only when the row actually touches their concern (environmental protection, hazards, epistemic investigation, detailed micro-loop semantics).

Other owners:

- `../PRODUCT.md` / behavioral docs own player/Wilson product semantics;
- `../VISUAL_GUIDE.md` and `../art/` own visual language;
- `../ASSET_SPEC.md` owns runtime asset structure/anchor conventions;
- `../ASSET_PIPELINE.md` owns technical production/export workflow.

If a catalog row conflicts with a canonical domain, product or art contract, fix the row or explicitly surface a domain gap for review. Do not silently promote catalog convenience into a new primitive.

## Column model

A mature row may contain several independent dimensions. Keep them distinct:

- **Identity / family** — stable content-facing name or family.
- **Domain mapping** — closest `EntityDefinition`, `ProjectDefinition`, `ActorProfileDefinition`, `PlaceDefinition`, etc.
- **Properties** — value-bearing semantics such as mass, hardness, rigidity, moisture, integrity and fill.
- **Capabilities** — reusable participation roles such as `container`, `structural_member`, `covering`, `sittable`, `harvestable`.
- **Derived affordances** — contextual opportunities such as carry, throw, roll, drag, push, stack and hang.
- **Relations / composition** — `inside`, `on_top_of`, `attached_to`, `part_of`, `connects`, semantic assembly slots/bindings and required component roles.
- **States / transformations** — authoritative condition/lifecycle inputs plus required visible/runtime contrasts; distinguish state bands from independent state machines.
- **Interactions / coverage** — generic actions, semantic interaction roles, important diagnostics/outcomes and representative-scene value; never object-pair API invention.
- **Environmental behavior** — exposure/response/process requirements where materially relevant rather than type-specific weather switches.
- **Project / production dependencies** — content families or project stages that require this family, where useful for backlog ordering.
- **Art contract** — relevant `docs/art/reference/REFERENCE_*.md` and visual sheet.
- **Anchors / sockets / interaction regions** — only when stable presentation adapters are required; do not confuse them with domain identity.
- **Production strategy** — procedural, modular, hybrid or manual where known.
- **Status / notes** — execution tracking.

These dimensions are a **catalog schema direction**, not a requirement that every Markdown table immediately have every column. The functional normalization pass should choose a readable structure and avoid giant cells that mix unrelated concerns.

## Important semantic separations

Catalog enrichment must preserve the stabilized domain distinctions:

```text
property != capability != derived affordance
world truth != Wilson belief/knowledge
assembly validity != effective performance
physical attemptability != expected success
visual state band != authoritative state machine
art socket != semantic interaction region != world entity
ProjectDefinition progress != duplicated physical structure state
```

Do not add catalog fields such as `recipe`, `favorite`, `explored_percent`, `tool_quality`, `shelter_quality` or object-pair interaction switches unless a canonical domain change explicitly admits such a concept.

## Status vocabulary

Status tracks **model/content production**, not domain runtime state or functional-schema validation:

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
| `BRIEFED` | Required functional/art inputs are sufficiently specified for production. |
| `BLOCKOUT` | A model exists but has not passed the required review gates. |
| `SELF_REVIEW` | Creator is iterating against applicable contracts. |
| `INDEPENDENT_REVIEW` | Independent review is in progress. |
| `APPROVED` | Accepted for the current milestone. |
| `DEFERRED` | Explicitly outside current scope. |

If the next catalog pass needs to track **functional specification completeness**, add a distinct field/status rather than overloading this production status.

## Priority

- `P0` — vertical-slice/systemic vocabulary; model first.
- `P1` — meaningful systemic expansion after P0 grammar works.
- `P2` — authored richness/long-run expansion; defer unless requested.

Priority may be reassessed when domain/content dependency analysis exposes a missing foundational family.

## Agent consumption

A modeling agent should normally start from a catalog row, then follow linked concerns:

```text
Asset Catalog row
→ relevant domain/product contract when needed
→ relevant art reference + visual sheet
→ family/asset brief when needed
→ art production review loop
→ technical asset pipeline
→ update catalog status/notes
```

A **catalog-normalization agent** should instead begin with the domain/product bundle, then audit the catalog as content data. It should not use art references as the sole source for functional requirements.

The long-term goal is that implementation and modeling agents never need to search all brainstorming rounds to discover what an asset must support.
