# Handoff — Foundational Causality to Systemic Gameplay Expansion

## Status

**Active stage-transition handoff.**

Validated integrated baseline on `main`:

```text
commit: f92d98543db5d73c1bb9de47ca7a270ca45eea54
RESULT: 104 PASS / 104 TOTAL
PASS headless_suite (104 tests)
```

This handoff transfers the project from a phase dominated by **proving fundamental runtime causality/ownership boundaries** into a phase dominated by **composing those foundations into richer persistent player-visible gameplay**.

Asset modeling and 3D production are being handled in parallel and are intentionally outside this handoff unless a runtime scenario needs a temporary/test representation.

---

# 1. Objective

The next agent should make Wilson Shipwrecked feel increasingly like **one continuous autonomous living simulation**, rather than a collection of separately validated subsystem demos.

Primary question:

> Can existing drives, perception, beliefs, habits, projects, actors, environment, motion, physics, learning and player influence combine into coherent situations whose history remains visible and behaviorally legible?

The default direction is no longer:

```text
find another foundation boundary
→ invent infrastructure
→ prove it in isolation
```

Prefer:

```text
choose a representative player-visible situation
→ compose existing primitives
→ identify the exact missing semantic pressure
→ add the smallest reusable primitive only if required
→ validate the whole causal sequence
```

---

# 2. Required reading

Read the smallest bundle needed for the chosen scene.

Start with:

1. `AGENTS.md`
2. `docs/README.md`
3. `docs/DISCOVERY_STATUS.md`
4. `docs/PRODUCT.md`
5. `docs/BEHAVIORAL_MODEL.md`
6. `docs/SCENE_VALIDATION.md`
7. `docs/brainstorming/representative-scene-catalog.md`

For runtime ownership/orchestration work:

- `docs/ARCHITECTURE.md`
- `docs/SIMULATION_CONTRACTS.md`
- `docs/SIMULATION_ORCHESTRATION.md`
- `docs/MUTATION_AUTHORITY.md`

Then read only the affected domain appendices/contracts.

Do not treat older handoffs as current authority. They are historical evidence for how the present baseline was reached.

---

# 3. What is already proven

Do not reopen these areas by default.

## Common bootstrap / restore / runtime composition

```text
production new run ────────┐
deterministic scenario ────┼→ SimulationBootstrapDefinition
simulation snapshot ───────┘
                                 ↓
                      SimulationOwnerBootstrapper
                                 ↓
                      authoritative owners
                                 ↓
                      RunRuntimeComposer
                                 ↓
                      reconstructible runtime
```

`NewRunDefinition` and scenario definitions are bootstrap input, not runtime authority. `PlayerProfile` remains outside current-run simulation composition.

## Autonomous action causality

```text
perception / drive / project / habit pressure
→ decision
→ committed CurrentIntention
→ semantic movement
→ matching ARRIVED
→ authored ActionExecution
→ commit
→ ActionOutcome
→ validated World mutation
→ WorldEvent + SemanticChangeSet
→ grounded consequences
→ perception / learning / reconsideration
```

Godot motion does not directly mutate semantic World truth.

## Physical observation and body consequence

```text
Godot physical observation
!= admitted semantic WorldEvent
!= authored consequence policy
!= WilsonBodyState mutation
!= Wilson perception/belief/memory
```

Real `RigidBody3D` contact, authored injury and falling-body threat response are already validated.

## World truth versus Wilson knowledge

```text
World truth
!= Wilson observation
!= Wilson belief
```

A hidden property change can occur while Wilson is absent; his belief remains stale until accessible perceptual evidence arrives. Mutually exclusive property beliefs are then reconciled from perception, not synchronized from World truth.

## Immediate threat and continuity

`HazardProjection` is not Wilson knowledge. Wilson acts from `PerceivedThreat` grounded in accessible evidence.

