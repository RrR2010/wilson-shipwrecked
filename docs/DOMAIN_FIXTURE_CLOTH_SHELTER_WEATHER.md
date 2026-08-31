# Final Domain Fixture — Cloth Shelter Under Rain and Wind

## Status and purpose

This is the final functional-domain stabilization fixture before package/module layout.

It stress-tests the intersection of:

- `EnvironmentalResponseRule`;
- material and moisture properties;
- semantic assembly slots and `AssemblyValidity`;
- `EffectivePhysicalProfile`;
- spatial protection/exposure;
- degradation and repair;
- `DynamicProcessState` / hazard dynamics;
- detached reusable components;
- Project state versus authoritative World state.

The fixture must work without a `ShelterSystem`, `RoofSystem`, weather-specific shelter subclasses, or entity-type branching.

---

# 1. Initial authored semantics

## 1.1 Components

```text
post_a / post_b / post_c / post_d
  material = wood
  structural_member
  structural_integrity = HIGH

crossbeam_a / crossbeam_b
  material = wood
  structural_member

cloth_01
  material = cloth
  flexible
  covering
  absorbency = HIGH
  water_resistance = MEDIUM
  structural_integrity = HIGH

fiber_binding_01..04
  material = fiber
  binding_component
  binding_integrity = HIGH
```

The cloth does not have a persistent `shelter_roof=true` flag.

## 1.2 Assembly

The physical shelter host exposes bounded semantic slots:

```text
roof_support_north
roof_support_south
roof_covering
roof_binding_1..4
```

Bindings attach `cloth_01` across the support structure.

```text
AssemblyValidity(shelter_host) = VALID
```

The cloth's configuration plus its material/profile derives useful covering semantics.

## 1.3 Protected use region

The shelter has a semantic interior/activity region:

```text
region.shelter_sleep_area
```

A derived protection query evaluates the current assembly and weather direction:

```text
DeriveProtectionProjection(
  source = shelter_host,
  protected_region = shelter_sleep_area,
  hazard = rain
)
```

Initial result may be:

```text
coverage = HIGH
protection_strength = MEDIUM/HIGH
leak_regions = none/minor
provenance = cloth_01 + roof bindings + orientation
```

This projection is derived, not durable truth.

---

# 2. FG0 — ordinary dry conditions

World:

```text
cloth moisture = LOW
bindings integrity = HIGH
wind = LOW
rain = none
sleep area moisture = LOW
```

Derived:

```text
AssemblyValidity = VALID
cloth effective mass = LOW
cloth covering performance = HIGH enough
ProtectionProjection(rain) = effective
```

No weather-specific mutation is occurring.

PASS requirement:

The shelter's useful behavior derives from ordinary components/configuration rather than a special shelter state machine.

---

# 3. FG1 — rain begins

Environment changes:

```text
rain intensity = MEDIUM
wind = LOW/MEDIUM
```

Reusable response rules evaluate exposed targets.

For exposed absorbent cloth:

```text
rain active
+ exposed cloth
+ absorbency > LOW
→ moisture increases
```

For the protected sleep region:

```text
ProtectionProjection(rain)
→ exposure reduced according to current coverage/protection strength
```

Result:

```text
cloth becomes wet
sleep area remains mostly dry
```

Important:

Rain does not check `entity_type == shelter`.

---

# 4. FG2 — wet cloth changes effective semantics

As moisture increases:

```text
cloth effective mass ↑
cloth sag/deformation tendency ↑
possibly tension/stability contribution ↓
```

These changes are derived from authoritative properties.

The assembly can remain structurally VALID while its performance worsens:

```text
AssemblyValidity = VALID
ProtectionProjection.coverage = HIGH
ProtectionProjection.protection_strength = MEDIUM
```

This mirrors the improvised-hammer invariant:

```text
valid assembly != optimal performance
```

Visual state may project `wet/sagging`, but those labels are not independent authoritative enums.

---

# 5. FG3 — stronger wind loads the wet covering

Wind increases:

```text
wind = HIGH
```

Reusable environmental response evaluates the cloth configuration:

```text
wind HIGH
+ exposed flexible covering
+ effective mass/tension/configuration
+ binding integrity
→ binding stress / displacement tendency
```

A bounded registered derivation determines which physical property is affected, e.g.:

