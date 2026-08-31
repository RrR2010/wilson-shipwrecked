class_name DomainId
extends RefCounted

## Lightweight nominal semantic ID.
##
## The wrapper exists for boundary validation and diagnostics. Stores/indexes should
## use key() rather than object identity so reconstructing an equivalent ID never
## changes lookup semantics.

enum Kind {
	ENTITY,
	ENTITY_TYPE,
	PLACE,
	REGION,
	PROPERTY,
	CAPABILITY,
	CATEGORY,
	RELATION_TYPE,
	ACTION,
	ROLE,
	INTERACTION_RULE,
	TRANSFORMATION,
	KNOWLEDGE,
	SEMANTIC_INTENTION,
	PROJECT_DEFINITION,
	PROJECT_INSTANCE,
	EVENT_DEFINITION,
	EVENT_INSTANCE,
	SEMANTIC_CONCEPT,
}

var kind: int
var value: StringName


func _init(p_kind: int, p_value: StringName) -> void:
	assert(p_kind >= 0 and p_kind < Kind.size(), "Invalid DomainId kind")
	assert(p_value != &"", "DomainId value cannot be empty")
	kind = p_kind
	value = p_value


func key() -> StringName:
	return StringName("%s:%s" % [kind_name(), String(value)])


func sort_key() -> String:
	return String(key())


func equals(other) -> bool:
	return other != null and kind == other.kind and value == other.value


func assert_kind(expected_kind: int) -> void:
	assert(kind == expected_kind, "Expected %s, got %s" % [_kind_name(expected_kind), kind_name()])


func kind_name() -> String:
	return _kind_name(kind)


func _to_string() -> String:
	return "%s(%s)" % [kind_name(), String(value)]


static func _kind_name(p_kind: int) -> String:
	match p_kind:
		Kind.ENTITY: return "EntityId"
		Kind.ENTITY_TYPE: return "EntityTypeId"
		Kind.PLACE: return "PlaceId"
		Kind.REGION: return "RegionId"
		Kind.PROPERTY: return "PropertyId"
		Kind.CAPABILITY: return "CapabilityId"
		Kind.CATEGORY: return "CategoryId"
		Kind.RELATION_TYPE: return "RelationTypeId"
		Kind.ACTION: return "ActionId"
		Kind.ROLE: return "RoleId"
		Kind.INTERACTION_RULE: return "InteractionRuleId"
		Kind.TRANSFORMATION: return "TransformationId"
		Kind.KNOWLEDGE: return "KnowledgeId"
		Kind.SEMANTIC_INTENTION: return "SemanticIntentionId"
		Kind.PROJECT_DEFINITION: return "ProjectDefinitionId"
		Kind.PROJECT_INSTANCE: return "ProjectInstanceId"
		Kind.EVENT_DEFINITION: return "EventDefinitionId"
		Kind.EVENT_INSTANCE: return "EventInstanceId"
		Kind.SEMANTIC_CONCEPT: return "SemanticConceptId"
		_: return "UnknownDomainId"


static func entity(p_value: StringName):
	return new(Kind.ENTITY, p_value)


static func entity_type(p_value: StringName):
	return new(Kind.ENTITY_TYPE, p_value)


static func place(p_value: StringName):
	return new(Kind.PLACE, p_value)


static func region(p_value: StringName):
	return new(Kind.REGION, p_value)


static func property(p_value: StringName):
	return new(Kind.PROPERTY, p_value)


static func capability(p_value: StringName):
	return new(Kind.CAPABILITY, p_value)


static func category(p_value: StringName):
	return new(Kind.CATEGORY, p_value)


static func relation_type(p_value: StringName):
	return new(Kind.RELATION_TYPE, p_value)


static func action(p_value: StringName):
	return new(Kind.ACTION, p_value)


static func role(p_value: StringName):
	return new(Kind.ROLE, p_value)
