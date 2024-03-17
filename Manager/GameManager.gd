extends Node

var inventory_slot = load("res://Scene/InventorySlot.tscn")
var object_item = load("res://Scene/Item/Item.tscn")
var player_ui = null
var player = null
var day_reset = true
var worldTime = 360
signal player_initialized

# In-game Cursor
onready var cursor = preload("res://Assets/cursor.png")

func _ready():
	Input.set_custom_mouse_cursor(cursor)
	self.pause_mode = Node.PAUSE_MODE_PROCESS

func _process(_delta):
	if Input.is_action_just_pressed("screen_shot"):
		take_screen_shot()
		
func _on_UI_onready(Ui_node):
	player_ui = Ui_node
	start_timeflow()
	build_slots()

func _on_player_onready(current_player):
	current_player.inventory.connect("inventory_changed", self, "_on_player_inventory_changed")
	player = current_player
	build_slots()
	
func build_slots():
	if player_ui == null or player == null:
		return
	
	player_ui.player_inventory = player.inventory
	
	# i don't know why but it works 
	if player.inventory.slots.size() != 0:
		player.inventory.slots = []
	
	#-----------------create inventory---------------------
	
	for i in player.inventory.inventory_max_size:
		var new_slot = inventory_slot.instance()
		player.inventory.slots.append(new_slot)
		player_ui.inventory_container.add_child(new_slot, true)
		new_slot.connect("inventory_slot_changed", player.inventory, "_on_inventory_slot_changed")

	#-------------initialize all slots-------------------

	if player.inventory.hotbar_slots.size() != 0:
		player.inventory.hotbar_slots = []
	
	if player.inventory.interacting_inv_slots.size() != 0:
		player.inventory.interacting_inv_slots = []
		
	if player.inventory.chest_slots.size() != 0:
		player.inventory.chest_slots = []
	
	#----------------load inv data---------------------
	
	var save_file = File.new()
	if save_file.file_exists("res://Save/inventory_data.txt"):
		var data = player.inventory.load_data()
		for i in player.inventory.slots.size():
			player.inventory.slots[i].item = data[i].item
			player.inventory.slots[i].quantity = data[i].quantity
	else:
		player.inventory.add_item(player.inventory.slots, "Scythe", 1)
		player.inventory.add_item(player.inventory.slots, "Hoe", 1)
		player.inventory.add_item(player.inventory.slots, "Pickaxe", 1)
		player.inventory.add_item(player.inventory.slots, "WateringCan", 1)
		player.inventory.add_item(player.inventory.slots, "Axe", 1)
		player.inventory.add_item(player.inventory.slots, "Chest", 1)
		player.inventory.add_item(player.inventory.slots, "Bed", 1)
		player.inventory.add_item(player.inventory.slots, "ParsnipSeed", 1)
		player.inventory.add_item(player.inventory.slots, "KaleSeed", 1)
		player.inventory.add_item(player.inventory.slots, "PotatoSeed", 1)
		player.inventory.add_item(player.inventory.slots, "CauliflowerSeed", 1)
		player.inventory.add_item(player.inventory.slots, "GarlicSeed", 1)
		player.inventory.add_item(player.inventory.slots, "RhubarbSeed", 1)
		player.inventory.record_data()
	
	# --------------create hotbar--------------------
	
	for i in player.inventory.hotbar_max_size:
		var new_slot = inventory_slot.instance()
		new_slot.item = player.inventory.slots[i].item
		new_slot.quantity = player.inventory.slots[i].quantity
		new_slot.connect("inventory_slot_changed", player.inventory, "_on_inventory_slot_changed")
		player.inventory.hotbar_slots.append(new_slot)
		player_ui.hotbar_container.add_child(new_slot, true)
	
	# ------------create slots for interaction------------
		
	for i in range(0, 36):
		var new_slot = 	inventory_slot.instance()
		new_slot.connect("inventory_slot_changed", player.inventory, "_on_inventory_slot_changed")
		player.inventory.chest_slots.append(new_slot)
		player_ui.chest_container.add_child(new_slot, true)
	
	for i in player.inventory.inventory_max_size:
		var new_slot = 	inventory_slot.instance()
		new_slot.connect("inventory_slot_changed", player.inventory, "_on_inventory_slot_changed")
		player.inventory.interacting_inv_slots.append(new_slot)
		player_ui.interacting_inv_container.add_child(new_slot, true)

	emit_signal("player_initialized", player)

func _on_player_inventory_changed(inventory):
	pass

func start_timeflow():
	var timer = Timer.new()
	timer.connect("timeout", player_ui, "_on_timeout")
	player_ui.connect("pause_time", timer, "set_paused", [true])
	player_ui.connect("pause_time", self, "pause_game")
	player_ui.connect("resume_time", timer, "set_paused", [false])
	player_ui.connect("resume_time", self, "resume_game")
	timer.wait_time = 1
	add_child(timer)
	timer.start()

func pause_game():
	get_tree().paused = true
	
func resume_game():
	get_tree().paused = false

# player and UI exits tree, but variable still saves value
func initialize_player():
	player = null
	player_ui = null

func update_current_tool(slot_num):
	if player == null:
		return
	if player.inventory.slots[slot_num].item != null:
		player.current_tool = player.inventory.slots[slot_num].item
	else:
		player.current_tool = null

func take_screen_shot():
	var time = OS.get_time()
	var dir = Directory.new()
	var current_time = String(time.hour) + String(time.minute) + String(time.second)
	yield(VisualServer, "frame_post_draw")
	var img = get_viewport().get_texture().get_data()
	img.flip_y()
	if !(dir.dir_exists("C:/Users/CKIRUser/Desktop/ScreenShot")):
		dir.make_dir("C:/Users/CKIRUser/Desktop/ScreenShot")
	img.save_png("C:/Users/CKIRUser/Desktop/ScreenShot/%s%s.png" %[get_tree().get_current_scene().name, current_time])
	
func spawn_item(parent_node, pos : Vector2, item_name : String, item_quantity : int):
	var target_item = ItemDatabase.get_item(item_name)
	for i in item_quantity:
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		var new_item_object = object_item.instance()
		new_item_object.item = target_item
		new_item_object.global_position = pos + Vector2(rng.randf_range(5,-5), rng.randf_range(5,-5))
		parent_node.call_deferred("add_child", new_item_object)
