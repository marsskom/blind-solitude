extends State
class_name TestCustomState

var active_mess: String
var change_mess: String

func _init(
	name: String,
	value: int,
	active_mess: String = "activated",
	change_mess: String = "changed"
) -> void:

	animation_name = name
	state_value = value

	self.active_mess = active_mess
	self.change_mess = change_mess

	self.connect("activated", self, "_on_activated")
	self.connect("changed", self, "_on_changed")

func _on_activated() -> void:
	emit_signal("activated", active_mess)

func _on_changed() -> void:
	emit_signal("changed", change_mess)
