class_name BiomModulate

var _node: Node2D
var _min_alpha_channel_value: float

func _init(node: Node2D, min_alpha_channel_value: float = 0.3):
	self._node = node
	self._min_alpha_channel_value = min_alpha_channel_value


func entered() -> void:
	_node.modulate.a = _min_alpha_channel_value


func exited() -> void:
	_node.modulate.a = 1
