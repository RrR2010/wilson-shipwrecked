extends SceneTree

const FIXTURE_PATH := "res://tests/scenes/spatial_navigation_perception/spatial_navigation_perception_harness_assisted.tscn"

var _failures: Array[String] = []
var _checkpoint_names: Array[StringName] = []


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var packed: PackedScene = load(FIXTURE_PATH)
	_expect_true(packed != null, "assisted harness scene loads")
	if packed == null:
		_finish()
		return

	var wrapper = packed.instantiate()
	var fixture = wrapper.get_node("SpatialNavigationPerception")
	fixture.checkpoint_reached.connect(func(name: StringName, _details: Dictionary) -> void:
		_checkpoint_names.append(name)
	)
	root.add_child(wrapper)

	for _frame in range(120):
		if not _checkpoint_names.is_empty():
			break
		await process_frame

	_expect_true(not _checkpoint_names.is_empty(), "assisted scenario reaches first checkpoint after scene startup")
	if not _checkpoint_names.is_empty():
		_expect_equal(_checkpoint_names[0], &"SCENE_READY", "first assisted checkpoint is SCENE_READY")
	_expect_true(fixture.pause_at_checkpoints, "assisted scenario remains configured to pause at checkpoints")
	_expect_true(not fixture.is_completed(), "scenario is paused before completion at first checkpoint")

	fixture.continue_requested.emit()
	for _frame in range(900):
		if _checkpoint_names.size() >= 2:
			break
		await process_frame

	_expect_true(_checkpoint_names.size() >= 2, "continue signal releases first checkpoint and scenario advances")
	if _checkpoint_names.size() >= 2:
		_expect_equal(_checkpoint_names[1], &"PASSIVE_WHILE_MOVING", "second assisted checkpoint is PASSIVE_WHILE_MOVING")

	wrapper.queue_free()
	await process_frame
	_finish()


func _expect_true(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _expect_equal(actual: Variant, expected: Variant, message: String) -> void:
	if actual != expected:
		_failures.append("%s (expected=%s actual=%s)" % [message, expected, actual])


func _finish() -> void:
	if _failures.is_empty():
		print("PASS spatial_navigation_perception_assisted_startup_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL spatial_navigation_perception_assisted_startup_test: %d failure(s)" % _failures.size())
	quit(1)
