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
var _completed := false


func _init() -> void:
	_run_slice()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS world_truth_belief_reconciliation_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL world_truth_belief_reconciliation_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	var campfire = RuntimeWorldRef.entity(DomainId.entity(&"campfire_1"))
	var fire_lit = DomainId.property(&"fire_lit")
	var fuel_level = DomainId.property(&"fuel_level")
	var old_claim = EpistemicClaim.property_claim(campfire, fire_lit, true)
	var new_claim = EpistemicClaim.property_claim(campfire, fire_lit, false)
	var unrelated_claim = EpistemicClaim.property_claim(campfire, fuel_level, 3)

	var beliefs = BeliefStore.new()
	var old_prop = BeliefProposition.new(old_claim)
	var unrelated_prop = BeliefProposition.new(unrelated_claim)
	_expect_true(beliefs.apply_evidence(BeliefEvidence.new(old_prop, true, 0.9, &"exec_saw_fire_lit", &"vision")).ok, "initial lit belief is learned from perception")
	_expect_true(beliefs.apply_evidence(BeliefEvidence.new(unrelated_prop, true, 0.7, &"exec_saw_fuel", &"vision")).ok, "unrelated property belief is seeded")
	var old_entry = beliefs.get_entry(old_prop)
	var unrelated_entry = beliefs.get_entry(unrelated_prop)
	_expect_true(old_entry != null, "old lit belief exists before hidden world change")
	_expect_true(unrelated_entry != null, "unrelated property belief exists before hidden world change")

	var learner = BeliefLearningService.new()
	var reconciliation = BeliefReconciliationService.new(learner)
	var coordinator = BeliefLearningCoordinator.new(learner, beliefs, reconciliation)

	# Authoritative world truth changes while Wilson has no perceptual evidence.
	var authoritative_fire_lit := false
	_expect_true(not authoritative_fire_lit, "fixture world truth changes while Wilson is away")
	var away_result: Dictionary = coordinator.process(PerceptionResult.new())
	_expect_equal(away_result["derived_evidence"].size(), 0, "hidden world change produces no Wilson belief evidence")
	_expect_true(is_equal_approx(old_entry.confidence, 0.9), "Wilson retains stale lit belief while away")
	_expect_true(beliefs.get_entry(BeliefProposition.new(new_claim)) == null, "Wilson does not know extinguished state before observing it")

	# Wilson returns and receives perceptual evidence of the current property value.
	var returned_perception = PerceptionResult.new([], [
		PerceptualEvidence.new(new_claim, 0.8, &"exec_return_observe_fire", &"vision")
	])
	var return_result: Dictionary = coordinator.process(returned_perception)
	_expect_equal(return_result["derived_evidence"].size(), 2, "new property observation yields support plus contradiction of old value")

	var new_prop = BeliefProposition.new(new_claim)
	var new_entry = beliefs.get_entry(new_prop)
	_expect_true(new_entry != null, "observed extinguished state becomes a Wilson belief")
	if new_entry != null:
		_expect_true(is_equal_approx(new_entry.confidence, 0.8), "new observed property value preserves perceptual confidence")
		_expect_equal(new_entry.last_source_execution_id, &"exec_return_observe_fire", "new belief preserves return-observation provenance")
	_expect_true(is_equal_approx(old_entry.confidence, 0.18), "contradictory observed property value weakens stale prior belief")
	_expect_equal(old_entry.last_source_execution_id, &"exec_return_observe_fire", "old belief revision preserves contradiction provenance")
	_expect_equal(String(old_entry.last_modality), "vision", "old belief revision preserves contradiction modality")
	_expect_true(is_equal_approx(unrelated_entry.confidence, 0.7), "unrelated property belief is not reconciled accidentally")
	_completed = true


func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)


func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
