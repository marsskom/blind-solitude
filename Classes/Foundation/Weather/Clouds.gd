extends Node
class_name Clouds

signal follow_wind
signal pass_player_position

export(NodePath) var wind_node: NodePath
onready var wind: Wind  = get_node(wind_node) as Wind

export(int) var max_clouds_count: int = 10

var _templates: Array = []
var _speed_model: Speed
var _player_position: Vector2 = Vector2.ZERO
var _clouds_count: int = 0

onready var rand_generator: RandomNumberGenerator = RandomNumberGenerator.new()


func _init():
	_speed_model = Speed.new()


func _ready():
	for node in $Templates.get_children():
		_templates.append(node as Sprite)

	create_max_clouds()

	wind.connect("wind_blow", self, "_on_wind_blow")


func create_max_clouds() -> void:
	while _clouds_count < max_clouds_count:
		_make_cloud()


func _make_cloud() -> void:
	if _clouds_count >= max_clouds_count:
		return

	_templates.shuffle()

	var template = _templates[0]
	var sprite = template.duplicate(DUPLICATE_GROUPS | DUPLICATE_SCRIPTS | DUPLICATE_USE_INSTANCING)
	sprite.name = UUID.v4()

	var rect = CloudFactory.get_cloud_appear_region(wind.get_direction(), sprite, _player_position)
	sprite.position.x = rect.position.x + rand_generator.randf_range(0, rect.size.x)
	sprite.position.y = rect.position.y + rand_generator.randf_range(0, rect.size.y)
	sprite.visible = true

	self.connect("follow_wind", sprite, "_on_follow_wind")
	self.connect("pass_player_position", sprite, "_on_player_position")
	sprite.connect("cloud_vanished", self, "_on_cloud_vanished")

	add_child(sprite)

	_clouds_count += 1


func _on_wind_blow(direction: Vector2, speed: float) -> void:
	var lerp_weight = _speed_model.kinematic_speed_to_lerp_weight(speed)

	emit_signal("follow_wind", direction, lerp_weight)


func _on_player_position(player_position: Vector2) -> void:
	_player_position = player_position

	emit_signal("pass_player_position", player_position)


func _on_cloud_vanished() -> void:
	_clouds_count -= 1

	_make_cloud()
