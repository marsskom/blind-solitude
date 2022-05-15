class_name StateMachine

signal state_changed

export(int) var max_history_count: int = 5

var _state: State setget set_state, get_state
var _history: Array = []


func _init(state: State) -> void:
	set_state(state)
	get_state().emit_signal("activated")

func set_state(value: State) -> void:
	_state = value

func get_state() -> State:
	return _state


func change(state: State) -> void:
	if get_state().get_value() == state.get_value():
		return

	self._append_state(state)

	emit_signal("state_changed", state)


func back() -> bool:
	if _history.size() > 0:
		_append_state(_history.pop_back(), true)
		return true

	return false


func _append_state(state: State, is_rewind: bool = false) -> void:
	get_state().emit_signal("changed")

	if not is_rewind:
		_history.append(get_state())

	set_state(state)
	get_state().emit_signal("activated")

	if (_history.size() > max_history_count):
		_history.pop_front()
