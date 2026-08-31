# Functional Domain Operations

## Status and purpose

This document is the canonical language-neutral **operation surface** for the Wilson Shipwrecked functional domain.

It owns:

- pure queries;
- deterministic derivation/decision services;
- owner-local commands;
- named lifecycle transactions;
- action execution semantics;
- graph/index-aware bounded query contracts;
- orchestration-facing operation ordering.

`DOMAIN_MODEL.md` owns state/concepts. `ARCHITECTURE.md` owns responsibility/module boundaries. `DOMAIN_PROCEDURAL_COMPOSITION.md` owns material/assembly/effective-physical semantics. Specialized appendices own narrow semantic details where applicable.

This document supersedes the former `DOMAIN_OPERATION_REFINEMENTS.md`; all accepted refinements are consolidated here.

It does not mandate method syntax, class layout, Godot signals, persistence APIs or a database/query language.

---

# 1. Operation categories

Every operation belongs to one of four categories.

## 1.1 Query

```text
state + query parameters
→ deterministic result
```

No mutation, gameplay RNG or authoritative event emission.

## 1.2 Derivation / decision service

```text
state/projections + context + optional named RandomSource
→ derived proposal/result
```

May consume deterministic gameplay RNG where the semantic operation explicitly permits stochastic choice. Does not directly mutate durable owners.

## 1.3 Command

```text
command
→ owning aggregate validates invariants
→ owner-local mutation
→ result / semantic events
```

A command may fail without mutation.

## 1.4 Lifecycle transaction

Coordinates multiple owners at a named boundary such as intervention, resurrection or End Run. Ordering/atomicity must be explicit and must not be hidden behind a broad event bus.

---

# 2. Shared query rules

## 2.1 Explicit authority context

Every predicate/query that could cross epistemic boundaries declares its context.

```text
PhysicalRuleContext
CognitionContext
ContentEligibilityContext
InterventionContext
PerceptionContext
```

Physical truth must never consult Wilson belief merely to decide legality/effectiveness. Cognition must not consume hidden authoritative facts as though Wilson perceived them.

## 2.2 Bounded graph/pattern traversal

Graph-aware queries must always be bounded by one or more of:

```text
local scope / place / region
relation type set
max depth
result limit
specific typed SemanticPattern
explicit candidate set
```

No operation may perform an unbounded arbitrary world/knowledge graph walk as ordinary gameplay logic.

## 2.3 Stable ordering

When a query returns an unordered semantic set that later feeds gameplay selection, normalize to stable semantic ordering before applying seeded randomness or deterministic tie-breaks.

Hash-map/index iteration order is never gameplay authority.

---

# 3. World queries

## 3.1 Direct authored/instance facts

```text
GetInstanceProperty(subject, property_id)
→ PropertyValue?

HasAuthoredCapability(subject, capability_id)
→ bool

HasCategory(subject, category_id)
→ bool

GetPlace(subject)
→ PlaceId?
```

These answer direct authoritative facts only. For derived physical semantics use effective-profile operations below.

## 3.2 World relations / typed graph view

```text
FindRelations(type?, subject?, object?)
→ WorldRelation[]

HasRelation(type, subject, object)
→ bool

GetOutgoingRelations(subject, relation_filter?)
→ WorldRelation[]

GetIncomingRelations(object, relation_filter?)
→ WorldRelation[]

GetRelated(subject, relation_type, direction, constraints?)
→ RuntimeWorldRef[]

TraverseRelations(start, allowed_relation_types, max_depth, constraints)
→ bounded RelationTraversalResult
```

These operations query the authoritative `WorldRelationStore` through its indexed `WorldRelationGraph` view. The graph does not create a second source of truth.

Typical uses:

```text
direct/nested contents
assembly/component membership
attachments
possession/held state
bounded structural dependency traversal
```

## 3.3 Spatial/place queries

```text
QueryNearby(subject_or_place, constraints)
→ RuntimeWorldRef[]

QueryRoute(origin, destination, constraints)
→ RouteOption[]
```

`RouteOption` is derived. Concrete navmesh/graph representation belongs to infrastructure.

## 3.4 Container/carry queries

```text
GetContainerContents(container)
GetCarriedBy(actor)
GetHeldItems(actor)
CanAccept(container, item)
```

These are projections over relations + physical capabilities/properties, not a separate universal inventory owner.

---

# 4. Effective physical semantics

