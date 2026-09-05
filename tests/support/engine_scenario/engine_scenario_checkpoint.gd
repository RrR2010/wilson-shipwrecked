class_name EngineScenarioCheckpoint
extends RefCounted

## Immutable semantic checkpoint record emitted by EngineScenarioHarness.
## The harness does not interpret probe payloads; scenario code owns probe meaning.

var name: StringName
var instruction: String
var simulation_time: float
var semantic_step: int
var physics_frame: int
var probes: Dictionary


func _init(
	p_name: StringName,
	p_instruction: String = "",
	p_simulation_time: float = -1.0,
	p_semantic_step: int = -1,
	p_physics_frame: int = -1,
	p_probes: Dictionary = {}
) -> void:
	assert(p_name != &"", "EngineScenarioCheckpoint requires a semantic name")
	name = p_name
	instruction = p_instruction
	simulation_time = p_simulation_time
	semantic_step = p_semantic_step
	physics_frame = p_physics_frame
	probes = p_probes.duplicate(true)


func describe() -> Dictionary:
	return {
		"type": "checkpoint",
		"name": String(name),
		"instruction": instruction,
		"simulation_time": simulation_time,
		"semantic_step": semantic_step,
		"physics_frame": physics_frame,
		"probes": probes.duplicate(true),
	}
