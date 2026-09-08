# Development Stages

## Purpose

This document is the canonical macro-level maturity map for Wilson Shipwrecked.

It answers a different question from the active handoff:

- `DEVELOPMENT_STAGES.md` defines the **large product-development stages**, their leading risk and the gate that proves each stage is mature enough to stop being the main risk;
- `docs/handoffs/*` defines the **finite tactical work for the currently active transition**;
- `DISCOVERY_STATUS.md` records the **concrete validated implementation checkpoint**.

This is intentionally not a detailed feature backlog. The project remains scene-led and evidence-driven. A stage may require implementation cuts different from those anticipated here.

The stable progression is:

```text
1. Structural systemic runtime
→ 2. Observable living simulation
→ 3. Entertaining autonomous diorama
→ 4. Player ↔ Wilson relationship loop
→ 5. Persistent living run
→ 6. Representative systemic/content breadth
→ 7. Productization
```

Stages are risk boundaries, not waterfall walls. Exploratory work from a later stage may begin earlier when it exposes a major product risk cheaply, but the active stage should remain the default prioritization lens.

A stage is not complete because many related systems exist. It is complete when its **player-visible risk has been materially demonstrated in the real runtime** and the relevant semantic behavior is regression-backed.

---

# Maturity scale used by manual observation

Runtime correctness and entertainment are different questions. Manual observation should increasingly distinguish:

```text
0. Works      — Wilson performs technically valid behavior.
1. Legible    — an observer can understand what Wilson is doing.
2. Interesting— an observer wants to see what happens next.
3. Memorable  — an observer can recount a small causal story afterward.
4. Fun        — the run creates amusement, curiosity, tension, attachment or a desire to interfere/replay.
```

Stage 2 primarily establishes levels 0–1.
Stage 3 should reliably reach level 3 and begin producing level-4 moments.
Later stages should broaden and sustain those qualities rather than discovering them for the first time.

---

# Stage 1 — Structural systemic runtime

Status: **COMPLETED**

## Leading question

> Can the simulation's core systems coexist with explicit authority, deterministic causality and reconstructible runtime boundaries?

## Required maturity

Reusable, regression-backed primitives exist for:

- World authority and typed semantic identity;
- Wilson cognition, drives, beliefs, habits, associations and episodes;
- projects;
- ActionExecution and grounded consequences;
- environment/weather and physical processes;
- non-Wilson actors;
- hazards/body consequences;
- player intervention / Presence boundaries;
- Director/player/run/profile separation;
- bootstrap, restore and deterministic fixtures;
- Godot spatial/navigation/perception/physics adapters.

The exact implementation baseline belongs in `DISCOVERY_STATUS.md`.

## Completion gate

Representative verticals prove the core causal boundaries without scene-specific bypasses or a second debug simulation architecture.

## Anti-goals

Do not remain in this stage to invent more abstractions, generic containers, universal graphs or cleanup with no representative pressure.

---

# Stage 2 — Observable living simulation

Status: **COMPLETED**

## Leading question

> Can Wilson live autonomously for several simulated minutes in a real Godot scene while an operator can understand what he is doing and why?

## Required maturity

One continuous real-runtime scene supports a representative subset of:

- recurring needs;
- movement and grounded actions;
- persistent project work;
- interruption and continuation;
- weather/context response;
- at least one non-Wilson actor;
- visible persistent world change;
- readable primitive presentation;
- compact causal observability;
- safe time acceleration;
- long-running bounded validation.

## Completion gate

The operator can open the living scene, watch multiple systems interact coherently, accelerate time and explain recent behavior from real semantic state rather than scripted choreography.

Validated completion context remains in the completed handoff:

`handoffs/systemic-runtime-to-observable-godot-living-simulation.md`

---

# Stage 3 — Entertaining autonomous diorama

Status: **ACTIVE**

## Leading question

> Can several minutes of autonomous simulation produce small, understandable and memorable stories rather than merely rotating through meters and task loops?

