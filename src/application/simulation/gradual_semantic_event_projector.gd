class_name GradualSemanticEventProjector
extends RefCounted

const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const WorldEvent = preload("res://src/domain/actions/world_event.gd")

var _rules: Array = []


func _init(rules: Array) -> void:
	var seen_ids: Dictionary = {}
	for rule in rules:
		assert(rule != null and rule.has_method("matches_transition"), "Gradual semantic projector rules must implement matches_transition")
		assert(not seen_ids.has(rule.id), "Duplicate gradual semantic boundary rule: %s" % String(rule.id))
		seen_ids[rule.id] = true
		_rules.append(rule)
	_rules.sort_custom(func(a, b): return String(a.id) < String(b.id))


func project(transitions: Array, step_id: StringName) -> Array:
	assert(step_id != &"", "Gradual semantic event projection requires step id")
	var events: Array = []
	var emitted: Dictionary = {}
	for transition in transitions:
		if not (transition is Dictionary) or not transition.has("subject"):
			continue
		var subject = transition["subject"]
		if subject == null or not subject.has_method("sort_key"):
			continue
		for rule in _rules:
			if not rule.matches_transition(transition):
				continue
			var emission_key := "%s|%s" % [String(rule.id), subject.sort_key()]
			if emitted.has(emission_key):
				continue
			emitted[emission_key] = true
			var bindings = RoleBinding.new()
			bindings.bind(rule.subject_role, subject)
			var occurrence_id := StringName("gradual:%s:%s:%s" % [String(step_id), String(rule.id), subject.sort_key()])
			events.append(WorldEvent.new(rule.event_type, null, bindings, occurrence_id))
	events.sort_custom(func(a, b): return String(a.execution_id) < String(b.execution_id))
	return events
