class_name WorldQuery
extends RefCounted

## Narrow read-only port into authoritative World truth.
##
## Derived services should depend on this kind of query surface rather than on a
## WorldState/EntityStore Dictionary. Concrete world storage remains replaceable.

func get_instance_property(_subject, _property_id):
	assert(false, "WorldQuery.get_instance_property must be implemented")


func has_authored_capability(_subject, _capability_id) -> bool:
	assert(false, "WorldQuery.has_authored_capability must be implemented")
	return false


func has_category(_subject, _category_id) -> bool:
	assert(false, "WorldQuery.has_category must be implemented")
	return false


func find_relations(_relation_type = null, _subject = null, _object = null) -> Array:
	assert(false, "WorldQuery.find_relations must be implemented")
	return []


func query_nearby(_subject_or_place, _constraints) -> Array:
	assert(false, "WorldQuery.query_nearby must be implemented")
	return []