## 4.1 Effective profile

```text
ResolveEffectivePhysicalProfile(subject, PhysicalRuleContext)
→ EffectivePhysicalProfile

GetEffectiveProperty(subject, property_id, PhysicalRuleContext)
→ EffectivePropertyResult

HasEffectiveCapability(subject, capability_id, PhysicalRuleContext)
→ bool + optional provenance
```

Resolution uses deterministic composition of:

```text
material defaults
entity definition
instance condition/overrides
runtime components/relations
assembly bindings
contents
registered PropertyDerivationDefinition DAG
```

No Wilson cognition is consulted.

Missing property is absent/insufficient, not silently coerced to zero.

## 4.2 Property dependency validation

At content bootstrap:

```text
CompilePropertyDependencyGraph(PropertyDerivationDefinition[])
→ PropertyDependencyGraph
```

Validation requires:

```text
known property/selectors
compatible output type
acyclic dependency graph
bounded registered combination policies
no arbitrary executable callback
no structural self-containment cycle admitted into recursive aggregation
```

## 4.3 Derived invalidation/provenance

After committed World changes, application-local maintenance may use:

```text
DeriveAffectedPhysicalSubjects(SemanticChangeSet, CompositionDependencyProjection)
→ bounded RuntimeWorldRef[]

InvalidateDerivedPhysicalCaches(affected_subjects, changed_semantics)
```

Caches remain reconstructible and non-authoritative.

Diagnostic query:

```text
ExplainEffectiveProperty(subject, property_id)
→ PropertyDerivationTrace
```

---

# 5. Predicate and semantic-pattern evaluation

## 5.1 Requirement predicates

```text
EvaluatePredicate(predicate, EvaluationContext)
→ bool + optional PredicateDiagnostics
```

The normalized predicate algebra remains the authority for hard applicability/eligibility semantics.

## 5.2 Semantic pattern matching

```text
MatchSemanticPattern(pattern, FactProjection, MatchScope)
→ bounded PatternBinding[]
```

Supported pattern families are typed and bounded, such as:

```text
SubjectPattern
RelationPattern
PropertyConstraintPattern
CapabilityPattern
CategoryPattern
PropositionPattern
AllOf / AnyOf / Not
```

Pattern matching is candidate discovery, not final authority.

Therefore:

```text
pattern match
!= action valid
!= belief true
!= assembly commit
!= project contribution accepted
```

The owner-specific operation performs final validation.

---

# 6. Authoritative action opportunity / attemptability

## 6.1 Candidate discovery

```text
QueryAttemptableActions(
  initiator,
  authoritative_local_context,
  action_filter?
)
→ AttemptableActionBinding[]
```

Candidate discovery should use bounded local indexes/pattern matching rather than global action × entity Cartesian products.

Conceptually:

```text
local semantic scope
+ action-role/capability/category indexes
+ relation adjacency
+ SemanticPattern prefilter
→ candidate role bindings
→ QueryActionAttemptability
```

## 6.2 Attemptability

```text
QueryActionAttemptability(
  action_id,
  complete_or_candidate_role_binding,
  PhysicalRuleContext
)
→ AttemptabilityResult
```

Typical result classes:

```text
ATTEMPTABLE
UNREACHABLE
ROLE_INCOMPATIBLE
BODY_BLOCKED
HARD_PRECONDITION_FAILED
```

Attemptability answers whether a grounded attempt can begin/progress enough to produce consequences/evidence. It does **not** guarantee goal success.

Hidden resistance/effectiveness usually should not erase an otherwise enactable experiment.

---

# 7. Wilson-relative tactical opportunities

Physical attemptability and Wilson-perceived plausibility are separate.

```text
DerivePerceivedTacticalOpportunities(
  current_intention,
  PerceptionResult,
  WilsonCognition,
  DecisionContinuationContext
)
→ TacticalOpportunity[]
```

A tactical opportunity may be speculative. It sees only Wilson-accessible/believed semantics.

Selected tactics still pass through authoritative attemptability/validation before execution.

## 7.1 Learned interactions

```text
QueryLearnedInteractions(WilsonKnowledgeProjection, perceived_local_context)
→ SemanticAffordance[]
```

Learned patterns expose purposeful known interactions but never bypass physical validation.

---

# 8. Interaction regions

