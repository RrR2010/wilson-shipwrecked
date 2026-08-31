# Functional Domain Operations

## Purpose

This document defines the language-neutral **behavioral surface of the functional domain model** in `DOMAIN_MODEL.md`.

`DOMAIN_MODEL.md` owns state shape and conceptual entities/value objects. This document owns:

- commands that may cause authoritative mutation;
- pure queries;
- domain services that derive semantic results;
- aggregate invariants;
- state-transition rules;
- orchestration-facing boundaries.

It does not define method syntax, classes per file, Godot signals, event-bus technology, dependency injection or persistence APIs.

---

# 1. Operation categories

Every domain operation belongs to one of four categories.

## 1.1 Query

Reads domain state and returns a deterministic derived answer.

```text
state + query parameters
→ result
```

Queries do not mutate state, consume RNG or emit authoritative events.

## 1.2 Decision/derivation service

Reads state and may consume deterministic gameplay RNG to derive a proposal/selection.

```text
state + context + RandomSource
→ derived proposal/result
```

It does not directly mutate durable owners.

## 1.3 Command

Requests a mutation from the owning aggregate/system.

```text
command
→ owner validates invariants
→ owner-local mutation
→ semantic result/events
```

A command may fail without mutation.

## 1.4 Lifecycle transaction

Coordinates multiple owners at an explicit domain boundary such as intervention, death/resurrection or End Run.

These transactions have named ordering/atomicity semantics and must not be hidden behind generic callbacks.

---

# 2. World queries

## 2.1 Effective property query

```text
GetEffectiveProperty(entity_id, property_id)
→ PropertyValue? 
```

Resolution order:

```text
instance override
→ type definition
→ absent
```

No Wilson knowledge is consulted.

## 2.2 Capability/category queries

```text
HasCapability(subject, capability_id) → bool
HasCategory(subject, category_id) → bool
```

These answer authoritative semantic facts.

## 2.3 Relation queries

```text
FindRelations(type?, subject?, object?)
→ WorldRelation[]

HasRelation(type, subject, object)
→ bool
```

Used by storage, held state, object arrangement, route obstruction and attachment/part relations.

## 2.4 Spatial/place queries

```text
GetPlace(subject) → PlaceId?
QueryNearby(subject/place, constraints) → SubjectRef[]
QueryRoute(origin, destination, constraints) → RouteOption[]
```

`RouteOption` is derived and may expose semantic annotations such as:

```text
length/effort class
known hazard subjects/places
current obstruction
surface/context properties
```

The implementation may later use navigation meshes/graphs; the domain query remains semantic.

## 2.5 Container/carry queries

```text
GetContainerContents(container)
GetCarriedBy(actor)
GetHeldItems(actor)
CanAccept(container, item)
```

These are projections over world relations + capabilities/properties.

---

# 3. World commands

## 3.1 Entity lifecycle

```text
CreateEntity(type_id, place/transform, initial_state)
MoveEntity(entity_id, destination)
DestroyEntity(entity_id, reason)
TransformEntity(entity_id, transformation_id)
```

World validates definition references, relation integrity and transformation transfer policy.

## 3.2 Property mutation

```text
SetInstanceProperty(entity_id, property_id, value)
ModifyInstanceProperty(entity_id, property_id, semantic_delta)
```

Only mutable instance properties may be changed. Definition/base properties are content, not runtime mutation targets.

## 3.3 Relation mutation

```text
CreateRelation(type, subject, object, qualifier?)
RemoveRelation(type, subject, object)
```

Relation invariants prevent impossible duplicates/exclusivity conflicts, e.g. one entity cannot normally be simultaneously held in two hands/containers unless the relation type explicitly permits it.

## 3.4 Body effects

```text
ApplyBodyEffect(effect)
AdvanceBodyState(elapsed, environment_context)
```

Examples:

```text
injury
poisoning
wetness
exertion
recovery
lethal consequence
```

The owner produces authoritative body-change events; cognition learns only from accessible observations.

## 3.5 Environmental advance

```text
AdvanceEnvironment(elapsed)
```

May progress:

```text
weather
spoilage
drying/wetting
fire fuel consumption
vegetation/fruit processes
storm weakening/damage preparation
```

The operation emits semantic world events only for meaningful changes; it need not emit one event per numeric tick.

---

# 4. Predicate evaluation

`RequirementPredicate` is evaluated against an explicit context.

```text
EvaluatePredicate(predicate, EvaluationContext)
→ bool + optional diagnostics
```

