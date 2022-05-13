extends GutTest

func test_formed_time() -> void:
	var timeSystem: TestTimeSystem = TestTimeSystem.new()
	var dict: Dictionary = timeSystem.formed_datetime(2_450_458)

	assert_eq(dict.minutes, 50)
	assert_eq(dict.hours, 16)
	assert_eq(dict.days, 1)
