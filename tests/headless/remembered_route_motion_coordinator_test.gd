extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const AssociationStore = preload("res://src/domain/cognition/association_store.gd")
const AssociationImpact = preload("res://src/domain/cognition/association_impact.gd")
const RememberedRouteOption = preload("res://src/application/simulation/remembered_route_option.gd")
const RememberedRoutePreferenceService = preload("res://src/application/simulation/remembered_route_preference_service.gd")
const RememberedRouteMotionCoordinator = preload("res://src/application/simulation/remembered_route_motion_coordinator.gd")
const MotionPort = preload("res://src/application/simulation/motion_port.gd")

var _failures: Array[String] = []


class FakeSpatialQuery:
	extends RefCounted
	var costs: Dictionary = {}

	func has_route(from_ref, to_ref) -> bool:
		return costs.has(_key(from_ref, to_ref))

	func route_cost(from_ref, to_ref) -> float:
		return float(costs.get(_key(from_ref, to_ref), INF))

	func _key(from_ref, to_ref) -> String:
		return "%s>%s" % [String(from_ref.key()), String(to_ref.key())]


class FakeMotion:
	extends MotionPort
	var status := MotionPort.MotionStatus.IDLE
	var target
	var requests: Array = []
	var cancellations := 0

	func request_move(_actor_ref: RuntimeWorldRef, target_ref: RuntimeWorldRef) -> bool:
		target = target_ref
		status = MotionPort.MotionStatus.MOVING
		requests.append(target_ref)
		return true

	func cancel_move(_actor_ref: RuntimeWorldRef) -> void:
		cancellations += 1
		status = MotionPort.MotionStatus.CANCELLED

	func get_status(_actor_ref: RuntimeWorldRef) -> int:
		return status

	func get_target(_actor_ref: RuntimeWorldRef) -> RuntimeWorldRef:
		return target


func _init() -> void:
	_run_test()
	if _failures.is_empty():
		print("PASS remembered_route_motion_coordinator_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL remembered_route_motion_coordinator_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_test() -> void:
	var actor = RuntimeWorldRef.entity(DomainId.entity(&"wilson"))
	var short_mid = RuntimeWorldRef.place(DomainId.place(&"short_mid"))
	var long_mid = RuntimeWorldRef.place(DomainId.place(&"long_mid"))
	var goal = RuntimeWorldRef.place(DomainId.place(&"goal"))
	var danger = DomainId.place(&"danger_pass")

	var spatial = FakeSpatialQuery.new()
	spatial.costs["%s>%s" % [String(actor.key()), String(short_mid.key())]] = 2.0
	spatial.costs["%s>%s" % [String(short_mid.key()), String(goal.key())]] = 2.0
	spatial.costs["%s>%s" % [String(actor.key()), String(long_mid.key())]] = 3.0
	spatial.costs["%s>%s" % [String(long_mid.key()), String(goal.key())]] = 3.0

	var associations = AssociationStore.new()
	associations.apply_impact(AssociationImpact.new(danger, -1.0, 0.0, 1.0, &"route_accident"))
	var preference = RememberedRoutePreferenceService.new(spatial, associations, 1.0)
	var short_route = RememberedRouteOption.new(&"short", [short_mid, goal], [danger])
	var long_route = RememberedRouteOption.new(&"long", [long_mid, goal])
	var motion = FakeMotion.new()
	var coordinator = RememberedRouteMotionCoordinator.new(motion, preference, actor)

	var started = coordinator.apply([short_route, long_route])
	_expect_equal(started.reason, &"move_requested", "preferred route starts through MotionPort")
	_expect_true(started.route == long_route, "remembered aversion selects long route")
	_expect_true(motion.target.equals(long_mid), "first long-route waypoint is requested")

	var repeated = coordinator.apply([short_route, long_route])
	_expect_equal(repeated.reason, &"already_moving", "coordinator does not restart current waypoint")
	_expect_equal(motion.requests.size(), 1, "already-moving route does not duplicate request")

	motion.status = MotionPort.MotionStatus.ARRIVED
	var advanced = coordinator.apply([short_route, long_route])
	_expect_equal(advanced.reason, &"move_requested", "arrival advances to next route waypoint")
	_expect_true(motion.target.equals(goal), "route progresses to final goal")
	_expect_equal(motion.requests.size(), 2, "next waypoint requested exactly once")

	motion.status = MotionPort.MotionStatus.ARRIVED
	var complete = coordinator.apply([short_route, long_route])
	_expect_equal(complete.reason, &"route_complete", "final arrival completes route")
	_expect_equal(motion.requests.size(), 2, "route completion emits no extra move request")

	motion.status = MotionPort.MotionStatus.MOVING
	motion.target = short_mid
	var redirected = coordinator.apply([short_route, long_route])
	_expect_equal(redirected.reason, &"move_requested", "movement on non-preferred route is redirected")
	_expect_equal(motion.cancellations, 1, "non-preferred movement is cancelled once")
	_expect_true(motion.target.equals(long_mid), "redirection targets preferred route first waypoint")


func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)


func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
