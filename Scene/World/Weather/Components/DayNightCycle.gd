extends CanvasModulate

onready var animation_player: AnimationPlayer = $AnimationPlayer

func _process(delta):
	var dict = TimeSystem.formed_datetime(OS.get_ticks_msec())

#	animation_player.play("DayNightCycle")
#	animation_player.seek(dict.hours as float)