This is the current leading product risk.

The goal is not maximum activity. The goal is a living rhythm containing ordinary life, personal behavior, interruptions, discovery, consequences and occasional comedy while remaining causally understandable.

## Required behavioral vocabulary

Before this stage is considered mature, the living scene should prove at least a narrow player-visible example of each major autonomous family below. Stage 6 expands these families; it should not introduce most of them for the first time.

### 1. Functional ordinary life

Wilson can satisfy recurring needs and pursue persistent projects without looking like a rigid meter scheduler.

Desired shape:

```text
ordinary activity / project
→ competing need or context
→ interruption or redirection
→ grounded resolution
→ later continuation where still meaningful
```

### 2. Quiet preference without direct utility

At least one behavior should be attributable to Wilson's personal history/preference rather than need relief or project progress.

Examples of the required phenomenon:

```text
preferred resting place
small aesthetic arrangement
repeated harmless leisure choice
attachment to a particular object/place
```

The target is the `Good Chair` phenomenon: Wilson must sometimes look like a person rather than an optimizer.

### 3. Physical experimentation / discovery

At least one living-scene loop should prove that Wilson can encounter uncertainty and learn through a physical attempt rather than only consume known affordances.

Desired shape:

```text
unknown / unresolved subject
→ curiosity or contextual reason to investigate
→ plausible physical experiment
→ meaningful success / partial result / counterevidence
→ belief or expectation changes
→ later tactic/choice can differ
```

This is a narrow early proof of the `Scientific Method` family. Broad interaction/discovery coverage belongs to Stage 6.

### 4. Actor or environment interference

At least one independent non-Wilson process should create a Wilson-visible consequence.

Examples:

```text
Gerald changes access/value/location of something Wilson cares about
weather changes what is safe/useful/comfortable
world process damages or changes a previously useful state
```

The consequence must reach Wilson through ordinary World → perception → cognition semantics rather than a scene controller instructing him to react.

### 5. History visibly changes a later choice

One grounded experience must alter a later repeated or analogous context in a way an observer can understand.

```text
experience
→ perception
→ belief / association / habit / episode consequence
→ similar later context
→ detectably different choice or reaction
```

### 6. Post-project life

Completing a large project must not collapse the simulation into eat/rest/idle repetition.

At least one of the following should become meaningful after completion:

- use;
- maintenance;
- degradation;
- preference;
- secondary projects;
- environmental interaction;
- new affordances or opportunities.

### 7. Bounded anti-stagnation

Stimulation/boredom may increase pressure toward optional activity when ordinary life becomes repetitive, but must not inject arbitrary random actions.

Repeated activity may remain recognizable as habit while losing enough novelty/stimulation value that other plausible behavior can re-enter competition.

### 8. Embodied semantic readability

Important actions, observations and reactions need enough **semantic presentation time** to be legible before unrelated behavior visually replaces them.

This is not final animation polish. It is a gameplay-temporal contract.

Distinguish:

```text
presentation-only motion
    blinking / breathing / decorative idle variation / particles
    → may be renderer-owned and non-blocking

semantic expression beat
    orient / surprise / hesitation / recoil / celebration / frustration /
    inspection / anticipation / recovery
    → occupies meaningful Wilson time when the behavior requires it
```

A semantic beat must remain deterministic/headless-safe and must never make a concrete animation clip authoritative.

Preferred direction:

```text
semantic action/reaction lifecycle
→ authored semantic duration/checkpoints/interruption policy
→ presentation adapter maps that lifecycle to animation/pose/audio
```

Do not implement domain correctness as:

```text
await AnimationPlayer.animation_finished
```

The domain/application layer may know that Wilson is still in an authored action/reaction phase. The presentation layer decides which clip, blend, facial pose, gaze or sound communicates it.

Immediate threats may interrupt appropriate ordinary expression beats according to explicit semantics; decorative presentation never blocks gameplay.

