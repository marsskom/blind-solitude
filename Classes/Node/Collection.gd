class_name Collection

var _collection: Dictionary = {} setget , get_all

func _init(nodes: Array):
	for node in nodes:
		_collection[node.name] = node


func append(name: String, node) -> void:
	_collection[name] = node


func get(name: String):
	return _collection[name]


func filter(property: String, value) -> Dictionary:
	var filtered: Dictionary = {}

	for key in _collection.keys():
		var obj = _collection[key]

		if not property in obj:
			continue

		if obj.get(property) == value:
			filtered[key] = obj

	return filtered


func get_all() -> Dictionary:
	return _collection


func keys() -> Array:
	return _collection.keys()


func values() -> Array:
	return _collection.values()
