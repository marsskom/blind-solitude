extends Node
class_name Accessories

export(NodePath) var character_node: NodePath

var collection: Dictionary = {} setget , get_all

onready var character: Node2D  = get_node(character_node) as Node2D

func _ready():
	for node in get_children():
		collection[node.name] = node as Node
		_add_remote_transform(node)

	character.connect("vector_changed", self, "_on_vector_changed")
	character.connect("state_changed", self, "_on_state_changed")


func _add_remote_transform(node: Node) -> void:
	var remote_transform_2d: RemoteTransform2D = RemoteTransform2D.new()
	remote_transform_2d.set_name("RemoteTransform2D_%s" % node.name)
	remote_transform_2d.remote_path = node.get_path()
	remote_transform_2d.set_owner(character)
	character.call_deferred("add_child", remote_transform_2d)


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
