# Representative Scene Validation

## Purpose

This document preserves the scene-driven validation work used to reduce Wilson's behavioral model before architecture design.

The representative scene catalog is treated as a **behavioral test suite**, not as a list of scripted scenes that must all be authored exactly as written.

The design question is:

> What persistent state and behavioral capabilities must exist for scenes like these to emerge, vary and leave consequences?

This document contains:

1. the 40-scene catalog inventory and triage;
2. the Must-have scene × system matrix;
3. the regression suite used to try to break the minimum behavioral model;
4. conclusions, cuts and remaining open work.

`BEHAVIORAL_MODEL.md` contains the resulting functional model.

---

## 1. Representative scene inventory and triage

Triage categories:

- **M — Must-have:** equivalent behavior should constrain the core simulation;
- **S — Strong:** highly desirable but should not determine the first minimum model alone;
- **E — Expensive/Later:** strong north-star/content case whose cost or specificity makes it a later requirement;
- **R — Reshape:** useful phenomenon but the original premise should be changed.

> Historical correction: an earlier note said there were 24 Must-have scenes. The actual marked list contains **23**. The matrices below use the 23 real Must-haves rather than promoting a scene only to satisfy the mistaken count.

| # | Scene | Triage | Principal test |
|---:|---|:---:|---|
| 1 | The Good Chair | M | preference, attachment, habit, quiet life |
| 2 | Breakfast First | S | habitual routine versus nearby opportunity |
| 3 | The Long Way Around | M | learned danger, spatial history, excessive caution |
| 4 | Scientific Method | M | iterative physical experimentation and partial feedback |
| 5 | The Perfectly Good Bowling Ball | M | property-based absurd but valid solution |
| 6 | Absolutely Not | M | suggestion is influence, never command |
| 7 | Fine! | S | limited insistence, irritation, compliance/refusal |
| 8 | The Missing Spoon | M | spatial expectation, anomaly and presence interpretation |
| 9 | The Benefactor | M | repeated help changes expectation/dependency |
| 10 | The Traitorous Fire | M | instance-specific grudge versus present utility |
| 11 | Gerald | M | persistent individual animal relationship and running gag |
| 12 | Victory Lap | S | transient triumph causing secondary bad decision |
| 13 | One More Piece | M | project continuation versus urgent hunger |
| 14 | Roof or Table? | M | competing projects, preference, suboptimal choice |
| 15 | Interior Design | M | aesthetic action/project without survival utility |
| 16 | The Laundry Problem | S | domestic frustration, weather adaptation |
| 17 | Storm Priorities | M | urgency, attachment and competing losses |
| 18 | The Umbrella | S | rare object, mistaken expectations, environmental comedy |
| 19 | Midnight Noise | S | night investigation, fear and false alarm |
| 20 | The Mushroom | M | hunger, uncertainty, curiosity and risk |
| 21 | Faster Than Walking | M | self-invented physical shortcut, risk and learning |
| 22 | Too Hot | M | overgeneralized danger and excessive caution |
| 23 | The Bottle | M | unresolved interest surviving interruption/time |
| 24 | Rotten Luck | S | spoiled resource redirects ordinary day |
| 25 | Inspection Day | M | preventive behavior becoming habit |
| 26 | Someone Moved the Rock | M | habit disruption, attachment and intervention detection |
| 27 | The Gift Test | E | deliberate test of unseen presence |
| 28 | Miracle Fatigue | S | expected intervention, omission and recovery of autonomy |
| 29 | Sabotaged Storage | M | pattern of anomalies, attribution, distrust and adaptation |
| 30 | The Unwanted Rescue | R | player help misunderstands Wilson; original physical timing should be rewritten |
| 31 | The Signal Fire | M | rare directed opportunity and intervention decision |
| 32 | Not Now, Humanity | R | directed scene broken by ordinary autonomy; replace toilet-like need |
| 33 | The Neighbor | E | additional area, carrying priorities and provenance |
| 34 | Captain Wilson | E | additional-area tone, roleplay and rare ball-reference |
| 35 | The Statue of Gerald | S | history becoming an authored contextual project/artifact |
| 36 | Gerald Is Missing | S | negative-valence attachment and quiet absence payoff |
| 37 | The Falling Palm | M | immediate threat, near death and intervention window |
| 38 | The Brilliant Shortcut | M | learned shortcut, risk and legible emergent death |
| 39 | I Hate Mushrooms | S | resurrection consequence without conscious death memory |
| 40 | The Experiment | E | advanced deliberate presence test / fourth-wall-adjacent payoff |

