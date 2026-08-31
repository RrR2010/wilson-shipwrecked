extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const EpistemicClaim = preload("res://src/domain/cognition/epistemic_claim.gd")
const PerceptualEvidence = preload("res://src/domain/cognition/perceptual_evidence.gd")
const PerceptionResult = preload("res://src/domain/cognition/perception_result.gd")
const BeliefLearningService = preload("res://src/domain/cognition/belief_learning_service.gd")
const BeliefStore = preload("res://src/domain/cognition/belief_store.gd")
const PerceivedOpportunityDefinition = preload("res://src/domain/cognition/perceived_opportunity_definition.gd")
const PerceivedOpportunityService = preload("res://src/domain/cognition/perceived_opportunity_service.gd")
const DecisionCandidate = preload("res://src/domain/cognition/decision_candidate.gd")
const DecisionRouter = preload("res://src/domain/cognition/decision_router.gd")

var _failures: Array[String] = []
var _completed := false

func _init() -> void:
	_run_slice()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS decision_routing_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL decision_routing_test: %d failure(s)" % _failures.size())
	quit(1)

func _run_slice() -> void:
	var crate = RuntimeWorldRef.entity(DomainId.entity(&"crate_4"))
	var impact_event = DomainId.event_definition(&"impact_committed")
	var impact_claim = EpistemicClaim.event_claim(crate, impact_event, &"target")
	var impact_evidence = PerceptualEvidence.new(impact_claim, 0.5, &"exec_1", &"hearing")
	var perception = PerceptionResult.new([], [impact_evidence])

	var learner = BeliefLearningService.new()
	var derived = learner.derive(impact_evidence)
	_expect_equal(derived.size(), 1, "one belief evidence derived")
	if derived.size() != 1:
		return
	var store = BeliefStore.new()
	var applied = store.apply_evidence(derived[0])
	_expect_not_null(applied, "belief apply returns result")
	if applied == null:
		return
	_expect_true(applied.ok, "perceived evidence reaches belief store")

	var investigate_id = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"investigate_impacted_object")
	var rest_id = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"rest")
	var evade_id = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"evade_threat")
	var current_id = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"open_container")

	var opportunity = PerceivedOpportunityDefinition.new(
		EpistemicClaim.Kind.EVENT,
		impact_event,
		investigate_id,
		DecisionCandidate.Scope.TACTICAL,
		0.2
	)
	var generator = PerceivedOpportunityService.new()
	var generated = generator.generate(perception, store, [opportunity])
	_expect_equal(generated.size(), 1, "perceived evidence generates one tactical candidate")
	if generated.size() != 1:
		return
	var investigate = generated[0]
	_expect_equal(investigate.bindings.get_subject(&"target").key(), crate.key(), "candidate keeps perceived target binding")
	_expect_equal(investigate.salience_score, 0.5, "perceptual confidence contributes salience")
	_expect_equal(investigate.belief_score, 0.5, "belief confidence contributes support")

	var empty_binding = RoleBinding.new()
	var rest = DecisionCandidate.new(rest_id, empty_binding, DecisionCandidate.Scope.INTENTIONAL, 5.0)
	var router = DecisionRouter.new()
	var tactical_result = router.resolve([rest, investigate], current_id)
	_expect_true(tactical_result.has_selection(), "router selects with active intention")
	_expect_equal(String(tactical_result.regime), "tactical", "active intention keeps tactical regime")
	_expect_equal(tactical_result.selected_candidate.intention_id.key(), investigate_id.key(), "high-scoring broad option does not displace local tactic")

	var no_current_result = router.resolve([rest, investigate], null)
	_expect_true(no_current_result.has_selection(), "router selects intentional candidate without active intention")
	_expect_equal(String(no_current_result.regime), "intentional", "no active intention routes broadly")
	_expect_equal(no_current_result.selected_candidate.intention_id.key(), rest_id.key(), "intentional candidate selected")

	var threat = DecisionCandidate.new(evade_id, empty_binding, DecisionCandidate.Scope.IMMEDIATE_THREAT, -10.0)
	var threat_result = router.resolve([rest, investigate, threat], current_id)
	_expect_equal(String(threat_result.regime), "immediate_threat", "threat uses separate fast-path regime")
	_expect_equal(threat_result.selected_candidate.intention_id.key(), evade_id.key(), "threat wins regardless cross-regime score")

	var alpha_id = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"alpha")
	var beta_id = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"beta")
	var alpha = DecisionCandidate.new(alpha_id, empty_binding, DecisionCandidate.Scope.INTENTIONAL, 1.0)
	var beta = DecisionCandidate.new(beta_id, empty_binding, DecisionCandidate.Scope.INTENTIONAL, 1.0)
	var tie = router.resolve([beta, alpha], null)
	_expect_equal(tie.selected_candidate.intention_id.key(), alpha_id.key(), "equal scores use stable semantic tie-break")

	var biased = DecisionCandidate.new(beta_id, empty_binding, DecisionCandidate.Scope.INTENTIONAL, 1.0, 0.0, 0.0, 0.0, 0.25)
	_expect_equal(biased.external_bias, 0.25, "external suggestion remains bounded component")

	_completed = true

func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)

func _expect_not_null(actual, label: String) -> void:
	if actual == null:
		_failures.append("Expected non-null: %s" % label)

func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
