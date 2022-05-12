extends GutTest

func test_state_init() -> void:
	var state: State = State.new("mock", 1)
	var stateMachine: StateMachine = StateMachine.new(state)

	assert_eq(state.get_name(), stateMachine.get_state().get_name())

func test_state_change() -> void:
	var stateMachine: StateMachine = StateMachine.new(State.new("first", 1))
	var state: State = State.new("second", 2)

	stateMachine.change(state)
	assert_eq(state.get_name(), stateMachine.get_state().get_name())

func test_history() -> void:
	var stateMachine: StateMachine = StateMachine.new(State.new("fake state", 0))

	var states: Array = [];
	for i in range(0, stateMachine.max_history_count + 1):
		states.push_back(State.new("mock%d" % i, i))
		stateMachine.change(states[i])

	assert_eq("mock%d" % stateMachine.max_history_count, stateMachine.get_state().get_name())

	stateMachine.change(State.new("last", 9))

	# Returns back to first state
	for i in range(0, stateMachine.max_history_count):
		stateMachine.back()

	# Asserts with "mock1" because "mock0" was deleted from history
	assert_eq("mock1", stateMachine.get_state().get_name())
