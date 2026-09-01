class_name HazardProjectionService
extends RefCounted

const DynamicProcessInstance = preload("res://src/domain/world/dynamic_process_instance.gd")
const HazardProjection = preload("res://src/domain/world/hazard_projection.gd")

var _process_store
var _world_query
var _rules: Dictionary = {}


func _init(process_store, world_query, rules: Array) -> void:
	assert(process_store != null and world_query != null, "HazardProjectionService requires process store and WorldQuery")
	_process_store = process_store
	_world_query = world_query
	for rule in rules:
		assert(rule != null, "Hazard rules cannot contain null")
		assert(not _rules.has(rule.process_definition_id), "Duplicate hazard rule for process definition")
		_rules[rule.process_definition_id] = rule


func derive() -> Array:
	var result: Array = []
	for process in _process_store.instances():
		if process.lifecycle != DynamicProcessInstance.Lifecycle.ACTIVE:
			continue
		var rule = _rules.get(process.definition_id)
		if rule == null:
			continue
		var place = _world_query.get_runtime_place(process.subject)
		if place == null:
			continue
		result.append(HazardProjection.new(
			process.id,
			process.subject,
			place,
			rule.severity,
			rule.urgency,
			rule.horizon,
			{"rule_id": rule.id, "process_definition_id": process.definition_id}
		))
	result.sort_custom(func(a, b): return a.stable_key() < b.stable_key())
	return result
