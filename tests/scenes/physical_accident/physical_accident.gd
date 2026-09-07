extends Node3D

signal checkpoint_reached(name: StringName, details: Dictionary)
signal continue_requested()
signal smoke_finished(success: bool, report: Dictionary)

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const PhysicalObservation = preload("res://src/application/simulation/physical_observation.gd")
const PhysicalObservationConsequenceRule = preload("res://src/application/simulation/physical_observation_consequence_rule.gd")
const PhysicalObservationConsequenceResolver = preload("res://src/application/simulation/physical_observation_consequence_resolver.gd")
const WilsonBodyImpactRule = preload("res://src/application/simulation/wilson_body_impact_rule.gd")
const WilsonBodyImpactConsequenceResolver = preload("res://src/application/simulation/wilson_body_impact_consequence_resolver.gd")
const WilsonBodyState = preload("res://src/domain/world/wilson_body_state.gd")
const GodotSceneSpatialRegistry = preload("res://src/infrastructure/spatial/godot_scene_spatial_registry.gd")
const GodotPhysicalObservationBuffer = preload("res://src/infrastructure/spatial/godot_physical_observation_buffer.gd")
const GodotDynamicContactObserver = preload("res://src/infrastructure/spatial/godot_dynamic_contact_observer.gd")

const SCENARIO_NAME := &"physical_accident"
const MAX_PHYSICS_TICKS := 240

var _registry
var _buffer
var _observer
var _body_state
var _semantic_resolver
var _body_resolver
var _wilson_ref
var _palm_ref
var _ticks := 0
var _finished := false
var _contact_magnitude := 0.0
var _semantic_event_count := 0
var _body_event_count := 0


func _ready() -> void:
	_wilson_ref = RuntimeWorldRef.wilson()
	_palm_ref = RuntimeWorldRef.entity(DomainId.entity(&"falling_palm_17"))
	_registry = GodotSceneSpatialRegistry.new()
	_buffer = GodotPhysicalObservationBuffer.new()
	_observer = GodotDynamicContactObserver.new(_registry, _buffer)
	_body_state = WilsonBodyState.new(1.0)

	if not _registry.bind(_wilson_ref, $Wilson):
		_fail("Wilson semantic binding failed")
		return
	if not _registry.bind(_palm_ref, $FallingPalm):
		_fail("falling palm semantic binding failed")
		return
	if not _observer.bind_body($FallingPalm):
		_fail("dynamic contact observer failed to bind falling palm")
		return

	var contact_event = DomainId.event_definition(&"dynamic_body_contact")
	_semantic_resolver = PhysicalObservationConsequenceResolver.new([
		PhysicalObservationConsequenceRule.new(
			PhysicalObservation.Kind.CONTACT,
			contact_event,
			0.0,
			&"impacted",
			&"source",
			true
		)
	])

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

	checkpoint_reached.emit(&"BOOTSTRAPPED", _probes())


func _physics_process(_delta: float) -> void:
	if _finished:
		return
	_ticks += 1
	if _buffer.pending_count() > 0:
		_resolve_contact_batch()
		return
	if _ticks >= MAX_PHYSICS_TICKS:
		_fail("falling palm produced no semantic contact observation within bounded physics ticks")


func _resolve_contact_batch() -> void:
	var observations = _buffer.drain_observations()
	var wilson_contacts: Array = []
	for observation in observations:
		if observation == null:
			continue
		if observation.kind != PhysicalObservation.Kind.CONTACT:
			continue
		if observation.subject != null and observation.subject.equals(_wilson_ref):
			wilson_contacts.append(observation)

	if wilson_contacts.is_empty():
		return

	var contact = wilson_contacts[0]
	if contact.other == null or not contact.other.equals(_palm_ref):
		_fail("contact observation did not preserve falling-palm semantic source")
		return
	_contact_magnitude = float(contact.magnitude)
	checkpoint_reached.emit(&"CONTACT_OBSERVED", _probes())

	var semantic = _semantic_resolver.resolve_result([contact], &"physical_accident_semantic")
	_semantic_event_count = semantic.events.size()
	if _semantic_event_count != 1:
		_fail("authored physical observation rule did not admit exactly one semantic event")
		return
	var semantic_event = semantic.events[0]
	if not semantic_event.event_type.equals(DomainId.event_definition(&"dynamic_body_contact")):
		_fail("admitted semantic event type does not match authored contact event")
		return
	checkpoint_reached.emit(&"EVENT_ADMITTED", _probes())

	var body = _body_resolver.resolve_result([contact], &"physical_accident_body")
	_body_event_count = body.events.size()
	if _body_event_count != 1:
		_fail("authored Wilson body impact rule did not emit exactly one body event")
		return
	if not is_equal_approx(_body_state.vitality, 0.75):
		_fail("grounded body consequence did not reduce Wilson vitality to 0.75")
		return
	if body.changes == null or body.changes.is_empty():
		_fail("body consequence did not expose vitality semantic change")
		return
	checkpoint_reached.emit(&"BODY_DAMAGED", _probes())
	_complete()


func _probes() -> Dictionary:
	return {
		"scenario": String(SCENARIO_NAME),
		"physics_ticks": _ticks,
		"palm_y": $FallingPalm.global_position.y,
		"contact_magnitude": _contact_magnitude,
		"semantic_event_count": _semantic_event_count,
		"body_event_count": _body_event_count,
		"vitality": 1.0 if _body_state == null else _body_state.vitality,
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