### Reshape notes

#### Scene 30 — The Unwanted Rescue

Preserve the phenomenon **player assistance can misunderstand Wilson**, but avoid an object vanishing from Wilson's reach after he has physically committed to it.

Preferred forms:

- Wilson prepares a risky route and the player moves the target before he begins, making the preparation useless; or
- Wilson positions an object as support and the player removes it thinking it is an obstacle, making the plan less safe and angering Wilson.

Trust must respond to Wilson's perceived outcome rather than the player's true intention.

#### Scene 32 — Not Now, Humanity

Preserve the phenomenon **ordinary autonomous pressure can destroy a directed event**, but avoid adding a toilet need merely to create interruption.

Preferred replacement:

- an aircraft/boat opportunity appears;
- Gerald steals exposed food at exactly the wrong time;
- Wilson must choose between the once-in-a-month rescue opportunity and his long-running rival.

This uses accumulated history rather than Sims-like need proliferation.

---

## 2. Must-have phenomenon families

The 23 Must-have scenes reduce to a smaller family of behavioral requirements:

1. **Preference without utility** — Good Chair, Interior Design.
2. **Emotional spatial/instance history** — Long Way Around, Traitorous Fire, Too Hot.
3. **Physical exploration and learning** — Scientific Method, Bowling Ball, Faster Than Walking.
4. **Autonomy against player influence** — Absolutely Not.
5. **Learning about the player/presence** — Missing Spoon, Benefactor, Moved Rock, Sabotaged Storage.
6. **Persistent relationship** — Gerald.
7. **Projects integrated into ordinary life** — One More Piece, Roof or Table?.
8. **World pressure exposing values** — Storm Priorities.
9. **Uncertainty + risk** — Mushroom.
10. **Persistent unresolved interest** — Bottle.
11. **Habit formation** — Inspection Day.
12. **Drama + intervention / God Power** — Signal Fire, Falling Palm, Brilliant Shortcut.

The key implication is that many representative scenes should emerge from shared systems rather than being implemented as scene-specific logic.

---

## 3. Must-have matrix — cognition, motivation and history

Legend:

- `●` essential for the scene's behavioral identity;
- `◐` materially important;
- `○` useful support/variation;
- `—` not material.

Columns:

- `ATT` attention/contextual salience;
- `DRV` drives;
- `TRT` stable traits;
- `ASC` association (`valence`, `attachment`);
- `MEM` episodic/history dependence;
- `KNW` beliefs/knowledge;
- `EXP` expectation/prediction;
- `HAB` habit.

| # | Scene | ATT | DRV | TRT | ASC | MEM | KNW | EXP | HAB |
|---:|---|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| 1 | Good Chair | ◐ | ◐ | — | ● | ◐ | ○ | ○ | ● |
| 3 | Long Way Around | ◐ | ○ | ◐ | ● | ● | ● | ● | ◐ |
| 4 | Scientific Method | ● | ○ | ● | ○ | ◐ | ● | ● | — |
| 5 | Bowling Ball | ◐ | ○ | ◐ | ◐ | ◐ | ● | ● | ○ |
| 6 | Absolutely Not | ● | ● | ● | ○ | ○ | ◐ | ◐ | — |
| 8 | Missing Spoon | ● | ○ | — | ◐ | ● | ◐ | ● | ● |
| 9 | Benefactor | ◐ | ◐ | ● | — | ● | ● | ● | ◐ |
| 10 | Traitorous Fire | ◐ | ◐ | — | ● | ● | ● | ● | ○ |
| 11 | Gerald | ● | ◐ | ○ | ● | ● | ● | ● | ● |
| 13 | One More Piece | ◐ | ● | — | ○ | ○ | ◐ | ◐ | — |
| 14 | Roof or Table? | ● | ◐ | ◐ | ● | ◐ | ● | ● | — |
| 15 | Interior Design | ● | ● | — | ● | ◐ | ◐ | ● | ◐ |
| 17 | Storm Priorities | ● | ● | ◐ | ● | ◐ | ● | ● | ◐ |
| 20 | Mushroom | ● | ● | ● | ◐ | ● | ● | ● | — |
| 21 | Faster Than Walking | ● | ◐ | ● | ◐ | ● | ● | ● | ◐ |
| 22 | Too Hot | ● | ● | ◐ | ◐ | ● | ● | ● | ◐ |
| 23 | Bottle | ● | ● | ● | ◐ | ● | ● | ● | — |
| 25 | Inspection Day | ● | ◐ | — | ◐ | ● | ● | ● | ● |
| 26 | Someone Moved the Rock | ● | ◐ | — | ● | ● | ● | ● | ● |
| 29 | Sabotaged Storage | ● | ◐ | — | ◐ | ● | ● | ● | ◐ |
| 31 | Signal Fire | ● | ◐ | ○ | ○ | ◐ | ● | ● | ◐ |
| 37 | Falling Palm | ● | ● | ◐ | ○ | ○ | ● | ● | ○ |
| 38 | Brilliant Shortcut | ● | ◐ | ● | ◐ | ● | ● | ● | ● |

