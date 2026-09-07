extends SceneTree

const SCENE_PATH := "res://tools/living_simulation/living_simulation.tscn"
const MAX_BOOT_FRAMES := 180
const MAX_OBSERVATION_FRAMES := 1200
const POST_CONSEQUENCE_FRAMES := 120

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
	var max_hunger := float(initial.get("hunger", -1.0))
	var hunger_after_meal := -1.0
	var completion_time := -1.0
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
		max_hunger = maxf(max_hunger, float(final.get("hunger", -1.0)))
		if int(final.get("grounded_consumptions", 0)) > 0 and hunger_after_meal < 0.0:
			hunger_after_meal = float(final.get("hunger", -1.0))
			completion_time = float(final.get("simulation_time", 0.0))
		if hunger_after_meal >= 0.0 and float(final.get("simulation_time", 0.0)) >= completion_time + 2.0:
			break

	if float(final.get("simulation_time", 0.0)) <= float(initial.get("simulation_time", 0.0)):
		_failures.append("Authoritative simulation time did not advance")
	if int(final.get("semantic_step", 0)) <= int(initial.get("semantic_step", 0)):
		_failures.append("Semantic step count did not advance")
	if max_hunger <= float(initial.get("hunger", -1.0)):
		_failures.append("Drive progression did not increase hunger before resource use")
	if not selected_intention:
		_failures.append("Wilson did not autonomously select an intention")
	if not moved:
		_failures.append("Wilson did not physically move during bounded observation")
	if hunger_after_meal < 0.0:
		_failures.append("Wilson never produced a grounded food consumption")
	elif hunger_after_meal >= max_hunger - 0.2:
		_failures.append("Grounded food consumption did not materially reduce hunger")
	if int(final.get("grounded_intention_completions", 0)) <= 0:
		_failures.append("Grounded food outcome did not complete seek_food intention")
	if hunger_after_meal >= 0.0 and float(final.get("simulation_time", 0.0)) < completion_time + 2.0:
		_failures.append("Simulation did not remain live after the grounded consequence")
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
