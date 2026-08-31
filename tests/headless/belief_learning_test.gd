extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const PerceptualEvidence = preload("res://src/domain/cognition/perceptual_evidence.gd")
const BeliefLearningService = preload("res://src/domain/cognition/belief_learning_service.gd")
const BeliefEvidence = preload("res://src/domain/cognition/belief_evidence.gd")
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
	var perceptual = PerceptualEvidence.new(crate, &"was_impacted", true, 0.5, &"exec_1", &"hearing")
	var learner = BeliefLearningService.new()
	var derived = learner.derive(perceptual)
	_expect_equal(derived.size(), 1, "one belief evidence derived")
	if derived.size() != 1:
		return
	var evidence = derived[0]
	_expect_true(evidence != null, "belief evidence exists")
	if evidence == null:
		return
	_expect_true(evidence.supports, "perception produces supporting evidence")
	_expect_equal(evidence.strength, 0.5, "perceptual confidence preserved")

	var store = BeliefStore.new()
	var first_result = store.apply_evidence(evidence)
	_expect_true(first_result != null, "first evidence returns result")
	if first_result == null:
		return
	_expect_true(first_result.ok, "first evidence applied")
	var proposition = evidence.proposition
	_expect_true(proposition != null, "evidence proposition exists")
	if proposition == null:
		return
	var entry = store.get_entry(proposition)
	_expect_true(entry != null, "belief entry created")
	if entry == null:
		return
	_expect_equal(entry.confidence, 0.5, "first support sets bounded confidence")
	_expect_equal(entry.evidence_count, 1, "evidence count tracked")

	var second_result = store.apply_evidence(evidence)
	_expect_true(second_result != null, "repeated evidence returns result")
	if second_result == null:
		return
	_expect_true(second_result.ok, "repeated support applied")
	_expect_equal(entry.confidence, 0.75, "repeated support has diminishing return")

	var contradiction = BeliefEvidence.new(proposition, false, 0.5, &"exec_2", &"vision")
	var contradiction_result = store.apply_evidence(contradiction)
	_expect_true(contradiction_result != null, "contradiction returns result")
	if contradiction_result == null:
		return
	_expect_true(contradiction_result.ok, "contradictory evidence applied")
	_expect_equal(entry.confidence, 0.375, "contradiction revises confidence downward")
	_expect_equal(entry.evidence_count, 3, "all evidence counted")
	_expect_equal(String(entry.last_modality), "vision", "latest provenance retained")

	var projection = EpistemicGraphProjection.new()
	projection.rebuild(store)
	var by_predicate = projection.query_by_predicate(&"was_impacted")
	var by_subject = projection.query_by_subject(crate)
	_expect_equal(by_predicate.size(), 1, "predicate projection rebuilt")
	_expect_equal(by_subject.size(), 1, "subject projection rebuilt")
	if by_subject.size() != 1:
		return

	var projection2 = EpistemicGraphProjection.new()
	projection2.rebuild(store)
	var by_subject2 = projection2.query_by_subject(crate)
	_expect_equal(by_subject2.size(), 1, "second subject projection rebuilt")
	if by_subject2.size() != 1:
		return
	_expect_equal(
		by_subject2[0].proposition.key(),
		by_subject[0].proposition.key(),
		"projection reconstruction preserves semantic result"
	)

	_completed = true

func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)

func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
