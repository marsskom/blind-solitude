class_name StateManager

var _machine: StateMachine
var _collection: Collection


func _init(states: Array, default_state_name: String = "Idle"):
	_collection = Collection.new(states)
	_machine = StateMachine.new(_collection.get(default_state_name))


func current() -> State:
	return _machine.get_state()


func change(state_name: String) -> void:
	_machine.change(_collection.get(state_name))


func m() -> StateMachine:
	return _machine


func c() -> Collection:
	return _collection
