extends SceneTree

const FIXTURE_PATH := "res://tests/scenes/spatial_navigation_perception/spatial_navigation_perception.tscn"

var _failures: Array[String] = []


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var packed: PackedScene = load(FIXTURE_PATH)
	if packed == null:
		_failures.append("3D integration fixture failed to load")
		_finish()
		return

	var fixture = packed.instantiate()
	fixture.pause_at_checkpoints = false
	fixture.auto_start = true
	root.add_child(fixture)

	var completed: bool = false
	for _frame in range(900):
		if fixture.is_completed():
			completed = true
			break
		await physics_frame

	if not completed:
		_failures.append("3D integration fixture did not complete within 900 physics frames")
	else:
		for failure in fixture.failures():
			_failures.append(String(failure))

	fixture.queue_free()
	await process_frame
	_finish()


func _finish() -> void:
	if _failures.is_empty():
		print("PASS spatial_navigation_perception_scene_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL spatial_navigation_perception_scene_test: %d failure(s)" % _failures.size())
	quit(1)
