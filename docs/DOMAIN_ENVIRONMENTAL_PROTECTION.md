# Environmental Protection and Exposure Domain

## Status and purpose

This document is the canonical language-neutral refinement for spatial protection/exposure semantics exposed by `DOMAIN_FIXTURE_CLOTH_SHELTER_WEATHER.md`.

It complements:

- `DOMAIN_PROCEDURAL_COMPOSITION.md`;
- `DOMAIN_HAZARD_DYNAMICS.md`;
- `DOMAIN_OPERATION_REFINEMENTS.md`;
- `SIMULATION_ORCHESTRATION.md`.

The goal is to let assembled structures, cloth, thatch, containers, terrain and other ordinary world configuration alter environmental exposure without introducing universal `indoors` flags, shelter-specific systems, or continuous geometry simulation.

---

# 1. Core distinction

A component's ability to cover is not the same as a target being protected.

```text
covering capability
!=
ProtectionProjection
!=
resolved target exposure
```

Example:

```text
cloth has capability.covering
```

but its actual rain protection depends on:

```text
attachment/configuration
orientation
coverage
integrity/tension
material properties
current rain/wind direction where relevant
```

---

# 2. ProtectionProjection

`ProtectionProjection` is a derived authoritative projection describing how a current world configuration shields a semantic target region from one environmental exposure family.

```text
ProtectionProjection
  source_ref: RuntimeWorldRef
  protected_region_ref: SemanticSpatialRegionRef
  exposure_kind: ExposureKindId
  coverage: bounded grade/scalar
  protection_strength: bounded grade/scalar
  gap_regions: bounded SemanticSpatialRegionRef[]
  provenance: optional bounded derivation trace
```

Typical exposure kinds:

```text
rain
sunlight
heat/radiant_sun
wind
splash
```

Other kinds require a validated gameplay need before admission.

`ProtectionProjection` is derived and normally not persisted.

---

# 3. Projection inputs

The derivation may read authoritative world semantics only:

```text
assembly bindings/configuration
component EffectivePhysicalProfiles
component integrity/moisture where relevant
semantic orientation/spatial relations
containment/support relations
protected region geometry category
current environmental direction/intensity when directional
```

It must not read Wilson belief or intent.

It must remain coarse and semantic. The domain does not require triangle-level ray casting or a full fluid/airflow solver.

---

# 4. ExposureResult

Environmental response rules should consume an explicit exposure result.

```text
ExposureResult
  target_ref
  exposure_kind
  exposure_level: bounded grade/scalar
  dominant_sources
  protection_refs
  uncertainty_if_applicable
```

Operation:

```text
ResolveExposure(target_or_region, exposure_kind, environment_context)
→ ExposureResult
```

Conceptual inputs:

```text
raw environment exposure
- applicable ProtectionProjection effects
+ semantic gaps/openings
+ containment/orientation adjustments
→ resolved exposure
```

This is not required to be arithmetic internally; registered bounded policies are sufficient.

---

# 5. EnvironmentalResponseRule refinement

`EnvironmentalResponseRule` should normally evaluate `ExposureResult` instead of assuming uniform place-level exposure.

Example:

```text
rain active
+ target absorbency > LOW
+ ResolveExposure(target, rain) >= LOW
→ increase moisture
```

This allows all of the following simultaneously:

```text
roof cloth: HIGH rain exposure
sleep area beneath intact cloth: LOW exposure
crate under same roof: VERY_LOW exposure
outside wood pile: HIGH exposure
```

No universal `indoors=true` property is required.

---

# 6. Partial protection and leaks

A leak is normally a projection/result, not an authoritative enum.

Example:

```text
one roof binding weakens
→ configuration changes
→ ProtectionProjection gap region appears
→ sleep-area ExposureResult rises locally
→ rain response wets bedding/ground
```

Presentation may label the result:

```text
minor leak
active drip
roof breach
```

but those labels should not replace the underlying configuration and exposure semantics.

---

# 7. Protection is configuration-relative

The same entity may provide different protection depending on world relations.

```text
cloth on ground
→ no useful overhead rain protection

cloth attached across supports
→ rain/shade ProtectionProjection

cloth hanging vertically
→ possible partial wind/rain-side protection
```

Function follows configuration rather than historical role or entity subtype.

---

# 8. Multiple protection layers

Protection may compose across a small bounded chain.

Example:

```text
rain
→ cloth roof
→ crate lid
→ item inside crate
```

Each layer may reduce exposure according to semantic rules.

Guard:

- protection composition must be bounded and acyclic;
- do not recursively traverse arbitrary world graphs without limits;
- containment/cover chains should have explicit maximum or structural bounds.

---

# 9. Damage/degradation feedback

Environmental exposure may mutate components that themselves contribute to protection.

Example:

```text
rain exposure
→ cloth moisture increases
→ effective mass/sag changes
→ wind stress on bindings increases
→ binding integrity falls
→ ProtectionProjection worsens
```

This is a valid feedback chain, but orchestration must advance it through explicit semantic boundaries rather than opaque fixed-point recursion.

Canonical style:

```text
environment step
→ resolve exposure
→ apply response mutations
→ recompute affected derived projections
→ detect threshold/failure boundary
→ emit grounded events/processes
```

---

# 10. Dynamic detachment and hazards

If protection failure creates moving dangerous geometry, use existing hazard semantics.

```text
binding failure
→ cloth/panel detaches
→ assembly relation mutation
→ ProtectionProjection changes immediately
→ optional DynamicProcessState for wind-driven component
```

No separate weather-debris system is required.

---

# 11. Project interaction

Projects may query protection as a world-derived condition.

Examples:

```text
shelter project completion requires rain protection >= threshold
repair contribution becomes relevant when protection falls below maintenance threshold
```

Project state does not own:

```text
roof attachment truth
component integrity
interior wetness
ProtectionProjection
```

Those remain World/derived semantics.

---

# 12. Persistence

Persist authoritative causes:

```text
component identities
mutable component properties
relations/assembly bindings
active DynamicProcessState when required
```

Recompute after load:

```text
AssemblyValidity
EffectivePhysicalProfile
ProtectionProjection
ExposureResult
```

Do not persist `minor_leak`, `indoors`, or cached protection projections merely for convenience.

---

# 13. Operations

Canonical conceptual operations:

```text
DeriveProtectionProjections(source_or_region, environment_context?)
ResolveExposure(target_or_region, exposure_kind, environment_context)
ExplainProtectionProjection(projection_ref)
ExplainExposureResult(target_ref, exposure_kind)
```

These are derived/query operations and do not own state.

---

# 14. Rejected alternatives

Do not introduce by default:

```text
ShelterSystem
RoofSystem
IndoorsSystem
roof_leak_level authoritative scalar
inside_shelter boolean as universal weather truth
weather immunity flags per object type
continuous CFD/rain simulation requirement
```

---

# 15. Regression targets

The same semantics should support:

```text
cloth shelter in rain/wind
thatch shelter with partial damage
shade canopy
object under palm/frond cover
covered storage crate
open vs closed container exposure
windbreak wall
partial rain protection from wreck geometry
```

---

# 16. Gate

PASS when:

- covering capability is distinct from actual protection;
- environmental exposure is target/configuration-specific rather than globally place-based;
- partial coverage/leaks emerge from configuration/integrity;
- layered protection is bounded;
- environmental degradation can alter protection through grounded mutations;
- detached components reuse hazard dynamics;
- projects consume world-derived protection rather than duplicate it;
- no shelter-specific state owner is required.

Current result after `DOMAIN_FIXTURE_CLOTH_SHELTER_WEATHER.md`: **PASS**.
