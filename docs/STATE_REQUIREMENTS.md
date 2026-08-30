# Functional State Requirements

## Status and purpose

This document translates the validated behavioral model into a **functional state inventory**.

It is still **pre-architecture**. It does not prescribe classes, ECS components, tables, JSON schemas, ownership boundaries, serialization format, update formulas, scheduler design or engine subsystems.

Its purpose is to answer, for each admitted concept:

- is it authoritative world state, Wilson-relative state, player-relative state, or derived/transient state?
- must it persist?
- what is its expected lifetime?
- what scope can it attach to?
- what creates, updates, consolidates, decays or removes it?
- what happens offline?
- what survives resurrection?
- what content vocabulary must exist for the concept to be meaningful?
- which representative scenes prove that the requirement exists?

`BEHAVIORAL_MODEL.md` remains the behavioral semantics reference. `SCENE_VALIDATION.md` remains the evidence/test-suite reference. This document is the bridge from those decisions toward later architecture/data-model work.

---

## 1. State classes

Before listing individual concepts, keep four state classes distinct.

### 1.1 Authoritative world state

Facts that are true in the simulation independently of what Wilson believes.

Examples:

- entity identity;
- location;
- physical/semantic properties and capabilities;
- current transformed form;
- container contents;
- project-built world progress;
- weather/environmental state;
- authoritative causes and outcomes.

Wilson may or may not know these facts.

### 1.2 Wilson-relative persistent state

State that expresses Wilson's accumulated personal history or learned model.

Examples:

- traits;
- drives;
- associations;
- beliefs/knowledge;
- selected episodes;
- habits;
- active/suspended intentional continuity;
- project desire/history where not already carried by the world result;
- presence relationship.

This state normally belongs to the current Wilson/run, even when its subject is a world entity.

### 1.3 Player-relative persistent state

State belonging to the player's intervention/progression layer rather than Wilson's mind.

Examples relevant to current discovery:

- God Power amount;
- non-intervention streak/progression state;
- game mode;
- discovery/unlock state where applicable;
- settings affecting offline simulation or AI availability.

This document records only behavioral dependencies on such state, not the complete player progression model.

### 1.4 Derived/transient state

State needed to explain a current decision or scene but normally reconstructible from persistent state + current context.

Examples:

- salience/attention;
- expectation;
- prediction error/anomaly strength;
- candidate intention set;
- action tendency / final competition weight;
- event-level causal hypothesis weights;
- transient emotion/reaction;
- opportunity urgency;
- completion-proximity bias;
- immediate-threat response state.

These concepts may exist at runtime, but product requirements do **not** currently require them to be durable save-state primitives.

---

## 2. Lifetime vocabulary

Use these product-level lifetime categories when discussing later data-model proposals.

| Lifetime | Meaning |
|---|---|
| **Moment** | Seconds or one visible reaction/action sequence. |
| **Short** | Minutes / part of an in-game day. |
| **Medium** | Multiple in-game days. |
| **Run-long** | Potentially the entire Wilson/island run. |
| **Cross-resurrection** | May survive Wilson resurrection within the same run. |
| **Cross-run** | Global player progression only; Wilson psychology does not currently require this. |

Not every state needs a fixed timeout. These labels describe expected behavioral persistence, not implementation timers.

---

# 3. Stable Wilson traits

## 3.1 Curiosity

| Requirement | Decision |
|---|---|
| State class | Wilson-relative persistent |
| Persist? | Yes |
| Lifetime | Run-long |
| Scope | Wilson-global |
| Initial source | Canonical Wilson baseline + modest per-run variation |
| Updated by experience? | No strong requirement for ordinary runtime drift yet; avoid casually rewriting personality from individual events |
| Decay | None required within a run |
| Offline | Unchanged unless a future explicit personality-shaping feature is admitted |
| Resurrection | Survives |
| Content dependency | Novelty/unknown-status, information-bearing affordances, experimental actions |
| Validating scenes | Scientific Method, Bowling Ball, Mushroom, Bottle, Faster Than Walking |

Functional role: increases the value of information gain, unresolved uncertainty and safe exploration. It must remain separate from risk tolerance.

## 3.2 Risk tolerance

| Requirement | Decision |
|---|---|
| State class | Wilson-relative persistent |
| Persist? | Yes |
| Lifetime | Run-long |
| Scope | Wilson-global |
| Initial source | Canonical baseline + modest per-run variation |
| Runtime update | No general experience-driven drift required yet; learned caution belongs primarily in beliefs/associations |
| Decay | None required |
| Offline | Unchanged |
| Resurrection | Survives |
| Content dependency | Perceived consequence severity/probability and actions with risk exposure |
| Validating scenes | Long Way Around, Mushroom, Faster Than Walking, Too Hot, Brilliant Shortcut, Falling Palm context |

