extends Node2D

func _ready():
	var save_file = File.new()
	if save_file.file_exists("res://Save/watered_saved.tscn"):
		var new_scene = load("res://Save/watered_saved.tscn").instance()
		add_child(new_scene, true)
		new_scene.set_owner(self)
	else:
		var original_scene = load("res://Scene/Area/Watered.tscn").instance()
		add_child(original_scene, true)
		original_scene.set_owner(self)
