extends Node

onready var animationPlayer = $AnimationPlayer
onready var houseObjects = $House_Functional
onready var selection = $House_Functional/Selection
onready var placableArea = $House_Functional/Selection/Placable
onready var selection_collider = $House_Functional/Selection/Area2D/CollisionShape2D
onready var selection_area = $House_Functional/Selection/Area2D
onready var baseTilemap = $House_Functional/baseGrid
onready var img_notplacable = preload("res://Assets/Others/NotPlacable.png")
onready var img_placable = preload("res://Assets/Others/Placable.png")
onready var player = GameManager.player
var furniture_placable : bool = false
enum {COSUMABLE, WEAPON, FARMINGTOOL, EQUIPMENT, FURNITURE, SEED}

func _on_Portal_body_entered(body):
	body.player_tracker.player_position = Vector2(577,92)
	ResourceSaver.save("res://Player/Player_Tracker.tres", body.player_tracker)
	save_house()
	animationPlayer.play("FadeOut")
	yield(animationPlayer, "animation_finished")
	var save_file = File.new()
	if save_file.file_exists("res://Save/farm_saved.tscn"):
		SceneChanger.change_scene("res://Save/farm_saved.tscn")
	else:
		SceneChanger.change_scene("res://Scene/FarmHandler.tscn")

func save_house():
	var packed_scene = PackedScene.new()
	packed_scene.pack(get_tree().get_current_scene())
	ResourceSaver.save("res://Save/house_saved.tscn", packed_scene)

func _physics_process(delta):
	if player.current_tool == null:
		return
	if player.current_tool.type != FURNITURE:
		selection.texture = null
		placableArea.texture = null
		selection_collider.visible = false
		furniture_placable = false
		placableArea.region_rect.size = Vector2(64,64)
		selection_collider.scale = Vector2(0.99,0.99)
	match player.current_tool.type:
		FURNITURE:
			
			# -------------Build Selection------------------#
			var mouse_pos = baseTilemap.get_local_mouse_position()
			var grid_pos = baseTilemap.world_to_map(mouse_pos)
			var texture = player.current_tool.texture
			selection.texture = texture
			placableArea.region_rect.size.x = 64 * player.current_tool.size.x
			placableArea.region_rect.size.y = 64 * player.current_tool.size.y
			selection_collider.scale.x = 0.99 * player.current_tool.size.x 
			selection_collider.scale.y = 0.99 *  player.current_tool.size.y
			selection_collider.visible = true
			selection.position = baseTilemap.map_to_world(grid_pos)
			if selection_area.get_overlapping_bodies().size() != 0:
				placableArea.texture = img_notplacable
				furniture_placable = false
			else:
				placableArea.texture = img_placable
				furniture_placable = true

			#------------------Placement-------------------#
			if Input.is_action_pressed("LeftClick") and furniture_placable:
				var furnitureResource = load("res://Scene/Furnitures/%s.tscn" %player.current_tool.name)
				var new_furniture = furnitureResource.instance()
				new_furniture.position = baseTilemap.map_to_world(grid_pos)
				houseObjects.add_child(new_furniture, true)
