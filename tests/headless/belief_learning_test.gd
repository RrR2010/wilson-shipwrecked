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
	var evidence = derived[0]
	_expect_true(evidence.supports, "perception produces supporting evidence")
	_expect_equal(evidence.strength, 0.5, "perceptual confidence preserved")

	var store = BeliefStore.new()
	_expect_true(store.apply_evidence(evidence).ok, "first evidence applied")
	var proposition = evidence.proposition
	var entry = store.get_entry(proposition)
	_expect_equal(entry.confidence, 0.5, "first support sets bounded confidence")
	_expect_equal(entry.evidence_count, 1, "evidence count tracked")

	_expect_true(store.apply_evidence(evidence).ok, "repeated support applied")
	_expect_equal(entry.confidence, 0.75, "repeated support has diminishing return")

	var contradiction = BeliefEvidence.new(proposition, false, 0.5, &"exec_2", &"vision")
	_expect_true(store.apply_evidence(contradiction).ok, "contradictory evidence applied")
	_expect_equal(entry.confidence, 0.375, "contradiction revises confidence downward")
	_expect_equal(entry.evidence_count, 3, "all evidence counted")
	_expect_equal(String(entry.last_modality), "vision", "latest provenance retained")

	var projection = EpistemicGraphProjection.new()
	projection.rebuild(store)
	_expect_equal(projection.query_by_predicate(&"was_impacted").size(), 1, "predicate projection rebuilt")
	_expect_equal(projection.query_by_subject(crate).size(), 1, "subject projection rebuilt")

	var projection2 = EpistemicGraphProjection.new()
	projection2.rebuild(store)
	_expect_equal(
		projection2.query_by_subject(crate)[0].proposition.key(),
		projection.query_by_subject(crate)[0].proposition.key(),
		"projection reconstruction preserves semantic result"
	)

	_completed = true

func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)

func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
