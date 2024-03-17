extends Node

var game_data = preload("res://Save/game_data.tres")
var player_tracker = preload("res://Player/Player_Tracker.tres")
onready var season = $Season
onready var day = $Day
onready var animationPlayer = $AnimationPlayer

func _ready():
	
	initialize_player_tracker()
	GameManager.day_reset = true
	
	season.text = game_data.season
	if game_data.day in [1, 21]:
		day.text = "%dst" %game_data.day
	elif game_data.day in [2, 22]:
		day.text = "%dnd" %game_data.day
	elif game_data.day in [3, 23]:
		day.text = "%drd" %game_data.day
	else:
		day.text = "%dth" %game_data.day
	
	animationPlayer.play("Default")
	
	var dir = Directory.new()
	if dir.file_exists("res://Save/watered_saved.tscn"):
		dir.remove("res://Save/watered_saved.tscn")
		
	yield(animationPlayer, "animation_finished")
	
	var save_file = File.new()
	if save_file.file_exists("res://Save/house_saved.tscn"):
		SceneChanger.change_scene("res://Save/house_saved.tscn")
	else:
		SceneChanger.change_scene("res://Scene/HouseHandler.tscn")
	
func initialize_player_tracker():
	player_tracker.last_direction = Vector2(-1,0)
	player_tracker.player_position = Vector2(408,224)
	player_tracker.current_time = 360
	ResourceSaver.save("res://Player/Player_Tracker.tres", player_tracker)
