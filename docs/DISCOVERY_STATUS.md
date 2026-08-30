# Product / Architecture Status

## Current stage

The project is in **contract and orchestration design before implementation**.

Behavioral discovery, persistent-state inventory, first architectural decomposition, guard analysis, semantic contract catalog and update-phase/orchestration specification are complete enough to stop reopening product psychology from first principles.

Completed sequence:

1. product fantasy and player-role discovery;
2. interaction/property/knowledge discovery;
3. psychology research and reduction;
4. independent representative-scene catalog;
5. scene triage and detailed behavioral analysis;
6. 23 Must-have scene × system matrix;
7. 12-case regression suite;
8. functional persistent-state inventory;
9. first architecture responsibility decomposition;
10. guard/self-stabilization analysis;
11. semantic simulation contract catalog;
12. simulation update-phase/orchestration specification.

Current work is **Deliverable C: mutation authority matrix**, followed by detailed representative decision traces and the architecture implementation gate.

Do not begin by choosing Godot nodes, ECS, GOAP, database schemas, serialization formats or final package/class layouts. Those remain downstream choices until mutation ownership and representative end-to-end traces are validated.

---

## Document precedence

For work affecting Wilson behavior, simulation state, architecture or orchestration, use this order:

1. **`BEHAVIORAL_MODEL.md`** — validated functional Wilson model;
2. **`STATE_REQUIREMENTS.md`** — persistence, scope, lifetime, decay/offline/resurrection semantics;
3. **`SCENE_VALIDATION.md`** — behavioral evidence and regression suite;
4. **`ARCHITECTURE.md`** — system boundaries, authority and composition;
5. **`SIMULATION_CONTRACTS.md`** — semantic cross-system contracts;
6. **`SIMULATION_ORCHESTRATION.md`** — clocks, ordering, reconsideration, interruption, learning timing and offline orchestration;
7. **`GUARDS_AND_CALIBRATION.md`** — invariants, bounded contributions and stabilization policy;
8. **`AI.md`** — runtime LLM authority/fallback boundary;
9. **`PRODUCT.md`** — overall player experience, modes, intervention rules and presentation intent;
10. **`SIMULATION.md`** — broader world/property/action vocabulary.

Where older provisional psychology language in `PRODUCT.md` or `SIMULATION.md` conflicts with `BEHAVIORAL_MODEL.md`, `STATE_REQUIREMENTS.md` or `SCENE_VALIDATION.md`, the newer behavioral documents win.

Where implementation-oriented wording conflicts with accepted responsibility boundaries, contracts or orchestration rules, `ARCHITECTURE.md`, `SIMULATION_CONTRACTS.md` and `SIMULATION_ORCHESTRATION.md` win unless a later documented architecture decision explicitly supersedes them.

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

These visible phenomena may still occur through composition.

---

## Current player / presence relationship

```text
presence_belief [0,1]
trust           [-1,+1]
dependency      [0,1]
```

Helpful and harmful unexplained interventions may both strengthen `presence_belief`; `trust` changes according to Wilson's perceived consequence and causal attribution.

`independence` is a stable trait. `dependency` is learned reliance and may change with intervention patterns.

Player private intent is never passed into Wilson cognition.

---

## Current LLM contract

The simulation must remain behaviorally complete without an LLM.

Allowed runtime roles are bounded to:

- sparse speech/thought realization;
- reaction-language realization;
- diary/history prose realization;
- optional bounded reweighting of already-valid ambiguous interpretations;
- rare grounded embellishment among valid candidates.

The LLM does not own world truth, physics, action validity, death, project progress, authoritative memories or Wilson knowledge.

Approximate interpretation calibration remains:

```text
~70% deterministic
~30% optional LLM-assisted
```

for eligible ambiguous interpretation cases, not ticks or actions.

---

## Current architecture conclusion

Authoritative mutation is intentionally concentrated.

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

Do not create one state-owning system per psychology noun.

---

## Current semantic contract conclusion

`SIMULATION_CONTRACTS.md` is the canonical catalog for cross-system handoffs.

