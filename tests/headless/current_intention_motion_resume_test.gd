extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const CurrentIntentionStore = preload("res://src/domain/cognition/current_intention_store.gd")
const DefaultSimulationActivityQuery = preload("res://src/application/simulation/default_simulation_activity_query.gd")
const DirectTargetMotionExecutionCoordinator = preload("res://src/application/simulation/direct_target_motion_execution_coordinator.gd")
const CurrentIntentionExecutionCoordinator = preload("res://src/application/simulation/current_intention_execution_coordinator.gd")
const FakeMotionPort = preload("res://tests/fakes/fake_motion_port.gd")

var _failures: Array[String] = []


class NoActionExecution:
	extends RefCounted
	func active_execution_ids() -> Array[StringName]:
		return []


func _init() -> void:
	_run()
	if _failures.is_empty():
		print("PASS current_intention_motion_resume_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL current_intention_motion_resume_test: %d failure(s)" % _failures.size())
	quit(1)


func _run() -> void:
	var wilson_ref = RuntimeWorldRef.wilson()
	var target_ref = RuntimeWorldRef.entity(DomainId.entity(&"food_patch"))
	var seek_food = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"seek_food")
	var bindings = RoleBinding.new()
	bindings.bind(&"target", target_ref)
	var intentions = CurrentIntentionStore.new()
	var selected = intentions.select(seek_food, bindings, &"bootstrap_selection")
	_expect_true(selected.ok, "current intention is admitted")

	var motion = FakeMotionPort.new()
	var executor = DirectTargetMotionExecutionCoordinator.new(motion, wilson_ref, [seek_food])
	var activity = DefaultSimulationActivityQuery.new(NoActionExecution.new(), intentions)
	var resume = CurrentIntentionExecutionCoordinator.new(activity, executor)
	var result = resume.resume_current()

	_expect_true(bool(result.get("handled", false)), "resume recognizes configured current intention")
	_expect_true(bool(result.get("resumed", false)), "resume starts semantic motion")
	_expect_equal(result.get("reason"), &"move_requested", "resume exposes direct motion reason")
	_expect_equal(motion.request_history.size(), 1, "resume emits one motion request")
	_expect_ref(motion.get_target(wilson_ref), target_ref, "motion request uses authoritative intention binding")

	var repeated = resume.resume_current()
	_expect_true(bool(repeated.get("resumed", false)), "repeated resume recognizes already-running motion")
	_expect_equal(repeated.get("reason"), &"already_moving", "repeated resume is idempotent for same target")
	_expect_equal(motion.request_history.size(), 1, "idempotent resume does not duplicate motion request")
	_expect_equal(motion.cancel_history.size(), 0, "idempotent resume does not cancel same-target motion")

	var unrelated = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"rest")
	var unrelated_store = CurrentIntentionStore.new()
	_expect_true(unrelated_store.select(unrelated, RoleBinding.new(), &"rest_selection").ok, "unrelated intention is admitted")
	var unrelated_activity = DefaultSimulationActivityQuery.new(NoActionExecution.new(), unrelated_store)
	var unrelated_resume = CurrentIntentionExecutionCoordinator.new(unrelated_activity, executor).resume_current()
	_expect_true(not bool(unrelated_resume.get("resumed", false)), "unhandled intention does not create motion")
	_expect_equal(unrelated_resume.get("reason"), &"not_handled", "unhandled intention stays explicit")


func _expect_true(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _expect_equal(actual: Variant, expected: Variant, message: String) -> void:
	if actual != expected:
		_failures.append("%s (expected=%s actual=%s)" % [message, expected, actual])


func _expect_ref(actual, expected, message: String) -> void:
	if actual == null or expected == null or not actual.equals(expected):
		_failures.append("%s (expected=%s actual=%s)" % [message, expected, actual])
