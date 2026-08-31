# Simulation Contract Catalog

## Status and purpose

This document is the canonical catalog of **semantic cross-system contracts** for Wilson Shipwrecked.

It complements:

- `BEHAVIORAL_MODEL.md` — behavioral meaning;
- `STATE_REQUIREMENTS.md` — persistence/lifetime requirements;
- `ARCHITECTURE.md` — owners/dependencies;
- `SIMULATION_ORCHESTRATION.md` — ordering/cadence;
- `DOMAIN_MODEL.md` / `DOMAIN_OPERATIONS.md` — normalized domain semantics and operations;
- `GUARDS_AND_CALIBRATION.md` — bounds/stability.

These are semantic boundaries, not a mandate for one concrete class/message type per contract. `DISCOVERY_STATUS.md` records which contracts already have concrete GDScript representation/regression coverage.

Design goal:

> Every important handoff preserves authority, accessibility, provenance and deterministic causality without exposing another owner's private state.

---

# 1. Contract design rules

## Authority is explicit

A contract is a fact/result, observation, proposal/evidence, derived decision value or projection. Those categories never silently interchange.

```text
WorldEvent        authoritative occurrence fact
ObservedEvent     Wilson-accessible projection
PerceptualEvidence Wilson-accessible typed claim evidence
BeliefEvidence    proposal to BeliefStore owner
PresentationEvent presentation-only projection
```

## Producers do not gain consumer authority

Producing evidence/project contribution/suggestion/opportunity never grants mutation authority over the destination owner.

## Derived contracts are ephemeral by default

Perception, salience, expectations, candidate evaluations, causal hypotheses, reactions and presentation projections are reconstructible/transient unless a separate lifecycle requirement explicitly admits persistence.

## Provenance is preserved

Evidence/decision contracts preserve enough source information to distinguish direct observation, ambiguity, repetition, inference/coincidence and externally suggested but unconfirmed ideas.

## Values are finite/guardable

No contract uses NaN, infinity or huge sentinel priorities as semantics. Immediate threat is a distinct regime.

## Replay-relevant randomness is attributable

Seeded gameplay randomness is associated with a deterministic semantic decision context/stream. Optional LLM output is never necessary to reconstruct authoritative physical truth.

---

# 2. Contract taxonomy

| Category | Meaning | Typical lifetime |
|---|---|---|
| Fact/result | authoritative occurrence or owner mutation result | moment; consequences stored by owner |
| Observation | what Wilson had access to | moment/short |
| Proposal/evidence | input for owner-local validation/mutation | moment |
| Derived decision value | current reasoning/evaluation | one decision cycle |
| Projection | read/debug/presentation view | moment/reconstructible |

One causal chain may cross all categories without duplicating authority.

---

# 3. World / observation contracts

## WorldEvent

Authoritative semantic fact emitted after a grounded World/action/intervention/environment occurrence is committed through normal owner paths.

Required semantics conceptually include:

```text
EventDefinitionId
involved authoritative bindings/subjects
causal/action provenance
stable order/time identity
observability-relevant context where required
```

It does **not** imply Wilson perceived the event.

`EventDefinition` describes an ordinary WorldEvent kind's potentially perceptible roles/modalities; Director lifecycle uses `DirectedEventDefinition`, not this type.

## PerceptionAccess

Observer-relative derived access to one WorldEvent/current context.

It determines:

```text
observable?
accessible role subset
accessible modalities
bounded confidence/quality basis
```

The current foundation proves coarse semantic place/co-location access. Fine range/occlusion/hearing/nav semantics may refine the adapter later.

## ObservedEvent

Wilson-accessible projection of a WorldEvent. It preserves only accessible bindings/semantics and never smuggles hidden authoritative cause into cognition.

## PerceptualEvidence

Derived evidence proposal carrying one typed `EpistemicClaim` plus confidence/provenance.

Current claim algebra:

```text
PROPERTY(subject, PropertyId, PropertyValue)
RELATION(subject, RelationTypeId, object)
EVENT(subject, EventDefinitionId, perceived_role)
```

Static property/relation evidence may arise without a fake WorldEvent.

## PerceptionResult

Bounded Wilson-accessible context for learning/reconsideration, conceptually aggregating:

```text
perceived subjects/context
ObservedEvent[]
PerceptualEvidence[]
accessible environment/spatial context
```

It is derived and normally not persisted.

## ObservationCoverage / ObservedChange

Optional derived contracts for negative evidence/anomaly reasoning. Non-observation becomes strong negative evidence only when bounded observation coverage justifies it.

---

# 4. Decision/reconsideration contracts

## DecisionContext

Bounded read-only context exposing only admitted Wilson-relative/current projections needed by one decision cycle:

```text
current/suspended intention
relevant drives/traits
belief/association/habit/episode projections
current perception/salience
project opportunities
suggestion/Director signals
recent current-chain outcomes/evidence
regime/trigger context
```

