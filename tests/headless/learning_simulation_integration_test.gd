extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const EpistemicClaim = preload("res://src/domain/cognition/epistemic_claim.gd")
const PerceptualEvidence = preload("res://src/domain/cognition/perceptual_evidence.gd")
const PerceptionResult = preload("res://src/domain/cognition/perception_result.gd")
const BeliefStore = preload("res://src/domain/cognition/belief_store.gd")
const BeliefLearningService = preload("res://src/domain/cognition/belief_learning_service.gd")
const AssociationStore = preload("res://src/domain/cognition/association_store.gd")
const HabitStore = preload("res://src/domain/cognition/habit_store.gd")
const HabitCandidateSource = preload("res://src/domain/cognition/habit_candidate_source.gd")
const EpisodeStore = preload("res://src/domain/cognition/episode_store.gd")
const ExperienceLearningRule = preload("res://src/domain/cognition/experience_learning_rule.gd")
const ExperienceLearningService = preload("res://src/domain/cognition/experience_learning_service.gd")
const CurrentIntentionStore = preload("res://src/domain/cognition/current_intention_store.gd")
const DecisionRouter = preload("res://src/domain/cognition/decision_router.gd")
const BeliefLearningCoordinator = preload("res://src/application/simulation/belief_learning_coordinator.gd")
const WilsonLearningCoordinator = preload("res://src/application/simulation/wilson_learning_coordinator.gd")
const DecisionCommitCoordinator = preload("res://src/application/simulation/decision_commit_coordinator.gd")
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
	var intention_store
	func _init(p_intention_store) -> void:
		intention_store = p_intention_store
	func active_execution_id() -> StringName:
		return &""
	func current_intention():
		return intention_store.current() if intention_store.has_current() else null

class PerceptionAccessStub:
	extends RefCounted
	func resolve(_events: Array, _step) -> Dictionary:
		return {}

class PerceptionStub:
	extends RefCounted
	var evidence
	func _init(p_evidence) -> void:
		evidence = p_evidence
	func perceive(_events: Array, _access: Dictionary):
		return PerceptionResult.new([], [evidence])

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
		print("PASS learning_simulation_integration_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL learning_simulation_integration_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	var gerald = RuntimeWorldRef.entity(DomainId.entity(&"gerald"))
	var event_type = DomainId.event_definition(&"gerald_interference")
	var protect_food = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"protect_food")
	var evidence = PerceptualEvidence.new(
		EpistemicClaim.event_claim(gerald, event_type, &"culprit"),
		1.0,
		&"exec_learning_1",
		&"vision"
	)
	var rule = ExperienceLearningRule.new(
		event_type,
		&"culprit",
		-0.25,
		0.2,
		0.7,
		&"gerald_near_food",
		protect_food,
		&"culprit",
		0.8
	)
	var beliefs = BeliefStore.new()
	var associations = AssociationStore.new()
	var habits = HabitStore.new()
	var episodes = EpisodeStore.new()
	var learning = WilsonLearningCoordinator.new(
		BeliefLearningCoordinator.new(BeliefLearningService.new(), beliefs),
		ExperienceLearningService.new([rule]),
		associations,
		habits,
		episodes
	)
	var intentions = CurrentIntentionStore.new()
	var habit_source = HabitCandidateSource.new(habits, [&"gerald_near_food"], 0.35, 0.2)
	var trace_sink = TraceSinkStub.new()
	var orchestrator = SimulationOrchestrator.new(
		WorldAdvanceStub.new(),
		ActionExecutionStub.new(),
		WorldCommandsStub.new(),
		DerivedInvalidatorStub.new(),
		ActivityQueryStub.new(intentions),
		PerceptionAccessStub.new(),
		PerceptionStub.new(evidence),
		learning,
		OpportunityStub.new(),
		beliefs,
		[],
		DecisionRouter.new(),
		DecisionCommitCoordinator.new(intentions),
		trace_sink,
		null,
		null,
		null,
		null,
		[habit_source]
	)

	var result = orchestrator.advance(SimulationStepContext.new(
		&"learning_step_1",
		1.0,
		1.0,
		null,
		[ReconsiderationGate.Trigger.MAJOR_EVENT_OR_OPPORTUNITY]
	))
	_expect_equal(beliefs.entries().size(), 1, "perception still updates belief owner")
	_expect_equal(associations.entries().size(), 1, "same accessible evidence updates association owner")
	_expect_equal(habits.entries().size(), 1, "same accessible evidence updates habit owner")
	_expect_equal(episodes.entries().size(), 1, "same accessible evidence may consolidate episode")
	_expect_equal(result.candidates.size(), 1, "newly learned active-cue habit joins candidate competition")
	if result.candidates.size() == 1:
		_expect_equal(result.candidates[0].intention_id.key(), protect_food.key(), "habit candidate retains semantic intention")
		_expect_equal(result.candidates[0].provenance.get("source"), "habit", "habit candidate exposes provenance")
	_expect_true(intentions.has_current(), "habit candidate still commits through normal cognition owner")
	if intentions.has_current():
		_expect_equal(intentions.current().intention_id.key(), protect_food.key(), "habit bias may win ordinary competition")
	_expect_equal(trace_sink.traces.size(), 1, "learning-integrated step remains traceable")
	if trace_sink.traces.size() == 1:
		_expect_true(trace_sink.traces[0].stage_results.has(&"immediate_learning"), "trace records Wilson learning")
		_expect_true(trace_sink.traces[0].stage_results.has(&"decision_candidates"), "trace records habit candidate")

	_completed = true


func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)


func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
