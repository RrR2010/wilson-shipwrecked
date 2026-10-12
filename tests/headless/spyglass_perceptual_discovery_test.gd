extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const EpistemicClaim = preload("res://src/domain/cognition/epistemic_claim.gd")
const BeliefProposition = preload("res://src/domain/cognition/belief_proposition.gd")
const BeliefStore = preload("res://src/domain/cognition/belief_store.gd")
const BeliefLearningService = preload("res://src/domain/cognition/belief_learning_service.gd")
const BeliefLearningCoordinator = preload("res://src/application/simulation/belief_learning_coordinator.gd")
const PassiveSpatialPerceptionSource = preload("res://src/application/simulation/passive_spatial_perception_source.gd")
const AuthoredToolOpportunitySource = preload("res://src/domain/cognition/authored_tool_opportunity_source.gd")
const FakeSpatialQueryPort = preload("res://tests/fakes/fake_spatial_query_port.gd")

class Candidates:
	extends RefCounted
	var items: Array
	func _init(p_items: Array) -> void:
		items = p_items
	func has_pending_refresh() -> bool:
		return true
	func consume_refresh_candidates() -> Array:
		return items.duplicate()
	func request_refresh() -> void:
		pass

class WorldQuery:
	extends RefCounted
	func find_relations(_type, _subject = null, _object = null) -> Array:
		return []

var failures: Array[String] = []

func _init() -> void:
	var wilson = RuntimeWorldRef.wilson()
	var spyglass = RuntimeWorldRef.entity(DomainId.entity(&"spyglass"))
	var target = RuntimeWorldRef.entity(DomainId.entity(&"relic"))
	var nearby = DomainId.relation_type(&"perceptibly_near")
	var held = DomainId.relation_type(&"held_by")
	var tool_claim = BeliefProposition.new(EpistemicClaim.relation_claim(wilson, nearby, spyglass))
	var target_claim = BeliefProposition.new(EpistemicClaim.property_claim(target, DomainId.property(&"interesting"), true))
	var beliefs = BeliefStore.new()
	beliefs.restore_entry(target_claim, 0.9, 1)
	var world = WorldQuery.new()
	var source = AuthoredToolOpportunitySource.new(world, beliefs, spyglass, wilson, target, tool_claim, target_claim, held, DomainId.relation_type(&"tool_exploration_receipt"), DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"collect_spyglass"), DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"investigate_with_spyglass"))
	_check(source.generate().is_empty(), "Without observation, no pickup candidate is allowed")
	var spatial = FakeSpatialQueryPort.new()
	var candidates = Candidates.new([spyglass])
	var observer = PassiveSpatialPerceptionSource.new(candidates, spatial, wilson, nearby, 4.0, &"vision", 0.95)
	var learning = BeliefLearningCoordinator.new(BeliefLearningService.new(), beliefs)
	spatial.set_distance(wilson, spyglass, 2.0)
	spatial.set_line_of_sight(wilson, spyglass, false)
	learning.process(observer.collect())
	_check(source.generate().is_empty(), "Occluded spyglass remains unknown")
	spatial.set_line_of_sight(wilson, spyglass, true)
	var evidence = observer.collect()
	_check(evidence.evidence.size() == 1, "Visible tool emits perceptual evidence")
	learning.process(evidence)
	var known = beliefs.get_entry(tool_claim)
	_check(known != null and known.confidence >= 0.5, "Visual evidence establishes Wilson-relative tool belief")
	var opportunities = source.generate()
	_check(opportunities.size() == 1, "Perceived tool becomes pickup opportunity")
	if opportunities.size() == 1:
		_check(opportunities[0].intention_id.value == &"collect_spyglass", "Perception initiates pickup intention")
	if failures.is_empty():
		print("PASS spyglass_perceptual_discovery_test")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		print("FAIL spyglass_perceptual_discovery_test: %d failure(s)" % failures.size())
		quit(1)

func _check(ok: bool, label: String) -> void:
	if not ok:
		failures.append(label)
