extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const WorldEvent = preload("res://src/domain/actions/world_event.gd")
const PerceptionAccess = preload("res://src/domain/cognition/perception_access.gd")
const PerceptionService = preload("res://src/domain/cognition/perception_service.gd")
const ExperienceLearningRule = preload("res://src/domain/cognition/experience_learning_rule.gd")
const ExperienceLearningService = preload("res://src/domain/cognition/experience_learning_service.gd")
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
		print("PASS post_accident_learning_behavior_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL post_accident_learning_behavior_test: %d failure(s)" % _failures.size())
	quit(1)


func _run() -> void:
	var wilson = RuntimeWorldRef.wilson()
	var palm = RuntimeWorldRef.entity(DomainId.entity(&"falling_palm_17"))
	var short_gate = RuntimeWorldRef.place(DomainId.place(&"palm_short_gate"))
	var long_gate = RuntimeWorldRef.place(DomainId.place(&"palm_long_gate"))
	var destination = RuntimeWorldRef.place(DomainId.place(&"fresh_water"))

	var spatial = FakeSpatialQuery.new()
	spatial.set_cost(wilson, short_gate, 3.0)
	spatial.set_cost(short_gate, destination, 3.0)
	spatial.set_cost(wilson, long_gate, 5.0)
	spatial.set_cost(long_gate, destination, 4.0)

	var short_route = RememberedRouteOption.new(&"under_palm", [short_gate, destination], [palm])
	var long_route = RememberedRouteOption.new(&"around_palm", [long_gate, destination])
	var associations = AssociationStore.new()
	var preference = RememberedRoutePreferenceService.new(spatial, associations, 1.0)

	_expect_same(preference.choose(wilson, [long_route, short_route]), short_route, "before the accident Wilson prefers the physically shorter route")

	var injury_event_type = DomainId.event_definition(&"wilson_injured_by_impact")
	var bindings = RoleBinding.new()
	bindings.bind(&"subject", wilson)
	bindings.bind(&"other", palm)
	var injury_event = WorldEvent.new(injury_event_type, null, bindings, &"accident_1")

	var perception = PerceptionService.new().perceive(
		[injury_event],
		{
			&"accident_1": PerceptionAccess.new(
				true,
				[&"pain"],
				[&"subject", &"other"],
				1.0
			)
		}
	)
	_expect_equal(perception.observed_events.size(), 1, "accessible injury becomes an observed event")
	_expect_equal(perception.evidence.size(), 2, "accessible injury roles become perceptual evidence")

	var learning = ExperienceLearningService.new([
		ExperienceLearningRule.new(
			injury_event_type,
			&"other",
			-0.85,
			0.0,
			0.9
		)
	])
	var applied_impacts := 0
	for evidence in perception.evidence:
		var proposals: Dictionary = learning.derive(evidence)
		for impact in proposals["association_impacts"]:
			_expect_true(impact.subject.equals(palm), "accident learning associates aversion with the perceived impact source")
			associations.apply_impact(impact)
			applied_impacts += 1

	_expect_equal(applied_impacts, 1, "only the authored impact-source role creates an association")
	var association = associations.get_association(palm)
	_expect_true(association != null, "the perceived palm gains a Wilson-relative association")
	if association != null:
		_expect_true(float(association.valence) <= -0.80, "injury creates strong negative remembered valence toward the palm")
		_expect_equal(int(association.evidence_count), 1, "one perceived injury contributes one association evidence item")
		_expect_equal(association.last_source_execution_id, &"accident_1", "association keeps accident provenance")

	_expect_same(preference.choose(wilson, [short_route, long_route]), long_route, "after the accident remembered aversion makes Wilson take the longer route")
	var short_eval = preference.evaluate(wilson, short_route)
	_expect_equal(float(short_eval.physical_cost), 6.0, "post-accident learning does not alter physical route cost")
	_expect_true(float(short_eval.aversion) >= 0.80, "route preference reads learned accident aversion")


func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)


func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])


func _expect_same(actual, expected, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected same route option" % label)
