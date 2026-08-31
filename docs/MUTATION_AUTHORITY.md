# Mutation Authority Matrix

## Status and purpose

This document is the canonical mutation-ownership companion to `ARCHITECTURE.md`, `SIMULATION_CONTRACTS.md`, `SIMULATION_ORCHESTRATION.md` and `STATE_REQUIREMENTS.md`.

It defines who owns durable mutation, who may read/query, who may only propose a semantic change and which derived pipelines remain non-authoritative.

Legend:

```text
M = normal authoritative mutation owner
P = may propose/command through an explicit contract; cannot reach into owner store
R = may read through admitted query/projection
O = observes emitted projection/result only
— = no normal dependency
```

Persistence may serialize/restore under owner invariants but is not a competing domain mutation owner.

---

# 1. Responsibility families

```text
WORLD     World authoritative physical state
COG       Wilson Cognition durable owners
ACTION    ActionExecution / Action Resolution lifecycle
PROJECT   Project lifecycle/progress owner
PLAYER    PlayerRunState + PlayerProfile owners
DIRECTOR  Directed-opportunity lifecycle owner
DECISION  derived reconsideration/candidate pipeline
LEARNING  derived owner-specific evidence/proposal pipeline
PRESENT   presentation/narrative adapters
PERSIST   persistence/reconstruction adapter
HEALTH    analytics/simulation-health diagnostics
```

Concrete package layout may split these responsibilities further; one normal owner per durable field remains the invariant.

---

# 2. Authority matrix

| State / semantic family | WORLD | COG | ACTION | PROJECT | PLAYER | DIRECTOR | DECISION | LEARNING | PRESENT | PERSIST | HEALTH |
|---|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| Entity identity/lifecycle | **M** | R via perception/query | P | R/P | P | P | R projection | R evidence | O | R/restore | O |
| Entity/place/physical properties | **M** | R only through admitted perception/belief paths | P | R | P | P | R bounded query/projection | R evidence | O | R/restore | O |
| Qualified World relations / containers / assembly bindings | **M** | R via perception/belief | P | R/P | P | P | R bounded query | R evidence | O | R/restore | O |
| Environment / physical dynamic processes | **M** | R via perception | P | R | P | P | R projection | R evidence | O | R/restore | O |
| Wilson body truth | **M** | R via bodily/perceptual projection | P | — | P | — | R admitted projection | P evidence only | O | R/restore | O |
| Wilson traits | — | **M** | R where explicitly needed | R | — | R bounded eligibility only | R | — | O | R/restore | O |
| Wilson drives | — | **M** | R effort/context only | R | — | R bounded eligibility only | R | P grounded update evidence | O | R/restore | O |
| BeliefStore / typed claims | — | **M** | R through cognition-facing query only | R bounded | bootstrap seed only | R bounded context | R | **P** | O | R/restore | O |
| Associations / habits / episodes | — | **M** | R only through chosen context where justified | R bounded | — | R bounded context | R | **P** | O | R/restore | O |
| Current/suspended intentions | — | **M** | R | R | — | O/R bounded | **P** selection/transition | — | O | R/restore | O |
| Presence belief/trust/dependency | — | **M** | — | — | R UX only | R bounded | R | **P** | O | R/restore | O |
| Project lifecycle/progress metadata | R linkage | R | P grounded outcome | **M** | P | P | R | P if grounded learning requires | O | R/restore | O |
| ActionExecution causal state | R context | R | **M** | R outcome | — | — | R | R outcome/evidence | O | R/restore | O |
| ActionAttemptability / effective profiles / assembly validity | R source | — | R | R | R where needed | R bounded | R | — | O/debug | — | O |
| SemanticChangeSet / graph invalidation work | source **M** change facts | — | — | — | — | — | derived maintenance | — | O/debug | — | O |
| PerceptionAccess / PerceptionResult | R source | R destination context | — | R projection | R signal source | R context source | R | R evidence | O | — | O |
| Candidate/evaluation/routing values | — | R source | selected result only | P candidate source | P suggestion source | P opportunity/bias | derived | — | O | — | O |
| Causal investigation / transient reaction | R accessible evidence source | R beliefs/history | — | — | — | — | derived | R result | O | — | O |
| God Power / run player intervention state | — | — | — | — | **M** | R only if approved | R signal context | — | O | R/restore | O |
| Director cooldown/opportunity lifecycle | R context | R bounded context | — | R bounded | R bounded | **M** | R opportunity | — | O | R/restore | O |
| PlayerProfile / Legacy / Diary metadata | O source facts | O/P Wilson-grounded facts | O | O/P | **M** | O/P rare event facts | O | O/P | O/R | R/restore | O |
| Presentation/reaction realization | — | source | source | source | source | source | source | source | **M presentation only** | optional artifact storage | O |
| Diagnostic trace / health metrics | O | O | O | O | O | O | P | P | O | optional diagnostic storage | **M diagnostics** |

Derived entries do not become persistent state owners merely because a concrete service caches/indexes them.

---

# 3. World mutation boundary

World is the sole normal owner of authoritative physical truth.

Other families submit explicit commands/effects. Successful mutation produces bounded semantic facts for downstream consumers:

```text
validated command / committed ActionOutcome
→ World owner prospective validation
→ authoritative mutation
→ SemanticChangeSet (derived-maintenance contract)
→ WorldEvent (authoritative occurrence fact)
```

## Exact relation identity

Relation mutation targets:

```text
RelationTypeId + subject + object + optional qualifier
```

