class_name WorldInterventionStub
extends RefCounted

const MutationResult = preload("res://src/domain/core/mutation_result.gd")

var accept: bool
var calls: int = 0

func _init(p_accept: bool = true) -> void:
	accept = p_accept

func apply_intervention(request):
	calls += 1
	if not accept:
		return MutationResult.failure(&"world_rejected", [String(request.definition_id)])
	return MutationResult.success(&"world_committed", request.payload)
