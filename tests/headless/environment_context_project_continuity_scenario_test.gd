extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const EventDefinition = preload("res://src/domain/content/event_definition.gd")
const ContentRegistry = preload("res://src/domain/content/content_registry.gd")
const ObservedEvent = preload("res://src/domain/cognition/observed_event.gd")
const PerceptionResult = preload("res://src/domain/cognition/perception_result.gd")
const ObservedEventCueRule = preload("res://src/domain/cognition/observed_event_cue_rule.gd")
const PerceivedCueService = preload("res://src/domain/cognition/perceived_cue_service.gd")
const PerceivedHabitCandidateSource = preload("res://src/domain/cognition/perceived_habit_candidate_source.gd")
const HabitStore = preload("res://src/domain/cognition/habit_store.gd")
const BeliefStore = preload("res://src/domain/cognition/belief_store.gd")
const CurrentIntentionStore = preload("res://src/domain/cognition/current_intention_store.gd")
const DecisionRouter = preload("res://src/domain/cognition/decision_router.gd")
const DecisionCommitCoordinator = preload("res://src/application/simulation/decision_commit_coordinator.gd")
const ProjectDefinition = preload("res://src/domain/projects/project_definition.gd")
const ProjectInstance = preload("res://src/domain/projects/project_instance.gd")
const ProjectStore = preload("res://src/domain/projects/project_store.gd")
const ProjectCandidateSource = preload("res://src/domain/projects/project_candidate_source.gd")
const PerceivedContextTransitionTriggerSource = preload("res://src/application/simulation/perceived_context_transition_trigger_source.gd")
const ReconsiderationGate = preload("res://src/application/simulation/reconsideration_gate.gd")
const SimulationOrchestrator = preload("res://src/application/simulation/simulation_orchestrator.gd")
const SimulationStepContext = preload("res://src/application/simulation/simulation_step_context.gd")
const WorldAdvanceResult = preload("res://src/application/simulation/world_advance_result.gd")

var _failures: Array[String] = []
var _completed := false


class WorldAdvanceStub:
	extends RefCounted
	func advance(_elapsed: float, _step):
		return WorldAdvanceResult.new()


class ActionExecutionStub:
	extends RefCounted
	func advance(_execution_id: StringName, _elapsed: float):
		return null


class WorldCommandsStub:
	extends RefCounted
	func apply_outcome(_outcome):
		return null


class DerivedInvalidatorStub:
	extends RefCounted
	func apply(_change_set):
		return []


class ProjectContributionStub:
	extends RefCounted
	func apply_grounded(_outcome, _commit_result):
		return null


class ActivityQueryStub:
	extends RefCounted
	var intentions
	func _init(p_intentions) -> void:
		intentions = p_intentions
	func active_execution_id() -> StringName:
		return &""
	func current_intention():
		return intentions.current() if intentions.has_current() else null


class PerceptionAccessStub:
	extends RefCounted
	func resolve(_events: Array, _step) -> Dictionary:
		return {}


class MutablePerceptionStub:
	extends RefCounted
	var result = PerceptionResult.new()
	func perceive(_events: Array, _access: Dictionary):
		return result


class LearningStub:
	extends RefCounted
	func process(perception_result) -> Dictionary:
		return {"observed": perception_result.observed_events.size()}


class OpportunityStub:
	extends RefCounted
	func generate(_perception_result, _belief_store, _definitions: Array) -> Array:
		return []


class TraceSinkStub:
	extends RefCounted
	var traces: Array = []
	func record(trace) -> void:
		traces.append(trace)


