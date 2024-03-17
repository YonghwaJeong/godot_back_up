extends Node2D

onready var pet = $Pet

func _input(event):
	
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			pet.destination = event.position
			print("New Destination")
			pet.set_physics_process(true)
