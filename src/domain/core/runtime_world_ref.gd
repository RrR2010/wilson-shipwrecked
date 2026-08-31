class_name RuntimeWorldRef
extends RefCounted

const DomainId = preload("res://src/domain/core/domain_id.gd")

## Stable reference to an authoritative runtime world subject.
## Wilson is explicit; entity/place/region refs carry the matching DomainId kind.

enum Kind {
	WILSON,
	ENTITY,
	PLACE,
	REGION,
}

var kind: int
var id


func _init(p_kind: int, p_id = null) -> void:
	kind = p_kind
	id = p_id
	match kind:
		Kind.WILSON:
			assert(id == null, "Wilson RuntimeWorldRef must not carry a DomainId")
		Kind.ENTITY:
			assert(id != null, "Entity RuntimeWorldRef requires an EntityId")
			id.assert_kind(DomainId.Kind.ENTITY)
		Kind.PLACE:
			assert(id != null, "Place RuntimeWorldRef requires a PlaceId")
			id.assert_kind(DomainId.Kind.PLACE)
		Kind.REGION:
			assert(id != null, "Region RuntimeWorldRef requires a RegionId")
			id.assert_kind(DomainId.Kind.REGION)
		_:
			assert(false, "Unsupported RuntimeWorldRef kind")


func key() -> StringName:
	match kind:
		Kind.WILSON:
			return &"wilson"
		_:
			return StringName("%s:%s" % [kind_name(), String(id.value)])


func sort_key() -> String:
	return String(key())


func equals(other) -> bool:
	if other == null or kind != other.kind:
		return false
	if kind == Kind.WILSON:
		return true
	return id.equals(other.id)


func kind_name() -> String:
	match kind:
		Kind.WILSON: return "Wilson"
		Kind.ENTITY: return "Entity"
		Kind.PLACE: return "Place"
		Kind.REGION: return "Region"
		_: return "UnknownRuntimeWorldRef"


func _to_string() -> String:
	if kind == Kind.WILSON:
		return "Wilson"
	return "%s(%s)" % [kind_name(), String(id.value)]


static func wilson():
	return new(Kind.WILSON)


static func entity(p_id):
	p_id.assert_kind(DomainId.Kind.ENTITY)
	return new(Kind.ENTITY, p_id)


static func place(p_id):
	p_id.assert_kind(DomainId.Kind.PLACE)
	return new(Kind.PLACE, p_id)


static func region(p_id):
	p_id.assert_kind(DomainId.Kind.REGION)
	return new(Kind.REGION, p_id)
