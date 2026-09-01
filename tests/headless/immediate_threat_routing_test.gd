extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const EpistemicClaim = preload("res://src/domain/cognition/epistemic_claim.gd")
const PerceptualEvidence = preload("res://src/domain/cognition/perceptual_evidence.gd")
const PerceptionResult = preload("res://src/domain/cognition/perception_result.gd")
const ThreatInterpretationRule = preload("res://src/domain/cognition/threat_interpretation_rule.gd")
const PerceivedThreatService = preload("res://src/domain/cognition/perceived_threat_service.gd")
const DefensiveCandidateDefinition = preload("res://src/domain/cognition/defensive_candidate_definition.gd")
const ImmediateThreatCandidateSource = preload("res://src/domain/cognition/immediate_threat_candidate_source.gd")
const DecisionCandidate = preload("res://src/domain/cognition/decision_candidate.gd")
const DecisionRouter = preload("res://src/domain/cognition/decision_router.gd")

var _failures: Array[String] = []
var _completed := false


func _init() -> void:
	_run_slice()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS immediate_threat_routing_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL immediate_threat_routing_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	var palm = RuntimeWorldRef.entity(DomainId.entity(&"palm_1"))
	var crack_event = DomainId.event_definition(&"palm_crack_visible")
	var dodge = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"dodge_threat")
	var continue_project = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"continue_project")
	var rule = ThreatInterpretationRule.new(crack_event, &"source", 0.9, 0.95, 0.5)
	var threat_service = PerceivedThreatService.new([rule])
	var source = ImmediateThreatCandidateSource.new(
		threat_service,
		[DefensiveCandidateDefinition.new(dodge, 0.4)]
	)

	var empty_perception = PerceptionResult.new()
	_expect_equal(source.generate(empty_perception).size(), 0, "physical hazard without accessible evidence creates no perceived threat candidate")

	var low_confidence = PerceptualEvidence.new(
		EpistemicClaim.event_claim(palm, crack_event, &"source"),
		0.3,
		&"hazard_cue_low",
		&"vision"
	)
	_expect_equal(source.generate(PerceptionResult.new([], [low_confidence])).size(), 0, "weak cue below authored confidence threshold does not force emergency")

	var evidence = PerceptualEvidence.new(
		EpistemicClaim.event_claim(palm, crack_event, &"source"),
		0.8,
		&"hazard_cue_1",
		&"vision"
	)
	var perception = PerceptionResult.new([], [evidence])
	var threat_candidates = source.generate(perception)
	_expect_equal(threat_candidates.size(), 1, "accessible threat cue creates defensive candidate")
	if threat_candidates.size() == 1:
		_expect_equal(threat_candidates[0].scope, DecisionCandidate.Scope.IMMEDIATE_THREAT, "defense uses immediate-threat regime")
		_expect_equal(threat_candidates[0].bindings.get_subject(&"threat_source").sort_key(), palm.sort_key(), "defense binds perceived threat source")
		_expect_true(threat_candidates[0].base_score <= 1.0 and threat_candidates[0].urgency_score <= 1.0, "emergency contributions remain bounded")

	var ordinary_bindings = RoleBinding.new()
	ordinary_bindings.bind(&"target", palm)
	var ordinary = DecisionCandidate.new(
		continue_project,
		ordinary_bindings,
		DecisionCandidate.Scope.INTENTIONAL,
		1.0,
		1.0,
		1.0,
		1.0,
		0.25
	)
	var candidates: Array = [ordinary]
	candidates.append_array(threat_candidates)
	var selected = DecisionRouter.new().resolve(candidates)
	_expect_equal(selected.regime, &"immediate_threat", "immediate threat wins by routing regime rather than giant score")
	_expect_equal(selected.selected.intention_id.sort_key(), dodge.sort_key(), "defensive intention is selected")
	_expect_true(selected.selected.total_score() < ordinary.total_score(), "lower-scoring defense still wins across regimes")

	_completed = true


func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)


func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
