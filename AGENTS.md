# AGENTS.md

## Mission

Build Wilson Shipwrecked as a coherent systemic simulation and living 3D diorama. Optimize for reusable rules and modular content, not maximum feature count.

## Documentation entry point

Before substantial work, read [`docs/README.md`](docs/README.md). It owns the current documentation map, authority hierarchy and task-specific reading bundles.

Do **not** read every document linearly by default. Read the smallest canonical bundle required for the task, then use fixtures/regressions as evidence when needed.

Also check [`docs/DISCOVERY_STATUS.md`](docs/DISCOVERY_STATUS.md) when the current project phase or next sequencing matters.

### Common task bundles

**Simulation/domain/architecture work**

Start from the relevant bundle in `docs/README.md`. At minimum, preserve the boundaries in:

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

Read specialized domain appendices only when the task touches them. Read regression/fixture documents to validate behavior, not as competing specifications.

**Asset/content catalog work**

Start from:

```text
docs/asset-catalog/README.md
→ relevant catalog tables
→ PRODUCT.md / domain core as needed
→ art contracts if visual requirements are affected
```

`docs/asset-catalog/` is the cross-cutting source of truth for modeled-content requirements and production backlog. `docs/art/` must not maintain a second object list.

**Visual / 3D production**

Read:

```text
docs/asset-catalog/<relevant row>
→ docs/VISUAL_GUIDE.md
→ docs/art/README.md and relevant art references
→ docs/ASSET_SPEC.md
→ docs/ASSET_PIPELINE.md
→ docs/art/AGENT_ART_PRODUCTION.md
```

The brainstorming asset rounds are historical breadth evidence, not the normal production prompt.

## Documentation rules

- Prefer one canonical owner per concern; `docs/README.md` defines the current ownership map.
- Do not create a new top-level canonical document for every fixture, edge case or content family.
- Promote validated changes into the existing owner document when the concern already has one.
- Validation traces/fixtures prove sufficiency; they do not create scene-specific APIs.
- `docs/brainstorming/` is exploratory/historical evidence.
- `docs/handoffs/` is stage-transition context, not durable design authority.
- If a refinement permanently supersedes an older contract, consolidate it into the owning contract when practical rather than growing an indefinite precedence chain.

### Handoffs

Stage-transition handoffs live under `docs/handoffs/` and should be named for the transition/problem they transfer.

A handoff should:

1. identify the exact current phase and objective;
2. give a minimal required-reading path;
3. list closed decisions/invariants and explicit anti-decisions;
4. identify deliverables and acceptance gates;
5. point to canonical sources rather than duplicating them extensively;
6. record open questions separately from accepted contracts.

---

# General engineering invariants

1. Keep authoritative simulation independent from rendering.
2. Prefer composition/data-driven semantics over concrete-type branching.
3. Route authoritative world mutations through validated domain operations/effects.
4. Keep gameplay randomness seeded and reproducible; presentation randomness is separate.
5. Do not couple game correctness to LLM availability.
6. Prefer the smallest reusable primitive proven by current cases; avoid premature universal frameworks.
7. Add deterministic/headless tests for domain rules and regressions where practical.
8. Preserve debuggability: autonomous decisions must be explainable through candidates, contributions, preconditions, expectations, evidence, observed events and authoritative outcomes.
9. Keep code/comments/docs in English.
10. Persist only state justified by the state/domain contracts; do not persist derived projections merely for convenience.
11. Keep critical mutation order explicit. Do not hide authoritative cross-owner mutation behind a broad event bus.
12. Keep evaluator contributions bounded and explainable; never use infinity/huge-score priority hacks.
13. Keep physical truth, Wilson knowledge/belief and Wilson desirability distinct.
14. Keep player-private intent distinct from Wilson observation and causal attribution.
15. Prefer effective properties/capabilities derived from material + condition + composition + contents over combinatorial entity variants.
16. Do not model exploration as a universal percentage; persist evidence-backed propositions/beliefs instead.
17. Keep committed dynamic-process evolution distinct from unresolved future collision/consequence.
18. Wilson emergency decisions consume perceived threat, never hidden authoritative hazard projections.

---

# Architecture and domain work

Preserve the separation between:

```text
state-owning authoritative systems
derived/composable services
explicit orchestration/application pipelines
presentation/adapters
```

Do not create one state-owning `System` for every psychology noun, content family or procedural mechanic.

Current state-owning families are conceptually:

```text
World Simulation
Wilson Cognition
Projects
Player Run State / Intervention
Director
Action Execution / Resolution
Player Profile across runs
```

Important semantic contact contracts include:

```text
ObservedEvent
PerceptualEvidence
SelectedIntention
ActionOutcome
```

The functional domain has passed structural, operation, procedural, hazard, epistemic and composition fixtures. New primitives must therefore be justified by a concrete invariant or representative behavior that existing composition cannot express.

Global GOAP, one universal rational utility function, ECS, Godot node layout and persistence technology are not mandated architecture choices.

When introducing a new boundary, first ask whether the component owns independent authority/lifecycle or merely derives a projection that belongs in an existing pipeline.

## Simulation/domain decision order

When adding behavior, ask:

1. Is this an existing action applied to a new compatible property/material/profile?
2. Is one reusable property/capability/relation/action/evidence rule sufficient?
3. Can runtime composition derive the semantics?
4. Can existing belief/history/habit/project/decision composition explain the behavior?
5. Can an environmental/dynamic-process rule express it parametrically?
6. Does it genuinely require a new primitive?

A large `if entity_type == ...` interaction chain is normally a design smell.

## Catalog versus domain

