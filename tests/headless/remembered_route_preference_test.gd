extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const AssociationStore = preload("res://src/domain/cognition/association_store.gd")
const RememberedRouteOption = preload("res://src/application/simulation/remembered_route_option.gd")
const RememberedRoutePreferenceService = preload("res://src/application/simulation/remembered_route_preference_service.gd")

var _failures: Array[String] = []


class FakeSpatialQuery:
	extends RefCounted
	var costs: Dictionary = {}

	func set_cost(from_ref, to_ref, cost: float) -> void:
		costs[_key(from_ref, to_ref)] = cost

	func has_route(from_ref, to_ref) -> bool:
		return costs.has(_key(from_ref, to_ref)) and is_finite(float(costs[_key(from_ref, to_ref)]))

	func route_cost(from_ref, to_ref) -> float:
		return float(costs.get(_key(from_ref, to_ref), INF))

	func _key(from_ref, to_ref) -> String:
		return "%s>%s" % [String(from_ref.key()), String(to_ref.key())]


func _init() -> void:
	_run()
	if _failures.is_empty():
		print("PASS remembered_route_preference_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL remembered_route_preference_test: %d failure(s)" % _failures.size())
	quit(1)


func _run() -> void:
	var wilson = RuntimeWorldRef.wilson()
	var short_gate = RuntimeWorldRef.place(DomainId.place(&"short_gate"))
	var long_gate = RuntimeWorldRef.place(DomainId.place(&"long_gate"))
	var destination = RuntimeWorldRef.place(DomainId.place(&"fresh_water"))
	var burned_ground = DomainId.place(&"burned_ground")

	var spatial = FakeSpatialQuery.new()
	spatial.set_cost(wilson, short_gate, 3.0)
	spatial.set_cost(short_gate, destination, 3.0)
	spatial.set_cost(wilson, long_gate, 5.0)
	spatial.set_cost(long_gate, destination, 4.0)

	var short_route = RememberedRouteOption.new(&"short", [short_gate, destination], [burned_ground])
	var long_route = RememberedRouteOption.new(&"long", [long_gate, destination])
	var associations = AssociationStore.new()
	var service = RememberedRoutePreferenceService.new(spatial, associations, 1.0)

	_expect_same(service.choose(wilson, [long_route, short_route]), short_route, "without remembered danger Wilson prefers physically shorter route")

	associations.restore_entry(burned_ground, -0.8, 0.0, 3, &"burn_event")
	_expect_same(service.choose(wilson, [short_route, long_route]), long_route, "strong remembered aversion makes Wilson take the long way around")
	var short_eval = service.evaluate(wilson, short_route)
	_expect_equal(float(short_eval.physical_cost), 6.0, "short route keeps physical cost separate")
	_expect_equal(float(short_eval.aversion), 0.8, "route evaluation reads Wilson-relative remembered aversion")
	_expect_true(float(short_eval.adjusted_cost) > 9.0, "remembered aversion raises desirability cost without changing physical truth")

	associations.restore_entry(burned_ground, -0.2, 0.0, 4, &"later_safe_passage")
	_expect_same(service.choose(wilson, [long_route, short_route]), short_route, "weaker aversion no longer overwhelms meaningful route efficiency")

	spatial.costs.erase("%s>%s" % [String(long_gate.key()), String(destination.key())])
	associations.restore_entry(burned_ground, -1.0, 0.0, 5, &"renewed_fear")
	_expect_same(service.choose(wilson, [long_route, short_route]), short_route, "memory cannot select a physically impossible alternative")

	var tie_a = RememberedRouteOption.new(&"a", [short_gate, destination])
	var tie_b = RememberedRouteOption.new(&"b", [short_gate, destination])
	_expect_same(service.choose(wilson, [tie_b, tie_a]), tie_a, "stable semantic key breaks exact route ties independently of insertion order")


func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)


func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])


func _expect_same(actual, expected, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected same route option" % label)
