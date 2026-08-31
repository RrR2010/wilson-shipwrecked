extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const ContentRegistry = preload("res://src/domain/content/content_registry.gd")
const EntityDefinition = preload("res://src/domain/content/entity_definition.gd")
const PropertyDefinition = preload("res://src/domain/content/property_definition.gd")

var _failures: Array[String] = []
var _completed := false


func _init() -> void:
	_run_slice()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS property_schema_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL property_schema_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	var integrity = DomainId.property(&"structural_integrity")
	var wet = DomainId.property(&"is_wet")
	var state = DomainId.property(&"state")

	var numeric = PropertyDefinition.new(integrity, PropertyDefinition.ValueFamily.NUMBER, 0, 5)
	var boolean = PropertyDefinition.new(wet, PropertyDefinition.ValueFamily.BOOLEAN)
	var symbol = PropertyDefinition.new(state, PropertyDefinition.ValueFamily.SYMBOL)

	_expect_true(numeric.validate_value(3), "numeric value inside bounds is valid")
	_expect_false(numeric.validate_value(6), "numeric value above bound is invalid")
	_expect_false(numeric.validate_value(true), "bool is not accepted as number")
	_expect_true(boolean.validate_value(false), "boolean property accepts bool")
	_expect_false(boolean.validate_value(0), "boolean property rejects number")
	_expect_true(symbol.validate_value(&"damaged"), "symbol property accepts StringName")
	_expect_false(symbol.supports_ordering(), "symbol property is not orderable")

	var typed = ContentRegistry.new()
	_expect_true(typed.register_property_definition(numeric).ok, "numeric property definition registers")
	_expect_true(typed.register_property_definition(boolean).ok, "boolean property definition registers")
	_expect_true(typed.register_property_definition(symbol).ok, "symbol property definition registers")
	var crate_type = DomainId.entity_type(&"typed_crate")
	_expect_true(typed.register_entity_definition(EntityDefinition.new(
		crate_type, [], {integrity.key(): 4, wet.key(): false, state.key(): &"intact"}, []
	)).ok, "typed entity definition registers")
	_expect_true(typed.seal().ok, "typed content with valid values seals")

	var invalid_value = ContentRegistry.new()
	_expect_true(invalid_value.register_property_definition(numeric).ok, "invalid-value schema registers")
	_expect_true(invalid_value.register_entity_definition(EntityDefinition.new(
		DomainId.entity_type(&"bad_crate"), [], {integrity.key(): 9}, []
	)).ok, "invalid authored entity registers before seal validation")
	var invalid_value_result = invalid_value.seal()
	_expect_false(invalid_value_result.ok, "out-of-bounds authored value fails seal")
	_expect_equal(String(invalid_value_result.code), "invalid_authored_property_value", "invalid authored value diagnostic code")

	var missing_schema = ContentRegistry.new()
	_expect_true(missing_schema.register_property_definition(numeric).ok, "schema mode activates")
	_expect_true(missing_schema.register_entity_definition(EntityDefinition.new(
		DomainId.entity_type(&"missing_schema_crate"), [], {wet.key(): true}, []
	)).ok, "entity with undeclared property registers before seal")
	var missing_result = missing_schema.seal()
	_expect_false(missing_result.ok, "undeclared property fails typed content seal")
	_expect_equal(String(missing_result.code), "missing_property_definition", "missing property definition diagnostic code")

	var legacy = ContentRegistry.new()
	_expect_true(legacy.register_entity_definition(EntityDefinition.new(
		DomainId.entity_type(&"legacy_crate"), [], {integrity.key(): 99}, []
	)).ok, "legacy entity registers")
	_expect_true(legacy.seal().ok, "legacy content without schemas remains compatible")

	_completed = true


func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)


func _expect_false(actual: bool, label: String) -> void:
	if actual:
		_failures.append("Expected false: %s" % label)


func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
