class_name PropertyDerivationDefinition
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")

## Declarative derived-property rule.
## policy_id selects a bounded registered physical policy; no arbitrary callback is stored here.

var id: StringName
var input_properties: Array
var output_property
var policy_id: StringName


func _init(p_id: StringName, p_inputs: Array, p_output, p_policy_id: StringName) -> void:
	assert(p_id != &"", "PropertyDerivationDefinition id cannot be empty")
	assert(p_output != null, "PropertyDerivationDefinition requires output PropertyId")
	p_output.assert_kind(DomainId.Kind.PROPERTY)
	assert(p_policy_id != &"", "PropertyDerivationDefinition policy_id cannot be empty")
	id = p_id
	output_property = p_output
	policy_id = p_policy_id
	input_properties = []
	for property_id in p_inputs:
		assert(property_id != null, "Derivation inputs cannot be null")
		property_id.assert_kind(DomainId.Kind.PROPERTY)
		input_properties.append(property_id)


func sort_key() -> String:
	return String(id)
