extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const ActionOutcome = preload("res://src/domain/actions/action_outcome.gd")
const BeliefStore = preload("res://src/domain/cognition/belief_store.gd")
const CurrentIntentionStore = preload("res://src/domain/cognition/current_intention_store.gd")
const DriveState = preload("res://src/domain/cognition/drive_state.gd")
const DriveProgressionService = preload("res://src/domain/cognition/drive_progression_service.gd")
const DriveCandidateDefinition = preload("res://src/domain/cognition/drive_candidate_definition.gd")
const DriveCandidateSource = preload("res://src/domain/cognition/drive_candidate_source.gd")
const DriveConsequenceDefinition = preload("res://src/domain/cognition/drive_consequence_definition.gd")
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
const GroundedDriveConsequenceService = preload("res://src/application/simulation/grounded_drive_consequence_service.gd")
const SimulationOrchestrator = preload("res://src/application/simulation/simulation_orchestrator.gd")
const SimulationStepContext = preload("res://src/application/simulation/simulation_step_context.gd")
const ReconsiderationGate = preload("res://src/application/simulation/reconsideration_gate.gd")
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
	var outcomes: Dictionary = {}
	var emitted: Dictionary = {}
	func register(execution_id: StringName, outcome) -> void:
		outcomes[execution_id] = outcome
	func advance(execution_id: StringName, _elapsed: float):
		if emitted.has(execution_id):
			return ActionProgressStub.new(null)
		emitted[execution_id] = true
		return ActionProgressStub.new(outcomes.get(execution_id))

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
	var execution_id: StringName = &""
	func _init(p_intention_store) -> void:
		intention_store = p_intention_store
	func active_execution_id() -> StringName:
		return execution_id
	func current_intention():
		return intention_store.current() if intention_store.has_current() else null

class SelectedIntentionExecutorStub:
	extends RefCounted
	var activity
	var actions
	var project_intention
	var food_intention
	var project_action
	var food_action
	var project_event
	var food_event
	var target
	var project_count := 0
	var food_count := 0
	func _init(p_activity, p_actions, p_project_intention, p_food_intention, p_project_action, p_food_action, p_project_event, p_food_event, p_target) -> void:
		activity = p_activity
		actions = p_actions
		project_intention = p_project_intention
		food_intention = p_food_intention
		project_action = p_project_action
		food_action = p_food_action
		project_event = p_project_event
		food_event = p_food_event
		target = p_target
	func advance(_current_intention):
		return null
	func apply(current_intention):
		if current_intention == null:
			return null
		var binding = RoleBinding.new()
		binding.bind(&"target", target)
		var execution_id: StringName
		var outcome
		if current_intention.intention_id.equals(project_intention):
			project_count += 1
			execution_id = StringName("project_exec_%02d" % project_count)
			outcome = ActionOutcome.new(execution_id, project_action, binding, [], project_event)
		elif current_intention.intention_id.equals(food_intention):
			food_count += 1
			execution_id = StringName("food_exec_%02d" % food_count)
			outcome = ActionOutcome.new(execution_id, food_action, binding, [], food_event)
		else:
			return null
		actions.register(execution_id, outcome)
		activity.execution_id = execution_id
		return {"execution_id": execution_id}

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
		print("PASS project_need_continuity_scenario_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL project_need_continuity_scenario_test: %d failure(s)" % _failures.size())
	quit(1)

