# Guards, Stability and Bounded Self-Calibration

## Status and purpose

This document defines architectural and behavioral guardrails that keep Wilson Shipwrecked stable over long-running autonomous simulation without flattening personality, history, risk or emergent stories.

It builds on `ARCHITECTURE.md`, `STATE_REQUIREMENTS.md`, `BEHAVIORAL_MODEL.md` and `SCENE_VALIDATION.md`.

The central principle is:

> Self-calibration may stabilize opportunity and competition, but must not rewrite Wilson, world truth or history merely to force target metrics.

The intended result is **bounded homeostasis**, not opaque adaptive difficulty or an online learning system with unrestricted authority.

---

# 1. Guard taxonomy

Use four distinct layers of protection.

## 1.1 Domain invariants

Hard correctness constraints that must never be violated.

Examples:

- normalized values remain inside their declared domains;
- quantities cannot become negative unless the domain explicitly supports debt;
- probabilities/weights cannot become NaN/Infinity;
- invalid physical actions never execute;
- an entity cannot be simultaneously in mutually exclusive authoritative states;
- no offline catch-up death;
- LLM output cannot bypass authoritative validation;
- resurrection rules remain authoritative and cannot be overwritten by psychological update logic.

These are not balance knobs. Violations are bugs.

## 1.2 Local behavioral guards

Each mutable behavioral concept limits its own growth, decay and contribution.

Examples:

- bounded association values;
- diminishing returns on attachment reinforcement;
- bounded habit contribution;
- confidence saturation;
- dependency gain caps;
- finite emotional duration;
- project continuation bias caps.

These protect one subsystem from becoming numerically explosive.

## 1.3 Cross-system guards

Prevent positive feedback loops involving multiple valid systems.

Examples:

```text
likes rock
→ chooses rock
→ habit strengthens
→ chooses rock more
→ attachment strengthens
→ chooses rock forever
```

or:

```text
player helps
→ dependency rises
→ Wilson waits
→ player helps because Wilson waits
→ dependency rises further
```

Cross-system guards limit monopoly without pretending the underlying history did not occur.

## 1.4 Population / simulation health guards

Measured over long windows and many seeds.

These do not directly alter Wilson state. They detect unhealthy emergent distributions such as:

- one intention family occupying most waking time;
- zero project completion;
- excessive death frequency;
- no experimentation;
- excessive experimentation;
- rare-event starvation;
- runaway dependence;
- permanent idle loops;
- memory growth without bound.

They are primarily development-time calibration signals. A restricted subset may drive bounded runtime pressure adjustments.

---

# 2. General numerical policy

## 2.1 Prefer naturally bounded domains

Where a concept is semantically normalized, define a hard valid range.

Current examples:

```text
association.valence   [-1, +1]
association.attachment [0, 1]
presence_belief        [0, 1]
trust                  [-1, +1]
dependency             [0, 1]
belief confidence      [0, 1]
habit strength          [0, 1]
traits                  bounded canonical ranges
```

Values must never rely on an eventual downstream clamp to remain valid.

Updates themselves should respect the domain.

## 2.2 Use saturation rather than linear accumulation

Repeated identical evidence should produce diminishing changes.

Conceptually:

```text
remaining headroom = max - current
update = evidence_strength × learning_rate × remaining_headroom
```

The exact formula is an implementation/balance choice, but the required behavior is:

- early evidence can matter;
- repeated identical evidence has diminishing impact;
- contradictory evidence can still move established values;
- no value grows without bound.

For signed variables, movement toward each boundary should depend on remaining distance to that boundary.

## 2.3 Bound decision contributions independently

Each `IIntentionEvaluator` contribution should have a declared semantic range before combination.

Example conceptual budget:

```text
NeedEvaluator              bounded
HabitEvaluator             bounded
CuriosityEvaluator         bounded
RiskEvaluator              bounded inhibition
SuggestionEvaluator        bounded
ProjectEvaluator           bounded
OpportunityUrgency         bounded normal range
```

