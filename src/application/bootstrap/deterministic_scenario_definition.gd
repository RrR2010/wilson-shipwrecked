class_name DeterministicScenarioDefinition
extends RefCounted

var scenario_name: StringName
var gameplay_seed: int
var simulation

func _init(p_scenario_name: StringName, p_gameplay_seed: int, p_simulation) -> void:
	assert(p_scenario_name != &"", "DeterministicScenarioDefinition requires scenario name")
	assert(p_simulation != null, "DeterministicScenarioDefinition requires simulation bootstrap definition")
	scenario_name = p_scenario_name
	gameplay_seed = p_gameplay_seed
	simulation = p_simulation
