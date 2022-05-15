extends Node
class_name Wind

signal wind_blow

# Wind average speed in kilometers (real kilometers)
export(float) var speed: float = 10.0
# Wind speed on time in hours (real hours)
export(int) var time: int = 1
# How often wind will change: count per hour
export(int) var variability: int = 2

var _direction: Vector2 = Vector2.ZERO setget , get_direction
var _last_change: float
var _distance: Distance

var _previous_speed: float = 0.0
var _speed_direction: int = 1
var _min_speed_limit: float = speed - 10
var _max_speed_limit: float = speed + 10


func _ready():
	_distance = Distance.new()

	create()


func _process(delta):
	if need_change():
		create()

	_update_speed()

	emit_signal("wind_blow", get_direction(), get_speed(delta))


func get_direction() -> Vector2:
	return _direction


func create():
	_previous_speed = 0.0

	_update_direction()
	_update_speed()

	_last_change = TimeSystem.get_value()


func _update_direction() -> void:
	var cases: Array = []
	match get_direction():
		Vector2.LEFT:
			cases = [Vector2.UP, Vector2.DOWN]
		Vector2.UP:
			cases = [Vector2.LEFT, Vector2.DOWN]
		Vector2.RIGHT:
			cases = [Vector2.UP, Vector2.DOWN]
		Vector2.DOWN:
			cases = [Vector2.LEFT, Vector2.RIGHT]
		_:
			cases = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]

	cases.shuffle()
	randomize()

	var key = randi() % cases.size()
	self._direction = (cases[key] + get_direction()).normalized()


func _update_speed() -> void:
	if abs(speed - _previous_speed) <= 5:
		speed += _speed_direction
	else:
		randomize()

		if (randi() % 10) % 2 == 0:
			_speed_direction = 1
		else:
			 _speed_direction = -1

		_previous_speed = speed
		speed += _speed_direction

	if speed < _min_speed_limit:
		speed = _min_speed_limit

	if speed < _max_speed_limit:
		speed = _max_speed_limit

	if speed < 1:
		speed = 1


func need_change() -> bool:
	var diff = TimeSystem.get_diff(_last_change)
	var datetime = TimeSystem.get_datetime(diff as int)
	var minutes_interval_to_change = TimeSystem.get_minutes_in_hour() / variability

	return datetime.get_minutes() >= minutes_interval_to_change


func get_speed(delta: float) -> float:
	var distance_per_hour = speed / time
	var vector_points_per_hour = _distance.kilometters_to_points(distance_per_hour)
	var percentage_value = delta * 100 / (
		TimeSystem.get_minutes_in_hour() * TimeSystem.get_seconds_in_minutes()
	)
	var point_per_delta = vector_points_per_hour * percentage_value

	return point_per_delta
