class_name ShallowActorMotionCoordinator
extends RefCounted

const MotionPort = preload("res://src/application/simulation/motion_port.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")

## Coordinates an authored shallow-actor destination with engine locomotion.
##
## Actor behavior remains domain-owned. Fine movement remains MotionPort/Godot-owned.
## EntityStore place truth is committed only after the matching actor reaches the
## authored place target. This coordinator does not add Wilson-style cognition to
## non-Wilson actors and does not own relationship state.

var _motion
var _entities
var _pending_by_actor_key: Dictionary = {}


func _init(motion_port, entity_store) -> void:
	assert(motion_port != null, "ShallowActorMotionCoordinator requires MotionPort")
	assert(entity_store != null, "ShallowActorMotionCoordinator requires EntityStore")
	_motion = motion_port
	_entities = entity_store


func request(decision: Dictionary) -> bool:
	var actor = decision.get("actor")
	var destination_place = decision.get("destination_place")
	if actor == null or destination_place == null:
		return false
	if actor.kind != RuntimeWorldRef.Kind.ENTITY:
		return false
	var key: String = actor.sort_key()
	if _pending_by_actor_key.has(key):
		return false
	var target_ref = RuntimeWorldRef.place(destination_place)
	if not _motion.request_move(actor, target_ref):
		return false
	_pending_by_actor_key[key] = {
		"actor": actor,
		"destination_place": destination_place,
		"target_ref": target_ref,
		"rule_id": decision.get("rule_id", &""),
	}
	return true


func reconcile() -> Dictionary:
	var arrived: Array = []
	var failed: Array = []
	var diagnostics: Array[String] = []
	var keys: Array = _pending_by_actor_key.keys()
	keys.sort_custom(func(a, b): return String(a) < String(b))
	for raw_key in keys:
		var key: String = String(raw_key)
		var pending: Dictionary = _pending_by_actor_key[key]
		var actor = pending.actor
		var status: int = _motion.get_status(actor)
		if status == MotionPort.MotionStatus.MOVING or status == MotionPort.MotionStatus.IDLE:
			continue
		if status == MotionPort.MotionStatus.ARRIVED:
			var mutation = _entities.set_place(actor.id, pending.destination_place)
			if mutation.ok:
				arrived.append(pending.duplicate())
			else:
				diagnostics.append("Actor arrival place commit failed for %s" % key)
				failed.append(pending.duplicate())
		else:
			failed.append(pending.duplicate())
			diagnostics.append("Actor motion ended without arrival for %s status=%d" % [key, status])
		_pending_by_actor_key.erase(key)
	return {
		"arrived": arrived,
		"failed": failed,
		"diagnostics": diagnostics,
	}


func has_pending(actor) -> bool:
	return actor != null and _pending_by_actor_key.has(actor.sort_key())


func pending_count() -> int:
	return _pending_by_actor_key.size()