---

## 4. Must-have matrix — intention, emotion, player and persistence

Columns:

- `INT` current/suspended intention and competition;
- `PRJ` project;
- `EMO` transient emotion/reaction;
- `CAU` causal attribution;
- `REL` unseen-presence relationship;
- `PLY` player suggestion/intervention;
- `GP` God Power calibration relevance;
- `LLM` optional LLM leverage, never dependency;
- `CONS` persistent consequence.

| # | Scene | INT | PRJ | EMO | CAU | REL | PLY | GP | LLM | CONS |
|---:|---|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| 1 | Good Chair | ◐ | — | ○ | — | — | ◐ | ○ | ○ | ● |
| 3 | Long Way Around | ◐ | — | ● | ○ | — | ◐ | ○ | ○ | ● |
| 4 | Scientific Method | ● | — | ◐ | — | — | ◐ | ○ | ○ | ● |
| 5 | Bowling Ball | ● | — | ◐ | — | — | ◐ | ◐ | ○ | ● |
| 6 | Absolutely Not | ● | — | ◐ | — | ◐ | ● | ○ | ◐ | ◐ |
| 8 | Missing Spoon | ◐ | — | ◐ | ● | ● | ● | ● | ◐ | ● |
| 9 | Benefactor | ● | ● | ◐ | ◐ | ● | ● | ● | ◐ | ● |
| 10 | Traitorous Fire | ● | ◐ | ● | ○ | — | ◐ | ○ | ○ | ● |
| 11 | Gerald | ● | — | ● | ◐ | — | ◐ | ○ | ◐ | ● |
| 13 | One More Piece | ● | ● | ◐ | — | — | ● | ◐ | ○ | ● |
| 14 | Roof or Table? | ● | ● | ◐ | — | ◐ | ● | ◐ | ◐ | ● |
| 15 | Interior Design | ● | ● | ◐ | — | — | ● | ◐ | ○ | ● |
| 17 | Storm Priorities | ● | ◐ | ● | — | — | ● | ● | ◐ | ● |
| 20 | Mushroom | ● | — | ● | ◐ | ◐ | ● | ◐ | ◐ | ● |
| 21 | Faster Than Walking | ● | ○ | ● | ◐ | — | ◐ | ◐ | ○ | ● |
| 22 | Too Hot | ● | — | ● | ◐ | ◐ | ● | ◐ | ○ | ● |
| 23 | Bottle | ● | — | ◐ | — | — | ● | ◐ | ◐ | ● |
| 25 | Inspection Day | ◐ | ◐ | ○ | — | — | ◐ | ○ | ○ | ● |
| 26 | Someone Moved the Rock | ● | — | ◐ | ● | ● | ● | ● | ◐ | ● |
| 29 | Sabotaged Storage | ● | ● | ● | ● | ● | ● | ● | ● | ● |
| 31 | Signal Fire | ● | ◐ | ● | — | — | ● | ● | ◐ | ● |
| 37 | Falling Palm | ● | — | ● | ○ | — | ● | ● | ○ | ● |
| 38 | Brilliant Shortcut | ● | — | ● | ◐ | — | ● | ● | ○ | ● |

### Coverage reading

Counting `● + ◐` as materially important produced the following approximate coverage across the 23 Must-haves:

| Concept | Material scenes | Reading |
|---|---:|---|
| Attention / salience | 23 | universal substrate |
| Intention competition | 23 | universal substrate |
| Expectations | 22 | almost universal |
| Knowledge / beliefs | 22 | almost universal |
| Transient emotion/reaction | 21 | near-universal expression/modulation |
| Memory/history | 20 | core continuity |
| Drives | 19 | core motivation |
| Associations | 17 | core personal continuity |
| Habits | 14 | recurring learned behavior |
| Traits | 13 | cross-cutting modulators |
| Projects | 9 | specialized but indispensable |
| Causal attribution | 9 | specialized anomaly interpretation |
| Presence relationship | 8 | product-specific vertical |