Functional role: changes how strongly **perceived** danger inhibits action. It does not determine what Wilson believes the danger to be.

## 3.3 Independence

| Requirement | Decision |
|---|---|
| State class | Wilson-relative persistent |
| Persist? | Yes |
| Lifetime | Run-long |
| Scope | Wilson-global |
| Initial source | Canonical baseline + modest variation |
| Runtime update | No ordinary drift currently required |
| Decay | None required |
| Offline | Unchanged |
| Resurrection | Survives |
| Content dependency | Player suggestions/interventions and presence-dependency behavior |
| Validating scenes | Absolutely Not, Benefactor, Roof or Table?, Mushroom suggestion variants |

Functional role: basal resistance to external influence and learned reliance. It is intentionally distinct from `dependency`.

---

# 4. Core drives

Drives are Wilson-relative persistent state because the simulation must resume coherent bodily/motivational pressure after save/load or offline catch-up. Their exact numerical representation is an architecture decision.

## 4.1 Hunger

| Requirement | Decision |
|---|---|
| Persist? | Yes |
| Lifetime | Short/continuous; meaningful across days |
| Scope | Wilson-global |
| Creation/update | Time, food consumption, bodily consequences |
| Decay/recovery | Satisfied by eating; grows again with time |
| Offline | May advance conservatively; offline simulation must not kill Wilson |
| Resurrection | Reset/normalize according to resurrection presentation; no requirement to preserve pre-death hunger |
| Content dependency | Edibility, food value, access to food |
| Validating scenes | One More Piece, Mushroom, Too Hot, storm/food priorities |

Extreme hunger should become nonlinearly dominant over trivial preferences, without becoming an unconditional command that ignores physical impossibility or immediate danger.

## 4.2 Energy

| Requirement | Decision |
|---|---|
| Persist? | Yes |
| Lifetime | Short/continuous |
| Scope | Wilson-global |
| Creation/update | Time awake, exertion, sleep/rest |
| Offline | May advance/recover consistently with offline-time model |
| Resurrection | Reset/normalize; no long-term pre-death preservation required |
| Content dependency | Effort cost, rest/sleep opportunities |
| Validating scenes | Absolutely Not, normal sleep cycle, idle-activity selection |

Low energy increases rest pressure and the effective cost of demanding activities.

## 4.3 Comfort

| Requirement | Decision |
|---|---|
| Persist? | Yes if represented as a changing internal drive/state; exact decomposition remains architectural |
| Lifetime | Short-to-medium |
| Scope | Wilson-global, derived partly from immediate environment |
| Creation/update | Weather exposure, shelter, seating/resting context, unpleasant conditions |
| Offline | May change conservatively with world/environment state |
| Resurrection | No special preservation required |
| Content dependency | Environmental comfort effects and preferred contexts |
| Validating scenes | Good Chair, shelter progression, weather/domestic behavior |

Comfort must remain distinct from danger/safety. The validated model does not contain an accumulating `safety` drive.

## 4.4 Stimulation

| Requirement | Decision |
|---|---|
| Persist? | Yes enough to preserve anti-stagnation pressure across interruptions/save |
| Lifetime | Short-to-medium |
| Scope | Wilson-global |
| Creation/update | Low novelty/activity/repetition increases pressure; interesting/engaging activity reduces it |
| Offline | Should advance cautiously; do not resolve rare spectacle merely because stimulation became high offline |
| Resurrection | May normalize; no trauma-like preservation required |
| Content dependency | Optional activities, unresolved curiosities, aesthetic/maintenance actions, experiments, leisure affordances |
| Validating scenes | Interior Design, Bottle, boredom/self-entertainment regression, Good Chair contrast |

Stimulation is not randomness and not a `fun` meter. It increases the value of optional activity when instrumental pressures are weak.

---

# 5. Associations

## 5.1 Association state

```text
association(subject)
    valence     [-1, +1]
    attachment  [0, 1]
```

| Requirement | Decision |
|---|---|
| State class | Wilson-relative persistent |
| Persist? | Yes |
| Lifetime | Medium to run-long |
| Scope | Subject instance, type/category where justified, animal, place; not necessarily every world entity |
| Creation | Meaningful/repeated direct experience or weak initial preference |
| Update | Subjective outcome valence, emotional intensity, repetition, uniqueness, attachment relevance |
| Consolidation | Repeated ordinary episodes may collapse into association rather than remain episodic |
| Decay | Slow drift toward neutral/irrelevance when unreinforced; no universal formula required |
| Saturation | Required; avoid runaway reinforcement |
| Offline | May update from ordinary offline interactions if those interactions are allowed to happen; no extreme relationship swing from opaque catch-up |
| Resurrection | Strong associations may survive, especially cause-of-death aversion; explicit episode may not |
| Content dependency | Stable subject identity/type/place references and outcome evaluation |
| Validating scenes | Good Chair, Long Way Around, Traitorous Fire, Gerald, Roof or Table?, Storm Priorities, Someone Moved the Rock, lost-favorite regression |

