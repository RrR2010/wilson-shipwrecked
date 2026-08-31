# Handoff — Asset Catalog Functional-Domain Normalization

## Purpose

The next task is to turn the current art-seeded cross-cutting asset catalog into a robust **functional + visual content catalog** while validating it against the stabilized Wilson Shipwrecked domain.

The catalog should become the practical source from which future modeling/content agents can answer:

> What content family must exist, what semantic roles must it support, what states/interactions/compositions matter, what visual contract applies, and what remains to be produced?

This is a **content/catalog normalization task**, not a new architecture discovery pass.

---

# 1. Current project state

The product/behavior, architecture and language-neutral functional-domain stabilization gates have passed.

The domain has already been stress-tested against:

- the full representative-scene suite;
- Scientific Method experimentation;
- Falling Palm immediate-threat/hazard dynamics;
- Sabotaged Storage expectation/causal-attribution behavior;
- improvised-hammer assembly/degradation/repair;
- cloth/shelter rain+wind composition/protection/degradation.

The current catalog lives at:

```text
docs/asset-catalog/
  README.md
  ENTITIES.md
  PROJECTS.md
  LIVING_WORLD.md
```

This location is intentional. The catalog is **cross-cutting**, not owned by `docs/art/`.

The current rows were seeded from art direction plus the earlier functional-asset brainstorming rounds. They are useful but **not yet certified as functionally complete**.

---

# 2. Your role

Act as an independent **content-domain designer / systems-content modeler**.

Your job is to:

1. validate every catalog family against the stabilized domain;
2. make the catalog structurally capable of describing functional requirements, not just visual/model requirements;
3. identify and add missing content families required by product/domain/representative behavior;
4. normalize ambiguous or overloaded rows/columns;
5. preserve the art/production information already captured;
6. ensure the catalog remains readable and usable as a production/backlog source.

Do not redesign the game merely because a catalog row is inconvenient.

---

# 3. Required reading — minimum path

Start with:

1. `README.md` — project thesis.
2. `docs/README.md` — documentation authority map and task bundles.
3. `docs/DISCOVERY_STATUS.md` — current closed gates and parallel catalog stream.
4. `docs/PRODUCT.md` — player experience and product semantics relevant to content.
5. `docs/DOMAIN_MODEL.md` — domain aggregates/state/content definitions.
6. `docs/DOMAIN_VOCABULARY.md` — canonical semantic distinctions and ID/reference vocabulary.
7. `docs/DOMAIN_CATALOGS.md` — admitted relations, predicates, effects, outcome/proposition vocabulary.
8. `docs/DOMAIN_OPERATIONS.md` — generic operations/actions/query boundaries.
9. `docs/DOMAIN_OPERATION_REFINEMENTS.md` — newer operation semantics that currently supersede specific older signatures.
10. `docs/DOMAIN_PROCEDURAL_COMPOSITION.md` — materials, effective properties, assembly, evidence/exploration and environmental response.
11. `docs/asset-catalog/README.md`.
12. `docs/asset-catalog/ENTITIES.md`.
13. `docs/asset-catalog/PROJECTS.md`.
14. `docs/asset-catalog/LIVING_WORLD.md`.

Then consult specialized domain appendices only where rows require them:

- `DOMAIN_ENVIRONMENTAL_PROTECTION.md` — covering/protection/exposure;
- `DOMAIN_HAZARD_DYNAMICS.md` — moving/falling/collapsing hazards;
- `DOMAIN_EPISTEMIC_INVESTIGATION.md` — observation/absence/anomalies/causal opportunity;
- `DOMAIN_MICRO_LOOP.md` — attemptability, tactical opportunities, interaction regions, same-chain learning.

Use validation fixtures when necessary to resolve an ambiguity, not as default catalog schemas.

---

# 4. Upstream breadth evidence

After understanding the stabilized domain, use:

```text
docs/brainstorming/functional-asset-catalog/
```

as a **recall source** for potentially missing content families/interactions/states.

Rounds 1–9 are brainstorming breadth.
Round 10 is the normalization bridge that explains why terms such as `heavy`, `throwable`, `wet`, `favorite`, `unexplored`, etc. must not automatically become domain capabilities/state fields.

