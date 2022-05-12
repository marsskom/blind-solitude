extends GutTest

func test_signals() -> void:
	var state: TestCustomState = TestCustomState.new("name", 1, "activated", "changed")
	state.connect("activated", self, "_state_on_activated")
	state.connect("changed", self, "_state_on_changed")

	var second_state: TestCustomState = TestCustomState.new(
		"second", 1, "second activated", "second changed"
	)
	second_state.connect("activated", self, "_state_second_on_activated")
	second_state.connect("changed", self, "_state_second_on_changed")

	var stateMachine: StateMachine = StateMachine.new(state)
	stateMachine.change(second_state)
	stateMachine.change(State.new("mock", 12))

func _state_on_activated(message) -> void:
	assert_eq(message, "activated")

func _state_on_changed(message) -> void:
	assert_eq(message, "changed")

func _state_second_on_activated(message) -> void:
	assert_eq(message, "second activated")

func _state_second_on_changed(message) -> void:
	assert_eq(message, "second changed")
