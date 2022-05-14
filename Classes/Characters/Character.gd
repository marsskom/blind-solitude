extends KinematicBody2D
class_name Character

signal vector_changed
signal state_changed

export(int) var ACCELERATION: int = 500
export(int) var MAX_SPEED: int = 80
export(int) var FRICTION: int = 500

export(NodePath) var states_collection_node: NodePath

var stateMachine: StateMachine
var velocity: Vector2 = Vector2.DOWN setget set_velocity, get_velocity
var last_vector: Vector2 = Vector2.DOWN

onready var states: StatesCollection = get_node(states_collection_node) as StatesCollection


func _ready():
	stateMachine = StateMachine.new(states.get("Idle"))
	stateMachine.connect("state_changed", self, "_on_state_chaged")


func _on_state_chaged(state: State):
	emit_signal("state_changed", state)


func set_velocity(value: Vector2) -> void:
	velocity = value


func get_velocity() -> Vector2:
	return velocity


func idle_process(delta) -> void:
	set_velocity(
		get_velocity().move_toward(last_vector, FRICTION * delta)
	)


func move_process(vector: Vector2, delta) -> void:
	set_velocity(
		get_velocity().move_toward(vector * MAX_SPEED, ACCELERATION * delta)
	)

	set_velocity(
		move_and_slide(get_velocity())
	)
