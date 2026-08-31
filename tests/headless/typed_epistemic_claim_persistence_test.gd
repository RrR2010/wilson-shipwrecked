extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const EpistemicClaim = preload("res://src/domain/cognition/epistemic_claim.gd")
const BeliefProposition = preload("res://src/domain/cognition/belief_proposition.gd")
const DomainValueCodec = preload("res://src/infrastructure/persistence/domain_value_codec.gd")

var _failures: Array[String] = []
var _completed := false


func _init() -> void:
	_run_slice()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS typed_epistemic_claim_persistence_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL typed_epistemic_claim_persistence_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	var crate = RuntimeWorldRef.entity(DomainId.entity(&"crate_4"))
	var palm = RuntimeWorldRef.entity(DomainId.entity(&"palm_1"))
	var claims = [
		EpistemicClaim.event_claim(crate, DomainId.event_definition(&"impact_committed"), &"target"),
		EpistemicClaim.property_claim(crate, DomainId.property(&"structural_integrity"), 3),
		EpistemicClaim.relation_claim(crate, DomainId.relation_type(&"near"), palm),
	]
	var codec = DomainValueCodec.new()
	for claim in claims:
		var original_key = BeliefProposition.new(claim).key()
		var encoded = codec.encode(claim)
		var json_text = JSON.stringify(encoded)
		var parsed = JSON.parse_string(json_text)
		_expect_true(parsed != null, "encoded claim survives JSON parse")
		if parsed == null:
			continue
		var restored = codec.decode(parsed)
		_expect_true(restored != null, "typed claim decodes")
		if restored == null:
			continue
		_expect_equal(restored.kind, claim.kind, "claim kind survives JSON round-trip")
		_expect_equal(restored.sort_key(), claim.sort_key(), "claim stable identity survives JSON round-trip")
		_expect_equal(BeliefProposition.new(restored).key(), original_key, "belief proposition identity survives claim reconstruction")

	_completed = true


func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)


func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
