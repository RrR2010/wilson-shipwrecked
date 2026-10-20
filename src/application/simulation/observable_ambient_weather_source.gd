class_name ObservableAmbientWeatherSource
extends RefCounted

const PerceptionResult = preload("res://src/domain/cognition/perception_result.gd")
const PerceptualEvidence = preload("res://src/domain/cognition/perceptual_evidence.gd")
const EpistemicClaim = preload("res://src/domain/cognition/epistemic_claim.gd")

## Weather authority is read only here, at an authored ambient-sensing boundary.
## The signal is a fresh Wilson-accessible observation, not a cognition World read.
## Reprojection each step also reconstructs the cue after restore.
var _environment
var _observer
var _property_id
var _sequence := 0


func _init(environment, observer, property_id) -> void:
	_environment = environment
	_observer = observer
	_property_id = property_id


func collect(_step = null):
	_sequence += 1
	var raining: bool = _environment.weather == &"rain"
	var evidence = PerceptualEvidence.new(
		EpistemicClaim.property_claim(_observer, _property_id, raining),
		0.95, StringName("ambient_weather_%d" % _sequence), &"ambient"
	)
	return PerceptionResult.new([], [evidence])
