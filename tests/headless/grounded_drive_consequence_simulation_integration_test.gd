extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const ActionOutcome = preload("res://src/domain/actions/action_outcome.gd")
const BeliefStore = preload("res://src/domain/cognition/belief_store.gd")
const CurrentIntentionStore = preload("res://src/domain/cognition/current_intention_store.gd")
const DecisionRouter = preload("res://src/domain/cognition/decision_router.gd")
const PerceptionResult = preload("res://src/domain/cognition/perception_result.gd")
const DriveState = preload("res://src/domain/cognition/drive_state.gd")
const DriveConsequenceDefinition = preload("res://src/domain/cognition/drive_consequence_definition.gd")
const SemanticChangeSet = preload("res://src/domain/world/semantic_change_set.gd")
const WorldCommitResult = preload("res://src/domain/world/world_commit_result.gd")
const DecisionCommitCoordinator = preload("res://src/application/simulation/decision_commit_coordinator.gd")
const GroundedDriveConsequenceService = preload("res://src/application/simulation/grounded_drive_consequence_service.gd")
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
	var accepted: bool
	func _init(p_accepted: bool) -> void:
		accepted = p_accepted
	func apply_outcome(_outcome):
		if accepted:
			return WorldCommitResult.new(true, [], [], [], SemanticChangeSet.new())
		return WorldCommitResult.new(false, [], [], ["rejected"], SemanticChangeSet.new())


class DerivedInvalidatorStub:
	extends RefCounted
	func apply(_change_set):
		return {}


class ActivityQueryStub:
	extends RefCounted
	func active_execution_id() -> StringName:
		return &"consume_exec"
	func current_intention():
		return null


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
		print("PASS grounded_drive_consequence_simulation_integration_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL grounded_drive_consequence_simulation_integration_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	var consume = DomainId.action(&"consume")
	var consumed = DomainId.event_definition(&"food_consumed")
	var bindings = RoleBinding.new()
	bindings.bind(&"actor", RuntimeWorldRef.wilson())
	bindings.bind(&"target", RuntimeWorldRef.entity(DomainId.entity(&"food_1")))
	var outcome = ActionOutcome.new(&"consume_exec", consume, bindings, [], consumed)
	var definition = DriveConsequenceDefinition.new(consume, DriveState.HUNGER, -0.35, consumed)

	var accepted_drives = DriveState.new({DriveState.HUNGER: 0.65})
	var accepted_trace = TraceSinkStub.new()
	var accepted_orchestrator = _make_orchestrator(
		outcome,
		true,
		GroundedDriveConsequenceService.new(accepted_drives, [definition]),
		accepted_trace
	)
	accepted_orchestrator.advance(SimulationStepContext.new(&"accepted_consume", 0.1, 0.1, null, []))
	_expect_float(accepted_drives.value(DriveState.HUNGER), 0.30, "accepted grounded outcome reduces hunger inside orchestrator ordering")
	_expect_equal(accepted_trace.traces.size(), 1, "accepted grounded consequence remains traceable")
	if accepted_trace.traces.size() == 1:
		_expect_true(accepted_trace.traces[0].stage_results.has(&"world_commit"), "trace records World acceptance before consequence")
		_expect_true(accepted_trace.traces[0].stage_results.has(&"drive_consequence"), "trace records grounded drive consequence")
		if accepted_trace.traces[0].stage_results.has(&"drive_consequence"):
			_expect_equal(
				accepted_trace.traces[0].stage_results[&"drive_consequence"].code,
				&"drive_consequence_applied",
				"trace exposes applied consequence result"
			)

	var rejected_drives = DriveState.new({DriveState.HUNGER: 0.65})
	var rejected_trace = TraceSinkStub.new()
	var rejected_orchestrator = _make_orchestrator(
		outcome,
		false,
		GroundedDriveConsequenceService.new(rejected_drives, [definition]),
		rejected_trace
	)
	rejected_orchestrator.advance(SimulationStepContext.new(&"rejected_consume", 0.1, 0.1, null, []))
	_expect_float(rejected_drives.value(DriveState.HUNGER), 0.65, "rejected World commit cannot reduce hunger through orchestrator")
	_expect_equal(rejected_trace.traces.size(), 1, "rejected grounded consequence remains traceable")
	if rejected_trace.traces.size() == 1 and rejected_trace.traces[0].stage_results.has(&"drive_consequence"):
		_expect_equal(
			rejected_trace.traces[0].stage_results[&"drive_consequence"].code,
			&"drive_consequence_not_grounded",
			"trace explicitly reports rejected consequence as not grounded"
		)
	else:
		_failures.append("Rejected World commit did not record drive_consequence trace stage")

	_completed = true


func _make_orchestrator(outcome, world_accepts: bool, consequence, trace_sink):
	var intentions = CurrentIntentionStore.new()
	return SimulationOrchestrator.new(
		WorldAdvanceStub.new(),
		ActionExecutionStub.new(outcome),
		WorldCommandsStub.new(world_accepts),
		DerivedInvalidatorStub.new(),
		ActivityQueryStub.new(),
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
		null,
		null,
		[],
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		consequence
	)


func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)


func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])


func _expect_float(actual: Variant, expected: float, label: String) -> void:
	if actual == null or not is_equal_approx(float(actual), expected):
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
