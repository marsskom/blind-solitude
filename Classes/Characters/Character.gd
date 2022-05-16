extends KinematicBody2D
class_name Character

signal vector_changed
signal state_changed

export(int) var ACCELERATION: int = 500
export(int) var MAX_SPEED: int = 80
export(int) var FRICTION: int = 500

export(NodePath) var states_node_path: NodePath
onready var states_node = get_node(states_node_path)

var _state_collection: Collection
var _state_machine: StateMachine
var _velocity: Vector2 = Vector2.DOWN setget set_velocity, get_velocity
var _last_vector: Vector2 = Vector2.DOWN

func _ready():
	_state_collection = Collection.new([])
	for state in states_node.get_children():
		_state_collection.append(state.name, state.get_state())

	_state_machine = StateMachine.new(_state_collection.get("Idle"))
	_state_machine.connect("state_changed", self, "_on_state_chaged")


func _on_state_chaged(state: State):
	emit_signal("state_changed", state)


func set_velocity(value: Vector2) -> void:
	_velocity = value


func get_velocity() -> Vector2:
	return _velocity


func idle_process(delta) -> void:
	set_velocity(
		get_velocity().move_toward(_last_vector, FRICTION * delta)
	)


func move_process(vector: Vector2, delta) -> void:
	set_velocity(
		get_velocity().move_toward(vector * MAX_SPEED, ACCELERATION * delta)
	)

	set_velocity(
		move_and_slide(get_velocity())
	)
