class_name SpatialNavigationPerceptionScene
extends Node3D

signal checkpoint_reached(name: StringName, details: Dictionary)
signal smoke_finished(success: bool, report: Dictionary)
signal continue_requested()

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const CurrentIntentionState = preload("res://src/domain/cognition/current_intention_state.gd")
const MotionPort = preload("res://src/application/simulation/motion_port.gd")
const EscapeDestinationResolver = preload("res://src/application/simulation/escape_destination_resolver.gd")
const DefensiveMotionExecutionCoordinator = preload("res://src/application/simulation/defensive_motion_execution_coordinator.gd")
const PassiveSpatialPerceptionSource = preload("res://src/application/simulation/passive_spatial_perception_source.gd")
const GodotSceneSpatialRegistry = preload("res://src/infrastructure/spatial/godot_scene_spatial_registry.gd")
const GodotMotionAdapter = preload("res://src/infrastructure/spatial/godot_motion_adapter.gd")
const GodotPassiveSpatialSensor = preload("res://src/infrastructure/spatial/godot_passive_spatial_sensor.gd")
const GodotSpatialQueryAdapter = preload("res://src/infrastructure/spatial/godot_spatial_query_adapter.gd")

@export var auto_start: bool = true
@export var pause_at_checkpoints: bool = true
@export var movement_speed_mps: float = 3.0
@export var max_motion_frames: int = 720

@onready var wall: StaticBody3D = $Wall
@onready var wilson: CharacterBody3D = $Wilson
@onready var wilson_spatial_reference: Node3D = $Wilson/SpatialReference
@onready var wilson_agent: NavigationAgent3D = $Wilson/NavigationAgent3D
@onready var perception_area: Area3D = $Wilson/PerceptionArea
@onready var target: Node3D = $Target
@onready var escape_target: Node3D = $EscapeTarget
@onready var perceptible: StaticBody3D = $Perceptible
@onready var perceptible_spatial_reference: Node3D = $Perceptible/SpatialReference
@onready var status_label: Label = $DebugUI/Margin/Status

var _registry: GodotSceneSpatialRegistry
var _motion: GodotMotionAdapter
var _sensor: GodotPassiveSpatialSensor
var _spatial: GodotSpatialQueryAdapter
var _passive: PassiveSpatialPerceptionSource

var _wilson_ref: RuntimeWorldRef
var _target_ref: RuntimeWorldRef
var _escape_ref: RuntimeWorldRef
var _perceptible_ref: RuntimeWorldRef
var _failures: Array[String] = []
var _observed_passive_while_moving: bool = false
var _observed_threat_redirect: bool = false
var _completed: bool = false

const START_POSITION := Vector3(-7.0, 0.0, 0.0)
const TARGET_POSITION := Vector3(7.0, 0.0, 2.0)
const ESCAPE_POSITION := Vector3(-7.0, 0.0, 5.5)
const PERCEPTIBLE_ROUTE_POSITION := Vector3(-1.5, 0.0, 2.2)
const COLLISION_PROBE_START := Vector3(-3.2, 0.0, 0.0)
const LOS_CLEAR_WILSON := Vector3(-4.0, 0.0, 3.0)
const LOS_CLEAR_TARGET := Vector3(0.0, 0.0, 3.0)
const LOS_BLOCKED_WILSON := Vector3(-4.0, 0.0, 0.0)
const LOS_BLOCKED_TARGET := Vector3(4.0, 0.0, 0.0)


func _ready() -> void:
	status_label.text = "Spatial / Navigation / Perception\ninitializing..."
	if auto_start:
		call_deferred("_run_smoke")


func _unhandled_key_input(event: InputEvent) -> void:
	var key_event := event as InputEventKey
	if key_event != null and key_event.pressed and not key_event.echo and key_event.keycode == KEY_SPACE:
		continue_requested.emit()


