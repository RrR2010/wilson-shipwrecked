# AGENTS.md

## Mission

Build Wilson Shipwrecked as a coherent systemic simulation and living 3D diorama. Optimize for reusable rules and modular assets, not maximum feature/content count.

## Required reading

Before substantial work, read the documents relevant to the task.

### Current product / behavior / architecture chain

Use this order when work affects simulation behavior, cognition, architecture, persistence, balancing or runtime AI:

1. `README.md` — project thesis and milestone;
2. `docs/DISCOVERY_STATUS.md` — current project phase, document precedence and validated conclusions;
3. `docs/BEHAVIORAL_MODEL.md` — current validated functional Wilson model;
4. `docs/STATE_REQUIREMENTS.md` — persistent/derived state requirements, scopes, lifetimes, decay, offline and resurrection semantics;
5. `docs/SCENE_VALIDATION.md` — representative-scene evidence, Must-have system matrix and regression suite;
6. `docs/ARCHITECTURE.md` — system boundaries, composition, contact points and game-loop direction;
7. `docs/SIMULATION_CONTRACTS.md` — semantic cross-system contracts and persistence/replay implications;
8. `docs/SIMULATION_ORCHESTRATION.md` — clocks, update phases, reconsideration, interruption, learning timing and offline orchestration;
9. `docs/MUTATION_AUTHORITY.md` — read/propose/mutate/observe ownership matrix;
10. `docs/DECISION_TRACES.md` — representative end-to-end architecture regressions;
11. `docs/IMPLEMENTATION_GATE.md` — implementation-readiness decision and recommended implementation sequence;
12. `docs/GUARDS_AND_CALIBRATION.md` — invariants, local/cross-system guards, health metrics and bounded self-stabilization;
13. `docs/DOMAIN_MODEL.md` — canonical language-neutral functional aggregates, state and concepts;
14. `docs/DOMAIN_VOCABULARY.md` — normalized internal semantic vocabulary;
15. `docs/DOMAIN_CATALOGS.md` — canonical relation/predicate/effect/proposition catalogues;
16. `docs/DOMAIN_OPERATIONS.md` — language-neutral command/query/derivation surface;
17. `docs/DOMAIN_PROCEDURAL_COMPOSITION.md` — materials, effective physical composition, gradual exploration, environmental responses and assembly semantics;
18. `docs/DOMAIN_HAZARD_DYNAMICS.md` — committed dynamic processes, hazard projections, perceived threats, causal windows and emergency concurrency;
19. `docs/DOMAIN_MICRO_LOOP.md` — canonical frame-group micro-loop and Scientific Method fixture;
20. `docs/DOMAIN_MICRO_LOOP_FALLING_PALM.md` — immediate-threat/hazard micro-loop fixture;
21. `docs/DOMAIN_OPERATION_REFINEMENTS.md` — refined attemptability, tactical opportunity, evidence and procedural operations;
22. `docs/DOMAIN_REGRESSION.md` — structural representative-scene regression;
23. `docs/DOMAIN_OPERATION_TRACES.md` — integration operation traces;
24. `docs/DOMAIN_VOCABULARY_REGRESSION.md` — normalized-vocabulary regression;
25. `docs/DOMAIN_SCHEMA.dbml` — relational-style visualization only, not persistence mandate;
26. `docs/AI.md` — runtime LLM authority/fallback contract;
27. `docs/PRODUCT.md` — overall experience, modes, player role, God Power, UI and rhythm;
28. `docs/SIMULATION.md` — broader systemic/property/action vocabulary.

Where an older provisional behavioral statement in `PRODUCT.md` or `SIMULATION.md` conflicts with `BEHAVIORAL_MODEL.md`, `STATE_REQUIREMENTS.md` or `SCENE_VALIDATION.md`, the newer behavioral documents win unless a later documented architectural/implementation decision explicitly supersedes them.

Where implementation-oriented wording conflicts with accepted architectural contracts, use `ARCHITECTURE.md`, `SIMULATION_CONTRACTS.md`, `SIMULATION_ORCHESTRATION.md`, `MUTATION_AUTHORITY.md`, the functional-domain documents, and validated regression traces as the current architecture source of truth unless implementation evidence deliberately supersedes them.

