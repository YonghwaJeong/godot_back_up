extends Node2D

onready var house = $Floor
onready var farm = $Farm
var current_scene

func on_entered_mainscene(scene):
	current_scene = scene
	if current_scene.name == "FarmHandler":
		print("You've entered to the Farm")
		
# Using Scene data, calculate NPC path and place them in current scene if needed