Do not allow one evaluator to emit arbitrary magnitudes that implicitly redefine every other evaluator's scale.

Immediate emergency is a separate decision regime rather than an evaluator returning `+1e9`.

## 2.4 Avoid hidden multiplication cascades

Multiplication is useful for semantic modulation, but uncontrolled products can collapse to zero or explode relatively.

Bad conceptual pattern:

```text
score *= hunger
score *= attachment
score *= habit
score *= mood
score *= director
...
```

Prefer a small number of explicitly meaningful transforms, then bounded combination.

Traits should modulate the term they semantically affect rather than multiply the entire candidate score.

---

# 3. Guarding traits

Traits are stable run-level disposition, not continuously learned values.

Current traits:

```text
curiosity
risk_tolerance
independence
```

Guards:

- initialize inside a deliberately narrow Wilson-canonical range;
- do not drift from ordinary outcomes;
- do not dynamically normalize toward population means;
- resurrection does not rewrite them;
- self-calibration never edits them to correct behavior statistics.

If future design allows trait shaping, it should be rare, bounded and explicit rather than an incidental side-effect of every action.

Reason: automatically changing traits to correct action distributions would erase run identity.

---

# 4. Drive guards

Current drives:

```text
hunger
energy
comfort
stimulation
```

## 4.1 Domain bounds

Each drive has a hard valid physiological/behavioral domain.

Time advancement and actions must saturate at endpoints rather than overflow.

## 4.2 Nonlinear urgency

Extreme physiological states should become disproportionately important without becoming global hard scripts.

Desired behavior:

```text
comfortable hunger → weak pressure
moderate hunger    → meaningful pressure
extreme hunger     → overwhelming normal deliberation pressure
```

Immediate threats can still override.

## 4.3 Stimulation anti-runaway

Stimulation must not create perpetual activity.

Guards:

- successful optional activity provides temporary stimulation relief;
- repeating the same stimulation source gives diminishing relief/value;
- low energy increases effort penalty for demanding stimulation activities;
- comfortable idle/rest remains valid;
- boredom raises optional candidate relevance, not random-action probability globally.

This creates variation without making Wilson hyperactive.

---

# 5. Association guards

Association contains:

```text
valence     [-1,+1]
attachment  [0,1]
```

## 5.1 Diminishing reinforcement

Repeated near-identical ordinary events should rapidly lose marginal impact.

Forty normal uses of the favorite rock should not push attachment through any conceptual ceiling or overwhelm all alternatives.

## 5.2 Subjective event strength

Association updates should use subjective consequence, not only objective event type.

Example:

```text
Gerald steals food while Wilson starving
> stronger negative impact
Gerald steals surplus food after eating
> weaker impact
```

## 5.3 Attachment does not universally increase action desire

Attachment raises relevance/attention when the subject is contextually involved. It must not be added as a universal positive action bonus.

This prevents high attachment to Gerald from forcing Wilson to approach Gerald constantly.

## 5.4 Slow drift, evidence-led reversal

Without interaction, association may drift slowly toward neutral where appropriate.

Meaningful contradictory encounters should dominate reversal.

Established grudges/preferences should resist one contradictory event but remain reversible over repeated evidence.

## 5.5 Anti-lock-in interaction with habits

Preference + habit feedback requires diminishing returns and repetition fatigue/stimulation effects.

The game should allow a favorite routine to remain recognizable while occasionally losing to novelty, urgency or another preference.

---

# 6. Belief/confidence guards

## 6.1 Proposition-level confidence only

Avoid a global `knowledge level` that can explode or become meaningless.

Confidence belongs to an individual claim.

## 6.2 Evidence quality caps update strength

Conceptual evidence quality order:

```text
clear direct observation / diagnostic experiment
> repeated consistent observations
> category inference
> coincidence
> suggestion without observed confirmation
```

Player suggestion alone is not authoritative evidence.

