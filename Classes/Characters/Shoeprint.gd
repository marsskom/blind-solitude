extends YSort

export(NodePath) var character_node: NodePath
onready var character: Node2D = get_node(character_node) as Node2D

export(NodePath) var scene_container_node: NodePath
onready var scene_container: Node2D = get_node(scene_container_node) as Node2D

onready var ysort: YSort = $YSort
onready var timer: Timer = $Timer

var _collection: Collection


func _ready():
	_collection = Collection.new(ysort.get_children())


func _on_move_right_foot_right() -> void:
	_past_shoeprint("MoveRightFootRight")


func _on_move_right_foot_left() -> void:
	_past_shoeprint("MoveRightFootLeft")


func _on_move_left_foot_right() -> void:
	_past_shoeprint("MoveLeftFootRight")


func _on_move_left_foot_left() -> void:
	_past_shoeprint("MoveLeftFootLeft")


func _on_move_up_foot_right() -> void:
	_past_shoeprint("MoveUpFootRight")


func _on_move_up_foot_left() -> void:
	_past_shoeprint("MoveUpFootLeft")


func _on_move_down_foot_right() -> void:
	_past_shoeprint("MoveDownFootRight")


func _on_move_down_foot_left() -> void:
	_past_shoeprint("MoveDownFootLeft")


func _past_shoeprint(sprite_name: String) -> void:
	var shoeprint = _collection.get(sprite_name).duplicate()

	shoeprint.name = UUID.v4()
	shoeprint.position = character.position + shoeprint.position
	shoeprint.visible = true

	var shoeprint_timer: Timer = self.timer.duplicate()
	shoeprint_timer.set_owner(shoeprint)
	shoeprint.add_child(shoeprint_timer)

	scene_container.add_child(shoeprint)
	shoeprint_timer.run()
