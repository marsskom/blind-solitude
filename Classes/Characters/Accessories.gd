extends Node
class_name Accessories

export(NodePath) var character_node: NodePath
onready var character: Node2D  = get_node(character_node) as Node2D

var collection: Dictionary = {} setget , get_all


func _ready():
	for node in get_children():
		collection[node.name] = node as Node

		character.call_deferred(
			"add_child",
			RemoteTransform2DFactory.create(node)
		)

	character.connect("vector_changed", self, "_on_vector_changed")
	character.connect("state_changed", self, "_on_state_changed")


func get(name: String) -> State:
	return collection[name]


func get_all() -> Dictionary:
	return collection


func get_visible() -> Dictionary:
	var filtered: Dictionary = {}

	for key in collection.keys():
		if collection[key].visible:
			filtered[key] = collection[key]

	return filtered


func _on_state_changed(state: State) -> void:
	for node in self.get_visible().values():
		node.set_animation_name(state.get_name())


func _on_vector_changed(vector: Vector2) -> void:
	for node in self.get_visible().values():
		node.set_vector(vector)