func _run_smoke() -> void:
	await _physics_frames(3)
	_setup_runtime_adapters()
	await _checkpoint(&"SCENE_READY", {
		"instruction": "Capture the full scene before movement. Press Space to continue.",
		"wilson": wilson.global_position,
		"target": target.global_position,
		"escape_target": escape_target.global_position,
		"perceptible": perceptible.global_position,
	})

	await _prove_collision()
	await _prove_navigation()
	await _prove_motion_and_passive_perception()
	await _prove_threat_motion_interruption()
	await _prove_line_of_sight()

	_completed = true
	var success: bool = _failures.is_empty()
	var report := {
		"success": success,
		"failures": _failures.duplicate(),
		"passive_while_moving": _observed_passive_while_moving,
		"threat_redirect": _observed_threat_redirect,
		"motion_status": _motion.get_status(_wilson_ref),
	}
	await _checkpoint(&"COMPLETE", {
		"instruction": "Final checkpoint. Capture the screen and console report.",
		"success": success,
		"failures": _failures,
	})
	if success:
		print("PASS spatial_navigation_perception_scene")
	else:
		push_error("FAIL spatial_navigation_perception_scene: %s" % "; ".join(_failures))
	smoke_finished.emit(success, report)


func _setup_runtime_adapters() -> void:
	_wilson_ref = RuntimeWorldRef.wilson()
	_target_ref = RuntimeWorldRef.entity(DomainId.entity(&"spatial_smoke_target"))
	_escape_ref = RuntimeWorldRef.entity(DomainId.entity(&"spatial_smoke_escape"))
	_perceptible_ref = RuntimeWorldRef.entity(DomainId.entity(&"spatial_smoke_perceptible"))

	_registry = GodotSceneSpatialRegistry.new()
	_expect(_registry.bind(_wilson_ref, wilson_spatial_reference), "Wilson binds to explicit spatial query reference")
	_expect(_registry.bind(_target_ref, target), "target binds to explicit RuntimeWorldRef")
	_expect(_registry.bind(_escape_ref, escape_target), "escape target binds to explicit RuntimeWorldRef")
	_expect(_registry.bind(_perceptible_ref, perceptible_spatial_reference), "perceptible binds to explicit spatial query reference")

	_motion = GodotMotionAdapter.new(_registry)
	_expect(_motion.bind_actor(_wilson_ref, wilson, wilson_agent, movement_speed_mps), "GodotMotionAdapter binds Wilson")

	_sensor = GodotPassiveSpatialSensor.new()
	add_child(_sensor)
	_sensor.configure(perception_area)
	_expect(_sensor.bind_candidate(_perceptible_ref, perceptible), "GodotPassiveSpatialSensor binds perceptible")

	_spatial = GodotSpatialQueryAdapter.new(_registry)
	_spatial.navigation_map = wilson_agent.get_navigation_map()
	_spatial.physics_space_state = get_world_3d().direct_space_state
	_passive = PassiveSpatialPerceptionSource.new(
		_sensor,
		_spatial,
		_wilson_ref,
		DomainId.relation_type(&"perceptibly_near"),
		3.1
	)

	_expect(_spatial.navigation_map.is_valid(), "navigation map RID is valid")
	_expect(_spatial.physics_space_state != null, "physics direct space state is available")
	_expect(is_equal_approx(wilson.global_position.y, 0.0), "Wilson navigation origin is aligned to navmesh plane")
	_expect(wilson_spatial_reference.global_position.y > wilson.global_position.y, "Wilson spatial query reference is above navigation origin")


func _prove_collision() -> void:
	_log_stage("COLLISION", "probing CharacterBody3D against the real wall collider")
	wilson.global_position = COLLISION_PROBE_START
	wilson.velocity = Vector3.ZERO
	await _physics_frames(1)
	var hit_wall: bool = false
	for _frame in range(90):
		wilson.velocity = Vector3(4.0, -0.5, 0.0)
		wilson.move_and_slide()
		for index in range(wilson.get_slide_collision_count()):
			var collision: KinematicCollision3D = wilson.get_slide_collision(index)
			if collision.get_collider() == wall:
				hit_wall = true
				break
		if hit_wall:
			break
		await get_tree().physics_frame
	_expect(hit_wall, "CharacterBody3D collides with Wall through move_and_slide")
	wilson.global_position = START_POSITION
	wilson.velocity = Vector3.ZERO
	await _physics_frames(2)


