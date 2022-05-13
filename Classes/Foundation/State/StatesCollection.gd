extends Node
class_name StatesCollection

var __collection: Dictionary = {} setget , get_all

func _ready():
	for state in get_children():
		self.__collection[state.name] = state as State

func get(name: String) -> State:
	return self.__collection[name]

func get_all() -> Dictionary:
	return __collection
