extends Node

signal day_night_animation_changed

onready var moon: Moon = Moon.new()

func _process(delta):
	if _is_moon_night_time() and moon.is_full_moon():
		emit_signal("day_night_animation_changed", "MoonLight")
	else:
		emit_signal("day_night_animation_changed", "DayNightCycle")


func _is_moon_night_time() -> bool:
	var datetime: Datetime = TimeSystem.get_current_datetime()
	var hours = datetime.get_hours()

	return hours >= 0 and hours <= 4
