extends SceneTree

const DomainId = preload("res://src/domain/core/domain_id.gd")
const RuntimeWorldRef = preload("res://src/domain/core/runtime_world_ref.gd")
const RoleBinding = preload("res://src/domain/actions/role_binding.gd")
const ActionOutcome = preload("res://src/domain/actions/action_outcome.gd")
const WorldCommitResult = preload("res://src/domain/world/world_commit_result.gd")
const DriveState = preload("res://src/domain/cognition/drive_state.gd")
const DriveConsequenceDefinition = preload("res://src/domain/cognition/drive_consequence_definition.gd")
const GroundedDriveConsequenceService = preload("res://src/application/simulation/grounded_drive_consequence_service.gd")

var _failures: Array[String] = []
var _completed := false


func _init() -> void:
	_run()
	if not _completed:
		_failures.append("Test body did not complete; check runtime errors above")
	if _failures.is_empty():
		print("PASS grounded_drive_consequence_test")
		quit(0)
		return
	for failure in _failures:
		push_error(failure)
	print("FAIL grounded_drive_consequence_test: %d failure(s)" % _failures.size())
	quit(1)


func _run() -> void:
	var consume = DomainId.action(&"consume")
	var inspect = DomainId.action(&"inspect")
	var consumed = DomainId.event_definition(&"food_consumed")
	var inspected = DomainId.event_definition(&"food_inspected")
	var food = RuntimeWorldRef.entity(DomainId.entity(&"food_1"))
	var bindings = RoleBinding.new()
	bindings.bind(&"actor", RuntimeWorldRef.wilson())
	bindings.bind(&"target", food)

	var drives = DriveState.new({DriveState.HUNGER: 0.65})
	var definition = DriveConsequenceDefinition.new(consume, DriveState.HUNGER, -0.35, consumed)
	var service = GroundedDriveConsequenceService.new(drives, [definition])
	var grounded = WorldCommitResult.new(true, [], [])
	var rejected = WorldCommitResult.new(false, [], [], ["rejected"])

	var consume_outcome = ActionOutcome.new(&"consume_1", consume, bindings, [], consumed)
	var rejected_result = service.apply_grounded(consume_outcome, rejected)
	_expect_true(rejected_result.ok, "rejected World commit is a non-mutating consequence result")
	_expect_equal(rejected_result.code, &"drive_consequence_not_grounded", "rejected World commit is explicitly not grounded")
	_expect_float(drives.value(DriveState.HUNGER), 0.65, "rejected World commit cannot change hunger")

	var applied = service.apply_grounded(consume_outcome, grounded)
	_expect_true(applied.ok, "grounded consume applies drive consequence")
	_expect_equal(applied.code, &"drive_consequence_applied", "matching grounded outcome reports applied consequence")
	_expect_float(drives.value(DriveState.HUNGER), 0.30, "grounded consumption reduces hunger")
	_expect_equal(applied.value.size(), 1, "one matching consequence produces one mutation record")
	if applied.value.size() == 1:
		_expect_equal(applied.value[0].get("drive_id"), DriveState.HUNGER, "mutation record identifies hunger")
		_expect_float(applied.value[0].get("previous"), 0.65, "mutation record preserves previous value")
		_expect_float(applied.value[0].get("current"), 0.30, "mutation record exposes current value")

	var duplicate = service.apply_grounded(consume_outcome, grounded)
	_expect_equal(duplicate.code, &"drive_consequence_already_applied", "same execution is idempotent")
	_expect_float(drives.value(DriveState.HUNGER), 0.30, "duplicate grounded delivery does not reduce hunger twice")

	var wrong_event = ActionOutcome.new(&"consume_wrong_event", consume, bindings, [], inspected)
	_expect_equal(service.apply_grounded(wrong_event, grounded).code, &"drive_consequence_no_match", "event-qualified definition rejects wrong event")
	_expect_float(drives.value(DriveState.HUNGER), 0.30, "wrong event cannot change hunger")

	var unrelated = ActionOutcome.new(&"inspect_1", inspect, bindings, [], inspected)
	_expect_equal(service.apply_grounded(unrelated, grounded).code, &"drive_consequence_no_match", "unrelated action does not manufacture drive consequence")
	_expect_float(drives.value(DriveState.HUNGER), 0.30, "unrelated action leaves hunger unchanged")

	var low_drives = DriveState.new({DriveState.HUNGER: 0.10})
	var clamp_service = GroundedDriveConsequenceService.new(low_drives, [definition])
	var clamped = clamp_service.apply_grounded(ActionOutcome.new(&"consume_clamped", consume, bindings, [], consumed), grounded)
	_expect_true(clamped.ok, "bounded consequence applies near lower limit")
	_expect_float(low_drives.value(DriveState.HUNGER), 0.0, "drive consequence clamps at zero")

	_completed = true


func _expect_true(actual: bool, label: String) -> void:
	if not actual:
		_failures.append("Expected true: %s" % label)


func _expect_equal(actual: Variant, expected: Variant, label: String) -> void:
	if actual != expected:
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])


func _expect_float(actual: Variant, expected: float, label: String) -> void:
	if actual == null or not is_equal_approx(float(actual), expected):
		_failures.append("%s | expected=%s actual=%s" % [label, expected, actual])
