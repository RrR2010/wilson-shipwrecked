class_name EffectivePropertyValueResolver
extends RefCounted

## Shared read boundary for consumers that need the current effective value of a
## physical property without knowing whether it is authored World truth or a
## reconstructible EffectivePhysicalProfile output.
##
## Derived values take precedence when the profile defines the requested property;
## otherwise the resolver falls back to ordinary WorldQuery property truth.

var _world_query
var _physical_profiles


func _init(world_query, physical_profiles = null) -> void:
	assert(world_query != null, "EffectivePropertyValueResolver requires WorldQuery")
	_world_query = world_query
	_physical_profiles = physical_profiles


func get_value(subject, property_id):
	assert(subject != null, "get_value requires subject")
	assert(property_id != null, "get_value requires property id")
	if _physical_profiles != null:
		var profile = _physical_profiles.resolve(subject)
		if profile.has_property(property_id):
			return profile.get_property(property_id)
	return _world_query.get_instance_property(subject, property_id)


func explain_value(subject, property_id) -> Dictionary:
	assert(subject != null, "explain_value requires subject")
	assert(property_id != null, "explain_value requires property id")
	if _physical_profiles != null:
		var profile = _physical_profiles.resolve(subject)
		if profile.has_property(property_id):
			return {
				"present": true,
				"value": profile.get_property(property_id),
				"source": &"effective_profile",
			}
	var value = _world_query.get_instance_property(subject, property_id)
	return {
		"present": value != null,
		"value": value,
		"source": &"world_query",
	}