## 6.3 One observation cannot create universal certainty

Generalization has bounded scope and confidence.

A single stone opening a coconut must not establish a universal physical law at maximum confidence.

## 6.4 Contradictions remain effective near saturation

Confidence saturation must not make beliefs mathematically irreversible.

Strong counterevidence should still move a high-confidence belief.

## 6.5 Exception handling prevents category collapse

One anomalous subtype should normally produce an exception/subtype belief before erasing a broad useful prior.

Example:

```text
stones usually hard
+
pumice-like stone unexpectedly fragile
```

should not immediately become:

```text
stones are not hard
```

---

# 7. Habit guards

Habits are a major positive-feedback risk.

## 7.1 Bounded habit strength

Habit reinforcement saturates.

## 7.2 Bounded decision influence

Maximum habit strength does not equal guaranteed execution.

Habit contributes a bounded bias and can lose to:

- urgent needs;
- current commitment;
- salient novelty;
- strong danger;
- directed opportunity;
- environment invalidation.

## 7.3 Cue-without-action extinction

A habit should weaken especially when:

```text
cue occurs
+
action is available/relevant
+
Wilson repeatedly does something else
+
no serious negative consequence follows
```

This is stronger evidence of extinction than passive elapsed time.

## 7.4 Repetition fatigue

Repeated execution may strengthen habit while simultaneously reducing stimulation value.

This intentional opposing feedback prevents established routines from consuming all discretionary time.

## 7.5 No emergency override

Habits never bypass the immediate-threat regime.

---

# 8. Emotion guards

Emotions are transient behavioral modifiers, not persistent accumulating bars.

Guards:

- fixed/bounded intensity domain;
- finite time horizon;
- subject/cause scoped where possible;
- decay after event context;
- repeated triggering may create durable belief/association updates, but not an ever-growing emotion reservoir;
- emotion modifies relevant evaluations rather than globally multiplying all choice scores.

Examples:

```text
fear(subject)
→ threat salience / avoidance

anger(culprit)
→ confrontation / reduced patience toward culprit
```

A fear of mushrooms must not globally suppress unrelated beach exploration.

---

# 9. Project guards

## 9.1 Few simultaneous persistent projects

Keep active/paused project count small enough for player readability.

This is a narrative guard as much as a CPU guard.

## 9.2 Bounded continuation bias

Current-intention inertia and completion proximity may strongly favor continuation but cannot indefinitely suppress physiological urgency.

## 9.3 Stage checkpoints

After a meaningful project stage, continuation pressure should normally fall enough for ordinary life to re-enter competition.

## 9.4 Resource conflict remains open

Do not reserve all future-compatible resources for a project as soon as it begins.

Reservation occurs only where an actual action/stage commits a participant.

## 9.5 Stalled project pressure cannot grow forever

A project lacking resources should not accumulate arbitrary hidden urgency until it dominates everything.

Instead it may:

- produce procurement intentions when contextually useful;
- lose salience temporarily;
- remain paused;
- eventually be reconsidered/abandoned if conditions meaningfully change.

---

# 10. Presence relationship guards

State:

```text
presence_belief [0,1]
trust           [-1,+1]
dependency      [0,1]
```

## 10.1 Separate update channels

Helpful and harmful anomalies may both increase presence belief.

Trust direction depends on perceived consequence and attribution.

Dependency depends on reliable assistance and Wilson behavior, not merely trust.

This prevents one scalar feedback loop.

## 10.2 Attribution-confidence gating

Do not update trust/dependency strongly when Wilson has low confidence that the presence caused the event.

## 10.3 Dependency gain has diminishing returns

Repeated identical assistance cannot push dependency upward linearly forever.

## 10.4 Dependency requires behavioral expression

Dependency should rise more strongly when Wilson actually changes behavior because help is expected, e.g. waits or requests intervention.

This prevents invisible assistance alone from automatically making Wilson helpless.

