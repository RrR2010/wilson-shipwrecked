# Functional Asset Catalog Brainstorming — Round 10

## Scope

This round normalizes the domain-facing terminology used across Rounds 1–9 after review against the functional domain model.

The earlier rounds remain useful brainstorming and production references. This document does **not** invalidate their object ideas. It clarifies how repeated terms should be interpreted so the asset catalog does not accidentally force the implementation into hundreds of flags, bespoke state machines or recipe-like object logic.

When a terminology conflict exists, use this round for domain interpretation and keep the earlier wording as visual/design shorthand.

---

# 1. Normalization rule

Every brainstormed object trait should first be classified as one of:

```text
PROPERTY
CAPABILITY
DERIVED AFFORDANCE
WORLD RELATION / ASSEMBLY CONFIGURATION
ENVIRONMENTAL RESPONSE
PRESENTATION BAND
CONTENT / AUTHORING METADATA
WILSON-RELATIVE KNOWLEDGE / ASSOCIATION
```

Do not promote every useful descriptive word into a domain capability or object state.

---

# 2. Properties

Use a property when a magnitude, ordered grade or value matters.

High-leverage physical properties currently implied across the catalog include:

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

Examples of earlier shorthand that should normally map to properties:

```text
heavy              → mass_class HIGH
lightweight         → mass_class LOW
sharp               → sharpness HIGH
blunt               → sharpness LOW / impact form
flexible            → flexibility
rigid               → rigidity
absorbent           → absorbency
waterproof-ish      → water_resistance
heat-resistant      → heat_resistance
unstable            → stability LOW
wet / soaked        → moisture bands
worn / damaged      → structural_integrity bands where appropriate
```

This distinction is especially important for tools, weather response and loaded containers.

---

# 3. True capabilities

Use a capability when the object can participate in a reusable semantic role.

Examples:

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

Capabilities should not guarantee effectiveness. Properties and context determine whether a particular action succeeds.

Example:

```text
cutting_edge
```

means that the object can participate as a cutting edge. Its `sharpness`, integrity, reach and target resistance determine effectiveness.

---

# 4. Derived affordances

The following should generally be **derived from physical profile + context**, not authored as universal boolean capabilities:

```text
portable
carry-small
carry-large
two-hand-carry
throwable
drag-able
pushable
rollable
stackable
hangable
placeable-on-surface
```

Examples:

```text
small stone
  graspable + low mass + low bulk
  → one-hand carry + throw

bowling ball
  graspable + very high mass + awkward bulk
  → two-hand carry / roll
  → ordinary throw filtered out

full barrel
  same container geometry
  + heavy contents
  → push/roll may remain
  → ordinary carry disappears
```

This reduces authored flag count and allows the same object to gain/lose affordances dynamically.

---

# 5. Material interpretation

Repeated material words across the rounds should be treated as reusable material profiles rather than duplicated property bundles on every asset.

Initial material vocabulary may include:

```text
wood
stone
metal
glass
cloth
fiber
shell
bone
plant_matter
```

Materials provide coarse defaults only. Object form and condition may override them.

Example:

```text
metal sheet
!=
metal rod
```

even though both inherit broad metal-like defaults.

Do not extend into detailed metallurgy or engineering constants unless a representative gameplay need requires it.

---

# 6. Composite tools

Tool-family descriptions from Round 3 should be interpreted as bounded semantic assemblies.

Preferred model:

```text
material/component properties
+ semantic assembly slots
+ current condition
→ effective physical profile
→ derived tool affordances
```

Example:

```text
handle
+ hard/heavy head
+ binding
→ impact-capable assembled tool
```

This is not a fixed `hammer recipe`.

A loose binding should reduce the tool's effective behavior without requiring a new entity type such as `hammer_loose`.

Tool state terms such as:

```text
tight
loose
frayed
chipped
dull
bent
cracked
```

should usually map to a small number of underlying properties on the relevant component.

---

# 7. Assembly slots versus art sockets

Earlier rounds use names such as:

```text
SOCKET_TOOL_HEAD
SOCKET_HANDLE
SOCKET_ROOF_*
SOCKET_FLOAT_*
```

Interpret these in two layers:

```text
DOMAIN:
  semantic assembly slot + compatibility predicate

ART/RUNTIME ADAPTER:
  transform/socket/anchor used to place the visual component
```

The domain must not depend on Blender/Godot socket names.

Compatibility is semantic and bounded, not free-form attachment of arbitrary objects to arbitrary surfaces.

---

# 8. Object condition and presentation states

The shared state vocabulary in Round 9 remains valuable for art production, but many entries should be presentation bands over smaller authoritative properties.

Preferred mappings:

```text
moisture
  → dry / damp / wet / soaked

freshness
  → fresh / aging / spoiled

cooking_progress + burn_level
  → raw / prepared / cooked / burned

structural_integrity
  → intact / worn / damaged / broken

fill_ratio
  → empty / partial / full / overfilled
```

`drying`, `recovering`, `burning`, etc. may represent active environmental processes rather than mutually exclusive object states.

Use explicit lifecycle enums only when transition identity itself matters.

---

# 9. Mystery containers and exploration

Earlier states such as:

```text
unexplored
inspected
attempted_opening
contents_revealed
```

