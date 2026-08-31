# Procedural Composition and Exploration Domain

## Status and purpose

This document is the canonical language-neutral companion for runtime physical composition, gradual exploration, generic environmental response and semantic assembly.

It complements:

- `DOMAIN_MODEL.md` — owners/concepts;
- `DOMAIN_VOCABULARY.md` — normalized terminology;
- `DOMAIN_CATALOGS.md` — admitted semantic families;
- `DOMAIN_OPERATIONS.md` — single canonical operation surface;
- `DOMAIN_MICRO_LOOP.md` — semantic execution cadence and experimentation behavior.

`DOMAIN_FIXTURE_IMPROVISED_HAMMER.md` remains regression evidence for composite-object semantics; it is not a competing specification.

There is no longer a separate operation-refinement document. Accepted operation signatures belong directly in `DOMAIN_OPERATIONS.md`.

---

# 1. Core procedural principle

Authoritative interaction semantics should emerge from composition:

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

Wilson cognition answers a separate question:

```text
World truth
→ perceptual accessibility
→ ObservedEvent / PerceptualEvidence
→ typed EpistemicClaim evidence
→ BeliefEntry confidence
→ perceived tactical opportunity
→ tactical/intention candidates
```

Therefore:

```text
physical possibility != Wilson knowledge != Wilson desirability
```

Environment normally changes ordinary authoritative state/processes; effective profile reads those consequences instead of consulting an invisible global weather modifier.

---

# 2. Material profiles

Materials justify a light authored concept when many content families share physical defaults.

```text
MaterialDefinition
  id: MaterialId
  default_properties: Map<PropertyId, PropertyValue>
  categories: Set<CategoryId>
```

Typical coarse families:

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

Useful defaults may include hardness, rigidity, flexibility, flammability, absorbency, water resistance, heat resistance and mass-density class.

A material profile is not a realism simulator. Entity form may override material defaults when representative gameplay needs it.

---

# 3. EffectivePhysicalProfile

Composite tools, loaded containers, damaged structures and repurposed salvage require a derived physical view.

```text
EffectivePhysicalProfile
  subject: RuntimeWorldRef
  properties: Map<PropertyId, PropertyValue>
  capabilities: Set<CapabilityId>
  provenance: bounded derivation trace
```

It is reconstructible derived state and should not become an independent persistence owner.

## Resolution inputs

The resolver may read only authoritative physical semantics:

```text
entity definition
material/default properties
instance overrides/condition
part_of / attached_to / inside relations
component properties/capabilities
assembly-slot bindings
contents
```

It must never read Wilson beliefs, habits, associations or intentions.

## PropertyDerivationDefinition

Derived properties use validated definitions rather than arbitrary callbacks.

Conceptually:

```text
PropertyDerivationDefinition
  id
  input selectors
  output PropertyId
  registered bounded combination policy
```

Current foundation proves bounded selectors:

```text
self.property
assembly_slot(slot_id).property
```

Inputs from assembly slots are external component leaves for the host's local property DAG; they do not create false local output edges.

Content bootstrap rejects unsupported selectors/policies, unknown typed property references and cyclic local property dependencies.

## Examples

```text
loaded container base mass + contents
→ effective mass class

head mass/hardness + handle integrity + binding integrity
→ impact capacity

float components + bindings + cargo + waterlogging
→ raft buoyancy/stability

cloth + attachment/tension/condition
→ covering/rain-protection semantics
```

---

# 4. Properties, capabilities and affordances

## Properties

Use when magnitude/value matters:

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

Values obey `PropertyDefinition` family/bounds and finite-number guards.

## Capabilities

Use for reusable role participation:

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

## Derived affordances

Prefer deriving context-sensitive opportunities rather than persisting flags such as:

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

An affordance/attemptability result does not guarantee goal success.

---

# 5. Assembly semantics

Runtime assembly remains semantic and bounded.

```text
AssemblyDefinition
  id: AssemblyDefinitionId
  slots: AssemblySlotDefinition[]

AssemblySlotDefinition
  id: AssemblySlotId
  semantic_role: AssemblyRoleId
  accepted_component_predicate: RequirementPredicate
  min_count
  max_count
  optional
```

`optional` is authoring clarity; cardinality remains the substantive constraint.

## Runtime binding projection

Physical truth remains ordinary World relation state; no `AssemblyStore` is required.

Canonical current representation:

```text
attached_to(component, host, qualifier = AssemblySlotId)
```

`WorldRelation.qualifier` is a bounded semantic value and participates in exact relation identity. Therefore distinct slot-qualified edges can coexist at the relation-store level; `AssemblyValidity`/future `RelationDefinition` constraints decide whether a particular configuration is admitted.

`AssemblyBindingProjection` derives:

```text
AssemblyBinding
  host
  slot_id
  component
```

from the authoritative relation set.

## AssemblyValidity

```text
VALID
INCOMPLETE
INCOMPATIBLE_COMPONENT
BROKEN_BINDING
INVALID_CONFIGURATION
```

It answers whether required roles are occupied by compatible live components under the admitted slot/cardinality configuration.

It does **not** answer tool/structure quality.

A weak but compatible configuration may remain `VALID` while effective stability, impact capacity, coverage or buoyancy degrade.

Do not introduce universal `assembly_quality`, `tool_quality` or `structure_quality` when effective properties already express consequences.

## Improvised hammer example

```text
slot.handle → structural_member
slot.head → impact_surface + sufficient hardness for compatibility
slot.binding → binding_component
```

