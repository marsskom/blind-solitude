extends KinematicBody2D

signal vector_changed

export(int) var ACCELERATION: int = 500
export(int) var MAX_SPEED: int = 80
export(int) var FRICTION: int = 500

var __stateMachine: StateMachine
var __velocity: Vector2 = Vector2.DOWN setget set_velocity, get_velocity
var __last_vector: Vector2 = Vector2.DOWN

onready var __idle_state = $States/Idle
onready var __move_state = $States/Move

func _ready():
	self.__stateMachine = StateMachine.new(self.__idle_state)

func _physics_process(delta):
	var vector = create_vector(delta)

	emit_signal("vector_changed", vector)

	if vector != Vector2.ZERO:
		move_process(vector, delta)
	else:
		idle_process(delta)

func set_velocity(velocity: Vector2) -> void:
	__velocity = velocity

func get_velocity() -> Vector2:
	return __velocity

func create_vector(delta) -> Vector2:
	var vector = Vector2.DOWN
	vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	vector = vector.normalized()

	if vector != Vector2.ZERO:
		self.__last_vector = vector

	return vector

func idle_process(delta) -> void:
	emit_signal("vector_changed", self.__last_vector)
	self.__stateMachine.change(self.__idle_state)
	self.set_velocity(
		self.get_velocity().move_toward(self.__last_vector, FRICTION * delta)
	)

func move_process(vector: Vector2, delta) -> void:
	self.__stateMachine.change(self.__move_state)

	self.set_velocity(
		self.get_velocity().move_toward(vector * MAX_SPEED, ACCELERATION * delta)
	)

	self.set_velocity(move_and_slide(self.get_velocity()))
