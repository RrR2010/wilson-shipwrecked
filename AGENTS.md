# AGENTS.md

## Mission

Build Wilson Shipwrecked as a coherent systemic simulation and living 3D diorama. Optimize for reusable rules, explicit authority and modular content rather than maximum feature count.

## Current project phase

The **structural runtime foundation and its key causal boundaries are implemented and locally validated**. This includes common bootstrap/restore composition, production new-run generation, deterministic engine-scenario tooling, Godot spatial/navigation/perception/physics adapters, grounded autonomous action, learning/habits, projects, non-Wilson actor relationships/locomotion, physical accidents/threats, player intervention/Presence attribution, intention interruption/resumption, belief reconciliation after unseen World changes, procedural weather, configuration-relative protection/exposure and authored structural relation failure.

Current strict baseline is recorded only in `docs/DISCOVERY_STATUS.md`; do not duplicate test counts or schema versions here.

The leading runtime phase is now:

```text
observable Godot living simulation
→ compose existing systemic runtime in one continuous scene
→ use readable primitive presentation before final assets
→ expose operator-facing causal readability / time controls
→ discover real integration/calibration gaps
→ add the smallest reusable primitive only when required
```

Primary goals:

```text
1. a real continuously running Godot development scene
2. readable primitive-shape composition for Wilson, actors, resources and projects
3. coherent needs / routines / projects / weather / actor interference over time
4. visible interruption, persistence and later resumption/history effects
5. operator inspection of current intent/recent causes plus safe time acceleration
```

Do not continue foundation architecture merely because another abstraction could be invented. Persistence/API cleanup and generalized infrastructure remain requirement-driven, although repeated concrete scene wiring may now justify a narrow reusable scene-binding/host composition boundary.

Before substantial runtime work, read:

1. [`docs/README.md`](docs/README.md) — documentation map and authority hierarchy;
2. [`docs/DISCOVERY_STATUS.md`](docs/DISCOVERY_STATUS.md) — concrete validated baseline and deferred pressures;
3. [`docs/handoffs/systemic-runtime-to-observable-godot-living-simulation.md`](docs/handoffs/systemic-runtime-to-observable-godot-living-simulation.md) — active runtime transition context;
4. only the canonical bundle relevant to the selected representative situation.

Asset/modeling work proceeds in parallel. The active living-simulation handoff intentionally excludes art/asset/modeling documentation unless the operator later changes that scope. Primitive-shape presentation is a runtime readability scaffold, not asset production.

Do not reopen foundation ownership, replace established typed contracts with generic containers, or introduce a universal framework merely because one new scenario needs implementation.

---

# Documentation workflow

Read the smallest canonical bundle sufficient for the task. Fixtures/regressions are evidence, not competing specifications.

## Simulation/domain/architecture

Core canonical bundle:

```text
ARCHITECTURE.md
SIMULATION_CONTRACTS.md
SIMULATION_ORCHESTRATION.md
MUTATION_AUTHORITY.md
DOMAIN_MODEL.md
DOMAIN_VOCABULARY.md
DOMAIN_CATALOGS.md
DOMAIN_OPERATIONS.md
DOMAIN_PROCEDURAL_COMPOSITION.md
```

Specialized appendices only when affected:

```text
DOMAIN_ENVIRONMENTAL_PROTECTION.md
DOMAIN_HAZARD_DYNAMICS.md
DOMAIN_EPISTEMIC_INVESTIGATION.md
DOMAIN_MICRO_LOOP.md
```

For Wilson/player-visible gameplay selection, also use:

```text
PRODUCT.md
BEHAVIORAL_MODEL.md
SCENE_VALIDATION.md
brainstorming/representative-scene-catalog.md
```

## Spatial / Godot presentation work

Read at minimum:

```text
docs/ARCHITECTURE.md
docs/SIMULATION_ORCHESTRATION.md
docs/SIMULATION_CONTRACTS.md
docs/MUTATION_AUTHORITY.md
docs/testing/SCENE_TESTS.md
```

