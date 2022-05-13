extends GutTest

func test_signals() -> void:
	var state: TestCustomState = TestCustomState.new("name", 1)
	state.connect("activated", self, "_state_on_activated")
	state.connect("changed", self, "_state_on_changed")

	var second_state: TestCustomState = TestCustomState.new(
		"second", 2, "second activated", "second changed"
	)
	second_state.connect("activated", self, "_state_second_on_activated")
	second_state.connect("changed", self, "_state_second_on_changed")

	var stateMachine: StateMachine = StateMachine.new(state)
	stateMachine.change(second_state)
	stateMachine.change(
		TestCustomState.new(
			"third", 3, "second activated", "second changed"
		)
	)

func _state_on_activated(message) -> void:
	assert_eq(message, "activated")

func _state_on_changed(message) -> void:
	assert_eq(message, "changed")

func _state_second_on_activated(message) -> void:
	assert_eq(message, "second activated")

func _state_second_on_changed(message) -> void:
	assert_eq(message, "second changed")
