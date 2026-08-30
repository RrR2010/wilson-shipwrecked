# Product / Architecture Status

## Current stage

The project has completed the **behavioral discovery → state inventory → architecture → contracts → orchestration → mutation authority → representative trace validation** sequence.

The architecture implementation gate is now **PASS**.

Current work may proceed into:

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
15. architecture implementation gate.

---

## Document precedence

For work affecting Wilson behavior, simulation state, architecture or implementation boundaries, use this order:

1. **`BEHAVIORAL_MODEL.md`** — validated functional Wilson model;
2. **`STATE_REQUIREMENTS.md`** — persistence, scope, lifetime, decay/offline/resurrection semantics;
3. **`SCENE_VALIDATION.md`** — behavioral evidence and regression suite;
4. **`ARCHITECTURE.md`** — system boundaries, authority and composition;
5. **`SIMULATION_CONTRACTS.md`** — semantic cross-system contracts;
6. **`SIMULATION_ORCHESTRATION.md`** — clocks, ordering, reconsideration, interruption, learning timing and offline orchestration;
7. **`MUTATION_AUTHORITY.md`** — read/propose/mutate/observe ownership matrix;
8. **`DECISION_TRACES.md`** — representative end-to-end architecture regressions;
9. **`IMPLEMENTATION_GATE.md`** — current readiness decision and implementation sequence;
10. **`GUARDS_AND_CALIBRATION.md`** — invariants, bounded contributions and stabilization policy;
11. **`AI.md`** — runtime LLM authority/fallback boundary;
12. **`PRODUCT.md`** — player experience, modes, intervention rules and presentation intent;
13. **`SIMULATION.md`** — broader world/property/action vocabulary.

Where older provisional psychology language in `PRODUCT.md` or `SIMULATION.md` conflicts with `BEHAVIORAL_MODEL.md`, `STATE_REQUIREMENTS.md` or `SCENE_VALIDATION.md`, the newer behavioral documents win.

Where implementation-oriented wording conflicts with accepted responsibility boundaries/contracts/orchestration, the architecture-contract documents above win unless a later documented implementation decision explicitly supersedes them with regression evidence.

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

### Persistent personal continuity

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

### Explicitly rejected as independent primitives for now

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
```

These visible phenomena remain compositional unless new evidence proves otherwise.

---

## Current architecture summary

### State-owning / authoritative systems

```text
World Simulation
Wilson Cognition
Project System
Player Intervention
Event / Scene Director
Action Resolution
```

Persistence stores durable state but does not invent domain rules.

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
- `SelectedIntention` is Wilson-relative choice, not physical success;
- `ActionOutcome` is grounded authoritative action feedback;
- learning crosses boundaries as semantic evidence/proposals;
- each durable state owner mutates only its own state;
- transient contracts are not persisted merely for convenience;
- deterministic traces preserve decision causality.

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
- committed physics cannot be rewound by late cognition;
- same-chain learning may precede reconsideration when the new knowledge is required for the next decision;
- maintenance stays outside immediate semantic outcome chains;
- offline simulation reuses normal owners under conservative substitutions;
- gameplay RNG order remains deterministic and separate from presentation randomness.

---

## Mutation authority summary

`MUTATION_AUTHORITY.md` confirms one normal owner per durable state family.

Highest-risk boundaries to preserve during implementation:

1. `Action Resolution ↔ World Simulation` — coordinated physical execution;
2. `Decision Pipeline → IntentionalState` — selected-intention commit;
3. `Learning Pipeline → cognition stores` — evidence-based owner-local mutation;
4. `ActionOutcome → Project System` — grounded project progression;
5. `Player Intervention → World Simulation` — atomic cost/effect semantics;
6. `Director → World/Decision` — bounded opportunity influence;
7. `Persistence → owners` — controlled restore without shadow authority.

---

## Representative trace validation

`DECISION_TRACES.md` validates the architecture against:

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
- self-calibration does not rewrite Wilson history/personality toward target averages.

---

## Current implementation gate

**PASS.** See `IMPLEMENTATION_GATE.md`.

Readiness:

```text
Concrete domain data model              READY
Package/module dependency layout        READY
First implementation vertical slice    READY after minimal model/layout kickoff
```

Remaining unknowns are implementation/calibration choices, not architecture blockers:

- concrete field/value-object representation;
- proposition/ID/tag representation;
- exact evaluator/learning formulas;
- exact clock frequencies;
- persistence technology/versioning;
- concrete dependency-injection/package mechanics;
- final vertical-slice fixture details.

---

## Immediate next work

Follow `IMPLEMENTATION_GATE.md`:

### Step 1 — Concrete domain data model

Define minimal typed structures for:

```text
stable domain IDs / semantic vocabulary
world query/result shapes
Wilson persistent stores/state
intentional state
observation → decision → action → learning contracts
minimal project/player/director state
seeded RNG + deterministic trace identity
```

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

### Step 3 — Headless vertical slice

Prove deterministic time/action/reconsideration/perception/candidate/evaluation/selection/outcome/learning/trace/save-load behavior before visual polish.

### Step 4 — Godot adapter

Presentation maps semantic domain IDs/events and does not duplicate legality/decision authority.

### Step 5 — Architecture regression fixtures

Prioritize headless versions of:

```text
Scientific Method
Sabotaged Storage
Brilliant Shortcut
Falling Palm
```

Any implementation change that breaks these invariants must update the owning design document and regression evidence rather than create a silent parallel architecture.