Then inspect relevant ports/tests before adding infrastructure adapters.

For non-trivial Godot API behavior, **research before implementing**: verify the exact current API and lifecycle semantics in authoritative Godot documentation/references, inspect existing repository adapters, and use a small executable probe when timing/order behavior remains ambiguous. Do not guess navigation synchronization, physics/process ordering, transform-space behavior, scene-tree lifecycle, time scaling or UI/world projection semantics.

During the current primitive living-simulation phase, follow the active handoff's explicit exclusion of art/asset/modeling documentation. That exclusion is phase-specific, not a change to the repository's general asset authority model.

## Asset/content catalog

```text
docs/asset-catalog/README.md
→ relevant catalog tables
→ PRODUCT.md / domain core as needed
→ art contracts when visual requirements are affected
```

`docs/asset-catalog/` is the cross-cutting source of truth for modeled-content requirements/backlog. `docs/art/` must not maintain a second object catalog.

## Visual / 3D production

```text
docs/asset-catalog/<relevant row>
→ docs/VISUAL_GUIDE.md
→ docs/art/README.md + relevant references
→ docs/ASSET_SPEC.md
→ docs/ASSET_PIPELINE.md
→ docs/art/AGENT_ART_PRODUCTION.md
```

Brainstorming asset rounds are historical breadth evidence, not normal production authority.

---

# Documentation rules

- Prefer one canonical owner per concern; `docs/README.md` defines the map.
- Update an existing canonical owner rather than creating a new top-level document for every fixture/edge case/system.
- Validation traces/fixtures prove sufficiency; they do not create scene-specific APIs.
- `docs/brainstorming/` is exploratory/historical evidence.
- `docs/handoffs/` is stage-transition context, not durable design authority.
- `docs/design-reviews/` contains temporary calibration/review evidence; it is not canonical authority.
- Do not recreate permanent `*_REFINEMENTS`, `*_NOTES`, `*_V2` override chains.
- Concrete schema versions/test counts belong in `DISCOVERY_STATUS.md`.

## Design reviews

Design/calibration reviews live under `docs/design-reviews/` and should begin with `Status: OPEN` or `Status: COMPLETED`.

When implementation consumes a review:

1. read it as advisory evidence against current canonical contracts and representative behavior;
2. resolve applicable findings via implementation/tests/canonical updates or explicit justified deferment/rejection;
3. do not silently work around findings;
4. mark the review completed only when its applicable scope is actually consumed;
5. keep durable decisions in canonical owners, not in review documents.

## Handoffs

Stage-transition handoffs live under `docs/handoffs/` and should be named for the transition/problem transferred.

A handoff should:

1. identify the exact phase/objective;
2. give a minimal required-reading path;
3. list closed decisions/invariants and explicit anti-decisions;
4. identify deliverables/acceptance gates;
5. point to canonical sources instead of duplicating them extensively;
6. separate open questions from accepted contracts;
7. record the exact validated strict-test checkpoint.

Only create a handoff when work is actually being transferred to another agent/stage.

---

# Git / PR / multi-agent workflow

`main` is the only integrated project state.

Normal work uses a short-lived task branch and PR. Do not commit directly to `main` during normal development.

Canonical flow:

```text
latest origin/main
→ short-lived task branch
→ coherent commits
→ required validation
→ PR targeting main
→ synchronize with main if materially required
→ validation
→ explicit operator merge authorization
→ squash merge
→ branch cleanup
```

## Branch isolation

Every normal task branch starts from `origin/main` and every normal PR targets `main`.

Do not base task B on another active unmerged task A. If B depends on A:

```text
finish and merge A
→ refresh origin/main
→ create/update B from new main
```

Stacked branches require an explicit exceptional reason.

## Multi-agent worktrees

Concurrent agents should use separate worktrees and branches. An agent owns its task branch; do not push to another active agent's branch.

