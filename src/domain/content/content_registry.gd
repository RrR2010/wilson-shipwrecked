class_name ContentRegistry
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")
const EntityDefinition = preload("res://src/domain/content/entity_definition.gd")
const MutationResult = preload("res://src/domain/core/mutation_result.gd")

## Validated authored-definition registry.
## Definitions may be registered only during bootstrap; seal() makes accidental
## runtime authoring mutation fail fast.

var _entity_definitions: Dictionary = {}
var _action_definitions: Dictionary = {}
var _action_resolution_definitions: Dictionary = {}
var _sealed := false


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
	_sealed = true
	return MutationResult.success(&"content_registry_sealed")


func is_sealed() -> bool:
	return _sealed


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