func _run_slice() -> void:
	var shelter = RuntimeWorldRef.entity(DomainId.entity(&"shelter_1"))
	var project_action = DomainId.action(&"attach_shelter_material")
	var food_action = DomainId.action(&"eat_food")
	var project_event = DomainId.event_definition(&"shelter_material_attached")
	var food_event = DomainId.event_definition(&"food_eaten")
	var project_intention = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"continue_shelter_project")
	var food_intention = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"seek_food")
	var definition_id = DomainId.new(DomainId.Kind.PROJECT_DEFINITION, &"small_shelter")
	var instance_id = DomainId.new(DomainId.Kind.PROJECT_INSTANCE, &"small_shelter_1")

	var project_binding = RoleBinding.new()
	project_binding.bind(&"project_subject", shelter)
	var project_definition = ProjectDefinition.new(
		definition_id,
		project_action,
		project_event,
		&"project_subject",
		&"target",
		project_intention,
		4,
		0.55
	)
	var project = ProjectInstance.new(instance_id, definition_id, project_binding)
	var projects = ProjectStore.new()
	_expect_true(projects.add(project), "partially completable project is registered")
	var project_contribution = ProjectContributionService.new(projects, [project_definition])
	var project_source = ProjectCandidateSource.new(projects, [project_definition])

	var drives = DriveState.new({DriveState.HUNGER: 0.46})
	var drive_progression = DriveProgressionService.new(drives, {DriveState.HUNGER: 0.04})
	var drive_source = DriveCandidateSource.new(drives, [
		DriveCandidateDefinition.new(DriveState.HUNGER, food_intention, 0.4)
	])
	var drive_consequence = GroundedDriveConsequenceService.new(drives, [
		DriveConsequenceDefinition.new(food_action, DriveState.HUNGER, -0.45, food_event)
	])

	var intentions = CurrentIntentionStore.new()
	var activity = ActivityQueryStub.new(intentions)
	var actions = ActionExecutionStub.new()
	var selected_executor = SelectedIntentionExecutorStub.new(
		activity,
		actions,
		project_intention,
		food_intention,
		project_action,
		food_action,
		project_event,
		food_event,
		shelter
	)
	var trace_sink = TraceSinkStub.new()
	var orchestrator = SimulationOrchestrator.new(
		WorldAdvanceStub.new(),
		actions,
		WorldCommandsStub.new(),
		DerivedInvalidatorStub.new(),
		activity,
		PerceptionAccessStub.new(),
		PerceptionStub.new(),
		LearningStub.new(),
		OpportunityStub.new(),
		BeliefStore.new(),
		[],
		DecisionRouter.new(),
		DecisionCommitCoordinator.new(intentions),
		trace_sink,
		drive_progression,
		drive_source,
		project_contribution,
		project_source,
		[],
		null,
		null,
		null,
		null,
		null,
		selected_executor,
		null,
		drive_consequence
	)

	var start = orchestrator.advance(SimulationStepContext.new(
		&"project_need_start", 1.0, 1.0, null, [ReconsiderationGate.Trigger.PROJECT_CHECKPOINT]
	))
	_expect_equal(project.contribution_count, 0, "project starts with durable zero progress")
	_expect_current_intention(intentions, project_intention, "calm hunger leaves the active project preferred")
	_expect_source_count(start.candidates, "project", 1, "initial competition exposes project candidate")
	_expect_source_count(start.candidates, "drive", 0, "calm hunger does not yet expose drive candidate")

	orchestrator.advance(SimulationStepContext.new(
		&"project_need_work_1", 1.0, 2.0, null, [ReconsiderationGate.Trigger.PROJECT_CHECKPOINT]
	))
	_expect_equal(project.contribution_count, 1, "first grounded project action leaves visible partial progress")
	_expect_current_intention(intentions, project_intention, "project remains preferred before hunger becomes pressing")

	var interruption = orchestrator.advance(SimulationStepContext.new(
		&"project_need_hunger_wins", 1.0, 3.0, null, []
	))
	_expect_equal(project.contribution_count, 2, "second grounded contribution persists before need interruption")
	_expect_equal(project.lifecycle, ProjectInstance.Lifecycle.ACTIVE, "need interruption does not abandon or complete project")
	_expect_equal(drives.band(DriveState.HUNGER), DriveState.UrgencyBand.PRESSING, "hunger progression reaches pressing band")
	_expect_source_count(interruption.candidates, "project", 1, "project remains a valid competitor while hunger is pressing")
	_expect_source_count(interruption.candidates, "drive", 1, "pressing hunger enters the same decision competition")
	_expect_current_intention(intentions, food_intention, "growing need autonomously displaces ordinary project intention")

	var recovery = orchestrator.advance(SimulationStepContext.new(
		&"project_need_food_resolved",
		1.0,
		4.0,
		null,
		[ReconsiderationGate.Trigger.ACTION_OR_INTENTION_COMPLETION]
	))
	_expect_true(drives.value(DriveState.HUNGER) < DriveState.PRESSING_EXIT, "grounded food action resolves hunger below pressing exit")
	_expect_equal(project.contribution_count, 2, "resolving hunger preserves prior project progress")
	_expect_source_count(recovery.candidates, "drive", 0, "resolved hunger leaves intentional competition")
	_expect_source_count(recovery.candidates, "project", 1, "unfinished project remains available after need resolution")
	_expect_current_intention(intentions, project_intention, "Wilson autonomously returns to the unfinished project")

	orchestrator.advance(SimulationStepContext.new(
		&"project_need_returned_work", 1.0, 5.0, null, [ReconsiderationGate.Trigger.PROJECT_CHECKPOINT]
	))
	_expect_equal(project.contribution_count, 3, "post-need project action continues from persistent partial progress")
	_expect_equal(project.lifecycle, ProjectInstance.Lifecycle.ACTIVE, "project remains active with one contribution still required")
	_expect_true(selected_executor.project_count >= 3, "project execution is re-entered after the competing need")
	_expect_equal(selected_executor.food_count, 1, "need resolution required one grounded food execution")
	_expect_equal(trace_sink.traces.size(), 5, "whole living sequence remains step-traceable")

	_completed = true

func _expect_current_intention(store, expected_id, label: String) -> void:
	if not store.has_current():
		_failures.append("%s | expected current intention but store was empty" % label)
		return
	_expect_equal(store.current().intention_id.key(), expected_id.key(), label)

func _expect_source_count(candidates: Array, source: String, expected: int, label: String) -> void:
	var actual := 0
	for candidate in candidates:
		if String(candidate.provenance.get("source", "")) == source:
			actual += 1
	_expect_equal(actual, expected, label)

func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)

func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
