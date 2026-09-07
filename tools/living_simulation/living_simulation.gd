extends Node3D

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

const SCENARIO_NAME := &"living_simulation_spine"
const GAMEPLAY_SEED := 61007
const MAX_NAVIGATION_SYNC_FRAMES := 120

var _owners
var _motion
var _host
var _wilson_ref
var _food_ref
var _shelter_ref
var _trace_sink := TraceSink.new()
var _boot_error := ""

@onready var _status_label: Label = $DebugUI/Panel/Margin/VBox/Status
@onready var _intention_label: Label = $DebugUI/Panel/Margin/VBox/Intention
@onready var _drive_label: Label = $DebugUI/Panel/Margin/VBox/Drive
@onready var _motion_label: Label = $DebugUI/Panel/Margin/VBox/Motion
@onready var _trace_label: Label = $DebugUI/Panel/Margin/VBox/Trace


class TraceSink:
	extends RefCounted
	var traces: Array = []

	func record(trace) -> void:
		traces.append(trace)
		if traces.size() > 64:
			traces.pop_front()


func _ready() -> void:
	call_deferred("_bootstrap_and_start")


func _process(_delta: float) -> void:
	_update_debug_projection()


func _bootstrap_and_start() -> void:
	var content = ContentRegistry.new()
	var seal_result = content.seal()
	if not seal_result.ok:
		_fail_boot("Content registry failed to seal")
		return

	var place_id = DomainId.place(&"living_island")
	var food_entity_id = DomainId.entity(&"food_patch_001")
	var shelter_entity_id = DomainId.entity(&"shelter_001")
	var food_type_id = DomainId.entity_type(&"food_patch")
	var shelter_type_id = DomainId.entity_type(&"shelter")
	var edible_property = DomainId.property(&"edible")
	var seek_food = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"seek_food")
	_wilson_ref = RuntimeWorldRef.wilson()
	_food_ref = RuntimeWorldRef.entity(food_entity_id)
	_shelter_ref = RuntimeWorldRef.entity(shelter_entity_id)

	var known_food = BeliefProposition.new(EpistemicClaim.property_claim(_food_ref, edible_property, true))
	var simulation = SimulationBootstrapDefinition.new(
		place_id,
		[
			EntityBootstrapSeed.new(food_entity_id, food_type_id, place_id),
			EntityBootstrapSeed.new(shelter_entity_id, shelter_type_id, place_id),
		],
		[],
		[BeliefBootstrapSeed.new(known_food, 0.9, 1, &"new_run_seed", &"memory")],
		null,
		1.0,
		{DriveState.HUNGER: 0.54}
	)
	var definition = DeterministicScenarioDefinition.new(SCENARIO_NAME, GAMEPLAY_SEED, simulation)
	var boot = DeterministicScenarioBootstrapService.new().bootstrap(definition, content)
	if not boot.ok:
		_fail_boot("Scenario bootstrap failed: %s %s" % [String(boot.code), str(boot.diagnostics)])
		return
	_owners = boot.owners
	var runtime = boot.runtime
	if runtime.world_advance == null:
		_fail_boot("Runtime composition did not provide authoritative World advance")
		return

	var registry = GodotSceneSpatialRegistry.new()
	var wilson_body: CharacterBody3D = $Wilson
	var navigation_agent: NavigationAgent3D = $Wilson/NavigationAgent3D
	if not registry.bind(_wilson_ref, wilson_body):
		_fail_boot("Scene registry rejected Wilson binding")
		return
	if not registry.bind(_food_ref, $FoodPatch):
		_fail_boot("Scene registry rejected food binding")
		return
	if not registry.bind(_shelter_ref, $Shelter):
		_fail_boot("Scene registry rejected shelter binding")
		return

	_motion = GodotMotionAdapter.new(registry)
	if not _motion.bind_actor(_wilson_ref, wilson_body, navigation_agent, 2.4):
		_fail_boot("Godot motion adapter rejected Wilson binding")
		return

	var navigation_ready := false
	for _frame in range(MAX_NAVIGATION_SYNC_FRAMES):
		await get_tree().physics_frame
		var navigation_map: RID = navigation_agent.get_navigation_map()
		if navigation_map.is_valid() and NavigationServer3D.map_get_iteration_id(navigation_map) > 0:
			navigation_ready = true
			break
	if not navigation_ready:
		_fail_boot("Navigation map did not synchronize")
		return

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
		runtime.world_advance,
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


func is_live() -> bool:
	return _boot_error == "" and _owners != null and _host != null


func boot_error() -> String:
	return _boot_error


func observation_snapshot() -> Dictionary:
	return {
		"live": is_live(),
		"simulation_time": -1.0 if _host == null else _host.simulation_time(),
		"semantic_step": -1 if _host == null else _host.semantic_step_count(),
		"hunger": -1.0 if _owners == null else _owners.drives.value(DriveState.HUNGER),
		"has_intention": false if _owners == null else _owners.current_intention.has_current(),
		"motion_status": -1 if _motion == null or _wilson_ref == null else _motion.get_status(_wilson_ref),
		"wilson_position": $Wilson.global_position,
		"trace_count": _trace_sink.traces.size(),
	}


func _update_debug_projection() -> void:
	if _boot_error != "":
		_status_label.text = "Runtime: ERROR — %s" % _boot_error
		return
	if _owners == null or _host == null:
		_status_label.text = "Runtime: bootstrapping..."
		return

	_status_label.text = "Runtime: LIVE   sim %.1fs   step %d" % [_host.simulation_time(), _host.semantic_step_count()]
	var intention := "none"
	var target := ""
	if _owners.current_intention.has_current():
		var current = _owners.current_intention.current()
		intention = current.intention_id.sort_key()
		var current_target = current.bindings.get_subject(&"target")
		if current_target != null:
			target = " → %s" % current_target.sort_key()
	_intention_label.text = "Intention: %s%s" % [intention, target]
	_drive_label.text = "Hunger: %.3f   band %d" % [_owners.drives.value(DriveState.HUNGER), _owners.drives.band(DriveState.HUNGER)]
	_motion_label.text = "Motion: %s   pos (%.1f, %.1f)" % [
		_motion_status_name(_motion.get_status(_wilson_ref)),
		$Wilson.global_position.x,
		$Wilson.global_position.z,
	]
	_trace_label.text = "Recent semantic traces: %d" % _trace_sink.traces.size()


func _motion_status_name(status: int) -> String:
	match status:
		GodotMotionAdapter.MotionStatus.IDLE:
			return "IDLE"
		GodotMotionAdapter.MotionStatus.MOVING:
			return "MOVING"
		GodotMotionAdapter.MotionStatus.ARRIVED:
			return "ARRIVED"
		GodotMotionAdapter.MotionStatus.BLOCKED:
			return "BLOCKED"
		GodotMotionAdapter.MotionStatus.ROUTE_INVALID:
			return "ROUTE_INVALID"
		_:
			return "UNKNOWN(%d)" % status


func _fail_boot(message: String) -> void:
	_boot_error = message
	push_error("[LIVING_SIM] %s" % message)
