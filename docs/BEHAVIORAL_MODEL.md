# Wilson Behavioral Model

## Status and purpose

This document records the current **functional behavioral model** discovered through product interviews, psychology research, representative-scene analysis, and scene regression.

It is deliberately **not an implementation architecture or data schema**. Names such as `belief`, `association`, `habit`, `project`, `presence_belief`, and numeric ranges describe behavioral requirements and useful conceptual dimensions. Architecture, storage ownership, update formulas, classes, schemas, algorithms, and engine boundaries remain later work.

This document supersedes older provisional psychology notes in `PRODUCT.md` and `SIMULATION.md` where they conflict with it.

The design standard is:

> Wilson should make choices that are attributable to what he notices, wants, believes and remembers, while still being capable of inefficiency, contradiction, surprise and comedy.

The behavioral model should remain as small as possible. A proposed psychological variable should not be admitted merely because it sounds human; it should materially change desirable player-visible scenes in a way that existing concepts cannot explain.

---

## 1. Functional behavioral loop

The current minimum explanatory loop is:

```text
WORLD
  ↓
ATTENTION / SALIENCE
What enters Wilson's consideration?
  ↓
KNOWLEDGE + HISTORY
What does Wilson think is true, and what happened before?
  ↓
EXPECTATION
What does Wilson predict will happen?
  ↓
MOTIVATIONAL PRESSURES
What matters now?
  ↓
CANDIDATE INTENTIONS
What plausible things might Wilson do?
  ↓
COMPETITION
Which intention wins now?
  ↓
ACTION
  ↓
OUTCOME
  ↓
REACTION + LEARNING + PERSISTENT CONSEQUENCE
```

A shorter design rule is:

```text
possible
→ noticed
→ plausible
→ desired
→ competes
→ selected
→ acted
→ observed
→ learned
```

This is a functional description, not a mandated runtime pipeline.

---

## 2. World truth versus Wilson belief

The simulation has authoritative world truth. Wilson does not automatically know it.

Keep these concepts distinct:

- **world truth:** actual properties, state, locations, causes and effects;
- **Wilson belief/knowledge:** what Wilson currently thinks is true;
- **expectation:** a prediction derived from beliefs, history and current context;
- **player knowledge:** what the player has discovered;
- **LLM context:** a bounded projection used for an optional request.

This separation is required for mistaken expectations, discovery, superstition, risk, surprise and comedy.

Example:

```text
WORLD:
pumice hardness = LOW

WILSON BELIEF:
stone-like object probably hard
confidence = MEDIUM

EXPECTATION:
striking the coconut should produce useful impact
```

The resulting failure can revise Wilson's belief without changing world truth.

---

## 3. Attention and contextual salience

Wilson must not evaluate every object and every possible action globally.

The world first produces a **small salient set**. Salience is derived from context rather than stored as a permanent global score.

Important influences include:

- proximity;
- visibility;
- current intention;
- need relevance;
- novelty;
- attachment;
- expected threat;
- unexpected change / prediction error;
- opportunity urgency;
- habitual expectation;
- recent/relevant memory;
- event or directed-scene framing.

Conceptually:

```text
WORLD
↓
small salient set
↓
candidate intentions
↓
competition
```

Attention is required for distraction, interruption and behavioral readability. Do not add a separate `distractibility` trait unless a future scene demonstrates a stable difference that contextual salience cannot explain.

---

## 4. Traits

Only three stable personality dimensions currently survive scene validation.

### 4.1 Curiosity

Curiosity increases the subjective value of uncertainty reduction, novelty and information-seeking.

It should especially affect:

- inspecting unfamiliar objects;
- continuing unresolved experiments;
- trying alternative strategies after partial feedback;
- revisiting suspended curiosities;
- safe intermediate experiments such as smelling, poking or tasting a small amount.

Curiosity is **not recklessness**. A highly curious but cautious Wilson should prefer information-seeking actions with limited exposure.

### 4.2 Risk tolerance

Risk tolerance changes how strongly **perceived** danger inhibits an intention.

It must remain separate from curiosity.

Wilson can take a bad risk because:

1. he knows the risk and tolerates it; or
2. his belief about the risk is wrong.

Only the first is directly a risk-tolerance effect.

### 4.3 Independence

Independence is Wilson's stable resistance to external influence and learned reliance.

It should affect:

- how strongly player suggestions alter desirability;
- how quickly repeated assistance creates dependency;
- how readily Wilson waits for an intervention instead of acting himself.

Independence is not the same as learned dependency.

### Rejected or deferred traits

Do **not** currently add:

- persistence;
- sociability;
- playfulness;
- orderliness;
- sanity;
- rationality;
- irrationality;
- superstitiousness;
- generic courage.

The scenes currently explain the corresponding behavior with history, habits, projects, transient emotion, curiosity, risk tolerance, stimulation and context.

---

## 5. Drives

The validated core drives are intentionally small:

```text
hunger
energy
comfort
stimulation
```

### Hunger

Creates increasingly strong pressure toward food-related intentions. Extreme hunger should strongly dominate trivial preferences and curiosity, but should not be implemented conceptually as an unconditional `if hunger > X then eat` override. Immediate threats and physically unavailable solutions still matter.

### Energy

Creates sleep/rest pressure and increases perceived effort cost when low.

It also changes which stimulation-seeking activities are attractive. A tired Wilson may prefer a quiet activity over a physically demanding experiment.

### Comfort

Supports non-survival preferences such as a favorite sitting place, better shelter, avoiding unpleasant weather and choosing familiar pleasant contexts.

### Stimulation / boredom

Stimulation is a core anti-stagnation pressure.

When urgent needs are low and the world is repetitive, stimulation increases the value of optional activity such as:

- revisiting unresolved curiosities;
- exploration;
- aesthetic work;
- harmless experiments;
- maintenance;
- a self-created physical challenge;
- a preferred leisure routine.

Boredom must **not** simply increase randomness.

A useful distinction is:

```text
curiosity:
How attractive is unknown information?

stimulation:
How strongly does Wilson want to escape low activity/repetition?
```

A bored but low-curiosity Wilson may rearrange shells or repeat a known game. A bored, highly curious Wilson is more likely to investigate an unresolved object.

### Removed drives

Do not currently model accumulating `safety`, `loneliness`, `cleanliness`, `fun`, `aesthetic`, or `order` bars.

Safety behavior is better explained through perceived threats, expected harm, immediate emergency and risk tolerance.

Gerald-related attachment and absence do not currently require a generic social/loneliness drive.

---

## 6. Associations

A subject may accumulate a persistent subjective association:

```text
association(subject)
    valence     [-1, +1]
    attachment  [0, 1]
```

A subject may be an object instance, object type, animal or place where appropriate.

### Valence

Represents dislike ↔ like.

### Attachment

Represents psychological importance / how much the subject matters to Wilson.

Attachment is deliberately independent of valence.

Example:

```text
Gerald:
    valence    = strongly negative
    attachment = very high
```

This supports rivalry, attention, absence and eventual reconciliation without requiring a single positive relationship score.

### Association update principles

Attachment grows mainly from:

- repetition;
- emotional intensity;
- uniqueness;
- recency;
- personal relevance.

It does **not** grow only from positive experiences. Repeated conflict can lower valence while increasing attachment.

Updates should use diminishing returns / saturation. Strong established associations should resist a single contradictory episode.

Valence may change substantially while attachment remains high. This enables grudges, forgiveness and relationships that change tone without becoming irrelevant.

### Association is not belief

A fire pit can be disliked while Wilson correctly believes it is now reliable.

A mushroom can have only moderately negative valence but a high-confidence danger belief that produces avoidance.

Do not add a persistent `threat` dimension to associations unless future scenes require it; danger currently belongs in beliefs/expected consequences.

---

## 7. Beliefs and knowledge

Treat knowledge as high-confidence beliefs rather than a wholly separate mental subsystem.

Conceptually a belief needs to express:

- a proposition / expected effect;
- confidence;
- scope;
- evidence/source semantics where behavior requires them.

Examples:

```text
ordinary stones tend to be hard
this fire pit is unreliable
red-spotted mushrooms may be dangerous
Gerald tends to steal exposed food
this spoon is normally beside the cooking area
```

### 7.1 Knowledge scopes

The scene analysis requires several scopes:

- **basic/universal concepts:** ordinary adult/basic physical knowledge Wilson starts with;
- **general principle:** e.g. sufficiently hard/heavy impact can break a vulnerable target;
- **category expectation:** stones tend to be hard;
- **type knowledge:** this recognizable mushroom type caused sickness;
- **instance knowledge:** this particular fire pit has failed repeatedly.

