# Procedural Composition and Exploration Domain

## Status and purpose

This document is a canonical, language-neutral companion to `DOMAIN_MODEL.md`, `DOMAIN_VOCABULARY.md`, `DOMAIN_CATALOGS.md`, and `DOMAIN_OPERATIONS.md`.

It formalizes four refinements exposed by the functional asset catalog and the Scientific Method micro-loop:

1. effective physical properties/capabilities derived from runtime composition;
2. gradual exploration through perceptual evidence rather than object-level exploration percentages;
3. generic environmental response rules;
4. bounded semantic assembly slots for tools and structures.

The goal is greater procedurality without introducing free-form physics, recipes, universal script callbacks, or hundreds of object-specific state flags.

---

# 1. Core procedural principle

The authoritative world should answer interactions from composable semantics:

```text
authored definition
+ material profile
+ instance condition
+ runtime components/relations
+ contents
+ environmental context
--------------------------------
→ EffectivePhysicalProfile
→ valid physical affordances
→ interaction resolution
```

Wilson's cognition must separately answer what he currently believes about those semantics:

```text
world truth
→ perceptual accessibility
→ PerceptualEvidence
→ belief evidence
→ BeliefEntry confidence
→ tactical/intention candidates
```

Therefore:

```text
physical possibility != Wilson knowledge != Wilson desirability
```

---

# 2. Material profiles

Materials are now common enough across natural resources, salvage, tools and structures to justify a light authored domain concept.

```text
MaterialDefinition
  id: MaterialId
  default_properties: Map<PropertyId, PropertyValue>
  categories: Set<CategoryId>
```

Typical material IDs may include:

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

A material profile is not a realism simulator. It provides reusable coarse defaults such as:

```text
hardness
rigidity
flexibility
flammability
absorbency
water_resistance
heat_resistance
base_mass_density_class
```

Entity definitions may override material defaults where form matters.

Example:

```text
metal_sheet:
  material = metal
  thickness = LOW
  sharpness = MEDIUM

metal_rod:
  material = metal
  thickness = MEDIUM
  sharpness = LOW
```

Do not introduce detailed metallurgy, exact engineering constants, or material properties that are not used by representative gameplay.

---

# 3. EffectivePhysicalProfile

`EntityDefinition.capabilities` and base properties are not always the final physical semantics of a runtime object.

Composite tools, loaded containers, damaged structures and repurposed salvage require a derived view.

```text
EffectivePhysicalProfile
  subject: RuntimeWorldRef
  properties: Map<PropertyId, PropertyValue>
  capabilities: Set<CapabilityId>
  provenance: optional bounded derivation trace
```

It is derived state and should not normally be persisted as an independent authoritative store.

## 3.1 Resolution inputs

The resolver may read only authoritative world semantics:

```text
entity definition
material defaults
instance property overrides
part_of / attached_to / inside relations
component properties/capabilities
assembly slot bindings
condition properties
environmental state when the queried property is context-sensitive
```

It must not read Wilson beliefs, habits, associations or intentions.

## 3.2 Property derivation examples

### Loaded barrel mass

```text
effective_mass(barrel)
=
base container mass class
+ bounded contribution of contents quantity/material
```

The result may remain an ordered grade rather than exact kilograms.

### Improvised hammer impact capacity

```text
head mass
+ head hardness
+ handle leverage
+ binding integrity
→ effective impact capacity
```

### Raft buoyancy/stability

```text
float components
+ structural bindings
+ cargo load
+ damage/waterlogging
→ effective buoyancy/stability grades
```

### Cloth covering behavior

```text
cloth material properties
+ attached configuration
+ tension/condition
→ covering / rain-protection capability
```

## 3.3 Effective capability derivation

Capabilities may be:

1. **intrinsic authored** — e.g. a bowl can contain small items;
2. **material/form derived** — e.g. a sharpened edge can cut;
3. **assembly derived** — e.g. handle + head + binding creates a usable chopping tool;
4. **relation/configuration derived** — e.g. cloth attached across supports becomes a covering;
5. **contextual affordance only** — e.g. an object is throwable only because its current mass/bulk and Wilson's body state make throwing feasible.

Do not model every derived affordance as a persistent capability flag.

---

# 4. Properties versus capabilities versus derived affordances

Use these distinctions consistently.

## 4.1 Properties

Use properties when a magnitude/value matters.

Initial high-leverage physical properties:

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

## 4.2 Capabilities

Use capabilities for reusable participation semantics.

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

## 4.3 Derived affordances

Prefer deriving these from physical profile + context rather than authoring boolean flags everywhere:

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

Example:

```text
small stone:
  graspable + LOW mass + LOW bulk
  → carry_one_hand + throw

bowling ball:
  graspable + VERY_HIGH mass + awkward bulk
  → two_hand_carry / roll
  → throw normally filtered out
```

---

# 5. AssemblySlotDefinition

Runtime procedural assembly must remain semantic and bounded.

```text
AssemblySlotDefinition
  id: AssemblySlotId
  semantic_role: AssemblyRoleId
  accepted_component_predicate: RequirementPredicate
  cardinality
  optional: bool
```

A runtime binding is ordinary authoritative structure state:

```text
AssemblyBinding
  host: EntityId / ProjectInstanceId physical host
  slot_id: AssemblySlotId
  component: EntityId
```

Implementations may realize this through `part_of` / `attached_to` relations plus validated slot metadata rather than requiring a separate storage subsystem.

## 5.1 Example — improvised hammer

```text
slot.handle:
  requires structural_member
  length >= LOW

slot.head:
  requires hard impact-capable component

slot.binding:
  requires binding_component
```

The assembly does not encode a `hammer recipe`. Instead, if the configuration produces sufficient effective impact semantics, relevant affordances become available.

## 5.2 Example — shelter roof slot

```text
slot.roof_panel_1:
  requires covering
  minimum effective span/coverage
```

Thatch, cloth or compatible salvage may satisfy the same semantic slot with different weather performance.

## 5.3 Presentation sockets are adapters

Asset names such as:

```text
SOCKET_TOOL_HEAD
SOCKET_ROOF_01
```

are presentation/authoring adapter identifiers.

They may map to `AssemblySlotDefinition`, but domain identity must not depend on Blender/Godot socket names or transforms.

---

# 6. Gradual exploration and perceptual evidence

Do not persist a universal:

```text
exploration_level(object)
```

Object exploration is emergent from independent beliefs and evidence.

A poorly explored object has few supported propositions; a well explored object has more and/or higher-confidence propositions.

## 6.1 PerceptualEvidence

```text
PerceptualEvidence
  subject: DomainSubjectRef
  evidence_kind: EvidenceKindId
  property_id?: PropertyId
  perceived_value/range?: PropertyValue
  proposition_hint?: PropositionPattern
  quality: EvidenceQuality
  source_action_id?: ActionId
  source_world_event_id?: WorldEventId
  modality: PerceptionModality
  causal_ref?: bounded trace ref
```

It is a derived contract, not durable world truth.

Typical modalities:

```text
VISUAL
TACTILE
AUDITORY
OLFACTORY
GUSTATORY
PROPRIOCEPTIVE
ACTION_FEEDBACK
```

## 6.2 EvidenceRuleDefinition

```text
EvidenceRuleDefinition
  id: EvidenceRuleId
  trigger: EvidenceTrigger
  requirements: RequirementPredicate
  source_projection: EvidenceProjectionSpec
  quality_policy: EvidenceQualityPolicy
```

An evidence rule answers:

> Given what Wilson did/perceived and what authoritative world facts are accessible through that modality, what evidence may become available?

It must not simply reveal all properties of the target.

## 6.3 Examples

### Visual inspection

```text
inspect_visual(target)
→ color / coarse shape / visible surface state
```

