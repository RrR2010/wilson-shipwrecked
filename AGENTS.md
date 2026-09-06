# AGENTS.md

## Mission

Build Wilson Shipwrecked as a coherent systemic simulation and living 3D diorama. Optimize for reusable rules, explicit authority and modular content rather than maximum feature count.

## Current project phase

The **structural runtime foundation, shared restore/bootstrap composition, deterministic engine-scenario tooling, Godot spatial/navigation/perception bridge, grounded autonomous action slice and production-facing fresh-run bootstrap are implemented and locally validated**.

Current strict baseline is recorded in `docs/DISCOVERY_STATUS.md`. Do not copy test counts/schema versions into this file.

The leading runtime verticals are now:

```text
1. product-level new-run/world-generation input above NewRunBootstrapService
2. richer representative gameplay semantics driven by validated scene needs
3. persistence evolution only when product requirements create real pressure
```

A generalized production scene-binding/host composer remains deferred until a second real production-facing use proves its shape. Cross-cutting correctness items listed in `DISCOVERY_STATUS.md` should be pulled forward when a representative scenario requires them. Do not hide a real domain gap behind scenario-specific code.

Before substantial work, read:

1. [`docs/README.md`](docs/README.md) — documentation map/authority hierarchy;
2. [`docs/DISCOVERY_STATUS.md`](docs/DISCOVERY_STATUS.md) — concrete validated baseline and remaining work;
3. [`docs/handoffs/production-new-run-autonomy-baseline.md`](docs/handoffs/production-new-run-autonomy-baseline.md) for current runtime continuation work;
4. only the canonical bundle relevant to the task.

Do not reopen foundation ownership, replace established typed contracts with generic containers, or introduce a new universal framework merely because one new adapter/scenario needs implementation.

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

## Spatial / Godot presentation work

Read at minimum:

```text
docs/ARCHITECTURE.md
docs/SIMULATION_ORCHESTRATION.md
docs/SIMULATION_CONTRACTS.md
docs/MUTATION_AUTHORITY.md
docs/ASSET_SPEC.md
docs/ASSET_PIPELINE.md
```

Then inspect the relevant domain ports/tests before adding infrastructure adapters.

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
- `docs/design-reviews/` contains temporary calibration/review evidence intended to be consumed by implementation work; it is not canonical authority.
- Do not recreate permanent `*_REFINEMENTS`, `*_NOTES`, `*_V2` override chains.
- Concrete schema versions/test counts belong in `DISCOVERY_STATUS.md`.

## Design reviews

Design/calibration reviews live under `docs/design-reviews/` and should begin with an explicit `Status: OPEN` or `Status: COMPLETED` marker.

When an implementation task or PR consumes a design review:

1. read the review as advisory evidence against the current canonical contracts and representative behavior;
2. resolve every applicable checklist/recommendation through implementation, tests, canonical-document updates, or an explicit justified rejection/deferment;
3. do not silently work around a review finding or leave consumed guidance looking open;
4. before considering the consuming work complete, change the review to `Status: COMPLETED` and record the consuming PR/commit plus any rejected/deferred recommendation and rationale;
5. if only part of a review is in scope, leave it `OPEN` and check/annotate only the items actually resolved rather than falsely closing the whole review.

A completed review remains historical calibration evidence. It must not become a second canonical specification; durable decisions discovered while consuming it belong in the appropriate canonical owner document.

## Handoffs

Stage-transition handoffs live under `docs/handoffs/` and should be named for the transition/problem transferred.

A handoff should:

1. identify the exact phase/objective;
2. give a minimal required-reading path;
3. list closed decisions/invariants and explicit anti-decisions;
4. identify deliverables/acceptance gates;
5. point to canonical sources instead of duplicating them extensively;
6. record open questions separately from accepted contracts;
7. record the exact validated strict-test checkpoint.

---

# Git / PR / multi-agent workflow

`main` is the only integrated project state.

Agents must not commit directly to `main` during normal development. Every independent task uses a short-lived task branch and integrates through a pull request.

Canonical flow:

```text
latest origin/main
→ short-lived task branch
→ coherent commits
→ required validation
→ PR targeting main
→ synchronize with main if materially required
→ validation
→ squash merge
→ delete task branch
```

## Branch isolation

Every normal task branch MUST start from `origin/main`.

Every normal PR MUST target `main`.

Do not base one agent's task branch on another active task branch and do not use an active feature branch as the base of another PR. Stacked branches/PRs require an explicit exceptional reason.

If task B depends on unmerged task A:

```text
finish and merge A
→ refresh origin/main
→ create/update B from the new main
```

Do not create an implicit dependency chain between agent branches.

## Multi-agent worktrees

Concurrent agents should use separate Git worktrees and separate branches.

Example:

```text
runtime worktree → runtime/<goal>
asset worktree   → assets/<goal>
```

An agent owns its task branch. Do not push commits to another active agent's branch.

Avoid concurrent edits to coordination hotspots such as:

```text
AGENTS.md
project.godot
docs/README.md
shared catalog/index files
shared pipeline configuration
```

When two tasks require a conflicting shared-file change, integrate the smaller/shared change first, then synchronize the other task from `main`.

## Synchronizing long-lived task work

Do not continuously merge `main` merely because another PR landed.

Synchronize when:

- the new `main` changes files/contracts used by the task;
- conflicts are likely;
- or immediately before integration when the branch materially depends on newer main state.

For branches actively consumed by another worktree/person for testing, prefer:

```bash
git fetch origin
git merge origin/main
```

Avoid history-rewriting rebase/force-push unless explicitly coordinated. Final history is normalized by squash merge.

After a meaningful synchronization, rerun the affected validation gate.

## Pull requests

Open a PR when the branch represents a coherent reviewable/integratable slice, not for every intermediate commit.

PRs should record:

- behavioral/asset scope;
- relevant architectural or catalog implications;
- validation performed;
- known deferred work.

Runtime/domain PRs must satisfy the strict test gate defined below before merge. Asset PRs must satisfy the applicable asset-pipeline validation and visual inspection.

Use squash merge for normal task PRs.

A PR is not integrated until it is merged into `main`. Passing tests on a feature branch is necessary but not sufficient.

## Merge authorization

Do not merge a PR on behalf of the operator without explicit authorization for that specific merge. Earlier approvals do not carry forward to future PRs.

## Branch lifecycle and cleanup

Task branches are disposable integration vehicles, not historical archives.

After a successful squash merge:

1. delete the remote task branch immediately, or rely on repository automatic head-branch deletion when enabled;
2. `git fetch --prune` in active worktrees;
3. delete obsolete local branches/worktrees when safe;
4. start the next task from the updated `origin/main`.

Do not keep merged task branches for history. Git commits and merged PRs are the historical record.

At steady state, remote branches should normally consist only of:

```text
main
currently active task branches
```

## Direct commits to main

Direct commits to `main` are exceptional.

Normal code, asset, documentation, refactor and configuration work goes through a task branch + PR even when small. This keeps concurrent-agent work isolated and gives every integrated change an explicit validation boundary.

---

# Global authority invariants

These contracts are already regression-backed. Preserve them unless representative evidence proves a canonical change is required.

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

A projection/service/index/adapter does not become an owner because it is convenient to mutate it.

Keep separate:

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

## Owner/query/service/command split

```text
owner stores     = authoritative state
query ports      = narrow semantic reads
derived services = deterministic proposals/projections
commands         = validated owner-local mutation
```

No presentation, debug, fixture or scenario path may bypass this split.

## Typed semantic identity

- Use `DomainId`/typed semantic IDs rather than display strings/scene paths as identity.
- Durable belief identity uses typed `EpistemicClaim`, currently `PROPERTY | RELATION | EVENT`.
- Do not restore generic `predicate + arbitrary Variant arguments` as durable epistemic identity.
- Numeric semantic identity must survive JSON representation changes such as `3` ↔ `3.0`.
- Property/qualifier semantic values are bounded; NaN/infinity are invalid.

