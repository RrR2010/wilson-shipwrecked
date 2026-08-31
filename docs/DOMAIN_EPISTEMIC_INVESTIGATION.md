# Epistemic Investigation Domain

## Status and purpose

This document is a canonical, language-neutral companion to the functional-domain documents.

It formalizes reusable epistemic contracts exposed by the `Sabotaged Storage` micro-loop:

1. negative evidence requires sufficient observation coverage;
2. multiple observations may be grouped into a bounded temporary investigation context;
3. causal hypotheses remain Wilson-relative and explainable through supporting/opposing evidence;
4. causal opportunity reasoning must use Wilson-known context rather than omniscient history;
5. investigation tactics may be selected for discriminating information value as well as material goal value.

No new state-owning system is introduced.

---

# 1. Core invariant

```text
actual cause
!=
current world result
!=
Wilson observation
!=
Wilson causal attribution
```

Private player intent and unobserved authoritative provenance never enter Wilson cognition directly.

---

# 2. ObservationCoverage

Non-observation is not automatically evidence of absence.

```text
ObservationCoverage
  scope: DomainSubjectRef / relation-query scope
  modality: PerceptionModality
  coverage_class: LOW | MEDIUM | HIGH | EXHAUSTIVE_FOR_QUERY
  query_pattern?: PropositionPattern
  diagnostics: bounded semantic values
```

Examples:

```text
quick glance into cluttered storage
→ LOW/MEDIUM coverage

careful inspection of small open container for a rope-sized item
→ EXHAUSTIVE_FOR_QUERY
```

Only sufficient coverage may produce strong negative evidence for propositions such as:

```text
inside(item, container)
present_at(item, place)
attached_to(component, host)
```

This prevents false certainty from occlusion, partial inspection or inaccessible contents.

`ObservationCoverage` is derived and normally not persisted.

---

# 3. ExpectationMismatch

Expectation comparison should preserve why a mismatch exists.

```text
ExpectationMismatch
  expected_proposition
  expectation_confidence
  observed_evidence_refs
  observation_coverage_ref?
  mismatch_kind
  mismatch_strength
```

Typical mismatch kinds:

```text
EXPECTED_PRESENT_BUT_ABSENT
EXPECTED_ABSENT_BUT_PRESENT
EXPECTED_VALUE_DIFFERENT
EXPECTED_RELATION_DIFFERENT
EXPECTED_EVENT_DID_NOT_OCCUR
UNEXPECTED_EVENT_OCCURRED
```

A mismatch is derived evidence for salience/investigation; it is not itself durable memory.

---

# 4. InvestigationContext

A bounded working context groups related observations around one unresolved problem.

```text
InvestigationContext
  investigation_id
  subject/problem pattern
  originating_expectation_refs
  collected_evidence_refs
  active_hypotheses
  unresolved_questions
  recent_tactic_signatures
  opened_at
  bounded expiration/completion policy
```

It is temporary working state/derived orchestration context, not a new psychological trait or global suspicion store.

Use cases include:

```text
missing storage materials
mysterious repeated fire failures
unexpected animal disappearance
strange object relocation
shelter damage with unclear cause
food repeatedly disappearing
```

An InvestigationContext may end because:

```text
cause becomes sufficiently resolved
material goal is recovered and curiosity falls
Wilson abandons/suspends investigation
context expires/consolidates into a selected Episode
stronger competing intention interrupts it
```

---

# 5. AnomalyPattern

Multiple related evidence items may produce a derived pattern summary.

```text
AnomalyPattern
  evidence_refs
  semantic_features: bounded map
  support_quality
```

Possible features:

```text
repetition count band
same subject family
same location family
destination diversity
personal-salience targeting
physical-direction consistency
known-actor compatibility
similarity to prior selected episodes
```

Do not persist arbitrary pattern objects indefinitely.

Durable consequences belong in beliefs/episodes/habits/associations/presence state if admitted by normal learning rules.

---

# 6. CausalHypothesis

Causal attribution should remain inspectable.

```text
CausalHypothesis
  cause_class
  subject_ref?
  supporting_evidence_refs
  opposing_evidence_refs
  prior_support
  current_support
  unresolved_conflicts
```

Canonical cause classes:

```text
SELF
KNOWN_ACTOR
NATURAL_PROCESS
UNKNOWN_ORDINARY_CAUSE
UNSEEN_PRESENCE
```

