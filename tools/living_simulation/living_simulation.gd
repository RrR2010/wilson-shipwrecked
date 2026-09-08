extends Node3D

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const ContentRegistry = preload("res://src/domain/content/content_registry.gd")
const EventDefinition = preload("res://src/domain/content/event_definition.gd")
const EntityBootstrapSeed = preload("res://src/application/bootstrap/entity_bootstrap_seed.gd")
const BeliefBootstrapSeed = preload("res://src/application/bootstrap/belief_bootstrap_seed.gd")
const ProjectBootstrapSeed = preload("res://src/application/bootstrap/project_bootstrap_seed.gd")
const HabitBootstrapSeed = preload("res://src/application/bootstrap/habit_bootstrap_seed.gd")
const SimulationBootstrapDefinition = preload("res://src/application/bootstrap/simulation_bootstrap_definition.gd")
const DeterministicScenarioDefinition = preload("res://src/application/bootstrap/deterministic_scenario_definition.gd")
const DeterministicScenarioBootstrapService = preload("res://src/application/bootstrap/deterministic_scenario_bootstrap_service.gd")
const ActionDefinition = preload("res://src/domain/actions/action_definition.gd")
const ActionResolutionDefinition = preload("res://src/domain/actions/action_resolution_definition.gd")
const RequirementPredicate = preload("res://src/domain/actions/requirement_predicate.gd")
const BeliefProposition = preload("res://src/domain/cognition/belief_proposition.gd")
const EpistemicClaim = preload("res://src/domain/cognition/epistemic_claim.gd")
const DecisionCandidate = preload("res://src/domain/cognition/decision_candidate.gd")
const DriveState = preload("res://src/domain/cognition/drive_state.gd")
const DriveProgressionService = preload("res://src/domain/cognition/drive_progression_service.gd")
const DriveCandidateDefinition = preload("res://src/domain/cognition/drive_candidate_definition.gd")
const DriveCandidateSource = preload("res://src/domain/cognition/drive_candidate_source.gd")
const DriveConsequenceDefinition = preload("res://src/domain/cognition/drive_consequence_definition.gd")
const IntentionCompletionDefinition = preload("res://src/domain/cognition/intention_completion_definition.gd")
const PerceivedOpportunityDefinition = preload("res://src/domain/cognition/perceived_opportunity_definition.gd")
const PerceivedOpportunityService = preload("res://src/domain/cognition/perceived_opportunity_service.gd")
const DriveBackedBelievedOpportunityCandidateSource = preload("res://src/domain/cognition/drive_backed_believed_opportunity_candidate_source.gd")
const PerceivedCueService = preload("res://src/domain/cognition/perceived_cue_service.gd")
const ObservedEventCueRule = preload("res://src/domain/cognition/observed_event_cue_rule.gd")
const PerceivedHabitCandidateSource = preload("res://src/domain/cognition/perceived_habit_candidate_source.gd")
const DecisionRouter = preload("res://src/domain/cognition/decision_router.gd")
const ProjectDefinition = preload("res://src/domain/projects/project_definition.gd")
const ProjectInstance = preload("res://src/domain/projects/project_instance.gd")
const ProjectContributionService = preload("res://src/domain/projects/project_contribution_service.gd")
const ProjectCandidateSource = preload("res://src/domain/projects/project_candidate_source.gd")
const WeatherDefinition = preload("res://src/domain/world/weather_definition.gd")
const WeatherTransitionDefinition = preload("res://src/domain/world/weather_transition_definition.gd")
const DecisionCommitCoordinator = preload("res://src/application/simulation/decision_commit_coordinator.gd")
const InterruptingDecisionCommitCoordinator = preload("res://src/application/simulation/interrupting_decision_commit_coordinator.gd")
const TargetedActionExecutionCoordinator = preload("res://src/application/simulation/targeted_action_execution_coordinator.gd")
const DirectTargetMotionExecutionCoordinator = preload("res://src/application/simulation/direct_target_motion_execution_coordinator.gd")
const CompositeSelectedIntentionExecutor = preload("res://src/application/simulation/composite_selected_intention_executor.gd")
const GroundedDriveConsequenceService = preload("res://src/application/simulation/grounded_drive_consequence_service.gd")
const GroundedIntentionCompletionService = preload("res://src/application/simulation/grounded_intention_completion_service.gd")
const PerceivedContextTransitionTriggerSource = preload("res://src/application/simulation/perceived_context_transition_trigger_source.gd")
const SemanticDueScheduler = preload("res://src/application/simulation/semantic_due_scheduler.gd")
const DueElapsedGate = preload("res://src/application/simulation/due_elapsed_gate.gd")
const SimulationOrchestrator = preload("res://src/application/simulation/simulation_orchestrator.gd")
const GodotSceneSpatialRegistry = preload("res://src/infrastructure/spatial/godot_scene_spatial_registry.gd")
const GodotMotionAdapter = preload("res://src/infrastructure/spatial/godot_motion_adapter.gd")
const GodotSimulationHost = preload("res://src/infrastructure/spatial/godot_simulation_host.gd")

