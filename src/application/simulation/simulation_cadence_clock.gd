class_name SimulationCadenceClock
extends RefCounted

## Accumulates fine-grained engine time and exposes deterministic coarse simulation steps.
##
## Rendering/physics may tick at any cadence. Authoritative simulation consumes fixed-size
## semantic steps so cognition and slow systems do not inherit render-frame timing.

var step_seconds: float
var _accumulator_seconds: float = 0.0

func _init(p_step_seconds: float = 0.1) -> void:
	assert(is_finite(p_step_seconds) and p_step_seconds > 0.0)
	step_seconds = p_step_seconds

func advance(delta_seconds: float) -> int:
	assert(is_finite(delta_seconds) and delta_seconds >= 0.0)
	_accumulator_seconds += delta_seconds
	var due_steps := int(floor((_accumulator_seconds + 1.0e-9) / step_seconds))
	if due_steps > 0:
		_accumulator_seconds -= float(due_steps) * step_seconds
		if _accumulator_seconds < 0.0 and absf(_accumulator_seconds) <= 1.0e-8:
			_accumulator_seconds = 0.0
	return due_steps

func remaining_seconds() -> float:
	return _accumulator_seconds

func reset() -> void:
	_accumulator_seconds = 0.0
