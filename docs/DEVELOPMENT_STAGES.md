# Development Stages

## Purpose

This document is the canonical macro-level maturity map for Wilson Shipwrecked.

It answers a different question from the active handoff.

- `DEVELOPMENT_STAGES.md` defines the **large product-development stages** and the gate that proves each one is mature enough to move on.
- `docs/handoffs/*` defines the **tactical work for the currently active transition**.
- `DISCOVERY_STATUS.md` records the **concrete validated implementation checkpoint**.

This is intentionally not a detailed feature backlog. The project remains scene-led and evidence-driven; a stage may require different implementation cuts than anticipated here.

The stable progression is:

```text
1. Structural systemic runtime
→ 2. Observable living simulation
→ 3. Entertaining autonomous diorama
→ 4. Player ↔ Wilson relationship loop
→ 5. Persistent living run
→ 6. Representative systemic breadth
→ 7. Productization
```

A later stage may begin exploratory work before the previous one is perfectly polished, but the previous stage's acceptance gate should be materially satisfied before it stops being the leading risk.

---

# Stage 1 — Structural systemic runtime

Status: **COMPLETED**

## Question

> Can the simulation's core systems coexist with explicit authority, deterministic causality and reconstructible runtime boundaries?

## Required maturity

The project needs reusable, regression-backed primitives for:

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

The exact concrete baseline belongs in `DISCOVERY_STATUS.md`.

## Completion gate

This stage is complete when representative verticals prove the core causal boundaries without relying on scene-specific bypasses or a second debug simulation architecture.

## Anti-goals

Do not remain in this stage merely to invent more abstractions, generic containers, universal graphs or cleanup that no representative situation requires.

---

# Stage 2 — Observable living simulation

Status: **COMPLETED**

## Question

> Can Wilson live autonomously for several simulated minutes in a real Godot scene while the operator can understand what he is doing and why?

## Required maturity

The real runtime should support one continuous living scene with a representative subset of:

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

Validated completion context is preserved in the completed handoff:

`handoffs/systemic-runtime-to-observable-godot-living-simulation.md`

---

# Stage 3 — Entertaining autonomous diorama

Status: **ACTIVE**

## Question

> Can several minutes of autonomous simulation produce small, understandable and memorable stories rather than merely rotating through meters and task loops?

This is the current leading product risk.

## Intended maturity

The island should begin to exhibit:

- bounded anti-stagnation behavior through Stimulation/boredom rather than random action injection;
- ordinary low-stakes life between urgent needs;
- at least one Gerald/environment interaction with a real Wilson-visible consequence;
- history/learning that visibly changes a later choice;
- completed structures that continue to matter through use, context, maintenance or degradation where appropriate;
- readable suboptimal behavior, including comedy that comes from Wilson's state/history rather than unexplained inactivity;
- enough variation that a five-to-ten-minute observation can produce more than one plausible sequence.

## Completion gate

A manual observation run should reliably produce at least a few causal situations worth recounting in plain language, for example:

```text
Gerald interfered with something Wilson cared about
→ Wilson noticed
→ later anticipated/reacted differently
```

or:

```text
Wilson finished a structure
→ weather later changed its usefulness/condition
→ he adapted or maintained it
```

The important property is not the exact story. It is that prior events alter later behavior and the operator can understand the connection.

## Current tactical handoff

`handoffs/observable-living-simulation-to-entertaining-systemic-diorama.md`

## Anti-goals

Do not solve this stage by:

- adding random behavior merely to avoid idle;
- giving every shallow actor a full Wilson cognition stack;
- scripting fixed stories;
- multiplying content before existing systems create persistent consequences;
- growing debug UI until it substitutes for player-visible readability.

---

# Stage 4 — Player ↔ Wilson relationship loop

Status: **PLANNED**

## Question

> Can the player intervene in the living world and create consequences that Wilson perceives, interprets and remembers without becoming Wilson's puppeteer?

## Intended maturity

Bring the already-founded player/Presence systems into the real living scene:

- inspect/select world objects;
- expose currently valid contextual interventions;
- physically alter, give, move or otherwise affect the World through admitted commands;
- make actual World consequences perceptible to Wilson when accessible;
- allow Presence attribution to change through evidence;
- support suggestions as bounded influence, not commands;
- make acceptance/refusal/reinterpretation legible;
- preserve player-private intent as separate from World truth and Wilson belief.

## Completion gate

The player can cause at least one meaningful situation where:

```text
player action
→ World consequence
→ Wilson observation
→ interpretation / relationship change
→ later behavior differs
```

and one suggestion case where Wilson can plausibly accept, refuse or ignore without violating autonomy.

## Anti-goals

