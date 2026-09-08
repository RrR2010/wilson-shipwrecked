extends SceneTree

const SCENE_PATH := "res://tools/living_simulation/living_simulation.tscn"
const MAX_BOOT_FRAMES := 180
const MAX_OBSERVATION_FRAMES := 1800

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
		_cleanup(scene)
		return

	var overlay = scene.get_node_or_null("CalibrationOverlay")
	if overlay == null or not overlay.set_speed_multiplier(4.0):
		_failures.append("Weather context test could not enable supported 4x observation speed")
		_cleanup(scene)
		return

	var initial: Dictionary = scene.observation_snapshot()
	if String(initial.get("weather", &"")) != "clear":
		_failures.append("Living simulation did not begin in authored clear weather")
	if int(initial.get("weather_transition_index", -1)) != 0:
		_failures.append("Living simulation weather transition index did not begin at zero")

	var saw_project_before_rain := false
	var progress_before_rain := 0
	var saw_rain := false
	var saw_cover_intention := false
	var saw_cover_arrival := false
	var cover_progress := -1
	var saw_return_to_clear := false
	var saw_ordinary_activity_after_clear := false
	var saw_project_progress_after_clear := false
	var clear_return_progress := -1
	var final: Dictionary = initial

	for _frame in range(MAX_OBSERVATION_FRAMES):
		await physics_frame
		if scene.boot_error() != "":
			_failures.append("Living simulation failed during weather observation: %s" % scene.boot_error())
			break
		final = scene.observation_snapshot()
		var weather := String(final.get("weather", &""))
		var intention := String(final.get("intention_key", ""))
		var project_progress := int(final.get("project_contributions", 0))

		if not saw_rain and project_progress > 0:
			saw_project_before_rain = true
			progress_before_rain = maxi(progress_before_rain, project_progress)

		if weather == "rain":
			if not saw_rain:
				saw_rain = true
				progress_before_rain = project_progress
			if intention.contains("seek_safer_cover"):
				saw_cover_intention = true
				if cover_progress < 0:
					cover_progress = project_progress
				if int(final.get("motion_status", -1)) == 2:
					saw_cover_arrival = true

		if saw_rain and weather == "clear" and int(final.get("weather_transition_index", 0)) >= 2:
			if not saw_return_to_clear:
				saw_return_to_clear = true
				clear_return_progress = project_progress
			if not intention.contains("seek_safer_cover"):
				saw_ordinary_activity_after_clear = true
			if clear_return_progress >= 0 and project_progress > clear_return_progress:
				saw_project_progress_after_clear = true

		if saw_return_to_clear and saw_ordinary_activity_after_clear and saw_project_progress_after_clear:
			break

	if not saw_project_before_rain:
		_failures.append("Shelter project did not establish ordinary activity before first rain")
	if not saw_rain:
		_failures.append("Authored weather progression never transitioned clear → rain")
	if int(final.get("weather_transition_index", 0)) < 1:
		_failures.append("Authoritative weather transition index did not advance")
	if not saw_cover_intention:
		_failures.append("Perceived rain context never selected seek_safer_cover")
	if not saw_cover_arrival:
		_failures.append("Weather context intention never physically arrived at shelter cover")
	if cover_progress >= 0 and cover_progress < progress_before_rain:
		_failures.append("Weather interruption regressed persistent project progress")
	if not saw_return_to_clear:
		_failures.append("Authored weather progression never transitioned rain → clear")
	if not saw_ordinary_activity_after_clear:
		_failures.append("Wilson remained stuck in seek_safer_cover after weather improved")
	if not saw_project_progress_after_clear:
		_failures.append("Persistent project did not resume grounded progress after weather improved")
	if int(final.get("motion_status", -1)) == 3 or int(final.get("motion_status", -1)) == 4:
		_failures.append("Weather interference ended in blocked or invalid motion")

	_cleanup(scene)


func _cleanup(scene) -> void:
	Engine.time_scale = 1.0
	if scene != null and is_instance_valid(scene):
		scene.queue_free()
		await process_frame
	_finish()


func _finish() -> void:
	Engine.time_scale = 1.0
	if _failures.is_empty():
		print("PASS living_simulation_weather_context_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL living_simulation_weather_context_test: %d failure(s)" % _failures.size())
	quit(1)
