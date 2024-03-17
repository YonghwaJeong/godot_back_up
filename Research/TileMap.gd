extends Astar_Path

var player

func _input(event):
	
	if !player:
		return
		
	if (event is InputEventMouseButton && event.is_pressed() && event.button_index == BUTTON_LEFT):
		var global_mouse_pos = world_to_map(get_global_mouse_position())
		set_path(world_to_map(player.global_position), global_mouse_pos)

func set_path(point1, point2):
	get_astar_path(point1, point2)
	player.path = path