```text
binding_integrity -= bounded stress contribution
```

No hidden `storm_damage_shelter()` operation is required.

---

# 6. FG4 — one binding weakens

Suppose:

```text
fiber_binding_03.binding_integrity: HIGH → LOW
```

The binding may still exist physically.

Derived state:

```text
AssemblyValidity = VALID or DEGRADED-VALID by diagnostics
roof stability ↓
ProtectionProjection.coverage ↓ slightly
leak region appears near one edge
```

The authoritative world does not need a `minor_leak` enum.

Instead:

```text
geometry/configuration + integrity
→ partial ProtectionProjection
→ rain exposure reaches part of sleep area
→ moisture increases there
```

Presentation may call this a `minor leak`.

---

# 7. FG5 — rain reaches the interior

Environmental response now sees partial exposure:

```text
rain
+ sleep_area exposed through protection gap
→ sleeping surface / ground moisture increases
```

Wilson may later perceive:

```text
drip
wet bedding/ground
visible loose cloth edge
```

and derive repair/project tactics through normal perception, evidence and candidate generation.

The fixture does not require cognition to prove physical correctness.

---

# 8. FG6 — binding failure and detachment

Wind stress eventually crosses the admitted failure condition.

Physical consequence:

```text
binding_03 fails/breaks
→ attachment relation removed
```

If remaining attachments still constrain the cloth:

```text
AssemblyValidity = INCOMPLETE/DEGRADED
cloth remains partially attached
ProtectionProjection degrades sharply
```

If wind can move the free portion across semantic boundaries, create:

```text
DynamicProcessState(
  kind = wind_driven_flexible_component,
  subject = cloth_01,
  phase = PREPARING/COMMITTED...
)
```

The dynamic-process primitive is reused from Falling Palm.

---

# 9. FG7A — cloth remains partly attached

Possible branch:

```text
three bindings remain
cloth flaps but stays on shelter
```

Consequences:

```text
covering performance low
rain exposure high
remaining bindings receive additional bounded stress
```

This creates an emergent cascading-failure possibility without a scripted shelter-collapse sequence.

A later repair can replace/rebind only the failed component.

---

# 10. FG7B — cloth fully detaches

Alternative branch:

```text
remaining attachments fail or detach
→ cloth no longer part_of/attached_to shelter
```

Immediately:

```text
AssemblyValidity(shelter_host) = INCOMPLETE
ProtectionProjection(rain) ≈ NONE for cloth roof
```

The same `cloth_01` remains an ordinary world entity with its own identity, moisture and condition.

No transformation to `storm_debris_cloth` is required.

If wind movement is committed, the cloth advances through ordinary dynamic-process semantics and may land elsewhere.

---

# 11. FG8 — detached cloth becomes reusable world material

After the wind-driven process completes:

```text
cloth_01 at another place
moisture = HIGH
structural_integrity may be reduced
no roof assembly binding
```

It remains potentially usable for:

```text
re-attachment as roof covering
wrapping
shade
bedding
carrying configuration
future project
```

Its available affordances follow its current profile and configuration.

This is a key procedurality requirement:

```text
component function follows world configuration
not historical asset role
```

---

# 12. FG9 — physical project projection

If a Shelter project instance exists, it does not own duplicate roof truth.

Project query reads World:

```text
roof covering slot currently unsatisfied
sleep-area rain protection below completion/maintenance threshold
```

The project may therefore become:

```text
needs repair / contribution available
```

but the Project aggregate does not directly set:

```text
cloth attachment
roof integrity
sleep-area wetness
```

Those remain World authority.

---

# 13. FG10 — repair

A repair tactic may:

```text
retrieve cloth_01
or select another compatible covering component
select compatible binding material
attach to semantic assembly slots
```

Examples of valid replacement covering:

```text
cloth sheet
thatch panel
compatible salvage sheet
```

Each can satisfy the same semantic covering slot with different effective properties.

After attachment:

```text
AssemblyValidity recomputed
EffectivePhysicalProfile recomputed
ProtectionProjection recomputed
```

No `repair_shelter_to_level_2` operation exists.

---

# 14. ProtectionProjection refinement

This fixture proves that a reusable spatial protection projection is needed.

