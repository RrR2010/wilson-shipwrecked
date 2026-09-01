# Handoff — System Breadth → Spatial Adapters, Scenario Bootstrap and Integrated Validation

## Purpose

This handoff transfers Wilson Shipwrecked from the completed **structural runtime foundation + planned system-breadth implementation** into the final pre-playable integration phase:

```text
fine spatial/nav/occlusion + Godot presentation adapters
→ deterministic scenario/bootstrap tooling
→ representative multi-system scenario + seed-population validation
```

This file is transition context, not design authority. Canonical documents win on conflicts. The documentation has been consolidated for this handoff; do not recreate the decisions below in parallel notes.

---

# 1. Exact starting checkpoint

Last gameplay/runtime merge baseline before this documentation-only transition:

```text
main gameplay baseline:
11b763eac7ad642936e21738bb85d8fb0bca3d5c

Godot:
4.7.1

strict local checkpoint:
RESULT: 39 PASS / 39 TOTAL
PASS headless_suite (39 tests)
```

The documentation branch containing this handoff changes contracts/maps only; it does not add runtime tests or claim a newer gameplay checkpoint.

Before runtime implementation, start from the merged documentation/main state and run:

```powershell
.\tests\run_headless_tests.ps1
```

Treat 39/39 as the inherited expected baseline until a new runtime test is intentionally added.

---

# 2. Required reading — minimal path

Always read:

```text
AGENTS.md
docs/README.md
docs/DISCOVERY_STATUS.md
```

For the first vertical, then read:

```text
docs/ARCHITECTURE.md
docs/SIMULATION_CONTRACTS.md
docs/SIMULATION_ORCHESTRATION.md
docs/MUTATION_AUTHORITY.md
docs/ASSET_SPEC.md
docs/ASSET_PIPELINE.md
```

Read domain appendices only when a concrete spatial/scenario case touches them.

For final representative validation, use as evidence sources:

```text
docs/SCENE_VALIDATION.md
docs/brainstorming/representative-scene-catalog.md
docs/asset-catalog/SCENE_COVERAGE.md
```

These scenario catalogs are evidence/backlog, not authority for new scene-specific APIs.

---

# 3. What is closed

Do not reopen these phases by default:

```text
FUNCTIONAL DOMAIN                    CLOSED
STRUCTURAL RUNTIME FOUNDATION        CLOSED
DOCUMENTATION CONSOLIDATION          CLOSED
DRIVES                               VALIDATED
PROJECTS                             VALIDATED
LEARNING STATE                       VALIDATED
ENVIRONMENT / DYNAMIC PROCESSES      VALIDATED
PROTECTION / HAZARDS                 VALIDATED
SHALLOW NON-WILSON ACTORS            VALIDATED
DIRECTOR / PLAYER INTERVENTION       VALIDATED
RUN LIFECYCLE / PLAYER PROFILE       VALIDATED
```

Current owner families are established:

```text
World
WilsonCognition
Projects
Director
PlayerRunState
RunLifecycleState
ActionExecution
PlayerProfile
```

Derived services, indexes, projections, spatial adapters, Godot nodes, fixtures and debug tools do not become new owners.

---

# 4. Non-negotiable invariants

## Authority separation

```text
World truth
!= Wilson observation
!= Wilson belief
!= Wilson desirability
!= player-private intent
!= Director intent
!= cross-run profile state
!= presentation
```

## Mutation direction

```text
owner stores     = authoritative state
query ports      = narrow reads
derived services = proposals/projections
commands         = validated owner-local mutation
```

No spatial adapter, Godot node, debug console or test fixture may bypass owner validation.

## Causality

```text
ActionExecution
→ ActionOutcome
→ validated World commit
→ WorldEvent + SemanticChangeSet
→ derived invalidation
→ Perception
→ PerceptualEvidence
→ owner-local learning
→ reconsideration/selection
→ CurrentIntention
```

Committed truth cannot be rewound by presentation, fixtures, debug commands, suggestion or reconstruction.

## Derived state

Do not persist or fixture-author reconstructible truth such as:

