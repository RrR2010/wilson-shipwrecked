class_name ProjectContributionService
extends RefCounted

var _store
var _world_query
var _definitions_by_key: Dictionary = {}


func _init(store, definitions: Array, world_query = null) -> void:
	assert(store != null, "ProjectContributionService requires ProjectStore")
	_store = store
	_world_query = world_query
	for definition in definitions:
		assert(definition != null, "Project definitions cannot contain null")
		_definitions_by_key[definition.id.key()] = definition


func reconcile() -> Dictionary:
	var applied: Array = []
	for instance in _store.instances():
		var definition = _definitions_by_key.get(instance.definition_id.key())
		if definition == null or definition.receipt_relation_type == null or _world_query == null:
			continue
		if not instance.subject_bindings.has(definition.project_subject_role):
			continue
		var subject = instance.subject_bindings.get_subject(definition.project_subject_role)
		var receipts = _world_query.find_relations(definition.receipt_relation_type, subject, subject)
		if _store.reconcile_receipt_count(instance.id, receipts.size(), definition.required_contributions):
			applied.append(instance.id)
	return {"applied": applied, "diagnostics": []}


func apply_grounded(outcome, world_commit_result) -> Dictionary:
	if outcome == null or world_commit_result == null or not world_commit_result.ok:
		return {"applied": [], "diagnostics": ["No successful grounded outcome"]}
	var applied: Array = []
	var diagnostics: Array[String] = []
	# Receipt-backed projects are reconciled from durable World truth, even after missed delivery.
	var reconciled = reconcile()
	applied.append_array(reconciled.get("applied", []))
	for instance in _store.instances():
		if not instance.is_active():
			continue
		var definition = _definitions_by_key.get(instance.definition_id.key())
		if definition == null:
			diagnostics.append("Missing definition for %s" % instance.definition_id.sort_key())
			continue
		if not outcome.action_id.equals(definition.contribution_action_id):
			continue
		if not outcome.event_type.equals(definition.contribution_event_type):
			continue
		if not instance.subject_bindings.has(definition.project_subject_role):
			continue
		if not outcome.bindings.has(definition.action_subject_role):
			continue
		var project_subject = instance.subject_bindings.get_subject(definition.project_subject_role)
		var action_subject = outcome.bindings.get_subject(definition.action_subject_role)
		if project_subject.sort_key() != action_subject.sort_key():
			continue
		if definition.receipt_relation_type != null:
			continue
		if _store.apply_contribution(instance.id, definition.required_contributions):
			applied.append(instance.id)
			diagnostics.append("Applied grounded contribution to %s" % instance.id.sort_key())
	return {"applied": applied, "diagnostics": diagnostics}