Avoid concurrent edits to coordination hotspots such as:

```text
AGENTS.md
project.godot
docs/README.md
shared catalog/index files
shared pipeline configuration
```

When two tasks need the same hotspot, integrate the smaller/shared change first where practical, then synchronize the other branch.

## Synchronization

Do not continuously merge `main` merely because another PR landed. Synchronize when newer `main` changes files/contracts used by the task, conflicts are likely, or integration materially depends on it.

For active shared worktrees prefer:

```bash
git fetch origin
git merge origin/main
```

Avoid rebase/force-push unless explicitly coordinated. Squash merge normalizes final history.

After meaningful synchronization, rerun affected validation.

## Pull requests

Open a PR when a branch is a coherent reviewable/integratable slice.

PRs should record:

- behavioral/asset scope;
- architectural/catalog implications;
- validation performed;
- known deferred work.

Runtime/domain PRs must satisfy the strict test gate before merge. Asset PRs satisfy applicable pipeline and visual validation.

Use squash merge for normal task PRs.

## Merge authorization

Do not merge a PR on behalf of the operator without explicit authorization for that specific merge. Earlier approvals do not carry forward to future PRs.

## Branch cleanup

After squash merge, task branches are disposable. Delete/prune merged branches/worktrees when safe. Git commits and merged PRs are the historical record.

---

# Global authority invariants

These contracts are regression-backed. Preserve them unless representative evidence proves a canonical change is required.

## Owners

```text
World
Wilson Cognition
Projects
Director
PlayerRunState / Intervention
RunLifecycleState
ActionExecution / Resolution
PlayerProfile across runs
```

A projection/service/index/adapter does not become an owner because mutation would be convenient.

Keep separate:

```text
World truth
!= Wilson observation
!= Wilson belief
!= Wilson desirability
!= non-Wilson actor relationship state
!= player-private intent
!= Director intent
!= cross-run profile state
!= presentation
```

## Owner/query/service/command split

```text
owner stores     = authoritative state
query ports      = narrow semantic reads
derived services = deterministic proposals/projections
commands         = validated owner-local mutation
```

No presentation/debug/fixture path may bypass this split.

## Typed semantic identity

- Use `DomainId` / typed semantic IDs, not display strings or scene paths, for domain identity.
- Durable belief identity uses typed `EpistemicClaim` (`PROPERTY | RELATION | EVENT`).
- Do not restore generic predicate + arbitrary Variant argument identity.
- Numeric semantic identity must survive JSON representation differences such as `3` vs `3.0`.
- Property/qualifier semantic values are bounded; NaN/infinity are invalid.

## Event naming

- `EventDefinition` = semantic/perceptual definition of an ordinary event kind.
- `WorldEvent` = authoritative occurrence fact.
- `ObservedEvent` = Wilson-accessible projection.
- Director lifecycle remains separate directed-opportunity state.

## World relations / composition

`WorldRelation` identity includes relation type + subject + object + optional bounded qualifier. Assembly bindings use ordinary World relations; there is no `AssemblyStore`.

Derived physical/composition/protection/hazard projections are reconstructible, not authority.

## Action causality

```text
ActionExecution
→ ActionOutcome
→ validated World commit
→ WorldEvent + SemanticChangeSet
→ derived invalidation
→ grounded cross-owner consequences
→ Perception
→ PerceptualEvidence
→ owner-local learning
→ reconsideration / decision
→ CurrentIntention
→ intention execution progression
```

- `ActionAttemptability` is a pure authoritative read; it does not guarantee goal success.
- ActionExecution owns progress/commit/terminal lifecycle but does not mutate World.
- crossing commit emits an outcome exactly once.
- committed physical truth cannot be rewound by reconsideration, suggestion, Luck, load or debug tools.
- `SemanticChangeSet` is invalidation, not a generic event bus.
- cross-owner consequences occur only after accepted grounded commits through explicit services.