An ordinary current intention can be temporarily suspended by an authored immediate-threat commitment and restored after defensive completion. This is a single narrow suspended-intention semantic, **not a generic intention stack**.

## Habits

```text
current perceived context
!= learned HabitStore
```

Current perceptual evidence may derive a semantic cue; that cue may activate a learned habit candidate. Perception is not cached into the habit store and hidden World state must not directly activate habits.

## Presence attribution

```text
player-private intent
!= World consequence
!= Wilson perception
!= causal attribution
```

Presence learning can follow a perceived consequence through authored attribution. Private player intent is not evidence by itself.

## Non-Wilson actors

Gerald has separate actor state and actor-relative relationship state. Non-Wilson relationship truth is not Wilson cognition. Shallow actor destination choice, physical transit and semantic arrival commit are validated without introducing a universal NPC AI framework.

---

# 4. Representative verticals already closed

The following scenes are evidence, not work to redo:

- production new-run autonomous flow;
- Long Way Around / remembered route preference;
- Gerald relationship-conditioned behavior;
- real physical accident authoring;
- post-accident Wilson learning and later route avoidance;
- early-vs-late player intervention causal windows;
- physical falling-body observation to defensive motion;
- shallow non-Wilson physical locomotion;
- Presence causal attribution from perceived player-caused consequence;
- learned habit activation from current perception;
- threat interruption followed by physical resumption of the prior activity;
- unseen World property change followed by later perception and belief reconciliation.

These collectively establish the foundation needed for the next phase.

---

# 5. New phase: systemic gameplay expansion

The next agent should work backward from **player-visible situations** that combine existing systems.

High-value pressure areas:

## A. Needs and routines over time

Examples:

```text
wake
→ habitual check / current need
→ obtain food or fail
→ energy/comfort pressure changes
→ optional activity or project
→ interruption
→ later continuation
```

Do not create a separate routine owner unless representative evidence proves one is necessary. The behavioral model already treats routines as visible sequences emerging from contexts, habits and intentions.

## B. Multi-step projects with visible partial progress

Desired shape:

```text
project attractive
→ choose contribution
→ locate/acquire material
→ transport
→ contribute
→ partial World progress persists
→ interruption / competing need
→ later return
→ completion or abandonment pressure
```

Projects are already first-class. Prefer exercising their composition with movement/resources/actions rather than redesigning project architecture.

## C. Actor interference with Wilson activity

Examples:

- Gerald competes for or approaches a resource relevant to Wilson;
- Wilson's learned Gerald history changes a preventive action;
- Gerald movement visibly affects Wilson's subsequent choice;
- actor relationship and Wilson association remain separate.

Avoid universal social graphs or deep generic NPC planning without concrete pressure.

## D. Environment/weather changing activity

Examples:

- rain/storm alters comfort or project attractiveness;
- resources become temporarily less useful/available;
- a project or routine is interrupted by environment state;
- Wilson later resumes or re-evaluates rather than blindly restoring stale activity.

## E. Return-to-game historical readability

The product fantasy depends on opening the game and understanding that something happened while away.

Useful pressure:

```text
World progresses
→ Wilson acts / environment changes
→ durable causes remain
→ player returns
→ current scene + Wilson behavior make recent history inferable
```

Do not solve this only with UI narration. First ensure the simulation leaves meaningful persistent traces.

---

# 6. Suggested first representative pressure

A strong first target is a **small living-day sequence** combining existing systems, for example:

```text
Wilson wakes hungry
→ current context/habit points him toward a known food source
→ Gerald or an environmental condition interferes
→ Wilson reacts using current relationship/history/belief
→ hunger is resolved or remains pressing
→ weather/context changes
→ Wilson abandons or redirects an ordinary activity
→ later returns to a partially completed project
```

This exact story is **not required**. Its purpose is to force composition across several existing owners without adding a universal planner.

A smaller first PR may prove one coherent subsection of that sequence if it exposes a real missing primitive.

---

# 7. How to choose work