The exact counts are less important than the causal roles. Concepts used by fewer scenes may still be indispensable because no other concept can produce those fantasies.

---

## 5. Best integration/reference scenes

### Good Chair — anti-overengineering baseline

A successful simulation must be interesting when almost nothing happens.

Required phenomena:

```text
comfort
+ preference / positive association
+ attachment
+ habit
+ contextual choice
```

If the game only looks alive during danger, rare events or player intervention, it fails this test.

### Scientific Method — knowledge-system reference

Required flow:

```text
goal
→ experiment
→ feedback
→ belief update
→ next candidate
→ partial progress
→ strategy refinement
```

This is the primary protection against reducing discovery to pair recipes.

### Sabotaged Storage — broad integration reference

Required flow:

```text
project need
→ expected storage state
→ prediction error
→ search
→ displaced objects become salient
→ arrangement/history comparison
→ pattern across anomalies
→ causal attribution
→ presence belief
→ anger
→ trust update
→ new storage/guard behavior
```

If this scene requires a large collection of scene-specific behavioral hacks, the model is not composing well enough.

### Brilliant Shortcut — fair emergent-death reference

Death should be reconstructable as a legible chain:

```text
known shortcut
+ changed weather/conditions
+ perceived risk
+ alternative route
+ Wilson's choice
+ physical consequence
```

Avoid opaque hidden death RNG.

---

## 6. Regression suite

After deriving the candidate minimum model from Must-haves, a second suite was selected specifically to **break it**.

It contains six Strong catalog scenes plus six missing-category patches.

Regression outcomes are classified:

- **PASS:** current primitives explain the scene;
- **PASS + refinement:** no new broad primitive, but an existing concept needs an explicit capability;
- **FAIL:** a new primitive would be justified.

No regression case currently produces a FAIL.

### Regression matrix

| Case | Required existing concepts | Result | Refinement / conclusion |
|---|---|:---:|---|
| Breakfast First | habit, attention, expectation, intention competition | PASS | Routine can emerge from habits; no routine system |
| Victory Lap | Gerald association/history, joy/excitement, current intention, attention, physical consequence | PASS | Confirms transient positive emotion must alter next action, not only animation |
| Miracle Fatigue | presence belief, trust, dependency, expectation, omission evidence, independence | PASS | Absence of expected help reduces dependency/expectation before belief |
| Statue of Gerald | attachment, history, stimulation, project, authored contextual possibility | PASS | Systemic motivation may select an authored project without procedural infinite crafting |
| Gerald Is Missing | attachment, recurring expectation, habit/routine context, absence evidence | PASS | No loneliness/social drive required; sadness can remain presentation-level candidate |
| I Hate Mushrooms | danger belief, negative association, resurrection rule, inaccessible episode source, transient fear | PASS + refinement | Belief/association may survive when explicit death episode is inaccessible; no subconscious-memory system |
| Self-entertainment | stimulation, affordance, short self-generated intention, feedback/history | PASS | No playfulness trait; micro-goal can be an ordinary short intention |
| Lost favorite object | attachment, expected location/availability, search intention, memory | PASS | No grief system; attachment and violated expectation are sufficient |
| Regret after delayed consequence | meaningful prior choice memory, delayed causal attribution, negative outcome, learning | PASS + refinement | Important episodes may need the meaningful choice among alternatives; no regret stat |
| Fear extinction/recovery | danger belief confidence, repeated safe exposure, association, history | PASS | Contradictory experience drives recovery; no forgiveness/extinction subsystem |
| False superstition | expectation violation, causal attribution error, weak/coincidental evidence, presence belief where relevant | PASS | No superstitiousness trait/system |
| Anticipation/preparation | learned recurring pattern, derived expectation, salience, preparation intention, possible later habit | PASS | No anticipation system; expectation creates preparation behavior |

---

## 7. Regression case details

### 7.1 Breakfast First

Behavior:

```text
wake cue
→ food-storage habit becomes salient
→ nearby ripe fruit creates competing intention
→ habit often wins
```

The existence of a recognizable morning sequence does not justify a `routine state machine`. Recurring cues and several habits can create the visible routine.

