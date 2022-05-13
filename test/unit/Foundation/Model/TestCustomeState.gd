extends State
class_name TestCustomState

var __active_mess: String
var __change_mess: String

func _init(
	name: String,
	value: int,
	active_mess: String = "activated",
	change_mess: String = "changed"
) -> void:

	self.__name = name
	self.__value = value

	self.__active_mess = active_mess
	self.__change_mess = change_mess

	self.connect("activated", self, "_on_activated")
	self.connect("changed", self, "_on_changed")

func _on_activated() -> void:
	emit_signal("activated", self.__active_mess)

func _on_changed() -> void:
	emit_signal("changed", self.__change_mess)