## Event naming

- `EventDefinition` = semantic/perceptual definition of an ordinary `WorldEvent` kind.
- `WorldEvent` = authoritative occurrence fact.
- `ObservedEvent` = Wilson-accessible projection.
- Director-owned lifecycle uses directed-opportunity definitions/state.

Do not overload ordinary event semantics for Director state.

## World relations / composition

`WorldRelation` exact identity includes:

```text
RelationTypeId + subject + object + optional qualifier
```

Qualifier is a bounded semantic scalar/symbol/typed ID, never an arbitrary Dictionary/Array.

Assembly bindings use ordinary World relations. There is no `AssemblyStore`.

`EffectivePhysicalProfile`, `AssemblyValidity`, `CompositionDependencyProjection`, protection/exposure and hazard projections are reconstructible derived semantics, not authority.

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
- crossing commit emits one `ActionOutcome` exactly once.
- committed physical truth cannot be rewound by reconsideration, suggestion, Luck, load or debug tools.
- `SemanticChangeSet` is an invalidation contract, not a generic event bus.
- cross-owner consequences such as drive changes occur only after accepted grounded commits and through explicit application services.

## Perception / learning

- Event perceptibility + runtime spatial access determine accessible roles/modalities.
- cognition receives only accessible observation/evidence semantics.
- `EpistemicGraphProjection` indexes only cognition-owned beliefs; never import hidden World truth.
- same-chain learning happens before the next tactical choice when it can affect that choice.
- Presence/association/habit/episode updates remain Wilson-relative; player-private intent is never evidence by itself.

## Immediate threat

Immediate threat wins through a separate routing regime, never giant/infinite utility scores. Wilson consumes `PerceivedThreat`, not hidden `HazardProjection` directly.

## Run/Profile

`RunLifecycleState` does not replace WilsonBody truth. Resurrection first passes the physical World/body boundary.

`PlayerProfile` is outside active Run state. Legacy/profile admission is explicit and must not copy Wilson autobiography wholesale.

---

# Common restore/bootstrap invariant

Every meaningful gameplay subsystem must be testable from an artificial but valid authoritative state without replaying all prior gameplay.

Canonical architecture:

```text
production new run --------┐
real save -----------------┼→ common owner/bootstrap + runtime-composition boundaries
valid deterministic fixture┘
                                  ↓
                         authoritative owner state
```

This is a global project invariant.

`NewRunDefinition` and deterministic scenario definitions are bootstrap inputs, not authoritative runtime owners. Fresh runs, restore and deterministic fixtures converge on the same `SimulationOwnerBootstrapper` / `RunRuntimeComposer` boundaries where applicable.

A fixture/debug scenario may declare durable owner causes and deterministic seed state, but must pass the same validation/construction/reconstruction semantics as normal restore/bootstrap.

Do not:

```text
mutate private stores after bootstrap to manufacture a scenario
persist derived projections/caches as fixture truth
skip action/process causal validation because the fixture is test-only
use Godot transforms as authoritative scenario state
build a debug console with arbitrary direct-store mutation
create a second debug-only simulation architecture
```

A development scenario launcher and future debug console are adapters over the common bootstrap boundary and normal commands.

Prefer declarative named scenarios such as:

```text
hungry_wilson_near_food
wilson_mid_shelter_project
storm_with_bad_roof
```

Scenario names are development identifiers, not domain identity.

---

# General engineering invariants

