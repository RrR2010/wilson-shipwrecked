# AGENTS.md

## Mission

Build Wilson Shipwrecked as a coherent systemic simulation and living 3D diorama. Optimize for reusable rules, explicit authority, explainable behavior and modular content rather than maximum feature count.

## Current project phase

The structural runtime foundation and the first continuously observable Godot living simulation are implemented and locally validated.

The current integrated baseline includes:

```text
common bootstrap / restore composition
production new-run generation
deterministic engine-scenario tooling
Godot spatial / navigation / perception / physics adapters
grounded autonomous action execution
needs / drives
projects with persistent progress
habits / episodes / beliefs
weather / environment / protection / degradation foundations
shallow non-Wilson actors and relationships
interruption / resumption
player intervention / Presence attribution foundations
primitive-shape living-island presentation
operator observability and 1x / 4x / 16x time controls
```

The leading phase is now:

```text
validated living simulation
→ richer self-generated situations
→ boredom / idle pressure instead of dead time
→ meaningful actor/environment interference
→ visible learning/history consequences
→ calibrate for readability, surprise and comedy
```

The next agent should start from the active handoff:

```text
docs/handoffs/observable-living-simulation-to-entertaining-systemic-diorama.md
```

Current strict baseline, commit checkpoint and known limitations live only in `docs/DISCOVERY_STATUS.md`.

Do not reopen foundation ownership or introduce a universal framework merely because one new situation needs support. Compose existing owners/services first and add the smallest reusable primitive only when representative pressure proves a semantic gap.

---

# Documentation workflow

Read the smallest canonical bundle sufficient for the task.

Start with:

```text
docs/README.md
docs/DISCOVERY_STATUS.md
active handoff
```

For simulation/domain/architecture work, use:

```text
docs/ARCHITECTURE.md
docs/SIMULATION_CONTRACTS.md
docs/SIMULATION_ORCHESTRATION.md
docs/MUTATION_AUTHORITY.md
docs/DOMAIN_MODEL.md
docs/DOMAIN_VOCABULARY.md
docs/DOMAIN_CATALOGS.md
docs/DOMAIN_OPERATIONS.md
docs/DOMAIN_PROCEDURAL_COMPOSITION.md
```

Specialized appendices only when relevant:

```text
docs/DOMAIN_ENVIRONMENTAL_PROTECTION.md
docs/DOMAIN_HAZARD_DYNAMICS.md
docs/DOMAIN_EPISTEMIC_INVESTIGATION.md
docs/DOMAIN_MICRO_LOOP.md
```

For player-visible behavior selection, also read:

```text
docs/PRODUCT.md
docs/BEHAVIORAL_MODEL.md
docs/SCENE_VALIDATION.md
docs/brainstorming/representative-scene-catalog.md
```

For Godot presentation/spatial work, read at minimum:

```text
docs/ARCHITECTURE.md
docs/SIMULATION_ORCHESTRATION.md
docs/SIMULATION_CONTRACTS.md
docs/MUTATION_AUTHORITY.md
docs/testing/SCENE_TESTS.md
```

For non-trivial Godot API/lifecycle behavior, verify the current engine semantics instead of guessing. Inspect existing adapters/tests first and use a small executable probe when timing/order remains ambiguous.

Asset/art/modeling work is a parallel concern. Runtime agents should not change art/asset documentation unless the operator explicitly asks.

## Documentation rules

- Prefer one canonical owner per concern; `docs/README.md` defines the map.
- Update an existing canonical owner instead of creating permanent override chains.
- Fixtures/regressions are evidence, not competing specifications.
- `docs/brainstorming/` is exploratory/historical evidence.
- `docs/handoffs/` is stage-transition context, not durable design authority.
- `docs/design-reviews/` is temporary calibration/review evidence.
- Concrete schema versions/test counts belong in `docs/DISCOVERY_STATUS.md`.
- Create a handoff only when work is actually transferred to another agent/stage.

A handoff should identify the exact objective, minimal reading path, closed decisions, anti-decisions, acceptance gates, open questions and the exact validated checkpoint.

---

# Git / PR workflow

`main` is the only integrated project state.

Normal flow:

```text
latest origin/main
→ short-lived task branch
→ coherent commits
→ focused validation
→ strict validation
→ PR targeting main
→ explicit operator merge authorization
→ squash merge
```

Do not base a new task on another unmerged task unless explicitly coordinated. Concurrent agents should use separate branches/worktrees and avoid editing another active agent's branch.

Do not merge a PR on behalf of the operator without explicit authorization for that specific merge.

Runtime/domain changes require the strict local gate:

```powershell
.\tests\run_headless_tests.ps1
```

Any `SCRIPT ERROR`, generic engine `ERROR`, explicit `FAIL`, non-zero process, or missing expected PASS marker is a failure.

---

# Global authority invariants

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

Canonical ownership shape:

