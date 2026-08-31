class_name PerceptionAccessResolver
extends RefCounted

## Application-facing port for deriving Wilson's sensory access to committed
## WorldEvents. Concrete spatial/hearing/occlusion implementations belong outside
## the cognition truth model.

func resolve(_world_events: Array, _step_context) -> Dictionary:
	assert(false, "PerceptionAccessResolver.resolve must be implemented")
	return {}
