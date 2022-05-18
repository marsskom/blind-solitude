extends Node
class_name KinematicBodyState

export(NodePath) var animation_tree_node: NodePath
onready var animation_tree: AnimationTree = get_node(animation_tree_node) as AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")

export(NodePath) var character_node: NodePath
onready var character: KinematicBody2D  = get_node(character_node) as KinematicBody2D

export(String) var animation_name: String = "Idle"
export(int) var state_value: int = 0
export(bool) var is_lockable: bool = false

var _state: State


func _ready():
	_state = State.new(name, state_value, is_lockable)

	animation_tree.set("parameters/%s/blend_position" % animation_name, Vector2.DOWN)

	_state.connect("activated", self, "_on_activated")
	_state.connect("changed", self, "_on_changed")

	character.connect("kb_direction_changed", self, "_on_vector_changed")


func get_state() -> State:
	return _state


func _on_vector_changed(vector: Vector2) -> void:
	animation_tree.set("parameters/%s/blend_position" % animation_name, vector)


func _on_activated():
	animation_state.travel(animation_name)


func _on_changed():
	animation_state.stop()


func _on_animation_ended():
	if _state.is_lockable():
		_state.unlock()