## 10.5 Non-response primarily reduces expectation/dependency

When Wilson explicitly expects help and none arrives:

- assistance expectation falls;
- dependency may fall;
- trust falls only modestly unless context made help especially expected.

Ordinary player silence does nothing.

## 10.6 Independence modulates acquisition, not hard cap

High independence slows dependency formation but does not make it impossible.

Self-calibration must never rewrite independence because dependency became high.

---

# 11. Intention competition guards

## 11.1 Small candidate set

Candidate generation is bounded before evaluation.

Wilson should not score the Cartesian product of all entities × verbs × goals every reconsideration.

## 11.2 Plausibility floor

Candidates that are technically possible but contextually meaningless stay outside the final probability distribution.

Randomness selects among plausible candidates; it does not rescue zero-motivation nonsense.

## 11.3 Hysteresis

The current intention receives continuity bias / switching cost.

A new candidate must exceed the current intention by a meaningful margin to cause ordinary interruption.

Immediate emergency bypasses hysteresis.

## 11.4 Probability temperature bounds

If probabilistic selection uses a temperature/noise concept, its range must be bounded by context class.

Do not let boredom or an LLM proposal arbitrarily increase global randomness.

## 11.5 Candidate family anti-monopoly

Development metrics should detect if one candidate family consumes an excessive fraction of discretionary decisions.

Runtime correction, if used, should target repeated opportunity selection through temporary diminishing novelty/repeat value, not by editing Wilson's personality.

---

# 12. Memory growth guards

Memory is a storage and behavioral runaway risk.

## 12.1 Episode admission threshold

Not every action becomes an autobiographical episode.

Create/select episodes based on importance drivers such as:

- surprise;
- consequence;
- attachment;
- emotion;
- meaningful choice;
- rarity;
- project/relationship milestone.

## 12.2 Consolidation

Repeated ordinary episodes consolidate into:

- beliefs;
- associations;
- habits;
- aggregate project/relationship facts.

Then redundant individual episodes may fade.

## 12.3 Bounded active recall context

Decision and LLM context receive only selected relevant memories, never the full run history by default.

## 12.4 Preserve exceptional history

Do not solve memory growth by aggressively deleting precisely the unusual events that create personal stories.

Use significance + redundancy, not only age.

---

# 13. Event Director guards

## 13.1 Cooldowns and eligibility

Rare events require explicit cooldown/frequency envelopes and prerequisites.

## 13.2 No pity timer for every piece of content

The game should not guarantee all rare content appears in every run.

Self-calibration may prevent pathological starvation of broad event classes, but should not turn rarity into a checklist.

## 13.3 Directed-scene budget

Limit the fraction of active play dominated by strongly directed scenes.

The normal living-diorama simulation remains the default.

## 13.4 Event pressure cannot invalidate history

The director may create opportunities and temporary bias, but must not rewrite beliefs, traits, inventory or relationships to manufacture eligibility.

---

# 14. God Power guards

## 14.1 Hard currency bounds

God Power has defined min/max/cap semantics. Offline accumulation is capped.

## 14.2 Generation and streak saturation

Passive non-intervention acceleration reaches a cap. It does not grow exponentially forever.

## 14.3 Intervention cost stability

Costs primarily reflect causal/physical magnitude and improbability.

Do not dynamically make an intervention expensive merely because Wilson happens to care deeply about the target.

## 14.4 Reward farming protection

If amusing scenes grant God Power, repeated near-identical behavior should have strongly diminishing or zero repeat reward.

Prefer milestone/novelty-based reward over raw event count.

---

# 15. Death-frequency guards

Death is allowed and important, but uncontrolled autonomous death frequency can destroy attachment.

## 15.1 Never directly lower Wilson's risk tolerance at runtime to hit a target death rate

That would rewrite personality.

## 15.2 Control opportunity pressure instead

Safe runtime-adjustable levers include bounded changes to:

