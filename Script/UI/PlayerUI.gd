extends Control

var player_tracker = preload("res://Player/Player_Tracker.tres")
var game_data = preload("res://Save/game_data.tres")
var player_data = preload("res://Player/Player_Setting.tres")
var player_inventory
var is_interacting = false
var is_pressing_shift = false
var recent_chest_address : String
onready var inventory_container = $Inventory/Backpack/GridContainer
onready var hotbar_container = $Inventory/Hotbar/GridContainer
onready var inventory_hotbar = $Inventory/Hotbar
onready var inventory_backpack = $Inventory/Backpack
onready var chest_interaction = $ChestInteraction
onready var chest_container = $ChestInteraction/ChestGrid
onready var interacting_inv_container = $ChestInteraction/InventoryGrid
onready var time = $Clock/Current_time
onready var date = $Clock/Current_date
onready var gold = $Clock/Current_gold
onready var container = $Inventory/Backpack/GridContainer
onready var pause_bt = $Pause
onready var resume_bt = $Resume
onready var nextday_bt = $NextDay
onready var backgroundshadow = $BackGroundShadow
var day_list : Array = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
var day_of_week : String
# current in-game time in min / initial value = 6:00 am
var total_time : int 
signal UI_onready
signal pause_time
signal resume_time

func _ready():
	inventory_backpack.visible = false
	inventory_hotbar.visible = true
	total_time = player_tracker.current_time
	connect("tree_exiting", self, "_on_PlayerUI_tree_exiting")
	pause_bt.connect("pressed", self, "_on_Pause_pressed")
	resume_bt.connect("pressed", self, "_on_Resume_pressed")
	nextday_bt.connect("pressed", self, "_on_NextDay_pressed")
	connect("UI_onready", GameManager, "_on_UI_onready")
	emit_signal("UI_onready", self)
	
	day_of_week = day_list[game_data.day%7]
	date.text = "%s.%d" %[day_of_week, game_data.day]
	gold.text = "%d" % player_data.money

	var hour = total_time / 60
	var minute = total_time - hour * 60
	time.text = "%0*d:%0*d" %[2, hour, 2, minute]

func _process(_delta):
	
	if Input.is_action_just_pressed("Inventory"):
		if is_interacting:
				return
		inventory_hotbar.visible = !inventory_hotbar.visible
		inventory_backpack.visible = !inventory_backpack.visible
		if inventory_hotbar.visible:
			player_inventory.inventory_to_hotbar()
			backgroundshadow.color = Color(0,0,0,0)
			emit_signal("resume_time")
		elif inventory_backpack.visible:
			player_inventory.hotbar_to_inventory()
			backgroundshadow.color = Color(0,0,0,0.5)
			emit_signal("pause_time")

	if Input.is_action_just_pressed("Esc"):
		if is_interacting:
			close_chest(recent_chest_address)
		
func open_chest(address):
	player_inventory.load_chest_data(address)
	recent_chest_address = address
	inventory_hotbar.visible = false
	chest_interaction.visible = true
	player_inventory.inventory_to_interacting_inv()
	backgroundshadow.color = Color(0,0,0,0.5)
	emit_signal("pause_time")
	is_interacting = true

func close_chest(address):
	player_inventory.save_chest_data(address)
	inventory_hotbar.visible = true
	chest_interaction.visible = false
	player_inventory.close_chest_interaction()
	backgroundshadow.color = Color(0,0,0,0)
	emit_signal("resume_time")
	is_interacting = false

func _on_timeout():
	total_time += 1
	GameManager.worldTime += 1
	var hour = total_time / 60
	var minute = total_time - hour * 60
	time.text = "%0*d:%0*d" %[2, hour, 2, minute]

func _on_Pause_pressed():
	emit_signal("pause_time")
	
func _on_Resume_pressed():
	emit_signal("resume_time")

func _on_NextDay_pressed():
	game_data.day += 1
	ResourceSaver.save("res://Save/game_data.tres", game_data)
	SceneChanger.change_scene("res://Scene/DayStart.tscn")
	
func _on_PlayerUI_tree_exiting():
	player_tracker.current_time = total_time
	ResourceSaver.save("res://Player/Player_Tracker.tres", player_tracker)
