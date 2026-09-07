extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const WorldEvent = preload("res://src/domain/actions/world_event.gd")
const PerceptionAccess = preload("res://src/domain/cognition/perception_access.gd")
const PerceptionService = preload("res://src/domain/cognition/perception_service.gd")
const PresenceAttributionRule = preload("res://src/domain/cognition/presence_attribution_rule.gd")
const PresenceAttributionService = preload("res://src/domain/cognition/presence_attribution_service.gd")
const PresenceRelationship = preload("res://src/domain/cognition/presence_relationship.gd")
const PresenceLearningService = preload("res://src/domain/cognition/presence_learning_service.gd")
const PresenceLearningCoordinator = preload("res://src/application/simulation/presence_learning_coordinator.gd")

var _failures: Array[String] = []
var _completed := false


func _init() -> void:
	_run_slice()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS presence_causal_attribution_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL presence_causal_attribution_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	var coconut := RuntimeWorldRef.entity(DomainId.entity(&"coconut_1"))
	var unexplained_move := DomainId.event_definition(&"object_moved_unexplained")
	var ordinary_move := DomainId.event_definition(&"object_moved_by_wind")
	var bindings := RoleBinding.new()
	bindings.bind(&"object", coconut)

	var rule := PresenceAttributionRule.new(
		unexplained_move,
		&"object",
		0.65,
		0.45,
		0.20,
		0.50,
		&"vision"
	)
	var attribution := PresenceAttributionService.new([rule])
	var perception := PerceptionService.new()
	var presence := PresenceRelationship.new()
	var learning := PresenceLearningCoordinator.new(PresenceLearningService.new(), presence)

	var hidden_event := WorldEvent.new(unexplained_move, null, bindings, &"exec_hidden_move")
	var hidden_result = perception.perceive(
		[hidden_event],
		{&"exec_hidden_move": PerceptionAccess.new(false)}
	)
	_expect_equal(attribution.derive(hidden_result).size(), 0, "unobserved world consequence cannot become Presence evidence")
	_expect_equal(presence.evidence_count, 0, "unobserved consequence leaves Presence relationship untouched")

	var ordinary_event := WorldEvent.new(ordinary_move, null, bindings, &"exec_wind_move")
	var ordinary_result = perception.perceive(
		[ordinary_event],
		{&"exec_wind_move": PerceptionAccess.new(true, [&"vision"], [&"object"], 0.9)}
	)
	_expect_equal(attribution.derive(ordinary_result).size(), 0, "ordinary perceived motion is not automatically attributed to Presence")
	_expect_equal(presence.evidence_count, 0, "mere perception does not mutate Presence relationship")

	var visible_event := WorldEvent.new(unexplained_move, null, bindings, &"exec_visible_move")
	var visible_result = perception.perceive(
		[visible_event],
		{&"exec_visible_move": PerceptionAccess.new(true, [&"vision"], [&"object"], 0.8)}
	)
	var derived: Array = attribution.derive(visible_result)
	_expect_equal(derived.size(), 1, "authored visible unexplained effect produces one attribution proposal")
	if derived.size() == 1:
		_expect_equal(derived[0].source_execution_id, &"exec_visible_move", "attribution preserves perceived world occurrence provenance")
		_expect_true(is_equal_approx(derived[0].confidence, 0.8), "attribution confidence comes from perception")
		learning.process(derived[0])

	_expect_equal(presence.evidence_count, 1, "only attributed perceived consequence updates Presence relationship")
	_expect_true(presence.presence_belief > 0.0, "visible unexplained agency increases Presence belief")
	_expect_true(presence.trust > 0.0, "helpful attributed outcome can increase Presence trust")
	_expect_true(presence.dependency > 0.0, "helpful attributed outcome can independently increase dependency")
	_completed = true


func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)


func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
