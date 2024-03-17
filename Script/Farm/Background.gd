extends Astar_Path

var pet

func _input(event):
	
	if !pet:
		return
		
	if (event is InputEventMouseButton && event.is_pressed() && event.button_index == BUTTON_RIGHT):
		var global_mouse_pos = world_to_map(get_global_mouse_position())
		set_path(world_to_map(pet.global_position), global_mouse_pos)

func set_path(point1, point2):
	get_astar_path(point1, point2)
	pet.path = path