```text
EffectivePhysicalProfile
AssemblyValidity
CompositionDependencyProjection
ProtectionProjection
ExposureResult
HazardProjection
PerceivedThreat
candidate evaluations
salience
routes by default
perception snapshots
indexes/caches
```

Persist/restore causes and rebuild projections.

---

# 5. Global testability architecture — already accepted

This is now canonical in `ARCHITECTURE.md` and `SIMULATION_ORCHESTRATION.md`:

```text
normal authoritative owner state
            ↑
common restore/bootstrap boundary
            ↑
real save | deterministic test fixture | debug scenario
```

This boundary is required so gameplay blocks can be tested directly without simulating all prior gameplay.

Examples of intended named artificial states:

```text
hungry_wilson_near_food
wilson_mid_shelter_project
storm_with_bad_roof
```

A fixture/debug scenario may specify durable owner causes and explicit deterministic seed state. It must enter through the same validation/construction/rebuild semantics as normal restore/bootstrap.

Forbidden:

```text
fixture mutates private stores after bootstrap
fixture serializes derived projections as truth
fixture skips action/process causal validation
Godot scene transform becomes authoritative scenario state
debug console exposes arbitrary store writes
separate debug-only simulation architecture
```

The future scenario launcher and debug console are adapters over the same bootstrap services and normal commands.

---

# 6. Vertical A — fine spatial/nav/occlusion + Godot presentation adapters

## Objective

Refine the already-closed coarse semantic spatial boundary without replacing it.

Existing semantic truth remains conceptually:

```text
EntityInstance.place_id
WilsonWorldState.place_id
World relations
```

Fine spatial infrastructure should implement/refine narrow ports for questions such as:

```text
metric distance
nearby with metric constraints
route/path availability
route cost/length
occlusion / line of sight
hearing accessibility
interaction reachability
semantic anchor/InteractionRegion resolution
```

## Godot responsibilities

Godot may provide:

```text
Node3D transforms
NavigationServer/navmesh
physics/raycast visibility helpers
colliders/areas
semantic interaction anchors
body/assembly/perch sockets
scene-instance registry
animation/audio/VFX/camera/UI adapters
```

But Godot artifacts are not domain identity.

Preferred mapping:

```text
stable RuntimeWorldRef / DomainId
↔ explicit scene-instance adapter mapping
↔ Node3D / mesh / collider / anchors
```

Do not use scene path, object name, instance ID or node pointer as durable semantic identity.

## Important distinction

```text
semantic placement
!= presentation transform
```

A render/interpolation transform change does not itself commit World placement. If gameplay movement must change authoritative semantic placement, that change uses the admitted World movement/placement boundary.

## Suggested first tests

At minimum prove:

```text
1. spatial adapter can resolve deterministic distance for mapped subjects;
2. unmapped/invalid subjects fail explicitly rather than inventing placement;
3. line-of-sight/occlusion changes perception access without rewriting World truth;
4. nav/route result is derived and reconstructible;
5. insertion/order of mapped scene nodes does not affect semantic result;
6. coarse PlaceId semantics still work when fine adapter is unavailable/headless;
7. Godot presentation adapter cannot bypass ActionAttemptability/World mutation;
8. semantic anchors resolve by typed role/anchor meaning rather than object-specific offsets.
```

Keep domain/service tests headless where possible. Add Godot integration tests only for adapter behavior that actually requires engine geometry/navigation.

---

# 7. Vertical B — deterministic playable scenario/bootstrap tooling

## Objective

Build one reusable development bootstrap mechanism before creating many bespoke smoke scenes.

Target composition:

```text
ScenarioDefinition / fixture data
→ common restore/bootstrap service
→ authoritative owner graph
→ rebuilt projections/indexes
→ optional headless runner
→ optional Godot presentation launcher
```

A scenario should be able to configure relevant durable causes across existing owners, for example:

```text
World entities/properties/relations/place
Wilson cognition/drives/beliefs/learning state
projects
dynamic processes
actor runtime state
Director opportunity state
PlayerRunState
RunLifecycleState
ActionExecution causal state when justified
explicit gameplay RNG/seed state
```

