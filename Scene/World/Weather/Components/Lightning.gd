# Thanks: https://www.youtube.com/watch?v=Hyq7KixGyHY
extends Line2D
class_name Lightning

onready var animation_player: AnimationPlayer = $AnimationPlayer

var _divider: float = 12
var _points_lerp: Array = []
var _sway: float
var _sway_divider: float = 66


func set_start(point: Vector2) -> void:
	add_point(point)


func set_end(point: Vector2) -> void:
	add_point(point)


func segmentize(from: Vector2, start_position: Vector2) -> void:
	_points_lerp.clear()

	var distance: float = from.length()
	_sway = clamp(distance / _sway_divider, 0, 10)

	var segment_count: int = (distance / _divider) as int
	for point in range(0, segment_count):
		_points_lerp.append(randf())

	_points_lerp.sort()

	var point_index: int = 1
	for point_offset in _points_lerp:
		add_point(start_position + point_offset * from, point_index)
		point_index += 1


func sway(normalized: Vector2) -> void:
	var point_count: int = get_point_count() - 1
	for point in point_count:
		if point == 0 or point == point_count:
			continue
		else:
			var offset = (
				(get_point_position(point) + get_point_position(point - 1)) / 2
			) + normalized * rand_range(-_sway, _sway)

			set_point_position(point, offset)


func _to_string() -> String:
	return points as String
