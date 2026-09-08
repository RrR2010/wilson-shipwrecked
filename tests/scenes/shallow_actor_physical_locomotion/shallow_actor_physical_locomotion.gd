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
const ShallowActorMotionCoordinator = preload("res://src/application/simulation/shallow_actor_motion_coordinator.gd")
const GodotSceneSpatialRegistry = preload("res://src/infrastructure/spatial/godot_scene_spatial_registry.gd")
const GodotMotionAdapter = preload("res://src/infrastructure/spatial/godot_motion_adapter.gd")
const MotionPort = preload("res://src/application/simulation/motion_port.gd")

const SCENARIO_NAME := &"shallow_actor_physical_locomotion"
const MOVE_EPSILON := 0.75
const MAX_NAVIGATION_SYNC_FRAMES := 120

var _gerald_id
var _gerald_ref
var _wilson_ref
var _camp
var _near_wilson
var _owners
var _actor_service
var _motion
var _motion_coordinator
var _started := false
var _moving_checkpoint_emitted := false
var _finished := false
var _start_position := Vector3.ZERO


func _ready() -> void:
	call_deferred("_run")


func _physics_process(delta: float) -> void:
	if not _started or _finished or _motion == null:
		return
	_motion.physics_tick(delta)
	if not _moving_checkpoint_emitted and $Gerald.global_position.distance_to(_start_position) > MOVE_EPSILON:
		_moving_checkpoint_emitted = true
		checkpoint_reached.emit(&"PHYSICAL_TRANSIT", _probes())
	var reconciliation: Dictionary = _motion_coordinator.reconcile()
	if not reconciliation.diagnostics.is_empty():
		_fail("Gerald motion reconciliation failed: %s" % str(reconciliation.diagnostics))
		return
	if reconciliation.arrived.is_empty():
		return
	checkpoint_reached.emit(&"SEMANTIC_ARRIVAL_COMMITTED", _probes())
	_complete()


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

	for index in range(3):
		_owners.actor_relationships.apply_impact(ActorRelationshipImpact.new(
			_gerald_ref,
			_wilson_ref,
			0.65,
			1.0,
			StringName("helpful_interaction_%d" % index)
		))

	var profile = ActorProfileDefinition.new(&"gerald", &"idle", 1.0)
	var rules: Array = [
		ActorBehaviorRule.new(&"approach_wilson", &"gerald", &"idle", &"wilson_present", &"idle", _near_wilson, 0.9, _wilson_ref, 0.40, 1.0),
	]
	_actor_service = ShallowActorAdvanceService.new(_owners.actors, [profile], rules, _owners.entities, _owners.actor_relationships)

	var registry = GodotSceneSpatialRegistry.new()
	if not registry.bind(_gerald_ref, $Gerald):
		_fail("Gerald spatial identity binding failed")
		return
	if not registry.bind(RuntimeWorldRef.place(_near_wilson), $NearWilson):
		_fail("Near-Wilson place binding failed")
		return
	_motion = GodotMotionAdapter.new(registry)
	var navigation_agent: NavigationAgent3D = $Gerald/NavigationAgent3D
	if not _motion.bind_actor(_gerald_ref, $Gerald, navigation_agent, 3.0):
		_fail("Gerald motion binding failed")
		return
	_motion_coordinator = ShallowActorMotionCoordinator.new(_motion, _owners.entities)

	var navigation_ready := false
	for _frame in range(MAX_NAVIGATION_SYNC_FRAMES):
		await get_tree().physics_frame
		var navigation_map: RID = navigation_agent.get_navigation_map()
		if navigation_map.is_valid() and NavigationServer3D.map_get_iteration_id(navigation_map) > 0:
			navigation_ready = true
			break
	if not navigation_ready:
		_fail("Gerald navigation map did not synchronize before movement request")
		return

	_start_position = $Gerald.global_position
	checkpoint_reached.emit(&"BOOTSTRAPPED", _probes())

	var stimuli := {_gerald_ref.sort_key(): [&"wilson_present"]}
	var decision_result: Dictionary = _actor_service.advance_deferred(1.0, stimuli)
	if decision_result.decisions.size() != 1 or decision_result.decisions[0].rule_id != &"approach_wilson":
		_fail("Friendly Gerald did not select deferred approach behavior")
		return
	var entity = _owners.entities.get_entity(_gerald_id)
	if entity == null or not entity.place_id.equals(_camp):
		_fail("Deferred actor decision changed semantic place before physical movement")
		return
	if not _motion_coordinator.request(decision_result.decisions[0]):
		_fail("Gerald physical movement request failed")
		return
	checkpoint_reached.emit(&"MOVE_REQUESTED", _probes())
	_started = true


func _probes() -> Dictionary:
	var entity = null if _owners == null else _owners.entities.get_entity(_gerald_id)
	var relationship = null if _owners == null else _owners.actor_relationships.get_relationship(_gerald_ref, _wilson_ref)
	return {
		"scenario": String(SCENARIO_NAME),
		"gerald_position": [$Gerald.global_position.x, $Gerald.global_position.y, $Gerald.global_position.z],
		"gerald_place": "" if entity == null else entity.place_id.sort_key(),
		"motion_status": MotionPort.MotionStatus.IDLE if _motion == null else _motion.get_status(_gerald_ref),
		"pending_motion": false if _motion_coordinator == null else _motion_coordinator.has_pending(_gerald_ref),
		"affinity": 0.0 if relationship == null else float(relationship.affinity),
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