It owns no mutable state.

## ReconsiderationTrigger

Derived reason for reconsideration, e.g. completion, invalidation, drive-band change, anomaly, player signal, project checkpoint, major opportunity or immediate threat.

Equivalent triggers are coalesced/debounced. Trigger urgency controls **when** to reconsider, not score magnitude.

## DecisionCandidate

Derived semantic option with intention ID/bindings, decision scope, bounded score contributions/provenance.

Candidate sources are composable; semantic duplicates should merge reasons instead of becoming duplicate lottery tickets.

## EvaluationContribution

One bounded explainable reason influencing a candidate. No contribution is infinite and no evaluator mutates state.

## SelectedIntention

Committed Wilson-relative choice result after routing/competition. It may become durable current intention through the cognition owner, but it is not proof of physical validity/success.

## Decision regime

Canonical regimes:

```text
IMMEDIATE_THREAT
TACTICAL
INTENTIONAL
```

Immediate threat uses a narrow perceived defensive set. Tactical stays within the current objective; intentional compares broader objectives.

---

# 5. Action contracts

## ActionDefinition / RoleBinding

Reusable authored verb + semantic roles/requirements/interruption behavior. Role binding connects the abstract roles to runtime subjects.

## AttemptabilityResult

Authoritative read result answering whether an action binding can be enacted far enough to obtain a grounded consequence/evidence. It does not guarantee Wilson's desired outcome.

## ActionExecutionState

Owned lifecycle of an active/restored action. Conceptually tracks:

```text
execution id
action/resolution definitions
binding snapshot
elapsed/progress
committed
outcome emitted
completed
interrupted
```

Current coarse interruption semantics:

```text
PRE_COMMIT_ONLY
NEVER
ANYTIME
```

A post-commit interruption never rewinds committed truth.

## ActionProgressResult

Result of advancing one execution; exposes progress/commit/terminal transition and at most one newly emitted outcome.

## ActionOutcome

Grounded authoritative action result produced at the commit checkpoint. It carries the bound participants/effects and typed `EventDefinitionId` required for the eventual authoritative WorldEvent.

ActionOutcome itself does not mutate World/cognition/projects.

## WorldCommitResult

World owner's validation/application result for an ActionOutcome.

For the supported effect set, batch validation is prospective/sequential before mutation. Successful commit returns authoritative mutation results, `SemanticChangeSet` and WorldEvent(s). Invalid batches intentionally leave no partial mutation.

## DiagnosticFeedback

Grounded physical/result detail useful to learning/debugging. It becomes Wilson evidence only through perception/accessibility.

---

# 6. Derived-state maintenance contract

`SemanticChangeSet` is a bounded internal maintenance contract emitted from owner mutation.

```text
World property/relation change
→ SemanticChangeSet
→ PropertyDependencyGraph / CompositionDependencyProjection
→ invalidate affected EffectivePhysicalProfile caches
```

It is **not** a gameplay event bus and does not directly drive Wilson psychology.

---

# 7. Learning contracts

## Learning interpretation

Grounded accessible perception/outcome context may derive owner-specific proposals in one semantic batch.

## BeliefEvidence

Supports/contradicts one typed belief proposition/claim with bounded strength and provenance. BeliefStore owns saturation/revision.

## AssociationImpact

Proposes valence/attachment consequences for one Wilson-relative subject. Supports negative valence with high attachment.

## HabitEvidence

Proposes bounded reinforcement/weakening/context differentiation of a cue/intention pattern.

## EpisodeCandidate

Proposes one meaningful Wilson-accessible experience for bounded episodic retention; memory owner decides admission/retention.

## PresenceEvidence

Separately proposes evidence about presence plausibility, trust consequence and dependency/reliance. Helpful and harmful anomalies may both increase presence belief while affecting trust differently.

Player-private intent is forbidden input.

## Same-chain ordering

When evidence can materially alter the next tactic:

```text
World commit
→ perception/evidence
→ derive/apply immediate relevant learning
→ tactical opportunity generation
→ next tactical decision
```

---

# 8. Epistemic contracts

## EpistemicClaim

Closed typed semantic identity for durable belief propositions. Current foundation supports PROPERTY / RELATION / EVENT.

Future causal/danger/expectation claim families require explicit typed admission rather than a return to generic `predicate + arbitrary arguments` identity.

## BeliefProposition / BeliefEntry

`BeliefProposition` wraps one claim. `BeliefEntry` owns Wilson-relative confidence/evidence metadata.

## EpistemicGraphProjection

Reconstructible indexed read view over BeliefStore only. It may index by subject/kind/semantic ID but never imports hidden World truth.

---

# 9. Project contracts

## ProjectOpportunity

Derived currently meaningful project possibility/next contribution family. It does not command Wilson.

## ProjectContribution

Semantic contribution proposal that may become a candidate/intention/action.

