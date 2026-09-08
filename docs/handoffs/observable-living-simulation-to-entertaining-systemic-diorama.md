# Handoff — Observable Living Simulation to Entertaining Systemic Diorama

Status: **ACTIVE**

## Objective

Advance Wilson Shipwrecked from a technically coherent, continuously observable living simulation into a diorama that produces **more varied, legible and memorable situations on its own**.

The previous phase proved that Wilson can continuously:

```text
perceive
→ choose
→ move
→ act
→ satisfy needs
→ progress a persistent project
→ react to weather
→ resume ordinary life
```

and that Gerald can move independently as a shallow actor without becoming another Wilson.

The next problem is no longer “can the systems run together?” It is:

> Can several minutes of autonomous play produce situations that read like small stories rather than a rotation through maintenance meters?

The focus should be **behavioral richness from existing systems**, not foundational architecture expansion.

---

# Starting checkpoint

Start from current integrated `main` after PR #74:

```text
e9cf01aab57a18520a4a2d0a52fa7f3a91a839dd
```

Latest strict local validation reported by the operator before squash integration:

```text
RESULT: 131 PASS / 131 TOTAL
PASS headless_suite (131 tests)
```

Primary calibration scene:

```text
tools/living_simulation/living_simulation.tscn
```

The operator manually validated this scene as coherent and increasingly interesting.

---

# Required reading

Read the smallest bundle first:

```text
AGENTS.md
docs/README.md
docs/DISCOVERY_STATUS.md
this handoff

docs/PRODUCT.md
docs/BEHAVIORAL_MODEL.md
docs/SIMULATION_ORCHESTRATION.md
docs/SIMULATION_CONTRACTS.md
docs/MUTATION_AUTHORITY.md
docs/testing/SCENE_TESTS.md
```

Then inspect:

```text
tools/living_simulation/
src/domain/cognition/
src/domain/actors/
src/application/simulation/
tests/headless/living_*_test.gd
tests/headless/actor_*_test.gd
```

Read specialized domain appendices only when a chosen situation requires them, especially:

```text
docs/DOMAIN_ENVIRONMENTAL_PROTECTION.md
docs/DOMAIN_HAZARD_DYNAMICS.md
docs/DOMAIN_EPISTEMIC_INVESTIGATION.md
docs/DOMAIN_MICRO_LOOP.md
```

## Scope exclusion

Do not make this phase depend on final assets, Blender production or art/modeling pipeline work. Primitive presentation remains sufficient for behavioral calibration unless the operator explicitly changes scope.

---

# What is already proven

Do not rebuild these systems from scratch.

## Wilson continuous loop

Validated in one real Godot scene:

```text
Hunger → seek_food → move → consume → grounded drive relief
Energy → seek_rest → move → rest → grounded drive relief
Stimulation → seek_stimulation → move → inspect curiosity → grounded drive relief
Project → repeated shelter contributions → interruption → later continuation → completion
Weather → clear/rain context → tactical seek cover
```

## Runtime/orchestration

The living phase also closed these important semantics:

```text
one active Wilson ActionExecution unless explicit concurrency policy exists
same intention + same bindings + active execution = continuation
same persistent intention + terminal prior action may start next sequential action
interruptible orphaned post-commit execution is cleared before new intention execution
TACTICAL may win from idle as well as while another intention is active
```

Do not regress these boundaries to make richer behavior easier.

## Gerald

Gerald currently provides:

```text
ActorStateStore runtime state
ActorRelationshipStore actor→Wilson relationship state
authored shallow behavior rules
deferred physical movement through GodotMotionAdapter
semantic place commit only after physical arrival
```

What Gerald does **not** yet provide is a compelling Wilson-visible consequence. That is now useful product pressure.

## Presentation

The scene already has:

```text
readable primitive silhouettes
staged shelter construction
weather lighting/rain
compact calibration overlay
world-space Wilson semantic bubble
1x / 4x / 16x observation controls
```

The operator preferred the compact UI to the earlier duplicate/debug-heavy presentation.

---

# Player-visible findings from the validated playground

The operator observed:

1. Before shelter completion, Wilson alternated coherently among construction, eating, resting, exploration and rain cover.
2. When no stronger pressure existed, returning to the shelter project read naturally.
3. After shelter completion, behavior became flatter: eat/rest/explore/idle dominated because the large persistent objective disappeared.
4. Rain initially exposed a routing bug after project completion; this is now fixed and Wilson seeks cover on later rains even from `none`.
5. Gerald mostly looked like “a bird walking around.” The motion worked, but the player-visible purpose was weak.
6. The campfire was misleading while it had no interaction and was hidden from the final presentation.
7. Large debug UI was noisy; compact observability is preferred.
8. World-space emojis/bubbles are useful if large/readable enough, but should communicate semantic state rather than explain away bad behavior.
9. The current loop is interesting enough to justify moving from infrastructure validation into entertainment/calibration work.

