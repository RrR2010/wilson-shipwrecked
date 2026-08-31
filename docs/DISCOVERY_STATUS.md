# Product / Architecture Status

## Current stage

The project has completed the **behavioral discovery → state inventory → architecture → contracts → orchestration → mutation authority → representative trace validation → final pre-domain gameplay regression** sequence.

The architecture implementation gate remains **PASS** after the final gameplay-design review.

Current work should now proceed into:

```text
concrete domain data model
module/package dependency layout
headless first vertical slice
Godot presentation integration after domain proof
```

Do not restart product psychology or architecture discovery from first principles unless implementation evidence breaks a documented invariant or representative regression scene.

Completed sequence:

1. product fantasy and player-role discovery;
2. interaction/property/knowledge discovery;
3. psychology research and reduction;
4. independent representative-scene catalog;
5. scene triage and detailed behavioral analysis;
6. 23 Must-have scene × system matrix;
7. 12-case regression suite;
8. functional persistent-state inventory;
9. architecture responsibility decomposition;
10. guard/self-stabilization analysis;
11. semantic simulation contract catalog;
12. simulation update-phase/orchestration specification;
13. mutation authority matrix;
14. detailed representative decision/mutation traces;
15. architecture implementation gate;
16. final gameplay-envelope regression covering long-run progression, property-driven interaction/discovery, God Power capability boundaries, death/run termination, Legacy Knowledge, Diary semantics and Luck.

---

## Document precedence

For work affecting Wilson behavior, simulation state, architecture or implementation boundaries, use this order:

1. **`BEHAVIORAL_MODEL.md`** — validated functional Wilson model;
2. **`STATE_REQUIREMENTS.md`** — persistence, scope, lifetime, decay/offline/resurrection/cross-run semantics;
3. **`SCENE_VALIDATION.md`** — behavioral evidence and regression suite;
4. **`ARCHITECTURE.md`** — system boundaries, authority and composition;
5. **`SIMULATION_CONTRACTS.md`** — semantic cross-system contracts;
6. **`SIMULATION_ORCHESTRATION.md`** — clocks, ordering, reconsideration, interruption, learning timing and offline orchestration;
7. **`MUTATION_AUTHORITY.md`** — read/propose/mutate/observe ownership matrix, including player-profile/Legacy/Diary boundaries;
8. **`DECISION_TRACES.md`** — representative end-to-end architecture regressions;
9. **`IMPLEMENTATION_GATE.md`** — current readiness decision and implementation sequence after the final gameplay review;
10. **`GUARDS_AND_CALIBRATION.md`** — invariants, bounded contributions and stabilization policy;
11. **`AI.md`** — runtime LLM authority/fallback boundary;
12. **`PRODUCT.md`** — player experience, modes, intervention rules, open-ended progression, death/run lifecycle and presentation intent;
13. **`SIMULATION.md`** — world/property/action/discovery vocabulary and property-driven interaction model.

Where older provisional psychology language conflicts with `BEHAVIORAL_MODEL.md`, `STATE_REQUIREMENTS.md` or `SCENE_VALIDATION.md`, the newer behavioral documents win.

Where implementation-oriented wording conflicts with accepted responsibility boundaries/contracts/orchestration, the architecture-contract documents above win unless a later documented implementation decision explicitly supersedes them with regression evidence.

`MUTATION_AUTHORITY.md` is the current canonical clarification for the broader **player-side domain authority family**: active-run intervention state and global player-profile/Legacy/Diary state may be separate concrete aggregates/modules even though they share the `PLAYER` authority family in the matrix.

Stage-transition context lives under `docs/handoffs/`; handoffs guide sequencing but are not competing canonical specifications.

---

## Current validated behavioral core

### Stable traits

```text
curiosity
risk_tolerance
independence
```

### Core drives

```text
hunger
energy
comfort
stimulation
```

### Persistent personal continuity within a run

```text
beliefs / knowledge + confidence + scope
associations: valence + attachment
selected episodic history
habits
current/suspended intentions
projects
presence relationship: presence_belief + trust + dependency
```

### Derived / transient behavior

```text
attention / salience
expectations
candidate intention tendencies
causal interpretation weights
prediction error / anomaly strength
fear / anger / joy-excitement / reactions
```

### Explicitly rejected as independent psychological primitives for now

