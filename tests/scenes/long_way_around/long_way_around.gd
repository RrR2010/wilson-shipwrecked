extends Node3D

signal checkpoint_reached(name: StringName, details: Dictionary)
signal continue_requested()
signal smoke_finished(success: bool, report: Dictionary)

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const AssociationBootstrapSeed = preload("res://src/application/bootstrap/association_bootstrap_seed.gd")
const SimulationBootstrapDefinition = preload("res://src/application/bootstrap/simulation_bootstrap_definition.gd")
const SimulationOwnerBootstrapper = preload("res://src/application/bootstrap/simulation_owner_bootstrapper.gd")
const RememberedRouteOption = preload("res://src/application/simulation/remembered_route_option.gd")
const RememberedRoutePreferenceService = preload("res://src/application/simulation/remembered_route_preference_service.gd")
const RememberedRouteMotionCoordinator = preload("res://src/application/simulation/remembered_route_motion_coordinator.gd")
const GodotSceneSpatialRegistry = preload("res://src/infrastructure/spatial/godot_scene_spatial_registry.gd")
const GodotSpatialQueryAdapter = preload("res://src/infrastructure/spatial/godot_spatial_query_adapter.gd")
const GodotMotionAdapter = preload("res://src/infrastructure/spatial/godot_motion_adapter.gd")

const SCENARIO_NAME := &"long_way_around"
const MAX_NAVIGATION_SYNC_FRAMES := 120
const MAX_MOTION_FRAMES := 900

var _wilson_ref
var _goal_ref
var _detour_a_ref
var _detour_b_ref
var _danger_subject
var _short_route
var _long_route
var _motion
var _coordinator
var _route_started := false
var _reported_detour_a := false
var _reported_detour_b := false
var _motion_frames := 0
var _finished := false


func _ready() -> void:
	call_deferred("_bootstrap_and_start")


func _physics_process(delta: float) -> void:
	if _finished or not _route_started or _motion == null:
		return

	_motion.physics_tick(delta)
	_motion_frames += 1
	if _motion_frames > MAX_MOTION_FRAMES:
		_fail("Wilson did not complete remembered route within bounded physics frames")
		return

	var status: int = _motion.get_status(_wilson_ref)
	if status == GodotMotionAdapter.MotionStatus.ROUTE_INVALID:
		_fail("Remembered route became invalid")
		return
	if status == GodotMotionAdapter.MotionStatus.BLOCKED:
		_fail("Remembered route became blocked")
		return

	if status != GodotMotionAdapter.MotionStatus.ARRIVED:
		return

	var current_target = _motion.get_target(_wilson_ref)
	if current_target != null and current_target.equals(_detour_a_ref) and not _reported_detour_a:
		_reported_detour_a = true
		checkpoint_reached.emit(&"DETOUR_ENTERED", _probes())
	elif current_target != null and current_target.equals(_detour_b_ref) and not _reported_detour_b:
		_reported_detour_b = true
		checkpoint_reached.emit(&"DETOUR_CROSSED", _probes())

	var progression = _coordinator.apply([_short_route, _long_route])
	if not bool(progression.get("ok", false)):
		_fail("Remembered route coordinator failed: %s" % String(progression.get("reason", &"unknown")))
		return
	if progression.get("reason") == &"route_complete":
		checkpoint_reached.emit(&"ARRIVED", _probes())
		_complete()