Qualifier is a bounded semantic value/typed ID. No caller may bypass exact qualified identity by removing “the first matching edge”.

## Batch safety

For the currently admitted effect set, the World command boundary validates the ordered prospective batch before mutation. A contradictory later effect must not intentionally leave earlier effects committed.

## Forbidden examples

```text
Project directly creates roof physical state
UI directly teleports/mutates World
Cognition removes inventory contents
Director sets entity property outside World command path
Persistence invents relation/property repair during load
```

---

# 4. ActionExecution authority

ActionExecution owns only action causality/progress:

```text
start
progress
commit checkpoint
outcome-emitted flag
completed/interrupted terminality
cleanup
```

It may produce one committed `ActionOutcome`, but it does not apply World effects itself and does not learn/choose/project-progress.

Committed physical truth cannot be rewound by later ActionExecution interruption or reconstruction.

---

# 5. Wilson Cognition authority

Wilson Cognition owns durable current-run psychology/history:

```text
traits
drives
BeliefStore typed EpistemicClaims
associations
habits
episodes
current/suspended intentions
Presence relationship
```

Decision may propose a selected intention transition; the intentional owner commits it.

Learning derives owner-specific proposals:

```text
BeliefEvidence
AssociationImpact
HabitEvidence
EpisodeCandidate
PresenceEvidence
```

Each destination owner applies only its own mutation. No learning processor cascades private writes into sibling stores.

Legacy Knowledge may seed initial claims/knowledge at run bootstrap through an explicit lifecycle operation; after bootstrap, PlayerProfile is not a second writable copy of run cognition.

---

# 6. Perception / epistemic authority

Perception is a derived boundary:

```text
WorldEvent/current World context
→ PerceptionAccess
→ ObservedEvent / PerceptualEvidence
```

Only accessible semantics become cognition evidence.

`EpistemicGraphProjection` indexes `BeliefStore`; it never imports World truth and never mutates beliefs.

A hidden authoritative cause may appear in debug trace while remaining absent from Wilson evidence. Diagnostic visibility is not cognition authority.

---

# 7. Project authority

Project owns lifecycle/progress metadata not already represented as physical World state.

It may expose project opportunities/contributions, read bounded World/cognition projections, consume grounded outcomes and mutate only its own lifecycle/progress metadata.

It may not choose Wilson's intention, execute physical actions or duplicate structure integrity/component truth.

---

# 8. Player authority

## Active-run state

PlayerRunState owns God Power, non-intervention progress, intervention permissions and suggestion-window state.

Physical interventions submit validated World operations. Suggestions submit bounded cognition signals.

Player private intent never mutates Presence/trust/dependency directly.

## Cross-run profile

PlayerProfile owns Legacy Knowledge, Diary/archive metadata, lifetime statistics and admitted global unlocks.

End Run may project eligible run facts/knowledge into PlayerProfile through explicit lifecycle logic. It never retroactively mutates the ended Wilson.

---

# 9. Director authority

Director owns `DirectedEventDefinition/Instance` opportunity lifecycle state: eligibility, rarity/cooldowns and active premise metadata.

It may introduce/authorize ordinary World opportunities through normal World mutation and may contribute bounded candidate bias.

It may not rewrite Wilson beliefs/traits/associations/habits/trust/intentions to force a scene.

Ordinary occurrence semantics remain `EventDefinition` + `WorldEvent`; do not overload those names with Director ownership.

---

# 10. Decision authority

Decision/reconsideration is derived/read-only until it returns a selection proposal.

It may read bounded approved contexts and derive:

```text
salience/expectations
candidates
bounded contributions
routing regime
selected candidate/intention proposal
```

It may not mutate beliefs, drives, associations, habits, projects, World or Player state.

Immediate threat is a separate regime; no extreme score bypass.

---

# 11. Presentation / persistence / health

## Presentation

Observe/project only. Animation completion, UI state and speech wording cannot determine action success or domain mutation.

## Persistence

Serializes/restores owner causes under owner invariants, then rebuilds reconstructible projections/indexes/caches. Unsupported development schemas fail explicitly; persistence does not reinterpret old state silently.

## Health/calibration

Owns measurements/diagnostics only. Runtime adaptation, when explicitly approved, may influence bounded pacing/opportunity controls but may not normalize durable psychology/history/world/project state directly.

---

# 12. Multi-owner lifecycle transactions

Explicit application/lifecycle orchestration coordinates cases such as:

```text
player intervention + cost/world effect
save/load reconstruction
death/resurrection
End Run + Legacy/Profile extraction
offline catch-up
```

The transaction coordinator owns ordering/rollback policy, not a shadow copy of every domain state.

---

# 13. Canonical anti-patterns

Reject:

```text
cross-store direct mutation
broad event-bus subscriber order defining authority
projection/index promoted to truth
persistence DTO repairing gameplay semantics
Director/player private intent writing cognition
ActionExecution applying learning/project updates
Project duplicating World structures
Presentation completing authoritative actions
arbitrary callbacks mutating multiple owners
```

---

# 14. Mutation-authority gate

A new implementation path is acceptable only if:

- exactly one normal owner mutates each durable field;
- cross-owner influence crosses explicit semantic contracts;
- World physical mutation stays World-owned;
- cognition mutation stays owner-local and grounded in accessible evidence;
- Project/Director/Player remain proposals/opportunities outside their own state;
- committed ActionExecution causality remains non-rewindable;
- persistence rebuilds rather than invents derived state;
- diagnostics can explain who proposed, who validated and who mutated each meaningful change.