```text
sanity
persistence
sociability
loneliness
playfulness
safety as an accumulating drive
cleanliness
orderliness
superstitiousness
faith separate from presence_belief
forgiveness
regret
routine
tradition
environmental ownership
global mood / persistent valence-arousal
chaoticity
```

`Luck` is not Wilson psychology. It is bounded chance favorability derived from normally-owned modifier sources and is only read by explicitly luck-sensitive random resolution.

These visible phenomena remain compositional unless new evidence proves otherwise.

---

## Current gameplay/domain constraints

The final pre-domain review established the following rules that concrete modeling must preserve.

### Open-ended progression

There is no macro escape objective, campaign endpoint or level-scaling progression.

Long-run evolution comes from:

```text
material/world development
+ accumulated knowledge
+ history/relationships/habits
+ projects/infrastructure
+ broader eligibility of authored/systemic possibilities
```

Runs may naturally last from weeks to years. Long-run mortality pressure may increase only through bounded exposure to dangerous/unusual opportunities; grounded physics and committed consequences are never secretly rewritten to force death.

### Property-driven interaction and crafting

The generic interaction model is **not an object-pair recipe catalog**.

Required direction:

```text
semantic action roles
+ participant properties/capabilities
+ contextual predicates
→ grounded effect/transformation
```

For example, coconut opening should be expressible through reusable impact-tool capability, hardness/impact and target breakability/resistance rather than separate `stone+coconut`, `hammer+coconut`, etc. recipes.

Transformation forms and unusual exceptions may remain authored/bounded. Procedurality comes from compatible participants satisfying reusable predicates.

### Discovery and player knowledge

Semantic prerequisites determine when an exploration/hidden possibility is eligible. Once Wilson encounters/performs an eligible exploration and observes a meaningful result, there is no separate RNG discovery gate that withholds the knowledge.

The normal chain is:

```text
requirements satisfied
→ generic exploration available
→ grounded result observed
→ Wilson learns semantic interaction
→ player-facing semantic knowledge becomes available
```

There is no visible recipe catalog or technology tree. Hints should normally arrive through diegetic content/events rather than privileged requirement UI.

### God Power and intervention capabilities

God Power amount determines intervention budget, not capability unlock.

Player affordances are explicit per supported object/environment capability. Enough currency does not make every entity draggable/manipulable.

A supported intervention may have a grounded lethal consequence for Wilson; no generic anti-homicide guard is required.

Wilson's psychological response depends only on perception + attribution + ordinary learning, never on the player's private helpful/harmful intention.

### Death, resurrection and End Run

After a coherent death sequence, the player always chooses:

```text
Resurrect
or
End Run
```

Resurrection is free and unlimited. Wilson does not consciously remember death, but immediate fear/body-state effects and durable learned danger/negative association may remain through normal psychological primitives.

End Run permanently closes the island/world and triggers player-level archival/Legacy processing before a fresh run begins.

### Legacy Knowledge

Legacy Knowledge is player-global cross-run operational knowledge, not Wilson autobiographical memory.

```text
completed-run Wilson knowledge
→ filter legacy_eligible
→ weighted bounded selection
→ global Legacy Knowledge
→ seed next Wilson's initial semantic knowledge
```

It does not transfer episodes, relationships, object instances, places, death facts or the source memory of learning the interaction.

The player may clear the global Legacy/progression state.

### Diary

There is one player-facing **Diary** surface containing semantically distinct information classes:

```text
Wilson-grounded current-run narrative/history
+
player-level statistics / important chronology / achievements
+
rare-event records and supported screenshots
+
archived completed-run summaries
```

One UI surface does not imply one undifferentiated authority/store. Wilson memory, player archive semantics and screenshot/media storage retain separate ownership.

### Luck

Preferred semantic model:

```text
neutral Wilson baseline
+ bounded active modifiers from world/content context
→ derived effective_luck
```

Luck biases only explicitly declared unresolved chance alternatives toward more/less favorable outcomes for Wilson.

Luck does not:

- control how frequently rare events occur;
- create event eligibility;
- legalize impossible actions;
- alter Wilson decision scores directly;
- reverse committed physics;
- rewrite grounded outcomes.

Wilson does not read the value. He may form correct or incorrect ordinary beliefs about lucky objects/contexts by observing coincidences.

No separate persistent `chaoticity` state is required. Quiet-vs-busy pacing remains bounded Director/opportunity pressure.

