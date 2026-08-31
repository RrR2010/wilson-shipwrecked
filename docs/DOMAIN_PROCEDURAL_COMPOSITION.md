# Procedural Composition and Exploration Domain

## Status and purpose

This document is a canonical, language-neutral companion to `DOMAIN_MODEL.md`, `DOMAIN_VOCABULARY.md`, `DOMAIN_CATALOGS.md`, and `DOMAIN_OPERATIONS.md`.

It formalizes four refinements exposed by the functional asset catalog and the Scientific Method micro-loop:

1. effective physical properties/capabilities derived from runtime composition;
2. gradual exploration through perceptual evidence rather than object-level exploration percentages;
3. generic environmental response rules;
4. bounded semantic assembly slots for tools and structures.

`DOMAIN_MICRO_LOOP.md` now owns the detailed frame-group execution semantics and adds canonical refinements for `ActionAttemptability`, `PerceivedTacticalOpportunity`, `PropertyDerivationDefinition`, `InteractionRegionDefinition`, and `DecisionContinuationContext`.

`DOMAIN_OPERATION_REFINEMENTS.md` owns the corresponding refined operation surface where older `DOMAIN_OPERATIONS.md` wording is ambiguous.

`DOMAIN_FIXTURE_IMPROVISED_HAMMER.md` validates composite-object semantics and makes `AssemblyValidity` versus effective performance explicit.

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
--------------------------------
→ AssemblyValidity where applicable
→ EffectivePhysicalProfile
→ authoritative attemptability/resolution
```

Wilson's cognition must separately answer what he currently believes about those semantics:

```text
world truth
→ perceptual accessibility
→ PerceptualEvidence
→ belief evidence
→ BeliefEntry confidence
→ PerceivedTacticalOpportunity
→ tactical/intention candidates
```

Therefore:

```text
physical possibility != Wilson knowledge != Wilson desirability
```

Environment normally affects effective semantics through explicit authoritative state/process changes (`EnvironmentalResponseRule`) rather than invisible profile-time global modifiers.

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
```

It must not read Wilson beliefs, habits, associations or intentions.

The detailed deterministic precedence, derivation graph and cycle invariants are canonical in `DOMAIN_MICRO_LOOP.md`.

## 3.2 PropertyDerivationDefinition

Derived properties must use validated bounded definitions rather than arbitrary callbacks.

```text
PropertyDerivationDefinition
  property_id: PropertyId
  input_dependencies: bounded property/relation/slot selectors
  combination_policy: registered bounded semantic policy
  output_domain: declared PropertyValue family
```

Content bootstrap must reject cyclic derivation graphs, invalid output types and unsupported selectors.

## 3.3 Property derivation examples

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

## 3.4 Effective capability derivation

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

These are not guarantees of goal success. `DOMAIN_MICRO_LOOP.md` distinguishes authoritative `ActionAttemptability` from Wilson-relative `PerceivedTacticalOpportunity`.

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

# 5. Assembly semantics

Runtime procedural assembly must remain semantic and bounded.

```text
AssemblyDefinition
  id: AssemblyDefinitionId
  slots: AssemblySlotDefinition[]

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

Structural composition used by effective-property aggregation must be acyclic; a component cannot transitively contain/assemble itself.

## 5.1 AssemblyValidity

Assembly compatibility and assembly performance are separate questions.

`AssemblyValidity` is a derived projection over definition/slot requirements and current authoritative bindings:

```text
AssemblyValidity =
  VALID
  INCOMPLETE
  INCOMPATIBLE_COMPONENT
  BROKEN_BINDING
  INVALID_CONFIGURATION
```

It answers:

> Are required semantic roles occupied by compatible live components in an admitted configuration?

It does **not** answer:

> Is this a good tool/structure?

A configuration may remain `VALID` while its effective `stability`, `impact_capacity`, `coverage`, `buoyancy` or other properties degrade.

Do not introduce universal `assembly_quality`, `tool_quality` or `structure_quality` scalars when effective properties already express the meaningful consequences.

`AssemblyValidity` normally remains derived. Persist component identities, mutable component state and bindings; recompute validity deterministically.

## 5.2 Example — improvised hammer

```text
slot.handle:
  requires structural_member
  length >= LOW

slot.head:
  requires impact_surface
  hardness >= MEDIUM

slot.binding:
  requires binding_component
```

The assembly does not encode a target-specific `hammer recipe`. If the current valid configuration produces sufficient effective impact semantics, relevant affordances become available.

A tiny hard pebble may satisfy the head slot while deriving weak `impact_capacity`; validity must not silently become a performance threshold.

## 5.3 Example — shelter roof slot

```text
slot.roof_panel_1:
  requires covering
  minimum effective span/coverage
