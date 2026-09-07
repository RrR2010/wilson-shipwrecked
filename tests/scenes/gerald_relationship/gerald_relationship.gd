extends Node3D

signal checkpoint_reached(name: StringName, details: Dictionary)
signal continue_requested()
signal smoke_finished(success: bool, report: Dictionary)

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const EntityBootstrapSeed = preload("res://src/application/bootstrap/entity_bootstrap_seed.gd")
const ActorStateBootstrapSeed = preload("res://src/application/bootstrap/actor_state_bootstrap_seed.gd")
const SimulationBootstrapDefinition = preload("res://src/application/bootstrap/simulation_bootstrap_definition.gd")
const SimulationOwnerBootstrapper = preload("res://src/application/bootstrap/simulation_owner_bootstrapper.gd")
const ActorProfileDefinition = preload("res://src/domain/actors/actor_profile_definition.gd")
const ActorBehaviorRule = preload("res://src/domain/actors/actor_behavior_rule.gd")
const ActorRelationshipImpact = preload("res://src/domain/actors/actor_relationship_impact.gd")
const ShallowActorAdvanceService = preload("res://src/domain/actors/shallow_actor_advance_service.gd")

const SCENARIO_NAME := &"gerald_relationship"

var _gerald_id
var _gerald_ref
var _wilson_ref
var _camp
var _near_wilson
var _owners
var _service
var _finished := false


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	_camp = DomainId.place(&"gerald_camp")
	_near_wilson = DomainId.place(&"near_wilson")
	_gerald_id = DomainId.entity(&"gerald")
	_gerald_ref = RuntimeWorldRef.entity(_gerald_id)
	_wilson_ref = RuntimeWorldRef.wilson()

	var definition = SimulationBootstrapDefinition.new(
		DomainId.place(&"wilson_camp"),
		[EntityBootstrapSeed.new(_gerald_id, DomainId.entity_type(&"seagull"), _camp)],
		[], [], null, 1.0, {}, [], [], [], [], null,
		&"clear", &"day", [],
		[ActorStateBootstrapSeed.new(_gerald_ref, &"gerald", &"idle")]
	)
	var boot = SimulationOwnerBootstrapper.new().bootstrap(definition)
	if not boot.ok:
		_fail("Gerald bootstrap failed: %s %s" % [String(boot.code), str(boot.diagnostics)])
		return
	_owners = boot.owners

	var profile = ActorProfileDefinition.new(&"gerald", &"idle", 1.0)
	var rules: Array = [
		ActorBehaviorRule.new(&"approach_wilson", &"gerald", &"idle", &"wilson_present", &"idle", _near_wilson, 0.9, _wilson_ref, 0.40, 1.0),
		ActorBehaviorRule.new(&"neutral_watch", &"gerald", &"idle", &"wilson_present", &"idle", _camp, 0.2),
	]
	_service = ShallowActorAdvanceService.new(_owners.actors, [profile], rules, _owners.entities, _owners.actor_relationships)
	_sync_presentation()
	checkpoint_reached.emit(&"BOOTSTRAPPED", _probes())

	var stimuli := {_gerald_ref.sort_key(): [&"wilson_present"]}
	var neutral = _service.advance(1.0, stimuli)
	if neutral.decisions.size() != 1 or neutral.decisions[0].rule_id != &"neutral_watch":
		_fail("Neutral Gerald did not choose neutral watch")
		return
	_sync_presentation()
	checkpoint_reached.emit(&"NEUTRAL_WATCH", _probes())

	for index in range(3):
		_owners.actor_relationships.apply_impact(ActorRelationshipImpact.new(
			_gerald_ref,
			_wilson_ref,
			0.65,
			1.0,
			StringName("helpful_interaction_%d" % index)
		))
	var affinity: float = _owners.actor_relationships.affinity(_gerald_ref, _wilson_ref)
	if affinity < 0.40:
		_fail("Helpful interactions did not create friendly Gerald affinity")
		return
	checkpoint_reached.emit(&"RELATIONSHIP_WARMED", _probes())

	var friendly = _service.advance(1.0, stimuli)
	if friendly.decisions.size() != 1 or friendly.decisions[0].rule_id != &"approach_wilson":
		_fail("Friendly Gerald did not choose approach behavior")
		return
	_sync_presentation()
	checkpoint_reached.emit(&"APPROACHED_WILSON", _probes())
	_complete()


func _sync_presentation() -> void:
	var entity = _owners.entities.get_entity(_gerald_id)
	if entity == null:
		return
	if entity.place_id.equals(_camp):
		$Gerald.position = $GeraldCamp.position
	elif entity.place_id.equals(_near_wilson):
		$Gerald.position = $NearWilson.position


func _probes() -> Dictionary:
	var relationship = null if _owners == null else _owners.actor_relationships.get_relationship(_gerald_ref, _wilson_ref)
	var entity = null if _owners == null else _owners.entities.get_entity(_gerald_id)
	return {
		"scenario": String(SCENARIO_NAME),
		"gerald_position": [$Gerald.position.x, $Gerald.position.y, $Gerald.position.z],
		"gerald_place": "" if entity == null else entity.place_id.sort_key(),
		"affinity": 0.0 if relationship == null else float(relationship.affinity),
		"evidence_count": 0 if relationship == null else int(relationship.evidence_count),
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
	smoke_finished.emit(false, {"scenario": String(SCENARIO_NAME), "failures": [message]})