## Perception / belief / learning

- Perceptibility + runtime access determine accessible roles/modalities.
- cognition receives only accessible observation/evidence semantics.
- `EpistemicGraphProjection` indexes cognition-owned beliefs only; it never imports hidden World truth.
- hidden World changes do not directly synchronize Wilson beliefs.
- mutually exclusive property beliefs may be reconciled only from new accessible perceptual evidence.
- same-chain learning occurs before the next tactical choice when it can affect that choice.

## Habits

```text
current perceived context
!= historical HabitStore
```

Perceptual evidence may derive a semantic cue used to activate a learned habit candidate. Hidden World state must not directly activate a habit. A perception-sensitive candidate source does not own/cache perception.

## Presence attribution

```text
player-private intent
!= World consequence
!= Wilson perception
!= Presence attribution
```

Player intervention matters to Presence cognition only through an actual World consequence that becomes accessible evidence and survives authored attribution rules.

## Immediate threat / interruption

Immediate threat uses a separate routing regime, never infinite/giant utility. Wilson consumes `PerceivedThreat`, not hidden `HazardProjection`.

A threat may temporarily suspend an ordinary current intention and later restore it. This is a narrow single suspended-intention semantic proven by representative pressure, not admission of an arbitrary generic intention stack. Restored activity must still respect current validity/context; do not treat suspension as rewind.

## Non-Wilson actors

Wilson-relative association/desirability remains separate from non-Wilson actor relationship state. `ActorRelationshipStore` is not `AssociationStore`, `ActorStateStore` or a universal social graph.

Physical locomotion and semantic actor placement remain separate: semantic destination selection → physical transit → matching arrival → semantic placement commit.

## Physical observation / hazard

```text
Godot physical truth
!= physical observation
!= admitted semantic event
!= authored consequence policy
!= body mutation
!= Wilson perception/belief
```

Collision existence is not automatically damage. A committed dynamic process is not a committed collision victim/result.

## Run/Profile

`RunLifecycleState` does not replace WilsonBody truth. Resurrection first crosses the physical World/body boundary.

`PlayerProfile` remains outside active Run state. Legacy admission is explicit and must not copy Wilson autobiography wholesale.

---

# Common restore/bootstrap invariant

Every meaningful gameplay subsystem must be testable from artificial but valid authoritative state without replaying all prior gameplay.

Canonical shape:

```text
production new run --------┐
real save -----------------┼→ common owner/bootstrap + runtime composition
valid deterministic fixture┘
                                  ↓
                         authoritative owner state
```

`NewRunDefinition` and deterministic scenario definitions are bootstrap inputs, not runtime owners. Fresh runs, restore and deterministic fixtures converge on `SimulationOwnerBootstrapper` / `RunRuntimeComposer` where applicable.

A fixture may declare durable owner causes and deterministic seed state, but must pass normal validation/construction/reconstruction semantics.

Do not:

```text
mutate private stores after bootstrap to manufacture scenarios
persist derived projections/caches as fixture truth
skip causal validation because a fixture is test-only
use Godot transforms as authoritative scenario state
build arbitrary direct-store debug mutation
create a second debug-only simulation architecture
```

Development launchers/debug tooling are adapters over common bootstrap and normal commands.

---

# Representative-pressure workflow

The next phase is explicitly scene-led.

For each candidate feature:

1. identify the player-visible situation requiring it;
2. compose current owners/services first;
3. identify the exact missing semantic gap;
4. decide whether it is durable owner state or derived state;
5. implement the smallest reusable primitive;
6. add focused regression;
7. add an integrated scenario when multiple systems interact;
8. run the strict suite;
9. update canonical docs only if a durable contract actually changed.

Prefer connected living-world loops such as:

```text
need / habit / project
→ action
→ actor or environment interference
→ consequence
→ learning/history
→ later changed choice
```

Do not optimize for raw subsystem count.

