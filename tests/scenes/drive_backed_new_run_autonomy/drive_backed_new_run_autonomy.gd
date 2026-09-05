extends Node3D

signal checkpoint_reached(name: StringName, details: Dictionary)
signal continue_requested()
signal smoke_finished(success: bool, report: Dictionary)

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const ContentRegistry = preload("res://src/domain/content/content_registry.gd")
const EntityBootstrapSeed = preload("res://src/application/bootstrap/entity_bootstrap_seed.gd")
const BeliefBootstrapSeed = preload("res://src/application/bootstrap/belief_bootstrap_seed.gd")
const SimulationBootstrapDefinition = preload("res://src/application/bootstrap/simulation_bootstrap_definition.gd")
const DeterministicScenarioDefinition = preload("res://src/application/bootstrap/deterministic_scenario_definition.gd")
const DeterministicScenarioBootstrapService = preload("res://src/application/bootstrap/deterministic_scenario_bootstrap_service.gd")
const BeliefProposition = preload("res://src/domain/cognition/belief_proposition.gd")
const EpistemicClaim = preload("res://src/domain/cognition/epistemic_claim.gd")
const DecisionCandidate = preload("res://src/domain/cognition/decision_candidate.gd")
const DriveState = preload("res://src/domain/cognition/drive_state.gd")
const DriveProgressionService = preload("res://src/domain/cognition/drive_progression_service.gd")
const DriveCandidateDefinition = preload("res://src/domain/cognition/drive_candidate_definition.gd")
const DriveCandidateSource = preload("res://src/domain/cognition/drive_candidate_source.gd")
const PerceivedOpportunityDefinition = preload("res://src/domain/cognition/perceived_opportunity_definition.gd")
const PerceivedOpportunityService = preload("res://src/domain/cognition/perceived_opportunity_service.gd")
const BelievedOpportunityCandidateSource = preload("res://src/domain/cognition/believed_opportunity_candidate_source.gd")
const DecisionRouter = preload("res://src/domain/cognition/decision_router.gd")
const DecisionCommitCoordinator = preload("res://src/application/simulation/decision_commit_coordinator.gd")
const DirectTargetMotionExecutionCoordinator = preload("res://src/application/simulation/direct_target_motion_execution_coordinator.gd")
const SemanticDueScheduler = preload("res://src/application/simulation/semantic_due_scheduler.gd")
const DueElapsedGate = preload("res://src/application/simulation/due_elapsed_gate.gd")
const SimulationOrchestrator = preload("res://src/application/simulation/simulation_orchestrator.gd")
const GodotSceneSpatialRegistry = preload("res://src/infrastructure/spatial/godot_scene_spatial_registry.gd")
const GodotMotionAdapter = preload("res://src/infrastructure/spatial/godot_motion_adapter.gd")
const GodotSimulationHost = preload("res://src/infrastructure/spatial/godot_simulation_host.gd")

const SCENARIO_NAME := &"drive_backed_new_run_autonomy"
const GAMEPLAY_SEED := 52031
const MAX_NAVIGATION_SYNC_FRAMES := 120
const MAX_MOTION_FRAMES := 600

