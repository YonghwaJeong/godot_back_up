extends Node

onready var background = $GradientSky
onready var intro_UI = $Intro
onready var animationPlayer = $AnimationPlayer

func _ready():
	animationPlayer.play("FadeIn")
	
func _on_New_pressed():
	animationPlayer.play("ZoomIn")

func _on_Load_pressed():
	get_tree().change_scene("res://Scene/DayStart.tscn")
	
func _on_Quit_pressed():
	get_tree().quit()

func _on_Back_pressed():
	animationPlayer.play_backwards("ZoomIn")

func _input(event):
	if event.is_action_pressed("skip") and animationPlayer.current_animation == "FadeIn":
		animationPlayer.set_speed_scale(180)

func _on_AnimationPlayer_animation_finished(anim_name):
	animationPlayer.set_speed_scale(1)
