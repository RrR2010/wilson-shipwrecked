extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const EpistemicClaim = preload("res://src/domain/cognition/epistemic_claim.gd")
const BeliefProposition = preload("res://src/domain/cognition/belief_proposition.gd")
const BeliefEvidence = preload("res://src/domain/cognition/belief_evidence.gd")
const BeliefStore = preload("res://src/domain/cognition/belief_store.gd")
const BeliefLearningService = preload("res://src/domain/cognition/belief_learning_service.gd")
const BeliefReconciliationService = preload("res://src/domain/cognition/belief_reconciliation_service.gd")
const BeliefLearningCoordinator = preload("res://src/application/simulation/belief_learning_coordinator.gd")
const PerceptualEvidence = preload("res://src/domain/cognition/perceptual_evidence.gd")
const PerceptionResult = preload("res://src/domain/cognition/perception_result.gd")
const DriveState = preload("res://src/domain/cognition/drive_state.gd")
const PerceivedContextTransitionTriggerSource = preload("res://src/application/simulation/perceived_context_transition_trigger_source.gd")
const ReconsiderationGate = preload("res://src/application/simulation/reconsideration_gate.gd")
const DriveCandidateDefinition = preload("res://src/domain/cognition/drive_candidate_definition.gd")
const PerceivedOpportunityDefinition = preload("res://src/domain/cognition/perceived_opportunity_definition.gd")
const DriveBackedBelievedOpportunityCandidateSource = preload("res://src/domain/cognition/drive_backed_believed_opportunity_candidate_source.gd")
const DecisionCandidate = preload("res://src/domain/cognition/decision_candidate.gd")

var failures: Array[String] = []

class DriveStub:
	extends RefCounted
	func band(_id) -> int:
		return 2
	func urgency(_id) -> float:
		return 1.0
	func value(_id) -> float:
		return 1.0

class ContentStub:
	extends RefCounted
	func get_event_definition(_id):
		return null

func _init() -> void:
	var food = RuntimeWorldRef.entity(DomainId.entity(&"exposed_berries"))
	var second_food = RuntimeWorldRef.entity(DomainId.entity(&"distant_berries"))
	var edible = DomainId.property(&"edible")
	var seek = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"seek_food")
	var beliefs = BeliefStore.new()
	beliefs.apply_evidence(BeliefEvidence.new(BeliefProposition.new(EpistemicClaim.property_claim(food, edible, true)), true, 0.9, &"seed", &"memory"))
	beliefs.apply_evidence(BeliefEvidence.new(BeliefProposition.new(EpistemicClaim.property_claim(second_food, edible, true)), true, 0.7, &"seed_far", &"memory"))
	var source = DriveBackedBelievedOpportunityCandidateSource.new(
		DriveStub.new(), beliefs,
		[DriveCandidateDefinition.new(DriveState.HUNGER, seek, 0.1)],
		[PerceivedOpportunityDefinition.new(EpistemicClaim.Kind.PROPERTY, edible, seek, DecisionCandidate.Scope.INTENTIONAL, 0.1)]
	)
	_check(source.generate().size() == 2, "two remembered edible sources support initial choice")
	# Hidden depletion cannot alter Wilson's belief before perceptual access.
	_check(source.generate().size() == 2, "unobserved depletion preserves original candidates")
	var learner = BeliefLearningService.new()
	var coordinator = BeliefLearningCoordinator.new(learner, beliefs, BeliefReconciliationService.new(learner))
	var empty_observation = PerceptionResult.new([], [PerceptualEvidence.new(EpistemicClaim.quantity_claim(food, 0), 0.9, &"visual_empty", &"vision")])
	var reconsider = PerceivedContextTransitionTriggerSource.new(ContentStub.new(), true)
	_check(reconsider.derive(empty_observation).has(ReconsiderationGate.Trigger.ACTION_INVALIDATION), "observed empty quantity requests reconsideration")
	_check(reconsider.derive(PerceptionResult.new()).is_empty(), "no observation cannot trigger reconsideration")
	coordinator.process(empty_observation)
	var after_empty: Array = source.generate()
	_check(after_empty.size() == 1, "observed empty first source leaves only distant food")
	if after_empty.size() == 1:
		_check(after_empty[0].bindings.get_subject(&"target").equals(second_food), "Wilson targets distant food after empty local patch")
	coordinator.process(PerceptionResult.new([], [PerceptualEvidence.new(EpistemicClaim.quantity_claim(food, 4), 0.9, &"visual_restock", &"vision")]))
	_check(source.generate().size() == 2, "observed restock restores local food candidate")
	if failures.is_empty():
		print("PASS depleted_food_expectation_test")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		print("FAIL depleted_food_expectation_test")
		quit(1)

func _check(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
