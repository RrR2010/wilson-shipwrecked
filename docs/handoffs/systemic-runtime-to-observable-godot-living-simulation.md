# Handoff — Systemic Runtime to Observable Godot Living Simulation

Status: **ACTIVE**

## Objective

Deliver the first **continuously observable and calibratable Godot living-simulation scene** for Wilson Shipwrecked using the real production/runtime boundaries and deliberately readable primitive geometry.

This is not primarily an art task and not a request for another isolated engine smoke test.

The target is a development experience where an operator can open a Godot scene, start a real run, watch Wilson and the island evolve for several simulated minutes, accelerate time, inspect important causal state, and understand why Wilson changes behavior.

The implementation may naturally break into multiple verticals, but do not optimize for a predetermined count. Choose the cuts that preserve a coherent working scene and avoid long-lived half-integrated infrastructure.

---

# Integrated baseline

Start from current `main`:

```text
f9082e766a01b982a3caefdf6d7c6168a10da4d8
```

This includes PR #67 (`effective protection feedback and structural relation failure`).

Latest strict local validation reported before squash integration:

```text
RESULT: 122 PASS / 122 TOTAL
PASS headless_suite (122 tests)
```

The squash merge changed commit identity, not the validated feature content. There are currently no GitHub Actions status checks replacing the operator-run strict Godot suite.

---

# Required reading

Start with the smallest runtime/engine bundle:

```text
AGENTS.md
docs/README.md
docs/DISCOVERY_STATUS.md
this handoff

docs/ARCHITECTURE.md
docs/SIMULATION_CONTRACTS.md
docs/SIMULATION_ORCHESTRATION.md
docs/MUTATION_AUTHORITY.md
docs/PRODUCT.md
docs/BEHAVIORAL_MODEL.md
docs/testing/SCENE_TESTS.md
```

Then inspect current source and the strongest existing engine-facing fixtures before designing a new production/dev scene, especially:

```text
tests/scenes/
tests/support/engine_scenario/
src/infrastructure/spatial/
src/application/bootstrap/
src/application/simulation/
```

Read specialized domain appendices only when the chosen living loop touches them, for example:

```text
docs/DOMAIN_ENVIRONMENTAL_PROTECTION.md
docs/DOMAIN_PROCEDURAL_WEATHER.md
docs/DOMAIN_HAZARD_DYNAMICS.md
docs/DOMAIN_PROCEDURAL_COMPOSITION.md
docs/DOMAIN_MICRO_LOOP.md
```

## Explicit scope exclusion

Do **not** use or modify art/asset/modeling documentation as part of this phase unless the operator later asks for it. A parallel agent owns that workstream.

In particular, do not make this task depend on final models, Blender production, visual-style convergence, asset-pipeline completion, or art-catalog cleanup.

Primitive-shape scene work here is a runtime/presentation scaffold for simulation readability.

---

# Research posture for Godot

This phase touches real Godot APIs heavily. Treat engine behavior as something to **verify**, not remember approximately.

Before implementing or changing non-trivial Godot behavior:

1. inspect the existing repository adapter/tests first;
2. check the current Godot 4.7 documentation or authoritative engine references for the exact API/semantics;
3. search for known lifecycle/order caveats when relevant (NavigationAgent3D, NavigationServer3D, physics callbacks, process order, SubViewport/UI projection, Control/Node3D interaction, signals, timers, scene-tree ownership, etc.);
4. prefer a small executable probe when documentation leaves behavior ambiguous;
5. only then implement the production adapter/scene behavior;
6. encode discovered lifecycle assumptions in focused tests/comments where they materially affect correctness.

Do not guess method names, callback timing, navigation synchronization, transform-space semantics, or UI projection behavior.

When internet research materially informs a non-obvious implementation choice, record the rationale briefly in the code/PR so later agents know which engine behavior is being relied upon.

---

# Product-level target

A successful scene should feel like a primitive but readable version of the living diorama:

```text
real new run / valid deterministic dev run
→ authoritative owners + RunRuntimeComposer
→ explicit semantic-to-Godot bindings
→ GodotSimulationHost runs continuously
→ Wilson perceives / decides / moves / acts
→ needs, projects, environment and history interact
→ visible world configuration changes
→ interruptions can occur
→ prior activity can later resume where semantics support it
→ operator can understand recent causality
```

The goal is not to script one fixed story. Author initial conditions/content so that useful systemic situations are likely, then let ordinary runtime rules produce the sequence.

A representative pressure shape might be:

```text
Wilson has a need
→ uses remembered/visible resource
→ contributes to an existing project
→ weather or another actor changes context
→ Wilson redirects
→ persistent project/world state remains
→ context later permits resumption
→ learned/history state affects a later choice
```

This is a pressure shape, not a mandatory cutscene.