These findings should drive the next cuts.

---

# Primary focus 1 — Idle as bounded boredom pressure

This is the smallest, highest-confidence next improvement.

`BEHAVIORAL_MODEL.md` already defines Stimulation as the anti-stagnation/boredom drive. Do **not** create a separate `BoredomStore`, `IdleSystem` or generic randomness controller.

Desired behavioral shape:

```text
meaningful activity
→ stimulation rises at ordinary authored rate

true idle / no meaningful intention or execution
→ stimulation rises faster
→ optional activity eventually becomes attractive

activity begins
→ idle boost disappears / returns to baseline
```

A simple bounded policy might conceptually support:

```text
normal activity       1.0x stimulation rate
short genuine idle    >1.0x
long genuine idle     higher, capped multiplier
```

Exact numbers are calibration, not canonical semantics.

## Important guards

Do not count these as boredom idle:

```text
Wilson moving toward an admitted intention
active ActionExecution
resting/eating/exploring/building
seek cover movement
meaningful suspended/resuming work state
```

Do not let the multiplier grow without bound.

Do not inject random actions merely because Wilson is idle.

## Acceptance

A headless test should prove that, from otherwise equivalent drive state:

```text
idle Wilson accumulates Stimulation pressure faster than meaningfully occupied Wilson
```

while preserving bounds and deterministic time behavior.

The living scene should visibly spend less time in inert `none` after the shelter is complete.

---

# Primary focus 2 — Give Gerald one meaningful interference loop

Do **not** turn Gerald into a second full cognition stack.

Choose one player-readable interaction where Gerald's ordinary shallow behavior changes Wilson's situation through existing domain semantics.

Good candidate shapes include:

```text
Gerald approaches exposed food
→ food context becomes salient / threatened / displaced
→ Wilson reacts or later learns a Gerald-related expectation/habit
```

or:

```text
Gerald occupies/disturbs a place Wilson values
→ Wilson observes consequence
→ association/relationship/history changes
→ later choice differs
```

or another similarly small loop supported by current systems.

The key requirement is:

> Gerald should cause at least one situation the operator can understand without reading “Gerald: arrivals=N”.

Prefer an ordinary World consequence + perception + cognition path. Avoid a scene script directly telling Wilson to react when Gerald reaches a waypoint.

## Relationship boundary

Keep distinct:

```text
ActorRelationshipStore = Gerald's authored relationship/runtime relation toward Wilson
Wilson AssociationStore/beliefs/habits = Wilson-relative learned meaning about Gerald
```

Do not collapse these into a universal social graph.

---

# Primary focus 3 — Make one learned/history effect visibly change a later choice

The repository already has stronger learning/history foundations than the playground visibly demonstrates.

Select one narrow causal chain:

```text
experience
→ accessible observation
→ belief / association / habit / episode update
→ similar context occurs later
→ Wilson makes a detectably different choice
```

This should be visible during one bounded living-island run.

Strong candidates are those connected to Gerald, weather or repeated optional activity, because they naturally recur.

Do not build a general “personality story engine.” Prove one history-dependent behavioral change first.

## Acceptance

The integrated scenario should be able to distinguish:

```text
before relevant experience
vs
later repeated context after learning/history
```

through semantic state/choice, not pixels.

---

# Secondary focus — Environmental protection/degradation if it enriches the same story

The domain/runtime already supports much more than the current playground exposes:

```text
weather
→ environmental response
→ component/binding degradation
→ effective protection changes
→ exposure changes
→ structural relation failure where authored
```

Only pull this forward if it supports the same living narrative rather than becoming a separate engineering project.

A useful player-visible shape could be:

```text
shelter complete
→ repeated weather slowly worsens protection
→ Wilson eventually has reason to repair/maintain it
```

This is attractive because it gives a completed project a **life after completion**, but it should not be forced into the first slice if the existing authoring path requires too much unrelated work.

Do not make incomplete shelter automatically count as full cover unless domain semantics explicitly support that configuration.

---

# Player intervention / Presence — intentionally later in this phase

The player-intervention and Presence-attribution foundations already exist.

Do not make them the first next feature.

First make the autonomous island interesting enough that the player has something worth perturbing.

Once the autonomous scene has:

```text
idle recovery
+ one meaningful Gerald interference
+ one visible learned/history consequence
```

then a small player intervention can be introduced to ask:

> Does adding the external Presence create a third causal participant, or merely override the simulation?

Keep player-private intent separate from Wilson perception/attribution.

---

# Presentation policy

Keep the current compact approach.

## UI

The operator explicitly preferred the reduced right-side panel. Do not restore duplicate walls of debug text by default.

The always-visible panel should prioritize only:

```text
speed
time/weather
current readable intention
need pressures
main persistent objective if any
small number of recent meaningful transitions
Gerald status only if currently useful
```

