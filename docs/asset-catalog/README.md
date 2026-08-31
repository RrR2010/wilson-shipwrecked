# Asset Catalog

## Purpose

This directory is the cross-cutting source of truth for **which modeled/content families are required, which functional contrasts they must support, and what remains to be produced**.

It is outside `docs/art/` because one row may connect:

```text
domain semantics
+ interactions/composition/lifecycle
+ Wilson-visible evidence requirements
+ project/scene coverage
+ art/adapters
+ production status
```

The catalog is content specification and production planning, **not a second simulation schema**. Canonical semantics remain in the stabilized `DOMAIN_*` documents.

Catalog split:

- [`ENTITIES.md`](ENTITIES.md) — physical entities, resources, components, containers, tools, salvage and comfort props;
- [`PROJECTS.md`](PROJECTS.md) — persistent project goals and composed structures/configurations;
- [`LIVING_WORLD.md`](LIVING_WORLD.md) — terrain/place presentation, flora, fauna, habitats and cross-family environmental presentation requirements.

The split is organizational, not a runtime inheritance hierarchy.

Historical breadth lives in `../brainstorming/functional-asset-catalog/`; it is recall evidence, not a competing backlog.

---

# Authority

Use the smallest applicable canonical bundle:

```text
DOMAIN_MODEL.md
→ DOMAIN_VOCABULARY.md
→ DOMAIN_CATALOGS.md
→ DOMAIN_OPERATIONS.md
→ DOMAIN_OPERATION_REFINEMENTS.md when it supersedes an older signature
→ DOMAIN_PROCEDURAL_COMPOSITION.md
```

Then consult specialized appendices only when relevant:

```text
DOMAIN_ENVIRONMENTAL_PROTECTION.md
DOMAIN_HAZARD_DYNAMICS.md
DOMAIN_EPISTEMIC_INVESTIGATION.md
DOMAIN_MICRO_LOOP.md
```

Other owners:

- product/Wilson semantics — `PRODUCT.md`, behavioral/state documents;
- visual language — `VISUAL_GUIDE.md`, `art/`;
- runtime asset adapters — `ASSET_SPEC.md`;
- production workflow — `ASSET_PIPELINE.md`.

If a row cannot be expressed using existing domain semantics, document the demonstrated requirement and review the canonical domain owner explicitly. Do not invent a primitive only in the catalog.

---

# Row model

Use **compact common columns + terse semantic tokens**. A row should let an agent answer:

```text
what is it?
→ what domain definition/configuration owns it?
→ what physical semantics matter?
→ how can it compose/be targeted?
→ which lifecycle/environment/evidence contrasts matter?
→ which generic actions/projects/scenes need it?
→ what must production supply?
```

Not every row needs every token.

## Functional specification status

`Spec` is independent from model/content production `Status`.

| Spec | Meaning |
|---|---|
| `UNREVIEWED` | Identified but not normalized against the current domain. |
| `PARTIAL` | Direction is valid, but important functional requirements remain underspecified. |
| `ALIGNED` | Domain mapping and required functional dimensions are explicit enough to brief downstream work. |
| `BLOCKED` | A demonstrated reusable requirement cannot currently be expressed by the canonical domain. |

`ALIGNED` does not mean the asset/model exists. Use `BLOCKED` only with a concrete domain-gap justification.

---

# Semantic token grammar

Tokens are documentation shorthand, not implementation syntax.

| Token | Use |
|---|---|
| `mat:` | Relevant `MaterialDefinition` assumption/default. |
| `prop:` | Authoritative/effective property values or bands materially used by gameplay. |
| `cap:` | True capability participation semantics. |
| `aff:` | Derived/contextual affordances such as carry, drag, throw, roll, stack or use-as-tool. |
| `rel:` | Relevant authoritative world relations such as `inside`, `on_top_of`, `attached_to`, `part_of`. |
| `role:` | Semantic assembly/project component role; **not a capability**. |
| `slot:` | Bounded semantic assembly slot on an authored host/archetype. |
| `region:` | Semantic `InteractionRegion` requirement such as lid edge, handle, weak joint or repair point. |
| `xform:` | Content-specific transformation/result triggered by semantic outcomes. |
| `env:` | Environmental response, protection/exposure or dynamic-process participation. |
| `band:` | Presentation band derived from authoritative properties/configuration/processes. |
| `evidence:` | Asset-specific sensory accessibility/recognition requirement; never Wilson belief state. |
| `act:` | Generic action/participant roles the family must support. |
| `scene:` | Representative-scene/systemic coverage worth preserving. |
| `project:` | Project dependency/use when useful for backlog ordering. |
| `intervention:` | Non-default per-object player-intervention requirement when content must author one explicitly. |

Keep cells terse. If a behavior requires a paragraph, first check whether it belongs in a canonical domain document instead.

---

# Normalization rules

Preserve these boundaries:

```text
Property != Capability != DerivedAffordance
WorldRelation / AssemblyConfiguration != Capability
world truth != Wilson observation != Wilson belief
AssemblyValidity != effective performance
ActionAttemptability != Wilson expected success
Effect != WorldEvent != ObservedEvent != Evidence
PresentationBand != authoritative state machine
art socket != InteractionRegion != Entity
Project lifecycle != duplicated physical structure state
```

Do not add convenience state such as:

```text
recipe
favorite
owned_by_wilson
explored_percent
known / unexplored
rival / sacred
tool_quality / structure_quality / shelter_quality
```

unless a later canonical domain change explicitly admits it.