### Valence

Represents dislike ↔ like.

### Attachment

Represents how much the subject matters psychologically. It is not positivity.

A hated Gerald may have strongly negative valence and very high attachment.

### Required asymmetries

- attachment may rise from negative repeated events;
- valence can recover while attachment remains high;
- established association should resist one contradictory event;
- attachment should generally decay more slowly than ordinary momentary preference;
- attachment increases attention and consequence importance, not automatic approach.

---

# 6. Beliefs / knowledge

## 6.1 General requirement

Wilson needs persistent learned propositions rather than one `knowledge level` per object.

| Requirement | Decision |
|---|---|
| State class | Wilson-relative persistent |
| Persist? | Yes |
| Lifetime | Medium to run-long; basic/high-confidence knowledge very stable |
| Scope | General principle, category, type, instance, selected place/arrangement |
| Creation | Basic prior, category inference, direct observation, experiment, repeated evidence, weak coincidence where causal ambiguity allows |
| Update | Confirmation, contradiction, prediction error, partial feedback, causal interpretation |
| Confidence | Required per proposition/claim, not per whole object |
| Evidence quality | Must matter functionally; direct evidence stronger than coincidence |
| Decay | Contextual/weak beliefs may weaken; established knowledge should be stable; no single universal forgetting curve |
| Offline | Ordinary learning may occur if offline activity is allowed; major discovery/rare spectacle should not be lost offline |
| Resurrection | Learned facts may survive; cause-of-death danger belief may survive even if death episode is inaccessible |
| Content dependency | Categories, properties/capabilities, observable effects, action outcomes, semantic relationships |
| Validating scenes | Scientific Method, Bowling Ball, Mushroom, Too Hot, Traitorous Fire, Gerald, Missing Spoon, Bottle |

## 6.2 Required belief scopes

The behavioral model requires at least these semantic scopes:

- basic/universal concept;
- general physical/semantic principle;
- category expectation;
- type-level claim;
- instance-level claim;
- selected spatial/arrangement expectation.

This is a functional vocabulary requirement, not a storage hierarchy prescription.

## 6.3 Spatial/arrangement expectations

Wilson must be able to learn that selected things are normally arranged in particular ways.

Examples:

- spoon normally beside cooking area;
- materials normally stored in a container/area;
- favorite rock normally at a location;
- decorative pattern normally has a recognizable arrangement;
- habitual route is normally clear.

These expectations should be selective. Product requirements do not justify a complete persistent snapshot of every object's position.

## 6.4 Source accessibility

Belief truth-to-Wilson and Wilson's ability to narrate *why* he believes it must be separable.

A strong danger expectation may remain after resurrection even when the death episode itself is unavailable to conscious recall.

Required behavior:

```text
explicit source inaccessible
+
consolidated danger belief remains
→ Wilson can react strongly without being able to explain why
```

Do not create a separate clinical subconscious-memory primitive merely to support this.

---

# 7. Episodic history

## 7.1 Episode requirement

Selected meaningful events need durable episodic representation long enough to support callbacks, causal learning, regret, diary, relationship change and later reinterpretation.

| Requirement | Decision |
|---|---|
| State class | Wilson-relative persistent |
| Persist? | Selected episodes only |
| Lifetime | Short to run-long depending on importance |
| Scope | Episode/event, referencing relevant subjects/context |
| Creation | Meaningful observed event rather than every action tick |
| Importance drivers | Need relevance, emotion, surprise, attachment, rarity, severity/consequence |
| Consolidation | Ordinary repetitions may disappear after updating belief/association/habit |
| Decay | Ordinary episodes relatively fast; important episodes slower; no universal curve |
| Offline | Generate only for offline events Wilson could know; catch-up should remain structured and conservative |
| Resurrection | Explicit death episode may become inaccessible while learned consequences survive |
| Content dependency | Event semantics, expected outcome, observed outcome, involved subjects, consequence categories |
| Validating scenes | Missing Spoon, Traitorous Fire, Gerald, Scientific Method, Brilliant Shortcut, regret regression, I Hate Mushrooms regression |

## 7.2 Minimum functional episode content

An important episode may need to preserve:

- relevant actors/subjects;
- what happened;
- what Wilson expected;
- what Wilson observed;
- consequence/importance;
- transient reaction;
- meaningful Wilson choice when later causal recognition/regret may depend on it.

Not every episode requires every field semantically. Architecture should not infer a mandatory giant event record from this list.

## 7.3 Meaningful prior choice

Regression adds an explicit requirement: some episodes must preserve **which salient alternative Wilson chose** when a later consequence may be attributed back to that decision.

Example:

```text
roof vs table
Wilson chose table
later rain damages camp
→ Wilson can recognize his earlier choice as causally relevant
```