---

# Primitive-shape readability contract

Final assets are intentionally unavailable. Primitive geometry should therefore be designed for **semantic readability at gameplay camera distance**, not merely for implementation convenience.

## Principles

Use simple meshes, but compose them when a single primitive is ambiguous.

Examples of acceptable prototype representation:

```text
Wilson
  capsule/cylinder body
  small head primitive
  clear forward marker or asymmetry when facing matters

Gerald / animal
  distinct body proportions
  head/tail or other silhouette cue
  visibly different scale/shape from Wilson

palm/tree
  narrow trunk cylinder
  crown made from spheres/cones/flattened primitives

food patch / harvestable plant
  stem/base + clustered visible fruit/food primitives

shelter
  support posts + roof plane/wedge + distinct sleeping/covered region

logs / sticks
  elongated cylinders with size differences

rocks
  low-poly spheres/boxes with distinct scale family

container / storage
  box body + lid/top cue

fire
  base stones/logs + simple flame/light indicator
```

Do not represent every entity as an undifferentiated cube.

Prefer recognizable silhouette, proportions, local grouping and restrained material/color differentiation over text labels attached to everything.

Primitive presentation may use composition, billboards, simple icons and debug overlays, but must not encode hidden gameplay rules that do not exist in the simulation.

## Identity rule

Primitive scene nodes are adapters/presentation:

```text
RuntimeWorldRef / DomainId
!= node name
!= NodePath
!= transform
!= material color
```

Bind semantic identities explicitly through existing spatial/runtime boundaries. Do not turn scene layout into a second authoritative World model.

---

# Wilson expression/readability proxy

Final facial expression cannot be evaluated with primitive geometry. Add a **Wilson-attached speech/thought/emote presentation surface** if it improves readability.

A useful prototype can show short symbolic states such as:

```text
🍖 / hungry
💤 / tired
💡 / idea/opportunity
❓ / uncertain/investigating
⚠ / threat
☔ / reacting to rain
🔨 / project/building
💭 / remembered preference / reconsideration cue
😠 / frustrated/negative reaction where grounded
🙂 / positive outcome where grounded
```

Exact glyphs/text are presentation choices.

## Critical boundary

The emote/bubble system must be a **projection of existing simulation/cognition state or emitted semantic events**, never a hidden behavior owner.

It may read approved presentation/debug projections such as:

```text
current intention
drive pressure
active action/project
recent perceived event
reconsideration/context transition
perceived threat
important grounded outcome
```

It must not:

```text
invent a belief Wilson does not hold
read hidden World truth and present it as Wilson thought
change utility/decision state
mutate drives/projects/beliefs
become required for simulation correctness
```

Keep this feature modular. If it proves expressive and low-noise, it may be retained as a final-product affordance later.

---

# Operator inspection and time controls

The scene should become a calibration tool, not only a visual demonstration.

Provide lightweight development controls/readouts sufficient to answer:

```text
What is Wilson doing?
Why did he choose it?
What changed recently?
What persistent thing is he working on?
What is the current weather/environment pressure?
Did he interrupt or resume something?
```

Candidate development-only surfaces:

```text
simulation speed: 1x / 4x / 16x (higher only if semantics remain stable)
current intention
action/execution status
top drive pressures / major candidate reason
active project + progress
weather/daylight
recent semantic events
selected entity properties/relations/effective properties
```

Prefer existing trace/explainability/projection paths over reading private stores directly.

Debug UI is presentation. It must not become mutation authority or a second simulation architecture.

---

# Living-loop scope

Do not attempt to activate every implemented system simultaneously on day one.

Choose a **small but causally rich** subset that can run reliably for several minutes. Good ingredients already supported include:

```text
needs/drives
known/perceived resource acquisition
ordinary movement/action execution
projects with persistent partial progress
habits/context cues
weather/environmental response
protection/degradation
Gerald or one shallow non-Wilson actor
threat/interruption/resumption where naturally triggered
learning/history that changes a later choice
```

Prefer 4–6 systems interacting coherently over 15 systems producing noise.

Calibrate authored starting conditions so the simulation demonstrates meaningful variation without hard-scripting a sequence.

---

# Scene composition / host abstraction

`generalized production scene-binding/host composition` has been deliberately deferred until repeated real use justified it.

This phase may now create that pressure.

Rule:

- first inspect the concrete wiring already present in engine scenarios;
- identify repeated stable responsibilities;
- extract a reusable composition boundary only when the new living scene would otherwise duplicate real production wiring;
- keep that abstraction strictly about adapter/host composition;
- do not let it own gameplay state or manufacture scenario truth.

Desired shape if justified:

```text
already bootstrapped run
+ explicit semantic scene-binding inputs
→ spatial registry/adapters
→ motion/perception/physics bridges
→ GodotSimulationHost
```

