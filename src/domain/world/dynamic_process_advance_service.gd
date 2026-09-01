class_name DynamicProcessAdvanceService
extends RefCounted

const DynamicProcessInstance = preload("res://src/domain/world/dynamic_process_instance.gd")
const SemanticChange = preload("res://src/domain/world/semantic_change.gd")
const SemanticChangeSet = preload("res://src/domain/world/semantic_change_set.gd")

var _store
var _definitions: Dictionary = {}
var _world_query
var _entities


func _init(store, definitions: Array, world_query, entity_store) -> void:
	assert(store != null, "DynamicProcessAdvanceService requires store")
	assert(world_query != null, "DynamicProcessAdvanceService requires WorldQuery")
	assert(entity_store != null, "DynamicProcessAdvanceService requires EntityStore")
	_store = store
	_world_query = world_query
	_entities = entity_store
	for definition in definitions:
		assert(definition != null, "Dynamic process definitions cannot contain null")
		assert(not _definitions.has(definition.id), "Duplicate dynamic process definition: %s" % String(definition.id))
		_definitions[definition.id] = definition


func advance(elapsed: float) -> Dictionary:
	assert(is_finite(elapsed) and elapsed >= 0.0, "Dynamic process elapsed must be finite and non-negative")
	var change_set = SemanticChangeSet.new()
	var progressed: Array[StringName] = []
	var completed: Array[StringName] = []
	var diagnostics: Array[String] = []
	if elapsed <= 0.0:
		return _result(change_set, progressed, completed, diagnostics)
	for instance in _store.instances():
		if not instance.is_active():
			continue
		var definition = _definitions.get(instance.definition_id)
		if definition == null:
			diagnostics.append("Missing dynamic process definition: %s" % String(instance.definition_id))
			continue
		var current_value = _world_query.get_instance_property(instance.subject, definition.target_property)
		if current_value == null or not (current_value is int or current_value is float):
			diagnostics.append("Dynamic process target property is missing/non-numeric: %s" % definition.target_property.sort_key())
			continue
		var current: float = float(current_value)
		if not is_finite(current):
			diagnostics.append("Dynamic process target property is non-finite: %s" % definition.target_property.sort_key())
			continue
		var next_value: float = clampf(current + definition.rate_per_second * elapsed, definition.lower_bound, definition.upper_bound)
		if not is_equal_approx(next_value, current):
			if _world_query.has_method("validate_property_value") and not _world_query.validate_property_value(definition.target_property, next_value):
				diagnostics.append("Dynamic process produced invalid property value: %s" % definition.target_property.sort_key())
				continue
			var mutation = _entities.set_property_override(instance.subject.id, definition.target_property, next_value)
			if not mutation.ok:
				diagnostics.append("Dynamic process mutation failed: %s" % String(mutation.code))
				continue
			change_set.add(SemanticChange.property_change(instance.subject, definition.target_property))
			progressed.append(instance.id)
		instance.elapsed += elapsed
		if is_equal_approx(next_value, definition.terminal_value()):
			_store.set_lifecycle(instance.id, DynamicProcessInstance.Lifecycle.COMPLETED)
			completed.append(instance.id)
	return _result(change_set, progressed, completed, diagnostics)


func _result(change_set, progressed: Array[StringName], completed: Array[StringName], diagnostics: Array[String]) -> Dictionary:
	return {
		"change_set": change_set,
		"progressed": progressed,
		"completed": completed,
		"diagnostics": diagnostics,
	}
