extends Node3D

signal checkpoint_reached(name: StringName, details: Dictionary)
signal continue_requested()
signal smoke_finished(success: bool, report: Dictionary)

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const PhysicalObservation = preload("res://src/application/simulation/physical_observation.gd")
const WilsonBodyImpactRule = preload("res://src/application/simulation/wilson_body_impact_rule.gd")
const WilsonBodyImpactConsequenceResolver = preload("res://src/application/simulation/wilson_body_impact_consequence_resolver.gd")
const WilsonBodyState = preload("res://src/domain/world/wilson_body_state.gd")
const PerceptionAccess = preload("res://src/domain/cognition/perception_access.gd")
const PerceptionService = preload("res://src/domain/cognition/perception_service.gd")
const ExperienceLearningRule = preload("res://src/domain/cognition/experience_learning_rule.gd")
const ExperienceLearningService = preload("res://src/domain/cognition/experience_learning_service.gd")
const AssociationStore = preload("res://src/domain/cognition/association_store.gd")
const RememberedRouteOption = preload("res://src/application/simulation/remembered_route_option.gd")
const RememberedRoutePreferenceService = preload("res://src/application/simulation/remembered_route_preference_service.gd")
const RememberedRouteMotionCoordinator = preload("res://src/application/simulation/remembered_route_motion_coordinator.gd")
const GodotSceneSpatialRegistry = preload("res://src/infrastructure/spatial/godot_scene_spatial_registry.gd")
const GodotPhysicalObservationBuffer = preload("res://src/infrastructure/spatial/godot_physical_observation_buffer.gd")
const GodotDynamicContactObserver = preload("res://src/infrastructure/spatial/godot_dynamic_contact_observer.gd")
const GodotSpatialQueryAdapter = preload("res://src/infrastructure/spatial/godot_spatial_query_adapter.gd")
const GodotMotionAdapter = preload("res://src/infrastructure/spatial/godot_motion_adapter.gd")

const SCENARIO_NAME := &"post_accident_learning"
const MAX_CONTACT_TICKS := 240
const MAX_NAVIGATION_SYNC_FRAMES := 120
const MAX_MOTION_FRAMES := 900

var _registry
var _buffer
var _observer
var _body_state
var _body_resolver
var _associations
var _wilson_ref
var _palm_ref
var _goal_ref
var _detour_a_ref
var _detour_b_ref
var _short_route
var _long_route
var _preference
var _motion
var _coordinator
var _contact_ticks := 0
var _motion_frames := 0
var _route_started := false
var _reported_detour_a := false
var _reported_detour_b := false
var _finished := false
var _learned_valence := 0.0


func _ready() -> void:
	call_deferred("_bootstrap")


func _physics_process(delta: float) -> void:
	if _finished:
		return
	if not _route_started:
		_contact_ticks += 1
		if _buffer != null and _buffer.pending_count() > 0:
			_resolve_contact_and_learn()
			return
		if _contact_ticks > MAX_CONTACT_TICKS:
			_fail("falling palm did not contact Wilson within bounded physics ticks")
		return

	_motion.physics_tick(delta)
	_motion_frames += 1
	if _motion_frames > MAX_MOTION_FRAMES:
		_fail("post-accident remembered route did not complete within bounded physics frames")
		return
	var status: int = _motion.get_status(_wilson_ref)
	if status == GodotMotionAdapter.MotionStatus.ROUTE_INVALID or status == GodotMotionAdapter.MotionStatus.BLOCKED:
		_fail("post-accident remembered route became invalid or blocked")
		return
	if status != GodotMotionAdapter.MotionStatus.ARRIVED:
		return
	var target = _motion.get_target(_wilson_ref)
	if target != null and target.equals(_detour_a_ref) and not _reported_detour_a:
		_reported_detour_a = true
		checkpoint_reached.emit(&"DETOUR_ENTERED", _probes())
	elif target != null and target.equals(_detour_b_ref) and not _reported_detour_b:
		_reported_detour_b = true
		checkpoint_reached.emit(&"DETOUR_CROSSED", _probes())
	var progression = _coordinator.apply([_short_route, _long_route])
	if not bool(progression.get("ok", false)):
		_fail("remembered route progression failed: %s" % String(progression.get("reason", &"unknown")))
		return
	if progression.get("reason") == &"route_complete":
		checkpoint_reached.emit(&"ARRIVED", _probes())
		_complete()


