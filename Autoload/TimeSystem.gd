extends Node

var _seconds_in_minutes: int = 60 setget , get_seconds_in_minutes
var _minutes_in_hour: int = 60 setget , get_minutes_in_hour
var _hours_in_day: int = 24 setget , get_hours_in_day

# Ticks relatively to real seconds
var minute_ticks: int = 1
var hour_ticks: int = minute_ticks * _minutes_in_hour
var day_ticks: int = hour_ticks * _hours_in_day

# Start from 9 AM
var value: float = _minutes_in_hour * 9
var multiplier: float = 1.0

# Game time system load globally but should started manually
var is_active: bool = false


func _process(delta):
	if not is_active:
		return

	value += delta * multiplier


func get_seconds_in_minutes() -> int:
	return _seconds_in_minutes


func get_minutes_in_hour() -> int:
	return _minutes_in_hour


func get_hours_in_day() -> int:
	return _hours_in_day


func activate() -> void:
	is_active = true


func _make_days(seconds: float) -> int:
	return floor(int(seconds) / day_ticks) as int


func _make_hours(seconds: float) -> int:
	return floor((int(seconds) / hour_ticks) % _hours_in_day) as int


func _make_minutes(seconds: float) -> int:
	return floor((int(seconds) / minute_ticks) % _minutes_in_hour) as int


func get_current_datetime() -> Datetime:
	return Datetime.new(
		_make_days(value),
		_make_hours(value),
		_make_minutes(value)
	)


func get_datetime(seconds: float) -> Datetime:
	return Datetime.new(
		_make_days(seconds),
		_make_hours(seconds),
		_make_minutes(seconds)
	)


func get_value() -> float:
	return value


# Returns diff between value and passed parameter in seconds
func get_diff(time: float) -> float:
	return value - time


func to_seconds(datetime: Datetime) -> float:
	var min_multiply_seconds = get_minutes_in_hour() * get_seconds_in_minutes()

	return (
		(datetime.get_days() * get_hours_in_day() * min_multiply_seconds)
		+ (datetime.get_hours() * min_multiply_seconds)
		+ (datetime.get_minutes() * get_seconds_in_minutes())
	)
