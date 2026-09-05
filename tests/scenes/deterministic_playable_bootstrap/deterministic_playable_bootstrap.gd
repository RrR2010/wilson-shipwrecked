extends Node3D

signal checkpoint_reached(name: StringName, details: Dictionary)
signal continue_requested()
signal smoke_finished(success: bool, report: Dictionary)

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const ContentRegistry = preload("res://src/domain/content/content_registry.gd")
const EntityBootstrapSeed = preload("res://src/application/bootstrap/entity_bootstrap_seed.gd")
const IntentionBootstrapSeed = preload("res://src/application/bootstrap/intention_bootstrap_seed.gd")
const SimulationBootstrapDefinition = preload("res://src/application/bootstrap/simulation_bootstrap_definition.gd")
const DeterministicScenarioDefinition = preload("res://src/application/bootstrap/deterministic_scenario_definition.gd")
const DeterministicScenarioBootstrapService = preload("res://src/application/bootstrap/deterministic_scenario_bootstrap_service.gd")
const DirectTargetMotionExecutionCoordinator = preload("res://src/application/simulation/direct_target_motion_execution_coordinator.gd")
const CurrentIntentionExecutionCoordinator = preload("res://src/application/simulation/current_intention_execution_coordinator.gd")
const SimulationOrchestrator = preload("res://src/application/simulation/simulation_orchestrator.gd")
const PerceivedOpportunityService = preload("res://src/domain/cognition/perceived_opportunity_service.gd")
const DecisionRouter = preload("res://src/domain/cognition/decision_router.gd")
const DecisionCommitCoordinator = preload("res://src/application/simulation/decision_commit_coordinator.gd")
const GodotSceneSpatialRegistry = preload("res://src/infrastructure/spatial/godot_scene_spatial_registry.gd")
const GodotMotionAdapter = preload("res://src/infrastructure/spatial/godot_motion_adapter.gd")
const GodotSimulationHost = preload("res://src/infrastructure/spatial/godot_simulation_host.gd")

const SCENARIO_NAME := &"deterministic_playable_bootstrap"
const GAMEPLAY_SEED := 41027
const MAX_NAVIGATION_SYNC_FRAMES := 120
const MAX_MOTION_FRAMES := 600

var _motion
var _host
var _wilson_ref
var _target_ref
var _motion_frames := 0
var _reported_moving := false
var _observe_motion := false
var _finished := false
var _trace_sink := TraceSink.new()


class EmptyWorldAdvance:
	extends RefCounted
	const ResultType = preload("res://src/application/simulation/world_advance_result.gd")
	func advance(_elapsed: float, _step):
		return ResultType.new()


class TraceSink:
	extends RefCounted
	var traces: Array = []
	func record(trace) -> void:
		traces.append(trace)


func _ready() -> void:
	call_deferred("_bootstrap_and_start")


func _physics_process(_delta: float) -> void:
	if _finished or not _observe_motion or _motion == null or _wilson_ref == null:
		return
	var status: int = _motion.get_status(_wilson_ref)
	if status == GodotMotionAdapter.MotionStatus.MOVING:
		_motion_frames += 1
		if not _reported_moving:
			_reported_moving = true
			checkpoint_reached.emit(&"MOVING", _probes())
		if _motion_frames > MAX_MOTION_FRAMES:
			_fail("Wilson did not arrive within bounded physics frames")
		return
	if status == GodotMotionAdapter.MotionStatus.ARRIVED:
		checkpoint_reached.emit(&"ARRIVED", _probes())
		_complete()
		return
	if status == GodotMotionAdapter.MotionStatus.ROUTE_INVALID:
		_fail("Motion route became invalid")
		return
	if status == GodotMotionAdapter.MotionStatus.BLOCKED:
		_fail("Motion route became blocked")


