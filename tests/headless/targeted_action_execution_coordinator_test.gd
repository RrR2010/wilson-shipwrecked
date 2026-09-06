extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const RequirementPredicate = preload("res://src/domain/actions/requirement_predicate.gd")
const ActionDefinition = preload("res://src/domain/actions/action_definition.gd")
const ActionResolutionDefinition = preload("res://src/domain/actions/action_resolution_definition.gd")
const CurrentIntentionState = preload("res://src/domain/cognition/current_intention_state.gd")
const MotionPort = preload("res://src/application/simulation/motion_port.gd")
const TargetedActionExecutionCoordinator = preload("res://src/application/simulation/targeted_action_execution_coordinator.gd")

var _failures: Array[String] = []
var _completed := false


class MotionStub:
	extends RefCounted
	var status: int = MotionPort.MotionStatus.IDLE
	var target = null
	var request_count := 0
	var cancel_count := 0

	func request_move(_actor_ref, target_ref) -> bool:
		request_count += 1
		target = target_ref
		status = MotionPort.MotionStatus.MOVING
		return true

	func cancel_move(_actor_ref) -> void:
		cancel_count += 1
		target = null
		status = MotionPort.MotionStatus.CANCELLED

	func get_status(_actor_ref) -> int:
		return status

	func get_target(_actor_ref):
		return target


class StartedState:
	extends RefCounted
	var execution_id: StringName
	var bindings

	func _init(p_execution_id: StringName, p_bindings) -> void:
		execution_id = p_execution_id
		bindings = p_bindings


class ActionExecutionStub:
	extends RefCounted
	var states: Dictionary = {}
	var start_count := 0

	func get_state(execution_id: StringName):
		return states.get(execution_id)

	func start(execution_id: StringName, _action_definition, _resolution_definition, bindings):
		if states.has(execution_id):
			return null
		start_count += 1
		var state = StartedState.new(execution_id, bindings.duplicate_binding())
		states[execution_id] = state
		return state


func _init() -> void:
	_run_slice()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS targeted_action_execution_coordinator_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL targeted_action_execution_coordinator_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	var seek_food = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"seek_food")
	var consume = DomainId.action(&"consume")
	var consumed = DomainId.event_definition(&"food_consumed")
	var action = ActionDefinition.new(
		consume,
		[&"actor", &"target"],
		RequirementPredicate.all_of([])
	)
	var resolution = ActionResolutionDefinition.new(consume, 1.0, 0.5, [], consumed, &"consume_default")
	var wilson = RuntimeWorldRef.wilson()
	var food = RuntimeWorldRef.entity(DomainId.entity(&"food_1"))
	var other_food = RuntimeWorldRef.entity(DomainId.entity(&"food_2"))
	var intention_bindings = RoleBinding.new()
	intention_bindings.bind(&"target", food)
	var intention = CurrentIntentionState.new(seek_food, intention_bindings, &"selection_7")

	var motion = MotionStub.new()
	var execution = ActionExecutionStub.new()
	var coordinator = TargetedActionExecutionCoordinator.new(
		motion,
		execution,
		wilson,
		seek_food,
		action,
		resolution
	)

	var applied = coordinator.apply(intention)
	_expect_equal(applied.reason, &"move_requested", "committed target intention requests motion")
	_expect_equal(motion.request_count, 1, "motion request occurs once")
	_expect_true(motion.target != null and motion.target.equals(food), "motion request preserves semantic target")
	_expect_equal(execution.start_count, 0, "action does not start before arrival")

	var moving = coordinator.advance(intention)
	_expect_equal(moving.reason, &"awaiting_arrival", "moving intention waits for arrival")
	_expect_equal(execution.start_count, 0, "waiting does not start action")

	motion.status = MotionPort.MotionStatus.ARRIVED
	motion.target = other_food
	var wrong_arrival = coordinator.advance(intention)
	_expect_equal(wrong_arrival.reason, &"arrival_target_mismatch", "arrival at another target cannot ground action start")
	_expect_equal(execution.start_count, 0, "wrong target arrival does not start action")

	motion.target = food
	var arrived = coordinator.advance(intention)
	_expect_true(arrived.started, "matching arrival starts authored action")
	_expect_equal(arrived.reason, &"action_started", "matching arrival reports action start")
	_expect_equal(arrived.execution_id, &"intention_selection_7_action_consume", "execution identity derives deterministically from intention selection and action")
	_expect_equal(execution.start_count, 1, "action starts exactly once")
	var state = execution.get_state(arrived.execution_id)
	_expect_true(state != null, "started action is owned by ActionExecution")
	if state != null:
		_expect_true(state.bindings.get_subject(&"target").equals(food), "action keeps intention target binding")
		_expect_true(state.bindings.get_subject(&"actor").equals(wilson), "coordinator contributes Wilson actor binding")

	var duplicate = coordinator.advance(intention)
	_expect_false(duplicate.started, "repeated arrival does not duplicate action")
	_expect_equal(duplicate.reason, &"action_already_started", "existing deterministic execution suppresses duplicate start")
	_expect_equal(execution.start_count, 1, "duplicate delivery remains idempotent")

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