---

# General engineering invariants

1. Keep authoritative simulation independent from rendering.
2. Prefer composition/data-driven semantics over concrete-type branching.
3. Route authoritative mutation through validated owner operations/effects.
4. Keep gameplay randomness seeded/reproducible; presentation randomness separate.
5. Do not couple game correctness to LLM availability.
6. Prefer the smallest reusable primitive proven by current cases; avoid premature universal frameworks.
7. Add deterministic/headless regressions for domain/system changes.
8. Preserve explainability/provenance for important decisions/derivations.
9. Keep code/comments/docs in English.
10. Persist durable causes; rebuild reconstructible projections/indexes/caches.
11. Keep critical mutation order explicit; no broad event-bus authority.
12. Keep evaluator contributions finite/bounded; no infinity/huge-score priority hacks.
13. Keep physical truth, Wilson belief and desirability distinct.
14. Keep player-private intent distinct from Wilson observation/attribution.
15. Prefer effective properties/capabilities from material + condition + composition + contents over combinatorial entity variants.
16. Do not model exploration as a universal percentage.
17. Keep committed process evolution distinct from unresolved future collision/consequence.
18. Stable semantic ordering precedes deterministic tie-break/seeded random selection.
19. Reconstruct caches/indexes from authority after load/bootstrap.
20. Fine spatial/nav/occlusion adapters refine semantic queries; they do not replace semantic placement/relations or become universal action-legality authority.

---

# Standard test gate

For runtime/domain changes:

```powershell
.\tests\run_headless_tests.ps1
```

The runner rejects:

```text
nonzero exit
SCRIPT ERROR
parse/compile errors
generic engine ERROR:
explicit FAIL
missing expected PASS marker
```

Do not claim a runtime slice green until the strict suite passes locally. `DISCOVERY_STATUS.md` records the current validated count.

## Robustness beyond happy paths

New scenario/scale work should use relevant combinations of:

```text
minimum/empty state
boundary numeric values
near-threshold bands
maximum admitted values
many entities / relations / beliefs / processes / projects / actors
dense and sparse layouts
conflicting simultaneous candidates/stimuli/events
multiple threats/opportunities
long-running bounded accumulation/decay
reconstruction around commit/lifecycle boundaries
invalid/adversarial fixture input
multiple deterministic seeds
stable ordering under insertion-order variation
```

Assertions should prove semantic correctness, finite bounds, deterministic replay and stable ordering. Do not use wall-clock timing as a gameplay-semantic assertion.

When adding tests:

- include pure/domain tests where useful;
- include focused integrated scenarios for cross-system work;
- include persistence/bootstrap reconstruction when durable state/causality is affected;
- test rejection/failure branches where relevant;
- never print PASS after an incomplete/erroring test body.

---

# Deferred work policy

`docs/DISCOVERY_STATUS.md` owns the current deferred list. Typical pressures include snapshot migration, positional API cleanup, hysteresis persistence, Legacy seeding, broader relationship/habit/route generalization, negative perception, view-cone refresh, effect-oriented stale intervention rejection and generalized host composition.

Do not clear these merely because they are listed. Pull one forward only when a representative gameplay or product requirement creates concrete pressure.

---

# Guards and calibration

Follow `docs/GUARDS_AND_CALIBRATION.md`.

- hard finite bounds are invariants;
- prefer saturating/diminishing updates before clamp;
- use semantic counter-pressure before hidden normalization;
- strong contradiction must remain able to revise beliefs;
- do not invisibly normalize psychology/history toward target averages;
- evaluate health across deterministic run populations;
- adaptive control is bounded/whitelisted;
- immediate threat uses a separate regime.

---

# Runtime AI

