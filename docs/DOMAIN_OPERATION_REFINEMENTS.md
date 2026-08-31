# Domain Operation Refinements

## Status and purpose

This document records canonical operation-level refinements discovered by `DOMAIN_PROCEDURAL_COMPOSITION.md` and `DOMAIN_MICRO_LOOP.md`.

It is intentionally small and normative. It corrects/clarifies older signatures in `DOMAIN_OPERATIONS.md` without duplicating that entire document.

When an older operation conflicts with a refinement here, this document owns the newer semantics until documentation consolidation.

---

# 1. Effective physical queries

Older effective-property lookup based only on `instance override → type definition` is superseded for properties that declare derivation semantics.

Canonical queries:

```text
ResolveEffectivePhysicalProfile(subject, PhysicalRuleContext)
→ EffectivePhysicalProfile

GetEffectiveProperty(subject, property_id, PhysicalRuleContext)
→ EffectivePropertyResult

HasEffectiveCapability(subject, capability_id, PhysicalRuleContext)
→ bool + optional provenance
```

Resolution must use the deterministic composition contract in `DOMAIN_MICRO_LOOP.md` / `DOMAIN_PROCEDURAL_COMPOSITION.md`.

For a non-derived property, the simple authored/instance path remains valid.

`GetEffectiveProperty` must never consult Wilson cognition.

---

# 2. Property derivation validation

Content bootstrap validates:

```text
PropertyDerivationDefinition[]
```

Required checks:

```text
known property/selector references
compatible output type
acyclic dependency graph
bounded combination policy
no arbitrary executable callback
no structural containment cycle used by aggregation
```

Invalid derivation graphs fail content validation rather than producing runtime recursion or arbitrary precedence.

---

# 3. Action attemptability

Replace the overloaded idea that a physical affordance means likely success.

```text
QueryActionAttemptability(
  action_id,
  complete_or_candidate_role_binding,
  PhysicalRuleContext
)
→ AttemptabilityResult
```

Possible conceptual outcomes:

```text
ATTEMPTABLE
UNREACHABLE
ROLE_INCOMPATIBLE
BODY_BLOCKED
HARD_PRECONDITION_FAILED
```

Rules:

- hidden resistance or unknown effectiveness normally does not make an otherwise enactable experiment disappear;
- attemptability validates whether a grounded attempt can begin/progress enough to produce evidence;
- goal success belongs to committed action resolution.

`ValidateAction` remains useful as the final authoritative gate before `StartAction`, but its contract must preserve this attempt-versus-success distinction.

---

# 4. Physical affordance versus Wilson-relative tactical opportunity

Do not use one `QueryPhysicalAffordances(initiator, perceived/local context)` operation for both authority and cognition.

Use two explicit projections.

## 4.1 Authoritative local action opportunities

```text
QueryAttemptableActions(
  initiator,
  authoritative_local_context,
  action_filter?
)
→ AttemptableActionBinding[]
```

This may be used internally by action/world services, debugging, and bounded exploration support.

It does not decide what Wilson knows/wants.

## 4.2 Wilson-relative tactical opportunities

```text
DerivePerceivedTacticalOpportunities(
  current_intention,
  PerceptionResult,
  WilsonCognition,
  DecisionContinuationContext
)
→ TacticalOpportunity[]
```

This service sees only Wilson-accessible/believed semantics.

A `TacticalOpportunity` may be speculative: it represents a tactic Wilson thinks is worth attempting, not an authoritative guarantee of success.

Before execution, selected bindings pass through `QueryActionAttemptability` / `ValidateAction`.

---

# 5. Tactical candidate operations

Refine broad candidate generation into scoped entry points.

```text
GenerateTacticalCandidates(TacticalDecisionContext)
→ CandidateTactic[]

EvaluateTacticalCandidate(candidate, TacticalDecisionContext)
→ EvaluationContribution[]

SelectTactic(plausible_candidates, RandomSource?)
→ SelectedTactic
```

`TacticalDecisionContext` includes:

```text
current intention
current perceived subjects/evidence
relevant beliefs/associations
recent bounded continuation history
accessible tactical opportunities
current reaction/body/drive projection where relevant
```

Typical bounded contribution families:

```text
expected goal progress
expected information gain
perceived effectiveness
perceived risk
effort
continuity
curiosity/novelty
repetition penalty
partial-progress leverage
```

The selected tactic produces/binds an ordinary `ActionDefinition`; it is not a new authoritative action type.

---

# 6. Intentional candidate operations

Existing broad operations remain conceptually:

```text
GenerateCandidates(DecisionContext)
EvaluateCandidate(...)
SelectIntention(...)
```

but are now explicitly the `INTENTIONAL` scope.

They should not run after every ordinary same-intention action outcome.

Trigger routing in `DOMAIN_MICRO_LOOP.md` decides when tactical scope escalates to intentional scope.

---

# 7. Interaction regions

Canonical queries:

```text
QueryPerceivableInteractionRegions(subject, PerceptionContext)
→ PerceivedInteractionRegion[]

ResolveInteractionRegion(
  InteractionRegionRef,
  PhysicalRuleContext
)
→ InteractionRegionProjection
```

`InteractionRegionProjection` may include bounded semantic modifiers such as:

```text
accepted action roles
local resistance modifier
local attachment/closure role
presentation anchor adapter id
```

Rules:

