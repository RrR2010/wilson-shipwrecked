extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const ActionEffect = preload("res://src/domain/actions/action_effect.gd")
const ActionOutcome = preload("res://src/domain/actions/action_outcome.gd")
const EntityInstance = preload("res://src/domain/world/entity_instance.gd")
const EntityStore = preload("res://src/domain/world/entity_store.gd")
const WorldRelationStore = preload("res://src/domain/world/world_relation_store.gd")
const DefaultWorldCommandPort = preload("res://src/domain/world/default_world_command_port.gd")
const ProjectDefinition = preload("res://src/domain/projects/project_definition.gd")
const ProjectInstance = preload("res://src/domain/projects/project_instance.gd")
const ProjectStore = preload("res://src/domain/projects/project_store.gd")
const ProjectContributionService = preload("res://src/domain/projects/project_contribution_service.gd")
const ProjectCandidateSource = preload("res://src/domain/projects/project_candidate_source.gd")

var _failures: Array[String] = []
var _completed := false


func _init() -> void:
	_run_slice()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS project_runtime_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL project_runtime_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	var shelter_id = DomainId.entity(&"shelter_1")
	var shelter_type = DomainId.entity_type(&"small_shelter")
	var camp = DomainId.place(&"camp")
	var integrity = DomainId.property(&"structural_integrity")
	var contribute_action = DomainId.action(&"attach_shelter_material")
	var contribution_event = DomainId.event_definition(&"shelter_material_attached")
	var continue_intention = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"continue_shelter_project")
	var project_definition_id = DomainId.new(DomainId.Kind.PROJECT_DEFINITION, &"small_shelter")
	var project_instance_id = DomainId.new(DomainId.Kind.PROJECT_INSTANCE, &"small_shelter_1")
	var shelter = RuntimeWorldRef.entity(shelter_id)

	var project_binding = RoleBinding.new()
	project_binding.bind(&"project_subject", shelter)
	var definition = ProjectDefinition.new(
		project_definition_id,
		contribute_action,
		contribution_event,
		&"project_subject",
		&"target",
		continue_intention,
		2,
		0.35
	)
	var instance = ProjectInstance.new(project_instance_id, project_definition_id, project_binding)
	var store = ProjectStore.new()
	_expect_true(store.add(instance), "project owner accepts unique instance")
	var progression = ProjectContributionService.new(store, [definition])
	var candidates = ProjectCandidateSource.new(store, [definition])
	_expect_equal(candidates.generate().size(), 1, "active project produces one candidate")
	_expect_equal(candidates.generate()[0].provenance["source"], "project", "candidate exposes project provenance")

	var entities = EntityStore.new()
	_expect_true(entities.add_entity(EntityInstance.new(shelter_id, shelter_type, camp)).ok, "shelter physical entity added")
	var world_commands = DefaultWorldCommandPort.new(entities, WorldRelationStore.new())
	var action_binding = RoleBinding.new()
	action_binding.bind(&"target", shelter)
	var outcome = ActionOutcome.new(
		&"exec_project_1",
		contribute_action,
		action_binding,
		[ActionEffect.new(ActionEffect.Kind.SET_PROPERTY, &"target", integrity, 1)],
		contribution_event
	)

	var rejected = progression.apply_grounded(outcome, null)
	_expect_equal(rejected["applied"].size(), 0, "uncommitted outcome cannot advance project")
	_expect_equal(instance.contribution_count, 0, "project remains unchanged before World commit")

	var first_commit = world_commands.apply_outcome(outcome)
	_expect_true(first_commit.ok, "first physical contribution commits through World")
	var first_progress = progression.apply_grounded(outcome, first_commit)
	_expect_equal(first_progress["applied"].size(), 1, "grounded outcome advances matching project")
	_expect_equal(instance.contribution_count, 1, "project stores bounded semantic contribution count")
	_expect_equal(instance.lifecycle, ProjectInstance.Lifecycle.ACTIVE, "project remains active before completion condition")
	_expect_equal(candidates.generate().size(), 1, "incomplete project remains a candidate source")

	var second_commit = world_commands.apply_outcome(outcome)
	_expect_true(second_commit.ok, "second physical contribution commits through World")
	progression.apply_grounded(outcome, second_commit)
	_expect_equal(instance.contribution_count, 2, "second grounded contribution reaches completion condition")
	_expect_equal(instance.lifecycle, ProjectInstance.Lifecycle.COMPLETED, "project lifecycle completes")
	_expect_equal(candidates.generate().size(), 0, "completed project stops producing candidates")
	_expect_equal(entities.get_entity(shelter_id).get_property_override(integrity), 1, "physical shelter truth remains World-owned")

	_completed = true


func _expect_true(actual: bool, label: String) -> void:
	if not actual: _failures.append("Expected true: %s" % label)


func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected: _failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
