class_name ImmediateThreatCandidateSource
extends RefCounted

const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const DecisionCandidate = preload("res://src/domain/cognition/decision_candidate.gd")

var _threat_service
var _defenses: Array
var _max_candidates: int


func _init(threat_service, defenses: Array, max_candidates: int = 12) -> void:
	assert(threat_service != null, "ImmediateThreatCandidateSource requires PerceivedThreatService")
	assert(max_candidates > 0 and max_candidates <= 64, "max_candidates must be within [1,64]")
	_threat_service = threat_service
	_defenses = defenses.duplicate()
	_max_candidates = max_candidates


func generate(perception_result) -> Array:
	var threats: Array = _threat_service.derive(perception_result)
	var result: Array = []
	for threat in threats:
		for defense in _defenses:
			if defense == null:
				continue
			var bindings = RoleBinding.new()
			bindings.bind(&"threat_source", threat.source_subject)
			result.append(DecisionCandidate.new(
				defense.intention_id,
				bindings,
				DecisionCandidate.Scope.IMMEDIATE_THREAT,
				defense.base_score,
				0.0,
				threat.confidence,
				threat.estimated_urgency,
				0.0,
				{
					"source": "perceived_threat",
					"event_type": threat.event_type.sort_key(),
					"estimated_severity": threat.estimated_severity,
					"source_execution_id": threat.source_execution_id,
				}
			))
			if result.size() >= _max_candidates:
				break
		if result.size() >= _max_candidates:
			break
	result.sort_custom(func(a, b): return a.stable_key() < b.stable_key())
	return result
