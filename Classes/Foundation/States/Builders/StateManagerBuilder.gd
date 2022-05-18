class_name StateManagerBuilder

static func from_states_node(nodes: Array, default_state_name: String = "Idle") -> StateManager:
	var states: Array = []

	for node in nodes:
		states.append(node.get_state())

	return StateManager.new(states, default_state_name)
