extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const ContentRegistry = preload("res://src/domain/content/content_registry.gd")
const EntityDefinition = preload("res://src/domain/content/entity_definition.gd")
const EntityInstance = preload("res://src/domain/world/entity_instance.gd")
const EntityStore = preload("res://src/domain/world/entity_store.gd")
const WorldRelationStore = preload("res://src/domain/world/world_relation_store.gd")
const DefaultWorldQuery = preload("res://src/domain/world/default_world_query.gd")
const DefaultWorldCommandPort = preload("res://src/domain/world/default_world_command_port.gd")
const PropertyDependencyGraph = preload("res://src/domain/physical/property_dependency_graph.gd")
const EffectivePhysicalProfileResolver = preload("res://src/domain/physical/effective_physical_profile_resolver.gd")
const RequirementPredicate = preload("res://src/domain/actions/requirement_predicate.gd")
const RequirementPredicateEvaluator = preload("res://src/domain/actions/requirement_predicate_evaluator.gd")
const ActionDefinition = preload("res://src/domain/actions/action_definition.gd")
const ActionAttemptabilityService = preload("res://src/domain/actions/action_attemptability_service.gd")
const ActionExecutionService = preload("res://src/domain/actions/action_execution_service.gd")
const ActionResolutionDefinition = preload("res://src/domain/actions/action_resolution_definition.gd")
const ActionEffect = preload("res://src/domain/actions/action_effect.gd")
const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const EpistemicClaim = preload("res://src/domain/cognition/epistemic_claim.gd")
const PerceptionAccess = preload("res://src/domain/cognition/perception_access.gd")
const PerceptionService = preload("res://src/domain/cognition/perception_service.gd")
const BeliefLearningService = preload("res://src/domain/cognition/belief_learning_service.gd")
const BeliefStore = preload("res://src/domain/cognition/belief_store.gd")
const CurrentIntentionStore = preload("res://src/domain/cognition/current_intention_store.gd")
const PerceivedOpportunityDefinition = preload("res://src/domain/cognition/perceived_opportunity_definition.gd")
const PerceivedOpportunityService = preload("res://src/domain/cognition/perceived_opportunity_service.gd")
const DecisionCandidate = preload("res://src/domain/cognition/decision_candidate.gd")
const DecisionRouter = preload("res://src/domain/cognition/decision_router.gd")
const BeliefLearningCoordinator = preload("res://src/application/simulation/belief_learning_coordinator.gd")
const DecisionCommitCoordinator = preload("res://src/application/simulation/decision_commit_coordinator.gd")
const DerivedStateInvalidator = preload("res://src/application/simulation/derived_state_invalidator.gd")
const SimulationOrchestrator = preload("res://src/application/simulation/simulation_orchestrator.gd")
const SimulationStepContext = preload("res://src/application/simulation/simulation_step_context.gd")
const StaticWorldAdvance = preload("res://tests/headless/fixtures/static_world_advance.gd")
const StaticActivityQuery = preload("res://tests/headless/fixtures/static_activity_query.gd")
const StaticPerceptionAccessResolver = preload("res://tests/headless/fixtures/static_perception_access_resolver.gd")
const InMemoryTraceSink = preload("res://tests/headless/fixtures/in_memory_trace_sink.gd")

var _failures: Array[String] = []
var _completed := false

func _init() -> void:
	_run_slice()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS simulation_micro_loop_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL simulation_micro_loop_test: %d failure(s)" % _failures.size())
	quit(1)