For every prospective primitive, ask:

1. Which representative player-visible situation requires it?
2. Can the situation already be expressed by composing existing owners/services?
3. If not, what is the smallest missing semantic contract?
4. Which owner, if any, must persist it?
5. Can it be derived instead of stored?
6. Does it preserve bootstrap/restore and headless testability?
7. Does it create systemic reuse beyond one scripted fixture?

If the answer starts with “it would be cleaner to have a generic framework,” that is not sufficient admission pressure.

---

# 8. Explicit anti-goals

Do **not** make the next block about:

- reopening owner architecture;
- a universal `GameState`/`RuntimeState`;
- a broad event bus with mutation authority;
- a generic arbitrary intention stack;
- a universal NPC AI framework;
- a social/relationship graph that collapses actor-relative and Wilson-relative state;
- direct use of `HazardProjection` as Wilson knowledge;
- hidden World truth activating Wilson habits/beliefs;
- player-private intent writing Wilson cognition;
- deep hierarchical planning before representative scenes require it;
- clearing technical-debt lists for their own sake;
- snapshot migration, positional-API cleanup or generalized host composition without product pressure;
- asset/modeling pipeline work in this runtime handoff.

---

# 9. Deferred work that may become relevant

Current deferred pressures include:

```text
snapshot compatibility/migration policy
capture/bootstrap positional API cleanup
drive hysteresis-band memory persistence
Legacy-to-new-Wilson seeding
production host/scene composition generalization
relationship decay/generalization
broader relationship interaction producers
effect-oriented stale intervention rejection
view-cone/orientation passive refresh
negative/absence perceptual evidence
habit disuse/decay/context generalization
route-memory acquisition/decay/generalization
broader collision/fall/grounding consequence policies
mid-interruption save semantics if product persistence requires it
```

Pull one forward only when the chosen gameplay sequence actually requires it.

---

# 10. Validation workflow

Normal runtime workflow remains:

```text
latest main
→ short-lived task branch
→ representative pressure
→ smallest missing primitive if necessary
→ focused tests
→ integrated scenario
→ strict suite
→ PR
→ explicit operator merge authorization
→ squash merge
```

Strict gate:

```powershell
.\tests\run_headless_tests.ps1
```

Any `SCRIPT ERROR`, generic engine `ERROR`, explicit `FAIL`, nonzero exit or missing expected PASS marker is failure even if another PASS line appears.

At handoff creation the validated strict checkpoint is:

```text
RESULT: 104 PASS / 104 TOTAL
PASS headless_suite (104 tests)
```

Do not infer a new expected count without adding registered tests and running the strict suite.

---

# 11. Acceptance criteria for the next block

The next block should be considered successful when:

1. at least one representative sequence composes several existing runtime systems into a coherent autonomous situation;
2. Wilson's behavior remains attributable to perception/history/needs/projects rather than hidden scripting;
3. interruptions and changing context preserve causal continuity;
4. persistent World/history changes visibly affect later behavior;
5. no new universal framework is introduced without demonstrated scene pressure;
6. focused and integrated regressions cover the new semantics;
7. the strict suite remains green;
8. any durable architectural contract discovered during implementation is updated in its existing canonical owner.

A useful qualitative exit condition is:

> Opening the game should increasingly look like Wilson has been living, not like a test harness has just selected the next subsystem demonstration.

---

# 12. Open design questions

These are questions, not accepted requirements:

- Which small set of daily-life loops gives the highest player-visible variety first?
- Which project is the best first multi-stage production-quality pressure fixture?
- How much recent-history presentation is needed once the World itself leaves enough readable traces?
- When does routine continuity require more than habits + current intention + projects?
- Which environmental/weather interactions create the strongest combinatorial value with existing actions/projects?
- When does Gerald need more behavior breadth versus more content/rules using the current shallow actor architecture?

Resolve these from representative scene pressure rather than architectural speculation.
