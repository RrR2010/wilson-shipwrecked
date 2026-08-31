class_name PropertyDerivationDefinition
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")
const PropertyInputSelector = preload("res://src/domain/physical/property_input_selector.gd")

## Declarative derived-property rule.
## Inputs may read the current subject or one bounded assembly slot.

var id: StringName
var input_selectors: Array
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
	input_selectors = []
	input_properties = []
	for input in p_inputs:
		assert(input != null, "Derivation inputs cannot be null")
		var selector = input
		if input is Object and input.has_method("assert_kind"):
			input.assert_kind(DomainId.Kind.PROPERTY)
			selector = PropertyInputSelector.subject_property(input)
		input_selectors.append(selector)
		if selector.kind == PropertyInputSelector.Kind.SUBJECT_PROPERTY:
			input_properties.append(selector.property_id)

func sort_key() -> String:
	return String(id)
