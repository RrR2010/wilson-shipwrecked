# Epistemic Investigation Domain

## Status and purpose

This document is the canonical language-neutral appendix for bounded Wilson-relative anomaly/investigation reasoning.

It formalizes:

1. negative evidence requires sufficient observation coverage;
2. related observations may form a bounded temporary investigation context;
3. causal hypotheses remain Wilson-relative and explainable;
4. causal opportunity reasoning uses Wilson-known/perceived context, never omniscient history;
5. investigation tactics may be valuable for information/discrimination as well as material progress.

It introduces no new state-owning system. Durable belief identity follows the typed `EpistemicClaim` model in `DOMAIN_MODEL.md` / `DOMAIN_VOCABULARY.md`.

---

# 1. Core invariant

```text
actual cause
!= current authoritative World result
!= Wilson observation/evidence
!= Wilson belief
!= Wilson causal attribution
```

Player-private intent and unobserved authoritative provenance never enter Wilson cognition directly.

---

# 2. Typed claim patterns

Investigation operates over typed Wilson-relative claims/patterns rather than arbitrary `predicate + Variant arguments` identity.

Current durable claim families are:

```text
PROPERTY(subject, PropertyId, PropertyValue)
RELATION(subject, RelationTypeId, object)
EVENT(subject, EventDefinitionId, perceived_role)
```

Investigation may use **patterns over these typed families**, for example:

```text
RelationClaimPattern(item?, inside, storage)
PropertyClaimPattern(target, structural_integrity, expected range)
EventClaimPattern(subject?, object_moved, target)
```

A pattern is derived/query syntax, not a durable belief identity by itself.

Causal hypotheses are also derived working projections by default. Do not add a persistent `CAUSAL` claim kind merely because an investigation needs temporary cause comparison; promote a new typed claim family only if representative behavior requires durable causal belief with stable semantics.

---

# 3. ObservationCoverage

Non-observation is not automatically evidence of absence.

```text
ObservationCoverage
  scope: DomainSubjectRef / bounded claim-query scope
  modality
  coverage_class: LOW | MEDIUM | HIGH | EXHAUSTIVE_FOR_QUERY
  claim_pattern?
  diagnostics
```

Examples:

```text
quick glance into cluttered storage
→ LOW/MEDIUM

careful inspection of a small open container for a rope-sized item
→ EXHAUSTIVE_FOR_QUERY
```

Only sufficient coverage may produce strong contradiction/negative evidence for claims such as:

```text
RelationClaim(item, inside, container)
RelationClaim(item, expected_at, place)
RelationClaim(component, attached_to, host)
```

Coverage is derived and normally not persisted.

---

# 4. ExpectationMismatch

Expectation comparison preserves what was expected and why current evidence conflicts.

```text
ExpectationMismatch
  expected_claim / typed claim pattern
  expectation_confidence
  observed_evidence_refs
  observation_coverage_ref?
  mismatch_kind
  mismatch_strength
```

Typical kinds:

```text
EXPECTED_PRESENT_BUT_ABSENT
EXPECTED_ABSENT_BUT_PRESENT
EXPECTED_VALUE_DIFFERENT
EXPECTED_RELATION_DIFFERENT
EXPECTED_EVENT_DID_NOT_OCCUR
UNEXPECTED_EVENT_OCCURRED
```

Mismatch is derived evidence for salience/investigation, not durable memory by itself.

---

# 5. InvestigationContext

A bounded working context groups related observations around one unresolved problem.

```text
InvestigationContext
  investigation_id
  subject/problem claim pattern
  originating expectation refs
  collected evidence refs
  active hypotheses
  unresolved questions
  recent tactic signatures
  opened_at
  bounded expiration/completion policy
```

It is temporary working/continuation state, not a global suspicion store or new psychological primitive.

Example problems:

```text
missing storage materials
repeated fire failures
animal disappearance
unexpected object relocation
shelter damage of unclear cause
food repeatedly disappearing
```

It may end when cause becomes sufficiently resolved, material goal is recovered, Wilson abandons/suspends it, context expires/consolidates or stronger priorities intervene.

---

# 6. AnomalyPattern

Multiple evidence items may produce a derived pattern summary.

```text
AnomalyPattern
  evidence_refs
  bounded semantic features
  support quality
```

Possible features:

