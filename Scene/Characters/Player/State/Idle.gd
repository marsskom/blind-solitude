extends Node

var __state: State setget , get_state
onready var __animation_tree: AnimationTree = $AnimationTree
onready var __animation_state = __animation_tree.get("parameters/playback")

func _ready():
	self.__state = State.new("idle", 0)

	self.__animation_tree.set("parameters/Idle/blend_position", Vector2.DOWN)

	self.__state.connect("activated", self, "__on_activated")
	self.__state.connect("changed", self, "__on_changed")

func get_state() -> State:
	return __state

func set_vector(vector: Vector2) -> void:
	self.__animation_tree.set("parameters/Idle/blend_position", vector)

func __on_activated():
	self.__animation_state.travel("Idle")

func __on_changed():
	self.__animation_state.stop()
