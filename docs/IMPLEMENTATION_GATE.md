# Architecture Implementation Gate

## Decision

The behavioral/architecture contract phase is **complete enough to proceed into concrete implementation design**.

Current gate status:

| Next step | Gate |
|---|---|
| Concrete domain data model | **READY** |
| Domain/application/Godot package layout | **READY** |
| First implementation vertical slice | **READY AFTER the minimal data model/package boundary is defined as part of implementation kickoff** |

There are no remaining product-psychology or cross-system-authority blockers that require another discovery cycle before implementation design begins.

This does **not** mean the architecture is immutable or that all balance/formulas are known. It means the responsibility graph, semantic handoffs, update ordering and mutation ownership are specific enough that concrete types can now be designed without encoding known ambiguity.

---

# 1. Evidence used for the gate

The gate is based on the following canonical artifacts:

1. `BEHAVIORAL_MODEL.md` — validated minimum behavioral model;
2. `STATE_REQUIREMENTS.md` — persistent/derived state inventory;
3. `SCENE_VALIDATION.md` — Must-have matrix and regression suite;
4. `ARCHITECTURE.md` — system boundaries and composition strategy;
5. `GUARDS_AND_CALIBRATION.md` — bounds and self-stabilization constraints;
6. `SIMULATION_CONTRACTS.md` — semantic cross-system contract catalog;
7. `SIMULATION_ORCHESTRATION.md` — clocks, ordering, reconsideration and interruption semantics;
8. `MUTATION_AUTHORITY.md` — explicit read/propose/mutate/observe authority matrix;
9. `DECISION_TRACES.md` — end-to-end validation across representative integration scenes.

The validated traces cover:

```text
Scientific Method
Sabotaged Storage
Brilliant Shortcut
Falling Palm
```

No trace required a new broad psychological primitive, shared mutable owner or scene-specific architectural bypass.

---

# 2. Gate criteria

## 2.1 Central state ownership is unambiguous — PASS

Durable/authoritative state families have one normal owner.

Critical ownership boundaries are explicit:

```text
World Simulation
  → authoritative physical/world truth

Wilson Cognition
  → traits, drives, beliefs, associations, habits,
    episodic history, intentions, presence relationship

Project System
  → project lifecycle/progress metadata

Player Intervention
  → God Power, permissions, suggestion/intervention state

Event / Scene Director
  → event eligibility/cooldowns/active authored premise state

Action Resolution
  → authoritative action validation/execution state/result semantics
```

Cross-owner effects use proposals/results rather than arbitrary shared writes.

---

## 2.2 World truth / observation / belief separation is explicit — PASS

Canonical chain:

```text
WorldEvent
→ ObservedEvent / PerceptionResult
→ LearningEvidence
→ BeliefEvidence / other owner-specific proposals
→ owner-local mutation
```

The architecture supports:

- Wilson being wrong;
- Wilson observing an effect without its cause;
- incorrect category inference;
- causal ambiguity;
- presence attribution;
- player knowledge differing from Wilson knowledge.

---

## 2.3 Decision contract is explainable and bounded — PASS

Normal decision flow is explicit:

```text
DecisionContext
→ CandidateIntention[]
→ EvaluationContribution[]
→ CandidateEvaluation[]
→ seeded selection
→ SelectedIntention
```

Each semantic contribution has finite influence.

Traits modulate only semantically related evaluators.

The design does not require one opaque universal rational score or global GOAP brain.

---

## 2.4 Reconsideration semantics are explicit — PASS

Wilson does not replan every render/simulation tick.

Triggers are coalesced and debounced.

Current intention receives bounded hysteresis/continuity advantage.

Intentions explicitly transition through:

```text
continue
suspend
complete
discard
```

This is sufficient to model persistent curiosity/projects while avoiding near-equal candidate ping-pong.

---

## 2.5 Action progression / interruption semantics are explicit — PASS

The architecture distinguishes:

```text
intention
!=
action step
```

Action interruption classes distinguish:

```text
immediate-safe interruption
checkpoint interruption
committed atomic consequence
```

This prevents causality-breaking rewinds after physical commitment.

---

## 2.6 Immediate threat is separate from normal utility — PASS

Emergency flow is explicit:

```text
perceivable immediate threat
→ narrow defensive candidate set
→ rapid feasible response selection
→ authoritative action resolution
→ post-threat learning / normal reconsideration
```

No `+Infinity` / giant score hack or accumulating safety drive is required.

---

## 2.7 Learning mutation flow is explicit — PASS

Grounded evidence is decomposed into bounded owner-specific proposals:

```text
BeliefEvidence
AssociationImpact
HabitEvidence
EpisodeCandidate
PresenceEvidence
```

Sibling cognition stores do not mutate one another directly.

Same-outcome-chain learning may occur before reconsideration when the next decision semantically depends on that newly learned fact, as validated by `Scientific Method`.

---

## 2.8 Projects compose without becoming the brain — PASS

Canonical flow:

```text
ProjectOpportunity
→ ProjectContribution
→ normal CandidateIntention competition
→ SelectedIntention
→ ActionOutcome
→ ProjectProgressResult
```

Project state does not command Wilson and does not duplicate authoritative world physics.

---

## 2.9 Player influence remains indirect — PASS

Suggestions:

```text
SuggestionSignal
→ normal intention competition
```

Physical intervention:

```text
ValidatedIntervention
→ world mutation
→ Wilson observation if perceivable
→ causal attribution
→ PresenceEvidence
```

Player private intent does not enter Wilson cognition.

---

## 2.10 Headless determinism/debuggability is preserved — PASS

The architecture can retain/reconstruct a causal trace linking:

```text
step/time
trigger batch
perception
expectation
candidates
contributions
seeded selection
intention
action
outcome
observation
learning evidence
owner-local update
guard activation
```

Presentation randomness and optional LLM behavior need not alter authoritative gameplay RNG consumption.

---

## 2.11 Offline policy remains compatible — PASS

Offline catch-up reuses normal owners under conservative substitutions.

Current required exclusions remain compatible with the architecture:

```text
no offline Wilson death
no consumption of rare spectacle / major discovery by default
no opaque extreme relationship swing
no contradictory second behavioral model
```

---

# 3. What remains deliberately unresolved

The following are **implementation/calibration decisions**, not blockers to implementation design.

## 3.1 Concrete field/type representation

Still open:

- ID types;
- enum/tag/property representation;
- belief proposition representation;
- typed value objects;
- collection/index structures;
- action/project identifiers;
- contract concrete type boundaries.

## 3.2 Numeric formulas and calibration

Still open:

- drive curves;
- evaluator combination formula;
- exact bounded contribution ranges;
- confidence update formula;
- association/habit learning rates;
- hysteresis thresholds;
- maintenance/decay rates;
- actual clock frequencies.

Implementation should expose these for deterministic testing/calibration rather than hardcode magic values throughout domain logic.

## 3.3 Persistence format/versioning

Still open:

- serialization technology;
- save schema/versioning;
- migration strategy;
- exact mid-action resume representation.

The semantic persistence boundary is already known.

## 3.4 Engine/application layout

Still open:

- exact Godot folder/node structure;
- domain language/runtime choice where not already fixed by project constraints;
- dependency-injection mechanism;
- concrete adapters;
- test harness organization.

These may now be designed from the responsibility graph rather than guessed from product prose.

## 3.5 First vertical-slice scope

The vertical slice should be chosen to exercise architecture contact points rather than maximize content.

A good slice must cover at minimum:

```text
world truth
perception
one drive
belief/expectation
candidate generation/evaluation
selected intention
action validation/outcome
learning
persistence/headless trace
presentation adapter boundary
```

It should also include at least one interruption/reconsideration case.

---

# 4. Recommended implementation sequence

