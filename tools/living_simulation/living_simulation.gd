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
const ActorStateBootstrapSeed = preload("res://src/application/bootstrap/actor_state_bootstrap_seed.gd")
const ActorRelationshipBootstrapSeed = preload("res://src/application/bootstrap/actor_relationship_bootstrap_seed.gd")
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
const ActorProfileDefinition = preload("res://src/domain/actors/actor_profile_definition.gd")
const ActorBehaviorRule = preload("res://src/domain/actors/actor_behavior_rule.gd")
const ShallowActorAdvanceService = preload("res://src/domain/actors/shallow_actor_advance_service.gd")
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
const ShallowActorMotionCoordinator = preload("res://src/application/simulation/shallow_actor_motion_coordinator.gd")
const SimulationOrchestrator = preload("res://src/application/simulation/simulation_orchestrator.gd")
const GodotSceneSpatialRegistry = preload("res://src/infrastructure/spatial/godot_scene_spatial_registry.gd")
const GodotMotionAdapter = preload("res://src/infrastructure/spatial/godot_motion_adapter.gd")
const GodotSimulationHost = preload("res://src/infrastructure/spatial/godot_simulation_host.gd")

const SCENARIO_NAME := &"living_island_playground"
const GAMEPLAY_SEED := 61007
const MAX_NAVIGATION_SYNC_FRAMES := 120
const SHELTER_REQUIRED_CONTRIBUTIONS := 100
const CLEAR_DURATION_SECONDS := 24.0
const RAIN_DURATION_SECONDS := 12.0

var _owners
var _motion
var _host
var _wilson_ref
var _food_ref
var _shelter_ref
var _rest_ref
var _curiosity_ref
var _gerald_ref
var _shelter_project_id
var _gerald_service
var _gerald_motion_coordinator
var _gerald_last_semantic_time := 0.0
var _gerald_motion_requests := 0
var _gerald_arrivals := 0
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
	var grounded_rests := 0
	var grounded_explorations := 0
	var grounded_intention_completions := 0
	var grounded_project_contributions := 0

	func record(trace) -> void:
		traces.append(trace)
		var action_progress = trace.stage_results.get(&"action_progress")
		if action_progress != null and action_progress.new_outcome != null:
			var action_value := String(action_progress.new_outcome.action_id.value)
			match action_value:
				"consume_food":
					grounded_consumptions += 1
				"rest":
					grounded_rests += 1
				"inspect_curiosity":
					grounded_explorations += 1
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


