extends SceneTree

const CompositeSelectedIntentionExecutor = preload("res://src/application/simulation/composite_selected_intention_executor.gd")

var _failures: Array[String] = []
var _completed := false


class DelegateStub:
	extends RefCounted
	var handled_key: StringName
	var calls: Array[StringName] = []

	func _init(p_handled_key: StringName) -> void:
		handled_key = p_handled_key

	func apply(current_intention) -> Dictionary:
		calls.append(&"apply")
		return _result(current_intention)

	func advance(current_intention) -> Dictionary:
		calls.append(&"advance")
		return _result(current_intention)

	func _result(current_intention) -> Dictionary:
		var key: StringName = current_intention.get("key", &"") if current_intention != null else &""
		return {
			"handled": key == handled_key,
			"reason": &"handled" if key == handled_key else &"not_handled",
			"delegate": handled_key,
		}


func _init() -> void:
	_run()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS composite_selected_intention_executor_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL composite_selected_intention_executor_test: %d failure(s)" % _failures.size())
	quit(1)


func _run() -> void:
	var first = DelegateStub.new(&"food")
	var second = DelegateStub.new(&"project")
	var composite = CompositeSelectedIntentionExecutor.new([first, second])

	var project_result = composite.apply({"key": &"project"})
	_expect_true(bool(project_result.get("handled", false)), "later matching delegate handles apply")
	_expect_equal(project_result.get("delegate"), &"project", "matching project delegate result is returned")
	_expect_equal(first.calls.size(), 1, "earlier delegate is consulted")
	_expect_equal(second.calls.size(), 1, "later delegate is consulted after miss")

	var food_result = composite.advance({"key": &"food"})
	_expect_true(bool(food_result.get("handled", false)), "first matching delegate handles advance")
	_expect_equal(food_result.get("delegate"), &"food", "matching food delegate result is returned")
	_expect_equal(first.calls.size(), 2, "first delegate receives advance")
	_expect_equal(second.calls.size(), 1, "dispatch stops after first handled result")

	var miss = composite.apply({"key": &"other"})
	_expect_true(not bool(miss.get("handled", true)), "unhandled intention remains explicit")
	_expect_equal(miss.get("reason"), &"not_handled", "unhandled result is diagnostic")
	_completed = true


func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)


func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