Generalization should occur in steps rather than after one success becoming universal law.

### 7.2 Category expectations and mistakes

Categories create priors, not confirmed properties.

A stone-like object may inherit an expectation of hardness and later violate it. This supports `The Useless Hammer`-type comedy without a scripted joke.

Category matching itself may be uncertain; Wilson can treat an object as `stone-like` rather than knowing exactly what it is.

### 7.3 Confidence

Confidence belongs to a proposition, not to an entire object.

Wilson may be highly confident that an object is lightweight but uncertain whether it floats or burns.

Repeated direct evidence can reinforce confidence. Strong contradiction should revise it more sharply than mere confirmation. Partial results should update the relevant mechanism rather than being treated as binary success/failure.

### 7.4 Feedback semantics

Experiment outcomes should be behaviorally distinguishable at least at the level of:

- goal success;
- partial progress;
- neutral/no useful evidence;
- counterevidence;
- catastrophic failure.

Example:

```text
wood breaks, lid unchanged
→ tool/method looks poor

stone dents lid
→ impact strategy looks promising
```

This is required for visible iterative experimentation without a general-purpose scientific AI.

### 7.5 Spatial and arrangement expectations

Wilson needs selected expectations about relevant world arrangement, for example:

- spoon normally here;
- wood stored there;
- favorite rock at this spot;
- shell arrangement has this shape;
- habitual path normally clear.

Do **not** imply that Wilson keeps a complete snapshot of the world. Spatial expectations should be limited to important, recently used, deliberately arranged, stored, attached or habitual subjects.

### 7.6 Source accessibility

A learned belief may survive even when the episode that originally justified it is no longer consciously available.

This is required for resurrection consequences:

```text
conscious death episode unavailable
+
strong learned danger expectation remains
→ inexplicable fear response
```

This does not require a separate clinical `subconscious memory` system.

---

## 8. Expectations

Expectation is one of the most central concepts found by the scene matrix.

It is normally **derived**, not necessarily persisted:

```text
beliefs + history + current context → expected state/outcome
```

Examples:

- Gerald is near exposed food → theft likely;
- clouds and wind → rain likely;
- repeatedly supplied project material → divine help may arrive;
- spoon was deliberately stored here → it should still be here;
- stone-like tool → probably hard;
- recurring animal usually appears here → it may appear again.

A central narrative force is:

```text
expected state != observed state
→ prediction error
→ orient/surprise
→ interpretation
→ learning
```

Expectation violations can also be **non-events**. If Wilson clearly expected a miracle or Gerald's recurring appearance and nothing happens, the omission can become evidence.

Omissions should only update beliefs when there was a meaningful prior expectation; ordinary player silence must not constantly reduce trust.

---

## 9. Episodic history and consolidation

The game does not need perfect autobiographical memory.

A useful functional flow is:

```text
EVENT
  ↓
EPISODE
  ↓
updates:
  belief/knowledge
  association
  habit
  player relationship
  future expectation evidence
```

Important episodes may include:

- relevant subjects;
- what happened;
- what Wilson expected;
- observed outcome;
- importance;
- emotional reaction;
- meaningful Wilson choice where later regret/causal recognition may matter.

### Episode importance

Importance should rise with combinations such as:

- need relevance;
- emotional intensity;
- surprise;
- existing attachment;
- rarity;
- consequence severity.

`Attachment` does not replace episode importance. A never-seen falling palm can create an extremely important episode.

### Consolidation

Common episodes may fade after their useful effects have consolidated.

Forty ordinary repetitions of sitting on a rock should not require forty permanent autobiographical events. Association + habit can carry the long-term effect while unusual sitting episodes remain episodic.

### Different decay semantics

Do not force one universal forgetting curve.

Conceptually:

- ordinary episodes may fade relatively quickly;
- strong episodes persist longer;
- associations drift slowly without reinforcement;
- habits weaken primarily through disuse/cue-without-action;
- established knowledge is much more stable;
- extreme learned associations can persist through resurrection even if the explicit episode is inaccessible.

---

## 10. Habits, routines and traditions

A habit is a learned contextual action bias:

```text
cue/context → action tendency
strength
```

Examples:

- after waking → check food storage;
- before bed → inspect fire;
- Gerald + exposed food → raise/protect food;
- evening + favorite rock available → sit there.

### Habit properties required by scenes

Habits must be able to:

- strengthen through repeated execution;
- form from preventive, comfortable, preferred or repeated behavior without explicit reward points;
- outlive the original utility for a while;
- compete with other intentions rather than becoming commands;
- be disrupted by changed environment;
- weaken through disuse and especially repeated cue-without-execution;
- remain incapable of overriding immediate emergency;
- bind to specific subjects or more generalized contexts where appropriate.

### Habit versus expectation

Keep them distinct:

```text
EXPECTATION:
Gerald may steal my food.

HABIT:
Gerald + food → raise food automatically.
```

A habit may remain after the supporting expectation weakens.

### Routine

Do not create a separate psychological `routine system` yet.

A routine is the visible sequence produced by several habits, recurring contexts and intentions.

### Tradition / ritual

Do not create a separate `tradition` primitive.

A tradition can emerge as a habit attached to a salient recurring cue, where the repeated action has little instrumental necessity. The player supplies much of the meaning.

### Environmental ownership

Do not create an `ownership` psychology primitive.

The desired behavior can emerge from:

```text
place/object attachment
+ expected arrangement
+ maintenance/restoration intentions or habits
```

---

## 11. Intentions and competition

The unit of psychological choice should be a meaningful intention, not a raw animation.

Examples:

```text
eat known food
investigate mushroom
taste mushroom cautiously
continue roof stage
repair table
protect food from storm
save favorite decoration
search for project material
```

### 11.1 Three filters

Keep these separate:

1. **Possibility** — can it physically happen?
2. **Consideration** — would Wilson plausibly think of it now?
3. **Desire/tendency** — how strongly does Wilson want it now?

An eligible physical action is not automatically a candidate intention.

### 11.2 Contributions

A candidate intention may receive positive and negative pressures such as:

```text
positive:
  need relief
  project value
  preference / association
  attachment relevance
  curiosity / information value
  habit
  opportunity urgency
  player suggestion
  directed-event relevance
  current-intention continuity

negative:
  perceived danger
  effort
  negative association
  uncertainty
  opportunity cost
  switching cost
```

Traits modify relevant terms rather than behaving like independent goals:

- curiosity amplifies information value;
- risk tolerance attenuates perceived-risk inhibition;
- independence attenuates external influence / learned dependence.

A final scalar tendency may be useful later for competition, but it must not be interpreted as one universal notion of objective rational utility.

### 11.3 Suboptimal but comprehensible behavior

Wilson should often choose something objectively worse because his subjective reasons differ from the player's.

Do not add `stupidity`, `chaos`, `irrationality`, or `sanity` to create this effect.

Useful sources of understandable inefficiency include:

- personal preference;
- attachment;
- incomplete or wrong knowledge;
- current emotion;
- habit;
- project completion proximity;
- current-intention inertia;
- curiosity;
- risk tolerance;
- opportunity urgency;
- stochastic choice among close plausible candidates.

### 11.4 Stochasticity

Do not always select the numerically strongest plausible intention when several are close.

The desired behavior is a weighted probabilistic choice among sufficiently plausible candidates, with strong reasons still dominating weak reasons.

A very low-probability action with no contextual reason should **not** remain in the lottery merely because it is physically possible.

### 11.5 Immediate emergency

Immediate threat is not just a high safety drive.

When a palm is actively falling, a small defensive/reactive set should dominate ordinary deliberation. Emergency response remains distinct from normal choice competition.

### 11.6 Opportunity urgency

Distinguish:

```text
need urgency:
How badly does Wilson need something?

opportunity urgency:
How quickly will this action stop being possible?
```

A decorative object about to blow into the sea can temporarily outrank stored food because the decoration's rescue window is seconds while the food can still be recovered later.

---

## 12. Current intention, suspended intentions and inertia

Wilson needs a current intention that creates short-term behavioral continuity.

Small changes in candidate desirability should not cause constant ping-pong between activities.

As Wilson invests in a short sequence — collecting a material, carrying it, positioning it, beginning work — switching should become less likely unless a sufficiently stronger stimulus appears.

This is conceptual **intention inertia / hysteresis**, not a personality trait.

Interrupted intentions may remain suspended where appropriate.

Examples:

- hunger interrupts table work; Wilson may resume after eating;
- an unresolved bottle can remain interesting for hours or days;
- a storm interrupts decoration work; the incomplete arrangement remains meaningful.

---

## 13. Projects

