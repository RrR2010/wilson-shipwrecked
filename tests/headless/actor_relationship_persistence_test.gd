extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const EntityBootstrapSeed = preload("res://src/application/bootstrap/entity_bootstrap_seed.gd")
const ActorStateBootstrapSeed = preload("res://src/application/bootstrap/actor_state_bootstrap_seed.gd")
const ActorRelationshipBootstrapSeed = preload("res://src/application/bootstrap/actor_relationship_bootstrap_seed.gd")
const SimulationBootstrapDefinition = preload("res://src/application/bootstrap/simulation_bootstrap_definition.gd")
const SimulationOwnerBootstrapper = preload("res://src/application/bootstrap/simulation_owner_bootstrapper.gd")
const SimulationSnapshotService = preload("res://src/infrastructure/persistence/simulation_snapshot_service.gd")

var _failures: Array[String] = []


func _init() -> void:
	_run_test()
	if _failures.is_empty():
		print("PASS actor_relationship_persistence_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL actor_relationship_persistence_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_test() -> void:
	var island = DomainId.place(&"relationship_island")
	var gerald_id = DomainId.entity(&"gerald")
	var gerald_ref = RuntimeWorldRef.entity(gerald_id)
	var wilson_ref = RuntimeWorldRef.wilson()
	var definition = SimulationBootstrapDefinition.new(
		island,
		[EntityBootstrapSeed.new(gerald_id, DomainId.entity_type(&"crab"), island)],
		[],
		[],
		null,
		1.0,
		{},
		[],
		[],
		[],
		[],
		null,
		&"clear",
		&"day",
		[],
		[ActorStateBootstrapSeed.new(gerald_ref, &"gerald", &"idle")],
		[ActorRelationshipBootstrapSeed.new(gerald_ref, wilson_ref, 0.72, 4, &"helpful_interaction")]
	)
	var boot = SimulationOwnerBootstrapper.new().bootstrap(definition)
	_expect_true(boot.ok, "bootstrap accepts actor relationship seed")
	if not boot.ok:
		return

	var initial = boot.owners.actor_relationships.get_relationship(gerald_ref, wilson_ref)
	_expect_true(initial != null, "bootstrap reconstructs actor relationship")
	if initial != null:
		_expect_close(float(initial["affinity"]), 0.72, "bootstrap preserves affinity")
		_expect_equal(int(initial["evidence_count"]), 4, "bootstrap preserves evidence count")
		_expect_equal(initial["last_source_execution_id"], &"helpful_interaction", "bootstrap preserves source execution")

	var snapshots = SimulationSnapshotService.new()
	var snapshot = snapshots.capture(
		boot.owners.entities,
		boot.owners.relations,
		boot.owners.wilson_world_state,
		boot.owners.beliefs,
		boot.owners.current_intention,
		boot.owners.drives,
		boot.owners.projects,
		boot.owners.associations,
		boot.owners.habits,
		boot.owners.episodes,
		boot.owners.presence,
		boot.owners.environment,
		boot.owners.dynamic_processes,
		boot.owners.actors,
		boot.owners.wilson_body_state,
		boot.owners.actor_relationships
	)
	_expect_equal(int(snapshot.get("schema_version", -1)), 11, "actor relationship persistence advances simulation snapshot schema")
	_expect_equal(Array(snapshot.get("actor_relationships", [])).size(), 1, "snapshot captures actor relationship")

	var restored = snapshots.restore(snapshot)
	var restored_entry = restored.actor_relationships.get_relationship(gerald_ref, wilson_ref)
	_expect_true(restored_entry != null, "restore reconstructs actor relationship")
	if restored_entry != null:
		_expect_close(float(restored_entry["affinity"]), 0.72, "restore preserves affinity")
		_expect_equal(int(restored_entry["evidence_count"]), 4, "restore preserves evidence count")
		_expect_equal(restored_entry["last_source_execution_id"], &"helpful_interaction", "restore preserves source execution")

	_expect_true(restored.actor_relationships != boot.owners.actor_relationships, "restore creates fresh relationship owner")


func _expect_true(condition: bool, label: String) -> void:
	if not condition:
		_failures.append("Expected true: %s" % label)


func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])


func _expect_close(actual: float, expected: float, label: String) -> void:
	if not is_equal_approx(actual, expected):
		_failures.append("%s | expected=%.6f actual=%.6f" % [label, expected, actual])
