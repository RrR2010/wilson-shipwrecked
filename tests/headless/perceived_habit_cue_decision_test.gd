extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const EpistemicClaim = preload("res://src/domain/cognition/epistemic_claim.gd")
const PerceptualEvidence = preload("res://src/domain/cognition/perceptual_evidence.gd")
const PerceptionResult = preload("res://src/domain/cognition/perception_result.gd")
const ExperienceLearningRule = preload("res://src/domain/cognition/experience_learning_rule.gd")
const ExperienceLearningService = preload("res://src/domain/cognition/experience_learning_service.gd")
const HabitStore = preload("res://src/domain/cognition/habit_store.gd")
const HabitCandidateSource = preload("res://src/domain/cognition/habit_candidate_source.gd")
const PerceivedCueRule = preload("res://src/domain/cognition/perceived_cue_rule.gd")
const PerceivedCueService = preload("res://src/domain/cognition/perceived_cue_service.gd")
const DecisionCandidate = preload("res://src/domain/cognition/decision_candidate.gd")
const DecisionRouter = preload("res://src/domain/cognition/decision_router.gd")

var _failures: Array[String] = []
var _completed := false


func _init() -> void:
	_run_slice()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS perceived_habit_cue_decision_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL perceived_habit_cue_decision_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	var gerald = RuntimeWorldRef.entity(DomainId.entity(&"gerald"))
	var interference = DomainId.event_definition(&"gerald_interference")
	var gerald_near_food = DomainId.event_definition(&"gerald_near_food_now")
	var protect_food = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"protect_food")
	var inspect_beach = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"inspect_beach")
	var cue_id: StringName = &"gerald_near_food"

	var learning_rule = ExperienceLearningRule.new(
		interference,
		&"culprit",
		0.0,
		0.0,
		0.0,
		cue_id,
		protect_food,
		&"culprit",
		0.8
	)
	var learning = ExperienceLearningService.new([learning_rule])
	var learned_evidence = PerceptualEvidence.new(
		EpistemicClaim.event_claim(gerald, interference, &"culprit"),
		1.0,
		&"exec_learn_protect_food",
		&"vision"
	)
	var proposals: Dictionary = learning.derive(learned_evidence)
	_expect_equal(proposals["habit_evidence"].size(), 1, "experience proposes one habit reinforcement")

	var habits = HabitStore.new()
	if proposals["habit_evidence"].size() == 1:
		habits.apply_evidence(proposals["habit_evidence"][0])
	var learned = habits.entries()
	_expect_equal(learned.size(), 1, "habit is stored after grounded learning evidence")
	if learned.size() == 1:
		_expect_true(float(learned[0]["strength"]) >= 0.79, "learned habit has enough strength to influence a later choice")

	var cue_service = PerceivedCueService.new([
		PerceivedCueRule.new(gerald_near_food, &"actor", cue_id, 0.5, &"vision"),
	])

	var wrong_modality = PerceptionResult.new([], [
		PerceptualEvidence.new(
			EpistemicClaim.event_claim(gerald, gerald_near_food, &"actor"),
			0.9,
			&"exec_heard_gerald",
			&"hearing"
		),
	])
	_expect_equal(cue_service.derive(wrong_modality).size(), 0, "non-authored modality does not activate the visual context cue")

	var current_perception = PerceptionResult.new([], [
		PerceptualEvidence.new(
			EpistemicClaim.event_claim(gerald, gerald_near_food, &"actor"),
			0.9,
			&"exec_gerald_near_food_now",
			&"vision"
		),
	])
	var active_cues: Array[StringName] = cue_service.derive(current_perception)
	_expect_equal(active_cues.size(), 1, "current perception activates one authored cue")
	if active_cues.size() == 1:
		_expect_equal(active_cues[0], cue_id, "derived cue matches the learned habit context")

	var habit_candidates: Array = HabitCandidateSource.new(habits, active_cues, 1.0, 0.2).generate()
	_expect_equal(habit_candidates.size(), 1, "active perceived cue makes the learned habit a decision candidate")
	if habit_candidates.size() == 1:
		_expect_equal(habit_candidates[0].intention_id.sort_key(), protect_food.sort_key(), "habit recalls the learned intention")
		_expect_equal(String(habit_candidates[0].provenance.get("source", "")), "habit", "candidate provenance remains explicit")

	var neutral_bindings = RoleBinding.new()
	var weak_alternative = DecisionCandidate.new(
		inspect_beach,
		neutral_bindings,
		DecisionCandidate.Scope.INTENTIONAL,
		0.3
	)
	var candidates: Array = [weak_alternative]
	candidates.append_array(habit_candidates)
	var decision = DecisionRouter.new().resolve(candidates)
	_expect_true(decision.selected_candidate != null, "decision router selects an intentional candidate")
	if decision.selected_candidate != null:
		_expect_equal(decision.selected_candidate.intention_id.sort_key(), protect_food.sort_key(), "learned habit changes the later autonomous choice")

	var inactive_candidates: Array = HabitCandidateSource.new(habits, [], 1.0, 0.2).generate()
	_expect_equal(inactive_candidates.size(), 0, "stored habit does not fire when its current cue is absent")
	_completed = true


func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)


func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
