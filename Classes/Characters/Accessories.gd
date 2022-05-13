extends Node
class_name Accessories

export(NodePath) var character_node: NodePath

var __collection: Dictionary = {} setget , get_all

onready var character: Node2D  = get_node(character_node) as Node2D

func _ready():
	for node in get_children():
		self.__collection[node.name] = node as Node
		self.__add_remote_transform(node)

	character.connect("vector_changed", self, "__on_vector_changed")
	character.connect("state_changed", self, "__on_state_changed")


func __add_remote_transform(node: Node) -> void:
	var remote_transform_2d: RemoteTransform2D = RemoteTransform2D.new()
	remote_transform_2d.set_name("RemoteTransform2D__%s" % node.name)
	remote_transform_2d.remote_path = node.get_path()
	remote_transform_2d.set_owner(character)
	character.call_deferred("add_child", remote_transform_2d)


func get(name: String) -> State:
	return self.__collection[name]


func get_all() -> Dictionary:
	return __collection


func get_visible() -> Dictionary:
	var filtered: Dictionary = {}

	for key in self.__collection.keys():
		if self.__collection[key].visible:
			filtered[key] = self.__collection[key]

	return filtered


func __on_state_changed(state: State) -> void:
	for node in self.get_visible().values():
		node.set_animation_name(state.get_name())


func __on_vector_changed(vector: Vector2) -> void:
	for node in self.get_visible().values():
		node.set_vector(vector)