It should not directly reveal hidden hardness or sealed contents.

### Touch

```text
touch(target)
→ surface temperature / tactile roughness / rigidity clues
```

### Lift

```text
lift(target)
+ action effort feedback
→ approximate mass-class evidence
```

### Shake

```text
shake(container)
+ internal motion/sound response
→ evidence for likely_contains_something
```

No sound should normally reduce confidence in movable contents, not prove emptiness.

### Strike

```text
wood breaks while target barely deforms
→ strong relative resistance evidence
```

This is especially important for Scientific Method.

---

# 7. Direct observation versus inference

Evidence should distinguish direct projection from inferred semantic claims.

Example:

```text
world: color = blue
visual evidence: observed color blue
→ high-confidence likely_property(color, blue)
```

Versus:

```text
world: paper inside opaque bottle
shake action: rattle heard
→ evidence for likely_contains_something
```

Wilson does not automatically receive `inside(paper, bottle)` from the rattle.

This boundary preserves uncertainty and supports later contradiction.

---

# 8. Exploration feeds affordances

Physical affordances are queried from authoritative physical truth, but Wilson candidate generation uses a perceived/believed projection.

Therefore all four cases are valid:

```text
physically possible + Wilson knows it
physically possible + Wilson does not know it
physically impossible + Wilson thinks it may work
physically impossible + Wilson knows it is implausible
```

The second case enables discovery.
The third case enables experiments and mistakes.

---

# 9. Tactical versus intentional reconsideration

The micro-loop requires two normal reconsideration scopes plus the existing immediate-threat regime.

```text
ReconsiderationScope =
  TACTICAL
  INTENTIONAL
  IMMEDIATE_THREAT
```

This is a scheduling/candidate-scope distinction, not a new state-owning AI system.

## 9.1 Tactical reconsideration

Question:

> How can Wilson continue the current intention after a checkpoint/outcome/new evidence?

Candidate space is constrained by the current intention.

Examples:

```text
use another tool
inspect first
change target point
change technique
retry with stronger force
pause at a safe checkpoint
```

## 9.2 Intentional reconsideration

Question:

> Should Wilson continue this intention, suspend it, or pursue another objective?

Triggered by stronger context changes such as:

```text
urgent drive transition
major opportunity
persistent repeated failure
strong anomaly outside current goal
player suggestion
context change
intention completion/invalidation
```

## 9.3 Escalation

A tactical result may escalate to intentional reconsideration when:

```text
no plausible tactic remains
estimated value drops materially
cost/risk rises beyond bounded tolerance
strong competing trigger arrives
```

This prevents global life-planning after every hammer strike while preserving interruption by meaningful events.

---

# 10. EnvironmentalResponseRule

Weather/environmental procedurality should not require object-specific update code.

```text
EnvironmentalResponseRule
  id: EnvironmentalResponseRuleId
  environment_trigger: EnvironmentCondition
  target_requirements: RequirementPredicate
  response: EffectSpec | EnvironmentalProcessSpec
  cadence/policy: bounded semantic policy
```

Examples:

### Rain wets absorbent exposed objects

```text
rain active
+ target exposed
+ absorbency > LOW
→ increase moisture
```

### Sun dries wet exposed objects

```text
sun exposure
+ moisture > dry threshold
→ start/advance drying process
```

### Wind displaces unstable light objects

```text
wind strength HIGH
+ target stability LOW
+ effective mass below threshold
+ exposed
→ displacement resolution candidate
```

### Rain suppresses fire

```text
rain
+ exposed burning subject
+ insufficient covering
→ reduce burn level / extinguish process
```

The rule should operate over properties/capabilities rather than entity-type lists whenever practical.

---

# 11. State-band rule

Brainstorming/art states such as:

```text
dry / damp / wet / soaked
fresh / aging / spoiled
raw / cooked / burned
intact / damaged / broken
empty / partial / full
```

should normally be presentation/content bands over smaller authoritative property families, not independent state machines.

