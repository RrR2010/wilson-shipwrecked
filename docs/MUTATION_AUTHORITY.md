# Mutation Authority Matrix

## Status and purpose

This document defines who may read, propose changes to, mutate or merely observe each authoritative/persistent state family in Wilson Shipwrecked.

It is the canonical mutation-ownership companion to:

- `ARCHITECTURE.md`;
- `SIMULATION_CONTRACTS.md`;
- `SIMULATION_ORCHESTRATION.md`;
- `STATE_REQUIREMENTS.md`.

The purpose is to expose hidden circular authority before concrete data models or package layout are introduced.

Legend:

```text
M = mutate / authoritative owner
P = propose a semantic update or command, but not apply it
R = read/query for domain decisions
O = observe output only; no domain read dependency required
— = no normal dependency
```

`P` never implies permission to reach into another owner's store. Proposals cross explicit semantic contracts and are validated/applied by the owner.

---

# 1. Systems and pipeline columns

The matrix uses these responsibility columns:

| Abbrev. | Responsibility |
|---|---|
| `WORLD` | World Simulation |
| `COG` | Wilson Cognition state owners/coordinator |
| `ACTION` | Action Resolution |
| `PROJECT` | Project System |
| `PLAYER` | Player Intervention System |
| `DIRECTOR` | Event / Scene Director |
| `DECISION` | Decision / Reconsideration Pipeline |
| `LEARNING` | Memory & Learning Pipeline |
| `PRESENT` | Presentation / Narrative Projection |
| `PERSIST` | Persistence adapter/backend |
| `HEALTH` | Analytics / simulation health monitor |

`PERSIST` may serialize/restore state, but it does not invent domain mutations. In the matrix, persistence therefore receives `R/O` rather than domain `M`; restore is a lifecycle operation that reconstructs an owner's state under that owner's schema/invariants.

---

# 2. Authority matrix

| State family | WORLD | COG | ACTION | PROJECT | PLAYER | DIRECTOR | DECISION | LEARNING | PRESENT | PERSIST | HEALTH |
|---|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| World entity identity/lifecycle | **M** | R | P | R/P | P | P | R | R | O | R | O |
| World transforms/location | **M** | R via perception/query | P | R | P | P | R via perception | R via observed evidence | O | R | O |
| World physical/semantic properties | **M** | R via perceived/belief context | P | R | P | P | R | R | O | R | O |
| Inventory/container truth | **M** | R via perception/query | P | R/P | P | P | R | R | O | R | O |
| Weather/environment authoritative state | **M** | R via perception | P where action affects it | R | P | P | R | R | O | R | O |
| Physical project-built structures/state | **M** | R | P | R | P | P | R | R | O | R | O |
| Wilson traits | — | **M** | R where needed | R | R indirectly | R only if content gating requires | R | — | O | R | O |
| Wilson drives | — | **M** | R for effort/body consequence | R | — | R only if approved gating requires | R | P from grounded bodily outcome where applicable | O | R | O |
| Wilson beliefs / knowledge | — | **M** | R only through cognition/action planning interfaces | R where project expectation requires | — | R only through bounded context if needed | R | **P** | O | R | O |
| Wilson associations | — | **M** | —/R only where action derivation needs chosen target context | R only if opportunity presentation requires | — | R only through bounded context if approved | R | **P** | O | R | O |
| Wilson habits | — | **M** | — | — | — | R only if approved context gating requires | R | **P** | O | R | O |
| Wilson episodic history | — | **M** | — | R if authored project eligibility explicitly depends on history | — | R through bounded `DirectorContext` | R | **P** | O/R for diary projection | R | O |
| Current/suspended intentions | — | **M** | R | R | — | O/R only through context | **P** selection/transition proposal | — | O | R | O |
| Presence belief/trust/dependency | — | **M** | — | — | R only for player-side UX if explicitly allowed; never mutate | R only through bounded context if needed | R | **P** | O | R | O |
| Project lifecycle/progress metadata | R for physical state linkage | R | P via grounded outcome | **M** | P if intervention affects project world prerequisites | P for authored opportunity eligibility | R | P only through grounded project-relevant learning if designed | O | R | O |
| Project contribution/opportunity derivation | R | R | R | derived owner/service | — | P scene opportunity only | R | — | O | — | O |
| God Power amount | — | — | — | — | **M** | R only if opportunity rules explicitly use it | R only if suggestion/intervention context requires | — | O | R | O |
| Non-intervention streak/progression | — | — | — | — | **M** | R if approved opportunity rule uses it | — | — | O | R | O |
| Suggestion insistence/window state | — | R via signal | — | — | **M** | — | R | — | O | R | O |
| Game-mode intervention permissions | — | — | — | — | **M** | R | R | — | O | R | O |
| Director cooldown/eligibility state | R context | R bounded context only | — | R bounded context only | R bounded context only | **M** | R via `DirectorContext`/opportunity | — | O | R | O |
| Active authored scene premise/progression | P world consequence only | R bounded context | P action consequence only | P/R when project-linked | P player consequence | **M** | R | R only from grounded events | O | R | O |
| Active authoritative action execution state | R | R | **M** | R | — | — | R | R outcome only | O | R if resumable save requires | O |
| Action validation/result | R/M world fact portion | O/R | **M** | O/R outcome | O | O | R | R | O | diagnostic only | O |
| Perception/salience/expectations | R source only | R source state | — | R source | R source signal | R source context | derived | R evidence only | O | — | O |
| Candidate intentions/evaluations | — | R source state | R selected only | P project candidates | P suggestion candidates | P event candidates/bias | derived | — | O | — | O |
| Causal attribution weights/result | R observed facts only | R beliefs/history | — | — | — | — | derived service under cognition | R result | O | — | O |
| Transient reaction/emotion | — | R context | — | — | — | — | derived modifier may be read | derived | O/derived presentation realization | — | O |
| Diagnostic trace/history | O | O | O | O | O | O | P | P | O | optional diagnostic storage | **M** for analytics-owned trace store |
| Simulation health metrics | O | O | O | O | O | O | O | O | O | optional store | **M** |