`Regret` itself is not persisted; the relevant choice + later consequence + causal recognition produce a transient regret-like reaction and future learning.

---

# 8. Habits

## 8.1 Habit state

```text
cue/context → action tendency
strength
```

| Requirement | Decision |
|---|---|
| State class | Wilson-relative persistent |
| Persist? | Yes |
| Lifetime | Medium to run-long if reinforced |
| Scope | Context/cue + action/intention; may reference specific instance, type, place or recurring situation |
| Creation | Repeated action under sufficiently similar cue/context |
| Reinforcement | Repeated execution; utility/reward not strictly required |
| Weakening | Disuse; especially repeated cue occurrence without executing the habitual response |
| Disruption | Environment can invalidate expected cue/target and force adaptation |
| Generalization | Functionally required in some cases; habit may bind to instance or broader context |
| Offline | Ordinary habits may reinforce/decay only through offline events that actually occur; avoid huge opaque changes |
| Resurrection | Ordinary habits may survive unless resurrection reset is intentionally specified; no requirement to erase them globally |
| Content dependency | Stable contextual cues and action/intention vocabulary |
| Validating scenes | Good Chair, Breakfast First, Gerald, Inspection Day, Someone Moved the Rock, Brilliant Shortcut, anticipation regression |

Habits are biases, not commands. They cannot override immediate emergency.

## 8.2 Routine and tradition

Do not persist `routine` or `tradition` as separate psychological primitives.

- routine = several habits/recurring contexts chaining visibly;
- tradition = habit tied to a salient recurring cue, often with weak instrumental value;
- environmental ownership = place attachment + arrangement expectation + restoration behavior.

Later architecture may cache/present such patterns, but product behavior does not require separate authoritative mental stats.

---

# 9. Intentional continuity

## 9.1 Current intention

| Requirement | Decision |
|---|---|
| State class | Wilson-relative short-lived intentional state |
| Persist? | Yes across save/load/interruption if Wilson is meaningfully mid-intention |
| Lifetime | Moment to short |
| Scope | Wilson-global current intention, referencing subjects/goal/context |
| Creation | Candidate intention wins normal competition or directed-event bias |
| Update | Action progress, interruption, completion, failure, reconsideration |
| Removal | Completion, abandonment, invalidation or replacement after sufficient competing pressure |
| Offline | Do not require resuming a fragile second-by-second animation state; preserve meaningful intent/progress where necessary for coherent catch-up |
| Resurrection | Does not survive death |
| Validating scenes | One More Piece, Scientific Method, Roof or Table?, Signal Fire, Falling Palm |

Current intention requires continuity/hysteresis: small stimuli should not constantly reset Wilson.

## 9.2 Suspended intention / unresolved interest

| Requirement | Decision |
|---|---|
| Persist? | Yes selectively |
| Lifetime | Short to medium |
| Scope | Wilson-global intention reference to subject/problem |
| Creation | Meaningful unresolved goal loses competition without being discarded |
| Update | Reconsidered, resolved, superseded or forgotten |
| Decay | Gradual relevance loss unless attachment/curiosity/history reinforces it |
| Offline | May remain suspended; do not resolve important spectacle silently |
| Resurrection | Ordinary suspended goals need not survive death |
| Validating scenes | Bottle, Scientific Method, project interruptions |

This supports “returning to unfinished thoughts” without making every unfinished action a project.

---

# 10. Projects

`Project` is a first-class functional concept because the desired outcome and partial world progress persist across interruptions.

| Requirement | Decision |
|---|---|
| State class | Mixed: Wilson-relative desired outcome + authoritative persistent world progress |
| Persist? | Yes |
| Lifetime | Medium to run-long |
| Scope | Project instance / target world outcome |
| Creation | Contextually appropriate authored/systemic project becomes desired/started |
| Progress | Visible contributions/stages modify authoritative world state |
| Pause | Required; project remains desirable but currently not pursued |
| Resume | Required |
| Abandon | Rare; should follow changed desirability/impossibility/history, not simple timeout |
| Dismantle | Supported where project/content permits |
| Competition | Multiple projects may coexist and compete for shared resources |
| Offline | Ordinary progress may advance with caps; important reveal/completion milestones may be held for active play |
| Resurrection | Physical project progress remains in world; Wilson-side project desire/relationship may be re-established from world/history rather than erased blindly |
| Content dependency | Authored project families, valid contributions/resources/capabilities, visible stage outcomes |
| Validating scenes | One More Piece, Roof or Table?, Interior Design, Benefactor, Sabotaged Storage; Statue of Gerald regression |

## 10.1 Required project semantics

Functionally, a project must support:

- persistent desired world outcome;
- visible partial progress;
- currently possible next contributions;
- resource/capability requirements;
- contextual importance;
- completion state;
- interruption and resumption.