Contexts are scoped to prevent accidental omniscience.

## 4.1 PhysicalRuleContext

May read:

```text
world properties/capabilities
world relations
spatial context
body state where physically relevant
```

Must not read Wilson beliefs/associations merely to decide physical truth.

## 4.2 CognitionContext

May read:

```text
Wilson beliefs
associations
habits
traits/drives
current/suspended intention
perceived world projection
```

Must not read unperceived authoritative facts as if Wilson knew them.

## 4.3 ContentEligibilityContext

Used by Project/Director authored eligibility.

May read explicitly approved semantic projections from both world and Wilson state. The definition declares which context family it requires.

## 4.4 InterventionContext

May read:

```text
mode
God Power
world target capabilities
allowed Wilson-relative discovery state where product rules require it
```

Private player intent is input metadata for UI only, never cognition evidence.

---

# 5. Affordance operations

## 5.1 Physical/exploratory affordances

```text
QueryPhysicalAffordances(initiator, perceived/local context)
→ Affordance[]
```

Algorithmic contract:

1. start from initiating subject capabilities/actions;
2. select locally relevant candidate participants;
3. test reusable physical rule predicates;
4. return partial/complete role bindings;
5. do not evaluate Wilson desire.

The query must remain bounded; no global Cartesian product.

## 5.2 Learned semantic affordances

```text
QueryLearnedInteractions(WilsonKnowledgeProjection, local context)
→ SemanticAffordance[]
```

A learned semantic affordance exposes purposeful intent but still points to the same authoritative physical action/rules.

---

# 6. Action resolution service

## 6.1 Validate action

```text
ValidateAction(action_id, complete_role_binding, PhysicalRuleContext)
→ ActionValidationResult
```

Possible results:

```text
VALID
INVALID_PARTICIPANTS
PRECONDITION_FAILED
TEMPORARILY_BLOCKED
```

## 6.2 Start action

```text
StartAction(validated_action, selected_intention_id)
→ ActionExecutionState
```

Starting does not imply success.

## 6.3 Advance action

```text
AdvanceAction(execution, elapsed/current_context)
→ ActionProgressResult
```

May return:

```text
CONTINUE
CHECKPOINT_REACHED
COMMIT
COMPLETE
INTERRUPTIBLE_FAILURE
```

## 6.4 Resolve committed action

```text
ResolveCommittedAction(execution, current_world, RandomSource?)
→ ActionOutcome + WorldMutationPlan
```

The plan is validated/applied through world authority.

Luck-sensitive randomness is allowed only when the resolution definition explicitly declares unresolved valid alternatives before commitment.

## 6.5 Produce outcome

`ActionOutcome` records:

```text
classification
participants
resolved effects
diagnostic feedback
semantic outcome tags
consequence severity
causal identity
```

It does not mutate beliefs/projects/habits directly.

---

# 7. Transformation resolution

```text
FindApplicableTransformations(subject, semantic_outcome_tags, world_context)
→ TransformationDefinition[]

ApplyTransformation(entity, selected_definition)
→ TransformationResult
```

Selection must be deterministic when more than one transform is eligible, or content validation must reject ambiguous overlapping definitions unless explicit priority semantics exist.

This is a content invariant: generic interaction rules may overlap; final physical transformations must not be silently ambiguous.

---

# 8. Perception operations

```text
Perceive(world_snapshot/query, WilsonBodyState, current_context, WorldEvent[])
→ PerceptionResult
```

Perception derives:

```text
PerceivedSubject[]
ObservedEvent[]
accessible environmental context
```

Observation records what Wilson could access, not authoritative cause.

Perception may use deterministic sensory thresholds/occlusion. If uncertainty/noise is stochastic, it uses a dedicated deterministic stream.

---

# 9. Expectation and prediction error

```text
DeriveExpectations(WilsonCognition, PerceptionResult, current intention/context)
→ ExpectedState[]

CompareExpectation(expected, observed/current perceived state)
→ PredictionError
```

Expected arrangements are ordinary propositions:

```text
spoon expected beside cooking area
materials expected inside storage
favorite rock expected at usual place
Gerald expected to approach food under cue
```

Prediction error can feed salience, learning, causal attribution and reaction; it is not persisted as independent long-term state.

---

# 10. Salience

```text
DeriveSalientSet(perception, WilsonCognition, expectations, current intention, DirectorContext)
→ bounded SalientSubject[]
```

Inputs may include:

```text
threat
novelty
attachment
habit cue
expectation mismatch
need relevance
project relevance
opportunity urgency
Director framing
```

Salience never becomes a permanent per-entity stat.

---

# 11. Candidate intention generation

```text
GenerateCandidates(DecisionContext)
→ CandidateIntention[]
```

Candidate sources are compositional:

```text
DriveIntentionSource
KnownInteractionSource
ExplorationSource
HabitSource
ProjectSource
SuspendedInterestSource
SuggestionSource
DirectorOpportunitySource
ReactionSource
```

Sources propose intentions; none chooses Wilson's action.

Equivalent candidates are semantically deduplicated before evaluation.

---

# 12. Intention evaluation and selection

```text
EvaluateCandidate(candidate, DecisionContext)
→ EvaluationContribution[]

CombineContributions(candidate, contributions)
→ CandidateEvaluation

SelectIntention(plausible_evaluations, RandomSource)
→ SelectedIntention
```

Contribution families include:

```text
need relief
project value
association/preference
attachment relevance
curiosity/information value
habit
perceived risk
effort
uncertainty
suggestion pressure
opportunity urgency
completion proximity
continuity/switching cost
transient reaction
Director bias
```

Invariants:

- every contribution is finite and bounded;
- impossible/implausible candidates are filtered before stochastic selection;
- immediate threat uses a separate regime;
- selection result is a proposal to `IntentionalState` owner.

---

# 13. Intentional-state commands

```text
CommitSelectedIntention(selected)
SuspendCurrentIntention(reason)
CompleteCurrentIntention(outcome_ref)
DiscardCurrentIntention(reason)
ResumeSuspendedIntention(intention_id)
```

Invariants:

- one current intention maximum;
- suspended list is bounded/selective;
- death clears current/fragile suspended intentions according to resurrection contract;
- physical action commitment cannot be undone by merely replacing the intention.

---

# 14. Immediate threat path

```text
DetectImmediateThreat(perception/body/world context)
→ ImmediateThreat?

GenerateDefensiveCandidates(threat)
→ bounded DefensiveCandidate[]

SelectFeasibleDefense(...)
→ SelectedIntention
```

This path bypasses normal broad competition but still validates physical feasibility and does not use infinity scores.

---

# 15. Reaction derivation

```text
DeriveReaction(observation/outcome, expectation, beliefs, association, attribution, current goal)
→ ReactionState?
```

Examples:

```text
fear
anger
joy/excitement
concern
surprise
frustration
relief
```

Reaction is temporary. Durable consequences are emitted as learning proposals rather than persisting long-term emotion bars.

---

# 16. Causal attribution

```text
DeriveCausalHypotheses(observed anomaly, Wilson context)
→ CausalHypothesis[]

SelectAttribution(hypotheses, deterministic/optional bounded interpretation)
→ AttributionResult
```

Candidate cause classes include:

```text
self
known actor
natural process
unknown ordinary cause
unseen presence
```

Actual cause is not automatically available to this service.

---

# 17. Learning operations

```text
InterpretLearningEvidence(observation/outcome, Wilson context)
→ LearningProposalBatch
```

Batch may contain:

```text
BeliefEvidence[]
AssociationImpact[]
HabitEvidence[]
EpisodeCandidate[]
PresenceEvidence[]
```

Owner commands:

```text
ApplyBeliefEvidence
ApplyAssociationImpact
ApplyHabitEvidence
AdmitEpisodeCandidate
ApplyPresenceEvidence
```

Each owner validates bounds/saturation independently.

## 17.1 Knowledge discovery

When observed evidence satisfies a `DiscoverySpec`:

```text
ApplyBeliefEvidence
→ operational KnowledgeId becomes known
→ semantic interaction becomes available
```

No separate discovery lottery occurs.

---

# 18. Project operations

Queries:

```text
QueryEligibleProjectDefinitions(context)
QueryProjectContributions(project, world/context)
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

Invariants:

- project progress is accepted only from grounded `ActionOutcome`/world facts;
- Project System does not set Wilson's current intention;
- physical structures remain world authority;
- a resource is not globally reserved merely because a project could use it.

---

# 19. Director operations

Queries:

```text
QueryEligibleEvents(world/Wilson bounded context)
GetDirectorContext(active_event_instances)
```

Commands:

```text
ActivateEvent(definition, bindings)
AdvanceEvent(instance, semantic events/time)
ResolveEvent(instance)
ExpireEvent(instance)
```

Director may issue:

```text
WorldOpportunity
TemporaryOpportunity
BoundedSceneBias
```

but never `SetWilsonIntention` or psychology mutations.

---

# 20. Non-Wilson actor operations

```text
DeriveActorOptions(actor_state, local_world_context)
SelectActorActivity(options, RandomSource)
CommitActorActivity(actor_state, selection)
AdvanceActorActivity(actor_state, elapsed)
```

The actor model is deliberately shallow.

Recurring identity is persistence of the actor/entity, not evidence for a full belief/association/history stack per animal.

---

# 21. Suggestion operations

```text
IssueSuggestion(intention_pattern, bindings)
→ SuggestionSignal + updated SuggestionWindowState
```

Validation checks:

- supported suggestion grammar;
- context/participant visibility or availability rules;
- bounded insistence/cooldown.

The signal enters candidate generation/evaluation. It never commits an intention itself.

---

# 22. Player intervention transaction

```text
RequestIntervention(capability, target/bindings)
→ InterventionValidation
```

If valid:

```text
reserve/consume God Power
→ apply validated world mutation
→ confirm world commit
→ finalize cost
→ emit WorldEvent
```

Atomicity rule:

- accepted intervention and God Power mutation cannot diverge;
- failed world application must have deterministic refund/rollback semantics;
- Wilson psychology receives only perception/attribution evidence after the world event.

---

# 23. Luck-sensitive resolution

```text
EvaluateEffectiveLuck(LuckContext)
→ SignedUnit

