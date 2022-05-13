extends KinematicBody2D
class_name Character

signal vector_changed
signal state_changed

export(int) var ACCELERATION: int = 500
export(int) var MAX_SPEED: int = 80
export(int) var FRICTION: int = 500

export(NodePath) var states_collection_node: NodePath

var __stateMachine: StateMachine
var __velocity: Vector2 = Vector2.DOWN setget set_velocity, get_velocity
var __last_vector: Vector2 = Vector2.DOWN

onready var states: StatesCollection = get_node(states_collection_node) as StatesCollection


func _ready():
	self.__stateMachine = StateMachine.new(states.get("Idle"))
	self.__stateMachine.connect("state_changed", self, "__on_state_chaged")


func __on_state_chaged(state: State):
	emit_signal("state_changed", state)


func set_velocity(velocity: Vector2) -> void:
	__velocity = velocity


func get_velocity() -> Vector2:
	return __velocity


func idle_process(delta) -> void:
	self.set_velocity(
		self.get_velocity().move_toward(self.__last_vector, FRICTION * delta)
	)


func move_process(vector: Vector2, delta) -> void:
	self.set_velocity(
		self.get_velocity().move_toward(vector * MAX_SPEED, ACCELERATION * delta)
	)

	self.set_velocity(move_and_slide(self.get_velocity()))
