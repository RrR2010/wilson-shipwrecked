# Representative Decision and Mutation Traces

## Status and purpose

This document validates the semantic contracts, orchestration phases and mutation-authority model against representative scenes that stress different parts of Wilson Shipwrecked.

It is a design regression artifact, not a scripted-scene implementation plan.

The traces intentionally show:

- authoritative state/events;
- Wilson observation;
- expectations;
- reconsideration triggers;
- candidate provenance;
- bounded evaluation contributions;
- selection/intentional transition;
- action progression and interruption class;
- grounded outcome;
- causal attribution where relevant;
- learning proposals;
- owner-local mutations;
- guard effects;
- deterministic/debug requirements.

Validated reference scenes:

1. `Scientific Method` — iterative learning and partial feedback;
2. `Sabotaged Storage` — anomaly, causal attribution and presence relationship;
3. `Brilliant Shortcut` — normal risk competition and fair emergent death;
4. `Falling Palm` — immediate-threat fast path and player intervention window.

---

# 1. Trace conventions

## State owner notation

```text
[WORLD]     World Simulation
[COG]       Wilson Cognition owner/store
[ACTION]    Action Resolution
[PROJECT]   Project System
[PLAYER]    Player Intervention
[DIRECTOR]  Event / Scene Director
[DECISION]  Decision / Reconsideration Pipeline
[LEARNING]  Memory & Learning Pipeline
[PRESENT]   Presentation
```

## Contract notation

Contracts are written as:

```text
ContractName(...)
```

Mutation is always shown against the owning system.

## Contribution notation

Numeric values are illustrative only.

The important property is finite semantic contribution identity, not a fixed formula or balance scale.

Example:

```text
CuriosityEvaluator   + bounded positive
RiskEvaluator        - bounded inhibition
ContinuityEvaluator  + bounded current-intention advantage
```

---

# 2. Scientific Method

## 2.1 Behavioral requirement

Canonical functional flow:

```text
goal
→ experiment
→ feedback
→ belief update
→ next candidate
→ partial progress
→ strategy refinement
```

The architecture must support a failed primary action that still yields useful diagnostic evidence.

---

## 2.2 Initial authoritative and Wilson-relative state

### [WORLD]

```text
coconut: intact
candidate stone A: stone-like, relatively fragile
candidate stone B: harder/heavier
both physically available nearby
```

Wilson does **not** read hidden hardness truth directly.

### [COG] beliefs

Conceptually:

```text
ordinary stone-like objects tend to be hard
confidence = medium/high

strong impact may open coconut
confidence = medium

stone A exact hardness
unknown / inferred from category
```

### [COG] state

```text
curiosity = canonical Wilson value
hunger = not immediately dominant
current intention = obtain/open coconut
```

---

## 2.3 Initial reconsideration

Trigger batch may contain:

```text
current tactic exhausted / need next step
salient unresolved coconut goal
novel usable stone affordance
```

[DECISION] builds `DecisionContext`.

### Perception

```text
PerceivedSubject(coconut)
PerceivedSubject(stone A, category≈stone, exact properties uncertain)
PerceivedSubject(stone B, if salient/visible)
```

### Candidate generation

Possible candidates:

```text
C1 = strike coconut using stone A
C2 = strike coconut using stone B
C3 = inspect/test stone A first
C4 = postpone coconut and do something unrelated
```

Candidate provenance may include:

```text
AffordanceIntentionSource
Curiosity/information source
current-intention continuation
```

### Evaluation

For `C1`:

```text
Need/usefulness contribution        positive
Expectation of useful impact       positive
Curiosity/information value         positive/moderate
Effort                              negative/small
Perceived risk                      low/moderate inhibition
Continuity                          positive
```

No evaluator knows authoritative hidden hardness.

### Selection

Seeded selection yields:

```text
SelectedIntention(test/open coconut using stone A)
```

[COG] commits current intention transition.

---

## 2.4 Action resolution

[ACTION] derives:

```text
ActionStep(strike coconut with stone A)
```

Interruption class after release/impact commitment:

```text
committed atomic consequence
```

[ACTION]/[WORLD] validate and resolve.

Authoritative result:

```text
coconut remains closed
stone A chips/cracks
impact feedback occurs
```

Contracts:

```text
ActionOutcome(
  primary_result = failure_to_open,
  authoritative_effects = stone_A_damaged,
  diagnostic_feedback = material_failed_under_impact
)

WorldEvent(stone A changed form/state)
```

---

## 2.5 Observation and immediate learning

Perception determines Wilson can observe:

```text
ObservedEvent(coconut did not open)
ObservedEvent(stone A chipped/cracked)
```

Expected-vs-observed comparison produces prediction error.

`LearningEvidence` preserves:

```text
direct observation
clear diagnostic result
scope = stone A / potentially bounded material/category inference
```

[LEARNING] proposes:

```text
BeliefEvidence(
  stone A is less suitable for high-impact use than expected,
  direct evidence,
  strong instance-level support
)

BeliefEvidence(
  category-level inference adjustment,
  weaker/bounded generalization
)

EpisodeCandidate(
  experiment produced surprising material failure
)
```

[COG] belief owner applies bounded updates.

### Guard checks

- one stone failure does not erase broad useful stone-category knowledge;
- instance evidence is stronger than category generalization;
- confidence remains bounded;
- contradictory future evidence can revise the result.

---

## 2.6 Same-chain reconsideration

The completed experimental action creates:

```text
ReconsiderationTrigger(COMPLETION)
ReconsiderationTrigger(STRONG_ANOMALY / prediction error)
```

Critical ordering:

```text
outcome
→ observation
→ immediate relevant belief update
→ one coalesced reconsideration
```

The next decision context therefore sees the revised belief.

Candidate set may now favor:

```text
C2 = try harder/heavier stone B
C3 = inspect alternative material
C4 = change technique
```

The **intention** `open/investigate coconut solution` may continue while the **action tactic** changes.

This is not stored as a giant procedural plan; it emerges from persistent goal continuity + revised expectations + affordances.

---

## 2.7 Debug trace requirements

A headless trace must answer:

```text
Why did stone A enter consideration?
What did Wilson expect?
What physically happened?
What did Wilson actually observe?
Why did the belief update at instance scope more strongly than category scope?
Why did the next tactic change?
```

No scene-specific `if scientific_method` logic is required.

### Result

**PASS.** Contracts/orchestration express iterative experimentation cleanly.

---

# 3. Sabotaged Storage

## 3.1 Behavioral requirement

Canonical flow:

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

This scene is the broad integration test for observation vs cause, episodic/history continuity and presence relationship.

---

## 3.2 Prior state

### [WORLD]

```text
materials stored in familiar area/container
```

### [COG]

Beliefs/expectations:

```text
materials are normally stored here
specific arrangement is familiar enough to recognize
```

Habits:

```text
retrieve materials from this storage location
```

Presence relationship may be neutral/weak or already partially established.

Project state may currently need stored material.

---

## 3.3 Player sabotage occurs while Wilson is absent

[PLAYER] validates intervention:

```text
ValidatedIntervention(move/displace stored materials)
```

Player God Power/cost updates under player-owner transaction semantics.

[WORLD] applies movement/displacement.

Authoritative contracts:

```text
WorldEvent(material locations changed)
WorldEvent(storage arrangement changed)
```

Wilson is not present and cannot perceive the intervention event itself.

Therefore:

```text
NO ObservedEvent(player moved materials)
NO immediate Wilson trust update
NO immediate causal attribution
```

This is a central authority/knowledge invariant.

---

## 3.4 Wilson later approaches storage

Current/project need makes the location salient.

Perception produces:

```text
ObservedChange(expected material absent)
ObservedChange(familiar arrangement mismatched)
PerceivedSubject(displaced material, if visible/search reveals it)
```

Expectation service compares current observation with Wilson-relative arrangement expectation.

Trigger batch:

```text
STRONG_ANOMALY
possibly action invalidation if retrieval step expected material in place
PROJECT_CHECKPOINT/blockage
```

One normal reconsideration follows.

---

## 3.5 Candidate generation

Possible candidates:

```text
C1 search nearby for missing materials
C2 inspect storage/container
C3 use alternative material
C4 postpone project
C5 improve/guard storage after recovery
```

If this is one anomaly, causal attribution may remain weak and mostly natural/unknown.

If several similar anomalies already exist in selected history, relevant episodes become part of context.

---

## 3.6 Causal attribution

