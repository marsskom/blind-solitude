extends GutTest

func test_state_init() -> void:
	var state: TestCustomState = TestCustomState.new("Idle", 0)
	var stateMachine: StateMachine = StateMachine.new(state)

	assert_eq(state.get_name(), stateMachine.get_state().get_name())

func test_state_change() -> void:
	var state: TestCustomState = TestCustomState.new("Idle", 0)

	var stateMachine: StateMachine = StateMachine.new(state)
	state = TestCustomState.new("Move", 1)

	stateMachine.change(state)
	assert_eq(state.get_name(), stateMachine.get_state().get_name())

func test_history() -> void:
	var state: TestCustomState = TestCustomState.new("fake state", 777)

	var stateMachine: StateMachine = StateMachine.new(state)

	for i in range(0, stateMachine.max_history_count + 1):
		state = TestCustomState.new("mock%d" % i, i)
		stateMachine.change(state)

	assert_eq("mock%d" % stateMachine.max_history_count, stateMachine.get_state().get_name())

	stateMachine.change(TestCustomState.new("last", 9))

	# Returns back to first state
	for i in range(0, stateMachine.max_history_count):
		stateMachine.back()

	# Asserts with "mock1" because "mock0" was deleted from history
	assert_eq("mock1", stateMachine.get_state().get_name())
