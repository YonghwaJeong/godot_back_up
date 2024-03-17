extends Node2D

onready var player = $Player

func _input(event):
	
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			player.destination = event.position
			player.is_on_point = false
			print("New Destination")
