# Functional Domain Operations

## Status and purpose

This document is the single canonical language-neutral **operation surface** for Wilson Shipwrecked.

It owns public query, derivation, owner-command and lifecycle-operation semantics. `DOMAIN_MODEL.md` owns state/concepts; `ARCHITECTURE.md` owns responsibility/dependency boundaries; specialized `DOMAIN_*` appendices own narrow semantics. Concrete implemented subset/version details live in `DISCOVERY_STATUS.md`.

This document does not mandate method syntax, class layout, Godot signals, persistence APIs or database/query technology.

---

# 1. Operation categories

## Query

```text
state + parameters → deterministic result
```

No mutation, authoritative event emission or gameplay RNG.

## Derivation / decision service

```text
state/projections + context + optional named RandomSource
→ derived proposal/result
```

May consume seeded gameplay RNG only where selection semantics explicitly permit it. Does not mutate durable owners.

## Command

```text
command
→ one owner validates
→ owner-local mutation
→ result / semantic facts
```

A failed command does not intentionally leave partial mutation.

## Lifecycle transaction

Coordinates multiple owners at a named boundary such as intervention, resurrection, End Run, offline catch-up or reconstruction. Ordering/atomicity is explicit and never delegated to broad subscriber order.

---

# 2. Shared query rules

## Authority context

Queries/predicates that can cross epistemic boundaries declare context such as:

```text
PhysicalRuleContext
CognitionContext
ContentEligibilityContext
InterventionContext
PerceptionContext
```

Physical truth never consults Wilson belief merely to decide legality/effectiveness. Cognition never consumes hidden World facts as observations.

## Bounds

Graph/pattern/spatial discovery is bounded by local place/region, relation set, max depth, result limit, typed pattern or explicit candidate set.

No ordinary gameplay operation performs an unbounded global Cartesian scan/walk.

## Stable ordering

Unordered semantic results are normalized to stable semantic ordering before deterministic tie-break or seeded randomness.

---

# 3. World queries

## Direct facts

```text
GetInstanceProperty(subject, property_id) → PropertyValue?
HasAuthoredCapability(subject, capability_id) → bool
HasCategory(subject, category_id) → bool
GetPlace(subject) → PlaceId?
IsLiveSubject(subject) → bool
```

These answer direct authoritative facts. Derived physical semantics use the effective-profile operations below.

## Relations

```text
FindRelations(type?, subject?, object?) → WorldRelation[]
GetRelation(exact_relation_key) → WorldRelation?
HasRelation(type, subject, object, qualifier?) → bool
GetOutgoingRelations(subject, relation_filter?) → WorldRelation[]
GetIncomingRelations(object, relation_filter?) → WorldRelation[]
TraverseRelations(start, allowed_types, max_depth, result_limit, direction)
→ RelationTraversalResult
```

`FindRelations(type, subject, object)` is intentionally broad and may return several edges when qualifiers differ.

Exact relation identity is:

```text
type + subject + object + optional qualifier
```

The qualifier is a bounded semantic `PropertyValue` / typed semantic ID. Relation identity does not by itself decide whether a configuration is admissible; relation/assembly validation handles cardinality/exclusivity.

## Spatial/place queries

```text
AreCoLocated(a, b) → bool
QueryNearby(subject_or_place, constraints) → bounded RuntimeWorldRef[]
QueryRoute(origin, destination, constraints) → RouteOption[]
```

Current foundation proves coarse `PlaceId` co-location/nearby semantics. Fine distance, occlusion and navigation are infrastructure adapters behind this boundary.

## Containers/carry

```text
GetContainerContents(container)
GetCarriedBy(actor)
GetHeldItems(actor)
CanAccept(container, item)
```

These are projections over relations + physical semantics, not a universal inventory owner.

---

# 4. Effective physical semantics

```text
ResolveEffectivePhysicalProfile(subject, PhysicalRuleContext)
→ EffectivePhysicalProfile

GetEffectiveProperty(subject, property_id, PhysicalRuleContext)
→ EffectivePropertyResult

HasEffectiveCapability(subject, capability_id, PhysicalRuleContext)
→ bool + optional provenance
```

Resolution composes admitted authored/base/instance/component/content semantics through validated bounded policies. Missing input is absent/insufficient, never silently zero.

## Property dependency graph

