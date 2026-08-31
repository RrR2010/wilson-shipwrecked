class_name WorldCommandPort
extends RefCounted

## Explicit mutation port owned by World.
##
## Derived services must return proposals/results; only application orchestration
## or a named owner transaction should invoke these commands.

func create_relation(_relation_type, _subject, _object, _qualifier = null):
	assert(false, "WorldCommandPort.create_relation must be implemented")


func remove_relation(_relation_type, _subject, _object):
	assert(false, "WorldCommandPort.remove_relation must be implemented")


func set_instance_property(_entity_id, _property_id, _value):
	assert(false, "WorldCommandPort.set_instance_property must be implemented")


func transform_entity(_entity_id, _transformation_id):
	assert(false, "WorldCommandPort.transform_entity must be implemented")
