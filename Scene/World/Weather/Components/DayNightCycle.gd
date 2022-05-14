extends CanvasModulate

onready var animation_player: AnimationPlayer = $AnimationPlayer

var animation_name: String = "DayNightCycle" setget set_animation, get_animation

func _process(delta):
	var dict = TimeSystem.get_current_datetime()
	var day_time_in_seconds = dict.get_hours() * 3600 + dict.get_minutes() * 60
	var current_frame = range_lerp(day_time_in_seconds, 0, 86400, 0, 24)

	animation_player.play(get_animation())
	animation_player.seek(current_frame as float)


func set_animation(value: String) -> void:
	animation_name = value


func get_animation() -> String:
	return animation_name


func _on_Weather_day_night_animation_changed(animation_name):
	set_animation(animation_name)
