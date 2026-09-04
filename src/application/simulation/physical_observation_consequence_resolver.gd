class_name PhysicalObservationConsequenceResolver
extends RefCounted

const PhysicalConsequenceResolution = preload("res://src/application/simulation/physical_consequence_resolution.gd")
const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const WorldEvent = preload("res://src/domain/actions/world_event.gd")

## Converts engine facts into authoritative semantic events only through authored
## rules. First matching rule wins for one observation, preserving input order.

var _rules: Array


func _init(rules: Array) -> void:
	_rules = rules.duplicate()
	for rule in _rules:
		assert(rule != null and rule.has_method("admits"), "Physical consequence rules must implement admits()")


func resolve(observations: Array, step_id: StringName) -> Array:
	return resolve_result(observations, step_id).events


func resolve_result(observations: Array, step_id: StringName):
	assert(step_id != &"", "Physical consequence resolution requires step_id")
	var events: Array = []
	for observation_index in range(observations.size()):
		var observation = observations[observation_index]
		if observation == null:
			continue
		for rule in _rules:
			if not rule.admits(observation):
				continue
			var bindings = RoleBinding.new()
			bindings.bind(rule.subject_role, observation.subject)
			if observation.other != null:
				bindings.bind(rule.other_role, observation.other)
			var occurrence_id := StringName("physical:%s:%d" % [String(step_id), observation_index])
			events.append(WorldEvent.new(rule.event_type, null, bindings, occurrence_id))
			break
	return PhysicalConsequenceResolution.new(events)
