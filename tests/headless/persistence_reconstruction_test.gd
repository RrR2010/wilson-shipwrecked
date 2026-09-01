extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const ContentRegistry = preload("res://src/domain/content/content_registry.gd")
const EntityDefinition = preload("res://src/domain/content/entity_definition.gd")
const EntityInstance = preload("res://src/domain/world/entity_instance.gd")
const EntityStore = preload("res://src/domain/world/entity_store.gd")
const WilsonWorldState = preload("res://src/domain/world/wilson_world_state.gd")
const WorldRelation = preload("res://src/domain/world/world_relation.gd")
const WorldRelationStore = preload("res://src/domain/world/world_relation_store.gd")
const DefaultWorldQuery = preload("res://src/domain/world/default_world_query.gd")
const PropertyDerivationDefinition = preload("res://src/domain/physical/property_derivation_definition.gd")
const PropertyDependencyGraph = preload("res://src/domain/physical/property_dependency_graph.gd")
const PhysicalDerivationPolicyRegistry = preload("res://src/domain/physical/physical_derivation_policy_registry.gd")
const EffectivePhysicalProfileResolver = preload("res://src/domain/physical/effective_physical_profile_resolver.gd")
const EpistemicClaim = preload("res://src/domain/cognition/epistemic_claim.gd")
const BeliefProposition = preload("res://src/domain/cognition/belief_proposition.gd")
const BeliefEvidence = preload("res://src/domain/cognition/belief_evidence.gd")
const BeliefStore = preload("res://src/domain/cognition/belief_store.gd")
const CurrentIntentionStore = preload("res://src/domain/cognition/current_intention_store.gd")
const DriveState = preload("res://src/domain/cognition/drive_state.gd")
const AssociationImpact = preload("res://src/domain/cognition/association_impact.gd")
const AssociationStore = preload("res://src/domain/cognition/association_store.gd")
const HabitEvidence = preload("res://src/domain/cognition/habit_evidence.gd")
const HabitStore = preload("res://src/domain/cognition/habit_store.gd")
const EpisodeCandidate = preload("res://src/domain/cognition/episode_candidate.gd")
const EpisodeStore = preload("res://src/domain/cognition/episode_store.gd")
const PresenceEvidence = preload("res://src/domain/cognition/presence_evidence.gd")
const PresenceRelationship = preload("res://src/domain/cognition/presence_relationship.gd")
const ProjectInstance = preload("res://src/domain/projects/project_instance.gd")
const ProjectStore = preload("res://src/domain/projects/project_store.gd")
const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const SimulationSnapshotService = preload("res://src/infrastructure/persistence/simulation_snapshot_service.gd")

var _failures: Array[String] = []
var _completed := false

func _init() -> void:
	_run_slice()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS persistence_reconstruction_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL persistence_reconstruction_test: %d failure(s)" % _failures.size())
	quit(1)

