extends State
class_name BlockedState

signal has_unlocked

func _init():
	.block(true)


func __on_activated():
	.block(true)
	.__on_activated()

func __on_changed():
	.block(false)
	.__on_changed()
