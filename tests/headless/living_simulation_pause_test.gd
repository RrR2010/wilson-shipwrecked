extends SceneTree

const SCENE_PATH := "res://tools/living_simulation/living_simulation.tscn"
var failures: Array[String] = []

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var scene = load(SCENE_PATH).instantiate()
	root.add_child(scene)
	for _frame in range(180):
		if scene.is_live() or scene.boot_error() != "":
			break
		await physics_frame
	if not scene.is_live():
		failures.append("Scene did not become live: %s" % scene.boot_error())
		await _finish(scene)
		return
	var overlay = scene.get_node("CalibrationOverlay")
	_check(overlay.set_speed_multiplier(4.0), "4x speed is supported")
	_check(overlay.toggle_pause(), "toggle enters pause")
	_check(is_zero_approx(overlay.speed_multiplier()), "paused speed is zero")
	_check(is_zero_approx(Engine.time_scale), "Godot simulation time scale is zero")
	var frozen = scene.observation_snapshot()
	for _frame in range(15):
		await process_frame
	var still = scene.observation_snapshot()
	_check(is_equal_approx(float(still["simulation_time"]), float(frozen["simulation_time"])), "pause freezes authoritative simulation time")
	_check(int(still["semantic_step"]) == int(frozen["semantic_step"]), "pause freezes semantic steps")
	_check(overlay.toggle_pause(), "toggle resumes")
	_check(is_equal_approx(overlay.speed_multiplier(), 4.0), "resume preserves prior 4x speed")
	_check(overlay.set_speed_multiplier(0.0), "explicit 0x speed supported")
	_check(overlay.set_speed_multiplier(1.0), "explicit 1x speed resumes")
	await _finish(scene)

func _finish(scene) -> void:
	Engine.time_scale = 1.0
	if scene != null and is_instance_valid(scene):
		scene.queue_free()
		await process_frame
	if failures.is_empty():
		print("PASS living_simulation_pause_test")
		quit(0)
		return
	for failure in failures:
		push_error(failure)
	print("FAIL living_simulation_pause_test: %d failure(s)" % failures.size())
	quit(1)

func _check(ok: bool, text: String) -> void:
	if not ok:
		failures.append(text)
