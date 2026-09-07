extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const EntityInstance = preload("res://src/domain/world/entity_instance.gd")
const WorldAdvanceResult = preload("res://src/application/simulation/world_advance_result.gd")
const SimulationOrchestrator = preload("res://src/application/simulation/simulation_orchestrator.gd")
const SimulationStepContext = preload("res://src/application/simulation/simulation_step_context.gd")
const PerceptionResult = preload("res://src/domain/cognition/perception_result.gd")
const PerceptionService = preload("res://src/domain/cognition/perception_service.gd")
const EpistemicClaim = preload("res://src/domain/cognition/epistemic_claim.gd")
const PerceptualEvidence = preload("res://src/domain/cognition/perceptual_evidence.gd")
const BeliefProposition = preload("res://src/domain/cognition/belief_proposition.gd")
const BeliefStore = preload("res://src/domain/cognition/belief_store.gd")
const BeliefLearningService = preload("res://src/domain/cognition/belief_learning_service.gd")
const BeliefReconciliationService = preload("res://src/domain/cognition/belief_reconciliation_service.gd")
const BeliefLearningCoordinator = preload("res://src/application/simulation/belief_learning_coordinator.gd")
const CurrentIntentionStore = preload("res://src/domain/cognition/current_intention_store.gd")
const DecisionRouter = preload("res://src/domain/cognition/decision_router.gd")
const DecisionCommitCoordinator = preload("res://src/application/simulation/decision_commit_coordinator.gd")

var _failures: Array[String] = []
var _completed := false


class WorldAdvanceStub:
	extends RefCounted
	var entity
	var property_id
	var changed := false
	func _init(p_entity, p_property_id) -> void:
		entity = p_entity
		property_id = p_property_id
	func advance(_elapsed: float, _step):
		if not changed:
			entity.set_property_override(property_id, false)
			changed = true
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
	func active_execution_id() -> StringName:
		return &""
	func current_intention():
		return null


class PerceptionAccessStub:
	extends RefCounted
	func resolve(_events: Array, _step) -> Dictionary:
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


class MutablePropertyPerceptionSource:
	extends RefCounted
	var observable := false
	var entity
	var subject_ref
	var property_id
	func _init(p_entity, p_subject_ref, p_property_id) -> void:
		entity = p_entity
		subject_ref = p_subject_ref
		property_id = p_property_id
	func collect(step):
		if not observable:
			return PerceptionResult.new()
		var value = entity.get_property_override(property_id)
		var claim = EpistemicClaim.property_claim(subject_ref, property_id, value)
		var evidence = PerceptualEvidence.new(claim, 0.9, step.step_id, &"vision")
		return PerceptionResult.new([], [evidence], [])


func _init() -> void:
	_run_slice()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS world_truth_belief_orchestrator_integration_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL world_truth_belief_orchestrator_integration_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	var fire_id = DomainId.entity(&"camp_fire")
	var fire_type = DomainId.entity_type(&"camp_fire_type")
	var camp = DomainId.place(&"camp")
	var fire_lit = DomainId.property(&"fire_lit")
	var fire_ref = RuntimeWorldRef.entity(fire_id)
	var fire = EntityInstance.new(fire_id, fire_type, camp, {fire_lit.key(): true})

	var true_claim = EpistemicClaim.property_claim(fire_ref, fire_lit, true)
	var false_claim = EpistemicClaim.property_claim(fire_ref, fire_lit, false)
	var true_prop = BeliefProposition.new(true_claim)
	var false_prop = BeliefProposition.new(false_claim)
	var beliefs = BeliefStore.new()
	var learner = BeliefLearningService.new()
	var reconciliation = BeliefReconciliationService.new(learner)
	var learning = BeliefLearningCoordinator.new(learner, beliefs, reconciliation)

	var initial_perception = PerceptionResult.new([], [
		PerceptualEvidence.new(true_claim, 0.9, &"initial_fire_observation", &"vision")
	], [])
	learning.process(initial_perception)
	var initial_true = beliefs.get_entry(true_prop)
	_expect_true(initial_true != null, "initial visible fire creates belief")
	if initial_true == null:
		return
	_expect_approx(initial_true.confidence, 0.9, "initial belief confidence matches observation")

	var passive = MutablePropertyPerceptionSource.new(fire, fire_ref, fire_lit)
	var traces = TraceSinkStub.new()
	var intentions = CurrentIntentionStore.new()
	var orchestrator = SimulationOrchestrator.new(
		WorldAdvanceStub.new(fire, fire_lit),
		ActionExecutionStub.new(),
		WorldCommandsStub.new(),
		DerivedInvalidatorStub.new(),
		ActivityQueryStub.new(),
		PerceptionAccessStub.new(),
		PerceptionService.new(),
		learning,
		OpportunityStub.new(),
		beliefs,
		[],
		DecisionRouter.new(),
		DecisionCommitCoordinator.new(intentions),
		traces,
		null, null, null, null, [],
		null,
		null,
		passive
	)

	passive.observable = false
	var away_step = orchestrator.advance(SimulationStepContext.new(
		&"fire_changes_while_away",
		0.1,
		0.1,
		null,
		[]
	))
	_expect_equal(fire.get_property_override(fire_lit), false, "World truth changes while Wilson is away")
	_expect_equal(away_step.perception.evidence.size(), 0, "hidden World change produces no perceptual evidence")
	_expect_approx(beliefs.get_entry(true_prop).confidence, 0.9, "hidden World change leaves old belief untouched")
	_expect_true(beliefs.get_entry(false_prop) == null, "hidden World change does not create new belief")

	passive.observable = true
	var return_step = orchestrator.advance(SimulationStepContext.new(
		&"wilson_returns_to_fire",
		0.1,
		0.2,
		null,
		[]
	))
	_expect_equal(return_step.perception.evidence.size(), 1, "returning Wilson perceives current World property")
	var false_entry = beliefs.get_entry(false_prop)
	var true_entry = beliefs.get_entry(true_prop)
	_expect_true(false_entry != null, "perceived current value creates matching belief")
	_expect_true(true_entry != null, "prior belief remains as revisable cognition history")
	if false_entry == null or true_entry == null:
		return
	_expect_approx(false_entry.confidence, 0.9, "current observed value becomes strongly believed")
	_expect_approx(true_entry.confidence, 0.09, "contradicted prior value is weakened only after perception")
	_expect_equal(String(true_entry.last_source_execution_id), "wilson_returns_to_fire", "contradiction provenance points to return observation")
	_expect_equal(String(true_entry.last_modality), "vision", "contradiction provenance preserves modality")
	_expect_equal(traces.traces.size(), 2, "both semantic steps run through orchestrator")

	_completed = true


func _expect_true(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _expect_equal(actual: Variant, expected: Variant, message: String) -> void:
	if actual != expected:
		_failures.append("%s (expected=%s actual=%s)" % [message, expected, actual])


func _expect_approx(actual: float, expected: float, message: String) -> void:
	if not is_equal_approx(actual, expected):
		_failures.append("%s (expected=%s actual=%s)" % [message, expected, actual])
