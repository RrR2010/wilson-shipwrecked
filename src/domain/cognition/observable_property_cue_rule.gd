class_name ObservablePropertyCueRule
extends RefCounted

const EpistemicClaim = preload("res://src/domain/cognition/epistemic_claim.gd")

## Applies only to current perceptual evidence; a durable belief alone is not
## evidence that the ambient condition is still active.
var property_id
var expected_value: Variant
var cue_id: StringName


func _init(p_property_id, p_expected_value: Variant, p_cue_id: StringName) -> void:
	property_id = p_property_id
	expected_value = p_expected_value
	cue_id = p_cue_id


func matches(evidence) -> bool:
	return evidence != null and evidence.claim != null \
		and evidence.claim.kind == EpistemicClaim.Kind.PROPERTY \
		and evidence.claim.semantic_id.equals(property_id) \
		and evidence.claim.value == expected_value \
		and evidence.modality == &"ambient"
