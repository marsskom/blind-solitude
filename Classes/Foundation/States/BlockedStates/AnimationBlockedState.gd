extends BlockedState
class_name AnimationBlockedState

# TODO: has bug when press on many keys the animation just has not finished
func __on_animation_ended():
	.block(false)

	emit_signal("has_unlocked", self)
