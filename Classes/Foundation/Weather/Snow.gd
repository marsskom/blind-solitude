extends Node
class_name Snow

export(NodePath) var clouds_node: NodePath
onready var clouds: Clouds = get_node(clouds_node) as Clouds

export(bool) var is_enabled: bool = true
export(int) var clouds_count: int = 100
export(int) var snow_duration_minutes: int = 30
export(int) var time_between_snow_minutes: int = 90

var _default_max_clouds_count: int
var _is_snowing: bool = false
var _last_snow_started: float = 0.0
var _last_snow_finished: float = 0.0
# Contains info about was snowing or not: 1 - was, 0 - not
var _snowing_data_array: Array = [1, 0, 0, 0, 1, 1, 0, 0, 1, 0]
var _snowing_data_max_size: int = 20

onready var rand_generator: RandomNumberGenerator = RandomNumberGenerator.new()


func _ready():
	_default_max_clouds_count = clouds.max_clouds_count

	$Timer.connect("timeout", self, "_on_timer_timeout")


func _physics_process(delta):
	if not is_enabled:
		return

	if need_snow():
		start_snow()

	if _is_snowing:
		check_and_stop_snow()


func need_snow() -> bool:
	if _is_snowing:
		return false

	var diff_real_seconds: float = TimeSystem.get_diff(_last_snow_finished)
	var diff_seconds: float = TimeSystem.to_seconds(TimeSystem.get_datetime(diff_real_seconds))

	if diff_seconds <= time_between_snow_minutes * TimeSystem.get_seconds_in_minutes():
		return false

	var probability: float = snow_probability()
	if probability >= 0.75:
		add_snow_note(1)
		return true

	add_snow_note(0)
	return false


func snow_probability() -> float:
	var probability: float = 0.0
	if _snowing_data_array.size() > 0:
		probability = _snowing_data_array.count(1) / _snowing_data_array.size()

	randomize()
	var god_hand: float = rand_generator.randfn()

	return probability + god_hand


func add_snow_note(value: int) -> void:
	if _snowing_data_array.size() >= _snowing_data_max_size:
		_snowing_data_array.pop_front()

	_snowing_data_array.append(value)


func start_snow() -> void:
	clouds.max_clouds_count = clouds_count
	clouds.create_max_clouds()
	$Timer.start(5)

	_is_snowing = true
	_last_snow_started = TimeSystem.get_value()


func check_and_stop_snow() -> void:
	var diff_real_seconds = TimeSystem.get_diff(_last_snow_started)
	var diff_seconds = TimeSystem.to_seconds(TimeSystem.get_datetime(diff_real_seconds))

	if diff_seconds > snow_duration_minutes * TimeSystem.get_seconds_in_minutes():
		$Particles2D.emitting = false
		clouds.max_clouds_count = _default_max_clouds_count

		_is_snowing = false
		_last_snow_finished = TimeSystem.get_value()


func _on_timer_timeout() -> void:
	$Particles2D.emitting = true
	$Timer.stop()


func _on_player_position(player_position: Vector2) -> void:
	var position = player_position + (Vector2.UP * 250)
	$Particles2D.position = position
