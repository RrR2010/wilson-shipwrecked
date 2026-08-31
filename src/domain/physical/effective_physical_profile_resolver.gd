class_name EffectivePhysicalProfileResolver
extends RefCounted

const EffectivePhysicalProfile = preload("res://src/domain/physical/effective_physical_profile.gd")
const PhysicalDerivationPolicyRegistry = preload("res://src/domain/physical/physical_derivation_policy_registry.gd")

## Pure read-side physical resolver with discardable per-subject cache.
## Reads through WorldQuery and never mutates authoritative World state.

var _world_query
var _graph
var _policies
var _cache: Dictionary = {}


func _init(world_query, dependency_graph, policies = null) -> void:
	assert(world_query != null, "EffectivePhysicalProfileResolver requires WorldQuery")
	assert(dependency_graph != null, "EffectivePhysicalProfileResolver requires PropertyDependencyGraph")
	_world_query = world_query
	_graph = dependency_graph
	_policies = policies if policies != null else PhysicalDerivationPolicyRegistry.new()


func resolve(subject):
	assert(subject != null, "resolve requires subject")
	var subject_key = subject.key()
	if _cache.has(subject_key):
		return _cache[subject_key]

	var profile = EffectivePhysicalProfile.new(subject)
	for output_property in _graph.topological_outputs():
		var rule = _graph.rule_for_output(output_property)
		assert(_policies.supports(rule.policy_id), "Unsupported derivation policy: %s" % String(rule.policy_id))
		var input_values: Array = []
		var input_explanations: Array = []
		var missing_input := false
		for input_property in rule.input_properties:
			var value: Variant
			var source: StringName
			if profile.has_property(input_property):
				value = profile.get_property(input_property)
				source = &"derived"
			else:
				value = _world_query.get_instance_property(subject, input_property)
				source = &"world_query"
			if value == null:
				missing_input = true
				break
			input_values.append(value)
			input_explanations.append({
				"property": input_property.sort_key(),
				"value": value,
				"source": String(source),
			})
		if missing_input:
			continue
		var output_value = _policies.evaluate(rule.policy_id, input_values)
		profile.set_property(output_property, output_value, {
			"kind": "derived_property",
			"rule_id": String(rule.id),
			"policy_id": String(rule.policy_id),
			"inputs": input_explanations,
		})

	_cache[subject_key] = profile
	return profile


func invalidate(subject, changed_property = null) -> Array:
	assert(subject != null, "invalidate requires subject")
	_cache.erase(subject.key())
	if changed_property == null:
		return []
	return _graph.affected_outputs(changed_property)


func clear_cache() -> void:
	_cache.clear()


func cached_subject_count() -> int:
	return _cache.size()
