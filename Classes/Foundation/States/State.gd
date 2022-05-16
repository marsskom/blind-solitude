class_name State

signal activated
signal changed

var name: String setget , get_name
var value: int setget , get_value
var is_lockable: bool setget , is_lockable

var _is_locked: bool = false

func _init(name: String, value: int, is_lockable: bool = false):
	self.name = name
	self.value = value
	self.is_lockable = is_lockable

	self.connect("activated", self, "_on_activated")
	self.connect("changed", self, "_on_changed")


func get_name() -> String:
	return name


func get_value() -> int:
	return value


func is_lockable() -> bool:
	return is_lockable


func lock() -> void:
	if not is_lockable():
		Log.error("Status '%s' is not lockable" % get_name())
		return

	_is_locked = true


func unlock() -> void:
	if not is_lockable():
		Log.error("Status '%s' is not lockable" % get_name())
		return

	_is_locked = false


func is_locked() -> bool:
	return _is_locked


func _on_activated():
	if is_lockable():
		lock()


func _on_changed():
	if is_lockable():
		unlock()
