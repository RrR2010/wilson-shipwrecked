extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const ProjectInstance = preload("res://src/domain/projects/project_instance.gd")
const ProjectBootstrapSeed = preload("res://src/application/bootstrap/project_bootstrap_seed.gd")
const SimulationBootstrapDefinition = preload("res://src/application/bootstrap/simulation_bootstrap_definition.gd")
const SimulationOwnerBootstrapper = preload("res://src/application/bootstrap/simulation_owner_bootstrapper.gd")

var _failures: Array[String] = []
var _completed := false


func _init() -> void:
	_run()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS project_bootstrap_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL project_bootstrap_test: %d failure(s)" % _failures.size())
	quit(1)


func _run() -> void:
	var place_id = DomainId.place(&"project_bootstrap_camp")
	var subject = RuntimeWorldRef.entity(DomainId.entity(&"raft_frame"))
	var bindings = RoleBinding.new()
	bindings.bind(&"project_subject", subject)
	var project_id = DomainId.new(DomainId.Kind.PROJECT_INSTANCE, &"raft_1")
	var definition_id = DomainId.new(DomainId.Kind.PROJECT_DEFINITION, &"build_raft")
	var seed = ProjectBootstrapSeed.new(
		project_id,
		definition_id,
		bindings,
		ProjectInstance.Lifecycle.PAUSED,
		2
	)
	var definition = SimulationBootstrapDefinition.new(place_id, [], [], [], null, 1.0, {}, [seed])
	var first = SimulationOwnerBootstrapper.new().bootstrap(definition)
	var second = SimulationOwnerBootstrapper.new().bootstrap(definition)

	_expect_true(first.ok and second.ok, "project-bearing bootstrap succeeds")
	if not first.ok or not second.ok:
		return
	var first_project = first.owners.projects.get_instance(project_id)
	var second_project = second.owners.projects.get_instance(project_id)
	_expect_true(first_project != null and second_project != null, "project seed reconstructs owner state")
	if first_project == null or second_project == null:
		return
	_expect_equal(first_project.definition_id.sort_key(), definition_id.sort_key(), "project definition binding survives bootstrap")
	_expect_equal(first_project.lifecycle, ProjectInstance.Lifecycle.PAUSED, "project lifecycle survives bootstrap")
	_expect_equal(first_project.contribution_count, 2, "project contribution count survives bootstrap")
	_expect_equal(first_project.subject_bindings.get_subject(&"project_subject").sort_key(), subject.sort_key(), "project subject binding survives bootstrap")
	_expect_true(first_project != second_project, "rebootstrap creates fresh project instance")
	_expect_true(first.owners.projects != second.owners.projects, "rebootstrap creates fresh project store")

	first.owners.projects.set_lifecycle(project_id, ProjectInstance.Lifecycle.ACTIVE)
	first.owners.projects.apply_contribution(project_id, 4)
	_expect_equal(first_project.lifecycle, ProjectInstance.Lifecycle.ACTIVE, "first project owner mutates independently")
	_expect_equal(first_project.contribution_count, 3, "first project contribution mutates independently")
	_expect_equal(second_project.lifecycle, ProjectInstance.Lifecycle.PAUSED, "second project owner preserves seed lifecycle")
	_expect_equal(second_project.contribution_count, 2, "second project owner preserves seed contribution count")
	_expect_equal(seed.lifecycle, ProjectInstance.Lifecycle.PAUSED, "bootstrap does not mutate project seed lifecycle")
	_expect_equal(seed.contribution_count, 2, "bootstrap does not mutate project seed contribution count")

	var empty = SimulationOwnerBootstrapper.new().bootstrap(SimulationBootstrapDefinition.new(place_id))
	_expect_true(empty.ok, "default project bootstrap succeeds")
	if empty.ok:
		_expect_equal(empty.owners.projects.instances().size(), 0, "new-run default project store starts empty")

	_completed = true


func _expect_true(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _expect_equal(actual: Variant, expected: Variant, message: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [message, expected, actual])
