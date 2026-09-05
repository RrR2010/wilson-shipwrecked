class_name WilsonBodyImpactConsequenceResolver
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")
const PhysicalConsequenceResolution = preload("res://src/application/simulation/physical_consequence_resolution.gd")
const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const WorldEvent = preload("res://src/domain/actions/world_event.gd")
const SemanticChange = preload("res://src/domain/world/semantic_change.gd")
const SemanticChangeSet = preload("res://src/domain/world/semantic_change_set.gd")

## Grounds selected physical observations into Wilson body truth. The body mutation
## commits first; only then are SemanticChange and injury/death WorldEvent emitted.

var _wilson_ref
var _body_state
var _vitality_property_id
var _rules: Array


func _init(wilson_ref, body_state, vitality_property_id, rules: Array) -> void:
	assert(wilson_ref != null, "Wilson body consequence resolver requires Wilson RuntimeWorldRef")
	assert(body_state != null and body_state.has_method("apply_damage"), "Wilson body consequence resolver requires body state")
	assert(vitality_property_id != null, "Wilson body consequence resolver requires vitality PropertyId")
	vitality_property_id.assert_kind(DomainId.Kind.PROPERTY)
	_wilson_ref = wilson_ref
	_body_state = body_state
	_vitality_property_id = vitality_property_id
	_rules = rules.duplicate()
	for rule in _rules:
		assert(rule != null and rule.has_method("admits"), "Wilson body impact rules must implement admits()")


func resolve(observations: Array, step_id: StringName) -> Array:
	return resolve_result(observations, step_id).events


func resolve_result(observations: Array, step_id: StringName):
	assert(step_id != &"", "Wilson body consequence resolution requires step_id")
	var events: Array = []
	var changes = SemanticChangeSet.new()
	var diagnostics: Array[String] = []

	for observation_index in range(observations.size()):
		var observation = observations[observation_index]
		if observation == null or observation.subject == null:
			continue
		if not observation.subject.equals(_wilson_ref):
			continue
		for rule in _rules:
			if not rule.admits(observation):
				continue
			var mutation = _body_state.apply_damage(rule.damage_fraction)
			if mutation == null or not mutation.ok:
				diagnostics.append("Wilson body impact rejected at observation %d" % observation_index)
				break

			changes.add(SemanticChange.property_change(_wilson_ref, _vitality_property_id))
			var bindings = RoleBinding.new()
			bindings.bind(&"subject", observation.subject)
			if observation.other != null:
				bindings.bind(&"other", observation.other)
			var event_type = rule.death_event_type if bool(mutation.value.get("died", false)) else rule.injury_event_type
			var occurrence_id := StringName("physical_body:%s:%d" % [String(step_id), observation_index])
			events.append(WorldEvent.new(event_type, null, bindings, occurrence_id))
			break

	return PhysicalConsequenceResolution.new(events, changes, diagnostics)
