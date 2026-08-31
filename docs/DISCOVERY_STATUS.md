# Discovery Status

## Current phase

Wilson Shipwrecked has completed the product/behavior/architecture discovery gate and the language-neutral functional-domain stabilization passes.

The current design phase is now **package/module dependency layout and concrete domain-type planning**, immediately before implementation-language-specific code.

The functional domain is no longer awaiting additional mandatory fixtures: structural, operation, vocabulary, procedural-composition, Scientific Method, Falling Palm, Sabotaged Storage, improvised-hammer, and cloth-shelter-weather regressions now exist.

---

# Canonical reading precedence

For work that changes simulation/domain behavior, read:

1. `BEHAVIORAL_MODEL.md`
2. `STATE_REQUIREMENTS.md`
3. `SCENE_VALIDATION.md`
4. `ARCHITECTURE.md`
5. `SIMULATION_CONTRACTS.md`
6. `SIMULATION_ORCHESTRATION.md`
7. `MUTATION_AUTHORITY.md`
8. `DECISION_TRACES.md`
9. `IMPLEMENTATION_GATE.md`
10. `GUARDS_AND_CALIBRATION.md`
11. `DOMAIN_MODEL.md`
12. `DOMAIN_VOCABULARY.md`
13. `DOMAIN_CATALOGS.md`
14. `DOMAIN_OPERATIONS.md`
15. `DOMAIN_PROCEDURAL_COMPOSITION.md`
16. `DOMAIN_ENVIRONMENTAL_PROTECTION.md`
17. `DOMAIN_HAZARD_DYNAMICS.md`
18. `DOMAIN_EPISTEMIC_INVESTIGATION.md`
19. `DOMAIN_MICRO_LOOP.md`
20. `DOMAIN_MICRO_LOOP_FALLING_PALM.md`
21. `DOMAIN_MICRO_LOOP_SABOTAGED_STORAGE.md`
22. `DOMAIN_FIXTURE_IMPROVISED_HAMMER.md`
23. `DOMAIN_FIXTURE_CLOTH_SHELTER_WEATHER.md`
24. `DOMAIN_OPERATION_REFINEMENTS.md`
25. `DOMAIN_REGRESSION.md`
26. `DOMAIN_OPERATION_TRACES.md`
27. `DOMAIN_VOCABULARY_REGRESSION.md`

`DOMAIN_SCHEMA.dbml` is a visualization aid only and is not a persistence/database mandate.

Where newer functional-domain normalization/refinement documents make an older term more precise, the newer document owns that refined semantic boundary without reopening already accepted product rules.

---

# Product / behavioral state

Accepted high-level product direction remains:

- persistent living diorama around autonomous Wilson;
- player is an external presence, not Wilson's direct controller;
- open-ended indefinite survival rather than escape campaign;
- ordinary days should be contemplative but normally contain visible progress/interesting beats;
- property/capability-driven interactions instead of recipe catalog/tech tree;
- player God Power modifies world state, never psychology directly;
- resurrection is free/unlimited inside the same run under the accepted memory rules;
- Legacy Knowledge is a bounded operational subset across ended runs;
- one Diary surface combines structured run history/stats/screenshots while preserving epistemic separation.

No new broad psychological primitive was required by the representative scene suite.

---

# Architecture state

Architecture remains based on explicit authority boundaries.

State-owning families:

```text
World Simulation
Wilson Cognition
Projects
Player Run State / Intervention
Director
Action Execution / Resolution
Player Profile across runs
```

Derived/non-owning services include:

```text
Perception
Perceptual Evidence derivation
Observation coverage / expectation mismatch
Investigation / anomaly pattern derivation
Causal hypothesis / attribution
Expectation
Salience
Assembly validity derivation
Effective physical profile derivation
Protection / exposure derivation
Affordance / attemptability derivation
Hazard projection
Perceived threat derivation
Tactical candidate generation/evaluation
Intentional candidate generation/evaluation
Reaction
Learning proposal derivation
Luck
```

Rendering does not own authoritative simulation time.

---

# Functional-domain state

## Structural model

`DOMAIN_MODEL.md` defines language-neutral aggregates and state including:

- world entities/places/relations/environment/body;
- non-Wilson recurring actors;
- Wilson beliefs/associations/habits/episodes/intentions/presence relation;
- projects/director/player state;
- action execution;
- deterministic contracts and seed streams.

