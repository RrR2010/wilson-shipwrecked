extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const EpistemicClaim = preload("res://src/domain/cognition/epistemic_claim.gd")
const PerceptualEvidence = preload("res://src/domain/cognition/perceptual_evidence.gd")
const PerceptionResult = preload("res://src/domain/cognition/perception_result.gd")
const BeliefStore = preload("res://src/domain/cognition/belief_store.gd")
const BeliefLearningService = preload("res://src/domain/cognition/belief_learning_service.gd")
const AssociationStore = preload("res://src/domain/cognition/association_store.gd")
const HabitStore = preload("res://src/domain/cognition/habit_store.gd")
const EpisodeStore = preload("res://src/domain/cognition/episode_store.gd")
const PresenceRelationship = preload("res://src/domain/cognition/presence_relationship.gd")
const ExperienceLearningRule = preload("res://src/domain/cognition/experience_learning_rule.gd")
const ExperienceLearningService = preload("res://src/domain/cognition/experience_learning_service.gd")
const BeliefLearningCoordinator = preload("res://src/application/simulation/belief_learning_coordinator.gd")
const WilsonLearningCoordinator = preload("res://src/application/simulation/wilson_learning_coordinator.gd")

var _failures: Array[String] = []
var _completed := false


func _init() -> void:
	_run_slice()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS learning_state_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL learning_state_test: %d failure(s)" % _failures.size())
	quit(1)


func _run_slice() -> void:
	var gerald = RuntimeWorldRef.entity(DomainId.entity(&"gerald"))
	var interference = DomainId.event_definition(&"gerald_interference")
	var protect_food = DomainId.new(DomainId.Kind.SEMANTIC_INTENTION, &"protect_food")
	var rule = ExperienceLearningRule.new(
		interference,
		&"culprit",
		-0.6,
		0.5,
		0.9,
		&"gerald_near_food",
		protect_food,
		&"culprit",
		0.6,
		0.5,
		-0.4,
		0.2
	)
	var evidence = PerceptualEvidence.new(
		EpistemicClaim.event_claim(gerald, interference, &"culprit"),
		0.8,
		&"exec_gerald_1",
		&"vision"
	)
	var beliefs = BeliefStore.new()
	var associations = AssociationStore.new()
	var habits = HabitStore.new()
	var episodes = EpisodeStore.new(4, 0.35)
	var presence = PresenceRelationship.new()
	var coordinator = WilsonLearningCoordinator.new(
		BeliefLearningCoordinator.new(BeliefLearningService.new(), beliefs),
		ExperienceLearningService.new([rule]),
		associations,
		habits,
		episodes,
		presence
	)

	coordinator.process(PerceptionResult.new([], [evidence]))
	_expect_equal(beliefs.entries().size(), 1, "perceived event still enters belief learning")
	var association = associations.get(gerald)
	_expect_true(association != null, "event produces subject association")
	if association != null:
		_expect_true(float(association["valence"]) < 0.0, "negative experience lowers valence")
		_expect_true(float(association["attachment"]) > 0.0, "negative repeated relevance can still increase attachment")
	_expect_equal(habits.entries().size(), 1, "event can reinforce one bounded habit")
	_expect_equal(episodes.entries().size(), 1, "important event consolidates one episode")
	_expect_true(presence.presence_belief > 0.0, "attributed experience can increase Presence belief")
	_expect_true(presence.trust < 0.0, "harmful attributed experience can reduce Presence trust")
	_expect_true(presence.dependency > 0.0, "Presence dependency remains independent dimension")

	for index in range(20):
		var repeated = PerceptualEvidence.new(
			EpistemicClaim.event_claim(gerald, interference, &"culprit"),
			1.0,
			StringName("exec_repeat_%02d" % index),
			&"vision"
		)
		coordinator.process(PerceptionResult.new([], [repeated]))
	association = associations.get(gerald)
	_expect_true(float(association["valence"]) >= -1.0 and float(association["valence"]) <= 1.0, "association valence remains bounded")
	_expect_true(float(association["attachment"]) >= 0.0 and float(association["attachment"]) <= 1.0, "association attachment remains bounded")
	var habit = habits.entries()[0]
	_expect_true(float(habit["strength"]) >= 0.0 and float(habit["strength"]) <= 1.0, "habit strength remains bounded")
	_expect_true(presence.presence_belief >= 0.0 and presence.presence_belief <= 1.0, "Presence belief remains bounded")
	_expect_true(presence.trust >= -1.0 and presence.trust <= 1.0, "Presence trust remains bounded")
	_expect_true(presence.dependency >= 0.0 and presence.dependency <= 1.0, "Presence dependency remains bounded")
	_expect_equal(episodes.entries().size(), 4, "episode store remains bounded under many important experiences")

	var insignificant_rule = ExperienceLearningRule.new(DomainId.event_definition(&"ordinary_noise"), &"source", 0.0, 0.0, 0.1)
	var insignificant_service = ExperienceLearningService.new([insignificant_rule])
	var noise = PerceptualEvidence.new(
		EpistemicClaim.event_claim(gerald, DomainId.event_definition(&"ordinary_noise"), &"source"),
		1.0,
		&"exec_noise",
		&"hearing"
	)
	var proposals: Dictionary = insignificant_service.derive(noise)
	_expect_equal(proposals["episode_candidates"].size(), 1, "low-importance event may propose episode")
	_expect_false(episodes.consider(proposals["episode_candidates"][0]), "episode owner rejects insignificant candidate")

	_completed = true


func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)


func _expect_false(actual: bool, label: String) -> void:
	if actual:
		_failures.append("Expected false: %s" % label)


func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
