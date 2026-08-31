extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const ActionOutcome = preload("res://src/domain/actions/action_outcome.gd")
const WorldEvent = preload("res://src/domain/actions/world_event.gd")

var _failures: Array[String] = []
var _completed := false


func _init() -> void:
	_run_slice()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS semantic_snapshot_immutability_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL semantic_snapshot_immutability_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	var action_id = DomainId.action(&"inspect")
	var event_id = DomainId.event_definition(&"inspection_committed")
	var original_target = RuntimeWorldRef.entity(DomainId.entity(&"crate_1"))
	var replacement_target = RuntimeWorldRef.entity(DomainId.entity(&"crate_2"))
	var bindings = RoleBinding.new()
	bindings.bind(&"target", original_target)

	var outcome = ActionOutcome.new(&"exec_1", action_id, bindings, [], event_id)
	var event = WorldEvent.new(event_id, action_id, bindings, &"exec_1")

	bindings.bind(&"target", replacement_target)

	_expect_equal(outcome.bindings.get_subject(&"target").key(), original_target.key(), "ActionOutcome preserves original binding snapshot")
	_expect_equal(event.bindings.get_subject(&"target").key(), original_target.key(), "WorldEvent preserves original binding snapshot")
	_expect_equal(bindings.get_subject(&"target").key(), replacement_target.key(), "original mutable binding can still change independently")

	_completed = true


func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