Structural representative-scene regression: **PASS**.

## Vocabulary/catalogues

`DOMAIN_VOCABULARY.md` / `DOMAIN_CATALOGS.md` normalize:

- references and identity families;
- property vs capability vs category;
- world relations;
- predicates and authority contexts;
- action vs semantic intention vs learned interaction;
- effect vs event vs observation/evidence;
- belief/knowledge proposition semantics.

Vocabulary representative-scene regression: **PASS**.

## Operation surface

`DOMAIN_OPERATIONS.md` defines commands, queries, derivation services and lifecycle transactions.

`DOMAIN_OPERATION_REFINEMENTS.md` refines newer procedural/micro-loop boundaries including:

```text
ResolveEffectivePhysicalProfile
QueryActionAttemptability
DerivePerceivedTacticalOpportunities
GenerateTacticalCandidates
InteractionRegion queries
PerceptualEvidence derivation
immediate same-chain learning
assembly/environment procedural operations
```

Integration operation regression: **PASS**.

## Procedural composition / object breadth

`DOMAIN_PROCEDURAL_COMPOSITION.md` formalizes:

- lightweight `MaterialDefinition`;
- derived `EffectivePhysicalProfile`;
- `PropertyDerivationDefinition` with deterministic/acyclic provenance;
- semantic bounded assembly slots;
- explicit `AssemblyValidity` separated from effective performance;
- properties vs true capabilities vs derived affordances;
- gradual exploration through `PerceptualEvidence` / `EvidenceRuleDefinition`;
- environmental response rules;
- presentation state bands over smaller authoritative properties;
- semantic `InteractionRegionDefinition` sub-targets.

The functional asset breadth (food, tools, modular structures, salvage, weather, absurd objects, comfort/personalization) is supportable without recipes or entity-type interaction switches, provided these normalized procedural contracts are preserved.

## Environmental protection / exposure

`DOMAIN_ENVIRONMENTAL_PROTECTION.md` adds the reusable bridge between spatial composition and environmental response:

```text
covering capability
!= ProtectionProjection
!= ExposureResult
```

It formalizes:

- `ProtectionProjection` as a derived configuration-relative shielding projection;
- `ResolveExposure` / `ExposureResult` for target-specific environmental exposure;
- partial coverage/leak behavior from geometry/configuration/integrity;
- bounded layered protection;
- deterministic degradation feedback through explicit semantic boundaries.

No universal `indoors` flag, roof-leak scalar, or Shelter/Roof owner is required.

## Scientific Method micro-loop

`DOMAIN_MICRO_LOOP.md` validates iterative experimentation and same-chain learning.

Critical distinctions:

```text
physical truth
!= action attemptability
!= Wilson-perceived tactic plausibility
!= Wilson desirability
```

Scientific Method regression: **PASS**.

## Falling Palm micro-loop / hazard dynamics

`DOMAIN_MICRO_LOOP_FALLING_PALM.md` and `DOMAIN_HAZARD_DYNAMICS.md` validate:

```text
DynamicProcessState
HazardProjection
PerceivedThreat
causal/intervention windows
authoritative vs perceived routes
secondary hazards
semantic-step concurrency ordering
```

Falling Palm regression: **PASS**.

## Sabotaged Storage micro-loop / epistemic investigation

`DOMAIN_MICRO_LOOP_SABOTAGED_STORAGE.md` and `DOMAIN_EPISTEMIC_INVESTIGATION.md` validate:

```text
ObservationCoverage
ExpectationMismatch
InvestigationContext
AnomalyPattern
CausalHypothesis with supporting/opposing evidence
PerceivedCausalOpportunity
information/discrimination value for investigation tactics
```

Sabotaged Storage regression: **PASS**.

## Improvised hammer composite-object fixture

`DOMAIN_FIXTURE_IMPROVISED_HAMMER.md` validates:

```text
components
→ assembly bindings
→ AssemblyValidity
→ EffectivePhysicalProfile
→ ordinary interaction resolution
→ degradation
→ failure/detachment
→ repair/replacement
→ recomputed semantics
```

Key invariant:

```text
assembly validity != effective performance
```

Improvised hammer regression: **PASS**.

## Cloth shelter weather fixture

`DOMAIN_FIXTURE_CLOTH_SHELTER_WEATHER.md` validates the final cross-domain composition chain:

```text
environment
+ world configuration
→ ResolveExposure
→ EnvironmentalResponseRule
→ moisture/integrity mutations
→ EffectivePhysicalProfile / AssemblyValidity
→ ProtectionProjection changes
→ attachment failure boundary
→ optional DynamicProcessState
→ detached reusable component
→ Project/cognition observe resulting world
```

The fixture confirms:

- wet cloth changes effective semantics without new entity type;
- a valid roof assembly may perform progressively worse;
- partial leaks derive from protection/exposure rather than a leak state machine;
- wind can degrade bindings through reusable response rules;
- detached cloth remains the same persistent world entity and may be reused;
- detached moving components reuse hazard dynamics;
- shelter projects query physical world truth rather than duplicate it;
- save/load persists causes and rederives projections.

Cloth shelter weather regression: **PASS with incorporated ProtectionProjection/ExposureResult refinement**.

---

# Functional asset catalog status

The visual PR includes broad brainstorming rounds under:

```text
docs/brainstorming/functional-asset-catalog/
```

Rounds 1–9 remain exploratory.

`ROUND_10_DOMAIN_NORMALIZATION.md` and the directory `README.md` define canonical interpretation so terms such as `heavy`, `throwable`, `wet`, `unexplored`, `favorite` do not mechanically become domain capabilities/states.

Cheap procedural regression contrasts include:

```text
empty vs water-filled barrel
tight vs loose tool binding
loose vs attached cloth
transparent vs opaque container
intact vs damaged/repaired shelter
stone vs bowling-ball impact grammar
```

---

# Functional-domain stabilization gate

Final status:

```text
Structural domain                    PASS
Vocabulary normalization            PASS
Representative scene regression     PASS
Operation regression                PASS
Functional asset breadth            PASS
Gradual exploration                 PASS
Composite object semantics          PASS
Environmental protection/exposure   PASS
Scientific Method micro-loop        PASS
Falling Palm hazard micro-loop      PASS
Sabotaged Storage epistemic loop    PASS
Improvised hammer fixture           PASS
Cloth shelter weather fixture       PASS
```

No new state-owning system was required for:

```text
crafting
exploration
tactical planning
procedural object composition
tool assembly/repair
material physics
interaction sub-regions
shelter/roof/weather protection
hazard projection
immediate threat handling
epistemic investigation
causal attribution working context
```

These remain composition/derivation concerns inside existing authority boundaries. Only time-extended authoritative physical evolution may require durable `DynamicProcessState` while active.

**Functional-domain stabilization gate: PASS.**

---

# Remaining non-blocking design questions

The following may be resolved during module/type design or implementation without reopening the functional domain by default:

1. exact spatial topology/navigation representation;
2. exact body mutation proposer API beneath World authority;
3. concrete shallow animal behavior representation;
4. exact environmental/dynamic-process persistence thresholds;
5. final bounded property catalogue and registered derivation policies;
6. exact semantic concept vocabulary boundaries;
7. concrete content serialization format;
8. presentation adapters for `InteractionRegion`, anchors and assembly sockets;
9. deterministic tie-break encoding for simultaneous semantic boundaries;
10. minimal serialization/reconstruction policy for save occurring mid-investigation;
11. concrete coarse representation used to derive protection coverage/gaps.

---

# Recommended next sequence

Proceed to package/module dependency layout using the stabilized domain boundaries.

Recommended order:

1. define language-neutral package/module responsibilities and dependency direction;
2. map canonical state owners versus derived services into those modules;
3. define registry/content-definition boundaries separately from runtime instances;
4. define orchestration/application layer dependencies without making it a domain owner;
5. define presentation/Godot adapters outside authoritative domain modules;
6. create concrete domain types/interfaces in the chosen implementation language;
7. implement the first vertical slice using the existing fixture set as regression targets.

The user's current implementation preference may later favor direct GDScript, but the dependency layout should remain conceptually language-neutral first.

---

# Implementation readiness

The previous architecture implementation gate remains valid and the functional-domain stabilization gate is now also complete.

Recommended implementation path:

```text
package/module dependency layout
→ concrete domain types
→ declarative content fixtures
→ first vertical slice
→ headless deterministic regressions
→ presentation adapters
```

Do not translate brainstorming asset terminology directly into gameplay enums/classes. Implement the normalized domain contracts and derive higher-level behavior from them.