**Regression result:** current habit + intention competition model is sufficient.

### 7.2 Victory Lap

Behavior:

```text
long-running Gerald rivalry
→ Wilson finally wins
→ transient triumph/joy
→ taunting/celebration becomes unusually attractive
→ environmental attention is reduced / action becomes careless
→ fall
→ food loss / injury / new history
```

This demonstrates why positive emotion must affect behavior for a short period rather than being only cosmetic.

It does **not** justify an `impulsivity` or `overconfidence` trait.

**Regression result:** transient joy/excitement survives the model.

### 7.3 Miracle Fatigue

Repeated assistance creates:

```text
presence belief high
trust high
intervention expectation high
dependency elevated
```

Wilson encounters effort and waits for help. Nothing happens.

The important learning order is:

```text
expected intervention omitted
→ expectation of help decreases
→ dependency decreases
→ trust may decrease slightly depending on context
→ presence belief changes much more slowly
```

Ordinary player silence should not count unless Wilson had formed a meaningful expectation in that situation.

**Regression result:** no learned-helplessness/self-efficacy stat required.

### 7.4 Statue of Gerald

Requirements:

```text
Gerald attachment high
long rich history
stimulation / comfortable period
available materials
contextually eligible authored decorative project
```

The motivation and subject can be systemic even if the buildable statue form is authored.

This yields the principle:

> Systemic history can select authored content because the current run made it appropriate; the simulation does not need to invent arbitrary build forms.

**Regression result:** project model passes and infinite procedural crafting remains unnecessary.

### 7.5 Gerald Is Missing

Behavior:

```text
Gerald attachment high
+ habitual expectation of Gerald at certain contexts
+ repeated absence
→ Gerald-related cues remain salient
→ checking/search/quiet concern behavior
```

Negative valence does not prevent attachment from making absence meaningful.

No generic loneliness drive is needed.

**Regression result:** strengthens `attachment`; weakens the case for `social/loneliness`.

### 7.6 I Hate Mushrooms

After a mushroom-caused death and resurrection:

```text
explicit conscious death episode unavailable
BUT
danger belief / negative learned association persists
```

Encountering the mushroom type produces intense fear/avoidance even though Wilson cannot narratively explain why.

This is modeled as **consolidated learning surviving inaccessible episodic source**, not as a new subconscious-memory or trauma system.

**Regression result:** current model passes if source accessibility is allowed to differ from belief persistence.

### 7.7 Missing patch — boredom/self-entertainment

Reference behavior:

Wilson is comfortable, sees an affordance with immediate feedback, and invents an unnecessary challenge such as kicking a coconut toward a line or trying to improve a stone-skipping result.

Needed concepts:

```text
stimulation
+ affordance
+ self-generated short intention
+ feedback
```

Repeated play may later create habit/place attachment.

**Regression result:** no `playfulness` trait required.

### 7.8 Missing patch — lost favorite object

Reference behavior:

Wilson looks for a personally important but low-utility object after discovering it missing, searches beyond objective rational value, gradually reduces search intensity, and reacts strongly if it returns.

Needed concepts:

```text
attachment
+ expected location/availability
+ prediction error
+ search intention
+ memory
```

**Regression result:** no grief or possession-drive primitive required.

### 7.9 Missing patch — regret after delayed consequence

Reference behavior:

Wilson chooses a table repair over roof work. Later a storm damages food/bedding because the roof remained incomplete. Wilson looks between the damage and the completed table and visibly recognizes the causal link.

Needed concepts:

```text
meaningful prior choice episode
+ later consequence
+ self-causal attribution
+ transient negative reaction
+ future belief/priority update
```

**Regression result:** no regret stat. Important episodes must retain meaningful choices when later consequences may refer back to them.

### 7.10 Missing patch — fear extinction/recovery

Reference behavior:

Wilson avoids a previously dangerous tide-pool route. Mere time does little because avoidance creates no contrary evidence. Later forced/voluntary safe passages progressively reduce danger confidence. A new crab injury can restore caution quickly because old history remains relevant.

Needed concepts:

```text
danger belief confidence
+ safe contradictory evidence
+ association changing more slowly
+ retained history
```

**Regression result:** no forgiveness/extinction subsystem.

### 7.11 Missing patch — false superstition

Reference behavior:

Two unrelated coincidences recur near a salient ritual or unexplained intervention. Wilson infers a causal relationship with weak/medium confidence and begins acting on it.

