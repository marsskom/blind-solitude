extends Node
class_name Stuff

var animation_name: String = "Idle" setget set_animation_name
var vector: Vector2 = Vector2.DOWN setget set_vector

onready var animation_tree: AnimationTree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")


func set_animation_name(name: String) -> void:
	animation_name = name
	run_animation()


func set_vector(value: Vector2) -> void:
	vector = value
	run_animation()


func run_animation() -> void:
	animation_state.travel(self.animation_name)
	animation_tree.set("parameters/%s/blend_position" % self.animation_name, self.vector)