[DECISION]/causal service receives only Wilson-visible evidence/history.

Hypotheses:

```text
natural displacement
self/misremembered
known actor (if plausible)
unknown ordinary cause
unseen presence
```

Inputs may include:

```text
pattern similarity across prior anomalies
lack of ordinary physical explanation
presence_belief prior
known actor opportunities
observation confidence
```

Optional LLM assistance is allowed only if this is an eligible ambiguous interpretation, and only as bounded reweighting among valid hypotheses.

Selected interpretation might become:

```text
unseen presence increasingly plausible
confidence = moderate
```

This remains Wilson-relative interpretation, not world truth.

---

## 3.7 Reaction and learning

Reaction derivation may produce:

```text
ReactionIntent(anger/frustration, target = suspected presence/storage anomaly)
```

[LEARNING] from the same grounded evidence snapshot proposes:

```text
BeliefEvidence(storage arrangement is unreliable under current conditions)
EpisodeCandidate(repeated unexplained storage disruption)
PresenceEvidence(
  presence existence/plausibility = positive,
  subjective consequence = harmful/frustrating,
  trust direction = negative
)
HabitEvidence(possible future inspection/guard routine reinforcement)
```

[COG] owners mutate independently:

```text
presence_belief may rise
trust may fall
habit may strengthen later after repeated guard behavior
belief about arrangement/reliability may update
selected episode may persist
```

### Important asymmetry

The player may have intended a joke, test or even indirect help.

That private intention does not appear in `PresenceEvidence`.

Trust follows Wilson's perceived consequence.

---

## 3.8 Adaptation

On subsequent reconsideration, candidate generation can now include:

```text
improve storage
inspect storage before relying on it
move materials elsewhere
create a project contribution that makes storage more robust
```

This arises from changed beliefs/history/habits/project opportunities rather than a bespoke `sabotaged_storage_mode`.

---

## 3.9 Guard checks

- repeated identical sabotage produces diminishing belief/relationship update;
- presence belief and trust remain separately bounded;
- negative trust does not force presence belief downward if evidence of agency is strong;
- director/health monitor cannot normalize trust back toward neutral;
- episodic memory growth remains bounded/consolidatable;
- player repeated intervention cannot directly set dependency/trust.

---

## 3.10 Debug trace requirements

Must answer:

```text
Did Wilson witness the intervention or only the result?
What arrangement did he expect?
Which anomalies were retrieved from history?
Which causal hypotheses existed?
Why did unseen-presence weight rise?
Why did presence_belief rise while trust fell?
What new future candidate became possible because of learning?
```

### Result

**PASS.** The graph preserves actual cause, observed result and inferred cause as separate stages.

---

# 4. Brilliant Shortcut

## 4.1 Behavioral requirement

Death or injury must be reconstructable as a legible chain:

```text
known shortcut
+ changed conditions
+ perceived risk
+ alternative route
+ Wilson's choice
+ physical consequence
```

No opaque hidden death RNG and no universal rational optimizer.

---

## 4.2 Prior state

### [COG]

Beliefs/history/habits may include:

```text
shortcut usually saves time/effort
shortcut succeeded before
route habit exists
current environmental conditions increase danger somewhat
```

Traits:

```text
risk_tolerance = stable Wilson value
```

### [WORLD]

```text
conditions changed: wet/slippery/windy/etc.
safer longer route remains physically available
shortcut remains physically possible but riskier
```

Wilson perceives enough of the changed conditions to form elevated risk expectation.

---

## 4.3 Normal reconsideration

Trigger may be ordinary route-choice/context transition.

Candidates:

```text
C1 use known shortcut
C2 take longer safer route
```

### Candidate C1 contribution trace

```text
HabitEvaluator             + bounded positive
EffortEvaluator            + relative advantage
Continuity/familiarity      + bounded positive
RiskEvaluator              - elevated inhibition from perceived current danger
RiskTolerance modulation   reduces/strengthens only risk term appropriately
Possible preference/history + bounded positive
```

### Candidate C2 contribution trace

```text
RiskEvaluator              less inhibition
EffortEvaluator            larger cost
Habit/familiarity          weaker
```

Neither candidate receives infinity or hardcoded outcome knowledge.

Seeded stochastic competition among meaningful candidates may choose `C1` even if `C2` is somewhat safer.