func _run_slice() -> void:
	var crate_type = DomainId.entity_type(&"crate")
	var pouch_type = DomainId.entity_type(&"pouch")
	var camp = DomainId.place(&"camp")
	var beach = DomainId.place(&"beach")
	var structural_integrity = DomainId.property(&"structural_integrity")
	var hardness = DomainId.property(&"hardness")
	var effective_resistance = DomainId.property(&"effective_resistance")
	var inside = DomainId.relation_type(&"inside")

	var content = ContentRegistry.new()
	_expect_true(content.register_entity_definition(EntityDefinition.new(crate_type, [], {structural_integrity.key(): 5, hardness.key(): 4}, [])).ok, "crate definition registers")
	_expect_true(content.register_entity_definition(EntityDefinition.new(pouch_type, [], {}, [])).ok, "pouch definition registers")
	_expect_true(content.seal().ok, "content seals")

	var crate_id = DomainId.entity(&"crate_4")
	var pouch_id = DomainId.entity(&"pouch_7")
	var crate = RuntimeWorldRef.entity(crate_id)
	var pouch = RuntimeWorldRef.entity(pouch_id)
	var entities = EntityStore.new()
	_expect_true(entities.add_entity(EntityInstance.new(crate_id, crate_type, camp)).ok, "crate added")
	_expect_true(entities.add_entity(EntityInstance.new(pouch_id, pouch_type, camp)).ok, "pouch added")
	_expect_true(entities.set_property_override(crate_id, structural_integrity, 2).ok, "runtime override set")
	var wilson_world = WilsonWorldState.new(beach)

	var relations = WorldRelationStore.new()
	var inner_slot: StringName = &"inner"
	_expect_true(relations.add_relation(WorldRelation.new(inside, pouch, crate, inner_slot)).ok, "relation added")

	var beliefs = BeliefStore.new()
	var event_type = DomainId.event_definition(&"impact_committed")
	var proposition = BeliefProposition.new(EpistemicClaim.event_claim(crate, event_type, &"target"))
	_expect_true(beliefs.apply_evidence(BeliefEvidence.new(proposition, true, 0.6, &"exec_1", &"vision")).ok, "belief evidence applied")

	var intention_store = CurrentIntentionStore.new()
	var investigate = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"investigate_crate")
	var intention_binding = RoleBinding.new()
	intention_binding.bind(&"target", crate)
	_expect_true(intention_store.select(investigate, intention_binding, &"step_9").ok, "current intention selected")

	var drives = DriveState.new({
		DriveState.HUNGER: 0.82,
		DriveState.ENERGY: 0.31,
		DriveState.COMFORT: 0.44,
		DriveState.STIMULATION: 0.63,
	})

	var project_definition_id = DomainId.new(DomainId.Kind.PROJECT_DEFINITION, &"repair_crate")
	var project_instance_id = DomainId.new(DomainId.Kind.PROJECT_INSTANCE, &"repair_crate_1")
	var project_binding = RoleBinding.new()
	project_binding.bind(&"project_subject", crate)
	var projects = ProjectStore.new()
	_expect_true(projects.add(ProjectInstance.new(project_instance_id, project_definition_id, project_binding, ProjectInstance.Lifecycle.ACTIVE, 1)), "project instance added")

	var associations = AssociationStore.new()
	_expect_true(associations.apply_impact(AssociationImpact.new(crate, 0.3, 0.5, 0.8, &"exec_assoc")), "association impact applied")
	var habits = HabitStore.new()
	_expect_true(habits.apply_evidence(HabitEvidence.new(&"crate_nearby", investigate, intention_binding, 0.6, 0.7, &"exec_habit")), "habit evidence applied")
	var episodes = EpisodeStore.new()
	_expect_true(episodes.consider(EpisodeCandidate.new(proposition.claim, 0.8, &"exec_episode", &"vision")), "episode consolidated")
	var presence = PresenceRelationship.new()
	presence.apply_evidence(PresenceEvidence.new(0.4, 0.2, 0.3, 0.5, &"exec_presence"))

	var policies = PhysicalDerivationPolicyRegistry.new()
	var resistance_rule = PropertyDerivationDefinition.new(&"effective_resistance_v1", [hardness, structural_integrity], effective_resistance, &"min_numeric")
	var graph_before = PropertyDependencyGraph.new()
	_expect_true(graph_before.compile([resistance_rule], policies).ok, "property graph compiles before save")
	var query_before = DefaultWorldQuery.new(entities, relations, content, wilson_world)
	var resistance_before = EffectivePhysicalProfileResolver.new(query_before, graph_before, policies).resolve(crate).get_property(effective_resistance)
	var relations_before = query_before.find_relations(inside, pouch, crate).size()
	var relation_key_before = query_before.find_relations(inside, pouch, crate)[0].key()
	var belief_before = beliefs.get_entry(proposition).confidence

	var persistence = SimulationSnapshotService.new()
	var snapshot = persistence.capture(
		entities,
		relations,
		wilson_world,
		beliefs,
		intention_store,
		drives,
		projects,
		associations,
		habits,
		episodes,
		presence
	)
	_expect_equal(snapshot.get("schema_version"), 7, "snapshot schema version")
	_expect_true(snapshot.has("drives"), "durable Wilson drives are persisted")
	_expect_true(snapshot.has("projects"), "durable project owner state is persisted")
	_expect_true(snapshot.has("associations"), "durable associations are persisted")
	_expect_true(snapshot.has("habits"), "durable habits are persisted")
	_expect_true(snapshot.has("episodes"), "consolidated episodes are persisted")
	_expect_true(snapshot.has("presence"), "Presence relationship is persisted")
	_expect_false(snapshot.has("relation_indexes"), "reconstructible relation indexes are not persisted")
	_expect_false(snapshot.has("epistemic_projection"), "epistemic projection is not persisted")
	_expect_false(snapshot.has("effective_physical_profiles"), "physical profile cache is not persisted")

	var json_text = JSON.stringify(snapshot)
	_expect_true(not json_text.is_empty(), "snapshot serializes to JSON")
	var parsed = JSON.parse_string(json_text)
	_expect_true(parsed is Dictionary, "serialized snapshot parses as Dictionary")
	if not (parsed is Dictionary): return

	var restored = persistence.restore(parsed)
	_expect_true(restored != null, "snapshot restores")
	if restored == null: return

	var restored_crate = RuntimeWorldRef.entity(crate_id)
	var restored_pouch = RuntimeWorldRef.entity(pouch_id)
	var query_after = DefaultWorldQuery.new(restored.entities, restored.relations, content, restored.wilson_world_state)
	_expect_equal(query_after.get_instance_property(restored_crate, structural_integrity), 2, "runtime property override survives save/load")
	_expect_equal(query_after.find_relations(inside, restored_pouch, restored_crate).size(), relations_before, "relation query survives save/load")
	_expect_equal(query_after.find_relations(inside, restored_pouch, restored_crate)[0].key(), relation_key_before, "qualified relation identity survives save/load")
	_expect_equal(query_after.find_relations(inside, restored_pouch, restored_crate)[0].qualifier, inner_slot, "relation qualifier survives save/load")
	_expect_true(restored.relations.validate_indexes().ok, "relation indexes rebuild valid")
	_expect_equal(restored.wilson_world_state.place_id.key(), beach.key(), "Wilson coarse place survives save/load")
	_expect_true(query_after.are_co_located(RuntimeWorldRef.wilson(), restored_crate) == false, "restored spatial query uses Wilson location")

	var restored_proposition = BeliefProposition.new(EpistemicClaim.event_claim(restored_crate, event_type, &"target"))
	var restored_belief = restored.beliefs.get_entry(restored_proposition)
	_expect_true(restored_belief != null, "belief proposition restores")
	if restored_belief != null:
		_expect_equal(restored_belief.confidence, belief_before, "belief confidence survives save/load")
		_expect_equal(restored_belief.evidence_count, 1, "belief evidence count survives save/load")
	_expect_equal(restored.epistemic_projection.query_by_subject(restored_crate).size(), 1, "epistemic projection rebuilds from beliefs")
	_expect_equal(restored.epistemic_projection.query_by_semantic_id(event_type).size(), 1, "typed semantic-id projection rebuilds")

	_expect_true(restored.current_intention.has_current(), "current intention survives save/load")
	if restored.current_intention.has_current():
		var current = restored.current_intention.current()
		_expect_equal(current.intention_id.key(), investigate.key(), "current intention id survives")
		_expect_equal(current.bindings.get_subject(&"target").key(), restored_crate.key(), "current intention binding survives")
		_expect_equal(String(current.selected_step_id), "step_9", "current intention provenance survives")

	_expect_equal(restored.drives.snapshot_values(), drives.snapshot_values(), "drive owner state survives save/load")
	_expect_equal(restored.drives.band(DriveState.HUNGER), DriveState.UrgencyBand.URGENT, "drive urgency band reconstructs from durable value")

	var restored_project = restored.projects.get_instance(project_instance_id)
	_expect_true(restored_project != null, "project instance survives save/load")
	if restored_project != null:
		_expect_equal(restored_project.definition_id.key(), project_definition_id.key(), "project definition binding survives")
		_expect_equal(restored_project.lifecycle, ProjectInstance.Lifecycle.ACTIVE, "project lifecycle survives")
		_expect_equal(restored_project.contribution_count, 1, "project contribution metadata survives")
		_expect_equal(restored_project.subject_bindings.get_subject(&"project_subject").key(), restored_crate.key(), "project physical subject binding survives")

	var original_association = associations.get_association(crate)
	var restored_association = restored.associations.get_association(restored_crate)
	_expect_true(restored_association != null, "association survives save/load")
	if restored_association != null:
		_expect_equal(restored_association["valence"], original_association["valence"], "association valence survives")
		_expect_equal(restored_association["attachment"], original_association["attachment"], "association attachment survives")
	_expect_equal(restored.habits.entries().size(), 1, "habit survives save/load")
	if restored.habits.entries().size() == 1:
		_expect_equal(restored.habits.entries()[0]["strength"], habits.entries()[0]["strength"], "habit strength survives")
		_expect_equal(restored.habits.entries()[0]["bindings"].get_subject(&"target").key(), restored_crate.key(), "habit binding survives")
	_expect_equal(restored.episodes.entries().size(), 1, "episode survives save/load")
	if restored.episodes.entries().size() == 1:
		_expect_equal(restored.episodes.entries()[0]["claim"].key(), restored_proposition.claim.key(), "episode typed claim survives")
		_expect_equal(restored.episodes.entries()[0]["importance"], 0.8, "episode importance survives")
	_expect_equal(restored.presence.presence_belief, presence.presence_belief, "Presence belief survives")
	_expect_equal(restored.presence.trust, presence.trust, "Presence trust survives")
	_expect_equal(restored.presence.dependency, presence.dependency, "Presence dependency survives")

	var graph_after = PropertyDependencyGraph.new()
	_expect_true(graph_after.compile([resistance_rule], policies).ok, "property graph recompiles after load")
	var resolver_after = EffectivePhysicalProfileResolver.new(query_after, graph_after, policies)
	_expect_equal(resolver_after.cached_subject_count(), 0, "derived physical cache starts empty after restore")
	_expect_equal(resolver_after.resolve(restored_crate).get_property(effective_resistance), resistance_before, "derived physical query matches after rebuild")

	_completed = true

func _expect_true(actual: bool, label: String) -> void:
	if not actual: _failures.append("Expected true: %s" % label)

func _expect_false(actual: bool, label: String) -> void:
	if actual: _failures.append("Expected false: %s" % label)

func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected: _failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
