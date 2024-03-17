extends Node

func change_scene(path : String):
	GameManager.initialize_player()
	get_tree().change_scene(path)

func change_scene_to(scene : PackedScene):
	GameManager.initialize_player()
	get_tree().change_scene_to(scene)
