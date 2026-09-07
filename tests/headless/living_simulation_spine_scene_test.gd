extends SceneTree

const SCENE_PATH := "res://tools/living_simulation/living_simulation.tscn"
const MAX_BOOT_FRAMES := 180
const MAX_OBSERVATION_FRAMES := 900

var _failures: Array[String] = []


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var packed: PackedScene = load(SCENE_PATH)
	if packed == null:
		_failures.append("Living simulation scene failed to load")
		_finish()
		return

	var scene = packed.instantiate()
	root.add_child(scene)

	var live := false
	for _frame in range(MAX_BOOT_FRAMES):
		if scene.boot_error() != "":
			_failures.append("Living simulation bootstrap failed: %s" % scene.boot_error())
			break
		if scene.is_live():
			live = true
			break
		await physics_frame

	if not live:
		if _failures.is_empty():
			_failures.append("Living simulation did not become live within bounded boot frames")
		scene.queue_free()
		await process_frame
		_finish()
		return

	var initial: Dictionary = scene.observation_snapshot()
	var moved := false
	var selected_intention := false
	var final: Dictionary = initial
	for _frame in range(MAX_OBSERVATION_FRAMES):
		await physics_frame
		if scene.boot_error() != "":
			_failures.append("Living simulation failed after bootstrap: %s" % scene.boot_error())
			break
		final = scene.observation_snapshot()
		var initial_position: Vector3 = initial.get("wilson_position", Vector3.ZERO)
		var current_position: Vector3 = final.get("wilson_position", Vector3.ZERO)
		moved = moved or initial_position.distance_to(current_position) > 0.5
		selected_intention = selected_intention or bool(final.get("has_intention", false))
		if moved and selected_intention and float(final.get("simulation_time", 0.0)) >= 5.0:
			break

	if float(final.get("simulation_time", 0.0)) <= float(initial.get("simulation_time", 0.0)):
		_failures.append("Authoritative simulation time did not advance")
	if int(final.get("semantic_step", 0)) <= int(initial.get("semantic_step", 0)):
		_failures.append("Semantic step count did not advance")
	if float(final.get("hunger", -1.0)) <= float(initial.get("hunger", -1.0)):
		_failures.append("Drive progression did not advance hunger")
	if not selected_intention:
		_failures.append("Wilson did not autonomously select an intention")
	if not moved:
		_failures.append("Wilson did not physically move during bounded observation")
	if int(final.get("trace_count", 0)) <= 0:
		_failures.append("Living simulation produced no semantic traces")

	scene.queue_free()
	await process_frame
	_finish()


func _finish() -> void:
	if _failures.is_empty():
		print("PASS living_simulation_spine_scene_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL living_simulation_spine_scene_test: %d failure(s)" % _failures.size())
	quit(1)
