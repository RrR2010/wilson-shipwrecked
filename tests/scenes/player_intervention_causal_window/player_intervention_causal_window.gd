extends Node3D

signal checkpoint_reached(name: StringName, details: Dictionary)
signal continue_requested()
signal smoke_finished(success: bool, report: Dictionary)

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const MutationResult = preload("res://src/domain/core/mutation_result.gd")
const PhysicalObservation = preload("res://src/application/simulation/physical_observation.gd")
const WilsonBodyImpactRule = preload("res://src/application/simulation/wilson_body_impact_rule.gd")
const WilsonBodyImpactConsequenceResolver = preload("res://src/application/simulation/wilson_body_impact_consequence_resolver.gd")
const PlayerInterventionService = preload("res://src/application/simulation/player_intervention_service.gd")
const InterventionDefinition = preload("res://src/domain/player/intervention_definition.gd")
const PhysicalInterventionRequest = preload("res://src/domain/player/physical_intervention_request.gd")
const PlayerRunState = preload("res://src/domain/player/player_run_state.gd")
const WilsonBodyState = preload("res://src/domain/world/wilson_body_state.gd")
const GodotSceneSpatialRegistry = preload("res://src/infrastructure/spatial/godot_scene_spatial_registry.gd")
const GodotPhysicalObservationBuffer = preload("res://src/infrastructure/spatial/godot_physical_observation_buffer.gd")
const GodotDynamicContactObserver = preload("res://src/infrastructure/spatial/godot_dynamic_contact_observer.gd")

const MAX_PHYSICS_TICKS := 420
const INTERVENTION_ID := &"deflect_small_dynamic_body"

class FixtureWorldInterventionPort:
	extends RefCounted
	var registry
	var calls := 0

	func _init(p_registry) -> void:
		registry = p_registry

	func apply_intervention(request):
		calls += 1
		var target_ref = request.payload.get("target_ref")
		var impulse = request.payload.get("impulse")
		if target_ref == null or not (impulse is Vector3):
			return MutationResult.failure(&"invalid_fixture_intervention", [])
		var node = registry.resolve(target_ref)
		if not (node is RigidBody3D):
			return MutationResult.failure(&"target_not_dynamic_body", [])
		node.apply_central_impulse(impulse)
		return MutationResult.success(&"future_motion_changed", {"target_ref": target_ref})

var _registry
var _buffer
var _observer
var _body_state
var _body_resolver
var _player_state
var _intervention
var _world_port
var _wilson_ref
var _early_ref
var _late_ref
var _ticks := 0
var _phase := &"early_fall"
var _early_intervened := false
var _early_avoided := false
var _late_contact_count := 0
var _injury_event_count := 0
var _late_intervened := false
var _post_damage_ticks := 0
var _finished := false


func _ready() -> void:
	_wilson_ref = RuntimeWorldRef.wilson()
	_early_ref = RuntimeWorldRef.entity(DomainId.entity(&"early_falling_palm"))
	_late_ref = RuntimeWorldRef.entity(DomainId.entity(&"late_falling_palm"))
	_registry = GodotSceneSpatialRegistry.new()
	_buffer = GodotPhysicalObservationBuffer.new()
	_observer = GodotDynamicContactObserver.new(_registry, _buffer)
	_body_state = WilsonBodyState.new(1.0)

	if not _registry.bind(_wilson_ref, $Wilson):
		_fail("Wilson semantic binding failed")
		return
	if not _registry.bind(_early_ref, $EarlyPalm) or not _registry.bind(_late_ref, $LatePalm):
		_fail("Palm semantic binding failed")
		return
	if not _observer.bind_body($EarlyPalm) or not _observer.bind_body($LatePalm):
		_fail("Dynamic contact observer binding failed")
		return

	_body_resolver = WilsonBodyImpactConsequenceResolver.new(
		_wilson_ref,
		_body_state,
		DomainId.property(&"vitality"),
		[
			WilsonBodyImpactRule.new(
				PhysicalObservation.Kind.CONTACT,
				0.0,
				0.25,
				DomainId.event_definition(&"wilson_injured_by_impact"),
				DomainId.event_definition(&"wilson_killed_by_impact"),
				true
			)
		]
	)

	_player_state = PlayerRunState.new(10.0, [INTERVENTION_ID])
	_world_port = FixtureWorldInterventionPort.new(_registry)
	_intervention = PlayerInterventionService.new(
		_player_state,
		_world_port,
		[InterventionDefinition.new(INTERVENTION_ID, INTERVENTION_ID, 2.0)]
	)
	checkpoint_reached.emit(&"BOOTSTRAPPED", _probes())


