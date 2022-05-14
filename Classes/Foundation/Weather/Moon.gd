class_name Moon

func is_full_moon() -> bool:
	var datetime: Datetime = TimeSystem.get_current_datetime()

	return datetime.get_days() % 23 == 0
