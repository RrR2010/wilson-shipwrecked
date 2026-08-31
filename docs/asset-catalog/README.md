# Asset Catalog

## Purpose

This directory is the cross-cutting source of truth for **what world/content families exist or are planned, what semantic roles they must support, what visual/interaction contrasts matter, and what remains to be produced**.

It is intentionally outside `docs/art/` because one catalog row may span:

- domain identity and material/profile assumptions;
- authoritative properties and true capabilities;
- derived affordances;
- relations, semantic assembly and interaction regions;
- transformations, environmental response and protection participation;
- Wilson-accessible evidence requirements where content-specific;
- project/representative-scene coverage;
- art references, anchors/adapters and production strategy;
- production status.

The catalog is **content data and production planning**, not a second simulation schema. Canonical semantics remain in the stabilized `DOMAIN_*` documents.

For the repository-wide documentation map, see [`../README.md`](../README.md).

---

## Catalog split

- [`ENTITIES.md`](ENTITIES.md) — physical entity/resource/component/container/tool/salvage/comfort families, including transformation descendants that need their own authored definition.
- [`PROJECTS.md`](PROJECTS.md) — persistent project goals and reusable composed structures/configurations.
- [`LIVING_WORLD.md`](LIVING_WORLD.md) — terrain/place presentation, flora, fauna, habitats and cross-family environmental presentation requirements.

The split is organizational, not a runtime inheritance hierarchy. Move or reframe a row when its semantics fit another file better; do not invent a domain type merely to preserve a table section.

The brainstorming rounds in `../brainstorming/functional-asset-catalog/` are recall/history sources only. They are not a competing backlog.

---

## Authority boundaries

For functional semantics, the normal authority path is:

```text
DOMAIN_MODEL.md
→ DOMAIN_VOCABULARY.md
→ DOMAIN_CATALOGS.md
→ DOMAIN_OPERATIONS.md
→ DOMAIN_OPERATION_REFINEMENTS.md where it supersedes an older signature
→ DOMAIN_PROCEDURAL_COMPOSITION.md
```

Consult specialized appendices only when relevant:

```text
DOMAIN_ENVIRONMENTAL_PROTECTION.md
DOMAIN_HAZARD_DYNAMICS.md
DOMAIN_EPISTEMIC_INVESTIGATION.md
DOMAIN_MICRO_LOOP.md
```

Other owners:

- `../PRODUCT.md` / behavioral documents own player/Wilson product semantics;
- `../VISUAL_GUIDE.md` and `../art/` own visual language;
- `../ASSET_SPEC.md` owns runtime asset structure/anchor/socket conventions;
- `../ASSET_PIPELINE.md` owns Blender/export/runtime production workflow.

If a row cannot be expressed using existing domain semantics, use the domain-gap protocol in the normalization handoff rather than silently adding a new primitive in the catalog.

---

# Normalized row model

The catalog deliberately uses a **small common column set plus terse semantic tokens**. This keeps rows readable while preserving the distinctions needed by modeling/content agents.

A row normally answers:

```text
what is it?
→ what domain definition/configuration owns it?
→ what physical semantics matter?
→ how can it compose / be targeted?
→ what transformations/environment/evidence must remain legible?
→ which generic actions/projects/scenes need it?
→ what must art/production provide?
```

Not every row needs every token.

## Functional specification status

`Spec` is independent from model/content production `Status`.

```text
UNREVIEWED  identified but not normalized against the current domain
PARTIAL     domain direction is valid, but important row requirements remain underspecified
ALIGNED     domain mapping and required functional dimensions are explicit enough to brief production
BLOCKED     a demonstrated reusable requirement cannot be expressed by the current domain
```

`ALIGNED` does **not** mean the model exists. It means functional/content specification is sufficiently normalized.

Use `BLOCKED` only with an explicit domain-gap note and supporting requirement/scene.

---

# Cell token grammar

Use these prefixes inside grouped cells. They are documentation shorthand, not implementation syntax.