Do not require every scenario to populate every owner. Missing optional owners should use explicit canonical defaults/bootstrap rules, not accidental null-dependent behavior.

## Validation requirements

Scenario admission must reject at least:

```text
dangling DomainIds
unknown authored definitions
out-of-range/non-finite values
invalid relation qualifiers
invalid lifecycle combinations
impossible committed/uncommitted ActionExecution snapshots
invalid project/director/process references
invalid cross-run leakage
fixture-authored derived projections
```

## Development launcher

A small launcher may list/choose scenarios and start them in Godot. Keep this thin:

```text
scenario id
→ load declarative fixture
→ common bootstrap
→ presentation adapter binds restored semantic world
```

Do not build gameplay logic into the launcher.

---

# 8. Vertical C — representative multi-system validation

## Objective

Stop validating only isolated subsystems and prove that the existing primitives compose into interesting, stable gameplay behavior.

Select scenes from the representative catalog that force interactions across several systems, for example combinations of:

```text
drives + perception + decision + attemptability
project + environment + protection
hazard + perception + immediate threat + route
animal actor + Wilson association/habit
Director opportunity + player suggestion + autonomy
player intervention + perception + Presence attribution
run lifecycle + persistence/reconstruction
```

Do not script the expected narrative. Configure causes and assert semantic invariants/outcomes/ranges.

Representative evidence may reveal missing cross-cutting primitives. If so:

```text
scenario exposes real gap
→ identify canonical owner/contract
→ implement reusable fix
→ add focused regression
→ return to representative scenario
```

Never add `if scenario == X` or scene-specific domain APIs.

---

# 9. Known cross-cutting correctness/support work

`docs/DISCOVERY_STATUS.md` owns the current list. At handoff time it includes areas such as:

```text
collision/overlap + grounded Wilson body consequences
generic reconsideration gating
drive hysteresis-band memory persistence
Wilson-relative route/escape evaluation
intervention causal windows
automatic habit-disuse/context producers
Presence causal-attribution production
full run-save composition across owner-local snapshots
full new-run bootstrap/reset
Legacy-to-new-Wilson seeding policy
```

These are not ten new independent “systems.” Pull them forward only when the active spatial/scenario work requires them, but do not work around them in a way that falsifies the canonical behavior.

Likely early pull-forwards:

- **Wilson-relative route/escape evaluation** during spatial/nav work;
- **collision/body consequence** when a representative hazard needs actual injury/death;
- **full run-save composition** when common bootstrap needs one composed real-save path;
- **generic reconsideration gating** when integrated scenarios expose per-tick routing artifacts;
- **Presence attribution production** when player-intervention representative scenes are added.

---

# 10. Persistence/bootstrap caution

Current owner-local development schemas are recorded in `DISCOVERY_STATUS.md`. Do not invent a fourth authority store merely to compose them.

The full save/bootstrap boundary should orchestrate existing owners/snapshot responsibilities.

Preferred conceptual direction:

```text
FullRunSnapshot / BootstrapInput
  contains versioned owner sections

bootstrap coordinator
  validates compatible authored content + sections
  delegates restore to owner/domain-specific reconstruction
  rebuilds derived state
  returns one authoritative run context
```

The composed envelope may be new infrastructure, but it must not redefine owner semantics.

---

# 11. PR / validation workflow

Use the existing workflow:

1. branch from current `main`;
2. implement one coherent vertical/slice;
3. open one **draft PR**;
4. user runs local Godot 4.7.1 strict suite;
5. fix failures on the same branch/PR;
6. after local green, update `DISCOVERY_STATUS.md` and PR body;
7. **user marks the same PR Ready for review**;
8. merge the same PR, normally squash.

Do not create duplicate non-draft PRs to work around readiness state.

Never claim local Godot validation without the user's actual runner output.

---

# 12. Testing standard for the remaining phase

The remaining phase must increase test realism without sacrificing determinism.

## Baseline rule

Every runtime change still passes:

```powershell
.\tests\run_headless_tests.ps1
```

But the final scenario suite must go well beyond a single nominal fixture.

## Variability matrix

For every important representative scenario/system boundary, deliberately vary dimensions such as:

