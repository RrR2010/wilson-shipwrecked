extends SceneTree

const SCENE_PATH := "res://tools/living_simulation/living_simulation.tscn"
const MAX_BOOT_FRAMES := 180
const TARGET_SIMULATION_SECONDS := 180.0
const MAX_OBSERVATION_FRAMES := 1800

var _failures: Array[String] = []


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var packed: PackedScene = load(SCENE_PATH)
	if packed == null:
		_failures.append("Living-island scene failed to load")
		_finish()
		return
	var scene = packed.instantiate()
	root.add_child(scene)

	var live := false
	for _frame in range(MAX_BOOT_FRAMES):
		if scene.boot_error() != "":
			_failures.append("Living-island bootstrap failed: %s" % scene.boot_error())
			break
		if scene.is_live():
			live = true
			break
		await physics_frame
	if not live:
		if _failures.is_empty():
			_failures.append("Living-island scene did not become live")
		await _cleanup(scene)
		return

	var overlay = scene.get_node_or_null("CalibrationOverlay")
	if overlay == null or not overlay.set_speed_multiplier(16.0):
		_failures.append("Playground test could not enable 16x execution")
		await _cleanup(scene)
		return

	var initial: Dictionary = scene.observation_snapshot()
	var target_time: float = float(initial.get("simulation_time", 0.0)) + TARGET_SIMULATION_SECONDS
	var initial_wilson_position: Vector3 = initial.get("wilson_position", Vector3.ZERO)
	var initial_gerald_position: Vector3 = initial.get("gerald_position", Vector3.ZERO)
	var max_wilson_displacement := 0.0
	var max_gerald_displacement := 0.0
	var max_energy := float(initial.get("energy", 0.0))
	var max_stimulation := float(initial.get("stimulation", 0.0))
	var rest_drop_observed := false
	var stimulation_drop_observed := false
	var previous_rests := int(initial.get("grounded_rests", 0))
	var previous_explores := int(initial.get("grounded_explorations", 0))
	var saw_build_bubble := false
	var saw_rest_bubble := false
	var saw_explore_bubble := false
	var final: Dictionary = initial

	for _frame in range(MAX_OBSERVATION_FRAMES):
		await physics_frame
		if scene.boot_error() != "":
			_failures.append("Living-island runtime failed: %s" % scene.boot_error())
			break
		final = scene.observation_snapshot()
		var current_wilson_position: Vector3 = final.get("wilson_position", Vector3.ZERO)
		var current_gerald_position: Vector3 = final.get("gerald_position", Vector3.ZERO)
		max_wilson_displacement = maxf(max_wilson_displacement, initial_wilson_position.distance_to(current_wilson_position))
		max_gerald_displacement = maxf(max_gerald_displacement, initial_gerald_position.distance_to(current_gerald_position))

		var energy := float(final.get("energy", -1.0))
		var stimulation := float(final.get("stimulation", -1.0))
		max_energy = maxf(max_energy, energy)
		max_stimulation = maxf(max_stimulation, stimulation)
		var rests := int(final.get("grounded_rests", 0))
		var explores := int(final.get("grounded_explorations", 0))
		if rests > previous_rests and energy < max_energy - 0.2:
			rest_drop_observed = true
		if explores > previous_explores and stimulation < max_stimulation - 0.2:
			stimulation_drop_observed = true
		previous_rests = rests
		previous_explores = explores

		var bubble: Label3D = scene.get_node_or_null("Wilson/ThoughtBubble") as Label3D
		if bubble != null:
			var bubble_text := String(bubble.text)
			saw_build_bubble = saw_build_bubble or bubble_text.contains("BUILD")
			saw_rest_bubble = saw_rest_bubble or bubble_text.contains("REST")
			saw_explore_bubble = saw_explore_bubble or bubble_text.contains("EXPLORE")

		if float(final.get("simulation_time", 0.0)) >= target_time:
			break

	if float(final.get("simulation_time", 0.0)) < target_time:
		_failures.append("Playground did not reach %.1f simulated seconds" % TARGET_SIMULATION_SECONDS)
	if max_wilson_displacement < 2.0:
		_failures.append("Wilson did not traverse the diverse island")
	if int(final.get("grounded_consumptions", 0)) < 2:
		_failures.append("Playground produced too little grounded hunger activity")
	if int(final.get("grounded_rests", 0)) < 1 or not rest_drop_observed:
		_failures.append("Energy/rest loop did not ground and materially reduce energy")
	if int(final.get("grounded_explorations", 0)) < 1 or not stimulation_drop_observed:
		_failures.append("Stimulation/exploration loop did not ground and materially reduce stimulation")
	if int(final.get("project_contributions", 0)) <= 0:
		_failures.append("Persistent shelter project never progressed in playground")
	if int(final.get("weather_transition_index", 0)) < 2:
		_failures.append("Playground did not exercise repeated weather context")
	if max_gerald_displacement < 2.0:
		_failures.append("Gerald did not physically traverse the island")
	if int(final.get("gerald_arrivals", 0)) < 2:
		_failures.append("Gerald did not commit multiple deferred semantic arrivals")
	if float(final.get("gerald_affinity", 0.0)) <= 0.0:
		_failures.append("Gerald relationship baseline was not preserved")
	if not saw_build_bubble or not saw_rest_bubble or not saw_explore_bubble:
		_failures.append("Expressive Wilson bubble did not project build/rest/explore states")
	if scene.get_node_or_null("RestSpot") == null or scene.get_node_or_null("CuriositySpot") == null:
		_failures.append("Diverse primitive targets are missing from the scene")
	if int(final.get("motion_status", -1)) == 3 or int(final.get("motion_status", -1)) == 4:
		_failures.append("Wilson ended playground observation in bad motion state")
	if int(final.get("gerald_motion_status", -1)) == 3 or int(final.get("gerald_motion_status", -1)) == 4:
		_failures.append("Gerald ended playground observation in bad motion state")

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
		print("PASS living_island_playground_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL living_island_playground_test: %d failure(s)" % _failures.size())
	quit(1)