func _bootstrap_and_start() -> void:
	var content = ContentRegistry.new()
	var seal_result = content.seal()
	if not seal_result.ok:
		_fail("Content registry failed to seal")
		return

	var place_id = DomainId.place(&"bootstrap_island")
	var target_entity_id = DomainId.entity(&"food_patch")
	var target_type_id = DomainId.entity_type(&"food_patch")
	var seek_food = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"seek_food")
	_target_ref = RuntimeWorldRef.entity(target_entity_id)
	_wilson_ref = RuntimeWorldRef.wilson()

	var bindings = RoleBinding.new()
	bindings.bind(&"target", _target_ref)
	var simulation = SimulationBootstrapDefinition.new(
		place_id,
		[EntityBootstrapSeed.new(target_entity_id, target_type_id, place_id)],
		[],
		[],
		IntentionBootstrapSeed.new(seek_food, bindings, &"scenario_seed")
	)
	var definition = DeterministicScenarioDefinition.new(SCENARIO_NAME, GAMEPLAY_SEED, simulation)
	var boot = DeterministicScenarioBootstrapService.new().bootstrap(definition, content)
	if not boot.ok:
		_fail("Scenario bootstrap failed: %s %s" % [String(boot.code), str(boot.diagnostics)])
		return

	checkpoint_reached.emit(&"BOOTSTRAPPED", {
		"scenario": String(boot.scenario_name),
		"seed": boot.gameplay_seed,
		"current_intention": String(boot.owners.current_intention.current().intention_id.key()),
	})

	var registry = GodotSceneSpatialRegistry.new()
	var wilson_body: CharacterBody3D = $Wilson
	var navigation_agent: NavigationAgent3D = $Wilson/NavigationAgent3D
	var target_node: Node3D = $Target
	if not registry.bind(_wilson_ref, wilson_body) or not registry.bind(_target_ref, target_node):
		_fail("Scene spatial registry rejected semantic binding")
		return

	_motion = GodotMotionAdapter.new(registry)
	if not _motion.bind_actor(_wilson_ref, wilson_body, navigation_agent, 3.0):
		_fail("Godot motion adapter rejected Wilson binding")
		return

	var runtime = boot.runtime
	var orchestrator = SimulationOrchestrator.new(
		EmptyWorldAdvance.new(),
		runtime.action_execution,
		runtime.world_commands,
		runtime.derived_invalidator,
		runtime.activity_query,
		runtime.perception_access,
		runtime.perception,
		runtime.learning,
		PerceivedOpportunityService.new(),
		boot.owners.beliefs,
		[],
		DecisionRouter.new(),
		DecisionCommitCoordinator.new(boot.owners.current_intention),
		_trace_sink
	)
	_host = GodotSimulationHost.new()
	_host.name = "GodotSimulationHost"
	add_child(_host)
	_host.configure(orchestrator, _motion, 0.1, 0.0)

	var navigation_ready := false
	for _frame in range(MAX_NAVIGATION_SYNC_FRAMES):
		await get_tree().physics_frame
		var navigation_map: RID = navigation_agent.get_navigation_map()
		if navigation_map.is_valid() and NavigationServer3D.map_get_iteration_id(navigation_map) > 0:
			navigation_ready = true
			break
	if not navigation_ready:
		_fail("Navigation map did not synchronize within bounded physics frames")
		return

	var executor = DirectTargetMotionExecutionCoordinator.new(_motion, _wilson_ref, [seek_food])
	var resume = CurrentIntentionExecutionCoordinator.new(runtime.activity_query, executor).resume_current()
	if not bool(resume.get("resumed", false)):
		_fail("Authoritative current intention did not resume: %s" % String(resume.get("reason", &"unknown")))
		return
	checkpoint_reached.emit(&"INTENTION_RESUMED", _probes())
	_observe_motion = true


func _probes() -> Dictionary:
	var body: CharacterBody3D = $Wilson
	return {
		"position": [body.global_position.x, body.global_position.y, body.global_position.z],
		"motion_status": -1 if _motion == null else _motion.get_status(_wilson_ref),
		"simulation_time": -1.0 if _host == null else _host.simulation_time(),
		"semantic_step": -1 if _host == null else _host.semantic_step_count(),
	}


func _complete() -> void:
	if _finished:
		return
	_finished = true
	checkpoint_reached.emit(&"COMPLETE", _probes())
	smoke_finished.emit(true, {
		"scenario": String(SCENARIO_NAME),
		"seed": GAMEPLAY_SEED,
		"trace_count": _trace_sink.traces.size(),
		"final_position": _probes().get("position"),
	})


func _fail(message: String) -> void:
	if _finished:
		return
	_finished = true
	smoke_finished.emit(false, {"failures": [message], "scenario": String(SCENARIO_NAME)})
