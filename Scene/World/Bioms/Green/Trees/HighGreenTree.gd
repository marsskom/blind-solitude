extends KinematicBody2D

onready var animated_sprite: AnimatedSprite = $AnimatedSprite

func _on_TransparentArea_area_entered(_area):
	animated_sprite.modulate.a = 0.4


func _on_TransparentArea_area_exited(_area):
	animated_sprite.modulate.a = 1
