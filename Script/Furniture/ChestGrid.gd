extends GridContainer

func _ready():
	GameManager.connect("player_initialized", self, "_on_player_initialized")

func _on_player_initialized(player):
	player.inventory.connect("inventory_changed", self, "_on_player_inventory_changed")
	# will be called only once per game run or player_initialization
	_on_player_inventory_changed(player.inventory)
			
func _on_player_inventory_changed(inventory):
	# redraw every slots again
	for slot in inventory.chest_slots:
		slot.visual_update()
