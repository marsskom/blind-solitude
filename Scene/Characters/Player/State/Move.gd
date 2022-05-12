extends Node

var __state: State setget , get_state
onready var __animation_tree: AnimationTree = $AnimationTree
onready var __animation_state = __animation_tree.get("parameters/playback")

func _ready():
	self.__state = State.new("move", 1)

	self.__animation_tree.set("parameters/Move/blend_position", Vector2.DOWN)

	self.__state.connect("activated", self, "__on_activated")
	self.__state.connect("changed", self, "__on_changed")

	get_parent().get_parent().connect("vector_changed", self, "__on_vector_changed")

func get_state() -> State:
	return __state

func __on_vector_changed(vector: Vector2) -> void:
	self.__animation_tree.set("parameters/Move/blend_position", vector)

func __on_activated():
	self.__animation_tree.active = true
	self.__animation_state.travel("Move")

func __on_changed():
	self.__animation_state.stop()
	self.__animation_tree.active = false
