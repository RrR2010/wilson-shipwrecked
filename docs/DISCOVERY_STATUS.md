# Discovery Status

## Current phase

Wilson Shipwrecked has completed the product/behavior/architecture discovery gate and the first language-neutral functional-domain passes.

The current design phase is **functional-domain stabilization through concrete scenario fixtures/micro-loops**, immediately before package/module layout and implementation-language-specific code.

The project is no longer waiting for a first domain model: structural, operation, vocabulary, procedural-composition, Scientific Method, Falling Palm, Sabotaged Storage and improvised-hammer regressions now exist.

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
16. `DOMAIN_HAZARD_DYNAMICS.md`
17. `DOMAIN_EPISTEMIC_INVESTIGATION.md`
18. `DOMAIN_MICRO_LOOP.md`
19. `DOMAIN_MICRO_LOOP_FALLING_PALM.md`
20. `DOMAIN_MICRO_LOOP_SABOTAGED_STORAGE.md`
21. `DOMAIN_FIXTURE_IMPROVISED_HAMMER.md`
22. `DOMAIN_OPERATION_REFINEMENTS.md`
23. `DOMAIN_REGRESSION.md`
24. `DOMAIN_OPERATION_TRACES.md`
25. `DOMAIN_VOCABULARY_REGRESSION.md`

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
Affordance/attemptability derivation
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

`DOMAIN_PROCEDURAL_COMPOSITION.md` was added after stress-testing against the extended functional asset catalog.

It formalizes:

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

## Scientific Method micro-loop

`DOMAIN_MICRO_LOOP.md` expands the game loop into semantic frame groups and validates one complete iterative experiment chain.

Critical distinctions now explicit:

```text
physical truth
!= action attemptability
!= Wilson-perceived tactic plausibility
!= Wilson desirability
```

Scientific Method regression: **PASS with incorporated refinements**.

## Falling Palm micro-loop / hazard dynamics

`DOMAIN_MICRO_LOOP_FALLING_PALM.md` validates the immediate-threat path against a time-extended environmental accident.

`DOMAIN_HAZARD_DYNAMICS.md` promotes reusable semantics including:

```text
DynamicProcessState
HazardProjection
PerceivedThreat
causal/intervention windows
authoritative vs perceived routes
secondary hazards
semantic-step concurrency ordering
```

Falling Palm regression: **PASS with incorporated hazard-dynamics refinements**.

## Sabotaged Storage micro-loop / epistemic investigation

`DOMAIN_MICRO_LOOP_SABOTAGED_STORAGE.md` validates an offscreen player intervention whose causal identity is hidden from Wilson.

`DOMAIN_EPISTEMIC_INVESTIGATION.md` promotes reusable semantics including:

```text
ObservationCoverage
ExpectationMismatch
InvestigationContext
AnomalyPattern
CausalHypothesis with supporting/opposing evidence
PerceivedCausalOpportunity
information/discrimination value for investigation tactics
```

Sabotaged Storage regression: **PASS with incorporated epistemic-investigation refinements**.

## Improvised hammer composite-object fixture

`DOMAIN_FIXTURE_IMPROVISED_HAMMER.md` validates the physical composition branch in isolation.

The fixture demonstrates:

```text
handle + impact head + binding
→ validated assembly bindings
→ AssemblyValidity
→ EffectivePhysicalProfile
→ derived impact semantics
→ ordinary hit resolution
→ grounded component degradation
→ weaker-but-valid configuration
→ component/binding failure
→ invalid/incomplete assembly
→ replacement/rebinding
→ recomputed capability
```

The key invariant is now explicit:

```text
assembly validity
!= effective tool performance
```

A semantically compatible assembly may be weak, and a degrading assembly may remain valid before actual structural failure. No universal `tool_quality` scalar or target-specific hammer recipe is required.

Improvised hammer regression: **PASS with incorporated AssemblyValidity refinement**.

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

# Current functional-domain gate

Current status:

```text
Structural domain                    PASS
Vocabulary normalization            PASS
Representative scene regression     PASS
Operation regression                PASS
Functional asset breadth            PASS + normalized procedural contracts
Gradual exploration                 PASS after evidence refinement
Composite object semantics          PASS after EffectivePhysicalProfile refinement
Scientific Method micro-loop        PASS
Falling Palm hazard micro-loop      PASS
Sabotaged Storage epistemic loop    PASS
Improvised hammer fixture           PASS
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
hazard projection
immediate threat handling
epistemic investigation
causal attribution working context
```

These remain composition/derivation concerns inside existing authority boundaries. Only time-extended authoritative physical evolution may require durable `DynamicProcessState` while active.

---

# Remaining non-blocking design questions

The following may still be refined during concrete fixtures/implementation, but they do not require reopening product discovery:

1. exact spatial topology representation / navigation implementation;
2. exact body mutation proposer API beneath World authority;
3. concrete shallow animal behavior representation;
4. exact environmental/dynamic-process persistence thresholds;
5. final bounded property catalogue and registered derivation policies;
6. exact semantic concept vocabulary boundaries;
7. concrete content serialization format;
8. exact presentation adapters for `InteractionRegion` / anchors / sockets;
9. exact deterministic tie-break encoding for simultaneous semantic boundaries;
10. exact minimal serialization/reconstruction policy for a save occurring mid-investigation.

---

# Recommended next sequence

Before implementation-specific package layout:

1. create the remaining environment/composition fixture (`cloth/shelter in rain/wind`);
2. validate that it reuses environmental response + assembly + effective profile + dynamic hazard semantics without bypass flags/classes;
3. normalize any final schema ambiguity;
4. then design package/module dependency layout;
5. only then select concrete language/runtime representation details.

The user's current implementation preference may later favor direct GDScript, but no functional-domain decision currently depends on that language choice.

---

# Implementation readiness

The previous architecture implementation gate remains valid.

The added functional-domain passes reduce implementation risk further, but the recommended order is still:

```text
final environment/composition fixture
→ package/module layout
→ concrete domain types
→ first vertical slice
```

Do not jump directly from asset/object brainstorming to concrete gameplay enums/classes. Use the normalized domain vocabulary and procedural contracts first.
