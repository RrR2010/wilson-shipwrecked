class_name ProjectContributionService
extends RefCounted

var _store
var _definitions_by_key: Dictionary = {}


func _init(store, definitions: Array) -> void:
	assert(store != null, "ProjectContributionService requires ProjectStore")
	_store = store
	for definition in definitions:
		assert(definition != null, "Project definitions cannot contain null")
		_definitions_by_key[definition.id.key()] = definition


func apply_grounded(outcome, world_commit_result) -> Dictionary:
	if outcome == null or world_commit_result == null or not world_commit_result.ok:
		return {"applied": [], "diagnostics": ["No successful grounded outcome"]}
	var applied: Array = []
	var diagnostics: Array[String] = []
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
		if _store.apply_contribution(instance.id, definition.required_contributions):
			applied.append(instance.id)
			diagnostics.append("Applied grounded contribution to %s" % instance.id.sort_key())
	return {"applied": applied, "diagnostics": diagnostics}
