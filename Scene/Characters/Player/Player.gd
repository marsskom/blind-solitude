extends Character

func _physics_process(delta):
	var vector = Vector2.DOWN
	vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	vector = vector.normalized()

	if vector != Vector2.ZERO:
		self.__last_vector = vector

	emit_signal("vector_changed", self.__last_vector)

	if vector != Vector2.ZERO:
		self.move_process(vector, delta)
	else:
		self.idle_process(delta)
