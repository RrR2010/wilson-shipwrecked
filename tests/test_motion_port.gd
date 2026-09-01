extends RefCounted

func run() -> void:
	_test_motion_reports_semantic_progress_without_engine_frames()

func _test_motion_reports_semantic_progress_without_engine_frames() -> void:
	var motion := FakeMotionPort.new()
	assert(motion.request_move(&"wilson", &"coconut_17"))
	assert(motion.get_target(&"wilson") == &"coconut_17")
	assert(motion.get_status(&"wilson") == MotionPort.MotionStatus.MOVING)

	motion.set_status(&"wilson", MotionPort.MotionStatus.ARRIVED)
	assert(motion.get_status(&"wilson") == MotionPort.MotionStatus.ARRIVED)

	motion.cancel_move(&"wilson")
	assert(motion.get_status(&"wilson") == MotionPort.MotionStatus.CANCELLED)