For functional-domain work, later normalization/refinement documents supersede older ambiguous shorthand without reopening accepted product rules. In particular, use `DOMAIN_PROCEDURAL_COMPOSITION.md`, `DOMAIN_HAZARD_DYNAMICS.md`, `DOMAIN_MICRO_LOOP*.md`, and `DOMAIN_OPERATION_REFINEMENTS.md` when they refine older `DOMAIN_MODEL.md` / `DOMAIN_OPERATIONS.md` wording.

### Visual / asset chain

Mandatory for visual/3D work:

- `docs/VISUAL_GUIDE.md` — visual direction;
- `docs/ASSET_SPEC.md` — runtime asset contracts;
- `docs/ASSET_PIPELINE.md` — Blender/tooling/export workflow;
- `docs/art/README.md` and its referenced art-direction support documents when present;
- `docs/brainstorming/functional-asset-catalog/README.md` before treating functional asset brainstorming as gameplay/domain schema.

### Handoffs

Stage-transition handoffs live under:

```text
docs/handoffs/
```

Handoffs are named for the transition/problem they transfer, not for an agent identity or generic `NEXT_AGENT` label.

When resuming work from a handoff:

1. read the handoff first;
2. follow its required-reading order;
3. treat the canonical docs it references as source of truth;
4. use the handoff for sequencing, closed decisions, anti-decisions and next deliverables;
5. update canonical docs when a contract changes instead of allowing the handoff to become a competing specification.

Handoffs are historical/operational transfer artifacts. Canonical design documents remain authoritative for the contracts they own.

A more local `AGENTS.md` may add or override instructions for its subtree. Explicit task/spec requirements override generic workflow preferences, but architectural invariants should only be changed deliberately and documented.

## Documentation ownership

Prefer one canonical document per concern instead of duplicating the same contract across files.

Current responsibility map:

```text
PRODUCT.md
  player experience / product rules / modes / presentation intent

BEHAVIORAL_MODEL.md
  Wilson functional psychology and decision requirements

STATE_REQUIREMENTS.md
  persistence / scope / lifetime / decay semantics

SCENE_VALIDATION.md
  behavioral evidence and regression tests

ARCHITECTURE.md
  technical responsibility boundaries / composition / high-level orchestration

SIMULATION_CONTRACTS.md
  semantic cross-system contract catalog

SIMULATION_ORCHESTRATION.md
  clocks / ordering / reconsideration / interruption / learning timing / offline flow

MUTATION_AUTHORITY.md
  durable state ownership and cross-system read/propose/mutate boundaries

DECISION_TRACES.md
  representative architecture regression traces

IMPLEMENTATION_GATE.md
  readiness decision and implementation sequence

GUARDS_AND_CALIBRATION.md
  bounds / feedback-loop control / health metrics / adaptive policy

DOMAIN_MODEL.md
  functional aggregates / entities / state shape / domain concepts

DOMAIN_VOCABULARY.md
  normalized internal semantic terminology

DOMAIN_CATALOGS.md
  admitted relation / predicate / effect / proposition vocabulary

DOMAIN_OPERATIONS.md
  functional command / query / derivation / lifecycle surface

DOMAIN_PROCEDURAL_COMPOSITION.md
  material / effective profile / assembly / exploration / environmental procedurality

DOMAIN_HAZARD_DYNAMICS.md
  committed dynamic processes / hazard projections / perceived threat / causal windows / emergency concurrency

DOMAIN_MICRO_LOOP.md
  semantic frame groups / tactical-vs-intentional cadence / Scientific Method fixture

DOMAIN_MICRO_LOOP_FALLING_PALM.md
  immediate-threat frame groups / route/intervention/collision fixture

DOMAIN_OPERATION_REFINEMENTS.md
  refined attemptability / tactical opportunity / evidence / assembly operation contracts

DOMAIN_REGRESSION.md / DOMAIN_OPERATION_TRACES.md / DOMAIN_VOCABULARY_REGRESSION.md
  functional-domain regression evidence

DOMAIN_SCHEMA.dbml
  visualization projection only; not a database/persistence mandate

SIMULATION.md
  broader world/property/action/event vocabulary

AI.md
  runtime LLM boundary and fallback

VISUAL_GUIDE.md / ASSET_SPEC.md / ASSET_PIPELINE.md / art/*
  visual and asset production contracts

brainstorming/functional-asset-catalog/*
  non-canonical breadth exploration; Round 10/README normalize its interpretation

DISCOVERY_STATUS.md
  phase/status/index and precedence

handoffs/*
  transition context and next-step sequencing
```

