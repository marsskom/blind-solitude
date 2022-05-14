extends Node
class_name StatesCollection

var collection: Dictionary = {} setget , get_all

func _ready():
	for state in get_children():
		collection[state.name] = state as State


func get(name: String) -> State:
	return collection[name]


func get_all() -> Dictionary:
	return collection
