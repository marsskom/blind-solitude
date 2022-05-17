extends Node
class_name Rain

signal increase_max_clouds_to
signal enable_lightning
signal disable_lightning
signal precipitation_begin
signal precipitation_ended

export(bool) var is_active: bool = true
export(int) var clouds_count: int = 100
export(int) var rain_duration_minutes: int = 2
export(int) var time_between_rain_minutes: int = 20

onready var timer: Timer = $Timer
onready var particles: Particles2D = $Particles2D

var _precipitation: Precipitation setget , get_precipitation
var _is_enabled: bool setget set_enabled, get_enabled
var _can_emit_state: bool = true


func _ready():
	_is_enabled = is_active

	_precipitation = Precipitation.new(
		rain_duration_minutes,
		time_between_rain_minutes,
		[0, 1, 0, 0, 0, 1, 0, 0, 0, 0]
	)
	_precipitation.connect("precipitation_started", self, "_on_rain_started")
	_precipitation.connect("precipitation_stopped", self, "_on_rain_stopped")

	timer.connect("timeout", self, "_on_timer_timeout")


func set_enabled(value: bool) -> void:
	_is_enabled = value


func get_enabled() -> bool:
	return _is_enabled


func get_precipitation() -> Precipitation:
	return _precipitation


func _physics_process(delta):
	if get_enabled():
		get_precipitation().common_process()


func _on_rain_started() -> void:
	if not _can_emit_state:
		return

	emit_signal("precipitation_begin", "Rain")
	emit_signal("increase_max_clouds_to", clouds_count)

	randomize()
	if (randi() % 11) % 2 == 0:
		emit_signal("enable_lightning")

	timer.start(5)


func _on_rain_stopped() -> void:
	particles.emitting = false

	emit_signal("disable_lightning")
	emit_signal("precipitation_ended", "Rain")


func _on_timer_timeout() -> void:
	particles.emitting = true
	timer.stop()


func _on_player_position(player_position: Vector2) -> void:
	var position = player_position + (Vector2.UP * 250)
	particles.position = position


func _on_state_avail_for_changes(is_available: bool) -> void:
	_can_emit_state = is_available
