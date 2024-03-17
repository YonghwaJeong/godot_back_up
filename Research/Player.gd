extends KinematicBody2D

var path = PoolVector2Array()
var velocity = Vector2.ZERO
var direction = Vector2(0, 1)
var tilemap : TileMap
var watered : TileMap
var player_speed : int = 45
var on_moving : bool = false
var currentState = COLLECTING
enum {WATERING, COLLECTING, MOVING, REST, SLEEP}
onready var animationTree = $AnimationTree 
onready var watered_area = preload("res://Scene/Area/WateredArea.tscn")

func _ready():
	self.connect("tree_entered", PathCalc, "pet_entered", [self])
	self.global_position = Vector2(325,203)
	animationTree.set("parameters/Idle/blend_position", direction)
	animationTree.set("parameters/Walk/blend_position", direction)
			
func _physics_process(delta):
	
	if path.size() == 0:
		return	
	
	match currentState:
		
		WATERING:
			
			if self.global_position.distance_to(tilemap.map_to_world(path[0])+Vector2(8,6))	< 0.7:
				path.remove(0)
				
				# when arrived at the last point of path
				if path.size() == 0:
					animationTree.get("parameters/playback").travel("Idle")
					yield(get_tree().create_timer(1), "timeout")
					watered.set_cellv(watered.world_to_map(self.global_position), 1)
					watered.update_bitmask_area(watered.world_to_map(self.global_position))
					var new_area = watered_area.instance()
					new_area.global_position = tilemap.map_to_world(tilemap.world_to_map(self.global_position)) + Vector2(8,8)
					watered.add_child(new_area, true)
					new_area.set_owner(watered)
					# find next point (start detection)
					yield(get_tree().create_timer(1), "timeout")
					on_moving = false
					return
				
			pet_move()
					
		COLLECTING:
	
			if self.global_position.distance_to(tilemap.map_to_world(path[0])+Vector2(8,6))	< 0.7:
				path.remove(0)
				if path.size() == 0:
					animationTree.get("parameters/playback").travel("Idle")
					yield(get_tree(), "idle_frame")
					on_moving = false
					return
				
			pet_move()
				
		MOVING:
			
			if self.global_position.distance_to(tilemap.map_to_world(path[0])+Vector2(8,6))	< 0.7:
				path.remove(0)
				if path.size() == 0:
					animationTree.get("parameters/playback").travel("Idle")
					yield(get_tree(), "idle_frame")
					on_moving = false
					self.visible = false
					return
				
			pet_move()
	
func pet_move():
			
	direction = self.global_position.direction_to(tilemap.map_to_world(path[0])+Vector2(8,6)) 	
				
	animationTree.set("parameters/Idle/blend_position", direction)
	animationTree.set("parameters/Walk/blend_position", direction)
	animationTree.get("parameters/playback").travel("Walk")
			
	if direction.x >= 0:
		$Sprite.flip_h = false
	elif direction.x < 0:
		$Sprite.flip_h = true
			
	velocity = direction * player_speed
	velocity = move_and_slide(velocity)
	on_moving = true