```text
QueryPerceivableInteractionRegions(subject, PerceptionContext)
→ PerceivedInteractionRegion[]

ResolveInteractionRegion(InteractionRegionRef, PhysicalRuleContext)
→ InteractionRegionProjection
```

Projection may include bounded semantics such as:

```text
accepted action roles
local resistance modifier
attachment/closure role
presentation adapter identifier
```

Hidden regions are not automatically exposed to cognition. Presentation maps semantic regions to transforms/colliders/anchors.

---

# 9. Assembly operations

## 9.1 Queries

```text
QueryAssemblyValidity(host)
→ AssemblyValidity

QueryCompatibleComponents(host, slot_id, local_candidates?)
→ EntityId[]

ValidateAssemblyBinding(host, slot_id, component)
→ AssemblyValidationResult
```

`QueryCompatibleComponents` may use SemanticPattern/index matching for candidate discovery, followed by full predicate validation.

`AssemblyValidity` is distinct from effective performance.

## 9.2 Commands

```text
AttachAssemblyComponent(host, slot_id, component)
DetachAssemblyComponent(host, slot_id, component)
```

Commands mutate ordinary World relation/binding truth through World authority.

After mutation, derived validity/effective profiles/protection are recomputed or invalidated from causes.

## 9.3 Diagnostics

```text
ExplainAssemblyValidity(host)
→ AssemblyValidityTrace
```

---

# 10. Environmental response / protection

## 10.1 Protection/exposure

```text
DeriveProtectionProjections(source_or_region, environment_context?)
→ ProtectionProjection[]

ResolveExposure(target_or_region, exposure_kind, environment_context)
→ ExposureResult
```

`covering capability != ProtectionProjection != resolved target exposure`.

## 10.2 Environmental response

```text
QueryApplicableEnvironmentalResponses(
  environment_state,
  authoritative_local_world_projection
)
→ EnvironmentalResponseCandidate[]

ResolveEnvironmentalResponse(candidate, elapsed, RandomSource?)
→ WorldMutationPlan | EnvironmentalProcessPlan
```

Rules operate on properties/capabilities/exposure/configuration, not object-type weather switches where reusable semantics suffice.

Example:

```text
rain active
+ absorbency > LOW
+ ResolveExposure(target, rain) >= LOW
→ moisture mutation/process
```

## 10.3 Diagnostics

```text
ExplainProtectionProjection(projection_ref)
ExplainExposureResult(target_ref, exposure_kind)
```

---

# 11. Hazard / dynamic-process operations

```text
AdvanceDynamicProcess(process, elapsed, authoritative_context)
→ DynamicProcessAdvanceResult

DeriveHazardProjection(process_or_source, authoritative_context)
→ HazardProjection

DerivePerceivedThreat(HazardAccessibleEvidence, WilsonContext)
→ PerceivedThreat?

QueryInterventionWindow(process, current_state)
→ InterventionWindow
```

Invariant:

```text
committed process != committed collision victim/result
```

Wilson emergency decisions consume `PerceivedThreat`, never hidden `HazardProjection` directly.

---

# 12. World commands

## 12.1 Entity lifecycle

```text
CreateEntity(type_id, place/transform, initial_state)
MoveEntity(entity_id, destination)
DestroyEntity(entity_id, reason)
TransformEntity(entity_id, transformation_id)
```

## 12.2 Property mutation

```text
SetInstanceProperty(entity_id, property_id, value)
ModifyInstanceProperty(entity_id, property_id, semantic_delta)
```

Only mutable instance properties may change.

## 12.3 Relation mutation

```text
CreateRelation(type, subject, object, qualifier?)
RemoveRelation(type, subject, object)
```

World validates `RelationDefinition` invariants/cardinality/exclusivity.

Committed relation/property changes update/rebuild derived indexes transactionally or deterministically through application-local maintenance.

## 12.4 Body effects

```text
ApplyBodyEffect(effect)
AdvanceBodyState(elapsed, environment_context)
```

## 12.5 Environment

```text
AdvanceEnvironment(elapsed)
```

World/environment mutation emits meaningful semantic facts at semantic boundaries, not one event per numeric tick.

---

# 13. Action execution and resolution

## 13.1 Final validation

```text
ValidateAction(action_id, complete_role_binding, PhysicalRuleContext)
→ ActionValidationResult
```

This is the final authoritative gate immediately before start and preserves attemptability-vs-success distinction.

## 13.2 Start

```text
StartAction(validated_action, selected_intention_id)
→ ActionExecutionState
```

