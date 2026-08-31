class_name ContentRegistry
extends RefCounted

## Validated authored-definition registry.
## Definitions may be registered only during bootstrap; seal() makes accidental
## runtime authoring mutation fail fast.

var _entity_definitions: Dictionary = {}
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


func entity_definition_ids() -> Array[String]:
	var result: Array[String] = []
	for definition in _entity_definitions.values():
		result.append(definition.id.sort_key())
	result.sort()
	return result
