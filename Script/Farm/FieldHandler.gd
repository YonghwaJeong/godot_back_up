extends Node2D

onready var ground = $Background
onready var hoed = $Hoed
onready var watered = $PlaceHolder/Watered
onready var plants = $Plants
onready var pet = $FarmObjects/Pet
onready var pet_detectable_area = $FarmObjects/Pet/Detectable
onready var player = GameManager.player
onready var watered_area = preload("res://Scene/Area/WateredArea.tscn")
onready var indicator = preload("res://Trash/indicator.tscn")
enum {MOVE, ATTACK, HOE, WATERING, FISHING, MINING, LUMBERING}
enum {COSUMABLE, WEAPON, FARMINGTOOL, EQUIPMENT, FURNITURE, SEED}

func _ready():
	yield(get_tree(), "idle_frame")
	ground.pet = $FarmObjects/Pet
	pet.tilemap = ground
	pet.watered = watered
	pet_detectable_area.tilemap = ground
	pet_detectable_area.pet = pet
	pet_detectable_area.hoed = hoed
	pet_detectable_area.watered = watered
	$FarmObjects/Pet/AnimationTree.active = true

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			var click_pos = get_global_mouse_position()
			var player_pos = player.global_position + Vector2(0,8)
			var click_grid_pos = ground.world_to_map(click_pos)
			var player_grid_pos = ground.world_to_map(player_pos)
			
			var is_out_range : bool = (abs(click_grid_pos.x - player_grid_pos.x) > 1 or abs(click_grid_pos.y - player_grid_pos.y) > 1)
			
			var direction_vector = player_pos.direction_to(click_pos)
			if abs(direction_vector.x) >= abs(direction_vector.y):
				player.set_direction(Vector2(direction_vector.x, 0).normalized())
			else:
				player.set_direction(Vector2(0, direction_vector.y).normalized())
			player_action(click_pos, is_out_range)
			
func player_action(click_pos, is_out_range):
	if player.current_tool == null:
		return
	match player.current_tool.type:
		
		FARMINGTOOL:
			
			if is_out_range:
				return
			
			match player.current_tool.name:
			
				"Hoe":
					player.state = HOE
					yield(get_tree().create_timer(0.4),"timeout")
					var grid_position = ground.world_to_map(click_pos)
					hoe_ground(grid_position)	
				
				"Axe":
					player.state = LUMBERING
				
				"Pickaxe":
					player.state = MINING
				
				"WateringCan":
					player.state = WATERING
					yield(get_tree().create_timer(0.4),"timeout")
					var grid_position = ground.world_to_map(player.tool_hitbox.global_position)
					water_ground(grid_position)
					var new_watered_area = watered_area.instance()
					watered.add_child(new_watered_area, true)
					new_watered_area.position = watered.map_to_world(grid_position) + Vector2(8,8)
					new_watered_area.set_owner(watered)
		
		SEED:
			
			if is_out_range:
				return
			
			if player.seedable and hoed.get_cellv(hoed.world_to_map(player.tool_hitbox.global_position)) == 0:
				var plant_scene = load("res://Scene/Crops/Spring/%s.tscn" %player.current_tool.subname)
				var plant_position = ground.map_to_world(ground.world_to_map(player.tool_hitbox.global_position)) + Vector2(8,8)
				var new_plant = plant_scene.instance()
				plants.add_child(new_plant, true)
				new_plant.position = plant_position
				new_plant.set_owner(get_parent())
				new_plant.connect("in_area", player, "change_seedable")
				new_plant.connect("out_area", player, "change_seedable")
			else:
				print("can't use seed")
		
		WEAPON:
			
			player.state = ATTACK
			
func hoe_ground(pos):
	if ground.get_cellv(pos) in [0,1,2,3,4,5,6]:
		hoed.set_cellv(pos, 0)
		hoed.update_bitmask_region(pos)

func water_ground(pos):
	if hoed.get_cellv(pos) == 0:
		watered.set_cellv(pos, 1)
		watered.update_bitmask_region(pos)

func clear_watered_area():
	for node in watered.get_children():
		node.queue_free()
	watered.clear()