```text
repetition band
same subject/category/place family
destination diversity
personal-salience targeting
physical-direction consistency
known-actor compatibility
similarity to selected prior episodes
```

Do not persist arbitrary pattern objects indefinitely. Durable consequences belong in existing cognition owners if normal learning admits them.

---

# 7. CausalHypothesis

Causal attribution remains inspectable and Wilson-relative.

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

Canonical broad cause classes:

```text
SELF
KNOWN_ACTOR
NATURAL_PROCESS
UNKNOWN_ORDINARY_CAUSE
UNSEEN_PRESENCE
```

`current_support` is not authoritative probability of truth. It is bounded Wilson-relative interpretation.

Presence receives no hidden architectural bonus; it wins only when Wilson-accessible evidence/history supports it comparatively.

---

# 8. PerceivedCausalOpportunity

A hypothesis may require asking whether the candidate cause could plausibly have acted.

```text
PerceivedCausalOpportunity
  hypothesis
  relevant time window
  known access plausibility
  known capability plausibility
  known presence/proximity evidence
  diagnostics
```

All inputs are Wilson-known/perceived claims/history.

Forbidden inputs unless first converted into accessible evidence:

```text
omniscient actor logs
private intervention provenance
unobserved World history
player intent
hidden exact physical opportunity
```

---

# 9. Causal support dimensions

Hypothesis comparison may combine bounded contributions such as:

```text
prior plausibility
pattern fit
physical explanation fit as Wilson understands it
perceived causal opportunity
personal/semantic targeting fit
history similarity
contradictory evidence
explanation-complexity penalty
```

No one contribution is infinite/authoritative.

---

# 10. Investigation tactics and information value

A tactic may be worthwhile because it distinguishes hypotheses.

```text
InvestigationTacticEvaluation
  immediate goal value
  expected information gain
  hypothesis discrimination value
  effort
  perceived risk
  interruption cost
  repetition penalty
```

Examples:

```text
search beside storage
→ distinguishes local spill from relocation

inspect tracks
→ may support/oppose known actor

check personally meaningful location
→ may distinguish random displacement from targeting
```

Exact Bayesian machinery is not required; bounded semantic estimates with provenance are sufficient.

---

# 11. Evidence diversity and saturation

Evidence novelty/diversity matters separately from repetition count.

```text
same evidence pattern repeated
→ diminishing marginal update

new independent/discriminating evidence
→ potentially stronger update
```

This applies to belief confidence, Presence belief/trust, association/habit learning and episode admission as appropriate.

Strong contradiction must remain capable of revising saturated beliefs.

---

# 12. Presence relationship semantics

Presence dimensions remain independent.

One investigation may validly yield:

```text
presence_belief ↑
trust ↓
```

because Wilson has more evidence an unseen agent exists while perceiving the consequences as harmful/frustrating.

No special sabotage relationship state is required.

---

# 13. Persistence

Normally persist only admitted durable owner outcomes:

```text
BeliefEntry changes
Association changes
Habit changes
selected Episodes
Presence relationship changes
World state
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

`InvestigationContext` may be minimal resumable continuation state or reconstructed from current/suspended intention plus bounded recent evidence. Do not promote every anomaly into permanent cognition.

---

# 14. Debug/explainability

Useful diagnostics:

```text
ExplainExpectationMismatch
ExplainNegativeEvidence
ExplainInvestigationEvidence
ExplainCausalHypothesis
ExplainAttributionSelection
ExplainInvestigationTactic
```

A trace must explain Wilson's mistaken attribution without exposing hidden player/World truth as a cognition input.

---

# 15. Anti-patterns

Do not introduce:

```text
player_caused_this=true inside Wilson cognition
universal suspicion meter
persistent investigation object for every anomaly
Presence hypothesis always winning with hidden bonus
not_seen = absent without coverage
omniscient actor-opportunity lookup for Wilson
LLM-generated unrestricted new cause classes
arbitrary predicate/argument belief identity
```

---

# 16. Regression target

`Sabotaged Storage` and related scenes should permit:

```text
same authoritative current World result
+ different Wilson-accessible histories/evidence
→ different plausible causal interpretations
```

while preserving actual cause separately and keeping all persistent cognition changes grounded in typed claims/evidence/owner-local learning.

**Result: PASS as a domain contract; concrete full investigation runtime remains system breadth, not unfinished structural foundation.**