func _bootstrap() -> void:
	for _frame in range(3):
		await get_tree().physics_frame
	_wilson_ref = RuntimeWorldRef.wilson()
	_palm_ref = RuntimeWorldRef.entity(DomainId.entity(&"falling_palm_17"))
	_goal_ref = RuntimeWorldRef.place(DomainId.place(&"goal"))
	_detour_a_ref = RuntimeWorldRef.place(DomainId.place(&"detour_a"))
	_detour_b_ref = RuntimeWorldRef.place(DomainId.place(&"detour_b"))
	_registry = GodotSceneSpatialRegistry.new()
	_buffer = GodotPhysicalObservationBuffer.new()
	_observer = GodotDynamicContactObserver.new(_registry, _buffer)
	_body_state = WilsonBodyState.new(1.0)
	_associations = AssociationStore.new()
	if not _registry.bind(_wilson_ref, $Wilson):
		_fail("Wilson semantic binding failed")
		return
	if not _registry.bind(_palm_ref, $FallingPalm):
		_fail("palm semantic binding failed")
		return
	if not _registry.bind(_goal_ref, $Goal) or not _registry.bind(_detour_a_ref, $DetourA) or not _registry.bind(_detour_b_ref, $DetourB):
		_fail("route semantic binding failed")
		return
	if not _observer.bind_body($FallingPalm):
		_fail("contact observer failed to bind palm")
		return
	_body_resolver = WilsonBodyImpactConsequenceResolver.new(
		_wilson_ref,
		_body_state,
		DomainId.property(&"vitality"),
		[WilsonBodyImpactRule.new(
			PhysicalObservation.Kind.CONTACT,
			0.0,
			0.25,
			DomainId.event_definition(&"wilson_injured_by_impact"),
			DomainId.event_definition(&"wilson_killed_by_impact"),
			true
		)]
	)
	checkpoint_reached.emit(&"BOOTSTRAPPED", _probes())


func _resolve_contact_and_learn() -> void:
	var observations = _buffer.drain_observations()
	var contact = null
	for observation in observations:
		if observation != null and observation.kind == PhysicalObservation.Kind.CONTACT and observation.subject != null and observation.subject.equals(_wilson_ref):
			contact = observation
			break
	if contact == null:
		return
	checkpoint_reached.emit(&"ACCIDENT_OBSERVED", _probes())
	var body = _body_resolver.resolve_result([contact], &"post_accident_body")
	if body.events.size() != 1 or not is_equal_approx(_body_state.vitality, 0.75):
		_fail("grounded accident did not produce one injury event and expected vitality")
		return
	checkpoint_reached.emit(&"BODY_DAMAGED", _probes())
	var injury_event = body.events[0]
	var perception = PerceptionService.new().perceive(
		[injury_event],
		{injury_event.execution_id: PerceptionAccess.new(true, [&"pain"], [&"subject", &"other"], 1.0)}
	)
	var learning = ExperienceLearningService.new([
		ExperienceLearningRule.new(injury_event.event_type, &"other", -0.85, 0.0, 0.9)
	])
	for evidence in perception.evidence:
		var proposals: Dictionary = learning.derive(evidence)
		for impact in proposals["association_impacts"]:
			_associations.apply_impact(impact)
	var association = _associations.get_association(_palm_ref)
	if association == null or float(association.valence) > -0.80:
		_fail("perceived injury did not create strong remembered palm aversion")
		return
	_learned_valence = float(association.valence)
	checkpoint_reached.emit(&"ACCIDENT_LEARNED", _probes())
	await _stage_later_revisit_and_start_route()


