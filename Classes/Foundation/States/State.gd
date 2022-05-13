extends Node
class_name State

signal activated
signal changed

export(NodePath) var animation_tree_node: NodePath
export(NodePath) var character_node: NodePath
export(String) var animation_name: String = "Idle"
export(int) var state_value: int = 0

var __name: String setget , get_name
var __value: int setget , get_value
var __is_blocked: bool = false setget block, is_blocked

onready var animation_tree: AnimationTree = get_node(animation_tree_node) as AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")

onready var character: Node2D  = get_node(character_node) as Node2D


func _ready():
	self.__name = animation_name
	self.__value = state_value

	animation_tree.set("parameters/Idle/blend_position", Vector2.DOWN)

	self.connect("activated", self, "__on_activated")
	self.connect("changed", self, "__on_changed")

	character.connect("vector_changed", self, "__on_vector_changed")


func get_name() -> String:
	return __name


func get_value() -> int:
	return __value


func block(value: bool) -> void:
	__is_blocked = value


func is_blocked() -> bool:
	return __is_blocked


func __on_vector_changed(vector: Vector2) -> void:
	animation_tree.set("parameters/%s/blend_position" % animation_name, vector)


func __on_activated():
	animation_tree.active = true
	animation_state.travel(animation_name)


func __on_changed():
	animation_state.stop()
	animation_tree.active = false