---

# 3. Owner-specific rules

## 3.1 World Simulation

World Simulation is the sole normal owner of authoritative non-Wilson physical truth.

Other systems may propose validated commands/effects, but final mutation is applied through world-owned rules.

Forbidden examples:

```text
Project System directly spawns completed roof geometry/state
Player UI directly teleports entity authoritative transform
Wilson Cognition directly removes food from inventory
Director directly sets an object property without world validation
```

Allowed pattern:

```text
proposal/command
→ authoritative world validation/application
→ WorldEvent / ActionOutcome
```

---

## 3.2 Wilson Cognition

Wilson Cognition owns durable Wilson-relative state:

```text
traits
drives
beliefs
associations
habits
episodic history
current/suspended intentions
presence relationship
```

The decision pipeline may propose a selected intention transition, but the intentional-state owner commits it.

The learning pipeline may propose belief/association/habit/episode/presence updates, but each store applies only its own mutation.

No learner may cascade private mutation into a sibling store.

---

## 3.3 Action Resolution

Action Resolution owns authoritative action execution/validation and grounded physical result semantics.

It may cause world mutation through the world-authority path, but it does not own Wilson desire or learning.

Forbidden:

```text
action succeeded → Action Resolution increases habit
fire burned Wilson → Action Resolution lowers trust in presence
project step completed → Action Resolution directly completes project lifecycle
```

Instead it emits grounded outcome information consumed by the appropriate owners.

---

## 3.4 Project System

Project System owns project lifecycle/progress metadata not already fully represented as world physical state.

It may expose opportunities/contributions and consume grounded outcomes.

It may not:

- choose Wilson's intention;
- claim physical success before `ActionOutcome`;
- mutate world structures directly outside the world path;
- edit Wilson preference/attachment to make a project attractive.

---

## 3.5 Player Intervention System

Player Intervention owns player-side intervention state:

```text
God Power
non-intervention progression
permissions
suggestion insistence/windows
```

It may propose world interventions and suggestion signals.

It may not mutate Wilson trust/dependency/presence belief directly. Those changes require Wilson-observable evidence and learning.

---

## 3.6 Event / Scene Director

Director owns:

```text
eligibility
cooldowns
rare-event schedule state
active authored premise/progression
```

It may propose world opportunities, temporary candidate sources and bounded scene bias.

It may not directly mutate Wilson psychology to force a scene.

---

## 3.7 Decision / Reconsideration Pipeline

Decision is primarily derived/read-only.

It may:

- read bounded cognition/world/project/player/director context;
- derive perception/salience/expectations/candidates/evaluations;
- propose `SelectedIntention` and intentional transition semantics.

It may not directly edit beliefs, associations, habits, drives or project/world state.

The only durable result of a decision cycle is committed through the cognition owner as intentional state.

---

## 3.8 Memory & Learning Pipeline

Learning is a proposal pipeline, not a monolithic owner.

It derives:

```text
BeliefEvidence
AssociationImpact
HabitEvidence
EpisodeCandidate
PresenceEvidence
```

from grounded Wilson-accessible evidence.

Each destination owner applies bounded mutation.

Learning may never use omniscient world facts that Wilson did not observe unless a specific non-observational biological effect legitimately updates a bodily state through its own owner.

---

## 3.9 Presentation

Presentation is observe-only with respect to authoritative simulation state.

It may realize:

```text
animation
sound
particles
camera
UI
speech/thought wording
```

but may not determine action success, timing truth, physical consequences or Wilson learning.

---

## 3.10 Persistence

Persistence serializes/restores canonical owner state.

It does not become a shadow domain owner.

During load:

```text
serialized canonical state
→ owner reconstruction/validation
→ derived caches/services recomputed
```

Avoid generic persistence callbacks that mutate cross-domain state in arbitrary order.

---

## 3.11 Health monitor / calibration

Health/analytics owns measurements and diagnostic history, not game truth.

Default behavior is read-only.