```text
SelectedIntention(use shortcut)
```

[COG] commits.

---

## 4.4 Action progression and commitment

[ACTION] derives traversal steps.

Before irreversible commitment, a major new perceivable hazard may trigger ordinary or immediate-threat reconsideration depending on urgency.

At the point Wilson jumps/steps into the committed dangerous segment:

```text
interruption class = committed atomic consequence
```

Late player suggestion or ordinary drive change cannot rewind the physical commitment.

[WORLD]/[ACTION] resolve deterministic/seeded physical consequences from authoritative conditions.

Possible grounded result:

```text
slip
fall
injury/death
```

Death is an authoritative physical outcome, not a cognition score.

---

## 4.5 Outcome and learning

If Wilson survives:

```text
ActionOutcome(injury/near miss)
ObservedEvent(pain/fall/route failure)
BeliefEvidence(shortcut dangerous under wet conditions)
AssociationImpact(route/place negative valence/relevance if justified)
EpisodeCandidate(near-death shortcut failure)
HabitEvidence(shortcut habit weakening/context differentiation)
```

If Wilson dies:

- physical death remains authoritative;
- resurrection policy determines which beliefs/associations survive;
- danger knowledge may persist even if explicit death episode is inaccessible, consistent with state requirements.

---

## 4.6 Guard checks

- risk tolerance modifies perceived-risk inhibition, not world danger probability;
- habit cannot overwhelm every counter-signal due bounded contribution;
- changed conditions can materially alter expectation even when habit is strong;
- no hidden death chance disconnected from world/action semantics;
- the health monitor cannot lower Wilson's risk tolerance merely because too many seeds die.

---

## 4.7 Debug trace requirements

Must answer:

```text
What did Wilson believe about the shortcut?
What changed in current conditions?
How did perceived risk differ from authoritative risk?
What alternatives existed?
Which bounded contributions favored each route?
Which seeded selection occurred?
At what action point did the consequence become committed?
Which physical facts caused injury/death?
```

### Result

**PASS.** Normal decision competition and authoritative action resolution remain cleanly separated.

---

# 5. Falling Palm

## 5.1 Behavioral requirement

This scene tests immediate threat as a separate fast decision regime and preserves a player intervention window without turning the player into direct Wilson control.

---

## 5.2 Authoritative event

[WORLD] detects/produces:

```text
palm begins falling toward Wilson's danger region
```

`WorldEvent(falling palm trajectory/state)` exists.

Threat response is allowed only if Wilson can perceive relevant danger in time.

Perception produces threat-relevant observation:

```text
ObservedEvent(palm falling / dangerous motion)
```

---

## 5.3 Immediate-threat trigger

Orchestration emits:

```text
ReconsiderationTrigger(THREAT, immediate)
```

This preempts ordinary normal reconsideration.

Normal candidates such as:

```text
continue table
inspect bottle
follow suggestion
sit in favorite chair
```

are excluded from the emergency candidate set.

---

## 5.4 Defensive candidate set

Depending on physical context:

```text
E1 dodge left
E2 dodge right
E3 retreat
E4 brace/use nearby cover if physically plausible
```

Evaluation is narrow and fast:

```text
physical feasibility
learned threat expectation
available time
perceived route safety
risk-response modulation where relevant
```

No ordinary project/preference utility competition is necessary.

Seeded selection may resolve among comparable defensive alternatives.

---

## 5.5 Player intervention window

Independently, [PLAYER] may have enough God Power to affect the environment.

Possible intervention:

```text
move/deflect object
alter falling obstruction within supported rules
```

Ordering remains explicit:

```text
player request
→ permission/cost validation
→ ValidatedIntervention
→ authoritative world effect
```

The player never executes Wilson's dodge directly.

If intervention changes the physical threat before Wilson's defensive action commits, Action Resolution validates against the new authoritative state.

If Wilson already committed to a dodge, his action continues unless the changed world invalidates it or creates a new threat.

---

## 5.6 Physical resolution

[ACTION]/[WORLD] resolve:

```text
defensive movement
palm trajectory
collision/no collision
injury/death
```

Grounded `ActionOutcome`/`WorldEvent`s follow.

If Wilson is hit, death/injury is authoritative.

If he escapes, the threat regime exits.

