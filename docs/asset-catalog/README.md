# Cross-Cutting Asset Catalog

## Purpose

`docs/asset-catalog/` is the source of truth for **modeled content requirements** and production status.

It answers:

> What content families must exist, what domain semantics must they support, what visual/runtime contrasts must be represented, and what is their production state?

It is deliberately cross-cutting:

```text
functional domain
+ interactions/composition
+ environment/evidence
+ art/model requirements
+ runtime adapters
+ production backlog
```

It is **not** the authority for domain primitive semantics. Canonical meaning remains in `DOMAIN_*`; visual language remains in `VISUAL_GUIDE.md` + `art/`; runtime asset conventions remain in `ASSET_SPEC.md` / `ASSET_PIPELINE.md`.

Historical breadth lives in `brainstorming/functional-asset-catalog/`. Do not use those rounds as a production backlog when a normalized row exists here.

---

## Files

- [`ENTITIES.md`](ENTITIES.md) — physical entities, resources, components, containers, tools, salvage and comfort props.
- [`PROJECTS.md`](PROJECTS.md) — persistent project goals and composed structures/configurations.
- [`LIVING_WORLD.md`](LIVING_WORLD.md) — places/terrain, flora, fauna, habitats and cross-family environmental presentation requirements.
- [`SCENE_COVERAGE.md`](SCENE_COVERAGE.md) — regression of the normalized catalog/domain against the 40 representative historical scenes, including accepted reshapes and remaining content follow-ups.

---

# 1. Authority rules

A catalog row may reference:

```text
EntityDefinition
ActorProfileDefinition
PlaceDefinition / PlaceState presentation
ProjectDefinition
AssemblyDefinition
MaterialDefinition
properties / capabilities / relations
interaction regions
actions / transformations
environmental responses/processes
perceptual evidence requirements
presentation adapters
```

A row must **not** invent a parallel simulation primitive merely because it is convenient for art/content planning.

Before introducing a new semantic term, ask:

1. Is it already an admitted property/capability/relation/predicate/effect/action/domain concept?
2. Is it a derived affordance rather than authored truth?
3. Is it a presentation band over an authoritative property/process?
4. Is it Wilson-relative knowledge/association rather than world truth?
5. Is it an art/runtime adapter rather than domain identity?
6. Which concrete gameplay requirement fails without a new primitive?

If the answer really requires a new domain concept, use the domain-gap protocol: justify it against product/representative behavior and update the canonical owning domain document explicitly.

---

# 2. Production status versus functional spec

These are independent dimensions.

## `Status` — model/content production

```text
TODO
BRIEFED
BLOCKOUT
SELF_REVIEW
INDEPENDENT_REVIEW
APPROVED
DEFERRED
```

Changing a model does not automatically change the functional brief.

## `Spec` — functional normalization

```text
UNREVIEWED  // not yet checked against canonical domain
PARTIAL     // useful brief exists but material semantics remain unresolved
ALIGNED     // sufficient and unambiguous under the current canonical domain
BLOCKED     // a demonstrated domain gap prevents an aligned brief
```

`ALIGNED` means the row is ready to guide content/model/runtime-adapter work. It does **not** mean the asset exists or is approved.

---

# 3. Priority

```text
P0  vertical-slice/core systemic grammar
P1  broad systemic expansion
P2  later authored richness / expensive expansion
```

Priority expresses content/systemic leverage, not implementation dependency by itself.

---

# 4. Compact semantic token grammar

Tables intentionally group related dimensions to remain readable. Use these prefixes consistently inside cells.

| Token | Meaning |
|---|---|
| `mat:` | material/profile assumption |
| `prop:` | authoritative/effective physical property |
| `cap:` | true reusable capability |
| `aff:` | derived/contextual affordance |
| `rel:` | world relation/configuration |
| `role:` | semantic assembly/project role |
| `slot:` | bounded assembly slot/compatibility role |
| `region:` | semantic `InteractionRegion` requirement |
| `xform:` | transformation/lifecycle descendant |
| `env:` | environmental response/process/exposure requirement |
| `band:` | visual/presentation band grounded in authoritative semantics |
| `evidence:` | content-specific perceptual evidence/accessibility requirement |
| `act:` | generic action participation |
| `scene:` | representative-scene/behavioral coverage |
| `project:` | project dependency/use |
| `intervention:` | authored player intervention support when object-specific |

