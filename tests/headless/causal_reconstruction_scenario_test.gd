extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const EntityInstance = preload("res://src/domain/world/entity_instance.gd")
const EntityStore = preload("res://src/domain/world/entity_store.gd")
const WilsonWorldState = preload("res://src/domain/world/wilson_world_state.gd")
const WorldRelationStore = preload("res://src/domain/world/world_relation_store.gd")
const BeliefStore = preload("res://src/domain/cognition/belief_store.gd")
const CurrentIntentionStore = preload("res://src/domain/cognition/current_intention_store.gd")
const EpistemicClaim = preload("res://src/domain/cognition/epistemic_claim.gd")
const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const ContentPackLoader = preload("res://src/infrastructure/content_loading/content_pack_loader.gd")
const SimulationSnapshotService = preload("res://src/infrastructure/persistence/simulation_snapshot_service.gd")
const ActionExecutionSnapshotService = preload("res://src/infrastructure/persistence/action_execution_snapshot_service.gd")
const RunRuntimeComposer = preload("res://src/application/simulation/run_runtime_composer.gd")

var _failures: Array[String] = []
var _completed := false


func _init() -> void:
	_run_scenario()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS causal_reconstruction_scenario_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL causal_reconstruction_scenario_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_scenario() -> void:
	var loader = ContentPackLoader.new()
	var loaded = loader.load_dictionary(_content_pack())
	_expect_true(loaded.ok, "representative content pack loads")
	if not loaded.ok:
		return
	var content = loaded.value
	var camp = DomainId.place(&"camp")
	var crate_id = DomainId.entity(&"crate_1")
	var crate = RuntimeWorldRef.entity(crate_id)
	var entities = EntityStore.new()
	_expect_true(entities.add_entity(EntityInstance.new(crate_id, DomainId.entity_type(&"crate"), camp)).ok, "crate added")
	var relations = WorldRelationStore.new()
	var wilson_world = WilsonWorldState.new(camp)
	var beliefs = BeliefStore.new()
	var intentions = CurrentIntentionStore.new()
	var initial_composition = RunRuntimeComposer.new().compose(
		entities,
		relations,
		wilson_world,
		beliefs,
		intentions,
		content
	)
	_expect_true(initial_composition.ok, "initial runtime composition succeeds")
	if not initial_composition.ok:
		return
	var initial_runtime = initial_composition.composition
	var bindings = RoleBinding.new()
	bindings.bind(&"actor", RuntimeWorldRef.wilson())
	bindings.bind(&"target", crate)
	var action = content.get_action_definition(DomainId.action(&"hit"))
	var resolution = content.get_action_resolution_definition(&"hit_basic_v1")
	_expect_true(initial_runtime.action_execution.start(&"exec_causal", action, resolution, bindings) != null, "action starts")
	var pre = initial_runtime.action_execution.advance(&"exec_causal", 0.25)
	_expect_false(pre.committed, "scenario saves before commit")
	_expect_true(pre.new_outcome == null, "no pre-save outcome")
	_expect_equal(initial_runtime.effective_physical_profiles.resolve(crate).get_property(DomainId.property(&"effective_resistance")), 4, "derived value established before save")

	# Save all authoritative causes before the irreversible checkpoint.
	var simulation_persistence = SimulationSnapshotService.new()
	var action_persistence = ActionExecutionSnapshotService.new()
	var sim_pre_json = JSON.stringify(simulation_persistence.capture(entities, relations, wilson_world, beliefs, intentions))
	var action_pre_json = JSON.stringify(action_persistence.capture(initial_runtime.action_execution))
	var sim_pre = JSON.parse_string(sim_pre_json)
	var action_pre = JSON.parse_string(action_pre_json)
	_expect_true(sim_pre is Dictionary and action_pre is Dictionary, "pre-commit snapshots survive JSON")
	if not (sim_pre is Dictionary) or not (action_pre is Dictionary):
		return

	# Restore into fresh owners, rebuild runtime through the production composition root,
	# and cross the commit exactly once.
	var restored = simulation_persistence.restore(sim_pre)
	var restored_composition = RunRuntimeComposer.new().compose(
		restored.entities,
		restored.relations,
		restored.wilson_world_state,
		restored.beliefs,
		restored.current_intention,
		content
	)
	_expect_true(restored_composition.ok, "restored owner state composes")
	if not restored_composition.ok:
		return
	var restored_runtime = restored_composition.composition
	var restore_results = action_persistence.restore(action_pre, restored_runtime.action_execution, content)
	_expect_equal(restore_results.size(), 1, "one active action restores")
	_expect_true(restore_results[0].ok, "pre-commit action restore valid")
	_expect_equal(restored_runtime.effective_physical_profiles.resolve(crate).get_property(DomainId.property(&"effective_resistance")), 4, "derived query matches after pre-commit restore")

	var crossing = restored_runtime.action_execution.advance(&"exec_causal", 0.25)
	_expect_true(crossing.committed and crossing.new_outcome != null, "restored action crosses commit and emits once")
	var commit = restored_runtime.world_commands.apply_outcome(crossing.new_outcome)
	_expect_true(commit.ok, "restored outcome commits through World owner")
	_expect_equal(restored_runtime.world_query.get_instance_property(crate, DomainId.property(&"structural_integrity")), 2, "commit mutates authoritative World")
	_expect_equal(commit.events.size(), 1, "commit emits one semantic event")
	_expect_equal(commit.change_set.changes.size(), 1, "commit emits one semantic change")
	var invalidation = restored_runtime.derived_invalidator.apply(commit.change_set)
	_expect_equal(invalidation.size(), 1, "change invalidates derived state")
	_expect_equal(restored_runtime.effective_physical_profiles.resolve(crate).get_property(DomainId.property(&"effective_resistance")), 2, "derived value recomputes after commit")

	# Spatial access is derived after commit; cognition receives only the accessible claim.
	var access = restored_runtime.perception_access.resolve(commit.events, null)
	_expect_true(access[&"exec_causal"].observable, "co-located committed event is observable")
	var perception = restored_runtime.perception.perceive(commit.events, access)
	_expect_equal(perception.evidence.size(), 1, "one accessible event role becomes evidence")
	_expect_equal(perception.evidence[0].claim.kind, EpistemicClaim.Kind.EVENT, "evidence uses typed EVENT claim")
	var learning = restored_runtime.learning.process(perception)
	_expect_equal(learning.get("mutation_results", []).size(), 1, "one belief mutation applied")
	_expect_equal(restored.beliefs.entries().size(), 1, "belief owner records perceived event")

	var completion = restored_runtime.action_execution.advance(&"exec_causal", 0.5)
	_expect_true(completion.completed, "restored action completes")
	_expect_true(completion.new_outcome == null, "completion never replays committed outcome")

	# Save again post-commit and prove a second reconstruction cannot duplicate causality.
	var sim_post = JSON.parse_string(JSON.stringify(simulation_persistence.capture(
		restored.entities,
		restored.relations,
		restored.wilson_world_state,
		restored.beliefs,
		restored.current_intention
	)))
	var action_post = JSON.parse_string(JSON.stringify(action_persistence.capture(restored_runtime.action_execution)))
	_expect_true(sim_post is Dictionary and action_post is Dictionary, "post-commit snapshots survive JSON")
	if not (sim_post is Dictionary) or not (action_post is Dictionary):
		return
	var restored_again = simulation_persistence.restore(sim_post)
	var second_composition = RunRuntimeComposer.new().compose(
		restored_again.entities,
		restored_again.relations,
		restored_again.wilson_world_state,
		restored_again.beliefs,
		restored_again.current_intention,
		content
	)
	_expect_true(second_composition.ok, "second restored owner state composes")
	if not second_composition.ok:
		return
	var second_runtime = second_composition.composition
	_expect_equal(second_runtime.world_query.get_instance_property(crate, DomainId.property(&"structural_integrity")), 2, "post-commit World truth survives second restore")
	_expect_equal(restored_again.beliefs.entries().size(), 1, "learned belief survives second restore")
	_expect_equal(restored_again.epistemic_projection.query_by_semantic_id(DomainId.event_definition(&"impact_committed")).size(), 1, "typed epistemic index rebuilds after second restore")

	var second_restore = action_persistence.restore(action_post, second_runtime.action_execution, content)
	_expect_true(second_restore[0].ok, "completed action reconstructs")
	var terminal_progress = second_runtime.action_execution.advance(&"exec_causal", 1.0)
	_expect_true(terminal_progress.completed, "completed action remains terminal after second restore")
	_expect_true(terminal_progress.new_outcome == null, "terminal reconstruction cannot duplicate outcome")

	_completed = true


