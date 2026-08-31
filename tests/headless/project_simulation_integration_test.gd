extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const ActionOutcome = preload("res://src/domain/actions/action_outcome.gd")
const BeliefStore = preload("res://src/domain/cognition/belief_store.gd")
const CurrentIntentionStore = preload("res://src/domain/cognition/current_intention_store.gd")
const DecisionRouter = preload("res://src/domain/cognition/decision_router.gd")
const PerceptionResult = preload("res://src/domain/cognition/perception_result.gd")
const ProjectDefinition = preload("res://src/domain/projects/project_definition.gd")
const ProjectInstance = preload("res://src/domain/projects/project_instance.gd")
const ProjectStore = preload("res://src/domain/projects/project_store.gd")
const ProjectContributionService = preload("res://src/domain/projects/project_contribution_service.gd")
const ProjectCandidateSource = preload("res://src/domain/projects/project_candidate_source.gd")
const SemanticChangeSet = preload("res://src/domain/world/semantic_change_set.gd")
const WorldCommitResult = preload("res://src/domain/world/world_commit_result.gd")
const DecisionCommitCoordinator = preload("res://src/application/simulation/decision_commit_coordinator.gd")
const SimulationOrchestrator = preload("res://src/application/simulation/simulation_orchestrator.gd")
const SimulationStepContext = preload("res://src/application/simulation/simulation_step_context.gd")
const WorldAdvanceResult = preload("res://src/application/simulation/world_advance_result.gd")

var _failures: Array[String] = []
var _completed := false

class WorldAdvanceStub:
	extends RefCounted
	func advance(_elapsed: float, _step):
		return WorldAdvanceResult.new()

class ActionProgressStub:
	extends RefCounted
	var new_outcome
	func _init(p_outcome) -> void:
		new_outcome = p_outcome

class ActionExecutionStub:
	extends RefCounted
	var outcome
	func _init(p_outcome) -> void:
		outcome = p_outcome
	func advance(_execution_id: StringName, _elapsed: float):
		return ActionProgressStub.new(outcome)

class WorldCommandsStub:
	extends RefCounted
	func apply_outcome(_outcome):
		return WorldCommitResult.new(true, [], [], [], SemanticChangeSet.new())

class DerivedInvalidatorStub:
	extends RefCounted
	func apply(_change_set):
		return {}

class ActivityQueryStub:
	extends RefCounted
	var intention_store
	func _init(p_intention_store) -> void:
		intention_store = p_intention_store
	func active_execution_id() -> StringName:
		return &"exec_project"
	func current_intention():
		return intention_store.current() if intention_store.has_current() else null

class PerceptionAccessStub:
	extends RefCounted
	func resolve(_events: Array, _step) -> Dictionary:
		return {}

class PerceptionStub:
	extends RefCounted
	func perceive(_events: Array, _access: Dictionary):
		return PerceptionResult.new([], [])

class LearningStub:
	extends RefCounted
	func process(_perception_result) -> Dictionary:
		return {}

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
		print("PASS project_simulation_integration_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL project_simulation_integration_test: %d failure(s)" % _failures.size())
	quit(1)

func _run_slice() -> void:
	var shelter = RuntimeWorldRef.entity(DomainId.entity(&"shelter_1"))
	var action_id = DomainId.action(&"attach_shelter_material")
	var event_type = DomainId.event_definition(&"shelter_material_attached")
	var intention_id = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"continue_shelter_project")
	var definition_id = DomainId.new(DomainId.Kind.PROJECT_DEFINITION, &"small_shelter")
	var instance_id = DomainId.new(DomainId.Kind.PROJECT_INSTANCE, &"small_shelter_1")

	var project_binding = RoleBinding.new()
	project_binding.bind(&"project_subject", shelter)
	var definition = ProjectDefinition.new(definition_id, action_id, event_type, &"project_subject", &"target", intention_id, 2, 0.4)
	var instance = ProjectInstance.new(instance_id, definition_id, project_binding)
	var projects = ProjectStore.new()
	_expect_true(projects.add(instance), "project is registered")
	var contribution = ProjectContributionService.new(projects, [definition])
	var project_source = ProjectCandidateSource.new(projects, [definition])

	var action_binding = RoleBinding.new()
	action_binding.bind(&"target", shelter)
	var outcome = ActionOutcome.new(&"exec_project", action_id, action_binding, [], event_type)
	var intentions = CurrentIntentionStore.new()
	var trace_sink = TraceSinkStub.new()
	var orchestrator = SimulationOrchestrator.new(
		WorldAdvanceStub.new(),
		ActionExecutionStub.new(outcome),
		WorldCommandsStub.new(),
		DerivedInvalidatorStub.new(),
		ActivityQueryStub.new(intentions),
		PerceptionAccessStub.new(),
		PerceptionStub.new(),
		LearningStub.new(),
		OpportunityStub.new(),
		BeliefStore.new(),
		[],
		DecisionRouter.new(),
		DecisionCommitCoordinator.new(intentions),
		trace_sink,
		null,
		null,
		contribution,
		project_source
	)

	var result = orchestrator.advance(SimulationStepContext.new(&"project_step_1", 1.0, 1.0, null, []))
	_expect_equal(instance.contribution_count, 1, "grounded committed outcome advances project before candidate generation")
	_expect_equal(instance.lifecycle, ProjectInstance.Lifecycle.ACTIVE, "project remains active until completion condition")
	_expect_equal(result.candidates.size(), 1, "active project candidate joins normal decision competition")
	if result.candidates.size() == 1:
		_expect_equal(result.candidates[0].intention_id.key(), intention_id.key(), "project candidate retains semantic intention")
	_expect_true(intentions.has_current(), "selected project intention commits through cognition owner")
	_expect_equal(trace_sink.traces.size(), 1, "project-integrated step remains traceable")
	if trace_sink.traces.size() == 1:
		_expect_true(trace_sink.traces[0].stage_results.has(&"project_progression"), "trace records grounded project progression")
		_expect_true(trace_sink.traces[0].stage_results.has(&"decision_candidates"), "trace records combined candidate set")

	_completed = true

func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)

func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