must **not** be interpreted as authoritative physical container states.

Separate:

```text
WORLD:
  sealed/open
  dented/damaged
  contents
  transparency/material/form

WILSON KNOWLEDGE:
  observed appearance
  inferred material
  inferred weight
  inferred contents
  opening behavior learned
  confidence by proposition

HISTORY:
  attempted actions / episodes
```

An object is not physically `unexplored`; Wilson simply has little evidence about it.

This enables gradual exploration:

```text
look   → color / visible form
hold   → weight / tactile clues
shake  → internal-motion evidence
strike → resistance/material evidence
open   → direct content evidence
```

---

# 10. Transparent versus opaque containers

Without introducing new simulation systems, asset variants should include at least one useful transparency contrast where practical:

```text
transparent bottle/jar
opaque bottle/container
```

This is a cheap regression for perceptual evidence rules:

```text
same contents
+ different visual accessibility
→ different Wilson evidence
```

Transparency itself may be represented as a property/material semantic rather than a special interaction.

---

# 11. Weather-response normalization

Round 8 responses should be modeled as generic environment × object semantics, not type-specific weather code.

Examples:

```text
rain
+ exposed
+ absorbency high
→ moisture increases

sun
+ wet exposed object
→ drying process

wind
+ low stability
+ sufficiently low effective mass
+ exposed
→ displacement candidate

rain
+ exposed fire
+ insufficient covering
→ burn level decreases / extinguishes
```

Therefore terms such as:

```text
wind-displaceable
wind-dangerous
rain-sensitive
```

are useful design categories but should usually derive from properties/configuration rather than become permanent capabilities.

---

# 12. Contents affect host properties

Containers should support effective physical properties derived from contents.

Required cheap regression:

```text
same barrel asset
  empty
  vs water-filled
```

Expected systemic consequences may differ in:

```text
effective mass
carry affordance
push effort
rolling hazard severity
buoyancy
```

Do not require different object types for loaded/unloaded variants.

---

# 13. Configuration changes function

The same asset may gain new semantic function from world configuration.

Required cheap regression:

```text
cloth sheet loose on ground
vs
cloth sheet attached/tensioned across supports
```

The second configuration may derive:

```text
covering
shade/rain-protection behavior
wind-load behavior
```

without turning the cloth into a different hard-coded object family.

Similar reuse applies to:

```text
flat rock → seat / work surface / hot-stone cooking surface
crate → storage / seat / work surface / obstacle
barrel → storage / rolling hazard / raft float candidate
pole → reach tool / structure / lever candidate
```

---

# 14. Personalization terminology

The following Round 9 terms should be treated as content/authoring metadata or emergent cognition semantics rather than physical capabilities:

```text
collectible
displayable
preference-capable
personal-location-capable
persistent-instance-worthy
repair-history-visible
```

Examples:

```text
favorite cup
favorite seat
retired tool
shell collection
```

should emerge from:

```text
persistent EntityId
+ associations
+ habits
+ episodes
+ stable placement relations
```

not from a `favorite` capability flag.

---

# 15. Low-cost regression contrasts to preserve in asset planning

These contrasts add high domain value without substantially increasing asset-production difficulty.

## 15.1 Barrel

```text
empty
water-filled
```

Tests contents-derived effective properties.

## 15.2 Improvised hammer

```text
tight binding
loose/repaired binding
```

Tests component condition → effective capability.

## 15.3 Cloth

```text
loose
attached/tensioned
```

Tests configuration-derived behavior.

## 15.4 Container

```text
transparent
opaque
```

Tests perceptual evidence accessibility.

## 15.5 Coconut

```text
whole
opened
empty shell reused as bowl/cup
```

Tests transformation + repurposing.

## 15.6 Shelter

```text
complete
panel detached
repaired with mismatched compatible panel
```

Tests world-component truth, weather damage and repair history.

## 15.7 Bowling ball

Keep as a rare absurd regression object:

```text
heavy
rollable
hard
awkward to carry
```

It must participate in ordinary physical rules, not special-case coconut logic.

---

# 16. Things to keep later/P2

The following remain valid brainstorming but should not drive new core primitives yet:

```text
free-form rope physics
universal pulley/hoist simulation
complex fluid dynamics
advanced erosion topology
large-scale flood simulation
advanced fire propagation
fine electrical/conductivity mechanics
fully general vehicle physics
free-form structural engineering
```

Prefer bounded authored structures and coarse semantic properties until representative scenes justify more.

---

# 17. Catalog interpretation gate

When adding or reviewing an asset family, verify:

1. Are descriptive magnitudes properties rather than capability flags?
2. Are action possibilities derived affordances where context matters?
3. Can configuration/contents change effective behavior without changing entity type?
4. Are art states presentation bands where possible?
5. Are knowledge terms Wilson-relative rather than world state?
6. Are sockets separated from domain assembly semantics?
7. Does weather use generic response rules?
8. Can unusual objects reuse ordinary interaction rules?
9. Is a new primitive truly required by gameplay rather than by asset naming convenience?

The intended outcome is:

```text
small semantic domain vocabulary
+ broad visual family vocabulary
+ composition
+ persistent history
= high procedural variety
```
