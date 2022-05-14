extends CanvasModulate

onready var animation_player: AnimationPlayer = $AnimationPlayer

func _process(delta):
	var dict = TimeSystem.get_current_datetime()
	var day_time_in_seconds = dict.get_hours() * 3600 + dict.get_minutes() * 60
	var current_frame = range_lerp(day_time_in_seconds, 0, 86400, 0, 24)

	animation_player.play("DayNightCycle")
	animation_player.seek(current_frame as float)
