extends Node

onready var animationPlayer = $AnimationPlayer
onready var fieldHandler = $FieldHandler
onready var watered = $FieldHandler/PlaceHolder/Watered
onready var pet_collecting_area = $FieldHandler/FarmObjects/Pet/Collecting
signal entered_mainscene

func _ready():
	yield(get_tree().create_timer(0.1), "timeout")
	GameManager.day_reset = false

func _on_ToHome_body_entered(body : KinematicBody2D):
	body.player_tracker.player_position = Vector2(288,256)
	ResourceSaver.save("res://Player/Player_Tracker.tres", body.player_tracker)
	save_farm_data()
	save_watered_area()
	animationPlayer.play("FadeOut")
	yield(animationPlayer, "animation_finished")
	var save_file = File.new()
	if save_file.file_exists("res://Save/house_saved.tscn"):
		SceneChanger.change_scene("res://Save/house_saved.tscn")
	else:
		SceneChanger.change_scene("res://Scene/HouseHandler.tscn")

func save_farm_data():
	var packed_scene = PackedScene.new()
	packed_scene.pack(get_tree().get_current_scene())
	ResourceSaver.save("res://Save/farm_saved.tscn", packed_scene)

func save_watered_area():
	var packed_scene = PackedScene.new()
	packed_scene.pack(watered)
	ResourceSaver.save("res://Save/watered_saved.tscn", packed_scene)

func _on_FarmHandler_tree_entered():
	self.connect("entered_mainscene", PathCalc, "on_entered_mainscene", [self])
	emit_signal("entered_mainscene")
