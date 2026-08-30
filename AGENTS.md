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
7. `docs/GUARDS_AND_CALIBRATION.md` — invariants, local/cross-system guards, health metrics and bounded self-stabilization;
8. `docs/AI.md` — runtime LLM authority/fallback contract;
9. `docs/PRODUCT.md` — overall experience, modes, player role, God Power, UI and rhythm;
10. `docs/SIMULATION.md` — broader systemic/property/action vocabulary.

Where an older provisional behavioral statement in `PRODUCT.md` or `SIMULATION.md` conflicts with `BEHAVIORAL_MODEL.md`, `STATE_REQUIREMENTS.md` or `SCENE_VALIDATION.md`, the newer behavioral documents win unless a later documented architectural/implementation decision explicitly supersedes them.

### Visual / asset chain

Mandatory for visual/3D work:

- `docs/VISUAL_GUIDE.md` — visual direction;
- `docs/ASSET_SPEC.md` — runtime asset contracts;
- `docs/ASSET_PIPELINE.md` — Blender/tooling/export workflow.

### Handoffs

Stage-transition handoffs live under:

```text
docs/handoffs/
```

Handoffs are named for the transition/problem they transfer, not for an agent identity or generic `NEXT_AGENT` label.

Example:

```text
docs/handoffs/behavioral-architecture-contracts.md
```

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
  technical responsibility boundaries / composition / orchestration

GUARDS_AND_CALIBRATION.md
  bounds / feedback-loop control / health metrics / adaptive policy

SIMULATION.md
  world/property/action/event vocabulary

AI.md
  runtime LLM boundary and fallback

VISUAL_GUIDE.md / ASSET_SPEC.md / ASSET_PIPELINE.md
  visual and asset production contracts

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
9. Preserve debuggability: autonomous decisions must be explainable through candidates, contributions, preconditions, expectations, observed events and authoritative outcomes.
10. Keep code/comments/docs in English.
11. Do not persist derived state merely because it is convenient to inspect; persist only state justified by `STATE_REQUIREMENTS.md` or a later documented contract.
12. Keep critical mutation order explicit. Do not hide authoritative cross-system mutation behind a broad event bus.
13. Evaluator/adaptive contributions must remain bounded and explainable; do not use arbitrary infinity/huge-score hacks for emergencies or priorities.

## Architecture work

Before introducing concrete schemas/classes/package layouts, preserve the separation between:

```text
state-owning authoritative systems
derived/composable services
explicit orchestration pipelines
adapters/presentation
```

Do not create one state-owning `System` for every psychology noun.

Current architecture favors semantic contact contracts such as:

```text
ObservedEvent
SelectedIntention
ActionOutcome
```

and an explicit learning/mutation flow.

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
- Query affordances from the simulation; do not duplicate legality rules in UI scripts.
- Prefer semantic animation/action names over asset-specific ones.
- Do not hardcode per-object interaction offsets when an anchor can express them.
- Keep web-export constraints in mind; measure before introducing expensive rendering features.
- Do not make rendered frame rate the authoritative simulation clock.

## Simulation work

When adding behavior, ask in this order:

1. Is this an existing action applied to a new compatible property?
2. Is one new reusable property/action enough?
3. Can existing belief/history/habit/project/decision composition explain it?
4. Can an event template express it parametrically?
5. Does it genuinely require a bespoke event or new primitive?

A large `if entity_type == ...` chain is usually a design smell.

Before adding a new psychological state/property, identify the validated scene or implementation requirement that becomes impossible without it.

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

Before creating or changing an asset, read `docs/VISUAL_GUIDE.md`, `docs/ASSET_SPEC.md` and `docs/ASSET_PIPELINE.md`.

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
- representative scenes still fit without bespoke architecture hacks;
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
