class_name Precipitation

signal precipitation_started
signal precipitation_stopped

var _duration_minutes: int
var _time_between_in_minutes: int
var _in_process: bool = false
var _last_time_started: float = 0.0
var _last_time_finished: float = 0.0
var _stat_data_array: Array
var _stat_data_max_size: int = 20
var _rand_generator: RandomNumberGenerator

func _init(duration_minutes: int, time_between: int, statistic_data_array: Array):
	_duration_minutes = duration_minutes
	_time_between_in_minutes = time_between
	_stat_data_array = statistic_data_array

	_rand_generator = RandomNumberGenerator.new()

func common_process():
	if may_start():
		start()

	if _in_process and may_stop():
		stop()


func may_start() -> bool:
	if _in_process:
		return false

	var diff_seconds: float = TimeSystem.get_diff(_last_time_finished)

	if diff_seconds <= _time_between_in_minutes * TimeSystem.get_seconds_in_minutes():
		return false

	var probability: float = _probability()
	if probability >= 0.75:
		add_note(1)
		return true

	add_note(0)
	return false


func _probability() -> float:
	var probability: float = 0.0
	if _stat_data_array.size() > 0:
		probability = _stat_data_array.count(1) / _stat_data_array.size()

	randomize()
	return probability + _rand_generator.randfn()


func add_note(value: int) -> void:
	if _stat_data_array.size() >= _stat_data_max_size:
		_stat_data_array.pop_front()

	_stat_data_array.append(value)


func start() -> void:
	_in_process = true
	_last_time_started = TimeSystem.get_value()

	emit_signal("precipitation_started")


func may_stop() -> bool:
	var diff_seconds = TimeSystem.get_diff(_last_time_started)

	return diff_seconds > _duration_minutes * TimeSystem.get_seconds_in_minutes()


func stop() -> void:
	_in_process = false
	_last_time_finished = TimeSystem.get_value()

	emit_signal("precipitation_stopped")