func _physics_process(_delta: float) -> void:
	_advance_gerald()


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
			_fail_boot("Living-island content registration failed")
			return
	var seal_result = content.seal()
	if not seal_result.ok:
		_fail_boot("Content registry failed to seal: %s" % str(seal_result.diagnostics))
		return

	var island_place_id = DomainId.place(&"living_island")
	var food_entity_id = DomainId.entity(&"food_patch_001")
	var shelter_entity_id = DomainId.entity(&"shelter_001")
	var rest_entity_id = DomainId.entity(&"rest_mat_001")
	var curiosity_entity_id = DomainId.entity(&"shipwreck_relic_001")
	var gerald_entity_id = DomainId.entity(&"gerald")
	var gerald_roost = DomainId.place(&"gerald_roost")
	var gerald_beach = DomainId.place(&"gerald_beach")
	var gerald_camp = DomainId.place(&"gerald_camp")
	var gerald_lookout = DomainId.place(&"gerald_lookout")

	var edible_property = DomainId.property(&"edible")
	var restful_property = DomainId.property(&"restful")
	var interesting_property = DomainId.property(&"interesting")
	var seek_food = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"seek_food")
	var seek_rest = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"seek_rest")
	var seek_stimulation = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"seek_stimulation")
	var continue_shelter = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"continue_shelter_project")
	var seek_cover = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"seek_safer_cover")
	var consume_food = DomainId.action(&"consume_food")
	var rest_action = DomainId.action(&"rest")
	var inspect_curiosity = DomainId.action(&"inspect_curiosity")
	var contribute_shelter = DomainId.action(&"contribute_shelter")
	var food_consumed = DomainId.event_definition(&"food_consumed")
	var rest_completed = DomainId.event_definition(&"rest_completed")
	var curiosity_inspected = DomainId.event_definition(&"curiosity_inspected")
	var shelter_contribution = DomainId.event_definition(&"shelter_contribution_committed")
	var shelter_project_definition_id = DomainId.new(DomainId.Kind.PROJECT_DEFINITION, &"build_shelter")
	_shelter_project_id = DomainId.new(DomainId.Kind.PROJECT_INSTANCE, &"build_shelter_001")
	_wilson_ref = RuntimeWorldRef.wilson()
	_food_ref = RuntimeWorldRef.entity(food_entity_id)
	_shelter_ref = RuntimeWorldRef.entity(shelter_entity_id)
	_rest_ref = RuntimeWorldRef.entity(rest_entity_id)
	_curiosity_ref = RuntimeWorldRef.entity(curiosity_entity_id)
	_gerald_ref = RuntimeWorldRef.entity(gerald_entity_id)

	var known_food = BeliefProposition.new(EpistemicClaim.property_claim(_food_ref, edible_property, true))
	var known_rest = BeliefProposition.new(EpistemicClaim.property_claim(_rest_ref, restful_property, true))
	var known_curiosity = BeliefProposition.new(EpistemicClaim.property_claim(_curiosity_ref, interesting_property, true))
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
		island_place_id,
		[
			EntityBootstrapSeed.new(food_entity_id, DomainId.entity_type(&"food_patch"), island_place_id, 0, {edible_property.key(): true}),
			EntityBootstrapSeed.new(shelter_entity_id, DomainId.entity_type(&"shelter"), island_place_id),
			EntityBootstrapSeed.new(rest_entity_id, DomainId.entity_type(&"rest_spot"), island_place_id, 0, {restful_property.key(): true}),
			EntityBootstrapSeed.new(curiosity_entity_id, DomainId.entity_type(&"shipwreck_relic"), island_place_id, 0, {interesting_property.key(): true}),
			EntityBootstrapSeed.new(gerald_entity_id, DomainId.entity_type(&"seagull"), gerald_roost),
		],
		[],
		[
			BeliefBootstrapSeed.new(known_food, 0.9, 1, &"new_run_seed", &"memory"),
			BeliefBootstrapSeed.new(known_rest, 0.9, 1, &"new_run_seed", &"memory"),
			BeliefBootstrapSeed.new(known_curiosity, 0.85, 1, &"new_run_seed", &"memory"),
		],
		null,
		1.0,
		{
			DriveState.HUNGER: 0.54,
			DriveState.ENERGY: 0.05,
			DriveState.STIMULATION: 0.05,
		},
		[project_seed],
		[],
		[weather_habit],
		[],
		null,
		&"clear",
		&"day",
		[],
		[ActorStateBootstrapSeed.new(_gerald_ref, &"gerald", &"roost")],
		[ActorRelationshipBootstrapSeed.new(_gerald_ref, _wilson_ref, 0.45, 3, &"shared_island_history")]
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
	var wilson_navigation_agent: NavigationAgent3D = $Wilson/NavigationAgent3D
	var gerald_body: CharacterBody3D = $Gerald
	var gerald_navigation_agent: NavigationAgent3D = $Gerald/NavigationAgent3D
	var spatial_bindings: Array = [
		[_wilson_ref, wilson_body],
		[_food_ref, $FoodPatch],
		[_shelter_ref, $Shelter],
		[_rest_ref, $RestSpot],
		[_curiosity_ref, $CuriositySpot],
		[_gerald_ref, gerald_body],
		[RuntimeWorldRef.place(gerald_roost), $GeraldTargets/Roost],
		[RuntimeWorldRef.place(gerald_beach), $GeraldTargets/Beach],
		[RuntimeWorldRef.place(gerald_camp), $GeraldTargets/Camp],
		[RuntimeWorldRef.place(gerald_lookout), $GeraldTargets/Lookout],
	]
	for binding in spatial_bindings:
		if not registry.bind(binding[0], binding[1]):
			_fail_boot("Scene registry rejected binding for %s" % binding[0].sort_key())
			return

	_motion = GodotMotionAdapter.new(registry)
	if not _motion.bind_actor(_wilson_ref, wilson_body, wilson_navigation_agent, 2.4):
		_fail_boot("Godot motion adapter rejected Wilson binding")
		return
	if not _motion.bind_actor(_gerald_ref, gerald_body, gerald_navigation_agent, 2.0):
		_fail_boot("Godot motion adapter rejected Gerald binding")
		return

	var navigation_ready := false
	for _frame in range(MAX_NAVIGATION_SYNC_FRAMES):
		await get_tree().physics_frame
		var wilson_map: RID = wilson_navigation_agent.get_navigation_map()
		var gerald_map: RID = gerald_navigation_agent.get_navigation_map()
		if wilson_map.is_valid() and gerald_map.is_valid() \
			and NavigationServer3D.map_get_iteration_id(wilson_map) > 0 \
			and NavigationServer3D.map_get_iteration_id(gerald_map) > 0:
			navigation_ready = true
			break
	if not navigation_ready:
		_fail_boot("Navigation map did not synchronize for living-island actors")
		return

	var hunger_definition = DriveCandidateDefinition.new(DriveState.HUNGER, seek_food, 0.10)
	var energy_definition = DriveCandidateDefinition.new(DriveState.ENERGY, seek_rest, 0.07)
	var stimulation_definition = DriveCandidateDefinition.new(DriveState.STIMULATION, seek_stimulation, 0.04)
	var drive_definitions: Array = [hunger_definition, energy_definition, stimulation_definition]
	var opportunity_definitions: Array = [
		PerceivedOpportunityDefinition.new(EpistemicClaim.Kind.PROPERTY, edible_property, seek_food, DecisionCandidate.Scope.INTENTIONAL, 0.10),
		PerceivedOpportunityDefinition.new(EpistemicClaim.Kind.PROPERTY, restful_property, seek_rest, DecisionCandidate.Scope.INTENTIONAL, 0.08),
		PerceivedOpportunityDefinition.new(EpistemicClaim.Kind.PROPERTY, interesting_property, seek_stimulation, DecisionCandidate.Scope.INTENTIONAL, 0.06),
	]
	var drive_progression = DriveProgressionService.new(_owners.drives, {
		DriveState.HUNGER: 0.04,
		DriveState.ENERGY: 0.018,
		DriveState.STIMULATION: 0.014,
	})
	var drive_source = DriveCandidateSource.new(_owners.drives, drive_definitions)
	var grounded_opportunities = DriveBackedBelievedOpportunityCandidateSource.new(
		_owners.drives,
		_owners.beliefs,
		drive_definitions,
		opportunity_definitions
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
	var consume_resolution = ActionResolutionDefinition.new(consume_food, 0.8, 0.5, [], food_consumed, &"consume_food_default")
	var rest_definition = ActionDefinition.new(
		rest_action,
		[&"actor", &"target"] as Array[StringName],
		RequirementPredicate.all_of([]),
		ActionDefinition.InterruptionClass.ANYTIME
	)
	var rest_resolution = ActionResolutionDefinition.new(rest_action, 2.4, 0.65, [], rest_completed, &"rest_default")
	var explore_definition = ActionDefinition.new(
		inspect_curiosity,
		[&"actor", &"target"] as Array[StringName],
		RequirementPredicate.all_of([]),
		ActionDefinition.InterruptionClass.ANYTIME
	)
	var explore_resolution = ActionResolutionDefinition.new(inspect_curiosity, 1.8, 0.6, [], curiosity_inspected, &"inspect_curiosity_default")
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
	var food_executor = TargetedActionExecutionCoordinator.new(_motion, runtime.action_execution, _wilson_ref, seek_food, consume_definition, consume_resolution)
	var rest_executor = TargetedActionExecutionCoordinator.new(_motion, runtime.action_execution, _wilson_ref, seek_rest, rest_definition, rest_resolution)
	var explore_executor = TargetedActionExecutionCoordinator.new(_motion, runtime.action_execution, _wilson_ref, seek_stimulation, explore_definition, explore_resolution)
	var project_executor = TargetedActionExecutionCoordinator.new(_motion, runtime.action_execution, _wilson_ref, continue_shelter, shelter_action_definition, shelter_action_resolution)
	var cover_executor = DirectTargetMotionExecutionCoordinator.new(_motion, _wilson_ref, [seek_cover])
	var executor = CompositeSelectedIntentionExecutor.new([
		food_executor,
		rest_executor,
		explore_executor,
		project_executor,
		cover_executor,
	])
	var drive_consequence = GroundedDriveConsequenceService.new(
		_owners.drives,
		[
			DriveConsequenceDefinition.new(consume_food, DriveState.HUNGER, -0.45, food_consumed),
			DriveConsequenceDefinition.new(rest_action, DriveState.ENERGY, -0.62, rest_completed),
			DriveConsequenceDefinition.new(inspect_curiosity, DriveState.STIMULATION, -0.58, curiosity_inspected),
		]
	)
	var intention_completion = GroundedIntentionCompletionService.new(
		_owners.current_intention,
		[
			IntentionCompletionDefinition.new(seek_food, consume_food, food_consumed),
			IntentionCompletionDefinition.new(seek_rest, rest_action, rest_completed),
			IntentionCompletionDefinition.new(seek_stimulation, inspect_curiosity, curiosity_inspected),
		]
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
	var weather_habit_source = PerceivedHabitCandidateSource.new(
		weather_cues,
		_owners.habits,
		0.5,
		0.2,
		DecisionCandidate.Scope.TACTICAL
	)
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

	var gerald_profile = ActorProfileDefinition.new(&"gerald", &"roost", 4.0)
	var gerald_rules: Array = [
		ActorBehaviorRule.new(&"gerald_to_beach", &"gerald", &"roost", &"", &"beach", gerald_beach, 0.60),
		ActorBehaviorRule.new(&"gerald_to_camp", &"gerald", &"beach", &"", &"camp", gerald_camp, 0.60),
		ActorBehaviorRule.new(&"gerald_to_lookout", &"gerald", &"camp", &"", &"lookout", gerald_lookout, 0.60),
		ActorBehaviorRule.new(&"gerald_to_roost", &"gerald", &"lookout", &"", &"roost", gerald_roost, 0.60),
	]
	_gerald_service = ShallowActorAdvanceService.new(
		_owners.actors,
		[gerald_profile],
		gerald_rules,
		_owners.entities,
		_owners.actor_relationships
	)
	_gerald_motion_coordinator = ShallowActorMotionCoordinator.new(_motion, _owners.entities)

	_host = GodotSimulationHost.new()
	_host.name = "GodotSimulationHost"
	add_child(_host)
	_host.configure(orchestrator, _motion, 0.1, 0.0)
	_gerald_last_semantic_time = _host.simulation_time()


func _advance_gerald() -> void:
	if _boot_error != "" or _host == null or _gerald_service == null or _gerald_motion_coordinator == null:
		return
	var simulation_time: float = _host.simulation_time()
	var elapsed: float = simulation_time - _gerald_last_semantic_time
	if elapsed <= 0.0:
		return
	_gerald_last_semantic_time = simulation_time

	var reconciliation: Dictionary = _gerald_motion_coordinator.reconcile()
	if not reconciliation.get("diagnostics", []).is_empty():
		_fail_boot("Gerald motion reconciliation failed: %s" % str(reconciliation.get("diagnostics", [])))
		return
	_gerald_arrivals += reconciliation.get("arrived", []).size()
	if _gerald_motion_coordinator.has_pending(_gerald_ref):
		return

	var actor_result: Dictionary = _gerald_service.advance_deferred(elapsed, {})
	if not actor_result.get("diagnostics", []).is_empty():
		_fail_boot("Gerald shallow behavior failed: %s" % str(actor_result.get("diagnostics", [])))
		return
	for decision in actor_result.get("movement_requests", []):
		if _gerald_motion_coordinator.request(decision):
			_gerald_motion_requests += 1


func is_live() -> bool:
	return _boot_error == "" and _owners != null and _host != null


func boot_error() -> String:
	return _boot_error


func observation_snapshot() -> Dictionary:
	var project = null
	var gerald_state = null
	var gerald_entity = null
	var gerald_affinity := 0.0
	if _owners != null:
		project = _owners.projects.get_instance(_shelter_project_id)
		gerald_state = _owners.actors.get_state(_gerald_ref)
		gerald_entity = _owners.entities.get_entity(_gerald_ref.id)
		gerald_affinity = _owners.actor_relationships.affinity(_gerald_ref, _wilson_ref)
	var intention_key := ""
	if _owners != null and _owners.current_intention.has_current():
		intention_key = _owners.current_intention.current().intention_id.sort_key()
	return {
		"live": is_live(),
		"simulation_time": -1.0 if _host == null else _host.simulation_time(),
		"semantic_step": -1 if _host == null else _host.semantic_step_count(),
		"hunger": -1.0 if _owners == null else _owners.drives.value(DriveState.HUNGER),
		"hunger_band": -1 if _owners == null else _owners.drives.band(DriveState.HUNGER),
		"energy": -1.0 if _owners == null else _owners.drives.value(DriveState.ENERGY),
		"energy_band": -1 if _owners == null else _owners.drives.band(DriveState.ENERGY),
		"stimulation": -1.0 if _owners == null else _owners.drives.value(DriveState.STIMULATION),
		"stimulation_band": -1 if _owners == null else _owners.drives.band(DriveState.STIMULATION),
		"has_intention": false if _owners == null else _owners.current_intention.has_current(),
		"intention_key": intention_key,
		"motion_status": -1 if _motion == null or _wilson_ref == null else _motion.get_status(_wilson_ref),
		"wilson_position": $Wilson.global_position,
		"trace_count": _trace_sink.traces.size(),
		"grounded_consumptions": _trace_sink.grounded_consumptions,
		"grounded_rests": _trace_sink.grounded_rests,
		"grounded_explorations": _trace_sink.grounded_explorations,
		"grounded_intention_completions": _trace_sink.grounded_intention_completions,
		"project_contributions": 0 if project == null else project.contribution_count,
		"project_active": false if project == null else project.is_active(),
		"grounded_project_contributions": _trace_sink.grounded_project_contributions,
		"weather": &"" if _owners == null else _owners.environment.weather,
		"daylight_phase": &"" if _owners == null else _owners.environment.daylight_phase,
		"weather_transition_index": -1 if _owners == null else _owners.environment.weather_transition_index,
		"gerald_position": $Gerald.global_position,
		"gerald_motion_status": -1 if _motion == null or _gerald_ref == null else _motion.get_status(_gerald_ref),
		"gerald_pending": false if _gerald_motion_coordinator == null else _gerald_motion_coordinator.has_pending(_gerald_ref),
		"gerald_mode": &"" if gerald_state == null else gerald_state.mode,
		"gerald_place": "" if gerald_entity == null else gerald_entity.place_id.sort_key(),
		"gerald_affinity": gerald_affinity,
		"gerald_motion_requests": _gerald_motion_requests,
		"gerald_arrivals": _gerald_arrivals,
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
	_drive_label.text = "Needs — hunger %.2f [%d]   energy %.2f [%d]   stimulation %.2f [%d]" % [
		_owners.drives.value(DriveState.HUNGER),
		_owners.drives.band(DriveState.HUNGER),
		_owners.drives.value(DriveState.ENERGY),
		_owners.drives.band(DriveState.ENERGY),
		_owners.drives.value(DriveState.STIMULATION),
		_owners.drives.band(DriveState.STIMULATION),
	]
	var project = _owners.projects.get_instance(_shelter_project_id)
	_project_label.text = "Shelter: %d/%d   active=%s   meals=%d rests=%d explores=%d" % [
		0 if project == null else project.contribution_count,
		SHELTER_REQUIRED_CONTRIBUTIONS,
		false if project == null else project.is_active(),
		_trace_sink.grounded_consumptions,
		_trace_sink.grounded_rests,
		_trace_sink.grounded_explorations,
	]
	_motion_label.text = "Wilson motion: %s   pos (%.1f, %.1f)   Gerald: %s arrivals=%d" % [
		_motion_status_name(_motion.get_status(_wilson_ref)),
		$Wilson.global_position.x,
		$Wilson.global_position.z,
		_motion_status_name(_motion.get_status(_gerald_ref)),
		_gerald_arrivals,
	]
	_trace_label.text = "Weather=%s   recent traces=%d   grounded work=%d" % [
		String(_owners.environment.weather),
		_trace_sink.traces.size(),
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