At bootstrap:

```text
CompilePropertyDependencyGraph(PropertyDerivationDefinition[])
→ validated PropertyDependencyGraph
```

Validation includes known selectors/properties, compatible output families, registered policies, acyclicity and no arbitrary callbacks.

Current selector families proven by the foundation include:

```text
self.property
assembly_slot(slot_id).property
```

## Invalidation/provenance

```text
DeriveAffectedPhysicalSubjects(SemanticChangeSet, CompositionDependencyProjection)
→ bounded RuntimeWorldRef[]

InvalidateDerivedPhysicalCaches(...)
ExplainEffectiveProperty(subject, property_id) → derivation trace
```

Component mutation propagates through composition dependencies to dependent hosts. These projections/caches are reconstructible, not authority.

---

# 5. Predicate and semantic-pattern evaluation

```text
EvaluatePredicate(predicate, EvaluationContext)
→ PredicateEvaluationResult
```

Property comparisons validate value-family compatibility before ordering/equality operations.

```text
MatchSemanticPattern(pattern, FactProjection, MatchScope)
→ bounded PatternBinding[]
```

Pattern matching is candidate discovery only:

```text
pattern match
!= action valid
!= belief true
!= assembly commit
!= project contribution accepted
```

Final validation remains owner/domain-specific.

---

# 6. Action opportunity and attemptability

```text
QueryAttemptableActions(initiator, authoritative_local_context, action_filter?)
→ bounded AttemptableActionBinding[]
```

Candidate discovery uses local indexes/patterns, not global action × entity products.

```text
QueryActionAttemptability(action_id, role_binding, PhysicalRuleContext)
→ AttemptabilityResult
```

Attemptability asks whether a grounded attempt can begin/progress enough to obtain a real result/evidence. It does not guarantee goal success; hidden resistance should normally be discovered by resolution rather than erase an enactable experiment.

Wilson-relative tactical plausibility is separate:

```text
DerivePerceivedTacticalOpportunities(current_intention, PerceptionResult, WilsonCognition, continuation_context)
→ TacticalOpportunity[]
```

Selected tactics still pass authoritative validation.

---

# 7. Assembly operations

```text
QueryAssemblyValidity(host) → AssemblyValidity
QueryCompatibleComponents(host, slot_id, local_candidates?) → EntityId[]
ValidateAssemblyBinding(host, slot_id, component) → AssemblyValidationResult
ExplainAssemblyValidity(host) → trace
```

Bindings are projected from ordinary authoritative World relations, commonly:

```text
attached_to(component, host, qualifier = AssemblySlotId)
```

Mutation uses normal World relation commands:

```text
CreateRelation(attached_to, component, host, slot_id)
RemoveRelation(attached_to, component, host, slot_id)
```

`AssemblyValidity` is distinct from performance. A weak but compatible assembly may remain `VALID` while effective properties degrade.

---

# 8. World commands and commit boundary

## Entity/property

```text
CreateEntity(...)
MoveEntity(...)
DestroyEntity(...)
TransformEntity(...)
SetInstanceProperty(entity_id, property_id, value)
ModifyInstanceProperty(entity_id, property_id, semantic_delta)
```

Property values are schema-validated and finite before authoritative mutation.

## Relations

```text
CreateRelation(type, subject, object, qualifier?)
RemoveRelation(type, subject, object, qualifier?)
```

Both address exact qualified identity. The owner may separately validate relation-definition cardinality/exclusivity.

## Effect batch semantics

A committed `ActionOutcome` may contain multiple effects. For the supported effect family, the World command boundary must validate the **ordered batch as a whole** against a shadow/prospective state before applying it, so an internally contradictory later effect cannot intentionally leave earlier mutation behind.

After successful owner commit:

```text
World state mutation
→ SemanticChangeSet for reconstructible invalidation
→ WorldEvent fact
```

`SemanticChangeSet` is not a gameplay event bus.

---

# 9. Action execution lifecycle

## Start

```text
StartAction(execution_id, ActionDefinition, ActionResolutionDefinition, RoleBinding)
→ ActionExecutionState | explicit failure/result
```

Attemptability is checked at start. Starting does not imply success.

## Progress / commit

```text
AdvanceAction(execution_id, elapsed)
→ ActionProgressResult
```