- frequency of catastrophic environmental opportunities;
- clustering/cooldown of lethal hazards;
- availability of ordinary safer alternatives;
- director-generated high-risk opportunities.

These operate on the world/opportunity distribution, not Wilson's identity.

## 15.3 Preserve legitimate consequences

Once a grounded lethal situation exists, do not secretly nerf physics because recent global death rate is high.

Self-calibration acts before opportunity generation, not after Wilson commits to a visible consequence.

---

# 16. Headless health metrics

Calibration must be based on distributions across many seeds and long horizons, not on anecdotal single runs.

Recommended development metrics include:

## Choice / activity

- waking idle fraction;
- action-family distribution;
- intention switch rate;
- aborted-action rate;
- repeated-action streak lengths;
- candidate-set size distribution;
- percentage of choices where top candidates are close vs dominant.

## Drives

- time spent in extreme hunger/energy states;
- crisis frequency;
- recovery time;
- proportion of decisions dominated by each drive.

## Exploration / knowledge

- experiment frequency;
- useful discovery frequency;
- repeated failed experiment loops;
- confidence saturation distribution;
- false-belief lifetime;
- successful correction frequency.

## Associations / habits

- attachment distribution by subject class;
- number of highly attached subjects;
- habit strength distribution;
- average habit lifetime;
- habit execution share;
- extinction frequency;
- favorite-choice monopoly rate.

## Projects

- projects started/completed/abandoned;
- completion-time distribution;
- percent waking time spent on projects;
- stalled-project duration;
- resource-conflict outcomes.

## Presence/player relationship

- presence belief trajectory;
- trust trajectory;
- dependency trajectory;
- wait-for-miracle frequency;
- refusal/suggestion acceptance distribution;
- fraction of interventions Wilson notices;
- attribution accuracy / false-positive rate.

## Narrative rhythm

- ordinary routine time;
- microevent frequency;
- rare-event frequency;
- directed-scene fraction;
- event clustering;
- persistent-consequence frequency;
- recurrence/callback rate.

## Risk/death

- dangerous-action frequency;
- near-death frequency;
- death rate per in-game day;
- death cause distribution;
- intervention save rate;
- resurrection frequency.

## Memory/performance

- active episode count;
- consolidation/deletion rate;
- average relevant-memory query size;
- simulation cost by phase;
- decision reconsiderations per simulated minute.

---

# 17. Health envelopes, not single targets

Do not calibrate toward exact scalar targets such as:

```text
death_rate = exactly 0.031/day
```

Use broad acceptable envelopes and distributions.

Example conceptual policy:

```text
healthy:
  project time neither ~0% nor ~90%
  habits visible but not monopolizing
  dependence can become high in some runs but not almost every assisted run
  rare events genuinely rare but not globally unreachable
```

Different seeds and Wilson trait variation should produce legitimate variance inside the envelope.

---

# 18. Runtime self-calibration: allowed levers

Runtime adaptation should be conservative, slow and bounded.

Good candidates:

## 18.1 Event pressure / cooldown normalization

If event opportunities have clustered excessively, increase cooldown pressure temporarily.

If broad environmental novelty has been absent for an unusually long period, gently increase eligible ordinary novelty opportunities.

## 18.2 Anti-repeat opportunity pressure

Repeated selection of the same discretionary activity can temporarily reduce its novelty/stimulation contribution without weakening the underlying habit/attachment.

This changes short-term attractiveness, not history.

## 18.3 Resource/ecology replenishment envelopes

Keep basic renewable resources inside authored ecological availability ranges where required to avoid dead worlds, without spawning resources directly in response to Wilson's hidden needs.

## 18.4 Director pacing

Maintain broad rhythm between ordinary time, microevents and rare/directed opportunities.

Do not force a specific story; only regulate opportunity density.

## 18.5 Computational budgets

Adapt candidate search breadth, memory-query budget or background update cadence within semantic-safe limits to preserve performance.

---

# 19. Runtime self-calibration: forbidden levers

