extends Node
class_name Stuff

var __animation_name: String = "Idle" setget set_animation_name
var __vector: Vector2 = Vector2.DOWN setget set_vector

onready var animation_tree: AnimationTree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")


func set_animation_name(name: String) -> void:
	__animation_name = name
	self.run_animation()


func set_vector(vector: Vector2) -> void:
	__vector = vector
	self.run_animation()


func run_animation() -> void:
	animation_state.travel(self.__animation_name)
	animation_tree.set("parameters/%s/blend_position" % self.__animation_name, self.__vector)