## Properties and materials

Prefer the admitted high-leverage physical vocabulary when applicable:

```text
mass_class        bulk_class          hardness
sharpness         rigidity            flexibility
absorbency        water_resistance    buoyancy
flammability      heat_resistance     structural_integrity
binding_integrity stability            moisture
temperature       freshness           cooking_progress
burn_level        fill_ratio
```

Other bounded properties are allowed when real gameplay consumes them; use coarse semantic values rather than invented engineering precision.

Common material IDs include:

```text
material.wood   material.stone   material.metal
material.glass  material.cloth   material.fiber
material.shell  material.bone    material.plant_matter
```

## Capabilities and affordances

Typical reusable capabilities include:

```text
graspable        container          liquid_container
receives_impact  impact_surface     cutting_edge
binding_component structural_member covering
fuel             tinder             cookable
sittable         sleepable          work_surface
climbable        perchable          harvestable
habitat
```

Prefer deriving context-dependent affordances rather than authoring permanent flags:

```text
carry_one_hand   carry_two_hands   drag   push
throw            roll              stack  hang
sit_here         use_as_impact_tool use_as_cutting_tool
```

A capability permits participation; it does not guarantee effectiveness.

## Assembly and project roles

Use semantic interchangeable roles instead of object-type recipes. Common catalog roles include:

```text
role.support
role.frame_member
role.cross_member
role.brace
role.binding
role.covering
role.surface
role.container
role.float
role.runner
role.marker
role.repair_component
```

These are content-level `AssemblyRoleId` examples, not new state owners. Slot compatibility is expressed through predicates over capabilities/properties.

Example:

```text
role.covering
  requires compatible covering semantics
  + sufficient effective span/coverage for the configuration
```

Cloth, thatch or compatible salvage may therefore fulfill the same role with different effective behavior.

## Transformations and detachable components

Create a separate row only when a descendant needs independent authored identity, capability set, interaction geometry or reusable production form.

Prefer a property/presentation band when only condition changes.

Examples:

- coconut shell/contents are transformation descendants with independent reuse;
- living fish and fish-as-food are distinct because actor semantics disappear;
- detached fronds/branches reuse their ordinary entity families with changed relations/location.

## Environment and presentation bands

States such as:

```text
dry / damp / wet / soaked
fresh / aging / spoiled
raw / cooked / burned
intact / damaged / broken
empty / partial / full
```

normally derive from smaller authoritative properties/configuration. Drying, spoilage, fire consumption, storm weakening and wave wash-up are processes.

Cross-family outcomes such as displaced props, fallen components, roof leaks or storm debris do not automatically deserve entity rows. `LIVING_WORLD.md` records production requirements for these outcomes without inventing domain identities.

Protection follows configuration:

```text
covering semantics
+ attachment/orientation/coverage/integrity
→ ProtectionProjection
→ ExposureResult
```

## Wilson-visible evidence

Use `evidence:` only for content-specific sensory/recognition requirements, for example:

```text
transparent vs opaque container
visible lid edge
rattle-accessible movable contents
recognizable recurring crab identity
visible mismatched repair
```

Never store `inspected`, `known`, `favorite` or `contents_revealed` as physical asset state.

## Player intervention

`EntityDefinition.intervention_capabilities` remains domain/content data. Add `intervention:` to a row only when the family needs a meaningful authored exception or special behavior that downstream agents must preserve.

Do not infer that every graspable/carryable object is player-movable, and do not infer that structures/fires expose direct drag merely from their physical affordances. Product intervention rules remain authoritative.

Exact `InterventionCapabilityId` names should come from the canonical content registry when that registry is concretized; the catalog must not invent a parallel intervention taxonomy just to fill a column.

---

# Art and production

Preserve where relevant:

- reference sheet (`Ref NN` / `art/reference/REFERENCE_*.md`);
- procedural/modular/hybrid/manual strategy;
- mandatory visible contrasts;
- interaction-region presentation adapters;
- assembly/attachment sockets where stable adapters are useful;
- notes affecting interchangeability/readability.

Art sockets/adapters may map to semantic slots/regions but never define domain identity.

Production `Status` remains:

```text
TODO
BRIEFED
BLOCKOUT
SELF_REVIEW
INDEPENDENT_REVIEW
APPROVED
DEFERRED
```

A family should normally reach `Spec=ALIGNED` before moving from `TODO` to `BRIEFED`.

Priority:

- `P0` — vertical-slice/systemic vocabulary;
- `P1` — meaningful systemic expansion after P0 grammar works;
- `P2` — authored richness/long-run expansion; normally deferred.

---

# Agent workflow

Model/content production:

```text
catalog row
→ canonical domain clarification only when needed
→ art reference
→ optional family brief for unusual complexity
→ production/review pipeline
→ update production Status
```

Catalog maintenance updates `Spec` independently from production `Status`.

Do not return to brainstorming rounds for routine requirements once a family has an `ALIGNED` row.

---

# Initial normalization result — 2026-08-31

The first functional-domain pass:

- added the independent `Spec` gate and compact token grammar;
- normalized current P0/P1 entities, projects and living-world families against the stabilized domain;
- added missing foundational construction, tinder, water, mushroom, clothing and utility content;
- normalized tool/project composition toward semantic roles instead of recipes;
- reclassified fake entity rows that were actually presentation bands, environmental outcomes or adapters;
- preserved art references and production status separately;
- found **no new broad domain primitive requirement**.

Future rows should use the same admission and normalization rules.
