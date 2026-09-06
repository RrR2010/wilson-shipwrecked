extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const ContentRegistry = preload("res://src/domain/content/content_registry.gd")
const EventDefinition = preload("res://src/domain/content/event_definition.gd")
const EntityStore = preload("res://src/domain/world/entity_store.gd")
const WorldRelationStore = preload("res://src/domain/world/world_relation_store.gd")
const DefaultWorldQuery = preload("res://src/domain/world/default_world_query.gd")
const PropertyDependencyGraph = preload("res://src/domain/physical/property_dependency_graph.gd")
const PhysicalDerivationPolicyRegistry = preload("res://src/domain/physical/physical_derivation_policy_registry.gd")
const EffectivePhysicalProfileResolver = preload("res://src/domain/physical/effective_physical_profile_resolver.gd")
const RequirementPredicate = preload("res://src/domain/actions/requirement_predicate.gd")
const RequirementPredicateEvaluator = preload("res://src/domain/actions/requirement_predicate_evaluator.gd")
const ActionDefinition = preload("res://src/domain/actions/action_definition.gd")
const ActionAttemptabilityService = preload("res://src/domain/actions/action_attemptability_service.gd")
const ActionExecutionService = preload("res://src/domain/actions/action_execution_service.gd")
const ActionResolutionDefinition = preload("res://src/domain/actions/action_resolution_definition.gd")
const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const CurrentIntentionState = preload("res://src/domain/cognition/current_intention_state.gd")
const MotionPort = preload("res://src/application/simulation/motion_port.gd")
const TargetedActionExecutionCoordinator = preload("res://src/application/simulation/targeted_action_execution_coordinator.gd")
const ActionExecutionSnapshotService = preload("res://src/infrastructure/persistence/action_execution_snapshot_service.gd")

var _failures: Array[String] = []
var _completed := false


class ArrivedMotionStub:
	extends RefCounted
	var target
	func _init(p_target) -> void:
		target = p_target
	func request_move(_actor_ref, target_ref) -> bool:
		target = target_ref
		return true
	func cancel_move(_actor_ref) -> void:
		pass
	func get_status(_actor_ref) -> int:
		return MotionPort.MotionStatus.ARRIVED
	func get_target(_actor_ref):
		return target


func _init() -> void:
	_run_slice()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS targeted_action_reconstruction_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL targeted_action_reconstruction_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	var seek_food = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"seek_food")
	var consume_id = DomainId.action(&"consume_food")
	var consumed_event = DomainId.event_definition(&"food_consumed")
	var action = ActionDefinition.new(consume_id, [&"actor", &"target"], RequirementPredicate.all_of([]))
	var resolution = ActionResolutionDefinition.new(consume_id, 1.0, 0.5, [], consumed_event, &"consume_food_default")

	var content = ContentRegistry.new()
	_expect_true(content.register_event_definition(EventDefinition.new(consumed_event, [&"actor", &"target"], [&"vision"])).ok, "event definition registers")
	_expect_true(content.register_action_definition(action).ok, "action definition registers")
	_expect_true(content.register_action_resolution_definition(resolution).ok, "resolution definition registers")
	_expect_true(content.seal().ok, "content seals")

	var world_query = DefaultWorldQuery.new(EntityStore.new(), WorldRelationStore.new(), content)
	var policies = PhysicalDerivationPolicyRegistry.new()
	var graph = PropertyDependencyGraph.new()
	_expect_true(graph.compile([], policies).ok, "empty property graph compiles")
	var profiles = EffectivePhysicalProfileResolver.new(world_query, graph, policies)
	var evaluator = RequirementPredicateEvaluator.new(world_query, profiles)
	var execution = ActionExecutionService.new(ActionAttemptabilityService.new(evaluator))

	var wilson = RuntimeWorldRef.wilson()
	var food = RuntimeWorldRef.entity(DomainId.entity(&"food_1"))
	var intention_bindings = RoleBinding.new()
	intention_bindings.bind(&"target", food)
	var intention = CurrentIntentionState.new(seek_food, intention_bindings, &"selection_7")
	var execution_id := &"intention_selection_7_action_consume_food"

	var action_bindings = intention_bindings.duplicate_binding()
	action_bindings.bind(&"actor", wilson)
	_expect_true(execution.start(execution_id, action, resolution, action_bindings) != null, "targeted consume execution starts")
	var committed = execution.advance(execution_id, 0.5)
	_expect_true(committed.committed, "consume crosses commit before snapshot")
	_expect_true(committed.new_outcome != null, "original execution emits grounded outcome once")

	var persistence = ActionExecutionSnapshotService.new()
	var snapshot = persistence.capture(execution)
	var restored = ActionExecutionService.new(ActionAttemptabilityService.new(evaluator))
	var restore_results = persistence.restore(snapshot, restored, content)
	_expect_equal(restore_results.size(), 1, "one targeted execution restores")
	_expect_true(restore_results[0].ok, "targeted execution restore succeeds")

	var restored_state = restored.get_state(execution_id)
	_expect_true(restored_state != null, "deterministic targeted execution identity survives restore")
	if restored_state != null:
		_expect_true(restored_state.committed and restored_state.outcome_emitted, "commit and outcome emission markers survive restore")

	var coordinator = TargetedActionExecutionCoordinator.new(
		ArrivedMotionStub.new(food),
		restored,
		wilson,
		seek_food,
		action,
		resolution
	)
	var resumed = coordinator.advance(intention)
	_expect_false(resumed.started, "restored arrival does not start a duplicate consume action")
	_expect_equal(resumed.reason, &"action_already_started", "coordinator recognizes restored deterministic execution")
	_expect_equal(resumed.execution_id, execution_id, "coordinator resolves the same execution id after restore")

	var completion = restored.advance(execution_id, 0.5)
	_expect_true(completion.completed, "restored committed consume can finish")
	_expect_true(completion.new_outcome == null, "restored committed consume never re-emits outcome")

	_completed = true


func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)


func _expect_false(actual: bool, label: String) -> void:
	if actual:
		_failures.append("Expected false: %s" % label)


func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
