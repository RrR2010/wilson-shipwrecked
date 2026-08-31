class_name SimulationStepTrace
extends RefCounted

## Diagnostic-only semantic trace.
## Never use trace data as gameplay authority. It exists so a headless run can
## answer: what happened, why was it considered, and what actually mutated?

var step_id
var inputs: Dictionary = {}
var stage_results: Dictionary = {}
var final_result


func _init(p_step_id) -> void:
	step_id = p_step_id


func record_input(name: StringName, value) -> void:
	inputs[name] = value


func record_result(stage: StringName, value) -> void:
	stage_results[stage] = value


func complete(result) -> void:
	final_result = result
