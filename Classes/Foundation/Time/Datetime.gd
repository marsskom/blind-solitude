class_name Datetime

var _days: int = 0 setget , get_days
var _hours: int = 0 setget , get_hours
var _minutes: int = 0 setget , get_minutes

func _init(days: int, hours: int, minutes: int):
	self._days = days
	self._hours = hours
	self._minutes = minutes


func get_days() -> int:
	return _days


func get_hours() -> int:
	return _hours


func get_minutes() -> int:
	return _minutes
