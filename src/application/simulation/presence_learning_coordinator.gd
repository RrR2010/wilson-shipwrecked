class_name PresenceLearningCoordinator
extends RefCounted

var _learner
var _presence


func _init(learner, presence) -> void:
	assert(learner != null, "PresenceLearningCoordinator requires learner")
	assert(presence != null, "PresenceLearningCoordinator requires PresenceRelationship")
	_learner = learner
	_presence = presence


func process(attribution_evidence) -> Dictionary:
	assert(attribution_evidence != null, "Presence learning requires attribution evidence")
	var evidence = _learner.derive(attribution_evidence)
	_presence.apply_evidence(evidence)
	return {"evidence": evidence, "applied": true}
