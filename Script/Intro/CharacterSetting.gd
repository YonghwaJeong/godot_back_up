extends Control

onready var player_resource = preload("res://Player/Player_Setting.tres")
onready var game_data_default = preload("res://Manager/GameData.gd")
onready var user_name = $Name_Setting/Input_Name
onready var farm_name = $Name_Setting/Input_FarmName
onready var favorite = $Name_Setting/Input_Favorite
onready var pet = $PetPreference
onready var player_appearance = $Appearance/PlayerAppearance
onready var skin_count = $Skin/Skin_count

signal enable_OK
signal disable_OK

func check_inputs():
	if user_name.text != "" and farm_name.text != "" and favorite.text != "" and pet.selection != "":
		emit_signal("enable_OK")
	else:
		emit_signal("disable_OK")
	
func _on_Input_Name_text_changed(new_text):
	check_inputs()

func _on_Input_FarmName_text_changed(new_text):
	check_inputs()

func _on_Input_Favorite_text_changed(new_text):
	check_inputs()
	
func _on_PetPreference_pet_selected():
	check_inputs()

func _on_OK_pressed():
	player_resource.player_name = user_name.text
	player_resource.farm_name = farm_name.text
	player_resource.player_favorite = favorite.text
	player_resource.pet = pet.selection
	player_resource.skin = int(skin_count.text) 
	player_resource.shirts = player_appearance.current_shirts
	player_resource.hair = player_appearance.current_hair
	player_resource.acc = player_appearance.current_acc
	player_resource.hair_color = player_appearance.get_child(3).get_modulate()
	player_resource.pants_color = player_appearance.get_child(0).get_modulate()
	player_resource.eyes_color = player_appearance.get_child(1).material.get_shader_param("eye_color")
	ResourceSaver.save("res://Player/Player_Setting.tres", player_resource)
	var game_data = game_data_default.new()
	ResourceSaver.save("res://Save/game_data.tres", game_data)
	var dir = Directory.new()
	if dir.file_exists("res://Save/inventory_data.txt"):
		dir.remove("res://Save/inventory_data.txt")
	get_tree().change_scene("res://Scene/DayStart.tscn")
