extends Label

export(NodePath) var character_node: NodePath

onready var character: Node2D  = get_node(character_node) as Node2D

func _process(delta):
	text = character.global_position as String
