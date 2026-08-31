extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const WorldEvent = preload("res://src/domain/actions/world_event.gd")
const EpistemicClaim = preload("res://src/domain/cognition/epistemic_claim.gd")
const PerceptionAccess = preload("res://src/domain/cognition/perception_access.gd")
const PerceptionService = preload("res://src/domain/cognition/perception_service.gd")

var _failures: Array[String] = []
var _completed := false


func _init() -> void:
	_run_slice()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS perception_projection_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL perception_projection_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	var wilson = RuntimeWorldRef.wilson()
	var stone = RuntimeWorldRef.entity(DomainId.entity(&"stone_42"))
	var crate = RuntimeWorldRef.entity(DomainId.entity(&"crate_4"))

	var bindings = RoleBinding.new()
	bindings.bind(&"actor", wilson)
	bindings.bind(&"tool", stone)
	bindings.bind(&"target", crate)

	var hit_event = WorldEvent.new(
		DomainId.event_definition(&"impact_committed"),
		DomainId.action(&"hit"),
		bindings,
		&"exec_hit_1"
	)
	var hidden_event = WorldEvent.new(
		DomainId.event_definition(&"distant_change"),
		DomainId.action(&"inspect"),
		bindings,
		&"exec_hidden_1"
	)

	var service = PerceptionService.new()
	var result = service.perceive([hit_event, hidden_event], {
		&"exec_hit_1": PerceptionAccess.new(true, [&"hearing"], [&"target"], 0.75),
		&"exec_hidden_1": PerceptionAccess.new(false),
	})

	_expect_equal(result.observed_events.size(), 1, "only observable event becomes ObservedEvent")
	_expect_equal(result.evidence.size(), 1, "only accessible role produces evidence")
	_expect_true(not result.diagnostics.is_empty(), "unobservable event leaves diagnostic")

	if result.observed_events.size() == 1:
		var observed = result.observed_events[0]
		_expect_equal(String(observed.event_type.value), "impact_committed", "observed event keeps semantic event type")
		_expect_equal(observed.event_type.kind, DomainId.Kind.EVENT_DEFINITION, "observed event uses EventDefinitionId")
		_expect_true(observed.perceived_bindings.has(&"target"), "target role is accessible")
		_expect_false(observed.perceived_bindings.has(&"tool"), "hidden tool role does not leak from WorldEvent")
		_expect_false(observed.perceived_bindings.has(&"actor"), "hidden actor role does not leak from WorldEvent")
		_expect_equal(observed.perceived_bindings[&"target"].key(), crate.key(), "accessible target identity preserved")
		_expect_equal(observed.modalities, [&"hearing"], "observation records modality")

	if result.evidence.size() == 1:
		var evidence = result.evidence[0]
		_expect_equal(evidence.claim.kind, EpistemicClaim.Kind.EVENT, "perception emits EVENT claim")
		_expect_equal(evidence.claim.subject.key(), crate.key(), "claim subject is accessible target only")
		_expect_equal(evidence.confidence, 0.75, "access confidence carried into evidence")
		_expect_equal(String(evidence.modality), "hearing", "evidence records modality")
		_expect_equal(String(evidence.claim.semantic_id.value), "impact_committed", "claim references typed perceived event")
		_expect_equal(String(evidence.claim.role_name), "target", "claim references perceived role")
		_expect_true(evidence.claim.sort_key().find("tool") == -1, "claim does not leak hidden tool role")
		_expect_true(evidence.claim.sort_key().find("actor") == -1, "claim does not leak hidden actor role")

	_expect_true(hit_event.bindings.has(&"tool"), "WorldEvent retains hidden tool truth")
	_expect_true(hit_event.bindings.has(&"actor"), "WorldEvent retains hidden actor truth")

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