## Content floor for calibration

Do not measure Stage 3 by raw asset count. Measure whether the current authored content offers enough **functional redundancy** for systemic competition.

The calibration scene should increasingly avoid one-to-one mappings such as:

```text
hunger      → exactly one food solution
stimulation → exactly one optional activity
weather     → exactly one response
project     → exactly one persistent objective
curiosity   → exactly one inspectable subject
```

Before closing the stage, there should be at least modest alternative pressure in several of these families so that the generic architecture is observable as behavioral variety rather than only reusable code.

## Completion gate

A five-to-ten-minute manual observation should reliably reach **memorable** rather than merely functional behavior.

The operator should be able to recount at least a few causal situations in plain language without depending on a large debug wall, such as:

```text
Gerald interfered with something Wilson cared about
→ Wilson noticed
→ a later encounter was handled differently
```

```text
Wilson tried something uncertain
→ the result surprised/frustrated him
→ he later tried or preferred another approach
```

```text
Wilson chose a personally preferred low-utility activity
→ another pressure later interrupted it
```

The exact stories are not requirements. Their causal families are.

Automated validation should preserve deterministic semantic ordering, bounded long-run behavior and the absence of authority leaks. Manual validation judges legibility, timing, personality, variation and whether any moments approach fun.

## Current tactical handoff

`handoffs/observable-living-simulation-to-entertaining-systemic-diorama.md`

## Anti-goals

Do not solve this stage by:

- injecting random behavior merely to avoid idle;
- giving every shallow actor a full Wilson cognition stack;
- scripting fixed stories;
- treating final assets as a prerequisite for behavioral calibration;
- multiplying content before existing systems create cross-system consequences;
- growing debug UI until it substitutes for player-visible readability;
- making animation clips or renderer callbacks authoritative simulation state;
- postponing all reaction/action timing questions to final polish.

---

# Stage 4 — Player ↔ Wilson relationship loop

Status: **PLANNED**

## Leading question

> Can the player perturb the living world and create consequences that Wilson perceives, interprets and remembers without becoming Wilson's puppeteer?

The autonomous island should already be worth watching before player intervention becomes a primary novelty source.

## Intended maturity

Bring the already-founded player/Presence systems into the real living scene:

- inspect/select world objects;
- expose currently valid contextual interventions;
- physically alter, give, move or otherwise affect the World through admitted commands;
- make actual World consequences perceptible to Wilson when accessible;
- allow Presence attribution to change through evidence;
- support suggestions as bounded influence, not commands;
- make acceptance/refusal/reinterpretation visually legible;
- preserve player-private intent as separate from World truth and Wilson belief;
- allow accumulated Presence history to affect later player-facing situations.

## Representative pressure

A useful small reference shape is:

```text
Wilson establishes/uses an expected arrangement
→ player changes something through an admitted intervention
→ Wilson later encounters prediction error
→ orient/search/reaction remains visually legible
→ attribution/relationship may change
→ later behavior differs
```

This covers the `Missing Spoon` / `Someone Moved the Rock` family without requiring either scene literally.

## Completion gate

The player can create at least:

1. one meaningful physical intervention chain:

```text
player action
→ World consequence
→ Wilson observation
→ interpretation / relationship change
→ later behavior differs
```

2. one bounded suggestion case where Wilson can plausibly accept, refuse or ignore;
3. one visible reaction where the player can understand Wilson's response without reading internal Presence scalars.

## Anti-goals

Do not turn the product into direct character control, omnipotent debug mutation or hidden telepathy between player intent and Wilson cognition.

---

# Stage 5 — Persistent living run

Status: **PLANNED**

## Leading question

> Does the island feel like the same continuing life when the player closes the game and returns later?

## Intended maturity

Turn existing persistence foundations into product behavior:

- real run save/load entry points;
- safe autosave/shutdown persistence;
- restoration of authoritative state and reconstructible projections;
- bounded offline elapsed-time progression;
- explicit policies for what may and may not happen offline;
- day/night and recurring context becoming behaviorally meaningful;
- maintenance/degradation/history continuing coherently;
- return-from-absence presentation that makes important changes inferable.

Earlier stages should already preserve representative state through explicit save/restore regressions where relevant. Stage 5 turns this capability into the normal player lifecycle rather than discovering persistence ownership from scratch.

## Completion gate

A player can leave a run, return later and observe a coherent continuation rather than a reset or opaque state jump.

Additionally, at least one meaningful elapsed-time consequence should be inferable primarily from **visible world state or Wilson behavior**, not only from a debug/history panel.

Examples of the phenomenon:

```text
project progressed or changed
resource spoiled/disappeared/moved
weather/world process altered something
Wilson now avoids/prefers a context because of admitted history
maintenance became relevant
```

## Anti-goals

Do not build a second offline simulation architecture or replay every hidden frame while the game was closed.

---

# Stage 6 — Representative systemic and content breadth

Status: **PLANNED**

## Leading question

> Can the already-proven gameplay vocabulary produce enough different situations and combinations to sustain a convincing run without bespoke story controllers?

This stage is primarily **breadth expansion and calibration**, not first introduction of the core behavioral families that make the game itself recognizable.

## Intended maturity

Use `SCENE_VALIDATION.md` and the representative scene catalog as a regression matrix rather than a script list.

Expand shared primitives/content across equivalents of:

- Gerald relationship/running gag;
- One More Piece / competing needs-projects;
- Storm Priorities;
- Mushroom uncertainty/risk;
- Missing Spoon / arrangement expectation;
- Scientific Method / iterative experimentation;
- Falling Palm / fair physical danger;
- Signal Fire / rare directed opportunity;
- habit disruption and absence;
- player assistance/dependency;
- competing projects;
- aesthetic/non-survival activity;
- post-completion structure life;
- multiple environmental consequences.

The goal is not to implement every catalog title. The goal is to demonstrate that a relatively small vocabulary can cover the important phenomenon families through recombination.

## Content-grammar coverage

Do not plan this stage as an asset quota. Prefer a content-role matrix that asks how many systems each piece of content can participate in.

Useful roles include:

```text
need relief
curiosity / uncertainty
physical tool
project material/result
hazard
preference / attachment
Gerald interaction
player intervention
weather/environment response
transformation / learned affordance
```

Prefer content that crosses multiple roles and produces new combinations over visually distinct objects with identical systemic function.

A healthy breadth stage should also add **functional redundancy**: multiple plausible foods, optional activities, experiment subjects, tools, project pressures, environmental effects and actor interactions where appropriate.

## Director pressure

After autonomous baseline interest is proven, validate that the Director can introduce rare opportunities without becoming a story controller:

```text
ordinary living state
→ eligible rare opportunity
→ Director exposes/biases opportunity
→ Wilson remains autonomous
→ current needs/history/world state may support, complicate or ruin it
```

## Completion gate

A representative subset spanning quiet life, experimentation, relationships, weather, hazards, projects, player influence and memory/history emerges from shared primitives with acceptable calibration.

Multiple manual runs/seeds should produce meaningfully different recountable sequences without requiring scene-specific APIs or a scripted expected story.

The operator should be able to recognize both:

- recurring Wilson identity/routines/history;
- materially different combinations and outcomes across runs.

## Anti-goals

Do not chase raw scenario count, handcrafted branching stories, one-off systems created only to reproduce a catalog title, or asset count disconnected from systemic role coverage.

---

# Stage 7 — Productization

Status: **PLANNED**

## Leading question

> Does this work as a shippable game experience rather than a development simulation tool?

## Intended maturity

This stage converges proven runtime/content behavior with production UX and assets:

- player-facing interaction UI distinct from calibration/debug surfaces;
- final or production-appropriate camera/framing;
- production animation assets and animation polish over already-proven semantic action/reaction timing;
- weather/environment VFX and readable feedback;
- audio/ambience and final reaction sound language;
- final emote/thought-language policy where useful;
- onboarding and first-run experience;
- save/load UX;
- performance and web-build constraints;
- resilience/error recovery;
- content tuning and pacing;
- asset/model integration and visual consistency;
- release-quality validation across target platforms.

Stage 7 should replace/sculpt presentation implementations, not invent the first temporal contract between gameplay and animation.

## Completion gate

A new player can launch the game, understand the fantasy without development tooling, observe Wilson living autonomously, intervene meaningfully, leave/return to a persistent run and experience enough systemic variety to justify continued play.

## Anti-goals

Do not postpone core behavioral, interaction, persistence, timing or content-breadth risks until this stage. Productization packages and polishes proven loops; it does not discover whether the game works for the first time.

---

# Cross-stage principles

These apply throughout the roadmap.

## 1. Risk-first progression

Advance the stage whose unanswered question is currently the greatest product risk. Do not finish every possible feature in one stage before touching the next.

## 2. Scene-led implementation

Representative player-visible situations create implementation pressure. Architecture remains requirement-driven.

For each proposed capability ask:

```text
Which observable situation needs this?
Can current primitives already express it?
What exact semantic gap remains?
Will closing the gap make the living scene more legible, personal, varied,
historical, expressive, discoverable or consequential?
```

If substantial work improves none of those dimensions, reconsider its priority.

## 3. Persistent causality over feature count

Prefer:

```text
one event
→ remembered consequence
→ later changed choice
```

over several unrelated activities with no history.

## 4. Autonomous interest before player perturbation

The world should be worth watching before player intervention becomes the main source of novelty.

## 5. Presentation timing is not final polish

Rendering remains non-authoritative, but some behavior requires semantic time to be readable.

Keep distinct:

```text
semantic meaning/timing/interruption
!= concrete animation clip/blend/asset
!= decorative renderer-only motion
```

Headless simulation must remain valid. Missing/changed animation assets must never change authoritative gameplay outcomes or deadlock the runtime.

## 6. Content is a multiplier, not a substitute for systems

Generic systems do not generate entertainment from zero content. Add authored elements when they create new systemic combinations, but prefer content-role coverage and functional redundancy over raw counts.

## 7. Debug readability is scaffolding

Calibration surfaces may remain available to developers, but player-facing readability must increasingly come from world state, timing, animation/expression, sound and interaction feedback.

## 8. Assets are parallel, not the maturity definition

3D assets and art direction progress in parallel. A macro stage is completed by behavioral/product capability, not asset count alone. Stage 7 requires convergence of both.

## 9. Handoffs remain tactical

When a stage is active, use a dedicated handoff to define the next finite implementation cut. Do not expand this document into a recursively detailed backlog.

## 10. Deterministic authority, emergent divergence

The authoritative simulation remains deterministic for the same durable causes/seed/input sequence. Variety should primarily arise from differing world state, timing, personality/history and accumulating causal consequences rather than unexplained behavior noise.

---

# Status summary

| Stage | Status | Leading question |
| --- | --- | --- |
| 1. Structural systemic runtime | COMPLETED | Are the systemic causal foundations sound? |
| 2. Observable living simulation | COMPLETED | Can the real simulation run continuously and readably? |
| 3. Entertaining autonomous diorama | ACTIVE | Does autonomous life produce memorable situations with personality, discovery and embodied readability? |
| 4. Player ↔ Wilson relationship loop | PLANNED | Can player influence create perceived, remembered and legible consequences? |
| 5. Persistent living run | PLANNED | Does the same life survive closing and returning in an understandable way? |
| 6. Representative systemic/content breadth | PLANNED | Can proven families scale to enough varied systemic stories? |
| 7. Productization | PLANNED | Does the result work as a shippable game? |

The exact current implementation checkpoint and test count remain owned by `DISCOVERY_STATUS.md`.
