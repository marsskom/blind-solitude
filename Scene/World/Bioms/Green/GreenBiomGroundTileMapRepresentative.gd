class_name GreenBiomGroundTileMapRepresentative

var tilemap_representative: TileMapRepresentative


func _init():
	tilemap_representative = TileMapRepresentative.new()


func get_tilemap_audio(tilemap: TileMap, tilemap_global_position: Vector2) -> AudioPlayer:
	var tilemap_name = tilemap_representative.get_tile_name_on_position(tilemap, tilemap_global_position)

	match tilemap_name:
		"mainlevbuild.png 3":
			return AudioPlayer.new("res://assets/Bioms/Green/sounds/dirt_run.mp3")
		_:
			return AudioPlayer.new("res://assets/Bioms/Green/sounds/grass_fast.mp3")