`Project` is a validated first-class functional concept.

A project differs from a suspended short intention because the world contains persistent visible partial progress toward a desired outcome.

A project requires behaviorally:

- a persistent desired world outcome;
- visible partial progress;
- remaining possible contributions;
- resource/capability requirements;
- contextual importance;
- pause/resume;
- completion;
- rare abandonment;
- dismantling where supported.

Projects generate immediate intentions such as gathering a suitable material, carrying it, installing a component, inspecting progress or repairing damage.

Do not require a deep hierarchical task planner. A project may simply make procurement or the next valid contribution attractive.

### Project competition

Multiple projects can coexist and compete for attention/resources. Avoid reserving all compatible material permanently to one project before Wilson actually commits it to a stage.

Target product readability remains roughly one dominant project plus a small number of secondary/paused projects, rather than a large quest list.

### Completion proximity

A nearly finished **current stage** should create a strong continuation bias even when the whole project is far from complete. This produces the `one more piece` behavior without a persistence trait.

### Project origins

Projects may become attractive because of:

- practical need;
- opportunity / accumulated resources;
- preference + stimulation;
- history/attachment.

### Authored project possibility versus systemic motivation

The simulation does **not** need infinite procedural crafting.

A key product rule is:

> Systemic history may make an authored project possibility contextually appropriate; the simulation does not need to invent the project's form.

`Statue of Gerald` is the canonical example. The history and subject selection can be systemic while the buildable form is authored and bounded.

### Project outcome as history

Completed structures remain in the world and can become new subjects of association, habits, maintenance, damage and player intervention. The island itself becomes a memory surface.

---

## 14. Transient emotion and reactions

Do not persist long-lived emotion bars as the primary memory mechanism.

Instead:

```text
persistent history/belief/association
+ current cue/context
→ transient emotion
```

Validated short-lived emotions/modifiers are:

### Fear

Triggered by expected harm / threat. Temporarily increases threat attention and avoidance.

### Anger

Triggered by negative outcome plus an obstacle/culprit Wilson can meaningfully confront. Temporarily increases culprit salience, confrontation and forceful action.

### Joy / excitement

Triggered by positive or unexpectedly successful outcomes. Can briefly increase celebration, continuation or overconfidence. `Victory Lap` demonstrates why this must affect behavior rather than only animation.

### Concern / sadness

Still less strongly validated as a distinct state. Quiet absence/loss behavior can often be produced directly by attachment + violated expectation + search/attention. Keep as a possible presentation/reaction state rather than a required persistent dimension.

### Reactions rather than persistent emotions

Treat these primarily as event/reaction primitives:

- **surprise/orient:** large prediction error;
- **frustration:** repeated blocked intention causing retry, strategy switch, abandonment or anger;
- **relief:** threat/absence resolves positively.

### No global mood model

Current scenes do not justify a persistent background valence/arousal or global mood that modifies every action.

---

## 15. Extinction, forgiveness, regret and reversal

These desirable behaviors should emerge from existing primitives rather than separate systems.

### Fear extinction / recovery

A negative danger expectation should not vanish simply because time passes.

Repeated safe exposure provides contradictory evidence:

```text
expected danger
observed safety
→ danger confidence decreases
```

Negative association can change more slowly than factual belief. Old evidence can remain available enough for a later negative event to restore avoidance quickly.

### Forgiveness

No `forgiveness` stat is required.

Repeated neutral/positive interactions can move valence toward neutral/positive while attachment remains high.

### Regret

No persistent `regret` stat is required.

Regret requires:

```text
meaningful prior choice
+ later negative consequence
+ causal recognition linking the two
→ transient reaction
→ stronger future learning
```

Some important episodes therefore need to retain Wilson's meaningful choice among alternatives, not only the final outcome.

### Lost meaningful possession

A lost favorite object requires attachment + expected location/availability + search/concern intentions. It does not require a generic grief system.

---

## 16. Causal attribution

Causal attribution is an event-level interpretation process, not a permanent fourth player-relationship stat.

For a meaningful anomaly, Wilson may compare candidate causes such as:

```text
self
known actor
natural process
unknown ordinary cause
unseen presence
```

The result should be capable of expressing:

```text
attributed cause
attribution confidence
```

Useful derived factors include anomaly strength and diagnosticity, but they need not be persistent psychological fields.

### Actual cause may differ from believed cause