Starting does not imply success.

## 13.3 Advance

```text
AdvanceAction(execution, elapsed, current_context)
→ ActionProgressResult
```

Possible semantic statuses:

```text
CONTINUE
CHECKPOINT_REACHED
COMMIT
COMPLETE
INTERRUPTIBLE_FAILURE
```

## 13.4 Resolve committed action

```text
ResolveCommittedAction(execution, current_world, RandomSource?)
→ ActionOutcome + WorldMutationPlan
```

Luck-sensitive choice is allowed only among already valid declared alternatives before authoritative commitment.

## 13.5 Outcome

`ActionOutcome` includes:

```text
classification
participants
resolved effects
diagnostic feedback
semantic outcome tags
consequence severity
causal identity
```

It does not mutate beliefs, habits, associations or projects directly.

---

# 14. Transformation resolution

```text
FindApplicableTransformations(subject, outcome_tags, world_context)
→ TransformationDefinition[]

ApplyTransformation(entity, selected_definition)
→ TransformationResult
```

Content validation rejects ambiguous overlapping final transformations unless explicit deterministic priority semantics are authored.

Generic interaction determines what semantic physical result happened; transformation definition determines how a particular content form changes.

---

# 15. Perception and evidence

## 15.1 Perception

```text
Perceive(world_query_snapshot, WilsonBodyState, current_context, WorldEvent[])
→ PerceptionResult
```

```text
PerceptionResult
  perceived_subjects
  observed_events
  perceptual_evidence
  accessible_environmental_context
  optional observation coverage projections
```

Static property discovery belongs in `perceptual_evidence`; it does not require fake WorldEvents.

## 15.2 Evidence derivation

```text
DerivePerceptualEvidence(
  perception_context,
  source_action_outcome?,
  source_world_events?,
  current_world_projection
)
→ PerceptualEvidence[]
```

Evidence output is Wilson-accessible and constrained by registered `EvidenceRuleDefinition`s/modality/accessibility.

Negative evidence requires sufficient `ObservationCoverage`; not-seen is not automatically absent.

---

# 16. Expectation / anomaly / investigation

```text
DeriveExpectations(WilsonCognition, PerceptionResult, current_context)
→ ExpectedState[]

CompareExpectation(expected, observed_or_perceived_state)
→ PredictionError / ExpectationMismatch
```

For bounded investigations:

```text
StartOrUpdateInvestigationContext(problem, mismatch, evidence, WilsonContext)
→ InvestigationContext

DeriveAnomalyPattern(context)
→ AnomalyPattern

DeriveCausalHypotheses(context, EpistemicGraphProjection)
→ CausalHypothesis[]

DerivePerceivedCausalOpportunities(hypothesis, perceived_context)
→ PerceivedCausalOpportunity[]

EvaluateInvestigationTactic(...)
→ bounded contributions
```

Actual cause, current world result, Wilson observation and Wilson attribution remain distinct.

---

# 17. Salience

```text
DeriveSalientSet(
  perception,
  WilsonCognition,
  expectations,
  current_intention,
  DirectorContext
)
→ bounded SalientSubject[]
```

Inputs may include threat, novelty, attachment, habit cue, mismatch, drive relevance, project relevance and opportunity urgency.

Salience is derived, not a permanent per-entity stat.

---

# 18. Tactical decision operations

```text
GenerateTacticalCandidates(TacticalDecisionContext)
→ CandidateTactic[]

EvaluateTacticalCandidate(candidate, TacticalDecisionContext)
→ EvaluationContribution[]

SelectTactic(plausible_candidates, RandomSource?)
→ SelectedTactic
```

Typical bounded contribution families:

```text
expected goal progress
information gain
perceived effectiveness
perceived risk
effort
continuity
curiosity/novelty
repetition penalty
partial-progress leverage
```

A selected tactic binds an ordinary `ActionDefinition`; it is not a new action type.

---

# 19. Intentional decision operations

```text
GenerateCandidates(DecisionContext)
→ CandidateIntention[]

EvaluateCandidate(candidate, DecisionContext)
→ EvaluationContribution[]

CombineContributions(candidate, contributions)
→ CandidateEvaluation

SelectIntention(plausible_evaluations, RandomSource)
→ SelectedIntention
```

Candidate sources include drives, known interactions, exploration, habits, projects, suspended interests, suggestions, director opportunities and reaction.

