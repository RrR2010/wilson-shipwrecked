extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const EpistemicClaim = preload("res://src/domain/cognition/epistemic_claim.gd")
const AssociationImpact = preload("res://src/domain/cognition/association_impact.gd")
const PresenceEvidence = preload("res://src/domain/cognition/presence_evidence.gd")
const AssociationBootstrapSeed = preload("res://src/application/bootstrap/association_bootstrap_seed.gd")
const HabitBootstrapSeed = preload("res://src/application/bootstrap/habit_bootstrap_seed.gd")
const EpisodeBootstrapSeed = preload("res://src/application/bootstrap/episode_bootstrap_seed.gd")
const PresenceBootstrapSeed = preload("res://src/application/bootstrap/presence_bootstrap_seed.gd")
const SimulationBootstrapDefinition = preload("res://src/application/bootstrap/simulation_bootstrap_definition.gd")
const SimulationOwnerBootstrapper = preload("res://src/application/bootstrap/simulation_owner_bootstrapper.gd")

var _failures: Array[String] = []
var _completed := false


func _init() -> void:
	_run()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS learning_owners_bootstrap_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL learning_owners_bootstrap_test: %d failure(s)" % _failures.size())
	quit(1)


func _run() -> void:
	var camp = DomainId.place(&"learning_bootstrap_camp")
	var crate = RuntimeWorldRef.entity(DomainId.entity(&"learning_crate"))
	var inspect = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"inspect_crate")
	var bindings = RoleBinding.new()
	bindings.bind(&"target", crate)
	var claim = EpistemicClaim.event_claim(
		crate,
		DomainId.event_definition(&"crate_discovered"),
		&"target"
	)

	var association_seed = AssociationBootstrapSeed.new(crate, -0.25, 0.6, 3, &"exec_assoc")
	var habit_seed = HabitBootstrapSeed.new(&"crate_nearby", inspect, bindings, 0.72, 4, &"exec_habit")
	var episode_seed = EpisodeBootstrapSeed.new(claim, 0.83, &"exec_episode", &"vision", 7)
	var presence_seed = PresenceBootstrapSeed.new(0.55, 0.2, 0.35, 5, &"exec_presence")
	var definition = SimulationBootstrapDefinition.new(
		camp,
		[], [], [], null, 1.0, {}, [],
		[association_seed], [habit_seed], [episode_seed], presence_seed
	)
	var first = SimulationOwnerBootstrapper.new().bootstrap(definition)
	var second = SimulationOwnerBootstrapper.new().bootstrap(definition)

	_expect_true(first.ok and second.ok, "learning-owner bootstrap succeeds")
	if not first.ok or not second.ok:
		_completed = true
		return

	var first_association = first.owners.associations.get_association(crate)
	var second_association = second.owners.associations.get_association(crate)
	_expect_true(first_association != null and second_association != null, "association seed reconstructs owner state")
	if first_association != null:
		_expect_float(first_association["valence"], -0.25, "association valence survives bootstrap")
		_expect_float(first_association["attachment"], 0.6, "association attachment survives bootstrap")
		_expect_equal(first_association["evidence_count"], 3, "association evidence count survives bootstrap")
		_expect_equal(first_association["last_source_execution_id"], &"exec_assoc", "association provenance survives bootstrap")

	var first_habit = first.owners.habits.get_habit(&"crate_nearby", inspect, bindings)
	var second_habit = second.owners.habits.get_habit(&"crate_nearby", inspect, bindings)
	_expect_true(first_habit != null and second_habit != null, "habit seed reconstructs owner state")
	if first_habit != null:
		_expect_float(first_habit["strength"], 0.72, "habit strength survives bootstrap")
		_expect_equal(first_habit["evidence_count"], 4, "habit evidence count survives bootstrap")
		_expect_equal(first_habit["bindings"].get_subject(&"target").sort_key(), crate.sort_key(), "habit binding survives bootstrap")

	_expect_equal(first.owners.episodes.entries().size(), 1, "episode seed reconstructs owner state")
	if first.owners.episodes.entries().size() == 1:
		var episode = first.owners.episodes.entries()[0]
		_expect_equal(episode["claim"].sort_key(), claim.sort_key(), "episode claim survives bootstrap")
		_expect_float(episode["importance"], 0.83, "episode importance survives bootstrap")
		_expect_equal(episode["sequence"], 7, "episode sequence survives bootstrap")

	_expect_float(first.owners.presence.presence_belief, 0.55, "presence belief survives bootstrap")
	_expect_float(first.owners.presence.trust, 0.2, "presence trust survives bootstrap")
	_expect_float(first.owners.presence.dependency, 0.35, "presence dependency survives bootstrap")
	_expect_equal(first.owners.presence.evidence_count, 5, "presence evidence count survives bootstrap")
	_expect_equal(first.owners.presence.last_source_execution_id, &"exec_presence", "presence provenance survives bootstrap")

	_expect_true(first.owners.associations != second.owners.associations, "rebootstrap creates fresh AssociationStore")
	_expect_true(first.owners.habits != second.owners.habits, "rebootstrap creates fresh HabitStore")
	_expect_true(first.owners.episodes != second.owners.episodes, "rebootstrap creates fresh EpisodeStore")
	_expect_true(first.owners.presence != second.owners.presence, "rebootstrap creates fresh PresenceRelationship")

	first.owners.associations.apply_impact(AssociationImpact.new(crate, 0.5, 0.2, 1.0, &"exec_mutate"))
	first.owners.presence.apply_evidence(PresenceEvidence.new(0.2, -0.1, 0.1, 1.0, &"exec_presence_mutate"))
	var mutated_association = first.owners.associations.get_association(crate)
	var untouched_association = second.owners.associations.get_association(crate)
	_expect_true(not is_equal_approx(float(mutated_association["valence"]), float(untouched_association["valence"])), "association mutation stays isolated between bootstraps")
	_expect_float(untouched_association["valence"], -0.25, "second association retains seed state")
	_expect_float(second.owners.presence.presence_belief, 0.55, "second Presence retains seed state")
	_expect_float(association_seed.valence, -0.25, "bootstrap does not mutate association seed")
	_expect_float(presence_seed.presence_belief, 0.55, "bootstrap does not mutate Presence seed")

	var empty = SimulationOwnerBootstrapper.new().bootstrap(SimulationBootstrapDefinition.new(camp))
	_expect_true(empty.ok, "default learning-owner bootstrap succeeds")
	if empty.ok:
		_expect_equal(empty.owners.associations.entries().size(), 0, "new-run AssociationStore starts empty")
		_expect_equal(empty.owners.habits.entries().size(), 0, "new-run HabitStore starts empty")
		_expect_equal(empty.owners.episodes.entries().size(), 0, "new-run EpisodeStore starts empty")
		_expect_float(empty.owners.presence.presence_belief, 0.0, "new-run Presence belief starts neutral")
		_expect_float(empty.owners.presence.trust, 0.0, "new-run Presence trust starts neutral")
		_expect_float(empty.owners.presence.dependency, 0.0, "new-run Presence dependency starts neutral")

	_completed = true


func _expect_true(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _expect_equal(actual: Variant, expected: Variant, message: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [message, expected, actual])


func _expect_float(actual: Variant, expected: float, message: String) -> void:
	if actual == null or not is_equal_approx(float(actual), expected):
		_failures.append("%s | expected=%s actual=%s" % [message, expected, actual])
