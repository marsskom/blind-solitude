extends Node
class_name TileMapSoundComponent

signal audio_player_registered

var _ground_tilemap
var _tilemap_representative
var _player_position: Vector2
var _player_state: State
var _audio_player: AudioPlayer

func _init(ground_tilemap, tilemap_representative, player: KinematicBody2D):
	_ground_tilemap = ground_tilemap
	_tilemap_representative = tilemap_representative

	player.connect("player_position", self, "_on_player_position")
	player.connect("state_changed", self, "_on_player_state")


func _physics_process(_delta):
	if null == _player_state:
		return

	if "Move" != _player_state.get_name():
		player_stop_walking()
		return

	player_walking()


func _on_player_position(player_position: Vector2) -> void:
	_player_position = player_position


func _on_player_state(state: State) -> void:
	_player_state = state


func player_stop_walking() -> void:
	if null != _audio_player:
		_audio_player.stop()


func player_walking() -> void:
	var audio_player = _tilemap_representative.get_tilemap_audio(_ground_tilemap, _player_position)
	if null != _audio_player and audio_player.is_equal(_audio_player):
		if not _audio_player.playing():
			_audio_player.play()

		return

	if null != _audio_player:
		_audio_player.stop()
		remove_child(_audio_player)
		_audio_player.queue_free()

	_audio_player = audio_player
	add_child(_audio_player)
	_audio_player.play()
