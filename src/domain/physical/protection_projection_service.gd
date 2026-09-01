class_name ProtectionProjectionService
extends RefCounted

const ProtectionProjection = preload("res://src/domain/physical/protection_projection.gd")

var _world_query
var _rules: Array


func _init(world_query, rules: Array) -> void:
	assert(world_query != null, "ProtectionProjectionService requires WorldQuery")
	_world_query = world_query
	_rules = rules.duplicate()


func derive_for_target(target, exposure_kind: StringName) -> Array:
	assert(target != null, "derive_for_target requires target")
	assert(exposure_kind != &"", "derive_for_target requires exposure kind")
	var result: Array = []
	for rule in _rules:
		if rule == null or rule.exposure_kind != exposure_kind:
			continue
		for relation in _world_query.find_relations(rule.relation_type, null, target):
			var coverage_value = _world_query.get_instance_property(relation.subject, rule.coverage_property)
			var strength_value = _world_query.get_instance_property(relation.subject, rule.strength_property)
			if not _unit_numeric(coverage_value) or not _unit_numeric(strength_value):
				continue
			result.append(ProtectionProjection.new(
				relation.subject,
				target,
				exposure_kind,
				float(coverage_value),
				float(strength_value),
				{"rule_id": rule.id, "relation_key": relation.key()}
			))
	result.sort_custom(func(a, b): return a.stable_key() < b.stable_key())
	return result


func _unit_numeric(value: Variant) -> bool:
	return (value is int or value is float) and is_finite(float(value)) and float(value) >= 0.0 and float(value) <= 1.0
