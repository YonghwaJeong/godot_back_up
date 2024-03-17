extends ColorRect

onready var selected = $Selected
export var selected_slot = 0 setget set_selected_slot

func _ready():
	GameManager.connect("player_initialized", self, "_on_player_initialized")

func _on_player_initialized(_player):
	GameManager.update_current_tool(selected_slot)

func _input(event):
	
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				if selected.rect_position.x == 0:
					selected.rect_position.x = 32*11
					self.selected_slot = 11
				else:
					selected.rect_position.x -= 32
					self.selected_slot -= 1
				
			if event.button_index == BUTTON_WHEEL_DOWN:
				if selected.rect_position.x == 352:
					selected.rect_position.x = 0
					self.selected_slot = 0
				else:
					selected.rect_position.x += 32
					self.selected_slot += 1
					
	if event is InputEventKey:
		if event.is_pressed():
			if event.scancode == KEY_QUOTELEFT:
				selected.rect_position.x = 0
			if event.scancode == KEY_1:
				selected.rect_position.x = 32 * 1
			if event.scancode == KEY_2:
				selected.rect_position.x = 32 * 2
			if event.scancode == KEY_3:
				selected.rect_position.x = 32 * 3
			if event.scancode == KEY_4:
				selected.rect_position.x = 32 * 4
			if event.scancode == KEY_5:
				selected.rect_position.x = 32 * 5
			if event.scancode == KEY_6:
				selected.rect_position.x = 32 * 6
			if event.scancode == KEY_7:
				selected.rect_position.x = 32 * 7
			if event.scancode == KEY_8:
				selected.rect_position.x = 32 * 8
			if event.scancode == KEY_9:
				selected.rect_position.x = 32 * 9
			if event.scancode == KEY_0:
				selected.rect_position.x = 32 * 10
			if event.scancode == KEY_MINUS:
				selected.rect_position.x = 32 * 11

func set_selected_slot(value):
	selected_slot = value
	GameManager.update_current_tool(selected_slot)
