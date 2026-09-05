class_name GroundedDeathLifecycleCoordinator
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")
const MutationResult = preload("res://src/domain/core/mutation_result.gd")
const RunLifecycleState = preload("res://src/application/lifecycle/run_lifecycle_state.gd")

## Cross-owner admission boundary for a death fact that World has already
## committed. This coordinator never inspects Godot callbacks or body vitality.

var _run_state
var _wilson_ref
var _death_event_type
var _subject_role: StringName
var _death_cause: StringName


func _init(
	p_run_state,
	p_wilson_ref,
	p_death_event_type,
	p_subject_role: StringName = &"subject",
	p_death_cause: StringName = &""
) -> void:
	assert(p_run_state != null and p_run_state.has_method("mark_dead"), "Grounded death coordinator requires RunLifecycleState")
	assert(p_wilson_ref != null, "Grounded death coordinator requires Wilson RuntimeWorldRef")
	assert(p_death_event_type != null, "Grounded death coordinator requires death EventDefinitionId")
	p_death_event_type.assert_kind(DomainId.Kind.EVENT_DEFINITION)
	assert(p_subject_role != &"", "Grounded death coordinator requires subject role")
	_run_state = p_run_state
	_wilson_ref = p_wilson_ref
	_death_event_type = p_death_event_type
	_subject_role = p_subject_role
	_death_cause = p_death_cause if p_death_cause != &"" else StringName(p_death_event_type.value)


func process(committed_events: Array):
	for event in committed_events:
		if not _is_grounded_wilson_death(event):
			continue
		if _run_state.lifecycle == RunLifecycleState.Lifecycle.DEAD:
			return MutationResult.success(&"grounded_death_already_admitted")
		if _run_state.lifecycle != RunLifecycleState.Lifecycle.ACTIVE:
			return MutationResult.success(&"grounded_death_run_not_active")
		return _run_state.mark_dead(_death_cause)
	return MutationResult.success(&"no_grounded_death")


func _is_grounded_wilson_death(event) -> bool:
	if event == null or event.event_type == null or not event.event_type.equals(_death_event_type):
		return false
	if event.bindings == null or not event.bindings.has_role(_subject_role):
		return false
	var subject = event.bindings.get_subject(_subject_role)
	return subject != null and subject.equals(_wilson_ref)
