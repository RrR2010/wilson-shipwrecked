extends SceneTree

const ContentPackLoader = preload("res://src/infrastructure/content_loading/content_pack_loader.gd")
const RelationFailureDefinition = preload("res://src/domain/world/relation_failure_definition.gd")

var _failures: Array[String] = []
var _completed := false


func _init() -> void:
	_run_slice()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS relation_failure_content_pack_loading_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL relation_failure_content_pack_loading_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	var loader = ContentPackLoader.new()
	var loaded = loader.load_dictionary({
		"schema_version": 1,
		"properties": [
			{"id": "binding_integrity", "family": "number", "min": 0.0, "max": 1.0},
		],
		"relation_failures": [
			{
				"id": "binding_breaks_when_weak",
				"relation": "attached_to",
				"monitored_property": "binding_integrity",
				"threshold": 0.25,
				"compare": "<=",
				"qualifier": {"kind": "assembly_slot", "id": "roof_binding"},
			},
			{
				"id": "pressure_release",
				"relation": "sealed_by",
				"monitored_property": "binding_integrity",
				"threshold": 0.9,
				"compare": ">=",
			},
		],
	})
	_expect_true(loaded.ok, "valid relation failure content loads")
	if loaded.ok:
		var definitions: Array = loaded.value.relation_failure_definitions()
		_expect_equal(definitions.size(), 2, "both relation failure definitions register")
		var first = definitions[0]
		var second = definitions[1]
		_expect_equal(String(first.id), "binding_breaks_when_weak", "definitions sort by stable id")
		_expect_equal(first.compare, RelationFailureDefinition.Compare.LTE, "<= parses to LTE")
		_expect_equal(first.qualifier.sort_key(), "assembly_slot:roof_binding", "typed assembly-slot qualifier parses")
		_expect_equal(second.compare, RelationFailureDefinition.Compare.GTE, ">= parses to GTE")
		_expect_true(second.qualifier == null, "qualifier remains optional")

	var invalid_compare = loader.load_dictionary({
		"schema_version": 1,
		"properties": [{"id": "integrity", "family": "number", "min": 0.0, "max": 1.0}],
		"relation_failures": [{
			"id": "invalid_compare",
			"relation": "attached_to",
			"monitored_property": "integrity",
			"threshold": 0.2,
			"compare": "<",
		}],
	})
	_expect_true(not invalid_compare.ok, "unsupported comparison is rejected")
	if not invalid_compare.ok:
		_expect_equal(invalid_compare.code, &"unknown_relation_failure_compare", "invalid compare reports semantic loader code")

	var invalid_threshold = loader.load_dictionary({
		"schema_version": 1,
		"properties": [{"id": "integrity", "family": "number", "min": 0.0, "max": 1.0}],
		"relation_failures": [{
			"id": "invalid_threshold",
			"relation": "attached_to",
			"monitored_property": "integrity",
			"threshold": "weak",
		}],
	})
	_expect_true(not invalid_threshold.ok, "non-numeric threshold is rejected")
	if not invalid_threshold.ok:
		_expect_equal(invalid_threshold.code, &"invalid_content_shape", "invalid threshold reports shape error")

	_completed = true


func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)


func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
