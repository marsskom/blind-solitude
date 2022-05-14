extends BlockedState
class_name AnimationBlockedState

func _on_animation_ended():
	.block(false)

	emit_signal("has_unlocked", self)
