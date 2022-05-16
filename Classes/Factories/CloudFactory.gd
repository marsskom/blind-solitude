class_name CloudFactory


static func get_cloud_appear_region(
	wind_direction: Vector2,
	cloud: Cloud,
	object_position: Vector2 = Vector2.ZERO
	) -> Rect2:
	var distance_vector = Vector2(cloud.max_distance_from_player, cloud.max_distance_from_player)

	var rect_width = max(cloud.max_distance_from_player / 2 - 100, 200)
	var rect_size = Vector2(rect_width, rect_width)

	var opposite_to_wind = wind_direction * -1
	var position = opposite_to_wind * distance_vector
	var relative_position = object_position + position

	return Rect2(relative_position - rect_size, rect_size * 2)
