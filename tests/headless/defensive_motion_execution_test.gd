extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const CurrentIntentionState = preload("res://src/domain/cognition/current_intention_state.gd")
const MotionPort = preload("res://src/application/simulation/motion_port.gd")
const EscapeDestinationResolver = preload("res://src/application/simulation/escape_destination_resolver.gd")
const DefensiveMotionExecutionCoordinator = preload("res://src/application/simulation/defensive_motion_execution_coordinator.gd")
const FakeMotionPort = preload("res://tests/fakes/fake_motion_port.gd")
const FakeSpatialQueryPort = preload("res://tests/fakes/fake_spatial_query_port.gd")

var _failures: Array[String] = []
var _completed := false


func _init() -> void:
	_run_slice()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS defensive_motion_execution_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL defensive_motion_execution_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	var wilson := RuntimeWorldRef.wilson()
	var threat := RuntimeWorldRef.entity(DomainId.entity(&"falling_palm"))
	var original_target := RuntimeWorldRef.entity(DomainId.entity(&"foraging_target"))
	var escape_a := RuntimeWorldRef.entity(DomainId.entity(&"escape_a"))
	var escape_b := RuntimeWorldRef.entity(DomainId.entity(&"escape_b"))
	var blocked_far := RuntimeWorldRef.entity(DomainId.entity(&"blocked_far"))
	var insufficient_gain := RuntimeWorldRef.entity(DomainId.entity(&"insufficient_gain"))
	var dodge = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"dodge_threat")
	var forage = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"forage")

	var spatial = FakeSpatialQueryPort.new()
	spatial.set_distance(wilson, threat, 3.0)
	spatial.set_route(wilson, escape_a, true, 5.0)
	spatial.set_distance(escape_a, threat, 7.0)
	spatial.set_route(wilson, escape_b, true, 3.0)
	spatial.set_distance(escape_b, threat, 7.0)
	spatial.set_route(wilson, blocked_far, false, 1.0)
	spatial.set_distance(blocked_far, threat, 12.0)
	spatial.set_route(wilson, insufficient_gain, true, 1.0)
	spatial.set_distance(insufficient_gain, threat, 3.1)

	var resolver = EscapeDestinationResolver.new(
		spatial,
		[escape_a, blocked_far, insufficient_gain, escape_b],
		0.25
	)
	_expect_ref(resolver.resolve(wilson, threat), escape_b, "equal safety prefers lower route cost")

	var motion = FakeMotionPort.new()
	_expect_true(motion.request_move(wilson, original_target), "original movement starts")
	_expect_equal(motion.get_status(wilson), MotionPort.MotionStatus.MOVING, "original movement is active")

	var coordinator = DefensiveMotionExecutionCoordinator.new(motion, resolver, wilson, [dodge])
	var threat_bindings = RoleBinding.new()
	threat_bindings.bind(&"threat_source", threat)
	var dodge_state = CurrentIntentionState.new(dodge, threat_bindings, &"threat_step")
	var execution: Dictionary = coordinator.apply(dodge_state)
	_expect_true(bool(execution.redirected), "defensive intention redirects movement")
	_expect_equal(StringName(execution.reason), &"redirected", "redirection reports semantic reason")
	_expect_ref(execution.target_ref, escape_b, "redirection uses deterministic escape destination")
	_expect_equal(motion.cancel_history.size(), 1, "active movement is cancelled exactly once before redirect")
	_expect_equal(motion.request_history.size(), 2, "redirect issues one replacement movement request")
	_expect_ref(motion.get_target(wilson), escape_b, "replacement target becomes current motion target")
	_expect_equal(motion.get_status(wilson), MotionPort.MotionStatus.MOVING, "replacement move returns to MOVING")

	var ordinary_bindings = RoleBinding.new()
	ordinary_bindings.bind(&"target", original_target)
	var ordinary_state = CurrentIntentionState.new(forage, ordinary_bindings, &"ordinary_step")
	var ordinary_execution: Dictionary = coordinator.apply(ordinary_state)
	_expect_true(not bool(ordinary_execution.handled), "ordinary intention is ignored by defensive executor")
	_expect_equal(motion.cancel_history.size(), 1, "ordinary intention does not cancel movement")
	_expect_ref(motion.get_target(wilson), escape_b, "ordinary intention preserves active escape target")

	var no_route_spatial = FakeSpatialQueryPort.new()
	no_route_spatial.set_distance(wilson, threat, 3.0)
	no_route_spatial.set_route(wilson, escape_a, false, INF)
	no_route_spatial.set_distance(escape_a, threat, 9.0)
	var no_route_coordinator = DefensiveMotionExecutionCoordinator.new(
		motion,
		EscapeDestinationResolver.new(no_route_spatial, [escape_a]),
		wilson,
		[dodge]
	)
	var before_cancel_count: int = motion.cancel_history.size()
	var no_route_execution: Dictionary = no_route_coordinator.apply(dodge_state)
	_expect_true(bool(no_route_execution.handled) and not bool(no_route_execution.redirected), "defensive intention can be handled without fabricating an unavailable route")
	_expect_equal(StringName(no_route_execution.reason), &"no_escape_destination", "missing route is explicit")
	_expect_equal(motion.cancel_history.size(), before_cancel_count, "existing movement is not cancelled when no escape route exists")

	_completed = true


func _expect_true(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _expect_equal(actual: Variant, expected: Variant, message: String) -> void:
	if actual != expected:
		_failures.append("%s (expected=%s actual=%s)" % [message, expected, actual])


func _expect_ref(actual, expected, message: String) -> void:
	if actual == null or expected == null or not actual.equals(expected):
		_failures.append("%s (expected=%s actual=%s)" % [message, expected, actual])