const SCENARIO_NAME := &"living_simulation_weather_context_interference"
const GAMEPLAY_SEED := 61007
const MAX_NAVIGATION_SYNC_FRAMES := 120
const SHELTER_REQUIRED_CONTRIBUTIONS := 100
const CLEAR_DURATION_SECONDS := 18.0
const RAIN_DURATION_SECONDS := 12.0

var _owners
var _motion
var _host
var _wilson_ref
var _food_ref
var _shelter_ref
var _shelter_project_id
var _trace_sink := TraceSink.new()
var _boot_error := ""

@onready var _status_label: Label = $DebugUI/Panel/Margin/VBox/Status
@onready var _intention_label: Label = $DebugUI/Panel/Margin/VBox/Intention
@onready var _drive_label: Label = $DebugUI/Panel/Margin/VBox/Drive
@onready var _project_label: Label = $DebugUI/Panel/Margin/VBox/Project
@onready var _motion_label: Label = $DebugUI/Panel/Margin/VBox/Motion
@onready var _trace_label: Label = $DebugUI/Panel/Margin/VBox/Trace


class TraceSink:
	extends RefCounted
	var traces: Array = []
	var grounded_consumptions := 0
	var grounded_intention_completions := 0
	var grounded_project_contributions := 0

	func record(trace) -> void:
		traces.append(trace)
		var drive_result = trace.stage_results.get(&"drive_consequence")
		if drive_result != null and drive_result.code == &"drive_consequence_applied":
			grounded_consumptions += 1
		var intention_result = trace.stage_results.get(&"intention_completion")
		if intention_result != null and intention_result.code == &"intention_completion_applied":
			grounded_intention_completions += 1
		var project_result = trace.stage_results.get(&"project_progression")
		if project_result is Dictionary:
			grounded_project_contributions += project_result.get("applied", []).size()
		if traces.size() > 64:
			traces.pop_front()


func _ready() -> void:
	call_deferred("_bootstrap_and_start")


func _process(_delta: float) -> void:
	_update_debug_projection()


