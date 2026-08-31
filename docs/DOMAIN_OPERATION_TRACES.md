# Functional Domain Operation Traces

## Purpose

These traces validate that the functional domain in `DOMAIN_MODEL.md` plus the operation surface in `DOMAIN_OPERATIONS.md` can **produce causal scene flows**, not merely store their final state.

They are deliberately language-neutral and shorter than implementation traces. Every arrow names a semantic domain operation/result rather than a method/API commitment.

---

# 1. Scientific Method — iterative partial feedback

```text
Wilson has intention: open sealed container
↓
QueryPhysicalAffordances(container/local context)
→ pull / hit-with candidates
↓
GenerateCandidates + EvaluateCandidate
→ inspect/pull selected
↓
ValidateAction + StartAction + ResolveCommittedAction
→ ActionOutcome(NO_EFFECT, feedback=lid_resists_pull)
↓
Perceive → ObservedEvent
↓
InterpretLearningEvidence
→ BeliefEvidence(container difficult_to_open)
↓
GenerateCandidates again
→ hit(container, wood)
↓
ResolveCommittedAction
→ ActionOutcome(FAILURE/PARTIAL,
   effects=wood transformed/broken,
   feedback=tool_failed_before_target)
↓
Perceive + Learn
→ belief about wood/tool suitability changes
↓
stone becomes salient as local impact-capable object
↓
Generate/Evaluate/Select hit(container, stone)
↓
ActionOutcome(PARTIAL, feedback=container_dented)
↓
Same-chain learning before reconsideration
→ promising impact strategy reinforced
↓
next hit variation selected
↓
ActionOutcome(SUCCESS, tag=seal_released)
→ transformation/open relation change
↓
Observed result
→ operational knowledge may consolidate
```

**Regression check:** no `container_opening_script`, recipe pair or scientific planner is required.

---

# 2. Sabotaged Storage — world truth vs expectation vs attribution

```text
Before scene:
WorldRelation: materials inside storage
Wilson belief: expected_relation(materials, inside, storage)
↓
Player RequestIntervention(move material)
→ validate capability/cost
→ world relation mutations
→ WorldEvents
↓
Wilson asleep / no perception
→ no immediate cognition update
↓
Later project contribution query needs material
↓
Wilson opens/inspects storage
→ Perceive current contents
↓
DeriveExpectations
→ expected material inside storage
↓
CompareExpectation
→ strong PredictionError
↓
GenerateCandidates
→ search for missing material
↓
Perception finds displaced pieces one by one
↓
EpisodeCandidates + repeated anomaly evidence
↓
DeriveCausalHypotheses
→ self / natural / known actor / unseen presence
↓
SelectAttribution
→ unseen presence increasingly plausible
↓
LearningProposalBatch
→ PresenceEvidence(presence_belief up, trust down if harmful)
→ Association/Habit evidence for storage guarding/rearrangement
↓
future candidate generation may include hide/secure/relocate materials
```

**Regression check:** no `sabotaged=true`, no direct Player→Trust mutation, no omniscient cause leak.

---

# 3. Storm Priorities — attachment vs urgency

```text
AdvanceEnvironment
→ weather intensifies
→ WorldEvents: wind moving vulnerable objects
↓
Perceive storm + moving possessions
↓
DeriveSalientSet
→ food, tool, attached decoration, shelter
↓
GenerateCandidates
→ secure food
→ secure tool
→ rescue decoration
→ retreat to shelter
↓
EvaluateCandidate
food: survival/need relevance
object: attachment + opportunity urgency
shelter: comfort/threat
↓
SelectIntention
→ one option wins without a hardcoded priority table
↓
Start/Advance carry/rescue action
↓
environment continues changing concurrently
↓
new gust creates stronger expiring opportunity
→ reconsideration trigger
↓
current action commitment rules decide whether Wilson can switch now
↓
World consequences persist: lost/moved/damaged objects
↓
Learning may later create storm-preparation beliefs/habits
```

**Regression check:** attachment can temporarily beat instrumental value without creating irrationality/chaos stats.

---

# 4. Signal Fire — Director opportunity without puppeteering

```text
QueryEligibleEvents
→ passing_boat eligible
↓
ActivateEvent
→ world opportunity: boat offshore
→ bounded DirectorContext: signaling opportunity urgency
↓
Perceive boat
→ strong salience / expectation
↓
GenerateCandidates from multiple sources
→ wave from beach
→ strengthen fire/smoke
→ fetch signaling material
→ continue unrelated urgent need if strong enough
↓
DirectorBiasEvaluator adds bounded relevance
↓
normal evaluation/selection chooses Wilson intention
↓
selected signaling action resolves through ordinary world/action rules
↓
boat event continues/expiring independently
↓
event resolves or expires based on world/result predicates
↓
Episode/knowledge/habit effects may follow
```

