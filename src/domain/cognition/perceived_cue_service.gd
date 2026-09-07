class_name PerceivedCueService
extends RefCounted

const EpistemicClaim = preload("res://src/domain/cognition/epistemic_claim.gd")

## Derives the currently active semantic context cues from Wilson-relative
## PerceptionResult evidence. Output is deterministic, deduplicated and contains
## no historical habit state.

var _rules: Array


func _init(rules: Array) -> void:
	_rules = rules.duplicate()


func derive(perception_result) -> Array[StringName]:
	assert(perception_result != null, "PerceivedCueService requires PerceptionResult")
	var seen: Dictionary = {}
	for evidence in perception_result.evidence:
		if evidence == null or evidence.claim == null:
			continue
		if evidence.claim.kind != EpistemicClaim.Kind.EVENT:
			continue
		for rule in _rules:
			if rule == null or not rule.matches(evidence):
				continue
			seen[rule.cue_id] = true
	var result: Array[StringName] = []
	for cue_id in seen.keys():
		result.append(StringName(cue_id))
	result.sort_custom(func(a, b): return String(a) < String(b))
	return result
