extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const BeliefStore = preload("res://src/domain/cognition/belief_store.gd")
const BeliefProposition = preload("res://src/domain/cognition/belief_proposition.gd")
const EpistemicClaim = preload("res://src/domain/cognition/epistemic_claim.gd")
const BeliefLearningService = preload("res://src/domain/cognition/belief_learning_service.gd")
const BeliefLearningCoordinator = preload("res://src/application/simulation/belief_learning_coordinator.gd")
const DriveState = preload("res://src/domain/cognition/drive_state.gd")
const DriveCandidateDefinition = preload("res://src/domain/cognition/drive_candidate_definition.gd")
const PerceivedOpportunityDefinition = preload("res://src/domain/cognition/perceived_opportunity_definition.gd")
const DriveBackedBelievedOpportunityCandidateSource = preload("res://src/domain/cognition/drive_backed_believed_opportunity_candidate_source.gd")
const DecisionCandidate = preload("res://src/domain/cognition/decision_candidate.gd")
const PassiveSpatialPerceptionSource = preload("res://src/application/simulation/passive_spatial_perception_source.gd")
const FakeSpatialQueryPort = preload("res://tests/fakes/fake_spatial_query_port.gd")

var _failures: Array[String] = []

class CandidateSource:
	extends RefCounted
	var pending := true
	var subject
	func _init(p_subject) -> void:
		subject = p_subject
	func has_pending_refresh() -> bool:
		return pending
	func consume_refresh_candidates() -> Array:
		pending = false
		return [subject]
	func request_refresh() -> void:
		pending = true

class WorldQueryStub:
	extends RefCounted
	var edible_property
	func _init(p_edible_property) -> void:
		edible_property = p_edible_property
	func get_quantity(_subject):
		return null
	func get_instance_property(_subject, property_id):
		return true if property_id.equals(edible_property) else null

class DriveStub:
	extends RefCounted
	func band(_id) -> int:
		return 2
	func urgency(_id) -> float:
		return 1.0
	func value(_id) -> float:
		return 0.8

func _init() -> void:
	var wilson = RuntimeWorldRef.wilson()
	var unknown_food = RuntimeWorldRef.entity(DomainId.entity(&"unknown_food"))
	var edible = DomainId.property(&"edible")
	var nearby = DomainId.relation_type(&"perceptibly_near")
	var seek_food = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"seek_food")
	var beliefs = BeliefStore.new()
	var source = _food_source(beliefs, edible, seek_food)
	_check(source.generate().is_empty(), "Unknown food identity cannot produce targeted seek_food")

	var spatial = FakeSpatialQueryPort.new()
	spatial.set_distance(wilson, unknown_food, 2.0)
	spatial.set_line_of_sight(wilson, unknown_food, true)
	var passive = PassiveSpatialPerceptionSource.new(
		CandidateSource.new(unknown_food), spatial, wilson, nearby, 4.0,
		&"vision", 0.95, WorldQueryStub.new(edible), null, [edible]
	)
	var perception = passive.collect()
	_check(perception.evidence.size() == 2, "Visible object emits proximity plus configured property evidence")
	BeliefLearningCoordinator.new(BeliefLearningService.new(), beliefs).process(perception)

	var candidates: Array = source.generate()
	_check(candidates.size() == 1, "Observed edible property enables targeted food candidate")
	if candidates.size() == 1:
		var candidate = candidates[0]
		_check(candidate.bindings.get_subject(&"target").equals(unknown_food), "Target comes from learned Wilson belief")
		_check(candidate.provenance.get("belief_modality", "") == "vision", "Candidate preserves visual belief provenance")
		_check(String(candidate.provenance.get("belief_source_execution_id", "")).begins_with("passive_spatial_"), "Candidate preserves perceptual source identity")

	var remembered_food = RuntimeWorldRef.entity(DomainId.entity(&"remembered_food"))
	var remembered_beliefs = BeliefStore.new()
	remembered_beliefs.restore_entry(
		BeliefProposition.new(EpistemicClaim.property_claim(remembered_food, edible, true)),
		0.75, 1, &"new_run_seed", &"memory"
	)
	var remembered_candidates: Array = _food_source(remembered_beliefs, edible, seek_food).generate()
	_check(remembered_candidates.size() == 1, "Authorized old memory may ground targeted destination")
	if remembered_candidates.size() == 1:
		_check(remembered_candidates[0].provenance.get("belief_modality", "") == "memory", "Memory stays distinct from recent observation")
		_check(remembered_candidates[0].provenance.get("belief_source_execution_id", "") == "new_run_seed", "Memory retains authored bootstrap source")

	if _failures.is_empty():
		print("PASS epistemic_destination_gating_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL epistemic_destination_gating_test: %d failure(s)" % _failures.size())
	quit(1)

func _food_source(beliefs, edible, seek_food):
	return DriveBackedBelievedOpportunityCandidateSource.new(
		DriveStub.new(), beliefs,
		[DriveCandidateDefinition.new(DriveState.HUNGER, seek_food, 0.1)],
		[PerceivedOpportunityDefinition.new(EpistemicClaim.Kind.PROPERTY, edible, seek_food, DecisionCandidate.Scope.INTENTIONAL, 0.1)]
	)

func _check(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)
