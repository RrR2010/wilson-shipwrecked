class_name CompositePerceptionTriggerSource
extends RefCounted

## Deterministically combines independent perception-derived reconsideration sources
## without expanding SimulationOrchestrator's constructor for each new trigger family.

var _sources: Array = []


func _init(sources: Array) -> void:
	for source in sources:
		assert(source != null and source.has_method("derive"), "Composite perception trigger sources must implement derive(perception_result)")
		_sources.append(source)


func derive(perception_result) -> Array[int]:
	assert(perception_result != null, "derive requires PerceptionResult")
	var seen: Dictionary = {}
	for source in _sources:
		for raw_trigger in source.derive(perception_result):
			seen[int(raw_trigger)] = true
	var result: Array[int] = []
	for raw_trigger in seen.keys():
		result.append(int(raw_trigger))
	result.sort()
	return result
