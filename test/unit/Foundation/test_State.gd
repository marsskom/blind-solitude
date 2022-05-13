extends GutTest

func test_state_constructor() -> void:
	var state: TestCustomState = TestCustomState.new("Idle", 0)

	assert_eq(state.get_name(), "Idle")
	assert_eq(state.get_value(), 0)

func test_state_export_vars() -> void:
	var state: TestCustomState = TestCustomState.new("Move", 1)

	assert_eq(state.get_name(), "Move")
	assert_eq(state.get_value(), 1)