func _bootstrap_and_start() -> void:
	var island = DomainId.place(&"route_memory_island")
	_danger_subject = DomainId.place(&"rocky_pass")
	var definition = SimulationBootstrapDefinition.new(
		island,
		[],
		[],
		[],
		null,
		1.0,
		{},
		[],
		[AssociationBootstrapSeed.new(_danger_subject, -0.95, 0.0, 3, &"past_route_accident")]
	)
	var boot = SimulationOwnerBootstrapper.new().bootstrap(definition)
	if not boot.ok:
		_fail("Owner bootstrap failed: %s %s" % [String(boot.code), str(boot.diagnostics)])
		return

	_wilson_ref = RuntimeWorldRef.wilson()
	_goal_ref = RuntimeWorldRef.place(DomainId.place(&"goal"))
	_detour_a_ref = RuntimeWorldRef.place(DomainId.place(&"detour_a"))
	_detour_b_ref = RuntimeWorldRef.place(DomainId.place(&"detour_b"))

	var registry = GodotSceneSpatialRegistry.new()
	if not registry.bind(_wilson_ref, $Wilson):
		_fail("Failed to bind Wilson runtime ref")
		return
	if not registry.bind(_goal_ref, $Goal):
		_fail("Failed to bind goal runtime ref")
		return
	if not registry.bind(_detour_a_ref, $DetourA):
		_fail("Failed to bind first detour runtime ref")
		return
	if not registry.bind(_detour_b_ref, $DetourB):
		_fail("Failed to bind second detour runtime ref")
		return

	_motion = GodotMotionAdapter.new(registry)
	if not _motion.bind_actor(_wilson_ref, $Wilson, $Wilson/NavigationAgent3D, 3.0):
		_fail("Godot motion adapter rejected Wilson binding")
		return

	var spatial = GodotSpatialQueryAdapter.new(registry)
	var navigation_ready := false
	for _frame in range(MAX_NAVIGATION_SYNC_FRAMES):
		await get_tree().physics_frame
		var navigation_map: RID = $Wilson/NavigationAgent3D.get_navigation_map()
		if navigation_map.is_valid() and NavigationServer3D.map_get_iteration_id(navigation_map) > 0:
			spatial.navigation_map = navigation_map
			navigation_ready = true
			break
	if not navigation_ready:
		_fail("Navigation map did not synchronize within bounded physics frames")
		return

	_short_route = RememberedRouteOption.new(&"short", [_goal_ref], [_danger_subject])
	_long_route = RememberedRouteOption.new(&"long", [_detour_a_ref, _detour_b_ref, _goal_ref])
	var preference = RememberedRoutePreferenceService.new(spatial, boot.owners.associations, 1.0)
	var direct_eval = preference.evaluate(_wilson_ref, _short_route)
	var detour_eval = preference.evaluate(_wilson_ref, _long_route)
	var selected = preference.choose(_wilson_ref, [_short_route, _long_route])
	if selected == null:
		_fail("No viable route was selected")
		return
	if selected.id != &"long":
		_fail("Remembered aversion did not select the long route")
		return
	if not bool(direct_eval.get("viable", false)):
		_fail("Short route must remain physically viable")
		return
	if float(direct_eval.get("physical_cost", INF)) >= float(detour_eval.get("physical_cost", INF)):
		_fail("Short route must be physically cheaper than detour")
		return

	checkpoint_reached.emit(&"BOOTSTRAPPED", {
		"scenario": String(SCENARIO_NAME),
		"remembered_valence": float(boot.owners.associations.get_association(_danger_subject).get("valence", 0.0)),
		"short_physical_cost": float(direct_eval.get("physical_cost", INF)),
		"long_physical_cost": float(detour_eval.get("physical_cost", INF)),
	})
	checkpoint_reached.emit(&"LONG_ROUTE_SELECTED", {
		"route": String(selected.id),
		"short_adjusted_cost": float(direct_eval.get("adjusted_cost", INF)),
		"long_adjusted_cost": float(detour_eval.get("adjusted_cost", INF)),
	})

	_coordinator = RememberedRouteMotionCoordinator.new(_motion, preference, _wilson_ref)
	var start = _coordinator.apply([_short_route, _long_route])
	if not bool(start.get("ok", false)) or start.get("reason") != &"move_requested":
		_fail("Preferred route did not start through MotionPort")
		return
	_route_started = true


func _probes() -> Dictionary:
	var body: CharacterBody3D = $Wilson
	var target = null if _motion == null else _motion.get_target(_wilson_ref)
	return {
		"position": [body.global_position.x, body.global_position.y, body.global_position.z],
		"motion_status": -1 if _motion == null else _motion.get_status(_wilson_ref),
		"motion_target": "" if target == null else String(target.key()),
	}


func _complete() -> void:
	if _finished:
		return
	_finished = true
	checkpoint_reached.emit(&"COMPLETE", _probes())
	smoke_finished.emit(true, {
		"scenario": String(SCENARIO_NAME),
		"final_position": _probes().get("position"),
	})


func _fail(message: String) -> void:
	if _finished:
		return
	_finished = true
	smoke_finished.emit(false, {"failures": [message], "scenario": String(SCENARIO_NAME)})