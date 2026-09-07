extends SceneTree

# Scenario placeholder intentionally fails until the smallest existing environment/context path
# is identified. This file records the representative pressure before any new semantic primitive
# is admitted.

func _init() -> void:
	push_error("FAIL environment_context_interruption_scenario_test: pressure not yet wired")
	print("FAIL environment_context_interruption_scenario_test: pressure not yet wired")
	quit(1)
