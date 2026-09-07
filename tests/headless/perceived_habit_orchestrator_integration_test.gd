extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const WorldEvent = preload("res://src/domain/actions/world_event.gd")
const PerceptionAccess = preload("res://src/domain/cognition/perception_access.gd")
const PerceptionService = preload("res://src/domain/cognition/perception_service.gd")
const PerceivedCueRule = preload("res://src/domain/cognition/perceived_cue_rule.gd")
const PerceivedCueService = preload("res://src/domain/cognition/perceived_cue_service.gd")
const PerceivedHabitCandidateSource = preload("res://src/domain/cognition/perceived_habit_candidate_source.gd")
const HabitStore = preload("res://src/domain/cognition/habit_store.gd")
const BeliefStore = preload("res://src/domain/cognition/belief_store.gd")
const CurrentIntentionStore = preload("res://src/domain/cognition/current_intention_store.gd")
const DecisionCandidate = preload("res://src/domain/cognition/decision_candidate.gd")
const DecisionRouter = preload("res://src/domain/cognition/decision_router.gd")
const DecisionCommitCoordinator = preload("res://src/application/simulation/decision_commit_coordinator.gd")
const ReconsiderationGate = preload("res://src/application/simulation/reconsideration_gate.gd")
const SimulationOrchestrator = preload("res://src/application/simulation/simulation_orchestrator.gd")
const SimulationStepContext = preload("res://src/application/simulation/simulation_step_context.gd")
const WorldAdvanceResult = preload("res://src/application/simulation/world_advance_result.gd")

var _failures: Array[String] = []
var _completed := false


class WorldAdvanceStub:
	extends RefCounted
	var events: Array
	func _init(p_events: Array) -> void:
		events = p_events.duplicate()
	func advance(_elapsed: float, _step):
		return WorldAdvanceResult.new(events)


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
	var execution_id: StringName
	func _init(p_execution_id: StringName) -> void:
		execution_id = p_execution_id
	func resolve(_events: Array, _step) -> Dictionary:
		return {execution_id: PerceptionAccess.new(true, [&"vision"], [&"actor"], 0.9)}


class LearningStub:
	extends RefCounted
	func process(perception_result) -> Dictionary:
		return {"evidence_count": perception_result.evidence.size()}


class OpportunityStub:
	extends RefCounted
	var candidate
	func _init(p_candidate) -> void:
		candidate = p_candidate
	func generate(_perception_result, _belief_store, _definitions: Array) -> Array:
		return [candidate]


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
		print("PASS perceived_habit_orchestrator_integration_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL perceived_habit_orchestrator_integration_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	var gerald = RuntimeWorldRef.entity(DomainId.entity(&"gerald"))
	var gerald_near_food = DomainId.event_definition(&"gerald_near_food_now")
	var protect_food = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"protect_food")
	var inspect_beach = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"inspect_beach")
	var cue_id: StringName = &"gerald_near_food"

	var habit_bindings = RoleBinding.new()
	habit_bindings.bind(&"culprit", gerald)
	var habits = HabitStore.new()
	habits.restore_entry(
		cue_id,
		protect_food,
		habit_bindings,
		0.8,
		3,
		&"exec_learned_before"
	)

	var event_bindings = RoleBinding.new()
	event_bindings.bind(&"actor", gerald)
	var context_event = WorldEvent.new(
		gerald_near_food,
		null,
		event_bindings,
		&"exec_gerald_near_food_now"
	)

	var cue_service = PerceivedCueService.new([
		PerceivedCueRule.new(gerald_near_food, &"actor", cue_id, 0.5, &"vision"),
	])
	var perceived_habits = PerceivedHabitCandidateSource.new(cue_service, habits, 1.0, 0.2)

	var neutral_bindings = RoleBinding.new()
	var weak_alternative = DecisionCandidate.new(
		inspect_beach,
		neutral_bindings,
		DecisionCandidate.Scope.INTENTIONAL,
		0.3
	)

	var intentions = CurrentIntentionStore.new()
	var traces = TraceSinkStub.new()
	var orchestrator = SimulationOrchestrator.new(
		WorldAdvanceStub.new([context_event]),
		ActionExecutionStub.new(),
		WorldCommandsStub.new(),
		DerivedInvalidatorStub.new(),
		ActivityQueryStub.new(intentions),
		PerceptionAccessStub.new(context_event.execution_id),
		PerceptionService.new(),
		LearningStub.new(),
		OpportunityStub.new(weak_alternative),
		BeliefStore.new(),
		[],
		DecisionRouter.new(),
		DecisionCommitCoordinator.new(intentions),
		traces,
		null, null, null, null, [],
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		perceived_habits
	)

	var result = orchestrator.advance(SimulationStepContext.new(
		&"habit_context_reconsideration",
		0.1,
		0.1,
		null,
		[ReconsiderationGate.Trigger.CONTEXT_TRANSITION]
	))

	_expect_equal(result.perception.evidence.size(), 1, "current world event becomes one Wilson-relative perceptual evidence item")
	_expect_equal(result.candidates.size(), 2, "current perception adds learned habit beside ordinary opportunity")
	var saw_habit: bool = false
	for candidate in result.candidates:
		if String(candidate.provenance.get("source", "")) == "habit":
			saw_habit = true
			_expect_equal(candidate.intention_id.sort_key(), protect_food.sort_key(), "habit candidate recalls learned protect-food intention")
	_expect_true(saw_habit, "orchestrator generates habit candidate from this step's perception")
	_expect_true(result.decision != null and result.decision.selected_candidate != null, "reconsideration produces a selected intention")
	if result.decision != null and result.decision.selected_candidate != null:
		_expect_equal(result.decision.selected_candidate.intention_id.sort_key(), protect_food.sort_key(), "learned habit beats weak ordinary alternative")
	_expect_true(intentions.has_current(), "selected habit is committed into current intention state")
	if intentions.has_current():
		_expect_equal(intentions.current().intention_id.sort_key(), protect_food.sort_key(), "committed intention is protect_food")
	_expect_equal(traces.traces.size(), 1, "habit decision is recorded in the normal simulation trace")
	_completed = true


func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)


func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