func _init() -> void:
	_run_slice()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS environment_context_project_continuity_scenario_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL environment_context_project_continuity_scenario_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	var weather_worsened = DomainId.event_definition(&"weather_worsened")
	var weather_improved = DomainId.event_definition(&"weather_improved")
	var content = ContentRegistry.new()
	_expect_true(content.register_event_definition(EventDefinition.new(
		weather_worsened, [], [&"hearing"], 1.0, EventDefinition.AccessScope.AMBIENT, true
	)).ok, "worsening weather context event registers")
	_expect_true(content.register_event_definition(EventDefinition.new(
		weather_improved, [], [&"hearing"], 1.0, EventDefinition.AccessScope.AMBIENT, true
	)).ok, "improving weather context event registers")
	_expect_true(content.seal().ok, "context content seals")

	var build_intention = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"continue_shelter_project")
	var seek_cover_intention = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"seek_safer_cover")
	var project_definition_id = DomainId.new(DomainId.Kind.PROJECT_DEFINITION, &"build_shelter")
	var project_instance_id = DomainId.new(DomainId.Kind.PROJECT_INSTANCE, &"build_shelter_1")
	var project_bindings = RoleBinding.new()
	var project_definition = ProjectDefinition.new(
		project_definition_id,
		DomainId.action(&"contribute_shelter"),
		DomainId.event_definition(&"shelter_contribution_committed"),
		&"project_subject",
		&"target",
		build_intention,
		3,
		0.30
	)
	var projects = ProjectStore.new()
	_expect_true(projects.add(ProjectInstance.new(
		project_instance_id, project_definition_id, project_bindings, ProjectInstance.Lifecycle.ACTIVE, 1
	)), "partially progressed project persists")
	var project_candidates = ProjectCandidateSource.new(projects, [project_definition])

	var shelter_bindings = RoleBinding.new()
	var habits = HabitStore.new()
	habits.restore_entry(&"dangerous_weather", seek_cover_intention, shelter_bindings, 0.95, 4, &"weather_routine_history")
	var cue_service = PerceivedCueService.new([
		ObservedEventCueRule.new(weather_worsened, &"dangerous_weather", &"hearing"),
	])
	var habit_candidates = PerceivedHabitCandidateSource.new(cue_service, habits)

	var intentions = CurrentIntentionStore.new()
	_expect_true(intentions.select(build_intention, project_bindings, &"project_before_weather").ok, "project begins as current intention")
	var perception = MutablePerceptionStub.new()
	var traces = TraceSinkStub.new()
	var context_triggers = PerceivedContextTransitionTriggerSource.new(content)
	var orchestrator = SimulationOrchestrator.new(
		WorldAdvanceStub.new(),
		ActionExecutionStub.new(),
		WorldCommandsStub.new(),
		DerivedInvalidatorStub.new(),
		ActivityQueryStub.new(intentions),
		PerceptionAccessStub.new(),
		perception,
		LearningStub.new(),
		OpportunityStub.new(),
		BeliefStore.new(),
		[],
		DecisionRouter.new(),
		DecisionCommitCoordinator.new(intentions),
		traces,
		null,
		null,
		ProjectContributionStub.new(),
		project_candidates,
		[],
		null,
		null,
		null,
		context_triggers,
		null,
		null,
		null,
		null,
		habit_candidates
	)

	perception.result = PerceptionResult.new([
		ObservedEvent.new(weather_worsened, null, &"ambient_weather_worsened_1", {}, [&"hearing"]),
	])
	var worsened_step = orchestrator.advance(SimulationStepContext.new(&"weather_worsens", 0.1, 0.1, null, []))
	_expect_true(worsened_step.decision != null and worsened_step.decision.selected_candidate != null, "perceived context transition opens reconsideration")
	if worsened_step.decision != null and worsened_step.decision.selected_candidate != null:
		_expect_equal(worsened_step.decision.selected_candidate.intention_id.sort_key(), seek_cover_intention.sort_key(), "weather cue makes learned shelter response beat project continuation")
	_expect_true(intentions.has_current(), "context decision remains an ordinary committed intention")
	if intentions.has_current():
		_expect_equal(intentions.current().intention_id.sort_key(), seek_cover_intention.sort_key(), "Wilson redirects to cover after perceiving worsening context")
	var persisted_project = projects.get_instance(project_instance_id)
	_expect_true(persisted_project != null and persisted_project.is_active(), "weather redirect does not discard project owner state")
	if persisted_project != null:
		_expect_equal(persisted_project.contribution_count, 1, "weather redirect preserves partial project progress")

	perception.result = PerceptionResult.new([
		ObservedEvent.new(weather_improved, null, &"ambient_weather_improved_1", {}, [&"hearing"]),
	])
	var improved_step = orchestrator.advance(SimulationStepContext.new(&"weather_improves", 0.1, 0.2, null, []))
	_expect_true(improved_step.decision != null and improved_step.decision.selected_candidate != null, "second perceived context transition reopens reconsideration")
	if improved_step.decision != null and improved_step.decision.selected_candidate != null:
		_expect_equal(improved_step.decision.selected_candidate.intention_id.sort_key(), build_intention.sort_key(), "persistent project becomes selected again after shelter cue disappears")
	if intentions.has_current():
		_expect_equal(intentions.current().intention_id.sort_key(), build_intention.sort_key(), "Wilson returns to persistent project after context improves")
	_expect_true(projects.get_instance(project_instance_id).is_active(), "returning to project uses same persistent project instance")
	_expect_equal(projects.get_instance(project_instance_id).contribution_count, 1, "return to project preserves prior progress exactly")

	_expect_equal(
		context_triggers.derive(perception.result),
		[ReconsiderationGate.Trigger.CONTEXT_TRANSITION],
		"authored observed context event derives only CONTEXT_TRANSITION"
	)
	_completed = true


func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)


func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