Do not infer a deep task/subtask hierarchy from these requirements.

## 10.2 Authored form, systemic eligibility

History may make an authored project possibility contextually appropriate.

Canonical example:

```text
long Gerald history
+ high attachment
+ suitable idle/stimulation context
+ available authored effigy/statue project
→ Gerald statue may become salient
```

The system does not need infinite procedural crafting or LLM-invented blueprints.

---

# 11. Presence relationship

The current relationship vector is:

```text
presence_belief [0,1]
trust           [-1,+1]
dependency      [0,1]
```

These dimensions must persist separately.

## 11.1 Presence belief

| Requirement | Decision |
|---|---|
| State class | Wilson-relative persistent |
| Lifetime | Medium to run-long |
| Scope | Wilson ↔ unseen-presence relationship |
| Creation/update | Accumulated evidence that unexplained interventions share an unseen-agent cause |
| Positive evidence | Diagnostic anomalies, witnessed materialization/rearrangement, successful deliberate tests |
| Negative evidence | Repeated deliberate tests with no response may reduce belief modestly; ordinary silence should not |
| Decay | Slow; should outlast learned dependency |
| Offline | Do not fabricate major divine evidence offline; ordinary previously-established expectations may persist |
| Resurrection | Survives unless product later specifies a relationship reset |
| Validating scenes | Missing Spoon, Someone Moved the Rock, Sabotaged Storage, Gift Test/Experiment north stars |

Helpful and harmful interventions can both increase presence belief.

## 11.2 Trust

| Requirement | Decision |
|---|---|
| State class | Wilson-relative persistent |
| Lifetime | Medium/run-long but relatively plastic |
| Scope | Wilson ↔ unseen presence |
| Update prerequisite | Event is attributed to presence with enough confidence |
| Update direction | Wilson's perceived consequence, not the player's hidden intention |
| Decay/change | Can change faster than presence belief; repeated contrary evidence can recover/damage it |
| Offline | Major swings should not happen from unseen rare events |
| Resurrection | Survives unless explicitly reset |
| Validating scenes | Benefactor, Sabotaged Storage, Missing Spoon variants, Unwanted Rescue rewrite |

Negative trust means Wilson expects harmful/unreliable intervention, not that he disbelieves the presence exists.

## 11.3 Dependency

| Requirement | Decision |
|---|---|
| State class | Wilson-relative persistent |
| Lifetime | Medium; more plastic than belief |
| Scope | Wilson ↔ unseen presence |
| Creation/update | Reliable repeated assistance + Wilson actually relying/waiting for it |
| Trait interaction | High independence slows dependency acquisition |
| Weakening | Expected help fails to arrive; Wilson repeatedly solves problems himself |
| Decay | Faster than presence belief; ordinary periods of self-reliance should lower it |
| Offline | Do not increase dramatically from hidden assistance; offline design should avoid teaching reliance through invisible miracles |
| Resurrection | Can survive but may be recalibrated by resurrection presentation; no requirement to reset automatically |
| Validating scenes | Benefactor, Miracle Fatigue regression |

Dependency primarily affects waiting/relying behavior, not generic laziness or automatic suggestion compliance.

---

# 12. Event-level causal attribution

Causal attribution is behaviorally essential but normally **derived/transient per event**, not a long-term relationship scalar.

## 12.1 Required causal candidate classes

Current scene evidence requires Wilson to be able to distinguish roughly:

- natural/environmental cause;
- self-caused / forgotten own action;
- known actor;
- unexplained/unknown ordinary cause;
- unseen presence suspected.

An implementation may represent these differently, but visible behavior must support this distinction.

## 12.2 Attribution confidence

For an ambiguous event, Wilson must be capable of holding a best causal interpretation with meaningful uncertainty.

Functional form:

```text
candidate causal hypotheses
+ contextual plausibility/evidence
→ attributed cause + confidence
```

This is distinct from long-term `presence_belief`:

- `presence_belief` is the prior accumulated plausibility that such an agent exists;
- current-event attribution is the context-specific interpretation of this anomaly.

## 12.3 Persistence requirement

The transient probability distribution itself does not need long-term persistence.

If the interpretation matters later, persist its **result/evidence through the episode/belief/relationship update**, e.g.:

```text
Wilson believed presence moved the spoon with moderate confidence
```

rather than requiring a live causal-distribution object days later.

## 12.4 Validating scenes

Missing Spoon, Someone Moved the Rock and Sabotaged Storage are canonical. Gift Test supports intentionally wrong attribution; Unwanted Rescue rewrite proves Wilson judges observable consequence rather than true player intent.

---

# 13. Expectations and prediction error

## 13.1 Expectation

Expectation is derived:

```text
beliefs + history + current context → predicted state/outcome
```

