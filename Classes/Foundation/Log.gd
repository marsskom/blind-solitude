extends Node

func debug(message: String) -> void:
	if !OS.is_debug_build():
		return

	self.__print("DEBUG", message)


func info(message: String) -> void:
	if !OS.is_debug_build():
		return

	self.__print("INFO", message)


func warning(message: String) -> void:
	self.__print("WARNING", message)


func error(message: String) -> void:
	self.__print("ERROR", message)


func critical(message: String) -> void:
	self.__print("CRITICAL", message)


func __print(category: String, message: String) -> void:
	if ProjectSettings.get_setting("logging/file_logging/enable_file_logging"):
		var date_time: Dictionary = OS.get_datetime()
		print(
			"%02d:%02d:%02d [%s] "
				% [date_time.hour, date_time.minute, date_time.second, category],
			message
		)
