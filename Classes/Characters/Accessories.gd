extends YSort
class_name Accessories

signal node_appeared
signal node_disappeared

export(NodePath) var character_node: NodePath
onready var character: Node2D  = get_node(character_node) as Node2D

var _collection: Collection setget , collection
var _remote_transforms_collection: Collection


func _ready():
	self._remote_transforms_collection = Collection.new([])

	self.connect("node_appeared", self, "_on_node_appeared")
	self.connect("node_disappeared", self, "_on_node_disappeared")

	self._collection = Collection.new(get_children())
	# TODO: set visible those accessories which already must be visible

	character.connect("vector_changed", self, "_on_vector_changed")
	character.connect("state_changed", self, "_on_state_changed")


func collection() -> Collection:
	return _collection


func get_visible() -> Dictionary:
	return collection().filter("visible", true)


func set_visibility(name: String, value: bool) -> void:
	var node = collection().get(name)

	node.visible = value

	if value:
		pass


func _on_node_appeared(node) -> void:
	_remote_transforms_collection.append(
		node.name,
		RemoteTransform2DFactory.create(node)
	)

	character.call_deferred(
		"add_child",
		_remote_transforms_collection.get(node.name)
	)


func _on_node_disappeared(node) -> void:
	character.call_deferred(
		"remove_child",
		_remote_transforms_collection.get(node.name)
	)

	_remote_transforms_collection.get(node.name).call_deferred("queue_free")


func _on_state_changed(state: State) -> void:
	for node in get_visible().values():
		node.set_animation_name(state.get_name())


func _on_vector_changed(vector: Vector2) -> void:
	for node in get_visible().values():
		node.set_vector(vector)