- LLM output is bounded proposal/interpretation/expression, never authoritative mutation.
- Core simulation remains complete with AI disabled/unavailable.
- Use structured output and strict validation where applicable.
- Resolve generated IDs against registries.
- Do not let an LLM invent authoritative memories, knowledge, physical properties, action validity or death outcomes.
- Bounded interpretation may reweight only admitted candidates/hypotheses.
- Provide deterministic same-function fallbacks.
- Never expose private provider keys in a public client.

---

# 3D / Blender production

Before producing an asset, start from its cross-cutting catalog row and visual/asset production bundle.

Preferred repeatable workflow:

```text
catalog requirement
→ art grammar/reference
→ inspect existing toolkit
→ deterministic bpy generator where appropriate
→ execute Blender
→ validate structure
→ render gameplay preview
→ inspect actual render
→ bounded iteration
→ export GLB
→ verify integration
→ update catalog status/notes
```

- inspect rendered results; code correctness is not visual correctness;
- evaluate at gameplay camera distance;
- use bounded autonomous aesthetic iterations;
- reuse shared primitives/materials;
- deterministic seeds for procedural variants;
- preserve semantic anchors/sockets;
- keep silhouettes readable;
- do not add unique animations when generic action + semantic anchor solves it;
- do not modify Wilson's core design incidentally;
- scripts must not rely on active selection unless they set it;
- own/clean only task-generated Blender collections/objects;
- keep units/transforms/export orientation consistent with `ASSET_SPEC.md`;
- do not leave temporary helpers/debris in runtime asset roots.

---

# Definition of done

## Code/domain change

- matches product/domain/architecture intent;
- relevant focused and strict regressions pass;
- no hidden simulation/presentation coupling;
- deterministic behavior remains reproducible;
- important decisions/derivations remain explainable;
- numeric guards are explicit;
- persistence/bootstrap implications are tested when affected;
- canonical docs are updated only when a contract actually changed.

## Representative gameplay change

- starts from a player-visible situation, not an abstraction backlog;
- composes existing owners/services before adding primitives;
- Wilson behavior is attributable to accessible evidence/history/needs/projects;
- persistent consequences affect later behavior where expected;
- cross-system causality has an integrated regression;
- no scene-specific shortcut becomes a universal production contract.

## Spatial/presentation adapter change

- preserves semantic identity/authority;
- narrow port remains headlessly usable;
- coarse semantic placement remains meaningful;
- fine spatial behavior has deterministic adapter tests where practical;
- Godot integration smoke tests validate mapping/anchors without making presentation authoritative.

## Scenario/bootstrap change

- fixture enters through common restore/bootstrap boundary where durable causes are involved;
- no direct private-store shortcut;
- invalid fixture admission fails clearly;
- rebuild semantics match real restore;
- deterministic seed is explicit;
- headless and presentation share authoritative scenario state where practical.

## Architecture/design-contract change

- authority owner explicit;
- durable vs derived state explicit;
- producer/consumer boundaries explicit;
- representative scenes still fit without bespoke hacks;
- guard/calibration implications considered;
- existing canonical owner updated;
- status/handoff updated only when sequencing changed.

## Asset/catalog change

- catalog row captures cross-cutting semantics without redefining domain;
- visual contracts satisfied;
- required states/anchors represented;
- gameplay-camera preview reviewed where applicable;
- runtime asset conventions validated;
- catalog status reflects actual completion.

---

# Architectural change protocol

Documentation describes current intended contracts, not immutable law. If representative implementation/content evidence proves a contract wrong:

1. identify the conflict and player-visible/invariant pressure;
2. explain the tradeoff;
3. update the canonical owner;
4. update affected tests/content/assets;
5. update `DISCOVERY_STATUS`/handoff only when sequencing or closed decisions changed;
6. do not quietly implement a contradictory second architecture.

## Priority

When tradeoffs conflict, optimize in this order:

1. coherent player experience;
2. simulation correctness and persistence safety;
3. behavioral legibility/historical continuity;
4. systemic reuse/combinatorial value;
5. visual coherence/readability;
6. developer/agent reproducibility;
7. raw content quantity.