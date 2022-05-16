extends Character

signal player_position

enum PlayerStates {
	IDLE,
	MOVE,
	PICK_UP,
}

onready var accessories: Accessories = $Accessories


func _physics_process(delta):
	emit_signal("player_position", global_position)

	var state: State = _state_machine.get_state()

	match state.get_value():
		PlayerStates.IDLE:
			idle_move_state(delta)
		PlayerStates.MOVE:
			idle_move_state(delta)
		PlayerStates.PICK_UP:
			if not state.is_locked():
				_state_machine.change(_state_collection.get("Idle"))


func idle_move_state(delta):
	var vector = Vector2.DOWN
	vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	vector = vector.normalized()

	if vector != Vector2.ZERO:
		_last_vector = vector

	emit_signal("vector_changed", _last_vector)

	if vector != Vector2.ZERO:
		_state_machine.change(_state_collection.get("Move"))
		.move_process(vector, delta)
	else:
		_state_machine.change(_state_collection.get("Idle"))
		.idle_process(delta)


func _input(_event):
	var state: State = _state_machine.get_state()
	if state.is_locked():
		return

	if Input.is_action_just_pressed("interaction"):
		state = _state_collection.get("PickUp")

	if Input.is_action_just_pressed("ui_select"):
		accessories.set_visibility(
			"PinkSnapBack",
			not accessories.collection().get("PinkSnapBack").visible
		)

	if null == state:
		return

	_state_machine.change(state)
