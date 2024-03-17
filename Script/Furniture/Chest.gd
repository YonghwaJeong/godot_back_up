extends StaticBody2D

export var address : String
onready var detect_area = $ChestArea

func _ready():
	address = get_parent().name + self.name

func _unhandled_input(event):
	
	if !(event is InputEventMouseButton):
		return
		
	if !(event.button_index == BUTTON_LEFT and event.pressed):
		return
		
	if detect_area.get_overlapping_bodies().size() == 0:
		return
	
	GameManager.player_ui.open_chest(address)
