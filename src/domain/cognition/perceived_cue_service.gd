class_name PerceivedCueService
extends RefCounted

const EpistemicClaim = preload("res://src/domain/cognition/epistemic_claim.gd")

## Derives currently active semantic context cues from Wilson-relative perception.
## Subject-scoped evidence and event-level observations remain distinct inputs:
## ambient observations may activate context without manufacturing epistemic claims.
## Output is deterministic, deduplicated and contains no historical habit state.

var _rules: Array


func _init(rules: Array) -> void:
	_rules = rules.duplicate()
	for rule in _rules:
		assert(
			rule != null and (rule.has_method("matches") or rule.has_method("matches_observed_event")),
			"Perceived cue rules must match evidence or observed events"
		)


func derive(perception_result) -> Array[StringName]:
	assert(perception_result != null, "PerceivedCueService requires PerceptionResult")
	var seen: Dictionary = {}
	for evidence in perception_result.evidence:
		if evidence == null or evidence.claim == null:
			continue
		if evidence.claim.kind != EpistemicClaim.Kind.EVENT:
			continue
		for rule in _rules:
			if not rule.has_method("matches") or not rule.matches(evidence):
				continue
			seen[rule.cue_id] = true
	for observed_event in perception_result.observed_events:
		if observed_event == null:
			continue
		for rule in _rules:
			if not rule.has_method("matches_observed_event") or not rule.matches_observed_event(observed_event):
				continue
			seen[rule.cue_id] = true
	var result: Array[StringName] = []
	for cue_id in seen.keys():
		result.append(StringName(cue_id))
	result.sort_custom(func(a, b): return String(a) < String(b))
	return result