All contributions are finite/bounded. Immediate threat is a separate regime rather than huge utility values.

## 19.1 Intentional-state commands

```text
CommitSelectedIntention(selected)
SuspendCurrentIntention(reason)
CompleteCurrentIntention(outcome_ref)
DiscardCurrentIntention(reason)
ResumeSuspendedIntention(intention_id)
```

One current intention maximum. Suspended set remains bounded/selective.

---

# 20. Decision continuation / reconsideration routing

```text
DecisionContinuationContext
  intention_id
  recent_tactic_signatures
  recent_outcome_refs
  recent_evidence_refs
  last_progress_ref?
```

Bounded to the current/suspended intention chain; not a second episodic memory store or durable failure counter.

```text
RouteReconsideration(trigger_batch, current_context)
→ TACTICAL | INTENTIONAL | IMMEDIATE_THREAT | NONE
```

Tactical may escalate when no plausible tactic remains, perceived value collapses, risk/cost crosses bounded tolerance or a stronger competing trigger arrives.

---

# 21. Immediate threat path

```text
DetectImmediateThreat(PerceptionResult, WilsonBodyState)
→ PerceivedThreat?

GenerateDefensiveCandidates(threat, perceived_route_options)
→ bounded DefensiveCandidate[]

SelectFeasibleDefense(candidates, WilsonContext, RandomSource?)
→ SelectedTactic/Intention
```

No infinity-score hacks. Defense still passes through normal physical validation.

---

# 22. Learning operations

## 22.1 Evidence interpretation

```text
InterpretLearningEvidence(perception/outcome, WilsonContext)
→ LearningProposalBatch
```

May contain:

```text
BeliefEvidence
AssociationImpact
HabitEvidence
EpisodeCandidate
PresenceEvidence
```

## 22.2 Owner-local commands

```text
ApplyBeliefEvidence
ApplyAssociationImpact
ApplyHabitEvidence
AdmitEpisodeCandidate
ApplyPresenceEvidence
```

Each store validates its own bounds/saturation/contradiction semantics.

## 22.3 Immediate same-chain learning

```text
ProcessImmediateRelevantLearning(
  PerceptionResult,
  ActionOutcome?,
  current_intention,
  WilsonCognition
)
→ AppliedLearningSummary
```

Semantic meaning:

```text
InterpretLearningEvidence
→ owner-local Apply* commands
→ return relevant revised cognition projection
```

Use only where grounded evidence can materially affect the next same-chain tactic.

Ordering:

```text
outcome
→ perception/evidence
→ immediate relevant learning
→ perceived tactical opportunities
→ tactical candidate generation
```

## 22.4 Epistemic graph queries

```text
QueryBeliefsBySubject(subject, constraints?)
QueryBeliefsByPredicate(predicate_pattern, constraints?)
MatchBeliefPattern(PropositionPattern, scope)
QuerySupportingOpposingEvidence(proposition_or_hypothesis, scope)
```

These use `EpistemicGraphProjection` over cognition-owned stores. They never import hidden World facts.

---

# 23. Reaction

```text
DeriveReaction(
  observation/outcome,
  expectation,
  beliefs,
  association,
  attribution,
  current_goal
)
→ ReactionState?
```

Reaction is transient. Durable consequences become learning proposals.

---

# 24. Project operations

Queries:

```text
QueryEligibleProjectDefinitions(context)
QueryProjectContributions(project, world_context)
```

Commands:

```text
StartProject(definition, bindings)
PauseProject(project_id)
ResumeProject(project_id)
ApplyProjectOutcome(project_id, ActionOutcome)
CompleteProject(project_id)
AbandonProject(project_id, reason)
```

Progress only from grounded outcomes/world facts. Projects never directly set Wilson's current intention or duplicate physical structure truth.

SemanticPattern may accelerate eligibility/contribution candidate discovery, but final project predicates remain authoritative.

---

# 25. Director operations

```text
QueryEligibleEvents(approved_world_cognition_context)
GetDirectorContext(active_event_instances)

ActivateEvent(definition, bindings)
AdvanceEvent(instance, semantic_events/time)
ResolveEvent(instance)
ExpireEvent(instance)
```

Director may expose opportunities/bounded bias, never `SetWilsonIntention` or direct cognition mutation.

---

# 26. Non-Wilson actor operations