Deeper diagnostics can remain available through traces/tests or optional debug surfaces rather than occupying the whole viewport.

## Wilson bubble

World-space bubble/emote remains useful.

Rules:

- large enough to read at gameplay camera distance;
- project real semantic state/events;
- do not invent hidden rationale;
- strange choices may be funny, but should not look like silent AI failure simply because presentation gives no cue.

Do not attach permanent text labels to every object.

---

# Suggested implementation order

The next agent may use multiple internal slices, but the operator does **not** want manual validation after each one. Use focused headless checks during implementation and ask for the full gate/manual observation only when the composed cut is ready.

Recommended order:

```text
Slice A — bounded idle → Stimulation acceleration
Slice B — one Gerald→World→Wilson interference
Slice C — one learning/history consequence affecting recurrence
Slice D — optional post-project maintenance/weather consequence if naturally supported
Slice E — compact presentation tweaks only where needed for readability
```

Do not stop after each slice for operator approval unless a design decision genuinely cannot be resolved from existing product/domain guidance.

---

# Testing strategy

## During implementation

Use small focused headless tests for each semantic primitive.

Examples:

```text
idle stimulation acceleration is bounded/deterministic
meaningful activity suppresses idle acceleration
Gerald interference commits through ordinary World semantics
Wilson only reacts after accessible perception
history state changes a later candidate/selection
```

## Integrated scene test

Extend or add one living-island scenario proving the combined causal chain.

Do not assert pixels. Assert semantic outcomes and grounded physical facts.

## Long-run

Preserve the existing accelerated long-run pressure. It should continue detecting:

```text
project starvation
runaway needs
intention oscillation
multiple active Wilson executions
stuck/invalid movement
Gerald locomotion failure
clock drift
unbounded trace growth
```

Add only a small number of new long-run guards that correspond to the new entertainment loop. Do not turn the long-run into a brittle script of one expected story.

## Manual gate

When the full slice is ready, ask the operator to run:

```powershell
.\tests\run_headless_tests.ps1
```

Then observe the final living scene rather than validating every internal slice separately.

The manual question is not “did every feature occur on cue?” It is:

> Did several minutes produce understandable variation, interference and at least one moment that felt like a small story?

---

# Completion condition for this handoff

Do not finish merely because Stimulation gained another multiplier.

This handoff is complete when the living island demonstrates all of the following in one coherent baseline:

1. **less dead idle** — inactivity creates bounded anti-stagnation pressure through existing Stimulation semantics;
2. **meaningful Gerald presence** — Gerald causes at least one Wilson-visible consequence rather than only waypoint travel;
3. **history matters** — a grounded experience changes a later choice/context response in the same run;
4. **post-project life** — after the shelter is complete, Wilson still has understandable optional/contextual activity rather than mostly inert waiting;
5. **causal legibility** — the operator can see what changed without a large debug wall;
6. **no authority leaks** — scene scripts/presentation do not become gameplay owners;
7. **strict validation green** — focused tests and full strict suite pass;
8. **manual observation accepted** — operator considers the resulting loop coherent/interesting enough to advance;
9. **documentation updated** — record actual durable contract changes and prepare the next handoff only when another stage is truly beginning.

---

# Anti-goals

Do not spend this phase on:

```text
new universal AI architecture
second full Wilson cognition for Gerald
generic social graph framework
random behavior injected solely to avoid idle
final asset production
final UI art pass
large content explosion
Director-driven scripted stories as a substitute for systemic situations
LLM-dependent behavior correctness
player intervention before autonomous behavior is worth perturbing
rewriting established authority boundaries without representative evidence
```

Do not confuse “more things happening” with “more interesting causality.”

---

# Open calibration questions

These are intentionally not pre-decided:

1. How quickly should idle accelerate Stimulation before it feels restless rather than alive?
2. Which Gerald interference is clearest and funniest with the smallest semantic addition?
3. Should the first visible learned consequence be a belief, association or habit?
4. Does a completed shelter need maintenance/repair immediately, or is richer optional behavior enough for the next cut?
5. How much irrational/suboptimal behavior reads as character before it reads as a bug?

Resolve these through representative scene pressure and bounded tests, not abstract subsystem design.

---

# Working style

This is a calibration-heavy integration phase.

- start from latest `main`;
- use one short-lived task branch per coherent vertical or one bounded multi-slice branch when the slices only make sense as one final scene;
- keep the living scene runnable throughout;
- prefer existing systems and authored content over new infrastructure;
- use focused tests during internal slices;
- run the full strict gate only for the composed checkpoint when practical;
- do not ask the operator to manually validate every slice;
- create a PR when the cut is coherent;
- never merge without explicit operator authorization;
- avoid recursive polish: choose a meaningful session objective and stop once its acceptance condition is met.
