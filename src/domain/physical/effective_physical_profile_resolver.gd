class_name EffectivePhysicalProfileResolver
extends RefCounted

const EffectivePhysicalProfile = preload("res://src/domain/physical/effective_physical_profile.gd")
const PhysicalDerivationPolicyRegistry = preload("res://src/domain/physical/physical_derivation_policy_registry.gd")
const PropertyInputSelector = preload("res://src/domain/physical/property_input_selector.gd")

## Pure read-side physical resolver with discardable per-subject cache.
## Reads through WorldQuery and optional reconstructible assembly bindings.

var _world_query
var _graph
var _policies
var _assembly_bindings
var _cache: Dictionary = {}

func _init(world_query, dependency_graph, policies = null, assembly_bindings = null) -> void:
	assert(world_query != null, "EffectivePhysicalProfileResolver requires WorldQuery")
	assert(dependency_graph != null, "EffectivePhysicalProfileResolver requires PropertyDependencyGraph")
	_world_query = world_query
	_graph = dependency_graph
	_policies = policies if policies != null else PhysicalDerivationPolicyRegistry.new()
	_assembly_bindings = assembly_bindings

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
		for selector in rule.input_selectors:
			var resolved = _resolve_input(subject, profile, selector)
			if not resolved.get("present", false):
				missing_input = true
				break
			input_values.append(resolved["value"])
			input_explanations.append(resolved["explanation"])
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

func _resolve_input(subject, profile, selector) -> Dictionary:
	match selector.kind:
		PropertyInputSelector.Kind.SUBJECT_PROPERTY:
			var value = profile.get_property(selector.property_id) if profile.has_property(selector.property_id) else _world_query.get_instance_property(subject, selector.property_id)
			if value == null:
				return {"present": false}
			return {"present": true, "value": value, "explanation": {
				"selector": selector.stable_key(),
				"property": selector.property_id.sort_key(),
				"value": value,
				"source": "derived" if profile.has_property(selector.property_id) else "world_query",
			}}
		PropertyInputSelector.Kind.ASSEMBLY_SLOT_PROPERTY:
			if _assembly_bindings == null:
				return {"present": false}
			var matching: Array = []
			for binding in _assembly_bindings.bindings_for_host(subject):
				if binding.slot_id.equals(selector.slot_id):
					matching.append(binding)
			if matching.size() != 1:
				return {"present": false}
			var component = matching[0].component
			var value = _world_query.get_instance_property(component, selector.property_id)
			if value == null:
				return {"present": false}
			return {"present": true, "value": value, "explanation": {
				"selector": selector.stable_key(),
				"slot": selector.slot_id.sort_key(),
				"component": component.sort_key(),
				"property": selector.property_id.sort_key(),
				"value": value,
				"source": "assembly_component",
			}}
	return {"present": false}

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
