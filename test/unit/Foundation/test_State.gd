extends GutTest

func test_state_constructor() -> void:
	var state: State = State.new("name", 1)

	assert_eq(state.get_name(), "name")
	assert_eq(state.get_value(), 1)
