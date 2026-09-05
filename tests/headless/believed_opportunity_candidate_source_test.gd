extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const BeliefProposition = preload("res://src/domain/cognition/belief_proposition.gd")
const BeliefStore = preload("res://src/domain/cognition/belief_store.gd")
const EpistemicClaim = preload("res://src/domain/cognition/epistemic_claim.gd")
const DecisionCandidate = preload("res://src/domain/cognition/decision_candidate.gd")
const PerceivedOpportunityDefinition = preload("res://src/domain/cognition/perceived_opportunity_definition.gd")
const BelievedOpportunityCandidateSource = preload("res://src/domain/cognition/believed_opportunity_candidate_source.gd")

var _failures: Array[String] = []
var _completed := false


func _init() -> void:
	_run()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS believed_opportunity_candidate_source_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL believed_opportunity_candidate_source_test: %d failure(s)" % _failures.size())
	quit(1)


func _run() -> void:
	var edible = DomainId.property(&"edible")
	var seek_food = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"seek_food")
	var food_a = RuntimeWorldRef.entity(DomainId.entity(&"food_a"))
	var food_b = RuntimeWorldRef.entity(DomainId.entity(&"food_b"))
	var beliefs = BeliefStore.new()
	_expect_true(beliefs.restore_entry(BeliefProposition.new(EpistemicClaim.property_claim(food_b, edible, true)), 0.65, 2).ok, "second food belief restores")
	_expect_true(beliefs.restore_entry(BeliefProposition.new(EpistemicClaim.property_claim(food_a, edible, true)), 0.90, 3).ok, "first food belief restores")

	var definition = PerceivedOpportunityDefinition.new(
		EpistemicClaim.Kind.PROPERTY,
		edible,
		seek_food,
		DecisionCandidate.Scope.INTENTIONAL,
		0.1
	)
	var source = BelievedOpportunityCandidateSource.new(beliefs, [definition])
	var candidates = source.generate()

	_expect_equal(candidates.size(), 2, "matching durable beliefs produce two opportunities")
	if candidates.size() == 2:
		_expect_equal(candidates[0].bindings.get_subject(&"target").sort_key(), food_a.sort_key(), "candidate ordering is stable by semantic target")
		_expect_equal(candidates[1].bindings.get_subject(&"target").sort_key(), food_b.sort_key(), "second target remains distinct")
		_expect_float(candidates[0].belief_score, 0.90, "candidate score derives from Wilson belief confidence")
		_expect_equal(candidates[0].provenance.get("source"), "belief", "belief provenance is explicit")
		_expect_equal(candidates[0].provenance.get("evidence_count"), 3, "belief evidence count remains observable provenance")

	var unrelated = PerceivedOpportunityDefinition.new(
		EpistemicClaim.Kind.PROPERTY,
		DomainId.property(&"drinkable"),
		seek_food,
		DecisionCandidate.Scope.INTENTIONAL,
		0.1
	)
	_expect_equal(BelievedOpportunityCandidateSource.new(beliefs, [unrelated]).generate().size(), 0, "unrelated belief semantics do not manufacture candidates")
	_completed = true


func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)


func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])


func _expect_float(actual: Variant, expected: float, label: String) -> void:
	if actual == null or not is_equal_approx(float(actual), expected):
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