---

## Current architecture summary

### State-owning / authoritative systems/families

```text
World Simulation
Wilson Cognition
Project System
Player-side domain
Event / Scene Director
Action Resolution
```

The player-side domain includes two conceptually separable responsibilities:

```text
active-run intervention:
  God Power
  non-intervention progression
  intervention permissions
  suggestion windows

global player profile:
  Legacy Knowledge
  lifetime statistics
  selected unlocks
  Diary archive metadata
```

Concrete package layout may split those into separate aggregates/modules. Persistence stores them but does not invent domain policy.

### Major pipelines

```text
Decision / Reconsideration Pipeline
Memory & Learning Pipeline
```

### Derived / composable services

```text
Perception
Salience / Attention
Expectation
Candidate Intention Generation
Intention Evaluation / Competition
Causal Attribution
Reaction / Emotion
Luck-effective-value query / chance bias where declared
```

### Adapters

```text
Godot presentation
persistence backend / serialization
LLM provider
analytics / debug tooling
```

---

## Current semantic contract summary

Central contracts:

```text
ObservedEvent
SelectedIntention
ActionOutcome
```

Additional contract families cover:

```text
world/perception
decision/reconsideration
action progression
learning evidence
projects
player intervention
director opportunities
presentation projection
```

Key invariants:

- world truth, Wilson observation and Wilson belief remain separate;
- authoritative interaction rules remain separate from Wilson semantic knowledge;
- `SelectedIntention` is Wilson-relative choice, not physical success;
- `ActionOutcome` is grounded authoritative action feedback;
- learning crosses boundaries as semantic evidence/proposals;
- each durable state owner mutates only its own state;
- transient contracts are not persisted merely for convenience;
- deterministic traces preserve decision causality.

Run termination, Legacy selection/bootstrap and Diary archival are now explicit **domain lifecycle boundaries** in `MUTATION_AUTHORITY.md` and `IMPLEMENTATION_GATE.md`. Concrete contracts for those boundaries should be defined during domain modeling rather than delegated to persistence callbacks.

---

## Current orchestration summary

Accepted update categories:

```text
authoritative simulation time
physical/action progression
slow simulation state
event-driven cognition
event-driven learning
maintenance/consolidation
presentation cadence
offline coarse stepping
```

Accepted rules:

- render FPS is not authoritative time;
- Wilson does not fully replan every tick;
- normal reconsideration triggers coalesce/debounce;
- current intention receives bounded hysteresis;
- immediate threat is a separate fast path;
- actions distinguish immediate-safe, checkpoint and committed-atomic interruption classes;
- intentions explicitly continue, suspend, complete or discard;
- committed physics cannot be rewound by late cognition or Luck;
- same-chain learning may precede reconsideration when the new knowledge is required for the next decision;
- maintenance stays outside immediate semantic outcome chains;
- offline simulation reuses normal owners under conservative substitutions;
- gameplay RNG order remains deterministic and separate from presentation randomness;
- Luck-sensitive random resolution occurs only before authoritative commitment and only among already-valid alternatives;
- End Run is an explicit lifecycle transaction rather than save-file deletion behavior.

---

## Mutation authority summary

`MUTATION_AUTHORITY.md` confirms one normal owner per durable state family.

Highest-risk boundaries to preserve during implementation:

1. `Action Resolution ↔ World Simulation` — coordinated physical execution and property-driven transformations;
2. `Decision Pipeline → IntentionalState` — selected-intention commit;
3. `Learning Pipeline → cognition stores` — evidence-based owner-local mutation;
4. `ActionOutcome → Project System` — grounded project progression;
5. `Player Intervention → World Simulation` — atomic cost/effect semantics;
6. `Director / Action Resolution → Luck-sensitive RNG` — bounded chance favorability without causal rewrites;
7. `Current-run Wilson knowledge → Player Profile → Next-run Wilson initialization` — Legacy Knowledge selection/bootstrap;
8. `Wilson history / Player Profile / Presentation` — one Diary UI without shared truth ownership;
9. `Persistence → owners` — controlled restore without shadow authority.

---

## Representative trace validation

`DECISION_TRACES.md` validates the core architecture against:

```text
Scientific Method
Sabotaged Storage
Brilliant Shortcut
Falling Palm
```

Results:

- partial experimental failure supports immediate evidence-led strategy refinement;
- actual cause, observed effect and inferred cause remain separate;
- presence belief can rise while trust falls;
- normal risk competition remains bounded/explainable;
- death/injury derives from grounded physical outcomes;
- committed action semantics prevent causal rewinds;
- immediate-threat fast path composes with player intervention;
- no new broad psychological primitive or shared mutable owner was required.

The final gameplay review adds implementation regressions that should be encoded as focused headless fixtures after the core slice:

```text
property-composed interaction with multiple valid tools
unknown exploration → learned semantic interaction
God Power supported vs unsupported affordance
lethal player intervention
unlimited resurrection with retained danger learning
End Run → weighted Legacy selection → new-run knowledge seed
single Diary surface with separate Wilson/player record semantics
bounded Luck-sensitive chance variant
```

---

## Guards and calibration summary

Non-negotiable rules:

- normalized state has hard finite bounds;
- update curves saturate/diminish before clamp;
- evaluator contributions have finite declared envelopes;
- strong contradictory evidence can move high-confidence beliefs;
- repeated identical evidence has diminishing returns;
- no huge-score/infinity priority hacks;
- immediate emergency is a separate regime;
- runtime self-calibration only touches explicitly whitelisted pacing/opportunity variables;
- self-calibration does not rewrite Wilson history/personality toward target averages;
- pacing pressure cannot manufacture missing discovery prerequisites;
- Luck is bounded and can bias only declared unresolved alternatives;
- long-run mortality pressure acts through opportunity exposure, never post-commit causal correction;
- Legacy Knowledge selection is bounded player-profile policy, not runtime self-calibration.

---

## Current implementation gate

**PASS after final gameplay-design regression.** See `IMPLEMENTATION_GATE.md`.

Readiness:

```text
Concrete domain data model              READY
Package/module dependency layout        READY
First implementation vertical slice    READY after minimal model/layout kickoff
```

Remaining unknowns are implementation/calibration choices, not architecture blockers:

- concrete field/value-object/ID representation;
- property/capability/tag and semantic predicate representation;
- interaction/transformation rule representation;
- learned semantic interaction representation;
- exact evaluator/learning formulas;
- exact clock frequencies;
- God Power values/caps;
- Luck bounds/modifier composition/luck-sensitive contracts;
- Legacy eligibility weights and selection count;
- persistence technology/versioning;
- player-profile/run-save/Diary storage schemas;
- concrete dependency-injection/package mechanics;
- final vertical-slice fixture details.

---

## Immediate next work

Follow `IMPLEMENTATION_GATE.md`.

### Step 1 — Concrete domain data model

Define minimal typed structures for:

```text
stable domain IDs / semantic vocabulary
properties / capabilities / semantic action roles
interaction eligibility predicates
transformation/effect rules
world query/result shapes
Wilson persistent stores/state
learned semantic interactions / beliefs
intentional state
observation → decision → action → learning contracts
minimal project/director state
active-run player intervention state
player-profile / Legacy Knowledge boundary
Luck modifier / effective-value query boundary
Diary semantic record boundaries
run termination / new-run bootstrap contracts
seeded RNG + deterministic trace identity
```

The first interaction model must prove that multiple compatible objects can satisfy one reusable property/capability rule. Do not start from an object-pair recipe table and plan to generalize it later.

Do not add fields solely for serialization/UI convenience.

### Step 2 — Package/module dependency layout

Enforce:

```text
domain state/contracts
↑
pure domain services/evaluators
↑
application orchestration
↑
Godot / persistence / LLM / debug adapters
```

Keep active-run intervention and global player-profile state separable even if exposed through a broader player-domain facade.

### Step 3 — Headless vertical slice

Prove deterministic time/action/reconsideration/perception/candidate/evaluation/selection/outcome/learning/trace/save-load behavior before visual polish.

The first slice should include a property-driven interaction that can succeed with at least two different compatible participants, plus the transition from generic exploration to learned semantic interaction.

### Step 4 — Godot adapter

Presentation maps semantic domain IDs/events and does not duplicate legality/decision authority.

### Step 5 — Architecture/gameplay regression fixtures

Prioritize headless versions of the existing representative traces, then the focused property/discovery/player-lifecycle/Luck regressions above.

Any implementation change that breaks these invariants must update the owning design document and regression evidence rather than create a silent parallel architecture.
