extends Character

enum PlayerStates {
	IDLE,
	MOVE,
	PICK_UP,
}

func _physics_process(delta):
	var state: State = self.__stateMachine.get_state()

	match state.get_value():
		PlayerStates.IDLE:
			idle_move_state(delta)
		PlayerStates.MOVE:
			idle_move_state(delta)
		PlayerStates.PICK_UP:
			if not state.is_blocked():
				self.__stateMachine.change(states.get("Idle"))


func idle_move_state(delta):
	var vector = Vector2.DOWN
	vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	vector = vector.normalized()

	if vector != Vector2.ZERO:
		self.__last_vector = vector

	emit_signal("vector_changed", self.__last_vector)

	if vector != Vector2.ZERO:
		.move_process(vector, delta)
	else:
		.idle_process(delta)


func _input(event):
	var state: State = self.__stateMachine.get_state()
	if state.is_blocked():
		return

	if Input.is_action_just_pressed("interaction"):
		state = states.get("PickUp")

	if null == state:
		return

	self.__stateMachine.change(state)