Content may register narrower subtypes when representative gameplay requires them, but hypothesis identity must remain bounded and validated.

`current_support` is not authoritative truth probability. It is a bounded Wilson-relative interpretation score/confidence.

---

# 7. PerceivedCausalOpportunity

A hypothesis may require reasoning about whether a candidate cause could plausibly have acted.

That reasoning must use Wilson-relative knowledge.

```text
PerceivedCausalOpportunity
  candidate_hypothesis
  relevant_time_window
  known_access_plausibility
  known_capability_plausibility
  known_presence/proximity evidence
  diagnostics
```

Examples:

```text
Gerald was recently seen near beach
+ known to carry small food
- not known to move heavy stone heads

storm was heard overnight
+ lightweight objects displaced downwind

Wilson remembers using the work area
+ self-misplacement plausible there
- no memory/habit of storing tools on favorite rock
```

Actual actor logs, intervention provenance and unobserved world history are forbidden inputs unless first transformed into Wilson-accessible evidence.

---

# 8. Causal support dimensions

Hypothesis evaluation may use bounded contributions such as:

```text
prior plausibility
pattern fit
physical explanation fit
perceived causal opportunity
personal/semantic targeting fit
history similarity
contradictory evidence
explanation complexity penalty
```

No single contribution is infinite or authoritative.

Presence must not receive architectural privilege. It wins only when Wilson-visible evidence/history makes it comparatively plausible.

---

# 9. Investigation tactics and information value

A tactic may be valuable because it can distinguish hypotheses.

```text
InvestigationTacticEvaluation
  immediate_goal_value
  expected_information_gain
  hypothesis_discrimination_value
  effort
  risk
  interruption cost
  repetition penalty
```

Examples:

```text
search directly beside storage
→ distinguishes local spill from deliberate relocation

inspect animal tracks
→ may support/oppose known actor hypothesis

check personally meaningful location
→ may discriminate random displacement from targeting
```

Exact Bayesian information theory is not required.

Use bounded semantic estimates with clear provenance.

---

# 10. Evidence diversity and saturation

Learning should treat evidence novelty separately from repetition count.

```text
same evidence pattern repeated many times
→ diminishing marginal update

new independent/discriminating evidence
→ potentially stronger update
```

This applies to:

```text
belief confidence
presence belief
trust consequence
habit adaptation
episode admission
```

Existing guards against runaway accumulation remain authoritative.

---

# 11. Relationship semantics

Presence relationship dimensions remain independent.

A single investigation may validly produce:

```text
presence_belief ↑
trust ↓
```

because:

```text
more evidence that an unseen agent exists
+
perceived harmful/frustrating consequence
```

No special sabotage relationship state is required.

---

# 12. Persistence

Normally persist only admitted durable outcomes:

```text
BeliefEntry changes
Association changes
Habit changes
selected Episodes
Presence relationship changes
world state
```

Normally derive/reconstruct:

```text
ObservationCoverage
ExpectationMismatch
AnomalyPattern
PerceivedCausalOpportunity
CausalHypothesis working set
InvestigationTacticEvaluation
```

`InvestigationContext` may be either:

```text
minimal resumable working state
```

or reconstructed from current/suspended intention plus recent bounded evidence refs.

The final persistence representation may choose either strategy, but must not promote every investigation to permanent cognition state.

---

# 13. Debug/explainability queries

Recommended derived diagnostics:

```text
ExplainExpectationMismatch(...)
ExplainNegativeEvidence(...)
ExplainInvestigationEvidence(...)
ExplainCausalHypothesis(...)
ExplainAttributionSelection(...)
ExplainInvestigationTactic(...)
```

A trace should make Wilson's mistake explainable without exposing private player intent as cognition input.

---

# 14. Anti-patterns

Do not introduce:

```text
player_caused_this = true inside Wilson cognition
universal suspicion meter
persistent investigation object for every anomaly
presence hypothesis always included/winning with hidden bonus
not_seen = absent without coverage semantics
exact omniscient actor opportunity queries for Wilson
LLM-generated new causes outside registered cause classes
```

---

# 15. Regression target

This contract is sufficient when `Sabotaged Storage` and related anomaly scenes can produce different valid attributions from different histories while preserving:

```text
same authoritative world result
+
different Wilson knowledge/history
→ different causal interpretation
```

That variation is a feature, not nondeterministic authority leakage.
