class_name ContentRegistry
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")
const EntityDefinition = preload("res://src/domain/content/entity_definition.gd")
const MutationResult = preload("res://src/domain/core/mutation_result.gd")

## Validated authored-definition registry.
## Definitions may be registered only during bootstrap; seal() makes accidental
## runtime authoring mutation fail fast.

var _entity_definitions: Dictionary = {}
var _property_definitions: Dictionary = {}
var _event_definitions: Dictionary = {}
var _action_definitions: Dictionary = {}
var _action_resolution_definitions: Dictionary = {}
var _sealed := false


func register_property_definition(definition) -> MutationResult:
	if _sealed:
		return MutationResult.failure(&"content_registry_sealed", ["Cannot register content after seal()"])
	assert(definition != null, "register_property_definition requires PropertyDefinition")
	definition.id.assert_kind(DomainId.Kind.PROPERTY)
	var definition_key = definition.id.key()
	if _property_definitions.has(definition_key):
		return MutationResult.failure(&"duplicate_property_definition", ["Duplicate property definition: %s" % definition.id.sort_key()])
	_property_definitions[definition_key] = definition
	return MutationResult.success(&"property_definition_registered", definition)


func register_event_definition(definition) -> MutationResult:
	if _sealed:
		return MutationResult.failure(&"content_registry_sealed", ["Cannot register content after seal()"])
	assert(definition != null, "register_event_definition requires EventDefinition")
	definition.id.assert_kind(DomainId.Kind.EVENT_DEFINITION)
	var definition_key = definition.id.key()
	if _event_definitions.has(definition_key):
		return MutationResult.failure(&"duplicate_event_definition", ["Duplicate event definition: %s" % definition.id.sort_key()])
	_event_definitions[definition_key] = definition
	return MutationResult.success(&"event_definition_registered", definition)


func register_entity_definition(definition: EntityDefinition) -> MutationResult:
	if _sealed:
		return MutationResult.failure(&"content_registry_sealed", ["Cannot register content after seal()"])
	assert(definition != null, "register_entity_definition requires EntityDefinition")
	var definition_key := definition.id.key()
	if _entity_definitions.has(definition_key):
		return MutationResult.failure(
			&"duplicate_entity_definition",
			["Duplicate entity definition: %s" % definition.id.sort_key()]
		)
	_entity_definitions[definition_key] = definition
	return MutationResult.success(&"entity_definition_registered", definition)


func register_action_definition(definition) -> MutationResult:
	if _sealed:
		return MutationResult.failure(&"content_registry_sealed", ["Cannot register content after seal()"])
	assert(definition != null, "register_action_definition requires ActionDefinition")
	definition.id.assert_kind(DomainId.Kind.ACTION)
	var definition_key = definition.id.key()
	if _action_definitions.has(definition_key):
		return MutationResult.failure(
			&"duplicate_action_definition",
			["Duplicate action definition: %s" % definition.id.sort_key()]
		)
	_action_definitions[definition_key] = definition
	return MutationResult.success(&"action_definition_registered", definition)


func register_action_resolution_definition(definition) -> MutationResult:
	if _sealed:
		return MutationResult.failure(&"content_registry_sealed", ["Cannot register content after seal()"])
	assert(definition != null, "register_action_resolution_definition requires ActionResolutionDefinition")
	definition.action_id.assert_kind(DomainId.Kind.ACTION)
	assert(definition.definition_id != &"", "ActionResolutionDefinition requires stable definition_id")
	if _action_resolution_definitions.has(definition.definition_id):
		return MutationResult.failure(
			&"duplicate_action_resolution_definition",
			["Duplicate action resolution definition: %s" % String(definition.definition_id)]
		)
	_action_resolution_definitions[definition.definition_id] = definition
	return MutationResult.success(&"action_resolution_definition_registered", definition)


func seal() -> MutationResult:
	if not _property_definitions.is_empty():
		for entity_definition in _entity_definitions.values():
			for property_key in entity_definition.base_property_keys():
				if not _property_definitions.has(property_key):
					return MutationResult.failure(&"missing_property_definition", ["Missing property definition for %s" % String(property_key)])
				var property_definition = _property_definitions[property_key]
				var value = entity_definition.get_base_property(property_definition.id)
				if not property_definition.validate_value(value):
					return MutationResult.failure(&"invalid_authored_property_value", ["Invalid value for %s on %s" % [property_definition.id.sort_key(), entity_definition.id.sort_key()]])
	if not _event_definitions.is_empty():
		for resolution in _action_resolution_definitions.values():
			if not _event_definitions.has(resolution.event_type.key()):
				return MutationResult.failure(&"missing_event_definition", ["Missing event definition for %s" % resolution.event_type.sort_key()])
	_sealed = true
	return MutationResult.success(&"content_registry_sealed")


func is_sealed() -> bool:
	return _sealed


func get_property_definition(property_id):
	assert(property_id != null, "get_property_definition requires PropertyId")
	property_id.assert_kind(DomainId.Kind.PROPERTY)
	return _property_definitions.get(property_id.key())


func validate_property_value(property_id, value: Variant) -> bool:
	var definition = get_property_definition(property_id)
	return definition == null or definition.validate_value(value)


func get_event_definition(event_id):
	assert(event_id != null, "get_event_definition requires EventDefinitionId")
	event_id.assert_kind(DomainId.Kind.EVENT_DEFINITION)
	return _event_definitions.get(event_id.key())


func get_entity_definition(type_id: DomainId) -> EntityDefinition:
	type_id.assert_kind(DomainId.Kind.ENTITY_TYPE)
	return _entity_definitions.get(type_id.key())


func has_entity_definition(type_id: DomainId) -> bool:
	type_id.assert_kind(DomainId.Kind.ENTITY_TYPE)
	return _entity_definitions.has(type_id.key())


func get_action_definition(action_id):
	assert(action_id != null, "get_action_definition requires ActionId")
	action_id.assert_kind(DomainId.Kind.ACTION)
	return _action_definitions.get(action_id.key())


func get_action_resolution_definition(definition_id: StringName):
	assert(definition_id != &"", "get_action_resolution_definition requires definition id")
	return _action_resolution_definitions.get(definition_id)


func entity_definition_ids() -> Array[String]:
	var result: Array[String] = []
	for definition in _entity_definitions.values():
		result.append(definition.id.sort_key())
	result.sort()
	return result


func property_definition_ids() -> Array[String]:
	var result: Array[String] = []
	for definition in _property_definitions.values():
		result.append(definition.id.sort_key())
	result.sort()
	return result


func event_definition_ids() -> Array[String]:
	var result: Array[String] = []
	for definition in _event_definitions.values():
		result.append(definition.id.sort_key())
	result.sort()
	return result


func action_definition_ids() -> Array[String]:
	var result: Array[String] = []
	for definition in _action_definitions.values():
		result.append(definition.id.sort_key())
	result.sort()
	return result


func action_resolution_definition_ids() -> Array[String]:
	var result: Array[String] = []
	for definition_id in _action_resolution_definitions.keys():
		result.append(String(definition_id))
	result.sort()
	return result
