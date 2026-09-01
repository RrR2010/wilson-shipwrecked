class_name PhysicalObservationPort
extends RefCounted

## Abstract boundary for engine-observed physical facts.
##
## Observations are typed inputs to consequence resolution; they are not themselves
## authoritative gameplay consequences.

func drain_observations() -> Array[PhysicalObservation]:
	push_error("PhysicalObservationPort.drain_observations() is abstract")
	return []