- hidden semantic regions are not automatically exposed to cognition;
- physical resolution may use region semantics once an action binds the region;
- presentation/geometry adapters map semantic regions to concrete transforms/colliders;
- regions are not independent entities unless they need independent lifecycle/relations.

---

# 8. Perception operation refinement

Refine:

```text
Perceive(...)
→ PerceptionResult
```

where:

```text
PerceptionResult
  perceived_subjects
  observed_events
  perceptual_evidence
  accessible_environmental_context
```

Static-world property discovery belongs in `perceptual_evidence`; it does not require synthetic world events.

Evidence generation is constrained by registered `EvidenceRuleDefinition`s and modality/accessibility.

---

# 9. Evidence derivation

```text
DerivePerceptualEvidence(
  perception_context,
  source_action_outcome?,
  source_world_events?,
  current_world_projection
)
→ PerceptualEvidence[]
```

Rules:

- evidence output is Wilson-accessible, not omniscient;
- direct versus inferential evidence remains distinguishable;
- absence of a sensory signal does not imply a stronger proposition than the evidence rule declares;
- evidence may concern property values/ranges, relations, relative comparison or semantic proposition hints.

---

# 10. Immediate same-chain learning

Introduce an orchestration-facing semantic operation:

```text
ProcessImmediateRelevantLearning(
  PerceptionResult,
  ActionOutcome?,
  current_intention,
  WilsonCognition
)
→ AppliedLearningSummary
```

This is not a new owner. It means:

```text
InterpretLearningEvidence
→ owner-local Apply*Evidence commands
→ return the resulting relevant cognitive revision projection
```

Use it only where new grounded evidence can materially affect the next same-chain tactic.

Maintenance/consolidation learning may remain deferred.

Normative ordering:

```text
outcome
→ perception/evidence
→ immediate relevant learning
→ tactical opportunity derivation
→ tactical candidate generation
```

---

# 11. DecisionContinuationContext

A bounded continuation object supports tactical deduplication without durable failure counters.

```text
DecisionContinuationContext
  intention_id
  recent_tactic_signatures: bounded list
  recent_outcome_refs: bounded list
  recent_evidence_refs: bounded list
  last_progress_ref?
```

Rules:

- lifetime is tied to current/suspended intention chain;
- bounded aggressively;
- not a second episodic-memory store;
- may be discarded after completion/abandonment or compacted into selected episode/belief evidence when meaningful.

---

# 12. Environmental response operations

```text
QueryApplicableEnvironmentalResponses(
  environment_state,
  authoritative local world projection
)
→ EnvironmentalResponseCandidate[]

ResolveEnvironmentalResponse(candidate, elapsed, RandomSource?)
→ WorldMutationPlan / EnvironmentalProcessPlan
```

Responses are selected by property/capability/context predicates, not entity-type switch statements when reusable semantics suffice.

Example:

```text
rain + exposed + absorbency > LOW
→ moisture mutation/process
```

---

# 13. Assembly operations

Queries:

```text
QueryCompatibleComponents(host, slot_id, local candidates)
→ EntityId[]

ValidateAssemblyBinding(host, slot_id, component)
→ AssemblyValidationResult
```

Commands:

```text
AttachAssemblyComponent(host, slot_id, component)
DetachAssemblyComponent(host, slot_id, component)
```

Commands mutate ordinary world relations/assembly binding truth through World authority.

After a binding mutation, effective profiles are derived from updated world state; no duplicated persistent `tool_stats` or `structure_stats` cache is authoritative.

---

# 14. Debug/provenance operations

Headless regression requires optional pure diagnostics:

```text
ExplainEffectiveProperty(subject, property_id)
→ PropertyDerivationTrace

ExplainTacticalCandidate(candidate)
→ TacticalDecisionTrace

ExplainPerceptualEvidence(evidence_ref)
→ EvidenceDerivationTrace
```

These traces must be derived from semantic provenance already available in the domain. They must not change behavior.

They are particularly important for procedural content because a result may depend on material, assembly, contents and condition rather than one authored object type.

---

# 15. Refined minimal micro-loop operation surface

```text
advance time/world/body/current action
→ collect authoritative outcomes/events
→ Perceive + DerivePerceptualEvidence
→ immediate-threat check
→ ProcessImmediateRelevantLearning when required
→ route trigger scope

if IMMEDIATE_THREAT:
  defensive fast path

else if TACTICAL:
  DerivePerceivedTacticalOpportunities
  → GenerateTacticalCandidates
  → Evaluate/SelectTactic
  → QueryActionAttemptability/ValidateAction
  → StartAction

else if INTENTIONAL:
  Derive expectations/salience
  → Generate/Evaluate/SelectIntention
  → commit intention
  → tactical derivation for its first action

→ resolve committed consequences
→ project/director reactions
→ maintenance
→ presentation/debug projection
```

No render callback is authoritative.

---

# 16. Refinement gate

The operation surface is complete enough for functional scenario fixtures when:

- authoritative attemptability is separate from Wilson-perceived tactical plausibility;
- effective property/capability derivation is explicit and explainable;
- tactical and intentional candidate generation are scoped separately;
- interaction subregions do not require mesh-level domain logic;
- static property exploration produces perceptual evidence without fake world events;
- immediate evidence can affect the next tactic before reconsideration;
- assembly/environment procedural rules remain bounded declarative semantics;
- no new state owner is introduced for exploration, crafting, tactical planning or procedural composition.
