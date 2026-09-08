extends SceneTree

const SCENE_PATH := "res://tools/living_simulation/living_simulation.tscn"
const MAX_BOOT_FRAMES := 180
const TARGET_SIMULATION_SECONDS := 180.0
const MAX_OBSERVATION_FRAMES := 3600

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
		await _cleanup(scene)
		return

	var overlay = scene.get_node_or_null("CalibrationOverlay")
	if overlay == null or not overlay.set_speed_multiplier(4.0):
		_failures.append("Spine continuity test could not enable supported 4x execution")
		await _cleanup(scene)
		return

	var initial: Dictionary = scene.observation_snapshot()
	var target_time := float(initial.get("simulation_time", 0.0)) + TARGET_SIMULATION_SECONDS
	var moved := false
	var selected_intention := false
	var max_hunger := float(initial.get("hunger", -1.0))
	var hunger_after_first_meal := -1.0
	var project_started := false
	var project_progress_before_interruption := 0
	var saw_food_interruption_after_work := false
	var second_meal_project_progress := -1
	var resumed_project_after_interruption := false
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

		var meals := int(final.get("grounded_consumptions", 0))
		var project_progress := int(final.get("project_contributions", 0))
		var intention_key := String(final.get("intention_key", ""))
		if meals > 0 and hunger_after_first_meal < 0.0:
			hunger_after_first_meal = float(final.get("hunger", -1.0))
		if project_progress > 0:
			project_started = true
		if project_started and meals < 2:
			project_progress_before_interruption = maxi(project_progress_before_interruption, project_progress)
		if project_started and intention_key.contains("seek_food"):
			saw_food_interruption_after_work = true
		if meals >= 2 and second_meal_project_progress < 0:
			second_meal_project_progress = project_progress
		if second_meal_project_progress >= 0 \
			and intention_key.contains("continue_shelter_project") \
			and project_progress > second_meal_project_progress:
			resumed_project_after_interruption = true
			break
		if float(final.get("simulation_time", 0.0)) >= target_time:
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
	if hunger_after_first_meal < 0.0:
		_failures.append("Wilson never produced the initial grounded food consumption")
	elif hunger_after_first_meal >= max_hunger - 0.2:
		_failures.append("Grounded food consumption did not materially reduce hunger")
	if not project_started:
		_failures.append("Wilson never produced grounded shelter project progress")
	if project_progress_before_interruption <= 0:
		_failures.append("Shelter project had no persistent partial progress before competing hunger")
	if not saw_food_interruption_after_work:
		_failures.append("Pressing hunger never displaced visible shelter project work")
	if int(final.get("grounded_consumptions", 0)) < 2:
		_failures.append("Competing hunger did not resolve through a second grounded meal within %.0fs semantic window" % TARGET_SIMULATION_SECONDS)
	if not resumed_project_after_interruption:
		_failures.append("Wilson did not return to the same persistent shelter project after hunger resolved")
	if int(final.get("grounded_project_contributions", 0)) < int(final.get("project_contributions", 0)):
		_failures.append("Observed project progress was not backed by grounded project contributions")
	if int(final.get("trace_count", 0)) <= 0:
		_failures.append("Living simulation produced no semantic traces")

	await _cleanup(scene)


func _cleanup(scene) -> void:
	Engine.time_scale = 1.0
	if scene != null and is_instance_valid(scene):
		scene.queue_free()
		await process_frame
	_finish()


func _finish() -> void:
	Engine.time_scale = 1.0
	if _failures.is_empty():
		print("PASS living_simulation_spine_scene_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL living_simulation_spine_scene_test: %d failure(s)" % _failures.size())
	quit(1)