Tokens are catalog shorthand, **not new domain types**.

Use canonical IDs/names where already admitted. Human-readable action/role shorthand may remain until concrete registries are created, but it must preserve the existing semantic distinction rather than imply an object-pair recipe.

---

# 5. What belongs in each grouped column

## Domain / material

Use for:

- definition kind (`EntityDefinition`, `ActorProfileDefinition`, `PlaceDefinition`, `AssemblyDefinition`, etc.);
- material/profile source;
- category/type identity only when useful to the brief.

## Physical semantics

Use for:

```text
prop:
cap:
aff:
```

Keep them visibly distinct.

Examples:

```text
prop: hardness=HIGH
cap: impact_surface
aff: use-as-impact-tool
```

Do not write:

```text
cap: heavy
cap: throwable
```

when these are magnitude/context-derived.

## Composition / regions

Use for:

```text
rel:
role:
slot:
region:
```

Art sockets/anchors may be mentioned in the production column, but domain identity must never depend on names such as `SOCKET_TOOL_HEAD`.

## Lifecycle / environment / evidence

Use for:

```text
xform:
env:
band:
evidence:
```

A presentation word such as `wet`, `broken`, `full`, `open`, `fallen` or `repaired` must make clear what authoritative cause/projection grounds it.

## Actions / coverage

Use for:

```text
act:
project:
scene:
```

This expresses required participation in the generic grammar, not an object-specific callback list.

## Art / production

Keep:

- art reference/sheet;
- procedural/modular/manual strategy;
- mandatory gameplay-camera contrasts;
- anchor/socket/adapter needs;
- exceptional asset brief requirement.

Do not repeat the visual guide.

---

# 6. Stable identity rule

The row `Family` value is the intended stable **catalog/content identity** unless explicitly marked as a production-only/presentation family.

Preferred patterns:

```text
stone_small
coconut_whole
project.shelter_basic
plant.palm_coconut
animal.crab_recurring
terrain.sand
```

One row may map to multiple GLBs/presentation variants.

Do not create new identities for every condition band:

```text
hammer_loose
wet_branch
fallen_frond
full_barrel
```

when ordinary state/configuration already distinguishes them.

---

# 7. Transformation descendants

Use a separate row when a transformation result has independent gameplay identity/semantics after the transition.

Good examples:

```text
coconut_whole
→ coconut_shell_half + coconut_meat_piece / contained liquid

animal.fish_small
→ fish_food_small_medium
```

Do not use a separate row only because art needs another visual band.

Detached reusable components normally keep/reveal their ordinary component family identity:

```text
palm frond attached to palm
→ same palm_frond entity detached/fallen
```

rather than creating `fallen_palm_frond`.

---

# 8. Assembly and project rules

## Assembly

Tool/structure composition uses semantic slots/roles and predicates.

Catalog example:

```text
slot: role.handle
slot: role.impact_head
slot: role.binding
```

Compatible catalog families may be listed as examples, not as an exhaustive recipe.

```text
branch_small
fiber_vine
stone_small
```

may satisfy a tool assembly if their effective semantics pass the predicates.

`AssemblyValidity` remains separate from performance.

## Projects

Project rows describe:

```text
ProjectDefinition intent/lifecycle
+ required semantic contribution roles
+ completion predicate expectations
+ physical/presentation milestones
```

Physical structure truth remains in World:

```text
entities
properties
relations
assembly bindings
protection/exposure
```

Do not put duplicate roof integrity, container contents, buoyancy or structural quality into Project state.

---

# 9. Environment and presentation bands

State words are often production bands, not lifecycle enums.

Preferred mappings:

```text
moisture
→ dry / damp / wet / soaked

freshness
→ fresh / aging / spoiled

cooking_progress + burn_level
→ raw / cooked / burned

structural_integrity
→ intact / damaged / broken

contents quantity / fill_ratio
→ empty / partial / full
```

