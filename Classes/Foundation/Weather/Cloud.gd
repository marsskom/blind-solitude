extends Sprite
class_name Cloud

signal cloud_vanished

export(int) var max_distance_from_player: int = 1200

onready var soft_collision = $SoftCollisionComponent

var _lock_for_remove: bool = false


func _physics_process(delta):
	if _lock_for_remove:
		return

	if soft_collision.is_colliding():
		position = lerp(
			position,
			position + soft_collision.get_push_vector(),
			delta * 10
		)


func _on_follow_wind(direction: Vector2, weight: float) -> void:
	position = lerp(
		position,
		position + direction,
		weight
	)


func _on_player_position(player_position: Vector2) -> void:
	if _lock_for_remove or player_position.distance_to(global_position) < max_distance_from_player:
		return

	_lock_for_remove = true
	queue_free()
	emit_signal("cloud_vanished")