1. Keep authoritative simulation independent from rendering.
2. Prefer composition/data-driven semantics over concrete-type branching.
3. Route authoritative mutation through validated owner operations/effects.
4. Keep gameplay randomness seeded/reproducible; presentation randomness separate.
5. Do not couple game correctness to LLM availability.
6. Prefer the smallest reusable primitive proven by current cases; avoid premature universal frameworks.
7. Add deterministic/headless regressions for domain/system changes.
8. Preserve explainability: decisions/derivations expose useful provenance/diagnostics.
9. Keep code/comments/docs in English.
10. Persist only durable causes; rebuild reconstructible projections/indexes/caches.
11. Keep critical mutation order explicit; no broad event-bus authority.
12. Keep evaluator contributions finite/bounded; no infinity/huge-score priority hacks.
13. Keep physical truth, Wilson knowledge/belief and desirability distinct.
14. Keep player-private intent distinct from Wilson observation/attribution.
15. Prefer effective properties/capabilities from material + condition + composition + contents over combinatorial entity variants.
16. Do not model exploration as a universal percentage.
17. Keep committed dynamic-process evolution distinct from unresolved future collision/consequence.
18. Stable semantic ordering precedes deterministic tie-break/seeded random selection.
19. Reconstruct indexes/caches from authority after load/bootstrap; never let a cache become truth.
20. Fine spatial/nav/occlusion adapters refine semantic queries; they do not replace `PlaceId`/relations or become action-legality authority.

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

Do not claim a runtime slice green until the strict suite passes locally. `DISCOVERY_STATUS.md` records the latest validated count.

## Required robustness beyond happy paths

New scenario/scale work must deliberately exercise **variability, extremes and data volume**, not only one handcrafted success case.

Use relevant combinations of:

```text
minimum/empty state
boundary numeric values
near-threshold hysteresis/bands
maximum admitted values
many entities / relations / beliefs / processes / projects / actors
dense and sparse spatial layouts
conflicting simultaneous candidates/stimuli/events
multiple threats/opportunities at once
long-running bounded accumulation/decay
reconstruction before/at/after commit or lifecycle boundaries
invalid/adversarial fixture input
multiple deterministic seeds / fixed seed populations
stable ordering under insertion-order variation
```

Assertions should prove semantic correctness, finite bounds, deterministic replay, stable ordering and bounded traversal/query behavior. Do not use wall-clock timing as a gameplay-semantic assertion; performance/load profiling is separate.

When adding tests:

- include pure/domain tests where useful;
- include at least one focused integrated scenario for cross-system work;
- include persistence/bootstrap reconstruction when durable state/causality is affected;
- test failure/rejection branches, not only success;
- never print PASS after an incomplete/erroring test body.

---

# Current implementation focus

## 1. Product-level new-run/world-generation input

`NewRunDefinition → NewRunBootstrapService` is already the validated production-facing fresh-run boundary. The next upstream problem is deriving those durable causes from actual product/run parameters without moving authority into presentation or scene construction.

Target shape:

```text
product run parameters + authored content + gameplay seed
→ deterministic world/run cause generation
→ NewRunDefinition
→ NewRunBootstrapService
→ authoritative owners/runtime
```

Rules:

- generation inputs/recipes are not new runtime owners;
- Godot nodes/transforms do not become bootstrap truth;
- generated causes must still satisfy ordinary bootstrap/content validation;
- deterministic generation uses explicit reproducible seed state;
- do not bypass `SimulationOwnerBootstrapper` or `RunRuntimeComposer`.

## 2. Richer representative gameplay semantics

Use `docs/SCENE_VALIDATION.md`, `docs/brainstorming/representative-scene-catalog.md` and functional domain contracts as evidence for the next missing primitive.

Current validated autonomous slice already reaches:

```text
passive perception
→ durable learning
→ drive-triggered intention
→ Godot motion
→ authored ActionExecution
→ World-accepted outcome/event
→ grounded hunger reduction
```

Prefer the next scenario that exposes a real missing semantic capability, such as richer Gerald behavior/relationships, physical accident authoring where representative behavior needs it, or Wilson-relative learned route/escape reasoning. Do not add scene-specific APIs just to make one scripted outcome pass.

## 3. Persistence evolution only under pressure

Current-run restore/rebootstrap and action-execution reconstruction are already validated. Further persistence work should be requirement-driven.

Candidates include:

```text
snapshot v9 → v10 compatibility policy
drive hysteresis-band memory persistence
grouped capture/bootstrap request objects if schemas expand again
```

Do not refactor long positional persistence/bootstrap APIs merely for cosmetic cleanup.

---

# Known cross-cutting work

