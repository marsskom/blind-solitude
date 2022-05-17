class_name TileMapRepresentative


func get_tile_name_on_position(tilemap: TileMap, tilemap_global_position: Vector2) -> String:
	var local_position = tilemap.to_local(tilemap_global_position)
	var tile_position = tilemap.world_to_map(local_position)
	var tile_id = tilemap.get_cellv(tile_position)

	return tilemap.tile_set.tile_get_name(tile_id)