func _stage_later_revisit_and_start_route() -> void:
	_observer.unbind_body($FallingPalm)
	$FallingPalm.freeze = true
	$FallingPalm.collision_layer = 0
	$FallingPalm.collision_mask = 0
	$FallingPalm.global_position = $PalmLaterPosition.global_position
	$Wilson.global_position = $RevisitStart.global_position
	$Wilson.velocity = Vector3.ZERO
	await get_tree().physics_frame

	_motion = GodotMotionAdapter.new(_registry)
	if not _motion.bind_actor(_wilson_ref, $Wilson, $Wilson/NavigationAgent3D, 3.0):
		_fail("Godot motion adapter rejected Wilson binding")
		return
	var spatial = GodotSpatialQueryAdapter.new(_registry)
	var navigation_map: RID = $Wilson/NavigationAgent3D.get_navigation_map()
	var ready := false
	for _frame in range(MAX_NAVIGATION_SYNC_FRAMES):
		navigation_map = $Wilson/NavigationAgent3D.get_navigation_map()
		if navigation_map.is_valid() and NavigationServer3D.map_get_iteration_id(navigation_map) > 0:
			ready = true
			break
		await get_tree().physics_frame
	if not ready:
		_fail("navigation map did not synchronize for post-accident revisit")
		return
	for _frame in range(2):
		await get_tree().physics_frame
	spatial.navigation_map = navigation_map
	_short_route = RememberedRouteOption.new(&"under_palm", [_goal_ref], [_palm_ref])
	_long_route = RememberedRouteOption.new(&"around_palm", [_detour_a_ref, _detour_b_ref, _goal_ref])
	_preference = RememberedRoutePreferenceService.new(spatial, _associations, 1.0)
	var short_eval = _preference.evaluate(_wilson_ref, _short_route)
	var long_eval = _preference.evaluate(_wilson_ref, _long_route)
	var selected = _preference.choose(_wilson_ref, [_short_route, _long_route])
	if selected == null or selected.id != &"around_palm":
		_fail("learned accident aversion did not select the longer route")
		return
	if float(short_eval.physical_cost) >= float(long_eval.physical_cost):
		_fail("short route must remain physically cheaper after learning")
		return
	checkpoint_reached.emit(&"LONG_ROUTE_SELECTED", {
		"route": String(selected.id),
		"learned_valence": _learned_valence,
		"short_physical_cost": float(short_eval.physical_cost),
		"long_physical_cost": float(long_eval.physical_cost),
		"short_adjusted_cost": float(short_eval.adjusted_cost),
		"long_adjusted_cost": float(long_eval.adjusted_cost),
	})
	_coordinator = RememberedRouteMotionCoordinator.new(_motion, _preference, _wilson_ref)
	var start = _coordinator.apply([_short_route, _long_route])
	if not bool(start.get("ok", false)) or start.get("reason") != &"move_requested":
		_fail("learned preferred route did not start through MotionPort")
		return
	_route_started = true


func _probes() -> Dictionary:
	var target = null if _motion == null else _motion.get_target(_wilson_ref)
	return {
		"scenario": String(SCENARIO_NAME),
		"vitality": 1.0 if _body_state == null else _body_state.vitality,
		"learned_valence": _learned_valence,
		"wilson_position": [$Wilson.global_position.x, $Wilson.global_position.y, $Wilson.global_position.z],
		"palm_position": [$FallingPalm.global_position.x, $FallingPalm.global_position.y, $FallingPalm.global_position.z],
		"motion_target": "" if target == null else String(target.key()),
	}


func _complete() -> void:
	if _finished:
		return
	_finished = true
	checkpoint_reached.emit(&"COMPLETE", _probes())
	smoke_finished.emit(true, {"scenario": String(SCENARIO_NAME), "final": _probes()})


func _fail(message: String) -> void:
	if _finished:
		return
	_finished = true
	smoke_finished.emit(false, {"scenario": String(SCENARIO_NAME), "failures": [message], "final": _probes()})
