class_name AlreadyProtectedCandidateFilter
extends RefCounted

## Uses a spatial access projection solely to suppress redundant movement to
## cover. The candidate has already been justified by fresh weather perception.
var _spatial_query
var _actor
var _cover
var _max_distance: float


func _init(spatial_query, actor, cover, max_distance: float = 1.5) -> void:
	_spatial_query = spatial_query
	_actor = actor
	_cover = cover
	_max_distance = max_distance


func allows(_candidate) -> bool:
	return _spatial_query.metric_distance(_actor, _cover) > _max_distance
