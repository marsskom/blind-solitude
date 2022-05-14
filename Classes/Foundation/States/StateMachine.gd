class_name StateMachine

signal state_changed

export(int) var max_history_count: int = 5

var state: State setget set_state, get_state
var history: Array = []


func _init(state: State) -> void:
	set_state(state)
	get_state().emit_signal("activated")

func set_state(value: State) -> void:
	state = value

func get_state() -> State:
	return state


func change(state: State) -> void:
	if get_state().get_value() == state.get_value():
		return

	self._append_state(state)

	emit_signal("state_changed", state)


func back() -> bool:
	if history.size() > 0:
		_append_state(history.pop_back(), true)
		return true

	return false


func _append_state(state: State, is_rewind: bool = false) -> void:
	get_state().emit_signal("changed")

	if not is_rewind:
		history.append(get_state())

	set_state(state)
	get_state().emit_signal("activated")

	if (history.size() > max_history_count):
		history.pop_front()
