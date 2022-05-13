class_name StateMachine

signal state_changed

export(int) var max_history_count: int = 5

var __state: State setget , get_state
var __history: Array = []


func _init(state: State) -> void:
	self.__state = state
	self.__state.emit_signal("activated")


func get_state() -> State:
	return __state


func change(state: State) -> void:
	if self.__state.get_value() == state.get_value():
		return

	self.__append_state(state)

	emit_signal("state_changed", state)


func back() -> bool:
	if self.__history.size() > 0:
		self.__append_state(self.__history.pop_back(), true)
		return true

	return false


func __append_state(state: State, is_rewind: bool = false) -> void:
	self.__state.emit_signal("changed")

	if not is_rewind:
		self.__history.append(self.__state)

	self.__state = state
	self.__state.emit_signal("activated")

	if (self.__history.size() > max_history_count):
		self.__history.pop_front()