Execution tracks elapsed progress, commit state, outcome-emitted state and terminal state.

At the authored commit fraction:

```text
not committed
→ committed
→ emit exactly one ActionOutcome
```

The World still does not mutate until its owner accepts the outcome.

## Interruption

Current canonical coarse interruption classes are:

```text
PRE_COMMIT_ONLY
NEVER
ANYTIME
```

Semantics:

- `PRE_COMMIT_ONLY` — may terminate before commit, never after;
- `NEVER` — ordinary interruption is not admitted;
- `ANYTIME` — may terminate before or after commit, but post-commit interruption only ends the remaining execution tail and cannot rewind the committed outcome.

If later representative actions need named safe checkpoints beyond the commit point, extend this contract explicitly rather than simulating them with hidden timing hacks.

## Terminality / cleanup

```text
completed OR interrupted → terminal
PruneTerminalExecutions() → owner-local cleanup result
```

Cleanup is separate from becoming terminal. Persistence may reconstruct terminal execution state without replaying outcomes.

## Reconstruction invariant

Restoring an existing execution restores past causal state; it does **not** rerun current attemptability to reconsider whether history should have happened.

---

# 10. Event, perception and evidence

## EventDefinition

```text
EventDefinition
  id: EventDefinitionId
  perceptible_roles
  modalities
  bounded base_confidence
```

It defines the semantic/perceptual envelope of a `WorldEvent` kind, not Director lifecycle.

## Perception access

```text
ResolvePerceptionAccess(WorldEvent[], PerceptionContext)
→ access by event/execution
```

The current engine-agnostic adapter derives accessibility from `EventDefinition` + authoritative coarse spatial placement. Fine metric/occlusion adapters may replace it behind the same contract.

## Perceive

```text
Perceive(WorldEvent[], resolved_access)
→ PerceptionResult
```

Produces only Wilson-accessible roles/observations/evidence. Hidden bindings must not reappear downstream.

## PerceptualEvidence

```text
PerceptualEvidence
  claim: EpistemicClaim
  confidence
  source_execution_id
  modality
```

Current typed claim kinds:

```text
PROPERTY(subject, PropertyId, PropertyValue)
RELATION(subject, RelationTypeId, object)
EVENT(subject, EventDefinitionId, perceived_role)
```

Static property/relation discovery need not fabricate a WorldEvent; richer evidence rules may produce the corresponding typed claim directly when those modalities are implemented.

---

# 11. Epistemic and learning operations

```text
ApplyBeliefEvidence(BeliefEvidence) → owner-local MutationResult
QueryBelief(EpistemicClaim / pattern) → BeliefEntry?
RebuildEpistemicGraphProjection(BeliefStore)
QueryEpistemicBySubject(...)
QueryEpistemicByKind(...)
QueryEpistemicBySemanticId(...)
```

The projection indexes cognition-owned beliefs only; it never imports hidden World truth.

Durable identity is based on typed claims, not generic predicate/Variant serialization.

Learning pipeline:

```text
PerceptionResult / grounded outcome
→ InterpretLearningEvidence
→ BeliefEvidence / AssociationImpact / HabitEvidence / EpisodeCandidate / PresenceEvidence
→ owner-local Apply* commands
```

Repeated identical evidence is subject to diminishing/saturation rules; contradictory evidence must remain able to revise belief.

For same-chain experimentation:

```text
outcome
→ perception/evidence
→ immediate relevant learning
→ perceived tactical opportunities
→ tactical candidate generation
```

---

# 12. Expectation / investigation

```text
DeriveExpectations(...)
CompareExpectation(...)
StartOrUpdateInvestigationContext(...)
DeriveAnomalyPattern(...)
DeriveCausalHypotheses(...)
DerivePerceivedCausalOpportunities(...)
EvaluateInvestigationTactic(...)
```

Actual cause, current World result, Wilson observation and Wilson attribution remain distinct. Negative evidence requires sufficient observation coverage.

Investigation working sets are bounded/transient unless a minimal resumable continuation is explicitly justified.

---

# 13. Decision operations

## Tactical

```text
GenerateTacticalCandidates(context)
EvaluateTacticalCandidate(...)
SelectTactic(...)
```

## Intentional

```text
GenerateCandidates(DecisionContext)
EvaluateCandidate(...)
CombineContributions(...)
SelectIntention(...)
```