**Regression check:** Director never calls `force_signal_fire()` or freezes normal Wilson autonomy.

---

# 5. Falling Palm — immediate-threat fast path + intervention

```text
AdvanceEnvironment(storm)
→ palm condition crosses failure threshold
→ WorldEvent(crack / structural failure beginning)
↓
Perceive
→ ImmediateThreat detected
↓
GenerateDefensiveCandidates(threat)
→ run route A
→ run route B
→ dodge/cover where feasible
↓
QueryRoute
→ route A partially blocked by camp clutter
↓
SelectFeasibleDefense
→ defensive intention committed
↓
Player may RequestIntervention(move obstruction)
→ if supported and before relevant commitment boundary:
   world relation/transform changes
   → route query/result changes
↓
Action progression and falling-palm world process continue
↓
Committed impact/escape outcome resolved authoritatively
→ BodyEffect / world damage / survival
↓
Perception + learning
→ palm/storm/place danger belief/association possible
```

**Regression check:** no +Infinity utility, no physics rewind, and player help changes world facts rather than Wilson choice directly.

---

# 6. Brilliant Shortcut — fair emergent death

```text
Prior history:
Wilson belief/habit: fallen trunk is useful shortcut
↓
AdvanceEnvironment(rain)
→ trunk property/state becomes wet/slippery
↓
Wilson approaches destination with cargo
↓
Perceive trunk condition
→ expectation + perceived risk
↓
QueryRoute
→ shortcut: short/high current risk
→ long route: longer/lower risk
↓
Generate/Evaluate candidates
risk_tolerance attenuates inhibition
habit/previous success favors shortcut
cargo/effort affects both
↓
SelectIntention(cross via trunk)
↓
StartAction
→ checkpoint/commit progression
↓
cargo begins slipping
→ new event/reconsideration only while interruption semantics permit
↓
Wilson attempts correction / continues
↓
committed physical loss of balance
→ ActionOutcome + BodyEffect
↓
if vitality/lethal conditions cross death rule:
   WilsonBodyState.alive=false
↓
Run → AWAITING_DEATH_CHOICE
```

**Regression check:** death is reconstructable from changed world state + Wilson belief/history + autonomous choice + grounded consequence, never hidden death RNG.

---

# 7. The Experiment — testing the unseen presence

```text
Prior state:
presence_belief > baseline
episodes of unexplained intervention
↓
GenerateCandidates
→ deliberate test of presence becomes plausible intention
↓
Wilson arranges three objects
→ world relations committed by ordinary put/move actions
↓
Wilson forms/uses expected arrangement
↓
Intention enters waiting/test phase
↓
Player may intervene or remain silent

CASE A: player moves one object
  RequestIntervention
  → world relation/transform changes
  ↓
  Wilson later Perceives arrangement mismatch
  ↓
  PredictionError
  ↓
  Causal attribution compares ordinary causes vs presence
  ↓
  PresenceEvidence may strongly reinforce belief

CASE B: animal moves object
  ActorRuntimeState chooses ordinary activity
  → world change
  ↓
  Wilson perceives only result / incomplete cause
  ↓
  false presence attribution remains possible

CASE C: nothing happens
  waiting expectation expires
  ↓
  dependency/presence confidence may decrease modestly
```

**Regression check:** deliberate player testing uses the same arrangement, expectation and causal-attribution concepts as Missing Spoon/Sabotaged Storage; no communication protocol primitive is required.

---

# 8. Cross-trace conclusions

These traces exercise the highest-risk boundaries:

```text
World → Perception → Cognition
Decision → IntentionalState → Action Resolution
ActionOutcome → World / Learning / Project
Player Intervention → World → Perception
Director → Opportunity/Bias → Decision
Environment → World state → threat/risk
Body consequence → death lifecycle
```

No trace requires:

- a generic event bus with arbitrary mutation authority;
- scene-specific domain flags;
- direct Project/Director/Player commands to Wilson;
- object-pair recipe lookup;
- full animal cognition;
- omniscient Wilson learning;
- physics rollback after commitment.

## Result

**Functional operation regression: PASS.**

The next useful domain step is normalization of the predicate/effect/semantic-relation vocabulary and definition of aggregate command/query interfaces at the class-responsibility level, still without choosing implementation language.