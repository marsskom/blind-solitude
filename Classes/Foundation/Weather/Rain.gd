extends Node
class_name Rain

export(NodePath) var clouds_node: NodePath
onready var clouds: Clouds = get_node(clouds_node) as Clouds

export(bool) var is_enabled: bool = true
export(int) var clouds_count: int = 100
export(int) var rain_duration_minutes: int = 30
export(int) var time_between_rain_minutes: int = 90

var _default_max_clouds_count: int
var _is_raining: bool = false
var _last_rain_started: float = 0.0
var _last_rain_finished: float = 0.0
# Contains info about was raining or not: 1 - was, 0 - not
var _raining_data_array: Array = [0, 1, 0, 0, 0, 1, 0, 0, 0, 0]
var _raining_data_max_size: int = 20

onready var rand_generator: RandomNumberGenerator = RandomNumberGenerator.new()


func _ready():
	_default_max_clouds_count = clouds.max_clouds_count

	$Timer.connect("timeout", self, "_on_timer_timeout")


func _physics_process(delta):
	if not is_enabled:
		return

	if need_rain():
		start_rain()

	if _is_raining:
		check_and_stop_rain()


func need_rain() -> bool:
	if _is_raining:
		return false

	var diff_real_seconds: float = TimeSystem.get_diff(_last_rain_finished)
	var diff_seconds: float = TimeSystem.to_seconds(TimeSystem.get_datetime(diff_real_seconds))

	if diff_seconds <= time_between_rain_minutes * TimeSystem.get_seconds_in_minutes():
		return false

	var probability: float = rain_probability()
	if probability >= 0.75:
		add_rain_note(1)
		return true

	add_rain_note(0)
	return false


func rain_probability() -> float:
	var probability: float = 0.0
	if _raining_data_array.size() > 0:
		probability = _raining_data_array.count(1) / _raining_data_array.size()

	randomize()
	var god_hand: float = rand_generator.randfn()

	return probability + god_hand


func add_rain_note(value: int) -> void:
	if _raining_data_array.size() >= _raining_data_max_size:
		_raining_data_array.pop_front()

	_raining_data_array.append(value)


func start_rain() -> void:
	clouds.max_clouds_count = clouds_count
	clouds.create_max_clouds()
	$Timer.start(5)

	_is_raining = true
	_last_rain_started = TimeSystem.get_value()


func check_and_stop_rain() -> void:
	var diff_real_seconds = TimeSystem.get_diff(_last_rain_started)
	var diff_seconds = TimeSystem.to_seconds(TimeSystem.get_datetime(diff_real_seconds))

	if diff_seconds > rain_duration_minutes * TimeSystem.get_seconds_in_minutes():
		$Particles2D.emitting = false
		clouds.max_clouds_count = _default_max_clouds_count

		_is_raining = false
		_last_rain_finished = TimeSystem.get_value()


func _on_timer_timeout() -> void:
	$Particles2D.emitting = true
	$Timer.stop()


func _on_player_position(player_position: Vector2) -> void:
	var position = player_position + (Vector2.UP * 250)
	$Particles2D.position = position
