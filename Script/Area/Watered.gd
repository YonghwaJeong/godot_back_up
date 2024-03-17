extends TileMap

func _ready():
	var save_file = File.new()
	if save_file.file_exists("res://Save/watered_saved.tscn"):
		var new_node = load("res://Save/watered_saved.tscn").instance()
		self.replace_by(new_node)
