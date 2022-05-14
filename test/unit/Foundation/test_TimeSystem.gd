extends GutTest

func test_formed_time() -> void:
	var datetime: Datetime = TimeSystem.get_datetime(1687)

	assert_eq(datetime.get_minutes(), 7)
	assert_eq(datetime.get_hours(), 4)
	assert_eq(datetime.get_days(), 1)


func test_game_time_without_start() -> void:
	var datetime: Datetime = TimeSystem.get_current_datetime()

	assert_eq(datetime.get_minutes(), 0)
	assert_eq(datetime.get_hours(), 9)
	assert_eq(datetime.get_days(), 0)
