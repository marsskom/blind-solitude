extends Node
class_name CharacterState

export(NodePath) var animation_tree_node: NodePath
export(NodePath) var character_node: NodePath
export(String) var animation_name: String = "Idle" setget , get_name
export(int) var state_value: int = 0 setget , get_value
export(bool) var is_lockable: bool = false

onready var animation_tree: AnimationTree = get_node(animation_tree_node) as AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")

onready var character: Node2D  = get_node(character_node) as Node2D

var _state: State

func _ready():
	_state = State.new(animation_name, state_value, is_lockable)

	animation_tree.set("parameters/Idle/blend_position", Vector2.DOWN)

	_state.connect("activated", self, "_on_activated")
	_state.connect("changed", self, "_on_changed")

	character.connect("vector_changed", self, "_on_vector_changed")


func get_state() -> State:
	return _state


func get_name() -> String:
	return animation_name


func get_value() -> int:
	return state_value


func is_locked() -> bool:
	return _state.is_locked()


func _on_vector_changed(vector: Vector2) -> void:
	animation_tree.set("parameters/%s/blend_position" % animation_name, vector)


func _on_activated():
	animation_state.travel(animation_name)


func _on_changed():
	animation_state.stop()


func _on_animation_ended():
	if _state.is_lockable():
		_state.unlock()
