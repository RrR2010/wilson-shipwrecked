extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const ObservedEventClaim = preload("res://src/domain/cognition/observed_event_claim.gd")
const BeliefProposition = preload("res://src/domain/cognition/belief_proposition.gd")
const DomainValueCodec = preload("res://src/infrastructure/persistence/domain_value_codec.gd")

var _failures: Array[String] = []
var _completed := false


func _init() -> void:
	_run_slice()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS typed_event_claim_persistence_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL typed_event_claim_persistence_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	var subject = RuntimeWorldRef.entity(DomainId.entity(&"crate_4"))
	var claim = ObservedEventClaim.new(DomainId.event_definition(&"impact_committed"), &"target")
	var proposition = BeliefProposition.new(&"observed_event", [subject, claim])
	var original_key = proposition.key()

	_expect_equal(claim.event_type.kind, DomainId.Kind.EVENT_DEFINITION, "claim stores EventDefinitionId")
	_expect_equal(String(claim.event_type.value), "impact_committed", "claim preserves event semantic id")
	_expect_equal(String(claim.role_name), "target", "claim preserves perceived role")

	var codec = DomainValueCodec.new()
	var encoded = codec.encode(claim)
	var json_text = JSON.stringify(encoded)
	var parsed = JSON.parse_string(json_text)
	_expect_true(parsed != null, "encoded claim survives JSON parse")
	if parsed == null:
		return
	var restored = codec.decode(parsed)
	_expect_true(restored != null, "typed claim decodes")
	if restored == null:
		return

	_expect_equal(restored.sort_key(), claim.sort_key(), "claim stable identity survives JSON round-trip")
	_expect_equal(restored.event_type.kind, DomainId.Kind.EVENT_DEFINITION, "restored claim retains event id kind")
	_expect_equal(String(restored.event_type.value), "impact_committed", "restored claim retains event value")
	_expect_equal(String(restored.role_name), "target", "restored claim retains role")

	var restored_proposition = BeliefProposition.new(&"observed_event", [subject, restored])
	_expect_equal(restored_proposition.key(), original_key, "belief proposition identity survives claim reconstruction")

	_completed = true


func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)


func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
