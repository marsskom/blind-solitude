extends Node2D

export(int) var wander_range = 32

onready var start_position = global_position
onready var target_position = global_position

onready var timer = $Timer


func _ready():
	update_target_position()

	timer.connect("timeout", self, "_on_timer_timeout")


func update_target_position() -> void:
	var target_vector = Vector2(rand_range(-wander_range, wander_range), rand_range(-wander_range, wander_range))
	target_position = start_position + target_vector


func get_time_left() -> float:
	return timer.time_left


func start_wander_timer(duration) -> void:
	timer.start(duration)


func _on_timer_timeout() -> void:
	update_target_position()
