class_name Datetime

var days: int = 0 setget , get_days
var hours: int = 0 setget , get_hours
var minutes: int = 0 setget , get_minutes

func _init(days: int, hours: int, minutes: int):
	self.days = days
	self.hours = hours
	self.minutes = minutes


func get_days() -> int:
	return days


func get_hours() -> int:
	return hours


func get_minutes() -> int:
	return minutes
