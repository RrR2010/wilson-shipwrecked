extends RefCounted

var _stimuli: Dictionary


func _init(stimuli: Dictionary) -> void:
	_stimuli = stimuli.duplicate(true)


func resolve(_step) -> Dictionary:
	return _stimuli.duplicate(true)