When a decision changes, update the document that owns that concern and any status/index references required for discoverability.

## General engineering rules

1. Keep authoritative simulation independent from rendering.
2. Prefer composition/data-driven capabilities over concrete-type branching.
3. Route world mutations through validated domain actions.
4. Keep randomness seeded and reproducible.
5. Do not couple game correctness to LLM availability.
6. Prefer a reusable primitive over multiple bespoke cases when the abstraction is genuine.
7. Avoid premature frameworks/generalization: implement the smallest reusable concept proven by current use cases.
8. Add tests for domain rules and regressions.
9. Preserve debuggability: autonomous decisions must be explainable through candidates, contributions, preconditions, expectations, evidence, observed events and authoritative outcomes.
10. Keep code/comments/docs in English.
11. Do not persist derived state merely because it is convenient to inspect; persist only state justified by `STATE_REQUIREMENTS.md` or a later documented contract.
12. Keep critical mutation order explicit. Do not hide authoritative cross-system mutation behind a broad event bus.
13. Evaluator/adaptive contributions must remain bounded and explainable; do not use arbitrary infinity/huge-score hacks for emergencies or priorities.
14. Keep physical possibility, Wilson knowledge, and Wilson desirability as distinct projections.
15. Prefer effective properties/capabilities derived from material + condition + composition + contents over authored combinatorial entity variants.
16. Do not model object exploration as one universal percentage; persist propositions/evidence-backed beliefs instead.
17. Keep committed dynamic-process evolution distinct from its still-unresolved future collision/consequence.
18. Wilson emergency decisions consume perceived threat, never hidden authoritative hazard projections directly.

## Architecture work

Before introducing concrete schemas/classes/package layouts, preserve the separation between:

```text
state-owning authoritative systems
derived/composable services
explicit orchestration pipelines
adapters/presentation
```

Do not create one state-owning `System` for every psychology noun or procedural mechanic.

Current architecture favors semantic contact contracts such as:

```text
ObservedEvent
PerceptualEvidence
SelectedIntention
ActionOutcome
```

and explicit perception/learning/mutation flow.

The contract/orchestration and functional-domain phases have passed representative structural/operation/micro-loop regression gates. Concrete schemas/classes/package layouts may now be designed, but they must preserve the boundaries in the canonical architecture/domain docs unless implementation evidence justifies a documented change.

Global GOAP, one universal rational utility function, ECS choice, Godot node layout and persistence technology are **not** currently mandated architectural assumptions.

When introducing a new system boundary, first ask whether the component owns independent authority/lifecycle or merely calculates a value that belongs in an existing pipeline.

## Guards and calibration work

Follow `docs/GUARDS_AND_CALIBRATION.md`.

Key rules:

- use hard finite domain bounds as invariants;
- prefer saturating/diminishing update curves before clamp;
- use semantic counter-pressure before hidden normalization;
- preserve strong contradictory evidence so beliefs remain revisable;
- do not silently normalize traits, beliefs, associations, habits, trust, dependency, memories or project history toward target averages;
- evaluate health across populations of deterministic/headless runs rather than forcing each run toward the same distribution;
- adaptive runtime control must be bounded and explicitly whitelisted;
- immediate threats use a distinct decision regime, not extreme utility constants.

## Godot work

- Treat Godot nodes as presentation/application adapters, not authoritative domain entities.
- Map stable domain entity IDs to scene instances explicitly.
- Query attemptability/affordances from the simulation; do not duplicate legality rules in UI scripts.
- Prefer semantic animation/action names over asset-specific ones.
- Do not hardcode per-object interaction offsets when an anchor/interaction region can express them.
- Keep web-export constraints in mind; measure before introducing expensive rendering features.
- Do not make rendered frame rate the authoritative simulation clock.

## Simulation work

When adding behavior, ask in this order:

1. Is this an existing action applied to a new compatible property/material/profile?
2. Is one new reusable property/capability/relation/action/evidence rule enough?
3. Can runtime composition derive the needed effective semantics?
4. Can existing belief/history/habit/project/decision composition explain it?
5. Can an event/environment/dynamic-process rule express it parametrically?
6. Does it genuinely require a bespoke event or new primitive?

A large `if entity_type == ...` chain is usually a design smell.

Before adding a new psychological state/property or procedural primitive, identify the validated scene/fixture or implementation invariant that becomes impossible without it.

## Runtime AI work

- LLM output is bounded proposal/interpretation/expression, never authority.
- The core simulation must be behaviorally complete when AI is disabled, unavailable or has no API key.
- Use structured outputs and strict validation where applicable.
- Resolve generated identifiers against registries.
- Do not let the LLM invent authoritative memories, knowledge, physical properties, action validity or death outcomes.
- Bounded interpretation may perturb weights only among already valid/plausible candidates.
- Provide deterministic same-function fallbacks.
- Never expose private provider keys in a public web client.

## 3D / Blender agent rules

Before creating or changing an asset, read the visual/asset chain above.

### Preferred method

For repeatable props/environment families:

```text
inspect existing toolkit
 -> write/reuse bpy generator
 -> execute Blender
 -> validate structure
 -> render canonical gameplay preview
 -> inspect actual render
 -> iterate
 -> export GLB
 -> verify integration
```

Prefer code-driven reproducibility to long sequences of Blender UI/MCP micro-operations.

### Visual iteration

- Inspect the rendered result; code correctness is not visual correctness.
- Evaluate at gameplay camera distance.
- Use at most a small bounded number of autonomous aesthetic iterations unless the task says otherwise.
- If the remaining choice is subjective art direction rather than a defect, surface alternatives instead of silently redefining the style.

### Asset generation

- Reuse shared primitives/materials.
- Use deterministic seeds for procedural variants.
- Preserve required anchors/sockets across variants.
- Keep geometry simple.
- Do not add texture detail to compensate for weak silhouettes.
- Do not create unique animations when a generic action + semantic anchor solves the interaction.
- Never modify Wilson's core identity/design as incidental work on another asset.

### Blender scene hygiene

- Scripts must not rely on active selection unless selection is explicitly set inside the script.
- Own and clean only generated collections/objects belonging to the task.
- Use stable names.
- Keep units/transforms/export orientation consistent with the asset spec.
- Do not leave temporary cameras/lights/helpers mixed into runtime asset roots.

## Generated assets and source control

Do not commit temporary previews, backups or experimentation debris. Commit source/generators and runtime outputs according to `ASSET_PIPELINE.md` and actual build requirements.

## Definition of done

### Code change

- behavior matches product/behavior/architecture intent;
- relevant tests pass;
- no new hidden coupling between simulation and presentation;
- deterministic behavior remains reproducible where applicable;
- autonomous decisions remain explainable in debug traces;
- guards/bounds remain explicit where numeric accumulation is introduced;
- docs updated if a contract changed.

### Architecture/design-contract change

- responsibility/authority owner is explicit;
- persistent versus derived state is explicit;
- producer/consumer boundaries are documented;
- representative scenes and micro-loop fixtures still fit without bespoke architecture hacks;
- guards/calibration implications are considered;
- canonical owning document is updated;
- `DISCOVERY_STATUS.md` or a handoff is updated when the project phase/next work changes materially.

### 3D asset change

- visual guide followed;
- asset spec validated;
- canonical preview inspected;
- semantic anchors/sockets correct;
- GLB/Godot integration verified when applicable;
- no bespoke coordinate workaround introduced.

## Architectural change protocol

Documentation describes current intended contracts, not immutable law. If implementation evidence shows a contract is wrong:

1. identify the conflict explicitly;
2. identify which validated scene/invariant is affected;
3. explain the tradeoff;
4. change the canonical relevant design document in the same change;
5. update affected tests/tools/assets;
6. update status/handoff documentation if sequencing or closed decisions changed;
7. avoid quietly implementing a contradictory second architecture.

## Priority

When tradeoffs conflict, optimize in this order:

1. coherent player experience;
2. simulation correctness and persistence safety;
3. behavioral legibility and historical continuity;
4. systemic reuse/combinatorial value;
5. visual coherence/readability;
6. developer/agent reproducibility;
7. raw content quantity.
