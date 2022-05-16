extends Node

signal day_night_animation_changed
signal available_for_state_changes

export(NodePath) var character_node: NodePath
onready var character: Node2D  = get_node(character_node) as Node2D

onready var clouds_node: Node = $Components/Clouds
onready var rain_node: Node = $Components/Rain
onready var snow_node: Node = $Components/Snow
onready var lightning_node: Node = $Components/LightningGenerator

onready var moon: Moon

var _states_collection: Collection
var _state_machine: StateMachine
var _default_max_clouds_value: int
var _precipitation_in_progress: bool = false

enum STATES {
	DEFAULT,
	RAIN,
	SNOW,
}


func _init():
	moon = Moon.new()


func _ready():
	_states_collection = Collection.new([
		State.new("Default", 0, false),
		State.new("Rain", 1, true),
		State.new("Snow", 2, true),
	])

	_state_machine = StateMachine.new(_states_collection.get("Default"))

	lightning_node.set_enabled(false)

	_default_max_clouds_value = clouds_node.max_clouds_count

	character.connect("player_position", clouds_node, "_on_player_position")
	character.connect("player_position", rain_node, "_on_player_position")
	character.connect("player_position", snow_node, "_on_player_position")

	if rain_node.is_active:
		self.connect("available_for_state_changes", rain_node, "_on_state_avail_for_changes")
		rain_node.connect("increase_max_clouds_to", clouds_node, "set_max_clouds")
		rain_node.connect("precipitation_begin", self, "_on_precipitation_begin")
		rain_node.connect("precipitation_ended", self, "_on_precipitation_ended")

	if lightning_node.is_active:
		rain_node.connect("enable_lightning", self, "_on_enable_lightning")
		rain_node.connect("disable_lightning", self, "_on_disable_lightning")

	if snow_node.is_active:
		self.connect("available_for_state_changes", snow_node, "_on_state_avail_for_changes")
		snow_node.connect("increase_max_clouds_to", clouds_node, "set_max_clouds")
		snow_node.connect("precipitation_begin", self, "_on_precipitation_begin")
		snow_node.connect("precipitation_ended", self, "_on_precipitation_ended")


func _process(_delta):
	var state = _state_machine.get_state()

	match state.get_value():
		STATES.RAIN:
			pass
		STATES.SNOW:
			pass
		STATES.DEFAULT:
			default_state()


func default_state() -> void:
	if moon.is_moon_night_time() and moon.is_full_moon():
		emit_signal("day_night_animation_changed", "MoonLight")
	else:
		emit_signal("day_night_animation_changed", "DayNightCycle")


func _on_precipitation_begin(state_name: String) -> void:
	emit_signal("available_for_state_changes", false)

	if _precipitation_in_progress:
		return

	_state_machine.change(_states_collection.get(state_name))
	_precipitation_in_progress = true


func _on_precipitation_ended(state_name: String) -> void:
	if _state_machine.get_state().get_name() != state_name:
		return

	clouds_node.set_max_clouds(_default_max_clouds_value)
	_state_machine.get_state().unlock()
	_precipitation_in_progress = false

	_state_machine.change(_states_collection.get("Default"))

	emit_signal("available_for_state_changes", true)


func _on_enable_lightning() -> void:
	lightning_node.set_enabled(true)


func _on_disable_lightning() -> void:
	lightning_node.set_enabled(false)