```

Thatch, cloth or compatible salvage may satisfy the same semantic slot with different weather performance.

## 5.4 Degradation and failure

Component condition can reduce effective performance without invalidating the assembly:

```text
binding_integrity HIGH → MEDIUM
AssemblyValidity = VALID
stability decreases
impact_capacity may decrease
```

A grounded failure can later change bindings/configuration:

```text
binding breaks
→ head detaches
→ required slot becomes unbound
→ AssemblyValidity = INCOMPLETE
→ use_as_impact_tool disappears
```

The world mutation occurs through ordinary effects/relations. Presentation follows the authoritative result.

## 5.5 Repair and replacement

Repair should mutate/replace ordinary components and bindings:

```text
replace binding
replace handle
replace head
reattach compatible component
```

Recompute `AssemblyValidity` and `EffectivePhysicalProfile` afterward.

Repair does not imply restoration to a pristine authored template. Existing damage on unreplaced components continues contributing to effective semantics.

## 5.6 Presentation sockets are adapters

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

## 6.1 PerceptionResult refinement

```text
PerceptionResult
  perceived_subjects: PerceivedSubject[]
  observed_events: ObservedEvent[]
  perceptual_evidence: PerceptualEvidence[]
  accessible_environmental_context
```

Static property discovery belongs in `perceptual_evidence`; it does not require synthetic `WorldEvent`s.

## 6.2 PerceptualEvidence

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

## 6.3 EvidenceRuleDefinition

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

## 6.4 Examples

### Visual inspection

```text
inspect_visual(target)
→ color / coarse shape / visible surface state / visible interaction regions
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

# 8. Exploration feeds tactical opportunities

Authoritative attemptability and Wilson candidate generation are separate.

Physical world/action services answer:

```text
Can this action be attempted?
What happens if committed?
```

Wilson-relative cognition answers:

```text
Does Wilson currently believe this tactic is plausible/informative enough to consider?
```

Therefore all four cases are valid:

```text
physically effective + Wilson knows it
physically effective + Wilson does not know it
physically ineffective + Wilson thinks it may work
physically ineffective + Wilson knows it is implausible but may test for information
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
change semantic target region
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

`DecisionContinuationContext` in `DOMAIN_MICRO_LOOP.md` carries only bounded same-intention recent tactic/outcome history; it is not a durable failure counter or second memory system.

---

# 10. InteractionRegionDefinition

Procedural tactics often need semantic sub-targets without mesh-level autonomous reasoning.

```text
InteractionRegionDefinition
  id: InteractionRegionId
  host applicability
  semantic categories
  accepted action-role semantics
  optional local physical modifiers
```

Runtime reference:

```text
InteractionRegionRef(host_entity_id, region_id)
```

Examples:

```text
lid_edge
handle
weak_joint
rope_knot
repair_point
fruit_cluster
```

Presentation maps regions to transforms/colliders/anchors. Hidden regions are not automatically exposed to Wilson cognition.

---

# 11. EnvironmentalResponseRule

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

# 12. State-band rule

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

# 13. Epistemic state must not leak into world assets

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

# 14. Content metadata versus domain semantics

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

# 15. Procedural regression fixtures

The following existing catalog objects should be used as low-cost domain regressions.

## 15.1 Coconut

Tests:

```text
property-driven breaking
multi-stage transformations
multi-output contents
repurposing shell as container/tool material
```

## 15.2 Improvised hammer

Tests:

```text
assembly slots
assembly validity versus effectiveness
material/component composition
derived impact capability
binding degradation
repair without new entity type explosion
```

Required contrast:

```text
tight binding vs loose binding
valid strong head vs valid weak head
```

Canonical fixture: `DOMAIN_FIXTURE_IMPROVISED_HAMMER.md`.

## 15.3 Barrel

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

## 15.4 Sealed container

Tests:

```text
gradual exploration
opaque/transparent evidence access
damage feedback
Scientific Method tactical loop
interaction regions such as lid edge
```

Required contrast:

```text
transparent vs opaque container
```

without requiring distinct cognitive code paths.

## 15.5 Cloth sheet

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

## 15.6 Shelter section

Tests:

```text
assembly slots
project/world truth split
weather damage
detached reusable components
repair history
interaction-region repair points
```

## 15.7 Bowling ball

Tests:

```text
absurd object obeys ordinary physics grammar
mass/roll/impact semantics
no special coconut-breaking rule
```

---

# 16. Procedural domain gate

This refinement passes when:

- new objects can gain useful behavior from existing properties/capabilities rather than type switches;
- composite objects can change effective physical semantics when parts/contents/condition change;
- assembly validity remains distinct from effective performance/quality;
- property derivation is acyclic, typed, deterministic and explainable;
- assembly compatibility is semantic and bounded rather than free-form universal construction;
- carrying/throwing/rolling can be derived where practical instead of authored as unrelated flags;
- exploration reveals individual facts through evidence modalities instead of one exploration percentage;
- Wilson can attempt physically enactable but ineffective experiments and learn from them;
- hidden world truth does not leak into tactical candidate generation;
- environment affects broad families through reusable response rules;
- art state variants can be projected from smaller authoritative properties;
- interaction sub-targets can be semantic without becoming mesh-level domain logic;
- brainstorming metadata does not inflate the authoritative gameplay schema.

`DOMAIN_MICRO_LOOP.md` validates this gate against a complete Scientific Method frame-group fixture.
`DOMAIN_FIXTURE_IMPROVISED_HAMMER.md` validates the assembly/effective-profile branch in isolation.