Do not build a universal scene/game framework preemptively.

---

# Godot-specific caution areas

Research before implementation where applicable:

- `NavigationAgent3D` path synchronization, repath and target-reached semantics;
- navigation-map readiness and iteration timing;
- `CharacterBody3D` physics cadence and motion ownership;
- runtime creation/removal of bodies and navigation obstacles/regions;
- transform-space conversions for world-space bubble/emote placement;
- `Control`/`CanvasLayer` vs `Label3D`/billboard tradeoffs for readable emotes;
- camera projection/unprojection when using screen-space overlays;
- process vs physics-process ordering;
- pausing/time scaling and whether simulation semantic time should follow engine `Engine.time_scale` or explicit host cadence;
- scene-tree lifecycle when binding/unbinding semantic entities;
- deterministic behavior under accelerated simulation.

Do not assume global Godot time scaling is automatically the correct simulation-speed implementation. Preserve explicit semantic clocks and validate acceleration behavior.

---

# Testing strategy

This phase needs both headless confidence and real-engine observation.

## Focused tests

Add focused tests for any new reusable adapter/composition primitive, especially lifecycle-sensitive Godot behavior.

## Integrated engine scenario

Keep at least one deterministic scenario that proves the scene/runtime bridge causally, without relying on operator observation.

The scenario should validate semantic checkpoints, not pixels.

## Long-running bounded simulation

Add a deterministic bounded run or harness where practical to catch:

```text
intention oscillation
stuck movement
project starvation
unbounded drive/history growth
repeated duplicate actions
dead relations/bindings
weather-loop instability
actor-interference deadlock
```

## Manual observation gate

Because this phase is specifically about readability, a manual Godot observation pass is legitimate in addition to headless tests.

Inspect at normal gameplay camera distance and accelerated time. Record concrete readability/calibration findings rather than treating “scene opens” as sufficient.

## Strict gate

Runtime/domain changes still require:

```powershell
.\tests\run_headless_tests.ps1
```

Any `SCRIPT ERROR`, generic engine `ERROR`, explicit `FAIL`, non-zero process, or missing expected PASS marker is failure.

---

# Deliverable / completion condition

Do not stop merely because a primitive island renders.

This handoff is complete when there is a coherent development scene that satisfies the following:

1. **real runtime entry** — uses common bootstrap/runtime composition rather than a debug-only simulation;
2. **continuous autonomous operation** — Wilson can run for several simulated minutes without scenario scripting driving each step;
3. **readable primitive world** — key entities/structures are distinguishable by deliberate primitive composition and silhouette;
4. **observable systemic interaction** — multiple existing systems interact in the same run, including at least one persistent activity such as a project/routine and at least one contextual interference such as weather or another actor;
5. **continuity** — persistent state survives interruptions and later affects/resumes behavior where domain semantics permit it;
6. **operator legibility** — current intention/recent causes can be inspected, and Wilson has an emote/bubble-style expression proxy if that materially improves understanding;
7. **time acceleration** — operator can speed observation without bypassing semantic clocks or breaking deterministic/runtime invariants;
8. **validation** — focused engine tests plus strict suite are green;
9. **no presentation authority leak** — primitive nodes, emotes and debug UI remain projections/adapters;
10. **documentation** — update `DISCOVERY_STATUS.md` and canonical docs only for actual new contracts; create the next handoff only when another agent/stage is truly taking over.

The operator should be able to open the scene and reasonably answer:

> “What has Wilson been doing, why did he change course, and what in this island has changed because time passed?”

---

# Anti-goals

Do not spend this phase on:

```text
final asset production
Blender/modeling pipeline convergence
facial rigging/animation
final UI polish
full content breadth
universal scene architecture
debug-only direct owner mutation
scripted cinematic behavior that bypasses cognition
presentation-driven gameplay truth
rewriting established architecture without representative pressure
```

Do not add a new subsystem merely because the primitive scene makes an existing implementation look visually simple.

---

# Working style

This is a research-heavy integration phase.

- investigate before coding;
- inspect existing adapters and tests before adding new ones;
- use official/current Godot references for API behavior;
- make small probes for uncertain engine semantics;
- keep commits coherent and reviewable;
- maintain a working scene throughout the phase where possible;
- fix architectural pressure when real composition exposes it, even if that requires refactoring;
- do not preserve a Frankenstein API solely for compatibility;
- avoid endless recursive polish: define a meaningful session/block objective and finish it before expanding scope.

Normal git flow remains:

```text
latest origin/main
→ new task branch
→ implementation
→ focused validation
→ strict local suite
→ PR to main
→ explicit operator authorization
→ squash merge
```

No merge authorization is implied by this handoff.
