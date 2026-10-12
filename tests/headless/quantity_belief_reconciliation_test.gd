extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const EpistemicClaim = preload("res://src/domain/cognition/epistemic_claim.gd")
const PerceptualEvidence = preload("res://src/domain/cognition/perceptual_evidence.gd")
const PerceptionResult = preload("res://src/domain/cognition/perception_result.gd")
const BeliefEvidence = preload("res://src/domain/cognition/belief_evidence.gd")
const BeliefProposition = preload("res://src/domain/cognition/belief_proposition.gd")
const BeliefStore = preload("res://src/domain/cognition/belief_store.gd")
const BeliefLearningService = preload("res://src/domain/cognition/belief_learning_service.gd")
const BeliefReconciliationService = preload("res://src/domain/cognition/belief_reconciliation_service.gd")
const BeliefLearningCoordinator = preload("res://src/application/simulation/belief_learning_coordinator.gd")

var _failures: Array[String] = []


func _init() -> void:
	_run_slice()
	if _failures.is_empty():
		print("PASS quantity_belief_reconciliation_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL quantity_belief_reconciliation_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	var food_ref = RuntimeWorldRef.entity(DomainId.entity(&"stored_food"))
	var remembered_three = BeliefProposition.new(EpistemicClaim.quantity_claim(food_ref, 3))
	var observed_one = BeliefProposition.new(EpistemicClaim.quantity_claim(food_ref, 1))
	var beliefs = BeliefStore.new()
	_expect_true(
		beliefs.apply_evidence(BeliefEvidence.new(remembered_three, true, 0.9, &"opened_chest_before", &"vision")).ok,
		"Wilson learns initial visible quantity"
	)
	var old_entry = beliefs.get_entry(remembered_three)

	var learner = BeliefLearningService.new()
	var reconciliation = BeliefReconciliationService.new(learner)
	var coordinator = BeliefLearningCoordinator.new(learner, beliefs, reconciliation)

	# Gerald changes hidden World truth while the chest is closed. With no perceptual
	# evidence, Wilson must continue carrying the stale remembered quantity.
	var hidden_world_quantity := 1
	_expect_equal(hidden_world_quantity, 1, "fixture hidden quantity changed")
	var hidden_result: Dictionary = coordinator.process(PerceptionResult.new())
	_expect_equal(hidden_result["derived_evidence"].size(), 0, "hidden stock change produces no cognition evidence")
	_expect_true(is_equal_approx(old_entry.confidence, 0.9), "stale quantity memory persists while container is closed")
	_expect_true(beliefs.get_entry(observed_one) == null, "Wilson does not know hidden post-theft quantity")

	# Opening/reinspecting the chest supplies current evidence. The new quantity is
	# supported and the mutually-exclusive stale quantity is contradicted.
	var observed = PerceptionResult.new([], [
		PerceptualEvidence.new(observed_one.claim, 0.85, &"reopened_chest", &"vision")
	])
	var observed_result: Dictionary = coordinator.process(observed)
	_expect_equal(observed_result["derived_evidence"].size(), 2, "reinspection supports new quantity and contradicts stale quantity")
	var new_entry = beliefs.get_entry(observed_one)
	_expect_true(new_entry != null, "post-theft quantity becomes belief only after observation")
	if new_entry != null:
		_expect_true(is_equal_approx(new_entry.confidence, 0.85), "new quantity keeps observation confidence")
	_expect_true(old_entry.confidence < 0.9, "reinspection weakens stale quantity memory")


func _expect_true(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _expect_equal(actual: Variant, expected: Variant, message: String) -> void:
	if actual != expected:
		_failures.append("%s (expected=%s actual=%s)" % [message, expected, actual])