```text
SEEDS
- one fixed debugging seed
- a stable small seed population
- seeds that alter tie-break/random alternatives

NUMERIC EXTREMES
- zero/minimum
- just below threshold
- exactly at threshold when meaningful
- just above threshold
- maximum admitted value
- long accumulation near saturation

DATA VOLUME
- empty collections
- one element
- typical population
- many entities
- many qualified relations
- many beliefs/episodes/habits
- many active processes/projects/actors
- dense local candidate sets

ORDERING
- reversed insertion order
- shuffled authored/fixture ordering
- semantically equal inputs with different JSON/map ordering

SIMULTANEITY
- multiple ordinary candidates
- threat + project + drive pressure together
- several visible events in one semantic window
- multiple active hazards/processes
- conflicting player/Director/Wilson pressures

SPATIAL EXTREMES
- same anchor/coincident
- near interaction boundary
- just out of range
- clear line of sight
- partial/full occlusion
- no route
- multiple routes
- dense obstacles/subjects

CAUSAL/LIFECYCLE EXTREMES
- before action commit
- exactly restored around commit boundary
- post-commit tail
- completed/interrupted execution
- active/paused/completed process/project
- DEAD/ACTIVE/ENDED run states where applicable
- save/restore after meaningful transition

INVALID/ADVERSARIAL INPUT
- dangling IDs
- invalid bounds/non-finite values
- incompatible role bindings
- malformed lifecycle combinations
- authored derived state in fixture
- impossible cross-owner reference
```

## Assertions

Prefer invariants and bounded ranges over brittle exact narrative sequences.

Assert where relevant:

```text
finite values
no overflow/unbounded accumulation
stable semantic ordering
same seed + same semantic input = same result
insertion order does not change semantic result
bounded traversal/query result sizes
no hidden World truth leaks into Wilson evidence
no owner is mutated by a projection/adapter
rejected mutation leaves state/resource unchanged
restore/bootstrap does not replay committed consequences
derived state after rebuild is semantically equivalent
immediate threat still wins by routing regime
Wilson autonomy survives suggestion/Director pressure
```

## Scale testing

Large-data tests should verify **semantic scalability guards**, not arbitrary machine-speed numbers.

Good checks:

```text
query result is capped/bounded
traversal honors max depth/result limit
candidate generation stays within declared local scope
stable ordering is maintained with large input sets
memory/history stores respect configured capacities
no accidental global Cartesian product is required
```

Wall-clock performance benchmarks may be added separately when useful, but must not replace semantic scale assertions.

## Population testing

For behavioral/calibration questions, use fixed deterministic seed populations rather than forcing every individual seed toward one desired behavior distribution.

Look for:

```text
bounds violations
pathological loops
starvation of legitimate candidates
repeated threshold spam
unbounded memory/process growth
determinism drift
rare impossible states
systematic failure under high density
```

Record failing seeds/scenarios so each discovered pathology becomes reproducible.

---

# 13. Definition of completion for this handoff phase

This handoff can be considered consumed when the project has all of the following:

```text
fine spatial/nav/occlusion ports implemented behind established semantic boundaries
Godot entity/anchor/presentation mapping without authority leakage
common real-save/test-fixture/debug-scenario restore/bootstrap mechanism
small development scenario launcher using that mechanism
representative multi-system scenario suite
deterministic seed-population coverage
edge/extreme/high-volume robustness coverage
cross-cutting gaps discovered by scenarios either fixed or explicitly tracked
strict suite green at the new final checkpoint
```

At that point the next handoff should be based on what the representative game scenarios actually reveal — likely content/playability/balance/polish rather than another architecture-first pass.

---

# 14. Final instruction to the next agent

Do not optimize for quickly drawing a scene on screen. Optimize for this chain:

```text
valid semantic state
→ correct fine spatial query
→ correct authoritative simulation behavior
→ reproducible scenario bootstrap
→ faithful Godot presentation
→ robust validation across variability/extremes/scale
```

The purpose of the next phase is to prove the implemented systemic architecture works as a game under **messy combinations**, not merely that each subsystem passes its isolated happy-path test.