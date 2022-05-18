extends BasicKinematicBody

signal player_position

enum PlayerStates {
	IDLE,
	MOVE,
	PICK_UP,
}

onready var accessories: Accessories = $Accessories


func _physics_process(delta):
	emit_signal("player_position", global_position)

	var state: State = _state_manager.current()

	match state.get_value():
		PlayerStates.IDLE:
			idle_move_state(delta)
		PlayerStates.MOVE:
			idle_move_state(delta)
		PlayerStates.PICK_UP:
			if not state.is_locked():
				_state_manager.change("Idle")


func idle_move_state(delta):
	var vector = Vector2.DOWN
	vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	vector = vector.normalized()

	if vector != Vector2.ZERO:
		set_last_direction(vector)

	if vector != Vector2.ZERO:
		_state_manager.change("Move")
		.move_process(vector, delta)
	else:
		_state_manager.change("Idle")
		.idle_process(delta)


func _input(_event):
	var state: State = _state_manager.current()
	if state.is_locked():
		return

	var state_name = null
	if Input.is_action_just_pressed("interaction"):
		state_name = "PickUp"

	if Input.is_action_just_pressed("ui_select"):
		accessories.set_visibility(
			"PinkSnapBack",
			not accessories.collection().get("PinkSnapBack").visible
		)

	if null == state_name:
		return

	_state_manager.change(state_name)
