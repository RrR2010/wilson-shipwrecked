# Product / Architecture Status

## Current stage

The project is in **contract and orchestration design before implementation**.

Behavioral discovery, persistent-state inventory, first architectural decomposition, guard analysis and the first semantic contract catalog are complete enough to stop reopening product psychology from first principles.

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
11. semantic simulation contract catalog.

Current work is **Deliverable B: update-phase and orchestration specification**.

Do not begin by choosing Godot nodes, ECS, GOAP, database schemas, serialization formats or final package/class layouts. Those remain downstream choices after phase ordering, mutation authority and interruption semantics are explicit.

---

## Document precedence

For work affecting Wilson behavior, simulation state, architecture or orchestration, use this order:

1. **`BEHAVIORAL_MODEL.md`** — validated functional Wilson model;
2. **`STATE_REQUIREMENTS.md`** — persistence, scope, lifetime, decay/offline/resurrection semantics;
3. **`SCENE_VALIDATION.md`** — behavioral evidence and regression suite;
4. **`ARCHITECTURE.md`** — system boundaries, authority and composition;
5. **`SIMULATION_CONTRACTS.md`** — semantic cross-system contracts;
6. **`GUARDS_AND_CALIBRATION.md`** — invariants, bounded contributions and stabilization policy;
7. **`AI.md`** — runtime LLM authority/fallback boundary;
8. **`PRODUCT.md`** — overall player experience, modes, intervention rules and presentation intent;
9. **`SIMULATION.md`** — broader world/property/action vocabulary.

Where older provisional psychology language in `PRODUCT.md` or `SIMULATION.md` conflicts with `BEHAVIORAL_MODEL.md`, `STATE_REQUIREMENTS.md` or `SCENE_VALIDATION.md`, the newer behavioral documents win.

Where implementation-oriented wording conflicts with accepted responsibility boundaries or semantic contracts, `ARCHITECTURE.md` and `SIMULATION_CONTRACTS.md` win unless a later documented architecture decision explicitly supersedes them.

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

`SIMULATION_CONTRACTS.md` is now the canonical catalog for cross-system handoffs.

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
- deterministic debug traces must preserve candidates, contributions, expectations, observations, evidence and guard effects.

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

The next canonical artifact is an **update-phase / orchestration specification** built on `SIMULATION_CONTRACTS.md`.

It must define:

- simulation clock categories;
- high-frequency action/physical progression;
- slow Wilson/world state ticks;
- event-driven cognition/reconsideration;
- event-driven learning;
- maintenance/consolidation passes;
- offline coarse stepping;
- ordering constraints between authoritative mutations;
- reconsideration-trigger coalescing;
- action versus intention interruption semantics;
- suspension versus discard of intentions;
- immediate-threat fast path;
- project-checkpoint timing;
- presentation synchronization;
- deterministic trace/RNG ordering requirements.

After that, produce a **mutation authority matrix** and run detailed contract/phase traces for at least:

```text
Scientific Method
Sabotaged Storage
Brilliant Shortcut or Falling Palm
```

Only then perform the architecture gate for concrete data model, package layout and first implementation vertical slice.

---

## Current implementation gate

The project is **not yet gated into implementation**.

Remaining blockers are architectural/orchestration blockers rather than unresolved product psychology:

1. update clocks and phase ordering are not yet canonical;
2. reconsideration trigger coalescing/hysteresis is not yet canonical;
3. action interruption versus intention suspension/discard is not yet canonical;
4. mutation authority has not yet been tabulated across all state families;
5. representative phase traces have not yet validated the completed contract graph;
6. offline substitutions and maintenance cadence remain to be specified.

Do not bypass these by encoding provisional behavior directly into engine classes.