func _prove_navigation() -> void:
	_log_stage("NAVIGATION", "querying the same real navigation map used by GodotMotionAdapter")
	_spatial.navigation_map = wilson_agent.get_navigation_map()
	var path: PackedVector3Array = NavigationServer3D.map_get_path(
		_spatial.navigation_map,
		wilson.global_position,
		target.global_position,
		true
	)
	_expect(not path.is_empty(), "NavigationServer3D returns a route")
	_expect(_spatial.has_route(_wilson_ref, _target_ref), "GodotSpatialQueryAdapter reports route availability")
	var cost: float = _spatial.route_cost(_wilson_ref, _target_ref)
	_expect(is_finite(cost) and cost > 0.0, "GodotSpatialQueryAdapter returns finite positive route cost")
	var detours: bool = false
	for point in path:
		if absf(point.z) >= 0.7:
			detours = true
			break
	_expect(detours, "navigation path contains a meaningful detour around the wall")
	print("[SMOKE][NAVIGATION] path_points=%d route_cost=%.3f detour=%s" % [path.size(), cost, detours])


func _prove_motion_and_passive_perception() -> void:
	wilson.global_position = START_POSITION
	perceptible.global_position = PERCEPTIBLE_ROUTE_POSITION
	target.global_position = TARGET_POSITION
	escape_target.global_position = ESCAPE_POSITION
	wilson.velocity = Vector3.ZERO
	await _physics_frames(2)
	var motion_start: Vector3 = wilson.global_position
	_expect(_motion.request_move(_wilson_ref, _target_ref), "GodotMotionAdapter accepts movement request")
	_expect(_motion.get_status(_wilson_ref) == MotionPort.MotionStatus.MOVING, "motion status becomes MOVING")

	var evidence_count: int = 0
	var max_displacement: float = 0.0
	var terminal_frame: int = -1
	for frame in range(max_motion_frames):
		wilson.velocity.y = -0.5
		_motion.physics_tick(1.0 / 60.0)
		var displacement: float = Vector2(
			wilson.global_position.x - motion_start.x,
			wilson.global_position.z - motion_start.z
		).length()
		max_displacement = maxf(max_displacement, displacement)

		if frame % 60 == 0:
			var next_point: Vector3 = wilson_agent.get_next_path_position()
			print("[SMOKE][MOTION] frame=%d status=%d position=%s next=%s displacement=%.3f path_points=%d candidates=%d dirty=%s" % [
				frame,
				_motion.get_status(_wilson_ref),
				str(wilson.global_position),
				str(next_point),
				displacement,
				wilson_agent.get_current_navigation_path().size(),
				_sensor.active_candidate_count(),
				_sensor.has_pending_refresh(),
			])

		if _motion.get_status(_wilson_ref) == MotionPort.MotionStatus.MOVING and _sensor.has_pending_refresh():
			var perception = _passive.collect()
			if not perception.diagnostics.is_empty():
				print("[SMOKE][PERCEPTION] diagnostics=%s" % str(perception.diagnostics))
			if not perception.evidence.is_empty():
				evidence_count += perception.evidence.size()
				_observed_passive_while_moving = true
				print("[SMOKE][PERCEPTION] frame=%d evidence=%d candidate_count=%d" % [frame, perception.evidence.size(), _sensor.active_candidate_count()])
				await _checkpoint(&"PASSIVE_WHILE_MOVING", {
					"instruction": "Wilson is still MOVING and real Area3D broadphase produced visible evidence. Capture now; press Space to continue.",
					"frame": frame,
					"wilson": wilson.global_position,
					"candidate_count": _sensor.active_candidate_count(),
					"evidence_count": perception.evidence.size(),
				})

		var status: int = _motion.get_status(_wilson_ref)
		if status == MotionPort.MotionStatus.ARRIVED or status == MotionPort.MotionStatus.BLOCKED or status == MotionPort.MotionStatus.ROUTE_INVALID:
			terminal_frame = frame
			break
		await get_tree().physics_frame

	var final_status: int = _motion.get_status(_wilson_ref)
	var arrived: bool = final_status == MotionPort.MotionStatus.ARRIVED
	_expect(max_displacement > 10.0, "GodotMotionAdapter physically moves Wilson across the fixture")
	_expect(_observed_passive_while_moving, "real Area3D candidate becomes evidence while Wilson remains MOVING")
	_expect(evidence_count > 0, "PassiveSpatialPerceptionSource emits positive evidence")
	_expect(arrived, "GodotMotionAdapter reaches ARRIVED")
	print("[SMOKE][MOTION] terminal_frame=%d final_status=%d final_position=%s max_displacement=%.3f evidence=%d" % [
		terminal_frame,
		final_status,
		str(wilson.global_position),
		max_displacement,
		evidence_count,
	])

	if arrived:
		await _checkpoint(&"ARRIVED", {
			"instruction": "Wilson arrived through GodotMotionAdapter. Capture final route position; press Space to continue.",
			"wilson": wilson.global_position,
			"target": target.global_position,
			"displacement": max_displacement,
		})
	else:
		await _checkpoint(&"MOTION_FAILED", {
			"instruction": "Motion terminated without ARRIVED. Capture Wilson, path overlay and console before continuing.",
			"wilson": wilson.global_position,
			"target": target.global_position,
			"motion_status": final_status,
			"displacement": max_displacement,
			"path_points": wilson_agent.get_current_navigation_path().size(),
		})


