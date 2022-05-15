extends Node

signal day_night_animation_changed

export(NodePath) var character_node: NodePath
onready var character: Node2D  = get_node(character_node) as Node2D

onready var moon: Moon = Moon.new()


func _ready():
	character.connect("player_position", $YSort/Clouds, "_on_player_position")
	character.connect("player_position", $YSort/Rain, "_on_player_position")
	character.connect("player_position", $YSort/Snow, "_on_player_position")


func _process(_delta):
	if _is_moon_night_time() and moon.is_full_moon():
		emit_signal("day_night_animation_changed", "MoonLight")
	else:
		emit_signal("day_night_animation_changed", "DayNightCycle")


func _is_moon_night_time() -> bool:
	var datetime: Datetime = TimeSystem.get_current_datetime()
	var hours = datetime.get_hours()

	return hours >= 0 and hours <= 4