Do not turn the product into direct character control, omnipotent debug mutation or hidden telepathy between player intent and Wilson cognition.

---

# Stage 5 — Persistent living run

Status: **PLANNED**

## Question

> Does the island feel like the same continuing life when the player closes the game and returns later?

## Intended maturity

Turn existing persistence foundations into product behavior:

- real run save/load entry points;
- safe autosave/shutdown persistence;
- restoration of current authoritative state and reconstructible runtime projections;
- bounded offline elapsed-time progression;
- clear policies for what may and may not happen offline;
- day/night and recurring context becoming behaviorally meaningful;
- maintenance/degradation/history continuing coherently;
- return-from-absence presentation that helps the player understand important changes.

## Completion gate

A player can leave a run, return later and observe a coherent continuation rather than a reset or opaque state jump. Save/load/offline progression must preserve causal invariants and produce understandable consequences.

## Anti-goals

Do not build a second offline simulation architecture or replay every hidden frame while the game was closed.

---

# Stage 6 — Representative systemic breadth

Status: **PLANNED**

## Question

> Can the same reusable systems produce a convincing breadth of the game's representative situations without bespoke story controllers?

## Intended maturity

Use `SCENE_VALIDATION.md` and the representative scene catalog as a regression matrix rather than a script list.

Pressure examples include equivalents of:

- Gerald;
- One More Piece;
- Storm Priorities;
- The Mushroom;
- The Missing Spoon;
- Scientific Method;
- The Falling Palm;
- Signal Fire;
- habit disruption and absence;
- player assistance/dependency;
- competing projects and aesthetic/non-survival activity.

The goal is not to implement all scenes literally. The goal is to prove that a relatively small vocabulary of systems and content can generate the important behavioral phenomena.

## Completion gate

A representative subset spanning quiet life, experimentation, relationships, weather, hazards, projects, player influence and memory/history can emerge from shared primitives with acceptable calibration and without proliferating scene-specific APIs.

## Anti-goals

Do not chase raw scenario count, handcrafted branching stories or one-off systems created only to reproduce a catalog title.

---

# Stage 7 — Productization

Status: **PLANNED**

## Question

> Does this work as a shippable game experience rather than a development simulation tool?

## Intended maturity

This stage converges runtime, content, assets and user experience:

- player-facing interaction UI distinct from calibration/debug surfaces;
- final or production-appropriate camera/framing;
- animation/action-state presentation;
- weather/environment VFX and readable feedback;
- audio/ambience;
- final emote/thought-language policy where useful;
- onboarding and first-run experience;
- save/load UX;
- performance and web-build constraints;
- resilience/error recovery;
- content tuning and pacing;
- asset/model integration and visual consistency;
- release-quality validation across target platforms.

## Completion gate

A new player can launch the game, understand the basic fantasy without development tooling, observe Wilson living autonomously, intervene meaningfully, leave/return to a persistent run and experience enough systemic variety to justify continued play.

## Anti-goals

Do not postpone core behavioral/product risk until this stage. Productization should polish and package proven loops, not discover whether the game is interesting for the first time.

---

# Cross-stage principles

These apply throughout the roadmap.

## 1. Risk-first progression

Advance the stage whose unanswered question is currently the greatest product risk. Do not finish every possible feature in one stage before touching the next.

## 2. Scene-led implementation

Representative player-visible situations create implementation pressure. Architecture remains requirement-driven.

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

## 5. Debug readability is scaffolding

Calibration surfaces may remain available to developers, but player-facing readability must increasingly come from world behavior, animation, expression and interaction feedback.

## 6. Assets are parallel, not the maturity definition

3D assets, art direction and production presentation progress in parallel. A macro stage is completed by behavioral/product capability, not by asset count alone. Stage 7 requires convergence of both.

## 7. Handoffs remain tactical

When a stage is active, use a dedicated handoff to define the next finite implementation cut. Do not expand this document into a recursively detailed backlog.

---

# Status summary

| Stage | Status | Leading question |
| --- | --- | --- |
| 1. Structural systemic runtime | COMPLETED | Are the systemic causal foundations sound? |
| 2. Observable living simulation | COMPLETED | Can the real simulation run continuously and readably? |
| 3. Entertaining autonomous diorama | ACTIVE | Does autonomous life produce memorable situations? |
| 4. Player ↔ Wilson relationship loop | PLANNED | Can player influence create perceived, remembered consequences? |
| 5. Persistent living run | PLANNED | Does the same life survive closing and returning? |
| 6. Representative systemic breadth | PLANNED | Can shared primitives cover the game's key behavioral situations? |
| 7. Productization | PLANNED | Does the result work as a shippable game? |

The exact current implementation checkpoint and test count remain owned by `DISCOVERY_STATUS.md`.
