extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const ActionOutcome = preload("res://src/domain/actions/action_outcome.gd")
const ActionEffect = preload("res://src/domain/actions/action_effect.gd")
const EntityInstance = preload("res://src/domain/world/entity_instance.gd")
const EntityStore = preload("res://src/domain/world/entity_store.gd")
const WorldRelationStore = preload("res://src/domain/world/world_relation_store.gd")
const DefaultWorldCommandPort = preload("res://src/domain/world/default_world_command_port.gd")
const DefaultWorldQuery = preload("res://src/domain/world/default_world_query.gd")
const ContentRegistry = preload("res://src/domain/content/content_registry.gd")
const ProjectStore = preload("res://src/domain/projects/project_store.gd")
const ProjectInstance = preload("res://src/domain/projects/project_instance.gd")
const ProjectDefinition = preload("res://src/domain/projects/project_definition.gd")
const ProjectContributionService = preload("res://src/domain/projects/project_contribution_service.gd")

var failures: Array[String] = []

func _init() -> void:
	_run()
	if failures.is_empty():
		print("PASS shelter_material_receipt_test")
		quit(0)
		return
	for failure in failures:
		push_error(failure)
	print("FAIL shelter_material_receipt_test: %d failure(s)" % failures.size())
	quit(1)

func _run() -> void:
	var place = DomainId.place(&"island")
	var planks_id = DomainId.entity(&"planks")
	var fiber_id = DomainId.entity(&"fiber")
	var shelter_id = DomainId.entity(&"shelter")
	var entities = EntityStore.new()
	for item in [[planks_id, 2], [fiber_id, 1], [shelter_id, null]]:
		entities.add_entity(EntityInstance.new(item[0], DomainId.entity_type(&"resource"), place, {}, item[1]))
	var relations = WorldRelationStore.new()
	var world = DefaultWorldCommandPort.new(entities, relations)
	var query = DefaultWorldQuery.new(entities, relations, ContentRegistry.new())
	var receipt_type = DomainId.relation_type(&"project_placement_receipt")
	var project_id = DomainId.project_instance(&"shelter_project")
	var definition_id = DomainId.project_definition(&"shelter")
	var action = DomainId.action(&"contribute_shelter")
	var event = DomainId.event_definition(&"shelter_contribution_committed")
	var intention = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"continue_shelter")
	var bindings = RoleBinding.new()
	bindings.bind(&"target", RuntimeWorldRef.entity(shelter_id))
	bindings.bind(&"planks", RuntimeWorldRef.entity(planks_id))
	bindings.bind(&"fiber", RuntimeWorldRef.entity(fiber_id))
	var defs = [ProjectDefinition.new(definition_id, action, event, &"target", &"target", intention, 2, 0.3, receipt_type)]
	var projects = ProjectStore.new()
	projects.add(ProjectInstance.new(project_id, definition_id, bindings))
	var service = ProjectContributionService.new(projects, defs, query)
	var effects = [
		ActionEffect.change_quantity(&"planks", -1),
		ActionEffect.change_quantity(&"fiber", -1),
		ActionEffect.record_execution_receipt(&"target", receipt_type),
	]
	var rejected = world.apply_outcome(ActionOutcome.new(&"rejected", action, bindings, effects, event))
	_check(rejected.ok, "first placement must commit")
	_check(entities.get_quantity(planks_id) == 1, "first placement spends plank")
	_check(entities.get_quantity(fiber_id) == 0, "first placement spends fiber")
	_check(projects.get_instance(project_id).contribution_count == 0, "World commit alone does not directly mutate Projects")
	# Simulate coordinator stopping after accepted World commit, then recovering from stored World relations.
	service.reconcile()
	_check(projects.get_instance(project_id).contribution_count == 1, "reconcile recovers committed placement")
	service.apply_grounded(ActionOutcome.new(&"rejected", action, bindings, effects, event), rejected)
	service.reconcile()
	_check(projects.get_instance(project_id).contribution_count == 1, "repeat delivery cannot double-count")
	var duplicate = world.apply_outcome(ActionOutcome.new(&"rejected", action, bindings, effects, event))
	_check(not duplicate.ok, "same receipt identity cannot spend material twice")
	_check(entities.get_quantity(planks_id) == 1, "duplicate rejected without spending plank")
	var shortage = world.apply_outcome(ActionOutcome.new(&"shortage", action, bindings, effects, event))
	_check(not shortage.ok, "fiber shortage rejects complete placement")
	_check(entities.get_quantity(planks_id) == 1, "shortage cannot spend remaining plank")
	_check(query.find_relations(receipt_type).size() == 1, "shortage cannot generate receipt")
	# Simulate restored ProjectStore with stale count but restored World relations.
	var restored = ProjectStore.new()
	restored.add(ProjectInstance.new(project_id, definition_id, bindings))
	var restored_service = ProjectContributionService.new(restored, defs, query)
	restored_service.reconcile()
	_check(restored.get_instance(project_id).contribution_count == 1, "restored project catches up from World receipt")
	_check(relations.validate_indexes().ok, "World receipt relation indexes remain valid")

func _check(ok: bool, message: String) -> void:
	if not ok:
		failures.append(message)
