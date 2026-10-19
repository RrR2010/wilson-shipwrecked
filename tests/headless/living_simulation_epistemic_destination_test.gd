extends SceneTree

const SCENE_PATH := "res://tools/living_simulation/living_simulation.tscn"
const MAX_BOOT_FRAMES := 180
const MAX_OBSERVATION_FRAMES := 3600
const TARGET_SIMULATION_SECONDS := 360.0

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
		_failures.append("Could not enable 16x epistemic smoke")
		await _cleanup(scene)
		return

	var initial: Dictionary = scene.observation_snapshot()
	var initial_far_quantity := int(initial.get("far_food_quantity", -1))
	if float(initial.get("far_food_edible_confidence", 0.0)) >= 0.0:
		_failures.append("Distant food must be unknown at playground bootstrap")

	var target_time := float(initial.get("simulation_time", 0.0)) + TARGET_SIMULATION_SECONDS
	var saw_near_empty := false
	var saw_far_discovery := false
	var saw_grounded_far_target := false
	var saw_far_consumption := false

	for _frame in range(MAX_OBSERVATION_FRAMES):
		await physics_frame
		if scene.boot_error() != "":
			_failures.append("Living simulation failed during epistemic smoke: %s" % scene.boot_error())
			break
		var snapshot: Dictionary = scene.observation_snapshot()
		var far_conf := float(snapshot.get("far_food_edible_confidence", -1.0))
		var intention := String(snapshot.get("intention_key", ""))
		var target := String(snapshot.get("intention_target_key", ""))
		var targeting_far := intention.contains("seek_food") and target.contains("food_patch_002")

		if targeting_far and far_conf < 0.5:
			_failures.append("Wilson targeted distant food before learning edible identity")
			break
		if int(snapshot.get("near_food_quantity", -1)) == 0 and float(snapshot.get("observed_food_empty_confidence", 0.0)) > 0.5:
			saw_near_empty = true
		if far_conf >= 0.5:
			saw_far_discovery = true
		if targeting_far and far_conf >= 0.5:
			saw_grounded_far_target = true
		if int(snapshot.get("far_food_quantity", initial_far_quantity)) < initial_far_quantity:
			saw_far_consumption = true
		if saw_near_empty and saw_far_discovery and saw_grounded_far_target and saw_far_consumption:
			break
		if float(snapshot.get("simulation_time", 0.0)) >= target_time:
			break

	if not saw_near_empty:
		_failures.append("Smoke never reached learned depletion of nearby food")
	if not saw_far_discovery:
		_failures.append("Wilson never discovered distant food through perceptual evidence")
	if not saw_grounded_far_target:
		_failures.append("Distant food was never targeted after discovery")
	if not saw_far_consumption:
		_failures.append("Distant food was never consumed after discovery")

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
		print("PASS living_simulation_epistemic_destination_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL living_simulation_epistemic_destination_test: %d failure(s)" % _failures.size())
	quit(1)
