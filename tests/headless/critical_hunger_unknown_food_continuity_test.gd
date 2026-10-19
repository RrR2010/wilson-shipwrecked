extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const DriveState = preload("res://src/domain/cognition/drive_state.gd")
const DriveCandidateDefinition = preload("res://src/domain/cognition/drive_candidate_definition.gd")
const DriveCandidateSource = preload("res://src/domain/cognition/drive_candidate_source.gd")
const NeedDrivenInvestigationCandidateSource = preload("res://src/domain/cognition/need_driven_investigation_candidate_source.gd")
const BeliefProposition = preload("res://src/domain/cognition/belief_proposition.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const DriveBackedBelievedOpportunityCandidateSource = preload("res://src/domain/cognition/drive_backed_believed_opportunity_candidate_source.gd")
const BeliefStore = preload("res://src/domain/cognition/belief_store.gd")
const EpistemicClaim = preload("res://src/domain/cognition/epistemic_claim.gd")
const PerceivedOpportunityDefinition = preload("res://src/domain/cognition/perceived_opportunity_definition.gd")
const DecisionCandidate = preload("res://src/domain/cognition/decision_candidate.gd")

var _failures: Array[String] = []


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var drives = DriveState.new({DriveState.HUNGER: 0.99})
	var seek_food = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"seek_food")
	var investigate = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"seek_stimulation")
	var edible = DomainId.property(&"edible")
	var hunger = DriveCandidateDefinition.new(DriveState.HUNGER, seek_food, 0.10)
	var empty_beliefs = BeliefStore.new()
	var targeted = DriveBackedBelievedOpportunityCandidateSource.new(
		drives, empty_beliefs, [hunger],
		[PerceivedOpportunityDefinition.new(EpistemicClaim.Kind.PROPERTY, edible, seek_food, DecisionCandidate.Scope.INTENTIONAL, 0.10)]
	)
	_expect(targeted.generate().is_empty(), "Unknown food must never produce a target-specific food candidate")

	# Baseline scene intentionally omits unbound seek_food; a critical hunger
	# scenario needs a separate lawful information-seeking opportunity.
	# RED: with no discovered food and no exploration policy, no candidate survives.
	var curiosity = DomainId.property(&"interesting")
	var known_place = RuntimeWorldRef.entity(DomainId.entity(&"known_curiosity"))
	empty_beliefs.restore_entry(BeliefProposition.new(EpistemicClaim.property_claim(known_place, curiosity, true)), 0.85, 1, &"initial", &"memory")
	var scene_drive_source = NeedDrivenInvestigationCandidateSource.new(drives, empty_beliefs, edible, curiosity, investigate)
	var candidates = scene_drive_source.generate()
	candidates.append_array(targeted.generate())
	var has_investigation := false
	for candidate in candidates:
		if candidate.intention_id.equals(investigate):
			has_investigation = true
	_expect(has_investigation, "Critical hunger without known food should motivate an admissible investigation, not idle")
	_expect(candidates.size() == 1 and candidates[0].bindings.get_subject(&"target").equals(known_place), "Investigation must only target known curiosity")
	drives.set_value(DriveState.HUNGER, 0.1)
	_expect(scene_drive_source.generate().is_empty(), "No fallback investigation under low hunger")
	_finish()


func _expect(condition: bool, label: String) -> void:
	if not condition:
		_failures.append(label)


func _finish() -> void:
	if _failures.is_empty():
		print("PASS critical_hunger_unknown_food_continuity_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL critical_hunger_unknown_food_continuity_test: %d failure(s)" % _failures.size())
	quit(1)
