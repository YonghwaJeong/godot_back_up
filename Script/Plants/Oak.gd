extends StaticBody2D

onready var trunk = $Position2D
onready var hurtbox = $TreeHurtbox
onready var chopped_oak = preload("res://Scene/Plants/Oak_Fallsdown.tscn")
var angular_speed = 0
var angular_acc = -0.11
var trunk_hp = 6
var total_hp = 10
var player_position : Vector2
export var current_hp = 10 setget set_hp
export var current_state = "normal"

func _ready():
	hurtbox.connect("area_entered", self, "_on_TreeHurtbox_entered")
	if current_state == "stump_only":
		trunk.queue_free()
		trunk = null

func _on_TreeHurtbox_entered(area):
	player_position = area.get_parent().global_position
	self.current_hp -= 1 
	print("Tree HP : ", current_hp)

func set_hp(value):
	current_hp = value
	if trunk != null and current_hp <= (total_hp - trunk_hp):
		var new_scene = chopped_oak.instance()
		get_parent().add_child(new_scene)
		new_scene.player_position = player_position
		new_scene.global_position = self.global_position
		trunk.queue_free()
		trunk = null
		current_state = "stump_only"
	if current_hp <= 0:
		GameManager.spawn_item(get_parent(), global_position + Vector2(0, 34), "Wood", 3)
		self.queue_free()