Do not copy the rounds mechanically into the catalog. Re-evaluate every candidate against the current domain.

The representative scene catalog may also be used for coverage recall:

```text
docs/brainstorming/representative-scene-catalog.md
```

`docs/SCENE_VALIDATION.md` contains the canonical scene/system validation view.

---

# 5. Art/production sources

The existing artistic information should be preserved, not treated as the functional source of truth.

Use when validating visual/model requirements:

```text
docs/VISUAL_GUIDE.md
docs/art/README.md
docs/art/reference/
docs/ASSET_SPEC.md
docs/ASSET_PIPELINE.md
```

Important ownership rule:

```text
asset-catalog/ = what content/model families are required + cross-cutting requirements
art/          = how those assets should look / artistic production behavior
```

Do not recreate an object catalog under `art/`.

---

# 6. Closed domain decisions you must preserve

## 6.1 Core semantic distinctions

Keep these separate:

```text
Property
Capability
DerivedAffordance
WorldRelation / AssemblyConfiguration
EnvironmentalResponse
PresentationBand
Content/AuthoringMetadata
Wilson-relative belief/knowledge/association
```

In particular:

```text
property != capability != affordance
world truth != Wilson observation != Wilson belief
physical attemptability != Wilson expectation of success
AssemblyValidity != effective performance
Effect != WorldEvent != ObservedEvent != Evidence
art socket != InteractionRegion != Entity
ProjectDefinition progress != duplicate physical project state
```

## 6.2 No recipe catalog

The game does not use a traditional recipe catalog as the authority for physical interactions.

Target grammar:

```text
material/component properties
+ semantic assembly/configuration
+ current condition
+ context
→ EffectivePhysicalProfile
→ attemptability / physical outcome
```

A catalog row may describe required component roles/assembly slots and known semantic uses. It must not encode target-specific object-pair recipes such as:

```text
hammer + coconut = open coconut
```

## 6.3 Tool/structure quality

Do not add universal:

```text
tool_quality
structure_quality
shelter_quality
```

when meaningful effective properties already express the consequences.

A valid assembly may perform poorly.

## 6.4 Exploration / knowledge

Do not add:

```text
explored_percent
unexplored world state
known flag on the physical entity
```

Wilson learns individual propositions from bounded evidence.

## 6.5 Personal significance

Do not add world/domain flags such as:

```text
favorite
owned_by_wilson
rival
sacred
```

when associations, habits, episodes and ordinary world relations already create the history.

## 6.6 Projects

Projects are first-class cognition/project state, but the physical structure remains world truth.

Catalog project rows should identify required component/role semantics without duplicating authoritative world properties into a second project-state model.

## 6.7 Player intervention

God Power changes world state through declared intervention affordances/capabilities. It does not directly set Wilson trust, dependency, beliefs or emotions.

---

# 7. First audit: catalog schema

Before editing hundreds of rows, determine whether the current table columns are sufficient and readable.

The current catalog README lists the expected dimensions. Validate whether they should become explicit columns, grouped columns or row substructures.

At minimum, assess support for the following dimensions.

## Identity / scope

- stable family/content ID;
- catalog kind/domain mapping;
- priority;
- functional-spec completeness distinct from production status if useful.

## Physical/domain semantics

- material/profile assumptions where relevant;
- canonical `PropertyId` values/ranges/bands that materially affect gameplay;
- true `CapabilityId`s;
- derived affordances that matter for content planning;
- relevant world relations;
- container/content semantics;
- assembly roles/slots/components;
- InteractionRegion requirements where a semantic sub-target is needed.

## Interaction semantics

- generic actions/roles the content participates in;
- important hard preconditions or physical participation roles;
- transformations/effect families;
- important grounded outcome/diagnostic contrasts where they require model/state support;
- not object-specific scripts.

## Environment / lifecycle

- environmental responses/processes;
- protection/exposure contribution where relevant;
- damage/degradation/repair requirements;
- authoritative lifecycle/condition versus presentation state bands;
- detached/reusable component behavior where relevant.

## Wilson-facing evidence where content-specific

Only when materially required by the asset:

- transparency/visibility distinctions;
- inspectable/tactile/auditory evidence needs;
- hidden versus visible interaction regions;
- recognizable persistent identity requirements for recurring actors/objects.