func _physics_process(_delta: float) -> void:
	if _finished:
		return
	_ticks += 1
	if _ticks > MAX_PHYSICS_TICKS:
		_fail("Causal-window scenario exceeded bounded physics ticks")
		return

	_drain_contacts()
	if _finished:
		return

	match _phase:
		&"early_fall":
			_advance_early_window()
		&"late_fall":
			pass
		&"post_damage":
			_advance_post_damage()


func _advance_early_window() -> void:
	if not _early_intervened and _ticks >= 6:
		var result = _intervention.apply(PhysicalInterventionRequest.new(
			INTERVENTION_ID,
			{"target_ref": _early_ref, "impulse": Vector3(24.0, 0.0, 0.0)}
		))
		if result == null or not result.ok:
			_fail("Early player intervention was not committed")
			return
		_early_intervened = true
		checkpoint_reached.emit(&"EARLY_INTERVENTION_COMMITTED", _probes())

	if _early_intervened and $EarlyPalm.global_position.x > 2.5 and $EarlyPalm.global_position.y < 2.5:
		if not is_equal_approx(_body_state.vitality, 1.0):
			_fail("Early intervention did not prevent Wilson injury")
			return
		_early_avoided = true
		$EarlyPalm.freeze = true
		$LatePalm.freeze = false
		_phase = &"late_fall"
		checkpoint_reached.emit(&"EARLY_COLLISION_AVOIDED", _probes())


func _drain_contacts() -> void:
	if _buffer.pending_count() == 0:
		return
	var observations = _buffer.drain_observations()
	for observation in observations:
		if observation == null or observation.kind != PhysicalObservation.Kind.CONTACT:
			continue
		if observation.subject == null or not observation.subject.equals(_wilson_ref):
			continue
		if observation.other != null and observation.other.equals(_early_ref):
			_fail("Early deflected palm still contacted Wilson")
			return
		if observation.other == null or not observation.other.equals(_late_ref):
			continue
		_late_contact_count += 1
		if _phase != &"late_fall":
			continue
		var body = _body_resolver.resolve_result([observation], &"late_palm_contact")
		_injury_event_count += body.events.size()
		if body.events.size() != 1 or not is_equal_approx(_body_state.vitality, 0.75):
			_fail("Late contact did not ground exactly one Wilson injury")
			return
		checkpoint_reached.emit(&"LATE_COLLISION_COMMITTED", _probes())

		var result = _intervention.apply(PhysicalInterventionRequest.new(
			INTERVENTION_ID,
			{"target_ref": _late_ref, "impulse": Vector3(-24.0, 4.0, 0.0)}
		))
		if result == null or not result.ok:
			_fail("Post-collision future-motion intervention should still be allowed")
			return
		_late_intervened = true
		_phase = &"post_damage"
		checkpoint_reached.emit(&"LATE_INTERVENTION_COMMITTED", _probes())


func _advance_post_damage() -> void:
	_post_damage_ticks += 1
	if _post_damage_ticks < 8:
		return
	if not _late_intervened:
		_fail("Late intervention marker was lost")
		return
	if not is_equal_approx(_body_state.vitality, 0.75):
		_fail("Late intervention retroactively changed committed injury")
		return
	if _injury_event_count != 1:
		_fail("Late intervention changed committed injury event history")
		return
	checkpoint_reached.emit(&"COMMITTED_INJURY_PRESERVED", _probes())
	_complete()


func _probes() -> Dictionary:
	return {
		"physics_ticks": _ticks,
		"phase": String(_phase),
		"early_intervened": _early_intervened,
		"early_avoided": _early_avoided,
		"early_x": $EarlyPalm.global_position.x,
		"late_x": $LatePalm.global_position.x,
		"late_contact_count": _late_contact_count,
		"injury_event_count": _injury_event_count,
		"vitality": 1.0 if _body_state == null else _body_state.vitality,
		"god_power": 0.0 if _player_state == null else _player_state.god_power,
		"world_intervention_calls": 0 if _world_port == null else _world_port.calls,
	}


func _complete() -> void:
	_finished = true
	checkpoint_reached.emit(&"COMPLETE", _probes())
	smoke_finished.emit(true, {"final": _probes()})


func _fail(message: String) -> void:
	if _finished:
		return
	_finished = true
	smoke_finished.emit(false, {"failures": [message], "final": _probes()})