func _prove_threat_motion_interruption() -> void:
	_log_stage("THREAT_REDIRECT", "redirecting an already-selected defensive intention through real Godot motion")
	wilson.global_position = START_POSITION
	wilson.velocity = Vector3.ZERO
	target.global_position = TARGET_POSITION
	escape_target.global_position = ESCAPE_POSITION
	perceptible.global_position = PERCEPTIBLE_ROUTE_POSITION
	await _physics_frames(2)

	_expect(_spatial.has_route(_wilson_ref, _escape_ref), "authored escape destination has a real navigation route")
	_expect(_motion.request_move(_wilson_ref, _target_ref), "pre-threat movement toward original target starts")
	for _frame in range(45):
		wilson.velocity.y = -0.5
		_motion.physics_tick(1.0 / 60.0)
		await get_tree().physics_frame
	_expect(_motion.get_status(_wilson_ref) == MotionPort.MotionStatus.MOVING, "pre-threat movement is still MOVING before interruption")
	var original_motion_target = _motion.get_target(_wilson_ref)
	_expect(original_motion_target != null and original_motion_target.equals(_target_ref), "pre-threat motion still targets the original destination")

	var distance_before: float = _spatial.metric_distance(_wilson_ref, _perceptible_ref)
	var dodge = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"dodge_threat")
	var bindings = RoleBinding.new()
	bindings.bind(&"threat_source", _perceptible_ref)
	var selected_defense = CurrentIntentionState.new(dodge, bindings, &"real_engine_threat_step")
	var resolver = EscapeDestinationResolver.new(_spatial, [_escape_ref], 0.25)
	var executor = DefensiveMotionExecutionCoordinator.new(_motion, resolver, _wilson_ref, [dodge])
	var execution: Dictionary = executor.apply(selected_defense)
	_observed_threat_redirect = bool(execution.get("redirected", false))
	_expect(_observed_threat_redirect, "selected defensive intention redirects real Godot motion")
	var redirected_target = _motion.get_target(_wilson_ref)
	_expect(redirected_target != null and redirected_target.equals(_escape_ref), "real motion target changes from original target to authored escape target")
	_expect(_motion.get_status(_wilson_ref) == MotionPort.MotionStatus.MOVING, "redirect immediately resumes semantic MOVING state")

	var redirect_start: Vector3 = wilson.global_position
	var terminal_frame: int = -1
	for frame in range(max_motion_frames):
		wilson.velocity.y = -0.5
		_motion.physics_tick(1.0 / 60.0)
		var status: int = _motion.get_status(_wilson_ref)
		if status == MotionPort.MotionStatus.ARRIVED or status == MotionPort.MotionStatus.BLOCKED or status == MotionPort.MotionStatus.ROUTE_INVALID:
			terminal_frame = frame
			break
		await get_tree().physics_frame

	var final_status: int = _motion.get_status(_wilson_ref)
	var distance_after: float = _spatial.metric_distance(_wilson_ref, _perceptible_ref)
	var redirect_displacement: float = Vector2(
		wilson.global_position.x - redirect_start.x,
		wilson.global_position.z - redirect_start.z
	).length()
	_expect(final_status == MotionPort.MotionStatus.ARRIVED, "redirected real motion reaches escape destination")
	_expect(redirect_displacement > 1.0, "redirect produces physical displacement toward escape destination")
	_expect(is_finite(distance_before) and is_finite(distance_after) and distance_after > distance_before, "escape movement increases metric distance from threat source")
	print("[SMOKE][THREAT_REDIRECT] terminal_frame=%d status=%d before_distance=%.3f after_distance=%.3f displacement=%.3f target=%s" % [
		terminal_frame,
		final_status,
		distance_before,
		distance_after,
		redirect_displacement,
		str(escape_target.global_position),
	])
	await _checkpoint(&"THREAT_REDIRECT", {
		"instruction": "A committed defensive intention cancelled the original route and redirected Wilson to the escape target. Capture now; press Space to continue.",
		"wilson": wilson.global_position,
		"escape_target": escape_target.global_position,
		"distance_before": distance_before,
		"distance_after": distance_after,
		"motion_status": final_status,
	})