func _bootstrap_and_start() -> void:
	var content = ContentRegistry.new()
	var weather_worsened = DomainId.event_definition(&"weather_worsened")
	var weather_improved = DomainId.event_definition(&"weather_improved")
	var authored_results: Array = [
		content.register_event_definition(EventDefinition.new(
			weather_worsened,
			[] as Array[StringName],
			[&"hearing"] as Array[StringName],
			1.0,
			EventDefinition.AccessScope.AMBIENT,
			true
		)),
		content.register_event_definition(EventDefinition.new(
			weather_improved,
			[] as Array[StringName],
			[&"hearing"] as Array[StringName],
			1.0,
			EventDefinition.AccessScope.AMBIENT,
			true
		)),
		content.register_weather_definition(WeatherDefinition.new(&"clear", CLEAR_DURATION_SECONDS, CLEAR_DURATION_SECONDS, {&"rain": 0.0})),
		content.register_weather_definition(WeatherDefinition.new(&"rain", RAIN_DURATION_SECONDS, RAIN_DURATION_SECONDS, {&"rain": 1.0})),
		content.register_weather_transition_definition(WeatherTransitionDefinition.new(&"clear", &"rain", 1.0, weather_worsened)),
		content.register_weather_transition_definition(WeatherTransitionDefinition.new(&"rain", &"clear", 1.0, weather_improved)),
	]
	for authored_result in authored_results:
		if authored_result == null or not authored_result.ok:
			_fail_boot("Weather content registration failed")
			return
	var seal_result = content.seal()
	if not seal_result.ok:
		_fail_boot("Content registry failed to seal: %s" % str(seal_result.diagnostics))
		return

	var place_id = DomainId.place(&"living_island")
	var food_entity_id = DomainId.entity(&"food_patch_001")
	var shelter_entity_id = DomainId.entity(&"shelter_001")
	var food_type_id = DomainId.entity_type(&"food_patch")
	var shelter_type_id = DomainId.entity_type(&"shelter")
	var edible_property = DomainId.property(&"edible")
	var seek_food = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"seek_food")
	var continue_shelter = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"continue_shelter_project")
	var seek_cover = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"seek_safer_cover")
	var consume_food = DomainId.action(&"consume_food")
	var contribute_shelter = DomainId.action(&"contribute_shelter")
	var food_consumed = DomainId.event_definition(&"food_consumed")
	var shelter_contribution = DomainId.event_definition(&"shelter_contribution_committed")
	var shelter_project_definition_id = DomainId.new(DomainId.Kind.PROJECT_DEFINITION, &"build_shelter")
	_shelter_project_id = DomainId.new(DomainId.Kind.PROJECT_INSTANCE, &"build_shelter_001")
	_wilson_ref = RuntimeWorldRef.wilson()
	_food_ref = RuntimeWorldRef.entity(food_entity_id)
	_shelter_ref = RuntimeWorldRef.entity(shelter_entity_id)

	var known_food = BeliefProposition.new(EpistemicClaim.property_claim(_food_ref, edible_property, true))
	var shelter_project_bindings = RoleBinding.new()
	shelter_project_bindings.bind(&"target", _shelter_ref)
	var project_seed = ProjectBootstrapSeed.new(
		_shelter_project_id,
		shelter_project_definition_id,
		shelter_project_bindings,
		ProjectInstance.Lifecycle.ACTIVE,
		0
	)
	var cover_bindings = RoleBinding.new()
	cover_bindings.bind(&"target", _shelter_ref)
	var weather_habit = HabitBootstrapSeed.new(
		&"dangerous_weather",
		seek_cover,
		cover_bindings,
		0.95,
		4,
		&"weather_routine_history"
	)
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
		{DriveState.HUNGER: 0.54},
		[project_seed],
		[],
		[weather_habit]
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

	var drive_definition = DriveCandidateDefinition.new(DriveState.HUNGER, seek_food, 0.1)
	var opportunity_definition = PerceivedOpportunityDefinition.new(
		EpistemicClaim.Kind.PROPERTY,
		edible_property,
		seek_food,
		DecisionCandidate.Scope.INTENTIONAL,
		0.1
	)
	var drive_progression = DriveProgressionService.new(_owners.drives, {DriveState.HUNGER: 0.04})
	var drive_source = DriveCandidateSource.new(_owners.drives, [drive_definition])
	var grounded_opportunities = DriveBackedBelievedOpportunityCandidateSource.new(
		_owners.drives,
		_owners.beliefs,
		[drive_definition],
		[opportunity_definition]
	)
	var scheduler = SemanticDueScheduler.new()
	scheduler.register(&"drives", 1.0, 0.0)
	var drive_due_gate = DueElapsedGate.new(scheduler, &"drives")

	var consume_definition = ActionDefinition.new(
		consume_food,
		[&"actor", &"target"] as Array[StringName],
		RequirementPredicate.all_of([]),
		ActionDefinition.InterruptionClass.ANYTIME
	)
	var consume_resolution = ActionResolutionDefinition.new(
		consume_food,
		0.8,
		0.5,
		[],
		food_consumed,
		&"consume_food_default"
	)
	var shelter_action_definition = ActionDefinition.new(
		contribute_shelter,
		[&"actor", &"target"] as Array[StringName],
		RequirementPredicate.all_of([]),
		ActionDefinition.InterruptionClass.ANYTIME
	)
	var shelter_action_resolution = ActionResolutionDefinition.new(
		contribute_shelter,
		0.8,
		0.5,
		[],
		shelter_contribution,
		&"contribute_shelter_default"
	)
	var food_executor = TargetedActionExecutionCoordinator.new(
		_motion,
		runtime.action_execution,
		_wilson_ref,
		seek_food,
		consume_definition,
		consume_resolution
	)
	var project_executor = TargetedActionExecutionCoordinator.new(
		_motion,
		runtime.action_execution,
		_wilson_ref,
		continue_shelter,
		shelter_action_definition,
		shelter_action_resolution
	)
	var cover_executor = DirectTargetMotionExecutionCoordinator.new(
		_motion,
		_wilson_ref,
		[seek_cover]
	)
	var executor = CompositeSelectedIntentionExecutor.new([food_executor, project_executor, cover_executor])
	var drive_consequence = GroundedDriveConsequenceService.new(
		_owners.drives,
		[DriveConsequenceDefinition.new(consume_food, DriveState.HUNGER, -0.45, food_consumed)]
	)
	var intention_completion = GroundedIntentionCompletionService.new(
		_owners.current_intention,
		[IntentionCompletionDefinition.new(seek_food, consume_food, food_consumed)]
	)
	var shelter_project_definition = ProjectDefinition.new(
		shelter_project_definition_id,
		contribute_shelter,
		shelter_contribution,
		&"target",
		&"target",
		continue_shelter,
		SHELTER_REQUIRED_CONTRIBUTIONS,
		0.35
	)
	var project_contribution = ProjectContributionService.new(_owners.projects, [shelter_project_definition])
	var project_source = ProjectCandidateSource.new(_owners.projects, [shelter_project_definition])
	var weather_cues = PerceivedCueService.new([
		ObservedEventCueRule.new(weather_worsened, &"dangerous_weather", &"hearing")
	])
	var weather_habit_source = PerceivedHabitCandidateSource.new(weather_cues, _owners.habits, 0.5, 0.2)
	var context_trigger_source = PerceivedContextTransitionTriggerSource.new(content)
	var base_decision_commit = DecisionCommitCoordinator.new(_owners.current_intention)
	var decision_commit = InterruptingDecisionCommitCoordinator.new(
		runtime.activity_query,
		runtime.action_execution,
		base_decision_commit
	)
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
		decision_commit,
		_trace_sink,
		drive_progression,
		drive_source,
		project_contribution,
		project_source,
		[grounded_opportunities],
		null,
		null,
		null,
		context_trigger_source,
		null,
		executor,
		drive_due_gate,
		drive_consequence,
		weather_habit_source,
		intention_completion
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
	var project = null if _owners == null or _shelter_project_id == null else _owners.projects.get_instance(_shelter_project_id)
	var intention_key := ""
	if _owners != null and _owners.current_intention.has_current():
		intention_key = _owners.current_intention.current().intention_id.sort_key()
	return {
		"live": is_live(),
		"simulation_time": -1.0 if _host == null else _host.simulation_time(),
		"semantic_step": -1 if _host == null else _host.semantic_step_count(),
		"hunger": -1.0 if _owners == null else _owners.drives.value(DriveState.HUNGER),
		"hunger_band": -1 if _owners == null else _owners.drives.band(DriveState.HUNGER),
		"has_intention": false if _owners == null else _owners.current_intention.has_current(),
		"intention_key": intention_key,
		"motion_status": -1 if _motion == null or _wilson_ref == null else _motion.get_status(_wilson_ref),
		"wilson_position": $Wilson.global_position,
		"trace_count": _trace_sink.traces.size(),
		"grounded_consumptions": _trace_sink.grounded_consumptions,
		"grounded_intention_completions": _trace_sink.grounded_intention_completions,
		"project_contributions": 0 if project == null else project.contribution_count,
		"project_active": false if project == null else project.is_active(),
		"grounded_project_contributions": _trace_sink.grounded_project_contributions,
		"weather": &"" if _owners == null else _owners.environment.weather,
		"daylight_phase": &"" if _owners == null else _owners.environment.daylight_phase,
		"weather_transition_index": -1 if _owners == null else _owners.environment.weather_transition_index,
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
	_drive_label.text = "Hunger: %.3f   band %d   meals %d" % [
		_owners.drives.value(DriveState.HUNGER),
		_owners.drives.band(DriveState.HUNGER),
		_trace_sink.grounded_consumptions,
	]
	var project = _owners.projects.get_instance(_shelter_project_id)
	_project_label.text = "Shelter project: %d/%d contributions   active=%s" % [
		0 if project == null else project.contribution_count,
		SHELTER_REQUIRED_CONTRIBUTIONS,
		false if project == null else project.is_active(),
	]
	_motion_label.text = "Motion: %s   pos (%.1f, %.1f)" % [
		_motion_status_name(_motion.get_status(_wilson_ref)),
		$Wilson.global_position.x,
		$Wilson.global_position.z,
	]
	_trace_label.text = "Recent traces: %d   completed food intentions: %d   grounded work: %d" % [
		_trace_sink.traces.size(),
		_trace_sink.grounded_intention_completions,
		_trace_sink.grounded_project_contributions,
	]


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