```text
World                     physical/environment/entity/relation/body truth
Wilson Cognition          drives/beliefs/associations/habits/episodes/intention
Projects                  project lifecycle/progress
ActionExecution           execution lifecycle/commit state
Director                  directed-opportunity lifecycle
PlayerRunState            run-local player powers/suggestions/progress
RunLifecycleState         run lifecycle metadata
PlayerProfile             cross-run state
```

Owner/query/service/command split:

```text
owner stores     = authoritative state
query ports      = narrow semantic reads
derived services = deterministic proposals/projections
commands         = validated owner-local mutation
```

Presentation, debug UI, fixtures and adapters do not become authority because mutation would be convenient.

Use `DomainId` / `RuntimeWorldRef` / typed semantic identity rather than node names, scene paths, colors or transforms.

---

# Causal invariants

Authoritative action causality remains:

```text
ActionExecution
→ ActionOutcome
→ validated World commit
→ WorldEvent + SemanticChangeSet
→ derived invalidation
→ grounded cross-owner consequences
→ Perception
→ learning/history
→ reconsideration / decision
→ CurrentIntention
→ execution progression
```

Important rules:

- committed physical truth cannot be rewound;
- action execution does not mutate World directly;
- cross-owner consequences follow accepted grounded World outcomes;
- hidden World changes do not directly synchronize Wilson beliefs;
- cognition receives only accessible observation/evidence semantics;
- current perceived context is not durable `HabitStore` state;
- immediate threat uses a separate routing regime, never giant/infinite utility;
- tactical responses may refine an active intention **or begin a context-local response from idle**; tactical scope is not conditional on a pre-existing intention;
- equivalent semantic continuation should not duplicate active action executions;
- a completed action may be followed by another execution under the same persistent intention;
- shallow actor physical transit and semantic placement remain separate;
- primitive nodes, bubbles and debug overlays are projections only.

---

# Bootstrap / restore invariant

Every meaningful gameplay subsystem should be testable from artificial but valid authoritative state without replaying all prior gameplay.

```text
production new run --------┐
real save -----------------┼→ common owner/bootstrap + runtime composition
valid deterministic fixture┘
```

Fresh runs, restore and deterministic fixtures converge on common owner construction/runtime composition where applicable.

Do not manufacture scenarios through private-store mutation, persist reconstructible caches as truth, use Godot transforms as semantic state, or create a second debug-only simulation architecture.

---

# Representative-pressure workflow

The current phase is explicitly scene-led.

For each candidate improvement:

1. identify a player-visible situation that is currently flat, confusing or missing;
2. compose current owners/services first;
3. identify the exact missing semantic gap;
4. decide whether it is durable owner state or derived state;
5. implement the smallest reusable primitive;
6. add focused regression;
7. add/update an integrated scenario when multiple systems interact;
8. run the strict suite;
9. update canonical docs only when a durable contract changed.

Prefer connected loops such as:

```text
need / boredom / habit / project
→ action
→ actor or environment interference
→ consequence
→ learning/history
→ later changed choice
```

The goal is not maximum subsystem count. The goal is understandable, surprising situations that still follow causal state.

---

# Current product-development emphasis

The validated `tools/living_simulation/living_simulation.tscn` is now a calibration playground, not proof-of-concept infrastructure to discard.

Use it to evaluate:

```text
dead time versus meaningful idle
repetition versus varied optional activity
whether weather/context still matters after projects finish
whether Gerald changes Wilson-visible situations rather than merely wandering
whether learning/history changes later behavior
whether unusual choices read as character/comedy rather than simulation failure
whether the operator can understand causality without a giant debug wall
```

Known promising next pressure: stimulation/boredom should rise faster during genuine inactivity, with bounded acceleration and reset/reduction when meaningful activity begins. Do not add randomness merely to avoid idle.

Gerald should only gain more behavioral influence when a representative scene requires it. Do not turn him into a second full Wilson by default.

---

# Engineering invariants

1. Keep authoritative simulation independent from rendering.
2. Prefer composition/data-driven semantics over concrete-type branching.
3. Route mutation through validated owner operations/effects.
4. Keep gameplay randomness seeded/reproducible.
5. Do not couple correctness to LLM availability.
6. Prefer the smallest reusable primitive proven by current cases.
7. Add deterministic/headless regressions for domain/system changes.
8. Preserve explainability/provenance for important decisions.
9. Keep code/comments/docs in English.
10. Persist durable causes; rebuild projections/indexes/caches.
11. Keep critical mutation order explicit; avoid broad event-bus authority.
12. Keep evaluator contributions finite/bounded.
13. Keep physical truth, Wilson belief and desirability distinct.
14. Keep player-private intent distinct from Wilson observation/attribution.
15. Do not model exploration as a universal percentage.
16. Stable semantic ordering precedes deterministic tie-break/random selection.
17. Fine spatial/navigation state belongs behind adapters, not in domain identity.
18. Calibration should solve behavioral pressure with authored/bounded rates and semantics, not by weakening invariants to make tests pass.