| Token | Meaning |
|---|---|
| `mat:` | `MaterialDefinition` assumption/default, when materially relevant. |
| `prop:` | Authoritative or effective `PropertyId` values/bands that materially affect gameplay. Prefer canonical names. |
| `cap:` | True authored/effective `CapabilityId` participation semantics. |
| `aff:` | Derived/contextual affordances such as one-hand carry, drag, throw, roll, stack or use-as-tool. |
| `rel:` | Relevant authoritative `WorldRelation` such as `inside`, `on_top_of`, `attached_to`, `part_of`. |
| `role:` | Semantic `AssemblyRoleId` / project contribution role. A role is not a capability. |
| `slot:` | Bounded semantic assembly slot when an authored host/archetype requires one. |
| `region:` | `InteractionRegionDefinition` requirement such as lid edge, handle, weak joint or repair point. |
| `xform:` | Content-specific transformation/result requirement triggered by semantic outcomes. |
| `env:` | Environmental response, protection/exposure or dynamic-process participation. |
| `band:` | Presentation band derived from authoritative properties/configuration. |
| `evidence:` | Asset-specific perceptual accessibility requirement; never Wilson belief state. |
| `act:` | Generic action/participant roles the family must support. |
| `scene:` | Representative-scene/systemic coverage worth preserving. |
| `project:` | Project dependency/use where backlog ordering benefits from it. |
| `intervention:` | Only non-default per-object player-intervention behavior that must be authored. |

Keep tokens terse. If one row needs a paragraph to explain semantics, first check whether the behavior belongs in a canonical domain document rather than the catalog.

---

# Canonical semantic separations

Catalog rows must preserve:

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

Do not add convenience fields such as:

```text
recipe
favorite
owned_by_wilson
explored_percent
known
unexplored
rival
sacred
tool_quality
structure_quality
shelter_quality
```

unless a future canonical domain change explicitly admits such a concept.

---

# Property / material conventions

Prefer the high-leverage physical vocabulary already admitted by `DOMAIN_PROCEDURAL_COMPOSITION.md`:

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
heat_resistance
structural_integrity
binding_integrity
stability
moisture
temperature
freshness
cooking_progress
burn_level
fill_ratio
```

Other bounded content properties are allowed when a real behavior needs them, for example `capacity_class`, form/visibility/closure semantics or resource quantity. Do not invent fake engineering precision; coarse grades/bands are preferred.

Common material IDs include:

```text
material.wood
material.stone
material.metal
material.glass
material.cloth
material.fiber
material.shell
material.bone
material.plant_matter
```

Material defaults never replace form-specific properties.

---

# Capability / affordance conventions

Use true capabilities for reusable participation roles, for example:

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

Prefer deriving these as affordances rather than authoring permanent flags when context matters:

```text
carry_one_hand
carry_two_hands
drag
push
throw
roll
stack
hang
sit_here
use_as_impact_tool
use_as_cutting_tool
```

A capability means participation is semantically valid; it never guarantees effectiveness.

---

# Composition and project roles

Semantic assembly/project roles are intentionally interchangeable. Typical catalog shorthand includes:

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

These names are content-level `AssemblyRoleId` examples, not new state owners. Slot compatibility is expressed through predicates over properties/capabilities, not exact object-type recipes.

Example:

```text
role.covering
  requires cap: covering
  + sufficient effective span/coverage for the target configuration
