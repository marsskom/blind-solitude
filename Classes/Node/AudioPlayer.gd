extends Node
class_name AudioPlayer

var _audio_file: String setget , get_aufio_file
var _player: AudioStreamPlayer setget , get_player
var _as_child: bool = false


func _init(audio_file: String):
	self._audio_file = audio_file

	var sfx = load(get_aufio_file())
	sfx.set_loop(true)

	_player = AudioStreamPlayer.new()
	_player.stream = sfx
	_player.bus = SoundBus.FOOT_STEPS


func get_aufio_file() -> String:
	return _audio_file


func get_player() -> AudioStreamPlayer:
	return _player


func is_equal(player: AudioPlayer) -> bool:
	return get_aufio_file() == player.get_aufio_file()


func play() -> void:
	if not _as_child:
		add_child(get_player())
		_as_child = true

	get_player().play()


func playing() -> bool:
	return get_player().playing


func stop() -> void:
	get_player().stop()