A tiny hard pebble may be a compatible head while producing low impact capacity. Compatibility must not silently become a performance threshold.

## Degradation / failure

```text
binding_integrity HIGH → LOW
AssemblyValidity remains VALID
impact_capacity/stability decrease
```

Later grounded failure may remove the exact slot-qualified relation:

```text
RemoveRelation(attached_to, binding, host, AssemblySlotId(binding))
→ required slot absent
→ AssemblyValidity = INCOMPLETE
→ dependent effective properties disappear/recompute
```

Repair replaces/mutates ordinary components/relations; unrepaired component damage remains part of effective semantics.

## Structural cycles

Structural dependency used for recursive composition/aggregation must be acyclic. A component/host graph cannot recursively depend on itself.

Where mutually exclusive role occupancy is required, express it through explicit relation/assembly constraints rather than assuming relation-key uniqueness enforces it.

## Presentation sockets

Asset identifiers such as `SOCKET_TOOL_HEAD` are adapters. They may map to `AssemblySlotId` but are never domain identity.

---

# 6. Composition-dependent invalidation

A component mutation can invalidate a cached host profile even when the host itself did not mutate.

Canonical maintenance path:

```text
component World mutation
→ SemanticChangeSet
→ CompositionDependencyProjection
→ dependent host(s)
→ invalidate EffectivePhysicalProfile caches
```

Relation changes invalidate direct endpoints and relevant transitive composite dependents.

`CompositionDependencyProjection` is reconstructible from World truth and never an authority owner.

This maintenance contract must remain separate from gameplay `WorldEvent`/learning flows.

---

# 7. Gradual exploration and typed evidence

Do not persist a universal:

```text
exploration_level(object)
```

Exploration emerges from independent supported beliefs/evidence.

## PerceptionResult

Conceptually:

```text
PerceptionResult
  perceived subjects
  observed events
  perceptual evidence
  accessible environmental context
```

## PerceptualEvidence

The structural foundation uses a compact typed contract:

```text
PerceptualEvidence
  claim: EpistemicClaim
  confidence: UnitInterval
  source_execution_id
  modality
```

Current claim kinds:

```text
PROPERTY(subject, PropertyId, PropertyValue)
RELATION(subject, RelationTypeId, object)
EVENT(subject, EventDefinitionId, perceived_role)
```

This replaces durable identity based on arbitrary proposition predicate/argument bags.

Richer future evidence metadata such as observation coverage, ranges or causal refs may be added as bounded provenance without changing the claim identity model.

## Evidence accessibility

`EventDefinition` declares which event roles/modalities are potentially perceptible. Runtime spatial access decides whether Wilson actually has access.

Current coarse adapter uses semantic place/co-location. Future visual/hearing/occlusion adapters can refine access behind the same boundary without exposing hidden World truth to cognition.

Static property/relation exploration need not fabricate a WorldEvent; future `EvidenceRuleDefinition`s may derive typed property/relation claims from inspect/touch/smell/etc.

---

# 8. Negative evidence and observation coverage

Not observed is not automatically absent.

Strong negative evidence requires sufficient bounded `ObservationCoverage` for the relevant query/scope.

Examples:

```text
quick glance into cluttered storage
→ weak/insufficient negative evidence

careful exhaustive inspection for a rope-sized item
→ strong evidence of absence for that bounded query
```

Coverage is derived and normally not persisted independently.

---

# 9. Environmental response rules

Environmental behavior should be reusable property/capability/configuration logic.

Conceptually:

```text
EnvironmentalResponseRule
  trigger/context
  target predicate
  exposure/protection condition
  bounded effect/process policy
```

Example:

```text
rain active
+ absorbency > LOW
+ resolved rain exposure >= LOW
→ moisture increases
```

Avoid object-type weather switch trees when ordinary semantics suffice.

---

# 10. Protection/exposure relation

`covering` capability alone does not mean a target is protected.

```text
covering/configuration
→ ProtectionProjection
→ ResolveExposure(target, exposure_kind)
→ EnvironmentalResponse
```

The cloth/shelter/weather fixture owns regression evidence; `DOMAIN_ENVIRONMENTAL_PROTECTION.md` owns detailed semantics.

---

# 11. Authoring/content loading boundary

The domain remains serialization-neutral, but the current implementation proves that these semantics can be loaded from bounded versioned content and sealed into typed definitions.

Authored content must not contain arbitrary executable callbacks, untyped relation-qualifier dictionaries or unbounded selectors.

Exact current content-pack schema/version belongs to `DISCOVERY_STATUS.md` + implementation/tests, not to this language-neutral semantic document.

---

# 12. Anti-patterns

Do not introduce:

```text
object-pair crafting recipes as the generic interaction model
AssemblyStore as duplicate physical truth
universal quality scalars
runtime type explosion for every material/configuration combination
arbitrary Dictionary qualifiers
arbitrary authored callbacks
persisted exploration percentages
profile derivation reading Wilson belief
manual host-cache invalidation scattered across gameplay code
presentation socket names as AssemblySlot identity
```

---

# 13. Regression expectations

The procedural-composition contract remains acceptable when the same primitives can express:

```text
improvised hammer with substitution/degradation/repair
loaded containers
rafts with component/cargo effects
cloth shelter protection under weather
repurposed salvage
experimentation with incomplete Wilson knowledge
```

without target-specific recipes, hidden knowledge leaks or duplicate physical authority.
