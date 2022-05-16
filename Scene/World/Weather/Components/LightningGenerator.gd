# Thanks: https://www.youtube.com/watch?v=Hyq7KixGyHY
extends Node2D
class_name LightningGenerator

signal lightning_flashed

export(bool) var is_enabled: bool = true
export(bool) var has_sub_forks: bool = true

export(NodePath) var camera_node: NodePath
onready var camera: Camera2D  = get_node(camera_node) as Camera2D

var _forks_array: Array = []
var _fork_count: int = 1
var _sub_fork_count: int = 10
var _sub_fork_length: float = 150
var _fork_offset: int = 300
var _length_offset: float = 1

onready var rand_generator: RandomNumberGenerator = RandomNumberGenerator.new()

onready var lightning_scene: PackedScene = preload("res://Scene/World/Weather/Components/Lightning.tscn")
onready var flash: Control = $CanvasLayer/Flash
onready var timer: Timer = $Timer
onready var path_follow: PathFollow2D = $Path2D/PathFollow2D


func _ready():
	randomize()

	timer.connect("timeout", self, "_on_timer_timeout")
	timer.start(10)


func _process(_delta):
	if not is_enabled:
		timer.stop()


func _on_timer_timeout() -> void:
	path_follow.offset = randi()
	var start = path_follow.position

	create(start, start * 6.66)

	timer.start(randi() % 9 + 1)


func create(start_position: Vector2, target_position: Vector2):
	_forks_array.clear()

	var target: Vector2
	var normalized: Vector2
	var from: Vector2

	for fork in range(0, _fork_count):
		var lightning_instance: Lightning = lightning_scene.instance()

		if fork == 0:
			target = start_position
		else:
			var rand = rand_range(-_fork_offset, _fork_offset)
			target = (start_position + normalized * rand) * randf()

		from = target - target_position

		if has_sub_forks:
			_sub_fork_count = from.length() / 40
			_sub_fork_length = from.length() / 5

		normalized = Vector2(from.y, -from.x).normalized()

		_blink(lightning_instance, start_position, target, from, normalized)

		_forks_array.append(lightning_instance)

		if _sub_fork_count > 0:
			for sub_fork in range(0, _sub_fork_count):
				var index: int = rand_range(0, _forks_array.size() - 1) as int
				var picked_fork: Lightning = _forks_array[index]
				var rand_point: int = rand_range(0, picked_fork.get_point_count() - 1) as int

				_forked(
					target,
					normalized,
					picked_fork.get_point_position(rand_point)
				)

	_flash()


func _forked(target: Vector2, normalized: Vector2, point: Vector2) -> void:
	var lightning_instance: Lightning = lightning_scene.instance()
	var rand = rand_range(-_sub_fork_length, _sub_fork_length)
	var fork_target: Vector2 = (point + normalized * rand) + (target / 4) * randf()
	var fork_from = fork_target - point
	var fork_normalized: Vector2 = Vector2(fork_from.y, -fork_from.x).normalized()

	_blink(lightning_instance, point, fork_target, fork_from, fork_normalized)


func _blink(
	lightning_instance: Lightning,
	start_point: Vector2,
	target: Vector2,
	from: Vector2,
	normalized: Vector2
	) -> void:

	add_child(lightning_instance)
	lightning_instance.set_start(start_point)
	lightning_instance.set_end(target)
	lightning_instance.segmentize(from, start_point)
	lightning_instance.sway(normalized)

	_frame(lightning_instance)


func _frame(lightning_instance: Lightning) -> void:
	yield(get_tree(), "idle_frame")
	lightning_instance.animation_player.play("Fade")


func _flash() -> void:
	yield(get_tree(), "idle_frame")
	flash.visible = !flash.visible
	yield(get_tree(), "idle_frame")
	flash.visible = !flash.visible

	emit_signal("lightning_flashed")
