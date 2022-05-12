extends KinematicBody2D

export(int) var ACCELERATION: int = 500
export(int) var MAX_SPEED: int = 80
export(int) var FRICTION: int = 500

var __stateMachine: StateMachine
var __velocity : Vector2 = Vector2.ZERO

onready var __idle_state = $States/Idle

func _ready():
	self.__stateMachine = StateMachine.new(self.__idle_state.get_state())

func _physics_process(delta):
	var vector = update_velocity(delta)

	# Now we have only idle state
	if vector != Vector2.ZERO:
		self.__idle_state.set_vector(vector)
	self.__velocity = self.__velocity.move_toward(vector, FRICTION * delta)

func update_velocity(delta) -> Vector2:
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()

	return input_vector