This is required for superstition and comic misunderstanding.

Example:

```text
truth:
animal took offering

Wilson belief:
unseen presence accepted offering
```

### Pattern evidence

Several related anomalies in a short/meaningful context may reinforce one another. Do not build a universal detective system; use this only where events share relevant timing, objects, locations or intervention signatures.

### False pattern recognition / superstition

Do not add a `superstitiousness` trait or separate superstition system.

A superstition can be a low/medium-confidence causal belief formed from weak/coincidental evidence, optionally nudged by existing `presence_belief` when an unseen agency is already plausible.

---

## 17. Relationship with the unseen presence

The validated relationship model is:

```text
presence_belief [0,1]
trust           [-1,+1]
dependency      [0,1]
```

### Presence belief

How plausible Wilson considers the existence of an unseen agency responsible for interventions.

This is the useful functional replacement for a separate `faith` stat.

Helpful and harmful anomalies can both increase presence belief if they provide evidence of agency.

### Trust

Wilson's expectation that the presence tends to produce beneficial versus harmful outcomes.

Trust must respond to **Wilson's perceived/attributed outcome**, not the player's actual intention.

A player who intended to help but visibly ruined Wilson's plan may reduce trust.

### Dependency

The learned tendency to delay or alter self-directed action while awaiting intervention.

Dependency is distinct from:

- presence belief;
- trust;
- stable independence.

Repeated reliable help can increase dependency. Silence after a clearly expected intervention should reduce dependency faster than it reduces belief.

### Different change rates

A useful qualitative relationship is:

- presence belief: evidence-driven and relatively stable;
- trust: more sensitive to recent attributed outcomes;
- dependency: behaviorally plastic and able to decay substantially when Wilson must resume solving problems himself.

### No fourth relationship dimension yet

Current scenes do not require separate persistent `faith`, `benevolence`, `reliability`, `presence_attachment`, `religiosity` or `self_efficacy` stats.

---

## 18. Player suggestions

A player suggestion increases the desirability of a valid/plausible intention; it never becomes a command.

Suggestion influence should be modulated by:

- Wilson's baseline desirability for the action;
- independence;
- trust;
- current risk/need/emotion;
- limited insistence.

Repeated suggestions should have diminishing returns. A second/third suggestion can increase pressure, but repeated insistence may also create irritation/refusal and should eventually enter a cooldown.

Negative trust should normally reduce suggestion influence and increase suspicion rather than mechanically invert every suggestion, which would create an exploitable `tell Wilson the opposite` controller.

Dependency and suggestion compliance are separate phenomena.

---

## 19. Player intervention, recognition and psychological consequences

Only interventions Wilson can recognize as anomalous should directly update his mental model of the presence.

Examples:

- moving a random unseen pebble Wilson has no expectation about → no meaningful anomaly;
- moving his habitual spoon → noticeable prediction error;
- relocating several carefully stored materials → strong pattern/anomaly;
- materializing a rare object within awareness → very strong evidence of unexplained agency.

This creates an important distinction:

```text
physical/causal intervention cost
≠
psychological narrative impact
```

God Power should not automatically become expensive merely because Wilson cares deeply about the affected object. Discovering and exploiting Wilson's routines is part of the player fantasy.

---

## 20. Knowledge through physical experimentation

Keep physical action, experiment and semantic learned interaction distinct.

Conceptually:

```text
physical action
→ observed effect
→ belief/property update
→ useful relationship may consolidate
→ learned semantic interaction
```

The system should support:

- property discovery;
- direct interaction discovery;
- generalization to a reusable principle when evidence supports it.

A useful learned semantic interaction may be a consolidation for planning/UI; it should not require that every valid object pair be authored as a recipe.

### Choosing the next experiment

Experiment desirability should depend on:

- goal relevance;
- information value;
- plausibility under Wilson's current beliefs;
- cost/risk.

Curiosity amplifies information value. Risk tolerance changes risk inhibition.

Partial progress should favor variations of a promising strategy rather than restarting from arbitrary alternatives.

---

## 21. Self-entertainment and micro-goals

When Wilson is comfortable but under-stimulated, he may create a short objective with no survival utility, such as trying to kick a coconut onto a line or improve a stone-skipping result.

This does **not** currently justify a `playfulness` trait or a separate mini-game planner.

It requires only:

- stimulation pressure;
- an interesting affordance with observable feedback;
- a short self-generated intention;
- optional memory of a relevant prior outcome when repetition matters.