func _run_slice() -> void:
	var crate_type = DomainId.entity_type(&"crate")
	var integrity = DomainId.property(&"structural_integrity")
	var camp = DomainId.place(&"camp")
	var content = ContentRegistry.new()
	var register_result = content.register_entity_definition(EntityDefinition.new(crate_type, [], {integrity.key(): 5}, []))
	_expect_true(register_result != null and register_result.ok, "crate definition registers")
	var seal_result = content.seal()
	_expect_true(seal_result != null and seal_result.ok, "content seals")

	var crate_id = DomainId.entity(&"crate_4")
	var entities = EntityStore.new()
	var add_result = entities.add_entity(EntityInstance.new(crate_id, crate_type, camp))
	_expect_true(add_result != null and add_result.ok, "crate instance added")
	var crate = RuntimeWorldRef.entity(crate_id)
	var wilson = RuntimeWorldRef.wilson()
	var relations = WorldRelationStore.new()
	var world_query = DefaultWorldQuery.new(entities, relations, content)

	var graph = PropertyDependencyGraph.new()
	var graph_result = graph.compile([])
	_expect_true(graph_result != null and graph_result.ok, "empty property graph compiles")
	var profiles = EffectivePhysicalProfileResolver.new(world_query, graph)
	var derived_invalidator = DerivedStateInvalidator.new(profiles)
	var evaluator = RequirementPredicateEvaluator.new(world_query, profiles)
	var attemptability = ActionAttemptabilityService.new(evaluator)
	var execution = ActionExecutionService.new(attemptability)

	var action_id = DomainId.action(&"hit")
	var requirements = RequirementPredicate.all_of([])
	var action = ActionDefinition.new(action_id, [&"actor", &"target"], requirements)
	var bindings = RoleBinding.new()
	bindings.bind(&"actor", wilson)
	bindings.bind(&"target", crate)
	var impact_committed = DomainId.event_definition(&"impact_committed")
	var resolution = ActionResolutionDefinition.new(action_id, 1.0, 0.5, [ActionEffect.new(ActionEffect.Kind.SET_PROPERTY, &"target", integrity, 2)], impact_committed)
	var execution_id: StringName = &"exec_micro_1"
	var started = execution.start(execution_id, action, resolution, bindings)
	_expect_true(started != null, "action execution starts")

	var world_commands = DefaultWorldCommandPort.new(entities, relations)
	var access = PerceptionAccess.new(true, [&"vision"], [&"target"], 0.8)
	var access_map: Dictionary = {}
	access_map[execution_id] = access
	var access_resolver = StaticPerceptionAccessResolver.new(access_map)
	var perception = PerceptionService.new()
	var belief_store = BeliefStore.new()
	var learning = BeliefLearningCoordinator.new(BeliefLearningService.new(), belief_store)
	var opportunity_service = PerceivedOpportunityService.new()
	var investigate = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"investigate_recent_impact")
	var opportunity_definitions = [
		PerceivedOpportunityDefinition.new(
			EpistemicClaim.Kind.EVENT,
			impact_committed,
			investigate,
			DecisionCandidate.Scope.INTENTIONAL,
			0.4,
			&"target"
		)
	]
	var router = DecisionRouter.new()
	var intention_store = CurrentIntentionStore.new()
	var decision_commit = DecisionCommitCoordinator.new(intention_store)
	var activity = StaticActivityQuery.new(execution_id, null)
	var trace_sink = InMemoryTraceSink.new()
	var orchestrator = SimulationOrchestrator.new(
		StaticWorldAdvance.new(), execution, world_commands, derived_invalidator,
		activity, access_resolver, perception, learning, opportunity_service,
		belief_store, opportunity_definitions, router, decision_commit, trace_sink
	)

	var step = SimulationStepContext.new(&"step_1", 0.5, 10.0, null, [])
	var result = orchestrator.advance(step)
	_expect_true(result != null, "orchestrator returns result")
	if result == null:
		return

	_expect_true(result.action_progress != null and result.action_progress.committed, "action crosses commit checkpoint")
	_expect_true(result.world_commit != null and result.world_commit.ok, "outcome commits through World owner")
	_expect_equal(world_query.get_instance_property(crate, integrity), 2, "World mutation is visible after commit")
	_expect_equal(result.world_commit.events.size(), 1, "World commit emits one event")
	_expect_equal(result.world_commit.change_set.changes.size(), 1, "World commit reports one semantic change")
	_expect_equal(result.perception.observed_events.size(), 1, "committed event becomes observed event")
	_expect_equal(result.perception.evidence.size(), 1, "observation produces perceptual evidence")
	_expect_equal(result.perception.evidence[0].claim.kind, EpistemicClaim.Kind.EVENT, "perception carries typed event claim")
	var learning_evidence: Array = result.immediate_learning.get("derived_evidence", [])
	_expect_equal(learning_evidence.size(), 1, "perceptual evidence becomes belief evidence")
	_expect_equal(belief_store.entries().size(), 1, "belief owner stores learned proposition")
	_expect_equal(result.candidates.size(), 1, "learned/perceived opportunity becomes candidate")
	_expect_true(result.decision.selected_candidate != null, "decision router selects candidate")
	if result.decision.selected_candidate != null:
		_expect_equal(result.decision.selected_candidate.intention_id.key(), investigate.key(), "selected intention matches perceived opportunity")
		_expect_equal(String(result.decision.regime), "intentional", "decision uses intentional regime")
	_expect_true(result.intention_commit != null and result.intention_commit.ok, "selected intention commits through cognition owner")
	_expect_true(intention_store.has_current(), "current intention becomes durable state")
	_expect_equal(trace_sink.traces.size(), 1, "one semantic trace recorded")
	if trace_sink.traces.size() == 1:
		var trace = trace_sink.traces[0]
		_expect_true(trace.stage_results.has(&"world_commit"), "trace records World commit")
		_expect_true(trace.stage_results.has(&"derived_invalidation"), "trace records derived invalidation")
		_expect_true(trace.stage_results.has(&"perception"), "trace records perception")
		_expect_true(trace.stage_results.has(&"immediate_learning"), "trace records learning")
		_expect_true(trace.stage_results.has(&"decision_candidates"), "trace records candidates")
		_expect_true(trace.stage_results.has(&"decision"), "trace records decision")
		_expect_true(trace.stage_results.has(&"intention_commit"), "trace records intention commit")

	_completed = true

func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)

func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
