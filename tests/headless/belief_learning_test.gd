extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const EpistemicClaim = preload("res://src/domain/cognition/epistemic_claim.gd")
const PerceptualEvidence = preload("res://src/domain/cognition/perceptual_evidence.gd")
const BeliefLearningService = preload("res://src/domain/cognition/belief_learning_service.gd")
const BeliefEvidence = preload("res://src/domain/cognition/belief_evidence.gd")
const BeliefProposition = preload("res://src/domain/cognition/belief_proposition.gd")
const BeliefStore = preload("res://src/domain/cognition/belief_store.gd")
const EpistemicGraphProjection = preload("res://src/domain/cognition/epistemic_graph_projection.gd")

var _failures: Array[String] = []
var _completed := false

func _init() -> void:
	_run_slice()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS belief_learning_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL belief_learning_test: %d failure(s)" % _failures.size())
	quit(1)

func _run_slice() -> void:
	var crate = RuntimeWorldRef.entity(DomainId.entity(&"crate_4"))
	var palm = RuntimeWorldRef.entity(DomainId.entity(&"palm_1"))
	var event_type = DomainId.event_definition(&"impact_committed")
	var event_claim = EpistemicClaim.event_claim(crate, event_type, &"target")
	var perceptual = PerceptualEvidence.new(event_claim, 0.5, &"exec_1", &"hearing")
	var learner = BeliefLearningService.new()
	var derived = learner.derive(perceptual)
	_expect_equal(derived.size(), 1, "one belief evidence derived")
	if derived.size() != 1:
		return
	var evidence = derived[0]
	_expect_true(evidence.supports, "perception produces supporting evidence")
	_expect_equal(evidence.strength, 0.5, "perceptual confidence preserved")
	_expect_equal(evidence.proposition.claim.kind, EpistemicClaim.Kind.EVENT, "belief proposition wraps EVENT claim")

	var store = BeliefStore.new()
	var first_result = store.apply_evidence(evidence)
	_expect_true(first_result.ok, "first evidence applied")
	var proposition = evidence.proposition
	var entry = store.get_entry(proposition)
	_expect_true(entry != null, "belief entry created")
	if entry == null:
		return
	_expect_equal(entry.confidence, 0.5, "first support sets bounded confidence")
	_expect_equal(entry.evidence_count, 1, "evidence count tracked")

	_expect_true(store.apply_evidence(evidence).ok, "repeated support applied")
	_expect_equal(entry.confidence, 0.75, "repeated support has diminishing return")

	var contradiction = BeliefEvidence.new(proposition, false, 0.5, &"exec_2", &"vision")
	_expect_true(store.apply_evidence(contradiction).ok, "contradictory evidence applied")
	_expect_equal(entry.confidence, 0.375, "contradiction revises confidence downward")
	_expect_equal(entry.evidence_count, 3, "all evidence counted")
	_expect_equal(String(entry.last_modality), "vision", "latest provenance retained")

	# Additional algebra variants have explicit identities and do not share generic tuple keys.
	var integrity = DomainId.property(&"structural_integrity")
	var near = DomainId.relation_type(&"near")
	var property_prop = BeliefProposition.new(EpistemicClaim.property_claim(crate, integrity, 3))
	var relation_prop = BeliefProposition.new(EpistemicClaim.relation_claim(crate, near, palm))
	_expect_true(property_prop.key() != proposition.key(), "property and event claims have distinct typed identity")
	_expect_true(relation_prop.key() != proposition.key(), "relation and event claims have distinct typed identity")
	_expect_true(property_prop.key() != relation_prop.key(), "property and relation claims have distinct typed identity")
	_expect_true(store.restore_entry(property_prop, 0.6, 1).ok, "property claim restores")
	_expect_true(store.restore_entry(relation_prop, 0.7, 1).ok, "relation claim restores")

	var projection = EpistemicGraphProjection.new()
	projection.rebuild(store)
	_expect_equal(projection.query_by_kind(EpistemicClaim.Kind.EVENT).size(), 1, "event kind projection rebuilt")
	_expect_equal(projection.query_by_kind(EpistemicClaim.Kind.PROPERTY).size(), 1, "property kind projection rebuilt")
	_expect_equal(projection.query_by_kind(EpistemicClaim.Kind.RELATION).size(), 1, "relation kind projection rebuilt")
	_expect_equal(projection.query_by_semantic_id(event_type).size(), 1, "event semantic-id projection rebuilt")
	_expect_equal(projection.query_by_semantic_id(integrity).size(), 1, "property semantic-id projection rebuilt")
	_expect_equal(projection.query_by_subject(crate).size(), 3, "subject projection indexes all claim kinds")
	_expect_equal(projection.query_by_subject(palm).size(), 1, "relation object is indexed as referenced subject")

	var projection2 = EpistemicGraphProjection.new()
	projection2.rebuild(store)
	var by_subject2 = projection2.query_by_subject(crate)
	_expect_equal(by_subject2.size(), 3, "second subject projection rebuilt")
	_expect_equal(by_subject2[0].proposition.sort_key(), projection.query_by_subject(crate)[0].proposition.sort_key(), "projection reconstruction preserves deterministic ordering")

	_completed = true

func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)

func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