SelectLuckSensitiveVariant(valid_variants, effective_luck, RandomSource)
→ selected variant
```

Invariants:

- variants are already physically/contextually valid;
- favorability is explicitly declared from Wilson's perspective;
- Luck cannot manufacture an event/action/result that was not eligible;
- selection occurs before authoritative commitment.

---

# 24. Death and resurrection lifecycle

## 24.1 Death

```text
Grounded body/world consequence
→ WilsonBodyState.alive = false
→ finish committed visual/semantic sequence
→ Run enters AWAITING_DEATH_CHOICE
```

Death is not a cognition command.

## 24.2 Resurrect

```text
ResurrectWilson(run_id)
```

Transaction:

1. preserve same RunId/world history;
2. restore/normalize authoritative body state;
3. clear current action/current fragile intention as required;
4. remove/inactivate explicit conscious death-source accessibility;
5. preserve admitted danger belief/association consequences;
6. continue run.

Free and unlimited.

---

# 25. End Run transaction

```text
EndRun(run_id, player_profile_id)
→ RunEnded
```

Required ordering:

1. freeze active run mutation;
2. calculate final structured run statistics/history;
3. construct/update `RunDiary` archive records;
4. project eligible operational Wilson knowledge;
5. perform deterministic weighted Legacy selection;
6. merge selected knowledge into PlayerProfile;
7. mark run permanently ended;
8. release active-run state after persistence/archival boundary succeeds.

Persistence stores the result but does not decide Legacy or Diary policy.

---

# 26. Start Run transaction

```text
StartRun(player_profile_id, seed)
→ RunBootstrap
```

Required ordering:

1. validate profile/global content references;
2. create deterministic world from seed;
3. create Wilson body/canonical cognition baseline;
4. merge Legacy Knowledge into initial operational knowledge;
5. create player run state;
6. initialize Director/projects/action state;
7. publish/bootstrap presentation only after valid domain state exists.

---

# 27. Offline catch-up operation

```text
CatchUpOffline(run, elapsed, policy)
→ CatchUpResult
```

Uses normal owner operations with conservative substitutions.

Must enforce:

```text
no Wilson death
no rare spectacle consumption by default
no major area reveal
no opaque extreme presence/relationship swing
```

Allowed ordinary changes must still have causal structured history sufficient for Diary/cognition where appropriate.

---

# 28. Aggregate invariants

## World

- every active `EntityInstance.type_id` resolves to a definition;
- world relation endpoints resolve within their permitted subject scope;
- mutually exclusive relations cannot coexist;
- transformed/destroyed entities cannot continue participating as active action subjects;
- physical properties remain finite/typed.

## Wilson body

- vitality/wetness/exertion remain bounded;
- body conditions use finite severity;
- `alive=false` only follows admitted grounded consequence/lifecycle operation;
- cognition cannot directly set body truth.

## Wilson cognition

- trait values remain bounded and normally stable;
- association valence/attachment remain bounded;
- belief confidence remains bounded;
- one current intention maximum;
- habit strength remains bounded;
- presence vector components remain bounded;
- no omniscient learning from unobserved world truth.

## Projects

- project lifecycle transitions are valid and monotonic where appropriate;
- world progress is not duplicated as authoritative project facts;
- completion derives from validated world/project conditions.

## Director

- active instances reference valid definitions;
- scene bias remains within declared envelopes;
- Director cannot mutate Wilson psychology/intention directly.

## Player run state

- God Power remains within cap/range;
- unsupported intervention capability cannot be purchased with extra GP;
- suggestion windows are bounded.

## Player profile

- Legacy contains only globally valid `legacy_eligible` knowledge IDs;
- archived run records are immutable except explicit migration/correction;
- active RunState is not embedded inside Diary archive.

---

# 29. Transition tables

## 29.1 Intention

| From | Event | To |
|---|---|---|
| none | selected intention committed | current |
| current | ordinary continuation | current |
| current | meaningful interruption, still relevant | suspended |
| current | completion | completed/removed |
| current | invalidated/abandoned | discarded |
| suspended | wins later competition | current |
| suspended | resolved/irrelevant/forgotten | removed |

## 29.2 Action execution

| From | Event | To |
|---|---|---|
| none | validated action starts | preparing |
| preparing | progress | preparing/checkpoint |
| preparing/checkpoint | interruption before commitment | interrupted |
| preparing/checkpoint | commitment reached | committed |
| committed | authoritative resolution | completed |
| committed | late reconsideration | **no rewind** |

## 29.3 Project

| From | Event | To |
|---|---|---|
| absent | project starts | active |
| active | Wilson stops working | active or paused (definition/lifecycle semantics) |
| active/paused | contribution | active/paused with updated grounded progress |
| active/paused | completion predicate | completed |
| active/paused | justified abandonment | abandoned |
| completed | ordinary runtime | completed |

## 29.4 Event

| From | Event | To |
|---|---|---|
| inactive | eligibility + selection | active |
| active | normal progression | active |
| active | success/failure resolution | resolved |
| active | opportunity window closes | expired |

## 29.5 Run

| From | Event | To |
|---|---|---|
| active | grounded Wilson death | awaiting_death_choice |
| awaiting_death_choice | resurrect | active |
| awaiting_death_choice | end run | ending → ended |
| ended | any active simulation command | **invalid** |

---

# 30. Orchestration-facing minimal loop

The application/game orchestrator can be expressed without implementation-specific APIs as:

```text
advance authoritative time
→ advance environment/body/current actions
→ collect WorldEvents
→ perceive relevant changes
→ detect immediate threat or normal reconsideration triggers
→ derive expectations/salience
→ generate/evaluate/select intention if needed
→ commit intentional transition
→ start/advance action
→ produce ActionOutcome / WorldEvents
→ derive/apply learning proposals
→ apply project/event reactions to grounded outcomes
→ maintenance/consolidation when scheduled
→ publish presentation/debug projection
```

Not every phase runs every frame/tick. `SIMULATION_ORCHESTRATION.md` owns cadence/order policy; these operations define the domain surface each phase may invoke.

---

# 31. Architectural anti-operations

The following operations should not exist as public domain capabilities:

```text
Director.force_wilson_action(...)
Project.set_current_wilson_action(...)
UI.move_entity_authoritatively(...)
FireSystem.increase_wilson_fear(...)
Persistence.fix_domain_state_arbitrarily(...)
Luck.make_action_succeed(...)
Suggestion.force_acceptance(...)
Presentation.on_animation_finished_commit_world_change(...)
```

If implementation appears to need one, first identify the missing semantic command/result boundary.

---

# 32. Operation-model gate

This operation model is sufficient for the next domain pass when:

- every state mutation enters through an owner command/lifecycle transaction;
- physical truth queries never silently consume Wilson belief;
- cognition queries never silently consume omniscient world truth;
- ActionOutcome is the physical/learning/project bridge;
- project/director/player influence remains proposal-based;
- lifecycle operations are explicit;
- deterministic RNG consumption is attributable;
- representative scene regression can be traced using these operations without scene-specific authority bypasses.

The next validation step is to enrich `DOMAIN_REGRESSION.md` with representative **operation traces** for the most integration-heavy scenes: Scientific Method, Sabotaged Storage, Storm Priorities, Signal Fire, Falling Palm, Brilliant Shortcut, and The Experiment.