func _content_pack() -> Dictionary:
	return {
		"schema_version": 1,
		"properties": [
			{"id": "structural_integrity", "family": "number", "min": 0, "max": 5},
			{"id": "hardness", "family": "number", "min": 0, "max": 5},
			{"id": "effective_resistance", "family": "number", "min": 0, "max": 5},
		],
		"events": [
			{"id": "impact_committed", "perceptible_roles": ["target"], "modalities": ["vision", "hearing"], "base_confidence": 0.85},
		],
		"entities": [
			{"id": "crate", "base_properties": {"structural_integrity": 5, "hardness": 4}, "capabilities": ["receives_impact"]},
		],
		"property_derivations": [
			{
				"id": "effective_resistance_v1",
				"inputs": [
					{"kind": "self", "property": "hardness"},
					{"kind": "self", "property": "structural_integrity"},
				],
				"output": "effective_resistance",
				"policy": "min_numeric",
			},
		],
		"actions": [
			{"id": "hit", "roles": ["actor", "target"], "requirements": {"kind": "has_capability", "role": "target", "capability": "receives_impact"}},
		],
		"resolutions": [
			{
				"id": "hit_basic_v1",
				"action": "hit",
				"duration": 1.0,
				"commit_fraction": 0.5,
				"event": "impact_committed",
				"effects": [{"kind": "set_property", "subject_role": "target", "property": "structural_integrity", "value": 2}],
			},
		],
	}


func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)


func _expect_false(actual: bool, label: String) -> void:
	if actual:
		_failures.append("Expected false: %s" % label)


func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
