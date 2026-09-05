extends Node3D

signal checkpoint_reached(name: StringName, details: Dictionary)
signal continue_requested()
signal smoke_finished(success: bool, report: Dictionary)

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const ContentRegistry = preload("res://src/domain/content/content_registry.gd")
const EntityBootstrapSeed = preload("res://src/application/bootstrap/entity_bootstrap_seed.gd")
const SimulationBootstrapDefinition = preload("res://src/application/bootstrap/simulation_bootstrap_definition.gd")
const DeterministicScenarioDefinition = preload("res://src/application/bootstrap/deterministic_scenario_definition.gd")
const DeterministicScenarioBootstrapService = preload("res://src/application/bootstrap/deterministic_scenario_bootstrap_service.gd")
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
const PassiveSpatialPerceptionSource = preload("res://src/application/simulation/passive_spatial_perception_source.gd")
const GodotSceneSpatialRegistry = preload("res://src/infrastructure/spatial/godot_scene_spatial_registry.gd")
const GodotMotionAdapter = preload("res://src/infrastructure/spatial/godot_motion_adapter.gd")
const GodotPassiveSpatialSensor = preload("res://src/infrastructure/spatial/godot_passive_spatial_sensor.gd")
const GodotSpatialQueryAdapter = preload("res://src/infrastructure/spatial/godot_spatial_query_adapter.gd")
const GodotSimulationHost = preload("res://src/infrastructure/spatial/godot_simulation_host.gd")

const SCENARIO_NAME := &"perception_learned_new_run_autonomy"
const GAMEPLAY_SEED := 61043
const MAX_NAVIGATION_SYNC_FRAMES := 120
const MAX_MOTION_FRAMES := 600

var _motion
var _host
var _owners
var _sensor
var _wilson_ref
var _target_ref
var _near_relation
var _motion_frames := 0
var _reported_learning := false
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

	if not _reported_learning and _has_learned_target_relation():
		_reported_learning = true
		checkpoint_reached.emit(&"PERCEPTION_LEARNED", _probes())

	if not _reported_pressing and _owners.drives.band(DriveState.HUNGER) >= DriveState.UrgencyBand.PRESSING:
		if not _reported_learning:
			_fail("Hunger became pressing before the visible food relation was learned")
			return
		_reported_pressing = true
		checkpoint_reached.emit(&"DRIVE_PRESSING", _probes())

	if not _reported_intention and _owners.current_intention.has_current():
		var current = _owners.current_intention.current()
		var target = current.bindings.get_subject(&"target")
		if target == null or not target.equals(_target_ref):
			_fail("Learned relation did not bind the perceived food object as target")
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

	var place_id = DomainId.place(&"learning_autonomy_island")
	var target_entity_id = DomainId.entity(&"visible_food_patch")
	var target_type_id = DomainId.entity_type(&"food_patch")
	var seek_food = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"seek_food")
	_near_relation = DomainId.relation_type(&"perceptibly_near")
	_target_ref = RuntimeWorldRef.entity(target_entity_id)
	_wilson_ref = RuntimeWorldRef.wilson()

	var simulation = SimulationBootstrapDefinition.new(
		place_id,
		[EntityBootstrapSeed.new(target_entity_id, target_type_id, place_id)],
		[],
		[],
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
	var wilson_spatial: Node3D = $Wilson/SpatialReference
	var navigation_agent: NavigationAgent3D = $Wilson/NavigationAgent3D
	var perception_area: Area3D = $Wilson/PerceptionArea
	var target_body: StaticBody3D = $Target
	var target_spatial: Node3D = $Target/SpatialReference
	if not registry.bind(_wilson_ref, wilson_spatial) or not registry.bind(_target_ref, target_spatial):
		_fail("Scene spatial registry rejected semantic binding")
		return

	_motion = GodotMotionAdapter.new(registry)
	if not _motion.bind_actor(_wilson_ref, wilson_body, navigation_agent, 3.0):
		_fail("Godot motion adapter rejected Wilson binding")
		return

	_sensor = GodotPassiveSpatialSensor.new()
	add_child(_sensor)
	_sensor.configure(perception_area)
	if not _sensor.bind_candidate(_target_ref, target_body):
		_fail("Passive spatial sensor rejected visible food binding")
		return

	var spatial = GodotSpatialQueryAdapter.new(registry)
	spatial.physics_space_state = get_world_3d().direct_space_state
	var passive = PassiveSpatialPerceptionSource.new(
		_sensor,
		spatial,
		_wilson_ref,
		_near_relation,
		14.0,
		&"vision",
		0.9
	)

	var navigation_ready := false
	for _frame in range(MAX_NAVIGATION_SYNC_FRAMES):
		await get_tree().physics_frame
		var navigation_map: RID = navigation_agent.get_navigation_map()
		if navigation_map.is_valid() and NavigationServer3D.map_get_iteration_id(navigation_map) > 0:
			spatial.navigation_map = navigation_map
			navigation_ready = true
			break
	if not navigation_ready:
		_fail("Navigation map did not synchronize within bounded physics frames")
		return

	await get_tree().physics_frame
	_sensor.reconcile_overlaps(true)
	if _sensor.active_candidate_count() != 1:
		_fail("Passive sensor did not discover the visible food candidate")
		return
	_sensor.request_refresh()

	var runtime = boot.runtime
	var drive_progression = DriveProgressionService.new(_owners.drives, {DriveState.HUNGER: 0.02})
	var drive_source = DriveCandidateSource.new(
		_owners.drives,
		[DriveCandidateDefinition.new(DriveState.HUNGER, seek_food, 0.1)]
	)
	var opportunity_definition = PerceivedOpportunityDefinition.new(
		EpistemicClaim.Kind.RELATION,
		_near_relation,
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
		passive,
		null,
		null,
		executor,
		drive_due_gate
	)

	_host = GodotSimulationHost.new()
	_host.name = "GodotSimulationHost"
	add_child(_host)
	_host.configure(orchestrator, _motion, 0.1, 0.0)


func _has_learned_target_relation() -> bool:
	for entry in _owners.beliefs.entries():
		var claim = entry.proposition.claim
		if claim.kind != EpistemicClaim.Kind.RELATION:
			continue
		if not claim.semantic_id.equals(_near_relation):
			continue
		if claim.object != null and claim.object.equals(_target_ref):
			return true
	return false


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
		"belief_count": -1 if _owners == null else _owners.beliefs.entry_count(),
		"learned_target_relation": false if _owners == null else _has_learned_target_relation(),
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
