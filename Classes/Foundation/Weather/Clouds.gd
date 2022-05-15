extends Node
class_name Clouds

signal follow_wind
signal pass_player_position

export(NodePath) var wind_node: NodePath
onready var wind: Wind  = get_node(wind_node) as Wind

export(int) var max_clouds_count: int = 20

var templates: Array = []
var speed_model: Speed

onready var cloud_region: Area2D = $CloudRegion
onready var rand_generator: RandomNumberGenerator = RandomNumberGenerator.new()


func _init():
	speed_model = Speed.new()


func _ready():
	for node in $Templates.get_children():
		templates.append(node as Sprite)

	for i in range(0, max_clouds_count):
		_make_cloud()

	wind.connect("wind_blow", self, "_on_wind_blow")


func _make_cloud() -> Sprite:
	templates.shuffle()

	var template = templates[0]
	var rect = _get_sprite_rect()
	var sprite = template.duplicate(DUPLICATE_GROUPS | DUPLICATE_SCRIPTS | DUPLICATE_USE_INSTANCING)
	sprite.name = UUID.v4()
	sprite.position.x = rect.position.x + rand_generator.randf_range(0, rect.size.x)
	sprite.position.y = rect.position.y + rand_generator.randf_range(0, rect.size.y)
	sprite.visible = true

	self.connect("follow_wind", sprite, "_on_follow_wind")
	self.connect("pass_player_position", sprite, "_on_player_position")
	sprite.connect("cloud_vanished", self, "_on_cloud_vanished")

	add_child(sprite)

	return sprite


func _get_sprite_rect() -> Rect2:
	if wind.get_direction().x != 0:
		if wind.get_direction().x < 0:
			var rect = $CloudRegion/SpawnRectangles/Right/CollisionShape2D
			var s = rect.shape.extents
			return Rect2($CloudRegion/SpawnRectangles/Right.global_position - s, s * 2)
		else:
			var rect = $CloudRegion/SpawnRectangles/Left/CollisionShape2D
			var s = rect.shape.extents
			return Rect2($CloudRegion/SpawnRectangles/Left.global_position - s, s * 2)

	if wind.get_direction().y != 0:
		if wind.get_direction().y < 0:
			var rect = $CloudRegion/SpawnRectangles/Bottom/CollisionShape2D
			var s = rect.shape.extents
			return Rect2($CloudRegion/SpawnRectangles/Bottom.global_position - s, s * 2)
		else:
			var rect = $CloudRegion/SpawnRectangles/Top/CollisionShape2D
			var s = rect.shape.extents
			return Rect2($CloudRegion/SpawnRectangles/Top.global_position - s, s * 2)

	var rect = $CloudRegion/SpawnRectangles/Top/CollisionShape2D
	var s = rect.shape.extents
	return Rect2($CloudRegion/SpawnRectangles/Top.global_position - s, s * 2)


func _on_wind_blow(direction: Vector2, speed: float) -> void:
	var lerp_weight = speed_model.kinematic_speed_to_lerp_weight(speed)

	emit_signal("follow_wind", direction, lerp_weight)


func _on_player_position(player_position: Vector2) -> void:
	emit_signal("pass_player_position", player_position)


func _on_cloud_vanished() -> void:
	_make_cloud()
