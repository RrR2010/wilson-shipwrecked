class_name AlreadyProtectedCandidateFilter
extends RefCounted

const ProjectInstance = preload("res://src/domain/projects/project_instance.gd")

## The calibration shelter is not protective merely because Wilson is near its
## construction marker. Require grounded project completion plus local proximity.
## No World weather lookup or persistent protection flag is introduced.
var _spatial_query
var _actor
var _cover
var _max_distance: float
var _projects
var _project_id


func _init(spatial_query, actor, cover, max_distance: float = 1.5, projects = null, project_id = null) -> void:
	_spatial_query = spatial_query
	_actor = actor
	_cover = cover
	_max_distance = max_distance
	_projects = projects
	_project_id = project_id


func allows(_candidate) -> bool:
	if _projects != null and _project_id != null:
		var shelter = _projects.get_instance(_project_id)
		if shelter == null or shelter.lifecycle != ProjectInstance.Lifecycle.COMPLETED:
			return true
	return _spatial_query.metric_distance(_actor, _cover) > _max_distance
