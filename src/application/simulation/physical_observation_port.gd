class_name PhysicalObservationPort
extends RefCounted

## Abstract boundary for engine-observed physical facts.
##
## These observations are inputs to domain consequence resolution; they are not
## themselves authoritative gameplay consequences.

func drain_observations() -> Array[Dictionary]:
	push_error("PhysicalObservationPort.drain_observations() is abstract")
	return []
