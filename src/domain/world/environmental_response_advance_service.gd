class_name EnvironmentalResponseAdvanceService
extends RefCounted

const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const SemanticChange = preload("res://src/domain/world/semantic_change.gd")
const SemanticChangeSet = preload("res://src/domain/world/semantic_change_set.gd")
const EntityInstance = preload("res://src/domain/world/entity_instance.gd")

## Applies declarative environmental responses to ordinary World properties.
## The condition provider may be procedural weather or any future environment source
## implementing condition(condition_id, fallback). Protection is optional and remains
## a separate derived query through ExposureResolver.

var _condition_provider
var _world_query
var _entities
var _definitions: Array
var _exposure_resolver


func _init(
	condition_provider,
	world_query,
	entity_store,
	definitions: Array,
	exposure_resolver = null
) -> void:
	assert(condition_provider != null and condition_provider.has_method("condition"), "Environmental response requires condition provider")
	assert(world_query != null, "Environmental response requires WorldQuery")
	assert(entity_store != null, "Environmental response requires EntityStore")
	_condition_provider = condition_provider
	_world_query = world_query
	_entities = entity_store
	_exposure_resolver = exposure_resolver
	var seen: Dictionary = {}
	for definition in definitions:
		assert(definition != null, "Environmental response definitions cannot contain null")
		assert(not seen.has(definition.id), "Duplicate environmental response definition: %s" % String(definition.id))
		if definition.exposure_kind != &"":
			assert(_exposure_resolver != null, "Exposure-aware environmental response requires ExposureResolver")
		seen[definition.id] = true
		_definitions.append(definition)
	_definitions.sort_custom(func(a, b): return String(a.id) < String(b.id))


func advance(elapsed: float) -> Dictionary:
	assert(is_finite(elapsed) and elapsed >= 0.0, "Environmental response elapsed must be finite and non-negative")
	var change_set = SemanticChangeSet.new()
	var transitions: Array = []
	var diagnostics: Array[String] = []
	if elapsed <= 0.0:
		return _result(change_set, transitions, diagnostics)

	for definition in _definitions:
		var condition := clampf(float(_condition_provider.condition(definition.condition_id, 0.0)), 0.0, 1.0)
		if condition <= 0.0:
			continue
		for entity in _entities.entities():
			if entity.lifecycle != EntityInstance.Lifecycle.ACTIVE:
				continue
			var subject = RuntimeWorldRef.entity(entity.id)
			if definition.required_capability != null and not _world_query.has_authored_capability(subject, definition.required_capability):
				continue
			var current_value = _world_query.get_instance_property(subject, definition.target_property)
			if not _finite_numeric(current_value):
				continue
			var susceptibility := 1.0
			if definition.susceptibility_property != null:
				var susceptibility_value = _world_query.get_instance_property(subject, definition.susceptibility_property)
				if not _unit_numeric(susceptibility_value):
					continue
				susceptibility = float(susceptibility_value)
				if susceptibility < definition.minimum_susceptibility:
					continue
			var exposure := condition
			if definition.exposure_kind != &"":
				var exposure_result = _exposure_resolver.resolve(subject, definition.exposure_kind, condition)
				exposure = exposure_result.residual_exposure
			if exposure <= 0.0:
				continue
			var current := float(current_value)
			var delta := definition.rate_per_second_at_full_exposure * exposure * susceptibility * elapsed
			var next_value := clampf(current + delta, definition.lower_bound, definition.upper_bound)
			if is_equal_approx(next_value, current):
				continue
			if _world_query.has_method("validate_property_value") and not _world_query.validate_property_value(definition.target_property, next_value):
				diagnostics.append("Environmental response produced invalid property value: %s" % definition.target_property.sort_key())
				continue
			var mutation = _entities.set_property_override(entity.id, definition.target_property, next_value)
			if not mutation.ok:
				diagnostics.append("Environmental response mutation failed: %s" % String(mutation.code))
				continue
			change_set.add(SemanticChange.property_change(subject, definition.target_property))
			transitions.append({
				"subject": subject,
				"property": definition.target_property,
				"previous": current,
				"current": next_value,
				"response_id": definition.id,
				"condition_id": definition.condition_id,
				"raw_condition": condition,
				"residual_exposure": exposure,
			})

	return _result(change_set, transitions, diagnostics)


func _result(change_set, transitions: Array, diagnostics: Array[String]) -> Dictionary:
	return {
		"change_set": change_set,
		"transitions": transitions,
		"diagnostics": diagnostics,
	}


func _finite_numeric(value: Variant) -> bool:
	return (value is int or value is float) and is_finite(float(value))


func _unit_numeric(value: Variant) -> bool:
	return _finite_numeric(value) and float(value) >= 0.0 and float(value) <= 1.0
