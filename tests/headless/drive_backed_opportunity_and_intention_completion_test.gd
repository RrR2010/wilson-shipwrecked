extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const ActionOutcome = preload("res://src/domain/actions/action_outcome.gd")
const BeliefStore = preload("res://src/domain/cognition/belief_store.gd")
const BeliefProposition = preload("res://src/domain/cognition/belief_proposition.gd")
const EpistemicClaim = preload("res://src/domain/cognition/epistemic_claim.gd")
const CurrentIntentionStore = preload("res://src/domain/cognition/current_intention_store.gd")
const DriveState = preload("res://src/domain/cognition/drive_state.gd")
const DriveCandidateDefinition = preload("res://src/domain/cognition/drive_candidate_definition.gd")
const PerceivedOpportunityDefinition = preload("res://src/domain/cognition/perceived_opportunity_definition.gd")
const DecisionCandidate = preload("res://src/domain/cognition/decision_candidate.gd")
const DriveBackedBelievedOpportunityCandidateSource = preload("res://src/domain/cognition/drive_backed_believed_opportunity_candidate_source.gd")
const IntentionCompletionDefinition = preload("res://src/domain/cognition/intention_completion_definition.gd")
const GroundedIntentionCompletionService = preload("res://src/application/simulation/grounded_intention_completion_service.gd")
const SemanticChangeSet = preload("res://src/domain/world/semantic_change_set.gd")
const WorldCommitResult = preload("res://src/domain/world/world_commit_result.gd")

var _failures: Array[String] = []


func _init() -> void:
	_test_drive_backed_belief_requires_meaningful_need()
	_test_grounded_action_can_complete_authored_intention()
	_finish()


func _test_drive_backed_belief_requires_meaningful_need() -> void:
	var seek_food = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"seek_food")
	var edible = DomainId.property(&"edible")
	var food_ref = RuntimeWorldRef.entity(DomainId.entity(&"food_1"))
	var beliefs = BeliefStore.new()
	beliefs.restore_entry(
		BeliefProposition.new(EpistemicClaim.property_claim(food_ref, edible, true)),
		0.9,
		1,
		&"seed",
		&"memory"
	)
	var drive_definition = DriveCandidateDefinition.new(DriveState.HUNGER, seek_food, 0.1)
	var opportunity_definition = PerceivedOpportunityDefinition.new(
		EpistemicClaim.Kind.PROPERTY,
		edible,
		seek_food,
		DecisionCandidate.Scope.INTENTIONAL,
		0.1
	)
	var drives = DriveState.new({DriveState.HUNGER: 0.2})
	var source = DriveBackedBelievedOpportunityCandidateSource.new(
		drives,
		beliefs,
		[drive_definition],
		[opportunity_definition]
	)
	_expect_equal(source.generate().size(), 0, "known food alone does not create a hunger intention while calm")

	drives.set_value(DriveState.HUNGER, 0.6)
	var candidates: Array = source.generate()
	_expect_equal(candidates.size(), 1, "pressing hunger activates known food opportunity")
	if candidates.size() == 1:
		_expect_true(candidates[0].bindings.has(&"target"), "drive-backed candidate is target-bound")
		_expect_true(candidates[0].bindings.get_subject(&"target").equals(food_ref), "drive-backed target comes from Wilson belief")
		_expect_true(float(candidates[0].provenance.get("drive_value", 0.0)) >= 0.6, "candidate provenance exposes backing need")


func _test_grounded_action_can_complete_authored_intention() -> void:
	var seek_food = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"seek_food")
	var consume = DomainId.action(&"consume_food")
	var consumed = DomainId.event_definition(&"food_consumed")
	var target = RuntimeWorldRef.entity(DomainId.entity(&"food_1"))
	var bindings = RoleBinding.new()
	bindings.bind(&"target", target)
	var intentions = CurrentIntentionStore.new()
	intentions.select(seek_food, bindings, &"step_select")
	var completion = GroundedIntentionCompletionService.new(
		intentions,
		[IntentionCompletionDefinition.new(seek_food, consume, consumed)]
	)
	var outcome = ActionOutcome.new(&"consume_exec", consume, bindings, [], consumed)
	var rejected = WorldCommitResult.new(false, [], [], ["rejected"], SemanticChangeSet.new())
	var rejected_result = completion.apply_grounded(outcome, rejected)
	_expect_equal(rejected_result.code, &"intention_completion_not_grounded", "rejected World outcome cannot complete intention")
	_expect_true(intentions.has_current(), "rejected World outcome preserves intention")

	var accepted = WorldCommitResult.new(true, [], [], [], SemanticChangeSet.new())
	var accepted_result = completion.apply_grounded(outcome, accepted)
	_expect_equal(accepted_result.code, &"intention_completion_applied", "accepted matching outcome completes intention")
	_expect_false(intentions.has_current(), "completed intention is cleared from authoritative cognition")


func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)


func _expect_false(actual: bool, label: String) -> void:
	if actual:
		_failures.append("Expected false: %s" % label)


func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])


func _finish() -> void:
	if _failures.is_empty():
		print("PASS drive_backed_opportunity_and_intention_completion_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL drive_backed_opportunity_and_intention_completion_test: %d failure(s)" % _failures.size())
	quit(1)