`docs/DISCOVERY_STATUS.md` owns the current list. Pull items forward when required by representative behavior, including areas such as:

```text
snapshot compatibility policy
drive hysteresis-memory persistence
Legacy-to-new-Wilson seeding policy
product-level NewRunDefinition/world-generation input
collision/grounding/fall policies beyond current impact behavior
Wilson-relative route/escape evaluation
intervention causal windows
automatic habit-disuse/context production
Presence attribution production
orientation/view-cone passive refresh
negative/absence passive evidence
richer Gerald behavior/relationship semantics
```

Do not silently mark these solved because an adapter/scenario can work around them.

---

# Guards and calibration

Follow `docs/GUARDS_AND_CALIBRATION.md`.

- hard finite bounds are invariants;
- prefer saturating/diminishing updates before clamp;
- use semantic counter-pressure before hidden normalization;
- strong contradiction must remain able to revise beliefs;
- do not normalize psychology/history toward target averages invisibly;
- evaluate health across deterministic run populations instead of forcing each run to one distribution;
- adaptive control is bounded/whitelisted;
- immediate threat uses a separate regime.

---

# Runtime AI

- LLM output is bounded proposal/interpretation/expression, never authoritative mutation.
- Core simulation remains behaviorally complete with AI disabled/unavailable.
- Use structured outputs/strict validation where applicable.
- Resolve generated IDs against registries.
- Do not let an LLM invent authoritative memories, knowledge, physical properties, action validity or death outcomes.
- Bounded interpretation may reweight only already admitted candidates/hypotheses.
- Provide deterministic same-function fallbacks.
- Never expose private provider keys in a public web client.

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
- preserve required semantic anchors/sockets;
- keep geometry simple/silhouettes readable;
- do not add unique animations when generic action + semantic anchor solves it;
- do not modify Wilson's core design incidentally;
- scripts must not rely on active selection unless they set it;
- own/clean only task-generated Blender collections/objects;
- keep units/transforms/export orientation consistent with `ASSET_SPEC.md`;
- do not leave temporary helpers in runtime asset roots;
- do not commit preview/backup/experimentation debris.

---

# Definition of done

## Code/domain change

- matches product/domain/architecture intent;
- relevant strict regressions pass;
- no hidden simulation/presentation coupling;
- deterministic behavior remains reproducible;
- important autonomous decisions/derivations remain explainable;
- numeric guards are explicit;
- persistence/bootstrap implications are tested when affected;
- canonical docs are updated only if a contract actually changed.

## Spatial/presentation adapter change

- preserves domain identity/authority;
- narrow port contract remains usable headlessly;
- coarse semantic placement remains meaningful;
- fine distance/nav/occlusion behavior has deterministic adapter tests where practical;
- Godot integration smoke tests validate mapping/anchors without making presentation authoritative;
- representative dense/sparse/occluded/blocked cases are covered.

## Scenario/bootstrap change

- fixture enters through common restore/bootstrap boundary;
- no direct private-store mutation shortcut;
- invalid fixture admission fails clearly;
- rebuild semantics match real restore;
- deterministic seed is explicit;
- headless and presentation use the same authoritative scenario state where practical;
- edge, extreme, volume and multi-seed validation is included.

## Architecture/design-contract change

- authority owner explicit;
- durable vs derived state explicit;
- producer/consumer boundaries explicit;
- representative fixtures still fit without bespoke hacks;
- guard/calibration implications considered;
- existing canonical owner updated;
- status/handoff updated only when phase/sequencing changed.

## Asset/catalog change

- catalog row captures cross-cutting semantics without redefining domain;
- applicable visual contracts satisfied;
- required states/contrasts/anchors represented;
- gameplay-camera preview reviewed where applicable;
- runtime asset conventions validated;
- catalog status reflects actual completion.

---

# Architectural change protocol

Documentation describes current intended contracts, not immutable law. If implementation/content evidence proves a contract wrong:

1. identify the conflict and representative behavior/invariant;
2. explain the tradeoff;
3. update the canonical owner document;
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