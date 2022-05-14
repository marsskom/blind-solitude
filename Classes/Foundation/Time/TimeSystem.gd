extends Node

# Ticks relatively to real seconds
var minute_ticks: int = 1
var hour_ticks: int = minute_ticks * 60
var day_ticks: int = hour_ticks * 24

# Start from 9 AM
var value: float = 60 * 9
var multiplier: float = 1.0

# Game time system load globally but should started manually
var is_active: bool = false


func _process(delta):
	if not is_active:
		return

	value += delta * multiplier


func activate() -> void:
	is_active = true


func _make_days(seconds: int) -> int:
	return floor(seconds / day_ticks) as int


func _make_hours(seconds: int) -> int:
	return floor((seconds / hour_ticks) % 24) as int


func _make_minutes(seconds: int) -> int:
	return floor((seconds / minute_ticks) % 60) as int


func get_current_datetime() -> Datetime:
	return Datetime.new(
		_make_days(value),
		_make_hours(value),
		_make_minutes(value)
	)

func get_datetime(seconds: int) -> Datetime:
	return Datetime.new(
		_make_days(seconds),
		_make_hours(seconds),
		_make_minutes(seconds)
	)