| Requirement | Decision |
|---|---|
| Persist? | Normally no |
| Lifetime | Moment/short |
| Scope | Current event/action/subject |
| Reconstruct from | Beliefs, habits/history, project/drive context, world perception |
| Save requirement | Save the persistent inputs, not every ephemeral prediction |
| Validating scenes | Nearly every Must-have; especially Missing Spoon, Gerald, Traitorous Fire, Mushroom, Brilliant Shortcut |

Some explicit waiting/test sequences may require a short-lived current expected response/window to remain coherent across pause/save. This is intentional-state continuity, not evidence for a global expectation database.

## 13.2 Prediction error / anomaly strength

Derived from expected vs observed state/outcome.

It influences:

- orient/surprise;
- attention;
- episode importance;
- knowledge update;
- causal attribution.

It does not currently need persistent storage after its consequences are consolidated.

---

# 14. Attention / salience

Attention is derived runtime state.

| Requirement | Decision |
|---|---|
| Persist? | Normally no |
| Lifetime | Moment |
| Scope | Current Wilson context over nearby/relevant subjects |
| Inputs | Proximity, visibility, current intention, needs, novelty, attachment, threat, expectation mismatch, opportunity urgency, habitual expectation, relevant memory, event framing |
| Save requirement | Preserve persistent causes and meaningful current intention; do not require durable salience scores for the whole world |
| Validating scenes | All Must-haves |

Product requirement: Wilson must operate over a small salient set, not globally evaluate every possible entity/action.

---

# 15. Candidate intentions and action tendency

Candidate intentions and their final comparative desirability are derived runtime decision state.

## 15.1 Persisted inputs

The following durable state may influence competition:

- drives;
- beliefs/knowledge;
- associations;
- habits;
- traits;
- project state;
- current/suspended intention;
- presence relationship;
- relevant episode effects.

## 15.2 Derived contributors

Examples:

- need relief;
- project value;
- preference/attachment relevance;
- curiosity/information value;
- perceived danger;
- effort;
- uncertainty;
- player suggestion pressure;
- opportunity urgency;
- completion proximity;
- switching cost;
- transient emotion.

No product requirement currently says to persist a universal `utility score` for actions.

## 15.3 Current intention continuity

The current winning intention itself may need short persistence; the candidate set/weights generally do not.

---

# 16. Transient emotion and reactions

The validated model does not persist days-long emotion bars.

## 16.1 Short-lived emotional states

Currently justified:

- fear;
- anger;
- joy/excitement.

`Sadness/concern` remains useful as a possible short reaction for loss/absence, but is less strongly required as a first-class state.

## 16.2 Derived reactions rather than long-term state

Treat these primarily as reactions/conditions:

- surprise/orient from prediction error;
- frustration from repeatedly blocked intention;
- relief from threat/absence resolving positively;
- regret from remembered choice + later negative consequence + causal recognition.

## 16.3 Persistence

| Requirement | Decision |
|---|---|
| Persist? | Only enough to carry the current scene/action sequence across pause/save if needed |
| Lifetime | Moment to short |
| Scope | Current Wilson state, usually with subject/cause |
| Long-term consequence | Must update memory/belief/association/habit/relationship where appropriate |
| Offline | Do not need detailed emotional simulation for unseen ordinary catch-up; persist resulting durable consequences if event itself is allowed |
| Resurrection | Transient emotion resets; consolidated fear-causing beliefs/associations may survive |
| Validating scenes | Long Way Around, Traitorous Fire, Storm Priorities, Mushroom, Too Hot, Victory Lap regression, Gerald Is Missing regression |

Fear of a mushroom days later should be regenerated from danger belief + association/history, not from a week-long `fear=0.8` bar.

---

# 17. Immediate threat state

Immediate physical emergencies are distinct from normal deliberation.

Examples:

- falling palm;
- imminent dangerous impact;
- rapidly collapsing path.

Requirements:

- drastically narrow candidate set toward immediate defensive responses;
- override normal habits/projects/trivial needs;
- remain grounded in perceived current danger;
- return to ordinary competition after immediate danger ends.

This is derived/transient and does not justify an accumulating safety drive.

---

# 18. God Power and player-side intervention state

God Power is not Wilson psychology but it materially conditions representative scenes and must persist at product level.

## 18.1 God Power

| Requirement | Decision |
|---|---|
| State class | Player-relative authoritative |
| Persist? | Yes |
| Lifetime | Run / mode-dependent; exact cross-run behavior remains product design |
| Update | Spend on supported interventions; passive generation; achievements/milestones; capped offline accumulation |
| Cost principle | Primarily physical/causal magnitude and improbability, not Wilson attachment |
| Resurrection | Resurrection costs no GP |
| Validating scenes | Missing Spoon, Someone Moved the Rock, Signal Fire, Falling Palm, Brilliant Shortcut |

## 18.2 Non-intervention streak