Do not duplicate Wilson's belief state into the catalog row.

## Product / content coverage

- project dependencies/uses;
- representative-scene coverage;
- long-run systemic value;
- player intervention affordances where authored per-object behavior is required.

## Art / production

Preserve:

- required visual states/contrasts;
- art reference/sheet;
- anchors/sockets/adapters;
- production strategy;
- production priority/status/notes.

### Readability requirement

Do not solve completeness by creating one 25-column Markdown table with unreadable paragraphs in every cell.

Possible solutions include:

- a stable compact common column set plus category-specific columns;
- separate tables for entity/project/living-world kinds;
- standardized terse semantic tokens in cells;
- a small number of supplemental detail blocks only for unusually complex families.

Prefer a structure agents can update reliably.

---

# 8. Second audit: classify what is actually a catalog row

The current files intentionally started broad. Some rows may not actually represent modeled content families.

Audit especially `LIVING_WORLD.md` for rows resembling:

```text
state.*
opportunity.*
adapter/socket vocabulary
presentation band
runtime outcome
```

Examples currently worth reviewing include concepts like:

- generic wet-material presentation;
- roof-damage state;
- light-prop displacement state;
- perch socket vocabulary;
- storm debris cluster;
- fallen branch/frond opportunity.

For each, decide whether it is:

1. a real reusable modeled family;
2. a state/contrast requirement that belongs on one or more real families;
3. a presentation band derived from a property;
4. an adapter contract owned by asset/art/runtime specifications;
5. a world process/outcome rather than an asset;
6. a legitimate placed content family that deserves its own row.

Do not keep a fake "asset" row merely because it was useful during brainstorming.

---

# 9. Third audit: current hotspots

Pay particular attention to these known risks.

## Assembled tools

Rows such as improvised knife/hatchet/hammer must not turn into hidden recipes or fixed type requirements.

Validate the relationship between:

```text
component families
AssemblyDefinition / semantic slots
runtime bindings
EffectivePhysicalProfile
presentation of assembled configuration
```

Decide whether an assembled-tool row represents a reusable authored host/configuration family, a semantic assembly archetype, or merely a derived runtime arrangement.

## Projects

Current project rows often list required components as prose nouns.

Normalize them toward:

- catalog IDs where the component family is known;
- semantic component roles when interchangeable families are intended;
- explicit optional versus required roles when meaningful;
- lifecycle visuals without duplicating physical truth.

## Properties

Current cells often use readable prose such as `medium mass`, `high hardness`, `stable`.

Map to canonical property vocabulary where the distinction is actually authoritative. Preserve coarse values; do not invent fake engineering precision.

## Interactions

Current interaction cells are useful prose but may be under-specified.

Normalize toward generic action/role semantics and important outcome requirements without creating object-specific APIs.

## Environmental behavior

Ensure cloth, fronds, fire, containers, structures, loose objects, terrain and similar families can express required rain/wind/sun/water effects via reusable environmental/property semantics.

## Actors / recurring fauna

Keep recurring identity (`EntityId` + shallow actor runtime state/history) distinct from a new psychology system. Validate habitat, carry/steal, movement/perch and visible-state needs.

## Transformation descendants

Check whether things such as whole/opened coconut, shell bowl, live/dead/cooked fish, detached components, broken salvage, etc. are modeled as:

- separate authored definitions;
- transformation variants/results;
- presentation bands;
- component/contents relations;

Use the smallest semantically correct family structure.

---

# 10. Fourth audit: missing functional breadth

Use the domain + product + representative scenes + brainstorming rounds to identify missing rows.

Do not limit the search to visually interesting assets.

Specifically check coverage for:

- generic tool/component grammar;
- binding/fastening components;
- cutting/impact/digging/probing roles;
- containers with varied closure/transparency/contents behavior;
- cooking, food prep and preservation participants;
- water collection/storage;
- fuel/tinder/fire-support content;
- construction components and interchangeable coverings;
- storage/protection configurations;
- transport/cargo/float components;
- environmental hazard/repair-relevant components;
- comfort/routine/personalization props;
- animal/habitat interaction objects;
- salvage/rare/absurd objects that obey ordinary rules;
- player-intervenable objects where authored intervention affordances are required;
- interaction-region/anchor requirements needed by generic actions.