## Immediate threat

```text
DetectImmediateThreat(PerceptionResult, WilsonBodyState)
GenerateDefensiveCandidates(...)
SelectFeasibleDefense(...)
```

Immediate threat is a separate regime, not an infinity-score contribution.

## Routing / intentional state

```text
RouteReconsideration(...) → TACTICAL | INTENTIONAL | IMMEDIATE_THREAT | NONE
CommitSelectedIntention(...)
SuspendCurrentIntention(...)
CompleteCurrentIntention(...)
DiscardCurrentIntention(...)
ResumeSuspendedIntention(...)
```

Candidate contributions are finite/bounded. Suggestions/Director influence are inputs to competition, never commands.

---

# 14. Projects

```text
QueryProjectOpportunities(...)
ValidateProjectContribution(...)
ApplyGroundedProjectProgress(...)
Complete/Pause/AbandonProject(...)
```

Project metadata/lifecycle is owner state; physical structure truth remains World-owned.

Canonical flow:

```text
project opportunity
→ normal candidate competition
→ action
→ World commit/outcome
→ project validates grounded consequence
→ project owner mutation
```

---

# 15. Environment, protection and hazards

## Protection/exposure

```text
DeriveProtectionProjections(...)
ResolveExposure(...)
ExplainProtectionProjection(...)
ExplainExposureResult(...)
```

## Environmental response

```text
QueryApplicableEnvironmentalResponses(...)
ResolveEnvironmentalResponse(candidate, elapsed, RandomSource?)
→ WorldMutationPlan | EnvironmentalProcessPlan
```

## Dynamic processes/hazards

```text
AdvanceDynamicProcess(...)
DeriveHazardProjection(...)
DerivePerceivedThreat(...)
QueryInterventionWindow(...)
```

Invariant:

```text
committed process != committed future collision victim/result
```

Wilson emergency decisions consume perceived threat only.

---

# 16. Player / Director / run lifecycle

## Player intervention

```text
ValidateIntervention(...)
ApplyInterventionTransaction(...)
```

Physical intervention mutates World through explicit validated operations. Wilson psychology changes only through perception/evidence.

Suggestion:

```text
SuggestionSignal → bounded candidate contribution → ordinary selection/validation
```

## Director

```text
EvaluateDirectedEventEligibility(...)
Open/advance/expire DirectorOpportunity(...)
```

Use `DirectedEventDefinition/Instance` for Director-owned lifecycle; use `EventDefinition/WorldEvent` for ordinary occurrence/perception semantics.

## Run lifecycle

```text
StartRun
Resurrect
EndRun
OfflineCatchUp
Save / Load / Rebuild
```

Lifecycle orchestration coordinates owner-local operations in deterministic order; it does not create a second authority store.

---

# 17. Persistence/reconstruction operations

Persist causes and minimal active lifecycle state; reconstruct derived indexes/projections/caches.

Current structural baseline proves reconstruction of:

```text
entities / property overrides
qualified World relations
Wilson coarse PlaceId
BeliefStore typed claims
CurrentIntention
ActionExecution pre/post commit and terminal state
```

and rebuilds relation/epistemic/physical projections as required.

Exact schema versions are implementation status, not domain semantics; see `DISCOVERY_STATUS.md`.

---

# 18. Diagnostics/explainability

Important operations should expose bounded diagnostics/provenance where decisions/derivations are nontrivial:

```text
ExplainEffectiveProperty
ExplainAssemblyValidity
ExplainAttemptability
ExplainPredicateFailure
ExplainPerceptionAccess
ExplainBeliefRevision
ExplainExpectationMismatch
ExplainCausalHypothesis
ExplainCandidateEvaluation
ExplainSelectedIntention
ExplainWorldCommit
```

Diagnostics never gain mutation authority.

---

# 19. Operation admission rule

Before adding a public operation, ask:

1. Is it owner-local mutation or a pure derivation/query?
2. Can an existing operation accept a new property/capability/relation/typed claim/content definition instead?
3. Does it preserve World/observation/belief separation?
4. Is discovery bounded and stably ordered?
5. Does it preserve committed causality and persistence reconstruction?
6. Does a representative system/scenario actually require it?

Avoid scene-specific APIs, global scanners, generic mutation buses and duplicate authority surfaces.