Environment-sensitive content should reference reusable rules/projections:

```text
EnvironmentalResponseRule
ProtectionProjection / ExposureResult
DynamicProcessState where a process spans causal boundaries
```

Do not create asset rows for results such as `wet_material`, `roof_damage`, `fallen_branch` or `light_prop_displaced` unless the result itself becomes an independently persistent modeled entity with distinct semantics.

`LIVING_WORLD.md` contains the shared production requirements for these cross-family outcomes.

---

# 10. Wilson-facing evidence

Only record evidence in a row when the asset must expose a **content-specific perceptual contrast**.

Examples:

```text
transparent vs opaque container
visible dent / lid shift
rattle from internal movable contents
palm cracks/lean before a fall
recognizable recurring animal identity
```

Do not store:

```text
explored
known
familiar
favorite
suspicious
```

on physical content. Those are Wilson-relative state/projections.

---

# 11. Player intervention

Record `intervention:` only where the content requires a specifically authored intervention capability/constraint.

Ordinary portable-object manipulation may be inherited from a reusable intervention definition when the runtime content registry is implemented.

Rules:

- enough God Power does not make an unsupported entity movable;
- intervention changes World truth first;
- Wilson reacts only through perception/attribution afterward;
- intervention must respect causal windows/action commitment;
- the catalog must never encode direct trust/dependency/emotion effects from player intent.

---

# 12. Presentation-only rows and production artifacts

Some reusable outputs are legitimate production requirements but not world entities.

Examples:

```text
PlaceState terrain presentation
procedural storm-debris placement generator
perch transform adapters
body-slot presentation adapters for qualified possession relations
shared moisture material treatment
```

Such rows/sections must explicitly state their mapping and must not receive fake `EntityTypeId`s.

---

# 13. Catalog admission rule

Before adding a family:

1. Is it a reusable gameplay/content identity, transformation descendant, stable place/feature, actor/habitat or justified presentation family?
2. Can the need be represented as a state/contrast on an existing family instead?
3. Is it only a process outcome, adapter or generated arrangement?
4. Which project, generic interaction, environmental rule or representative behavior needs it?
5. Does it add systemic leverage rather than mere island plausibility?
6. Is the proposed priority justified?

If a row exists only because a brainstorming round named it, do not admit it automatically.

---

# 14. Production workflow

Typical flow:

```text
Spec=ALIGNED + Status=TODO
→ BRIEFED where clarification is actually needed
→ BLOCKOUT
→ SELF_REVIEW
→ INDEPENDENT_REVIEW
→ APPROVED
```

Agents should:

1. read this README;
2. read the row and referenced canonical domain/art docs;
3. preserve required functional contrasts during modeling;
4. add only the adapters/regions/variants the row requires;
5. update `Status` as production advances;
6. update `Spec` only when the functional brief itself changes.

A row may be `APPROVED` visually while later becoming `PARTIAL` functionally if new gameplay evidence exposes a requirement; these dimensions intentionally do not collapse.

---

# 15. Functional completeness gate

The current normalized catalog gate passes when:

- every P0 row has an explicit domain mapping or explicit presentation-only reason;
- P1 rows are structured enough to avoid semantic reverse-engineering;
- properties/capabilities/affordances remain visibly separate;
- tools and projects use semantic roles/composition rather than recipes;
- transformations and detachable descendants are explicit where identity matters;
- environment/protection/hazard requirements are attached to real families/processes;
- content-specific evidence requirements are represented without duplicating Wilson beliefs;
- pseudo-assets/process outcomes/adapters are reclassified;
- art references and production status remain independent;
- any future domain gap is surfaced rather than hidden in a catalog token.

`SCENE_COVERAGE.md` is the behavioral regression companion for this gate. It confirms domain/game-loop coverage for the accepted 40-scene phenomenon suite, records two canonical reshapes, and tracks localized content/presentation follow-ups before exhaustive scene-content coverage is claimed.

The target remains:

```text
small canonical domain vocabulary
+ normalized cross-cutting content families
+ composition
+ persistent history
+ explicit production status
= broad emergent scene coverage
```
