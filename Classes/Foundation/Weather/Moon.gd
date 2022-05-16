class_name Moon

func is_moon_night_time() -> bool:
	var datetime: Datetime = TimeSystem.get_current_datetime()
	var hours = datetime.get_hours()

	return hours >= 0 and hours <= 4


func is_full_moon() -> bool:
	var datetime: Datetime = TimeSystem.get_current_datetime()

	return datetime.get_days() % 23 == 0
