extends Node

func debug(message) -> void:
	if !OS.is_debug_build():
		return

	_print("DEBUG", message)


func info(message) -> void:
	if !OS.is_debug_build():
		return

	_print("INFO", message)


func warning(message) -> void:
	_print("WARNING", message)


func error(message) -> void:
	_print("ERROR", message)


func critical(message) -> void:
	_print("CRITICAL", message)


func _print(category: String, message) -> void:
	if ProjectSettings.get_setting("logging/file_logging/enable_file_logging"):
		var date_time: Dictionary = OS.get_datetime()
		var format = "%02d:%02d:%02d [%s] " % [
			date_time.hour,
			date_time.minute,
			date_time.second,
			category
		]

		print(format, message)

		match category:
			"WARNING":
				push_warning(message)
			"CRITICAL":
				push_error(message)
			"ERROR":
				push_error(message)
