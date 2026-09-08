extends SceneTree

const SCENE_PATH := "res://tools/living_simulation/living_simulation.tscn"
const MAX_BOOT_FRAMES := 180
# Weather intentionally consumes a meaningful share of Wilson's available activity
# time. Ten simulated minutes preserves the strong eventual-completion + post-
# completion-liveness guard without calibrating project speed around this test.
const TARGET_SIMULATION_SECONDS := 600.0
const MAX_OBSERVATION_FRAMES := 4800
const MAX_CONSECUTIVE_BAD_MOTION_FRAMES := 120
const MAX_CONSECUTIVE_STALLED_FRAMES := 120

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
	if overlay == null:
		_failures.append("Calibration overlay is missing from living simulation")
		await _cleanup(scene)
		return
	if overlay.set_speed_multiplier(2.0):
		_failures.append("Calibration overlay accepted unsupported 2x speed")
	if not overlay.set_speed_multiplier(16.0):
		_failures.append("Calibration overlay rejected supported 16x speed")
		await _cleanup(scene)
		return
	if not is_equal_approx(Engine.time_scale, 16.0):
		_failures.append("16x calibration control did not scale engine execution")

	var initial: Dictionary = scene.observation_snapshot()
	var target_time := float(initial.get("simulation_time", 0.0)) + TARGET_SIMULATION_SECONDS
	var previous: Dictionary = initial
	var previous_project := int(initial.get("project_contributions", 0))
	var previous_meals := int(initial.get("grounded_consumptions", 0))
	var previous_intention := String(initial.get("intention_key", ""))
	var intention_transitions := 0
	var bad_motion_frames := 0
	var stalled_frames := 0
	var max_bad_motion_frames := 0
	var max_stalled_frames := 0
	var project_completed := false
	var meals_at_project_completion := -1
	var meals_after_project_completion := false
	var saw_project_progress := previous_project > 0
	var final: Dictionary = initial

	for _frame in range(MAX_OBSERVATION_FRAMES):
		await physics_frame
		if scene.boot_error() != "":
			_failures.append("Living simulation failed during long run: %s" % scene.boot_error())
			break
		final = scene.observation_snapshot()

		var simulation_time := float(final.get("simulation_time", -1.0))
		var previous_time := float(previous.get("simulation_time", -1.0))
		if simulation_time <= previous_time + 1.0e-6:
			stalled_frames += 1
		else:
			stalled_frames = 0
		max_stalled_frames = maxi(max_stalled_frames, stalled_frames)

		var hunger := float(final.get("hunger", -1.0))
		if not is_finite(hunger) or hunger < -1.0e-6 or hunger > 1.0 + 1.0e-6:
			_failures.append("Hunger escaped bounded finite range during long run: %s" % str(hunger))
			break

		var position: Vector3 = final.get("wilson_position", Vector3.ZERO)
		if not is_finite(position.x) or not is_finite(position.y) or not is_finite(position.z):
			_failures.append("Wilson position became non-finite during long run")
			break
		if absf(position.x) > 11.0 or absf(position.z) > 8.0:
			_failures.append("Wilson escaped bounded island navigation area: %s" % str(position))
			break

		var motion_status := int(final.get("motion_status", -1))
		if motion_status == 3 or motion_status == 4:
			bad_motion_frames += 1
		else:
			bad_motion_frames = 0
		max_bad_motion_frames = maxi(max_bad_motion_frames, bad_motion_frames)

		var project_progress := int(final.get("project_contributions", 0))
		if project_progress < previous_project:
			_failures.append("Persistent project progress regressed during long run")
			break
		if project_progress < 0 or project_progress > 100:
			_failures.append("Persistent project progress escaped authored bounds: %d" % project_progress)
			break
		if project_progress > 0:
			saw_project_progress = true
		previous_project = project_progress

		var meals := int(final.get("grounded_consumptions", 0))
		if meals < previous_meals:
			_failures.append("Grounded meal count regressed during long run")
			break
		previous_meals = meals

		var intention := String(final.get("intention_key", ""))
		if intention != previous_intention:
			intention_transitions += 1
			previous_intention = intention

		if project_progress == 100 and not bool(final.get("project_active", true)) and not project_completed:
			project_completed = true
			meals_at_project_completion = meals
		if project_completed and meals > meals_at_project_completion:
			meals_after_project_completion = true

		previous = final.duplicate(true)
		if simulation_time >= target_time:
			break

	if float(final.get("simulation_time", 0.0)) < target_time:
		_failures.append("Long run did not reach %.1f semantic seconds" % TARGET_SIMULATION_SECONDS)
	if max_stalled_frames > MAX_CONSECUTIVE_STALLED_FRAMES:
		_failures.append("Semantic clock stalled for %d consecutive physics frames" % max_stalled_frames)
	if max_bad_motion_frames > MAX_CONSECUTIVE_BAD_MOTION_FRAMES:
		_failures.append("Motion remained BLOCKED/ROUTE_INVALID for %d consecutive frames" % max_bad_motion_frames)
	if not saw_project_progress:
		_failures.append("Long run produced no persistent project progress")
	if not project_completed:
		_failures.append("Shelter project did not reach bounded completion during ten-minute long run")
	if int(final.get("project_contributions", 0)) != int(final.get("grounded_project_contributions", 0)):
		_failures.append("Project owner progress diverged from grounded contribution count")
	if not meals_after_project_completion:
		_failures.append("Simulation did not continue grounded need behavior after project completion")
	var final_meals := int(final.get("grounded_consumptions", 0))
	if final_meals < 5:
		_failures.append("Long run produced implausibly little grounded need activity: %d meals" % final_meals)
	if final_meals > 160:
		_failures.append("Long run produced likely duplicate/runaway grounded need activity: %d meals" % final_meals)
	if intention_transitions > 300:
		_failures.append("Long run showed likely intention oscillation: %d transitions" % intention_transitions)
	if int(final.get("trace_count", 0)) > 64:
		_failures.append("Bounded trace projection grew beyond configured buffer")

	var final_time := float(final.get("simulation_time", 0.0))
	var final_step := int(final.get("semantic_step", 0))
	if absf(float(final_step) - final_time * 10.0) > 2.0:
		_failures.append("Semantic step count drifted from authoritative 0.1s cadence: time=%.3f step=%d" % [final_time, final_step])

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
		print("PASS living_simulation_long_run_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL living_simulation_long_run_test: %d failure(s)" % _failures.size())
	quit(1)