The passive-generation acceleration needs persistent continuity across ordinary save/load and allowed offline progression.

Core rhythm:

```text
observe
→ accumulate intervention capacity
→ encounter meaningful opportunity
→ intervene or remain observer
→ consequence
```

Any intervention breaks the streak. Exact formulas remain later balance work.

---

# 19. Resurrection persistence contract

Resurrection is a special persistence boundary and must be specified explicitly rather than treating death as either full reset or normal continuation.

Current functional contract:

### Must remain in world

- authoritative environmental changes;
- structures/project progress unless the death event itself changed them;
- ordinary entity history/world consequences;
- player-side state unless separately specified.

### Wilson state expected to survive

- stable traits;
- much ordinary knowledge;
- associations where narratively meaningful;
- presence relationship unless a later product rule resets it;
- strong learned danger expectation from cause of death.

### Wilson state that may reset/normalize

- current intention;
- immediate drives/body state;
- transient emotion;
- fragile suspended action sequence.

### Explicit death memory

Wilson does not consciously remember death after resurrection.

However:

```text
cause-of-death episode inaccessible
+
consolidated negative association/danger belief retained
→ inexplicable caution/fear
```

This is the canonical `I Hate Mushrooms` requirement.

---

# 20. Offline-state contract

Offline simulation must update only state justified by events that are allowed to occur offline.

## 20.1 May progress offline conservatively

- ordinary drives;
- ordinary world/environmental state;
- limited project progress;
- ordinary learning;
- ordinary association/habit changes;
- existing relationships gradually;
- God Power to cap.

## 20.2 Must not happen invisibly

- Wilson death;
- major rare/directed scene resolution;
- major area discovery;
- extreme irreversible player/presence relationship changes caused by spectacle the player never saw;
- rare project reveal/final milestone where the reveal itself is part of the payoff, if the content is designated view-worthy.

## 20.3 Offline memory/history

Only create episodes for events Wilson could know. Catch-up history must be structured enough for diary realization without letting an LLM invent missing facts.

The return target remains:

> “Let's see what happened,” not guilt or panic.

---

# 21. Consolidation and decay matrix

The current requirements imply **different forgetting semantics by state type**.

| State | Typical persistence | Main reinforcement | Main weakening | Resurrection |
|---|---|---|---|---|
| Traits | Run-long | none required | none required | survive |
| Hunger / energy / comfort / stimulation | continuous | time/context | satisfaction/recovery/activity | normalize as appropriate |
| Association valence | medium/run-long | emotionally relevant encounters | contrary experiences + slow drift | strong cases may survive |
| Attachment | run-long when strong | repetition, salience, uniqueness | long irrelevance/disuse, slowly | may survive |
| Belief/knowledge | medium/run-long | evidence/confirmation | contradiction; weak claims may fade | much survives |
| Episode | short→run-long by importance | recall/relevance/new linked evidence | forgetting/consolidation | explicit death episode inaccessible |
| Habit | medium/run-long | cue + repeated action | cue without action, disuse, changed context | generally may survive |
| Current intention | moment/short | continued action/progress | completion/interruption/reconsideration | no |
| Suspended intention | short/medium | unresolved relevance/curiosity | resolution, irrelevance, forgetting | normally no |
| Project | medium/run-long | visible progress/relevance | completion, rare abandonment/impossibility | world progress survives |
| Presence belief | medium/run-long | diagnostic intervention evidence | repeated failed tests, slowly | survive by default |
| Trust | medium/run-long, plastic | attributed helpful outcomes | attributed harmful outcomes | survive by default |
| Dependency | medium, plastic | reliable help + reliance | self-solution / expected help absent | may survive but should remain plastic |
| Transient emotion | seconds/minutes | current event/context | time/context resolution | no |

Do not replace this with one generic `decay_rate` merely for implementation convenience unless later architecture can still preserve these distinct behaviors.

---

# 22. Content vocabulary required by the model

The behavioral state is only meaningful if content supplies compatible semantic vocabulary.

The current minimum content-facing needs include:

## Subjects/scopes

- stable entity instance identity where history matters;
- type/category identity;
- place/region identity where learned place association matters;
- project identity/outcome;
- recurring actor identity.

## World semantics

- physical/semantic properties and capabilities;
- observable outcomes/effects;
- risk-relevant expected consequences;
- interaction/action vocabulary;
- project contribution/resource semantics;
- transformation semantics.

## Event/history semantics

- actor/action/target or equivalent event meaning;
- expected vs observed outcome where relevant;
- outcome diagnostic class such as success/partial progress/counterevidence;
- causal actor/source where authoritative;
- whether Wilson perceived/knows the event;
- enough context to recognize meaningful recurring cues.

## Presentation semantics

For sparse reaction/dialogue realization, the simulation must be capable of producing grounded semantic intents such as:

- fear/avoidance reaction to subject;
- accusatory disbelief toward suspected presence;
- resentful disbelief toward hated fire pit;
- triumphant celebration;
- concern at attached subject absence;
- proud completion reaction.

This is semantic grounding, not a requirement to expose internal state numerically in UI.

---

# 23. Representative-scene coverage summary

The inventory is validated by the scene suite rather than by abstract psychology alone.

### Association / attachment

Good Chair, Long Way Around, Traitorous Fire, Gerald, Storm Priorities, Moved Rock, lost favorite object.

### Knowledge / belief / confidence

Scientific Method, Bowling Ball, Mushroom, Too Hot, Traitorous Fire, Bottle.

### Spatial expectation / anomaly

Missing Spoon, Sabotaged Storage, Moved Rock, Interior Design.

### Episodic memory / consolidation

Traitorous Fire, Gerald, Brilliant Shortcut, regret regression, resurrection mushroom.

### Habit

Breakfast First, Good Chair, Inspection Day, Gerald food defense, Moved Rock, anticipation regression.

### Intentional continuity

Bottle, Scientific Method, One More Piece, Roof or Table?, Signal Fire.

### Project

One More Piece, Roof or Table?, Interior Design, Sabotaged Storage, Benefactor, Statue of Gerald.

### Presence relationship / attribution

Missing Spoon, Benefactor, Moved Rock, Sabotaged Storage, Miracle Fatigue, Gift Test/Experiment north stars.

### Emotion as transient modifier

Long Way Around, Traitorous Fire, Mushroom, Too Hot, Victory Lap, Gerald Is Missing.

### Immediate threat / intervention

Falling Palm, Brilliant Shortcut, Signal Fire.

No additional broad psychological primitive was required by the regression suite.

---

# 24. Explicit non-requirements for later architecture

Do not infer that the product needs durable primitives for:

```text
sanity
persistence
sociability
loneliness
playfulness
safety meter
cleanliness
orderliness
superstitiousness
faith separate from presence_belief
forgiveness
regret
routine
tradition
environmental ownership
global mood
persistent surprise
persistent frustration
universal utility score
complete world snapshot in Wilson memory
one knowledge score per object
```

The visible phenomena associated with these labels are currently produced by admitted state and derived interpretation.

Likewise, do not infer a requirement for:

- infinite procedural crafting;
- a general scientific planner;
- full autobiographical memory;
- universal causal inference over arbitrary domains;
- LLM-authored truth or memory;
- deep psychology merely to make Wilson appear human.

---

# 25. Data-model constraints that can now be derived without choosing architecture

The following are safe **requirements on any future design**, even though the implementation form remains open.

1. **Wilson-relative state must reference stable subjects at multiple scopes.** Instance-only and type-only storage are both insufficient.
2. **World truth and Wilson belief must be separable.** A mistaken Wilson must not mutate authoritative physics.
3. **Confidence is proposition-level.** Avoid a monolithic per-object knowledge percentage.
4. **Association valence and attachment must be independently representable.**
5. **Selected history must carry expected vs observed outcome and sometimes meaningful prior choice.**
6. **Repeated ordinary history must be consolidatable.** The model cannot require unbounded episode retention for every repetition.
7. **Habits need contextual cues and variable strength.**
8. **Projects need persistent visible world progress independent of Wilson's current action.**
9. **Presence belief, trust and dependency must be independently mutable.**
10. **Resurrection must support partial psychological persistence without conscious death recall.**
11. **Offline catch-up must be capable of applying ordinary state transitions while excluding major spectacle/death.**
12. **Derived decision state should not force persistent storage.** Attention, expectations, causal weights and action scores should be reconstructible wherever possible.
13. **Content must expose semantic consequences/evidence, not only animation results.** Wilson cannot learn from partial progress if the simulation cannot classify/describe what happened.
14. **Any optional LLM layer must consume grounded projections of this state and return bounded interpretation/expression, never become authoritative storage.**

These constraints are the intended input to the next architecture/data-model phase.

---

# 26. Remaining functional questions before architecture freeze

The large psychological questions are closed, but several **calibration/content-boundary** questions remain and should not be mistaken for missing primitives:

1. exact canonical baseline/range of the three traits;
2. qualitative-to-numeric calibration of drive urgency curves;
3. thresholds/saturation for association and attachment change;
4. belief-confidence update strength by evidence class;
5. how many episodes are retained/consolidated in practice;
6. habit formation/extinction pacing;
7. practical limit and salience behavior for simultaneous projects;
8. resurrection normalization details for drives/dependency;
9. offline caps for project/relationship/habit progression;
10. qualitative God Power cost classes and passive streak curve;
11. which authored historical projects/scenes are required for the first vertical slice;
12. which exact world properties/interactions are needed by that slice.

These can be calibrated after a first architecture proposal exists, provided that proposal preserves the functional distinctions in this document.
