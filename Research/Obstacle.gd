extends StaticBody2D

onready var tilemap = get_parent().get_child(0)
var is_mouse_entering : bool = false

func _ready():
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("mouse_exited", self, "_on_mouse_exited")
	
func _on_mouse_entered():
	is_mouse_entering = true

func _on_mouse_exited():
	is_mouse_entering = false

func _unhandled_input(event):
	
	if !(is_mouse_entering):
		return
	
	if (event is InputEventMouseButton && event.is_pressed() && event.button_index == BUTTON_RIGHT):
		tilemap.astar.set_point_disabled(tilemap.id(tilemap.world_to_map(self.global_position)), false)
		self.queue_free()
		
