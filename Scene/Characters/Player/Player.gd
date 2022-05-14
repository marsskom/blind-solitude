extends Character

enum PlayerStates {
	IDLE,
	MOVE,
	PICK_UP,
}

onready var accessories: Accessories = $Accessories

func _physics_process(delta):
	var state: State = stateMachine.get_state()

	match state.get_value():
		PlayerStates.IDLE:
			idle_move_state(delta)
		PlayerStates.MOVE:
			idle_move_state(delta)
		PlayerStates.PICK_UP:
			if not state.is_blocked():
				stateMachine.change(states.get("Idle"))


func idle_move_state(delta):
	var vector = Vector2.DOWN
	vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	vector = vector.normalized()

	if vector != Vector2.ZERO:
		last_vector = vector

	emit_signal("vector_changed", last_vector)

	if vector != Vector2.ZERO:
		stateMachine.change(states.get("Move"))
		.move_process(vector, delta)
	else:
		stateMachine.change(states.get("Idle"))
		.idle_process(delta)


func _input(event):
	var state: State = stateMachine.get_state()
	if state.is_blocked():
		return

	if Input.is_action_just_pressed("interaction"):
		state = states.get("PickUp")

	if Input.is_action_just_pressed("ui_select"):
		accessories.get("PinkSnapBack").visible = not accessories.get("PinkSnapBack").visible

	if null == state:
		return

	stateMachine.change(state)
