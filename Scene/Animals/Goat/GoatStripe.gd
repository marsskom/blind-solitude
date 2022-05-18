extends BasicKinematicBody

export(int) var WANDER_TARGET_RANGE = 2

onready var soft_collision: Area2D = $SoftCollisionComponent
onready var wander_controller: Node2D = $WanderController
onready var state_timer_node: Timer = $StateTimer
onready var wander_state_node: Node = $States/Wander

enum {
	IDLE,
	WANDER
}


func _ready():
	._ready()

	state_timer_node.connect("timeout", self, "_on_timer_timeout")


func _physics_process(delta):
	var state = _state_manager.current()

	match state.get_value():
		IDLE:
			.idle_process(delta)

			if wander_controller.get_time_left() == 0:
				update_wander()

			if state_timer_node.is_stopped():
				state_timer_node.start(rand_range(2, 4))

		WANDER:
			if not state.is_locked():
				_state_manager.change("Idle")
				return

			if global_position.distance_to(wander_controller.target_position) <= WANDER_TARGET_RANGE:
				state.unlock()
				return

			accelerate_towards_point(wander_controller.target_position, delta)

			if soft_collision.is_colliding():
				var push_vector: Vector2 = soft_collision.get_push_vector()
				set_last_direction(push_vector)
				set_velocity(get_velocity() + push_vector * delta * 400)

			set_velocity(move_and_slide(get_velocity()))


func accelerate_towards_point(point, delta) -> void:
	var direction = global_position.direction_to(point)
	set_last_direction(direction)
	set_velocity(get_velocity().move_toward(direction * MAX_SPEED, ACCELERATION * delta))


func update_wander() -> void:
	wander_controller.start_wander_timer(rand_range(1, 3))


func _on_timer_timeout() -> void:
	_state_manager.change("Wander")
