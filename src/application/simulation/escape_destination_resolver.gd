class_name EscapeDestinationResolver
extends RefCounted

## Application-layer derived spatial query for emergency movement.
##
## Candidate destinations are authored RuntimeWorldRefs. Fine distance and route
## answers come from SpatialQueryPort; no scene-node identity crosses this boundary.

var _spatial_query
var _candidates: Array
var _minimum_distance_gain: float


func _init(spatial_query, candidates: Array, minimum_distance_gain: float = 0.25) -> void:
	assert(spatial_query != null, "EscapeDestinationResolver requires SpatialQueryPort")
	assert(is_finite(minimum_distance_gain) and minimum_distance_gain >= 0.0, "minimum distance gain must be finite and non-negative")
	_spatial_query = spatial_query
	_candidates = candidates.duplicate()
	_minimum_distance_gain = minimum_distance_gain
	for candidate in _candidates:
		assert(candidate != null, "escape destination candidates cannot contain null")


func resolve(actor_ref, threat_ref):
	if actor_ref == null or threat_ref == null:
		return null
	var baseline_distance: float = _spatial_query.metric_distance(actor_ref, threat_ref)
	if not is_finite(baseline_distance):
		return null

	var viable: Array = []
	for candidate in _candidates:
		if candidate.equals(actor_ref) or candidate.equals(threat_ref):
			continue
		if not _spatial_query.has_route(actor_ref, candidate):
			continue
		var threat_distance: float = _spatial_query.metric_distance(candidate, threat_ref)
		var route_cost: float = _spatial_query.route_cost(actor_ref, candidate)
		if not is_finite(threat_distance) or not is_finite(route_cost):
			continue
		if threat_distance < baseline_distance + _minimum_distance_gain:
			continue
		viable.append({
			"ref": candidate,
			"threat_distance": threat_distance,
			"route_cost": route_cost,
			"key": String(candidate.key()),
		})

	if viable.is_empty():
		return null
	viable.sort_custom(func(a, b):
		if not is_equal_approx(float(a.threat_distance), float(b.threat_distance)):
			return float(a.threat_distance) > float(b.threat_distance)
		if not is_equal_approx(float(a.route_cost), float(b.route_cost)):
			return float(a.route_cost) < float(b.route_cost)
		return String(a.key) < String(b.key)
	)
	return viable[0].ref
