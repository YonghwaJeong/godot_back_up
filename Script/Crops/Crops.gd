extends Node2D

class_name Crops

onready var sprite = $Sprite
signal in_area
signal out_area
export var plant_name : String
export var max_stage : int
export var day_for_stage : PoolIntArray
export var growth : int = 0
export var is_watered : bool = false
export var current_stage : int = 0
export var is_harvestable : bool = false

func _ready():
	
	if is_harvestable:
		sprite.frame = current_stage + 1
		return
	
	if GameManager.day_reset and is_watered:
		growth += 1
	
	if growth == day_for_stage[current_stage]:
		growth = 0
		current_stage += 1
		
	if current_stage == max_stage:
		is_harvestable = true
	
	sprite.frame = current_stage + 1
	is_watered = false
	
func _on_PlantArea_mouse_entered():
	emit_signal("in_area")

func _on_PlantArea_mouse_exited():
	emit_signal("out_area")

func _on_PlantHarvestArea_area_entered(area):
	
	if GameManager.player.current_tool.name != "Scythe" and "Golden Scythe":
		return
	
	if !(is_harvestable):
		return
			
	GameManager.spawn_item(get_parent(), global_position, plant_name, 1)
	self.queue_free()