```text
ProtectionProjection
  source_ref
  protected_region_ref
  hazard_or_exposure_kind
  coverage: bounded grade/scalar
  protection_strength: bounded grade/scalar
  leak_or_gap_regions: bounded semantic region refs
  provenance: bounded derivation trace
```

Typical uses:

```text
rain cover
shade from sunlight/heat
partial wind shelter
possibly bounded splash/debris shielding where authored rules admit it
```

It is derived from:

```text
assembly/configuration
covering components
orientation/spatial relation
component integrity
material properties
current environment direction/intensity where relevant
```

It is not a universal continuous geometry solver.

---

# 15. Exposure resolution

Environmental response should resolve target exposure through an explicit query rather than assuming every object in a place receives the same weather.

Conceptually:

```text
ResolveExposure(target_or_region, exposure_kind, environment)
→ ExposureResult
```

Inputs may include:

```text
place/region
cover/protection projections
containment
orientation
semantic occlusion
current environment
```

Output is a bounded semantic exposure quantity/grade.

This allows:

```text
cloth itself = highly rain-exposed
sleep area beneath cloth = weakly exposed
crate inside covered shelter = even less exposed
```

without encoding `indoors=true` as a universal boolean.

---

# 16. Deterministic cascading response rule

Environmental response chains must terminate at explicit semantic boundaries.

Example:

```text
rain/wind changes
→ response rules mutate moisture/binding integrity
→ recompute affected derived projections
→ if failure predicate crosses boundary, emit/commit attachment failure
→ optional dynamic process begins
→ later collision/landing resolution
```

Do not recursively re-run arbitrary environment rules until fixed point in one opaque call.

The orchestrator advances bounded consequences in deterministic phases.

---

# 17. Save/load branch

If saved while:

```text
cloth wet
binding_03 weak
cloth still attached
```

persist:

```text
component identities
relations/assembly bindings
mutable moisture/integrity properties
```

rederive after load:

```text
AssemblyValidity
EffectivePhysicalProfile
ProtectionProjection
ExposureResult
```

If saved while cloth is already in a committed wind-driven process, persist the active `DynamicProcessState` as required by `DOMAIN_HAZARD_DYNAMICS.md`.

---

# 18. Player intervention branch

A player may, through an admitted intervention capability:

```text
move a loose detached cloth
move/protect vulnerable items
possibly stabilize/remove a component before a causal failure boundary
```

But cannot silently:

```text
restore failed attachment after the failure has committed
make wet bedding retroactively dry
rewind a committed wind-driven process
```

Any later valid repair is a new grounded world mutation.

---

# 19. Regression matrix

| Requirement | Result |
|---|---|
| rain affects exposed materials generically | PASS |
| cloth wetness changes effective semantics | PASS |
| assembly validity separate from performance | PASS |
| partial covering/protection | PASS after `ProtectionProjection` refinement |
| interior exposure derived rather than global place flag | PASS after `ResolveExposure` refinement |
| wind stresses configuration generically | PASS |
| binding degradation without type variants | PASS |
| detached component retains identity | PASS |
| detached component can become dynamic hazard | PASS |
| repair uses ordinary components/bindings | PASS |
| Project does not duplicate physical truth | PASS |
| save/load reconstructs derived semantics | PASS |
| no shelter-specific owner/system required | PASS |

---

# 20. Rejected alternatives

Do not introduce:

```text
ShelterSystem
RoofSystem
WeatherDamageSystem per asset family
shelter_condition enum as sole physical truth
roof_leak_level persistent scalar detached from geometry/configuration
cloth_role = ROOF persistent identity
storm_debris_cloth entity type
repair_shelter recipe
indoors boolean as universal exposure truth
```

---

# 21. Fixture result

**PASS with two small reusable refinements:**

```text
ProtectionProjection
ResolveExposure / ExposureResult
```

These concepts complete the missing bridge between spatial composition and environmental response.

The final combined chain is:

```text
environment
+ authoritative world configuration
→ ResolveExposure
→ EnvironmentalResponseRule
→ mutable component properties/relations
→ EffectivePhysicalProfile / AssemblyValidity
→ ProtectionProjection
→ possible failure boundary
→ DynamicProcessState
→ grounded aftermath
→ Project/cognition observe the resulting world
```

No new state-owning system is required.