Do not automatically change these merely to improve health metrics:

```text
Wilson traits
learned beliefs
association valence/attachment
habit strength/history
presence belief/trust/dependency
project progress
physical properties/rules
past episodes
player God Power balance mid-run beyond documented economy rules
```

These are part of the actual run history/identity.

If a value becomes extreme because of legitimate history, the world should normally create natural opportunities for correction rather than silently normalizing the value.

Examples:

- high dependency can fall when help is absent;
- strong fear can weaken through safe exposure;
- strong habit can weaken through cue-without-action;
- wrong beliefs can encounter counterevidence.

This is **systemic correction**, not hidden stat correction.

---

# 20. Prefer counter-pressure over normalization

A key design rule:

> When a system risks monopolization, first add a semantically valid opposing pressure rather than directly normalizing the stored state.

Examples:

```text
habit repetition
↔ declining stimulation value

project commitment
↔ rising hunger/energy pressure + stage checkpoints

fear avoidance
↔ urgent goals + safe exposure opportunities

dependency
↔ unanswered expectations + independence

attachment lock-in
↔ saturation + novelty + opportunity context
```

This keeps visible behavior causally understandable.

---

# 21. Guard observability

Every evaluator and updater should support development-time explanation.

For a selected decision, debug tooling should be able to show conceptually:

```text
candidate: continue_roof
  project value        +...
  completion proximity +...
  continuity           +...
  hunger inhibition    -...
  effort               -...

candidate: eat_food
  hunger relief        +...
  habit                +...
  switching cost       -...
```

For a state update:

```text
Gerald attachment:
  previous
  event evidence
  bounded delta
  saturation effect
  resulting value
```

This is essential for detecting runaway loops and tuning safely.

Player-facing UI should not expose these numbers.

---

# 22. Guard failure policy

Development builds should treat invariant violations aggressively:

- assert or emit high-severity diagnostics for NaN/Infinity/out-of-domain state;
- log the seed, simulation time, Wilson state and causal event chain;
- capture the last bounded sequence of authoritative events and decisions;
- make failures reproducible headlessly.

Production builds may clamp as a final containment mechanism where necessary, but clamping should generate diagnostics and must not be the primary balance mechanism.

---

# 23. Recommended calibration workflow

Use a layered workflow:

```text
1. unit-test local invariants and update bounds
2. run deterministic scene regression cases
3. run long single-seed simulations
4. run many-seed population simulations
5. compare health distributions
6. identify responsible subsystem/contribution
7. tune local semantic curves/limits first
8. tune cross-system counter-pressure second
9. only then consider bounded runtime pacing adaptation
```

Never begin by adding global correction hacks.

---

# 24. Architectural consequence

The architecture in `ARCHITECTURE.md` should make guards composable:

```text
IIntentionEvaluator
  → bounded contribution contract

ILearningProcessor
  → bounded state-update contract

State owner
  → domain invariant enforcement

Game Orchestrator
  → scheduling/reconsideration budgets

Health Monitor / analytics
  → observation, not arbitrary mutation

Event Director
  → limited runtime pacing adaptation
```

A future `SimulationHealthMonitor` may compute rolling health indicators, but it should be read-only by default. Any adaptive controller must use a narrow explicitly whitelisted set of pacing levers.

---

# 25. Current stance on "self-calibrating"

Wilson Shipwrecked should be **self-stabilizing more than self-balancing**.

Self-stabilizing means:

- state variables saturate;
- repetition has diminishing returns;
- habits can extinguish;
- beliefs can be contradicted;
- dependencies can recover;
- projects yield to life;
- event density is bounded;
- resource/world opportunities remain viable;
- no numeric accumulator grows without control.

Self-balancing would mean changing Wilson or world truth to force desired averages. Avoid that.

The player should be able to create an unusually dependent, fearful, attached or chaotic history. The guard system exists to prevent mathematical/pathological runaway, not to prevent meaningful extremes.