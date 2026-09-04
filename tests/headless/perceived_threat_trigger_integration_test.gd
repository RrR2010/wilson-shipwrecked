extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const BeliefStore = preload("res://src/domain/cognition/belief_store.gd")
const CurrentIntentionStore = preload("res://src/domain/cognition/current_intention_store.gd")
const DecisionRouter = preload("res://src/domain/cognition/decision_router.gd")
const EpistemicClaim = preload("res://src/domain/cognition/epistemic_claim.gd")
const PerceptualEvidence = preload("res://src/domain/cognition/perceptual_evidence.gd")
const PerceptionResult = preload("res://src/domain/cognition/perception_result.gd")
const ThreatInterpretationRule = preload("res://src/domain/cognition/threat_interpretation_rule.gd")
const PerceivedThreatService = preload("res://src/domain/cognition/perceived_threat_service.gd")
const DefensiveCandidateDefinition = preload("res://src/domain/cognition/defensive_candidate_definition.gd")
const ImmediateThreatCandidateSource = preload("res://src/domain/cognition/immediate_threat_candidate_source.gd")
const DecisionCandidate = preload("res://src/domain/cognition/decision_candidate.gd")
const DecisionCommitCoordinator = preload("res://src/application/simulation/decision_commit_coordinator.gd")
const PerceivedThreatTriggerSource = preload("res://src/application/simulation/perceived_threat_trigger_source.gd")
const ReconsiderationGate = preload("res://src/application/simulation/reconsideration_gate.gd")
const SimulationOrchestrator = preload("res://src/application/simulation/simulation_orchestrator.gd")
const SimulationStepContext = preload("res://src/application/simulation/simulation_step_context.gd")
const WorldAdvanceResult = preload("res://src/application/simulation/world_advance_result.gd")
const FakeMotionPort = preload("res://tests/fakes/fake_motion_port.gd")

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


class LearningRecordingStub:
	extends RefCounted
	var evidence_counts: Array[int] = []
	func process(perception_result) -> Dictionary:
		evidence_counts.append(perception_result.evidence.size())
		return {"evidence_count": perception_result.evidence.size()}


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
		print("PASS perceived_threat_trigger_integration_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL perceived_threat_trigger_integration_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	var wilson_ref: RuntimeWorldRef = RuntimeWorldRef.wilson()
	var palm_ref: RuntimeWorldRef = RuntimeWorldRef.entity(DomainId.entity(&"moving_threat_palm"))
	var ordinary_ref: RuntimeWorldRef = RuntimeWorldRef.entity(DomainId.entity(&"ordinary_route_object"))
	var threat_event = DomainId.event_definition(&"palm_crack_visible")
	var nearby_relation = DomainId.relation_type(&"perceptibly_near")
	var dodge = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"dodge_threat")

	var motion: Variant = FakeMotionPort.new()
	_expect_true(motion.request_move(wilson_ref, palm_ref), "movement request starts before perception changes")
	_expect_equal(motion.get_status(wilson_ref), 1, "Wilson begins in MOVING state")

	var rule = ThreatInterpretationRule.new(threat_event, &"source", 0.9, 0.95, 0.5)
	var threat_service = PerceivedThreatService.new([rule])
	var threat_candidates = ImmediateThreatCandidateSource.new(
		threat_service,
		[DefensiveCandidateDefinition.new(dodge, 0.4)]
	)
	var threat_triggers = PerceivedThreatTriggerSource.new(threat_service)

	var intentions = CurrentIntentionStore.new()
	var perception = MutablePerceptionStub.new()
	var learning = LearningRecordingStub.new()
	var traces = TraceSinkStub.new()
	var orchestrator = SimulationOrchestrator.new(
		WorldAdvanceStub.new(),
		ActionExecutionStub.new(),
		WorldCommandsStub.new(),
		DerivedInvalidatorStub.new(),
		ActivityQueryStub.new(intentions),
		PerceptionAccessStub.new(),
		perception,
		learning,
		OpportunityStub.new(),
		BeliefStore.new(),
		[],
		DecisionRouter.new(),
		DecisionCommitCoordinator.new(intentions),
		traces,
		null, null, null, null, [],
		threat_candidates,
		null,
		null,
		threat_triggers
	)

	var ordinary_evidence = PerceptualEvidence.new(
		EpistemicClaim.relation_claim(wilson_ref, nearby_relation, ordinary_ref),
		0.9,
		&"ordinary_route_evidence",
		&"vision"
	)
	perception.result = PerceptionResult.new([], [ordinary_evidence])
	var ordinary_step = orchestrator.advance(
		SimulationStepContext.new(&"ordinary_while_moving", 0.1, 0.1, null, [])
	)
	_expect_equal(motion.get_status(wilson_ref), 1, "ordinary evidence is processed while Wilson remains MOVING")
	_expect_equal(ordinary_step.perception.evidence.size(), 1, "ordinary evidence reaches the semantic chain")
	_expect_true(ordinary_step.decision == null, "ordinary evidence does not force reconsideration")
	_expect_equal(ordinary_step.candidates.size(), 0, "ordinary evidence does not generate decision candidates without a trigger")
	_expect_true(not intentions.has_current(), "ordinary evidence does not replace the current movement intention")

	var threat_evidence = PerceptualEvidence.new(
		EpistemicClaim.event_claim(palm_ref, threat_event, &"source"),
		0.8,
		&"visible_palm_crack",
		&"vision"
	)
	perception.result = PerceptionResult.new([], [threat_evidence])
	var threat_step = orchestrator.advance(
		SimulationStepContext.new(&"threat_while_moving", 0.1, 0.2, null, [])
	)
	_expect_equal(motion.get_status(wilson_ref), 1, "threat routing occurs before movement reaches ARRIVED")
	_expect_equal(threat_step.perception.evidence.size(), 1, "accessible threat evidence reaches the semantic chain")
	_expect_true(threat_step.decision != null, "perceived threat wakes reconsideration without an external trigger")
	if threat_step.decision != null:
		_expect_equal(threat_step.decision.regime, &"immediate_threat", "perceived threat enters immediate-threat routing regime")
		_expect_true(threat_step.decision.selected_candidate != null, "immediate-threat routing selects a defense")
		if threat_step.decision.selected_candidate != null:
			_expect_equal(threat_step.decision.selected_candidate.scope, DecisionCandidate.Scope.IMMEDIATE_THREAT, "selected defense is scoped as immediate threat")
			_expect_equal(threat_step.decision.selected_candidate.intention_id.sort_key(), dodge.sort_key(), "selected defense uses authored dodge intention")
	_expect_true(intentions.has_current(), "selected defense is committed as current intention")
	if intentions.has_current():
		_expect_equal(intentions.current().intention_id.sort_key(), dodge.sort_key(), "threat decision replaces cognition intention with defense")
	_expect_equal(learning.evidence_counts, [1, 1], "ordinary and threat evidence both learn before routing")

	var derived_triggers: Array[int] = threat_triggers.derive(PerceptionResult.new([], [threat_evidence]))
	_expect_equal(derived_triggers, [ReconsiderationGate.Trigger.THREAT], "threat evidence derives only the THREAT gate trigger")
	_expect_equal(threat_triggers.derive(PerceptionResult.new([], [ordinary_evidence])).size(), 0, "ordinary evidence derives no reconsideration trigger")

	_completed = true


func _expect_true(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _expect_equal(actual: Variant, expected: Variant, message: String) -> void:
	if actual != expected:
		_failures.append("%s (expected=%s actual=%s)" % [message, expected, actual])