Examples:

```text
moisture → dry/damp/wet/soaked visual band
freshness → fresh/aging/spoiled band
cooking_progress + burn_level → raw/cooked/burned band
structural_integrity → intact/damaged/broken band
fill_ratio → empty/partial/full band
```

`drying` is normally a process (`moisture > 0 + active drying process`), not a mutually exclusive condition enum.

Use explicit lifecycle enums only when semantic transition identity itself matters.

---

# 12. Epistemic state must not leak into world assets

Terms such as:

```text
unexplored
inspected
contents_revealed
known
familiar
```

are Wilson-relative projections and must not normally be stored as authoritative `EntityInstance` states.

For a mystery container:

```text
world truth:
  sealed/open
  damaged
  contents relations

Wilson cognition:
  visual properties known?
  likely contents?
  inferred material?
  opening behavior learned?
```

Presentation may derive an `unexplored` UI/content label from Wilson knowledge, but it is not a physical property of the container.

---

# 13. Content metadata versus domain semantics

Brainstorming labels such as:

```text
collectible
preference-capable
personal-location-capable
persistent-instance-worthy
repair-history-visible
displayable
```

should not automatically become physical capabilities.

Use one of:

```text
content authoring metadata
presentation metadata
persistence hint
ordinary association/habit behavior
```

A cup becomes Wilson's favorite through association/history, not because it has `capability.favorite_candidate`.

---

# 14. Procedural regression fixtures

The following existing catalog objects should be used as low-cost domain regressions.

## 14.1 Coconut

Tests:

```text
property-driven breaking
multi-stage transformations
multi-output contents
repurposing shell as container/tool material
```

## 14.2 Improvised hammer

Tests:

```text
assembly slots
material/component composition
derived impact capability
binding degradation
repair without new entity type explosion
```

Required contrast:

```text
tight binding vs loose binding
```

## 14.3 Barrel

Tests:

```text
container contents
derived mass
rollable affordance
slope hazard
```

Required contrast:

```text
empty vs water-filled
```

## 14.4 Sealed container

Tests:

```text
gradual exploration
opaque/transparent evidence access
damage feedback
Scientific Method tactical loop
```

Required contrast:

```text
transparent vs opaque container
```

without requiring distinct cognitive code paths.

## 14.5 Cloth sheet

Tests:

```text
material properties
weather response
configuration-derived covering capability
wind response
repurposing
```

Required contrast:

```text
loose on ground
vs attached/tensioned across supports
```

## 14.6 Shelter section

Tests:

```text
assembly slots
project/world truth split
weather damage
detached reusable components
repair history
```

## 14.7 Bowling ball

Tests:

```text
absurd object obeys ordinary physics grammar
mass/roll/impact semantics
no special coconut-breaking rule
```

---

# 15. Explicit anti-models

Do not implement:

```text
exploration_level per object
unexplored as world state
one capability flag for every possible affordance
one entity type for every condition combination
recipes for composite tools
free-form arbitrary component attachment
Blender/Godot sockets as domain identity
realistic continuous material simulation
weather switch statements by entity type
persisted EffectivePhysicalProfile caches as independent truth
```

---

# 16. Procedural-domain gate

Before language-specific implementation begins, the functional model should demonstrate that:

- one interaction rule can accept multiple physically compatible objects;
- effective properties can change from contents, condition and assembly without changing entity type;
- composite tools gain/lose effectiveness through component state;
- visual exploration reveals only modality-accessible evidence;
- Wilson can hold partial/incorrect property beliefs;
- environmental rules affect heterogeneous compatible objects without type lists;
- structures can use bounded semantic slots with interchangeable compatible components;
- presentation state bands derive from smaller authoritative properties;
- personalization metadata does not become unnecessary physical capability flags;
- tactical reconsideration can refine an intention without broad global reconsideration after every action.

These requirements extend the domain model without changing its authority boundaries or replacing the existing property/capability/relation foundation.
