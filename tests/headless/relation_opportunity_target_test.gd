extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const BeliefProposition = preload("res://src/domain/cognition/belief_proposition.gd")
const BeliefStore = preload("res://src/domain/cognition/belief_store.gd")
const EpistemicClaim = preload("res://src/domain/cognition/epistemic_claim.gd")
const PerceptualEvidence = preload("res://src/domain/cognition/perceptual_evidence.gd")
const PerceptionResult = preload("res://src/domain/cognition/perception_result.gd")
const DecisionCandidate = preload("res://src/domain/cognition/decision_candidate.gd")
const PerceivedOpportunityDefinition = preload("res://src/domain/cognition/perceived_opportunity_definition.gd")
const PerceivedOpportunityService = preload("res://src/domain/cognition/perceived_opportunity_service.gd")
const BelievedOpportunityCandidateSource = preload("res://src/domain/cognition/believed_opportunity_candidate_source.gd")

var _failures: Array[String] = []
var _completed := false


func _init() -> void:
	_run()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS relation_opportunity_target_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL relation_opportunity_target_test: %d failure(s)" % _failures.size())
	quit(1)


func _run() -> void:
	var wilson = RuntimeWorldRef.wilson()
	var food = RuntimeWorldRef.entity(DomainId.entity(&"visible_food"))
	var near = DomainId.relation_type(&"perceptibly_near")
	var seek_food = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"seek_food")
	var claim = EpistemicClaim.relation_claim(wilson, near, food)
	var definition = PerceivedOpportunityDefinition.new(
		EpistemicClaim.Kind.RELATION,
		near,
		seek_food,
		DecisionCandidate.Scope.INTENTIONAL,
		0.1
	)

	var perceptual = PerceivedOpportunityService.new().generate(
		PerceptionResult.new([], [PerceptualEvidence.new(claim, 0.8, &"sensor_1", &"vision")]),
		BeliefStore.new(),
		[definition]
	)
	_expect_equal(perceptual.size(), 1, "relation perception yields one opportunity")
	if perceptual.size() == 1:
		_expect_target(perceptual[0], food, "fresh relation evidence binds relation object as target")

	var beliefs = BeliefStore.new()
	_expect_true(beliefs.restore_entry(BeliefProposition.new(claim), 0.85, 1).ok, "relation belief restores")
	var remembered = BelievedOpportunityCandidateSource.new(beliefs, [definition]).generate()
	_expect_equal(remembered.size(), 1, "relation belief yields one remembered opportunity")
	if remembered.size() == 1:
		_expect_target(remembered[0], food, "remembered relation binds relation object as target")

	_completed = true


func _expect_target(candidate, expected, label: String) -> void:
	var target = candidate.bindings.get_subject(&"target")
	if target == null or not target.equals(expected):
		_failures.append("%s | expected=%s actual=%s" % [label, expected.sort_key(), "null" if target == null else target.sort_key()])


func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)


func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
