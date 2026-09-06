class_name RememberedRoutePreferenceService
extends RefCounted

## Derived Wilson-relative route evaluation.
##
## SpatialQueryPort supplies physical reachability/cost. AssociationStore supplies
## Wilson's remembered valence toward semantic route subjects. This service owns no
## state and never changes navigation truth.

var _spatial_query
var _associations
var _aversion_weight: float


func _init(spatial_query, association_store, aversion_weight: float = 1.0) -> void:
	assert(spatial_query != null, "RememberedRoutePreferenceService requires SpatialQueryPort")
	assert(association_store != null, "RememberedRoutePreferenceService requires AssociationStore")
	assert(is_finite(aversion_weight) and aversion_weight >= 0.0 and aversion_weight <= 2.0, "aversion_weight must be within [0,2]")
	_spatial_query = spatial_query
	_associations = association_store
	_aversion_weight = aversion_weight


func choose(actor_ref, options: Array):
	assert(actor_ref != null, "choose requires actor ref")
	var viable: Array = []
	for option in options:
		assert(option != null, "route options cannot contain null")
		var physical_cost := _route_cost(actor_ref, option.waypoints)
		if not is_finite(physical_cost):
			continue
		var aversion := _route_aversion(option.memory_subjects)
		var adjusted_cost := physical_cost * (1.0 + aversion * _aversion_weight)
		viable.append({
			"option": option,
			"physical_cost": physical_cost,
			"aversion": aversion,
			"adjusted_cost": adjusted_cost,
			"key": option.stable_key(),
		})
	if viable.is_empty():
		return null
	viable.sort_custom(func(a, b):
		if not is_equal_approx(float(a.adjusted_cost), float(b.adjusted_cost)):
			return float(a.adjusted_cost) < float(b.adjusted_cost)
		if not is_equal_approx(float(a.physical_cost), float(b.physical_cost)):
			return float(a.physical_cost) < float(b.physical_cost)
		return String(a.key) < String(b.key)
	)
	return viable[0].option


func evaluate(actor_ref, option) -> Dictionary:
	assert(actor_ref != null, "evaluate requires actor ref")
	assert(option != null, "evaluate requires route option")
	var physical_cost := _route_cost(actor_ref, option.waypoints)
	var aversion := _route_aversion(option.memory_subjects)
	return {
		"viable": is_finite(physical_cost),
		"physical_cost": physical_cost,
		"aversion": aversion,
		"adjusted_cost": INF if not is_finite(physical_cost) else physical_cost * (1.0 + aversion * _aversion_weight),
	}


func _route_cost(actor_ref, waypoints: Array) -> float:
	var current = actor_ref
	var total := 0.0
	for waypoint in waypoints:
		if not _spatial_query.has_route(current, waypoint):
			return INF
		var segment_cost: float = _spatial_query.route_cost(current, waypoint)
		if not is_finite(segment_cost):
			return INF
		total += segment_cost
		current = waypoint
	return total


func _route_aversion(subjects: Array) -> float:
	var strongest := 0.0
	for subject in subjects:
		var association = _associations.get_association(subject)
		if association == null:
			continue
		strongest = maxf(strongest, maxf(0.0, -float(association.get("valence", 0.0))))
	return strongest