Three central contracts remain especially important:

```text
ObservedEvent
SelectedIntention
ActionOutcome
```

The catalog additionally defines semantic responsibilities for world/perception, reconsideration, candidate evaluation, action progress, learning evidence, projects, player intervention, director inputs and presentation projection.

Key rules:

- world truth, Wilson observation and Wilson belief remain separate;
- `SelectedIntention` is an authoritative Wilson-relative choice, not proof of physical success;
- `ActionOutcome` is grounded authoritative feedback from action resolution;
- learning crosses boundaries as evidence/proposals, with each persistent state owner mutating only its own state;
- project progress depends on grounded outcomes;
- transient contracts are not persisted merely for convenience;
- deterministic debug traces preserve candidates, contributions, expectations, observations, evidence and guard effects.

---

## Current orchestration conclusion

`SIMULATION_ORCHESTRATION.md` is canonical for runtime ordering.

Accepted update categories:

```text
authoritative simulation time
physical/action progression cadence
slow simulation cadence
event-driven cognition
event-driven learning
maintenance cadence
presentation cadence
offline coarse stepping
```

Accepted ordering/interrupt rules include:

- render FPS is never the authoritative simulation clock;
- current action progresses without full cognition every step;
- multiple normal reconsideration triggers coalesce into one decision context;
- immediate threat uses a separate fast path;
- action interruption semantics distinguish immediate-safe, checkpoint and committed-atomic consequences;
- intentions explicitly continue, suspend, complete or discard;
- committed physics cannot be rewound by late reconsideration;
- grounded observation/outcome precedes learning;
- same-chain learning may apply before a reconsideration that depends on the newly learned fact;
- project progress occurs only from grounded outcomes;
- maintenance/consolidation stays outside immediate semantic outcome chains;
- offline simulation reuses normal owners under conservative substitutions and cannot kill Wilson or consume major rare spectacle by default;
- gameplay RNG ordering remains deterministic and separate from presentation randomness.

---

## Guards and calibration conclusion

Current non-negotiable rules include:

- normalized state has hard finite bounds;
- normal update curves saturate/diminish before clamp;
- evaluator contributions have declared finite influence envelopes;
- strong contradictory evidence can move high-confidence beliefs;
- repeated identical evidence has diminishing returns;
- no arbitrary huge-score / infinity priority hacks;
- immediate emergency uses a separate decision regime;
- runtime self-calibration may adjust only explicitly whitelisted pacing/opportunity variables;
- self-calibration does not rewrite Wilson's traits, beliefs, associations, habits, trust, dependency, project history or memories toward target averages.

---

## Immediate next work

### Deliverable C — Mutation authority matrix

Rows should cover all persistent/authoritative state families, including:

```text
world entity/location/property state
weather/environment state
Wilson traits
Wilson drives
beliefs
associations
habits
episodic history
current/suspended intentions
presence relationship
projects
player God Power / intervention state
director eligibility/cooldown/active-scene state
active authoritative action state where required
```

Columns should cover systems/pipelines and classify each relationship as:

```text
read
propose
mutate
observe only
```

The goal is to expose hidden circular authority before concrete schemas/classes are introduced.

### Deliverable D — Detailed traces

Run the full contract + phase graph through at least:

```text
Scientific Method
Sabotaged Storage
Brilliant Shortcut or Falling Palm
```

The traces must show candidate provenance, expectations, trigger batches, interruption semantics, grounded outcome, learning proposals, owner-local mutations and deterministic/debug implications.

### Deliverable E — Architecture gate

After C and D, explicitly decide readiness for:

```text
concrete data model
Godot/domain package layout
first implementation vertical slice
```

and list remaining blockers.

---

## Current implementation gate

The project is **not yet gated into implementation**.

Remaining blockers are narrow architecture-validation blockers rather than unresolved product psychology:

1. mutation authority has not yet been tabulated across all state families;
2. representative end-to-end traces have not yet validated the completed contract/orchestration graph;
3. the architecture implementation gate has not yet been performed.

Do not bypass these by encoding provisional behavior directly into engine classes.