func _prove_line_of_sight() -> void:
	_log_stage("LOS", "testing clear target hit and wall occlusion through GodotSpatialQueryAdapter")
	wilson.global_position = LOS_CLEAR_WILSON
	perceptible.global_position = LOS_CLEAR_TARGET
	wilson.velocity = Vector3.ZERO
	await _physics_frames(2)
	_spatial.physics_space_state = get_world_3d().direct_space_state
	var clear_los: bool = _spatial.has_line_of_sight(_wilson_ref, _perceptible_ref)
	_expect(clear_los, "GodotSpatialQueryAdapter reports clear LOS when target is unobstructed")
	print("[SMOKE][LOS] clear=%s" % clear_los)

	wilson.global_position = LOS_BLOCKED_WILSON
	perceptible.global_position = LOS_BLOCKED_TARGET
	await _physics_frames(2)
	var blocked_los: bool = not _spatial.has_line_of_sight(_wilson_ref, _perceptible_ref)
	_expect(blocked_los, "GodotSpatialQueryAdapter reports blocked LOS through Wall")
	print("[SMOKE][LOS] blocked_by_wall=%s" % blocked_los)
	await _checkpoint(&"LOS_BLOCKED", {
		"instruction": "Wilson and the orange object are separated by the red wall; adapter reports blocked LOS. Capture now; press Space to finish.",
		"blocked": blocked_los,
	})


func _checkpoint(name: StringName, details: Dictionary) -> void:
	var instruction: String = String(details.get("instruction", "Press Space to continue."))
	status_label.text = "CHECKPOINT: %s\n%s\n\nFailures so far: %d" % [String(name), instruction, _failures.size()]
	print("[SMOKE][CHECKPOINT] %s %s" % [String(name), str(details)])
	checkpoint_reached.emit(name, details)
	if pause_at_checkpoints:
		await continue_requested


func _physics_frames(count: int) -> void:
	for _index in range(count):
		await get_tree().physics_frame


func _expect(condition: bool, message: String) -> void:
	if condition:
		print("[SMOKE][PASS] %s" % message)
		return
	_failures.append(message)
	push_error("[SMOKE][FAIL] %s" % message)


func _log_stage(stage: String, message: String) -> void:
	print("[SMOKE][%s] %s" % [stage, message])


func is_completed() -> bool:
	return _completed


func failures() -> Array[String]:
	return _failures.duplicate()
