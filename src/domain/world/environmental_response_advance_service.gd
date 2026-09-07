class_name EnvironmentalResponseAdvanceService
extends RefCounted

const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const SemanticChange = preload("res://src/domain/world/semantic_change.gd")
const SemanticChangeSet = preload("res://src/domain/world/semantic_change_set.gd")
const EntityInstance = preload("res://src/domain/world/entity_instance.gd")
const EnvironmentalResponseTargetSelector = preload("res://src/domain/world/environmental_response_target_selector.gd")
const EffectivePropertyValueResolver = preload("res://src/domain/physical/effective_property_value_resolver.gd")

## Applies declarative environmental responses to ordinary World properties.
## The condition provider may be procedural weather or any future environment source
## implementing condition(condition_id, fallback). Explicit condition snapshots allow
## coarse/offline advancement to preserve the exact duration spent in each regime.
## Protection and assembly targeting remain derived queries rather than durable state.

var _condition_provider
var _world_query
var _entities
var _definitions: Array
var _exposure_resolver
var _property_values
var _assembly_bindings


func _init(
	condition_provider,
	world_query,
	entity_store,
	definitions: Array,
	exposure_resolver = null,
	physical_profiles = null,
	assembly_bindings = null,
	property_values = null
) -> void:
	assert(condition_provider != null and condition_provider.has_method("condition"), "Environmental response requires condition provider")
	assert(world_query != null, "Environmental response requires WorldQuery")
	assert(entity_store != null, "Environmental response requires EntityStore")
	_condition_provider = condition_provider
	_world_query = world_query
	_entities = entity_store
	_exposure_resolver = exposure_resolver
	_property_values = property_values if property_values != null else EffectivePropertyValueResolver.new(world_query, physical_profiles)
	_assembly_bindings = assembly_bindings
	assert(_property_values.has_method("get_value"), "Environmental property resolver must implement get_value(subject, property_id)")
	var seen: Dictionary = {}
	for definition in definitions:
		assert(definition != null, "Environmental response definitions cannot contain null")
		assert(not seen.has(definition.id), "Duplicate environmental response definition: %s" % String(definition.id))
		if definition.exposure_kind != &"":
			assert(_exposure_resolver != null, "Exposure-aware environmental response requires ExposureResolver")
		if definition.target_selector.kind == EnvironmentalResponseTargetSelector.Kind.ASSEMBLY_SLOT:
			assert(_assembly_bindings != null, "Assembly-targeted environmental response requires AssemblyBindingProjection")
		seen[definition.id] = true
		_definitions.append(definition)
	_definitions.sort_custom(func(a, b): return String(a.id) < String(b.id))


func advance(elapsed: float, condition_snapshot: Dictionary = {}) -> Dictionary:
	assert(is_finite(elapsed) and elapsed >= 0.0, "Environmental response elapsed must be finite and non-negative")
	var change_set = SemanticChangeSet.new()
	var transitions: Array = []
	var diagnostics: Array[String] = []
	if elapsed <= 0.0:
		return _result(change_set, transitions, diagnostics)

	for definition in _definitions:
		var condition: float = _condition_value(definition.condition_id, condition_snapshot)
		if condition <= 0.0:
			continue
		for entity in _entities.entities():
			if entity.lifecycle != EntityInstance.Lifecycle.ACTIVE:
				continue
			var source_subject = RuntimeWorldRef.entity(entity.id)
			if definition.required_capability != null and not _world_query.has_authored_capability(source_subject, definition.required_capability):
				continue
			var susceptibility := 1.0
			if definition.susceptibility_property != null:
				var susceptibility_value = _property_values.get_value(source_subject, definition.susceptibility_property)
				if not _unit_numeric(susceptibility_value):
					continue
				susceptibility = float(susceptibility_value)
				if susceptibility < definition.minimum_susceptibility:
					continue
			var exposure := condition
			if definition.exposure_kind != &"":
				var exposure_result = _exposure_resolver.resolve(source_subject, definition.exposure_kind, condition)
				exposure = exposure_result.exposure_level
			if exposure <= 0.0:
				continue
			for target_subject in _resolve_targets(source_subject, definition.target_selector):
				_apply_response(
					definition,
					source_subject,
					target_subject,
					condition,
					exposure,
					susceptibility,
					elapsed,
					change_set,
					transitions,
					diagnostics
				)

	return _result(change_set, transitions, diagnostics)


func _apply_response(
	definition,
	source_subject,
	target_subject,
	condition: float,
	exposure: float,
	susceptibility: float,
	elapsed: float,
	change_set,
	transitions: Array,
	diagnostics: Array[String]
) -> void:
	var current_value = _world_query.get_instance_property(target_subject, definition.target_property)
	if not _finite_numeric(current_value):
		return
	var current := float(current_value)
	var delta: float = definition.rate_per_second_at_full_exposure * exposure * susceptibility * elapsed
	var next_value := clampf(current + delta, definition.lower_bound, definition.upper_bound)
	if is_equal_approx(next_value, current):
		return
	if _world_query.has_method("validate_property_value") and not _world_query.validate_property_value(definition.target_property, next_value):
		diagnostics.append("Environmental response produced invalid property value: %s" % definition.target_property.sort_key())
		return
	if target_subject.kind != RuntimeWorldRef.Kind.ENTITY:
		diagnostics.append("Environmental response target must currently be an entity: %s" % target_subject.sort_key())
		return
	var mutation = _entities.set_property_override(target_subject.id, definition.target_property, next_value)
	if not mutation.ok:
		diagnostics.append("Environmental response mutation failed: %s" % String(mutation.code))
		return
	change_set.add(SemanticChange.property_change(target_subject, definition.target_property))
	transitions.append({
		"subject": target_subject,
		"source_subject": source_subject,
		"property": definition.target_property,
		"previous": current,
		"current": next_value,
		"response_id": definition.id,
		"condition_id": definition.condition_id,
		"raw_condition": condition,
		"residual_exposure": exposure,
		"target_selector": definition.target_selector.stable_key(),
	})


func _resolve_targets(source_subject, selector) -> Array:
	match selector.kind:
		EnvironmentalResponseTargetSelector.Kind.SELF:
			return [source_subject]
		EnvironmentalResponseTargetSelector.Kind.ASSEMBLY_SLOT:
			var result: Array = []
			for binding in _assembly_bindings.bindings_for_host(source_subject):
				if binding.slot_id.equals(selector.slot_id):
					result.append(binding.component)
			result.sort_custom(func(a, b): return a.sort_key() < b.sort_key())
			return result
	return []


func _condition_value(condition_id: StringName, snapshot: Dictionary) -> float:
	if snapshot.has(condition_id):
		return clampf(float(snapshot[condition_id]), 0.0, 1.0)
	if snapshot.has(String(condition_id)):
		return clampf(float(snapshot[String(condition_id)]), 0.0, 1.0)
	if not snapshot.is_empty():
		return 0.0
	return clampf(float(_condition_provider.condition(condition_id, 0.0)), 0.0, 1.0)


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