## ProjectProgressResult

Project owner's accepted interpretation of a grounded World/action outcome as lifecycle/progress change.

Canonical flow:

```text
ProjectOpportunity
→ candidate competition
→ action
→ World commit/outcome
→ Project validates contribution
→ Project owner mutation
```

Physical structure truth stays World-owned.

---

# 10. Player contracts

## SuggestionSignal

Player-side signal entering normal candidate competition with bounded influence. It never becomes a Wilson command.

## ValidatedIntervention

Approved player intervention after permission/cost validation. It is not proof that the physical World effect succeeded until the World owner returns its result.

## InterventionObservation

Wilson-relative observation of resulting World consequences. It may support causal attribution/Presence evidence without carrying hidden player intent.

---

# 11. Director contracts

## DirectorContext

Bounded read-only context for authored/systemic opportunity eligibility. It cannot mutate Wilson psychology.

## DirectedEventDefinition / DirectedEventInstance

Director-owned opportunity/rarity/cooldown/lifecycle semantics. Keep this distinct from ordinary `EventDefinition` / `WorldEvent` occurrence semantics.

## DirectorOpportunity / SceneBias

Temporary opportunity/context or bounded candidate bias. Neither commands Wilson nor bypasses ordinary physical validity/threat handling.

---

# 12. Presentation contracts

## ReactionIntent

Derived grounded transient Wilson expression intent. Persistent consequences flow separately through learning owners.

## SpeechAct

Grounded semantic communicative intent before deterministic/optional-LLM wording realization. It cannot invent facts/memories/causes.

## PresentationEvent

Adapter-facing semantic projection of domain state/events/reactions. Godot/UI/audio consume it; it has no authoritative mutation role.

---

# 13. Cross-contract invariants

## World → cognition

```text
WorldEvent
→ PerceptionAccess
→ ObservedEvent / PerceptualEvidence
→ learning interpretation
→ owner-specific evidence
→ owner-local cognition mutation
```

Forbidden:

```text
WorldEvent → direct belief update because simulation knows truth
```

## Wilson intention → physics

```text
DecisionCandidate
→ selection
→ SelectedIntention
→ action binding
→ AttemptabilityResult
→ ActionExecution
→ ActionOutcome
→ WorldCommitResult
```

Selected intention never proves physical success.

## Project

```text
project opportunity
→ ordinary Wilson choice/action
→ grounded World result
→ project progress mutation
```

## Player intervention

```text
player request
→ validation/transaction
→ World result
→ perception if accessible
→ causal attribution / PresenceEvidence
```

## Reaction versus durable learning

```text
ObservedEvent / PerceptualEvidence
├→ transient ReactionIntent
└→ durable-owner evidence proposals
```

---

# 14. Persistence implications

Transport/derived contracts are not automatically canonical save state.

Normally persist owner causes:

```text
World authoritative state
Wilson durable cognition/current semantic intention
ActionExecution causal state needed for continuity
Projects
Director continuity state
PlayerRunState / PlayerProfile
required gameplay RNG state
```

Normally reconstruct perception, relation/epistemic indexes, effective physical profile, assembly validity, candidate/evaluation data and traces.

Concrete development snapshot/content schema versions belong to `DISCOVERY_STATUS.md`.

---

# 15. Representative contract traces

## Scientific Method

```text
current intention
→ tactic candidate
→ attemptable experimental action
→ committed ActionOutcome
→ World mutation + WorldEvent
→ accessible diagnostic evidence
→ typed belief revision
→ tactical reconsideration with revised belief
```

Partial/failure feedback changes the next experiment without pair-specific recipes.

## Sabotaged Storage

```text
actual storage relation change
→ partial/negative observation with coverage semantics
→ expectation mismatch
→ bounded investigation/causal hypotheses
→ Wilson-relative attribution
→ belief/Presence/association proposals
```

Actual cause remains separate from inferred cause.

## Falling Palm

```text
committed dynamic process
→ authoritative hazard projection
→ Wilson-accessible threat evidence
→ immediate-threat regime
→ ordinary defensive action validation/execution
```

Hidden hazard truth never becomes a direct cognition input.

---

# 16. Contract gate

The contract catalog remains valid when:

- World truth, observation and belief stay distinct;
- typed semantic identities survive persistence/reconstruction;
- `SelectedIntention` does not bypass physical validation;
- ActionExecution commit/outcome semantics are explicit and non-rewindable;
- learning crosses boundaries as evidence/proposals + owner mutation;
- Project/Director/player signals remain non-authoritative over Wilson physical choice;
- decision contributions are bounded/explainable;
- immediate threat remains a distinct regime;
- transient transport/projections do not become accidental persistence authority;
- deterministic traces can explain the causal chain.

The structural foundation has passed this gate; new system breadth should extend these contracts only when representative behavior requires a new semantic distinction.