Any runtime adaptation must act only through explicitly whitelisted pacing/opportunity controls and must not directly rewrite:

```text
traits
beliefs
associations
habits
trust
dependency
memories
project progress
world history
```

---

# 4. Cross-system mutation invariants

The following are canonical architectural invariants.

## 4.1 One owner per durable state family

A durable value may have many readers and proposal sources, but exactly one normal mutation owner.

If implementation finds two systems both needing direct write authority to the same field, the state boundary is probably wrong or the field actually contains two different semantic concepts.

## 4.2 Proposal is not mutation

Examples:

```text
BeliefEvidence       → belief owner may mutate
AssociationImpact    → association owner may mutate
ProjectContribution  → project candidate, no mutation
ValidatedIntervention→ world command path, not direct world write by player UI
SelectedIntention    → committed by intentional-state owner
```

## 4.3 World truth never flows directly into Wilson belief

Required:

```text
world truth
→ perception/observation
→ learning evidence
→ belief proposal
→ belief owner mutation
```

## 4.4 Project and world state remain split

Physical structure state belongs to World Simulation.

Project lifecycle/meta-progress belongs to Project System where not reducible to world truth.

A project must not duplicate every physical fact as a second authoritative copy.

## 4.5 Action and world authority must not conflict

Action Resolution determines semantic validity/execution outcome while World Simulation owns resulting physical truth.

Concrete implementation should make this an explicit coordinated boundary, not two independent writers racing over the same entity fields.

## 4.6 Restore is not runtime authority

Persistence may write reconstructed values during controlled load/bootstrap, but this does not grant it runtime domain authority.

## 4.7 Debug data is never fed back as truth

A trace saying "risk contribution = -0.6" is diagnostic output, not a persistent cognition primitive to be reloaded and trusted later.

---

# 5. High-risk coupling checks

Before implementation, explicitly reject these patterns.

### Fire/interaction code edits psychology

Bad:

```text
FireSystem -> BeliefStore
FireSystem -> AssociationStore
FireSystem -> HabitStore
FireSystem -> PresenceRelationship
```

Correct:

```text
grounded world/action outcome
→ Wilson observation
→ LearningEvidence
→ owner-specific proposals
```

### Project manager becomes planner

Bad:

```text
ProjectSystem.set_wilson_action(build_roof)
```

Correct:

```text
ProjectOpportunity
→ CandidateIntention
→ normal competition
```

### Director becomes hidden puppet master

Bad:

```text
Director.set_hunger(low)
Director.set_trust(high)
Director.force_intention(signal_fire)
```

Correct:

```text
TemporaryOpportunity
SceneBias within declared envelope
world event/opportunity
```

### Presentation commits game state

Bad:

```text
animation_finished("eat") -> remove food / satisfy hunger
```

Correct:

```text
authoritative ActionOutcome(eat)
→ world/body mutations
→ presentation reflects outcome
```

### Persistence callback performs domain repair

Bad:

```text
on_load(): if project says roof complete then spawn missing roof
```

Correct:

- validate state consistency explicitly;
- treat mismatch as migration/validation error;
- domain owner or migration routine resolves it deterministically, not arbitrary adapter side effect.

---

# 6. Mutation transaction boundaries

Some cross-owner operations require coordinated atomic semantics even though ownership remains separate.

## 6.1 Player intervention

Conceptually:

```text
validate player permission/cost
→ reserve/consume player resource
→ apply world command
```

Implementation must define atomic failure/refund semantics so accepted intervention and God Power mutation cannot diverge.

This is orchestration across two owners, not shared ownership.

## 6.2 Action outcome

A successful physical action may update multiple world fields atomically:

```text
container contents
object transform/form
actor body state
```

These remain one world/action transaction before learning observes the result.

## 6.3 Project contribution

World physical mutation and project metadata update occur sequentially from the same grounded outcome:

```text
world/action commit
→ ActionOutcome
→ project validates contribution
→ project metadata commit
```

Project failure must not roll back a valid world event merely because the project did not count it, unless the physical action itself was transactional by domain rule.

## 6.4 Learning batch

Multiple cognition stores may update from one evidence snapshot.

These updates should share one causal batch identity for debugging, but each store applies its own bounded mutation.

---

# 7. Architecture gate result for mutation ownership

The mutation graph is sufficiently explicit to proceed to detailed representative traces.

No central durable state family currently requires ambiguous shared runtime ownership.

The highest-risk implementation boundaries that must remain explicit are:

1. `Action Resolution ↔ World Simulation` for coordinated physical execution;
2. `Decision Pipeline → IntentionalState` for selected-intention commit;
3. `Learning Pipeline → cognition stores` for evidence-based owner-local mutation;
4. `ActionOutcome → Project System` for physical-result-driven project progress;
5. `Player Intervention → World Simulation` for atomic cost/effect semantics;
6. `Director → World/Decision` for bounded opportunity influence without forced behavior;
7. `Persistence → owners` for controlled restore without shadow authority.

Next deliverable: run full contract + orchestration + mutation traces across the representative integration scenes.