Needed concepts:

```text
weak evidence
+ causal attribution
+ mistaken belief
+ confidence
+ optional presence-belief prior
```

The false belief remains Wilson's model, never world truth.

**Regression result:** no `superstitiousness` trait/system.

### 7.12 Missing patch — anticipation/preparation

Reference behavior:

Wilson learns that certain conditions predict Gerald, storms or shore debris and prepares before the event occurs.

Needed concepts:

```text
pattern/history
→ derived expectation
→ opportunity becomes salient early
→ preparation intention
```

Repeated preparation under the same cue may later become a habit.

**Regression result:** no anticipation subsystem.

---

## 8. Regression conclusion

The regression suite did **not** justify another broad psychological primitive.

Instead it strengthened several existing requirements:

1. **Expectations must include expected absence/presence and relevant spatial arrangement.**
2. **Important episodic history may need meaningful prior choices, not only outcomes.**
3. **Learned belief/association may survive when the original episode is no longer consciously accessible.**
4. **Transient positive emotion can materially affect immediate behavior and cause secondary consequences.**
5. **Omission is evidence only when Wilson actually expected something.**
6. **Contradictory lived experience should drive fear recovery more strongly than clock-time decay.**
7. **Systemic history may make bounded authored content contextually eligible without requiring content invention.**

This is strong evidence that the current candidate minimum model is sufficiently expressive for the behavioral discovery stage.

---

## 9. Concepts explicitly rejected after regression

Do not add these as independent primitives without a new scene that demonstrates unique behavioral need:

```text
sanity
global mood / background valence-arousal
persistence
sociability
loneliness
playfulness
safety as accumulating need
cleanliness
orderliness
superstitiousness
faith separate from presence_belief
forgiveness
regret
routine
tradition
environmental ownership
irrationality / stupidity
generic impulsivity
self-efficacy / learned helplessness
grief
trauma/subconscious-memory subsystem
anticipation subsystem
```

The visible behaviors remain desirable; only the extra primitives are rejected.

---

## 10. LLM leverage from scene validation

The representative scenes support an optional LLM as a **bounded contextual variation layer**, not as behavioral authority.

Highest-value cases include:

- ambiguous causal attribution in Missing Spoon / Moved Rock / Sabotaged Storage;
- sparse contextual Gerald callbacks;
- diary compression;
- short reaction lines;
- contextual reweighting among already plausible close project/interpretation candidates.

Low-value or forbidden cases include:

- immediate physical truth;
- death outcome;
- action validity;
- project progress;
- property discovery truth;
- normal emergency response;
- authoritative memory creation.

Initial calibration target:

```text
~70% deterministic interpretation
~30% optional LLM-assisted bounded interpretation
```

This ratio applies only to eligible ambiguous interpretation cases, not all decisions.

---

## 11. God Power implications

The scenes imply at least four qualitative intervention families:

1. **Physically tiny, narratively strong** — move habitual spoon/rock.
2. **Productive assistance** — provide/move useful resources, influence an experiment/project.
3. **Sabotage** — scatter storage, alter a plan, expose possession to risk.
4. **Critical intervention** — rescue opportunity, falling palm, lethal shortcut.

Do not price God Power simply by Wilson's psychological attachment. Physical/causal magnitude and improbability should dominate cost predictability.

The passive non-intervention streak is narratively important because it creates:

```text
observe
→ accumulate capacity
→ encounter meaningful intervention window
→ spend or remain observer
→ live with consequences
```

Exact cost numbers remain later balance work.

---

## 12. Behavioral discovery exit criterion

The behavioral discovery phase is considered essentially complete when:

- the Must-have matrix is covered by shared primitives;
- the regression suite does not require additional broad psychological systems;
- discarded concepts are recorded explicitly;
- remaining questions concern state lifetime/ownership, content vocabulary, balance or architecture rather than unexplained player-visible behavior.

The current work meets that criterion.

### Next design stage

Before choosing engine architecture or schemas, derive a **functional persistent-state inventory** from `BEHAVIORAL_MODEL.md` and this matrix:

- what must persist for seconds, minutes, days, a run, or across resurrection;
- what is authoritative world state versus Wilson interpretation;
- what is derived versus persisted;
- what needs instance/type/category scope;
- what must be available offline;
- what may be summarized/consolidated;
- what content registries/vocabularies are required.

Only after that inventory should architecture/data-model work begin.