```text
DeriveActorOptions(actor_state, local_world_context)
SelectActorActivity(options, RandomSource)
CommitActorActivity(actor_state, selection)
AdvanceActorActivity(actor_state, elapsed)
```

The actor model remains deliberately shallow. Recurring identity does not imply Wilson-level cognition for animals.

---

# 27. Suggestion operations

```text
IssueSuggestion(intention_pattern, bindings)
→ SuggestionSignal + updated SuggestionWindowState
```

Validation covers grammar, bounded insistence/cooldown and applicable visibility/availability rules.

The signal influences candidate generation/evaluation but never commits an intention.

---

# 28. Player intervention transaction

```text
RequestIntervention(capability, target_or_bindings)
→ InterventionValidation
```

If valid:

```text
reserve/consume God Power
→ apply validated World mutation
→ confirm World commit
→ finalize cost
→ emit WorldEvent
```

Accepted intervention and cost mutation cannot diverge. Failed world application has deterministic rollback/refund semantics.

Wilson psychology changes only through perception/attribution/evidence after the resulting world event.

---

# 29. Luck-sensitive resolution

```text
EvaluateEffectiveLuck(LuckContext)
→ SignedUnit

SelectLuckSensitiveVariant(valid_variants, effective_luck, RandomSource)
→ selected variant
```

Only already valid declared variants participate. Luck cannot manufacture impossible outcomes or rewrite committed causes.

---

# 30. Death / resurrection / End Run

## 30.1 Death

```text
grounded body/world consequence
→ WilsonBodyState.alive = false
→ finish committed semantic/visual consequence
→ run enters AWAITING_DEATH_CHOICE
```

Death is not a cognition command.

## 30.2 Resurrection

Named application transaction coordinates body restoration and admitted cognitive continuity according to product/state contracts.

Wilson does not consciously remember dying; grounded danger learning may remain according to accepted rules.

## 30.3 End Run

Coordinates run closure, bounded Legacy Knowledge extraction, Diary archival and profile mutations. Cross-run transfer never copies arbitrary Wilson autobiography.

---

# 31. Offline catch-up

```text
AdvanceOffline(elapsed, OfflinePolicy, deterministic streams)
→ bounded owner-local advances + CatchUpSummary
```

Reuse normal domain semantics under conservative allowed-outcome policies.

Offline policy suppresses death, rare spectacle/major discovery consumption and other forbidden outcome classes rather than creating a second contradictory simulation.

---

# 32. Diagnostics / explanation

Pure diagnostics include:

```text
ExplainEffectiveProperty
ExplainAssemblyValidity
ExplainProtectionProjection
ExplainExposureResult
ExplainActionAttemptability
ExplainTacticalCandidate
ExplainIntentionalCandidate
ExplainPerceptualEvidence
ExplainBeliefMatch
ExplainRelationTraversal
ExplainSemanticPatternMatch
ExplainHazardProjection
ExplainPerceivedThreat
```

Diagnostics derive from semantic provenance already available. They never alter results.

---

# 33. Canonical micro-loop operation surface

```text
advance due World/body/environment/dynamic processes
→ advance current ActionExecution
→ commit authoritative owner-local mutations in deterministic causal order
→ collect ActionOutcome / WorldEvent
→ Perceive + DerivePerceptualEvidence
→ immediate-threat check
→ ProcessImmediateRelevantLearning when required
→ RouteReconsideration

if IMMEDIATE_THREAT:
  defensive fast path

else if TACTICAL:
  DerivePerceivedTacticalOpportunities
  → GenerateTacticalCandidates
  → Evaluate/SelectTactic
  → QueryActionAttemptability / ValidateAction
  → StartAction

else if INTENTIONAL:
  expectations/salience
  → Generate/Evaluate/SelectIntention
  → CommitSelectedIntention
  → tactical derivation for first action

→ grounded project/director processing
→ maintenance
→ presentation/debug projections
```

No render callback is authoritative.

---

# 34. Operation invariants

The operation surface is accepted only while these remain true:

```text
authoritative attemptability != Wilson tactical plausibility
effective physical truth never reads cognition
Wilson decision never reads hidden World truth
patterns discover candidates but do not bypass final validation
graph indexes never own mutation
assembly validity != effective performance
projects progress only from grounded outcomes/world facts
learning mutates only owner-local cognition stores
player private intent never becomes evidence
committed action/process causes are not rewound by reconsideration
RNG usage is named/seeded/stably ordered
render FPS is never simulation authority
```
