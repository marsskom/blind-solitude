extends KinematicBody2D

onready var animated_sprite: AnimatedSprite = $AnimatedSprite

var modulate_model: BiomModulate

func _ready():
	modulate_model = BiomModulate.new(animated_sprite)


func _on_TransparentArea_area_entered(_area):
	modulate_model.entered()


func _on_TransparentArea_area_exited(_area):
	modulate_model.exited()
