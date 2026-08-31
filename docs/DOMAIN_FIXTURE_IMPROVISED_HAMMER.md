# Domain Fixture — Improvised Hammer

## Purpose

This fixture stress-tests procedural composite-object semantics without relying on complex cognition.

It validates whether a usable improvised impact tool can emerge from ordinary components, assembly slots, material profiles, condition properties and derived effective semantics without requiring a dedicated recipe-specific runtime type.

The fixture exercises:

- bounded semantic assembly;
- component compatibility;
- assembly validity versus assembly effectiveness;
- `EffectivePhysicalProfile` derivation;
- derived impact capability;
- use-induced degradation;
- degraded-but-still-valid configurations;
- component failure;
- repair/rebinding;
- replacement components;
- provenance/debug explainability.

The target invariant is:

```text
components + valid configuration + current condition
→ derived physical semantics
```

not:

```text
recipe completed
→ magic hammer type
```

---

# 1. Fixture definitions

## 1.1 Components

### Handle

```text
entity: branch_handle_01
material: wood
properties:
  length_class = MEDIUM
  rigidity = MEDIUM
  structural_integrity = HIGH
  mass_class = LOW
capabilities:
  structural_member
  graspable
```

### Head

```text
entity: impact_stone_01
material: stone
properties:
  hardness = HIGH
  mass_class = MEDIUM
  bulk_class = LOW
capabilities:
  impact_surface
```

### Binding

```text
entity: fiber_binding_01
material: fiber
properties:
  binding_integrity = HIGH
  flexibility = HIGH
capabilities:
  binding_component
```

None of the three components is authored as `hammer`.

---

# 2. Host assembly definition

The fixture may use a lightweight authored assembly host/profile such as:

```text
AssemblyDefinition: assembly.improvised_impact_tool
```

with slots:

```text
slot.handle
  accepted_component_predicate:
    HasCapability(component, structural_member)

slot.head
  accepted_component_predicate:
    HasCapability(component, impact_surface)
    PropertyCompare(component.hardness, >=, MEDIUM)

slot.binding
  accepted_component_predicate:
    HasCapability(component, binding_component)
```

The definition expresses a bounded semantic configuration, not a recipe result.

A runtime assembly consists of ordinary component identity plus validated bindings.

```text
AssemblyBinding(host, slot.handle, branch_handle_01)
AssemblyBinding(host, slot.head, impact_stone_01)
AssemblyBinding(host, slot.binding, fiber_binding_01)
```

---

# 3. Assembly validity versus effectiveness

These must remain distinct.

## 3.1 Assembly validity

Validity answers:

> Are the required roles occupied by compatible live components in a structurally admitted configuration?

Conceptually:

```text
AssemblyValidity
  VALID
  INCOMPLETE
  INCOMPATIBLE_COMPONENT
  BROKEN_BINDING
  INVALID_CONFIGURATION
```

A low-quality but intact binding may still yield `VALID`.

## 3.2 Assembly effectiveness

Effectiveness is derived through the `EffectivePhysicalProfile`.

Example:

```text
head.mass_class = MEDIUM
head.hardness = HIGH
handle.length_class = MEDIUM
handle.structural_integrity = HIGH
binding.binding_integrity = HIGH

→ impact_capacity = HIGH
→ stability = HIGH
→ capability.use_as_impact_tool
```

No independent `hammer_quality` value is required.

---

# 4. Initial profile derivation

Resolve:

```text
ResolveEffectivePhysicalProfile(host)
```

Expected provenance chain:

```text
impact_capacity
← head mass
← head hardness
← handle leverage/length
← handle structural integrity
← binding integrity
```

Possible bounded result:

```text
properties:
  mass_class = MEDIUM
  bulk_class = MEDIUM
  impact_capacity = HIGH
  stability = HIGH

capabilities:
  graspable
  use_as_impact_tool
```

The assembly remains the same runtime object identity while these derived values change.

---

# 5. First use

Wilson or another actor uses the assembled tool against a target requiring impact.

```text
action.hit(actor, target, tool = assembly_host)
```

Attemptability reads effective semantics:

```text
HasEffectiveCapability(tool, use_as_impact_tool)
```

Resolution may compare:

```text
tool.impact_capacity
vs target.break_resistance / deformation resistance
```

A successful strike produces ordinary `ActionOutcome` and world effects.

The tool type does not participate in target-specific recipe lookup.

---

# 6. Degradation after use

A committed strike may produce wear effects on participants.

Example:

```text
ModifyProperty(fiber_binding_01.binding_integrity, HIGH → MEDIUM)
```

or:

```text
ModifyProperty(branch_handle_01.structural_integrity, HIGH → MEDIUM)
```

These are authoritative component mutations.

The composite object itself does not need a duplicated `condition` state if condition already lives on its components.

Resolve profile again:

```text
binding_integrity = MEDIUM
→ impact_capacity = MEDIUM/HIGH
→ stability = MEDIUM
```

The assembly can remain:

```text
AssemblyValidity = VALID
```

while becoming less effective.

This distinction is mandatory.

---

# 7. Progressive risk without hidden tool tiers

A degraded assembly can produce different physical resolution envelopes through ordinary properties.

For example:

```text
stability = MEDIUM
```

may admit pre-authored physically plausible committed variants such as:

```text
normal impact
head shifts slightly
binding loosens further
```

At lower integrity:

```text
stability = LOW
```

valid variants may additionally include:

```text
head detaches
handle cracks
poor energy transfer
```

This must not be implemented as:

```text
if tool_type == improvised_hammer:
    special_break_roll()
```

The same semantics must be reusable by axes, mallets, paddles, repaired tools and bound structural components where applicable.

