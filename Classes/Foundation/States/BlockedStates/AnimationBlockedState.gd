extends State
class_name AnimationBlockedState

func __on_activated():
	.block(true)
	.__on_activated()


func __on_animation_ended():
	.block(false)
