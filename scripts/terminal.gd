extends StaticBody3D

@export_file("*.txt") var message_path: String = "res://data/terminal_message.txt"

var _cached_message: String = ""


func _ready() -> void:
	add_to_group("terminal")
	collision_layer = 4
	collision_mask = 0
	_cached_message = _load_message()


func get_message() -> String:
	if _cached_message.is_empty():
		_cached_message = _load_message()
	return _cached_message


func _load_message() -> String:
	if message_path.is_empty():
		return "NO DATA"
	if not FileAccess.file_exists(message_path):
		push_warning("Terminal message missing: %s" % message_path)
		return "ERROR: MESSAGE FILE NOT FOUND"
	var file := FileAccess.open(message_path, FileAccess.READ)
	if file == null:
		return "ERROR: CANNOT READ MESSAGE"
	return file.get_as_text().strip_edges()