Add rows only when the content family is justified by gameplay/systemic coverage, not simply because an object could exist on an island.

---

# 11. Domain-gap protocol

The default expectation is that the stabilized domain is sufficient.

If catalog normalization exposes something that cannot be represented without a new domain concept:

1. state the exact content/behavior that cannot be expressed;
2. identify the representative scene/product requirement or reusable invariant that proves the gap;
3. show why existing property/capability/relation/action/composition/evidence semantics are insufficient;
4. propose the smallest reusable domain addition;
5. regression-check it against existing domain distinctions;
6. update the canonical owning domain document explicitly.

Do **not** silently introduce a new primitive only inside a catalog column.

---

# 12. Production-status rule

Existing catalog `Status` means model/content production lifecycle:

```text
TODO
BRIEFED
BLOCKOUT
SELF_REVIEW
INDEPENDENT_REVIEW
APPROVED
DEFERRED
```

Do not redefine it to mean "functional analysis complete".

If useful, introduce a separate compact functional-spec field, for example conceptually:

```text
UNREVIEWED
PARTIAL
DOMAIN_ALIGNED
BLOCKED_DOMAIN_GAP
```

You may choose different names or avoid a new field if another readable mechanism works better.

The goal is to let the catalog itself show what still needs functional normalization without corrupting production tracking.

---

# 13. Deliverables

Expected durable outputs are primarily updates to the existing catalog, not a new forest of documents.

## Required

1. Update `docs/asset-catalog/README.md` if the normalized schema/column rules change.
2. Normalize `ENTITIES.md`.
3. Normalize `PROJECTS.md`.
4. Normalize `LIVING_WORLD.md`.
5. Add missing functional rows/families demonstrated by the audit.
6. Preserve existing useful art/reference/production information.
7. Make incomplete functional analysis visibly trackable in the catalog itself.

## Optional

Create at most **one** additional durable catalog-support document only if a large reusable matrix genuinely cannot remain readable in the three catalog files/README. Prefer not to add one.

Do not create one document per content family.

---

# 14. Acceptance gate

The catalog/domain normalization pass is complete when:

- every P0 family has an explicit, unambiguous domain mapping or a documented reason it is presentation-only;
- P1 rows are sufficiently structured that later agents do not need to reverse-engineer their intended semantics;
- properties/capabilities/affordances are no longer casually conflated;
- project components reference stable families or semantic interchangeable roles where appropriate;
- tool/crafting content follows assembly/property semantics rather than recipes;
- important generic interactions and transformation/state requirements are represented;
- environmental response/protection/hazard-relevant requirements are represented where applicable;
- rows that are really presentation bands/adapters/process outcomes are reclassified or moved into requirements of actual content families;
- missing foundational functional families discovered from product/domain/scene coverage are added;
- art references and production status remain usable;
- no catalog row creates a second authoritative simulation schema;
- genuine domain gaps, if any, are explicit and separately justified;
- the catalog can serve as a practical to-do/source-of-truth for future modeling/content agents.

---

# 15. Non-goals

Do not:

- design concrete GDScript classes/package layout as part of this pass;
- turn the catalog into a database persistence schema;
- enumerate every possible combination of material × condition × assembly;
- add realistic engineering constants that gameplay does not consume;
- invent recipes for every useful object pair;
- duplicate art direction inside functional columns;
- duplicate Wilson beliefs/history inside world-content rows;
- create a new state-owning system per catalog category;
- expand P2 content merely to make the catalog feel exhaustive.

The target is **functional completeness of the content vocabulary**, not maximal object count.

---

# 16. Final review questions

Before considering the pass complete, be able to answer:

```text
Can an implementation/content agent tell which domain definitions a row requires?
Can a modeling agent tell which functional contrasts must be visually represented?
Can a systems agent tell which generic interactions the asset participates in?
Can a project row express interchangeable components without a recipe?
Can environment-sensitive assets express their reusable responses?
Can a row distinguish authoritative state from presentation bands?
Can recurring identity/history exist without asset-specific psychology?
Can the catalog expose incomplete functional work without abusing production status?
Can the catalog be extended later without creating a parallel domain model?
```

If yes, the catalog is ready to act as the cross-cutting content source of truth for production and implementation.
