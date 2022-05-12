class_name State

signal activated
signal changed

var __name: String setget , get_name
var __value: int setget , get_value

func _init(name: String, value: int) -> void:
	self.__name = name
	self.__value = value

func get_name() -> String:
	return __name

func get_value() -> int:
	return __value
