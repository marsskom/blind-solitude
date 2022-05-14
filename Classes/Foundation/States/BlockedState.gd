extends State
class_name BlockedState

signal has_unlocked

func _init():
	.block(true)


func _on_activated():
	.block(true)
	._on_activated()

func _on_changed():
	.block(false)
	._on_changed()