---

# 8. Failure boundary

Suppose repeated use reduces:

```text
fiber_binding_01.binding_integrity = VERY_LOW
```

A committed strike resolves a binding failure:

```text
RemoveAssemblyBinding(host, slot.head, impact_stone_01)
RemoveAssemblyBinding(host, slot.binding, fiber_binding_01)
```

and creates/updates ordinary spatial relations for detached components.

Now:

```text
AssemblyValidity = INCOMPLETE
```

and profile resolution removes:

```text
use_as_impact_tool
```

The host or surviving component identity may remain depending on representation policy.

No transform into a bespoke `broken_hammer` type is necessary unless presentation/content later proves that useful.

---

# 9. Repair by rebinding

Repair may use a new compatible component:

```text
fiber_binding_02
  binding_integrity = HIGH
```

Validate:

```text
ValidateAssemblyBinding(host, slot.binding, fiber_binding_02)
```

Then attach/rebind components.

Expected result:

```text
AssemblyValidity = VALID
```

Re-resolve profile from current components.

The repaired tool may differ from its original performance if:

- handle was already damaged;
- replacement binding is weaker/stronger;
- replacement head has different mass/hardness;
- configuration differs within admitted bounds.

Therefore repair does not imply restoration to a pristine authored template.

---

# 10. Replacement head variant

Replace the stone head with a found metal impact head:

```text
material = metal
hardness = VERY_HIGH
mass_class = MEDIUM
capability = impact_surface
```

The same assembly definition accepts it if the slot predicate is satisfied.

The resulting profile may become:

```text
impact_capacity = VERY_HIGH
stability = MEDIUM/HIGH
```

without introducing:

```text
stone_hammer
metal_hammer
improved_hammer
```

as mandatory runtime types.

Authored visual names may still exist for presentation/content organization, but physical authority remains compositional.

---

# 11. Invalid component contrast

Try binding a soft fruit as the head.

```text
fruit:
  hardness = VERY_LOW
  no impact_surface capability
```

Result:

```text
ValidateAssemblyBinding(slot.head, fruit)
→ INCOMPATIBLE_COMPONENT
```

This validates semantic boundedness.

The assembly system is not free-form arbitrary attachment.

---

# 12. Valid but poor component contrast

A small low-mass hard pebble may satisfy the head slot:

```text
hardness = HIGH
mass_class = VERY_LOW
capability = impact_surface
```

Assembly can remain valid, while profile derives:

```text
impact_capacity = LOW/MEDIUM
```

This is a critical regression:

```text
valid assembly != effective tool
```

Otherwise slot validation would silently become a recipe/quality gate.

---

# 13. Derived affordances

The composite profile may participate in contextual affordance queries.

Examples:

```text
use_as_impact_tool
carry_one_hand
place_on_surface
hang_on_tool_rack
```

Some arise from true effective capabilities; others remain contextual derived affordances based on total mass/bulk, hand occupancy and local context.

Do not persist these as combinatorial booleans on the assembly instance unless independently justified.

---

# 14. Presentation mapping

Presentation may need:

```text
SOCKET_HANDLE
SOCKET_TOOL_HEAD
SOCKET_BINDING
```

but these are adapters to semantic assembly slots.

Visual state can derive from authoritative component state:

```text
binding_integrity HIGH
→ tight binding visual

binding_integrity MEDIUM
→ visibly frayed/loose

binding missing
→ detached/broken presentation
```

No visual animation event is allowed to authoritatively determine whether the head detached.

---

# 15. Save/load and persistence

Persist authoritative facts only:

```text
component entity identities
component mutable properties
assembly bindings / equivalent validated relations
component spatial state
```

Normally do not persist:

```text
EffectivePhysicalProfile
impact_capacity cache
carry affordance
presentation condition band
```

Those are reconstructed deterministically.

---

# 16. Debug requirements

A headless trace must answer:

```text
Why was this component accepted/rejected for the slot?
Why is the assembly valid/incomplete?
Which component properties contributed to impact_capacity?
Why did impact_capacity change after use?
Why is the assembly still valid but less effective?
What exact grounded outcome caused binding degradation?
Why did a repair restore some but not all performance?
```

Suggested debug surfaces:

```text
ExplainAssemblyValidity(host)
ExplainEffectiveProperty(host, impact_capacity)
ExplainEffectiveCapability(host, use_as_impact_tool)
```

---

# 17. Regression branches

The fixture must pass these branches:

1. good stone + good handle + good binding → strong impact tool;
2. same assembly after binding degradation → still valid, weaker/less stable;
3. binding failure → head detaches, impact-tool capability disappears;
4. rebind with replacement fiber → capability returns;
5. replace head with compatible metal → stronger profile without new mandatory tool type;
6. incompatible fruit head → binding rejected;
7. valid but tiny pebble head → valid weak tool;
8. damaged handle + fresh binding → repair remains limited by handle condition;
9. save/load → same effective profile derives from persisted components/bindings;
10. no target-specific recipe lookup is needed for ordinary impact use.

---

# 18. Result

**PASS with one canonical refinement:** assembly validity must be explicit and separate from effective physical quality/performance.

The existing domain already provides the required authority boundaries. No new state-owning Crafting/Tool/Repair system is required.

Reusable composition is sufficient when the implementation preserves:

```text
AssemblyDefinition / AssemblySlotDefinition
AssemblyBinding
AssemblyValidity
MaterialDefinition
component mutable properties
EffectivePhysicalProfile
PropertyDerivationDefinition
ordinary ActionOutcome/effects
```

The fixture therefore supports the functional asset catalog's tool philosophy without a recipe catalog or combinatorial tool-type explosion.
