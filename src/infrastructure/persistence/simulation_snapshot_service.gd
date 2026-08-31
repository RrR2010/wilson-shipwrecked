class_name SimulationSnapshotService
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const EntityInstance = preload("res://src/domain/world/entity_instance.gd")
const EntityStore = preload("res://src/domain/world/entity_store.gd")
const WorldRelation = preload("res://src/domain/world/world_relation.gd")
const WorldRelationStore = preload("res://src/domain/world/world_relation_store.gd")
const BeliefProposition = preload("res://src/domain/cognition/belief_proposition.gd")
const BeliefStore = preload("res://src/domain/cognition/belief_store.gd")
const CurrentIntentionStore = preload("res://src/domain/cognition/current_intention_store.gd")
const EpistemicGraphProjection = preload("res://src/domain/cognition/epistemic_graph_projection.gd")
const DomainValueCodec = preload("res://src/infrastructure/persistence/domain_value_codec.gd")
const RestoredSimulationState = preload("res://src/infrastructure/persistence/restored_simulation_state.gd")

const SCHEMA_VERSION := 1

var _codec


func _init(codec = null) -> void:
	_codec = codec if codec != null else DomainValueCodec.new()


func capture(entity_store, relation_store, belief_store, intention_store) -> Dictionary:
	assert(entity_store != null, "capture requires EntityStore")
	assert(relation_store != null, "capture requires WorldRelationStore")
	assert(belief_store != null, "capture requires BeliefStore")
	assert(intention_store != null, "capture requires CurrentIntentionStore")
	return {
		"schema_version": SCHEMA_VERSION,
		"entities": _capture_entities(entity_store),
		"relations": _capture_relations(relation_store),
		"beliefs": _capture_beliefs(belief_store),
		"current_intention": _capture_intention(intention_store),
	}


func restore(snapshot: Dictionary):
	assert(int(snapshot.get("schema_version", -1)) == SCHEMA_VERSION, "Unsupported simulation snapshot schema")
	var entities = EntityStore.new()
	for record in snapshot.get("entities", []):
		var entity = EntityInstance.new(
			_codec.decode(record["id"]),
			_codec.decode(record["type_id"]),
			_codec.decode(record["place_id"]),
			_codec.decode(record["state_overrides"]),
			_codec.decode(record["quantity"])
		)
		entity.lifecycle = int(record["lifecycle"])
		var add_result = entities.add_entity(entity)
		assert(add_result.ok, "Failed to restore entity: %s" % str(add_result.diagnostics))

	var relations = WorldRelationStore.new()
	for record in snapshot.get("relations", []):
		var relation = WorldRelation.new(
			_codec.decode(record["relation_type"]),
			_codec.decode(record["subject"]),
			_codec.decode(record["object"]),
			_codec.decode(record["qualifier"])
		)
		var relation_result = relations.add_relation(relation)
		assert(relation_result.ok, "Failed to restore relation: %s" % str(relation_result.diagnostics))
	# Deliberately rebuild reconstructible indexes after authority is restored.
	relations.rebuild_indexes()
	assert(relations.validate_indexes().ok, "Restored relation indexes invalid")

	var beliefs = BeliefStore.new()
	for record in snapshot.get("beliefs", []):
		var proposition = BeliefProposition.new(
			StringName(record["predicate"]),
			_codec.decode(record["arguments"])
		)
		var belief_result = beliefs.restore_entry(
			proposition,
			float(record["confidence"]),
			int(record["evidence_count"]),
			StringName(record.get("last_source_execution_id", "")),
			StringName(record.get("last_modality", ""))
		)
		assert(belief_result.ok, "Failed to restore belief: %s" % str(belief_result.diagnostics))

	var intention_store = CurrentIntentionStore.new()
	var intention_record = snapshot.get("current_intention")
	if intention_record != null:
		var bindings = _decode_binding(intention_record["bindings"])
		var intention_result = intention_store.select(
			_codec.decode(intention_record["intention_id"]),
			bindings,
			StringName(intention_record["selected_step_id"])
		)
		assert(intention_result.ok, "Failed to restore current intention")

	var epistemic_projection = EpistemicGraphProjection.new()
	epistemic_projection.rebuild(beliefs)
	return RestoredSimulationState.new(entities, relations, beliefs, intention_store, epistemic_projection)


func _capture_entities(entity_store) -> Array:
	var result: Array = []
	for entity in entity_store.entities():
		result.append({
			"id": _codec.encode(entity.id),
			"type_id": _codec.encode(entity.type_id),
			"place_id": _codec.encode(entity.place_id),
			"lifecycle": entity.lifecycle,
			"quantity": _codec.encode(entity.quantity),
			"state_overrides": _codec.encode(entity.state_overrides()),
		})
	return result


func _capture_relations(relation_store) -> Array:
	var result: Array = []
	for relation in relation_store.relations():
		result.append({
			"relation_type": _codec.encode(relation.relation_type),
			"subject": _codec.encode(relation.subject),
			"object": _codec.encode(relation.object),
			"qualifier": _codec.encode(relation.qualifier),
		})
	return result


func _capture_beliefs(belief_store) -> Array:
	var result: Array = []
	for entry in belief_store.entries():
		result.append({
			"predicate": String(entry.proposition.predicate),
			"arguments": _codec.encode(entry.proposition.arguments),
			"confidence": entry.confidence,
			"evidence_count": entry.evidence_count,
			"last_source_execution_id": String(entry.last_source_execution_id),
			"last_modality": String(entry.last_modality),
		})
	return result


func _capture_intention(intention_store):
	if not intention_store.has_current():
		return null
	var current = intention_store.current()
	return {
		"intention_id": _codec.encode(current.intention_id),
		"bindings": _encode_binding(current.bindings),
		"selected_step_id": String(current.selected_step_id),
	}


func _encode_binding(binding) -> Array:
	var result: Array = []
	for role_name in binding.role_names():
		result.append({
			"role": String(role_name),
			"subject": _codec.encode(binding.get_subject(role_name)),
		})
	return result


func _decode_binding(records: Array):
	var binding = RoleBinding.new()
	for record in records:
		binding.bind(StringName(record["role"]), _codec.decode(record["subject"]))
	return binding