var _motion
var _host
var _owners
var _wilson_ref
var _target_ref
var _motion_frames := 0
var _reported_pressing := false
var _reported_intention := false
var _reported_moving := false
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
	if _finished or _owners == null:
		return

	if not _reported_pressing and _owners.drives.band(DriveState.HUNGER) >= DriveState.UrgencyBand.PRESSING:
		_reported_pressing = true
		checkpoint_reached.emit(&"DRIVE_PRESSING", _probes())

	if not _reported_intention and _owners.current_intention.has_current():
		var current = _owners.current_intention.current()
		var target = current.bindings.get_subject(&"target")
		if target == null or not target.equals(_target_ref):
			_fail("Drive-backed decision did not bind the believed food target")
			return
		_reported_intention = true
		checkpoint_reached.emit(&"INTENTION_SELECTED", _probes())

	if _motion == null or _wilson_ref == null:
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
	if status == GodotMotionAdapter.MotionStatus.ARRIVED and _reported_moving:
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

	var place_id = DomainId.place(&"autonomy_island")
	var target_entity_id = DomainId.entity(&"known_food_patch")
	var target_type_id = DomainId.entity_type(&"food_patch")
	var edible_property = DomainId.property(&"edible")
	var seek_food = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"seek_food")
	_target_ref = RuntimeWorldRef.entity(target_entity_id)
	_wilson_ref = RuntimeWorldRef.wilson()

	var known_food = BeliefProposition.new(EpistemicClaim.property_claim(_target_ref, edible_property, true))
	var simulation = SimulationBootstrapDefinition.new(
		place_id,
		[EntityBootstrapSeed.new(target_entity_id, target_type_id, place_id)],
		[],
		[BeliefBootstrapSeed.new(known_food, 0.9, 1, &"new_run_seed", &"memory")],
		null,
		1.0,
		{DriveState.HUNGER: 0.54}
	)
	var definition = DeterministicScenarioDefinition.new(SCENARIO_NAME, GAMEPLAY_SEED, simulation)
	var boot = DeterministicScenarioBootstrapService.new().bootstrap(definition, content)
	if not boot.ok:
		_fail("Scenario bootstrap failed: %s %s" % [String(boot.code), str(boot.diagnostics)])
		return
	_owners = boot.owners

	checkpoint_reached.emit(&"BOOTSTRAPPED", {
		"scenario": String(boot.scenario_name),
		"seed": boot.gameplay_seed,
		"hunger": _owners.drives.value(DriveState.HUNGER),
		"has_current_intention": _owners.current_intention.has_current(),
		"belief_count": _owners.beliefs.entry_count(),
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

	var runtime = boot.runtime
	var drive_progression = DriveProgressionService.new(_owners.drives, {DriveState.HUNGER: 0.02})
	var drive_source = DriveCandidateSource.new(
		_owners.drives,
		[DriveCandidateDefinition.new(DriveState.HUNGER, seek_food, 0.1)]
	)
	var opportunity_definition = PerceivedOpportunityDefinition.new(
		EpistemicClaim.Kind.PROPERTY,
		edible_property,
		seek_food,
		DecisionCandidate.Scope.INTENTIONAL,
		0.1
	)
	var believed_opportunities = BelievedOpportunityCandidateSource.new(
		_owners.beliefs,
		[opportunity_definition]
	)
	var scheduler = SemanticDueScheduler.new()
	scheduler.register(&"drives", 1.0, 0.0)
	var drive_due_gate = DueElapsedGate.new(scheduler, &"drives")
	var executor = DirectTargetMotionExecutionCoordinator.new(_motion, _wilson_ref, [seek_food])
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
		_owners.beliefs,
		[],
		DecisionRouter.new(),
		DecisionCommitCoordinator.new(_owners.current_intention),
		_trace_sink,
		drive_progression,
		drive_source,
		null,
		null,
		[believed_opportunities],
		null,
		null,
		null,
		null,
		null,
		executor,
		drive_due_gate
	)

	_host = GodotSimulationHost.new()
	_host.name = "GodotSimulationHost"
	add_child(_host)
	_host.configure(orchestrator, _motion, 0.1, 0.0)


func _probes() -> Dictionary:
	var body: CharacterBody3D = $Wilson
	var current_intention := ""
	var current_target := ""
	if _owners != null and _owners.current_intention.has_current():
		var current = _owners.current_intention.current()
		current_intention = current.intention_id.sort_key()
		var target = current.bindings.get_subject(&"target")
		if target != null:
			current_target = target.sort_key()
	return {
		"position": [body.global_position.x, body.global_position.y, body.global_position.z],
		"motion_status": -1 if _motion == null else _motion.get_status(_wilson_ref),
		"simulation_time": -1.0 if _host == null else _host.simulation_time(),
		"semantic_step": -1 if _host == null else _host.semantic_step_count(),
		"hunger": -1.0 if _owners == null else _owners.drives.value(DriveState.HUNGER),
		"hunger_band": -1 if _owners == null else _owners.drives.band(DriveState.HUNGER),
		"current_intention": current_intention,
		"current_target": current_target,
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