Proceed in this order.

## Step 1 — Concrete domain data model

Translate semantic state/contract requirements into minimal typed data structures.

Priority:

```text
stable IDs / semantic vocabulary
world query/result shapes
Wilson persistent stores/state
intentional state
contracts: observation → decision → action → learning
project/player/director minimal state
trace identity / seeded RNG abstraction
```

Avoid adding fields solely because they are convenient to serialize or display.

## Step 2 — Package/module dependency layout

Make dependency direction enforceable:

```text
domain state/contracts
↑
pure domain services/evaluators
↑
application orchestration
↑
Godot/persistence/LLM/debug adapters
```

Prevent Godot scene objects from becoming domain identity/state owners.

## Step 3 — Headless vertical slice first

Before visual polish, prove a deterministic headless loop that can:

1. advance time;
2. progress one action;
3. trigger reconsideration;
4. perceive bounded context;
5. generate/evaluate candidates;
6. select an intention with seeded RNG;
7. resolve a grounded outcome;
8. apply one belief/association/habit update path;
9. emit a complete decision trace;
10. save/load canonical state and reproduce behavior.

## Step 4 — Godot presentation adapter

Map the proven domain loop to presentation through semantic IDs/events.

Do not reimplement domain legality/decision logic in nodes/scripts.

## Step 5 — Regression scenes

Encode representative architecture regressions early:

```text
Scientific Method partial-feedback loop
Sabotaged Storage observation-vs-cause separation
Brilliant Shortcut deterministic risk trace
Falling Palm emergency fast path
```

The first versions may be headless fixtures rather than full authored scenes.

---

# 5. Recommended first vertical slice

The strongest first slice is a **small headless island micro-scenario centered on object experimentation and interruption**.

Suggested capabilities:

```text
Wilson with hunger + curiosity + risk_tolerance
2–4 world objects with semantic affordances/properties
one food target
one uncertain tool/material interaction
one safe rest/idle option
one player suggestion signal
one environmental interruption/threat trigger
one simple persistent belief update
one simple association or habit update
seeded RNG + full decision trace
save/load
```

Why this slice:

- exercises the universal behavioral loop;
- tests world truth vs Wilson belief;
- validates candidate composition;
- validates same-chain learning/reconsideration;
- validates interruption/hysteresis;
- can run entirely headless;
- does not require director/project/LLM complexity immediately;
- leaves room to add project/player-presence verticals next without changing core boundaries.

Do **not** begin the first slice with `Sabotaged Storage` as the only scenario. It is an excellent integration regression but depends on more subsystems at once and would encourage premature implementation breadth.

---

# 6. Implementation constraints carried forward

The implementation phase must preserve these architecture invariants:

1. domain simulation runs without Godot rendering;
2. rendering FPS is not authoritative time;
3. all gameplay randomness is seeded/injected;
4. LLM paths are optional, bounded and non-authoritative;
5. world truth, observation, belief and player knowledge remain distinct;
6. no system freely mutates another system's durable state;
7. transient salience/expectation/evaluation values are recomputed rather than persisted by default;
8. projects generate opportunities, not Wilson commands;
9. suggestions influence, never directly command Wilson;
10. immediate threat is a separate decision regime;
11. action commitment boundaries prevent causal rewinds;
12. decision traces remain semantically explainable;
13. guards use bounded contributions/saturation, not hidden normalization;
14. health monitoring is read-only by default;
15. adapters do not become domain owners.

---

# 7. Gate conclusion

**Architecture gate: PASS.**

Wilson Shipwrecked is ready to leave contract/orchestration discovery and enter **concrete domain-model + implementation-layout design**.

No additional broad discovery phase is recommended before that work.

Future implementation evidence may still invalidate an individual contract. If that happens, follow the architectural change protocol in `AGENTS.md`: identify the failed invariant/scene, update the canonical design document and regression tests, and avoid creating a silent parallel architecture.