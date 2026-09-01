class_name ShallowActorAdvanceService
extends RefCounted

var _store
var _profiles: Dictionary = {}
var _rules: Array
var _entities


func _init(store, profiles: Array, rules: Array, entity_store) -> void:
	assert(store != null, "ShallowActorAdvanceService requires ActorStateStore")
	assert(entity_store != null, "ShallowActorAdvanceService requires EntityStore")
	_store = store
	_entities = entity_store
	_rules = rules.duplicate()
	for profile in profiles:
		assert(profile != null, "Actor profiles cannot contain null")
		assert(not _profiles.has(profile.id), "Duplicate actor profile: %s" % String(profile.id))
		_profiles[profile.id] = profile


func advance(elapsed: float, stimuli_by_actor: Dictionary = {}) -> Dictionary:
	assert(is_finite(elapsed) and elapsed >= 0.0, "Actor elapsed must be finite and non-negative")
	var decisions: Array = []
	var moved: Array = []
	var diagnostics: Array[String] = []
	for state in _store.states():
		var profile = _profiles.get(state.profile_id)
		if profile == null:
			diagnostics.append("Missing actor profile: %s" % String(state.profile_id))
			continue
		state.decision_cooldown = maxf(0.0, state.decision_cooldown - elapsed)
		if state.decision_cooldown > 0.0:
			continue
		var stimuli: Array[StringName] = []
		for stimulus in stimuli_by_actor.get(state.actor.sort_key(), []):
			stimuli.append(StringName(stimulus))
		var selected = _select_rule(state, stimuli)
		state.decision_cooldown = profile.decision_interval
		if selected == null:
			continue
		state.mode = selected.next_mode
		state.last_rule_id = selected.id
		var record: Dictionary = {
			"actor": state.actor,
			"rule_id": selected.id,
			"mode": state.mode,
		}
		if selected.destination_place != null:
			var mutation = _entities.set_place(state.actor.id, selected.destination_place)
			if mutation.ok:
				moved.append(state.actor)
				record["destination_place"] = selected.destination_place
			else:
				diagnostics.append("Actor movement failed for %s" % state.actor.sort_key())
		decisions.append(record)
	return {
		"decisions": decisions,
		"moved": moved,
		"diagnostics": diagnostics,
	}


func _select_rule(state, stimuli: Array[StringName]):
	var matches: Array = []
	for rule in _rules:
		if rule != null and rule.matches(state, stimuli):
			matches.append(rule)
	if matches.is_empty():
		return null
	matches.sort_custom(func(a, b):
		if not is_equal_approx(a.priority, b.priority):
			return a.priority > b.priority
		return String(a.id) < String(b.id)
	)
	return matches[0]
