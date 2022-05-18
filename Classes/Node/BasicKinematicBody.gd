extends KinematicBody2D
class_name BasicKinematicBody

signal kb_direction_changed
signal kb_state_changed

export(int) var ACCELERATION: int = 500
export(int) var MAX_SPEED: int = 80
export(int) var FRICTION: int = 500

export(NodePath) var states_node_path: NodePath
onready var states_node = get_node(states_node_path)

var _state_manager: StateManager
var _velocity: Vector2 = Vector2.DOWN setget set_velocity, get_velocity
var _last_direction: Vector2 = Vector2.DOWN setget set_last_direction, get_last_direction

func _ready():
	_state_manager = StateManagerBuilder.from_states_node(states_node.get_children())
	_state_manager.m().connect("state_changed", self, "_on_state_chaged")


func _on_state_chaged(state: State):
	emit_signal("kb_state_changed", state)


func set_velocity(value: Vector2) -> void:
	_velocity = value


func get_velocity() -> Vector2:
	return _velocity


func set_last_direction(value: Vector2) -> void:
	_last_direction = value

	emit_signal("kb_direction_changed", _last_direction)


func get_last_direction() -> Vector2:
	return _last_direction


func idle_process(delta) -> void:
	set_velocity(
		get_velocity().move_toward(get_last_direction(), FRICTION * delta)
	)


func move_process(vector: Vector2, delta) -> void:
	set_velocity(
		get_velocity().move_toward(vector * MAX_SPEED, ACCELERATION * delta)
	)

	set_velocity(
		move_and_slide(get_velocity())
	)
