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

## Stage-boundary note

This handoff is one tactical cut inside **Stage 3 — Entertaining autonomous diorama** from `DEVELOPMENT_STAGES.md`.

Completing this handoff does **not** by itself complete Stage 3 or authorize advancing to the player/Presence stage.

After the pressures in this handoff are closed, Stage 3 still needs to demonstrate, in narrow living-scene form where not already proven:

```text
quiet preference / non-utility personal behavior
physical experimentation / discovery
embodied semantic action/reaction timing
modest functional content alternatives
```

Those may be handled by one or more later finite Stage-3 handoffs. Stage 6 expands these families; it should not introduce the core vocabulary for the first time.

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
docs/DEVELOPMENT_STAGES.md
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

This does **not** mean presentation semantics can be postponed. Primitive animation/pose/gaze/timing is valid whenever needed to prove that a semantic action or reaction is legible.

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

Presentation is non-authoritative, but later Stage-3 work must preserve enough semantic time for important action/reaction beats to be visible. Do not infer from the current bubble-based readability that final action/reaction timing can be left entirely to the renderer.

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

# Stage-3 continuation pressure — Embodied semantic readability

This is a **required Stage-3 pressure**, but it does not have to be implemented inside the same PR as idle/Gerald/history unless that PR naturally exposes the need.

The problem to solve is temporal, not artistic:

```text
important semantic event
→ Wilson notices / acts / reacts
→ player must have time to perceive that meaning
→ only then should unrelated visible behavior replace it
```

Examples:

```text
coconut falls / rolls
→ Wilson orients
→ brief surprise/confusion beat
→ then continues or investigates
```

```text
experiment fails
→ frustration/inspection/recovery beat
→ then next tactic begins
```

Keep distinct:

```text
presentation-only motion
    blink / breathing / decorative idle variation
    → renderer-owned, non-blocking

semantic expression beat
    orient / surprise / hesitation / recoil / celebration / frustration /
    inspection / anticipation / recovery
    → may occupy Wilson for authored semantic time
```

Do not make concrete animation completion authoritative. Preferred direction:

```text
semantic lifecycle / duration / checkpoints / interruption
→ presentation adapter
→ animation / pose / gaze / audio
```

A missing or replaced animation asset must not change the authoritative outcome or deadlock headless execution.

Immediate threats may interrupt appropriate ordinary expression beats through explicit semantics.

---

# Stage-3 continuation pressure — One real experiment/discovery loop

Before Stage 3 completes, the living simulation should contain at least one narrow uncertainty-driven physical investigation beyond generic known inspection.

Desired causal shape:

```text
unresolved object/property/effect
→ Wilson has reason to investigate
→ grounded physical attempt
→ meaningful result / partial progress / counterevidence
→ expectation/belief update
→ later tactic or preference may change
```

This is the first living proof of the `Scientific Method` phenomenon family, not a demand for broad content coverage in the current handoff.

Avoid a hidden recipe script or a random discovery roll after an already-observed result.

---

# Stage-3 continuation pressure — Quiet personal behavior

Before Stage 3 completes, prove at least one `Good Chair`-like low-stakes behavior attributable to Wilson's preference/history rather than direct need relief or project optimization.

The point is not a specific chair/rock. The point is that Wilson can visibly choose something because **he** likes/values/does it, then later allow other pressures to interrupt or compete with that tendency.

---

# Player intervention / Presence — intentionally later in Stage 3

The player-intervention and Presence-attribution foundations already exist.

Do not make them the first next feature.

First make the autonomous island interesting enough that the player has something worth perturbing.

Once the autonomous scene has enough Stage-3 vocabulary, a small **risk probe** may be introduced before Stage 4 formally becomes active, for example:

```text
Wilson establishes an expected arrangement
→ player moves one supported object
→ Wilson later encounters the mismatch
→ reaction/search/attribution remains legible
```

Such a probe is allowed to expose integration risk. It does not mean Stage 4 has begun or that the autonomous Stage-3 gate is complete.

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

World-space bubble/emote remains useful as temporary calibration presentation.

Rules:

- large enough to read at gameplay camera distance;
- project real semantic state/events;
- do not invent hidden rationale;
- strange choices may be funny, but should not look like silent AI failure simply because presentation gives no cue;
- do not use the bubble as a substitute for action/reaction timing that should eventually be embodied.

Do not attach permanent text labels to every object.

---

# Suggested implementation order for this handoff

The next agent may use multiple internal slices, but the operator does **not** want manual validation after each one. Use focused headless checks during implementation and ask for the full gate/manual observation only when the composed cut is ready.

Recommended order:

```text
Slice A — bounded idle → Stimulation acceleration
Slice B — one Gerald→World→Wilson interference
Slice C — one learning/history consequence affecting recurrence
Slice D — optional post-project maintenance/weather consequence if naturally supported
Slice E — compact presentation tweaks only where needed for readability
```

Do not silently expand this handoff to implement all remaining Stage-3 continuation pressures. Once its completion condition is met, update the stage status evidence and prepare the next finite Stage-3 handoff rather than recursively extending the session.

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

Use the Stage-3 manual maturity vocabulary from `DEVELOPMENT_STAGES.md`; this handoff should move the playground from merely interesting toward recountable/memorable situations.

---

# Completion condition for this handoff

Do not finish merely because Stimulation gained another multiplier.

This **handoff** is complete when the living island demonstrates all of the following in one coherent baseline:

1. **less dead idle** — inactivity creates bounded anti-stagnation pressure through existing Stimulation semantics;
2. **meaningful Gerald presence** — Gerald causes at least one Wilson-visible consequence rather than only waypoint travel;
3. **history matters** — a grounded experience changes a later choice/context response in the same run;
4. **post-project life** — after the shelter is complete, Wilson still has understandable optional/contextual activity rather than mostly inert waiting;
5. **causal legibility** — the operator can see what changed without a large debug wall;
6. **no authority leaks** — scene scripts/presentation do not become gameplay owners;
7. **strict validation green** — focused tests and full strict suite pass;
8. **manual observation accepted** — operator considers the resulting loop coherent/interesting enough to continue Stage 3;
9. **documentation updated** — record actual durable contract changes and create a next Stage-3 handoff if unresolved Stage-3 maturity pressures remain.

Do **not** mark Stage 3 complete solely from this list. Stage completion is governed by `DEVELOPMENT_STAGES.md` and additionally requires the remaining Stage-3 vocabulary such as embodied semantic readability, a narrow experiment/discovery loop and quiet personal/non-utility behavior where not yet demonstrated.

---

# Anti-goals

Do not spend this handoff on:

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
player intervention as primary novelty before autonomous behavior is worth perturbing
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
6. Which next Stage-3 slice should come first after this handoff: embodied reaction timing, experiment/discovery, or quiet preference?

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