---

## 5.7 Post-threat cognition

After danger is no longer immediate:

```text
reaction
learning
normal reconsideration
```

If a prior intention was interrupted, intentional transition policy decides:

```text
resume
remain suspended
or discard if context changed
```

Example:

```text
continue roof work after recovering
```

may be reasonable, while an expired temporary opportunity may be discarded.

---

## 5.8 Learning and presence relationship

If the player visibly/unexplainedly saves Wilson:

```text
InterventionObservation(physical rescue effect)
→ causal attribution
→ PresenceEvidence
```

Potential owner-local consequences:

```text
presence_belief rises
trust rises if perceived as helpful
attachment/belief about hazard may change
selected episode may persist
```

Again, helpfulness is inferred from observed consequence, not supplied as player private intent.

---

## 5.9 Guard checks

- emergency does not use `+999999` utility;
- no accumulating safety drive is required;
- player intervention still pays/validates through player/world authority;
- Wilson's normal independence trait does not prevent involuntary physical rescue;
- suggestion influence remains irrelevant to direct emergency physics unless a suggestion arrives early enough to enter normal/fast cognition as a signal;
- no offline catch-up may resolve this rare spectacle/death while the player is absent under current policy.

---

## 5.10 Debug trace requirements

Must answer:

```text
When did the palm become perceivable?
Why did threat regime activate?
Which emergency candidates were physically feasible?
What defensive action did Wilson select?
Did the player intervene before or after action commitment?
What authoritative world state existed at collision resolution?
Why did Wilson live/die?
What did he infer about the unseen presence afterward?
```

### Result

**PASS.** Immediate-threat fast path composes with player intervention and normal post-event learning without hidden priority hacks.

---

# 6. Cross-scene findings

## 6.1 The contract set is expressive enough

No trace requires a new broad contract family or psychological primitive.

The same contracts compose across learning, anomaly attribution, ordinary risk and emergencies.

## 6.2 Ordering matters more than additional state

The most important architecture result is the ordering distinction:

```text
world truth
→ observation
→ grounded learning
→ reconsideration using updated Wilson-relative state
```

for same-chain experimental/anomaly outcomes.

This solves behavior that might otherwise tempt implementation to persist more transient state.

## 6.3 Action commitment must be semantic

`Brilliant Shortcut` and `Falling Palm` both require a clear semantic boundary after which physical consequence cannot be rewound by ordinary cognition.

This argues for action-step interruption classes/checkpoints in the concrete model.

## 6.4 Presence learning composes without privileged player knowledge

Both sabotage and rescue work through:

```text
world effect
→ Wilson observation
→ causal attribution
→ PresenceEvidence
```

No special direct `player_helped` / `player_hurt` cognition channel is needed.

## 6.5 Project logic remains decoupled

`Scientific Method` can operate without a formal project, while `Sabotaged Storage` may involve project needs. The same decision/action/learning contracts work in both cases.

This supports keeping `Project` first-class but not making it the universal planner.

---

# 7. Trace regression checklist

Any future architecture/data-model change must continue to satisfy these checks.

### Scientific Method

- partial failure can produce useful diagnostic evidence;
- immediate relevant learning can affect the next tactic;
- category inference remains bounded;
- unresolved intention may continue across tactic changes.

### Sabotaged Storage

- Wilson can observe a result without observing its cause;
- causal attribution uses only Wilson-accessible evidence;
- presence belief can rise while trust falls;
- player private intent is absent;
- repeated anomalies can alter future storage behavior without bespoke scene state.

### Brilliant Shortcut

- perceived risk differs from authoritative risk;
- alternatives and bounded contributions remain explainable;
- stochastic selection is seeded/replayable;
- committed physics cannot be rewound;
- injury/death derives from grounded world/action outcome.

### Falling Palm

- threat regime excludes ordinary candidate breadth;
- Wilson still selects/executes his own response;
- player intervention changes world truth, not Wilson's body command;
- intervention ordering relative to action commitment is reconstructable;
- post-threat presence learning uses observation + attribution.

---

# 8. Deliverable D gate

The representative traces validate the current contract/orchestration/mutation architecture without requiring bespoke structural hacks.

No new blocker was found in the tested scenes.

The architecture can proceed to the explicit implementation-readiness gate.