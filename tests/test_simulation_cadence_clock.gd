extends RefCounted

func run() -> void:
	_test_accumulates_engine_frames_into_fixed_steps()
	_test_large_delta_emits_multiple_steps()
	_test_same_elapsed_time_is_frame_partition_independent()

func _test_accumulates_engine_frames_into_fixed_steps() -> void:
	var clock := SimulationCadenceClock.new(0.1)
	for _i in range(5):
		assert(clock.advance(1.0 / 60.0) == 0)
	assert(clock.advance(1.0 / 60.0) == 1)
	assert(absf(clock.remaining_seconds()) < 1.0e-6)

func _test_large_delta_emits_multiple_steps() -> void:
	var clock := SimulationCadenceClock.new(0.1)
	assert(clock.advance(0.35) == 3)
	assert(absf(clock.remaining_seconds() - 0.05) < 1.0e-6)

func _test_same_elapsed_time_is_frame_partition_independent() -> void:
	var sixty_hz := SimulationCadenceClock.new(0.1)
	var thirty_hz := SimulationCadenceClock.new(0.1)
	var sixty_steps := 0
	var thirty_steps := 0
	for _i in range(60):
		sixty_steps += sixty_hz.advance(1.0 / 60.0)
	for _i in range(30):
		thirty_steps += thirty_hz.advance(1.0 / 30.0)
	assert(sixty_steps == 10)
	assert(thirty_steps == 10)
	assert(absf(sixty_hz.remaining_seconds() - thirty_hz.remaining_seconds()) < 1.0e-6)