These activities should be readily interruptible by more important needs/events, but repeated participation may later create habits, preferences or place attachment.

---

## 22. Recurring events and anticipation

Anticipation should use derived expectations rather than a separate `anticipation` system.

Repeated evidence may lead Wilson to prepare before a recurring event:

```text
conditions predict event
→ expectation becomes salient
→ preparation intention becomes valuable
```

Examples:

- protect food before Gerald arrives;
- check/secure vulnerable objects before a storm;
- visit shore after conditions that previously brought debris.

If the preparation becomes routinely repeated under the same cue, it may later consolidate into a habit.

---

## 23. Resurrection consequence

Resurrection remains a special product rule built from ordinary psychological primitives.

Death may produce:

- a very strong danger belief/association tied to the cause;
- a high-importance episode.

After resurrection:

- Wilson has no conscious memory of dying;
- the explicit death episode may be inaccessible;
- learned danger/negative association may remain;
- encountering the cause can produce intense inexplicable fear/caution.

Do not create a dedicated `trauma` or `subconscious memory` subsystem unless later content requires distinctions the existing belief/association model cannot express.

---

## 24. LLM boundary

The simulation must be functionally complete without an LLM.

The LLM may add contextual variety but cannot own truth, physical outcomes, memory or normal decision authority.

High-value runtime roles are:

1. short grounded spoken/thought realization;
2. diary/history prose realization from structured facts;
3. bounded interpretation/weight perturbation in eligible ambiguous cases;
4. rare grounded scene embellishment from valid candidates;
5. reaction-language variation.

For ambiguous interpretation, a useful initial calibration target is approximately:

```text
~70% deterministic interpretation
~30% optional LLM-assisted interpretation
```

The ratio is calibratable and should apply to **eligible ambiguous interpretation cases**, not to all decisions/ticks.

The safe pattern is:

```text
simulation generates valid candidates + baseline weights
→ optional LLM nudges/reweights within bounds
→ simulation validates/clamps
→ simulation performs final choice
```

The LLM cannot promote an impossible or unmotivated zero-plausibility action into dominance.

Every LLM use needs a deterministic result with the same semantic function.

---

## 25. Concepts deliberately removed from the minimum model

The current scene suite does not justify independent primitives for:

```text
sanity
global mood / persistent valence-arousal
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
ownership
irrationality
stupidity
self-efficacy / learned helplessness
```

Their desired visible behaviors are explainable through combinations of the admitted primitives.

This list is an explicit defense against psychological-system proliferation.

---

## 26. Candidate minimum behavioral model

Current validated conceptual inventory:

```text
WORLD
  physical/semantic properties
  capabilities
  environmental state
  instance identity

ATTENTION
  contextual salience (derived)

TRAITS
  curiosity
  risk_tolerance
  independence

DRIVES
  hunger
  energy
  comfort
  stimulation

BELIEFS / KNOWLEDGE
  proposition / expected effect
  confidence
  scope
  category inference
  selected spatial/arrangement expectations
  source may be consciously accessible or not

ASSOCIATIONS
  valence
  attachment

EPISODIC HISTORY
  selected meaningful events
  meaningful prior choices
  expected vs observed outcome

HABITS
  cue/context → action tendency
  strength
  formation / disruption / extinction

INTENTIONAL STATE
  current intention
  suspended intentions
  projects
  short self-generated goals
  intention inertia / completion proximity

EXPECTATIONS
  derived from beliefs + history + context

TRANSIENT EMOTION / REACTION
  fear
  anger
  joy/excitement
  concern/sadness if later required
  surprise/orient
  frustration/block response
  relief

CAUSAL ATTRIBUTION
  event-specific competing causes
  attribution confidence

PLAYER RELATIONSHIP
  presence_belief
  trust
  dependency
```

Do not convert this block directly into classes or tables. The next design stage should first derive the **required persistent state inventory and ownership/lifetime constraints** from this model and the scene matrices.

---

## 27. Validation rule going forward

Any proposed new psychological primitive should answer:

1. Which desirable scene cannot be expressed convincingly without it?
2. Why can that scene not be explained through current beliefs, association, history, habits, projects, drives, traits or transient reactions?
3. Does the concept create a player-visible difference large enough to justify authoring, balance and debugging cost?

If those answers are weak, defer the primitive.