```

A cloth sheet, thatch panel or compatible salvage panel may therefore fill the same role with different effective protection.

Project rows reference stable catalog families when one is genuinely required and semantic roles when multiple families are intentionally interchangeable.

---

# Transformation-descendant rule

Create a separate catalog row only when the descendant needs an independent authored definition/identity, capability set, interaction geometry or reusable production form.

Prefer:

```text
property/presentation band
```

when only condition/appearance changed.

Prefer:

```text
transformation result / detached component
```

when the result becomes independently manipulable or gains materially different semantics.

Examples in the normalized catalog:

- a whole coconut transforms into reusable shell/contents definitions rather than requiring parallel `whole`, `opened`, and `bowl` identities for the same shell;
- living fish and fish-as-food are distinct because the living form has actor semantics while the food result does not;
- detached fronds/branches remain the ordinary frond/branch families with changed relations/state, not special `fallen_*` entity types.

---

# Environmental and presentation-state rule

Weather/content states such as:

```text
dry / damp / wet / soaked
fresh / aging / spoiled
raw / cooked / burned
intact / damaged / broken
empty / partial / full
```

are normally `band:` projections over authoritative properties.

Processes such as drying, fire consumption, spoilage, storm weakening or wave wash-up remain environmental/world processes.

Cross-family outcomes such as `wind displaced`, `fallen after detachment`, `roof leak`, or `storm debris pile` are not automatically catalog entities. `LIVING_WORLD.md` records the production requirements for these outcomes without creating fake world types.

Protection follows configuration:

```text
cap: covering
+ attachment/orientation/coverage/integrity
→ ProtectionProjection
→ ExposureResult
```

Do not encode universal `indoors`, `roof_leak_level` or per-type weather immunity.

---

# Wilson-facing evidence rule

Only record `evidence:` when the family requires specific sensory accessibility or persistent recognition.

Examples:

```text
transparent vs opaque container
visible lid edge
rattle-accessible movable contents
recognizable recurring crab identity
visible repair mismatch
```

The catalog never stores:

```text
Wilson knows X
contents revealed
inspected
favorite
```

Those are cognition/history projections.

---

# Art / production contract

Preserve in each row where relevant:

- reference sheet (`Ref NN` / `docs/art/reference/REFERENCE_*.md`);
- procedural/modular/hybrid/manual strategy;
- required visible contrasts;
- interaction-region presentation adapters;
- assembly/attachment sockets where a stable adapter is useful;
- model-production notes that materially affect interchangeability/readability.

Art sockets/adapters may map to semantic slots/regions but never define domain identity.

---

# Production status

`Status` tracks model/content production lifecycle only:

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
| `BRIEFED` | Functional/art inputs are sufficiently specified for production. |
| `BLOCKOUT` | A model/content implementation exists but has not passed review. |
| `SELF_REVIEW` | Creator is iterating against applicable contracts. |
| `INDEPENDENT_REVIEW` | Independent review is in progress. |
| `APPROVED` | Accepted for the current milestone. |
| `DEFERRED` | Explicitly outside current production scope. |

A family should normally reach `Spec=ALIGNED` before moving from `TODO` to `BRIEFED`.

---

# Priority

- `P0` — vertical-slice/systemic vocabulary; establish the reusable grammar first.
- `P1` — meaningful systemic expansion after P0 grammar works.
- `P2` — authored richness/long-run expansion; normally deferred.

Priority reflects content dependency/systemic leverage, not visual complexity.

---

# Agent consumption

A modeling/content agent should normally follow:

```text
catalog row
→ canonical domain contract only where semantics need clarification
→ art reference / visual sheet
→ optional family brief for unusually complex assets
→ production/review pipeline
→ update production Status
```

A catalog-maintenance agent should update `Spec` independently from production `Status`.

Do not search the brainstorming rounds to discover routine requirements once a family has an `ALIGNED` catalog row.

---

# Normalization result

The 2026-08-31 functional-domain pass:

- introduced the independent `Spec` gate and compact token grammar;
- normalized P0 and current P1 families against the stabilized property/capability/affordance/composition vocabulary;
- added missing foundational construction, tinder, water, mushroom, clothing and utility families demonstrated by product/scene/content coverage;
- removed/reclassified fake entity rows that were actually presentation bands, environmental outcomes or adapter vocabulary;
- normalized project rows toward semantic component roles rather than prose recipes;
- preserved art references and production status separately;
- found **no new broad domain primitive requirement**.

Future rows should use the same schema and admission rules.
