extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const EventDefinition = preload("res://src/domain/content/event_definition.gd")
const EnvironmentalResponseTargetSelector = preload("res://src/domain/world/environmental_response_target_selector.gd")
const ContentPackLoader = preload("res://src/infrastructure/content_loading/content_pack_loader.gd")

var _failures: Array[String] = []
var _completed := false


func _init() -> void:
	_run_slice()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS environment_content_pack_loading_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL environment_content_pack_loading_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	var loaded = ContentPackLoader.new().load_dictionary({
		"schema_version": 1,
		"properties": [
			{"id": "moisture", "family": "number", "min": 0.0, "max": 1.0},
			{"id": "absorbency", "family": "number", "min": 0.0, "max": 1.0},
			{"id": "coverage", "family": "number", "min": 0.0, "max": 1.0},
			{"id": "rain_protection", "family": "number", "min": 0.0, "max": 1.0},
			{"id": "binding_integrity", "family": "number", "min": 0.0, "max": 1.0},
		],
		"events": [{
			"id": "weather_changed",
			"modalities": ["vision", "hearing"],
			"access_scope": "ambient",
			"context_transition": true,
		}],
		"entities": [{
			"id": "cloth",
			"capabilities": ["covering"],
			"base_properties": {"moisture": 0.0, "absorbency": 1.0, "coverage": 0.8, "rain_protection": 0.75},
		}],
		"assemblies": [{
			"id": "simple_shelter",
			"slots": [{
				"id": "cover_binding",
				"role": "binding",
				"accepted_component": {"kind": "all_of", "children": []},
			}],
		}],
		"weather": [
			{"id": "clear", "min_duration": 1.0, "max_duration": 1.0, "conditions": {"rain_intensity": 0.0}},
			{"id": "rain", "min_duration": 4.0, "max_duration": 4.0, "conditions": {"rain_intensity": 1.0}},
		],
		"weather_transitions": [
			{"from": "clear", "to": "rain", "weight": 1.0, "event": "weather_changed"},
			{"from": "rain", "to": "clear", "weight": 1.0, "event": "weather_changed"},
		],
		"environmental_responses": [
			{
				"id": "covering_gets_wet",
				"condition": "rain_intensity",
				"target_property": "moisture",
				"rate": 0.25,
				"required_capability": "covering",
				"susceptibility_property": "absorbency",
			},
			{
				"id": "wind_degrades_cover_binding",
				"condition": "wind_intensity",
				"target_property": "binding_integrity",
				"rate": -0.1,
				"target": {"kind": "assembly_slot", "slot": "cover_binding"},
			},
		],
		"protection_rules": [{
			"id": "rain_cover",
			"exposure_kind": "rain",
			"relation": "protects",
			"coverage_property": "coverage",
			"strength_property": "rain_protection",
		}],
		"dynamic_processes": [{
			"id": "drying",
			"target_property": "moisture",
			"rate": -0.05,
			"lower_bound": 0.0,
			"upper_bound": 1.0,
		}],
	})
	_expect_true(loaded.ok, "environmental content pack loads and seals")
	if not loaded.ok:
		_completed = true
		return
	var content = loaded.value
	_expect_equal(content.weather_definitions().size(), 2, "weather definitions enter sealed registry")
	_expect_equal(content.weather_transition_definitions().size(), 2, "weather transitions enter sealed registry")
	_expect_equal(content.environmental_response_definitions().size(), 2, "environment responses enter sealed registry")
	_expect_equal(content.protection_rule_definitions().size(), 1, "protection rule enters sealed registry")
	_expect_equal(content.dynamic_process_definitions().size(), 1, "dynamic process enters sealed registry")
	var event = content.get_event_definition(DomainId.event_definition(&"weather_changed"))
	_expect_true(event != null, "ambient weather event is retrievable")
	if event != null:
		_expect_equal(event.access_scope, EventDefinition.AccessScope.AMBIENT, "content loader preserves ambient access scope")
		_expect_true(event.context_transition, "content loader preserves authored context-transition semantics")
	var responses = content.environmental_response_definitions()
	var wind_response = null
	for response in responses:
		if response.id == &"wind_degrades_cover_binding":
			wind_response = response
	_expect_true(wind_response != null, "assembly-slot environmental response is retrievable")
	if wind_response != null:
		_expect_equal(wind_response.target_selector.kind, EnvironmentalResponseTargetSelector.Kind.ASSEMBLY_SLOT, "loader preserves assembly-slot target kind")
		_expect_equal(wind_response.target_selector.slot_id.sort_key(), DomainId.assembly_slot(&"cover_binding").sort_key(), "loader preserves target assembly slot")

	var malformed = ContentPackLoader.new().load_dictionary({
		"schema_version": 1,
		"properties": [{"id": "binding_integrity", "family": "number", "min": 0.0, "max": 1.0}],
		"environmental_responses": [{
			"id": "bad_target",
			"condition": "wind_intensity",
			"target_property": "binding_integrity",
			"rate": -0.1,
			"target": {"kind": "assembly_slot"},
		}],
	})
	_expect_true(not malformed.ok, "assembly-slot target without slot fails content loading")
	_expect_equal(malformed.code, &"invalid_content_shape", "malformed target fails with content-shape diagnostic")

	_completed = true


func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)


func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
