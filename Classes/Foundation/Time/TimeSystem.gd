extends Node

var __minute_ticks: int = 1000
var __hour_ticks: int = __minute_ticks * 60
var __day_ticks: int = __hour_ticks * 24

var __last_miliseconds: int = 0


func _process(delta):
	# TODO: usage of ticks is wrong way
	var miliseconds = OS.get_ticks_msec()
	self.formed_datetime(miliseconds)

	self.__last_miliseconds = miliseconds


func formed_datetime(miliseconds: int) -> Dictionary:
	var diff = miliseconds - self.__last_miliseconds

	return {
		"minutes": floor((miliseconds / self.__minute_ticks) % 60) as int,
		"hours": floor((miliseconds / self.__hour_ticks) % 24) as int,
		"days": floor(miliseconds / self.__day_ticks) as int,
	}
