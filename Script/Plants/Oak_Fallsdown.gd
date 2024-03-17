extends Node2D

onready var trunk = $Position2D
var angular_speed = 0
var angular_acc = -0.11
var player_position

func _physics_process(delta):
	var falling_direction = Vector2(-(global_position.direction_to(player_position)).x, 0).normalized()
	angular_speed += angular_acc
	trunk.rotation_degrees += angular_speed * angular_speed * delta * falling_direction.x
	if abs(trunk.rotation_degrees) > 90:
		var item_position = trunk.global_position + Vector2(falling_direction.x * 40, 0)
		GameManager.spawn_item(get_parent(), item_position , "Wood", 5)
		GameManager.spawn_item(get_parent(), item_position , "Sap", 3)
		queue_free()
