extends SceneTree

const SCENE_PATH := "res://tools/living_simulation/living_simulation.tscn"
const MAX_BOOT_FRAMES := 180
const MAX_OBSERVATION_FRAMES := 3600
const MAX_SEMANTIC_SECONDS := 450.0

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
			_failures.append("Living simulation did not become live")
		await _cleanup(scene)
		return

	var overlay = scene.get_node_or_null("CalibrationOverlay")
	if overlay == null or not overlay.set_speed_multiplier(16.0):
		_failures.append("Post-project weather test could not enable 16x execution")
		await _cleanup(scene)
		return

	var initial: Dictionary = scene.observation_snapshot()
	var deadline: float = float(initial.get("simulation_time", 0.0)) + MAX_SEMANTIC_SECONDS
	var project_completed := false
	var completion_weather_index := -1
	var saw_clear_after_completion := false
	var saw_post_completion_rain := false
	var saw_cover_from_post_completion_rain := false
	var final: Dictionary = initial

	for _frame in range(MAX_OBSERVATION_FRAMES):
		await physics_frame
		if scene.boot_error() != "":
			_failures.append("Living simulation failed during post-project weather observation: %s" % scene.boot_error())
			break
		final = scene.observation_snapshot()
		var progress := int(final.get("project_contributions", 0))
		var active := bool(final.get("project_active", true))
		var weather := String(final.get("weather", &""))
		var weather_index := int(final.get("weather_transition_index", -1))
		var intention := String(final.get("intention_key", ""))

		if not project_completed and progress == 100 and not active:
			project_completed = true
			completion_weather_index = weather_index
		if project_completed and weather == "clear" and weather_index >= completion_weather_index:
			saw_clear_after_completion = true
		if saw_clear_after_completion and weather == "rain" and weather_index > completion_weather_index:
			saw_post_completion_rain = true
			if intention.contains("seek_safer_cover"):
				saw_cover_from_post_completion_rain = true
				break

		if float(final.get("simulation_time", 0.0)) >= deadline:
			break

	if not project_completed:
		_failures.append("Shelter did not complete within bounded post-project weather setup")
	if not saw_post_completion_rain:
		_failures.append("No clear → rain transition occurred after shelter completion")
	if not saw_cover_from_post_completion_rain:
		_failures.append("Tactical rain response was not selectable after project completion from idle")

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
		print("PASS living_simulation_post_project_weather_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL living_simulation_post_project_weather_test: %d failure(s)" % _failures.size())
	quit(1)