The asset catalog may state that a content family requires specific properties, capabilities, interaction roles, composition slots, states, contrasts or production assets.

It must not silently introduce:

```text
new psychological primitives
new authoritative property families
new action semantics
object-pair recipes
hidden exploration flags
scene-specific state machines
```

If catalog analysis exposes a real domain gap, surface it explicitly and update the canonical domain contract as a separate reviewed decision.

---

# Guards and calibration

Follow `docs/GUARDS_AND_CALIBRATION.md` when numeric accumulation or adaptive control is involved.

Key rules:

- hard finite bounds are invariants;
- prefer saturating/diminishing updates before clamp;
- use semantic counter-pressure before hidden normalization;
- strong contradictory evidence must remain able to revise beliefs;
- do not silently normalize traits, beliefs, associations, habits, trust, dependency, memories or project history toward target averages;
- evaluate simulation health across deterministic/headless run populations instead of forcing every run toward one distribution;
- adaptive control is bounded and explicitly whitelisted;
- immediate threats use a distinct regime, not extreme utility constants.

---

# Godot / implementation work

- Treat Godot nodes as presentation/application adapters, not authoritative domain entities.
- Map stable domain entity IDs to scene instances explicitly.
- Query attemptability/affordances from simulation; do not duplicate legality rules in UI scripts.
- Prefer semantic animation/action names over asset-specific names.
- Use semantic interaction regions/anchors rather than per-object hardcoded offsets.
- Do not make rendered frame rate authoritative simulation time.
- Keep the web-export target in mind and measure performance before adding expensive rendering/runtime techniques.

Concrete package/module layout should preserve language-neutral dependency directions before convenience-specific GDScript coupling is introduced.

---

# Runtime AI

- LLM output is bounded proposal/interpretation/expression, never authoritative mutation.
- The core simulation must be behaviorally complete with AI disabled/unavailable/no API key.
- Use structured outputs and strict validation where applicable.
- Resolve generated identifiers against registries.
- Do not let an LLM invent authoritative memories, knowledge, physical properties, action validity or death outcomes.
- Bounded interpretation may perturb weights only among already valid/plausible candidates.
- Provide deterministic same-function fallbacks.
- Never expose private provider keys in a public web client.

---

# 3D / Blender production

Before producing an asset, start from its cross-cutting catalog row and the visual/asset production bundle above.

## Preferred repeatable workflow

```text
catalog requirement
→ relevant art grammar/reference
→ inspect existing toolkit
→ write/reuse deterministic bpy generator when appropriate
→ execute Blender
→ validate structure
→ render canonical gameplay preview
→ inspect actual render
→ bounded iteration
→ export GLB
→ verify integration
→ update catalog status/notes
```

Prefer reproducible generators for repeatable families over long UI/MCP micro-operation sequences.

## Visual iteration

- Inspect rendered results; code correctness is not visual correctness.
- Evaluate at gameplay camera distance.
- Use only a small bounded number of autonomous aesthetic iterations unless instructed otherwise.
- When the remaining choice is subjective direction rather than a defect, surface alternatives rather than silently redefining style.

## Asset generation

- Reuse shared primitives/materials.
- Use deterministic seeds for procedural variants.
- Preserve required semantic anchors/sockets across variants.
- Keep geometry simple and silhouettes readable.
- Do not add texture detail to compensate for weak form.
- Do not create unique animations when a generic action + semantic anchor solves the interaction.
- Never modify Wilson's core identity/design as incidental work on another asset.

## Blender scene hygiene

- Scripts must not rely on active selection unless they explicitly set it.
- Own/clean only generated collections/objects belonging to the task.
- Use stable names.
- Keep units, transforms and export orientation consistent with `ASSET_SPEC.md`.
- Do not leave temporary cameras/lights/helpers inside runtime asset roots.

## Generated assets and source control

Do not commit temporary previews, backups or experimentation debris. Commit generators/source/runtime outputs according to `ASSET_PIPELINE.md` and actual build needs.

---

# Definition of done

## Code/domain change

- behavior matches product/domain/architecture intent;
- relevant regressions pass;
- no hidden simulation/presentation coupling is introduced;
- deterministic behavior remains reproducible where applicable;
- autonomous decisions remain explainable;
- numeric guards remain explicit;
- canonical docs are updated if a contract changes.

## Architecture/design-contract change

- authority owner is explicit;
- durable versus derived state is explicit;
- producer/consumer boundaries are documented;
- representative scenes/fixtures still fit without bespoke architecture hacks;
- guard/calibration implications are considered;
- the canonical owner document is updated;
- status/handoff is updated only when phase/sequencing materially changes.

## Asset/catalog change

- catalog row captures required cross-cutting semantics without redefining the domain;
- applicable visual contracts are satisfied;
- required states/contrasts/anchors are represented;
- gameplay-camera preview is reviewed when a model exists;
- runtime asset conventions are validated;
- catalog status/notes reflect actual completion.

---

# Architectural change protocol

Documentation describes current intended contracts, not immutable law. If implementation/content evidence shows a contract is wrong:

1. identify the conflict and affected validated behavior/invariant;
2. explain the tradeoff;
3. update the canonical owner document;
4. update affected tests/content/assets;
5. update status/handoff only when sequencing or closed decisions changed;
6. do not quietly implement a contradictory second architecture.

## Priority

When tradeoffs conflict, optimize in this order:

1. coherent player experience;
2. simulation correctness and persistence safety;
3. behavioral legibility and historical continuity;
4. systemic reuse/combinatorial value;
5. visual coherence/readability;
6. developer/agent reproducibility;
7. raw content quantity.
