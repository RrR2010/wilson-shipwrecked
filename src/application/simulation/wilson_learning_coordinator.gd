class_name WilsonLearningCoordinator
extends RefCounted

var _belief_learning
var _experience_learning
var _associations
var _habits
var _episodes


func _init(belief_learning, experience_learning, associations, habits, episodes) -> void:
	assert(belief_learning != null, "WilsonLearningCoordinator requires belief learning coordinator")
	assert(experience_learning != null, "WilsonLearningCoordinator requires experience learning service")
	assert(associations != null, "WilsonLearningCoordinator requires AssociationStore")
	assert(habits != null, "WilsonLearningCoordinator requires HabitStore")
	assert(episodes != null, "WilsonLearningCoordinator requires EpisodeStore")
	_belief_learning = belief_learning
	_experience_learning = experience_learning
	_associations = associations
	_habits = habits
	_episodes = episodes


func process(perception_result) -> Dictionary:
	assert(perception_result != null, "process requires PerceptionResult")
	var belief_result = _belief_learning.process(perception_result)
	var association_results: Array = []
	var habit_results: Array = []
	var episode_results: Array = []
	for perceptual_evidence in perception_result.evidence:
		var proposals: Dictionary = _experience_learning.derive(perceptual_evidence)
		for impact in proposals["association_impacts"]:
			association_results.append(_associations.apply_impact(impact))
		for evidence in proposals["habit_evidence"]:
			habit_results.append(_habits.apply_evidence(evidence))
		for candidate in proposals["episode_candidates"]:
			episode_results.append(_episodes.consider(candidate))
	return {
		"belief": belief_result,
		"association_results": association_results,
		"habit_results": habit_results,
		"episode_results": episode_results,
	}
